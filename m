Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02ACE5810B3
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 12:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbiGZKE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 06:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237858AbiGZKEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 06:04:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25343205D;
        Tue, 26 Jul 2022 03:04:03 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26Q8rSAj003239;
        Tue, 26 Jul 2022 10:04:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sLKh7CxcqpanIi/lO9M2uyYqsgJ/Auazp9eQ0Nc+H38=;
 b=r0dXkVoZWJ0GlWQCjGRSiPbHJ1YNzynNuKE0YmSlGuWbeBjKemBTGy7iMZl8JWLBc6K/
 fNYpkIbDX9yC/ShkY6Mm4dru0CZCN9IFu3eV9BjKpkiaUBwB4biY7k9XgIgtCrRZTj4G
 6hRi+SZofIJm4x1wTjySgwEcLXjsfZVqj6QgLMlIJLs8q+UkT8tJ42OQzXFF/wyMT4ZT
 yQ9gU81GEN2nZksJHpNd5/XTbJ9VUTXS5si4gWesEDSScHSRGR3ZCcnCaIDtuHyFDcA+
 sEm+pH8XoQXDsLe1byLo1gUYw7D30VCKN4nRmiRlulChKd3B3Js90J7ZIsn6huIx8Wda iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjd59hvb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 10:04:01 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26QA08gT033414;
        Tue, 26 Jul 2022 10:04:01 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjd59hv9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 10:04:00 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26Q9oQCj029159;
        Tue, 26 Jul 2022 10:03:58 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3hg94eaq9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 10:03:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26QA3tEu8454548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 10:03:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 242724C040;
        Tue, 26 Jul 2022 10:03:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1B714C04E;
        Tue, 26 Jul 2022 10:03:51 +0000 (GMT)
Received: from MBP-von-Wenjia.fritz.box.com (unknown [9.211.107.22])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Jul 2022 10:03:51 +0000 (GMT)
From:   Wenjia Zhang <wenjia@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Subject: [PATCH net-next v2 4/4] net/smc: Enable module load on netlink usage
Date:   Tue, 26 Jul 2022 12:03:30 +0200
Message-Id: <20220726100330.75191-5-wenjia@linux.ibm.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220726100330.75191-1-wenjia@linux.ibm.com>
References: <20220726100330.75191-1-wenjia@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wDmtvY9exeXcYIfDBOWE9en78Xbh5jO_
X-Proofpoint-ORIG-GUID: 0AspDuTbAMRLG-Ys-Fa5iiv_vEgDNO04
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_02,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207260037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Raspl <raspl@linux.ibm.com>

Previously, the smc and smc_diag modules were automatically loaded as
dependencies of the ism module whenever an ISM device was present.
With the pending rework of the ISM API, the smc module will no longer
automatically be loaded in presence of an ISM device. Usage of an AF_SMC
socket will still trigger loading of the smc modules, but usage of a
netlink socket will not.
This is addressed by setting the correct module aliases.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
---
 net/smc/af_smc.c   | 1 +
 net/smc/smc_diag.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 6e70d9c10b78..79c1318af1fe 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3515,3 +3515,4 @@ MODULE_DESCRIPTION("smc socket address family");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NETPROTO(PF_SMC);
 MODULE_ALIAS_TCP_ULP("smc");
+MODULE_ALIAS_GENL_FAMILY(SMC_GENL_FAMILY_NAME);
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index 1fca2f90a9c7..80ea7d954ece 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -268,3 +268,4 @@ module_init(smc_diag_init);
 module_exit(smc_diag_exit);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_NETLINK, NETLINK_SOCK_DIAG, 43 /* AF_SMC */);
+MODULE_ALIAS_GENL_FAMILY(SMCR_GENL_FAMILY_NAME);
-- 
2.35.2

