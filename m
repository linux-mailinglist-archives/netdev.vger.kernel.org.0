Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEB33F2469
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 03:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbhHTBso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 21:48:44 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:14289 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234909AbhHTBsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 21:48:43 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GrPfL3cnVz88Db;
        Fri, 20 Aug 2021 09:47:54 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 20 Aug 2021 09:48:00 +0800
Received: from [10.67.103.6] (10.67.103.6) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 20 Aug
 2021 09:48:00 +0800
Subject: Re: [PATCH V2 net-next 2/4] ethtool: extend coalesce setting uAPI
 with CQE mode
To:     Jakub Kicinski <kuba@kernel.org>
References: <1629353844-49626-1-git-send-email-moyufeng@huawei.com>
 <1629353844-49626-3-git-send-email-moyufeng@huawei.com>
 <20210819120829.27c9b124@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
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
From:   moyufeng <moyufeng@huawei.com>
Message-ID: <6e68afa9-9071-4459-ca6b-666ea806ace6@huawei.com>
Date:   Fri, 20 Aug 2021 09:48:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20210819120829.27c9b124@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/8/20 3:08, Jakub Kicinski wrote:
> On Thu, 19 Aug 2021 14:17:22 +0800 Yufeng Mo wrote:
>> In order to support more coalesce parameters through netlink,
>> add two new parameter kernel_coal and extack for .set_coalesce
>> and .get_coalesce, then some extra info can return to user with
>> the netlink API.
>>
>> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
> Looks like it builds fine, unfortunately you need to correct the kdoc 
> of the functions which have it (by adding the new param description
> everywhere), otherwise we'll get these on W=1 builds:
> 
> drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:741: warning: Function parameter or member 'kernel_coal' not described in 'hns_get_coalesce'
> drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:741: warning: Function parameter or member 'extack' not described in 'hns_get_coalesce'
> drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:787: warning: Function parameter or member 'kernel_coal' not described in 'hns_set_coalesce'
> drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:787: warning: Function parameter or member 'extack' not described in 'hns_set_coalesce'
> drivers/net/ethernet/intel/i40e/i40e_ethtool.c:2825: warning: Function parameter or member 'kernel_coal' not described in 'i40e_get_coalesce'
> drivers/net/ethernet/intel/i40e/i40e_ethtool.c:2825: warning: Function parameter or member 'extack' not described in 'i40e_get_coalesce'
> drivers/net/ethernet/intel/i40e/i40e_ethtool.c:2999: warning: Function parameter or member 'kernel_coal' not described in 'i40e_set_coalesce'
> drivers/net/ethernet/intel/i40e/i40e_ethtool.c:2999: warning: Function parameter or member 'extack' not described in 'i40e_set_coalesce'
> drivers/net/ethernet/intel/iavf/iavf_ethtool.c:699: warning: Function parameter or member 'kernel_coal' not described in 'iavf_get_coalesce'
> drivers/net/ethernet/intel/iavf/iavf_ethtool.c:699: warning: Function parameter or member 'extack' not described in 'iavf_get_coalesce'
> drivers/net/ethernet/intel/iavf/iavf_ethtool.c:817: warning: Function parameter or member 'kernel_coal' not described in 'iavf_set_coalesce'
> drivers/net/ethernet/intel/iavf/iavf_ethtool.c:817: warning: Function parameter or member 'extack' not described in 'iavf_set_coalesce'
> drivers/net/ethernet/ti/davinci_emac.c:395: warning: Function parameter or member 'kernel_coal' not described in 'emac_get_coalesce'
> drivers/net/ethernet/ti/davinci_emac.c:395: warning: Function parameter or member 'extack' not described in 'emac_get_coalesce'
> drivers/net/ethernet/ti/davinci_emac.c:415: warning: Function parameter or member 'kernel_coal' not described in 'emac_set_coalesce'
> drivers/net/ethernet/ti/davinci_emac.c:415: warning: Function parameter or member 'extack' not described in 'emac_set_coalesce'
> drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1416: warning: Function parameter or member 'kernel_coal' not described in 'axienet_ethtools_get_coalesce'
> drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1416: warning: Function parameter or member 'extack' not described in 'axienet_ethtools_get_coalesce'
> drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1444: warning: Function parameter or member 'kernel_coal' not described in 'axienet_ethtools_set_coalesce'
> drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1444: warning:
> Function parameter or member 'extack' not described in
> 'axienet_ethtools_set_coalesce'
> .
> 
ok, will fix it in V3, thanks
