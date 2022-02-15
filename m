Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89C74B7714
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243159AbiBOSmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 13:42:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243155AbiBOSmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 13:42:52 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6929327FEA;
        Tue, 15 Feb 2022 10:42:42 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FH4N62029572;
        Tue, 15 Feb 2022 18:42:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=zXmbrA+nSO5dCXMa3+3nbbOi7Ym51eV5ADJO++TfFv0=;
 b=oqxhdoF2rIqYW/BJuSS/ErAWNzD765UjQwIZsoI1GRVfs8Q4rXVcbrU0FnnU2cLvawLF
 AYQae2Cd1+DskOtQ8w0jBO1dosO2XnVLEnsQC0jWQs51B0aIWTzltga+MqrU8TT6TYuE
 6wZRUb+QiL0SiOtIHwASsKyJLCAD5FQ09A07Gzue+CMRKkVOs3wDPkZEg1hjEkmZf/0C
 Y4R6t4FzGXAUV4f/3cdB3op7Dw+UoIkXqGgD7iu/thJxqgEhn1U8mAAj1qbkrBKeemu+
 cBSwqrCWSrO7kIUkT7hFcBjN4Pf+m4/bIXwZOO2udmhOmdEx6mAWMMzdpbLPqSunLQcQ bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8570taav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 18:42:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21FIfEKi150005;
        Tue, 15 Feb 2022 18:42:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3e620xg50s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 18:42:17 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21FIgHrN152289;
        Tue, 15 Feb 2022 18:42:17 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by userp3030.oracle.com with ESMTP id 3e620xg50h-1;
        Tue, 15 Feb 2022 18:42:17 +0000
From:   Sherry Yang <sherry.yang@oracle.com>
To:     skhan@linuxfoundation.org, shuah@kernel.org, keescook@chromium.org,
        luto@amacapital.net, wad@chromium.org, christian@brauner.io,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        usama.anjum@collabora.com, sherry.yang@oracle.com
Subject: [PATCH v3] selftests/seccomp: Fix seccomp failure by adding missing headers
Date:   Tue, 15 Feb 2022 10:42:15 -0800
Message-Id: <20220215184215.40093-1-sherry.yang@oracle.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: NohrFFT0X_beyLbk1JWdxuHwTzUHtHwb
X-Proofpoint-GUID: NohrFFT0X_beyLbk1JWdxuHwTzUHtHwb
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
required for these two tests. Use KHDR_INCLUDES to correctly reach
the installed headers.

Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Tested-by: Sherry Yang <sherry.yang@oracle.com>
---
 tools/testing/selftests/seccomp/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/seccomp/Makefile b/tools/testing/selftests/seccomp/Makefile
index 0ebfe8b0e147..7eaed95ba4b3 100644
--- a/tools/testing/selftests/seccomp/Makefile
+++ b/tools/testing/selftests/seccomp/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -Wl,-no-as-needed -Wall
+CFLAGS += -Wl,-no-as-needed -Wall $(KHDR_INCLUDES)
 LDFLAGS += -lpthread
 
 TEST_GEN_PROGS := seccomp_bpf seccomp_benchmark
-- 
2.31.1

