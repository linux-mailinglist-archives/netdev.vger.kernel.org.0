Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A733E249A
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 09:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242111AbhHFH5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 03:57:40 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:22333 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233915AbhHFH5j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 03:57:39 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628236644; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=J6PBzDHz2JLjAPZzxlx7hTcbbesUbDjh8NFkE0SzyZA=;
 b=dnHgmriLZ+OS6+6XQ0EjU+pohpoKI/5XgDjEzVM0ksFLd86yUttXNN93O0iOF34BCmCI0hqH
 puadpNGAKkuY/2nXhGY3TScjzPtR3kVENTWzRq6TjLgXhTk5c++Cv/LYGfoEG1PTvyqF4QaZ
 IsADR8zLX2sEZz42eFeiVdRotkc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 610ceb62ad1af63949afa69b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 06 Aug 2021 07:57:22
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B6442C43144; Fri,  6 Aug 2021 07:57:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C7C26C433F1;
        Fri,  6 Aug 2021 07:57:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C7C26C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mt76: fix enum type mismatch
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210721150745.1914829-1-arnd@kernel.org>
References: <20210721150745.1914829-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ryder Lee <ryder.lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Soul Huang <Soul.Huang@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>,
        Xing Song <xing.song@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210806075721.B6442C43144@smtp.codeaurora.org>
Date:   Fri,  6 Aug 2021 07:57:21 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> There is no 'NONE' version of 'enum mcu_cipher_type', and returning
> 'MT_CIPHER_NONE' causes a warning:
> 
> drivers/net/wireless/mediatek/mt76/mt7921/mcu.c: In function 'mt7921_mcu_get_cipher':
> drivers/net/wireless/mediatek/mt76/mt7921/mcu.c:114:24: error: implicit conversion from 'enum mt76_cipher_type' to 'enum mcu_cipher_type' [-Werror=enum-conversion]
>   114 |                 return MT_CIPHER_NONE;
>       |                        ^~~~~~~~~~~~~~
> 
> Add the missing MCU_CIPHER_NONE defintion that fits in here with
> the same value.
> 
> Fixes: c368362c36d3 ("mt76: fix iv and CCMP header insertion")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers.git, thanks.

abf3d98dee7c mt76: fix enum type mismatch

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210721150745.1914829-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

