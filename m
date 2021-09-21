Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665144135CE
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 17:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbhIUPGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 11:06:06 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:40177 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232540AbhIUPGF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 11:06:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632236677; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=kKeGMSBk1nf9nhoNt1xIaAgqlBzdmnInIfZ2mQ9acs0=;
 b=nWhxF0qFhX2P5j2lGufKlkCbLr2R/8hVXxA1hUIoZcJRn86gMbUuNFeOEjnoWKZh25xIQzh/
 1WBYDeeJWI05b+XTYFRac/+aVSO3d4lrnU28cEkslkEykOwj9gkhcD9SBeJIdr+IlArmyvBH
 YaKuOqmrkKtqLKF4WtlpwV35XTs=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 6149f475bd6681d8edf0567a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 21 Sep 2021 15:04:21
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4660BC43637; Tue, 21 Sep 2021 15:04:20 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E5344C43616;
        Tue, 21 Sep 2021 15:04:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org E5344C43616
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rsi: Fix module dev_oper_mode parameter description
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210916144245.10181-1-marex@denx.de>
References: <20210916144245.10181-1-marex@denx.de>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-wireless@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Karun Eagalapati <karun256@gmail.com>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210921150420.4660BC43637@smtp.codeaurora.org>
Date:   Tue, 21 Sep 2021 15:04:20 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marek Vasut <marex@denx.de> wrote:

> The module parameters are missing dev_oper_mode 12, BT classic alone,
> add it. Moreover, the parameters encode newlines, which ends up being
> printed malformed e.g. by modinfo, so fix that too.
> 
> However, the module parameter string is duplicated in both USB and SDIO
> modules and the dev_oper_mode mode enumeration in those module parameters
> is a duplicate of macros used by the driver. Furthermore, the enumeration
> is confusing.
> 
> So, deduplicate the module parameter string and use __stringify() to
> encode the correct mode enumeration values into the module parameter
> string. Finally, replace 'Wi-Fi' with 'Wi-Fi alone' and 'BT' with
> 'BT classic alone' to clarify what those modes really mean.
> 
> Fixes: 898b255339310 ("rsi: add module parameter operating mode")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> Cc: Angus Ainslie <angus@akkea.ca>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Karun Eagalapati <karun256@gmail.com>
> Cc: Martin Fuzzey <martin.fuzzey@flowbird.group>
> Cc: Martin Kepplinger <martink@posteo.de>
> Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> Cc: Siva Rebbagondla <siva8118@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: <stable@vger.kernel.org> # 4.17+

Patch applied to wireless-drivers-next.git, thanks.

31f97cf9f0c3 rsi: Fix module dev_oper_mode parameter description

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210916144245.10181-1-marex@denx.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

