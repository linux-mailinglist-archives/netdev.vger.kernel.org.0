Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0E43ECD3F
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 05:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbhHPDbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 23:31:12 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8415 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbhHPDa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 23:30:57 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gp01F5wgkz87sc;
        Mon, 16 Aug 2021 11:25:53 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 16 Aug 2021 11:29:54 +0800
Received: from [10.67.103.6] (10.67.103.6) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 16 Aug
 2021 11:29:54 +0800
Subject: Re: [RFC V3 net-next 1/4] ethtool: add two coalesce attributes for
 CQE mode
To:     Jakub Kicinski <kuba@kernel.org>
References: <1628819129-23332-1-git-send-email-moyufeng@huawei.com>
 <1628819129-23332-2-git-send-email-moyufeng@huawei.com>
 <20210813105503.600ad1cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
Message-ID: <9aad8548-8a3e-b88c-441f-805a0b71d709@huawei.com>
Date:   Mon, 16 Aug 2021 11:29:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20210813105503.600ad1cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/8/14 1:55, Jakub Kicinski wrote:
> On Fri, 13 Aug 2021 09:45:26 +0800 Yufeng Mo wrote:
>> Currently, there many drivers who support CQE mode configuration,
>> some configure it as a fixed when initialized, some provide an
>> interface to change it by ethtool private flags. In order make it
>> more generic, add two new 'ETHTOOL_A_COALESCE_USE_CQE_TX' and
>> 'ETHTOOL_A_COALESCE_USE_CQE_RX' coalesce attributes, then these
>> parameters can be accessed by ethtool netlink coalesce uAPI.
>>
>> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
> The series LGTM. When I was asking for documentation earlier I meant 
> a paragraph explaining the difference between the two modes. Here is 
> an example based on my current understanding, I could very well be
> wrong but you see what kind of explanation I'm after? If this is more
> or less correct please feel free to use it and modify as you see fit.
> 

The description in the following document is consistent with my
understanding. I'll add the following paragraph and add
"Signed-off-by: Jakub Kicinski <kuba@kernel.org>" to the patch.
Thanks for your correction.

> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index c86628e6a235..fc7ac5938aac 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -939,12 +939,25 @@ Gets coalescing parameters like ``ETHTOOL_GCOALESCE`` ioctl request.
>    ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
>    ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
>    ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
> +  ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
> +  ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
>    ===========================================  ======  =======================
>  
>  Attributes are only included in reply if their value is not zero or the
>  corresponding bit in ``ethtool_ops::supported_coalesce_params`` is set (i.e.
>  they are declared as supported by driver).
>  
> +Timer reset mode (``ETHTOOL_A_COALESCE_USE_CQE_TX`` and
> +``ETHTOOL_A_COALESCE_USE_CQE_RX``) control the interaction between packet
> +arrival and the various time based delay parameters. By default timers are
> +expected to limit the max delay between any packet arrival/departure
> +and a corresponding interrupt. In this mode timer should be started by packet
> +arrival (sometimes delivery of previous interrupt) and reset when interrupt
> +is delivered.
> +Setting the appropriate attribute to 1 will enable ``CQE`` mode, where
> +each packet event resets the timer. In this mode timer is used to force
> +the interrupt if queue goes idle, while busy queues depend on the packet
> +limit to trigger interrupts.
>  
>  COALESCE_SET
>  ============
> @@ -977,6 +990,8 @@ Sets coalescing parameters like ``ETHTOOL_SCOALESCE`` ioctl request.
>    ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
>    ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
>    ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
> +  ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
> +  ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
>    ===========================================  ======  =======================
>  
>  Request is rejected if it attributes declared as unsupported by driver (i.e.
> .
> 
