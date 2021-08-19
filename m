Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD713F2061
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 21:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbhHSTJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 15:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhHSTJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 15:09:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5325610A5;
        Thu, 19 Aug 2021 19:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629400112;
        bh=vZ+AsgA+LL6ARAeSPGYJS6fjzFl41SpTlEnvQdUjMLY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ohfv9AtsSCoSIllXg+e9g/k5S3dPmLksn25/vBYMGfvIj6964k11XqqMnpka1cdgu
         zP/4RpLlUMgvThSpY3yZmT2gGHJSzeACKJCBF7dC7IiHaNY35j6FueiItTuBk6ALq0
         B3GTFlgASLkZagwenGElEasjd/CC+kuEdIubqLPLGhsqRzES7+PoG0fgHc5dUv9Pgc
         d3iJsPebwC31D/Ik8HUJFiOV/vyW5SN8B8uWZm0Si+VLIgE6JAdGgPk6bXMyyRWgba
         VZ6MOQyZUoimyEhwfcabwoNp6AXYdSUZDX+qkggG43DfChxmEOIq0m2CbeZaw6wPXr
         CGBHQwwzW+8xQ==
Date:   Thu, 19 Aug 2021 12:08:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yufeng Mo <moyufeng@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <shenjian15@huawei.com>, <lipeng321@huawei.com>,
        <yisen.zhuang@huawei.com>, <linyunsheng@huawei.com>,
        <huangguangbin2@huawei.com>, <chenhao288@hisilicon.com>,
        <salil.mehta@huawei.com>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <netanel@amazon.com>, <akiyano@amazon.com>,
        <thomas.lendacky@amd.com>, <irusskikh@marvell.com>,
        <michael.chan@broadcom.com>, <edwin.peer@broadcom.com>,
        <rohitm@chelsio.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 net-next 2/4] ethtool: extend coalesce setting uAPI
 with CQE mode
Message-ID: <20210819120829.27c9b124@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1629353844-49626-3-git-send-email-moyufeng@huawei.com>
References: <1629353844-49626-1-git-send-email-moyufeng@huawei.com>
        <1629353844-49626-3-git-send-email-moyufeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Aug 2021 14:17:22 +0800 Yufeng Mo wrote:
> In order to support more coalesce parameters through netlink,
> add two new parameter kernel_coal and extack for .set_coalesce
> and .get_coalesce, then some extra info can return to user with
> the netlink API.
> 
> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

Looks like it builds fine, unfortunately you need to correct the kdoc 
of the functions which have it (by adding the new param description
everywhere), otherwise we'll get these on W=1 builds:

drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:741: warning: Function parameter or member 'kernel_coal' not described in 'hns_get_coalesce'
drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:741: warning: Function parameter or member 'extack' not described in 'hns_get_coalesce'
drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:787: warning: Function parameter or member 'kernel_coal' not described in 'hns_set_coalesce'
drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:787: warning: Function parameter or member 'extack' not described in 'hns_set_coalesce'
drivers/net/ethernet/intel/i40e/i40e_ethtool.c:2825: warning: Function parameter or member 'kernel_coal' not described in 'i40e_get_coalesce'
drivers/net/ethernet/intel/i40e/i40e_ethtool.c:2825: warning: Function parameter or member 'extack' not described in 'i40e_get_coalesce'
drivers/net/ethernet/intel/i40e/i40e_ethtool.c:2999: warning: Function parameter or member 'kernel_coal' not described in 'i40e_set_coalesce'
drivers/net/ethernet/intel/i40e/i40e_ethtool.c:2999: warning: Function parameter or member 'extack' not described in 'i40e_set_coalesce'
drivers/net/ethernet/intel/iavf/iavf_ethtool.c:699: warning: Function parameter or member 'kernel_coal' not described in 'iavf_get_coalesce'
drivers/net/ethernet/intel/iavf/iavf_ethtool.c:699: warning: Function parameter or member 'extack' not described in 'iavf_get_coalesce'
drivers/net/ethernet/intel/iavf/iavf_ethtool.c:817: warning: Function parameter or member 'kernel_coal' not described in 'iavf_set_coalesce'
drivers/net/ethernet/intel/iavf/iavf_ethtool.c:817: warning: Function parameter or member 'extack' not described in 'iavf_set_coalesce'
drivers/net/ethernet/ti/davinci_emac.c:395: warning: Function parameter or member 'kernel_coal' not described in 'emac_get_coalesce'
drivers/net/ethernet/ti/davinci_emac.c:395: warning: Function parameter or member 'extack' not described in 'emac_get_coalesce'
drivers/net/ethernet/ti/davinci_emac.c:415: warning: Function parameter or member 'kernel_coal' not described in 'emac_set_coalesce'
drivers/net/ethernet/ti/davinci_emac.c:415: warning: Function parameter or member 'extack' not described in 'emac_set_coalesce'
drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1416: warning: Function parameter or member 'kernel_coal' not described in 'axienet_ethtools_get_coalesce'
drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1416: warning: Function parameter or member 'extack' not described in 'axienet_ethtools_get_coalesce'
drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1444: warning: Function parameter or member 'kernel_coal' not described in 'axienet_ethtools_set_coalesce'
drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1444: warning:
Function parameter or member 'extack' not described in
'axienet_ethtools_set_coalesce'
