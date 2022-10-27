Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80EC60F727
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 14:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbiJ0M0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 08:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235589AbiJ0M0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 08:26:42 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C389E13C1D2
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:26:41 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id o13so846315ilc.7
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lniLLq0wWXt/bwGWmVmVl0IrNVPhksr2CD/LLDMRS+A=;
        b=iT1BRxpiJ1FEPFYwmqxHLZwKGyvfuqDSSjPdNyeSC8hI3C5hVMsF6/UOjXFUyYS9nq
         XVwlez9HeD1TD792m2ZwoXP22fBXJbo7scUTO+g5diRZNPog3/CpkeLQBkKYxBpndyW/
         DL/zpb9ZpRHOgKgspyfFhQzeyrudcvHvLY0hArRYzIvsiMOb7xTdDzzBce4TsvknUHTo
         a6cT7gI+rsDazezSiL/tRGHZCyN1OCR11LCZnk81tUWhTl0gJRdAkdsW2z7QrNhgOFck
         /90Im8QD7CwhSDeNlYksE88k+wsCyXbka0PMvRJ+ciSeRWDnfuCQWZj/smEjLoVvjGRr
         LRNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lniLLq0wWXt/bwGWmVmVl0IrNVPhksr2CD/LLDMRS+A=;
        b=mruqVJvlqh7ZAnnMcV0Rb8hy5Nr4CpGuugVvaf345/6g3xZ1wgh83k3T4+o1ckwt/5
         +SELdbYRDScdE9yrU21kYJMlflof7I7FVxo+Ik7kflDYdmu4F4iAU5DzLOloF93eS0GW
         5i1HjuPU6m9A6oHy4nPJsBCTC2kLktDdFx+f9Fkz+b6/iEBKSi4pSz+DftOJmxcpfkEC
         w92G9EN6lVnxo9goCTpHj4sEfWL5sA/5TpBFhwMC9p22jzd4viWO4LmCRDZTuzdnZnfR
         B8BDol5ahrFYU6ZIxID9S94LPRGtyLW+OvPAfIoBiOFR3tqsAG6eH+jhYlXvgzDxg8aY
         FtUA==
X-Gm-Message-State: ACrzQf0EMQHylDE6f/vB+eySdQ+SPBzZO6XWJA7NMIarF6gDokKboBHg
        I3ZiRTg3D9wdb5s2zz7+rj50wA==
X-Google-Smtp-Source: AMsMyM5p5OoGa5JWm9afYrjlUvN/zVxlsYvYweWofRMNvAoRuj9t9V8CIEvHDh1wuGMYIkg7eyzjMQ==
X-Received: by 2002:a92:d0a:0:b0:300:3d26:b1fa with SMTP id 10-20020a920d0a000000b003003d26b1famr9158422iln.272.1666873601045;
        Thu, 27 Oct 2022 05:26:41 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id w24-20020a05663800d800b003566ff0eb13sm526528jao.34.2022.10.27.05.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 05:26:40 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/7] net: ipa: no more global filtering starting with IPA v5.0
Date:   Thu, 27 Oct 2022 07:26:28 -0500
Message-Id: <20221027122632.488694-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221027122632.488694-1-elder@linaro.org>
References: <20221027122632.488694-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA v5.0 eliminates the global filter table entry.  As a result,
there is no need to shift the filtered endpoint bitmap when it is
written to IPA local memory.

Update comments to explain this.  Also delete a redundant block of
comments above the function.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_table.c | 59 ++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index db1992eaafaa9..cf3a3de239dc3 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -32,8 +32,8 @@
  * endian 64-bit "slot" that holds the address of a rule definition.  (The
  * size of these slots is 64 bits regardless of the host DMA address size.)
  *
- * Separate tables (both filter and route) used for IPv4 and IPv6.  There
- * are normally another set of "hashed" filter and route tables, which are
+ * Separate tables (both filter and route) are used for IPv4 and IPv6.  There
+ * is normally another set of "hashed" filter and route tables, which are
  * used with a hash of message metadata.  Hashed operation is not supported
  * by all IPA hardware (IPA v4.2 doesn't support hashed tables).
  *
@@ -51,19 +51,32 @@
  * Each filter rule is associated with an AP or modem TX endpoint, though
  * not all TX endpoints support filtering.  The first 64-bit slot in a
  * filter table is a bitmap indicating which endpoints have entries in
- * the table.  The low-order bit (bit 0) in this bitmap represents a
- * special global filter, which applies to all traffic.  This is not
- * used in the current code.  Bit 1, if set, indicates that there is an
- * entry (i.e. slot containing a system address referring to a rule) for
- * endpoint 0 in the table.  Bit 3, if set, indicates there is an entry
- * for endpoint 2, and so on.  Space is set aside in IPA local memory to
- * hold as many filter table entries as might be required, but typically
- * they are not all used.
+ * the table.  Each set bit in this bitmap indicates the presence of the
+ * address of a filter rule in the memory following the bitmap.  Until IPA
+ * v5.0,  the low-order bit (bit 0) in this bitmap represents a special
+ * global filter, which applies to all traffic.  Otherwise the position of
+ * each set bit represents an endpoint for which a filter rule is defined.
+ *
+ * The global rule is not used in current code, and support for it is
+ * removed starting at IPA v5.0.  For IPA v5.0+, the endpoint bitmap
+ * position defines the endpoint ID--i.e. if bit 1 is set in the endpoint
+ * bitmap, endpoint 1 has a filter rule.  Older versions of IPA represent
+ * the presence of a filter rule for endpoint X by bit (X + 1) being set.
+ * I.e., bit 1 set indicates the presence of a filter rule for endpoint 0,
+ * and bit 3 set means there is a filter rule present for endpoint 2.
+ *
+ * Each filter table entry has the address of a set of equations that
+ * implement a filter rule.  So following the endpoint bitmap there
+ * will be such an address/entry for each endpoint with a set bit in
+ * the bitmap.
  *
  * The AP initializes all entries in a filter table to refer to a "zero"
- * entry.  Once initialized the modem and AP update the entries for
- * endpoints they "own" directly.  Currently the AP does not use the
- * IPA filtering functionality.
+ * rule.  Once initialized, the modem and AP update the entries for
+ * endpoints they "own" directly.  Currently the AP does not use the IPA
+ * filtering functionality.
+ *
+ * This diagram shows an example of a filter table with an endpoint
+ * bitmap as defined prior to IPA v5.0.
  *
  *                    IPA Filter Table
  *                 ----------------------
@@ -658,12 +671,6 @@ bool ipa_table_mem_valid(struct ipa *ipa, bool filter)
  * when a route table is initialized or reset, its entries are made to refer
  * to the zero rule.  The zero rule is shared for route and filter tables.
  *
- * Note that the IPA hardware requires a filter or route rule address to be
- * aligned on a 128 byte boundary.  The coherent DMA buffer we allocate here
- * has a minimum alignment, and we place the zero rule at the base of that
- * allocated space.  In ipa_table_init() we verify the minimum DMA allocation
- * meets our requirement.
- *
  *	     +-------------------+
  *	 --> |     zero rule     |
  *	/    |-------------------|
@@ -708,12 +715,16 @@ int ipa_table_init(struct ipa *ipa)
 	/* First slot is the zero rule */
 	*virt++ = 0;
 
-	/* Next is the filter table bitmap.  The "soft" bitmap value
-	 * must be converted to the hardware representation by shifting
-	 * it left one position.  (Bit 0 repesents global filtering,
-	 * which is possible but not used.)
+	/* Next is the filter table bitmap.  The "soft" bitmap value might
+	 * need to be converted to the hardware representation by shifting
+	 * it left one position.  Prior to IPA v5.0, bit 0 repesents global
+	 * filtering, which is possible but not used.  IPA v5.0+ eliminated
+	 * that option, so there's no shifting required.
 	 */
-	*virt++ = cpu_to_le64((u64)ipa->filter_map << 1);
+	if (ipa->version < IPA_VERSION_5_0)
+		*virt++ = cpu_to_le64((u64)ipa->filter_map << 1);
+	else
+		*virt++ = cpu_to_le64((u64)ipa->filter_map);
 
 	/* All the rest contain the DMA address of the zero rule */
 	le_addr = cpu_to_le64(addr);
-- 
2.34.1

