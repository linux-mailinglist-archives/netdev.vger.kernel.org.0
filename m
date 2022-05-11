Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C273F522DEB
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 10:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243398AbiEKILG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 04:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243347AbiEKIKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 04:10:53 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6EDBE36
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 01:10:48 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220511081044epoutp04dae9d2519372d525e4deb94e224b3b51~t-qoBGweH2118221182epoutp04m
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 08:10:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220511081044epoutp04dae9d2519372d525e4deb94e224b3b51~t-qoBGweH2118221182epoutp04m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652256644;
        bh=hYuYJE8BwycrFmnXxWX4i3trO1jS9jYV/ZuxbJi1tKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNqJVx0bFor6YxZSH+CH5q+KunN2n6yqFFwr+hL5akzubYpefwfz2kRoCqraGT6ru
         7n7NAYbVmZjT8Fr3nqpF9hh+BJhMh/oTXB0k9gs3Sgad0u3DgA9EhV3glQcV15zPVw
         s/e2Qdgqu2Cco7gOWb7vYXziaEZ9lxfoRjNglGF4=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220511081043epcas5p10f5e3b2a3f8855ff9749d9e7de865b90~t-qnWbudH1267712677epcas5p1L;
        Wed, 11 May 2022 08:10:43 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        73.47.09827.38F6B726; Wed, 11 May 2022 17:10:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220511080728epcas5p2e377c38aba2e93dccc7fe8958e4724c2~t-nx_sb8M2058020580epcas5p2f;
        Wed, 11 May 2022 08:07:28 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220511080728epsmtrp131b4e7949cc848bea730c9146e648d1a~t-nx9cZEl1662516625epsmtrp1d;
        Wed, 11 May 2022 08:07:28 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff70000002663-b1-627b6f83abf8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4A.23.08924.0CE6B726; Wed, 11 May 2022 17:07:28 +0900 (KST)
Received: from localhost.localdomain (unknown [107.109.224.44]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220511080724epsmtip1865254a99dca147d491a5b07d63ed55b~t-ntr2NO31048910489epsmtip1v;
        Wed, 11 May 2022 08:07:24 +0000 (GMT)
From:   Maninder Singh <maninder1.s@samsung.com>
To:     mcgrof@kernel.org, avimalin@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        senozhatsky@chromium.org, andriy.shevchenko@linux.intel.com,
        naveen.n.rao@linux.ibm.com, davem@davemloft.net,
        mhiramat@kernel.org, anil.s.keshavamurthy@intel.com,
        linux@rasmusvillemoes.dk, akpm@linux-foundation.org,
        keescook@chromium.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        v.narang@samsung.com, Maninder Singh <maninder1.s@samsung.com>,
        Onkarnath <onkarnath.1@samsung.com>
Subject: [PATCH 2/2] kallsyms: move sprint_module_info to kallsyms_tiny.c
Date:   Wed, 11 May 2022 13:36:57 +0530
Message-Id: <20220511080657.3996053-2-maninder1.s@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511080657.3996053-1-maninder1.s@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTVxjHc+69vfe2S9nlJXoGSJWBBrPBxtScxAamIeRKWBQ+LHHMzAJ3
        wCgvaxXdXAZCx6QMKQhaS8d4cRsWBGzKhALFFSyjOhVhk4654AAtJlsodJjKxka5kPnt/zzP
        7/+8nBwa92skA+ms3GOcIlcmDyVFxHeDETteLck7lfra6Rs7kL6jjURPl+twVFF8AUO9zkkC
        uT2TFJr6/j6FmhuXcKS/oyJQcXcLhpzzMwDdKs9Bjy0VGBoz60k0rasn0eBXpQSa0MwC1Pzt
        dtRa8w+FbA2bUMsX8wL07/RfAmQ5M7Xa+2oTiTyDt3BkHfkSIOclLXgzkK0rGiVY02UHxlaV
        /EmxPboHFKuy/EKxzX1zGKueuIezRkMZyf6gXSZYTdN1wNaPJLF31dnsWZMBsB2mnwh20Rhy
        6MV3RNJ0Tp5VwCmiYo6KMlfGtIL89m0n2xYkReCzIDUQ0pDZBRc8vwM1ENF+TC+A+qY5kg8W
        ALyut2N8sAjgr45KsGGx3RxeL5gB1E4N43zgBnDAdhn3UiQTCQ3mPsJbCGBmcVj2qHbNgjON
        ADpdk6SX8mcOwDNDbsyrCSYcmhrsa24xEwMf9rcK+HkSePHeU0oNaFrIxMLinjAe8YUjF2cI
        r8ZXkZKuurUtIHNNCNW9TYSXh0wcvDaxm2/jD58MmyheB8K5ylKKR07ALk0hb1WtHqCvIXkm
        Fs6MNgq8DM5EwA5zFJ/eAmvt7Rg/1gdWLM9gfF4Mu+s3dDhUOTrXtw+Ciy4XwWsWTgytrL9v
        NYBFniVSA7bqnjtH99w5uv9HNwDcAF7i8pU5GZxyd350LnciUinLUR7PzYhMy8sxgrVfvDOh
        Gzycmo+0AowGVgBpPDRAPHD2ZKqfOF320cecIu89xXE5p7SCIJoI3Sy+mdEp82MyZMe4bI7L
        5xQbVYwWBhZh1fhh6UrrHuE5+aFL/b397iPmkD9KAz7vOqiLHhrfU3j43H3b6YJ0ufGRPcXc
        njRfv7+wWKsPTogh91EjT0qmJVcPnCL7fAqI5htRiQ80aZ/4Jpe1vJwWH/H3tENyZZx9/8eE
        OylVvyGP/xuGOltIQ0ftbOZYfFrCFpF0IO7DKkuXy0ISvi+kv+UjJfa6RpJud94V2eVXpOKJ
        sKPUz88cKUfcnvOj0ozqRHVlmzW2XFgrOV85YBwqDe3Z69zus18VJv1g3/K2gqJvTJv0AT6P
        g3e5klVtdPLmqjDt19Hjr3TnWd8lxuw1cYG3k/rcMeWO+GB34qfPlt7eGp6dfjA1SxlKKDNl
        r+/EFUrZf8C92200BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWy7bCSnO6BvOokg0frTCzmrF/DZvH992xm
        i96m6UwWu1/cZrH48vM2u8WDg9fZLRYv/MZsMed8C4tF044VTBYvPjxhtDjTnWvxfF8vk8Xl
        XXPYLB7PmsdmcXh+G4vFjQlPGS0WL1ezWD3lL7vFsQViFit6PrBa/H/8ldViX8cDoNkbF7FZ
        /Dx8htni0Mm5jBYvlsxgdJDymN1wkcVjy8qbTB4Tm9+xe+ycdZfdo2XfLXaPxXteMnl03bjE
        7LFpVSebx4kZv1k8Jiw6wOgx72Sgx4WubI++LasYPdZvucri8XmTXAB/FJdNSmpOZllqkb5d
        AlfGv8szWAvWKVas+STfwNgq3cXIySEhYCJx7PRxpi5GLg4hgR2MEif+HGGDSEhL/Pz3ngXC
        FpZY+e85O0TRJ0aJVz/ngSXYBPQkVu3awwKSEBH4zyzxaUov2ChmgaWMEjevzAQbJSzgKdFx
        5AsTiM0ioCqxZcEpZhCbV8BO4uHe1awQK+QlZl76DrSCg4NTwF6iaacKSFgIqKT7exs7RLmg
        xMmZT8AWMwOVN2+dzTyBUWAWktQsJKkFjEyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNz
        NzGC411LawfjnlUf9A4xMnEwHmKU4GBWEuHd31eRJMSbklhZlVqUH19UmpNafIhRmoNFSZz3
        QtfJeCGB9MSS1OzU1ILUIpgsEwenVAOTxy7/vgO/y0M1k94KJ7unrN911J7TSN9DfdeV5Zc4
        Jk8PnHlnyqPP6v4X/f8cWv3u3d7Y/Fi2m4tlMjft78y6wJ7/hfHb2h1T3yyYLHRd1lx1xcn/
        KyU0uiKmP7G0ecm8wOdif/Zmm+9nfohOUfqpnCNsvmGL5c+w7Uti9yyyqbRYJtZUPOHjqmPH
        l65e47d5WYzJ1tXeV4y3m3mxGd5O+iauYdSwvjuEQSX2295bnxqbI6865R4uNbi7w1LPLL/7
        n0DWRg9Ggal7ZvWxBD66++pPsdKPFx35uhrtb5PLYrddSqr85f7qWqXGWpXNPj/fsgaJODNE
        zjOYMFEq3WDT5Xs28WliIXfXzlq3kLkrTomlOCPRUIu5qDgRAMVlb3VmAwAA
X-CMS-MailID: 20220511080728epcas5p2e377c38aba2e93dccc7fe8958e4724c2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20220511080728epcas5p2e377c38aba2e93dccc7fe8958e4724c2
References: <20220511080657.3996053-1-maninder1.s@samsung.com>
        <CGME20220511080728epcas5p2e377c38aba2e93dccc7fe8958e4724c2@epcas5p2.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As previous patch makes new file for generic kallsyms
(always compilable), move sprint_module_info module to
new file kallsyms_tiny.c

no functional change with this commit

Co-developed-by: Onkarnath <onkarnath.1@samsung.com>
Signed-off-by: Onkarnath <onkarnath.1@samsung.com>
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
---
 include/linux/kallsyms.h | 11 +++++++++
 kernel/kallsyms_tiny.c   | 47 +++++++++++++++++++++++++++++++++++
 lib/vsprintf.c           | 53 ----------------------------------------
 3 files changed, 58 insertions(+), 53 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index c5e63a217404..95a2f4ade996 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -27,6 +27,17 @@ struct module;
 /* How and when do we show kallsyms values? */
 extern bool kallsyms_show_value(const struct cred *cred);
 
+#if !defined(CONFIG_KALLSYMS) && defined(CONFIG_MODULES)
+extern int sprint_module_info(char *buf, unsigned long value,
+				int modbuildid, int backtrace, int symbol);
+#else
+static inline int sprint_module_info(char *buf, unsigned long value,
+				int modbuildid, int backtrace, int symbol)
+{
+	return 0;
+}
+#endif
+
 static inline int is_kernel_text(unsigned long addr)
 {
 	if (__is_kernel_text(addr))
diff --git a/kernel/kallsyms_tiny.c b/kernel/kallsyms_tiny.c
index 96ad06836126..8ed9fdd7d9f7 100644
--- a/kernel/kallsyms_tiny.c
+++ b/kernel/kallsyms_tiny.c
@@ -49,3 +49,50 @@ bool kallsyms_show_value(const struct cred *cred)
 		return false;
 	}
 }
+
+#if !defined(CONFIG_KALLSYMS) && defined(CONFIG_MODULES)
+int sprint_module_info(char *buf, unsigned long value,
+			     int modbuildid, int backtrace, int symbol)
+{
+	struct module *mod;
+	unsigned long offset;
+	void *base;
+	char *modname;
+	int len;
+	const unsigned char *buildid = NULL;
+	bool add_offset;
+
+	if (is_ksym_addr(value))
+		return 0;
+
+	if (backtrace || symbol)
+		add_offset = true;
+	else
+		add_offset = false;
+
+	preempt_disable();
+	mod = __module_address(value);
+	if (mod) {
+		modname = mod->name;
+#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
+		if (modbuildid)
+			buildid = mod->build_id;
+#endif
+		if (add_offset) {
+			base = mod->core_layout.base;
+			offset = value - (unsigned long)base;
+		}
+	}
+	preempt_enable();
+	if (!mod)
+		return 0;
+
+	/* address belongs to module */
+	if (add_offset)
+		len = sprintf(buf, "0x%p+0x%lx", base, offset);
+	else
+		len = sprintf(buf, "0x%lx", value);
+
+	return len + fill_name_build_id(buf, modname, modbuildid, buildid, len);
+}
+#endif
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 799fccca4a2d..983fdb02543c 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -999,59 +999,6 @@ char *bdev_name(char *buf, char *end, struct block_device *bdev,
 }
 #endif
 
-#if !defined(CONFIG_KALLSYMS) && defined(CONFIG_MODULES)
-static int sprint_module_info(char *buf, unsigned long value,
-			     int modbuildid, int backtrace, int symbol)
-{
-	struct module *mod;
-	unsigned long offset;
-	void *base;
-	char *modname;
-	int len;
-	const unsigned char *buildid = NULL;
-	bool add_offset;
-
-	if (is_ksym_addr(value))
-		return 0;
-
-	if (backtrace || symbol)
-		add_offset = true;
-	else
-		add_offset = false;
-
-	preempt_disable();
-	mod = __module_address(value);
-	if (mod) {
-		modname = mod->name;
-#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
-		if (modbuildid)
-			buildid = mod->build_id;
-#endif
-		if (add_offset) {
-			base = mod->core_layout.base;
-			offset = value - (unsigned long)base;
-		}
-	}
-	preempt_enable();
-	if (!mod)
-		return 0;
-
-	/* address belongs to module */
-	if (add_offset)
-		len = sprintf(buf, "0x%p+0x%lx", base, offset);
-	else
-		len = sprintf(buf, "0x%lx", value);
-
-	return len + fill_name_build_id(buf, modname, modbuildid, buildid, len);
-}
-#else
-static inline int sprint_module_info(char *buf, unsigned long value,
-			     int modbuildid, int backtrace, int symbol)
-{
-	return 0;
-}
-#endif
-
 static noinline_for_stack
 char *symbol_string(char *buf, char *end, void *ptr,
 		    struct printf_spec spec, const char *fmt)
-- 
2.17.1

