Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D69161364E
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbiJaM1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiJaM1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:27:47 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1151FCE5;
        Mon, 31 Oct 2022 05:27:06 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N1C7q1jhwzHvRP;
        Mon, 31 Oct 2022 20:26:47 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 20:27:04 +0800
Subject: Re: [ovs-dev] [PATCH net] openvswitch: add missing resv_start_op
 initialization for dp_vport_genl_family
To:     Ilya Maximets <i.maximets@ovn.org>, <pshelar@ovn.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <dev@openvswitch.org>
CC:     <linux-kernel@vger.kernel.org>
References: <20221031081210.2852708-1-william.xuanziyang@huawei.com>
 <7f118c0f-c79a-7f26-aefc-afae00483233@ovn.org>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <9b86ae1c-4700-f41f-29ab-4372ec9e7b22@huawei.com>
Date:   Mon, 31 Oct 2022 20:27:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <7f118c0f-c79a-7f26-aefc-afae00483233@ovn.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 10/31/22 09:12, Ziyang Xuan via dev wrote:
>> I got a warning using the latest mainline codes to start vms as following:
>>
>> ===================================================
>> WARNING: CPU: 1 PID: 1 at net/netlink/genetlink.c:383 genl_register_family+0x6c/0x76c
>> CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc2-00886-g882ad2a2a8ff #43
>> ...
>> Call trace:
>>  genl_register_family+0x6c/0x76c
>>  dp_init+0xa8/0x124
>>  do_one_initcall+0x84/0x450
>>
>> It is because that commit 9c5d03d36251 ("genetlink: start to validate
>> reserved header bytes") has missed the resv_start_op initialization
>> for dp_vport_genl_family, and commit ce48ebdd5651 ("genetlink: limit
>> the use of validation workarounds to old ops") add checking warning.
>>
>> Add resv_start_op initialization for dp_vport_genl_family to fix it.
>>
>> Fixes: 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
> 
> Hi, Ziyang Xuan.  Thanks for the patch!
> 
> But it looks like Jakub already fixed that issue a couple of days ago:
>   https://git.kernel.org/netdev/net/c/e4ba4554209f
> 

That's fine. Ignore this.

Thank you.

> Best regards, Ilya Maximets.
> 
> .
> 
