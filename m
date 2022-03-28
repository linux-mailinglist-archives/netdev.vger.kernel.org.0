Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1D84E8FE0
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 10:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239203AbiC1IQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 04:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239184AbiC1IQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 04:16:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E7713D49;
        Mon, 28 Mar 2022 01:14:48 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22S7BHIX030140;
        Mon, 28 Mar 2022 08:14:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=/6fqljDLo66D/QnPQ+CevPQegWYTq0n+psUMxtgm+pA=;
 b=hp44cF9R8b/vyuRFLfnxU9oA911azijr17ci/R8bqIvevygfAsVv2Oj1C0EPJbWkK6qs
 jAfAmOQbD1e3lYEyb+xztI3E84DJavFzpPQu/Ynubdebk+x0w0t3DnfOUGTNDg8iSy6K
 ryqKhgDE6JBVEsfdQZTgQLBrdK2x+DHzPM2HGpuswMoqU/doKY5XOaS/TfZtKfO4O1pK
 9sxkDlTXE+IunxdNfbf4UZnRzvnyMPVWmKQ0KyjEPDAVAxR4zCpu67IXOprkEhoGeZ+z
 F9WTiRIAVgNaKqZKVF/87xOgR/VY60F1/fr4wmyXUmjEbgJV11pfTvB0ioxdMpHotk1i ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f2c8j4ww5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 08:14:31 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22S7w6dU012050;
        Mon, 28 Mar 2022 08:14:31 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f2c8j4wvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 08:14:30 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22S8DVpJ007374;
        Mon, 28 Mar 2022 08:14:29 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3f1tf8jx76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 08:14:29 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22S82VaY44695860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 08:02:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91594A4053;
        Mon, 28 Mar 2022 08:14:25 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AC6BA4040;
        Mon, 28 Mar 2022 08:14:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 28 Mar 2022 08:14:25 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id 2FAA2E1FFE; Mon, 28 Mar 2022 10:14:25 +0200 (CEST)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 0/1] veth: Support bonding events
Date:   Mon, 28 Mar 2022 10:14:16 +0200
Message-Id: <20220328081417.1427666-1-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tMvRc4urkMauDHxdDFCImmplfl2-rgI8
X-Proofpoint-GUID: JXIw4A-TnEXQDyWnuMu34rKtyoV8l0dk
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_02,2022-03-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1011
 mlxlogscore=884 impostorscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203280046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case virtual instances are attached to an external network via veth
and a bridge, the interface to the external network can be a bond
interface. Bonding drivers generate specific events during failover
that trigger switch updates.  When a veth device is attached to a
bridge with a bond interface, we want external switches to learn about
the veth devices as well.

Without this patch we have seen cases where recovery after bond
failover took an unacceptable amount of time (depending on timeout
settings in the network).

Due to the symmetric nature of veth special care is required to avoid
endless notification loops. Therefore we only notify from a veth
bridgeport to a peer that is not a bridgeport.

References:
Same handling as for macvlan:
4c9912556867 ("macvlan: Support bonding events"
and vlan:
4aa5dee4d999 ("net: convert resend IGMP to notifier event")

Alternatives:
Propagate notifier events to all ports of a bridge. IIUC, this was
rejected in https://www.spinics.net/lists/netdev/msg717292.html
It also seems difficult to avoid re-bouncing the notifier.

Alexandra Winter (1):
  veth: Support bonding events

 drivers/net/veth.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

-- 
2.32.0

