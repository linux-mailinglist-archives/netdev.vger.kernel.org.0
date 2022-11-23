Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6930635AEE
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 12:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237040AbiKWLEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 06:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236842AbiKWLDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 06:03:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405FA7C6AE;
        Wed, 23 Nov 2022 03:00:09 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AN9qoew029445;
        Wed, 23 Nov 2022 10:59:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=5SyPY29HvLNByajQto6ZZ5nFzuczfenX2LPAWmlMTpU=;
 b=eI7lhaoKEJLtWtF2rSlbG33iQ2uDiDHiaRRf/I4KegUblR6VI3HKFV6qmzY2eqbJ/3O6
 HpwE30Lx2M5FT3t4Akg/oVKp/e+aG9UqwpnHYVOMi7Vz+uTjtU472tKXPiTeD7YWIcaB
 fVDEUUgmSiNIRsVgaeCNz1NSJ4TewyvMP57qaQC/QNEJFFNCXnJ6/b8Lz2YlIXLEWCEj
 mttixwsHMx7Aa3CguwZ/Ia2E8w5EKkh036xs0Pp35RclefuoLCQf/HwsMCnrE2r6p98d
 mXztj+J4WtiySwc2jlczdYL/0tJR05FMbj0RfTrrZ+411D0v5y3fEaL6NPlhXMHlKqCx fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m100stjsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 10:59:59 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ANAxwde022895;
        Wed, 23 Nov 2022 10:59:58 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m100stjsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 10:59:58 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ANAp1G4023486;
        Wed, 23 Nov 2022 10:59:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3kxps8m29k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 10:59:56 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ANAxrXp2753250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 10:59:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DE935204F;
        Wed, 23 Nov 2022 10:59:53 +0000 (GMT)
Received: from LAPTOP-8S6R7U4L.localdomain (unknown [9.171.0.166])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7FA025204E;
        Wed, 23 Nov 2022 10:59:52 +0000 (GMT)
From:   Jan Karcher <jaka@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Subject: [PATCH net-next] net/smc: Unbind smc control from tcp control
Date:   Wed, 23 Nov 2022 11:58:30 +0100
Message-Id: <20221123105830.17167-1-jaka@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VUgPlRbf0c7UTTZGFVAMVBWzqf9j9E8g
X-Proofpoint-ORIG-GUID: M4J-Mh--bgisbBNhQ1APmZNrF3piQiuD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_05,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the past SMC used the values of tcp_{w|r}mem to create the send
buffer and RMB. We now have our own sysctl knobs to tune them without
influencing the TCP default.

This patch removes the dependency on the TCP control by providing our
own initial values which aim for a low memory footprint.

Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
---
 Documentation/networking/smc-sysctl.rst |  4 ++--
 net/smc/smc_core.h                      |  6 ++++--
 net/smc/smc_sysctl.c                    | 10 ++++++----
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/smc-sysctl.rst b/Documentation/networking/smc-sysctl.rst
index 6d8acdbe9be1..a1c634d3690a 100644
--- a/Documentation/networking/smc-sysctl.rst
+++ b/Documentation/networking/smc-sysctl.rst
@@ -44,7 +44,7 @@ smcr_testlink_time - INTEGER
 
 wmem - INTEGER
 	Initial size of send buffer used by SMC sockets.
-	The default value inherits from net.ipv4.tcp_wmem[1].
+	The default value aims for a small memory footprint and is set to 16KiB.
 
 	The minimum value is 16KiB and there is no hard limit for max value, but
 	only allowed 512KiB for SMC-R and 1MiB for SMC-D.
@@ -53,7 +53,7 @@ wmem - INTEGER
 
 rmem - INTEGER
 	Initial size of receive buffer (RMB) used by SMC sockets.
-	The default value inherits from net.ipv4.tcp_rmem[1].
+	The default value aims for a small memory footprint and is set to 64KiB.
 
 	The minimum value is 16KiB and there is no hard limit for max value, but
 	only allowed 512KiB for SMC-R and 1MiB for SMC-D.
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 285f9bd8e232..67c3937f341d 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -206,8 +206,10 @@ struct smc_rtoken {				/* address/key of remote RMB */
 	u32			rkey;
 };
 
-#define SMC_BUF_MIN_SIZE	16384	/* minimum size of an RMB */
-#define SMC_RMBE_SIZES		16	/* number of distinct RMBE sizes */
+#define SMC_SNDBUF_INIT_SIZE 16384 /* initial size of send buffer */
+#define SMC_RCVBUF_INIT_SIZE 65536 /* initial size of receive buffer */
+#define SMC_BUF_MIN_SIZE	 16384	/* minimum size of an RMB */
+#define SMC_RMBE_SIZES		 16	/* number of distinct RMBE sizes */
 /* theoretically, the RFC states that largest size would be 512K,
  * i.e. compressed 5 and thus 6 sizes (0..5), despite
  * struct smc_clc_msg_accept_confirm.rmbe_size being a 4 bit value (0..15)
diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
index b6f79fabb9d3..a63aa79d4856 100644
--- a/net/smc/smc_sysctl.c
+++ b/net/smc/smc_sysctl.c
@@ -19,8 +19,10 @@
 #include "smc_llc.h"
 #include "smc_sysctl.h"
 
-static int min_sndbuf = SMC_BUF_MIN_SIZE;
-static int min_rcvbuf = SMC_BUF_MIN_SIZE;
+static int initial_sndbuf	= SMC_SNDBUF_INIT_SIZE;
+static int initial_rcvbuf	= SMC_RCVBUF_INIT_SIZE;
+static int min_sndbuf		= SMC_BUF_MIN_SIZE;
+static int min_rcvbuf		= SMC_BUF_MIN_SIZE;
 
 static struct ctl_table smc_table[] = {
 	{
@@ -88,8 +90,8 @@ int __net_init smc_sysctl_net_init(struct net *net)
 	net->smc.sysctl_autocorking_size = SMC_AUTOCORKING_DEFAULT_SIZE;
 	net->smc.sysctl_smcr_buf_type = SMCR_PHYS_CONT_BUFS;
 	net->smc.sysctl_smcr_testlink_time = SMC_LLC_TESTLINK_DEFAULT_TIME;
-	WRITE_ONCE(net->smc.sysctl_wmem, READ_ONCE(net->ipv4.sysctl_tcp_wmem[1]));
-	WRITE_ONCE(net->smc.sysctl_rmem, READ_ONCE(net->ipv4.sysctl_tcp_rmem[1]));
+	WRITE_ONCE(net->smc.sysctl_wmem, initial_sndbuf);
+	WRITE_ONCE(net->smc.sysctl_rmem, initial_rcvbuf);
 
 	return 0;
 
-- 
2.34.1

