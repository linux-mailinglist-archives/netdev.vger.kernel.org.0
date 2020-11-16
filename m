Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D1F2B3EEE
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 09:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgKPIl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 03:41:58 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7906 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgKPIl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 03:41:58 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CZMxd275fz6xPd;
        Mon, 16 Nov 2020 16:41:41 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Mon, 16 Nov 2020
 16:41:45 +0800
Subject: Re: [PATCH V3 net-next 06/10] net: hns3: add ethtool priv-flag for
 DIM
To:     Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
References: <1605151998-12633-1-git-send-email-tanhuazhong@huawei.com>
 <1605151998-12633-7-git-send-email-tanhuazhong@huawei.com>
 <20201114105423.07c2ce67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <370fe668-d719-6380-f172-ad01edeb666e@huawei.com>
Date:   Mon, 16 Nov 2020 16:41:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20201114105423.07c2ce67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/11/15 2:54, Jakub Kicinski wrote:
> On Thu, 12 Nov 2020 11:33:14 +0800 Huazhong Tan wrote:
>> Add a control private flag in ethtool for enable/disable
>> DIM feature.
>>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
> Please work on a common ethtool API for the configuration instead of
> using private flags.
> 
> Private flags were overused because the old IOCTL-based ethtool was
> hard to extend, but we have a netlink API now.
> 
> For example here you're making a choice between device and DIM
> implementation of IRQ coalescing. You can add a new netlink attribute
> to the ETHTOOL_MSG_COALESCE_GET/ETHTOOL_MSG_COALESCE_SET commands which
> controls the type of adaptive coalescing (if enabled).
> 

The device's implementation of IRQ coalescing will be removed, if DIM 
works ok for a long time. So could this private flag for DIM be 
uptreamed as a transition scheme? And adding a new netlink attrtibute to 
controls the type of adaptive coalescing seems useless for other drivers.

> 
> One question I don't think we have a strong answer for is how to handle
> this extension from ethtool_ops point of view. Should we add a new
> "extended" op which drivers may start implementing? Or separate the
> structure passed in to the ops from the one used as uAPI?
> 
> Thoughts anyone?
> 
> 
> Huazhong Tan, since the DIM and EQ/CQ patches may require more
> infrastructure work feel free to repost the first 4 patches separately,
> I can apply those as is.
> 

ok, thanks.

> .
> 

