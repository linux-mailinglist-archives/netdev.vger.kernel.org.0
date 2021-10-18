Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7BB43190E
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhJRM3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:29:53 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:31252 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbhJRM3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 08:29:52 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634560061; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=RnKubHLBxsURiKk2HojMzMbLeWSvD8hkXWqctYdrYCU=;
 b=teQlPUV79NuU3t20Icdz6fME80ajitnbTNYHewUfd+uBJsKGgwP18i7jpfZwXF+5WGanXWPx
 JPUVscNZLbmhJX7h35j3yIW4qdRETlWaKlouiVW/WpfyX6KzfCLl4gi1be2hID6C+VLF+GKY
 eh0hUQ6vc8VeMfjxl35CZcaruxA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 616d682cab9da96e64d7dbca (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 12:27:24
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3B46AC43617; Mon, 18 Oct 2021 12:27:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D3172C4338F;
        Mon, 18 Oct 2021 12:27:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org D3172C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mwifiex: Add quirk resetting the PCI bridge on MS Surface
 devices
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211011134238.16551-1-verdre@v0yd.nl>
References: <20211011134238.16551-1-verdre@v0yd.nl>
To:     =?utf-8?q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>,
        David Laight <David.Laight@ACULAB.COM>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163456003528.19217.10035499117616642207.kvalo@codeaurora.org>
Date:   Mon, 18 Oct 2021 12:27:24 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonas Dreßler <verdre@v0yd.nl> wrote:

> The most recent firmware (15.68.19.p21) of the 88W8897 PCIe+USB card
> reports a hardcoded LTR value to the system during initialization,
> probably as an (unsuccessful) attempt of the developers to fix firmware
> crashes. This LTR value prevents most of the Microsoft Surface devices
> from entering deep powersaving states (either platform C-State 10 or
> S0ix state), because the exit latency of that state would be higher than
> what the card can tolerate.
> 
> Turns out the card works just the same (including the firmware crashes)
> no matter if that hardcoded LTR value is reported or not, so it's kind
> of useless and only prevents us from saving power.
> 
> To get rid of those hardcoded LTR requirements, it's possible to reset
> the PCI bridge device after initializing the cards firmware. I'm not
> exactly sure why that works, maybe the power management subsystem of the
> PCH resets its stored LTR values when doing a function level reset of
> the bridge device. Doing the reset once after starting the wifi firmware
> works very well, probably because the firmware only reports that LTR
> value a single time during firmware startup.
> 
> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>

I'm not sure what was the conclusion from the discussion, so dropping
the patch. Please resend once it's ready to be applied.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211011134238.16551-1-verdre@v0yd.nl/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

