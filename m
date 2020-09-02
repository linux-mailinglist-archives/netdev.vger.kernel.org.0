Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA1D25A7ED
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 10:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgIBInI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 04:43:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53890 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726140AbgIBInH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 04:43:07 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0828Xag0030773;
        Wed, 2 Sep 2020 04:42:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=6N8E/Fm3fViq5AOeD/pRzzN/BIBlXvWCEntWGmDFN1A=;
 b=JEtESbOdYTVZUAbur4I07PFJvlgYmglSyQWG+HxWxpBr/rdeBw8ybxRIBpupAmmttBsO
 zBCWs6pmU9H9LCMjlGnxfqM+wMtnnVxfEdYu0C/Qpvn2S6i3Al/fNvBJ9I7mYF8YGRMq
 tYb60laRbXakglcPTdoqhvOB7sEKEM1Cxjo0cxmFCzYXdjUbSnZWZh3j+PQJoWkUK5JW
 yQnLP7wLgYBJJoH2pg4+Kh7yd4Ez4kJQZbHv4Y8c4MbEQFzWNJ9F+Z1xfaT8ftb3eN2z
 16DplC41XUBQ5Jz1VAd/6sJK77RAY4GPjII4fr4OAiYq7RecbGGvkMuUkfBvD+04tzHX ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33a6cwjqq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 04:42:56 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0828YRm6032482;
        Wed, 2 Sep 2020 04:42:55 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33a6cwjqph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 04:42:55 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0828gEG3003237;
        Wed, 2 Sep 2020 08:42:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 337en7jrfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 08:42:53 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0828gpYP11993498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Sep 2020 08:42:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DCCDAE045;
        Wed,  2 Sep 2020 08:42:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A10BAE04D;
        Wed,  2 Sep 2020 08:42:49 +0000 (GMT)
Received: from naverao1-tp.ibmuc.com (unknown [9.102.21.218])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  2 Sep 2020 08:42:48 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Vaidyanathan Srinivasan <svaidy@linux.ibm.com>
Subject: [PATCH] libbpf: Remove arch-specific include path in Makefile
Date:   Wed,  2 Sep 2020 14:12:46 +0530
Message-Id: <20200902084246.1513055-1-naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_03:2020-09-02,2020-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 clxscore=1011 phishscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020074
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ubuntu mainline builds for ppc64le are failing with the below error (*):
    CALL    /home/kernel/COD/linux/scripts/atomic/check-atomics.sh
    DESCEND  bpf/resolve_btfids

  Auto-detecting system features:
  ...                        libelf: [ [32mon[m  ]
  ...                          zlib: [ [32mon[m  ]
  ...                           bpf: [ [31mOFF[m ]

  BPF API too old
  make[6]: *** [Makefile:295: bpfdep] Error 1
  make[5]: *** [Makefile:54: /home/kernel/COD/linux/debian/build/build-generic/tools/bpf/resolve_btfids//libbpf.a] Error 2
  make[4]: *** [Makefile:71: bpf/resolve_btfids] Error 2
  make[3]: *** [/home/kernel/COD/linux/Makefile:1890: tools/bpf/resolve_btfids] Error 2
  make[2]: *** [/home/kernel/COD/linux/Makefile:335: __build_one_by_one] Error 2
  make[2]: Leaving directory '/home/kernel/COD/linux/debian/build/build-generic'
  make[1]: *** [Makefile:185: __sub-make] Error 2
  make[1]: Leaving directory '/home/kernel/COD/linux'

resolve_btfids needs to be build as a host binary and it needs libbpf.
However, libbpf Makefile hardcodes an include path utilizing $(ARCH).
This results in mixing of cross-architecture headers resulting in a
build failure.

The specific header include path doesn't seem necessary for a libbpf
build. Hence, remove the same.

(*) https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.9-rc3/ppc64el/log

Reported-by: Vaidyanathan Srinivasan <svaidy@linux.ibm.com>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
This is a simpler fix that seems to work and I saw the proper headers 
from within tools/ being included in both cross-architecture builds as 
well as a native ppc64le build. I am not sure if there is a better way 
to ask kbuild to build resolve_btfids/libbpf for the host architecture, 
and if that will set $(ARCH) appropriately.

- Naveen


 tools/lib/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index adbe994610f2..fccc4dcda4b6 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -62,7 +62,7 @@ FEATURE_USER = .libbpf
 FEATURE_TESTS = libelf zlib bpf
 FEATURE_DISPLAY = libelf zlib bpf
 
-INCLUDES = -I. -I$(srctree)/tools/include -I$(srctree)/tools/arch/$(ARCH)/include/uapi -I$(srctree)/tools/include/uapi
+INCLUDES = -I. -I$(srctree)/tools/include -I$(srctree)/tools/include/uapi
 FEATURE_CHECK_CFLAGS-bpf = $(INCLUDES)
 
 check_feat := 1

base-commit: 0697fecf7ecd8abf70d0f46e6a352818e984cc9f
-- 
2.25.4

