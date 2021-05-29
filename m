Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A264F394E44
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 23:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhE2VZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 17:25:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhE2VZd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 May 2021 17:25:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E95B961077;
        Sat, 29 May 2021 21:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622323436;
        bh=ZcsrZEQSb8PwDIOS5JuhSvyiJM4u5+htoSWW3OGSH/o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KArg4rzCCQGgsflRi43Kaf1h+92mBK8kI9ItbTpYf0JGrYql0j+AR4Tdm/XRIiy9t
         uL/WmI4NXeA0842Vxg9nfINlHIr0+Hfg7TrtqWM5dHS/cEQfdAqH6nhfGGilI31C3z
         arnzUhYZ6Gs48QAmJe7Se5Cpo7qtQGiKSarryAtlCNbtQ123E+ONMJ4eKqizv6wgHF
         rMH9NHftt3emR8yMlpSjww1rl8OaqYljUhO1rCXioTOa8g15EaZum0HKENYoBA9KPj
         zN2YrCQxGUvni+gAfBJ1upOV687dDX4tLsyOd66/qSxuMn2hdY0RcGU4+Ck4qKt/No
         GTAxFhFUEuV1g==
Date:   Sat, 29 May 2021 14:23:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <thomas.lendacky@amd.com>,
        <irusskikh@marvell.com>, <michael.chan@broadcom.com>,
        <edwin.peer@broadcom.com>, <rohitm@chelsio.com>,
        <jesse.brandeburg@intel.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [RFC V2 net-next 1/3] ethtool: extend coalesce setting uAPI
 with CQE mode
Message-ID: <20210529142355.17fb609d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1622258536-55776-2-git-send-email-tanhuazhong@huawei.com>
References: <1622258536-55776-1-git-send-email-tanhuazhong@huawei.com>
        <1622258536-55776-2-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 May 2021 11:22:14 +0800 Huazhong Tan wrote:
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index 25131df..8e8c6b3 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -937,6 +937,8 @@ Kernel response contents:
>    ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
>    ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
>    ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
> +  ``ETHTOOL_A_COALESCE_USE_CQE_TX``	       bool    timer reset in CQE, Tx
> +  ``ETHTOOL_A_COALESCE_USE_CQE_RX``	       bool    timer reset in CQE, Rx
>    ===========================================  ======  =======================
>  
>  Attributes are only included in reply if their value is not zero or the
> @@ -975,6 +977,8 @@ Request contents:
>    ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
>    ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
>    ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
> +  ``ETHTOOL_A_COALESCE_USE_CQE_TX``	       bool    timer reset in CQE, Tx
> +  ``ETHTOOL_A_COALESCE_USE_CQE_RX``	       bool    timer reset in CQE, Rx
>    ===========================================  ======  =======================
>  
>  Request is rejected if it attributes declared as unsupported by driver (i.e.

Did you provide the theory of operation for CQE vs EQE mode somewhere,
as I requested?

> +	[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX]	= { .type = NLA_U8 },
> +	[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX]	= { .type = NLA_U8 },

Why not NLA_POLICY_MAX(NLA_U8, 1) ?

Any chance you could split the patch into adding the new parameter 
to the callback and adding new attributes?
