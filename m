Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313CB40EB3D
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 22:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236274AbhIPUDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 16:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbhIPUDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 16:03:49 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8898CC061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 13:02:26 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id f22so10244755qkm.5
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 13:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q4OKFYOWcSEcatx5aT492+CSkyNK0GPlz7nabv6YqJM=;
        b=2kYbuD/+4wEGdSxOMdkdHrg/H4oKkSEYGfPXne2Yk2bCMwlpJ0UWHKvaLXNXDq3dVg
         47y7nVMHSMrO8eu4x9I2Hu8vNkiCvcMaEkk0anJq8ZC7iA6bpBU162mjGdqvgtg1hlAx
         itBHka92fF+9CEjdKML3pRhVPN8QZNWrQJ84MokQzpLohvKKuDH1FM3MW+CuhG3Ew02e
         JSoQyRE7/nB9LZjM6Oae8xREoTIEQmxwpOB5Z4hONUwZfb9uJg2tahfGDpIU3MFkB6Ux
         JbHD5QnrvXvfGRbMjdFC1RPazGNKRHFcwpuKNXIdrFUitu4DV4YuAw9kLM2aBuzFRZNi
         13EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q4OKFYOWcSEcatx5aT492+CSkyNK0GPlz7nabv6YqJM=;
        b=Hng9uo4Yjb+qkWQxH0s23kAbwhT6Zvk2ms9Ad8aJI0g0pVRyJTZf34bo7AfDWisXea
         wz+rTgFQgYTRTWyNHfIj429OmM3Zo6qwBhkWBDlIxgeUsEE/I9hfhQNtAQ06m7hZVlff
         giZQhMi7BnABKg8/vIU4rPeE4e8I5H3kPz0wnND/sI45xujboekJGOYaiu2dk+/QpMvA
         UTvYBK4SY8nKHAQNnA2Ugf/CAf+RUz6O6tSHzoHAEm0ups0sxDx6UJZtwwyffh+qOsbR
         KflS2ls8a3MqbTd+kTnYHL4l7JXfQe7G5N25GRV8TRMtSth0c7+VAIah+h148lFBuocl
         NTgg==
X-Gm-Message-State: AOAM532fHWuWOuv5Rnz9MLji109lJLUqxOEJuAHF3TiTx03BBxPBCf5R
        UrDj+so70awusi8kvL43FwlSnA==
X-Google-Smtp-Source: ABdhPJy56AezqSjUDPoZj9n1TYsIuFYbRyCjdvxovUOXJnlt7nwP0H5EwIZChorM0KKEDTIcbQYyeA==
X-Received: by 2002:a05:620a:2008:: with SMTP id c8mr6854518qka.493.1631822543958;
        Thu, 16 Sep 2021 13:02:23 -0700 (PDT)
Received: from localhost.localdomain (200.146.127.228.dynamic.adsl.gvt.net.br. [200.146.127.228])
        by smtp.googlemail.com with ESMTPSA id a24sm1307043qtp.90.2021.09.16.13.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 13:02:23 -0700 (PDT)
From:   Felipe Magno de Almeida <felipe@sipanda.io>
X-Google-Original-From: Felipe Magno de Almeida <felipe@expertise.dev>
To:     jhs@mojatatu.com, jiri@resnulli.us, xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, boris.sukholitko@broadcom.com,
        vadym.kochan@plvision.eu, ilya.lifshits@broadcom.com,
        vladbu@nvidia.com, idosch@idosch.org, paulb@nvidia.com,
        dcaratti@redhat.com, marcelo.leitner@gmail.com,
        amritha.nambiar@intel.com, sridhar.samudrala@intel.com,
        tom@sipanda.io, pctammela@mojatatu.com, eric.dumazet@gmail.com,
        Felipe Magno de Almeida <felipe@sipanda.io>
Subject: [PATCH RFC net-next 1/2] net: Add PANDA network packet parser
Date:   Thu, 16 Sep 2021 17:00:40 -0300
Message-Id: <20210916200041.810-2-felipe@expertise.dev>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916200041.810-1-felipe@expertise.dev>
References: <20210916200041.810-1-felipe@expertise.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felipe Magno de Almeida <felipe@sipanda.io>

Adds the generic PANDA parser implementation to net/panda and the
auxiliary include headers that are used by the optimized and generic
implementation to include/net/panda.

The PANDA project allows the user to to create network packet parsers
by combining and matching protocols in a declarative way, albeit in C
code. This feature allows the flexibility users need to write parsers
for specific protocols or to change the specifics on how and what data
to extract from network packets.

The PANDA project also has a C-to-C compiler that reads a C file with
a declarative parser definition and outputs an optimized version that
uses the compiler inline optimizations to achieve much better
performance than a generic implementation could. This compiler could
be added later to the tools directory to be used in other subsystems
to generate optimized versions of specialized parsers.

A couple drawbacks of this commit (which is meant as a RFC PATCH) is
that it fails checkpatch in some cases and that it has some code
repetition from existing code in kernel. Keep in mind that these
drawbacks are known and they will get fixed with a proper submission
patch.

For example, to define a very simple parser, you would define the
parser nodes and a parser table for each non-terminal parser as such:

```
PANDA_MAKE_PARSE_NODE(ether_node, panda_parse_ether, NULL, NULL, ether_table);
PANDA_MAKE_PARSE_NODE(ipv4_node, panda_parse_ipv4, extract_ipv4, NULL,
		      ip_table);
PANDA_MAKE_PARSE_NODE(ipv6_node, panda_parse_ipv6, extract_ipv6, NULL,
		      ip_table);
PANDA_MAKE_LEAF_PARSE_NODE(ports_node, panda_parse_ports, extract_ports, NULL);

PANDA_MAKE_PROTO_TABLE(ether_table,
	{ __cpu_to_be16(ETH_P_IP), &ipv4_node },
	{ __cpu_to_be16(ETH_P_IPV6), &ipv6_node },
);

PANDA_MAKE_PROTO_TABLE(ip_table,
	{ IPPROTO_TCP, &ports_node },
	{ IPPROTO_UDP, &ports_node },
);

PANDA_PARSER(parser, "Simple parser without md templates", &ether_node);
```

Which you can run this way:

```
panda_parse(parser, packet, len, &extracted_header_metadata, 0, 0);
```

Signed-off-by: Felipe Magno de Almeida <felipe@sipanda.io>
---
 include/net/panda/compiler_helpers.h          |  79 ++
 include/net/panda/flag_fields.h               | 369 ++++++++
 include/net/panda/parser.h                    | 394 ++++++++
 include/net/panda/parser_metadata.h           | 873 ++++++++++++++++++
 include/net/panda/parser_types.h              | 255 +++++
 include/net/panda/proto_nodes.h               |  48 +
 .../net/panda/proto_nodes/proto_arp_rarp.h    |  88 ++
 include/net/panda/proto_nodes/proto_batman.h  | 106 +++
 include/net/panda/proto_nodes/proto_ether.h   |  58 ++
 include/net/panda/proto_nodes/proto_fcoe.h    |  49 +
 include/net/panda/proto_nodes/proto_gre.h     | 290 ++++++
 include/net/panda/proto_nodes/proto_icmp.h    |  74 ++
 include/net/panda/proto_nodes/proto_igmp.h    |  49 +
 include/net/panda/proto_nodes/proto_ip.h      |  77 ++
 include/net/panda/proto_nodes/proto_ipv4.h    | 150 +++
 include/net/panda/proto_nodes/proto_ipv4ip.h  |  59 ++
 include/net/panda/proto_nodes/proto_ipv6.h    | 133 +++
 include/net/panda/proto_nodes/proto_ipv6_eh.h | 108 +++
 include/net/panda/proto_nodes/proto_ipv6ip.h  |  59 ++
 include/net/panda/proto_nodes/proto_mpls.h    |  49 +
 include/net/panda/proto_nodes/proto_ports.h   |  59 ++
 include/net/panda/proto_nodes/proto_ppp.h     |  79 ++
 include/net/panda/proto_nodes/proto_pppoe.h   |  98 ++
 include/net/panda/proto_nodes/proto_tcp.h     | 177 ++++
 include/net/panda/proto_nodes/proto_tipc.h    |  56 ++
 include/net/panda/proto_nodes/proto_vlan.h    |  66 ++
 include/net/panda/proto_nodes_def.h           |  40 +
 include/net/panda/tlvs.h                      | 289 ++++++
 net/Kconfig                                   |   9 +
 net/Makefile                                  |   1 +
 net/panda/Makefile                            |   8 +
 net/panda/panda_parser.c                      | 605 ++++++++++++
 32 files changed, 4854 insertions(+)
 create mode 100644 include/net/panda/compiler_helpers.h
 create mode 100644 include/net/panda/flag_fields.h
 create mode 100644 include/net/panda/parser.h
 create mode 100644 include/net/panda/parser_metadata.h
 create mode 100644 include/net/panda/parser_types.h
 create mode 100644 include/net/panda/proto_nodes.h
 create mode 100644 include/net/panda/proto_nodes/proto_arp_rarp.h
 create mode 100644 include/net/panda/proto_nodes/proto_batman.h
 create mode 100644 include/net/panda/proto_nodes/proto_ether.h
 create mode 100644 include/net/panda/proto_nodes/proto_fcoe.h
 create mode 100644 include/net/panda/proto_nodes/proto_gre.h
 create mode 100644 include/net/panda/proto_nodes/proto_icmp.h
 create mode 100644 include/net/panda/proto_nodes/proto_igmp.h
 create mode 100644 include/net/panda/proto_nodes/proto_ip.h
 create mode 100644 include/net/panda/proto_nodes/proto_ipv4.h
 create mode 100644 include/net/panda/proto_nodes/proto_ipv4ip.h
 create mode 100644 include/net/panda/proto_nodes/proto_ipv6.h
 create mode 100644 include/net/panda/proto_nodes/proto_ipv6_eh.h
 create mode 100644 include/net/panda/proto_nodes/proto_ipv6ip.h
 create mode 100644 include/net/panda/proto_nodes/proto_mpls.h
 create mode 100644 include/net/panda/proto_nodes/proto_ports.h
 create mode 100644 include/net/panda/proto_nodes/proto_ppp.h
 create mode 100644 include/net/panda/proto_nodes/proto_pppoe.h
 create mode 100644 include/net/panda/proto_nodes/proto_tcp.h
 create mode 100644 include/net/panda/proto_nodes/proto_tipc.h
 create mode 100644 include/net/panda/proto_nodes/proto_vlan.h
 create mode 100644 include/net/panda/proto_nodes_def.h
 create mode 100644 include/net/panda/tlvs.h
 create mode 100644 net/panda/Makefile
 create mode 100644 net/panda/panda_parser.c

diff --git a/include/net/panda/compiler_helpers.h b/include/net/panda/compiler_helpers.h
new file mode 100644
index 000000000000..2f349529a78d
--- /dev/null
+++ b/include/net/panda/compiler_helpers.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_COMPILER_HELPERS_H__
+#define __PANDA_COMPILER_HELPERS_H__
+
+/* Various helper defintions and functions that are compiler specific
+ * (e.g. they use __attribute__
+ */
+
+/* Define the __defaligned macro if it's not already defined */
+#ifndef __defaligned
+#define __defaligned() __attribute__ ((__aligned__))
+#endif
+
+/* Define the __aligned macro if it's not already defined */
+#ifndef __aligned
+#define __aligned(size) __attribute__((__aligned__(size)))
+#endif
+
+/* Define the __unused macro if it's not already defined */
+#ifndef __unused
+#define __unused() __attribute__((unused))
+#endif
+
+/* Define the __always_inline macro if it's not already defined */
+#ifndef __always_inline
+#define __always_inline __attribute__((always_inline)) inline
+#endif
+
+/* Utilities for dynamic arrays in sections */
+
+#define PANDA_DEFINE_SECTION(NAME, TYPE)				\
+extern TYPE __start_##NAME[];						\
+extern TYPE __stop_##NAME[];						\
+static inline unsigned int panda_section_array_size_##NAME(void)	\
+{									\
+	return (unsigned int)(__stop_##NAME - __start_##NAME);		\
+}									\
+static inline TYPE *panda_section_base_##NAME(void)			\
+{									\
+	return __start_##NAME;						\
+}
+
+#ifndef __bpf__
+#define PANDA_SECTION_ATTR(NAME) __attribute__((__used__, __section__(#NAME)))
+#else
+#define PANDA_SECTION_ATTR(NAME)
+#endif
+
+/* Assume cache line size of 64 for purposes of section alignment */
+#ifndef PANDA_ALIGN_SECTION
+#define PANDA_ALIGN_SECTION  __aligned(64)
+#endif
+
+#endif /* __PANDA_COMPILER_HELPERS_H__ */
diff --git a/include/net/panda/flag_fields.h b/include/net/panda/flag_fields.h
new file mode 100644
index 000000000000..406d653bf822
--- /dev/null
+++ b/include/net/panda/flag_fields.h
@@ -0,0 +1,369 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_FLAG_FIELDS_H__
+#define __PANDA_FLAG_FIELDS_H__
+
+/* Definitions and functions for processing and parsing flag-fields */
+
+#include <stddef.h>
+#include <stdbool.h>
+
+#include <linux/types.h>
+
+#include "net/panda/parser_types.h"
+
+/* Definitions for parsing flag-fields
+ *
+ * Flag-fields is a common networking protocol construct that encodes optional
+ * data in a set of flags and data fields. The flags indicate whether or not a
+ * corresponding data field is present. The data fields are fixed length per
+ * each flag-field definition and ordered by the ordering of the flags
+ * indicating the presence of the fields (e.g. GRE and GUE employ flag-fields)
+ */
+
+/* Flag-fields descriptors and tables
+ *
+ * A set of flag-fields is defined in a table of type struct panda_flag_fields.
+ * Each entry in the table is a descriptor for one flag-field in a protocol and
+ * includes a flag value, mask (for the case of a multi-bit flag), and size of
+ * the cooresponding field. A flag is matched if "(flags & mask) == flag"
+ */
+
+/* One descriptor for a flag
+ *
+ * flag: protocol value
+ * mask: mask to apply to field
+ * size: size for associated field data
+ */
+struct panda_flag_field {
+	__u32 flag;
+	__u32 mask;
+	size_t size;
+};
+
+/* Descriptor for a protocol field with flag fields
+ *
+ * Defines the flags and their data fields for one instance a flag field in
+ * in a protocol header (e.g. GRE v0 flags):
+ *
+ * num_idx: Number of flag_field structures
+ * fields: List of defined flag fields
+ */
+struct panda_flag_fields {
+	size_t num_idx;
+	struct panda_flag_field fields[];
+};
+
+/* Compute the length of optional fields present in a flags field */
+static inline size_t panda_flag_fields_length(__u32 flags,
+					      const struct panda_flag_fields
+							*flag_fields)
+{
+	size_t len = 0;
+	__u32 mask;
+	int i;
+
+	for (i = 0; i < flag_fields->num_idx; i++) {
+		mask = flag_fields->fields[i].mask ? :
+						flag_fields->fields[i].flag;
+
+		if ((flags & mask) == flag_fields->fields[i].flag)
+			len += flag_fields->fields[i].size;
+	}
+
+	return len;
+}
+
+static inline ssize_t __panda_flag_fields_offset(__u32 targ_idx, __u32 flags,
+						 const struct panda_flag_fields
+							*flag_fields)
+{
+	size_t offset = 0;
+	__u32 mask;
+	int i;
+
+	for (i = 0; i < targ_idx; i++) {
+		mask = flag_fields->fields[i].mask ? :
+						flag_fields->fields[i].flag;
+
+		if ((flags & mask) == flag_fields->fields[i].flag)
+			offset += flag_fields->fields[i].size;
+	}
+
+	return offset;
+}
+
+/* Determine offset of a field given a set of flags */
+static inline ssize_t panda_flag_fields_offset(__u32 targ_idx, __u32 flags,
+					       const struct panda_flag_fields
+							*flag_fields)
+{
+	__u32 mask;
+
+	mask = flag_fields->fields[targ_idx].mask ? :
+				flag_fields->fields[targ_idx].flag;
+	if ((flags & mask) != flag_fields->fields[targ_idx].flag) {
+		/* Flag not set */
+		return -1;
+	}
+
+	return __panda_flag_fields_offset(targ_idx, flags, flag_fields);
+}
+
+/* Check flags are legal */
+static inline bool panda_flag_fields_check_invalid(__u32 flags, __u32 mask)
+{
+	return !!(flags & ~mask);
+}
+
+/* Retrieve a byte value from a flag field */
+static inline __u8 panda_flag_fields_get8(const __u8 *fields, __u32 targ_idx,
+					  __u32 flags,
+					  const struct panda_flag_fields
+							*flag_fields)
+{
+	ssize_t offset = panda_flag_fields_offset(targ_idx, flags, flag_fields);
+
+	if (offset < 0)
+		return 0;
+
+	return *(__u8 *)&fields[offset];
+}
+
+/* Retrieve a short value from a flag field */
+static inline __u16 panda_flag_fields_get16(const __u8 *fields,
+					    __u32 targ_idx,
+					    __u32 flags,
+					    const struct panda_flag_fields
+							*flag_fields)
+{
+	ssize_t offset = panda_flag_fields_offset(targ_idx, flags, flag_fields);
+
+	if (offset < 0)
+		return 0;
+
+	return *(__u16 *)&fields[offset];
+}
+
+/* Retrieve a 32 bit value from a flag field */
+static inline __u32 panda_get_flag_field32(const __u8 *fields, __u32 targ_idx,
+					   __u32 flags,
+					   const struct panda_flag_fields
+							*flag_fields)
+{
+	ssize_t offset = panda_flag_fields_offset(targ_idx, flags, flag_fields);
+
+	if (offset < 0)
+		return 0;
+
+	return *(__u32 *)&fields[offset];
+}
+
+/* Retrieve a 64 bit value from a flag field */
+static inline __u64 panda_get_flag_field64(const __u8 *fields, __u32 targ_idx,
+					   __u32 flags,
+					   const struct panda_flag_fields
+							*flag_fields)
+{
+	ssize_t offset = panda_flag_fields_offset(targ_idx, flags, flag_fields);
+
+	if (offset < 0)
+		return 0;
+
+	return *(__u64 *)&fields[offset];
+}
+
+
+/* Structure or parsing operations for flag-fields
+ *
+ * flags_offset: Offset of flags in the protocol header
+ * start_fields_offset: Return the offset in the header of the start of the
+ *	flag fields data
+ */
+struct panda_proto_flag_fields_ops {
+	__u32 (*get_flags)(const void *hdr);
+	size_t (*start_fields_offset)(const void *hdr);
+};
+
+/* Flag-field parse node operations
+ *
+ * Operations to process a single flag-field
+ *
+ * extract_metadata: Extract metadata for the node. Input is the meta
+ *	data frame which points to a parser defined metadata structure.
+ *	If the value is NULL then no metadata is extracted
+ * handle_flag_field: Per flag-field handler which allows arbitrary processing
+ *	of a flag-field. Input is the flag-field data and a parser defined
+ *	metadata structure for the current frame. Return value is a parser
+ *	return code: PANDA_OKAY indicates no errors, PANDA_STOP* return
+ *	values indicate to stop parsing
+ */
+struct panda_parse_flag_field_node_ops {
+	void (*extract_metadata)(const void *hdr, void *frame,
+				 struct panda_ctrl_data ctrl);
+	int (*handle_flag_field)(const void *hdr, void *frame,
+				 struct panda_ctrl_data ctrl);
+};
+
+/* A parse node for a single flag field */
+struct panda_parse_flag_field_node {
+	const struct panda_parse_flag_field_node_ops ops;
+	const char *name;
+};
+
+/* One entry in a flag-fields protocol table:
+ *	index: flag-field index (index in a flag-fields table)
+ *	node: associated TLV parse structure for the type
+ */
+struct panda_proto_flag_fields_table_entry {
+	int index;
+	const struct panda_parse_flag_field_node *node;
+};
+
+/* Flag-fields table
+ *
+ * Contains a table that maps a flag-field index to a flag-field parse node.
+ * Note that the index correlates to an entry in a flag-fields table that
+ * describes the flag-fields of a protocol
+ */
+struct panda_proto_flag_fields_table {
+	int num_ents;
+	const struct panda_proto_flag_fields_table_entry *entries;
+};
+
+/* A flag-fields parse node. Note this is a super structure for a PANDA parse
+ * node and tyoe is PANDA_NODE_TYPE_FLAG_FIELDS
+ */
+struct panda_parse_flag_fields_node {
+	const struct panda_parse_node parse_node;
+	const struct panda_proto_flag_fields_table *flag_fields_proto_table;
+};
+
+/* A flag-fields protocol node. Note this is a super structure for a PANDA
+ * protocol node and tyoe is PANDA_NODE_TYPE_FLAG_FIELDS
+ */
+struct panda_proto_flag_fields_node {
+	struct panda_proto_node proto_node;
+	struct panda_proto_flag_fields_ops ops;
+	const struct panda_flag_fields *flag_fields;
+};
+
+/* Helper to create a flag-fields protocol table */
+#define PANDA_MAKE_FLAG_FIELDS_TABLE(NAME, ...)				\
+	static const struct panda_proto_flag_fields_table_entry		\
+					__##NAME[] =  { __VA_ARGS__ };	\
+	static const struct panda_proto_flag_fields_table NAME = {	\
+		.num_ents = sizeof(__##NAME) /				\
+			sizeof(struct					\
+				panda_proto_flag_fields_table_entry),	\
+		.entries = __##NAME,					\
+	}
+
+/* Forward declarations for flag-fields parse nodes */
+#define PANDA_DECL_FLAG_FIELDS_PARSE_NODE(FLAG_FIELDS_PARSE_NODE)	\
+	static const struct panda_parse_flag_fields_node		\
+						FLAG_FIELDS_PARSE_NODE
+
+/* Forward declarations for flag-field proto tables */
+#define PANDA_DECL_FLAG_FIELDS_TABLE(FLAG_FIELDS_TABLE)			\
+	static const struct panda_proto_flag_fields_table		\
+						FLAG_FIELDS_TABLE
+
+
+/* Helper to create a parse node with a next protocol table */
+#define __PANDA_MAKE_FLAG_FIELDS_PARSE_NODE(PARSE_FLAG_FIELDS_NODE,	\
+					    PROTO_FLAG_FIELDS_NODE,	\
+					    EXTRACT_METADATA, HANDLER,	\
+					    WILDCARD_NODE,		\
+					    PROTO_TABLE,		\
+					    FLAG_FIELDS_TABLE)		\
+	static const struct panda_parse_flag_fields_node		\
+					PARSE_FLAG_FIELDS_NODE = {	\
+		.flag_fields_proto_table = FLAG_FIELDS_TABLE,		\
+		.parse_node.node_type = PANDA_NODE_TYPE_FLAG_FIELDS,	\
+		.parse_node.proto_node =				\
+				&PROTO_FLAG_FIELDS_NODE.proto_node,	\
+		.parse_node.ops.extract_metadata = EXTRACT_METADATA,	\
+		.parse_node.ops.handle_proto = HANDLER,			\
+		.parse_node.wildcard_node = WILDCARD_NODE,		\
+		.parse_node.proto_table = PROTO_TABLE,			\
+	}
+
+/* Helper to create a flag-fields parse node */
+#define PANDA_MAKE_FLAG_FIELDS_PARSE_NODE(PARSE_FLAG_FIELDS_NODE,	\
+					  PROTO_FLAG_FIELDS_NODE,	\
+					  EXTRACT_METADATA, HANDLER,	\
+					  PROTO_TABLE,			\
+					  FLAG_FIELDS_TABLE)		\
+	PANDA_DECL_FLAG_FIELDS_TABLE(FLAG_FIELDS_TABLE);		\
+	PANDA_DECL_PROTO_TABLE(PROTO_TABLE);				\
+	__PANDA_MAKE_FLAG_FIELDS_PARSE_NODE(PARSE_FLAG_FIELDS_NODE,	\
+					    PROTO_FLAG_FIELDS_NODE,	\
+					    EXTRACT_METADATA, HANDLER,	\
+					    NULL, &PROTO_TABLE,		\
+					    &FLAG_FIELDS_TABLE)
+
+/* Helper to create an overlay flag-fields parse node */
+#define PANDA_MAKE_FLAG_FIELDS_OVERLAY_PARSE_NODE(			\
+					PARSE_FLAG_FIELDS_NODE,		\
+					PROTO_FLAG_FIELDS_NODE,		\
+					EXTRACT_METADATA, HANDLER,	\
+					OVERLAY_NODE,			\
+					FLAG_FIELDS_TABLE)		\
+	PANDA_DECL_FLAG_FIELDS_TABLE(FLAG_FIELDS_TABLE);		\
+	__PANDA_MAKE_FLAG_FIELDS_PARSE_NODE(PARSE_FLAG_FIELDS_NODE,	\
+					    PROTO_FLAG_FIELDS_NODE,	\
+					    EXTRACT_METADATA, HANDLER,	\
+					    OVERLAY_NODE, NULL,		\
+					    &FLAG_FIELDS_TABLE)		\
+
+/* Helper to create a leaf flag-fields parse node */
+#define PANDA_MAKE_LEAF_FLAG_FIELDS_PARSE_NODE(PARSE_FLAG_FIELDS_NODE,	\
+					       PROTO_FLAG_FIELDS_NODE,	\
+					       EXTRACT_METADATA,	\
+					       HANDLER,			\
+					       FLAG_FIELDS_TABLE)	\
+	PANDA_DECL_FLAG_FIELDS_TABLE(FLAG_FIELDS_TABLE);		\
+	__PANDA_MAKE_FLAG_FIELDS_PARSE_NODE(PARSE_FLAG_FIELDS_NODE,	\
+					    PROTO_FLAG_FIELDS_NODE,	\
+					    EXTRACT_METADATA, HANDLER,	\
+					    NULL, NULL,			\
+					    &FLAG_FIELDS_TABLE)
+
+/* Helper to create a parse node for a single flag-field */
+#define PANDA_MAKE_FLAG_FIELD_PARSE_NODE(NODE_NAME, METADATA_FUNC,	\
+					 HANDLER_FUNC)			\
+	static const struct panda_parse_flag_field_node NODE_NAME = {	\
+		.ops.extract_metadata = METADATA_FUNC,			\
+		.ops.handle_flag_field = HANDLER_FUNC,			\
+		.name = #NODE_NAME,					\
+	}
+
+/* Null flag-field node for filling out flag-fields table */
+PANDA_MAKE_FLAG_FIELD_PARSE_NODE(PANDA_FLAG_NODE_NULL, NULL, NULL);
+
+#endif /* __PANDA_FLAG_FIELDS_H__ */
diff --git a/include/net/panda/parser.h b/include/net/panda/parser.h
new file mode 100644
index 000000000000..a3e572eef40b
--- /dev/null
+++ b/include/net/panda/parser.h
@@ -0,0 +1,394 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PARSER_H__
+#define __PANDA_PARSER_H__
+
+/* Parser interface for PANDA
+ *
+ * Definitions and functions for PANDA parser.
+ */
+
+#include <linux/types.h>
+
+#include "net/panda/compiler_helpers.h"
+#include "net/panda/flag_fields.h"
+#include "net/panda/parser_types.h"
+#include "net/panda/tlvs.h"
+
+/* Panda parser return codes */
+enum {
+	PANDA_OKAY = 0,			/* Okay and continue */
+	PANDA_STOP_OKAY = -1,		/* Okay and stop parsing */
+
+	/* Parser failure */
+	PANDA_STOP_FAIL = -2,
+	PANDA_STOP_LENGTH = -3,
+	PANDA_STOP_UNKNOWN_PROTO = -4,
+	PANDA_STOP_ENCAP_DEPTH = -5,
+	PANDA_STOP_UNKNOWN_TLV = -6,
+	PANDA_STOP_TLV_LENGTH = -7,
+	PANDA_STOP_BAD_FLAG = -8,
+};
+
+/* Helper to create a parser */
+#define __PANDA_PARSER(PARSER, NAME, ROOT_NODE)				\
+static const struct panda_parser __##PARSER = {				\
+	.name = NAME,							\
+	.root_node = ROOT_NODE,						\
+	.parser_type = PANDA_GENERIC,					\
+	.parser_entry_point = NULL					\
+};									\
+
+#define PANDA_PARSER(PARSER, NAME, ROOT_NODE)				\
+	__PANDA_PARSER(PARSER, NAME, ROOT_NODE)				\
+	static const struct panda_parser *PARSER __unused() =		\
+							&__##PARSER;
+
+#define PANDA_PARSER_EXT(PARSER, NAME, ROOT_NODE)			\
+	__PANDA_PARSER(PARSER, NAME, ROOT_NODE)				\
+	const struct panda_parser *PARSER __unused() = &__##PARSER;
+
+/* Helper to create an optimized parservairant */
+#define __PANDA_PARSER_OPT(PARSER, NAME, ROOT_NODE, FUNC)		\
+static const struct panda_parser __##PARSER = {				\
+	.name = NAME,							\
+	.root_node = ROOT_NODE,						\
+	.parser_type = PANDA_OPTIMIZED,					\
+	.parser_entry_point = FUNC					\
+};
+
+/* Helpers to create and use Kmod parser vairant */
+#define __PANDA_PARSER_KMOD(PARSER, NAME, ROOT_NODE, FUNC)		\
+const struct panda_parser __##PARSER##_kmod = {				\
+	.name = NAME,							\
+	.root_node = ROOT_NODE,						\
+	.parser_type = PANDA_KMOD,					\
+	.parser_entry_point = FUNC					\
+};
+
+#define PANDA_PARSER_KMOD(PARSER, NAME, ROOT_NODE, FUNC)		\
+	__PANDA_PARSER_KMOD(PARSER, NAME, ROOT_NODE, FUNC)		\
+	const struct panda_parser *PARSER##_kmod = &__##PARSER##_kmod;
+
+#define PANDA_PARSER_KMOD_EXTERN(NAME)					\
+	extern const struct panda_parser *NAME##_kmod
+
+#define PANDA_PARSER_KMOD_NAME(NAME) NAME##_kmod
+
+#define PANDA_PARSER_OPT(PARSER, NAME, ROOT_NODE, FUNC)			\
+	__PANDA_PARSER_OPT(PARSER, NAME, ROOT_NODE, FUNC)		\
+	static const struct panda_parser *PARSER __unused() =		\
+							&__##PARSER;
+
+#define PANDA_PARSER_OPT_EXT(PARSER, NAME, ROOT_NODE, FUNC)		\
+	__PANDA_PARSER_OPT(PARSER, NAME, ROOT_NODE, FUNC)		\
+	const struct panda_parser *PARSER __unused() = &__##PARSER;
+
+/* Helper to create an XDP parser vairant */
+#define __PANDA_PARSER_XDP(PARSER, NAME, ROOT_NODE, FUNC)		\
+static const struct panda_parser __##PARSER = {				\
+	.name = NAME,							\
+	.root_node = ROOT_NODE,						\
+	.parser_type = PANDA_XDP,					\
+	.parser_xdp_entry_point = FUNC					\
+};
+
+#define PANDA_PARSER_XDP(PARSER, NAME, ROOT_NODE, FUNC)			\
+	__PANDA_PARSER_XDP(PARSER, NAME, ROOT_NODE, FUNC)		\
+	static const struct panda_parser *__##PARSER##_ext =		\
+							&__##PARSER;
+
+#define PANDA_PARSER_XDP_EXT(PARSER, NAME, ROOT_NODE, FUNC)		\
+	__PANDA_PARSER_XDP(PARSER, NAME, ROOT_NODE, FUNC)		\
+	const struct panda_parser *__##PARSER##_ext = &__##PARSER;
+
+/* Helper to create a parser table */
+#define PANDA_MAKE_PARSER_TABLE(NAME, ...)				\
+	static const struct panda_parser_table_entry __##NAME[] =	\
+						{ __VA_ARGS__ };	\
+	static const struct panda_parser_table NAME =	{		\
+		.num_ents = sizeof(__##NAME) /				\
+			sizeof(struct panda_parser_table_entry),	\
+		.entries = __##NAME,					\
+	}
+
+/* Helper to create a protocol table */
+#define PANDA_MAKE_PROTO_TABLE(NAME, ...)				\
+	static const struct panda_proto_table_entry __##NAME[] =	\
+						{ __VA_ARGS__ };	\
+	static const struct panda_proto_table NAME =	{		\
+		.num_ents = sizeof(__##NAME) /				\
+				sizeof(struct panda_proto_table_entry),	\
+		.entries = __##NAME,					\
+	}
+
+/* Forward declarations for parse nodes */
+#define PANDA_DECL_PARSE_NODE(PARSE_NODE)				\
+	static const struct panda_parse_node PARSE_NODE
+
+/* Forward declarations for protocol tables */
+#define PANDA_DECL_PROTO_TABLE(PROTO_TABLE)				\
+	static const struct panda_proto_table PROTO_TABLE
+
+/* Helper to create a parse node with a next protocol table */
+#define __PANDA_MAKE_PARSE_NODE(PARSE_NODE, PROTO_NODE,			\
+				EXTRACT_METADATA, HANDLER,		\
+				UNKNOWN_RET, WILDCARD_NODE,		\
+				PROTO_TABLE)				\
+	static const struct panda_parse_node PARSE_NODE = {		\
+		.proto_node = &PROTO_NODE,				\
+		.ops.extract_metadata = EXTRACT_METADATA,		\
+		.ops.handle_proto = HANDLER,				\
+		.unknown_ret = UNKNOWN_RET,				\
+		.wildcard_node = WILDCARD_NODE,				\
+		.proto_table = PROTO_TABLE,				\
+	}
+
+/* Helper to create a parse node with default unknown next proto function
+ * that returns parser failure code
+ */
+#define PANDA_MAKE_PARSE_NODE(PARSE_NODE, PROTO_NODE,			\
+			      EXTRACT_METADATA, HANDLER, PROTO_TABLE)	\
+	PANDA_DECL_PROTO_TABLE(PROTO_TABLE);				\
+	__PANDA_MAKE_PARSE_NODE(PARSE_NODE, PROTO_NODE,			\
+				EXTRACT_METADATA, HANDLER,		\
+				PANDA_STOP_UNKNOWN_PROTO, NULL,		\
+				&PROTO_TABLE)
+
+/* Helper to create a parse node single overlay node */
+#define PANDA_MAKE_OVERLAY_PARSE_NODE(PARSE_NODE, PROTO_NODE,		\
+			      EXTRACT_METADATA, HANDLER, OVERLAY_NODE)	\
+	__PANDA_MAKE_PARSE_NODE(PARSE_NODE, PROTO_NODE,			\
+				EXTRACT_METADATA, HANDLER,		\
+				PANDA_STOP_UNKNOWN_PROTO, OVERLAY_NODE,	\
+				NULL)
+
+/* Helper to create a leaf parse node with no next protocol table */
+#define PANDA_MAKE_LEAF_PARSE_NODE(PARSE_NODE, PROTO_NODE,		\
+				   EXTRACT_METADATA, HANDLER)		\
+	__PANDA_MAKE_PARSE_NODE(PARSE_NODE, PROTO_NODE,			\
+				EXTRACT_METADATA, HANDLER,		\
+				PANDA_STOP_UNKNOWN_PROTO, NULL,		\
+				NULL)
+
+/* Parsing functions */
+
+/* Flags to Panda parser functions */
+#define PANDA_F_DEBUG			(1 << 0)
+
+#ifndef __KERNEL__
+/* Parse starting at the provided root node */
+int __panda_parse(const struct panda_parser *parser, const void *hdr,
+		  size_t len, struct panda_metadata *metadata,
+		  unsigned int flags, unsigned int max_encaps);
+#else
+static inline int __panda_parse(const struct panda_parser *parser,
+		  const void *hdr, size_t len, struct panda_metadata *metadata,
+		  unsigned int flags, unsigned int max_encaps)
+{
+	return 0;
+}
+#endif
+
+/* Parse packet starting from a parser node
+ *
+ * Arguments:
+ *	- parser: Parser being invoked
+ *	- hdr: pointer to start of packet
+ *	- len: length of packet
+ *	- metadata: metadata structure
+ *	- flags: allowed parameterized parsing
+ *	- max_encaps: maximum layers of encapsulation to parse
+ *
+ * Returns PANDA return code value.
+ */
+static inline int panda_parse(const struct panda_parser *parser,
+			      const void *hdr, size_t len,
+			      struct panda_metadata *metadata,
+			      unsigned int flags, unsigned int max_encaps)
+{
+	switch (parser->parser_type) {
+	case PANDA_GENERIC:
+		return __panda_parse(parser, hdr, len, metadata, flags,
+				     max_encaps);
+	case PANDA_KMOD:
+	case PANDA_OPTIMIZED:
+		return (parser->parser_entry_point)(parser, hdr, len, metadata,
+						    flags, max_encaps);
+	default:
+		return PANDA_STOP_FAIL;
+	}
+}
+
+extern int panda_parse_ethernet(const void *hdr, size_t len,
+			 struct panda_metadata *metadata,
+			 unsigned int flags, unsigned int max_encaps);
+
+static inline const struct panda_parser *panda_lookup_parser_table(
+				const struct panda_parser_table *table,
+				int key)
+{
+	int i;
+
+	for (i = 0; i < table->num_ents; i++)
+		if (table->entries[i].value == key)
+			return *table->entries[i].parser;
+
+	return NULL;
+}
+
+static inline int panda_parse_from_table(const struct panda_parser_table *table,
+					 int key, const void *hdr, size_t len,
+					 struct panda_metadata *metadata,
+					 unsigned int flags,
+					 unsigned int max_encaps)
+{
+	const struct panda_parser *parser;
+
+	if (!(parser = panda_lookup_parser_table(table, key)))
+		return PANDA_STOP_FAIL;
+
+	return panda_parse(parser, hdr, len, metadata, flags, max_encaps);
+}
+
+
+static inline int panda_parse_xdp(const struct panda_parser *parser,
+				  struct panda_ctx *ctx, const void **hdr,
+				  const void *hdr_end, bool tailcall)
+{
+	if (parser->parser_type != PANDA_XDP)
+		return PANDA_STOP_FAIL;
+
+	return (parser->parser_xdp_entry_point)(ctx, hdr, hdr_end, tailcall);
+}
+
+#define PANDA_PARSE_XDP(PARSER, CTX, HDR, HDR_END, TAILCALL)		\
+	panda_xdp_parser_##PARSER(CTX, HDR, HDR_END, TAILCALL)
+
+/* Helper to make an extern for a parser */
+#define PANDA_PARSER_EXTERN(NAME)					\
+	extern struct panda_parser *NAME
+
+/* Helper to make forward declaration for a const parser */
+#define PANDA_PARSER_DECL(NAME)						\
+	static const struct panda_parser *NAME
+
+#define PANDA_PARSER_EXT_DECL(NAME)					\
+	extern const struct panda_parser *NAME
+
+struct panda_parser_def {
+	struct panda_parser **parser;
+	const char *name;
+	const struct panda_parse_node *root_node;
+	enum panda_parser_type parser_type;
+	panda_parser_opt_entry_point parser_entry_point;
+} PANDA_ALIGN_SECTION;
+
+PANDA_DEFINE_SECTION(panda_parsers, struct panda_parser_def)
+
+/* Helper to add parser to list of parser at initialization */
+#define PANDA_PARSER_ADD(PARSER, NAME, ROOT_NODE)			\
+struct panda_parser *PARSER;						\
+static const struct panda_parser_def PANDA_SECTION_ATTR(panda_parsers)	\
+			PANDA_UNIQUE_NAME(__panda_parsers_,) = {	\
+	.parser = &PARSER,						\
+	.name = NAME,							\
+	.root_node = ROOT_NODE,						\
+	.parser_type = PANDA_GENERIC,					\
+}
+
+/* Helper to add parser to list of parser at initialization */
+#define PANDA_PARSER_OPT_ADD(PARSER, NAME, ROOT_NODE, FUNC)		\
+struct panda_parser *PARSER;						\
+static const struct panda_parser_def PANDA_SECTION_ATTR(panda_parsers)	\
+			PANDA_UNIQUE_NAME(__panda_parsers_,) = {	\
+	.parser = &PARSER,						\
+	.name = NAME,							\
+	.root_node = ROOT_NODE,						\
+	.parser_type = PANDA_OPTIMIZED,					\
+	.parser_entry_point = FUNC					\
+}
+
+
+struct panda_parser *panda_parser_create(const char *name,
+					 const struct panda_parse_node
+								*root_node);
+void panda_parser_destroy(struct panda_parser *parser);
+int panda_parser_init(void);
+
+#ifndef __KERNEL__
+
+extern siphash_key_t __panda_hash_key;
+
+/* Helper functions to compute the siphash from start pointer
+ * through len bytes. Note that siphash library expects start to
+ * be aligned to 64 bits
+ */
+static inline __u32 panda_compute_hash(const void *start, size_t len)
+{
+	__u32 hash;
+
+	hash = siphash(start, len, &__panda_hash_key);
+	if (!hash)
+		hash = 1;
+
+	return hash;
+}
+
+/* Helper macro to compute a hash from a metadata structure. METADATA
+ * is a pointer to a metadata structure and HASH_START_FIELD is the offset
+ * within the structure to start the hash. This macro requires that the
+ * common metadata for IP addresses is defined in the metadata structure,
+ * that is there is an addrs field of type PANDA_METADATA_addrs in the
+ * metadata structure. The end offset of the hash area is the last byte
+ * of the addrs structure which can be different depending on the type
+ * of address (for instance, IPv6 addresses have more bytes than IPv4
+ * addresses so the length of the bytes hashed area will be greater).
+ */
+#define PANDA_COMMON_COMPUTE_HASH(METADATA, HASH_START_FIELD) ({	\
+	__u32 hash;							\
+	const void *start = PANDA_HASH_START(METADATA,			\
+					     HASH_START_FIELD);		\
+	size_t olen = PANDA_HASH_LENGTH(METADATA,			\
+				offsetof(typeof(*METADATA),		\
+				HASH_START_FIELD));			\
+									\
+	hash = panda_compute_hash(start, olen);				\
+	hash;								\
+})
+
+/* Initialization function for hash key. If the argument is NULL the
+ * hash key is randomly set
+ */
+void panda_hash_secret_init(siphash_key_t *init_key);
+
+/* Function to print the raw bytesused in a hash */
+void panda_print_hash_input(const void *start, size_t len);
+
+#endif /* __KERNEL__ */
+
+#endif /* __PANDA_PARSER_H__ */
diff --git a/include/net/panda/parser_metadata.h b/include/net/panda/parser_metadata.h
new file mode 100644
index 000000000000..ba6f76549438
--- /dev/null
+++ b/include/net/panda/parser_metadata.h
@@ -0,0 +1,873 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PARSER_METADATA_H__
+#define __PANDA_PARSER_METADATA_H__
+
+/* Helper definitions for PANDA parser metadata handling
+ *
+ * This defines a set of macros, constants, and functions that can be
+ * optionally used in constructing parse nodes and to assist in meta
+ * data handling as well as packet hashing.
+ */
+
+#ifndef __KERNEL__
+#include <string.h>
+#endif
+
+#include <linux/if_ether.h>
+#include <linux/mpls.h>
+
+#include "net/panda/parser.h"
+
+/* The PANDA helpers defines a common set of fields that may be used in
+ * parser specific metadata structures. This is done at the granularity of
+ * field names. When the common names and their types are used in meta
+ * data structure then helper marcos can be used to create functions
+ * that take the parser specific data structure as an argument but
+ * operate on the common fields. In this way we can essentially have
+ * the same functions operate on different input structures, in particular
+ * we can define per protocol macros that extract common fields into
+ * different metadata structures. The type of the structure is an argument
+ * to the macro, and then from that a function definition can be ommited that
+ * uses the type. Here is an example to extract common metadata for IPv4
+ * into a user defined metadata structure.
+ *
+ * #define PANDA_METADATA_ipv4_addrs(NAME, STRUCT)			\
+ * static void NAME(const void *viph, void *iframe)			\
+ * {									\
+ *	struct STRUCT *frame = iframe;					\
+ *	const struct iphdr *iph = viph;					\
+ *									\
+ *       frame->addr_type = PANDA_ADDR_TYPE_IPV4;			\
+ *       frame->ip_proto = iph->protocol;				\
+ *       memcpy(frame->addrs.v4_addrs, &iph->saddr,			\
+ *              sizeof(frame->addrs.v4_addrs));				\
+ * }
+ *
+ * In this example the common metadata field names used are addr_type,
+ * addrs.v4, and ip_proto.
+ *
+ * #defines for metadata names and their types are below. Note the macros
+ * can be used to define the common metadata fields in a data structure,
+ * however this is not required. As long as the types and names are
+ * maintained differnt definitions may be used. This is particulary relevant
+ * when common names are in data structures and the user may wish to add
+ * other elements in the structure
+ */
+
+/* Common metadata names and macro definitions. Add new common meta
+ * data names to this list
+ */
+
+#define PANDA_METADATA_eth_proto	__be16	eth_proto
+#define PANDA_METADATA_eth_addrs	__u8 eth_addrs[2 * ETH_ALEN]
+#define PANDA_TCP_MAX_SACKS	4
+
+enum panda_addr_types {
+	PANDA_ADDR_TYPE_INVALID = 0, /* Invalid addr type */
+	PANDA_ADDR_TYPE_IPV4,
+	PANDA_ADDR_TYPE_IPV6,
+	PANDA_ADDR_TYPE_TIPC,
+};
+
+#define	PANDA_METADATA_addr_type	__u8 addr_type
+#define PANDA_METADATA_addrs						\
+	union {								\
+		union {							\
+			__be32		v4_addrs[2];			\
+			struct {					\
+				__be32	saddr;				\
+				__be32	daddr;				\
+			} v4;						\
+		};							\
+		union {							\
+			struct in6_addr v6_addrs[2];			\
+			struct {					\
+				struct in6_addr saddr;			\
+				struct in6_addr daddr;			\
+			} v6;						\
+		};							\
+		__be32		tipckey;				\
+	} addrs
+
+#define	PANDA_METADATA_ip_proto	__u8 ip_proto
+#define	PANDA_METADATA_is_fragment	__u8 is_fragment: 1
+#define	PANDA_METADATA_first_frag	__u8 first_frag: 1
+
+#define PANDA_METADATA_flow_label	__u32 flow_label
+
+#define PANDA_METADATA_l2_off		__u16 l2_off
+#define PANDA_METADATA_l3_off		__u16 l3_off
+#define PANDA_METADATA_l4_off		__u16 l4_off
+
+#define PANDA_METADATA_ports						\
+	union {								\
+		__be32 ports;						\
+		__be16 port16[2];					\
+		struct {						\
+			__be16 src_port;				\
+			__be16 dst_port;				\
+		};							\
+		struct {						\
+			__be16 sport;					\
+			__be16 dport;					\
+		} port_pair;						\
+	}
+
+#define PANDA_METADATA_tcp_options					\
+	struct {							\
+		__u16 mss;						\
+		__u8 window_scaling;					\
+		struct {						\
+			__u32 value;					\
+			__u32 echo;					\
+		} timestamp;						\
+		struct {						\
+			__u32 left_edge;				\
+			__u32 right_edge;				\
+		} sack[PANDA_TCP_MAX_SACKS];					\
+	} tcp_options
+
+#define PANDA_METADATA_keyid		__be32  keyid
+
+#define PANDA_MAX_VLAN_CNT	2
+#define PANDA_METADATA_vlan_count	__u8 vlan_count : 2
+#define PANDA_METADATA_vlan						\
+	struct {							\
+		union {							\
+			struct {					\
+				__u16   id:12,				\
+					dei:1,				\
+					priority:3;			\
+			};						\
+			__be16  tci;					\
+		};							\
+		__be16  tpid;						\
+	} vlan[PANDA_MAX_VLAN_CNT]
+
+#define PANDA_METADATA_icmp						\
+	struct {							\
+		__u8	type;						\
+		__u8	code;						\
+		__u16	id;						\
+	} icmp
+
+#define PANDA_METADATA_mpls						\
+	struct {							\
+		__u32	ttl: 8;						\
+		__u32	bos: 1;						\
+		__u32	tc: 3;						\
+		__u32	label: 20;					\
+	} mpls
+
+#define PANDA_METADATA_arp						\
+	struct {							\
+		__u32	sip;						\
+		__u32	tip;						\
+		__u8	op;						\
+		__u8	sha[ETH_ALEN];					\
+		__u8	tha[ETH_ALEN];					\
+	} arp
+
+#define PANDA_METADATA_gre						\
+	struct {							\
+		__u32 flags;						\
+		__be16 csum;						\
+		__be32 keyid;						\
+		__be32 seq;						\
+		__be32 routing;						\
+	} gre
+
+#define PANDA_METADATA_gre_pptp						\
+	struct {							\
+		__u32 flags;						\
+		__be16 length;						\
+		__be16 callid;						\
+		__be32 seq;						\
+		__be32 ack;						\
+	} gre_pptp
+
+/* Meta data structure containing all common metadata in canonical field
+ * order. eth_proto is declared as the hash start field for the common
+ * metadata structure. addrs is last field for canonical hashing.
+ */
+struct panda_metadata_all {
+	PANDA_METADATA_addr_type;
+	PANDA_METADATA_is_fragment;
+	PANDA_METADATA_first_frag;
+	PANDA_METADATA_vlan_count;
+	PANDA_METADATA_eth_addrs;
+	PANDA_METADATA_tcp_options;
+	PANDA_METADATA_mpls;
+	PANDA_METADATA_arp;
+	PANDA_METADATA_gre;
+	PANDA_METADATA_gre_pptp;
+	PANDA_METADATA_l2_off;
+	PANDA_METADATA_l3_off;
+	PANDA_METADATA_l4_off;
+
+
+#define PANDA_HASH_START_FIELD_ALL eth_proto
+	PANDA_METADATA_eth_proto __aligned(8);
+	PANDA_METADATA_ip_proto;
+	PANDA_METADATA_flow_label;
+	PANDA_METADATA_vlan;
+	PANDA_METADATA_keyid;
+	PANDA_METADATA_ports;
+	PANDA_METADATA_icmp;
+
+	PANDA_METADATA_addrs; /* Must be last */
+};
+
+#define PANDA_HASH_OFFSET_ALL					\
+	offsetof(struct panda_metadata_all,			\
+		 PANDA_HASH_START_FIELD_ALL)
+
+/* Template for hash consistentify. Sort the source and destination IP (and the
+ * ports if the IP address are the same) to have consistent hash within the two
+ * directions.
+ */
+#define PANDA_HASH_CONSISTENTIFY(FRAME) do {				\
+	int addr_diff, i;						\
+									\
+	switch ((FRAME)->addr_type) {					\
+	case PANDA_ADDR_TYPE_IPV4:					\
+		addr_diff = (FRAME)->addrs.v4_addrs[1] -		\
+					(FRAME)->addrs.v4_addrs[0];	\
+		if ((addr_diff < 0) ||					\
+		    (addr_diff == 0 && ((FRAME)->port16[1] <		\
+					(FRAME)->port16[0]))) {		\
+			PANDA_SWAP((FRAME)->addrs.v4_addrs[0],		\
+				   (FRAME)->addrs.v4_addrs[1]);		\
+			PANDA_SWAP((FRAME)->port16[0],			\
+				   (FRAME)->port16[1]);			\
+		}							\
+		break;							\
+	case PANDA_ADDR_TYPE_IPV6:					\
+		addr_diff = memcmp(&(FRAME)->addrs.v6_addrs[1],		\
+				   &(FRAME)->addrs.v6_addrs[0],		\
+				   sizeof((FRAME)->addrs.v6_addrs[1]));	\
+		if ((addr_diff < 0) ||					\
+		    (addr_diff == 0 && ((FRAME)->port16[1] <		\
+					(FRAME)->port16[0]))) {		\
+			for (i = 0; i < 4; i++)				\
+				PANDA_SWAP((FRAME)->addrs.v6_addrs[0].	\
+							s6_addr32[i],	\
+				     (FRAME)->addrs.v6_addrs[1].	\
+							s6_addr32[i]);	\
+			PANDA_SWAP((FRAME)->port16[0],			\
+				   (FRAME)->port16[1]);			\
+		}							\
+		break;							\
+	}								\
+} while (0)
+
+/* Helper to get starting address for hash start. This is just the
+ * address of the field name in HASH_START_FIELD of a metadata
+ * structure instance (indicated by pointer in FRAME)
+ */
+#define PANDA_HASH_START(FRAME, HASH_START_FIELD)			\
+	(&(FRAME)->HASH_START_FIELD)
+
+/* Helper that returns the hash length for a metadata structure. This
+ * returns the end of the address fields for the given type (the
+ * address fields are assumed to be the common metadata fields in a nion
+ * in the last fields in the metadata structure). The macro returns the
+ * offset of the last byte of address minus the offset of the field
+ * where the hash starts as indicated by the HASH_OFFSET argument.
+ */
+#define PANDA_HASH_LENGTH(FRAME, HASH_OFFSET) ({			\
+	size_t diff = HASH_OFFSET + sizeof((FRAME)->addrs);		\
+									\
+	switch ((FRAME)->addr_type) {					\
+	case PANDA_ADDR_TYPE_IPV4:					\
+		diff -= sizeof((FRAME)->addrs.v4_addrs);		\
+		break;							\
+	case PANDA_ADDR_TYPE_IPV6:					\
+		diff -= sizeof((FRAME)->addrs.v6_addrs);		\
+		break;							\
+	}								\
+	sizeof(*(FRAME)) - diff;					\
+})
+
+/* Helpers to extract common metadata */
+
+/* Meta data helper for Ethernet.
+ * Uses common metadata fields: eth_proto, eth_addrs
+ */
+#define PANDA_METADATA_TEMP_ether(NAME, STRUCT)				\
+static void NAME(const void *veth, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+									\
+	frame->eth_proto = ((struct ethhdr *)veth)->h_proto;		\
+	memcpy(frame->eth_addrs, &((struct ethhdr *)veth)->h_dest,	\
+	       sizeof(frame->eth_addrs));				\
+}
+
+/* Meta data helper for Ethernet with setting L2 offset.
+ * Uses common metadata fields: eth_proto, eth_addrs, l2_off
+ */
+#define PANDA_METADATA_TEMP_ether_off(NAME, STRUCT)			\
+static void NAME(const void *veth, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+									\
+	frame->l2_off = ctrl.hdr_offset;				\
+	frame->eth_proto = ((struct ethhdr *)veth)->h_proto;		\
+	memcpy(frame->eth_addrs, &((struct ethhdr *)veth)->h_dest,	\
+	       sizeof(frame->eth_addrs));				\
+}
+
+/* Meta data helper for Ethernet without extracting addresses.
+ * Uses common metadata fields: eth_proto
+ */
+#define PANDA_METADATA_TEMP_ether_noaddrs(NAME, STRUCT)			\
+static void NAME(const void *veth, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+									\
+	frame->eth_proto = ((struct ethhdr *)veth)->h_proto;		\
+}
+
+/* Meta data helper for IPv4.
+ * Uses common metadata fields: is_fragment, first_frag, ip_proto,
+ * addr_type, addrs.v4_addrs, l3_off
+ */
+#define PANDA_METADATA_TEMP_ipv4(NAME, STRUCT)				\
+static void NAME(const void *viph, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+	const struct iphdr *iph = viph;					\
+									\
+	if (ip_is_fragment(iph)) {					\
+		frame->is_fragment = 1;					\
+		frame->first_frag =					\
+				!(iph->frag_off & htons(IP_OFFSET));	\
+	}								\
+									\
+	frame->l3_off = ctrl.hdr_offset;				\
+	frame->addr_type = PANDA_ADDR_TYPE_IPV4;			\
+	frame->ip_proto = iph->protocol;				\
+	memcpy(frame->addrs.v4_addrs, &iph->saddr,			\
+	       sizeof(frame->addrs.v4_addrs));				\
+}
+
+/* Meta data helper for IPv4 to only extract IP address.
+ * Uses common meta * data fields: ip_proto, addr_type, addrs.v4_addrs
+ */
+#define PANDA_METADATA_TEMP_ipv4_addrs(NAME, STRUCT)			\
+static void NAME(const void *viph, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+	const struct iphdr *iph = viph;					\
+									\
+	frame->addr_type = PANDA_ADDR_TYPE_IPV4;			\
+	frame->ip_proto = iph->protocol;				\
+	memcpy(frame->addrs.v4_addrs, &iph->saddr,			\
+	       sizeof(frame->addrs.v4_addrs));				\
+}
+
+/* Meta data helper for IPv6.
+ * Uses common metadata fields: ip_proto, addr_type, flow_label,
+ * addrs.v6_addrs, l3_off
+ */
+#define PANDA_METADATA_TEMP_ipv6(NAME, STRUCT)				\
+static void NAME(const void *viph, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+	const struct ipv6hdr *iph = viph;				\
+									\
+	frame->l3_off = ctrl.hdr_offset;				\
+	frame->ip_proto = iph->nexthdr;					\
+	frame->addr_type = PANDA_ADDR_TYPE_IPV6;			\
+	frame->flow_label = ntohl(ip6_flowlabel(iph));			\
+	memcpy(frame->addrs.v6_addrs, &iph->saddr,			\
+	       sizeof(frame->addrs.v6_addrs));				\
+}
+
+/* Meta data helper for IPv6 to only extract IP address.
+ * Uses common metadata fields: ip_proto, addr_type, addrs.v6_addrs
+ */
+#define PANDA_METADATA_TEMP_ipv6_addrs(NAME, STRUCT)			\
+static void NAME(const void *viph, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+	const struct ipv6hdr *iph = viph;				\
+									\
+	frame->ip_proto = iph->nexthdr;					\
+	frame->addr_type = PANDA_ADDR_TYPE_IPV6;			\
+	memcpy(frame->addrs.v6_addrs, &iph->saddr,			\
+	       sizeof(frame->addrs.v6_addrs));				\
+}
+
+/* Meta data helper for transport ports.
+ * Uses common metadata fields: ports
+ */
+#define PANDA_METADATA_TEMP_ports(NAME, STRUCT)				\
+static void NAME(const void *vphdr, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+									\
+	frame->ports = ((struct port_hdr *)vphdr)->ports;		\
+}
+
+/* Meta data helper for transport with ports and offset
+ * Uses common metadata fields: ports, l4_off
+ */
+#define PANDA_METADATA_TEMP_ports_off(NAME, STRUCT)			\
+static void NAME(const void *vphdr, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+									\
+	frame->ports = ((struct port_hdr *)vphdr)->ports;		\
+	frame->l4_off = ctrl.hdr_offset;				\
+}
+
+/* Meta data helpers for TCP options */
+
+/* Meta data helper for TCP MSS option
+ * Uses common metadata field: tcp_options
+ */
+#define PANDA_METADATA_TEMP_tcp_option_mss(NAME, STRUCT)		\
+static void NAME(const void *vopt, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	const struct tcp_opt_union *opt = vopt;				\
+	struct STRUCT *frame = iframe;					\
+									\
+	frame->tcp_options.mss = ntohs(opt->mss);			\
+}
+
+/* Meta data helper for TCP window scaling option
+ * Uses common metadata field: tcp_options
+ */
+#define PANDA_METADATA_TEMP_tcp_option_window_scaling(NAME, STRUCT)	\
+static void NAME(const void *vopt, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	const struct tcp_opt_union *opt = vopt;				\
+	struct STRUCT *frame = iframe;					\
+									\
+	frame->tcp_options.window_scaling = opt->window_scaling;	\
+}
+
+/* Meta data helper for TCP timestamps option
+ * Uses common metadata field: tcp_options
+ */
+#define PANDA_METADATA_TEMP_tcp_option_timestamp(NAME, STRUCT)		\
+static void NAME(const void *vopt, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	const struct tcp_opt_union *opt = vopt;				\
+	struct STRUCT *frame = iframe;					\
+									\
+	frame->tcp_options.timestamp.value =				\
+				ntohl(opt->timestamp.value);		\
+	frame->tcp_options.timestamp.echo =				\
+				ntohl(opt->timestamp.echo);		\
+}
+
+/* Common macro to set one metadata entry for sack. N indicates which
+ * entry (per protocol specification that is 0, 1, 2, or 3)
+ */
+#define PANDA_METADATA_SET_TCP_SACK(N, VOPT, IFRAME, STRUCT) do {	\
+	const struct tcp_opt_union *opt = vopt;				\
+	struct STRUCT *frame = iframe;					\
+									\
+	frame->tcp_options.sack[N].left_edge =				\
+				ntohl(opt->sack[N].left_edge);		\
+	frame->tcp_options.sack[N].right_edge =				\
+				ntohl(opt->sack[N].right_edge);		\
+} while (0)
+
+/* Meta data helper for setting one TCP sack option
+ * Uses common metadata field: tcp_options.sack[0]
+ */
+#define PANDA_METADATA_TEMP_tcp_option_sack_1(NAME, STRUCT)		\
+static void NAME(const void *vopt, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	PANDA_METADATA_SET_TCP_SACK(0, vopt, iframe, STRUCT);		\
+}
+
+/* Meta data helper for setting two TCP sack options
+ * Uses common metadata field: tcp_options.sack[0], tcp_options.sack[1]
+ */
+#define PANDA_METADATA_TEMP_tcp_option_sack_2(NAME, STRUCT)		\
+static void NAME(const void *vopt, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	PANDA_METADATA_SET_TCP_SACK(0, vopt, iframe, STRUCT);		\
+	PANDA_METADATA_SET_TCP_SACK(1, vopt, iframe, STRUCT);		\
+}
+
+/* Meta data helper for setting three TCP sack options
+ * Uses common metadata field: tcp_options.sack[0], tcp_options.sack[1],
+ * tcp_options.sack[2]
+ */
+#define PANDA_METADATA_TEMP_tcp_option_sack_3(NAME, STRUCT)		\
+static void NAME(const void *vopt, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	PANDA_METADATA_SET_TCP_SACK(0, vopt, iframe, STRUCT);		\
+	PANDA_METADATA_SET_TCP_SACK(1, vopt, iframe, STRUCT);		\
+	PANDA_METADATA_SET_TCP_SACK(2, vopt, iframe, STRUCT);		\
+}
+
+/* Meta data helper for setting four TCP sack options
+ * Uses common metadata field: tcp_options.sack[0], tcp_options.sack[1],
+ * tcp_options.sack[2], tcp_options.sack[3]
+ */
+#define PANDA_METADATA_TEMP_tcp_option_sack_4(NAME, STRUCT)		\
+static void NAME(const void *vopt, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	PANDA_METADATA_SET_TCP_SACK(0, vopt, iframe, STRUCT);		\
+	PANDA_METADATA_SET_TCP_SACK(1, vopt, iframe, STRUCT);		\
+	PANDA_METADATA_SET_TCP_SACK(2, vopt, iframe, STRUCT);		\
+	PANDA_METADATA_SET_TCP_SACK(3, vopt, iframe, STRUCT);		\
+}
+
+/* Meta data helper for IP overlay (differentiate based on version number).
+ * Uses common metadata fields: eth_proto
+ */
+#define PANDA_METADATA_TEMP_ip_overlay(NAME, STRUCT)			\
+static void NAME(const void *viph, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+									\
+	switch (((struct ip_hdr_byte *)viph)->version) {		\
+	case 4:								\
+		frame->eth_proto = __cpu_to_be16(ETH_P_IP);		\
+		break;							\
+	case 6:								\
+		frame->eth_proto = __cpu_to_be16(ETH_P_IPV6);		\
+		break;							\
+	}								\
+}
+
+/* Meta data helper for Routing, DestOpt, and Hop-by-Hop extension headers.
+ * Uses common metadata fields: ip_proto
+ */
+#define PANDA_METADATA_TEMP_ipv6_eh(NAME, STRUCT)			\
+static void NAME(const void *vopt, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	((struct STRUCT *)iframe)->ip_proto =				\
+			((struct ipv6_opt_hdr *)vopt)->nexthdr;		\
+}
+
+/* Meta data helper for Fragmentation extension header.
+ * Uses common metadata fields: ip_proto, is_fragment, first_frag
+ */
+#define PANDA_METADATA_TEMP_ipv6_frag(NAME, STRUCT)			\
+static void NAME(const void *vfrag, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+	const struct ipv6_frag_hdr *frag = vfrag;			\
+									\
+	frame->ip_proto = frag->nexthdr;				\
+	frame->is_fragment = 1;						\
+	frame->first_frag = !(frag->frag_off & htons(IP6_OFFSET));	\
+}
+
+/* Meta data helper for Fragmentation extension header without info.
+ * Uses common metadata fields: ip_proto
+ */
+#define PANDA_METADATA_TEMP_ipv6_frag_noinfo(NAME, STRUCT)		\
+static void NAME(const void *vfrag, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	((struct STRUCT *)iframe)->ip_proto =				\
+			((struct ipv6_frag_hdr *)vfrag)->nexthdr;	\
+}
+
+#define PANDA_METADATA_TEMP_arp_rarp(NAME, STRUCT)			\
+static void NAME(const void *vearp, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+	const struct earphdr *earp = vearp;				\
+									\
+	frame->arp.op = ntohs(earp->arp.ar_op) & 0xff;			\
+									\
+	/* Record Ethernet addresses */					\
+	memcpy(frame->arp.sha, earp->ar_sha, ETH_ALEN);			\
+	memcpy(frame->arp.tha, earp->ar_tha, ETH_ALEN);			\
+									\
+	/* Record IP addresses */					\
+	memcpy(&frame->arp.sip, &earp->ar_sip, sizeof(frame->arp.sip));	\
+	memcpy(&frame->arp.tip, &earp->ar_tip, sizeof(frame->arp.tip));	\
+}
+
+/* Meta data helper for VLAN.
+ * Uses common metadata fields: vlan_count, vlan[0].id, vlan[0].priority,
+ * vlan[0].tci, vlan[0].tpid, vlan[1].id, vlan[1].priority, vlan[1].tci,
+ * vlan[1].tpid
+ */
+#define PANDA_METADATA_TEMP_vlan_set_tpid(NAME, STRUCT, TPID)		\
+static void NAME(const void *vvlan, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+	const struct vlan_hdr *vlan = vvlan;				\
+	int index = (frame->vlan_count < PANDA_MAX_VLAN_CNT) ?		\
+			frame->vlan_count++ : PANDA_MAX_VLAN_CNT - 1;	\
+									\
+	frame->vlan[index].id = ntohs(vlan->h_vlan_TCI) &		\
+				VLAN_VID_MASK;				\
+	frame->vlan[index].priority = (ntohs(vlan->h_vlan_TCI) &	\
+				VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;	\
+	frame->vlan[index].tpid = TPID;					\
+}
+
+#define PANDA_METADATA_TEMP_vlan_8021AD(NAME, STRUCT)			\
+	PANDA_METADATA_TEMP_vlan_set_tpid(NAME, STRUCT, ETH_P_8021AD)
+
+#define PANDA_METADATA_TEMP_vlan_8021Q(NAME, STRUCT)			\
+	PANDA_METADATA_TEMP_vlan_set_tpid(NAME, STRUCT, ETH_P_8021Q)
+
+/* Meta data helper for ICMP (ICMPv4 or ICMPv6).
+ * Uses common metadata fields: icmp.type, icmp.code, icmp.id
+ */
+#define PANDA_METADATA_TEMP_icmp(NAME, STRUCT)				\
+static void NAME(const void *vicmp, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+	const struct icmphdr *icmp = vicmp;				\
+									\
+	frame->icmp.type = icmp->type;					\
+	frame->icmp.code = icmp->code;					\
+	if (icmp_has_id(icmp->type))					\
+		frame->icmp.id = icmp->un.echo.id ? : 1;		\
+	else								\
+		frame->icmp.id = 0;					\
+}
+
+/* Meta data helper for MPLS.
+ * Uses common metadata fields: mpls.label, mpls.ttl, mpls.tc, mpls.bos, keyid
+ */
+#define PANDA_METADATA_TEMP_mpls(NAME, STRUCT)				\
+static void NAME(const void *vmpls, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+	const struct mpls_label *mpls = vmpls;				\
+	__u32 entry, label;						\
+									\
+	entry = ntohl(mpls[0].entry);					\
+	label = (entry & MPLS_LS_LABEL_MASK) >> MPLS_LS_LABEL_SHIFT;	\
+									\
+	frame->mpls.label = label;					\
+	frame->mpls.ttl =						\
+		(entry & MPLS_LS_TTL_MASK) >> MPLS_LS_TTL_SHIFT;	\
+	frame->mpls.tc = (entry & MPLS_LS_TC_MASK) >> MPLS_LS_TC_SHIFT;	\
+	frame->mpls.bos = (entry & MPLS_LS_S_MASK) >> MPLS_LS_S_SHIFT;	\
+									\
+	if (label == MPLS_LABEL_ENTROPY)				\
+		frame->keyid =						\
+			mpls[1].entry & htonl(MPLS_LS_LABEL_MASK);	\
+}
+
+/* Meta data helper for tipc.
+ * Uses common metadata fields: addr_type, tipckwy
+ *
+ * For non keepalive message set source node identity in tipc addresses.
+ * For keepalive messages set the tipc address to a random number fo
+ * spread PROBE/PROBE_REPLY messages across cores.
+ */
+#define PANDA_METADATA_TEMP_tipc(NAME, STRUCT)				\
+static void NAME(const void *vtipc, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+	const struct tipc_basic_hdr *tipc = vtipc;			\
+									\
+	__u32 w0 = ntohl(tipc->w[0]);					\
+	bool keepalive_msg;						\
+									\
+	keepalive_msg = (w0 & TIPC_KEEPALIVE_MSG_MASK) ==		\
+					TIPC_KEEPALIVE_MSG_MASK;	\
+	frame->addrs.tipckey = keepalive_msg ? 0 : tipc->w[3];		\
+	frame->addr_type = PANDA_ADDR_TYPE_TIPC;			\
+}
+
+/* Meta data helper for GRE (v0)
+ * Uses common metadata field: gre.flags
+ */
+#define PANDA_METADATA_TEMP_gre(NAME, STRUCT)				\
+static void NAME(const void *vhdr, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+									\
+	frame->gre.flags = gre_get_flags(vhdr);				\
+}
+
+/* Meta data helper for GRE-PPTP (GRE v1)
+ * Uses common metadata field: gre_pptp.flags
+ */
+#define PANDA_METADATA_TEMP_gre_pptp(NAME, STRUCT)			\
+static void NAME(const void *vhdr, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+									\
+	frame->gre_pptp.flags = gre_get_flags(vhdr);			\
+}
+
+/* Meta data helper for GRE checksum
+ * Uses common metadata field: gre.checksum
+ */
+#define PANDA_METADATA_TEMP_gre_checksum(NAME, STRUCT)			\
+static void NAME(const void *vdata, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+									\
+	frame->gre.csum = *(__u16 *)vdata;				\
+}
+
+/* Meta data helper for GRE keyid
+ * Uses common metadata field: gre.keyid and keyid
+ */
+#define PANDA_METADATA_TEMP_gre_keyid(NAME, STRUCT)			\
+static void NAME(const void *vdata, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+	__u32 v = *(__u32 *)vdata;					\
+									\
+	frame->gre.keyid = v;						\
+	frame->keyid = v;						\
+}
+
+/* Meta data helper for GRE sequence number
+ * Uses common metadata field: gre.seq
+ */
+#define PANDA_METADATA_TEMP_gre_seq(NAME, STRUCT)			\
+static void NAME(const void *vdata, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+									\
+	frame->gre.seq = *(__u32 *)vdata;				\
+}
+
+/* Meta data helper for GRE routing
+ * Uses common metadata field: gre.routing
+ */
+#define PANDA_METADATA_TEMP_gre_routing(NAME, STRUCT)			\
+static void NAME(const void *vdata, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+									\
+	frame->gre.routing = *(__u32 *)vdata;				\
+}
+
+
+/* Meta data helper for GRE keyid
+ * Uses common metadata field: pptp.length, pptp.call_id, and keyid
+ */
+#define PANDA_METADATA_TEMP_gre_pptp_key(NAME, STRUCT)			\
+static void NAME(const void *vdata, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+	struct panda_pptp_id *key = (struct panda_pptp_id *)vdata;	\
+									\
+	frame->keyid = key->val32;					\
+	frame->gre_pptp.length = key->payload_len;			\
+	frame->gre_pptp.callid = key->call_id;				\
+}
+
+/* Meta data helper for GRE-pptp sequence number
+ * Uses common metadata field: pptp.seq
+ */
+#define PANDA_METADATA_TEMP_gre_pptp_seq(NAME, STRUCT)			\
+static void NAME(const void *vdata, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+									\
+	frame->gre_pptp.seq = *(__u32 *)vdata;				\
+}
+
+/* Meta data helper for GRE-pptp ACK
+ * Uses common metadata field: pptp.ack
+ */
+#define PANDA_METADATA_TEMP_gre_pptp_ack(NAME, STRUCT)			\
+static void NAME(const void *vdata, void *iframe,			\
+		 struct panda_ctrl_data ctrl)				\
+{									\
+	struct STRUCT *frame = iframe;					\
+									\
+	frame->gre_pptp.ack = *(__u32 *)vdata;				\
+}
+
+/* Helper function to define a function to print common metadata */
+#define PANDA_PRINT_METADATA(FRAME) do {				\
+	char a4buf[INET_ADDRSTRLEN];					\
+	char a6buf[INET6_ADDRSTRLEN];					\
+									\
+	switch ((FRAME)->addr_type) {					\
+	case PANDA_ADDR_TYPE_IPV4:					\
+		printf("IPv4 source address: %s\n",			\
+		inet_ntop(AF_INET, &(FRAME)->addrs.v4_addrs[0],		\
+			  a4buf, sizeof(a4buf)));			\
+		printf("IPv4 destination address: %s\n",		\
+		       inet_ntop(AF_INET, &(FRAME)->addrs.v4_addrs[1],	\
+		       a4buf, sizeof(a4buf)));				\
+		break;							\
+	case PANDA_ADDR_TYPE_IPV6:					\
+		printf("IPv6 source address: %s\n",			\
+		       inet_ntop(AF_INET6, &(FRAME)->addrs.v6_addrs[0],	\
+				 a6buf, sizeof(a6buf)));		\
+		printf("IPv6 destination address: %s\n",		\
+		       inet_ntop(AF_INET6, &(FRAME)->addrs.v6_addrs[1],	\
+				 a6buf, sizeof(a6buf)));		\
+		break;							\
+	}								\
+	printf("Source port %04x\n", ntohs((FRAME)->port16[0]));	\
+	printf("Destination port %04x\n", ntohs((FRAME)->port16[1]));	\
+} while (0)
+
+#endif /* __PANDA_PARSER_METADATA_H__ */
diff --git a/include/net/panda/parser_types.h b/include/net/panda/parser_types.h
new file mode 100644
index 000000000000..f746b4de2bea
--- /dev/null
+++ b/include/net/panda/parser_types.h
@@ -0,0 +1,255 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_TYPES_H__
+#define __PANDA_TYPES_H__
+
+/* Type definitions for PANDA parser */
+
+#include <stddef.h>
+#include <stdbool.h>
+
+#include <linux/types.h>
+
+#include "net/panda/compiler_helpers.h"
+
+/* Panda parser type codes */
+enum panda_parser_type {
+	/* Use non-optimized loop panda parser algorithm */
+	PANDA_GENERIC = 0,
+	/* Use optimized, generated, parser algorithm  */
+	PANDA_OPTIMIZED = 1,
+	/* XDP parser */
+	PANDA_XDP = 2,
+	/* Kernel module parser */
+	PANDA_KMOD = 3,
+};
+
+/* Parse and protocol node types */
+enum panda_parser_node_type {
+	/* Plain node, no super structure */
+	PANDA_NODE_TYPE_PLAIN,
+	/* TLVs node with super structure for TLVs */
+	PANDA_NODE_TYPE_TLVS,
+	/* Flag-fields with super structure for flag-fields */
+	PANDA_NODE_TYPE_FLAG_FIELDS,
+};
+
+/* Protocol parsing operations:
+ *
+ * len: Return length of protocol header. If value is NULL then the length of
+ *	the header is taken from the min_len in the protocol node. If the
+ *	return value < 0 (a PANDA_STOP_* return code value) this indicates an
+ *	error and parsing is stopped. A the return value greater than or equal
+ *	to zero then gives the protocol length. If the returned length is less
+ *	than the minimum protocol length, indicated in min_len by the protocol
+ *	node, then this considered and error.
+ * next_proto: Return next protocol. If value is NULL then there is no
+ *	next protocol. If return value is greater than or equal to zero
+ *	this indicates a protocol number that is used in a table lookup
+ *	to get the next layer protocol node.
+ */
+struct panda_parse_ops {
+	ssize_t (*len)(const void *hdr);
+	int (*next_proto)(const void *hdr);
+};
+
+/* Protocol node
+ *
+ * This structure contains the definitions to describe parsing of one type
+ * of protocol header. Fields are:
+ *
+ * node_type: The type of the node (plain, TLVs, flag-fields)
+ * encap: Indicates an encapsulation protocol (e.g. IPIP, GRE)
+ * overlay: Indicates an overlay protocol. This is used, for example, to
+ *	switch on version number of a protocol header (e.g. IP version number
+ *	or GRE version number)
+ * name: Text name of protocol node for debugging
+ * min_len: Minimum length of the protocol header
+ * ops: Operations to parse protocol header
+ */
+struct panda_proto_node {
+	enum panda_parser_node_type node_type;
+	__u8 encap;
+	__u8 overlay;
+	const char *name;
+	size_t min_len;
+	const struct panda_parse_ops ops;
+};
+
+/* Panda generic metadata
+ *
+ * Contains an array of parser specific (user defined) metadata structures.
+ * Meta data structures are defined specifically for each parser. An
+ * instance of this metadata is a frame. One frame is used for each
+ * level of encapulation. When the number of encapsulation layers exceeds
+ * max_num_frame then last frame is reused
+ *	encaps: Number of encapsulation protocol encountered.
+ *	max_frame_num: Maximum number of frames. One frame is used for each
+ *		level of encapulation. When the number of encapsulation
+ *		layers exceeds this value the last frame is reuse used
+ *	frame_size: The size in bytes of each metadata frame
+ *	frame_data: Contains max_frame_num metadata frames
+ */
+struct panda_metadata {
+	unsigned int encaps;
+	unsigned int max_frame_num;
+	size_t frame_size;
+
+	/* Application specific metadata frames */
+	__u8 frame_data[0] __aligned(8);
+};
+
+struct panda_ctx {
+	__u32 frame_num;
+	__u32 next;
+	__u32 offset;
+	struct panda_metadata metadata;
+};
+
+struct panda_ctrl_data {
+	size_t hdr_len;
+	size_t hdr_offset;
+};
+
+/* Parse node operations
+ *
+ * Operations to process a parsing node
+ *
+ * extract_metadata: Extract metadata for the node. Input is the meta
+ *	data frame which points to a parser defined metadata structure.
+ *	If the value is NULL then no metadata is extracted
+ * handle_proto: Per protocol handler which allows arbitrary processing
+ *	of a protocol layer. Input is the header data and a parser defined
+ *	metadata structure for the current frame. Return value is a parser
+ *	return code: PANDA_OKAY indicates no errors, PANDA_STOP* return
+ *	values indicate to stop parsing
+ */
+struct panda_parse_node_ops {
+	void (*extract_metadata)(const void *hdr, void *frame,
+				 const struct panda_ctrl_data ctrl);
+	int (*handle_proto)(const void *hdr, void *frame,
+			    const struct panda_ctrl_data ctrl);
+};
+
+/* Protocol node and parse node operations ordering. When processing a
+ * layer, operations are called in following order:
+ *
+ * protoop.len
+ * parseop.extract_metadata
+ * parseop.handle_proto
+ * protoop.next_proto
+ */
+
+struct panda_parse_node;
+
+/* One entry in a protocol table:
+ *	value: protocol number
+ *	node: associated parse node for the protocol number
+ */
+struct panda_proto_table_entry {
+	int value;
+	const struct panda_parse_node *node;
+};
+
+/* Protocol table
+ *
+ * Contains a protocol table that maps a protocol number to a parse
+ * node
+ */
+struct panda_proto_table {
+	int num_ents;
+	const struct panda_proto_table_entry *entries;
+};
+
+/* Parse node definition. Defines parsing and processing for one node in
+ * the parse graph of a parser. Contains:
+ *
+ * node_type: The type of the node (plain, TLVs, flag-fields)
+ * proto_node: Protocol node
+ * ops: Parse node operations
+ * proto_table: Protocol table for next protocol. This must be non-null if
+ * next_proto is not NULL
+ */
+struct panda_parse_node {
+	enum panda_parser_node_type node_type;
+	int unknown_ret;
+	const struct panda_proto_node *proto_node;
+	const struct panda_parse_node_ops ops;
+	const struct panda_proto_table *proto_table;
+	const struct panda_parse_node *wildcard_node;
+};
+
+/* Declaration of a PANDA parser */
+struct panda_parser;
+
+/* Panda entry-point for optimized parsers */
+typedef int (*panda_parser_opt_entry_point)(const struct panda_parser *parser,
+					    const void *hdr, size_t len,
+					    struct panda_metadata *metadata,
+					    unsigned int flags,
+					    unsigned int max_encaps);
+
+/* Panda entry-point for XDP parsers */
+typedef int (*panda_parser_xdp_entry_point)(struct panda_ctx *ctx,
+					    const void **hdr,
+					    const void *hdr_end,
+					    bool tailcall);
+
+/* Definition of a PANDA parser. Fields are:
+ *
+ * name: Text name for the parser
+ * root_node: Root parse node of the parser. When the parser is invoked
+ *	parsing commences at this parse node
+ */
+struct panda_parser {
+	const char *name;
+	const struct panda_parse_node *root_node;
+	enum panda_parser_type parser_type;
+	panda_parser_opt_entry_point parser_entry_point;
+	panda_parser_xdp_entry_point parser_xdp_entry_point;
+};
+
+/* One entry in a parser table:
+ *	value: key vlaue
+ *	parser: parser associated with the key value
+ */
+struct panda_parser_table_entry {
+	int value;
+	struct panda_parser **parser;
+};
+
+/* Parser table
+ *
+ * Contains a parser table that maps a key value, which could be a protocol
+ * number, to a parser
+ */
+struct panda_parser_table {
+	int num_ents;
+	const struct panda_parser_table_entry *entries;
+};
+
+#endif /* __PANDA_TYPES_H__ */
diff --git a/include/net/panda/proto_nodes.h b/include/net/panda/proto_nodes.h
new file mode 100644
index 000000000000..76b3a4db49bf
--- /dev/null
+++ b/include/net/panda/proto_nodes.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+/* Include for all defined proto nodes */
+
+#include "net/panda/proto_nodes/proto_ether.h"
+#include "net/panda/proto_nodes/proto_pppoe.h"
+#include "net/panda/proto_nodes/proto_ipv4.h"
+#include "net/panda/proto_nodes/proto_ipv6.h"
+#include "net/panda/proto_nodes/proto_ports.h"
+#include "net/panda/proto_nodes/proto_tcp.h"
+#include "net/panda/proto_nodes/proto_ip.h"
+#include "net/panda/proto_nodes/proto_ipv6_eh.h"
+#include "net/panda/proto_nodes/proto_ipv4ip.h"
+#include "net/panda/proto_nodes/proto_ipv6ip.h"
+#include "net/panda/proto_nodes/proto_gre.h"
+#include "net/panda/proto_nodes/proto_vlan.h"
+#include "net/panda/proto_nodes/proto_icmp.h"
+#include "net/panda/proto_nodes/proto_ppp.h"
+#include "net/panda/proto_nodes/proto_mpls.h"
+#include "net/panda/proto_nodes/proto_arp_rarp.h"
+#include "net/panda/proto_nodes/proto_tipc.h"
+#include "net/panda/proto_nodes/proto_batman.h"
+#include "net/panda/proto_nodes/proto_igmp.h"
+#include "net/panda/proto_nodes/proto_fcoe.h"
diff --git a/include/net/panda/proto_nodes/proto_arp_rarp.h b/include/net/panda/proto_nodes/proto_arp_rarp.h
new file mode 100644
index 000000000000..8e35b84e98af
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_arp_rarp.h
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_ARP_RARP_H__
+#define __PANDA_PROTO_ARP_RARP_H__
+
+#ifndef __KERNEL__
+#include <arpa/inet.h>
+#endif
+
+#include <linux/if_arp.h>
+
+#include "net/panda/parser.h"
+
+/* ARP and RARP node definitions */
+
+struct earphdr {
+	struct arphdr arp;
+	__u8 ar_sha[ETH_ALEN];
+	__u8 ar_sip[4];
+	__u8 ar_tha[ETH_ALEN];
+	__u8 ar_tip[4];
+};
+
+static inline ssize_t arp_len_check(const void *vearp)
+{
+	const struct earphdr *earp = vearp;
+	const struct arphdr *arp = &earp->arp;
+
+	if (arp->ar_hrd != htons(ARPHRD_ETHER) ||
+	    arp->ar_pro != htons(ETH_P_IP) ||
+	    arp->ar_hln != ETH_ALEN ||
+	    arp->ar_pln != 4 ||
+	    (arp->ar_op != htons(ARPOP_REPLY) &&
+	     arp->ar_op != htons(ARPOP_REQUEST)))
+		return PANDA_STOP_FAIL;
+
+	return sizeof(struct earphdr);
+}
+
+#endif /* __PANDA_PROTO_ARP_RARP_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* panda_parse_arp protocol node
+ *
+ * Parse ARP header
+ */
+static const struct panda_proto_node panda_parse_arp __unused() = {
+	.name = "ARP",
+	.min_len = sizeof(struct earphdr),
+	.ops.len = arp_len_check,
+};
+
+/* panda_parse_rarp protocol node
+ *
+ * Parse RARP header
+ */
+static const struct panda_proto_node panda_parse_rarp __unused() = {
+	.name = "RARP",
+	.min_len = sizeof(struct earphdr),
+	.ops.len = arp_len_check,
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_batman.h b/include/net/panda/proto_nodes/proto_batman.h
new file mode 100644
index 000000000000..40e95cd48836
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_batman.h
@@ -0,0 +1,106 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_BATMAN_H__
+#define __PANDA_PROTO_BATMAN_H__
+
+#include <linux/if_ether.h>
+
+#include "net/panda/parser.h"
+
+/* ARP and RARP node definitions */
+
+#define BATADV_COMPAT_VERSION 15
+
+enum batadv_packettype {
+	/* 0x00 - 0x3f: local packets or special rules for handling */
+	BATADV_IV_OGM           = 0x00,
+	BATADV_BCAST            = 0x01,
+	BATADV_CODED            = 0x02,
+	BATADV_ELP		= 0x03,
+	BATADV_OGM2		= 0x04,
+	/* 0x40 - 0x7f: unicast */
+#define BATADV_UNICAST_MIN     0x40
+	BATADV_UNICAST          = 0x40,
+	BATADV_UNICAST_FRAG     = 0x41,
+	BATADV_UNICAST_4ADDR    = 0x42,
+	BATADV_ICMP             = 0x43,
+	BATADV_UNICAST_TVLV     = 0x44,
+#define BATADV_UNICAST_MAX     0x7f
+	/* 0x80 - 0xff: reserved */
+};
+
+struct batadv_unicast_packet {
+	__u8 packet_type;
+	__u8 version;
+	__u8 ttl;
+	__u8 ttvn; /* destination translation table version number */
+	__u8 dest[ETH_ALEN];
+	/* "4 bytes boundary + 2 bytes" long to make the payload after the
+	 * following ethernet header again 4 bytes boundary aligned
+	 */
+};
+
+struct batadv_eth {
+	struct batadv_unicast_packet batadv_unicast;
+	struct ethhdr eth;
+};
+
+static inline ssize_t batman_len_check(const void *vbeth)
+{
+	const struct batadv_eth *beth = vbeth;
+
+	if (beth->batadv_unicast.version != BATADV_COMPAT_VERSION ||
+	    beth->batadv_unicast.packet_type != BATADV_UNICAST)
+		return PANDA_STOP_FAIL;
+
+	return sizeof(struct batadv_eth);
+}
+
+static inline int batman_proto(const void *vbeth)
+{
+	return ((struct batadv_eth *)vbeth)->eth.h_proto;
+}
+
+#endif /* __PANDA_PROTO_BATMAN_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* parse_batman panda_protocol node
+ *
+ * Parse BATMAN header
+ *
+ * Next protocol operation returns Ethertype (e.g. ETH_P_IPV4)
+ */
+static const struct panda_proto_node panda_parse_batman __unused() = {
+	.name = "BATMAN",
+	.encap = 1,
+	.min_len = sizeof(struct batadv_eth),
+	.ops.len = batman_len_check,
+	.ops.next_proto = batman_proto,
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_ether.h b/include/net/panda/proto_nodes/proto_ether.h
new file mode 100644
index 000000000000..77f54dffeb3e
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_ether.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_ETHER_H__
+#define __PANDA_PROTO_ETHER_H__
+
+/* Ethernet node definitions */
+
+#include <linux/if_ether.h>
+
+#include "net/panda/parser.h"
+
+static inline int ether_proto(const void *veth)
+{
+	return ((struct ethhdr *)veth)->h_proto;
+}
+
+#endif /* __PANDA_PROTO_ETHER_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* panda_parse_ether protocol node
+ *
+ * Parses Ethernet header
+ *
+ * Next protocol operation returns Ethertype (e.g. ETH_P_IPV4)
+ */
+
+static const struct panda_proto_node panda_parse_ether __unused() = {
+	.name = "Ethernet",
+	.min_len = sizeof(struct ethhdr),
+	.ops.next_proto = ether_proto,
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_fcoe.h b/include/net/panda/proto_nodes/proto_fcoe.h
new file mode 100644
index 000000000000..2fa614345fe4
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_fcoe.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_FCOE_H__
+#define __PANDA_PROTO_FCOE_H__
+
+#include "net/panda/parser.h"
+
+/* Generic FCOE node definitions */
+
+#define FCOE_HEADER_LEN		38
+
+#endif /* __PANDA_PROTO_FCOE_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* panda_parse_fcoe protocol node
+ *
+ * Parse FCOE header
+ */
+static const struct panda_proto_node panda_parse_fcoe __unused() = {
+	.name = "FCOE",
+	.min_len = FCOE_HEADER_LEN,
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_gre.h b/include/net/panda/proto_nodes/proto_gre.h
new file mode 100644
index 000000000000..3f39f2b46d20
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_gre.h
@@ -0,0 +1,290 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_GRE_H__
+#define __PANDA_PROTO_GRE_H__
+
+/* GRE node definitions */
+
+#ifndef __KERNEL__
+#include <arpa/inet.h>
+#endif
+
+#include <linux/ip.h>
+
+#include "net/panda/parser.h"
+
+/* Define common GRE constants. These normally come from linux/if_tunnel.h,
+ * however that include file has a lot of other definitions beyond just GRE
+ * which can be a problem compiling especially with older kernel includes. So
+ * we define the GRE values here if they aren't already defined elsewhere.
+ */
+#ifndef GRE_CSUM
+#define GRE_CSUM	__cpu_to_be16(0x8000)
+#endif
+
+#ifndef GRE_ROUTING
+#define GRE_ROUTING	__cpu_to_be16(0x4000)
+#endif
+
+#ifndef GRE_KEY
+#define GRE_KEY		__cpu_to_be16(0x2000)
+#endif
+
+#ifndef GRE_SEQ
+#define GRE_SEQ		__cpu_to_be16(0x1000)
+#endif
+
+#ifndef GRE_ACK
+#define GRE_ACK		__cpu_to_be16(0x0080)
+#endif
+
+#ifndef GRE_VERSION
+#define GRE_VERSION	__cpu_to_be16(0x0007)
+#endif
+
+#ifndef GRE_VERSION_0
+#define GRE_VERSION_0	__cpu_to_be16(0x0000)
+#endif
+
+#ifndef GRE_VERSION_1
+#define GRE_VERSION_1	__cpu_to_be16(0x0001)
+#endif
+
+#ifndef GRE_PROTO_PPP
+#define GRE_PROTO_PPP	__cpu_to_be16(0x880b)
+#endif
+
+#ifndef GRE_PPTP_KEY_MASK
+#define GRE_PPTP_KEY_MASK	__cpu_to_be32(0xffff)
+#endif
+
+/* GRE flag-field definitions */
+static const struct panda_flag_fields gre_flag_fields = {
+	.fields = {
+		{
+#define GRE_FLAGS_CSUM_IDX	0
+			.flag = GRE_CSUM,
+			.size = sizeof(__be32),
+		},
+		{
+#define GRE_FLAGS_KEY_IDX	1
+			.flag = GRE_KEY,
+			.size = sizeof(__be32),
+		},
+#define GRE_FLAGS_SEQ_IDX	2
+		{
+			.flag = GRE_SEQ,
+			.size = sizeof(__be32),
+		},
+#define GRE_FLAGS_NUM_IDX	3
+	},
+	.num_idx = GRE_FLAGS_NUM_IDX
+};
+
+#define GRE_FLAGS_V0_MASK	(GRE_CSUM | GRE_KEY | GRE_SEQ | GRE_ROUTING)
+
+static const struct panda_flag_fields pptp_gre_flag_fields = {
+	.fields = {
+		{
+#define GRE_PPTP_FLAGS_CSUM_IDX	0
+			.flag = GRE_CSUM,
+			.size = sizeof(__be32),
+		},
+		{
+#define GRE_PPTP_FLAGS_KEY_IDX	1
+			.flag = GRE_KEY,
+			.size = sizeof(__be32),
+		},
+#define GRE_PPTP_FLAGS_SEQ_IDX	2
+		{
+			.flag = GRE_SEQ,
+			.size = sizeof(__be32),
+		},
+#define GRE_PPTP_FLAGS_ACK_IDX	3
+		{
+			.flag = GRE_ACK,
+			.size = sizeof(__be32),
+		},
+#define GRE_PPTP_FLAGS_NUM_IDX	4
+	},
+	.num_idx = GRE_PPTP_FLAGS_NUM_IDX
+};
+
+#define GRE_FLAGS_V1_MASK	(GRE_CSUM | GRE_KEY | GRE_SEQ |		\
+				 GRE_ROUTING | GRE_ACK)
+
+#define GRE_PPTP_KEY_MASK	__cpu_to_be32(0xffff)
+
+struct gre_hdr {
+	__be16 flags;
+	__be16 protocol;
+	__u8 fields[0];
+};
+
+struct panda_pptp_id {
+	union {
+		struct {
+			__u16 payload_len;
+			__u16 call_id;
+		};
+		__u32 val32;
+	};
+};
+
+static inline int gre_proto_version(const void *vgre)
+{
+	return ntohs(((struct gre_hdr *)vgre)->flags & GRE_VERSION);
+}
+
+static inline size_t gre_v0_len_from_flags(unsigned int flags)
+{
+	return sizeof(struct gre_hdr) +
+		panda_flag_fields_length(flags, &gre_flag_fields);
+}
+
+static inline ssize_t gre_v0_len_check(const void *vgre)
+{
+	const struct gre_hdr *gre = vgre;
+
+	/* Check for valid set of flags */
+	if (panda_flag_fields_check_invalid(gre->flags, GRE_FLAGS_V0_MASK |
+								GRE_VERSION))
+		return PANDA_STOP_BAD_FLAG;
+
+	/* Only look inside GRE without routing */
+	if (((struct gre_hdr *)vgre)->flags & GRE_ROUTING)
+		return PANDA_STOP_OKAY;
+
+	return gre_v0_len_from_flags(gre->flags);
+}
+
+static inline int gre_v0_proto(const void *vgre)
+{
+	return ((struct gre_hdr *)vgre)->protocol;
+}
+
+static inline size_t gre_v1_len_from_flags(unsigned int flags)
+{
+	return sizeof(struct gre_hdr) +
+		panda_flag_fields_length(flags, &pptp_gre_flag_fields);
+}
+
+static inline ssize_t gre_v1_len_check(const void *vgre)
+{
+	const struct gre_hdr *gre = vgre;
+
+	/* Check for valid set of flags */
+	if (panda_flag_fields_check_invalid(gre->flags, GRE_FLAGS_V1_MASK |
+								GRE_VERSION))
+		return PANDA_STOP_BAD_FLAG;
+
+	/* Only look inside GRE without routing */
+	if (((struct gre_hdr *)vgre)->flags & GRE_ROUTING)
+		return PANDA_STOP_OKAY;
+
+	/* Version1 must be PPTP, and check that keyid id set */
+	if (!(gre->protocol == GRE_PROTO_PPP && (gre->flags & GRE_KEY)))
+		return PANDA_STOP_OKAY;
+
+	return gre_v1_len_from_flags(gre->flags);
+}
+
+static inline int gre_v1_proto(const void *vgre)
+{
+	/* Protocol already checked in gre_v1_len_check. Returning zero
+	 * means PPP
+	 */
+
+	return 0;
+}
+
+#endif /* __PANDA_PROTO_GRE_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* panda_parse_gre_base protocol node
+ *
+ * Parse base GRE header as an overlay to determine GRE version
+ *
+ * Next protocol operation returns GRE version number (i.e. 0 or 1).
+ */
+static const struct panda_proto_node panda_parse_gre_base __unused() = {
+	.name = "GRE base",
+	.overlay = 1,
+	.min_len = sizeof(struct gre_hdr),
+	.ops.next_proto = gre_proto_version,
+};
+
+static inline __u32 gre_get_flags(const void *hdr)
+{
+	return ((struct gre_hdr *)hdr)->flags;
+}
+
+static inline size_t gre_fields_offset(const void *hdr)
+{
+	return sizeof(struct gre_hdr);
+}
+
+/* panda_parse_gre_v0 protocol node
+ *
+ * Parse a version 0 GRE header
+ *
+ * Next protocol operation returns a GRE protocol (e.g. ETH_P_IPV4).
+ */
+static const struct panda_proto_flag_fields_node
+					panda_parse_gre_v0 __unused() = {
+	.proto_node.node_type = PANDA_NODE_TYPE_FLAG_FIELDS,
+	.proto_node.name = "GRE v0",
+	.proto_node.encap = 1,
+	.proto_node.min_len = sizeof(struct gre_hdr),
+	.proto_node.ops.next_proto = gre_v0_proto,
+	.proto_node.ops.len = gre_v0_len_check,
+	.ops.get_flags = gre_get_flags,
+	.ops.start_fields_offset = gre_fields_offset,
+	.flag_fields = &gre_flag_fields,
+};
+
+/* panda_parse_gre_v1 protocol node
+ *
+ * Parse a version 1 GRE header
+ *
+ * Next protocol operation returns GRE_PROTO_PPP.
+ */
+static const struct panda_proto_flag_fields_node
+					panda_parse_gre_v1 __unused() = {
+	.proto_node.node_type = PANDA_NODE_TYPE_FLAG_FIELDS,
+	.proto_node.name = "GRE v1 - pptp",
+	.proto_node.encap = 1,
+	.proto_node.min_len = sizeof(struct gre_hdr),
+	.proto_node.ops.next_proto = gre_v1_proto,
+	.proto_node.ops.len = gre_v1_len_check,
+	.ops.get_flags = gre_get_flags,
+	.ops.start_fields_offset = gre_fields_offset,
+	.flag_fields = &pptp_gre_flag_fields,
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_icmp.h b/include/net/panda/proto_nodes/proto_icmp.h
new file mode 100644
index 000000000000..222863c83617
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_icmp.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_ICMP_H__
+#define __PANDA_PROTO_ICMP_H__
+
+/* Generic ICMP node definitions */
+
+#include <linux/icmp.h>
+#include <linux/icmpv6.h>
+
+#include "net/panda/parser.h"
+
+static inline bool icmp_has_id(__u8 type)
+{
+	switch (type) {
+	case ICMP_ECHO:
+	case ICMP_ECHOREPLY:
+	case ICMP_TIMESTAMP:
+	case ICMP_TIMESTAMPREPLY:
+	case ICMPV6_ECHO_REQUEST:
+	case ICMPV6_ECHO_REPLY:
+		return true;
+	}
+
+	return false;
+}
+
+#endif /* __PANDA_PROTO_ICMP_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* panda_parse_icmpv4 protocol node
+ *
+ * Parse ICMPv4 header
+ */
+static const struct panda_proto_node panda_parse_icmpv4 __unused() = {
+	.name = "ICMPv4",
+	.min_len = sizeof(struct icmphdr),
+};
+
+/* panda_parse_icmpv6 protocol node
+ *
+ * Parse ICMPv6 header
+ */
+static const struct panda_proto_node panda_parse_icmpv6 __unused() = {
+	.name = "ICMPv6",
+	.min_len = sizeof(struct icmp6hdr),
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_igmp.h b/include/net/panda/proto_nodes/proto_igmp.h
new file mode 100644
index 000000000000..1010ba3a55c9
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_igmp.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_IGMP_H__
+#define __PANDA_PROTO_IGMP_H__
+
+/* PANDA protocol node for IGMP */
+
+#include <linux/igmp.h>
+
+#include "net/panda/parser.h"
+
+#endif /* __PANDA_PROTO_IGMP_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* panda_parse_igmp protocol node
+ *
+ * Parse IGMP header
+ */
+static const struct panda_proto_node panda_parse_igmp __unused() = {
+	.name = "IGMP",
+	.min_len = sizeof(struct igmphdr),
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_ip.h b/include/net/panda/proto_nodes/proto_ip.h
new file mode 100644
index 000000000000..4992a0d67786
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_ip.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_IP_H__
+#define __PANDA_PROTO_IP_H__
+
+#include "net/panda/parser.h"
+
+/* IP overlay node definitions */
+
+#include <asm/byteorder.h>
+
+struct ip_hdr_byte {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8    rsvd:4,
+		version:4;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u8    version:4,
+		rsvd:4;
+#else
+#error "Please fix <asm/byteorder.h>"
+#endif
+};
+
+static inline int ip_proto(const void *viph)
+{
+	return ((struct ip_hdr_byte *)viph)->version;
+}
+
+static inline size_t ip_min_len(const void *viph)
+{
+	return sizeof(struct ip_hdr_byte);
+}
+
+#endif /* __PANDA_PROTO_IP_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* parse_ip protocol node
+ *
+ * Parses first byte of IP header to distinguish IP version (i.e. IPv4
+ * and IPv6)
+ *
+ * Next protocol operation returns IP version number (e.g. 4 for IPv4,
+ * 6 for IPv6)
+ */
+static const struct panda_proto_node panda_parse_ip __unused() = {
+	.name = "IP overlay",
+	.overlay = 1,
+	.min_len = sizeof(struct ip_hdr_byte),
+	.ops.next_proto = ip_proto,
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_ipv4.h b/include/net/panda/proto_nodes/proto_ipv4.h
new file mode 100644
index 000000000000..2a463713af9f
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_ipv4.h
@@ -0,0 +1,150 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PROTO_IPV4_H__
+#define __PROTO_IPV4_H__
+
+/* IPv4 node definitions */
+
+#ifndef __KERNEL__
+#include <arpa/inet.h>
+#endif
+
+#include <linux/ip.h>
+
+#include "net/panda/parser.h"
+
+#define IP_MF		0x2000	/* Flag: "More Fragments"   */
+#define IP_OFFSET	0x1FFF	/* "Fragment Offset" part   */
+
+static inline size_t ipv4_len(const void *viph)
+{
+	return ((struct iphdr *)viph)->ihl * 4;
+}
+
+static inline bool ip_is_fragment(const struct iphdr *iph)
+{
+	return (iph->frag_off & htons(IP_MF | IP_OFFSET)) != 0;
+}
+
+static inline int ipv4_proto(const void *viph)
+{
+	const struct iphdr *iph = viph;
+
+	if (ip_is_fragment(iph) && (iph->frag_off & htons(IP_OFFSET))) {
+		/* Stop at a non-first fragment */
+		return PANDA_STOP_OKAY;
+	}
+
+	return iph->protocol;
+}
+
+static inline int ipv4_proto_stop1stfrag(const void *viph)
+{
+	const struct iphdr *iph = viph;
+
+	if (ip_is_fragment(iph)) {
+		/* Stop at all fragments */
+		return PANDA_STOP_OKAY;
+	}
+
+	return iph->protocol;
+}
+
+static inline ssize_t ipv4_length(const void *viph)
+{
+	return ipv4_len(viph);
+}
+
+static inline ssize_t ipv4_length_check(const void *viph)
+{
+	const struct iphdr *iph = viph;
+
+	if (iph->version != 4)
+		return PANDA_STOP_UNKNOWN_PROTO;
+
+	return ipv4_len(viph);
+}
+
+#endif /* __PROTO_IPV4_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* panda_parse_ipv4 protocol node
+ *
+ * Parse IPv4 header
+ *
+ * Next protocol operation returns IP proto number (e.g. IPPROTO_TCP)
+ */
+static const struct panda_proto_node panda_parse_ipv4 __unused() = {
+	.name = "IPv4",
+	.min_len = sizeof(struct iphdr),
+	.ops.len = ipv4_length,
+	.ops.next_proto = ipv4_proto,
+};
+
+/* panda_parse_ipv4_stop1stfrag protocol node
+ *
+ * Parse IPv4 header but don't parse into first fragment
+ *
+ * Next protocol operation returns IP proto number (e.g. IPPROTO_TCP)
+ */
+static const struct panda_proto_node panda_parse_ipv4_stop1stfrag __unused() = {
+	.name = "IPv4 without parsing 1st fragment",
+	.min_len = sizeof(struct iphdr),
+	.ops.len = ipv4_length,
+	.ops.next_proto = ipv4_proto_stop1stfrag,
+};
+
+/* panda_parse_ipv4_check protocol node
+ *
+ * Check version is four and parse IPv4 header
+ *
+ * Next protocol operation returns IP proto number (e.g. IPPROTO_TCP)
+ */
+static const struct panda_proto_node panda_parse_ipv4_check __unused() = {
+	.name = "IPv4-check",
+	.min_len = sizeof(struct iphdr),
+	.ops.len = ipv4_length_check,
+	.ops.next_proto = ipv4_proto,
+};
+
+/* panda_parse_ipv4_stop1stfrag_check protocol node
+ *
+ * Check IP version is four an parse IPv4 header but don't parse into first
+ * fragment
+ *
+ * Next protocol operation returns IP proto number (e.g. IPPROTO_TCP)
+ */
+static const struct panda_proto_node panda_parse_ipv4_stop1stfrag_check
+							__unused() = {
+	.name = "IPv4 without parsing 1st fragment",
+	.min_len = sizeof(struct iphdr),
+	.ops.len = ipv4_length,
+	.ops.next_proto = ipv4_proto_stop1stfrag,
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_ipv4ip.h b/include/net/panda/proto_nodes/proto_ipv4ip.h
new file mode 100644
index 000000000000..80cfcb85c743
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_ipv4ip.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_IPV4IP_H__
+#define __PANDA_PROTO_IPV4IP_H__
+
+/* IPv4 in IP node definitions */
+
+#include <linux/ip.h>
+
+#include "net/panda/parser.h"
+
+static inline int ipv4_proto_default(const void *viph)
+{
+	return 0; /* Indicates IPv4 */
+}
+
+#endif /* __PANDA_PROTO_IPV4IP_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* parse_ipv4ip protocol node
+ *
+ * Parses IPv4IP header
+ *
+ * Next protocol operation returns 0 indicating IPv4
+ */
+static const struct panda_proto_node panda_parse_ipv4ip __unused() = {
+	.name = "IPv4 in IP",
+	.encap = 1,
+	.overlay = 1,
+	.min_len = sizeof(struct iphdr),
+	.ops.next_proto = ipv4_proto_default,
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_ipv6.h b/include/net/panda/proto_nodes/proto_ipv6.h
new file mode 100644
index 000000000000..9e0043d95ab4
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_ipv6.h
@@ -0,0 +1,133 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_IPV6_H__
+#define __PANDA_PROTO_IPV6_H__
+
+/* IPv6 node definitions */
+
+#ifndef __KERNEL__
+#include <arpa/inet.h>
+#endif
+
+#include <linux/ipv6.h>
+
+#include "net/panda/parser.h"
+
+#define ipv6_optlen(p)  (((p)->hdrlen+1) << 3)
+
+#define IPV6_FLOWLABEL_MASK	htonl(0x000FFFFF)
+static inline __be32 ip6_flowlabel(const struct ipv6hdr *hdr)
+{
+	return *(__be32 *)hdr & IPV6_FLOWLABEL_MASK;
+}
+
+static inline int ipv6_proto(const void *viph)
+{
+	return ((struct ipv6hdr *)viph)->nexthdr;
+}
+
+static inline int ipv6_proto_stopflowlabel(const void *viph)
+{
+	const struct ipv6hdr *iph = viph;
+
+	if (ip6_flowlabel(iph)) {
+		/* Don't continue if flowlabel is non-zero */
+		return PANDA_STOP_OKAY;
+	}
+
+	return iph->nexthdr;
+}
+
+static inline ssize_t ipv6_length_check(const void *viph)
+{
+	const struct ipv6hdr *iph = viph;
+
+	if (iph->version != 6)
+		return PANDA_STOP_UNKNOWN_PROTO;
+
+	return sizeof(struct ipv6hdr);
+}
+
+#endif /* __PANDA_PROTO_IPV6_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* panda_parse_ipv6 protocol node
+ *
+ * Parse IPv6 header
+ *
+ * Next protocol operation returns IP proto number (e.g. IPPROTO_TCP)
+ */
+static const struct panda_proto_node panda_parse_ipv6 __unused() = {
+	.name = "IPv6",
+	.min_len = sizeof(struct ipv6hdr),
+	.ops.next_proto = ipv6_proto,
+};
+
+/* parse_ipv6_stopflowlabel protocol node
+ *
+ * Parse IPv6 header and stop at a non-zero flow label
+ *
+ * Next protocol operation returns IP proto number (e.g. IPPROTO_TCP)
+ */
+static const struct panda_proto_node
+				panda_parse_ipv6_stopflowlabel __unused() = {
+	.name = "IPv6 stop at non-zero flow label",
+	.min_len = sizeof(struct ipv6hdr),
+	.ops.next_proto = ipv6_proto_stopflowlabel,
+};
+
+
+/* panda_parse_ipv6_check protocol node
+ *
+ * Check version is six and parse IPv6 header
+ *
+ * Next protocol operation returns IP proto number (e.g. IPPROTO_TCP)
+ */
+static const struct panda_proto_node panda_parse_ipv6_check __unused() = {
+	.name = "IPv6",
+	.min_len = sizeof(struct ipv6hdr),
+	.ops.len = ipv6_length_check,
+	.ops.next_proto = ipv6_proto,
+};
+
+/* parse_ipv6_stopflowlabel_check protocol node
+ *
+ * Check version is six, parse IPv6 header, and stop at a non-zero flow label
+ *
+ * Next protocol operation returns IP proto number (e.g. IPPROTO_TCP)
+ */
+static const struct panda_proto_node
+				panda_parse_ipv6_stopflowlabel_check
+							__unused() = {
+	.name = "IPv6 stop at non-zero flow label",
+	.min_len = sizeof(struct ipv6hdr),
+	.ops.len = ipv6_length_check,
+	.ops.next_proto = ipv6_proto_stopflowlabel,
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_ipv6_eh.h b/include/net/panda/proto_nodes/proto_ipv6_eh.h
new file mode 100644
index 000000000000..e41131df6f32
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_ipv6_eh.h
@@ -0,0 +1,108 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_IPV6_EH_H__
+#define __PANDA_PROTO_IPV6_EH_H__
+
+/* Generic definitions for IPv6 extension headers */
+
+#ifndef __KERNEL__
+#include <arpa/inet.h>
+#endif
+
+#include <linux/ipv6.h>
+
+#include "net/panda/parser.h"
+
+struct ipv6_frag_hdr {
+	__u8    nexthdr;
+	__u8    reserved;
+	__be16  frag_off;
+	__be32  identification;
+};
+
+#define IP6_MF		0x0001
+#define IP6_OFFSET	0xFFF8
+
+static inline int ipv6_eh_proto(const void *vopt)
+{
+	return ((struct ipv6_opt_hdr *)vopt)->nexthdr;
+}
+
+static inline ssize_t ipv6_eh_len(const void *vopt)
+{
+	return ipv6_optlen((struct ipv6_opt_hdr *)vopt);
+}
+
+static inline int ipv6_frag_proto(const void *vfraghdr)
+{
+	const struct ipv6_frag_hdr *fraghdr = vfraghdr;
+
+	if (fraghdr->frag_off & htons(IP6_OFFSET)) {
+		/* Stop at non-first fragment */
+		return PANDA_STOP_OKAY;
+	}
+
+	return fraghdr->nexthdr;
+}
+
+#endif /* __PANDA_PROTO_IPV6_EH_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+static const struct panda_proto_node panda_parse_ipv6_eh __unused() = {
+	.name = "IPv6 EH",
+	.min_len = sizeof(struct ipv6_opt_hdr),
+	.ops.next_proto = ipv6_eh_proto,
+	.ops.len = ipv6_eh_len,
+};
+
+/* panda_parse_ipv6_eh protocol node
+ *
+ * Parse IPv6 extension header (Destinaion Options, Hop-by-Hop Options,
+ * or Routing Header
+ *
+ * Next protocol operation returns IP proto number (e.g. IPPROTO_TCP)
+ */
+static const struct panda_proto_node panda_parse_ipv6_frag_eh __unused() = {
+	.name = "IPv6 EH",
+	.min_len = sizeof(struct ipv6_frag_hdr),
+	.ops.next_proto = ipv6_frag_proto,
+};
+
+/* panda_parse_ipv6_frag_eh protocol node
+ *
+ * Parse IPv6 fragmentation header, stop parsing at first fragment
+ *
+ * Next protocol operation returns IP proto number (e.g. IPPROTO_TCP)
+ */
+static const struct panda_proto_node panda_parse_ipv6_frag_eh_stop1stfrag
+							__unused() = {
+	.name = "IPv6 EH",
+	.min_len = sizeof(struct ipv6_frag_hdr),
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_ipv6ip.h b/include/net/panda/proto_nodes/proto_ipv6ip.h
new file mode 100644
index 000000000000..d73d95951c6b
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_ipv6ip.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_IPV6IP_H__
+#define __PANDA_PROTO_IPV6IP_H__
+
+/* IPv6 in IP node definitions */
+
+#include <linux/ipv6.h>
+
+#include "net/panda/parser.h"
+
+static inline int ipv6_proto_default(const void *viph)
+{
+	return 0; /* Indicates IPv6 */
+}
+
+#endif /* __PANDA_PROTO_IPV6IP_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* panda_parse_ipv6ip protocol node
+ *
+ * Parses IPv6IP header
+ *
+ * Next protocol operation returns 0 indicating IPv4
+ */
+static const struct panda_proto_node panda_parse_ipv6ip __unused() = {
+	.name = "IPv6 in IP",
+	.encap = 1,
+	.overlay = 1,
+	.min_len = sizeof(struct ipv6hdr),
+	.ops.next_proto = ipv6_proto_default,
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_mpls.h b/include/net/panda/proto_nodes/proto_mpls.h
new file mode 100644
index 000000000000..e3ed5c614b9e
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_mpls.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_MPLS_H__
+#define __PANDA_PROTO_MPLS_H__
+
+/* MPLS node definitions */
+
+#include <linux/mpls.h>
+
+#include "net/panda/parser.h"
+
+#endif /* __PANDA_PROTO_MPLS_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* panda_parse_mpls protocol node
+ *
+ * Parse MPLS header
+ */
+static const struct panda_proto_node panda_parse_mpls __unused() = {
+	.name = "MPLS",
+	.min_len = 2 * sizeof(struct mpls_label),
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_ports.h b/include/net/panda/proto_nodes/proto_ports.h
new file mode 100644
index 000000000000..ff4186bd6ddb
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_ports.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_PORTS_H__
+#define __PANDA_PROTO_PORTS_H__
+
+#include "net/panda/parser.h"
+
+/* Transport nodes with ports definitions */
+
+struct port_hdr {
+	union {
+		__be32   ports;
+		struct {
+			__be16 sport;
+			__be16 dport;
+		};
+	};
+};
+
+#endif /* __PANDA_PROTO_PORTS_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* Generic PANDA parse nodes for transport protocols that contain port
+ * numbers cnanonical location
+ *
+ * Transport header starts with sixteen bit source and destination port
+ * numbers. Applicable protocols include TCP, UDP, SCTP, etc.
+ */
+static const struct panda_proto_node panda_parse_ports __unused() = {
+	.name = "Transport with ports",
+	.min_len = sizeof(struct port_hdr),
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_ppp.h b/include/net/panda/proto_nodes/proto_ppp.h
new file mode 100644
index 000000000000..59b50baef517
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_ppp.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_PPP_H__
+#define __PANDA_PROTO_PPP_H__
+
+#include <linux/ppp_defs.h>
+
+#include "net/panda/parser.h"
+
+/* PPP node definitions */
+
+struct ppp_hdr_proto8 {
+	__u8 address;
+	__u8 control;
+	__u8 protocol;
+};
+
+struct ppp_hdr_proto16 {
+	__u8 address;
+	__u8 control;
+	__be16 protocol;
+};
+
+static inline int ppp_proto(const void *vppp)
+{
+	/*
+	https://tools.ietf.org/html/rfc1661#section-2
+	if most significant byte is odd protcol length is 1 byte
+	*/
+	return ((struct ppp_hdr_proto8*)vppp)->protocol % 2 ? __be16_to_cpu(((struct ppp_hdr_proto8*)vppp)->protocol) : ((struct ppp_hdr_proto16*)vppp)->protocol;
+}
+
+static inline ssize_t ppp_length(const void *vppp)
+{
+	return ((struct ppp_hdr_proto8*)vppp)->protocol % 2 ? sizeof(struct ppp_hdr_proto8) : sizeof(struct ppp_hdr_proto16);
+}
+
+#endif /* __PANDA_PROTO_PPP_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* panda_parse_ppp protocol node
+ *
+ * Parse PPP header
+ *
+ * Next protocol operation returns IP proto number (e.g. IPPROTO_TCP)
+ */
+static const struct panda_proto_node panda_parse_ppp __unused() = {
+	.name = "PPP",
+	.min_len = sizeof(struct ppp_hdr_proto8),
+	.ops.len = ppp_length,
+	.ops.next_proto = ppp_proto,
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_pppoe.h b/include/net/panda/proto_nodes/proto_pppoe.h
new file mode 100644
index 000000000000..75afc4f66ebd
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_pppoe.h
@@ -0,0 +1,98 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_PPPOE_H__
+#define __PANDA_PROTO_PPPOE_H__
+
+#include "net/panda/parser.h"
+
+struct pppoe_hdr_proto8 {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 type : 4;
+	__u8 ver : 4;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u8 ver : 4;
+	__u8 type : 4;
+#else
+#error	"Please fix <asm/byteorder.h>"
+#endif
+	__u8 code;
+	__be16 sid;
+	__be16 length;
+	__u8 protocol;
+} __attribute__((packed));
+
+struct pppoe_hdr_proto16 {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 type : 4;
+	__u8 ver : 4;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u8 ver : 4;
+	__u8 type : 4;
+#else
+#error	"Please fix <asm/byteorder.h>"
+#endif
+	__u8 code;
+	__be16 sid;
+	__be16 length;
+	__be16 protocol;
+} __attribute__((packed));
+
+//int static_assert_global_v[sizeof(struct pppoe_hdr) == 6 ? -1 : 1];
+
+/* PPP node definitions */
+static inline int pppoe_proto(const void *vppp)
+{
+	/*
+	https://tools.ietf.org/html/rfc1661#section-2
+	if most significant byte is odd protcol length is 1 byte
+	*/
+	return ((struct pppoe_hdr_proto8*)vppp)->protocol % 2 ? __be16_to_cpu(((struct pppoe_hdr_proto8*)vppp)->protocol) : ((struct pppoe_hdr_proto16*)vppp)->protocol;
+}
+
+static inline ssize_t pppoe_length(const void *vppp)
+{
+	return ((struct pppoe_hdr_proto8*)vppp)->protocol % 2 ? sizeof(struct pppoe_hdr_proto8) : sizeof(struct pppoe_hdr_proto16);
+}
+
+#endif /* __PANDA_PROTO_PPP_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* panda_parse_ppp protocol node
+ *
+ * Parse PPP header
+ *
+ * Next protocol operation returns IP proto number (e.g. IPPROTO_TCP)
+ */
+static const struct panda_proto_node panda_parse_pppoe __unused() = {
+	.name = "PPPoE",
+	.min_len = sizeof(struct pppoe_hdr_proto8),
+	.ops.len = pppoe_length,
+	.ops.next_proto = pppoe_proto,
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_tcp.h b/include/net/panda/proto_nodes/proto_tcp.h
new file mode 100644
index 000000000000..85e2f930a285
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_tcp.h
@@ -0,0 +1,177 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_TCP_H__
+#define __PANDA_PROTO_TCP_H__
+
+#include <linux/tcp.h>
+
+#include "net/panda/parser.h"
+
+/* TCP node definitions */
+
+#define TCPOPT_NOP		1	/* Padding */
+#define TCPOPT_EOL		0	/* End of options */
+#define TCPOPT_MSS		2	/* Segment size negotiating */
+#define TCPOPT_WINDOW		3	/* Window scaling */
+#define TCPOPT_SACK_PERM	4	/* SACK Permitted */
+#define TCPOPT_SACK		5	/* SACK Block */
+#define TCPOPT_TIMESTAMP	8	/* Better RTT estimations/PAWS */
+#define TCPOPT_MD5SIG		19	/* MD5 Signature (RFC2385) */
+#define TCPOPT_FASTOPEN		34	/* Fast open (RFC7413) */
+#define TCPOPT_EXP		254	/* Experimental */
+
+struct tcp_opt {
+	__u8 type;
+	__u8 len;
+	__u8 data[0];
+};
+
+struct tcp_timestamp_option_data {
+	__be32 value;
+	__be32 echo;
+};
+
+struct tcp_sack_option_data {
+	__be32 left_edge;
+	__be32 right_edge;
+};
+
+#define TCP_MAX_SACKS	4
+
+struct tcp_opt_union {
+	struct tcp_opt opt;
+	union {
+		__be16 mss;
+		__u8 window_scaling;
+		struct tcp_timestamp_option_data timestamp;
+		struct tcp_sack_option_data sack[TCP_MAX_SACKS];
+	} __attribute__((packed));
+} __attribute__((packed));
+
+static inline ssize_t tcp_len(const void *vtcp)
+{
+	return ((struct tcphdr *)vtcp)->doff * 4;
+}
+
+static inline ssize_t tcp_tlv_len(const void *hdr)
+{
+	return ((struct tcp_opt *)hdr)->len;
+}
+
+static inline int tcp_tlv_type(const void *hdr)
+{
+	return ((struct tcp_opt *)hdr)->type;
+}
+
+static inline size_t tcp_tlvs_start_offset(const void *hdr)
+{
+	return sizeof(struct tcphdr);
+}
+
+#endif /* __PANDA_PROTO_TCP_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* PANDA protocol node for TCP
+ *
+ * There are two variants:
+ *   - Parse TCP header and TLVs
+ *   - Just parse header without parsing TLVs
+ */
+
+/* panda_parse_tcp_tlvs protocol node
+ *
+ * Parse TCP header and any TLVs
+ */
+static const struct panda_proto_tlvs_node panda_parse_tcp_tlvs __unused() = {
+	.proto_node.node_type = PANDA_NODE_TYPE_TLVS,
+	.proto_node.name = "TCP with TLVs",
+	.proto_node.min_len = sizeof(struct tcphdr),
+	.proto_node.ops.len = tcp_len,
+	.ops.len = tcp_tlv_len,
+	.ops.type = tcp_tlv_type,
+	.ops.start_offset = tcp_tlvs_start_offset,
+	.pad1_val = TCPOPT_NOP,
+	.pad1_enable = 1,
+	.eol_val = TCPOPT_EOL,
+	.eol_enable = 1,
+	.min_len = sizeof(struct tcp_opt),
+};
+
+/* panda_parse_tcp_no_tlvs protocol node
+ *
+ * Parse TCP header without considering TLVs
+ */
+static const struct panda_proto_node panda_parse_tcp_notlvs __unused() = {
+	.name = "TCP without TLVs",
+	.min_len = sizeof(struct tcphdr),
+	.ops.len = tcp_len,
+};
+
+/* Protocol nodes for individual TLVs */
+
+static const struct panda_proto_tlv_node panda_parse_tcp_option_mss
+							__unused() = {
+	.min_len = sizeof(struct tcp_opt) + sizeof(__be16),
+};
+
+static const struct panda_proto_tlv_node panda_parse_tcp_option_window_scaling
+							__unused() = {
+	.min_len = sizeof(struct tcp_opt) + sizeof(__u8),
+};
+
+static const struct panda_proto_tlv_node panda_parse_tcp_option_timestamp
+							__unused() = {
+	.min_len = sizeof(struct tcp_opt) +
+				sizeof(struct tcp_timestamp_option_data),
+};
+
+static const struct panda_proto_tlv_node panda_parse_tcp_option_sack_1
+							__unused() = {
+	.min_len = sizeof(struct tcp_opt) +
+				sizeof(struct tcp_sack_option_data),
+};
+
+static const struct panda_proto_tlv_node panda_parse_tcp_option_sack_2
+							__unused() = {
+	.min_len = sizeof(struct tcp_opt) +
+				2 * sizeof(struct tcp_sack_option_data),
+};
+
+static const struct panda_proto_tlv_node panda_parse_tcp_option_sack_3
+							__unused() = {
+	.min_len = sizeof(struct tcp_opt) +
+				3 * sizeof(struct tcp_sack_option_data),
+};
+
+static const struct panda_proto_tlv_node panda_parse_tcp_option_sack_4
+							__unused() = {
+	.min_len = sizeof(struct tcp_opt) +
+				4 * sizeof(struct tcp_sack_option_data),
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_tipc.h b/include/net/panda/proto_nodes/proto_tipc.h
new file mode 100644
index 000000000000..761f75a7e4f6
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_tipc.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_TIPC_H__
+#define __PANDA_PROTO_TIPC_H__
+
+/* TIPC node definitions */
+
+#include <linux/ppp_defs.h>
+
+#include "net/panda/parser.h"
+
+/* LINK_PROTOCOL + MSG_IS_KEEPALIVE */
+#define TIPC_KEEPALIVE_MSG_MASK		0x0e080000
+
+struct tipc_basic_hdr {
+	__be32 w[4];
+};
+
+#endif /* __PANDA_PROTO_TIPC_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* panda_parse_tipc protocol node
+ *
+ * Parse TIPC header
+ */
+static const struct panda_proto_node panda_parse_tipc __unused() = {
+	.name = "TIPC",
+	.min_len = sizeof(struct tipc_basic_hdr),
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes/proto_vlan.h b/include/net/panda/proto_nodes/proto_vlan.h
new file mode 100644
index 000000000000..b2db4a8fdfec
--- /dev/null
+++ b/include/net/panda/proto_nodes/proto_vlan.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_VLAN_H__
+#define __PANDA_PROTO_VLAN_H__
+
+#include "net/panda/parser.h"
+
+#define VLAN_PRIO_MASK		0xe000 /* Priority Code Point */
+#define VLAN_PRIO_SHIFT		13
+#define VLAN_VID_MASK		0x0fff /* VLAN Identifier */
+
+/* VLAN node definitions */
+
+#ifndef __KERNEL__
+struct vlan_hdr {
+	__be16  h_vlan_TCI;
+	__be16  h_vlan_encapsulated_proto;
+};
+#endif
+
+static inline int vlan_proto(const void *vvlan)
+{
+	return ((struct vlan_hdr *)vvlan)->h_vlan_encapsulated_proto;
+}
+
+#endif /* __PANDA_PROTO_VLAN_H__ */
+
+#ifdef PANDA_DEFINE_PARSE_NODE
+
+/* panda_parse_vlan protocol node
+ *
+ * Parse VLAN header
+ *
+ * Next protocol operation returns Ethertype (e.g. ETH_P_IPV4)
+ */
+static const struct panda_proto_node panda_parse_vlan __unused() = {
+	.name = "VLAN",
+	.min_len = sizeof(struct vlan_hdr),
+	.ops.next_proto = vlan_proto,
+};
+
+#endif /* PANDA_DEFINE_PARSE_NODE */
diff --git a/include/net/panda/proto_nodes_def.h b/include/net/panda/proto_nodes_def.h
new file mode 100644
index 000000000000..c8fc924e2428
--- /dev/null
+++ b/include/net/panda/proto_nodes_def.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_PROTO_NODES_DEF_H__
+#define __PANDA_PROTO_NODES_DEF_H__
+
+/* Include all proto nodes and define proto nodes */
+
+#define PANDA_DEFINE_PARSE_NODE_STATIC static
+#define PANDA_DEFINE_PARSE_NODE 1
+
+#include "net/panda/proto_nodes.h"
+
+#undef PANDA_DEFINE_PARSE_NODE
+#undef PANDA_DEFINE_PARSE_NODE_STATIC
+
+#endif /* __PANDA_PROTO_NODES_H__ */
diff --git a/include/net/panda/tlvs.h b/include/net/panda/tlvs.h
new file mode 100644
index 000000000000..a3480d698358
--- /dev/null
+++ b/include/net/panda/tlvs.h
@@ -0,0 +1,289 @@
+/* SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+ *
+ * Copyright (c) 2020,2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef __PANDA_TLV_H__
+#define __PANDA_TLV_H__
+
+/* Definitions and functions for processing and parsing TLVs */
+
+#ifndef __KERNEL__
+#include <stddef.h>
+#include <sys/types.h>
+#endif
+
+#include <linux/types.h>
+
+#include "net/panda/parser_types.h"
+
+/* Definitions for parsing TLVs
+ *
+ * TLVs are a common protocol header structure consisting of Type, Length,
+ * Value tuple (e.g. for handling TCP or IPv6 HBH options TLVs)
+ */
+
+/* Descriptor for parsing operations of one type of TLV. Fields are:
+ *
+ * len: Return length of a TLV. Must be set. If the return value < 0 (a
+ *	PANDA_STOP_* return code value) this indicates an error and parsing
+ *	is stopped. A the return value greater than or equal to zero then
+ *	gives the protocol length. If the returned length is less than the
+ *	minimum TLV option length, indicated by min_len by the TLV protocol
+ *	node, then this considered and error.
+ * type: Return the type of the TLV. If the return value is less than zero
+ *	(PANDA_STOP_* value) then this indicates and error and parsing stops
+ */
+struct panda_proto_tlvs_opts {
+	size_t (*start_offset)(const void *hdr);
+	ssize_t (*len)(const void *hdr);
+	int (*type)(const void *hdr);
+};
+
+/* TLV parse node operations
+ *
+ * Operations to process a sigle TLV parsenode
+ *
+ * extract_metadata: Extract metadata for the node. Input is the meta
+ *	data frame which points to a parser defined metadata structure.
+ *	If the value is NULL then no metadata is extracted
+ * handle_tlv: Per TLV type handler which allows arbitrary processing
+ *	of a TLV. Input is the TLV data and a parser defined metadata
+ *	structure for the current frame. Return value is a parser
+ *	return code: PANDA_OKAY indicates no errors, PANDA_STOP* return
+ *	values indicate to stop parsing
+ */
+struct panda_parse_tlv_node_ops {
+	void (*extract_metadata)(const void *hdr, void *frame,
+				 const struct panda_ctrl_data ctrl);
+	int (*handle_tlv)(const void *hdr, void *frame,
+			  const struct panda_ctrl_data ctrl);
+	int (*overlay_type)(const void *hdr);
+};
+
+/* Parse node for a single TLV. Use common parse node operations
+ * (extract_metadata and handle_proto)
+ */
+struct panda_parse_tlv_node {
+	const struct panda_proto_tlv_node *proto_tlv_node;
+	const struct panda_parse_tlv_node_ops tlv_ops;
+	const struct panda_proto_tlvs_table *overlay_table;
+	const struct panda_parse_tlv_node *overlay_wildcard_node;
+	int unknown_overlay_ret;
+	const char *name;
+};
+
+/* One entry in a TLV table:
+ *	value: TLV type
+ *	node: associated TLV parse structure for the type
+ */
+struct panda_proto_tlvs_table_entry {
+	int type;
+	const struct panda_parse_tlv_node *node;
+};
+
+/* TLV table
+ *
+ * Contains a table that maps a TLV type to a TLV parse node
+ */
+struct panda_proto_tlvs_table {
+	int num_ents;
+	const struct panda_proto_tlvs_table_entry *entries;
+};
+
+/* Parse node for parsing a protocol header that contains TLVs to be
+ * parser:
+ *
+ * parse_node: Node for main protocol header (e.g. IPv6 node in case of HBH
+ *	options) Note that node_type is set in parse_node to
+ *	PANDA_NODE_TYPE_TLVS and that the parse node can then be cast to a
+ *	parse_tlv_node
+ * tlv_proto_table: Lookup table for TLV type
+ * max_tlvs: Maximum number of TLVs that are to be parseed in one list
+ * max_tlv_len: Maximum length allowed for any TLV in a list
+ *	one type of TLVS.
+ */
+struct panda_parse_tlvs_node {
+	const struct panda_parse_node parse_node;
+	const struct panda_proto_tlvs_table *tlv_proto_table;
+	size_t max_tlvs;
+	size_t max_tlv_len;
+	int unknown_tlv_type_ret;
+	const struct panda_parse_tlv_node *tlv_wildcard_node;
+};
+
+/* A protocol node for parsing proto with TLVs
+ *
+ * proto_node: proto node
+ * ops: Operations for parsing TLVs
+ * pad1_val: Type value indicating one byte of TLV padding (e.g. would be
+ *	for IPv6 HBH TLVs)
+ * pad1_enable: Pad1 value is used to detect single byte padding
+ * eol_val: Type value that indicates end of TLV list
+ * eol_enable: End of list value in eol_val is used
+ * start_offset: When there TLVs start relative the enapsulating protocol
+ *	(e.g. would be twenty for TCP)
+ * min_len: Minimal length of a TLV option
+ */
+struct panda_proto_tlvs_node {
+	struct panda_proto_node proto_node;
+	struct panda_proto_tlvs_opts ops;
+	__u8 pad1_val;
+	__u8 eol_val;
+	__u8 pad1_enable;
+	__u8 eol_enable;
+	size_t min_len;
+};
+
+/* A protocol node for parsing proto with TLVs
+ *
+ * min_len: Minimal length of TLV
+ */
+struct panda_proto_tlv_node {
+	size_t min_len;
+};
+
+/* Look up a TLV parse node given
+ *
+ * Arguments:
+ *	- node: A TLVs parse node containing lookup table
+ *	- type: TLV type to lookup
+ *
+ * Returns pointer to parse node if the protocol is matched else returns
+ * NULL if the parse node isn't found
+ */
+const struct panda_parse_tlv_node *panda_parse_lookup_tlv(
+				const struct panda_parse_tlvs_node *node,
+				unsigned int type);
+
+/* Helper to create a TLV protocol table */
+#define PANDA_MAKE_TLV_TABLE(NAME, ...)					\
+	static const struct panda_proto_tlvs_table_entry __##NAME[] =	\
+						{ __VA_ARGS__ };	\
+	static const struct panda_proto_tlvs_table NAME = {		\
+		.num_ents = sizeof(__##NAME) /				\
+			sizeof(struct panda_proto_tlvs_table_entry),	\
+		.entries = __##NAME,					\
+	}
+
+/* Forward declarations for TLV parser nodes */
+#define PANDA_DECL_TLVS_PARSE_NODE(TLVS_PARSE_NODE)			\
+	static const struct panda_parse_tlvs_node TLVS_PARSE_NODE
+
+/* Forward declarations for TLV type tables */
+#define PANDA_DECL_TLVS_TABLE(TLVS_TABLE)				\
+	static const struct panda_proto_tlvs_table TLVS_TABLE
+
+/* Helper to create a parse node with a next protocol table */
+#define __PANDA_MAKE_TLVS_PARSE_NODE(PARSE_TLV_NODE, PROTO_TLV_NODE,	\
+				     EXTRACT_METADATA, HANDLER,		\
+				     UNKNOWN_RET, WILDCARD_NODE,	\
+				     UNKNOWN_TLV_TYPE_RET,		\
+				     TLV_WILDCARD_NODE,			\
+				     PROTO_TABLE, TLV_TABLE)		\
+	static const struct panda_parse_tlvs_node PARSE_TLV_NODE = {	\
+		.parse_node.node_type = PANDA_NODE_TYPE_TLVS,		\
+		.parse_node.proto_node = &PROTO_TLV_NODE.proto_node,	\
+		.parse_node.ops.extract_metadata = EXTRACT_METADATA,	\
+		.parse_node.ops.handle_proto = HANDLER,			\
+		.parse_node.unknown_ret = UNKNOWN_RET,			\
+		.parse_node.wildcard_node = WILDCARD_NODE,		\
+		.parse_node.proto_table = PROTO_TABLE,			\
+		.tlv_proto_table = TLV_TABLE,				\
+		.unknown_tlv_type_ret = UNKNOWN_TLV_TYPE_RET,		\
+		.tlv_wildcard_node = TLV_WILDCARD_NODE,			\
+	}
+
+/* Helper to create a TLVs parse node with default unknown next proto
+ * function that returns parse failure code and default unknown TLV
+ * function that ignores unknown TLVs
+ */
+#define PANDA_MAKE_TLVS_PARSE_NODE(PARSE_TLV_NODE, PROTO_TLV_NODE,	\
+				   EXTRACT_METADATA, HANDLER,		\
+				   PROTO_TABLE, TLV_TABLE)		\
+	PANDA_DECL_TLVS_TABLE(TLV_TABLE);				\
+	PANDA_DECL_PROTO_TABLE(PROTO_TABLE)				\
+	__PANDA_MAKE_TLVS_PARSE_NODE(PARSE_TLV_NODE,			\
+				    (PROTO_NODE).pnode,			\
+				    EXTRACT_METADATA, HANDLER,		\
+				    PANDA_STOP_UNKNOWN_PROTO, NULL,	\
+				    PANDA_OKAY, NULL,			\
+				    &PROTO_TABLE, &TLV_TABLE)
+
+/* Helper to create a TLVs parse node with default unknown next proto
+ * function that returns parse failure code and default unknown TLV
+ * function that ignores unknown TLVs
+ */
+#define PANDA_MAKE_TLVS_OVERLAY_PARSE_NODE(PARSE_TLV_NODE,		\
+					   PROTO_TLV_NODE,		\
+					   EXTRACT_METADATA, HANDLER,	\
+					   OVERLAY_NODE, TLV_TABLE)	\
+	PANDA_DECL_TLVS_TABLE(TLV_TABLE);				\
+	__PANDA_MAKE_TLVS_PARSE_NODE(PARSE_TLV_NODE,			\
+				    (PROTO_NODE).pnode,			\
+				    EXTRACT_METADATA, HANDLER,		\
+				    PANDA_STOP_UNKNOWN_PROTO,		\
+				    OVERLAY_NODE, PANDA_OKAY, NULL,	\
+				    &PROTO_TABLE, &TLV_TABLE)
+
+/* Helper to create a leaf TLVs parse node with default unknown TLV
+ * function that ignores unknown TLVs
+ */
+#define PANDA_MAKE_LEAF_TLVS_PARSE_NODE(PARSE_TLV_NODE, PROTO_TLV_NODE,	\
+					EXTRACT_METADATA, HANDLER,	\
+					TLV_TABLE)			\
+	PANDA_DECL_TLVS_TABLE(TLV_TABLE);				\
+	__PANDA_MAKE_TLVS_PARSE_NODE(PARSE_TLV_NODE, PROTO_TLV_NODE,	\
+				     EXTRACT_METADATA, HANDLER,		\
+				     PANDA_STOP_UNKNOWN_PROTO, NULL,	\
+				     PANDA_OKAY, NULL,			\
+				     NULL, &TLV_TABLE)
+
+#define PANDA_MAKE_TLV_PARSE_NODE(NODE_NAME, PROTO_TLV_NODE,		\
+				  METADATA_FUNC, HANDLER_FUNC)		\
+	static const struct panda_parse_tlv_node NODE_NAME = {		\
+		.proto_tlv_node = &PROTO_TLV_NODE,			\
+		.tlv_ops.extract_metadata = METADATA_FUNC,		\
+		.tlv_ops.handle_tlv = HANDLER_FUNC,			\
+		.name = #NODE_NAME,					\
+	}
+
+#define PANDA_MAKE_TLV_OVERLAY_PARSE_NODE(NODE_NAME,			\
+					  METADATA_FUNC, HANDLER_FUNC,	\
+					  OVERLAY_TABLE,		\
+					  OVERLAY_TYPE_FUNC,		\
+					  UNKNOWN_OVERLAY_RET,		\
+					  OVERLAY_WILDCARD_NODE)	\
+	PANDA_DECL_TLVS_TABLE(OVERLAY_TABLE);				\
+	static const struct panda_parse_tlv_node NODE_NAME = {		\
+		.tlv_ops.extract_metadata = METADATA_FUNC,		\
+		.tlv_ops.handle_tlv = HANDLER_FUNC,			\
+		.tlv_ops.overlay_type = OVERLAY_TYPE_FUNC,		\
+		.unknown_overlay_ret = UNKNOWN_OVERLAY_RET,		\
+		.overlay_wildcard_node = OVERLAY_WILDCARD_NODE,		\
+		.overlay_table = &OVERLAY_TABLE,			\
+		.name = #NODE_NAME,					\
+	}
+
+#endif /* __PANDA_TLV_H__ */
diff --git a/net/Kconfig b/net/Kconfig
index fb13460c6dab..9f2ff50d1788 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -455,4 +455,13 @@ config ETHTOOL_NETLINK
 	  netlink. It provides better extensibility and some new features,
 	  e.g. notification messages.
 
+config NET_PANDA
+	bool "PANDA parser"
+	help
+	  If you say Y here, you will be able to classify packets based on
+	  a configurable combination of packet keys and masks.
+
+	  To compile this code as a module, choose M here: the module will
+	  be called cls_flower.
+
 endif   # if NET
diff --git a/net/Makefile b/net/Makefile
index fbfeb8a0bb37..e1f46d0b47b1 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -79,3 +79,4 @@ obj-$(CONFIG_NET_NCSI)		+= ncsi/
 obj-$(CONFIG_XDP_SOCKETS)	+= xdp/
 obj-$(CONFIG_MPTCP)		+= mptcp/
 obj-$(CONFIG_MCTP)		+= mctp/
+obj-$(CONFIG_PANDA)		+= panda/
diff --git a/net/panda/Makefile b/net/panda/Makefile
new file mode 100644
index 000000000000..44420a1edf12
--- /dev/null
+++ b/net/panda/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the Linux networking PANDA parser.
+#
+
+ifeq ($(CONFIG_NET_PANDA),y)
+obj-$(CONFIG_NET_PANDA) += panda_parser.o
+endif
diff --git a/net/panda/panda_parser.c b/net/panda/panda_parser.c
new file mode 100644
index 000000000000..62094a339709
--- /dev/null
+++ b/net/panda/panda_parser.c
@@ -0,0 +1,605 @@
+// SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+/*
+ * Copyright (c) 2020, 2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#include <net/panda/parser.h>
+
+/* Lookup a type in a node table*/
+static const struct panda_parse_node *lookup_node(int type,
+				    const struct panda_proto_table *table)
+{
+	int i;
+
+	for (i = 0; i < table->num_ents; i++)
+		if (type == table->entries[i].value)
+			return table->entries[i].node;
+
+	return NULL;
+}
+
+/* Lookup a type in a node TLV table */
+static const struct panda_parse_tlv_node *lookup_tlv_node(int type,
+				const struct panda_proto_tlvs_table *table)
+{
+	int i;
+
+	for (i = 0; i < table->num_ents; i++)
+		if (type == table->entries[i].type)
+			return table->entries[i].node;
+
+	return NULL;
+}
+
+/* Lookup up a protocol for the table associated with a parse node */
+const struct panda_parse_tlv_node *panda_parse_lookup_tlv(
+		const struct panda_parse_tlvs_node *node,
+		unsigned int type)
+{
+	return lookup_tlv_node(type, node->tlv_proto_table);
+}
+
+/* Lookup a flag-fields index in a protocol node flag-fields table */
+static const struct panda_parse_flag_field_node *lookup_flag_field_node(int idx,
+				const struct panda_proto_flag_fields_table
+								*table)
+{
+	int i;
+
+	for (i = 0; i < table->num_ents; i++)
+		if (idx == table->entries[i].index)
+			return table->entries[i].node;
+
+	return NULL;
+}
+
+static int panda_parse_one_tlv(
+		const struct panda_parse_tlvs_node *parse_tlvs_node,
+		const struct panda_parse_tlv_node *parse_tlv_node,
+		const void *hdr, void *frame, int type,
+		struct panda_ctrl_data tlv_ctrl, unsigned int flags)
+{
+	const struct panda_proto_tlv_node *proto_tlv_node =
+					parse_tlv_node->proto_tlv_node;
+	const struct panda_parse_tlv_node_ops *ops;
+	int ret;
+
+parse_again:
+
+	if (flags & PANDA_F_DEBUG)
+		printf("PANDA parsing TLV %s\n", parse_tlv_node->name);
+
+	if (proto_tlv_node && (tlv_ctrl.hdr_len < proto_tlv_node->min_len)) {
+		/* Treat check length error as an unrecognized TLV */
+		parse_tlv_node = parse_tlvs_node->tlv_wildcard_node;
+		if (parse_tlv_node)
+			goto parse_again;
+		else
+			return parse_tlvs_node->unknown_tlv_type_ret;
+	}
+
+	ops = &parse_tlv_node->tlv_ops;
+
+	if (ops->extract_metadata)
+		ops->extract_metadata(hdr, frame, tlv_ctrl);
+
+	if (ops->handle_tlv) {
+		ret = ops->handle_tlv(hdr, frame, tlv_ctrl);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	if (!parse_tlv_node->overlay_table)
+		return PANDA_OKAY;
+
+	/* We have an TLV overlay  node */
+
+	if (parse_tlv_node->tlv_ops.overlay_type)
+		type = parse_tlv_node->tlv_ops.overlay_type(hdr);
+	else
+		type = tlv_ctrl.hdr_len;
+
+	/* Get TLV node */
+	parse_tlv_node = lookup_tlv_node(type, parse_tlv_node->overlay_table);
+	if (parse_tlv_node)
+		goto parse_again;
+
+	/* Unknown TLV overlay node */
+	parse_tlv_node = parse_tlv_node->overlay_wildcard_node;
+	if (parse_tlv_node)
+		goto parse_again;
+
+	return parse_tlv_node->unknown_overlay_ret;
+}
+
+static int panda_parse_tlvs(const struct panda_parse_node *parse_node,
+			    const void *hdr, void *frame,
+			    const struct panda_ctrl_data ctrl,
+			    unsigned int flags)
+{
+	const struct panda_parse_tlvs_node *parse_tlvs_node;
+	const struct panda_proto_tlvs_node *proto_tlvs_node;
+	const struct panda_parse_tlv_node *parse_tlv_node;
+	size_t off, len, offset = ctrl.hdr_offset;
+	struct panda_ctrl_data tlv_ctrl;
+	const __u8 *cp = hdr;
+	ssize_t tlv_len;
+	int type, ret;
+
+	parse_tlvs_node = (struct panda_parse_tlvs_node *)parse_node;
+	proto_tlvs_node = (struct panda_proto_tlvs_node *)
+						parse_node->proto_node;
+
+	/* Assume hlen marks end of TLVs */
+	off = proto_tlvs_node->ops.start_offset(hdr);
+
+	/* We assume start offset is less than or equal to minimal length */
+	len = ctrl.hdr_len - off;
+
+	cp += off;
+	offset += off;
+
+	while (len > 0) {
+		if (proto_tlvs_node->pad1_enable &&
+		   *cp == proto_tlvs_node->pad1_val) {
+			/* One byte padding, just advance */
+			cp++;
+			offset++;
+			len--;
+			continue;
+		}
+
+		if (proto_tlvs_node->eol_enable &&
+		    *cp == proto_tlvs_node->eol_val) {
+			cp++;
+			offset++;
+			len--;
+
+			/* Hit EOL, we're done */
+			break;
+		}
+
+		if (len < proto_tlvs_node->min_len) {
+			/* Length error */
+			return PANDA_STOP_TLV_LENGTH;
+		}
+
+		/* If the len function is not set this degenerates to an
+		 * array of fixed sized values (which maybe be useful in
+		 * itself now that I think about it)
+		 */
+		if (proto_tlvs_node->ops.len) {
+			tlv_len = proto_tlvs_node->ops.len(cp);
+			if (!tlv_len || len < tlv_len)
+				return PANDA_STOP_TLV_LENGTH;
+
+			if (tlv_len < proto_tlvs_node->min_len)
+				return tlv_len < 0 ? tlv_len :
+						PANDA_STOP_TLV_LENGTH;
+		} else {
+			tlv_len = proto_tlvs_node->min_len;
+		}
+
+		tlv_ctrl.hdr_len = tlv_len;
+		tlv_ctrl.hdr_offset = offset;
+
+		type = proto_tlvs_node->ops.type(cp);
+
+		/* Get TLV node */
+		parse_tlv_node = lookup_tlv_node(type,
+				parse_tlvs_node->tlv_proto_table);
+		if (parse_tlv_node) {
+parse_one_tlv:
+			ret = panda_parse_one_tlv(parse_tlvs_node,
+						  parse_tlv_node, cp, frame,
+						  type, tlv_ctrl, flags);
+			if (ret != PANDA_OKAY)
+				return ret;
+		} else {
+			/* Unknown TLV */
+			parse_tlv_node = parse_tlvs_node->tlv_wildcard_node;
+			if (parse_tlv_node) {
+				/* If a wilcard node is present parse that
+				 * node as an overlay to this one. The
+				 * wild card node can perform error processing
+				 */
+				goto parse_one_tlv;
+			} else {
+				/* Return default error code. Returning
+				 * PANDA_OKAY means skip
+				 */
+				if (parse_tlvs_node->unknown_tlv_type_ret !=
+				    PANDA_OKAY)
+					return
+					  parse_tlvs_node->unknown_tlv_type_ret;
+			}
+		}
+
+		/* Move over current header */
+		cp += tlv_len;
+		offset += tlv_len;
+		len -= tlv_len;
+	}
+
+	return PANDA_OKAY;
+}
+
+static int panda_parse_flag_fields(const struct panda_parse_node *parse_node,
+				   const void *hdr, void *frame,
+				   struct panda_ctrl_data ctrl,
+				   unsigned int pflags)
+{
+	const struct panda_parse_flag_fields_node *parse_flag_fields_node;
+	const struct panda_proto_flag_fields_node *proto_flag_fields_node;
+	const struct panda_parse_flag_field_node *parse_flag_field_node;
+	const struct panda_flag_fields *flag_fields;
+	size_t offset = ctrl.hdr_offset, ioff;
+	ssize_t off;
+	__u32 flags;
+	int i;
+
+	parse_flag_fields_node =
+			(struct panda_parse_flag_fields_node *)parse_node;
+	proto_flag_fields_node =
+			(struct panda_proto_flag_fields_node *)
+						parse_node->proto_node;
+	flag_fields = proto_flag_fields_node->flag_fields;
+
+	flags = proto_flag_fields_node->ops.get_flags(hdr);
+
+	/* Position at start of field data */
+	ioff = proto_flag_fields_node->ops.start_fields_offset(hdr);
+	hdr += ioff;
+	offset += ioff;
+
+	for (i = 0; i < flag_fields->num_idx; i++) {
+		off = panda_flag_fields_offset(i, flags, flag_fields);
+		if (off < 0)
+			continue;
+
+		/* Flag field is present, try to find in the parse node
+		 * table based on index in proto flag-fields
+		 */
+		parse_flag_field_node = lookup_flag_field_node(i,
+			parse_flag_fields_node->flag_fields_proto_table);
+		if (parse_flag_field_node) {
+			const struct panda_parse_flag_field_node_ops
+				*ops = &parse_flag_field_node->ops;
+			struct panda_ctrl_data flag_ctrl;
+			const __u8 *cp = hdr + off;
+
+			flag_ctrl.hdr_len = flag_fields->fields[i].size;
+			flag_ctrl.hdr_offset = offset + off;
+
+			if (pflags & PANDA_F_DEBUG)
+				printf("PANDA parsing flag-field %s\n",
+				      parse_flag_field_node->name);
+
+			if (ops->extract_metadata)
+				ops->extract_metadata(cp, frame, flag_ctrl);
+
+			if (ops->handle_flag_field)
+				ops->handle_flag_field(cp, frame, flag_ctrl);
+		}
+	}
+
+	return PANDA_OKAY;
+}
+
+/* Parse a packet
+ *
+ * Arguments:
+ *   - parser: Parser being invoked
+ *   - node: start root node (may be different than parser->root_node)
+ *   - hdr: pointer to start of packet
+ *   - len: length of packet
+ *   - metadata: metadata structure
+ *   - start_node: first node (typically node_ether)
+ *   - flags: allowed parameterized parsing
+ */
+int __panda_parse(const struct panda_parser *parser, const void *hdr,
+		  size_t len, struct panda_metadata *metadata,
+		  unsigned int flags, unsigned int max_encaps)
+{
+	const struct panda_parse_node *parse_node = parser->root_node;
+	const struct panda_parse_node *next_parse_node;
+	void *frame = metadata->frame_data;
+	struct panda_ctrl_data ctrl;
+	unsigned int frame_num = 0;
+	const void *base_hdr = hdr;
+	int type, ret;
+
+	/* Main parsing loop. The loop normal teminates when we encounter a
+	 * leaf protocol node, an error condition, hitting limit on layers of
+	 * encapsulation, protocol condition to stop (i.e. flags that
+	 * indicate to stop at flow label or hitting fragment), or
+	 * unknown protocol result in table lookup for next node.
+	 */
+
+	do {
+		const struct panda_proto_node *proto_node =
+						parse_node->proto_node;
+		ssize_t hlen = proto_node->min_len;
+
+		/* Protocol node length checks */
+
+		if (flags & PANDA_F_DEBUG)
+			printf("PANDA parsing %s\n", proto_node->name);
+
+		if (len < hlen)
+			return PANDA_STOP_LENGTH;
+
+		if (proto_node->ops.len) {
+			hlen = proto_node->ops.len(hdr);
+			if (len < hlen)
+				return PANDA_STOP_LENGTH;
+
+			if (hlen < proto_node->min_len)
+				return hlen < 0 ? hlen : PANDA_STOP_LENGTH;
+		} else {
+			hlen = proto_node->min_len;
+		}
+
+		ctrl.hdr_len = hlen;
+		ctrl.hdr_offset = hdr - base_hdr;
+
+		/* Callback processing order
+		 *    1) Extract Metadata
+		 *    2) Process TLVs
+		 *	2.a) Extract metadata from TLVs
+		 *	2.b) Process TLVs
+		 *    3) Process protocol
+		 */
+
+		/* Extract metadata, per node processing */
+
+		if (parse_node->ops.extract_metadata)
+			parse_node->ops.extract_metadata(hdr, frame, ctrl);
+
+		switch (parse_node->node_type) {
+		case PANDA_NODE_TYPE_PLAIN:
+		default:
+			break;
+		case PANDA_NODE_TYPE_TLVS:
+			/* Process TLV nodes */
+			if (parse_node->proto_node->node_type ==
+			    PANDA_NODE_TYPE_TLVS) {
+				/* Need error in case parse_node is TLVs type
+				 * but proto_node is not TLVs type
+				 */
+				ret = panda_parse_tlvs(parse_node, hdr, frame,
+						       ctrl, flags);
+				if (ret != PANDA_OKAY)
+					return ret;
+			}
+			break;
+		case PANDA_NODE_TYPE_FLAG_FIELDS:
+			/* Process flag-fields */
+			if (parse_node->proto_node->node_type ==
+						PANDA_NODE_TYPE_FLAG_FIELDS) {
+				/* Need error in case parse_node is flag-fields
+				 * type but proto_node is not flag-fields type
+				 */
+				ret = panda_parse_flag_fields(parse_node, hdr,
+							      frame, ctrl,
+							      flags);
+				if (ret != PANDA_OKAY)
+					return ret;
+			}
+			break;
+		}
+
+		/* Process protocol */
+		if (parse_node->ops.handle_proto)
+			parse_node->ops.handle_proto(hdr, frame, ctrl);
+
+		/* Proceed to next protocol layer */
+
+		if (!parse_node->proto_table && !parse_node->wildcard_node) {
+			/* Leaf parse node */
+
+			return PANDA_STOP_OKAY;
+		}
+
+		if (proto_node->encap) {
+			/* New encapsulation leyer. Check against
+			 * number of encap layers allowed and also
+			 * if we need a new metadata frame.
+			 */
+			if (++metadata->encaps > max_encaps)
+				return PANDA_STOP_ENCAP_DEPTH;
+
+			if (metadata->max_frame_num > frame_num) {
+				frame += metadata->frame_size;
+				frame_num++;
+			}
+		}
+
+		if (proto_node->ops.next_proto && parse_node->proto_table) {
+			/* Lookup next proto */
+
+			type = proto_node->ops.next_proto(hdr);
+			if (type < 0)
+				return type;
+
+			/* Get next node */
+			next_parse_node = lookup_node(type,
+						parse_node->proto_table);
+
+			if (next_parse_node)
+				goto found_next;
+		}
+
+		/* Try wildcard node. Either table lookup failed to find a node
+		 * or there is only a wildcard
+		 */
+		if (parse_node->wildcard_node) {
+			/* Perform default processing in a wildcard node */
+
+			next_parse_node = parse_node->wildcard_node;
+		} else {
+			/* Return default code. Parsing will stop
+			 * with the inidicated code
+			 */
+
+			return parse_node->unknown_ret;
+		}
+
+found_next:
+		/* Found next protocol node, set up to process */
+
+		if (!proto_node->overlay) {
+			/* Move over current header */
+			hdr += hlen;
+			len -= hlen;
+		}
+
+		parse_node = next_parse_node;
+
+	} while (1);
+}
+
+struct panda_parser *panda_parser_create(const char *name,
+					 const struct panda_parse_node
+								*root_node)
+{
+	struct panda_parser *parser;
+
+	parser = calloc(1, sizeof(*parser));
+	if (!parser)
+		return NULL;
+
+	parser->name = name;
+	parser->root_node = root_node;
+
+	return parser;
+}
+
+static
+struct panda_parser *panda_parser_opt_create(const char *name,
+				const struct panda_parse_node *root_node,
+				panda_parser_opt_entry_point parser_entry_point)
+{
+	struct panda_parser *parser;
+
+	parser = calloc(1, sizeof(*parser));
+	if (!parser)
+		return NULL;
+
+	parser->name = name;
+	parser->root_node = root_node;
+	parser->parser_type = PANDA_OPTIMIZED;
+	parser->parser_entry_point = parser_entry_point;
+
+	return parser;
+}
+
+void panda_parser_destroy(struct panda_parser *parser)
+{
+	free(parser);
+}
+
+siphash_key_t __panda_hash_key;
+void panda_hash_secret_init(siphash_key_t *init_key)
+{
+	if (init_key) {
+		__panda_hash_key = *init_key;
+	} else {
+		__u8 *bytes = (__u8 *)&__panda_hash_key;
+		int i;
+
+		for (i = 0; i < sizeof(__panda_hash_key); i++)
+			bytes[i] = rand();
+	}
+}
+
+void panda_print_hash_input(const void *start, size_t len)
+{
+	const __u8 *data = start;
+	int i;
+
+	printf("Hash input (size %lu): ", len);
+	for (i = 0; i < len; i++)
+		printf("%02x ", data[i]);
+	printf("\n");
+}
+
+/* Create a dummy parser to ensure that the section is defined */
+static struct panda_parser_def PANDA_SECTION_ATTR(panda_parsers) dummy_parser;
+
+int panda_parser_init(void)
+{
+	const struct panda_parser_def *def_base =
+					panda_section_base_panda_parsers();
+	int i, j;
+
+	for (i = 0; i < panda_section_array_size_panda_parsers(); i++) {
+		const struct panda_parser_def *def = &def_base[i];
+
+		if (!def->name && !def->root_node)
+			continue;
+
+		switch (def->parser_type) {
+		case  PANDA_GENERIC:
+			*def->parser = panda_parser_create(def->name,
+							   def->root_node);
+			if (!def->parser) {
+				fprintf(stderr, "Create parser \"%s\" failed\n",
+					def->name);
+				goto fail;
+			}
+			break;
+		case PANDA_OPTIMIZED:
+			*def->parser = panda_parser_opt_create(def->name,
+						def->root_node,
+						def->parser_entry_point);
+			if (!def->parser) {
+				fprintf(stderr, "Create parser \"%s\" failed\n",
+					def->name);
+				goto fail;
+			}
+			break;
+		default:
+			goto fail;
+		}
+	}
+
+	return 0;
+
+fail:
+	for (j = 0; j < i; j++) {
+		const struct panda_parser_def *def = &def_base[i];
+
+		panda_parser_destroy(*def->parser);
+		*def->parser = NULL;
+	}
+	return -1;
+}
+
+module_init(panda_parser_init);
+module_exit(panda_parser_exit);
+
+MODULE_AUTHOR("Tom Herbert <tom@expertise.dev>");
+MODULE_DESCRIPTION("PANDA parser");
+MODULE_LICENSE("GPL v2");
-- 
2.33.0

