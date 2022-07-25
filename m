Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C684C580726
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 00:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbiGYWNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 18:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiGYWN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 18:13:29 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C89124BDD
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 15:13:28 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26PLFM1p031990;
        Mon, 25 Jul 2022 22:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : from : to : cc : subject : content-type :
 content-transfer-encoding; s=pp1;
 bh=FeuQet+e1e2F42+WxKEFeKctMlxQKlzOjhpMRcmZpcY=;
 b=KDscwQQSx4PCWVibKeHMy6UD5PcgmIF2Dft4J3llMFAVfGYbVbjBCbq6E7A28j46EvTI
 7GD1QUhVDejQ4CGvVdj5GeXBBmmQAEc1caTEktnXA4A1IWnCZqgI3Rca8sxj7JQ/jBTT
 V/YvE7q8XIo8n3HXc6Cg/kzNcoJgtuq0S1R7YWnoQDinTdjedxcz/VrTTqWGzEpNn0wB
 CFyX5lHTp8mSut7Cu1OCQsDizhASXrDe5jlLInA/v83OEn/zx6xTVp9NF+sBxzpzi/Jy
 rOSg1YEjL+hFcSf7nHylUo115IHnb7SoCFpFMhrA4+kj7spJpvVg8rVRH+iM8YaWbwbX FQ== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hj2x9s834-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 22:13:25 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26PM6MS4029004;
        Mon, 25 Jul 2022 22:13:24 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04wdc.us.ibm.com with ESMTP id 3hg94af1k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 22:13:24 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26PMDOpM29622728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jul 2022 22:13:24 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F4BC78063;
        Mon, 25 Jul 2022 22:13:24 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC1A27805C;
        Mon, 25 Jul 2022 22:13:23 +0000 (GMT)
Received: from [9.211.52.76] (unknown [9.211.52.76])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 25 Jul 2022 22:13:23 +0000 (GMT)
Message-ID: <d8b21ff4-422b-28ee-fc49-f8d9612ebccf@linux.vnet.ibm.com>
Date:   Mon, 25 Jul 2022 15:13:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-Language: en-US
From:   David Christensen <drc@linux.vnet.ibm.com>
To:     davem@davemloft.net, Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com
Cc:     Netdev <netdev@vger.kernel.org>
Subject: EEH Error With NAPI_STATE_SCHED Set in BNX2X Results in RTNL Held
 While Sleeping
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6LSNC7EFrID9TWGrFdc_8WdBAQ6Kb7gA
X-Proofpoint-GUID: 6LSNC7EFrID9TWGrFdc_8WdBAQ6Kb7gA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-25_13,2022-07-25_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1011 malwarescore=0 adultscore=0 impostorscore=0 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 mlxlogscore=570 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207250090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_FILL_THIS_FORM_SHORT autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While performing EEH error recovery tests, internal test team 
encountered an issue where the bnx2x driver is holding the RTNL lock 
while sleeping in napi_disable() on a SuSE 15.3-SP3 system (kernel 
5.3.18-150300.59.68) while running network stress on multiple adapters, 
even when a previous fix (bnx2x: fix napi API usage sequence) has been 
applied to the bnx2x driver.

crash> foreach UN bt
PID: 213    TASK: c000000004ba9f80  CPU: 9   COMMAND: "eehd"
  #0 [c000000004c277e0] __schedule at c000000000c756a8
  #1 [c000000004c278b0] schedule at c000000000c75d80
  #2 [c000000004c278e0] schedule_timeout at c000000000c7bc8c
  #3 [c000000004c279c0] msleep at c000000000212bec
  #4 [c000000004c279f0] napi_disable at c000000000a0b2e8
  #5 [c000000004c27a30] bnx2x_netif_stop at c0080000015cbbf4 [bnx2x]
  #6 [c000000004c27a60] bnx2x_io_slot_reset at c00800000159555c [bnx2x]
  #7 [c000000004c27b20] eeh_report_reset at c00000000004ca3c
  #8 [c000000004c27b90] eeh_pe_report at c00000000004d228
  #9 [c000000004c27c40] eeh_handle_normal_event at c00000000004dae4
#10 [c000000004c27d00] eeh_event_handler at c00000000004e3b0
#11 [c000000004c27db0] kthread at c000000000175f9c
#12 [c000000004c27e20] ret_from_kernel_thread at c00000000000cda8

What's interesting to me in this case is that the failure only occurs 
when stress testing multiple adapters simultaneously and injecting the 
EEH error to an upstream PCIe switch.  If errors are injected to the 
switch while running stress tests on a single NIC, no problem is observed.

Reviewing the bnx2x driver code did not reveal any obvious problems, but 
when reviewing the NAPI state machine it did appear to my eye that there 
is no practical method to abort a scheduled poll in the driver (i.e. 
when NAPI_STATE_SCHED is set), so there's no obvious mechanism for the 
driver to recover in this situation when the NIC registers are 
inaccessible due to the EEH.

My attempt to introduce such a mechanism, shown below, hasn't resolved 
the problem. The NIC receives a hardware interrupt while initializing 
the driver which results in a NULL pointer reference, suggesting I've 
missed some required step.

void napi_err_cancel(struct napi_struct *n)
{
         unsigned long flags, new, val;

         if (n->gro_bitmask) {
                 napi_gro_flush(n, true);
         }

         gro_normal_list(n);

         if (unlikely(!list_empty(&n->poll_list))) {
                 /* If n->poll_list is not empty, we need to mask irqs */
                 local_irq_save(flags);
                 list_del_init(&n->poll_list);
                 local_irq_restore(flags);
         }

         do {
                 val = READ_ONCE(n->state);
                 WARN_ON(test_bit(NAPI_STATE_DISABLE, &val));

                 new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED);
         } while (cmpxchg(&n->state, val, new) != val);

         return (val & NAPIF_STATE_SCHED);
}
EXPORT_SYMBOL(napi_err_cancel);

My question: Is a new function required to abort a schedule poll, and if 
so, what else is required?  I reviewed several other drivers that 
support EEH and did not see any that appear to handle this situation.

Dave

P.S. A few additional details on the failure.

crash> net
    NET_DEVICE     NAME   IP ADDRESS(ES)
c000000ef3bd3000  lo     127.0.0.1
c000000eef1f3000  eth0   9.3.233.22
c000000002490000  eth8   106.1.233.22 (tg3)
c000000002498000  eth1   107.1.233.22 (bnx2x)
c0000000024a4000  eth9   106.2.233.22 (tg3)
c0000000024b4000  eth10  109.1.233.22 (tg3)
c000000002494000  eth5   110.1.233.22 (e1000e)
c0000000024a8000  eth2   107.2.233.22 (bnx2x)
c0000000024b8000  eth6   109.2.233.22 (tg3)
c0000000024bc000  eth7   110.2.233.22 (e10001)
c000000eb3000000  eth16  111.1.233.22 (mlx5)
c000000eab100000  eth15  111.2.233.22 (mlx5)

# Get address of bnx2x structure for eth1
crash> struct -ox net_device
struct net_device {
...
}
SIZE: 0x980

crash> struct -x bnx2x c000000002498980
struct bnx2x {
   fp = 0xc000000002520000,
...
}

# Observe NAPI struct in per-queue fastpath[0]
crash> struct -x bnx2x_fastpath c000000002520000
struct bnx2x_fastpath {
   bp = 0xc000000002498980,
   napi = {
     poll_list = {
       next = 0xc000000002520008,
       prev = 0xc000000002520008
     },
     state = 13,
     weight = 64,
     defer_hard_irqs_count = 0,
     gro_bitmask = 0,
     poll = 0xc0080000015c8a88 <bnx2x_poll>,
     poll_owner = -1,
     dev = 0xc000000002498000,
     gro_hash = {{
         list = {
           next = 0xc000000002520048,
           prev = 0xc000000002520048
         },
         count = 0
       }, {
         list = {
           next = 0xc000000002520060,
           prev = 0xc000000002520060
         },
         count = 0
       }, {
         list = {
           next = 0xc000000002520078,
           prev = 0xc000000002520078
         },
         count = 0
       }, {
         list = {
           next = 0xc000000002520090,
           prev = 0xc000000002520090
         },
         count = 0
       }, {
         list = {
           next = 0xc0000000025200a8,
           prev = 0xc0000000025200a8
         },
         count = 0
       }, {
         list = {
           next = 0xc0000000025200c0,
           prev = 0xc0000000025200c0
         },
         count = 0
       }, {
         list = {
           next = 0xc0000000025200d8,
           prev = 0xc0000000025200d8
         },
         count = 0
       }, {
         list = {
           next = 0xc0000000025200f0,
           prev = 0xc0000000025200f0
         },
         count = 0
       }},
     skb = 0x0,
     rx_list = {
       next = 0xc000000002520110,
       prev = 0xc000000002520110
     },
     rx_count = 0,
     timer = {
       node = {
         node = {
           __rb_parent_color = 13835058055321092392,
           rb_right = 0x0,
           rb_left = 0x0
         },
         expires = 0
       },
       _softexpires = 0,
       function = 0xc000000000a0d2d0 <napi_watchdog>,
       base = 0xc000000efce32380,
       state = 0 '\000',
       is_rel = 0 '\000',
       is_soft = 0 '\000'
     },
     dev_list = {
       next = 0xc000000002520168,
       prev = 0xc000000002520168
     },
     napi_hash_node = {
       next = 0x0,
       pprev = 0x5deadbeef0000122
     },
     napi_id = 2284
   },
...
}

crash> struct -ox bnx2x_fastpath
struct bnx2x_fastpath {
...
}
SIZE: 0x2f0

# ... and NAPI struct in fastpath[1]
crash> struct -x bnx2x_fastpath c0000000025202f0
struct bnx2x_fastpath {
   bp = 0xc000000002498980,
   napi = {
     poll_list = {
       next = 0xc0000000025202f8,
       prev = 0xc0000000025202f8
     },
     state = 0x9,
     weight = 0x40,
     defer_hard_irqs_count = 0x0,
     gro_bitmask = 0x0,
     poll = 0xc0080000015c8a88 <bnx2x_poll>,
     poll_owner = 0xffffffff,
     dev = 0xc000000002498000,
     gro_hash = {{
         list = {
           next = 0xc000000002520338,
           prev = 0xc000000002520338
         },
         count = 0x0
       }, {
         list = {
           next = 0xc000000002520350,
           prev = 0xc000000002520350
         },
         count = 0x0
       }, {
         list = {
           next = 0xc000000002520368,
           prev = 0xc000000002520368
         },
         count = 0x0
       }, {
         list = {
           next = 0xc000000002520380,
           prev = 0xc000000002520380
         },
         count = 0x0
       }, {
         list = {
           next = 0xc000000002520398,
           prev = 0xc000000002520398
         },
         count = 0x0
       }, {
         list = {
           next = 0xc0000000025203b0,
           prev = 0xc0000000025203b0
         },
         count = 0x0
       }, {
         list = {
           next = 0xc0000000025203c8,
           prev = 0xc0000000025203c8
         },
         count = 0x0
       }, {
         list = {
           next = 0xc0000000025203e0,
           prev = 0xc0000000025203e0
         },
         count = 0x0
       }},
     skb = 0x0,
     rx_list = {
       next = 0xc000000002520400,
       prev = 0xc000000002520400
     },
     rx_count = 0x0,
     timer = {
       node = {
         node = {
           __rb_parent_color = 0xc000000002520418,
           rb_right = 0x0,
           rb_left = 0x0
         },
         expires = 0x0
       },
       _softexpires = 0x0,
       function = 0xc000000000a0d2d0 <napi_watchdog>,
       base = 0xc000000efce32380,
       state = 0x0,
       is_rel = 0x0,
       is_soft = 0x0
     },
     dev_list = {
       next = 0xc000000002520458,
       prev = 0xc000000002520458
     },
     napi_hash_node = {
       next = 0x0,
       pprev = 0x5deadbeef0000122
     },
     napi_id = 0x8ed
   },
...
}

# ... fastpath[2..X] structs also show NAPI state as 9
