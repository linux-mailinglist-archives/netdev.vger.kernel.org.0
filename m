Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46F24FFC21
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236701AbiDMRNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237341AbiDMRMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:12:53 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF771B796
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:10:32 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DGrfY6029364
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=rkK91+nXTlp1E16WkN+ugp9VYqWjIU2WOhzNDXwhIG4=;
 b=Qe8Nk73CR5FsovDK4HKyW3g+w0JL7/m6pnLtupT1DvcpDAWma1c6lh0dVu/FxDiVhChY
 JVmzZn+Y/TQkxIIcTPRW8MbS3GIiZk2dh0S1nhknlAwF4+MzXKGnNU5KxJvnuTfZvcM8
 Siww+LCBt1ORk06adBBVsryt8oMjYPkFTvT15+QUlFBnvbPzJ5HOSByIGkSuUvq0Q/5B
 gUB+ZpLg2hBczFs7YSE2al+NrGiXHsDzsATP7itKOOy9nE++XNR/rBcLodKOIl2mWgtT
 Qkz5UXL7U0qzHJrfNni4ewmUb7cmlEdEvNRGjLXyzsknWSM5DXPAKVE6R4slY0qLx/y0 XA== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fe186j99p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:31 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23DGrNqE014125
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:30 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 3fb1s9su97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:30 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23DHATEF15335692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Apr 2022 17:10:29 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83F28124053;
        Wed, 13 Apr 2022 17:10:29 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CABE124060;
        Wed, 13 Apr 2022 17:10:29 +0000 (GMT)
Received: from ltcden12-lp23.aus.stglabs.ibm.com (unknown [9.40.195.166])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 13 Apr 2022 17:10:29 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com
Subject: [PATCH net-next 0/6] ibmvnic: Use a set of LTBs per pool
Date:   Wed, 13 Apr 2022 13:10:20 -0400
Message-Id: <20220413171026.1264294-1-drt@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CVbBa-SUXfSxmuLkqFmzujfDXECyTq7g
X-Proofpoint-ORIG-GUID: CVbBa-SUXfSxmuLkqFmzujfDXECyTq7g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-13_03,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 suspectscore=0 impostorscore=0 mlxscore=0 clxscore=1011 lowpriorityscore=0
 phishscore=0 mlxlogscore=976 bulkscore=0 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204130086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

ibmvnic uses a single large long term buffer (LTB) per rx or tx
pool (queue). This has two limitations.
 
First, if we need to free/allocate an LTB (eg during a reset), under
low memory conditions, the allocation can fail. 

Second, the kernel limits the size of single LTB (DMA buffer) to 16MB
(based on MAX_ORDER). With jumbo frames (mtu = 9000) we can only have
about 1763 buffers per LTB (16MB / 9588 bytes per frame) even though
the max supported buffers is 4096. (The 9588 instead of 9088 comes from
IBMVNIC_BUFFER_HLEN.)

To overcome these limitations, allow creating a set of LTBs per queue.

Sukadev Bhattiprolu (6):
  ibmvnic: rename local variable index to bufidx
  ibmvnic: define map_rxpool_buf_to_ltb()
  ibmvnic: define map_txpool_buf_to_ltb()
  ibmvnic: convert rxpool ltb to a set of ltbs
  ibmvnic: Allow multiple ltbs in rxpool ltb_set
  ibmvnic: Allow multiple ltbs in txpool ltb_set

 drivers/net/ethernet/ibm/ibmvnic.c | 310 ++++++++++++++++++++++++-----
 drivers/net/ethernet/ibm/ibmvnic.h |  54 ++++-
 2 files changed, 308 insertions(+), 56 deletions(-)

-- 
2.27.0

