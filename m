Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA2F896FB
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 07:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfHLFsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 01:48:15 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4658 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725901AbfHLFsO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 01:48:14 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DBBA81890D9B4B653AE7;
        Mon, 12 Aug 2019 13:48:06 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Mon, 12 Aug 2019
 13:48:04 +0800
Subject: Re: [PATCH net-next] net: can: Fix compiling warning
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20190802033643.84243-1-maowenan@huawei.com>
 <0050efdb-af9f-49b9-8d83-f574b3d46a2e@hartkopp.net>
 <20190806135231.GJ1974@kadam>
 <6e1c5aa0-8ed3-eec3-a34d-867ea8f54e9d@hartkopp.net>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
From:   maowenan <maowenan@huawei.com>
Message-ID: <5018f6ca-53b5-c712-a012-a0fcda5c10c2@huawei.com>
Date:   Mon, 12 Aug 2019 13:48:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <6e1c5aa0-8ed3-eec3-a34d-867ea8f54e9d@hartkopp.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/8/7 0:41, Oliver Hartkopp wrote:
> Hello Dan,
> 
> On 06/08/2019 15.52, Dan Carpenter wrote:
>> On Fri, Aug 02, 2019 at 10:10:20AM +0200, Oliver Hartkopp wrote:
> 
>>> Btw. what kind of compiler/make switches are you using so that I can see
>>> these warnings myself the next time?
>>
>> These are Sparse warnings, not from GCC.
> 
> I compiled the code (the original version), but I do not get that "Should it be static?" warning:

Hello Oliver,

here are my steps for net/can/bcm.c,
make allmodconfig ARCH=mips CROSS_COMPILE=mips-linux-gnu-
make C=2 net/can/bcm.o ARCH=mips CROSS_COMPILE=mips-linux-gnu-

  CHECK   scripts/mod/empty.c
  CALL    scripts/checksyscalls.sh
<stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
  CALL    scripts/atomic/check-atomics.sh
  CHECK   net/can/bcm.c
./include/linux/slab.h:672:13: error: undefined identifier '__builtin_mul_overflow'
./include/linux/slab.h:672:13: error: not a function <noident>
./include/linux/slab.h:672:13: error: not a function <noident>
net/can/bcm.c:1683:5: warning: symbol 'bcm_sock_no_ioctlcmd' was not declared. Should it be static?
./include/linux/slab.h:672:13: warning: call with no type!
  CC [M]  net/can/bcm.o

for net/can/raw.c,
make allmodconfig ARCH=mips CROSS_COMPILE=mips-linux-gnu-
make C=2 net/can/raw.o ARCH=mips CROSS_COMPILE=mips-linux-gnu-

  CHECK   scripts/mod/empty.c
  CALL    scripts/checksyscalls.sh
<stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
  CALL    scripts/atomic/check-atomics.sh
  CHECK   net/can/raw.c
net/can/raw.c:840:5: warning: symbol 'raw_sock_no_ioctlcmd' was not declared. Should it be static?
  CC [M]  net/can/raw.o

