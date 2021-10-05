Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73AE0421DFF
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 07:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhJEFfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 01:35:18 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:62557 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbhJEFfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 01:35:15 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633412006; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=k8lSqHnJAUansCD00Twm75ZHHDIkxHaVX0p0kJSvRCQ=;
 b=qDd9QGNYb1xNZjsutYxVfyaKVagxIrRriXk/+M2mbJ4mFYE9YSsG1H8EzRAl2vNq57+TyutT
 /iNnFSpnBBh+2wEClk4VpzF4GqXW6zMBaRqdQPxlxEc93JROyM6wdo3HzsfXdQDCrrbJNf88
 Cn792jBNiQuTNqTAknSaAfzEfFo=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 615be3a20d9325367bca65b1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 05 Oct 2021 05:33:22
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D556FC43460; Tue,  5 Oct 2021 05:33:22 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AA143C4338F;
        Tue,  5 Oct 2021 05:33:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org AA143C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtl8xxxu: Use lower tx rates for the ack packet
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211001040044.1028708-1-chris.chiu@canonical.com>
References: <20211001040044.1028708-1-chris.chiu@canonical.com>
To:     Chris Chiu <chris.chiu@canonical.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org,
        code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Chiu <chris.chiu@canonical.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20211005053322.D556FC43460@smtp.codeaurora.org>
Date:   Tue,  5 Oct 2021 05:33:22 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chris.chiu@canonical.com> wrote:

> According to the Realtek propritary driver and the rtw88 driver, the
> tx rates of the ack (includes block ack) are initialized with lower
> tx rates (no HT rates) which is set by the RRSR register value. In
> real cases, ack rate higher than current tx rate could lead to
> difficulty for the receiving end to receive management/control frames.
> The retransmission rate would be higher then expected when the driver
> is acting as receiver and the RSSI is not good.
> 
> Cross out higer rates for ack packet before implementing dynamic rrsr
> configuration like the commit 4830872685f8 ("rtw88: add dynamic rrsr
> configuration").
> 
> Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
> Acked-by: Jes Sorensen <Jes.Sorensen@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

7acd723c30c0 rtl8xxxu: Use lower tx rates for the ack packet

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211001040044.1028708-1-chris.chiu@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

