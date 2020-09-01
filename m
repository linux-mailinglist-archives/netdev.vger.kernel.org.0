Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC78C258EE9
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 15:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgIANLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 09:11:18 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:10257 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbgIANGh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 09:06:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598965562; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=cSrZbk7e/jeZSp8Bprl3QgOkG7poAuCV3fNdztHsFvY=;
 b=ZnJJnBB6/ztGu6QnzHbefcSoSy1rytc9SfB/0X8Zy64Da3bjBfGPCEKdSJzMzYRb57KjbsNE
 CsNcm8GWUQ9/l6DZ6EDtPSvSVwUOt7xP6tPcKS6CyoBy+Xv5c/0khKvhC4o8FqCdmdpUfusZ
 aWZrAMSA19jXSrfp2VTDGfLzKiQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f4e4739238e1efa37926922 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Sep 2020 13:06:01
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 10DFBC43395; Tue,  1 Sep 2020 13:06:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2DC04C433CA;
        Tue,  1 Sep 2020 13:05:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2DC04C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [01/30] mwifiex: pcie: Move tables to the only place they're used
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200826093401.1458456-2-lee.jones@linaro.org>
References: <20200826093401.1458456-2-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200901130601.10DFBC43395@smtp.codeaurora.org>
Date:   Tue,  1 Sep 2020 13:06:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Saves on 10's of complains about 'defined but not used' variables.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>  In file included from drivers/net/wireless/marvell/mwifiex/main.h:57,
>  from drivers/net/wireless/marvell/mwifiex/main.c:22:
>  drivers/net/wireless/marvell/mwifiex/pcie.h:310:41: warning: ‘mwifiex_pcie8997’ defined but not used [-Wunused-const-variable=]
>  310 | static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
>  | ^~~~~~~~~~~~~~~~
>  drivers/net/wireless/marvell/mwifiex/pcie.h:300:41: warning: ‘mwifiex_pcie8897’ defined but not used [-Wunused-const-variable=]
>  300 | static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
>  | ^~~~~~~~~~~~~~~~
>  drivers/net/wireless/marvell/mwifiex/pcie.h:292:41: warning: ‘mwifiex_pcie8766’ defined but not used [-Wunused-const-variable=]
>  292 | static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
>  | ^~~~~~~~~~~~~~~~
> 
>  NB: Repeats 10's of times - snipped for brevity.
> 
> Cc: Amitkumar Karwar <amitkarwar@gmail.com>
> Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
> Cc: Xinming Hu <huxinming820@gmail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

10 patches applied to wireless-drivers-next.git, thanks.

77dacc8fc64c mwifiex: pcie: Move tables to the only place they're used
f5c3bf15f34c brcmsmac: ampdu: Remove a couple set but unused variables
dd13d6dcc24d iwlegacy: 3945-mac: Remove all non-conformant kernel-doc headers
305fd82aee87 iwlegacy: 3945-rs: Remove all non-conformant kernel-doc headers
a60e33af4e28 iwlegacy: 3945: Remove all non-conformant kernel-doc headers
78211e026bd0 brcmfmac: p2p: Fix a couple of function headers
ef8308d34a93 orinoco_usb: Downgrade non-conforming kernel-doc headers
1d2389b53c85 brcmsmac: phy_cmn: Remove a unused variables 'vbat' and 'temp'
2fae7bf8e379 zd1211rw: zd_chip: Fix formatting
f3242a5ba91d zd1211rw: zd_mac: Add missing or incorrect function documentation

-- 
https://patchwork.kernel.org/patch/11737755/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

