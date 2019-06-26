Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D2156DA6
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbfFZP3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:29:44 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:19116 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725958AbfFZP3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 11:29:44 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4A8C8D118A354417CDE0;
        Wed, 26 Jun 2019 23:29:37 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Wed, 26 Jun 2019
 23:29:31 +0800
Subject: Re: [PATCH] bonding: Always enable vlan tx offload
To:     Jiri Pirko <jiri@resnulli.us>
References: <20190624135007.GA17673@nanopsycho>
 <20190626080844.20796-1-yuehaibing@huawei.com>
 <20190626152505.GB2424@nanopsycho>
CC:     <davem@davemloft.net>, <sdf@google.com>, <jianbol@mellanox.com>,
        <jiri@mellanox.com>, <mirq-linux@rere.qmqm.pl>,
        <willemb@google.com>, <sdf@fomichev.me>, <j.vosburgh@gmail.com>,
        <vfalico@gmail.com>, <andy@greyhouse.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <498bf1cb-1fb8-05a8-482a-79f37bf812dc@huawei.com>
Date:   Wed, 26 Jun 2019 23:29:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190626152505.GB2424@nanopsycho>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/6/26 23:25, Jiri Pirko wrote:
> Wed, Jun 26, 2019 at 10:08:44AM CEST, yuehaibing@huawei.com wrote:
>> We build vlan on top of bonding interface, which vlan offload
>> is off, bond mode is 802.3ad (LACP) and xmit_hash_policy is
>> BOND_XMIT_POLICY_ENCAP34.
>>
>> Because vlan tx offload is off, vlan tci is cleared and skb push
>> the vlan header in validate_xmit_vlan() while sending from vlan
>> devices. Then in bond_xmit_hash, __skb_flow_dissect() fails to
>> get information from protocol headers encapsulated within vlan,
>> because 'nhoff' is points to IP header, so bond hashing is based
>> on layer 2 info, which fails to distribute packets across slaves.
>>
>> This patch always enable bonding's vlan tx offload, pass the vlan
>> packets to the slave devices with vlan tci, let them to handle
>> vlan implementation.
>>
>> Fixes: 278339a42a1b ("bonding: propogate vlan_features to bonding master")
>> Suggested-by: Jiri Pirko <jiri@resnulli.us>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> 
> Could you please do the same for team? Thanks!

Sure, will send it, thank you!

> 
> .
> 

