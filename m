Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BACC3E1C09
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242172AbhHETEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:04:48 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:41724 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242313AbhHETEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 15:04:33 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 175J4JDp011244
        for <netdev@vger.kernel.org>; Thu, 5 Aug 2021 14:04:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1628190259;
        bh=KJjBxFRrLVVeMq6WW7rpCQvJaLIXnD5n8GjN1/3L91U=;
        h=To:From:Subject:Date;
        b=vg9cbysw/aM7P8+wnN9dqSH0VRBHoCjzncbvVZeIFB86qGUbkJfCwfwBV4qUyt9Pr
         QTnXnxxviPn6wCQV2JjB6Mt3pwRxxh+7Hh76SIVvTRd7hsWYWyyjOFgPVsIu65ZLZX
         FpoL+B2785mPC+6lkwZw4+hXS914Ur7OKoAcwIE4=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 175J4J0I052428
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <netdev@vger.kernel.org>; Thu, 5 Aug 2021 14:04:19 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 5 Aug
 2021 14:04:18 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 5 Aug 2021 14:04:18 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 175J4HdD109830
        for <netdev@vger.kernel.org>; Thu, 5 Aug 2021 14:04:18 -0500
To:     netdev <netdev@vger.kernel.org>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [net-next] WARNING: CPU: 2 PID: 1189 at ../net/core/skbuff.c:5412
 skb_try_coalesce+0x354/0x368
Message-ID: <dcf8012a-ffa5-f5ab-af68-5c59a410299f@ti.com>
Date:   Thu, 5 Aug 2021 22:04:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all

with current net-next is see below splat when run netperf TCP_STREAM

<REMOTE HOST> netperf -l 10 -H 192.168.1.2 -t TCP_STREAM -c -C -j -B "am6 " -s 1 -s 1

Is this know issue?

<FAILED DUT>
root@am65xx-evm:~# uname -a
Linux am65xx-evm 5.14.0-rc3-00973-g372bbdd5bb3f #5 SMP PREEMPT Thu Aug 5 21:57:28 EEST 2021 aarch64 GNU/Linux

root@am65xx-evm:~# [  227.929271] ------------[ cut here ]------------
[  227.933917] WARNING: CPU: 2 PID: 1189 at ../net/core/skbuff.c:5412 skb_try_coalesce+0x354/0x368
[  227.942624] Modules linked in:
[  227.945679] CPU: 2 PID: 1189 Comm: netserver Not tainted 5.14.0-rc3-00973-g372bbdd5bb3f #5
[  227.953931] Hardware name: Texas Instruments AM654 Base Board (DT)
[  227.960098] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
[  227.966097] pc : skb_try_coalesce+0x354/0x368
[  227.970449] lr : tcp_try_coalesce.part.74+0x48/0x180
[  227.975410] sp : ffff80001544fa40
[  227.978716] x29: ffff80001544fa40 x28: ffff0008013a0dc0 x27: 0000000000000000
[  227.985851] x26: 0000000000000000 x25: 0000000000002d20 x24: ffff000809f25240
[  227.992984] x23: ffff000809f286c0 x22: 0000000000002d40 x21: ffff80001544fac4
[  228.000118] x20: ffff000807536600 x19: ffff000807535800 x18: 0000000000000000
[  228.007251] x17: 0000000000000000 x16: 0000000000000000 x15: ffff00080794a882
[  228.014384] x14: 72657074656e0066 x13: 0000000000000080 x12: ffff000800792e58
[  228.021517] x11: 0000000000000000 x10: 0000000000000001 x9 : ffff000000000000
[  228.028650] x8 : 0000000000002798 x7 : 00000000000005a8 x6 : ffff000809f24c82
[  228.035783] x5 : 0000000000000000 x4 : 0000000000000640 x3 : 0000000000000001
[  228.042915] x2 : ffff80001544fb57 x1 : 0000000000000007 x0 : ffff000809f286c0
[  228.050050] Call trace:
[  228.052490]  skb_try_coalesce+0x354/0x368
[  228.056497]  tcp_try_coalesce.part.74+0x48/0x180
[  228.061108]  tcp_queue_rcv+0x12c/0x170
[  228.064853]  tcp_rcv_established+0x558/0x6f8
[  228.069118]  tcp_v4_do_rcv+0x90/0x220
[  228.072775]  __release_sock+0x70/0xb8
[  228.076439]  release_sock+0x30/0x90
[  228.079926]  tcp_recvmsg+0x90/0x1d0
[  228.083411]  inet_recvmsg+0x54/0x128
[  228.086983]  __sys_recvfrom+0xbc/0x148
[  228.090728]  __arm64_sys_recvfrom+0x24/0x38
[  228.094906]  invoke_syscall+0x44/0x100
[  228.098655]  el0_svc_common+0x3c/0xd8
[  228.102314]  do_el0_svc+0x28/0x90
[  228.105626]  el0_svc+0x24/0x38
[  228.108679]  el0t_64_sync_handler+0x90/0xb8
[  228.112857]  el0t_64_sync+0x178/0x17c
[  228.116517] ---[ end trace 2e0ec9d02424634a ]---        0

-- 
Best regards,
grygorii
