Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB0060BE70
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 01:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiJXXSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 19:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbiJXXSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 19:18:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5972E25E9
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:38:59 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OLGJso003162
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 21:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=zDi5MyIfhVNkrw7FtYNDU4o3zaqIRO+PWC9NNdAJuKk=;
 b=lEIBfqiK3L2A9Zn8b7iRlfa/oB5LOfYPvmzO7XI0X+xAjOkt1mbKdDYErH96uDTBWR3U
 yUrf2UMv063laIpZd4c1KFzm4M8gqfopvEd+FSRtzGif9gS9n4VKG7rX2qTOL+3+OXGh
 CD3zPLl6ee8uja/0knwjlT8Ye3YIBlU5p3r0plsVjFOlRvl74v3h0lUwgzByL1EuFOu2
 yk2YJWOZFk824LQkMdjERzJ3GfKQvxpvd5DCLzwHIf4pQnVp9AipM3fqFmpV0ppRtOpz
 P1X36TvHqFLpl0BcgT3LCiWRtfN/F8Hz1AXB/uulb8sU2tZKPSUAXkXylGMSSZ1NRTv2 DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ke200sm8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 21:38:43 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29OLGLcv003318
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 21:38:43 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ke200sm7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 21:38:43 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29OLZQx5021156;
        Mon, 24 Oct 2022 21:38:42 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02wdc.us.ibm.com with ESMTP id 3kdytvscva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 21:38:42 +0000
Received: from smtpav02.dal12v.mail.ibm.com ([9.208.128.128])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29OLccWg41419088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 21:38:38 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF92C58065;
        Mon, 24 Oct 2022 21:38:38 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 547C25805A;
        Mon, 24 Oct 2022 21:38:38 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com (unknown [9.65.197.49])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 24 Oct 2022 21:38:38 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     nick.child@ibm.com, dave.taht@gmail.com,
        Nick Child <nnac123@linux.ibm.com>
Subject: [RFC PATCH net-next 0/1] ibmveth: Implement BQL
Date:   Mon, 24 Oct 2022 16:38:27 -0500
Message-Id: <20221024213828.320219-1-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xatmI735MCarRiYPoF-Vm48GbsehPYJa
X-Proofpoint-GUID: ujgkPNYw7VZ3C7x41fTOwc30OLUM8Dyt
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_07,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 mlxlogscore=935
 priorityscore=1501 suspectscore=0 phishscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240129
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Labeled as RFC because I am unsure if adding Byte Queue Limits (BQL) is
positively effecting the ibmveth driver. BQL is common among network
drivers so I would like to incorporate it into the virtual ethernet
driver, ibmveth. But I am having trouble measuring its effects.

From my understanding (and please correct me if I am wrong), BQL will 
use the number of packets sent to the NIC to approximate the minimum
number of packets to enqueue to a netdev_queue without starving the NIC.
As a result, bufferbloat in the networking queues are minimized which
may allow for smaller latencies.

After performing various netperf tests under differing loads and
priorities, I do not see any performance effect when comparing the
driver with and without BQL. The ibmveth driver is a virtual driver
which has an abstracted view of the NIC so I am comfortable without
seeing any performance deltas. That being said, I would like to know if
BQL is actually being enforced in some way. In other words, I would
like to observe a change in the number of queued bytes during BQL
implementations. Does anyone know of a mechanism to measure the length
of a netdev_queue?

I tried creating a BPF script[1] to track the bytes in a netdev_queue
but again am not seeing any difference with and without BQL. I do not
believe anything is wrong with BQL (it is more likely that my tracing
is bad) but I would like to have some evidence of BQL having a
positive effect on the device. Any recommendations or advice would be
greatly appreciated.
Thanks.

[1] https://github.com/nick-child-ibm/bpf_scripts/blob/main/bpftrace_queued_bytes.bt 

Nick Child (1):
  ibmveth: Implement BQL

 drivers/net/ethernet/ibm/ibmveth.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
2.31.1

