Return-Path: <netdev+bounces-3293-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01A4F706623
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:07:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A5A62815F4
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C92B0171B3;
	Wed, 17 May 2023 11:04:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38CC168D8
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:04:22 +0000 (UTC)
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6AEF3
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:49 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id af79cd13be357-757942bd912so36746085a.2
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321414; x=1686913414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E2icZgj75N7YHEh5BHv7MRh1AjkwPp1BwTBEW4VCGug=;
        b=Lpc3Ytk2zlKdGyvgWHZ3DgZWG9VVvYJDf/BShs7hM1CiBzT5peIQ5Kq2+x4WRaLzS0
         +VipnsEaVYbz5+pYbpW6T3ZvvN8qy4Wir141ukyUTwlbCcqsEQD6nT3WAhWRRo9zuDdt
         FAVehl76qw5pMFajuasMH3mDCBFqAaHV1P+hTRRJowcAI4nhMCxZMc2nNwBVwHpBuZDF
         Yms4fg1OrE3tZ3QQ4HdiO6xYL4Voy7EERKQgUUqvD0qqoQoDB/1fPD2woalR8Z8fJU6x
         YTkQvsd6tcnUJMaTSi/fbnYvWf0iUQSkiZdK4WGqa4E969cfvGFKrj1cBZoa5PuZJcC6
         HzNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321414; x=1686913414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E2icZgj75N7YHEh5BHv7MRh1AjkwPp1BwTBEW4VCGug=;
        b=dYsBZ2I3cc+aJis0W+I+URvWmEjJe9mveKYylJOG+BgTmVVwM9wtIjTfCgvYwmRfpf
         +PBF8pDoVHmbCjhTEq5higYmnnL2norAmnWDLqCrKeZnJnhZBVqAJdj16DitCM/JFPXI
         YZaTrWqro67gqe4oOX2q5AnIkFlHwTy9LIEihFT7o70qqJcUlA76a/BmA1Bd9z4j0xFA
         JuIKdHYBz2009c+lFlB/hEP+1KXqcGdENj9mExqSZHCeMFBGUgCDdrVX1mdMetN8YroF
         oVHkFazEPtWjU864UfbaHYVgnFBFBQ3k8fJhIqi3OqxzzHomOUM1/F7H9A1NR3pg3n0F
         Ga2Q==
X-Gm-Message-State: AC+VfDwe+sPS/OLQm+h2PLGZmLsueXkfclGIGnj3j9bLcOX8jPhmdWq+
	bxZeqo1jw8vn5xNbxwfFJQAl1mObeU7zt0f/Ctg=
X-Google-Smtp-Source: ACHHUZ7gNvnqy13AzdXy9LAVsME56oNoauCxVzzAN6a0U3bjZpJIONLRADLM6V2daCI3Q773ScdZaQ==
X-Received: by 2002:a05:6214:c8d:b0:5e3:d150:3168 with SMTP id r13-20020a0562140c8d00b005e3d1503168mr57854382qvr.18.1684321414053;
        Wed, 17 May 2023 04:03:34 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id g6-20020a05620a13c600b0075772c756e0sm525089qkl.101.2023.05.17.04.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:03:32 -0700 (PDT)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: netdev@vger.kernel.org
Cc: deb.chatterjee@intel.com,
	anjali.singhai@intel.com,
	namrata.limaye@intel.com,
	tom@sipanda.io,
	p4tc-discussions@netdevconf.info,
	mleitner@redhat.com,
	Mahesh.Shirshyad@amd.com,
	Vipin.Jain@amd.com,
	tomasz.osinski@intel.com,
	jiri@resnulli.us,
	xiyou.wangcong@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	vladbu@nvidia.com,
	simon.horman@corigine.com,
	khalidm@nvidia.com,
	toke@redhat.com
Subject: [PATCH RFC v2 net-next 09/28] p4tc: add P4 data types
Date: Wed, 17 May 2023 07:02:13 -0400
Message-Id: <20230517110232.29349-9-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230517110232.29349-1-jhs@mojatatu.com>
References: <20230517110232.29349-1-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Introduce abstraction that represents P4 data types.
This also introduces the Kconfig and Makefile which later patches use.
Types could be little, host or big endian definitions. The abstraction also
supports defining:

a) bitstrings using annotations in control that look like "bitX" where X
   is the number of bits defined in a type

b) bitslices such that one can define in control bit8[0-3] and
   bit16[0-9]. A 4-bit slice from bits 0-3 and a 10-bit slice from bits
   0-9 respectively.

Each type has a bitsize, a name (for debugging purposes), an ID and
methods/ops. The P4 types will be used by metadata, headers, dynamic
actions and other part of P4TC.

Each type has four ops:

- validate_p4t: Which validates if a given value of a specific type
  meets valid boundary conditions.

- create_bitops: Which, given a bitsize, bitstart and bitend allocates and
  returns a mask and a shift value. For example, if we have type bit8[3-3]
  meaning bitstart = 3 and bitend = 3, we'll create a mask which would only
  give us the fourth bit of a bit8 value, that is, 0x08. Since we are
  interested in the fourth bit, the bit shift value will be 3.

- host_read : Which reads the value of a given type and transforms it to
  host order

- host_write : Which writes a provided host order value and transforms it
  to the type's native order

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/p4tc_types.h    |   87 +++
 include/uapi/linux/p4tc.h   |   40 ++
 net/sched/Kconfig           |    8 +
 net/sched/Makefile          |    2 +
 net/sched/p4tc/Makefile     |    3 +
 net/sched/p4tc/p4tc_types.c | 1354 +++++++++++++++++++++++++++++++++++
 6 files changed, 1494 insertions(+)
 create mode 100644 include/net/p4tc_types.h
 create mode 100644 include/uapi/linux/p4tc.h
 create mode 100644 net/sched/p4tc/Makefile
 create mode 100644 net/sched/p4tc/p4tc_types.c

diff --git a/include/net/p4tc_types.h b/include/net/p4tc_types.h
new file mode 100644
index 000000000000..26594c0b0298
--- /dev/null
+++ b/include/net/p4tc_types.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_P4TYPES_H
+#define __NET_P4TYPES_H
+
+#include <linux/netlink.h>
+#include <linux/pkt_cls.h>
+#include <linux/types.h>
+
+#include <uapi/linux/p4tc.h>
+
+#define P4T_MAX_BITSZ 128
+
+struct p4tc_type_mask_shift {
+	void *mask;
+	u8 shift;
+};
+
+struct p4tc_type;
+struct p4tc_type_ops {
+	int (*validate_p4t)(struct p4tc_type *container, void *value, u16 startbit,
+			    u16 endbit, struct netlink_ext_ack *extack);
+	struct p4tc_type_mask_shift *(*create_bitops)(u16 bitsz,
+						      u16 bitstart,
+						      u16 bitend,
+						      struct netlink_ext_ack *extack);
+	int (*host_read)(struct p4tc_type *container,
+			 struct p4tc_type_mask_shift *mask_shift, void *sval,
+			 void *dval);
+	int (*host_write)(struct p4tc_type *container,
+			  struct p4tc_type_mask_shift *mask_shift, void *sval,
+			  void *dval);
+	void (*print)(struct net *net, struct p4tc_type *container,
+		      const char *prefix, void *val);
+};
+
+#define P4T_MAX_STR_SZ 32
+struct p4tc_type {
+	char name[P4T_MAX_STR_SZ];
+	const struct p4tc_type_ops *ops;
+	size_t container_bitsz;
+	size_t bitsz;
+	int typeid;
+};
+
+struct p4tc_type *p4type_find_byid(int id);
+bool p4tc_type_unsigned(int typeid);
+
+int p4t_copy(struct p4tc_type_mask_shift *dst_mask_shift,
+	     struct p4tc_type *dst_t, void *dstv,
+	     struct p4tc_type_mask_shift *src_mask_shift,
+	     struct p4tc_type *src_t, void *srcv);
+int p4t_cmp(struct p4tc_type_mask_shift *dst_mask_shift,
+	    struct p4tc_type *dst_t, void *dstv,
+	    struct p4tc_type_mask_shift *src_mask_shift,
+	    struct p4tc_type *src_t, void *srcv);
+void p4t_release(struct p4tc_type_mask_shift *mask_shift);
+
+int p4tc_register_types(void);
+void p4tc_unregister_types(void);
+
+#ifdef CONFIG_RETPOLINE
+int __p4tc_type_host_read(const struct p4tc_type_ops *ops,
+			  struct p4tc_type *container,
+			  struct p4tc_type_mask_shift *mask_shift, void *sval,
+			  void *dval);
+int __p4tc_type_host_write(const struct p4tc_type_ops *ops,
+			   struct p4tc_type *container,
+			   struct p4tc_type_mask_shift *mask_shift, void *sval,
+			   void *dval);
+#else
+static inline int __p4tc_type_host_read(const struct p4tc_type_ops *ops,
+					struct p4tc_type *container,
+					struct p4tc_type_mask_shift *mask_shift,
+					void *sval, void *dval)
+{
+	return ops->host_read(container, mask_shift, sval, dval);
+}
+static inline int __p4tc_type_host_write(const struct p4tc_type_ops *ops,
+					struct p4tc_type *container,
+					struct p4tc_type_mask_shift *mask_shift,
+					void *sval, void *dval)
+{
+	return ops->host_write(container, mask_shift, sval, dval);
+}
+#endif
+
+#endif
diff --git a/include/uapi/linux/p4tc.h b/include/uapi/linux/p4tc.h
new file mode 100644
index 000000000000..2b6f126dbeb5
--- /dev/null
+++ b/include/uapi/linux/p4tc.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __LINUX_P4TC_H
+#define __LINUX_P4TC_H
+
+#define P4TC_MAX_KEYSZ 512
+
+enum {
+	P4T_UNSPEC,
+	P4T_U8 = 1, /* NLA_U8 */
+	P4T_U16 = 2, /* NLA_U16 */
+	P4T_U32 = 3, /* NLA_U32 */
+	P4T_U64 = 4, /* NLA_U64 */
+	P4T_STRING = 5, /* NLA_STRING */
+	P4T_FLAG = 6, /* NLA_FLAG */
+	P4T_MSECS = 7, /* NLA_MSECS */
+	P4T_NESTED = 8, /* NLA_NESTED */
+	P4T_NESTED_ARRAY = 9, /* NLA_NESTED_ARRAY */
+	P4T_NUL_STRING = 10, /* NLA_NUL_STRING */
+	P4T_BINARY = 11, /* NLA_BINARY */
+	P4T_S8 = 12, /* NLA_S8 */
+	P4T_S16 = 13, /* NLA_S16 */
+	P4T_S32 = 14, /* NLA_S32 */
+	P4T_S64 = 15, /* NLA_S64 */
+	P4T_BITFIELD32 = 16, /* NLA_BITFIELD32 */
+	P4T_MACADDR = 17, /* NLA_REJECT */
+	P4T_IPV4ADDR,
+	P4T_BE16,
+	P4T_BE32,
+	P4T_BE64,
+	P4T_U128,
+	P4T_S128,
+	P4T_PATH,
+	P4T_BOOL,
+	P4T_DEV,
+	P4T_KEY,
+	__P4T_MAX,
+};
+#define P4T_MAX (__P4T_MAX - 1)
+
+#endif
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 4b95cb1ac435..ea57a4c7b205 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -676,6 +676,14 @@ config NET_EMATCH_IPT
 	  To compile this code as a module, choose M here: the
 	  module will be called em_ipt.
 
+config NET_P4_TC
+	bool "P4 TC support"
+	select NET_CLS_ACT
+	help
+	  Say Y here if you want to use P4 features on top of TC.
+	  The concept of Pipelines, Tables, metadata will be enabled
+          with this option.
+
 config NET_CLS_ACT
 	bool "Actions"
 	select NET_CLS
diff --git a/net/sched/Makefile b/net/sched/Makefile
index b5fd49641d91..937b8f8a90ce 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -82,3 +82,5 @@ obj-$(CONFIG_NET_EMATCH_TEXT)	+= em_text.o
 obj-$(CONFIG_NET_EMATCH_CANID)	+= em_canid.o
 obj-$(CONFIG_NET_EMATCH_IPSET)	+= em_ipset.o
 obj-$(CONFIG_NET_EMATCH_IPT)	+= em_ipt.o
+
+obj-$(CONFIG_NET_P4_TC)		+= p4tc/
diff --git a/net/sched/p4tc/Makefile b/net/sched/p4tc/Makefile
new file mode 100644
index 000000000000..dd1358c9e802
--- /dev/null
+++ b/net/sched/p4tc/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-y := p4tc_types.o
diff --git a/net/sched/p4tc/p4tc_types.c b/net/sched/p4tc/p4tc_types.c
new file mode 100644
index 000000000000..3a6d643d453d
--- /dev/null
+++ b/net/sched/p4tc/p4tc_types.c
@@ -0,0 +1,1354 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * net/sched/p4tc_types.c -  P4 datatypes
+ * Copyright (c) 2022-2023, Mojatatu Networks
+ * Copyright (c) 2022-2023, Intel Corporation.
+ * Authors:     Jamal Hadi Salim <jhs@mojatatu.com>
+ *              Victor Nogueira <victor@mojatatu.com>
+ *              Pedro Tammela <pctammela@mojatatu.com>
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/skbuff.h>
+#include <linux/rtnetlink.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <net/net_namespace.h>
+#include <net/netlink.h>
+#include <net/pkt_sched.h>
+#include <net/pkt_cls.h>
+#include <net/act_api.h>
+#include <net/p4tc_types.h>
+#include <linux/etherdevice.h>
+
+static DEFINE_IDR(p4tc_types_idr);
+
+static void p4tc_types_put(void)
+{
+	unsigned long tmp, typeid;
+	struct p4tc_type *type;
+
+	idr_for_each_entry_ul(&p4tc_types_idr, type, tmp, typeid) {
+		idr_remove(&p4tc_types_idr, typeid);
+		kfree(type);
+	}
+}
+
+struct p4tc_type *p4type_find_byid(int typeid)
+{
+	return idr_find(&p4tc_types_idr, typeid);
+}
+
+static struct p4tc_type *p4type_find_byname(const char *name)
+{
+	struct p4tc_type *type;
+	unsigned long tmp, typeid;
+
+	idr_for_each_entry_ul(&p4tc_types_idr, type, tmp, typeid) {
+		if (!strncmp(type->name, name, P4T_MAX_STR_SZ))
+			return type;
+	}
+
+	return NULL;
+}
+
+bool p4tc_type_unsigned(int typeid)
+{
+	switch (typeid) {
+	case P4T_U8:
+	case P4T_U16:
+	case P4T_U32:
+	case P4T_U64:
+	case P4T_U128:
+	case P4T_BOOL:
+		return true;
+	default:
+		return false;
+	}
+}
+
+int p4t_copy(struct p4tc_type_mask_shift *dst_mask_shift,
+	     struct p4tc_type *dst_t, void *dstv,
+	     struct p4tc_type_mask_shift *src_mask_shift,
+	     struct p4tc_type *src_t, void *srcv)
+{
+	u64 readval[BITS_TO_U64(P4TC_MAX_KEYSZ)] = {0};
+	const struct p4tc_type_ops *srco, *dsto;
+
+	dsto = dst_t->ops;
+	srco = src_t->ops;
+
+	__p4tc_type_host_read(srco, src_t, src_mask_shift, srcv,
+			      &readval);
+	__p4tc_type_host_write(dsto, dst_t, dst_mask_shift, &readval,
+			       dstv);
+
+	return 0;
+}
+
+int p4t_cmp(struct p4tc_type_mask_shift *dst_mask_shift,
+	    struct p4tc_type *dst_t, void *dstv,
+	    struct p4tc_type_mask_shift *src_mask_shift,
+	    struct p4tc_type *src_t, void *srcv)
+{
+	u64 a[BITS_TO_U64(P4TC_MAX_KEYSZ)] = {0};
+	u64 b[BITS_TO_U64(P4TC_MAX_KEYSZ)] = {0};
+	const struct p4tc_type_ops *srco, *dsto;
+
+	dsto = dst_t->ops;
+	srco = src_t->ops;
+
+	__p4tc_type_host_read(dsto, dst_t, dst_mask_shift, dstv, a);
+	__p4tc_type_host_read(srco, src_t, src_mask_shift, srcv, b);
+
+	return memcmp(a, b, sizeof(a));
+}
+
+void p4t_release(struct p4tc_type_mask_shift *mask_shift)
+{
+	kfree(mask_shift->mask);
+	kfree(mask_shift);
+}
+
+static int p4t_validate_bitpos(u16 bitstart, u16 bitend, u16 maxbitstart,
+			       u16 maxbitend, struct netlink_ext_ack *extack)
+{
+	if (bitstart > maxbitstart) {
+		NL_SET_ERR_MSG_MOD(extack, "bitstart too high");
+		return -EINVAL;
+	}
+	if (bitend > maxbitend) {
+		NL_SET_ERR_MSG_MOD(extack, "bitend too high");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+//XXX: Latter immedv will be 64 bits
+static int p4t_u32_validate(struct p4tc_type *container, void *value,
+			    u16 bitstart, u16 bitend,
+			    struct netlink_ext_ack *extack)
+{
+	u32 container_maxsz = U32_MAX;
+	u32 *val = value;
+	size_t maxval;
+	int ret;
+
+	ret = p4t_validate_bitpos(bitstart, bitend, 31, 31, extack);
+	if (ret < 0)
+		return ret;
+
+	maxval = GENMASK(bitend, 0);
+	if (val && (*val > container_maxsz || *val > maxval)) {
+		NL_SET_ERR_MSG_MOD(extack, "U32 value out of range");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct p4tc_type_mask_shift *
+p4t_u32_bitops(u16 bitsiz, u16 bitstart, u16 bitend,
+	       struct netlink_ext_ack *extack)
+{
+	u32 mask = GENMASK(bitend, bitstart);
+	struct p4tc_type_mask_shift *mask_shift;
+	u32 *cmask;
+
+	mask_shift = kzalloc(sizeof(*mask_shift), GFP_KERNEL);
+	if (!mask_shift)
+		return ERR_PTR(-ENOMEM);
+
+	cmask = kzalloc(sizeof(u32), GFP_KERNEL);
+	if (!cmask) {
+		kfree(mask_shift);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	*cmask = mask;
+
+	mask_shift->mask = cmask;
+	mask_shift->shift = bitstart;
+
+	return mask_shift;
+}
+
+static int p4t_u32_write(struct p4tc_type *container,
+			 struct p4tc_type_mask_shift *mask_shift, void *sval,
+			 void *dval)
+{
+	u32 *dst = dval;
+	u32 *src = sval;
+	u32 maskedst = 0;
+	u8 shift = 0;
+
+	if (mask_shift) {
+		u32 *dmask = mask_shift->mask;
+
+		maskedst = *dst & ~*dmask;
+		shift = mask_shift->shift;
+	}
+
+	*dst = maskedst | (*src << shift);
+
+	return 0;
+}
+
+static void p4t_u32_print(struct net *net, struct p4tc_type *container,
+			  const char *prefix, void *val)
+{
+	u32 *v = val;
+
+	pr_info("%s 0x%x\n", prefix, *v);
+}
+
+static int p4t_u32_hread(struct p4tc_type *container,
+			 struct p4tc_type_mask_shift *mask_shift, void *sval,
+			 void *dval)
+{
+	u32 *dst = dval;
+	u32 *src = sval;
+
+	if (mask_shift) {
+		u32 *smask = mask_shift->mask;
+		u8 shift = mask_shift->shift;
+
+		*dst = (*src & *smask) >> shift;
+	} else {
+		*dst = *src;
+	}
+
+	return 0;
+}
+
+/*XXX: future converting immedv to 64 bits */
+static int p4t_s32_validate(struct p4tc_type *container, void *value,
+			    u16 bitstart, u16 bitend,
+			    struct netlink_ext_ack *extack)
+{
+	s32 minsz = S32_MIN, maxsz = S32_MAX;
+	s32 *val = value;
+
+	if (val && (*val > maxsz || *val < minsz)) {
+		NL_SET_ERR_MSG_MOD(extack, "S32 value out of range");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int p4t_s32_hread(struct p4tc_type *container,
+			 struct p4tc_type_mask_shift *mask_shift, void *sval,
+			 void *dval)
+{
+	s32 *dst = dval;
+	s32 *src = sval;
+
+	*dst = *src;
+
+	return 0;
+}
+
+static int p4t_s32_write(struct p4tc_type *container,
+			 struct p4tc_type_mask_shift *mask_shift, void *sval,
+			 void *dval)
+{
+	s32 *dst = dval;
+	s32 *src = sval;
+
+	*dst = *src;
+
+	return 0;
+}
+
+static void p4t_s32_print(struct net *net, struct p4tc_type *container,
+			  const char *prefix, void *val)
+{
+	s32 *v = val;
+
+	pr_info("%s %x\n", prefix, *v);
+}
+
+static void p4t_s64_print(struct net *net, struct p4tc_type *container,
+			  const char *prefix, void *val)
+{
+	s64 *v = val;
+
+	pr_info("%s 0x%llx\n", prefix, *v);
+}
+
+static int p4t_be32_validate(struct p4tc_type *container, void *value,
+			     u16 bitstart, u16 bitend,
+			     struct netlink_ext_ack *extack)
+{
+	size_t container_maxsz = U32_MAX;
+	__u32 *val_u32 = value;
+	__be32 val = 0;
+	size_t maxval;
+	int ret;
+
+	ret = p4t_validate_bitpos(bitstart, bitend, 31, 31, extack);
+	if (ret < 0)
+		return ret;
+
+	if (value)
+		val = (__be32)(be32_to_cpu(*val_u32));
+
+	maxval = GENMASK(bitend, 0);
+	if (val && (val > container_maxsz || val > maxval)) {
+		NL_SET_ERR_MSG_MOD(extack, "BE32 value out of range");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int p4t_be32_hread(struct p4tc_type *container,
+			  struct p4tc_type_mask_shift *mask_shift, void *sval,
+			  void *dval)
+{
+	u32 *dst = dval;
+	u32 *src = sval;
+	u32 readval = be32_to_cpu(*src);
+
+	if (mask_shift) {
+		u32 *smask = mask_shift->mask;
+		u8 shift = mask_shift->shift;
+
+		readval = (readval & *smask) >> shift;
+	}
+
+	*dst = readval;
+
+	return 0;
+}
+
+static int p4t_be32_write(struct p4tc_type *container,
+			  struct p4tc_type_mask_shift *mask_shift, void *sval,
+			  void *dval)
+{
+	__be32 *dst = dval;
+	u32 maskedst = 0;
+	u32 *src = sval;
+	u8 shift = 0;
+
+	if (mask_shift) {
+		u32 *dmask = (u32 *)mask_shift->mask;
+
+		maskedst = *dst & ~*dmask;
+		shift = mask_shift->shift;
+	}
+
+	*dst = cpu_to_be32(maskedst | (*src << shift));
+
+	return 0;
+}
+
+static void p4t_be32_print(struct net *net, struct p4tc_type *container,
+			   const char *prefix, void *val)
+{
+	__be32 *v = val;
+
+	pr_info("%s 0x%x\n", prefix, *v);
+}
+
+static int p4t_be64_hread(struct p4tc_type *container,
+			  struct p4tc_type_mask_shift *mask_shift, void *sval,
+			  void *dval)
+{
+	u64 *dst = dval;
+	u64 *src = sval;
+	u64 readval = be64_to_cpu(*src);
+
+	if (mask_shift) {
+		u64 *smask = mask_shift->mask;
+		u8 shift = mask_shift->shift;
+
+		readval = (readval & *smask) >> shift;
+	}
+
+	*dst = readval;
+
+	return 0;
+}
+
+static int p4t_be64_write(struct p4tc_type *container,
+			  struct p4tc_type_mask_shift *mask_shift, void *sval,
+			  void *dval)
+{
+	__be64 *dst = dval;
+	u64 maskedst = 0;
+	u64 *src = sval;
+	u8 shift = 0;
+
+	if (mask_shift) {
+		u64 *dmask = (u64 *)mask_shift->mask;
+
+		maskedst = *dst & ~*dmask;
+		shift = mask_shift->shift;
+	}
+
+	*dst = cpu_to_be64(maskedst | (*src << shift));
+
+	return 0;
+}
+
+static void p4t_be64_print(struct net *net, struct p4tc_type *container,
+			   const char *prefix, void *val)
+{
+	__be64 *v = val;
+
+	pr_info("%s 0x%llx\n", prefix, *v);
+}
+
+static int p4t_u16_validate(struct p4tc_type *container, void *value,
+			    u16 bitstart, u16 bitend,
+			    struct netlink_ext_ack *extack)
+{
+	u16 container_maxsz = U16_MAX;
+	u16 *val = value;
+	u16 maxval;
+	int ret;
+
+	ret = p4t_validate_bitpos(bitstart, bitend, 15, 15, extack);
+	if (ret < 0)
+		return ret;
+
+	maxval = GENMASK(bitend, 0);
+	if (val && (*val > container_maxsz || *val > maxval)) {
+		NL_SET_ERR_MSG_MOD(extack, "U16 value out of range");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct p4tc_type_mask_shift *
+p4t_u16_bitops(u16 bitsiz, u16 bitstart, u16 bitend,
+	       struct netlink_ext_ack *extack)
+{
+	u16 mask = GENMASK(bitend, bitstart);
+	struct p4tc_type_mask_shift *mask_shift;
+	u16 *cmask;
+
+	mask_shift = kzalloc(sizeof(*mask_shift), GFP_KERNEL);
+	if (!mask_shift)
+		return ERR_PTR(-ENOMEM);
+
+	cmask = kzalloc(sizeof(u16), GFP_KERNEL);
+	if (!cmask) {
+		kfree(mask_shift);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	*cmask = mask;
+
+	mask_shift->mask = cmask;
+	mask_shift->shift = bitstart;
+
+	return mask_shift;
+}
+
+static int p4t_u16_write(struct p4tc_type *container,
+			 struct p4tc_type_mask_shift *mask_shift, void *sval,
+			 void *dval)
+{
+	u16 *dst = dval;
+	u16 *src = sval;
+	u16 maskedst = 0;
+	u8 shift = 0;
+
+	if (mask_shift) {
+		u16 *dmask = mask_shift->mask;
+
+		maskedst = *dst & ~*dmask;
+		shift = mask_shift->shift;
+	}
+
+	*dst = maskedst | (*src << shift);
+
+	return 0;
+}
+
+static void p4t_u16_print(struct net *net, struct p4tc_type *container,
+			  const char *prefix, void *val)
+{
+	u16 *v = val;
+
+	pr_info("%s 0x%x\n", prefix, *v);
+}
+
+static int p4t_u16_hread(struct p4tc_type *container,
+			 struct p4tc_type_mask_shift *mask_shift, void *sval,
+			 void *dval)
+{
+	u16 *dst = dval;
+	u16 *src = sval;
+
+	if (mask_shift) {
+		u16 *smask = mask_shift->mask;
+		u8 shift = mask_shift->shift;
+
+		*dst = (*src & *smask) >> shift;
+	} else {
+		*dst = *src;
+	}
+
+	return 0;
+}
+
+static int p4t_s16_validate(struct p4tc_type *container, void *value,
+			    u16 bitstart, u16 bitend,
+			    struct netlink_ext_ack *extack)
+{
+	s16 minsz = S16_MIN, maxsz = S16_MAX;
+	s16 *val = value;
+
+	if (val && (*val > maxsz || *val < minsz)) {
+		NL_SET_ERR_MSG_MOD(extack, "S16 value out of range");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int p4t_s16_hread(struct p4tc_type *container,
+			 struct p4tc_type_mask_shift *mask_shift, void *sval,
+			 void *dval)
+{
+	s16 *dst = dval;
+	s16 *src = sval;
+
+	*dst = *src;
+
+	return 0;
+}
+
+static int p4t_s16_write(struct p4tc_type *container,
+			 struct p4tc_type_mask_shift *mask_shift, void *sval,
+			 void *dval)
+{
+	s16 *dst = dval;
+	s16 *src = sval;
+
+	*src = *dst;
+
+	return 0;
+}
+
+static void p4t_s16_print(struct net *net, struct p4tc_type *container,
+			  const char *prefix, void *val)
+{
+	s16 *v = val;
+
+	pr_info("%s %d\n", prefix, *v);
+}
+
+static int p4t_be16_validate(struct p4tc_type *container, void *value,
+			     u16 bitstart, u16 bitend,
+			     struct netlink_ext_ack *extack)
+{
+	__be16 container_maxsz = U16_MAX;
+	__u16 *val_u16 = value;
+	__be16 val = 0;
+	size_t maxval;
+	int ret;
+
+	ret = p4t_validate_bitpos(bitstart, bitend, 15, 15, extack);
+	if (ret < 0)
+		return ret;
+
+	if (value)
+		val = (__be16)(be16_to_cpu(*val_u16));
+
+	maxval = GENMASK(bitend, 0);
+	if (val && (val > container_maxsz || val > maxval)) {
+		NL_SET_ERR_MSG_MOD(extack, "BE16 value out of range");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int p4t_be16_hread(struct p4tc_type *container,
+			  struct p4tc_type_mask_shift *mask_shift, void *sval,
+			  void *dval)
+{
+	u16 *dst = dval;
+	u16 *src = sval;
+	u16 readval = be16_to_cpu(*src);
+
+	if (mask_shift) {
+		u16 *smask = mask_shift->mask;
+		u8 shift = mask_shift->shift;
+
+		readval = (readval & *smask) >> shift;
+	}
+
+	*dst = readval;
+
+	return 0;
+}
+
+static int p4t_be16_write(struct p4tc_type *container,
+			  struct p4tc_type_mask_shift *mask_shift, void *sval,
+			  void *dval)
+{
+	__be16 *dst = dval;
+	u16 maskedst = 0;
+	u16 *src = sval;
+	u8 shift = 0;
+
+	if (mask_shift) {
+		u16 *dmask = (u16 *)mask_shift->mask;
+
+		maskedst = *dst & ~*dmask;
+		shift = mask_shift->shift;
+	}
+
+	*dst = cpu_to_be16(maskedst | (*src << shift));
+
+	return 0;
+}
+
+static void p4t_be16_print(struct net *net, struct p4tc_type *container,
+			   const char *prefix, void *val)
+{
+	__be16 *v = val;
+
+	pr_info("%s 0x%x\n", prefix, *v);
+}
+
+static int p4t_u8_validate(struct p4tc_type *container, void *value,
+			   u16 bitstart, u16 bitend,
+			   struct netlink_ext_ack *extack)
+{
+	u8 *val = value;
+	size_t container_maxsz = U8_MAX;
+	u8 maxval;
+	int ret;
+
+	ret = p4t_validate_bitpos(bitstart, bitend, 7, 7, extack);
+	if (ret < 0)
+		return ret;
+
+	maxval = GENMASK(bitend, 0);
+	if (val && (*val > container_maxsz || *val > maxval)) {
+		NL_SET_ERR_MSG_MOD(extack, "U8 value out of range");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct p4tc_type_mask_shift *
+p4t_u8_bitops(u16 bitsiz, u16 bitstart, u16 bitend,
+	      struct netlink_ext_ack *extack)
+{
+	u8 mask = GENMASK(bitend, bitstart);
+	struct p4tc_type_mask_shift *mask_shift;
+	u8 *cmask;
+
+	mask_shift = kzalloc(sizeof(*mask_shift), GFP_KERNEL);
+	if (!mask_shift)
+		return ERR_PTR(-ENOMEM);
+
+	cmask = kzalloc(sizeof(u8), GFP_KERNEL);
+	if (!cmask) {
+		kfree(mask_shift);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	*cmask = mask;
+
+	mask_shift->mask = cmask;
+	mask_shift->shift = bitstart;
+
+	return mask_shift;
+}
+
+static int p4t_u8_write(struct p4tc_type *container,
+			struct p4tc_type_mask_shift *mask_shift, void *sval,
+			void *dval)
+{
+	u8 *dst = dval;
+	u8 *src = sval;
+	u8 maskedst = 0;
+	u8 shift = 0;
+
+	if (mask_shift) {
+		u8 *dmask = (u8 *)mask_shift->mask;
+
+		maskedst = *dst & ~*dmask;
+		shift = mask_shift->shift;
+	}
+
+	*dst = maskedst | (*src << shift);
+
+	return 0;
+}
+
+static void p4t_u8_print(struct net *net, struct p4tc_type *container,
+			 const char *prefix, void *val)
+{
+	u8 *v = val;
+
+	pr_info("%s 0x%x\n", prefix, *v);
+}
+
+static int p4t_u8_hread(struct p4tc_type *container,
+			struct p4tc_type_mask_shift *mask_shift, void *sval,
+			void *dval)
+{
+	u8 *dst = dval;
+	u8 *src = sval;
+
+	if (mask_shift) {
+		u8 *smask = mask_shift->mask;
+		u8 shift = mask_shift->shift;
+
+		*dst = (*src & *smask) >> shift;
+	} else {
+		*dst = *src;
+	}
+
+	return 0;
+}
+
+static int p4t_s8_validate(struct p4tc_type *container, void *value,
+			   u16 bitstart, u16 bitend,
+			   struct netlink_ext_ack *extack)
+{
+	s8 minsz = S8_MIN, maxsz = S8_MAX;
+	s8 *val = value;
+
+	if (val && (*val > maxsz || *val < minsz)) {
+		NL_SET_ERR_MSG_MOD(extack, "S8 value out of range");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int p4t_s8_hread(struct p4tc_type *container,
+			struct p4tc_type_mask_shift *mask_shift, void *sval,
+			void *dval)
+{
+	s8 *dst = dval;
+	s8 *src = sval;
+
+	*dst = *src;
+
+	return 0;
+}
+
+static void p4t_s8_print(struct net *net, struct p4tc_type *container,
+			 const char *prefix, void *val)
+{
+	s8 *v = val;
+
+	pr_info("%s %d\n", prefix, *v);
+}
+
+static int p4t_u64_validate(struct p4tc_type *container, void *value,
+			    u16 bitstart, u16 bitend,
+			    struct netlink_ext_ack *extack)
+{
+	u64 container_maxsz = U64_MAX;
+	u8 *val = value;
+	u64 maxval;
+	int ret;
+
+	ret = p4t_validate_bitpos(bitstart, bitend, 63, 63, extack);
+	if (ret < 0)
+		return ret;
+
+	maxval = GENMASK_ULL(bitend, 0);
+	if (val && (*val > container_maxsz || *val > maxval)) {
+		NL_SET_ERR_MSG_MOD(extack, "U64 value out of range");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct p4tc_type_mask_shift *
+p4t_u64_bitops(u16 bitsiz, u16 bitstart, u16 bitend,
+	       struct netlink_ext_ack *extack)
+{
+	u64 mask = GENMASK(bitend, bitstart);
+	struct p4tc_type_mask_shift *mask_shift;
+	u64 *cmask;
+
+	mask_shift = kzalloc(sizeof(*mask_shift), GFP_KERNEL);
+	if (!mask_shift)
+		return ERR_PTR(-ENOMEM);
+
+	cmask = kzalloc(sizeof(u64), GFP_KERNEL);
+	if (!cmask) {
+		kfree(mask_shift);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	*cmask = mask;
+
+	mask_shift->mask = cmask;
+	mask_shift->shift = bitstart;
+
+	return mask_shift;
+}
+
+static int p4t_u64_write(struct p4tc_type *container,
+			 struct p4tc_type_mask_shift *mask_shift, void *sval,
+			 void *dval)
+{
+	u64 *dst = dval;
+	u64 *src = sval;
+	u64 maskedst = 0;
+	u8 shift = 0;
+
+	if (mask_shift) {
+		u64 *dmask = (u64 *)mask_shift->mask;
+
+		maskedst = *dst & ~*dmask;
+		shift = mask_shift->shift;
+	}
+
+	*dst = maskedst | (*src << shift);
+
+	return 0;
+}
+
+static void p4t_u64_print(struct net *net, struct p4tc_type *container,
+			  const char *prefix, void *val)
+{
+	u64 *v = val;
+
+	pr_info("%s 0x%llx\n", prefix, *v);
+}
+
+static int p4t_u64_hread(struct p4tc_type *container,
+			 struct p4tc_type_mask_shift *mask_shift, void *sval,
+			 void *dval)
+{
+	u64 *dst = dval;
+	u64 *src = sval;
+
+	if (mask_shift) {
+		u64 *smask = mask_shift->mask;
+		u8 shift = mask_shift->shift;
+
+		*dst = (*src & *smask) >> shift;
+	} else {
+		*dst = *src;
+	}
+
+	return 0;
+}
+
+/* As of now, we are not allowing bitops for u128 */
+static int p4t_u128_validate(struct p4tc_type *container, void *value,
+			     u16 bitstart, u16 bitend,
+			     struct netlink_ext_ack *extack)
+{
+	if (bitstart != 0 || bitend != 127) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only valid bit type larger than bit64 is bit128");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int p4t_u128_hread(struct p4tc_type *container,
+			  struct p4tc_type_mask_shift *mask_shift, void *sval,
+			  void *dval)
+{
+	memcpy(sval, dval, sizeof(__u64) * 2);
+
+	return 0;
+}
+
+static int p4t_u128_write(struct p4tc_type *container,
+			  struct p4tc_type_mask_shift *mask_shift, void *sval,
+			  void *dval)
+{
+	memcpy(sval, dval, sizeof(__u64) * 2);
+
+	return 0;
+}
+
+static void p4t_u128_print(struct net *net, struct p4tc_type *container,
+			   const char *prefix, void *val)
+{
+	u64 *v = val;
+
+	pr_info("%s[0-63] %16llx", prefix, v[0]);
+	pr_info("%s[64-127] %16llx", prefix, v[1]);
+}
+
+static int p4t_ipv4_validate(struct p4tc_type *container, void *value,
+			     u16 bitstart, u16 bitend,
+			     struct netlink_ext_ack *extack)
+{
+	/* Not allowing bit-slices for now */
+	if (bitstart != 0 || bitend != 31) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid bitstart or bitend");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void p4t_ipv4_print(struct net *net, struct p4tc_type *container,
+			   const char *prefix, void *val)
+{
+	u32 *v32 = val;
+	u8 *v = val;
+
+	*v32 = cpu_to_be32(*v32);
+
+	pr_info("%s %u.%u.%u.%u\n", prefix, v[0], v[1], v[2], v[3]);
+}
+
+static int p4t_mac_validate(struct p4tc_type *container, void *value,
+			    u16 bitstart, u16 bitend,
+			    struct netlink_ext_ack *extack)
+{
+	if (bitstart != 0 || bitend != 47) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid bitstart or bitend");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void p4t_mac_print(struct net *net, struct p4tc_type *container,
+			  const char *prefix, void *val)
+{
+	u8 *v = val;
+
+	pr_info("%s %02X:%02x:%02x:%02x:%02x:%02x\n", prefix, v[0], v[1], v[2],
+		v[3], v[4], v[5]);
+}
+
+static int p4t_dev_validate(struct p4tc_type *container, void *value,
+			    u16 bitstart, u16 bitend,
+			    struct netlink_ext_ack *extack)
+{
+	if (bitstart != 0 || bitend != 31) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid start or endbit values");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int p4t_dev_write(struct p4tc_type *container,
+			 struct p4tc_type_mask_shift *mask_shift, void *sval,
+			 void *dval)
+{
+	u32 *src = sval;
+	u32 *dst = dval;
+
+	*dst = *src;
+
+	return 0;
+}
+
+static int p4t_dev_hread(struct p4tc_type *container,
+			 struct p4tc_type_mask_shift *mask_shift, void *sval,
+			 void *dval)
+{
+	u32 *src = sval;
+	u32 *dst = dval;
+
+	*dst = *src;
+
+	return 0;
+}
+
+static void p4t_dev_print(struct net *net, struct p4tc_type *container,
+			  const char *prefix, void *val)
+{
+	const u32 *ifindex = val;
+	struct net_device *dev = dev_get_by_index_rcu(net, *ifindex);
+
+	pr_info("%s %s\n", prefix, dev->name);
+}
+
+static int p4t_key_hread(struct p4tc_type *container,
+			 struct p4tc_type_mask_shift *mask_shift, void *sval,
+			 void *dval)
+{
+	memcpy(dval, sval, BITS_TO_BYTES(container->bitsz));
+
+	return 0;
+}
+
+static int p4t_key_write(struct p4tc_type *container,
+			 struct p4tc_type_mask_shift *mask_shift, void *sval,
+			 void *dval)
+{
+	memcpy(dval, sval, BITS_TO_BYTES(container->bitsz));
+
+	return 0;
+}
+
+static void p4t_key_print(struct net *net, struct p4tc_type *container,
+			  const char *prefix, void *val)
+{
+	u64 *v = val;
+	u16 bitstart = 0, bitend = 63;
+	int i;
+
+	for (i = 0; i < BITS_TO_U64(container->bitsz); i++) {
+		pr_info("%s[%u-%u] %16llx\n", prefix, bitstart, bitend, v[i]);
+		bitstart += 64;
+		bitend += 64;
+	}
+}
+
+static int p4t_key_validate(struct p4tc_type *container, void *value,
+			    u16 bitstart, u16 bitend,
+			    struct netlink_ext_ack *extack)
+{
+	if (p4t_validate_bitpos(bitstart, bitend, 0, P4TC_MAX_KEYSZ, extack))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int p4t_bool_validate(struct p4tc_type *container, void *value,
+			     u16 bitstart, u16 bitend,
+			     struct netlink_ext_ack *extack)
+{
+	bool *val = value;
+	int ret;
+
+	ret = p4t_validate_bitpos(bitstart, bitend, 31, 31, extack);
+	if (ret < 0)
+		return ret;
+
+	if (*val == true || *val == false)
+		return 0;
+
+	return -EINVAL;
+}
+
+static int p4t_bool_hread(struct p4tc_type *container,
+			  struct p4tc_type_mask_shift *mask_shift, void *sval,
+			  void *dval)
+{
+	bool *dst = dval;
+	bool *src = sval;
+
+	*dst = *src;
+
+	return 0;
+}
+
+static int p4t_bool_write(struct p4tc_type *container,
+			  struct p4tc_type_mask_shift *mask_shift, void *sval,
+			  void *dval)
+{
+	bool *dst = dval;
+	bool *src = sval;
+
+	*dst = *src;
+
+	return 0;
+}
+
+static void p4t_bool_print(struct net *net, struct p4tc_type *container,
+			   const char *prefix, void *val)
+{
+	bool *v = val;
+
+	pr_info("%s %s", prefix, *v ? "true" : "false");
+}
+
+static const struct p4tc_type_ops u8_ops = {
+	.validate_p4t = p4t_u8_validate,
+	.create_bitops = p4t_u8_bitops,
+	.host_read = p4t_u8_hread,
+	.host_write = p4t_u8_write,
+	.print = p4t_u8_print,
+};
+
+static const struct p4tc_type_ops u16_ops = {
+	.validate_p4t = p4t_u16_validate,
+	.create_bitops = p4t_u16_bitops,
+	.host_read = p4t_u16_hread,
+	.host_write = p4t_u16_write,
+	.print = p4t_u16_print,
+};
+
+static const struct p4tc_type_ops u32_ops = {
+	.validate_p4t = p4t_u32_validate,
+	.create_bitops = p4t_u32_bitops,
+	.host_read = p4t_u32_hread,
+	.host_write = p4t_u32_write,
+	.print = p4t_u32_print,
+};
+
+static const struct p4tc_type_ops u64_ops = {
+	.validate_p4t = p4t_u64_validate,
+	.create_bitops = p4t_u64_bitops,
+	.host_read = p4t_u64_hread,
+	.host_write = p4t_u64_write,
+	.print = p4t_u64_print,
+};
+
+static const struct p4tc_type_ops u128_ops = {
+	.validate_p4t = p4t_u128_validate,
+	.host_read = p4t_u128_hread,
+	.host_write = p4t_u128_write,
+	.print = p4t_u128_print,
+};
+
+static const struct p4tc_type_ops s8_ops = {
+	.validate_p4t = p4t_s8_validate,
+	.host_read = p4t_s8_hread,
+	.print = p4t_s8_print,
+};
+
+static const struct p4tc_type_ops s16_ops = {
+	.validate_p4t = p4t_s16_validate,
+	.host_read = p4t_s16_hread,
+	.host_write = p4t_s16_write,
+	.print = p4t_s16_print,
+};
+
+static const struct p4tc_type_ops s32_ops = {
+	.validate_p4t = p4t_s32_validate,
+	.host_read = p4t_s32_hread,
+	.host_write = p4t_s32_write,
+	.print = p4t_s32_print,
+};
+
+static const struct p4tc_type_ops s64_ops = {
+	.print = p4t_s64_print,
+};
+
+static const struct p4tc_type_ops s128_ops = {};
+
+static const struct p4tc_type_ops be16_ops = {
+	.validate_p4t = p4t_be16_validate,
+	.create_bitops = p4t_u16_bitops,
+	.host_read = p4t_be16_hread,
+	.host_write = p4t_be16_write,
+	.print = p4t_be16_print,
+};
+
+static const struct p4tc_type_ops be32_ops = {
+	.validate_p4t = p4t_be32_validate,
+	.create_bitops = p4t_u32_bitops,
+	.host_read = p4t_be32_hread,
+	.host_write = p4t_be32_write,
+	.print = p4t_be32_print,
+};
+
+static const struct p4tc_type_ops be64_ops = {
+	.validate_p4t = p4t_u64_validate,
+	.host_read = p4t_be64_hread,
+	.host_write = p4t_be64_write,
+	.print = p4t_be64_print,
+};
+
+static const struct p4tc_type_ops string_ops = {};
+static const struct p4tc_type_ops nullstring_ops = {};
+
+static const struct p4tc_type_ops flag_ops = {};
+static const struct p4tc_type_ops path_ops = {};
+static const struct p4tc_type_ops msecs_ops = {};
+static const struct p4tc_type_ops mac_ops = {
+	.validate_p4t = p4t_mac_validate,
+	.create_bitops = p4t_u64_bitops,
+	.host_read = p4t_u64_hread,
+	.host_write = p4t_u64_write,
+	.print = p4t_mac_print,
+};
+
+static const struct p4tc_type_ops ipv4_ops = {
+	.validate_p4t = p4t_ipv4_validate,
+	.host_read = p4t_be32_hread,
+	.host_write = p4t_be32_write,
+	.print = p4t_ipv4_print,
+};
+
+static const struct p4tc_type_ops bool_ops = {
+	.validate_p4t = p4t_bool_validate,
+	.host_read = p4t_bool_hread,
+	.host_write = p4t_bool_write,
+	.print = p4t_bool_print,
+};
+
+static const struct p4tc_type_ops dev_ops = {
+	.validate_p4t = p4t_dev_validate,
+	.host_read = p4t_dev_hread,
+	.host_write = p4t_dev_write,
+	.print = p4t_dev_print,
+};
+
+static const struct p4tc_type_ops key_ops = {
+	.validate_p4t = p4t_key_validate,
+	.host_read = p4t_key_hread,
+	.host_write = p4t_key_write,
+	.print = p4t_key_print,
+};
+
+#ifdef CONFIG_RETPOLINE
+int __p4tc_type_host_read(const struct p4tc_type_ops *ops,
+			  struct p4tc_type *container,
+			  struct p4tc_type_mask_shift *mask_shift, void *sval,
+			  void *dval)
+{
+	#define HREAD(cops) \
+		if (ops == &cops) \
+			return cops.host_read(container, mask_shift, sval, dval)
+
+	HREAD(u8_ops);
+	HREAD(u16_ops);
+	HREAD(u32_ops);
+	HREAD(u64_ops);
+	HREAD(u128_ops);
+	HREAD(s8_ops);
+	HREAD(s16_ops);
+	HREAD(s32_ops);
+	HREAD(be16_ops);
+	HREAD(be32_ops);
+	HREAD(mac_ops);
+	HREAD(ipv4_ops);
+	HREAD(bool_ops);
+	HREAD(dev_ops);
+	HREAD(key_ops);
+
+	return ops->host_read(container, mask_shift, sval, dval);
+}
+
+int __p4tc_type_host_write(const struct p4tc_type_ops *ops,
+			    struct p4tc_type *container,
+			    struct p4tc_type_mask_shift *mask_shift, void *sval,
+			    void *dval)
+{
+	#define HWRITE(cops) \
+		if (ops == &cops) \
+			return cops.host_write(container, mask_shift, sval, dval)
+
+	HWRITE(u8_ops);
+	HWRITE(u16_ops);
+	HWRITE(u32_ops);
+	HWRITE(u64_ops);
+	HWRITE(u128_ops);
+	HWRITE(s16_ops);
+	HWRITE(s32_ops);
+	HWRITE(be16_ops);
+	HWRITE(be32_ops);
+	HWRITE(mac_ops);
+	HWRITE(ipv4_ops);
+	HWRITE(bool_ops);
+	HWRITE(dev_ops);
+	HWRITE(key_ops);
+
+	return ops->host_write(container, mask_shift, sval, dval);
+}
+#endif
+
+static int __p4tc_do_regtype(int typeid, size_t bitsz, size_t container_bitsz,
+			     const char *t_name,
+			     const struct p4tc_type_ops *ops)
+{
+	struct p4tc_type *type;
+	int err;
+
+	if (typeid > P4T_MAX)
+		return -EINVAL;
+
+	if (p4type_find_byid(typeid) || p4type_find_byname(t_name))
+		return -EEXIST;
+
+	if (bitsz > P4T_MAX_BITSZ)
+		return -E2BIG;
+
+	if (container_bitsz > P4T_MAX_BITSZ)
+		return -E2BIG;
+
+	type = kzalloc(sizeof(*type), GFP_ATOMIC);
+	if (!type)
+		return -ENOMEM;
+
+	err = idr_alloc_u32(&p4tc_types_idr, type, &typeid, typeid, GFP_ATOMIC);
+	if (err < 0)
+		return err;
+
+	strscpy(type->name, t_name, P4T_MAX_STR_SZ);
+	type->typeid = typeid;
+	type->bitsz = bitsz;
+	type->container_bitsz = container_bitsz;
+	type->ops = ops;
+
+	return 0;
+}
+
+static inline int __p4tc_register_type(int typeid, size_t bitsz,
+				       size_t container_bitsz,
+				       const char *t_name,
+				       const struct p4tc_type_ops *ops)
+{
+	if (__p4tc_do_regtype(typeid, bitsz, container_bitsz, t_name, ops) <
+	    0) {
+		pr_err("Unable to allocate p4 type %s\n", t_name);
+		p4tc_types_put();
+		return -1;
+	}
+
+	return 0;
+}
+
+#define p4tc_register_type(...)                            \
+	do {                                               \
+		if (__p4tc_register_type(__VA_ARGS__) < 0) \
+			return -1;                         \
+	} while (0)
+
+int p4tc_register_types(void)
+{
+	p4tc_register_type(P4T_U8, 8, 8, "u8", &u8_ops);
+	p4tc_register_type(P4T_U16, 16, 16, "u16", &u16_ops);
+	p4tc_register_type(P4T_U32, 32, 32, "u32", &u32_ops);
+	p4tc_register_type(P4T_U64, 64, 64, "u64", &u64_ops);
+	p4tc_register_type(P4T_U128, 128, 128, "u128", &u128_ops);
+	p4tc_register_type(P4T_S8, 8, 8, "s8", &s8_ops);
+	p4tc_register_type(P4T_BE16, 16, 16, "be16", &be16_ops);
+	p4tc_register_type(P4T_BE32, 32, 32, "be32", &be32_ops);
+	p4tc_register_type(P4T_BE64, 64, 64, "be64", &be64_ops);
+	p4tc_register_type(P4T_S16, 16, 16, "s16", &s16_ops);
+	p4tc_register_type(P4T_S32, 32, 32, "s32", &s32_ops);
+	p4tc_register_type(P4T_S64, 64, 64, "s64", &s64_ops);
+	p4tc_register_type(P4T_S128, 128, 128, "s128", &s128_ops);
+	p4tc_register_type(P4T_STRING, P4T_MAX_STR_SZ * 4, P4T_MAX_STR_SZ * 4,
+			   "string", &string_ops);
+	p4tc_register_type(P4T_NUL_STRING, P4T_MAX_STR_SZ * 4,
+			   P4T_MAX_STR_SZ * 4, "nullstr", &nullstring_ops);
+	p4tc_register_type(P4T_FLAG, 32, 32, "flag", &flag_ops);
+	p4tc_register_type(P4T_PATH, 0, 0, "path", &path_ops);
+	p4tc_register_type(P4T_MSECS, 0, 0, "msecs", &msecs_ops);
+	p4tc_register_type(P4T_MACADDR, 48, 64, "mac", &mac_ops);
+	p4tc_register_type(P4T_IPV4ADDR, 32, 32, "ipv4", &ipv4_ops);
+	p4tc_register_type(P4T_BOOL, 32, 32, "bool", &bool_ops);
+	p4tc_register_type(P4T_DEV, 32, 32, "dev", &dev_ops);
+	p4tc_register_type(P4T_KEY, P4TC_MAX_KEYSZ, P4TC_MAX_KEYSZ, "key",
+			   &key_ops);
+
+	return 0;
+}
+
+void p4tc_unregister_types(void)
+{
+	p4tc_types_put();
+}
-- 
2.25.1


