Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35453DC52B
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 10:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbhGaIur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 04:50:47 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:19347 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbhGaIuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 04:50:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627721440; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=umJbV2hG5/Yp526M0LlnozPrNCkbsNWKGIS3tLnL3yQ=; b=l+6b+YwzaobEss8nNAJ+dAO+H8xKj2YrZURTywzH3kxXIrPt7X1SIcBxH7PSyyk+CcJDzn/E
 6fUfs8OKWcfojMVpM9JHTrVXoOsBeuSMikzei8O+eqkAC0k/KJyAlYVZsW5njXcdBZ1o5VJA
 yGQKgSdNNpc5QNF01XKkaSc1cR8=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 61050edf290ea35ee6dbd91b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 31 Jul 2021 08:50:39
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0FCB5C433D3; Sat, 31 Jul 2021 08:50:39 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F18D4C433F1;
        Sat, 31 Jul 2021 08:50:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F18D4C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jonas =?utf-8?Q?Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Subject: Re: [PATCH v2 1/2] mwifiex: pcie: add DMI-based quirk implementation for Surface devices
References: <20210709145831.6123-1-verdre@v0yd.nl>
        <20210709145831.6123-2-verdre@v0yd.nl>
Date:   Sat, 31 Jul 2021 11:50:29 +0300
In-Reply-To: <20210709145831.6123-2-verdre@v0yd.nl> ("Jonas \=\?utf-8\?Q\?Dre\?\=
 \=\?utf-8\?Q\?\=C3\=9Fler\=22's\?\= message
        of "Fri, 9 Jul 2021 16:58:30 +0200")
Message-ID: <87pmuyeuju.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonas Dre=C3=9Fler <verdre@v0yd.nl> writes:

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
> Signed-off-by: Jonas Dre=C3=9Fler <verdre@v0yd.nl>

[...]

> --- /dev/null
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
> @@ -0,0 +1,32 @@
> +// SPDX-License-Identifier: GPL-2.0

I prefer having a consistent license within a driver. So please either
convert mwifiex to use SPDX in every file or use the same license boiler
plate as used in the driver.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
