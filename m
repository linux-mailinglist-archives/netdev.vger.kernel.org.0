Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2298D3F3C00
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 20:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbhHUSSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 14:18:05 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:15753 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230419AbhHUSSC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 14:18:02 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629569842; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=I8bEgQgwoVXWik88aOT0fBHMxu2+DCSThr85RFpmXdM=;
 b=ufwRUBi1yV0JXz14nEcP2/Rg71UzbFiRCazasYEzwyOxNzcwX1VnzH7LCdhp/6ckL/18spnb
 fQ5r04YeHMUoxhBCOBHfCMmY0bX+dxTvoFK4fyAG3DD6VU9Oi8g2QJzGV54YQ8LADPg152aW
 1H1i/nOyehNTmBOZ9Dgo0KuJ8Tw=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6121432334bfa769795c6005 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 21 Aug 2021 18:17:07
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 29347C43616; Sat, 21 Aug 2021 18:17:07 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 40F1BC4338F;
        Sat, 21 Aug 2021 18:17:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 40F1BC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: rtl8xxxu: disable interrupt_in transfer for 8188cu and 8192cu
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210701163354.118403-1-chris.chiu@canonical.com>
References: <20210701163354.118403-1-chris.chiu@canonical.com>
To:     chris.chiu@canonical.com
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org,
        code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Chiu <chris.chiu@canonical.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210821181707.29347C43616@smtp.codeaurora.org>
Date:   Sat, 21 Aug 2021 18:17:07 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

chris.chiu@canonical.com wrote:

> From: Chris Chiu <chris.chiu@canonical.com>
> 
> There will be crazy numbers of interrupts triggered by 8188cu and
> 8192cu module, around 8000~10000 interrupts per second, on the usb
> host controller. Compare with the vendor driver source code, it's
> mapping to the configuration CONFIG_USB_INTERRUPT_IN_PIPE and it is
> disabled by default.
> 
> Since the interrupt transfer is neither used for TX/RX nor H2C
> commands. Disable it to avoid the excessive amount of interrupts
> for the 8188cu and 8192cu module which I only have for verification.
> 
> Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
> Tested-by: reto.schneider@husqvarnagroup.com
> Acked-by: Jes Sorensen <Jes.Sorensen@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

f62cdab7f5db rtl8xxxu: disable interrupt_in transfer for 8188cu and 8192cu

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210701163354.118403-1-chris.chiu@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

