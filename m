Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05843FAB2E
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 13:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbhH2Lr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 07:47:59 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:41395 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbhH2Lrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 07:47:53 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630237621; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=FrcsjeYEV4aD3jrH0YZK+LgW/bik9E8xvwieK0EEtzY=;
 b=m8PzL64UCzg8HozLNkKYVtOWE82rT/8KSYznRtTuI1iydhVPsNON3fJw0w6azYiYl6zxBNtA
 MjihDgHByyQBoBBj76gI9G2V7pex0Gpif8w/DgEiur9pg42UiZ0d1AIYOGIN0E2wnRgE22GO
 /ICjX95NgPGgwMOW3rfdxZXguJA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 612b73b4825e13c54a3674b8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 29 Aug 2021 11:47:00
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 250C0C4338F; Sun, 29 Aug 2021 11:47:00 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3DF9AC4338F;
        Sun, 29 Aug 2021 11:46:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 3DF9AC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 1/2] mwifiex: pcie: add DMI-based quirk implementation
 for
 Surface devices
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210820142050.35741-2-verdre@v0yd.nl>
References: <20210820142050.35741-2-verdre@v0yd.nl>
To:     =?utf-8?q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
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
        =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210829114700.250C0C4338F@smtp.codeaurora.org>
Date:   Sun, 29 Aug 2021 11:47:00 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonas Dreßler <verdre@v0yd.nl> wrote:

> This commit adds the ability to apply device-specific quirks to the
> mwifiex driver. It uses DMI matching similar to the quirks brcmfmac uses
> with dmi.c. We'll add identifiers to match various MS Surface devices,
> which this is primarily meant for, later.
> 
> This commit is a slightly modified version of a previous patch sent in
> by Tsuchiya Yuto.
> 
> Co-developed-by: Tsuchiya Yuto <kitakar@gmail.com>
> Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>

2 patches applied to wireless-drivers-next.git, thanks.

5448bc2a426c mwifiex: pcie: add DMI-based quirk implementation for Surface devices
a847666accf2 mwifiex: pcie: add reset_d3cold quirk for Surface gen4+ devices

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210820142050.35741-2-verdre@v0yd.nl/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

