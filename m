Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280BA5EB440
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbiIZWLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiIZWKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:10:06 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8EF11A25
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:54 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id v128so6387983ioe.12
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=TADOfYOTBoJgrt/wKumKA3PSBigW3LJ4F95Qu3IuQK8=;
        b=Dd6SNbJ1lUuoi4FzHnZcXWqBxv2dihkI/SfVDCr040HczOWYTmuTmzqEeD20y5zz/F
         yc5SEh/VAS8y3wgvhShRmu8FT4W3AjwjFzZlYmOiWRu4ZBfkNdEPRDOLbxoCXYPKCD2Z
         2Y22aD/I/73rSuGfXjcRnUN1c7STpTrPuDcJWWzvNNpjAcyuSxqXAbYtzPbtqmY/R3xZ
         2LsPm+0QBP1eMe8F+zU+J3Iu2C3ntJUpc49agqc2tvrKmdjrJkq5/IxzutCr9/g7Y0qE
         zibHHm80/z3joe+iZK9RfBtwbjxmBhX3dfKteEHM3tHdPmBV91Aez0Nc39PrbwVuSkud
         Wvjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=TADOfYOTBoJgrt/wKumKA3PSBigW3LJ4F95Qu3IuQK8=;
        b=e0UOj4ZtrX9FiDDQsgoudmo10eBvORSZM7loz1MaNhZPDBF3Iyx/Jj49me8/pDRnyq
         K08pxnG1XxLwgvk7h2CM7zVbPUBIm7RENO9H1Bu+bGm5GX0j9ZQ1g7PFcg46ThgMyrJP
         ON442DlSKN+3H/AGXfVpNTWiPDTcmpNBPtan/tTFfGUF0n0Mhpwvw8ED2B+JBXpIABp1
         A0UOwfwreoCe8qSM3kqYtMm0tDtvdP0DJTTQFDqyaE7Oi23rGt90NERjmcvxmOWQKBLl
         rxqN8yWWuau5pVFaP/8wgZH9v6JCw5JtbYPj4pk5+dQbCubtfh/H5EZ/5uU7K7o+CE0F
         YZzg==
X-Gm-Message-State: ACrzQf29uFSHNOZN6TfGQu/0nq/0INF1sefTzwxNxQjLr+2tw/I3QIex
        Uzshn+Rv/gBUHPwNWpqaAaVvkg==
X-Google-Smtp-Source: AMsMyM7YBdWUpQyM4/vtBJfmJeC2hmK6WSqsMr56AOugpav8Xupmsgp1L1oqpmYm5unKs+rUrBjikw==
X-Received: by 2002:a05:6638:4304:b0:343:5953:5fc8 with SMTP id bt4-20020a056638430400b0034359535fc8mr12860640jab.123.1664230193988;
        Mon, 26 Sep 2022 15:09:53 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b003567503cf92sm7631600jad.82.2022.09.26.15.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:09:52 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 06/15] net: ipa: introduce ipa_reg field masks
Date:   Mon, 26 Sep 2022 17:09:22 -0500
Message-Id: <20220926220931.3261749-7-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926220931.3261749-1-elder@linaro.org>
References: <20220926220931.3261749-1-elder@linaro.org>
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

Add register field descriptors to the ipa_reg structure.  A field in
a register is defined by a field mask, which is a 32-bit mask having
a single contiguous range of bits set.

For each register that has at least one field defined, an enumerated
type will identify the register's fields.  The ipa_reg structure for
that register will include an array fmask[] of field masks, indexed
by that enumerated type.  Each field mask defines the position and
bit width of a field.  An additional "fcount" records how many
fields (masks) are defined for a given register.

Introduce two macros to be used to define registers that have at
least one field.

Introduce a few new functions related to field masks.  The first
simply returns a field mask, given an IPA register pointer and field
mask ID.  A variant of that is meant to be used for the special case
of single-bit field masks.

Next, ipa_reg_encode(), identifies a field with an IPA register
pointer and a field ID, and takes a value to represent in that
field.  The result encodes the value in the appropriate place to be
stored in the register.  This is roughly modeled after the bitmask
operations (like u32_encode_bits()).

Another function (ipa_reg_decode()) similarly identifies a register
field, but the value supplied to it represents a full register
value.  The value encoded in the field is extracted from the value
and returned.  This is also roughly modeled after bitmask operations
(such as u32_get_bits()).

Finally, ipa_reg_field_max() returns the maximum value representable
by a field.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_reg.h | 68 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 49eec53a375ec..a616b0c3d59a6 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -125,11 +125,15 @@ enum ipa_reg_id {
  * struct ipa_reg - An IPA register descriptor
  * @offset:	Register offset relative to base of the "ipa-reg" memory
  * @stride:	Distance between two instances, if parameterized
+ * @fcount:	Number of entries in the @fmask array
+ * @fmask:	Array of mask values defining position and width of fields
  * @name:	Upper-case name of the IPA register
  */
 struct ipa_reg {
 	u32 offset;
 	u32 stride;
+	u32 fcount;
+	const u32 *fmask;			/* BIT(nr) or GENMASK(h, l) */
 	const char *name;
 };
 
@@ -145,6 +149,18 @@ struct ipa_reg {
 		.stride	= __stride,					\
 	}
 
+#define IPA_REG_FIELDS(__NAME, __name, __offset)			\
+	IPA_REG_STRIDE_FIELDS(__NAME, __name, __offset, 0)
+
+#define IPA_REG_STRIDE_FIELDS(__NAME, __name, __offset, __stride)	\
+	static const struct ipa_reg ipa_reg_ ## __name = {		\
+		.name   = #__NAME,					\
+		.offset = __offset,					\
+		.stride = __stride,					\
+		.fcount = ARRAY_SIZE(ipa_reg_ ## __name ## _fmask),	\
+		.fmask  = ipa_reg_ ## __name ## _fmask,			\
+	}
+
 /**
  * struct ipa_regs - Description of registers supported by hardware
  * @reg_count:	Number of registers in the @reg[] array
@@ -746,6 +762,58 @@ extern const struct ipa_regs ipa_regs_v4_5;
 extern const struct ipa_regs ipa_regs_v4_9;
 extern const struct ipa_regs ipa_regs_v4_11;
 
+/* Return the field mask for a field in a register */
+static inline u32 ipa_reg_fmask(const struct ipa_reg *reg, u32 field_id)
+{
+	if (!reg || WARN_ON(field_id >= reg->fcount))
+		return 0;
+
+	return reg->fmask[field_id];
+}
+
+/* Return the mask for a single-bit field in a register */
+static inline u32 ipa_reg_bit(const struct ipa_reg *reg, u32 field_id)
+{
+	u32 fmask = ipa_reg_fmask(reg, field_id);
+
+	WARN_ON(!is_power_of_2(fmask));
+
+	return fmask;
+}
+
+/* Encode a value into the given field of a register */
+static inline u32
+ipa_reg_encode(const struct ipa_reg *reg, u32 field_id, u32 val)
+{
+	u32 fmask = ipa_reg_fmask(reg, field_id);
+
+	if (!fmask)
+		return 0;
+
+	val <<= __ffs(fmask);
+	if (WARN_ON(val & ~fmask))
+		return 0;
+
+	return val;
+}
+
+/* Given a register value, decode (extract) the value in the given field */
+static inline u32
+ipa_reg_decode(const struct ipa_reg *reg, u32 field_id, u32 val)
+{
+	u32 fmask = ipa_reg_fmask(reg, field_id);
+
+	return fmask ? (val & fmask) >> __ffs(fmask) : 0;
+}
+
+/* Return the maximum value representable by the given field; always 2^n - 1 */
+static inline u32 ipa_reg_field_max(const struct ipa_reg *reg, u32 field_id)
+{
+	u32 fmask = ipa_reg_fmask(reg, field_id);
+
+	return fmask ? fmask >> __ffs(fmask) : 0;
+}
+
 const struct ipa_reg *ipa_reg(struct ipa *ipa, enum ipa_reg_id reg_id);
 
 /* Returns 0 for NULL reg; warning will have already been issued */
-- 
2.34.1

