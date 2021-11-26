Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C469545F1EE
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 17:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378551AbhKZQfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 11:35:47 -0500
Received: from m43-7.mailgun.net ([69.72.43.7]:57358 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239930AbhKZQdq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 11:33:46 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1637944232; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=DMGiKj+VdrJLlqSkskX7fU4LLNzIOYS3+wT732akEpU=;
 b=ZZP6HKiu2ra1vjKRj3TFGxQyCGYu2BW8YAFDc4+4VR3oIZw3/FurBPNAEDBP+eZnKQmWtB4c
 xir6fij7DcFxXiig68JXxJ8jKP+j16rkItjEKnuQsudXNjKISyVsElAJZ7ow2T3uU4RhounE
 3EVlx/aafIuSfn3nOlFOZlw+xK8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 61a10ba1465c4a723bab60d9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 26 Nov 2021 16:30:25
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5E0CAC4360D; Fri, 26 Nov 2021 16:30:25 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AB59AC4360C;
        Fri, 26 Nov 2021 16:30:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org AB59AC4360C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mwifiex: Ignore BTCOEX events from the 88W8897 firmware
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211103205827.14559-1-verdre@v0yd.nl>
References: <20211103205827.14559-1-verdre@v0yd.nl>
To:     =?utf-8?q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163794421996.10370.7668732301973284317.kvalo@codeaurora.org>
Date:   Fri, 26 Nov 2021 16:30:25 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonas Dreßler <verdre@v0yd.nl> wrote:

> The firmware of the 88W8897 PCIe+USB card sends those events very
> unreliably, sometimes bluetooth together with 2.4ghz-wifi is used and no
> COEX event comes in, and sometimes bluetooth is disabled but the
> coexistance mode doesn't get disabled.
> 
> This means we sometimes end up capping the rx/tx window size while
> bluetooth is not enabled anymore, artifically limiting wifi speeds even
> though bluetooth is not being used.
> 
> Since we can't fix the firmware, let's just ignore those events on the
> 88W8897 device. From some Wireshark capture sessions it seems that the
> Windows driver also doesn't change the rx/tx window sizes when bluetooth
> gets enabled or disabled, so this is fairly consistent with the Windows
> driver.
> 
> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>

Patch applied to wireless-drivers-next.git, thanks.

84d94e16efa2 mwifiex: Ignore BTCOEX events from the 88W8897 firmware

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211103205827.14559-1-verdre@v0yd.nl/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

