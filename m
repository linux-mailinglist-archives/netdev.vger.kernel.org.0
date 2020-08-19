Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D659724A9B6
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgHSWwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:52:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4988 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727769AbgHSWwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:52:35 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JMXDYM067865;
        Wed, 19 Aug 2020 18:52:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ScQpDyMUdZ0X6OJsJz9rOObpjPIGfHpQllcS/CSgvCY=;
 b=mEHZo0hiHCUBHHs8YQFHdG8Nc3HNHIPxk5MCsYx54MyHI78Ze5OtJjtdzZsBUIdzRTVL
 A5dpxMEMaIDir3ciWBJBOsTIZrv1gDEN/E9N7MeY3PaWB4L319tKNZDkfgx0v0cz0vvT
 3q2e3jnayYMVqLxDExxXbl8VFbNLOz4IysLUvDTjdC96XaEYMaA3TkZDmWG7g5pL3JaI
 RkZ1gkK+JQ/jA+4XnZLo8yYZsLF1praKJocY3kle+mCamh9kwkTrW/qKi47th87iANRv
 /Ixo6xY9H7aqIqQdC5WrhWCyV6GxGg/EB2aETsIDnhDrcJhjbZ1LHhQO1FKsmSnRfdVP zA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 330ww9my5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 18:52:30 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07JMnUga026246;
        Wed, 19 Aug 2020 22:52:30 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 3304ccudwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 22:52:30 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07JMqPLD60359104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 22:52:26 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87DDEBE051;
        Wed, 19 Aug 2020 22:52:28 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02794BE04F;
        Wed, 19 Aug 2020 22:52:27 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.160.63.43])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 19 Aug 2020 22:52:27 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next v2 1/4] ibmvnic: compare adapter->init_done_rc with more readable ibmvnic_rc_codes
Date:   Wed, 19 Aug 2020 17:52:23 -0500
Message-Id: <20200819225226.10152-2-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20200819225226.10152-1-ljp@linux.ibm.com>
References: <20200819225226.10152-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 mlxscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008190178
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of comparing (adapter->init_done_rc == 1), let it
be (adapter->init_done_rc == PARTIALSUCCESS).

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5afb3c9c52d2..65f5d99f97dc 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -974,7 +974,7 @@ static int set_link_state(struct ibmvnic_adapter *adapter, u8 link_state)
 			return -1;
 		}
 
-		if (adapter->init_done_rc == 1) {
+		if (adapter->init_done_rc == PARTIALSUCCESS) {
 			/* Partuial success, delay and re-send */
 			mdelay(1000);
 			resend = true;
-- 
2.23.0

