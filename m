Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2851F431918
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhJRMdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:33:04 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:13353 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230399AbhJRMdD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 08:33:03 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634560252; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=KqtpMIVRke8Zx8U0r3eUL9gInbDot/bfnHC07DXz8kw=;
 b=juH+qjE1l95lIR2KFfotSTJEpIrM0fe1zSiPH3k2q8djCY9mt0AT0aUoC/odTf+vQ4hK1Y5O
 4luJgwQHEe170XCRQbUQEDDyLwFLYjMb+dJOlhuxbmdIux2mguiDTDBzuCMpyOXOPNjFRxoh
 5NvNg/KSUs3A2SSNElW33Jhy0DA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 616d68cf0605239689645c52 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 12:30:07
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3946FC43619; Mon, 18 Oct 2021 12:30:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D89AEC4338F;
        Mon, 18 Oct 2021 12:30:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org D89AEC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 1/2] mwifiex: Read a PCI register after writing the TX
 ring
 write pointer
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211011133224.15561-2-verdre@v0yd.nl>
References: <20211011133224.15561-2-verdre@v0yd.nl>
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
        David Laight <David.Laight@ACULAB.COM>, stable@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163456019981.5790.2196596945429161000.kvalo@codeaurora.org>
Date:   Mon, 18 Oct 2021 12:30:07 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonas Dreßler <verdre@v0yd.nl> wrote:

> On the 88W8897 PCIe+USB card the firmware randomly crashes after setting
> the TX ring write pointer. The issue is present in the latest firmware
> version 15.68.19.p21 of the PCIe+USB card.
> 
> Those firmware crashes can be worked around by reading any PCI register
> of the card after setting that register, so read the PCI_VENDOR_ID
> register here. The reason this works is probably because we keep the bus
> from entering an ASPM state for a bit longer, because that's what causes
> the cards firmware to crash.
> 
> This fixes a bug where during RX/TX traffic and with ASPM L1 substates
> enabled (the specific substates where the issue happens appear to be
> platform dependent), the firmware crashes and eventually a command
> timeout appears in the logs.
> 
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=109681
> Cc: stable@vger.kernel.org
> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>

2 patches applied to wireless-drivers-next.git, thanks.

e5f4eb8223aa mwifiex: Read a PCI register after writing the TX ring write pointer
8e3e59c31fea mwifiex: Try waking the firmware until we get an interrupt

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211011133224.15561-2-verdre@v0yd.nl/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

