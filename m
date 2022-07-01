Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADB3563769
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiGAQHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiGAQHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:07:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4731A2A24D
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 09:07:33 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 261FLiXS005253;
        Fri, 1 Jul 2022 16:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=pp1;
 bh=VRy0vYnt3TMsLleXxuwDBXKGMkm1bH1iEXV1MOWzm1g=;
 b=JQxQPmvCiq2uv8aGOaG9hRR/VyMU2xdi1lPmaGay22EUrF+WIQM4jKNwLTp0+X0tGHZ1
 O9fFwdrflvIyD6LvxV1sgIJyFNhjJxCzu9OOv96575GEreEdsdUC40ztrZgRyP5w59HH
 Yk1AO1KIITQgZ3n5E4rv+akzB8fI6O2+1C5tgK7pj1nxCIthf2PK0XMFyUGTP/7P+3jJ
 MmJwfq/r/0djNboI7NwD07/rWHkdR3bdlTu6xp1ns31I9BaVVtulxk8+Q5b/yNbPvad3
 U/Y+qCGQZ2vwakp3IJVLaz4AV44QR4O58B3W836xC80H2X4c37t7Df6y13PMg48CUOYT lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h23gehh3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 16:07:29 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 261G7TFE006536;
        Fri, 1 Jul 2022 16:07:29 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h23gehh1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 16:07:29 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 261G6L2x010545;
        Fri, 1 Jul 2022 16:07:26 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3gwt097duu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 16:07:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 261G7OI420382158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Jul 2022 16:07:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04B5E11C04C;
        Fri,  1 Jul 2022 16:07:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2670011C04A;
        Fri,  1 Jul 2022 16:07:22 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.43.56.77])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Jul 2022 16:07:21 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH v1 net-next] af_unix: Put a named socket in the global
 hash table.
From:   Sachin Sant <sachinp@linux.ibm.com>
In-Reply-To: <20220701072519.96097-1-kuniyu@amazon.com>
Date:   Fri, 1 Jul 2022 21:37:20 +0530
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <B2998825-F963-4BF6-BD6F-7665E51DBAE8@linux.ibm.com>
References: <20220701072519.96097-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
X-Mailer: Apple Mail (2.3696.100.31)
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qsw_cdl2dahtlC3UbD4_ovpaNPPik8D4
X-Proofpoint-GUID: O-d7Pr9nfpQbjTax2oNvPMtfqPpg6c1z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-01_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 impostorscore=0 bulkscore=0 malwarescore=0 mlxlogscore=968 adultscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207010064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Note when dumping sockets by sock_diag, procfs, and bpf_iter, they are
> filtered only by netns.  In other words, sockets with different netns
> and the same mount ns are skipped while iterating sockets.  Thus, we
> need a fix only for finding a peer socket.
> 
> This patch adds a global hash table for named sockets, links them with
> sk_bind_node, and uses it in unix_find_socket_byinode().  By doing so,
> we can keep all sockets in per-netns hash tables and dump them easily.
> 
> Thank Sachin Sant and Leonard Crestez for reports, logs and a reproducer.
> 
> Fixes: cf2f225e2653 ("af_unix: Put a socket into a per-netns hash table.")
> Reported-by: Sachin Sant <sachinp@linux.ibm.com>
> Reported-by: Leonard Crestez <cdleonard@gmail.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> net/unix/af_unix.c | 47 ++++++++++++++++++++++++++++++++++++----------
> 1 file changed, 37 insertions(+), 10 deletions(-)
> 

Thanks for the fix. 
The patch fixes the reported problem.

Tested-by: Sachin Sant <sachinp@linux.ibm.com>

- Sachin

