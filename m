Return-Path: <netdev+bounces-12141-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F228736653
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:35:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDC912810F9
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27933BE79;
	Tue, 20 Jun 2023 08:35:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3A4BE62
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:35:01 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC1F10CF;
	Tue, 20 Jun 2023 01:34:59 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35K8L6JF003242;
	Tue, 20 Jun 2023 08:34:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=afeIJn1UTcgIZ0bm1P798AU5j9tO3GQcQ5Fn/fEgZvQ=;
 b=SVVCkf992cy/xF/PVw7O4z4BGX/ad7/ELwJfMmRcMu8aWWDebZBFEG67ps/Xu96DVUPg
 l/teRhOt4bwuSm4tbRGrXo1EabwMeQQd2AYHdbhVdKZLpX/QEQ/6yhIzcw/pQTs2H6id
 o+5q+xSEmO8t1Z96/I9B7/5w6HEKaEZSpCB6F/hecNlB5gNeZgOpjV8iATQbMSQV5fsn
 tENMosNUM0KHMZ9Uy1bUvN1piQVoOMqsSw/etckgeCYp95xMwYn7H3krK3rNrmq2Q5FV
 c75wnGqUFNooi+VsUDOiIiQRzd/hE3otIa8+L++Hzb5FV8YJqJABpugMdMDjassXZ7oC RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rb8hbrdjg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Jun 2023 08:34:51 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35K8L8rN003320;
	Tue, 20 Jun 2023 08:34:50 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rb8hbrdfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Jun 2023 08:34:50 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
	by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35K4aCOS027815;
	Tue, 20 Jun 2023 08:34:47 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3r943e1fdq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Jun 2023 08:34:47 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35K8Yi0h45154586
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jun 2023 08:34:44 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 04F5320043;
	Tue, 20 Jun 2023 08:34:44 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E40CF20040;
	Tue, 20 Jun 2023 08:34:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 20 Jun 2023 08:34:43 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
	id 9056AE0652; Tue, 20 Jun 2023 10:34:43 +0200 (CEST)
From: Alexandra Winter <wintera@linux.ibm.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Jules Irenge <jbi.octave@gmail.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 2/4] s390/lcs: Convert sprintf to scnprintf
Date: Tue, 20 Jun 2023 10:34:09 +0200
Message-Id: <20230620083411.508797-3-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230620083411.508797-1-wintera@linux.ibm.com>
References: <20230620083411.508797-1-wintera@linux.ibm.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kYQTvhnGC5QkpK2iRXRDyfE1C11dbsAF
X-Proofpoint-ORIG-GUID: TdWjrPQXtSCPL7aNU2iZB559NVglQqZ_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-20_05,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 phishscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 impostorscore=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306200076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Thorsten Winkler <twinkler@linux.ibm.com>

This LWN article explains the rationale for this change
https: //lwn.net/Articles/69419/
Ie. snprintf() returns what *would* be the resulting length,
while scnprintf() returns the actual length.

Reported-by: Jules Irenge <jbi.octave@gmail.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Thorsten Winkler <twinkler@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/lcs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/lcs.h b/drivers/s390/net/lcs.h
index bd52caa3b11b..a2699b70b050 100644
--- a/drivers/s390/net/lcs.h
+++ b/drivers/s390/net/lcs.h
@@ -21,7 +21,7 @@ do { \
 #define LCS_DBF_TEXT_(level,name,text...) \
 	do { \
 		if (debug_level_enabled(lcs_dbf_##name, level)) { \
-			sprintf(debug_buffer, text); \
+			scnprintf(debug_buffer, sizeof(debug_buffer), text); \
 			debug_text_event(lcs_dbf_##name, level, debug_buffer); \
 		} \
 	} while (0)
-- 
2.39.2


