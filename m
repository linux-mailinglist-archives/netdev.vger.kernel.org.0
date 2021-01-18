Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D527A2F9DFA
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 12:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390202AbhARLVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 06:21:19 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2948 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390191AbhARLVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 06:21:09 -0500
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4DK8SR02gWz5HDF;
        Mon, 18 Jan 2021 19:19:19 +0800 (CST)
Received: from [127.0.0.1] (10.69.26.252) by dggeme755-chm.china.huawei.com
 (10.3.19.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2106.2; Mon, 18
 Jan 2021 19:20:24 +0800
Subject: Re: [PATCH net-next] net: hns3: debugfs add dump tm info of nodes,
 priority and qset
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
References: <1610694569-43099-1-git-send-email-tanhuazhong@huawei.com>
 <20210116182306.65a268a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <d2fc48f6-aa2f-081a-dbce-312b869b8e04@huawei.com>
Date:   Mon, 18 Jan 2021 19:20:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210116182306.65a268a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme709-chm.china.huawei.com (10.1.199.105) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/17 10:23, Jakub Kicinski wrote:
> On Fri, 15 Jan 2021 15:09:29 +0800 Huazhong Tan wrote:
>> From: Guangbin Huang <huangguangbin2@huawei.com>
>>
>> To increase methods to dump more tm info, adds three debugfs commands
>> to dump tm info of nodes, priority and qset. And a new tm file of debugfs
>> is created for only dumping tm info.
>>
>> Unlike previous debugfs commands, to dump each tm information, user needs
>> to enter two commands now. The first command writes parameters to tm and
>> the second command reads info from tm. For examples, to dump tm info of
>> priority 0, user needs to enter follow two commands:
>> 1. echo dump priority 0 > tm
>> 2. cat tm
>>
>> The reason for adding new tm file is because we accepted Jakub Kicinski's
>> opinion as link https://lkml.org/lkml/2020/9/29/2101. And in order to
>> avoid generating too many files, we implement write ops to allow user to
>> input parameters.
> Why are you trying to avoid generating too many files? How many files
> would it be? What's the size of each dump/file?


The maximum number of tm node, priority and qset are 8, 256,
1280, if we create a file for each one, then there are 8 node
files, 256 priority files, 1280 qset files. It seems a little
bit hard for using as well.


Thanks.

>> However, If there are two or more users concurrently write parameters to
>> tm, parameters of the latest command will overwrite previous commands,
>> this concurrency problem will confuse users, but now there is no good
>> method to fix it.
> .

