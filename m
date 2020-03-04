Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF299179742
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 18:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730103AbgCDRx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 12:53:58 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2509 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729749AbgCDRx5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 12:53:57 -0500
Received: from lhreml702-cah.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 17E83EE211FE9E141AC5;
        Wed,  4 Mar 2020 17:53:55 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml702-cah.china.huawei.com (10.201.108.43) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 4 Mar 2020 17:53:54 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 4 Mar 2020
 17:53:54 +0000
From:   John Garry <john.garry@huawei.com>
Subject: kmemleak report in tcp_metrics_init()->genl_register_family()
To:     <edumazet@google.com>, "David S . Miller" <davem@davemloft.net>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
        <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <786c9926-e92c-32d5-6a1f-b6352a077d5f@huawei.com>
Date:   Wed, 4 Mar 2020 17:53:53 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml725-chm.china.huawei.com (10.201.108.76) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi guys,

On 5.6-rc4, I get this report of a memory leak after booting:

root@(none)$ more /sys/kernel/debug/kmemleak
unreferenced object 0xffff2027d1838300 (size 128):
   comm "swapper/0", pid 1, jiffies 4294894708 (age 155.112s)
   hex dump (first 32 bytes):
     80 82 83 d1 27 20 ff ff 00 00 00 00 00 00 00 00  ....' ..........
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<(____ptrval____)>] __kmalloc+0x1c8/0x2d0
     [<(____ptrval____)>] genl_register_family+0x300/0x6a8
     [<(____ptrval____)>] tcp_metrics_init+0x30/0x48
     [<(____ptrval____)>] tcp_init+0x270/0x29c
     [<(____ptrval____)>] inet_init+0x178/0x264
     [<(____ptrval____)>] do_one_initcall+0x5c/0x1b0
     [<(____ptrval____)>] kernel_init_freeable+0x1f8/0x260
     [<(____ptrval____)>] kernel_init+0x10/0x108
     [<(____ptrval____)>] ret_from_fork+0x10/0x18


.config is here https://pastebin.com/RbvNz825, dmesg 
https://pastebin.com/ABW4S1Qw

Cheers,
John
