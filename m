Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178333F3C4B
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 21:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhHUTV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 15:21:28 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:24779 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230364AbhHUTVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 15:21:23 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629573643; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=uU3flCSn+iSXZF50k3teJibmCKL3vWrmBnwznoFYZGw=;
 b=q97HT5JrXJWMBojwU72wIPWaKlqkgamBownFKAnC74No3hJI/hp4q0EWmCgkcb1MfDYzn879
 CpjdosA6d2RBZmF+34rRlglkAaXldRDHUWPl7tS9SR8rIrwqgGZlf9IBymclXek7ycLkZRkl
 r4Hwpmoa6aNhqcqIs1HjdAU4hnU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6121520034bfa7697987cce9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 21 Aug 2021 19:20:32
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E1BE5C43617; Sat, 21 Aug 2021 19:20:32 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1A513C4338F;
        Sat, 21 Aug 2021 19:20:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 1A513C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmsmac: make array addr static const,
 makes object smaller
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210819125552.8888-1-colin.king@canonical.com>
References: <20210819125552.8888-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210821192032.E1BE5C43617@smtp.codeaurora.org>
Date:   Sat, 21 Aug 2021 19:20:32 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the array addr on the stack but instead it
> static const. Makes the object code smaller by 79 bytes:
> 
> Before:
>    text   data   bss     dec    hex filename
>  176015  54652   128  230795  3858b .../broadcom/brcm80211/brcmsmac/main.o
> 
> After:
>    text   data   bss     dec    hex filename
>  175872  54716   128  230716  3853c .../broadcom/brcm80211/brcmsmac/main.o
> 
> (gcc version 10.3.0)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

0dc62413c882 brcmsmac: make array addr static const, makes object smaller

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210819125552.8888-1-colin.king@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

