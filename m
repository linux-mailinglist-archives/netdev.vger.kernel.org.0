Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380A14B16F7
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 21:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241022AbiBJUbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 15:31:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238675AbiBJUbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 15:31:18 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED21B84;
        Thu, 10 Feb 2022 12:31:19 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21AJ2Pvi017445;
        Thu, 10 Feb 2022 20:30:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=iFid2oHawZ97i+mh3gez9SH2xyGLZefuUmNiHCuPX2w=;
 b=XknN75rYi2AgoCpnNSamH2K9QNxTlkdi9KRxli21N1/W8fRMQeJfzR49fafK62sOrQaj
 emLNVSTEJuWCSRFavxzlWjGRTXOoJPyApt0UsHY1FbjuCYXhWZWbDimCuydeABvuRy28
 Oz3yK7QpVLt5FmeYWvTq5MZMwdzZt1oZRTHQJj8li4tvytHrFalOIzHYXAqKn4JVzDP1
 FVYNDbHfDuTNQx0osZAFC2Gna3sNeVwgqcSty11rwZdxQ/QI0OOwDGYJdS188tTBac2c
 2Y1H/ucE98SN2J+Z+RSa5Bql9cThk+6Vm6znXtAKFQw4R9Dn0/4SiYFY6t7GGyo7jRjO 1w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3h28s748-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 20:30:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21AKKDde180714;
        Thu, 10 Feb 2022 20:30:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3e51rtyjgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 20:30:52 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21AKUp6N023749;
        Thu, 10 Feb 2022 20:30:51 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by aserp3030.oracle.com with ESMTP id 3e51rtyjfm-1;
        Thu, 10 Feb 2022 20:30:51 +0000
From:   Sherry Yang <sherry.yang@oracle.com>
To:     skhan@linuxfoundation.org, shuah@kernel.org, keescook@chromium.org,
        luto@amacapital.net, wad@chromium.org, christian@brauner.io,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, sherry.yang@oracle.com
Subject: [PATCH v2] selftests/seccomp: Fix seccomp failure by adding missing headers
Date:   Thu, 10 Feb 2022 12:30:49 -0800
Message-Id: <20220210203049.67249-1-sherry.yang@oracle.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: rTAVfO73xdUzFbd4s-2N81lXGDYe60LF
X-Proofpoint-GUID: rTAVfO73xdUzFbd4s-2N81lXGDYe60LF
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

seccomp_bpf failed on tests 47 global.user_notification_filter_empty
and 48 global.user_notification_filter_empty_threaded when it's
tested on updated kernel but with old kernel headers. Because old
kernel headers don't have definition of macro __NR_clone3 which is
required for these two tests. Since under selftests/, we can install
headers once for all tests (the default INSTALL_HDR_PATH is
usr/include), fix it by adding usr/include to the list of directories
to be searched. Use "-isystem" to indicate it's a system directory as
the real kernel headers directories are.

Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Tested-by: Sherry Yang <sherry.yang@oracle.com>
---
 tools/testing/selftests/seccomp/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/seccomp/Makefile b/tools/testing/selftests/seccomp/Makefile
index 0ebfe8b0e147..585f7a0c10cb 100644
--- a/tools/testing/selftests/seccomp/Makefile
+++ b/tools/testing/selftests/seccomp/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -Wl,-no-as-needed -Wall
+CFLAGS += -Wl,-no-as-needed -Wall -isystem ../../../../usr/include/
 LDFLAGS += -lpthread
 
 TEST_GEN_PROGS := seccomp_bpf seccomp_benchmark
-- 
2.31.1

