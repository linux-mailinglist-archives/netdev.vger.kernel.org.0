Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C442C60DC7D
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 09:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbiJZHvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 03:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbiJZHvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 03:51:21 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BC272682
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 00:51:10 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d24so13281635pls.4
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 00:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tixdFHR45z7pEuUePaQUniCdAkz42QDR32YoI0elqUM=;
        b=HVHtkvNN1eC3kBZkWeSHqc9Z128sRXaGZMqkMvPntPD1xyhQZNgv1Vf5nYEjd8+WLl
         ctV9+ghQt2sx9mBweil+UBw3y6dLIWsTysqduQiQDjlhGiSYs24jqRk/6Dva2C539HEF
         CsD5Qhnhatri5fbNnfiO2ei7RoVirscZi38JniJ31qXOfCT7Qm6Irw3z5Z6Fbq5xF0vQ
         HrlDb4g4qQ1q+vzT51QRzHbRMNdvMYDWHQqUFh5hUk3gfR38l2wQ1f8XzRNhXF9KE+95
         jRX1IIFmJ/KGxSwZpQQxDfwTIpqEzcBdUHwsiY0VlPBK9yz44uU9TGg//YsecZRBnXQS
         DL0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tixdFHR45z7pEuUePaQUniCdAkz42QDR32YoI0elqUM=;
        b=J4MUHTiWwJ5BHP6X6yIsIYbuWWACtFWgqxchUsAW2/Vq/O80UFx2gXLEBu8Qw8cmky
         M/bT/BuJbpTD0m5ECPe3Qyf9JFAX4LiZ4cF1DMdX2ki414B70Ax3vVcVMZ5tvnVid4HV
         PS+KlRCLzqMOzCFAO6BIokqODci2GYGvjVLqrI+s7uBlXixizI9icg09RBYIChJnpi3B
         sV6SjwVVdcaCMbRjWVGRg1ndfIOE6Caui9L2A+I5+LShGEKt1ieb5+czUUNAdzcd07nI
         2ROj+1XQOVuKKbl2ubFCg7+126cPMIoUqqeMw6D9ou2Qn8wXnhNruemwUUPyjVzsCN3U
         kluQ==
X-Gm-Message-State: ACrzQf3slzGDlHoDk7hMYKAwllHn2qqBJia37xNmvqwcrqnfpNi1zbIZ
        DAwT3XR7e0hLHshGW6D43RQeb+zCRwDGcA==
X-Google-Smtp-Source: AMsMyM7u5MqXH/bg2vRWHypy25q8vRC/uMgaX00pW6ZCvdd3QfgJLSXyAJnE+8gkvfvHO0mLBV3LfQ==
X-Received: by 2002:a17:90b:4d84:b0:212:c78f:8d6e with SMTP id oj4-20020a17090b4d8400b00212c78f8d6emr2755971pjb.201.1666770668430;
        Wed, 26 Oct 2022 00:51:08 -0700 (PDT)
Received: from linkdev2.localdomain ([49.37.37.214])
        by smtp.gmail.com with ESMTPSA id w20-20020a170902ca1400b001714e7608fdsm2310913pld.256.2022.10.26.00.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 00:51:07 -0700 (PDT)
From:   Pratyush Kumar Khan <pratyush@sipanda.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     tom@sipanda.io, abuduri@ventanamicro.com, chethan@sipanda.io,
        Pratyush <pratyush@sipanda.io>
Subject: [RFC PATCH 1/4] kParser: Add new kParser KMOD
Date:   Wed, 26 Oct 2022 13:20:51 +0530
Message-Id: <20221026075054.119069-2-pratyush@sipanda.io>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221026075054.119069-1-pratyush@sipanda.io>
References: <20221026075054.119069-1-pratyush@sipanda.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pratyush <pratyush@sipanda.io>

kParser, or the "Kernel Parser" is a highly programmable, high
performance protocol parser in the Linux network stack. An instance
of kParser is programmed by "ip parser ..." commands in iproute2.

The kParser is dynamically programmable and script-able. For instance,
to add new protocol to parse in an existing instance of kparser, CLI
commands are executed -- there is no need to write user code or perform
a recompile of the parser.

A parser is programmed through the "ip parser" CLI, and common netlink
interfaces are used to instantiate a parser in the kernel. A parser is
defined by a parse graph which is implemented by kparser as a set of
parse node definitions and protocol tables that describe the linkages
between the nodes. Per its program, a kparser instance will report
metadata about the packet and various protocols layers of the packet.
Metadata is any information about the packet including header offsets
and value of fields of interest to the programmer; the later is
analogous to the flow information extracted by flow dissector (the
primary difference being that kParser can extract arbitrary protocol
fields and report on fields in multiple layers of encapsulation).

kParser is called in the kernel by the kparser_parse and
__kparser_parse functions. The output returned is a set metadata about
the parsed packet. Metadata is any information that the parser is
programmed to report about a packet (e.g. offsets of various headers,
extracted IP addresses and ports, etc.). A pointer to a metadata buffer
is input to kparser_parse, kparser will fill in the metadata as per
the programming of the parser. Note that the structure of the metadata
buffer is determined by the programmer, when the buffer is returned
the caller can cast the buffer to the data structure for that parser.

The iproute2 CLI for the kParser works in tandem with the KMOD kParser
to configure any number of parser instances. If kParser KMOD is not
statically compiled with Linux kernel, it needs to be additionally enabled,
compiled and loaded to use the iproute2 CLI for kParser. Please note that
the kParser CLI is scriptable meaning the parser configuration in the
kernel can by dynamically updated without need to recompile any code or
reload kernel module.

Change description:
Global header file include/net/kparser.h exports the kParser datapath
KMOD APIs. The APIs are:

/* kparser_parse(): Function to parse a skb using a parser instance key.
 *
 * skb: input packet skb
 * kparser_key: key of the associated kParser parser object which must
 *     be already created via CLI.
 * _metadata: User provided metadata buffer. It must be same as
 *
 * configured metadata objects in CLI.
 * metadata_len: Total length of the user provided metadata buffer.
 *
 * return: kParser error code as defined in include/uapi/linux/kparser.h
 */
        int kparser_parse(struct sk_buff *skb,
                          const struct kparser_hkey *kparser_key,
                          void *_metadata, size_t metadata_len);

/* __kparser_parse(): Function to parse a void * packet buffer using a
 * parser instance key.
 *
 * parser: Non NULL kparser_get_parser() returned and cached opaque
 *     pointer referencing a valid parser instance.
 * _hdr: input packet buffer
 * parse_len: length of input packet buffer
 * _metadata: User provided metadata buffer. It must be same as
 *     configured metadata objects in CLI.
 * metadata_len: Total length of the user provided metadata buffer.
 *
 * return: kParser error code as defined in include/uapi/linux/kparser.h
 */
        int __kparser_parse(const void *parser, void *_hdr,
                            size_t parse_len, void *_metadata,
                            size_t metadata_len);

/* kparser_get_parser(): Function to get an opaque reference of a parser
 * instance and mark it immutable so that while actively using, it can
 * not be deleted. The parser is identified by a key. It marks  the
 * associated parser and whole parse tree immutable so that when it is
 * locked, it can not be deleted.
 *
 * kparser_key: key of the associated kParser parser object which must
 *     be already created via CLI.
 *
 * return: NULL if key not found, else an opaque parser instance pointer
 *     which can be used in the following APIs 3 and 4.
 *
 * NOTE: This call makes the whole parser tree immutable. If caller
 * calls this more than once, later caller will need to release the same
 * parser exactly that many times using the API kparser_put_parser().
 */
        const void *kparser_get_parser(const struct kparser_hkey
                                       *kparser_key);

/* kparser_put_parser(): Function to return and undo the read only
 * operation done previously by kparser_get_parser(). The parser
 * instance is identified by using a previously obtained opaque parser
 * pointer via API kparser_get_parser(). This undo the immutable
 * change so that any component of the whole parse tree can be deleted
 * again.
 *
 * parser: void *, Non NULL opaque pointer which was previously returned
 *     by kparser_get_parser(). Caller can use cached opaque pointer as
 *     long as system does not restart and kparser.ko is not reloaded.
 *
 * return: boolean, true if put operation is success, else false.
 *
 * NOTE: This call makes the whole parser tree deletable for the very
 * last call.
 */
        bool kparser_put_parser(const void *parser);

Global header file include/uapi/linux/kparser.h exports the shared data
structures and constants with user space, i.e. ip

kParser KMOD is integrated with Linux kernel using changes in
net/Kconfig and net/Makefile

net/kparser/kparser.h is KMOD kParser's private header file.

net/kparser/kparser_main.c is kParser KMOD's main module source file
with netlink opcode handlers

net/kparser/kparser_cmds.c implements kParser KMOD-CLI management API
layer

net/kparser/kparser_cmds_ops.c implements kParser KMOD-CLI debug dump
operations

net/kparser/kparser_cmds_ops.c implements kParser KMOD-CLI netlink
request operations handlers

net/kparser/kparser_condexpr.h is kParser conditionals helper and
structures header file

net/kparser/kparser_datapath.c kParser main datapath source file for
parsing logic - data path

net/kparser/kparser_metaextract.h implements kParser metadata helper
and structures

net/kparser/kparser_types.h implements kParser private datapath
configuration structures

Example CLI: Five tuple parser with header offsets
==============================================

Now we can refer to an example kParser configuration which can parse
simple IPv4 five tuples, i.e. IPv4 header offset, offset of IPv4 addresses,
IPv4 protocol number, L4 header offset (i.e. TCP/UDP) and L4 port numbers.
The sample ip commands are:

ip parser create md-rule name md.iphdr_offset type offset md-off 0
ip parser create md-rule name md.ipaddrs src-hdr-off 12 length 8 md-off 4
ip parser create md-rule name md.l4_hdr.offset type offset md-off 2
ip parser create md-rule name md.ports src-hdr-off 0 length 4 md-off 12 \
	isendianneeded true
ip parser create node name node.ports hdr.minlen 4	\
	md-rule md.l4_hdr.offset md-rule md.ports
ip parser create node name node.ipv4 hdr.minlen 20 hdr.len-field-off 0 \
	hdr.len-field-len 1 \
hdr.len-field-mask 0x0f hdr.len-field-multiplier 4 nxt.field-off 9 \
	nxt.field-len 1 nxt.table-ent 6:node.ports \
	nxt.table-ent 17:node.ports md-rule md.iphdr_offset \
	md-rule md.ipaddrs
ip parser create node name node.ether hdr.minlen 14 nxt.offset 12 \
	nxt.length 2 nxt.table-ent 0x800:node.ipv4
ip parser create parser name tuple_parser rootnode node.ether \
	base-metametadata-size 14

This sample parser will parse Ethernet/IPv4 to UDP and TCP, report the
offsets of the innermost IP and TCP or UDP header, extract IPv4
addresses and UDP or TCP ports (into a frame).

Signed-off-by: Pratyush Kumar Khan <pratyush@sipanda.io>
---
 include/net/kparser.h               |   90 +
 include/uapi/linux/kparser.h        |  678 +++++
 net/Kconfig                         |    9 +
 net/Makefile                        |    1 +
 net/kparser/Makefile                |   10 +
 net/kparser/kparser.h               |  391 +++
 net/kparser/kparser_cmds.c          |  898 +++++++
 net/kparser/kparser_cmds_dump_ops.c |  532 ++++
 net/kparser/kparser_cmds_ops.c      | 3621 +++++++++++++++++++++++++++
 net/kparser/kparser_condexpr.h      |   52 +
 net/kparser/kparser_datapath.c      | 1094 ++++++++
 net/kparser/kparser_main.c          |  325 +++
 net/kparser/kparser_metaextract.h   |  896 +++++++
 net/kparser/kparser_types.h         |  586 +++++
 14 files changed, 9183 insertions(+)
 create mode 100644 include/net/kparser.h
 create mode 100644 include/uapi/linux/kparser.h
 create mode 100644 net/kparser/Makefile
 create mode 100644 net/kparser/kparser.h
 create mode 100644 net/kparser/kparser_cmds.c
 create mode 100644 net/kparser/kparser_cmds_dump_ops.c
 create mode 100644 net/kparser/kparser_cmds_ops.c
 create mode 100644 net/kparser/kparser_condexpr.h
 create mode 100644 net/kparser/kparser_datapath.c
 create mode 100644 net/kparser/kparser_main.c
 create mode 100644 net/kparser/kparser_metaextract.h
 create mode 100644 net/kparser/kparser_types.h

diff --git a/include/net/kparser.h b/include/net/kparser.h
new file mode 100644
index 000000000000..3ee3bd0226fa
--- /dev/null
+++ b/include/net/kparser.h
@@ -0,0 +1,90 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2022, SiPanda Inc.
+ *
+ * kparser.h - kParser global net header file
+ *
+ * Authors:     Pratyush Kumar Khan <pratyush@sipanda.io>
+ */
+
+#ifndef _NET_KPARSER_H
+#define _NET_KPARSER_H
+
+#include <linux/kparser.h>
+#include <linux/skbuff.h>
+
+/* The kParser data path API can consume max 512 bytes */
+#define KPARSER_MAX_SKB_PACKET_LEN	512
+
+/* kparser_parse(): Function to parse a skb using a parser instance key.
+ *
+ * skb: input packet skb
+ * kparser_key: key of the associated kParser parser object which must be
+ *              already created via CLI.
+ * _metadata: User provided metadata buffer. It must be same as configured
+ *            metadata objects in CLI.
+ * metadata_len: Total length of the user provided metadata buffer.
+ *
+ * return: kParser error code as defined in include/uapi/linux/kparser.h
+ */
+extern int kparser_parse(struct sk_buff *skb,
+			 const struct kparser_hkey *kparser_key,
+			 void *_metadata, size_t metadata_len);
+
+/* __kparser_parse(): Function to parse a void * packet buffer using a parser instance key.
+ *
+ * parser: Non NULL kparser_get_parser() returned and cached opaque pointer
+ * referencing a valid parser instance.
+ * _hdr: input packet buffer
+ * parse_len: length of input packet buffer
+ * _metadata: User provided metadata buffer. It must be same as configured
+ * metadata objects in CLI.
+ * metadata_len: Total length of the user provided metadata buffer.
+ *
+ * return: kParser error code as defined in include/uapi/linux/kparser.h
+ */
+extern int __kparser_parse(const void *parser, void *_hdr,
+			   size_t parse_len, void *_metadata, size_t metadata_len);
+
+/* kparser_get_parser(): Function to get an opaque reference of a parser instance and mark it
+ * immutable so that while actively using, it can not be deleted. The parser is identified by a key.
+ * It marks the associated parser and whole parse tree immutable so that when it is locked, it can
+ * not be deleted.
+ *
+ * kparser_key: key of the associated kParser parser object which must be
+ * already created via CLI.
+ *
+ * return: NULL if key not found, else an opaque parser instance pointer which
+ * can be used in the following APIs 3 and 4.
+ *
+ * NOTE: This call makes the whole parser tree immutable. If caller calls this
+ * more than once, later caller will need to release the same parser exactly that
+ * many times using the API kparser_put_parser().
+ */
+extern const void *kparser_get_parser(const struct kparser_hkey *kparser_key);
+
+/* kparser_put_parser(): Function to return and undo the read only operation done previously by
+ * kparser_get_parser(). The parser instance is identified by using a previously obtained opaque
+ * parser pointer via API kparser_get_parser(). This undo the immutable change so that any component
+ * of the whole parse tree can be deleted again.
+ *
+ * parser: void *, Non NULL opaque pointer which was previously returned by kparser_get_parser().
+ * Caller can use cached opaque pointer as long as system does not restart and kparser.ko is not
+ * reloaded.
+ *
+ * return: boolean, true if put operation is success, else false.
+ *
+ * NOTE: This call makes the whole parser tree deletable for the very last call.
+ */
+extern bool kparser_put_parser(const void *parser);
+
+/* net/core/filter.c's callback hook structure to use kParser APIs if kParser enabled */
+struct get_kparser_funchooks {
+	const void * (*kparser_get_parser_hook)(const struct kparser_hkey *kparser_key);
+	int (*__kparser_parse_hook)(const void *parser, void *_hdr,
+				    size_t parse_len, void *_metadata, size_t metadata_len);
+	bool (*kparser_put_parser_hook)(const void *prsr);
+};
+
+extern struct get_kparser_funchooks kparser_funchooks;
+
+#endif /* _NET_KPARSER_H */
diff --git a/include/uapi/linux/kparser.h b/include/uapi/linux/kparser.h
new file mode 100644
index 000000000000..2297355a31c0
--- /dev/null
+++ b/include/uapi/linux/kparser.h
@@ -0,0 +1,678 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+/* Copyright (c) 2022, SiPanda Inc.
+ *
+ * kparser.h - kParser global Linux header file
+ *
+ * Authors:     Tom Herbert <tom@sipanda.io>
+ *              Pratyush Kumar Khan <pratyush@sipanda.io>
+ */
+
+#ifndef _LINUX_KPARSER_H
+#define _LINUX_KPARSER_H
+
+#include <linux/string.h>
+#include <linux/types.h>
+
+/* *********************** NETLINK_GENERIC *********************** */
+#define KPARSER_GENL_NAME		"kParser"
+#define KPARSER_GENL_VERSION		0x1
+
+/* *********************** NETLINK CLI *********************** */
+#define KPARSER_ERR_STR_MAX_LEN		256
+/* *********************** Namespaces/objects *********************** */
+enum kparser_global_namespace_ids {
+	KPARSER_NS_INVALID,
+	KPARSER_NS_CONDEXPRS,
+	KPARSER_NS_CONDEXPRS_TABLE,
+	KPARSER_NS_CONDEXPRS_TABLES,
+	KPARSER_NS_COUNTER,
+	KPARSER_NS_COUNTER_TABLE,
+	KPARSER_NS_METADATA,
+	KPARSER_NS_METALIST,
+	KPARSER_NS_NODE_PARSE,
+	KPARSER_NS_PROTO_TABLE,
+	KPARSER_NS_TLV_NODE_PARSE,
+	KPARSER_NS_TLV_PROTO_TABLE,
+	KPARSER_NS_FLAG_FIELD,
+	KPARSER_NS_FLAG_FIELD_TABLE,
+	KPARSER_NS_FLAG_FIELD_NODE_PARSE,
+	KPARSER_NS_FLAG_FIELD_PROTO_TABLE,
+	KPARSER_NS_PARSER,
+	KPARSER_NS_OP_PARSER_LOCK_UNLOCK,
+	KPARSER_NS_MAX
+};
+
+#define KPARSER_ATTR_RSP(id)		KPARSER_ATTR_RSP_##id
+
+#define KPARSER_DEFINE_ATTR_IDS(id)			\
+	KPARSER_ATTR_CREATE_##id,	/* NLA_BINARY */\
+	KPARSER_ATTR_UPDATE_##id,	/* NLA_BINARY */\
+	KPARSER_ATTR_READ_##id,		/* NLA_BINARY */\
+	KPARSER_ATTR_DELETE_##id,	/* NLA_BINARY */\
+	KPARSER_ATTR_RSP(id)
+
+enum {
+	KPARSER_ATTR_UNSPEC,	/* Add more entries after this */
+	KPARSER_DEFINE_ATTR_IDS(KPARSER_NS_CONDEXPRS),
+	KPARSER_DEFINE_ATTR_IDS(KPARSER_NS_CONDEXPRS_TABLE),
+	KPARSER_DEFINE_ATTR_IDS(KPARSER_NS_CONDEXPRS_TABLES),
+	KPARSER_DEFINE_ATTR_IDS(KPARSER_NS_COUNTER),
+	KPARSER_DEFINE_ATTR_IDS(KPARSER_NS_COUNTER_TABLE),
+	KPARSER_DEFINE_ATTR_IDS(KPARSER_NS_METADATA),
+	KPARSER_DEFINE_ATTR_IDS(KPARSER_NS_METALIST),
+	KPARSER_DEFINE_ATTR_IDS(KPARSER_NS_NODE_PARSE),
+	KPARSER_DEFINE_ATTR_IDS(KPARSER_NS_PROTO_TABLE),
+	KPARSER_DEFINE_ATTR_IDS(KPARSER_NS_TLV_NODE_PARSE),
+	KPARSER_DEFINE_ATTR_IDS(KPARSER_NS_TLV_PROTO_TABLE),
+	KPARSER_DEFINE_ATTR_IDS(KPARSER_NS_FLAG_FIELD),
+	KPARSER_DEFINE_ATTR_IDS(KPARSER_NS_FLAG_FIELD_TABLE),
+	KPARSER_DEFINE_ATTR_IDS(KPARSER_NS_FLAG_FIELD_NODE_PARSE),
+	KPARSER_DEFINE_ATTR_IDS(KPARSER_NS_FLAG_FIELD_PROTO_TABLE),
+	KPARSER_DEFINE_ATTR_IDS(KPARSER_NS_PARSER),
+	KPARSER_DEFINE_ATTR_IDS(KPARSER_NS_OP_PARSER_LOCK_UNLOCK),
+	KPARSER_ATTR_MAX	/* Add more entries before this */
+};
+
+enum {
+	KPARSER_CMD_UNSPEC,
+	KPARSER_CMD_CONFIGURE,
+	KPARSER_CMD_MAX
+};
+
+/* *********************** kparser hash key (hkey) *********************** */
+#define KPARSER_INVALID_ID		0xffff
+
+#define KPARSER_USER_ID_MIN		0
+#define KPARSER_USER_ID_MAX		0x8000
+#define KPARSER_KMOD_ID_MIN		0x8001
+#define KPARSER_KMOD_ID_MAX		0xfffe
+
+#define KPARSER_MAX_NAME		128
+#define KPARSER_MAX_DIGIT_STR_LEN	16
+#define KPARSER_DEF_NAME_PREFIX		"kparser_default_name"
+#define KPARSER_USER_ID_MIN		0
+#define KPARSER_USER_ID_MAX		0x8000
+#define KPARSER_KMOD_ID_MIN		0x8001
+#define KPARSER_KMOD_ID_MAX		0xfffe
+
+struct kparser_hkey {
+	__u16 id;
+	char name[KPARSER_MAX_NAME];
+};
+
+/* *********************** conditional expressions *********************** */
+enum kparser_condexpr_types {
+	KPARSER_CONDEXPR_TYPE_OR,
+	KPARSER_CONDEXPR_TYPE_AND,
+};
+
+enum kparser_expr_types {
+	KPARSER_CONDEXPR_TYPE_EQUAL,
+	KPARSER_CONDEXPR_TYPE_NOTEQUAL,
+	KPARSER_CONDEXPR_TYPE_LT,
+	KPARSER_CONDEXPR_TYPE_LTE,
+	KPARSER_CONDEXPR_TYPE_GT,
+	KPARSER_CONDEXPR_TYPE_GTE,
+};
+
+/* One boolean condition expressions */
+struct kparser_condexpr_expr {
+	enum kparser_expr_types type;
+	__u16 src_off;
+	__u8 length;
+	__u32 mask;
+	__u32 value;
+};
+
+struct kparser_conf_condexpr {
+	struct kparser_hkey key;
+	struct kparser_condexpr_expr config;
+};
+
+struct kparser_conf_condexpr_table {
+	struct kparser_hkey key;
+	int idx;
+	int default_fail;
+	enum kparser_condexpr_types type;
+	struct kparser_hkey condexpr_expr_key;
+};
+
+struct kparser_conf_condexpr_tables {
+	struct kparser_hkey key;
+	int idx;
+	struct kparser_hkey condexpr_expr_table_key;
+};
+
+/* *********************** counter *********************** */
+#define KPARSER_CNTR_NUM_CNTRS		7
+
+struct kparser_cntr_conf {
+	bool valid_entry;
+	__u8 index;
+	__u32 max_value;
+	__u32 array_limit;
+	size_t el_size;
+	bool reset_on_encap;
+	bool overwrite_last;
+	bool error_on_exceeded;
+};
+
+struct kparser_conf_cntr {
+	struct kparser_hkey key;
+	struct kparser_cntr_conf conf;
+};
+
+/* *********************** metadata *********************** */
+enum kparser_metadata_type {
+	KPARSER_METADATA_INVALID,
+	KPARSER_METADATA_HDRDATA,
+	KPARSER_METADATA_HDRDATA_NIBBS_EXTRACT,
+	KPARSER_METADATA_HDRLEN,
+	KPARSER_METADATA_CONSTANT_BYTE,
+	KPARSER_METADATA_CONSTANT_HALFWORD,
+	KPARSER_METADATA_OFFSET,
+	KPARSER_METADATA_BIT_OFFSET,
+	KPARSER_METADATA_NUMENCAPS,
+	KPARSER_METADATA_NUMNODES,
+	KPARSER_METADATA_TIMESTAMP,
+	KPARSER_METADATA_RETURN_CODE,
+	KPARSER_METADATA_COUNTER,
+	KPARSER_METADATA_NOOP,
+	KPARSER_METADATA_MAX
+};
+
+enum kparser_metadata_counter_op_type {
+	KPARSER_METADATA_COUNTEROP_NOOP,
+	KPARSER_METADATA_COUNTEROP_INCR,
+	KPARSER_METADATA_COUNTEROP_RST
+};
+
+#define KPARSER_METADATA_OFFSET_MIN		0
+#define KPARSER_METADATA_OFFSET_MAX		0xffffff
+#define KPARSER_METADATA_OFFSET_INVALID		0xffffffff
+
+/* TODO: align and pack all struct members
+ */
+struct kparser_conf_metadata {
+	struct kparser_hkey key;
+	enum kparser_metadata_type type;
+	enum kparser_metadata_counter_op_type cntr_op; // 3 bit
+	bool frame;
+	bool e_bit;
+	__u8 cntr; // 3 bit
+	__u8 cntr_data; // 3 bit
+	__u8 constant_value;
+	size_t soff;
+	size_t doff;
+	size_t len;
+	size_t add_off;
+	struct kparser_hkey counterkey;
+};
+
+/* *********************** metadata list/table *********************** */
+struct kparser_conf_metadata_table {
+	struct kparser_hkey key;
+	size_t metadata_keys_count;
+	struct kparser_hkey metadata_keys[0];
+};
+
+/* *********************** parse nodes *********************** */
+/* kParser protocol node types
+ */
+enum kparser_node_type {
+	/* Plain node, no super structure */
+	KPARSER_NODE_TYPE_PLAIN,
+	/* TLVs node with super structure for TLVs */
+	KPARSER_NODE_TYPE_TLVS,
+	/* Flag-fields with super structure for flag-fields */
+	KPARSER_NODE_TYPE_FLAG_FIELDS,
+	/* It represents the limit value */
+	KPARSER_NODE_TYPE_MAX,
+};
+
+/* Types for parameterized functions */
+struct kparser_parameterized_len {
+	__u16 src_off;
+	__u8 size;
+	bool endian;
+	__u32 mask;
+	__u8 right_shift;
+	__u8 multiplier;
+	__u8 add_value;
+};
+
+struct kparser_parameterized_next_proto {
+	__u16 src_off;
+	__u16 mask;
+	__u8 size;
+	__u8 right_shift;
+};
+
+struct kparser_conf_parse_ops {
+	bool len_parameterized;
+	struct kparser_parameterized_len pflen;
+	struct kparser_parameterized_next_proto pfnext_proto;
+	bool cond_exprs_parameterized;
+	struct kparser_hkey cond_exprs_table;
+};
+
+/* base nodes */
+struct kparser_conf_node_proto {
+	bool encap;
+	bool overlay;
+	size_t min_len;
+	struct kparser_conf_parse_ops ops;
+};
+
+struct kparser_conf_node_parse {
+	int unknown_ret;
+	struct kparser_hkey proto_table_key;
+	struct kparser_hkey wildcard_parse_node_key;
+	struct kparser_hkey metadata_table_key;
+	struct kparser_conf_node_proto proto_node;
+};
+
+/* TLVS */
+struct kparser_proto_tlvs_opts {
+	struct kparser_parameterized_len pfstart_offset;
+	bool len_parameterized;
+	struct kparser_parameterized_len pflen;
+	struct kparser_parameterized_next_proto pftype;
+};
+
+struct kparser_conf_proto_tlvs_node {
+	struct kparser_proto_tlvs_opts ops;
+	bool tlvsstdfmt;
+	bool fixed_start_offset;
+	size_t start_offset;
+	__u8 pad1_val;
+	__u8 padn_val;
+	__u8 eol_val;
+	bool pad1_enable;
+	bool padn_enable;
+	bool eol_enable;
+	size_t min_len;
+};
+
+#define KPARSER_DEFAULT_TLV_MAX_LOOP			255
+#define KPARSER_DEFAULT_TLV_MAX_NON_PADDING		255
+#define KPARSER_DEFAULT_TLV_MAX_CONSEC_PAD_BYTES	255
+#define KPARSER_DEFAULT_TLV_MAX_CONSEC_PAD_OPTS		255
+#define KPARSER_DEFAULT_TLV_DISP_LIMIT_EXCEED		0
+#define KPARSER_DEFAULT_TLV_EXCEED_LOOP_CNT_ERR		false
+
+/* Two bit code that describes the action to take when a loop node
+ * exceeds a limit
+ */
+enum {
+	KPARSER_LOOP_DISP_STOP_OKAY = 0,
+	KPARSER_LOOP_DISP_STOP_NODE_OKAY = 1,
+	KPARSER_LOOP_DISP_STOP_SUB_NODE_OKAY = 2,
+	KPARSER_LOOP_DISP_STOP_FAIL = 3,
+};
+
+/* Configuration for a TLV node (generally loop nodes)
+ *
+ * max_loop: Maximum number of TLVs to process
+ * max_non: Maximum number of non-padding TLVs to process
+ * max_plen: Maximum consecutive padding bytes
+ * max_c_pad: Maximum number of consecutive padding options
+ * disp_limit_exceed: Disposition when a TLV parsing limit is exceeded. See
+ * KPARSER_LOOP_DISP_STOP_* in parser.h
+ * exceed_loop_cnt_is_err: True is exceeding maximum number of TLVS is an error
+ */
+struct kparser_loop_node_config {
+	__u16 max_loop;
+	__u16 max_non;
+	__u8 max_plen;
+	__u8 max_c_pad;
+	__u8 disp_limit_exceed;
+	bool exceed_loop_cnt_is_err;
+};
+
+/* TODO:
+ * disp_limit_exceed: 2;
+ * exceed_loop_cnt_is_err: 1;
+ */
+struct kparser_conf_parse_tlvs {
+	struct kparser_conf_proto_tlvs_node proto_node;
+	struct kparser_hkey tlv_proto_table_key;
+	int unknown_tlv_type_ret;
+	struct kparser_hkey tlv_wildcard_node_key;
+	struct kparser_loop_node_config config;
+};
+
+/* flag fields */
+struct kparser_parameterized_get_value {
+	__u16 src_off;
+	__u32 mask;
+	__u8 size;
+};
+
+struct kparser_proto_flag_fields_ops {
+	bool get_flags_parameterized;
+	struct kparser_parameterized_get_value pfget_flags;
+	bool start_fields_offset_parameterized;
+	struct kparser_parameterized_len pfstart_fields_offset;
+	bool flag_fields_len;
+	__u16 hdr_length;
+};
+
+struct kparser_conf_node_proto_flag_fields {
+	struct kparser_proto_flag_fields_ops ops;
+	struct kparser_hkey flag_fields_table_hkey;
+};
+
+struct kparser_conf_parse_flag_fields {
+	struct kparser_conf_node_proto_flag_fields proto_node;
+	struct kparser_hkey flag_fields_proto_table_key;
+};
+
+struct kparser_conf_node {
+	struct kparser_hkey key;
+	enum kparser_node_type type;
+	struct kparser_conf_node_parse plain_parse_node;
+	struct kparser_conf_parse_tlvs tlvs_parse_node;
+	struct kparser_conf_parse_flag_fields flag_fields_parse_node;
+};
+
+/* *********************** tlv parse node *********************** */
+struct kparser_conf_proto_tlv_node_ops {
+	bool overlay_type_parameterized;
+	struct kparser_parameterized_next_proto pfoverlay_type;
+	bool cond_exprs_parameterized;
+	struct kparser_hkey cond_exprs_table;
+};
+
+struct kparser_conf_node_proto_tlv {
+	size_t min_len;
+	size_t max_len;
+	bool is_padding;
+	struct kparser_conf_proto_tlv_node_ops ops;
+};
+
+struct kparser_conf_node_parse_tlv {
+	struct kparser_hkey key;
+	struct kparser_conf_node_proto_tlv node_proto;
+	struct kparser_hkey overlay_proto_tlvs_table_key;
+	struct kparser_hkey overlay_wildcard_parse_node_key;
+	int unknown_ret;
+	struct kparser_hkey metadata_table_key;
+};
+
+/* *********************** flag field *********************** */
+/* One descriptor for a flag
+ *
+ * flag: protocol value
+ * mask: mask to apply to field
+ * size: size for associated field data
+ */
+struct kparser_flag_field {
+	__u32 flag;
+	__u32 networkflag;
+	__u32 mask;
+	size_t size;
+	bool endian;
+};
+
+struct kparser_conf_flag_field {
+	struct kparser_hkey key;
+	struct kparser_flag_field conf;
+};
+
+/* *********************** flag field parse node *********************** */
+struct kparser_parse_flag_field_node_ops_conf {
+	struct kparser_hkey cond_exprs_table_key;
+};
+
+struct kparser_conf_node_parse_flag_field {
+	struct kparser_hkey key;
+	struct kparser_hkey metadata_table_key;
+	struct kparser_parse_flag_field_node_ops_conf ops;
+};
+
+/* *********************** generic tables *********************** */
+struct kparser_conf_table {
+	struct kparser_hkey key;
+	bool add_entry;
+	__u16 elems_cnt;
+	int optional_value1;
+	int optional_value2;
+	struct kparser_hkey elem_key;
+};
+
+/* *********************** parser *********************** */
+/* Flags for parser configuration */
+#define KPARSER_F_DEBUG		(1 << 0)
+
+#define KPARSER_MAX_NODES	10
+#define KPARSER_MAX_ENCAPS	1
+#define KPARSER_MAX_FRAMES	255
+
+/* Configuration for a KPARSER parser
+ *
+ * flags: Flags KPARSER_F_* in parser.h
+ * max_nodes: Maximum number of nodes to parse
+ * max_encaps: Maximum number of encapsulations to parse
+ * max_frames: Maximum number of metadata frames
+ * metameta_size: Size of metameta data. The metameta data is at the head
+ * of the user defined metadata structure. This also serves as the
+ * offset of the first metadata frame
+ * frame_size: Size of one metadata frame
+ */
+struct kparser_config {
+	__u16 flags;
+	__u16 max_nodes;
+	__u16 max_encaps;
+	__u16 max_frames;
+	size_t metameta_size;
+	size_t frame_size;
+};
+
+struct kparser_conf_parser {
+	struct kparser_hkey key;
+	struct kparser_config config;
+	struct kparser_hkey root_node_key;
+	struct kparser_hkey ok_node_key;
+	struct kparser_hkey fail_node_key;
+	struct kparser_hkey atencap_node_key;
+};
+
+/* *********************** CLI config interface *********************** */
+
+/* NOTE: we can't use BITS_PER_TYPE from kernel header here and had to redefine BITS_IN_U32
+ * since this is shared with user space code.
+ */
+#define BITS_IN_BYTE	8
+#define BITS_IN_U32	(sizeof(__u32) * BITS_IN_BYTE)
+
+#define KPARSER_CONFIG_MAX_KEYS			128
+#define KPARSER_CONFIG_MAX_KEYS_BV_LEN ((KPARSER_CONFIG_MAX_KEYS / BITS_IN_U32) + 1)
+struct kparser_config_set_keys_bv {
+	__u32 ns_keys_bvs[KPARSER_CONFIG_MAX_KEYS_BV_LEN];
+};
+
+struct kparser_conf_cmd {
+	enum kparser_global_namespace_ids namespace_id;
+	struct kparser_config_set_keys_bv conf_keys_bv;
+	__u8 recursive_read_delete;
+	union {
+		/* for read/delete commands */
+		/* KPARSER_NS_OP_PARSER_LOCK_UNLOCK */
+		struct kparser_hkey obj_key;
+
+		/* KPARSER_NS_CONDEXPRS */
+		struct kparser_conf_condexpr cond_conf;
+
+		/* KPARSER_NS_COUNTER */
+		struct kparser_conf_cntr cntr_conf;
+
+		/* KPARSER_NS_METADATA */
+		struct kparser_conf_metadata md_conf;
+
+		/* KPARSER_NS_METALIST */
+		struct kparser_conf_metadata_table mdl_conf;
+
+		/* KPARSER_NS_NODE_PARSE */
+		struct kparser_conf_node node_conf;
+
+		/* KPARSER_NS_TLV_NODE_PARSE */
+		struct kparser_conf_node_parse_tlv tlv_node_conf;
+
+		/* KPARSER_NS_FLAG_FIELD */
+		struct kparser_conf_flag_field flag_field_conf;
+
+		/* KPARSER_NS_FLAG_FIELD_NODE_PARSE */
+		struct kparser_conf_node_parse_flag_field flag_field_node_conf;
+
+		/* KPARSER_NS_PROTO_TABLE */
+		/* KPARSER_NS_TLV_PROTO_TABLE */
+		/* KPARSER_NS_FLAG_FIELD_TABLE */
+		/* KPARSER_NS_FLAG_FIELD_PROTO_TABLE */
+		/* KPARSER_NS_CONDEXPRS_TABLE */
+		/* KPARSER_NS_CONDEXPRS_TABLES */
+		/* KPARSER_NS_COUNTER_TABLE */
+		struct kparser_conf_table table_conf;
+
+		/* KPARSER_NS_PARSER */
+		struct kparser_conf_parser parser_conf;
+	};
+};
+
+struct kparser_cmd_rsp_hdr {
+	int op_ret_code;
+	__u8 err_str_buf[KPARSER_ERR_STR_MAX_LEN];
+	struct kparser_hkey key;
+	struct kparser_conf_cmd object;
+	size_t objects_len;
+	/* array of fixed size kparser_conf_cmd objects */
+	struct kparser_conf_cmd objects[0];
+};
+
+/* ***********************  kParser error code *********************** */
+/*
+ * There are two variants of the KPARSER return codes. The normal variant is
+ * a number between -15 and 0 inclusive where the name for the code is
+ * prefixed by KPARSER_. There is also a special 16-bit encoding which is
+ * 0xfff0 + -val where val is the negative number for the code so that
+ * corresponds to values 0xfff0 to 0xffff. Names for the 16-bit encoding
+ * are prefixed by KPARSER_16BIT_
+ */
+enum {
+	KPARSER_OKAY = 0,		/* Okay and continue */
+	KPARSER_RET_OKAY = -1,		/* Encoding of OKAY in ret code */
+
+	KPARSER_OKAY_USE_WILD = -2,	/* cam instruction */
+	KPARSER_OKAY_USE_ALT_WILD = -3,	/* cam instruction */
+
+	KPARSER_STOP_OKAY = -4,		/* Okay and stop parsing */
+	KPARSER_STOP_NODE_OKAY = -5,	/* Stop parsing current node */
+	KPARSER_STOP_SUB_NODE_OKAY = -6,/* Stop parsing currnet sub-node */
+
+	/* Parser failure */
+	KPARSER_STOP_FAIL = -12,
+	KPARSER_STOP_LENGTH = -13,
+	KPARSER_STOP_UNKNOWN_PROTO = -14,
+	KPARSER_STOP_ENCAP_DEPTH = -15,
+	KPARSER_STOP_UNKNOWN_TLV = -16,
+	KPARSER_STOP_TLV_LENGTH = -17,
+	KPARSER_STOP_BAD_FLAG = -18,
+	KPARSER_STOP_FAIL_CMP = -19,
+	KPARSER_STOP_LOOP_CNT = -20,
+	KPARSER_STOP_TLV_PADDING = -21,
+	KPARSER_STOP_OPTION_LIMIT = -22,
+	KPARSER_STOP_MAX_NODES = -23,
+	KPARSER_STOP_COMPARE = -24,
+	KPARSER_STOP_BAD_EXTRACT = -25,
+	KPARSER_STOP_BAD_CNTR = -26,
+	KPARSER_STOP_CNTR1 = -27,
+	KPARSER_STOP_CNTR2 = -28,
+	KPARSER_STOP_CNTR3 = -29,
+	KPARSER_STOP_CNTR4 = -30,
+	KPARSER_STOP_CNTR5 = -31,
+	KPARSER_STOP_CNTR6 = -32,
+	KPARSER_STOP_CNTR7 = -33,
+};
+
+static inline const char *kparser_code_to_text(int code)
+{
+	switch (code) {
+	case KPARSER_OKAY:
+		return "okay";
+	case KPARSER_RET_OKAY:
+		return "okay-ret";
+	case KPARSER_OKAY_USE_WILD:
+		return "okay-use-wild";
+	case KPARSER_OKAY_USE_ALT_WILD:
+		return "okay-use-alt-wild";
+	case KPARSER_STOP_OKAY:
+		return "stop-okay";
+	case KPARSER_STOP_NODE_OKAY:
+		return "stop-node-okay";
+	case KPARSER_STOP_SUB_NODE_OKAY:
+		return "stop-sub-node-okay";
+	case KPARSER_STOP_FAIL:
+		return "stop-fail";
+	case KPARSER_STOP_LENGTH:
+		return "stop-length";
+	case KPARSER_STOP_UNKNOWN_PROTO:
+		return "stop-unknown-proto";
+	case KPARSER_STOP_ENCAP_DEPTH:
+		return "stop-encap-depth";
+	case KPARSER_STOP_UNKNOWN_TLV:
+		return "stop-unknown-tlv";
+	case KPARSER_STOP_TLV_LENGTH:
+		return "stop-tlv-length";
+	case KPARSER_STOP_BAD_FLAG:
+		return "stop-bad-flag";
+	case KPARSER_STOP_FAIL_CMP:
+		return "stop-fail-cmp";
+	case KPARSER_STOP_LOOP_CNT:
+		return "stop-loop-cnt";
+	case KPARSER_STOP_TLV_PADDING:
+		return "stop-tlv-padding";
+	case KPARSER_STOP_OPTION_LIMIT:
+		return "stop-option-limit";
+	case KPARSER_STOP_MAX_NODES:
+		return "stop-max-nodes";
+	case KPARSER_STOP_COMPARE:
+		return "stop-compare";
+	case KPARSER_STOP_BAD_EXTRACT:
+		return "stop-bad-extract";
+	case KPARSER_STOP_BAD_CNTR:
+		return "stop-bad-counter";
+	default:
+		return "unknown-code";
+	}
+}
+
+/* *********************** HKey utility APIs *********************** */
+static inline bool kparser_hkey_id_empty(const struct kparser_hkey *key)
+{
+	if (!key)
+		return true;
+	return (key->id == KPARSER_INVALID_ID);
+}
+
+static inline bool kparser_hkey_name_empty(const struct kparser_hkey *key)
+{
+	if (!key)
+		return true;
+	return ((key->name[0] == '\0') ||
+			!strcmp(key->name, KPARSER_DEF_NAME_PREFIX));
+}
+
+static inline bool kparser_hkey_empty(const struct kparser_hkey *key)
+{
+	return (kparser_hkey_id_empty(key) && kparser_hkey_name_empty(key));
+}
+
+static inline bool kparser_hkey_user_id_invalid(const struct kparser_hkey *key)
+{
+	if (!key)
+		return true;
+	return ((key->id == KPARSER_INVALID_ID) ||
+			(key->id > KPARSER_USER_ID_MAX));
+}
+
+#endif /* _LINUX_KPARSER_H */
diff --git a/net/Kconfig b/net/Kconfig
index 48c33c222199..39b70349dbcc 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -471,4 +471,13 @@ config NETDEV_ADDR_LIST_TEST
 	default KUNIT_ALL_TESTS
 	depends on KUNIT
 
+config KPARSER
+	tristate "kParser in Kernel"
+	help
+	  kParser stands for "The Kernel Parser". This is a programmable
+	  network packet parser which is a ported version of the PANDA
+	  parser. This module exposes kParser APIs in Kernel.
+
+	  If unsure, say N.
+
 endif   # if NET
diff --git a/net/Makefile b/net/Makefile
index 6a62e5b27378..db73fd395fa0 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -78,3 +78,4 @@ obj-$(CONFIG_NET_NCSI)		+= ncsi/
 obj-$(CONFIG_XDP_SOCKETS)	+= xdp/
 obj-$(CONFIG_MPTCP)		+= mptcp/
 obj-$(CONFIG_MCTP)		+= mctp/
+obj-$(CONFIG_KPARSER)		+= kparser/
diff --git a/net/kparser/Makefile b/net/kparser/Makefile
new file mode 100644
index 000000000000..5a40d5cb340d
--- /dev/null
+++ b/net/kparser/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for KPARSER module
+#
+
+ccflags-y := -DDEBUG -DKERNEL_MOD
+
+obj-$(CONFIG_KPARSER) += kparser.o
+
+kparser-objs := kparser_main.o kparser_cmds.o kparser_cmds_ops.o kparser_cmds_dump_ops.o kparser_datapath.o
diff --git a/net/kparser/kparser.h b/net/kparser/kparser.h
new file mode 100644
index 000000000000..b98e057660c6
--- /dev/null
+++ b/net/kparser/kparser.h
@@ -0,0 +1,391 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2022, SiPanda Inc.
+ *
+ * kparser.h - kParser local header file
+ *
+ * Author:      Pratyush Kumar Khan <pratyush@sipanda.io>
+ */
+
+#ifndef __KPARSER_H
+#define __KPARSER_H
+
+#include <linux/hash.h>
+#include <linux/kparser.h>
+#include <linux/kref.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/rhashtable-types.h>
+#include <linux/skbuff.h>
+#include <linux/xxhash.h>
+
+#include "kparser_types.h"
+#include "kparser_condexpr.h"
+#include "kparser_metaextract.h"
+#include "kparser_types.h"
+
+/* These are used to track owner/owned relationship between different objects
+ */
+struct kparser_ref_ctx {
+	int nsid;
+	const void *obj;
+	const void __rcu **link_ptr;
+	struct kref *refcount;
+	struct list_head *list;
+	struct list_head list_node;
+};
+
+#define KPARSER_LINK_OBJ_SIGNATURE		0xffaabbff
+
+/* bookkeeping structure to manage the above struct kparser_ref_ctx and map an owner with owned both
+ * ways
+ */
+struct kparser_obj_link_ctx {
+	int sig;
+	struct kparser_ref_ctx owner_obj;
+	struct kparser_ref_ctx owned_obj;
+};
+
+/* global hash table structures */
+struct kparser_htbl {
+	struct rhashtable tbl;
+	struct rhashtable_params tbl_params;
+};
+
+/* it binds a netlink cli structure to an internal namespace object structure
+ *
+ * key: hash key, must be always the very first entry for hash functions to work correctly.
+ * ht_node_id: ID based hash table's linking object.
+ * ht_node_name: name based hash table's linking object.
+ * refcount: tracks how many other objects are linked using refcount.
+ * config: netlink msg's config structure cached, it is replayed back during read operations.
+ * owner_list: list pointer for kparser_obj_link_ctx.owner_obj.list
+ * owned_list: list pointer for kparser_obj_link_ctx.owned_obj.list
+ */
+struct kparser_glue {
+	struct kparser_hkey key;
+	struct rhash_head ht_node_id;
+	struct rhash_head ht_node_name;
+	struct kref refcount;
+	struct kparser_conf_cmd config;
+	struct list_head owner_list;
+	struct list_head owned_list;
+};
+
+/* internal namespace structures for conditional expressions
+ * it binds a netlink cli structure to an internal namespace object structure
+ */
+struct kparser_glue_condexpr_expr {
+	struct kparser_glue glue;
+	struct kparser_condexpr_expr expr;
+};
+
+/* internal namespace structures for conditional expressions table
+ * it binds a netlink cli structure to an internal namespace object structure
+ */
+struct kparser_glue_condexpr_table {
+	struct kparser_glue glue;
+	struct kparser_condexpr_table table;
+};
+
+/* internal namespace structures for table of conditional expressions table
+ * it binds a netlink cli structure to an internal namespace object structure
+ */
+struct kparser_glue_condexpr_tables {
+	struct kparser_glue glue;
+	struct kparser_condexpr_tables table;
+};
+
+/* internal namespace structures for counters
+ * it binds a netlink cli structure to an internal namespace object structure
+ */
+struct kparser_glue_counter {
+	struct kparser_glue glue;
+	struct kparser_cntr_conf counter_cnf;
+};
+
+/* internal namespace structures for counter table
+ * it binds a netlink cli structure to an internal namespace object structure
+ */
+struct kparser_glue_counter_table {
+	struct kparser_glue glue;
+	__u8 elems_cnt;
+	struct kparser_glue_counter k_cntrs[KPARSER_CNTR_NUM_CNTRS];
+};
+
+/* internal namespace structures for metadata
+ * it binds a netlink cli structure to an internal namespace object structure
+ */
+struct kparser_glue_metadata_extract {
+	struct kparser_glue glue;
+	struct kparser_metadata_extract mde;
+};
+
+/* internal namespace structures for metadata list
+ * it binds a netlink cli structure to an internal namespace object structure
+ */
+struct kparser_glue_metadata_table {
+	struct kparser_glue glue;
+	size_t md_configs_len;
+	struct kparser_conf_cmd *md_configs;
+	struct kparser_metadata_table metadata_table;
+};
+
+/* internal namespace structures for node
+ * it binds a netlink cli structure to an internal namespace object structure
+ */
+struct kparser_glue_node {
+	struct kparser_glue glue;
+};
+
+struct kparser_glue_glue_parse_node {
+	struct kparser_glue_node glue;
+	union {
+		struct kparser_parse_node node;
+		struct kparser_parse_flag_fields_node flags_parse_node;
+		struct kparser_parse_tlvs_node tlvs_parse_node;
+	} parse_node;
+};
+
+/* internal namespace structures for table
+ * it binds a netlink cli structure to an internal namespace object structure
+ */
+struct kparser_glue_protocol_table {
+	struct kparser_glue glue;
+	struct kparser_proto_table proto_table;
+};
+
+/* internal namespace structures for tlv nodes and tables
+ * it binds a netlink cli structure to an internal namespace object structure
+ */
+struct kparser_glue_parse_tlv_node {
+	struct kparser_glue_node glue;
+	struct kparser_parse_tlv_node tlv_parse_node;
+};
+
+/* internal namespace structures for tlvs proto table
+ * it binds a netlink cli structure to an internal namespace object structure
+ */
+struct kparser_glue_proto_tlvs_table {
+	struct kparser_glue glue;
+	struct kparser_proto_tlvs_table tlvs_proto_table;
+};
+
+/* internal namespace structures for flagfields and tables
+ * it binds a netlink cli structure to an internal namespace object structure
+ */
+struct kparser_glue_flag_field {
+	struct kparser_glue glue;
+	struct kparser_flag_field flag_field;
+};
+
+/* internal namespace structures for flag field node
+ * it binds a netlink cli structure to an internal namespace object structure
+ */
+struct kparser_glue_flag_fields {
+	struct kparser_glue glue;
+	struct kparser_flag_fields flag_fields;
+};
+
+struct kparser_glue_flag_field_node {
+	struct kparser_glue_node glue;
+	struct kparser_parse_flag_field_node node_flag_field;
+};
+
+/* internal namespace structures for flag field table
+ * it binds a netlink cli structure to an internal namespace object structure
+ */
+struct kparser_glue_proto_flag_fields_table {
+	struct kparser_glue glue;
+	struct kparser_proto_flag_fields_table flags_proto_table;
+};
+
+/* internal namespace structures for parser
+ * it binds a netlink cli structure to an internal namespace object structure
+ */
+struct kparser_glue_parser {
+	struct kparser_glue glue;
+	struct list_head list_node;
+	struct kparser_parser parser;
+};
+
+/* name hash table's hash object comparison function callback */
+static inline int kparser_cmp_fn_name(struct rhashtable_compare_arg *arg,
+				      const void *ptr)
+{
+	const char *key2 = arg->key;
+	const struct kparser_hkey *key1 = ptr;
+
+	return strcmp(key1->name, key2);
+}
+
+/* ID hash table's hash object comparison function callback */
+static inline int kparser_cmp_fn_id(struct rhashtable_compare_arg *arg,
+				    const void *ptr)
+{
+	const __u16 *key2 = arg->key;
+	const __u16 *key1 = ptr;
+
+	return (*key1 != *key2);
+}
+
+/* name hash table's hash calculation function callback from hash key */
+static inline __u32 kparser_generic_hash_fn_name(const void *hkey, __u32 key_len, __u32 seed)
+{
+	const char *key = hkey;
+
+	/* TODO: check if seed needs to be used here
+	 * TODO: replace xxh32() with siphash
+	 */
+	return xxh32(hkey, strlen(key), 0);
+}
+
+/* ID hash table's hash calculation function callback from hash key */
+static inline __u32 kparser_generic_hash_fn_id(const void *hkey, __u32 key_len, __u32 seed)
+{
+	const __u16 *key = hkey;
+	/* TODO: check if seed needs to be used here
+	 */
+	return *key;
+}
+
+/* name hash table's hash calculation function callback from object */
+static inline __u32 kparser_generic_obj_hashfn_name(const void *obj, __u32 key_len, __u32 seed)
+{
+	const struct kparser_hkey *key;
+
+	key = obj;
+	/* TODO: check if seed needs to be used here
+	 * TODO: replace xxh32() with siphash
+	 * Note: this only works because key always in the start place
+	 * of all the differnt kparser objects
+	 */
+	return xxh32(key->name, strlen(key->name), 0);
+}
+
+/* ID hash table's hash calculation function callback from object */
+static inline __u32 kparser_generic_obj_hashfn_id(const void *obj, __u32 key_len, __u32 seed)
+{
+	/* TODO: check if seed needs to be used here
+	 * TODO: replace xxh32() with siphash
+	 * Note: this only works because key always is the very first object in all the differnt
+	 * kparser objects
+	 */
+	return ((const struct kparser_hkey *)obj)->id;
+}
+
+/* internal shared functions */
+int kparser_init(void);
+int kparser_deinit(void);
+int kparser_config_handler_add(const void *cmdarg, size_t cmdarglen,
+			       struct kparser_cmd_rsp_hdr **rsp,
+			       size_t *rsp_len);
+int kparser_config_handler_update(const void *cmdarg, size_t cmdarglen,
+				  struct kparser_cmd_rsp_hdr **rsp,
+				  size_t *rsp_len);
+int kparser_config_handler_read(const void *cmdarg, size_t cmdarglen,
+				struct kparser_cmd_rsp_hdr **rsp,
+				size_t *rsp_len);
+int kparser_config_handler_delete(const void *cmdarg, size_t cmdarglen,
+				  struct kparser_cmd_rsp_hdr **rsp,
+				  size_t *rsp_len);
+void *kparser_namespace_lookup(enum kparser_global_namespace_ids ns_id,
+			       const struct kparser_hkey *key);
+void kparser_ref_get(struct kref *refcount);
+void kparser_ref_put(struct kref *refcount);
+int kparser_conf_key_manager(enum kparser_global_namespace_ids ns_id,
+			     const struct kparser_hkey *key,
+			     struct kparser_hkey *new_key,
+			     struct kparser_cmd_rsp_hdr *rsp,
+			     const char *op);
+void kparser_free(void *ptr);
+int kparser_namespace_remove(enum kparser_global_namespace_ids ns_id,
+			     struct rhash_head *obj_id,
+			     struct rhash_head *obj_name);
+int kparser_namespace_insert(enum kparser_global_namespace_ids ns_id,
+			     struct rhash_head *obj_id,
+			     struct rhash_head *obj_name);
+
+/* Generic kParser KMOD's netlink msg handler's definitions for create */
+typedef int kparser_obj_create_update(const struct kparser_conf_cmd *conf,
+				      size_t conf_len,
+				      struct kparser_cmd_rsp_hdr **rsp,
+				      size_t *rsp_len, const char *op);
+/* Generic kParser KMOD's netlink msg handler's definitions for read and delete */
+typedef int kparser_obj_read_del(const struct kparser_hkey *key,
+		struct kparser_cmd_rsp_hdr **rsp,
+		size_t *rsp_len, __u8 recursive_read,
+		const char *op);
+/* Generic kParser KMOD's netlink msg handler's free callbacks */
+typedef void kparser_free_obj(void *ptr, void *arg);
+int kparser_link_attach(const void *owner_obj,
+			int owner_nsid,
+			const void **owner_obj_link_ptr,
+			struct kref *owner_obj_refcount,
+			struct list_head *owner_list,
+			const void *owned_obj,
+			int owned_nsid,
+			struct kref *owned_obj_refcount,
+			struct list_head *owned_list,
+			struct kparser_cmd_rsp_hdr *rsp,
+			const char *op);
+int kparser_link_detach(const void *obj,
+			struct list_head *owner_list,
+			struct list_head *owned_list,
+			struct kparser_cmd_rsp_hdr *rsp);
+int alloc_first_rsp(struct kparser_cmd_rsp_hdr **rsp, size_t *rsp_len, int nsid);
+void kparser_start_new_tree_traversal(void);
+void kparser_dump_parser_tree(const struct kparser_parser *obj);
+
+/* kParser KMOD's netlink msg/cmd handler's, these are innermost handlers */
+kparser_obj_create_update
+	kparser_create_cond_exprs,
+	kparser_create_cond_table,
+	kparser_create_cond_tables,
+	kparser_create_counter,
+	kparser_create_counter_table,
+	kparser_create_metadata,
+	kparser_create_metalist,
+	kparser_create_parse_node,
+	kparser_create_proto_table,
+	kparser_create_parse_tlv_node,
+	kparser_create_tlv_proto_table,
+	kparser_create_flag_field,
+	kparser_create_flag_field_table,
+	kparser_create_parse_flag_field_node,
+	kparser_create_flag_field_proto_table,
+	kparser_create_parser,
+	kparser_parser_lock;
+
+kparser_obj_read_del
+	kparser_read_cond_exprs,
+	kparser_read_cond_table,
+	kparser_read_cond_tables,
+	kparser_read_counter,
+	kparser_read_counter_table,
+	kparser_read_metadata,
+	kparser_del_metadata,
+	kparser_read_metalist,
+	kparser_del_metalist,
+	kparser_read_parse_node,
+	kparser_del_parse_node,
+	kparser_read_proto_table,
+	kparser_del_proto_table,
+	kparser_read_parse_tlv_node,
+	kparser_read_tlv_proto_table,
+	kparser_read_flag_field,
+	kparser_read_flag_field_table,
+	kparser_read_parse_flag_field_node,
+	kparser_read_flag_field_proto_table,
+	kparser_read_parser,
+	kparser_del_parser,
+	kparser_parser_unlock;
+
+kparser_free_obj
+	kparser_free_metadata,
+	kparser_free_metalist,
+	kparser_free_node,
+	kparser_free_proto_tbl,
+	kparser_free_parser;
+
+#endif /* __KPARSER_H */
diff --git a/net/kparser/kparser_cmds.c b/net/kparser/kparser_cmds.c
new file mode 100644
index 000000000000..c656c3df4a7f
--- /dev/null
+++ b/net/kparser/kparser_cmds.c
@@ -0,0 +1,898 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2022, SiPanda Inc.
+ *
+ * kparser_cmds.c - kParser KMOD-CLI management API layer
+ *
+ * Author:      Pratyush Kumar Khan <pratyush@sipanda.io>
+ */
+
+#include <linux/bitops.h>
+#include <linux/rhashtable.h>
+#include <linux/slab.h>
+#include <linux/sort.h>
+
+#include "kparser.h"
+
+#define KREF_INIT_VALUE		1
+
+/* These are used to track node loops in parse tree traversal operations */
+static __u64 curr_traversal_ts_id_ns;
+
+/* This function marks a start of a new parse tree traversal operation */
+void kparser_start_new_tree_traversal(void)
+{
+	curr_traversal_ts_id_ns = ktime_get_ns();
+}
+
+/* A simple wrapper for kfree for additional future internal debug info, particularly to
+ * track memleaks
+ */
+void kparser_free(void *ptr)
+{
+	if (ptr)
+		kfree(ptr);
+}
+
+/* Kernel API kref_put() must have a non-NULL callback, since we don't need to do anything during
+ * refcount release, kparser_release_ref() is just empty.
+ */
+static void kparser_release_ref(struct kref *kref)
+{
+}
+
+/* Consumer of this is datapath */
+void kparser_ref_get(struct kref *refcount)
+{
+	pr_debug("{%s:%d}:refcnt:%u\n", __func__, __LINE__, kref_read(refcount));
+
+	kref_get(refcount);
+}
+
+/* Consumer of this is datapath */
+void kparser_ref_put(struct kref *refcount)
+{
+	unsigned int refcnt;
+
+	refcnt = kref_read(refcount);
+	pr_debug("{%s:%d}:refcnt:%u\n", __func__, __LINE__, refcnt);
+
+	if (refcnt > KREF_INIT_VALUE)
+		kref_put(refcount, kparser_release_ref);
+	else
+		pr_warn("refcount violation detected, val:%u", refcnt);
+}
+
+/* These are to track/bookkeep owner/owned relationships(both ways) when refcount is involved among
+ * various different types of namespace objects
+ */
+int kparser_link_attach(const void *owner_obj,
+			int owner_nsid,
+			const void **owner_obj_link_ptr,
+			struct kref *owner_obj_refcount,
+			struct list_head *owner_list,
+			const void *owned_obj,
+			int owned_nsid,
+			struct kref *owned_obj_refcount,
+			struct list_head *owned_list,
+			struct kparser_cmd_rsp_hdr *rsp,
+			const char *op)
+{
+	struct kparser_obj_link_ctx *reflist = NULL;
+
+	reflist = kzalloc(sizeof(*reflist), GFP_KERNEL);
+	if (!reflist) {
+		rsp->op_ret_code = ENOMEM;
+		(void)snprintf(rsp->err_str_buf,
+				sizeof(rsp->err_str_buf),
+				"%s: kzalloc failed", op);
+		return -ENOMEM;
+	}
+
+	reflist->sig = KPARSER_LINK_OBJ_SIGNATURE;
+	reflist->owner_obj.nsid = owner_nsid;
+	reflist->owner_obj.obj = owner_obj;
+	reflist->owner_obj.link_ptr = owner_obj_link_ptr;
+	reflist->owner_obj.list = owner_list;
+	reflist->owner_obj.refcount = owner_obj_refcount;
+
+	reflist->owned_obj.nsid = owned_nsid;
+	reflist->owned_obj.obj = owned_obj;
+	reflist->owned_obj.list = owned_list;
+	reflist->owned_obj.refcount = owned_obj_refcount;
+
+	/* reflist is a bookkeeping tracker which maps an owner with owned, both ways.
+	 * hence for both owner and owned map contexts, it is kept in their respective lists.
+	 */
+	list_add_tail(&reflist->owner_obj.list_node, reflist->owner_obj.list);
+	list_add_tail(&reflist->owned_obj.list_node, reflist->owned_obj.list);
+
+	if (reflist->owned_obj.refcount)
+		kref_get(reflist->owned_obj.refcount);
+
+	pr_debug("{%s:%d}:owner:%p owned:%p ref:%p\n",
+		 __func__, __LINE__, owner_obj, owned_obj, reflist);
+
+	synchronize_rcu();
+
+	return 0;
+}
+
+/* It is reverse bookkeeping action of kparser_link_attach(). when an object is detached (be it
+ * owner or owned, the respective map links needs be properly updated to indicate this detachment.
+ * kparser_link_break() is responsible for this removal update.
+ */
+static inline int kparser_link_break(const void *owner, const void *owned,
+				     struct kparser_obj_link_ctx *ref,
+				     struct kparser_cmd_rsp_hdr *rsp)
+{
+	if (!ref) {
+		if (rsp) {
+			rsp->op_ret_code = EFAULT;
+			(void)snprintf(rsp->err_str_buf,
+					sizeof(rsp->err_str_buf),
+					"link is NULL!");
+		}
+		return -EFAULT;
+	}
+
+	if (ref->sig != KPARSER_LINK_OBJ_SIGNATURE) {
+		if (rsp) {
+			rsp->op_ret_code = EFAULT;
+			(void)snprintf(rsp->err_str_buf,
+					sizeof(rsp->err_str_buf),
+					"link is corrupt!");
+		}
+		return -EFAULT;
+	}
+
+	if (owner && ref->owner_obj.obj != owner) {
+		if (rsp) {
+			rsp->op_ret_code = EFAULT;
+			(void)snprintf(rsp->err_str_buf,
+					sizeof(rsp->err_str_buf),
+					"link owner corrupt!");
+		}
+		return -EFAULT;
+	}
+
+	if (owned && ref->owned_obj.obj != owned) {
+		if (rsp) {
+			rsp->op_ret_code = EFAULT;
+			(void)snprintf(rsp->err_str_buf,
+					sizeof(rsp->err_str_buf),
+					"link owned corrupt!");
+		}
+		return -EFAULT;
+	}
+
+	if (ref->owned_obj.refcount)
+		kref_put(ref->owned_obj.refcount, kparser_release_ref);
+
+	if (ref->owner_obj.link_ptr)
+		rcu_assign_pointer(*ref->owner_obj.link_ptr, NULL);
+
+	list_del_init_careful(&ref->owner_obj.list_node);
+	list_del_init_careful(&ref->owned_obj.list_node);
+
+	synchronize_rcu();
+
+	return 0;
+}
+
+/* when a detachment happens, from owner object perspective, it needs to remove the bookkeeping
+ * map contexts with respect to mapped owned objects.
+ */
+static inline int kparser_link_detach_owner(const void *obj,
+					    struct list_head *list,
+					    struct kparser_cmd_rsp_hdr *rsp)
+{
+	struct kparser_obj_link_ctx *tmp_list_ref = NULL, *curr_ref = NULL;
+
+	list_for_each_entry_safe(curr_ref, tmp_list_ref, list, owner_obj.list_node) {
+		if (kparser_link_break(obj, NULL, curr_ref, rsp) != 0)
+			return -EFAULT;
+		kparser_free(curr_ref);
+	}
+
+	return 0;
+}
+
+/* when a detachment happens, from owned object perspective, it needs to remove the bookkeeping
+ * map contexts with respect to mapped owner objects.
+ */
+static inline int kparser_link_detach_owned(const void *obj,
+					    struct list_head *list,
+					    struct kparser_cmd_rsp_hdr *rsp)
+{
+	struct kparser_obj_link_ctx *tmp_list_ref = NULL, *curr_ref = NULL;
+	const struct kparser_glue_glue_parse_node *kparsenode;
+	const struct kparser_glue_protocol_table *proto_table;
+	int i;
+
+	list_for_each_entry_safe(curr_ref, tmp_list_ref, list, owned_obj.list_node) {
+		/* Special case handling:
+		 * if this is parse node and owned by a prototable, make sure
+		 * to remove that table's entry from array separately
+		 */
+		if (curr_ref->owner_obj.nsid == KPARSER_NS_PROTO_TABLE &&
+		    curr_ref->owned_obj.nsid == KPARSER_NS_NODE_PARSE) {
+			proto_table = curr_ref->owner_obj.obj;
+			kparsenode = curr_ref->owned_obj.obj;
+			for (i = 0; i < proto_table->proto_table.num_ents;
+					i++) {
+				if (proto_table->proto_table.entries[i].node !=
+						&kparsenode->parse_node.node)
+					continue;
+				rcu_assign_pointer(proto_table->proto_table.entries[i].node, NULL);
+				memset(&proto_table->proto_table.entries[i], 0,
+				       sizeof(proto_table->proto_table.entries[i]));
+				synchronize_rcu();
+				break;
+			}
+		}
+
+		if (kparser_link_break(NULL, obj, curr_ref, rsp) != 0)
+			return -EFAULT;
+		kparser_free(curr_ref);
+	}
+
+	return 0;
+}
+
+/* bookkeeping function to break a link between an owner and owned object */
+int kparser_link_detach(const void *obj,
+			struct list_head *owner_list,
+			struct list_head *owned_list,
+			struct kparser_cmd_rsp_hdr *rsp)
+{
+	if (kparser_link_detach_owner(obj, owner_list, rsp) != 0)
+		return -EFAULT;
+
+	if (kparser_link_detach_owned(obj, owned_list, rsp) != 0)
+		return -EFAULT;
+
+	return 0;
+}
+
+/* kParser KMOD's namespace definitions */
+struct kparser_mod_namespaces {
+	enum kparser_global_namespace_ids namespace_id;
+	const char *name;
+	struct kparser_htbl htbl_name;
+	struct kparser_htbl htbl_id;
+	kparser_obj_create_update *create_handler;
+	kparser_obj_create_update *update_handler;
+	kparser_obj_read_del *read_handler;
+	kparser_obj_read_del *del_handler;
+	kparser_free_obj *free_handler;
+	size_t bv_len;
+	unsigned long *bv;
+};
+
+/* Statically define kParser KMOD's namespaces with all the parameters */
+#define KPARSER_DEFINE_MOD_NAMESPACE(g_ns_obj, nsid, obj_name, field, create,	\
+				     read, update, delete, free)		\
+static struct kparser_mod_namespaces g_ns_obj = {				\
+	.namespace_id = nsid,							\
+	.name = #nsid,								\
+	.htbl_name =	{							\
+		.tbl_params = {							\
+			.head_offset = offsetof(				\
+					struct obj_name,			\
+					field.ht_node_name),			\
+			.key_offset = offsetof(					\
+					struct obj_name,			\
+					field.key.name),			\
+			.key_len = sizeof(((struct kparser_hkey *)0)->name),	\
+			.automatic_shrinking = true,				\
+			.hashfn = kparser_generic_hash_fn_name,			\
+			.obj_hashfn = kparser_generic_obj_hashfn_name,		\
+			.obj_cmpfn = kparser_cmp_fn_name,			\
+		}								\
+	},									\
+	.htbl_id =	{							\
+		.tbl_params = {							\
+			.head_offset = offsetof(				\
+					struct obj_name,			\
+					field.ht_node_id),			\
+			.key_offset = offsetof(					\
+					struct obj_name,			\
+					field.key.id),				\
+			.key_len = sizeof(((struct kparser_hkey *)0)->id),	\
+			.automatic_shrinking = true,				\
+			.hashfn = kparser_generic_hash_fn_id,			\
+			.obj_hashfn = kparser_generic_obj_hashfn_id,		\
+			.obj_cmpfn = kparser_cmp_fn_id,				\
+		}								\
+	},									\
+										\
+	.create_handler = create,						\
+	.read_handler = read,							\
+	.update_handler = update,						\
+	.del_handler = delete,							\
+	.free_handler = free,							\
+}
+
+KPARSER_DEFINE_MOD_NAMESPACE(kparser_mod_namespace_condexprs,
+			     KPARSER_NS_CONDEXPRS,
+			     kparser_glue_condexpr_expr,
+			     glue,
+			     kparser_create_cond_exprs,
+			     kparser_read_cond_exprs,
+			     NULL, NULL, NULL);
+
+KPARSER_DEFINE_MOD_NAMESPACE(kparser_mod_namespace_condexprs_table,
+			     KPARSER_NS_CONDEXPRS_TABLE,
+			     kparser_glue_condexpr_table,
+			     glue,
+			     kparser_create_cond_table,
+			     kparser_read_cond_table,
+			     NULL, NULL, NULL);
+
+KPARSER_DEFINE_MOD_NAMESPACE(kparser_mod_namespace_condexprs_tables,
+			     KPARSER_NS_CONDEXPRS_TABLES,
+			     kparser_glue_condexpr_tables,
+			     glue,
+			     kparser_create_cond_tables,
+			     kparser_read_cond_tables,
+			     NULL, NULL, NULL);
+
+KPARSER_DEFINE_MOD_NAMESPACE(kparser_mod_namespace_counter,
+			     KPARSER_NS_COUNTER,
+			     kparser_glue_counter,
+			     glue,
+			     kparser_create_counter,
+			     kparser_read_counter,
+			     NULL, NULL, NULL);
+
+KPARSER_DEFINE_MOD_NAMESPACE(kparser_mod_namespace_counter_table,
+			     KPARSER_NS_COUNTER_TABLE,
+			     kparser_glue_counter_table,
+			     glue,
+			     kparser_create_counter_table,
+			     kparser_read_counter_table,
+			     NULL, NULL, NULL);
+
+KPARSER_DEFINE_MOD_NAMESPACE(kparser_mod_namespace_metadata,
+			     KPARSER_NS_METADATA,
+			     kparser_glue_metadata_extract,
+			     glue,
+			     kparser_create_metadata,
+			     kparser_read_metadata,
+			     NULL,
+			     kparser_del_metadata,
+			     kparser_free_metadata);
+
+KPARSER_DEFINE_MOD_NAMESPACE(kparser_mod_namespace_metalist,
+			     KPARSER_NS_METALIST,
+			     kparser_glue_metadata_table,
+			     glue,
+			     kparser_create_metalist,
+			     kparser_read_metalist,
+			     NULL,
+			     kparser_del_metalist,
+			     kparser_free_metalist);
+
+KPARSER_DEFINE_MOD_NAMESPACE(kparser_mod_namespace_node_parse,
+			     KPARSER_NS_NODE_PARSE,
+			     kparser_glue_glue_parse_node,
+			     glue.glue,
+			     kparser_create_parse_node,
+			     kparser_read_parse_node,
+			     NULL,
+			     kparser_del_parse_node,
+			     kparser_free_node);
+
+KPARSER_DEFINE_MOD_NAMESPACE(kparser_mod_namespace_proto_table,
+			     KPARSER_NS_PROTO_TABLE,
+			     kparser_glue_protocol_table,
+			     glue,
+			     kparser_create_proto_table,
+			     kparser_read_proto_table,
+			     NULL,
+			     kparser_del_proto_table,
+			     kparser_free_proto_tbl);
+
+KPARSER_DEFINE_MOD_NAMESPACE(kparser_mod_namespace_tlv_node_parse,
+			     KPARSER_NS_TLV_NODE_PARSE,
+			     kparser_glue_parse_tlv_node,
+			     glue.glue,
+			     kparser_create_parse_tlv_node,
+			     kparser_read_parse_tlv_node,
+			     NULL, NULL, NULL);
+
+KPARSER_DEFINE_MOD_NAMESPACE(kparser_mod_namespace_tlv_proto_table,
+			     KPARSER_NS_TLV_PROTO_TABLE,
+			     kparser_glue_proto_tlvs_table,
+			     glue,
+			     kparser_create_tlv_proto_table,
+			     kparser_read_tlv_proto_table,
+			     NULL, NULL, NULL);
+
+KPARSER_DEFINE_MOD_NAMESPACE(kparser_mod_namespace_flag_field,
+			     KPARSER_NS_FLAG_FIELD,
+			     kparser_glue_flag_field,
+			     glue,
+			     kparser_create_flag_field,
+			     kparser_read_flag_field,
+			     NULL, NULL, NULL);
+
+KPARSER_DEFINE_MOD_NAMESPACE(kparser_mod_namespace_flag_field_table,
+			     KPARSER_NS_FLAG_FIELD_TABLE,
+			     kparser_glue_flag_fields,
+			     glue,
+			     kparser_create_flag_field_table,
+			     kparser_read_flag_field_table,
+			     NULL, NULL, NULL);
+
+KPARSER_DEFINE_MOD_NAMESPACE(kparser_mod_namespace_flag_field_parse_node,
+			     KPARSER_NS_FLAG_FIELD_NODE_PARSE,
+			     kparser_glue_flag_field_node,
+			     glue.glue,
+			     kparser_create_parse_flag_field_node,
+			     kparser_read_parse_flag_field_node,
+			     NULL, NULL, NULL);
+
+KPARSER_DEFINE_MOD_NAMESPACE(kparser_mod_namespace_flag_field_proto_table,
+			     KPARSER_NS_FLAG_FIELD_PROTO_TABLE,
+			     kparser_glue_proto_flag_fields_table,
+			     glue,
+			     kparser_create_flag_field_proto_table,
+			     kparser_read_flag_field_proto_table,
+			     NULL, NULL, NULL);
+
+KPARSER_DEFINE_MOD_NAMESPACE(kparser_mod_namespace_parser,
+			     KPARSER_NS_PARSER,
+			     kparser_glue_parser,
+			     glue,
+			     kparser_create_parser,
+			     kparser_read_parser,
+			     NULL,
+			     kparser_del_parser,
+			     kparser_free_parser);
+
+KPARSER_DEFINE_MOD_NAMESPACE(kparser_mod_namespace_parser_lock_unlock,
+			     KPARSER_NS_OP_PARSER_LOCK_UNLOCK,
+			     kparser_glue_parser,
+			     glue,
+			     kparser_parser_lock,
+			     NULL, NULL,
+			     kparser_parser_unlock,
+			     NULL);
+
+static struct kparser_mod_namespaces *g_mod_namespaces[] = {
+	[KPARSER_NS_INVALID] = NULL,
+	[KPARSER_NS_CONDEXPRS] = &kparser_mod_namespace_condexprs,
+	[KPARSER_NS_CONDEXPRS_TABLE] = &kparser_mod_namespace_condexprs_table,
+	[KPARSER_NS_CONDEXPRS_TABLES] =
+		&kparser_mod_namespace_condexprs_tables,
+	[KPARSER_NS_COUNTER] = &kparser_mod_namespace_counter,
+	[KPARSER_NS_COUNTER_TABLE] = &kparser_mod_namespace_counter_table,
+	[KPARSER_NS_METADATA] = &kparser_mod_namespace_metadata,
+	[KPARSER_NS_METALIST] = &kparser_mod_namespace_metalist,
+	[KPARSER_NS_NODE_PARSE] = &kparser_mod_namespace_node_parse,
+	[KPARSER_NS_PROTO_TABLE] = &kparser_mod_namespace_proto_table,
+	[KPARSER_NS_TLV_NODE_PARSE] = &kparser_mod_namespace_tlv_node_parse,
+	[KPARSER_NS_TLV_PROTO_TABLE] = &kparser_mod_namespace_tlv_proto_table,
+	[KPARSER_NS_FLAG_FIELD] = &kparser_mod_namespace_flag_field,
+	[KPARSER_NS_FLAG_FIELD_TABLE] =
+		&kparser_mod_namespace_flag_field_table,
+	[KPARSER_NS_FLAG_FIELD_NODE_PARSE] =
+		&kparser_mod_namespace_flag_field_parse_node,
+	[KPARSER_NS_FLAG_FIELD_PROTO_TABLE] =
+		&kparser_mod_namespace_flag_field_proto_table,
+	[KPARSER_NS_PARSER] = &kparser_mod_namespace_parser,
+	[KPARSER_NS_OP_PARSER_LOCK_UNLOCK] =
+		&kparser_mod_namespace_parser_lock_unlock,
+	[KPARSER_NS_MAX] = NULL,
+};
+
+/* Function to allocate autogen IDs for hash keys if user did not allocate themselves
+ * TODO: free ids
+ */
+static inline __u16 allocate_id(__u16 id, unsigned long *bv, size_t bvsize)
+{
+	int i;
+
+	if (id != KPARSER_INVALID_ID) {
+		/* try to allocate passed id */
+		/* already allocated, conflict */
+		if (!test_bit(id, bv))
+			return KPARSER_INVALID_ID;
+		__clear_bit(id, bv);
+		return id;
+	}
+
+	/* allocate internally, scan bitvector */
+	for (i = 0; i < bvsize; i++) {
+		/* avoid bit vectors which are already full */
+		if (bv[i]) {
+			id = __builtin_ffs(bv[i]);
+			if (id) {
+				id--;
+				id += (i * BITS_PER_TYPE(unsigned long));
+				__clear_bit(id, bv);
+				return (id + KPARSER_KMOD_ID_MIN);
+			}
+			pr_alert("{%s:%d} ID alloc failed: {%d:%d}\n", __func__, __LINE__, id, i);
+			return KPARSER_INVALID_ID;
+		}
+	}
+
+	pr_alert("{%s:%d} ID alloc failed: {%d:%d}\n", __func__, __LINE__, id, i);
+	return KPARSER_INVALID_ID;
+}
+
+/* allocate hash key's autogen ID */
+static inline int kparser_allocate_key_id(enum kparser_global_namespace_ids ns_id,
+					  const struct kparser_hkey *key,
+					  struct kparser_hkey *new_key)
+{
+	*new_key = *key;
+	new_key->id = allocate_id(KPARSER_INVALID_ID,
+				  g_mod_namespaces[ns_id]->bv,
+				  g_mod_namespaces[ns_id]->bv_len);
+
+	if (new_key->id == KPARSER_INVALID_ID)
+		return -ENOENT;
+
+	return 0;
+}
+
+/* allocate hash key's autogen name */
+static inline bool kparser_allocate_key_name(enum kparser_global_namespace_ids ns_id,
+					     const struct kparser_hkey *key,
+					     struct kparser_hkey *new_key)
+{
+	*new_key = *key;
+	memset(new_key->name, 0, sizeof(new_key->name));
+	snprintf(new_key->name, sizeof(new_key->name),
+		 "%s-%s-%u", KPARSER_DEF_NAME_PREFIX,
+		 g_mod_namespaces[ns_id]->name, key->id);
+	new_key->name[sizeof(new_key->name) - 1] = '\0';
+	return true;
+}
+
+/* check and decide which component of hash key needs to be allocated using autogen code */
+int kparser_conf_key_manager(enum kparser_global_namespace_ids ns_id,
+			     const struct kparser_hkey *key,
+			     struct kparser_hkey *new_key,
+			     struct kparser_cmd_rsp_hdr *rsp,
+			     const char *op)
+{
+	if (kparser_hkey_empty(key)) {
+		rsp->op_ret_code = -EINVAL;
+		(void)snprintf(rsp->err_str_buf, sizeof(rsp->err_str_buf),
+				"%s:HKey missing", op);
+		return -EINVAL;
+	}
+
+	if (kparser_hkey_id_empty(key) && new_key)
+		return kparser_allocate_key_id(ns_id, key, new_key);
+
+	if (kparser_hkey_user_id_invalid(key)) {
+		rsp->op_ret_code = -EINVAL;
+		(void)snprintf(rsp->err_str_buf, sizeof(rsp->err_str_buf),
+				"%s:HKey id invalid:%u",
+				op, key->id);
+		return -EINVAL;
+	}
+
+	if (kparser_hkey_name_empty(key) && new_key)
+		return kparser_allocate_key_name(ns_id, key, new_key);
+
+	if (new_key)
+		*new_key = *key;
+
+	return 0;
+}
+
+/* remove an object from namespace */
+int kparser_namespace_remove(enum kparser_global_namespace_ids ns_id,
+			     struct rhash_head *obj_id,
+			     struct rhash_head *obj_name)
+{
+	int rc;
+
+	if (ns_id <= KPARSER_NS_INVALID || ns_id >= KPARSER_NS_MAX)
+		return -EINVAL;
+
+	if (!g_mod_namespaces[ns_id])
+		return -ENOENT;
+
+	rc = rhashtable_remove_fast(&g_mod_namespaces[ns_id]->htbl_id.tbl, obj_id,
+				    g_mod_namespaces[ns_id]->htbl_id.tbl_params);
+
+	if (rc)
+		return rc;
+
+	rc = rhashtable_remove_fast(&g_mod_namespaces[ns_id]->htbl_name.tbl, obj_name,
+				    g_mod_namespaces[ns_id]->htbl_name.tbl_params);
+
+	return rc;
+}
+
+/* lookup an object using hash key from namespace */
+void *kparser_namespace_lookup(enum kparser_global_namespace_ids ns_id,
+			       const struct kparser_hkey *key)
+{
+	void *ret;
+
+	if (ns_id <= KPARSER_NS_INVALID || ns_id >= KPARSER_NS_MAX)
+		return NULL;
+
+	if (!g_mod_namespaces[ns_id])
+		return NULL;
+
+	ret = rhashtable_lookup(&g_mod_namespaces[ns_id]->htbl_id.tbl,
+				&key->id,
+				g_mod_namespaces[ns_id]->htbl_id.tbl_params);
+
+	if (ret)
+		return ret;
+
+	ret = rhashtable_lookup(&g_mod_namespaces[ns_id]->htbl_name.tbl,
+				key->name,
+				g_mod_namespaces[ns_id]->htbl_name.tbl_params);
+
+	return ret;
+}
+
+/* insert an object using hash key into namespace */
+int kparser_namespace_insert(enum kparser_global_namespace_ids ns_id,
+			     struct rhash_head *obj_id,
+			     struct rhash_head *obj_name)
+{
+	int rc;
+
+	if (ns_id <= KPARSER_NS_INVALID || ns_id >= KPARSER_NS_MAX)
+		return -EINVAL;
+
+	if (!g_mod_namespaces[ns_id])
+		return -ENOENT;
+
+	rc = rhashtable_insert_fast(&g_mod_namespaces[ns_id]->htbl_id.tbl, obj_id,
+				    g_mod_namespaces[ns_id]->htbl_id.tbl_params);
+	if (rc)
+		return rc;
+
+	rc = rhashtable_insert_fast(&g_mod_namespaces[ns_id]->htbl_name.tbl, obj_name,
+				    g_mod_namespaces[ns_id]->htbl_name.tbl_params);
+
+	return rc;
+}
+
+/* allocate the manadatory very first response header (rsp) for netlink reply msg */
+int alloc_first_rsp(struct kparser_cmd_rsp_hdr **rsp, size_t *rsp_len, int nsid)
+{
+	if (!rsp || *rsp || !rsp_len || (*rsp_len != 0))
+		return -EINVAL;
+
+	*rsp = kzalloc(sizeof(**rsp), GFP_KERNEL);
+	if (!(*rsp)) {
+		pr_alert("%s:kzalloc failed for rsp, size:%lu\n", __func__, sizeof(**rsp));
+		return -ENOMEM;
+	}
+
+	*rsp_len = sizeof(struct kparser_cmd_rsp_hdr);
+	(*rsp)->object.namespace_id = nsid;
+	(*rsp)->objects_len = 0;
+	return 0;
+}
+
+/* initialize kParser's name space manager contexts */
+int kparser_init(void)
+{
+	int err, i, j;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	for (i = 0; i < (sizeof(g_mod_namespaces) /
+				sizeof(g_mod_namespaces[0])); i++) {
+		if (!g_mod_namespaces[i])
+			continue;
+
+		err = rhashtable_init(&g_mod_namespaces[i]->htbl_name.tbl,
+				      &g_mod_namespaces[i]->htbl_name.tbl_params);
+		if (err)
+			goto handle_error;
+
+		err = rhashtable_init(&g_mod_namespaces[i]->htbl_id.tbl,
+				      &g_mod_namespaces[i]->htbl_id.tbl_params);
+		if (err)
+			goto handle_error;
+
+		g_mod_namespaces[i]->bv_len =
+			((KPARSER_KMOD_ID_MAX - KPARSER_KMOD_ID_MIN) /
+			 BITS_PER_TYPE(unsigned long)) + 1;
+
+		pr_debug("{%s:%d}:bv_len:%lu, total_bytes:%lu, range:[%d:%d]\n",
+			 __func__, __LINE__,
+			 g_mod_namespaces[i]->bv_len,
+			 sizeof(__u32) * g_mod_namespaces[i]->bv_len,
+			 KPARSER_KMOD_ID_MAX, KPARSER_KMOD_ID_MIN);
+
+		g_mod_namespaces[i]->bv = kcalloc(g_mod_namespaces[i]->bv_len, sizeof(__u32),
+						  GFP_KERNEL);
+
+		if (!g_mod_namespaces[i]->bv) {
+			pr_alert("%s: kzalloc() failed\n", __func__);
+			goto handle_error;
+		}
+
+		memset(g_mod_namespaces[i]->bv, 0xff, g_mod_namespaces[i]->bv_len * sizeof(__u32));
+	}
+
+	pr_debug("OUT: %s:%s:%d:err:%d\n", __FILE__, __func__, __LINE__, err);
+
+	return 0;
+
+handle_error:
+	for (j = 0; j < i; j++) {
+		if (!g_mod_namespaces[j])
+			continue;
+
+		rhashtable_destroy(&g_mod_namespaces[j]->htbl_name.tbl);
+		rhashtable_destroy(&g_mod_namespaces[j]->htbl_id.tbl);
+
+		kparser_free(g_mod_namespaces[j]->bv);
+		g_mod_namespaces[j]->bv_len = 0;
+	}
+
+	pr_debug("OUT: %s() failed, err: %d\n", __func__, err);
+
+	return err;
+}
+
+/* de-initialize kParser's name space manager contexts and free and remove all entries */
+int kparser_deinit(void)
+{
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	for (i = 0; i < ARRAY_SIZE(g_mod_namespaces); i++) {
+		if (!g_mod_namespaces[i])
+			continue;
+
+		rhashtable_destroy(&g_mod_namespaces[i]->htbl_name.tbl);
+		rhashtable_free_and_destroy(&g_mod_namespaces[i]->htbl_id.tbl,
+					    g_mod_namespaces[i]->free_handler, NULL);
+
+		kparser_free(g_mod_namespaces[i]->bv);
+
+		g_mod_namespaces[i]->bv_len = 0;
+	}
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return 0;
+}
+
+/* pre-process handler for all the netlink msg processors */
+static inline const struct kparser_conf_cmd
+*kparser_config_handler_preprocess(const void *cmdarg,
+				   size_t cmdarglen, struct kparser_cmd_rsp_hdr **rsp,
+				   size_t *rsp_len)
+{
+	enum kparser_global_namespace_ids ns_id;
+	const struct kparser_conf_cmd *conf;
+	int rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	conf = cmdarg;
+	if (!conf || cmdarglen < sizeof(*conf) || !rsp || *rsp || !rsp_len ||
+	    (*rsp_len != 0) || conf->namespace_id <= KPARSER_NS_INVALID ||
+	    conf->namespace_id >= KPARSER_NS_MAX) {
+		pr_debug("{%s:%d}:[%p %lu %p %p %p %lu %d]\n",
+			 __func__, __LINE__,
+			 conf, cmdarglen, rsp, *rsp, rsp_len,
+			 *rsp_len, conf->namespace_id);
+		goto err_return;
+	}
+
+	ns_id = conf->namespace_id;
+
+	if (!g_mod_namespaces[ns_id])
+		goto err_return;
+
+	if (!g_mod_namespaces[ns_id]->create_handler)
+		goto err_return;
+
+	rc = alloc_first_rsp(rsp, rsp_len, conf->namespace_id);
+	if (rc) {
+		pr_debug("%s:alloc_first_rsp() failed, rc:%d\n",
+			 __func__, rc);
+		goto err_return;
+	}
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return cmdarg;
+
+err_return:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return NULL;
+}
+
+#define KPARSER_CONFIG_HANDLER_PRE()					\
+do {									\
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);	\
+	conf = kparser_config_handler_preprocess(cmdarg, cmdarglen,	\
+			rsp, rsp_len);					\
+	if (!conf)							\
+		pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__,		\
+				__LINE__);				\
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);	\
+}									\
+while (0)
+
+/* netlink msg processors for create */
+int kparser_config_handler_add(const void *cmdarg, size_t cmdarglen,
+			       struct kparser_cmd_rsp_hdr **rsp, size_t *rsp_len)
+{
+	const struct kparser_conf_cmd *conf;
+
+	KPARSER_CONFIG_HANDLER_PRE();
+
+	if (!conf)
+		return KPARSER_ATTR_UNSPEC;
+
+	if (!g_mod_namespaces[conf->namespace_id]->create_handler)
+		return KPARSER_ATTR_UNSPEC;
+
+	return g_mod_namespaces[conf->namespace_id]->create_handler(conf, cmdarglen,
+								    rsp, rsp_len, "create");
+}
+
+/* netlink msg processors for update */
+int kparser_config_handler_update(const void *cmdarg, size_t cmdarglen,
+				  struct kparser_cmd_rsp_hdr **rsp, size_t *rsp_len)
+{
+	const struct kparser_conf_cmd *conf;
+
+	KPARSER_CONFIG_HANDLER_PRE();
+
+	if (!conf)
+		return KPARSER_ATTR_UNSPEC;
+
+	if (!g_mod_namespaces[conf->namespace_id]->update_handler)
+		return KPARSER_ATTR_UNSPEC;
+
+	return g_mod_namespaces[conf->namespace_id]->update_handler(conf, cmdarglen,
+								    rsp, rsp_len, "update");
+}
+
+/* netlink msg processors for read */
+int kparser_config_handler_read(const void *cmdarg, size_t cmdarglen,
+				struct kparser_cmd_rsp_hdr **rsp, size_t *rsp_len)
+{
+	const struct kparser_conf_cmd *conf;
+
+	KPARSER_CONFIG_HANDLER_PRE();
+
+	if (!conf)
+		return KPARSER_ATTR_UNSPEC;
+
+	if (!g_mod_namespaces[conf->namespace_id]->read_handler)
+		return KPARSER_ATTR_UNSPEC;
+
+	return g_mod_namespaces[conf->namespace_id]->read_handler(&conf->obj_key, rsp, rsp_len,
+			conf->recursive_read_delete, "read");
+}
+
+/* netlink msg processors for delete */
+int kparser_config_handler_delete(const void *cmdarg, size_t cmdarglen,
+				  struct kparser_cmd_rsp_hdr **rsp, size_t *rsp_len)
+{
+	const struct kparser_conf_cmd *conf;
+
+	KPARSER_CONFIG_HANDLER_PRE();
+
+	if (!conf)
+		return KPARSER_ATTR_UNSPEC;
+
+	if (!g_mod_namespaces[conf->namespace_id]->del_handler)
+		return KPARSER_ATTR_UNSPEC;
+
+	return g_mod_namespaces[conf->namespace_id]->del_handler(&conf->obj_key, rsp, rsp_len,
+			conf->recursive_read_delete, "delete");
+}
diff --git a/net/kparser/kparser_cmds_dump_ops.c b/net/kparser/kparser_cmds_dump_ops.c
new file mode 100644
index 000000000000..0a4c47cf78ea
--- /dev/null
+++ b/net/kparser/kparser_cmds_dump_ops.c
@@ -0,0 +1,532 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2022, SiPanda Inc.
+ *
+ * kparser_cmds_dump_ops.c - kParser KMOD-CLI debug dump operations
+ *
+ * Author:      Pratyush Kumar Khan <pratyush@sipanda.io>
+ */
+
+#include "kparser.h"
+
+/* forward declarations of dump functions which dump config structures for debug purposes */
+static void kparser_dump_node(const struct kparser_parse_node *obj);
+static void kparser_dump_proto_table(const struct kparser_proto_table *obj);
+static void kparser_dump_tlv_parse_node(const struct kparser_parse_tlv_node *obj);
+static void kparser_dump_metadatatable(const struct kparser_metadata_table *obj);
+static void kparser_dump_cond_tables(const struct kparser_condexpr_tables *obj);
+
+/* debug code: dump kparser_parameterized_len structure */
+static void kparser_dump_param_len(const struct kparser_parameterized_len *pflen)
+{
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!pflen) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	pr_debug("pflen.src_off:%u\n", pflen->src_off);
+	pr_debug("pflen.size:%u\n", pflen->size);
+	pr_debug("pflen.endian:%d\n", pflen->endian);
+	pr_debug("pflen.mask:%u\n", pflen->mask);
+	pr_debug("pflen.right_shift:%u\n", pflen->right_shift);
+	pr_debug("pflen.multiplier:%u\n", pflen->multiplier);
+	pr_debug("pflen.add_value:%u\n", pflen->add_value);
+
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_parameterized_next_proto structure */
+static void kparser_dump_param_next_proto(const struct kparser_parameterized_next_proto
+					  *pfnext_proto)
+{
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!pfnext_proto) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	pr_debug("pfnext_proto.src_off:%u\n", pfnext_proto->src_off);
+	pr_debug("pfnext_proto.mask:%u\n", pfnext_proto->mask);
+	pr_debug("pfnext_proto.size:%u\n", pfnext_proto->size);
+	pr_debug("pfnext_proto.right_shift:%u\n", pfnext_proto->right_shift);
+
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_condexpr_expr structure */
+static void kparser_dump_cond_expr(const struct kparser_condexpr_expr *obj)
+{
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	pr_debug("type:%u, src_off:%u, len:%u, mask:%04x value:%04x\n",
+		 obj->type, obj->src_off,
+			obj->length, obj->mask, obj->value);
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_condexpr_table structure */
+static void kparser_dump_cond_table(const struct kparser_condexpr_table *obj)
+{
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	pr_debug("default_fail:%d, type:%u\n", obj->default_fail, obj->type);
+	pr_debug("num_ents:%u, entries:%p\n", obj->num_ents, obj->entries);
+
+	if (!obj->entries)
+		goto done;
+
+	for (i = 0; i < obj->num_ents; i++)
+		kparser_dump_cond_expr(obj->entries[i]);
+
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_condexpr_tables structure */
+static void kparser_dump_cond_tables(const struct kparser_condexpr_tables *obj)
+{
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	pr_debug("num_ents:%u, entries:%p\n", obj->num_ents, obj->entries);
+	if (!obj->entries)
+		goto done;
+
+	for (i = 0; i < obj->num_ents; i++)
+		kparser_dump_cond_table(obj->entries[i]);
+
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_proto_node structure */
+static void kparser_dump_proto_node(const struct kparser_proto_node *obj)
+{
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	pr_debug("encap:%u\n", obj->encap);
+	pr_debug("overlay:%u\n", obj->overlay);
+	pr_debug("min_len:%lu\n", obj->min_len);
+
+	pr_debug("ops.flag_fields_length:%d\n", obj->ops.flag_fields_length);
+
+	pr_debug("ops.len_parameterized:%d\n", obj->ops.len_parameterized);
+	kparser_dump_param_len(&obj->ops.pflen);
+
+	kparser_dump_param_next_proto(&obj->ops.pfnext_proto);
+
+	pr_debug("ops.cond_exprs_parameterized:%d\n", obj->ops.cond_exprs_parameterized);
+	kparser_dump_cond_tables(&obj->ops.cond_exprs);
+
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_proto_tlvs_table structure */
+static void kparser_dump_proto_tlvs_table(const struct kparser_proto_tlvs_table *obj)
+{
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	pr_debug("num_ents:%u, entries:%p\n", obj->num_ents, obj->entries);
+	if (!obj->entries)
+		goto done;
+
+	for (i = 0; i < obj->num_ents; i++) {
+		pr_debug("[%d]: val: %04x\n", i, obj->entries[i].type);
+		kparser_dump_tlv_parse_node(obj->entries[i].node);
+	}
+
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_parse_tlv_node structure */
+static void kparser_dump_tlv_parse_node(const struct kparser_parse_tlv_node *obj)
+{
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	pr_debug("name: %s\n", obj->name);
+	pr_debug("unknown_tlv_type_ret:%d\n", obj->unknown_overlay_ret);
+
+	pr_debug("proto_tlv_node.min_len: %lu\n", obj->proto_tlv_node.min_len);
+	pr_debug("proto_tlv_node.max_len: %lu\n", obj->proto_tlv_node.max_len);
+	pr_debug("proto_tlv_node.is_padding: %u\n", obj->proto_tlv_node.is_padding);
+	pr_debug("proto_tlv_node.overlay_type_parameterized: %u\n",
+		 obj->proto_tlv_node.ops.overlay_type_parameterized);
+	kparser_dump_param_next_proto(&obj->proto_tlv_node.ops.pfoverlay_type);
+	pr_debug("proto_tlv_node.cond_exprs_parameterized: %u\n",
+		 obj->proto_tlv_node.ops.cond_exprs_parameterized);
+	kparser_dump_cond_tables(&obj->proto_tlv_node.ops.cond_exprs);
+
+	kparser_dump_proto_tlvs_table(obj->overlay_table);
+	kparser_dump_tlv_parse_node(obj->overlay_wildcard_node);
+	kparser_dump_metadatatable(obj->metadata_table);
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_parse_tlvs_node structure */
+static void kparser_dump_tlvs_parse_node(const struct kparser_parse_tlvs_node *obj)
+{
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	kparser_dump_proto_tlvs_table(obj->tlv_proto_table);
+
+	pr_debug("unknown_tlv_type_ret:%d\n", obj->unknown_tlv_type_ret);
+
+	kparser_dump_tlv_parse_node(obj->tlv_wildcard_node);
+
+	pr_debug("config:max_loop: %u\n", obj->config.max_loop);
+	pr_debug("config:max_non: %u\n", obj->config.max_non);
+	pr_debug("config:max_plen: %u\n", obj->config.max_plen);
+	pr_debug("config:max_c_pad: %u\n", obj->config.max_c_pad);
+	pr_debug("config:disp_limit_exceed: %u\n", obj->config.disp_limit_exceed);
+	pr_debug("config:exceed_loop_cnt_is_err: %u\n", obj->config.exceed_loop_cnt_is_err);
+
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_proto_tlvs_node structure */
+static void kparser_dump_tlvs_proto_node(const struct kparser_proto_tlvs_node *obj)
+{
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	kparser_dump_proto_node(&obj->proto_node);
+
+	kparser_dump_param_len(&obj->ops.pfstart_offset);
+	pr_debug("ops.len_parameterized:%d\n", obj->ops.len_parameterized);
+	kparser_dump_param_len(&obj->ops.pflen);
+	kparser_dump_param_next_proto(&obj->ops.pftype);
+
+	pr_debug("start_offset:%lu\n", obj->start_offset);
+	pr_debug("pad1_val:%u\n", obj->pad1_val);
+	pr_debug("padn_val:%u\n", obj->padn_val);
+	pr_debug("eol_val:%u\n", obj->eol_val);
+	pr_debug("pad1_enable:%u\n", obj->pad1_enable);
+	pr_debug("padn_enable:%u\n", obj->padn_enable);
+	pr_debug("eol_enable:%u\n", obj->eol_enable);
+	pr_debug("fixed_start_offset:%u\n", obj->fixed_start_offset);
+	pr_debug("min_len:%lu\n", obj->min_len);
+
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_flag_field structure */
+static void kparser_dump_flag_field(const struct kparser_flag_field *obj)
+{
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	pr_debug("flag:%04x, mask:%04x size:%lu\n", obj->flag, obj->mask, obj->size);
+
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_flag_fields structure */
+static void kparser_dump_flag_fields(const struct kparser_flag_fields *obj)
+{
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	pr_debug("num_idx:%lu, fields:%p\n", obj->num_idx, obj->fields);
+
+	if (!obj->fields)
+		goto done;
+
+	for (i = 0; i < obj->num_idx; i++)
+		kparser_dump_flag_field(&obj->fields[i]);
+
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_parse_flag_field_node structure */
+static void kparser_dump_parse_flag_field_node(const struct kparser_parse_flag_field_node *obj)
+{
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	pr_debug("name: %s\n", obj->name);
+
+	kparser_dump_metadatatable(obj->metadata_table);
+	kparser_dump_cond_tables(&obj->ops.cond_exprs);
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_proto_flag_fields_table structure */
+static void kparser_dump_proto_flag_fields_table(const struct kparser_proto_flag_fields_table *obj)
+{
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	pr_debug("num_ents:%d, entries:%p\n", obj->num_ents, obj->entries);
+
+	if (!obj->entries)
+		goto done;
+
+	for (i = 0; i < obj->num_ents; i++) {
+		pr_debug("proto_flag_fields_table_entry_flag:%x\n", obj->entries[i].flag);
+		kparser_dump_parse_flag_field_node(obj->entries[i].node);
+	}
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_parse_flag_fields_node structure */
+static void kparser_dump_flags_parse_node(const struct kparser_parse_flag_fields_node *obj)
+{
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	kparser_dump_proto_flag_fields_table(obj->flag_fields_proto_table);
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_proto_flag_fields_node structure */
+static void kparser_dump_flags_proto_node(const struct kparser_proto_flag_fields_node *obj)
+{
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	kparser_dump_proto_node(&obj->proto_node);
+
+	pr_debug("ops.get_flags_parameterized:%d\n", obj->ops.get_flags_parameterized);
+	pr_debug("ops.pfget_flags: src_off:%u mask:%04x size:%u\n",
+		 obj->ops.pfget_flags.src_off,
+		 obj->ops.pfget_flags.mask,
+		 obj->ops.pfget_flags.size);
+
+	pr_debug("ops.start_fields_offset_parameterized:%d\n",
+		 obj->ops.start_fields_offset_parameterized);
+	kparser_dump_param_len(&obj->ops.pfstart_fields_offset);
+
+	pr_debug("ops.flag_feilds_len:%u ops.hdr_length:%u\n",
+		 obj->ops.flag_fields_len, obj->ops.hdr_length);
+
+	kparser_dump_flag_fields(obj->flag_fields);
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_metadata_table structure */
+static void kparser_dump_metadatatable(const struct kparser_metadata_table *obj)
+{
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	pr_debug("num_ents:%u, entries:%p\n", obj->num_ents, obj->entries);
+	if (!obj->entries)
+		goto done;
+
+	for (i = 0; i < obj->num_ents; i++)
+		pr_debug("mde[%d]:%04x\n", i, obj->entries[i].val);
+
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_proto_table structure */
+static void kparser_dump_proto_table(const struct kparser_proto_table *obj)
+{
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	pr_debug("num_ents:%u, entries:%p\n", obj->num_ents, obj->entries);
+	if (!obj->entries)
+		goto done;
+
+	for (i = 0; i < obj->num_ents; i++) {
+		pr_debug("[%d]: val: %d\n", i, obj->entries[i].value);
+		kparser_dump_node(obj->entries[i].node);
+	}
+
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump kparser_parse_node structure */
+static void kparser_dump_node(const struct kparser_parse_node *obj)
+{
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	pr_debug("name: %s: type: %d\n", obj->name, obj->node_type);
+	pr_debug("unknown_ret:%d\n", obj->unknown_ret);
+
+	switch (obj->node_type) {
+	case KPARSER_NODE_TYPE_PLAIN:
+		kparser_dump_proto_node(&obj->proto_node);
+		break;
+
+	case KPARSER_NODE_TYPE_TLVS:
+		kparser_dump_tlvs_proto_node(&obj->tlvs_proto_node);
+		kparser_dump_tlvs_parse_node((const struct kparser_parse_tlvs_node *)obj);
+		break;
+
+	case KPARSER_NODE_TYPE_FLAG_FIELDS:
+		kparser_dump_flags_proto_node(&obj->flag_fields_proto_node);
+		kparser_dump_flags_parse_node((const struct kparser_parse_flag_fields_node *)obj);
+		break;
+
+	default:
+		pr_debug("unknown node type:%d\n", obj->node_type);
+		break;
+	}
+
+	kparser_dump_proto_table(obj->proto_table);
+
+	kparser_dump_node(obj->wildcard_node);
+
+	kparser_dump_metadatatable(obj->metadata_table);
+
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
+
+/* debug code: dump whole parse tree from kparser_parser structure */
+void kparser_dump_parser_tree(const struct kparser_parser *obj)
+{
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	if (!obj) {
+		pr_debug("obj NULL");
+		goto done;
+	}
+
+	pr_debug("name: %s\n", obj->name);
+
+	pr_debug("config: flags:%02x\n", obj->config.flags);
+	pr_debug("config: max_nodes:%u\n", obj->config.max_nodes);
+	pr_debug("config: max_encaps:%u\n", obj->config.max_encaps);
+	pr_debug("config: max_frames:%u\n", obj->config.max_frames);
+	pr_debug("config: metameta_size:%lu\n", obj->config.metameta_size);
+	pr_debug("config: frame_size:%lu\n", obj->config.frame_size);
+
+	pr_debug("cntrs_len: %lu\n", obj->cntrs_len);
+	for (i = 0; i < (sizeof(obj->cntrs_conf.cntrs) /
+				sizeof(obj->cntrs_conf.cntrs[0])); i++) {
+		pr_debug("cntrs:%d: max_value:%u\n", i,
+			 obj->cntrs_conf.cntrs[i].max_value);
+		pr_debug("cntrs:%d: array_limit:%u\n", i,
+			 obj->cntrs_conf.cntrs[i].array_limit);
+		pr_debug("cntrs:%d: el_size:%lu\n", i,
+			 obj->cntrs_conf.cntrs[i].el_size);
+		pr_debug("cntrs:%d: reset_on_encap:%d\n", i,
+			 obj->cntrs_conf.cntrs[i].reset_on_encap);
+		pr_debug("cntrs:%d: overwrite_last:%d\n", i,
+			 obj->cntrs_conf.cntrs[i].overwrite_last);
+		pr_debug("cntrs:%d: error_on_exceeded:%d\n", i,
+			 obj->cntrs_conf.cntrs[i].error_on_exceeded);
+		if (obj->cntrs)
+			pr_debug("cntr[%d]:%d", i, obj->cntrs->cntr[i]);
+	}
+
+	kparser_dump_node(obj->root_node);
+	kparser_dump_node(obj->okay_node);
+	kparser_dump_node(obj->fail_node);
+	kparser_dump_node(obj->atencap_node);
+
+done:
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+}
diff --git a/net/kparser/kparser_cmds_ops.c b/net/kparser/kparser_cmds_ops.c
new file mode 100644
index 000000000000..d2e7a1ec4083
--- /dev/null
+++ b/net/kparser/kparser_cmds_ops.c
@@ -0,0 +1,3621 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2022, SiPanda Inc.
+ *
+ * kparser_cmds_ops.c - kParser KMOD-CLI netlink request operations handlers
+ *
+ * Author:      Pratyush Kumar Khan <pratyush@sipanda.io>
+ */
+
+#include <linux/slab.h>
+#include <linux/sort.h>
+#include <net/kparser.h>
+
+#include "kparser.h"
+
+/* global netlink cmd handler mutex, all handlers must run within protection of this mutex
+ * NOTE: never use this mutex on data path operations since they can run under interrupt contexts
+ */
+static DEFINE_MUTEX(kparser_config_lock);
+
+/* global counter config, shared among all the parsers */
+static struct kparser_cntrs_conf cntrs_conf = {};
+static __u8 cntrs_conf_idx;
+
+/* common pre-process code for create handlers */
+static inline bool
+kparser_cmd_create_pre_process(const char *op,
+			       const struct kparser_conf_cmd *conf,
+			       const struct kparser_hkey *argkey, struct kparser_hkey *newkey,
+			       void **kobj, size_t kobjsize, struct kparser_cmd_rsp_hdr *rsp,
+			       size_t glueoffset)
+{
+	struct kparser_glue *glue;
+
+	if (kparser_conf_key_manager(conf->namespace_id, argkey, newkey, rsp, op) != 0) {
+		pr_alert("%s:%d\n", __func__, __LINE__);
+		return false;
+	}
+
+	pr_debug("{%s:%d} OP:%s Key{%s:%d}:{%s:%d}\n",
+		 __func__, __LINE__,
+		 op, argkey->name, argkey->id,
+		 newkey->name, newkey->id);
+
+	if (kparser_namespace_lookup(conf->namespace_id, newkey)) {
+		rsp->op_ret_code = EEXIST;
+		snprintf(rsp->err_str_buf,
+			 sizeof(rsp->err_str_buf),
+			 "%s:Duplicate object HKey:{%s:%u}",
+			 op, newkey->name, newkey->id);
+		return false;
+	}
+
+	*kobj = kzalloc(kobjsize, GFP_KERNEL);
+	if (!(*kobj)) {
+		rsp->op_ret_code = ENOMEM;
+		snprintf(rsp->err_str_buf,
+			 sizeof(rsp->err_str_buf),
+			 "%s:Object allocation failed for size:%lu",
+			 op, kobjsize);
+		return false;
+	}
+
+	glue = (*kobj) + glueoffset;
+	glue->key = *newkey;
+
+	rsp->op_ret_code = kparser_namespace_insert(conf->namespace_id,
+						    &glue->ht_node_id, &glue->ht_node_name);
+	if (rsp->op_ret_code) {
+		snprintf(rsp->err_str_buf,
+			 sizeof(rsp->err_str_buf),
+			 "%s:Htbl insert err:%d", op, rsp->op_ret_code);
+		return false;
+	}
+
+	glue->config = *conf;
+	kref_init(&glue->refcount);
+
+	snprintf(rsp->err_str_buf, sizeof(rsp->err_str_buf), "%s:Success", op);
+	rsp->key = *newkey;
+	rsp->object.conf_keys_bv = conf->conf_keys_bv;
+	rsp->object = *conf;
+
+	return true;
+}
+
+/* Following functions create kParser object handlers for netlink msgs
+ * create handler for object conditionals
+ * NOTE: All handlers startting from here must hold mutex kparser_config_lock
+ * before any work can be done and must release that mutex before return.
+ */
+int kparser_create_cond_exprs(const struct kparser_conf_cmd *conf,
+			      size_t conf_len,
+			      struct kparser_cmd_rsp_hdr **rsp,
+			      size_t *rsp_len, const char *op)
+{
+	struct kparser_glue_condexpr_expr *kobj = NULL;
+	const struct kparser_conf_condexpr *arg;
+	struct kparser_hkey key;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	mutex_lock(&kparser_config_lock);
+
+	arg = &conf->cond_conf;
+
+	if (!kparser_cmd_create_pre_process(op, conf, &arg->key, &key,
+					    (void **)&kobj, sizeof(*kobj), *rsp,
+					    offsetof(struct kparser_glue_condexpr_expr, glue)))
+		goto done;
+
+	kobj->expr = arg->config;
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "OK");
+	(*rsp)->key = key;
+	(*rsp)->object.conf_keys_bv = conf->conf_keys_bv;
+	(*rsp)->object.cond_conf = kobj->glue.config.cond_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	if ((*rsp)->op_ret_code != 0)
+		kparser_free(kobj);
+
+	synchronize_rcu();
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_CONDEXPRS);
+}
+
+/* read handler for object conditionals */
+int kparser_read_cond_exprs(const struct kparser_hkey *key,
+			    struct kparser_cmd_rsp_hdr **rsp,
+			    size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	struct kparser_glue_condexpr_expr *kobj;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	kobj = kparser_namespace_lookup(KPARSER_NS_CONDEXPRS, key);
+	if (!kobj) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found", __func__);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = kobj->glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = kobj->glue.config.conf_keys_bv;
+	(*rsp)->object.cond_conf = kobj->glue.config.cond_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_CONDEXPRS);
+}
+
+/* create handler for object conditionals table entry */
+static bool kparser_create_cond_table_ent(const struct kparser_conf_table *arg,
+					  struct kparser_glue_condexpr_table **proto_table,
+					  struct kparser_cmd_rsp_hdr *rsp)
+{
+	const struct kparser_glue_condexpr_expr *kcondent;
+	void *realloced_mem;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	*proto_table = kparser_namespace_lookup(KPARSER_NS_CONDEXPRS_TABLE, &arg->key);
+	if (!(*proto_table)) {
+		rsp->op_ret_code = ENOENT;
+		snprintf(rsp->err_str_buf,
+			 sizeof(rsp->err_str_buf),
+			 "%s: Object key not found", __func__);
+		return false;
+	}
+
+	kcondent = kparser_namespace_lookup(KPARSER_NS_CONDEXPRS, &arg->elem_key);
+	if (!kcondent) {
+		rsp->op_ret_code = ENOENT;
+		snprintf(rsp->err_str_buf,
+			 sizeof(rsp->err_str_buf),
+			 "%s: Object key:{%s:%u} not found",
+			 __func__, arg->elem_key.name, arg->elem_key.id);
+		return false;
+	}
+
+	(*proto_table)->table.num_ents++;
+	realloced_mem = krealloc((*proto_table)->table.entries,
+				 (*proto_table)->table.num_ents *
+				 sizeof(struct kparser_condexpr_expr *),
+				 GFP_KERNEL | ___GFP_ZERO);
+	if (!realloced_mem) {
+		rsp->op_ret_code = ENOMEM;
+		snprintf(rsp->err_str_buf,
+			 sizeof(rsp->err_str_buf),
+			 "%s: krealloc() err, ents:%d, size:%lu",
+			 __func__, (*proto_table)->table.num_ents,
+			 sizeof(struct kparser_condexpr_expr));
+		return false;
+	}
+	rcu_assign_pointer((*proto_table)->table.entries, realloced_mem);
+
+	(*proto_table)->table.entries[(*proto_table)->table.num_ents - 1] = &kcondent->expr;
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return true;
+}
+
+/* create handler for object conditionals table */
+int kparser_create_cond_table(const struct kparser_conf_cmd *conf,
+			      size_t conf_len,
+			      struct kparser_cmd_rsp_hdr **rsp,
+			      size_t *rsp_len, const char *op)
+{
+	struct kparser_glue_condexpr_table *proto_table = NULL;
+	const struct kparser_conf_table *arg;
+	struct kparser_hkey key;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	mutex_lock(&kparser_config_lock);
+
+	arg = &conf->table_conf;
+
+	/* create a table entry */
+	if (arg->add_entry) {
+		if (kparser_create_cond_table_ent(arg, &proto_table, *rsp) == false)
+			goto done;
+		goto skip_table_create;
+	}
+
+	if (!kparser_cmd_create_pre_process(op, conf, &arg->key, &key,
+					    (void **)&proto_table, sizeof(*proto_table), *rsp,
+					    offsetof(struct kparser_glue_condexpr_table, glue)))
+		goto done;
+
+	proto_table->glue.config.namespace_id = conf->namespace_id;
+	proto_table->glue.config.conf_keys_bv = conf->conf_keys_bv;
+	proto_table->glue.config.table_conf = *arg;
+	proto_table->glue.config.table_conf.key = key;
+	kref_init(&proto_table->glue.refcount);
+	proto_table->table.default_fail = arg->optional_value1;
+	proto_table->table.type = arg->optional_value2;
+
+skip_table_create:
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "OK");
+	(*rsp)->key = key;
+	(*rsp)->object.conf_keys_bv = conf->conf_keys_bv;
+	(*rsp)->object.table_conf = proto_table->glue.config.table_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	if ((*rsp)->op_ret_code != 0) {
+		if (proto_table && !arg->add_entry)
+			kparser_free(proto_table);
+	}
+
+	synchronize_rcu();
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_CONDEXPRS_TABLE);
+}
+
+/* read handler for object conditionals table */
+int kparser_read_cond_table(const struct kparser_hkey *key,
+			    struct kparser_cmd_rsp_hdr **rsp,
+			    size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	const struct kparser_glue_condexpr_table *proto_table;
+	const struct kparser_glue_condexpr_expr *kcondent;
+	struct kparser_conf_cmd *objects = NULL;
+	void *realloced_mem;
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	proto_table = kparser_namespace_lookup(KPARSER_NS_CONDEXPRS_TABLE, key);
+	if (!proto_table) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found", __func__);
+		goto done;
+	}
+
+	(*rsp)->key = proto_table->glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = proto_table->glue.config.conf_keys_bv;
+	(*rsp)->object.table_conf = proto_table->glue.config.table_conf;
+	(*rsp)->object.table_conf.optional_value1 = proto_table->table.default_fail;
+	(*rsp)->object.table_conf.optional_value2 = proto_table->table.type;
+
+	for (i = 0; i < proto_table->table.num_ents; i++) {
+		(*rsp)->objects_len++;
+		*rsp_len = *rsp_len + sizeof(struct kparser_conf_cmd);
+		realloced_mem = krealloc(*rsp, *rsp_len, GFP_KERNEL | ___GFP_ZERO);
+		if (!realloced_mem) {
+			pr_alert("%s:krealloc failed for rsp, len:%lu\n",
+				 __func__, *rsp_len);
+			*rsp_len = 0;
+			mutex_unlock(&kparser_config_lock);
+			return KPARSER_ATTR_UNSPEC;
+		}
+		*rsp = realloced_mem;
+		objects = (struct kparser_conf_cmd *)(*rsp)->objects;
+		objects[i].namespace_id = proto_table->glue.config.namespace_id;
+		objects[i].table_conf = proto_table->glue.config.table_conf;
+		if (!proto_table->table.entries)
+			continue;
+		kcondent = container_of(proto_table->table.entries[i],
+					struct kparser_glue_condexpr_expr, expr);
+		objects[i].table_conf.elem_key = kcondent->glue.key;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_CONDEXPRS_TABLE);
+}
+
+/* create handler for object conditionals table's list entry */
+static bool kparser_create_cond_tables_ent(const struct kparser_conf_table *arg,
+					   struct kparser_glue_condexpr_tables **proto_table,
+					   struct kparser_cmd_rsp_hdr *rsp)
+{
+	const struct kparser_glue_condexpr_table *kcondent;
+	void *realloced_mem;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	*proto_table = kparser_namespace_lookup(KPARSER_NS_CONDEXPRS_TABLES, &arg->key);
+	if (!(*proto_table)) {
+		rsp->op_ret_code = ENOENT;
+		snprintf(rsp->err_str_buf, sizeof(rsp->err_str_buf),
+			 "%s: Object key not found", __func__);
+		return false;
+	}
+
+	kcondent = kparser_namespace_lookup(KPARSER_NS_CONDEXPRS_TABLE, &arg->elem_key);
+	if (!kcondent) {
+		rsp->op_ret_code = ENOENT;
+		snprintf(rsp->err_str_buf, sizeof(rsp->err_str_buf),
+			 "%s: Object key:{%s:%u} not found",
+			 __func__, arg->elem_key.name, arg->elem_key.id);
+		return false;
+	}
+
+	(*proto_table)->table.num_ents++;
+	realloced_mem = krealloc((*proto_table)->table.entries, (*proto_table)->table.num_ents *
+				 sizeof(struct kparser_condexpr_table *), GFP_KERNEL | ___GFP_ZERO);
+	if (!realloced_mem) {
+		rsp->op_ret_code = ENOMEM;
+		snprintf(rsp->err_str_buf, sizeof(rsp->err_str_buf),
+			 "%s: krealloc() err, ents:%d, size:%lu",
+			 __func__, (*proto_table)->table.num_ents,
+			 sizeof(struct kparser_condexpr_table *));
+		return false;
+	}
+	rcu_assign_pointer((*proto_table)->table.entries, realloced_mem);
+
+	(*proto_table)->table.entries[(*proto_table)->table.num_ents - 1] = &kcondent->table;
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return true;
+}
+
+/* create handler for object conditionals table's list */
+int kparser_create_cond_tables(const struct kparser_conf_cmd *conf,
+			       size_t conf_len,
+			       struct kparser_cmd_rsp_hdr **rsp,
+			       size_t *rsp_len, const char *op)
+{
+	struct kparser_glue_condexpr_tables *proto_table = NULL;
+	const struct kparser_conf_table *arg;
+	struct kparser_hkey key;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	mutex_lock(&kparser_config_lock);
+
+	arg = &conf->table_conf;
+
+	/* create a table entry */
+	if (arg->add_entry) {
+		if (kparser_create_cond_tables_ent(arg, &proto_table, *rsp) == false)
+			goto done;
+		goto skip_table_create;
+	}
+
+	if (!kparser_cmd_create_pre_process(op, conf, &arg->key, &key,
+					    (void **)&proto_table, sizeof(*proto_table), *rsp,
+					    offsetof(struct kparser_glue_condexpr_tables, glue)))
+		goto done;
+
+	proto_table->glue.config.namespace_id = conf->namespace_id;
+	proto_table->glue.config.conf_keys_bv = conf->conf_keys_bv;
+	proto_table->glue.config.table_conf = *arg;
+	proto_table->glue.config.table_conf.key = key;
+	kref_init(&proto_table->glue.refcount);
+
+skip_table_create:
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = key;
+	(*rsp)->object.conf_keys_bv = conf->conf_keys_bv;
+	(*rsp)->object.table_conf = proto_table->glue.config.table_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	if ((*rsp)->op_ret_code != 0) {
+		if (proto_table && !arg->add_entry)
+			kparser_free(proto_table);
+	}
+
+	synchronize_rcu();
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_CONDEXPRS_TABLES);
+}
+
+/* read handler for object conditionals table's list */
+int kparser_read_cond_tables(const struct kparser_hkey *key,
+			     struct kparser_cmd_rsp_hdr **rsp,
+			     size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	const struct kparser_glue_condexpr_tables *proto_table;
+	const struct kparser_glue_condexpr_table *kcondent;
+	struct kparser_conf_cmd *objects = NULL;
+	void *realloced_mem;
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	proto_table = kparser_namespace_lookup(KPARSER_NS_CONDEXPRS_TABLES, key);
+	if (!proto_table) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found", __func__);
+		goto done;
+	}
+
+	(*rsp)->key = proto_table->glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = proto_table->glue.config.conf_keys_bv;
+	(*rsp)->object.table_conf = proto_table->glue.config.table_conf;
+
+	for (i = 0; i < proto_table->table.num_ents; i++) {
+		(*rsp)->objects_len++;
+		*rsp_len = *rsp_len + sizeof(struct kparser_conf_cmd);
+		realloced_mem = krealloc(*rsp, *rsp_len, GFP_KERNEL | ___GFP_ZERO);
+		if (!realloced_mem) {
+			pr_alert("%s:krealloc failed for rsp, len:%lu\n",
+				 __func__, *rsp_len);
+			*rsp_len = 0;
+			mutex_unlock(&kparser_config_lock);
+			return KPARSER_ATTR_UNSPEC;
+		}
+		*rsp = realloced_mem;
+		objects = (struct kparser_conf_cmd *)(*rsp)->objects;
+		objects[i].namespace_id = proto_table->glue.config.namespace_id;
+		objects[i].table_conf = proto_table->glue.config.table_conf;
+		if (!proto_table->table.entries)
+			continue;
+		kcondent = container_of(proto_table->table.entries[i],
+					struct kparser_glue_condexpr_table, table);
+		objects[i].table_conf.elem_key = kcondent->glue.key;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_CONDEXPRS_TABLES);
+}
+
+/* create handler for object counter */
+int kparser_create_counter(const struct kparser_conf_cmd *conf,
+			   size_t conf_len,
+			   struct kparser_cmd_rsp_hdr **rsp,
+			   size_t *rsp_len, const char *op)
+{
+	struct kparser_glue_counter *kcntr = NULL;
+	const struct kparser_conf_cntr *arg;
+	struct kparser_hkey key;
+	int rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	mutex_lock(&kparser_config_lock);
+
+	arg = &conf->cntr_conf;
+
+	if (!arg->conf.valid_entry) {
+		(*rsp)->op_ret_code = EINVAL;
+		snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+			 "%s: counter entry is not valid", __func__);
+		goto done;
+	}
+
+	if (cntrs_conf_idx >= KPARSER_CNTR_NUM_CNTRS) {
+		(*rsp)->op_ret_code = EINVAL;
+		snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+			 "%s: counter index %d can not be >= %d",
+			 __func__, cntrs_conf_idx, KPARSER_CNTR_NUM_CNTRS);
+		goto done;
+	}
+
+	if (kparser_conf_key_manager(conf->namespace_id, &arg->key, &key, *rsp, op) != 0) {
+		pr_alert("here:%s:%d\n", __func__, __LINE__);
+		goto done;
+	}
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	if (kparser_namespace_lookup(conf->namespace_id, &key)) {
+		(*rsp)->op_ret_code = EEXIST;
+		snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+			 "%s: Duplicate object key", __func__);
+		goto done;
+	}
+
+	kcntr = kzalloc(sizeof(*kcntr), GFP_KERNEL);
+	if (!kcntr) {
+		(*rsp)->op_ret_code = ENOMEM;
+		snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+			 "%s: kzalloc() failed", __func__);
+		goto done;
+	}
+
+	kcntr->glue.key = key;
+
+	rc = kparser_namespace_insert(conf->namespace_id,
+				      &kcntr->glue.ht_node_id, &kcntr->glue.ht_node_name);
+	if (rc) {
+		(*rsp)->op_ret_code = rc;
+		snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+			 "%s: kparser_namespace_insert() err", __func__);
+		goto done;
+	}
+
+	kcntr->glue.config.namespace_id = conf->namespace_id;
+	kcntr->glue.config.conf_keys_bv = conf->conf_keys_bv;
+	kcntr->glue.config.cntr_conf = *arg;
+	kcntr->glue.config.cntr_conf.key = key;
+	kref_init(&kcntr->glue.refcount);
+
+	kcntr->counter_cnf = arg->conf;
+	kcntr->counter_cnf.index = cntrs_conf_idx;
+
+	cntrs_conf.cntrs[cntrs_conf_idx] = kcntr->counter_cnf;
+
+	cntrs_conf_idx++;
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = key;
+	(*rsp)->object.conf_keys_bv = conf->conf_keys_bv;
+	(*rsp)->object.cntr_conf = kcntr->glue.config.cntr_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	if ((*rsp)->op_ret_code != 0)
+		kparser_free(kcntr);
+
+	synchronize_rcu();
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_COUNTER);
+}
+
+/* read handler for object counter */
+int kparser_read_counter(const struct kparser_hkey *key,
+			 struct kparser_cmd_rsp_hdr **rsp,
+			 size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	struct kparser_glue_counter *kcntr;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	kcntr = kparser_namespace_lookup(KPARSER_NS_COUNTER, key);
+	if (!kcntr) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found", __func__);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = kcntr->glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = kcntr->glue.config.conf_keys_bv;
+	(*rsp)->object.cntr_conf = kcntr->glue.config.cntr_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_COUNTER);
+}
+
+/* create handler for object counter table */
+int kparser_create_counter_table(const struct kparser_conf_cmd *conf,
+				 size_t conf_len,
+				 struct kparser_cmd_rsp_hdr **rsp,
+				 size_t *rsp_len, const char *op)
+{
+	struct kparser_glue_counter_table *table = NULL;
+	const struct kparser_conf_table *arg;
+	struct kparser_glue_counter *kcntr;
+	struct kparser_hkey key;
+	int rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	mutex_lock(&kparser_config_lock);
+
+	arg = &conf->table_conf;
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	/* create a table entry */
+	if (arg->add_entry) {
+		table = kparser_namespace_lookup(conf->namespace_id, &arg->key);
+		if (!table) {
+			(*rsp)->op_ret_code = ENOENT;
+			snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+				 "%s: table key not found", __func__);
+			goto done;
+		}
+		if (table->elems_cnt >= KPARSER_CNTR_NUM_CNTRS) {
+			(*rsp)->op_ret_code = EINVAL;
+			snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+				 "%s: table full:%u", __func__, table->elems_cnt);
+			goto done;
+		}
+		kcntr = kparser_namespace_lookup(KPARSER_NS_COUNTER,
+						 &arg->elem_key);
+		if (!kcntr) {
+			(*rsp)->op_ret_code = ENOENT;
+			snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+				 "%s: Object key not found", __func__);
+			goto done;
+		}
+		table->k_cntrs[table->elems_cnt++] = *kcntr;
+		goto skip_table_create;
+	}
+
+	if (kparser_conf_key_manager(conf->namespace_id, &arg->key, &key, *rsp, op) != 0) {
+		pr_alert("here:%s:%d\n", __func__, __LINE__);
+		goto done;
+	}
+
+	if (kparser_namespace_lookup(conf->namespace_id, &key)) {
+		(*rsp)->op_ret_code = EEXIST;
+		snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+			 "%s: Duplicate object key", __func__);
+		goto done;
+	}
+
+	/* create counter table */
+	table = kzalloc(sizeof(*table), GFP_KERNEL);
+	if (!table) {
+		(*rsp)->op_ret_code = ENOMEM;
+		snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+			 "%s: kzalloc() failed", __func__);
+		goto done;
+	}
+
+	table->glue.key = key;
+
+	rc = kparser_namespace_insert(conf->namespace_id,
+				      &table->glue.ht_node_id, &table->glue.ht_node_name);
+	if (rc) {
+		(*rsp)->op_ret_code = rc;
+		snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+			 "%s: kparser_namespace_insert() err", __func__);
+		goto done;
+	}
+
+	table->glue.config.namespace_id = conf->namespace_id;
+	table->glue.config.conf_keys_bv = conf->conf_keys_bv;
+	table->glue.config.table_conf = *arg;
+	table->glue.config.table_conf.key = key;
+	kref_init(&table->glue.refcount);
+
+skip_table_create:
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = key;
+	(*rsp)->object.conf_keys_bv = conf->conf_keys_bv;
+	(*rsp)->object.table_conf = table->glue.config.table_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	if ((*rsp)->op_ret_code != 0)
+		if (table && !arg->add_entry)
+			kparser_free(table);
+
+	synchronize_rcu();
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_COUNTER_TABLE);
+}
+
+/* read handler for object counter table */
+int kparser_read_counter_table(const struct kparser_hkey *key,
+			       struct kparser_cmd_rsp_hdr **rsp,
+			       size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	const struct kparser_glue_counter_table *table;
+	struct kparser_conf_cmd *objects = NULL;
+	void *realloced_mem;
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	table = kparser_namespace_lookup(KPARSER_NS_COUNTER_TABLE, key);
+	if (!table) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found", __func__);
+		goto done;
+	}
+
+	(*rsp)->key = table->glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = table->glue.config.conf_keys_bv;
+	(*rsp)->object.table_conf = table->glue.config.table_conf;
+
+	for (i = 0; i < KPARSER_CNTR_NUM_CNTRS; i++) {
+		(*rsp)->objects_len++;
+		*rsp_len = *rsp_len + sizeof(struct kparser_conf_cmd);
+		realloced_mem = krealloc(*rsp, *rsp_len, GFP_KERNEL | ___GFP_ZERO);
+		if (!realloced_mem) {
+			pr_alert("%s:krealloc failed for rsp, len:%lu\n", __func__, *rsp_len);
+			*rsp_len = 0;
+			mutex_unlock(&kparser_config_lock);
+			return KPARSER_ATTR_UNSPEC;
+		}
+		*rsp = realloced_mem;
+		objects = (struct kparser_conf_cmd *)(*rsp)->objects;
+		objects[i].namespace_id = table->k_cntrs[i].glue.config.namespace_id;
+		objects[i].cntr_conf = table->k_cntrs[i].glue.config.cntr_conf;
+		objects[i].cntr_conf.conf = cntrs_conf.cntrs[i];
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_COUNTER_TABLE);
+}
+
+/* create handler for object metadata */
+int kparser_create_metadata(const struct kparser_conf_cmd *conf,
+			    size_t conf_len,
+			    struct kparser_cmd_rsp_hdr **rsp,
+			    size_t *rsp_len, const char *op)
+{
+	struct kparser_glue_metadata_extract *kmde = NULL;
+	const struct kparser_conf_metadata *arg;
+	struct kparser_glue_counter *kcntr;
+	struct kparser_hkey key;
+	int rc, cntridx = 0;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	mutex_lock(&kparser_config_lock);
+
+	arg = &conf->md_conf;
+
+	if (kparser_conf_key_manager(conf->namespace_id, &arg->key, &key, *rsp, op) != 0) {
+		pr_alert("here:%s:%d\n", __func__, __LINE__);
+		goto done;
+	}
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	if (kparser_namespace_lookup(conf->namespace_id, &key)) {
+		(*rsp)->op_ret_code = EEXIST;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf), "%s: Duplicate object key", op);
+		goto done;
+	}
+
+	if (arg->type == KPARSER_METADATA_COUNTER) {
+		kcntr = kparser_namespace_lookup(KPARSER_NS_COUNTER, &arg->counterkey);
+		if (!kcntr) {
+			(*rsp)->op_ret_code = ENOENT;
+			snprintf((*rsp)->err_str_buf,
+				 sizeof((*rsp)->err_str_buf),
+				 "%s: Counter object key not found", op);
+			goto done;
+		}
+		cntridx = kcntr->counter_cnf.index + 1;
+	}
+
+	kmde = kzalloc(sizeof(*kmde), GFP_KERNEL);
+	if (!kmde) {
+		(*rsp)->op_ret_code = ENOMEM;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf), "%s: kzalloc() failed", op);
+		goto done;
+	}
+
+	kmde->glue.key = key;
+
+	rc = kparser_namespace_insert(conf->namespace_id,
+				      &kmde->glue.ht_node_id, &kmde->glue.ht_node_name);
+	if (rc) {
+		(*rsp)->op_ret_code = rc;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kparser_namespace_insert() err", op);
+		goto done;
+	}
+
+	kmde->glue.config.namespace_id = conf->namespace_id;
+	kmde->glue.config.conf_keys_bv = conf->conf_keys_bv;
+	kmde->glue.config.md_conf = *arg;
+	kmde->glue.config.md_conf.key = key;
+	kref_init(&kmde->glue.refcount);
+	INIT_LIST_HEAD(&kmde->glue.owner_list);
+	INIT_LIST_HEAD(&kmde->glue.owned_list);
+
+	if (!kparser_metadata_convert(arg, &kmde->mde, cntridx)) {
+		(*rsp)->op_ret_code = EINVAL;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kparser_metadata_convert() err", op);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = key;
+	(*rsp)->object.conf_keys_bv = conf->conf_keys_bv;
+	(*rsp)->object.md_conf = kmde->glue.config.md_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	if ((*rsp)->op_ret_code != 0)
+		kparser_free(kmde);
+
+	synchronize_rcu();
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_METADATA);
+}
+
+/* read handler for object metadata */
+int kparser_read_metadata(const struct kparser_hkey *key,
+			  struct kparser_cmd_rsp_hdr **rsp,
+			  size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	const struct kparser_glue_metadata_extract *kmde;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	kmde = kparser_namespace_lookup(KPARSER_NS_METADATA, key);
+	if (!kmde) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found", op);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = kmde->glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = kmde->glue.config.conf_keys_bv;
+	(*rsp)->object.md_conf = kmde->glue.config.md_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_METADATA);
+}
+
+/* delete handler for object metadata */
+int kparser_del_metadata(const struct kparser_hkey *key,
+			 struct kparser_cmd_rsp_hdr **rsp,
+			 size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	struct kparser_glue_metadata_extract *kmde;
+	int rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	kmde = kparser_namespace_lookup(KPARSER_NS_METADATA, key);
+	if (!kmde) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found", op);
+		goto done;
+	}
+
+	if (kref_read(&kmde->glue.refcount) != 0) {
+		(*rsp)->op_ret_code = EBUSY;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Metadata object is associated with a metalist, delete that metalist instead",
+			 op);
+		goto done;
+	}
+
+	rc = kparser_namespace_remove(KPARSER_NS_METADATA,
+				      &kmde->glue.ht_node_id, &kmde->glue.ht_node_name);
+	if (rc) {
+		(*rsp)->op_ret_code = rc;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf), "%s: namespace remove error", op);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = kmde->glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = kmde->glue.config.conf_keys_bv;
+	(*rsp)->object.md_conf = kmde->glue.config.md_conf;
+
+	kparser_free(kmde);
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_METADATA);
+}
+
+/* free handler for object metadata */
+void kparser_free_metadata(void *ptr, void *arg)
+{
+	/* TODO: */
+}
+
+/* create handler for object metadata list */
+int kparser_create_metalist(const struct kparser_conf_cmd *conf,
+			    size_t conf_len,
+			    struct kparser_cmd_rsp_hdr **rsp,
+			    size_t *rsp_len, const char *op)
+{
+	struct kparser_glue_metadata_extract *kmde = NULL;
+	struct kparser_glue_metadata_table *kmdl = NULL;
+	const struct kparser_conf_metadata_table *arg;
+	struct kparser_conf_cmd *objects = NULL;
+	struct kparser_hkey key;
+	void *realloced_mem;
+	int rc, i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	mutex_lock(&kparser_config_lock);
+
+	arg = &conf->mdl_conf;
+
+	if (kparser_conf_key_manager(conf->namespace_id, &arg->key, &key, *rsp, op) != 0) {
+		pr_alert("%s:%d\n", __func__, __LINE__);
+		goto done;
+	}
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	if (kparser_namespace_lookup(conf->namespace_id, &key)) {
+		(*rsp)->op_ret_code = EEXIST;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Duplicate object key", op);
+		goto done;
+	}
+
+	kmdl = kzalloc(sizeof(*kmdl), GFP_KERNEL);
+	if (!kmdl) {
+		(*rsp)->op_ret_code = ENOMEM;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kzalloc() failed", op);
+		goto done;
+	}
+
+	kmdl->glue.key = key;
+	kmdl->glue.config.namespace_id = conf->namespace_id;
+	kmdl->glue.config.conf_keys_bv = conf->conf_keys_bv;
+	kmdl->glue.config.mdl_conf = *arg;
+	kmdl->glue.config.mdl_conf.key = key;
+	kmdl->glue.config.mdl_conf.metadata_keys_count = 0;
+	kref_init(&kmdl->glue.refcount);
+	INIT_LIST_HEAD(&kmdl->glue.owner_list);
+	INIT_LIST_HEAD(&kmdl->glue.owned_list);
+
+	conf_len -= sizeof(*conf);
+
+	for (i = 0; i < arg->metadata_keys_count; i++) {
+		if (conf_len < sizeof(struct kparser_hkey)) {
+			(*rsp)->op_ret_code = EINVAL;
+			snprintf((*rsp)->err_str_buf,
+				 sizeof((*rsp)->err_str_buf),
+				 "%s: conf len/buffer incomplete", op);
+			goto done;
+		}
+
+		conf_len -= sizeof(struct kparser_hkey);
+
+		pr_debug("Key: {ID:%u Name:%s}\n",
+			 arg->metadata_keys[i].id, arg->metadata_keys[i].name);
+
+		kmde = kparser_namespace_lookup(KPARSER_NS_METADATA, &arg->metadata_keys[i]);
+		if (!kmde) {
+			(*rsp)->op_ret_code = ENOENT;
+			snprintf((*rsp)->err_str_buf,
+				 sizeof((*rsp)->err_str_buf),
+				 "%s: Object key {%s:%u} not found",
+				 op, arg->metadata_keys[i].name, arg->metadata_keys[i].id);
+			goto done;
+		}
+		kmdl->metadata_table.num_ents++;
+		realloced_mem = krealloc(kmdl->metadata_table.entries,
+					 kmdl->metadata_table.num_ents * sizeof(*kmde),
+					 GFP_KERNEL | ___GFP_ZERO);
+		if (!realloced_mem) {
+			(*rsp)->op_ret_code = ENOMEM;
+			snprintf((*rsp)->err_str_buf,
+				 sizeof((*rsp)->err_str_buf),
+				 "%s: krealloc() err, ents:%d, size:%lu",
+				 op, kmdl->metadata_table.num_ents, sizeof(*kmde));
+			goto done;
+		}
+		rcu_assign_pointer(kmdl->metadata_table.entries, realloced_mem);
+
+		kmdl->metadata_table.entries[i] = kmde->mde;
+		kref_get(&kmde->glue.refcount);
+
+		(*rsp)->objects_len++;
+		*rsp_len = *rsp_len + sizeof(struct kparser_conf_cmd);
+		realloced_mem = krealloc(*rsp, *rsp_len, GFP_KERNEL | ___GFP_ZERO);
+		if (!realloced_mem) {
+			pr_alert("%s:krealloc failed for rsp, len:%lu\n", __func__, *rsp_len);
+			*rsp_len = 0;
+			mutex_unlock(&kparser_config_lock);
+			if (kmdl) {
+				kparser_free(kmdl->metadata_table.entries);
+				kparser_free(kmdl);
+			}
+			return KPARSER_ATTR_UNSPEC;
+		}
+		*rsp = realloced_mem;
+
+		objects = (struct kparser_conf_cmd *)(*rsp)->objects;
+		objects[i].namespace_id = kmde->glue.config.namespace_id;
+		objects[i].conf_keys_bv = kmde->glue.config.conf_keys_bv;
+		objects[i].md_conf = kmde->glue.config.md_conf;
+
+		kmdl->md_configs_len++;
+		realloced_mem = krealloc(kmdl->md_configs,
+					 kmdl->md_configs_len *
+					 sizeof(struct kparser_conf_cmd),
+					 GFP_KERNEL | ___GFP_ZERO);
+		if (!realloced_mem) {
+			(*rsp)->op_ret_code = ENOMEM;
+			snprintf((*rsp)->err_str_buf,
+				 sizeof((*rsp)->err_str_buf),
+				 "%s: krealloc() err,ents:%lu, size:%lu",
+				 op,
+					kmdl->md_configs_len,
+					sizeof(struct kparser_conf_cmd));
+			goto done;
+		}
+		kmdl->md_configs = realloced_mem;
+		kmdl->md_configs[i].namespace_id = kmde->glue.config.namespace_id;
+		kmdl->md_configs[i].conf_keys_bv = kmde->glue.config.conf_keys_bv;
+		kmdl->md_configs[i].md_conf = kmde->glue.config.md_conf;
+	}
+
+	rc = kparser_namespace_insert(conf->namespace_id,
+				      &kmdl->glue.ht_node_id, &kmdl->glue.ht_node_name);
+	if (rc) {
+		(*rsp)->op_ret_code = rc;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kparser_namespace_insert() err", op);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = key;
+	(*rsp)->object.conf_keys_bv = conf->conf_keys_bv;
+	(*rsp)->object.mdl_conf = kmdl->glue.config.mdl_conf;
+	(*rsp)->object.mdl_conf.metadata_keys_count = 0;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	if ((*rsp)->op_ret_code != 0 && kmdl) {
+		kparser_free(kmdl->metadata_table.entries);
+		kparser_free(kmdl->md_configs);
+		kparser_free(kmdl);
+	}
+
+	synchronize_rcu();
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_METALIST);
+}
+
+/* read handler for object metadata list */
+int kparser_read_metalist(const struct kparser_hkey *key,
+			  struct kparser_cmd_rsp_hdr **rsp,
+			  size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	const struct kparser_glue_metadata_table *kmdl;
+	struct kparser_conf_cmd *objects = NULL;
+	void *realloced_mem;
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	kmdl = kparser_namespace_lookup(KPARSER_NS_METALIST, key);
+	if (!kmdl) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found", op);
+		goto done;
+	}
+
+	(*rsp)->key = kmdl->glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = kmdl->glue.config.conf_keys_bv;
+	(*rsp)->object.mdl_conf = kmdl->glue.config.mdl_conf;
+
+	for (i = 0; i < kmdl->md_configs_len; i++) {
+		(*rsp)->objects_len++;
+		*rsp_len = *rsp_len + sizeof(struct kparser_conf_cmd);
+		realloced_mem = krealloc(*rsp, *rsp_len, GFP_KERNEL | ___GFP_ZERO);
+		if (!realloced_mem) {
+			pr_alert("%s:krealloc failed for rsp, len:%lu\n",
+				 op, *rsp_len);
+			*rsp_len = 0;
+			mutex_unlock(&kparser_config_lock);
+			return KPARSER_ATTR_UNSPEC;
+		}
+		*rsp = realloced_mem;
+		objects = (struct kparser_conf_cmd *)(*rsp)->objects;
+		objects[i].namespace_id = kmdl->md_configs[i].namespace_id;
+		objects[i].conf_keys_bv = kmdl->md_configs[i].conf_keys_bv;
+		objects[i].md_conf = kmdl->md_configs[i].md_conf;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_METALIST);
+}
+
+/* delete handler for object metadata list */
+int kparser_del_metalist(const struct kparser_hkey *key,
+			 struct kparser_cmd_rsp_hdr **rsp,
+			 size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	struct kparser_obj_link_ctx *tmp_list_ref = NULL, *curr_ref = NULL;
+	struct kparser_obj_link_ctx *node_tmp_list_ref = NULL;
+	struct kparser_obj_link_ctx *node_curr_ref = NULL;
+	struct kparser_glue_glue_parse_node *kparsenode;
+	struct kparser_glue_metadata_extract *kmde;
+	struct kparser_glue_metadata_table *kmdl;
+	struct kparser_conf_cmd *objects = NULL;
+	void *realloced_mem;
+	int i, rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	kmdl = kparser_namespace_lookup(KPARSER_NS_METALIST, key);
+	if (!kmdl) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf), "%s: Object key not found", op);
+		goto done;
+	}
+
+	/* verify if there is any associated immutable parser */
+	list_for_each_entry_safe(curr_ref, tmp_list_ref,
+				 &kmdl->glue.owned_list, owned_obj.list_node) {
+		if (curr_ref->owner_obj.nsid != KPARSER_NS_NODE_PARSE)
+			continue;
+		if (kref_read(curr_ref->owner_obj.refcount) == 0)
+			continue;
+		kparsenode = (struct kparser_glue_glue_parse_node *)curr_ref->owner_obj.obj;
+		list_for_each_entry_safe(node_curr_ref, node_tmp_list_ref,
+					 &kparsenode->glue.glue.owned_list, owned_obj.list_node) {
+			if (node_curr_ref->owner_obj.nsid != KPARSER_NS_PARSER)
+				continue;
+			if (kref_read(node_curr_ref->owner_obj.refcount) != 0) {
+				(*rsp)->op_ret_code = EBUSY;
+				snprintf((*rsp)->err_str_buf,
+					 sizeof((*rsp)->err_str_buf),
+					 "%s:attached parser `%s` is immutable",
+					 op,
+						((struct kparser_glue_parser *)
+						 node_curr_ref->owner_obj.obj)->glue.key.name);
+				goto done;
+			}
+		}
+	}
+
+	if (kparser_link_detach(kmdl, &kmdl->glue.owner_list, &kmdl->glue.owned_list, *rsp) != 0)
+		goto done;
+
+	(*rsp)->key = kmdl->glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = kmdl->glue.config.conf_keys_bv;
+	(*rsp)->object.mdl_conf = kmdl->glue.config.mdl_conf;
+
+	for (i = 0; i < kmdl->md_configs_len; i++) {
+		(*rsp)->objects_len++;
+		*rsp_len = *rsp_len + sizeof(struct kparser_conf_cmd);
+		realloced_mem = krealloc(*rsp, *rsp_len, GFP_KERNEL | ___GFP_ZERO);
+		if (!realloced_mem) {
+			pr_alert("%s:krealloc failed for rsp, len:%lu\n",
+				 __func__, *rsp_len);
+			*rsp_len = 0;
+			mutex_unlock(&kparser_config_lock);
+			return KPARSER_ATTR_UNSPEC;
+		}
+		*rsp = realloced_mem;
+		objects = (struct kparser_conf_cmd *)(*rsp)->objects;
+		objects[i].namespace_id = kmdl->md_configs[i].namespace_id;
+		objects[i].conf_keys_bv = kmdl->md_configs[i].conf_keys_bv;
+		objects[i].md_conf = kmdl->md_configs[i].md_conf;
+
+		kmde = kparser_namespace_lookup(KPARSER_NS_METADATA, &objects[i].md_conf.key);
+		if (!kmde) {
+			(*rsp)->op_ret_code = ENOENT;
+			snprintf((*rsp)->err_str_buf,
+				 sizeof((*rsp)->err_str_buf),
+				 "%s: Object key not found", op);
+			goto done;
+		}
+
+		rc = kparser_namespace_remove(KPARSER_NS_METADATA,
+					      &kmde->glue.ht_node_id, &kmde->glue.ht_node_name);
+		if (rc) {
+			(*rsp)->op_ret_code = rc;
+			snprintf((*rsp)->err_str_buf,
+				 sizeof((*rsp)->err_str_buf),
+				 "%s: namespace remove error", op);
+			goto done;
+		}
+
+		kparser_free(kmde);
+	}
+
+	rc = kparser_namespace_remove(KPARSER_NS_METALIST,
+				      &kmdl->glue.ht_node_id, &kmdl->glue.ht_node_name);
+	if (rc) {
+		(*rsp)->op_ret_code = rc;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf), "%s: namespace remove error", op);
+		goto done;
+	}
+
+	kparser_free(kmdl->metadata_table.entries);
+
+	kmdl->metadata_table.num_ents = 0;
+
+	kparser_free(kmdl->md_configs);
+
+	kparser_free(kmdl);
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_METALIST);
+}
+
+/* free handler for object metadata list */
+void kparser_free_metalist(void *ptr, void *arg)
+{
+	/* TODO:  */
+}
+
+/* handler to convert and map netlink node context to kParser KMOD's node context */
+static inline bool kparser_conf_node_convert(const struct kparser_conf_node *conf,
+					     void *node, size_t node_len)
+{
+	struct kparser_glue_proto_flag_fields_table *kflag_fields_proto_table;
+	struct kparser_parse_flag_fields_node *flag_fields_parse_node;
+	struct kparser_glue_parse_tlv_node *kparsetlvwildcardnode;
+	struct kparser_glue_glue_parse_node *kparsewildcardnode;
+	struct kparser_glue_proto_tlvs_table *kprototlvstbl;
+	struct kparser_glue_condexpr_tables *kcond_tables;
+	struct kparser_parse_tlvs_node *tlvs_parse_node;
+	struct kparser_glue_flag_fields *kflag_fields;
+	struct kparser_glue_protocol_table *kprototbl;
+	struct kparser_parse_node *plain_parse_node;
+	struct kparser_glue_metadata_table *kmdl;
+
+	if (!conf || !node || node_len < sizeof(*plain_parse_node))
+		return false;
+
+	plain_parse_node = node;
+	plain_parse_node->node_type = conf->type;
+	plain_parse_node->unknown_ret = conf->plain_parse_node.unknown_ret;
+	plain_parse_node->proto_node.encap = conf->plain_parse_node.proto_node.encap;
+	plain_parse_node->proto_node.overlay = conf->plain_parse_node.proto_node.overlay;
+	plain_parse_node->proto_node.min_len = conf->plain_parse_node.proto_node.min_len;
+	plain_parse_node->proto_node.ops.len_parameterized =
+		conf->plain_parse_node.proto_node.ops.len_parameterized;
+	plain_parse_node->proto_node.ops.pflen = conf->plain_parse_node.proto_node.ops.pflen;
+	plain_parse_node->proto_node.ops.pfnext_proto =
+		conf->plain_parse_node.proto_node.ops.pfnext_proto;
+
+	kcond_tables =
+		kparser_namespace_lookup(KPARSER_NS_CONDEXPRS_TABLES,
+					 &conf->plain_parse_node.proto_node.ops.cond_exprs_table);
+	if (kcond_tables) {
+		plain_parse_node->proto_node.ops.cond_exprs = kcond_tables->table;
+		plain_parse_node->proto_node.ops.cond_exprs_parameterized = true;
+	}
+
+	strcpy(plain_parse_node->name, conf->key.name);
+
+	kprototbl = kparser_namespace_lookup(KPARSER_NS_PROTO_TABLE,
+					     &conf->plain_parse_node.proto_table_key);
+	if (kprototbl)
+		rcu_assign_pointer(plain_parse_node->proto_table, &kprototbl->proto_table);
+
+	kparsewildcardnode =
+		kparser_namespace_lookup(KPARSER_NS_NODE_PARSE,
+					 &conf->plain_parse_node.wildcard_parse_node_key);
+	if (kparsewildcardnode)
+		rcu_assign_pointer(plain_parse_node->wildcard_node,
+				   &kparsewildcardnode->parse_node);
+
+	kmdl = kparser_namespace_lookup(KPARSER_NS_METALIST,
+					&conf->plain_parse_node.metadata_table_key);
+	if (kmdl)
+		rcu_assign_pointer(plain_parse_node->metadata_table, &kmdl->metadata_table);
+
+	switch (conf->type) {
+	case KPARSER_NODE_TYPE_PLAIN:
+		break;
+
+	case KPARSER_NODE_TYPE_TLVS:
+		if (node_len < sizeof(*tlvs_parse_node))
+			return false;
+
+		tlvs_parse_node = node;
+
+		tlvs_parse_node->parse_node.tlvs_proto_node.ops =
+			conf->tlvs_parse_node.proto_node.ops;
+
+		tlvs_parse_node->parse_node.tlvs_proto_node.start_offset =
+			conf->tlvs_parse_node.proto_node.start_offset;
+		tlvs_parse_node->parse_node.tlvs_proto_node.pad1_val =
+			conf->tlvs_parse_node.proto_node.pad1_val;
+		tlvs_parse_node->parse_node.tlvs_proto_node.padn_val =
+			conf->tlvs_parse_node.proto_node.padn_val;
+		tlvs_parse_node->parse_node.tlvs_proto_node.eol_val =
+			conf->tlvs_parse_node.proto_node.eol_val;
+		tlvs_parse_node->parse_node.tlvs_proto_node.pad1_enable =
+			conf->tlvs_parse_node.proto_node.pad1_enable;
+		tlvs_parse_node->parse_node.tlvs_proto_node.padn_enable =
+			conf->tlvs_parse_node.proto_node.padn_enable;
+		tlvs_parse_node->parse_node.tlvs_proto_node.eol_enable =
+			conf->tlvs_parse_node.proto_node.eol_enable;
+		tlvs_parse_node->parse_node.tlvs_proto_node.fixed_start_offset =
+			conf->tlvs_parse_node.proto_node.fixed_start_offset;
+		tlvs_parse_node->parse_node.tlvs_proto_node.min_len =
+			conf->tlvs_parse_node.proto_node.min_len;
+
+		kprototlvstbl =
+			kparser_namespace_lookup(KPARSER_NS_TLV_PROTO_TABLE,
+						 &conf->tlvs_parse_node.tlv_proto_table_key);
+		if (kprototlvstbl)
+			rcu_assign_pointer(tlvs_parse_node->tlv_proto_table,
+					   &kprototlvstbl->tlvs_proto_table);
+
+		kparsetlvwildcardnode =
+			kparser_namespace_lookup(KPARSER_NS_TLV_NODE_PARSE,
+						 &conf->tlvs_parse_node.tlv_wildcard_node_key);
+		if (kparsetlvwildcardnode)
+			rcu_assign_pointer(tlvs_parse_node->tlv_wildcard_node,
+					   &kparsetlvwildcardnode->tlv_parse_node);
+
+		tlvs_parse_node->unknown_tlv_type_ret =
+			conf->tlvs_parse_node.unknown_tlv_type_ret;
+
+		tlvs_parse_node->config =
+			conf->tlvs_parse_node.config;
+		break;
+
+	case KPARSER_NODE_TYPE_FLAG_FIELDS:
+		if (node_len < sizeof(*flag_fields_parse_node))
+			return false;
+		flag_fields_parse_node = node;
+
+		flag_fields_parse_node->parse_node.flag_fields_proto_node.ops =
+			conf->flag_fields_parse_node.proto_node.ops;
+
+		kflag_fields =
+			kparser_namespace_lookup(KPARSER_NS_FLAG_FIELD_TABLE,
+						 &conf->flag_fields_parse_node.proto_node.
+						 flag_fields_table_hkey);
+		if (kflag_fields)
+			rcu_assign_pointer(flag_fields_parse_node->
+					   parse_node.flag_fields_proto_node.flag_fields,
+					   &kflag_fields->flag_fields);
+
+		kflag_fields_proto_table =
+			kparser_namespace_lookup(KPARSER_NS_FLAG_FIELD_PROTO_TABLE,
+						 &conf->flag_fields_parse_node.
+						 flag_fields_proto_table_key);
+		if (kflag_fields_proto_table)
+			rcu_assign_pointer(flag_fields_parse_node->flag_fields_proto_table,
+					   &kflag_fields_proto_table->flags_proto_table);
+		break;
+
+	default:
+		return false;
+	}
+	return true;
+}
+
+/* create handler for object parse node */
+int kparser_create_parse_node(const struct kparser_conf_cmd *conf,
+			      size_t conf_len,
+			      struct kparser_cmd_rsp_hdr **rsp,
+			      size_t *rsp_len, const char *op)
+{
+	struct kparser_glue_glue_parse_node *kparsenode = NULL;
+	struct kparser_glue_protocol_table *proto_table;
+	struct kparser_glue_metadata_table *mdl;
+	const struct kparser_conf_node *arg;
+	struct kparser_hkey key;
+	int rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	mutex_lock(&kparser_config_lock);
+
+	arg = &conf->node_conf;
+
+	if (kparser_conf_key_manager(conf->namespace_id, &arg->key, &key, *rsp, op) != 0) {
+		pr_alert("%s:%d\n", __func__, __LINE__);
+		goto done;
+	}
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	if (kparser_namespace_lookup(conf->namespace_id, &key)) {
+		(*rsp)->op_ret_code = EEXIST;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Duplicate object key",
+			 __func__);
+		goto done;
+	}
+
+	kparsenode = kzalloc(sizeof(*kparsenode), GFP_KERNEL);
+	if (!kparsenode) {
+		(*rsp)->op_ret_code = ENOMEM;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kzalloc() failed", __func__);
+		goto done;
+	}
+
+	kparsenode->glue.glue.key = key;
+	INIT_LIST_HEAD(&kparsenode->glue.glue.owner_list);
+	INIT_LIST_HEAD(&kparsenode->glue.glue.owned_list);
+
+	rc = kparser_namespace_insert(conf->namespace_id,
+				      &kparsenode->glue.glue.ht_node_id,
+				      &kparsenode->glue.glue.ht_node_name);
+	if (rc) {
+		(*rsp)->op_ret_code = rc;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kparser_namespace_insert() err",
+			 __func__);
+		goto done;
+	}
+
+	kparsenode->glue.glue.config.namespace_id = conf->namespace_id;
+	kparsenode->glue.glue.config.conf_keys_bv = conf->conf_keys_bv;
+	kparsenode->glue.glue.config.node_conf = *arg;
+	kparsenode->glue.glue.config.node_conf.key = key;
+	kref_init(&kparsenode->glue.glue.refcount);
+
+	if (!kparser_conf_node_convert(arg, &kparsenode->parse_node,
+				       sizeof(kparsenode->parse_node))) {
+		(*rsp)->op_ret_code = EINVAL;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kparser_conf_node_convert() err",
+			 __func__);
+		goto done;
+	}
+
+	if (kparsenode->parse_node.node.proto_table) {
+		proto_table = container_of(kparsenode->parse_node.node.proto_table,
+					   struct kparser_glue_protocol_table,
+					   proto_table);
+		if (kparser_link_attach(kparsenode,
+					KPARSER_NS_NODE_PARSE,
+					(const void **)&kparsenode->parse_node.node.proto_table,
+					&kparsenode->glue.glue.refcount,
+					&kparsenode->glue.glue.owner_list,
+					proto_table,
+					KPARSER_NS_PROTO_TABLE,
+					&proto_table->glue.refcount,
+					&proto_table->glue.owned_list,
+					*rsp, op) != 0)
+			goto done;
+	}
+
+	if (kparsenode->parse_node.node.metadata_table) {
+		mdl = container_of(kparsenode->parse_node.node.metadata_table,
+				   struct kparser_glue_metadata_table,
+				   metadata_table);
+		if (kparser_link_attach(kparsenode,
+					KPARSER_NS_NODE_PARSE,
+					(const void **)&kparsenode->parse_node.node.metadata_table,
+					&kparsenode->glue.glue.refcount,
+					&kparsenode->glue.glue.owner_list,
+					mdl,
+					KPARSER_NS_METALIST,
+					&mdl->glue.refcount,
+					&mdl->glue.owned_list,
+					*rsp, op) != 0)
+			goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = key;
+	(*rsp)->object.conf_keys_bv = conf->conf_keys_bv;
+	(*rsp)->object.node_conf = kparsenode->glue.glue.config.node_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	if ((*rsp)->op_ret_code != 0)
+		kparser_free(kparsenode);
+
+	synchronize_rcu();
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_NODE_PARSE);
+}
+
+/* read handler for object parse node */
+int kparser_read_parse_node(const struct kparser_hkey *key,
+			    struct kparser_cmd_rsp_hdr **rsp,
+			    size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	const struct kparser_glue_glue_parse_node *kparsenode;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	kparsenode = kparser_namespace_lookup(KPARSER_NS_NODE_PARSE, key);
+	if (!kparsenode) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf), "%s: Object key not found", op);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = kparsenode->glue.glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = kparsenode->glue.glue.config.conf_keys_bv;
+	(*rsp)->object.node_conf = kparsenode->glue.glue.config.node_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_NODE_PARSE);
+}
+
+/* delete handler for object parse node */
+int kparser_del_parse_node(const struct kparser_hkey *key,
+			   struct kparser_cmd_rsp_hdr **rsp,
+			   size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	struct kparser_obj_link_ctx *tmp_list_ref = NULL, *curr_ref = NULL;
+	struct kparser_glue_glue_parse_node *kparsenode;
+	int rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	kparsenode = kparser_namespace_lookup(KPARSER_NS_NODE_PARSE, key);
+	if (!kparsenode) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found", op);
+		goto done;
+	}
+
+	/* verify if there is any associated immutable parser */
+	list_for_each_entry_safe(curr_ref, tmp_list_ref,
+				 &kparsenode->glue.glue.owned_list,
+				 owned_obj.list_node) {
+		if (curr_ref->owner_obj.nsid != KPARSER_NS_PARSER)
+			continue;
+		if (kref_read(curr_ref->owner_obj.refcount) != 0) {
+			(*rsp)->op_ret_code = EBUSY;
+			snprintf((*rsp)->err_str_buf,
+				 sizeof((*rsp)->err_str_buf),
+				 "%s:attached parser `%s` is immutable",
+				 op, ((struct kparser_glue_parser *)
+					curr_ref->owner_obj.obj)->glue.key.name);
+			goto done;
+		}
+	}
+
+	if (kparser_link_detach(kparsenode, &kparsenode->glue.glue.owner_list,
+				&kparsenode->glue.glue.owned_list, *rsp) != 0)
+		goto done;
+
+	rc = kparser_namespace_remove(KPARSER_NS_NODE_PARSE,
+				      &kparsenode->glue.glue.ht_node_id,
+				      &kparsenode->glue.glue.ht_node_name);
+	if (rc) {
+		(*rsp)->op_ret_code = rc;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: namespace remove error", op);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = kparsenode->glue.glue.config.conf_keys_bv;
+	(*rsp)->object.node_conf = kparsenode->glue.glue.config.node_conf;
+
+	kparser_free(kparsenode);
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_NODE_PARSE);
+}
+
+/* free handler for object parse node */
+void kparser_free_node(void *ptr, void *arg)
+{
+	/* TODO: */
+}
+
+/* create handler for object protocol table entry */
+static bool kparser_create_proto_table_ent(const struct kparser_conf_table *arg,
+					   struct kparser_glue_protocol_table **proto_table,
+					   struct kparser_cmd_rsp_hdr *rsp, const char *op)
+{
+	struct kparser_glue_glue_parse_node *kparsenode;
+	void *realloced_mem;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	*proto_table = kparser_namespace_lookup(KPARSER_NS_PROTO_TABLE, &arg->key);
+	if (!(*proto_table)) {
+		rsp->op_ret_code = ENOENT;
+		snprintf(rsp->err_str_buf,
+			 sizeof(rsp->err_str_buf),
+			 "%s: Object key not found", op);
+		return false;
+	}
+
+	kparsenode = kparser_namespace_lookup(KPARSER_NS_NODE_PARSE, &arg->elem_key);
+	if (!kparsenode) {
+		rsp->op_ret_code = ENOENT;
+		snprintf(rsp->err_str_buf,
+			 sizeof(rsp->err_str_buf),
+			 "%s: parse node key:{%s:%u} not found",
+			 op, arg->elem_key.name, arg->elem_key.id);
+		return false;
+	}
+
+	(*proto_table)->proto_table.num_ents++;
+	realloced_mem = krealloc((*proto_table)->proto_table.entries,
+				 (*proto_table)->proto_table.num_ents *
+				 sizeof(struct kparser_proto_table_entry),
+				 GFP_KERNEL | ___GFP_ZERO);
+	if (!realloced_mem) {
+		rsp->op_ret_code = ENOMEM;
+		snprintf(rsp->err_str_buf,
+			 sizeof(rsp->err_str_buf),
+			 "%s: krealloc() err, ents:%d, size:%lu",
+			 op,
+				(*proto_table)->proto_table.num_ents,
+				sizeof(struct kparser_proto_table_entry));
+		return false;
+	}
+	rcu_assign_pointer((*proto_table)->proto_table.entries, realloced_mem);
+
+	if (kparser_link_attach(*proto_table,
+				KPARSER_NS_PROTO_TABLE,
+				NULL, /* due to realloc, can't cache pointer here */
+				&(*proto_table)->glue.refcount,
+				&(*proto_table)->glue.owner_list,
+				kparsenode,
+				KPARSER_NS_NODE_PARSE,
+				&kparsenode->glue.glue.refcount,
+				&kparsenode->glue.glue.owned_list,
+				rsp, op) != 0)
+		return false;
+
+	(*proto_table)->proto_table.entries[(*proto_table)->proto_table.num_ents - 1].value =
+			arg->optional_value1;
+	(*proto_table)->proto_table.entries[(*proto_table)->proto_table.num_ents - 1].encap =
+			arg->optional_value2;
+	(*proto_table)->proto_table.entries[(*proto_table)->proto_table.num_ents - 1].node =
+			&kparsenode->parse_node.node;
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return true;
+}
+
+/* create handler for object protocol table */
+int kparser_create_proto_table(const struct kparser_conf_cmd *conf,
+			       size_t conf_len,
+			       struct kparser_cmd_rsp_hdr **rsp,
+			       size_t *rsp_len, const char *op)
+{
+	struct kparser_glue_protocol_table *proto_table = NULL;
+	const struct kparser_conf_table *arg;
+	struct kparser_hkey key;
+	int rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	mutex_lock(&kparser_config_lock);
+
+	arg = &conf->table_conf;
+
+	/* create a table entry */
+	if (arg->add_entry) {
+		if (kparser_create_proto_table_ent(arg, &proto_table, *rsp, op) == false)
+			goto done;
+		goto skip_table_create;
+	}
+
+	if (kparser_conf_key_manager(conf->namespace_id, &arg->key, &key, *rsp, op) != 0) {
+		pr_alert("%s:%d\n", __func__, __LINE__);
+		goto done;
+	}
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	if (kparser_namespace_lookup(conf->namespace_id, &key)) {
+		(*rsp)->op_ret_code = EEXIST;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Duplicate object key", op);
+		goto done;
+	}
+
+	/* create protocol table */
+	proto_table = kzalloc(sizeof(*proto_table), GFP_KERNEL);
+	if (!proto_table) {
+		(*rsp)->op_ret_code = ENOMEM;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf), "%s: kzalloc() failed", op);
+		goto done;
+	}
+
+	proto_table->glue.key = key;
+
+	rc = kparser_namespace_insert(conf->namespace_id,
+				      &proto_table->glue.ht_node_id,
+				      &proto_table->glue.ht_node_name);
+	if (rc) {
+		(*rsp)->op_ret_code = rc;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kparser_namespace_insert() err", op);
+		goto done;
+	}
+
+	proto_table->glue.config.namespace_id = conf->namespace_id;
+	proto_table->glue.config.conf_keys_bv = conf->conf_keys_bv;
+	proto_table->glue.config.table_conf = *arg;
+	proto_table->glue.config.table_conf.key = key;
+	kref_init(&proto_table->glue.refcount);
+	INIT_LIST_HEAD(&proto_table->glue.owner_list);
+	INIT_LIST_HEAD(&proto_table->glue.owned_list);
+
+skip_table_create:
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->object.conf_keys_bv = conf->conf_keys_bv;
+	(*rsp)->object.table_conf = *arg;
+
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	if ((*rsp)->op_ret_code != 0)
+		if (proto_table && !arg->add_entry)
+			kparser_free(proto_table);
+
+	synchronize_rcu();
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_PROTO_TABLE);
+}
+
+/* read handler for object protocol table */
+int kparser_read_proto_table(const struct kparser_hkey *key,
+			     struct kparser_cmd_rsp_hdr **rsp,
+			     size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	const struct kparser_glue_protocol_table *proto_table;
+	const struct kparser_glue_glue_parse_node *parse_node;
+	struct kparser_conf_cmd *objects = NULL;
+	void *realloced_mem;
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	proto_table = kparser_namespace_lookup(KPARSER_NS_PROTO_TABLE, key);
+	if (!proto_table) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found", op);
+		goto done;
+	}
+
+	(*rsp)->key = proto_table->glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = proto_table->glue.config.conf_keys_bv;
+	(*rsp)->object.table_conf = proto_table->glue.config.table_conf;
+
+	for (i = 0; i < proto_table->proto_table.num_ents; i++) {
+		(*rsp)->objects_len++;
+		*rsp_len = *rsp_len + sizeof(struct kparser_conf_cmd);
+		realloced_mem = krealloc(*rsp, *rsp_len, GFP_KERNEL | ___GFP_ZERO);
+		if (!realloced_mem) {
+			pr_alert("%s:krealloc failed for rsp, len:%lu\n", __func__, *rsp_len);
+			*rsp_len = 0;
+			mutex_unlock(&kparser_config_lock);
+			return KPARSER_ATTR_UNSPEC;
+		}
+		*rsp = realloced_mem;
+		objects = (struct kparser_conf_cmd *)(*rsp)->objects;
+		objects[i].namespace_id = proto_table->glue.config.namespace_id;
+		objects[i].table_conf = proto_table->glue.config.table_conf;
+		objects[i].table_conf.optional_value1 = proto_table->proto_table.entries[i].value;
+		if (!proto_table->proto_table.entries[i].node)
+			continue;
+		parse_node = container_of(proto_table->proto_table.entries[i].node,
+					  struct kparser_glue_glue_parse_node,
+					  parse_node.node);
+		objects[i].table_conf.elem_key = parse_node->glue.glue.key;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_PROTO_TABLE);
+}
+
+/* delete handler for object protocol table */
+int kparser_del_proto_table(const struct kparser_hkey *key,
+			    struct kparser_cmd_rsp_hdr **rsp,
+			    size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	struct kparser_obj_link_ctx *tmp_list_ref = NULL, *curr_ref = NULL;
+	struct kparser_obj_link_ctx *node_tmp_list_ref = NULL;
+	struct kparser_obj_link_ctx *node_curr_ref = NULL;
+	struct kparser_glue_protocol_table *proto_table;
+	struct kparser_glue_glue_parse_node *kparsenode;
+	struct kparser_glue_glue_parse_node *parse_node;
+	struct kparser_conf_cmd *objects = NULL;
+	void *realloced_mem;
+	int i, rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	proto_table = kparser_namespace_lookup(KPARSER_NS_PROTO_TABLE, key);
+	if (!proto_table) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found", op);
+		goto done;
+	}
+
+	/* verify if there is any associated immutable parser */
+	list_for_each_entry_safe(curr_ref, tmp_list_ref,
+				 &proto_table->glue.owned_list, owned_obj.list_node) {
+		if (curr_ref->owner_obj.nsid != KPARSER_NS_NODE_PARSE)
+			continue;
+		if (kref_read(curr_ref->owner_obj.refcount) == 0)
+			continue;
+		kparsenode = (struct kparser_glue_glue_parse_node *)
+			curr_ref->owner_obj.obj;
+		list_for_each_entry_safe(node_curr_ref, node_tmp_list_ref,
+					 &kparsenode->glue.glue.owned_list, owned_obj.list_node) {
+			if (node_curr_ref->owner_obj.nsid != KPARSER_NS_PARSER)
+				continue;
+			if (kref_read(node_curr_ref->owner_obj.refcount) != 0) {
+				(*rsp)->op_ret_code = EBUSY;
+				snprintf((*rsp)->err_str_buf,
+					 sizeof((*rsp)->err_str_buf),
+					 "%s:attached parser `%s` is immutable",
+					 op,
+						((struct kparser_glue_parser *)
+						 node_curr_ref->owner_obj.obj)->glue.key.name);
+				goto done;
+			}
+		}
+	}
+
+	(*rsp)->key = proto_table->glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = proto_table->glue.config.conf_keys_bv;
+	(*rsp)->object.table_conf = proto_table->glue.config.table_conf;
+
+	for (i = 0; i < proto_table->proto_table.num_ents; i++) {
+		(*rsp)->objects_len++;
+		*rsp_len = *rsp_len + sizeof(struct kparser_conf_cmd);
+		realloced_mem = krealloc(*rsp, *rsp_len, GFP_KERNEL | ___GFP_ZERO);
+		if (!realloced_mem) {
+			pr_alert("%s:krealloc failed for rsp, len:%lu\n",
+				 __func__, *rsp_len);
+			*rsp_len = 0;
+			mutex_unlock(&kparser_config_lock);
+			return KPARSER_ATTR_UNSPEC;
+		}
+		*rsp = realloced_mem;
+		objects = (struct kparser_conf_cmd *)(*rsp)->objects;
+		objects[i].namespace_id = proto_table->glue.config.namespace_id;
+		objects[i].table_conf = proto_table->glue.config.table_conf;
+		objects[i].table_conf.optional_value1 = proto_table->proto_table.entries[i].value;
+		if (!proto_table->proto_table.entries[i].node)
+			continue;
+		parse_node = container_of(proto_table->proto_table.entries[i].node,
+					  struct kparser_glue_glue_parse_node,
+					  parse_node.node);
+		objects[i].table_conf.elem_key = parse_node->glue.glue.key;
+	}
+
+	if (kparser_link_detach(proto_table, &proto_table->glue.owner_list,
+				&proto_table->glue.owned_list, *rsp) != 0)
+		goto done;
+
+	rc = kparser_namespace_remove(KPARSER_NS_PROTO_TABLE,
+				      &proto_table->glue.ht_node_id,
+				      &proto_table->glue.ht_node_name);
+	if (rc) {
+		(*rsp)->op_ret_code = rc;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: namespace remove error", op);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	kparser_free(proto_table->proto_table.entries);
+	kparser_free(proto_table);
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_PROTO_TABLE);
+}
+
+/* free handler for object protocol table */
+void kparser_free_proto_tbl(void *ptr, void *arg)
+{
+	/* TODO: */
+}
+
+/* handler to convert and map from netlink tlv node to kParser KMOD's tlv node */
+static inline bool kparser_conf_tlv_node_convert(const struct kparser_conf_node_parse_tlv *conf,
+						 struct kparser_parse_tlv_node *node)
+{
+	struct kparser_glue_parse_tlv_node *kparsewildcardnode;
+	struct kparser_glue_condexpr_tables *kcond_tables;
+	struct kparser_glue_proto_tlvs_table *kprototbl;
+	struct kparser_glue_metadata_table *kmdl;
+
+	if (!conf || !node)
+		return false;
+
+	node->proto_tlv_node.min_len = conf->node_proto.min_len;
+	node->proto_tlv_node.max_len = conf->node_proto.max_len;
+	node->proto_tlv_node.is_padding = conf->node_proto.is_padding;
+
+	node->proto_tlv_node.ops.pfoverlay_type = conf->node_proto.ops.pfoverlay_type;
+	if (node->proto_tlv_node.ops.pfoverlay_type.src_off ||
+	    node->proto_tlv_node.ops.pfoverlay_type.size ||
+	    node->proto_tlv_node.ops.pfoverlay_type.right_shift)
+		node->proto_tlv_node.ops.overlay_type_parameterized = true;
+
+	kcond_tables = kparser_namespace_lookup(KPARSER_NS_CONDEXPRS_TABLES,
+						&conf->node_proto.ops.cond_exprs_table);
+	if (kcond_tables) {
+		node->proto_tlv_node.ops.cond_exprs = kcond_tables->table;
+		node->proto_tlv_node.ops.cond_exprs_parameterized = true;
+	}
+
+	kprototbl = kparser_namespace_lookup(KPARSER_NS_TLV_PROTO_TABLE,
+					     &conf->overlay_proto_tlvs_table_key);
+	if (kprototbl)
+		rcu_assign_pointer(node->overlay_table, &kprototbl->tlvs_proto_table);
+
+	kparsewildcardnode = kparser_namespace_lookup(KPARSER_NS_TLV_NODE_PARSE,
+						      &conf->overlay_wildcard_parse_node_key);
+	if (kparsewildcardnode)
+		rcu_assign_pointer(node->overlay_wildcard_node,
+				   &kparsewildcardnode->tlv_parse_node);
+
+	node->unknown_overlay_ret = conf->unknown_ret;
+	strcpy(node->name, conf->key.name);
+
+	kmdl = kparser_namespace_lookup(KPARSER_NS_METALIST,
+					&conf->metadata_table_key);
+	if (kmdl)
+		rcu_assign_pointer(node->metadata_table, &kmdl->metadata_table);
+
+	return true;
+}
+
+/* create handler for object tlv node */
+int kparser_create_parse_tlv_node(const struct kparser_conf_cmd *conf,
+				  size_t conf_len,
+				  struct kparser_cmd_rsp_hdr **rsp,
+				  size_t *rsp_len, const char *op)
+{
+	struct kparser_glue_parse_tlv_node *node = NULL;
+	const struct kparser_conf_node_parse_tlv *arg;
+	struct kparser_hkey key;
+	int rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	mutex_lock(&kparser_config_lock);
+
+	arg = &conf->tlv_node_conf;
+
+	if (kparser_conf_key_manager(conf->namespace_id, &arg->key, &key, *rsp, op) != 0) {
+		pr_alert("%s:%d\n", __func__, __LINE__);
+		goto done;
+	}
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	if (kparser_namespace_lookup(conf->namespace_id, &key)) {
+		(*rsp)->op_ret_code = EEXIST;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Duplicate object key", __func__);
+		goto done;
+	}
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node) {
+		(*rsp)->op_ret_code = ENOMEM;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kzalloc() failed", __func__);
+		goto done;
+	}
+
+	node->glue.glue.key = key;
+
+	rc = kparser_namespace_insert(conf->namespace_id,
+				      &node->glue.glue.ht_node_id,
+				      &node->glue.glue.ht_node_name);
+	if (rc) {
+		(*rsp)->op_ret_code = rc;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kparser_namespace_insert() err",
+			 __func__);
+		goto done;
+	}
+
+	node->glue.glue.config.namespace_id = conf->namespace_id;
+	node->glue.glue.config.conf_keys_bv = conf->conf_keys_bv;
+	node->glue.glue.config.tlv_node_conf = *arg;
+	node->glue.glue.config.tlv_node_conf.key = key;
+	kref_init(&node->glue.glue.refcount);
+
+	if (!kparser_conf_tlv_node_convert(arg, &node->tlv_parse_node)) {
+		(*rsp)->op_ret_code = EINVAL;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kparser_conf_tlv_node_convert() err",
+			 __func__);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = key;
+	(*rsp)->object.conf_keys_bv = conf->conf_keys_bv;
+	(*rsp)->object.tlv_node_conf = node->glue.glue.config.tlv_node_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	if ((*rsp)->op_ret_code != 0)
+		kparser_free(node);
+
+	synchronize_rcu();
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_TLV_NODE_PARSE);
+}
+
+/* read handler for object tlv node */
+int kparser_read_parse_tlv_node(const struct kparser_hkey *key,
+				struct kparser_cmd_rsp_hdr **rsp,
+				size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	const struct kparser_glue_parse_tlv_node *node;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	node = kparser_namespace_lookup(KPARSER_NS_TLV_NODE_PARSE, key);
+	if (!node) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found",
+			 __func__);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = node->glue.glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = node->glue.glue.config.conf_keys_bv;
+	(*rsp)->object.tlv_node_conf = node->glue.glue.config.tlv_node_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_TLV_NODE_PARSE);
+}
+
+/* create handler for object tlv proto table's entry */
+static bool kparser_create_tlv_proto_table_ent(const struct kparser_conf_table *arg,
+					       struct kparser_glue_proto_tlvs_table **proto_table,
+					       struct kparser_cmd_rsp_hdr *rsp)
+{
+	const struct kparser_glue_parse_tlv_node *kparsenode;
+	void *realloced_mem;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	*proto_table = kparser_namespace_lookup(KPARSER_NS_TLV_PROTO_TABLE, &arg->key);
+	if (!(*proto_table)) {
+		rsp->op_ret_code = ENOENT;
+		snprintf(rsp->err_str_buf,
+			 sizeof(rsp->err_str_buf),
+			 "%s: Object key not found",
+			 __func__);
+		return false;
+	}
+
+	kparsenode = kparser_namespace_lookup(KPARSER_NS_TLV_NODE_PARSE, &arg->elem_key);
+	if (!kparsenode) {
+		rsp->op_ret_code = ENOENT;
+		snprintf(rsp->err_str_buf,
+			 sizeof(rsp->err_str_buf),
+			 "%s: Object key:{%s:%u} not found",
+			 __func__, arg->elem_key.name, arg->elem_key.id);
+		return false;
+	}
+
+	(*proto_table)->tlvs_proto_table.num_ents++;
+	realloced_mem = krealloc((*proto_table)->tlvs_proto_table.entries,
+				 (*proto_table)->tlvs_proto_table.num_ents *
+				 sizeof(struct kparser_proto_tlvs_table_entry),
+				 GFP_KERNEL | ___GFP_ZERO);
+	if (!realloced_mem) {
+		rsp->op_ret_code = ENOMEM;
+		snprintf(rsp->err_str_buf,
+			 sizeof(rsp->err_str_buf),
+			 "%s: krealloc() err, ents:%d, size:%lu",
+			 __func__,
+				(*proto_table)->tlvs_proto_table.num_ents,
+				sizeof(struct kparser_proto_tlvs_table_entry));
+		return false;
+	}
+	rcu_assign_pointer((*proto_table)->tlvs_proto_table.entries, realloced_mem);
+
+	(*proto_table)->tlvs_proto_table.entries[(*proto_table)->tlvs_proto_table.num_ents -
+		1].type = arg->optional_value1;
+	(*proto_table)->tlvs_proto_table.entries[(*proto_table)->tlvs_proto_table.num_ents -
+		1].node = &kparsenode->tlv_parse_node;
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return true;
+}
+
+/* create handler for object tlv proto table */
+int kparser_create_tlv_proto_table(const struct kparser_conf_cmd *conf,
+				   size_t conf_len,
+				   struct kparser_cmd_rsp_hdr **rsp,
+				   size_t *rsp_len, const char *op)
+{
+	struct kparser_glue_proto_tlvs_table *proto_table = NULL;
+	const struct kparser_conf_table *arg;
+	struct kparser_hkey key;
+	int rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	mutex_lock(&kparser_config_lock);
+
+	arg = &conf->table_conf;
+
+	/* create a table entry */
+	if (arg->add_entry) {
+		if (kparser_create_tlv_proto_table_ent(arg, &proto_table, *rsp) == false)
+			goto done;
+		goto skip_table_create;
+	}
+
+	if (kparser_conf_key_manager(conf->namespace_id, &arg->key, &key, *rsp, op) != 0) {
+		pr_alert("%s:%d\n", __func__, __LINE__);
+		goto done;
+	}
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	if (kparser_namespace_lookup(conf->namespace_id, &key)) {
+		(*rsp)->op_ret_code = EEXIST;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Duplicate object key",
+			 __func__);
+		goto done;
+	}
+
+	/* create protocol table */
+	proto_table = kzalloc(sizeof(*proto_table), GFP_KERNEL);
+	if (!proto_table) {
+		(*rsp)->op_ret_code = ENOMEM;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kzalloc() failed", __func__);
+		goto done;
+	}
+
+	proto_table->glue.key = key;
+
+	rc = kparser_namespace_insert(conf->namespace_id,
+				      &proto_table->glue.ht_node_id,
+				      &proto_table->glue.ht_node_name);
+	if (rc) {
+		(*rsp)->op_ret_code = rc;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kparser_namespace_insert() err",
+			 __func__);
+		goto done;
+	}
+
+	proto_table->glue.config.namespace_id = conf->namespace_id;
+	proto_table->glue.config.conf_keys_bv = conf->conf_keys_bv;
+	proto_table->glue.config.table_conf = *arg;
+	proto_table->glue.config.table_conf.key = key;
+	kref_init(&proto_table->glue.refcount);
+
+skip_table_create:
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = key;
+	(*rsp)->object.conf_keys_bv = conf->conf_keys_bv;
+	(*rsp)->object.table_conf = proto_table->glue.config.table_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	if ((*rsp)->op_ret_code != 0)
+		if (proto_table && !arg->add_entry)
+			kparser_free(proto_table);
+
+	synchronize_rcu();
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_TLV_PROTO_TABLE);
+}
+
+/* read handler for object tlv proto table */
+int kparser_read_tlv_proto_table(const struct kparser_hkey *key,
+				 struct kparser_cmd_rsp_hdr **rsp,
+				 size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	const struct kparser_glue_proto_tlvs_table *proto_table;
+	const struct kparser_glue_parse_tlv_node *parse_node;
+	struct kparser_conf_cmd *objects = NULL;
+	void *realloced_mem;
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	proto_table = kparser_namespace_lookup(KPARSER_NS_TLV_PROTO_TABLE, key);
+	if (!proto_table) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found",
+			 __func__);
+		goto done;
+	}
+
+	(*rsp)->key = proto_table->glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = proto_table->glue.config.conf_keys_bv;
+	(*rsp)->object.table_conf = proto_table->glue.config.table_conf;
+
+	for (i = 0; i < proto_table->tlvs_proto_table.num_ents; i++) {
+		(*rsp)->objects_len++;
+		*rsp_len = *rsp_len + sizeof(struct kparser_conf_cmd);
+		realloced_mem = krealloc(*rsp, *rsp_len, GFP_KERNEL | ___GFP_ZERO);
+		if (!realloced_mem) {
+			pr_alert("%s:krealloc failed for rsp, len:%lu\n", __func__, *rsp_len);
+			*rsp_len = 0;
+			mutex_unlock(&kparser_config_lock);
+			return KPARSER_ATTR_UNSPEC;
+		}
+		*rsp = realloced_mem;
+		objects = (struct kparser_conf_cmd *)(*rsp)->objects;
+		objects[i].namespace_id = proto_table->glue.config.namespace_id;
+		objects[i].table_conf = proto_table->glue.config.table_conf;
+		objects[i].table_conf.optional_value1 =
+			proto_table->tlvs_proto_table.entries[i].type;
+		if (!proto_table->tlvs_proto_table.entries[i].node)
+			continue;
+		parse_node = container_of(proto_table->tlvs_proto_table.entries[i].node,
+					  struct kparser_glue_parse_tlv_node, tlv_parse_node);
+		objects[i].table_conf.elem_key = parse_node->glue.glue.key;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_TLV_PROTO_TABLE);
+}
+
+/* create handler for object flag field */
+int kparser_create_flag_field(const struct kparser_conf_cmd *conf,
+			      size_t conf_len,
+			      struct kparser_cmd_rsp_hdr **rsp,
+			      size_t *rsp_len, const char *op)
+{
+	struct kparser_glue_flag_field *kobj = NULL;
+	const struct kparser_conf_flag_field *arg;
+	struct kparser_hkey key;
+	int rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	mutex_lock(&kparser_config_lock);
+
+	arg = &conf->flag_field_conf;
+
+	if (kparser_conf_key_manager(conf->namespace_id, &arg->key, &key, *rsp, op) != 0) {
+		pr_alert("%s:%d\n", __func__, __LINE__);
+		goto done;
+	}
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	if (kparser_namespace_lookup(conf->namespace_id, &key)) {
+		(*rsp)->op_ret_code = EEXIST;
+		snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+			 "%s: Duplicate object key", op);
+		goto done;
+	}
+
+	kobj = kzalloc(sizeof(*kobj), GFP_KERNEL);
+	if (!kobj) {
+		(*rsp)->op_ret_code = ENOMEM;
+		snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+			 "%s: kzalloc() failed", op);
+		goto done;
+	}
+
+	kobj->glue.key = key;
+
+	rc = kparser_namespace_insert(conf->namespace_id,
+				      &kobj->glue.ht_node_id, &kobj->glue.ht_node_name);
+	if (rc) {
+		(*rsp)->op_ret_code = rc;
+		snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf),
+			 "%s: kparser_namespace_insert() err", op);
+		goto done;
+	}
+
+	kobj->glue.config.namespace_id = conf->namespace_id;
+	kobj->glue.config.conf_keys_bv = conf->conf_keys_bv;
+	kobj->glue.config.flag_field_conf = *arg;
+	kobj->glue.config.flag_field_conf.key = key;
+	kref_init(&kobj->glue.refcount);
+
+	kobj->flag_field = arg->conf;
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = key;
+	(*rsp)->object.conf_keys_bv = conf->conf_keys_bv;
+	(*rsp)->object.flag_field_conf = kobj->glue.config.flag_field_conf;
+
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	if ((*rsp)->op_ret_code != 0)
+		kparser_free(kobj);
+
+	synchronize_rcu();
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_FLAG_FIELD);
+}
+
+/* read handler for object flag field */
+int kparser_read_flag_field(const struct kparser_hkey *key,
+			    struct kparser_cmd_rsp_hdr **rsp,
+			    size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	struct kparser_glue_flag_field *kobj;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	kobj = kparser_namespace_lookup(KPARSER_NS_FLAG_FIELD, key);
+	if (!kobj) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found", op);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = kobj->glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = kobj->glue.config.conf_keys_bv;
+	(*rsp)->object.flag_field_conf = kobj->glue.config.flag_field_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_FLAG_FIELD);
+}
+
+/* compare call back to sort flag fields using their flag values in qsort API */
+static int compare(const void *lhs, const void *rhs)
+{
+	const struct kparser_flag_field *lhs_flag = lhs;
+	const struct kparser_flag_field *rhs_flag = rhs;
+
+	pr_debug("lflag:%x rflag:%x\n", lhs_flag->flag, rhs_flag->flag);
+
+	if (lhs_flag->flag < rhs_flag->flag)
+		return -1;
+	if (lhs_flag->flag > rhs_flag->flag)
+		return 1;
+
+	return 0;
+}
+
+/* create handler for object flag field table entry */
+static bool kparser_create_flag_field_table_ent(const struct kparser_conf_table *arg,
+						struct kparser_glue_flag_fields **proto_table,
+						struct kparser_cmd_rsp_hdr *rsp)
+{
+	const struct kparser_glue_flag_field *kflagent;
+	void *realloced_mem;
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	*proto_table = kparser_namespace_lookup(KPARSER_NS_FLAG_FIELD_TABLE, &arg->key);
+	if (!(*proto_table)) {
+		rsp->op_ret_code = ENOENT;
+		snprintf(rsp->err_str_buf, sizeof(rsp->err_str_buf),
+			 "%s: Object key not found", __func__);
+		return false;
+	}
+
+	kflagent = kparser_namespace_lookup(KPARSER_NS_FLAG_FIELD, &arg->elem_key);
+	if (!kflagent) {
+		rsp->op_ret_code = ENOENT;
+		snprintf(rsp->err_str_buf, sizeof(rsp->err_str_buf),
+			 "%s: Object key:{%s:%u} not found",
+			 __func__, arg->elem_key.name, arg->elem_key.id);
+		return false;
+	}
+
+	(*proto_table)->flag_fields.num_idx++;
+
+	realloced_mem = krealloc((*proto_table)->flag_fields.fields,
+				 (*proto_table)->flag_fields.num_idx *
+				 sizeof(struct kparser_flag_field),
+				 GFP_KERNEL | ___GFP_ZERO);
+	if (!realloced_mem) {
+		rsp->op_ret_code = ENOMEM;
+		snprintf(rsp->err_str_buf,
+			 sizeof(rsp->err_str_buf),
+			 "%s: krealloc() err, ents:%lu, size:%lu",
+			 __func__,
+			 (*proto_table)->flag_fields.num_idx,
+			 sizeof(struct kparser_flag_field));
+		return false;
+	}
+	rcu_assign_pointer((*proto_table)->flag_fields.fields, realloced_mem);
+
+	(*proto_table)->flag_fields.fields[(*proto_table)->flag_fields.num_idx - 1] =
+		kflagent->flag_field;
+
+	sort((*proto_table)->flag_fields.fields,
+	     (*proto_table)->flag_fields.num_idx,
+	     sizeof(struct kparser_flag_field), &compare, NULL);
+
+	for (i = 0; i < (*proto_table)->flag_fields.num_idx; i++)
+		pr_debug("List[%d]:%x\n",
+			 i, (*proto_table)->flag_fields.fields[i].flag);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return true;
+}
+
+/* create handler for object flag field */
+int kparser_create_flag_field_table(const struct kparser_conf_cmd *conf,
+				    size_t conf_len,
+				    struct kparser_cmd_rsp_hdr **rsp,
+				    size_t *rsp_len, const char *op)
+{
+	struct kparser_glue_flag_fields *proto_table = NULL;
+	const struct kparser_conf_table *arg;
+	struct kparser_hkey key;
+	int rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	mutex_lock(&kparser_config_lock);
+
+	arg = &conf->table_conf;
+
+	if (arg->add_entry) {
+		if (kparser_create_flag_field_table_ent(arg, &proto_table, *rsp) == false)
+			goto done;
+		goto skip_table_create;
+	}
+
+	if (kparser_conf_key_manager(conf->namespace_id, &arg->key, &key, *rsp, op) != 0) {
+		pr_alert("%s:%d\n", __func__, __LINE__);
+		goto done;
+	}
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	if (kparser_namespace_lookup(conf->namespace_id, &key)) {
+		(*rsp)->op_ret_code = EEXIST;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Duplicate object key",
+			 __func__);
+		goto done;
+	}
+
+	proto_table = kzalloc(sizeof(*proto_table), GFP_KERNEL);
+	if (!proto_table) {
+		(*rsp)->op_ret_code = ENOMEM;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kzalloc() failed", __func__);
+		goto done;
+	}
+
+	proto_table->glue.key = key;
+
+	rc = kparser_namespace_insert(conf->namespace_id,
+				      &proto_table->glue.ht_node_id,
+				      &proto_table->glue.ht_node_name);
+	if (rc) {
+		(*rsp)->op_ret_code = rc;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kparser_namespace_insert() err",
+			 __func__);
+		goto done;
+	}
+
+	proto_table->glue.config.namespace_id = conf->namespace_id;
+	proto_table->glue.config.conf_keys_bv = conf->conf_keys_bv;
+	proto_table->glue.config.table_conf = *arg;
+	proto_table->glue.config.table_conf.key = key;
+	kref_init(&proto_table->glue.refcount);
+
+skip_table_create:
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = key;
+	(*rsp)->object.conf_keys_bv = conf->conf_keys_bv;
+	(*rsp)->object.table_conf =
+		proto_table->glue.config.table_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	if ((*rsp)->op_ret_code != 0)
+		if (proto_table && !arg->add_entry)
+			kparser_free(proto_table);
+
+	synchronize_rcu();
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_FLAG_FIELD_TABLE);
+}
+
+/* read handler for object flag field */
+int kparser_read_flag_field_table(const struct kparser_hkey *key,
+				  struct kparser_cmd_rsp_hdr **rsp,
+				  size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	const struct kparser_glue_flag_fields *proto_table;
+	const struct kparser_glue_flag_field *kflagent;
+	struct kparser_conf_cmd *objects = NULL;
+	void *realloced_mem;
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	proto_table = kparser_namespace_lookup(KPARSER_NS_FLAG_FIELD_TABLE, key);
+	if (!proto_table) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found",
+			 __func__);
+		goto done;
+	}
+
+	(*rsp)->key = proto_table->glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = proto_table->glue.config.conf_keys_bv;
+	(*rsp)->object.table_conf = proto_table->glue.config.table_conf;
+
+	for (i = 0; i < proto_table->flag_fields.num_idx; i++) {
+		(*rsp)->objects_len++;
+		*rsp_len = *rsp_len + sizeof(struct kparser_conf_cmd);
+		realloced_mem = krealloc(*rsp, *rsp_len, GFP_KERNEL | ___GFP_ZERO);
+		if (!realloced_mem) {
+			pr_alert("%s:krealloc failed for rsp, len:%lu\n", __func__, *rsp_len);
+			*rsp_len = 0;
+			mutex_unlock(&kparser_config_lock);
+			return KPARSER_ATTR_UNSPEC;
+		}
+		*rsp = realloced_mem;
+
+		objects = (struct kparser_conf_cmd *)(*rsp)->objects;
+		objects[i].namespace_id = proto_table->glue.config.namespace_id;
+		objects[i].table_conf = proto_table->glue.config.table_conf;
+		objects[i].table_conf.optional_value1 = i;
+		if (!proto_table->flag_fields.fields)
+			continue;
+		kflagent = container_of(&proto_table->flag_fields.fields[i],
+					struct kparser_glue_flag_field, flag_field);
+		objects[i].table_conf.elem_key = kflagent->glue.key;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_FLAG_FIELD_TABLE);
+}
+
+/* handler to convert and map netlink's flag node to kParser KMOD's flag node */
+static inline bool
+kparser_create_parse_flag_field_node_convert(const struct kparser_conf_node_parse_flag_field *conf,
+					     struct kparser_parse_flag_field_node *node)
+{
+	struct kparser_glue_condexpr_tables *kcond_tables;
+	struct kparser_glue_metadata_table *kmdl;
+
+	if (!conf || !node)
+		return false;
+
+	strcpy(node->name, conf->key.name);
+
+	kcond_tables = kparser_namespace_lookup(KPARSER_NS_CONDEXPRS_TABLES,
+						&conf->ops.cond_exprs_table_key);
+	if (kcond_tables)
+		node->ops.cond_exprs = kcond_tables->table;
+
+	kmdl = kparser_namespace_lookup(KPARSER_NS_METALIST, &conf->metadata_table_key);
+	if (kmdl)
+		rcu_assign_pointer(node->metadata_table, &kmdl->metadata_table);
+
+	return true;
+}
+
+/* create handler for object flag field node */
+int kparser_create_parse_flag_field_node(const struct kparser_conf_cmd *conf,
+					 size_t conf_len,
+					 struct kparser_cmd_rsp_hdr **rsp,
+					 size_t *rsp_len, const char *op)
+{
+	const struct kparser_conf_node_parse_flag_field *arg;
+	struct kparser_glue_flag_field_node *node = NULL;
+	struct kparser_hkey key;
+	int rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	mutex_lock(&kparser_config_lock);
+
+	arg = &conf->flag_field_node_conf;
+
+	if (kparser_conf_key_manager(conf->namespace_id, &arg->key, &key, *rsp, op) != 0) {
+		pr_alert("%s:%d\n", __func__, __LINE__);
+		goto done;
+	}
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	if (kparser_namespace_lookup(conf->namespace_id, &key)) {
+		(*rsp)->op_ret_code = EEXIST;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Duplicate object key",
+			 __func__);
+		goto done;
+	}
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node) {
+		(*rsp)->op_ret_code = ENOMEM;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kzalloc() failed", __func__);
+		goto done;
+	}
+
+	node->glue.glue.key = key;
+
+	rc = kparser_namespace_insert(conf->namespace_id,
+				      &node->glue.glue.ht_node_id, &node->glue.glue.ht_node_name);
+	if (rc) {
+		(*rsp)->op_ret_code = rc;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kparser_namespace_insert() err",
+			 __func__);
+		goto done;
+	}
+
+	node->glue.glue.config.namespace_id = conf->namespace_id;
+	node->glue.glue.config.conf_keys_bv = conf->conf_keys_bv;
+	node->glue.glue.config.flag_field_node_conf = *arg;
+	node->glue.glue.config.flag_field_node_conf.key = key;
+	kref_init(&node->glue.glue.refcount);
+
+	if (!kparser_create_parse_flag_field_node_convert(arg, &node->node_flag_field)) {
+		(*rsp)->op_ret_code = EINVAL;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kparser_conf_tlv_node_convert() err",
+			 __func__);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = key;
+	(*rsp)->object.conf_keys_bv = conf->conf_keys_bv;
+	(*rsp)->object.flag_field_node_conf = node->glue.glue.config.flag_field_node_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	if ((*rsp)->op_ret_code != 0)
+		kparser_free(node);
+
+	synchronize_rcu();
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_FLAG_FIELD_NODE_PARSE);
+}
+
+/* read handler for object flag field node */
+int kparser_read_parse_flag_field_node(const struct kparser_hkey *key,
+				       struct kparser_cmd_rsp_hdr **rsp,
+				       size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	const struct kparser_glue_flag_field_node *node;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	node = kparser_namespace_lookup(KPARSER_NS_FLAG_FIELD_NODE_PARSE, key);
+	if (!node) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found",
+			 __func__);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = node->glue.glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = node->glue.glue.config.conf_keys_bv;
+	(*rsp)->object.flag_field_node_conf = node->glue.glue.config.flag_field_node_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_FLAG_FIELD_NODE_PARSE);
+}
+
+/* create handler for object flag field proto table's entry */
+static bool
+kparser_create_flag_field_proto_table_ent(const struct kparser_conf_table *arg,
+					  struct kparser_glue_proto_flag_fields_table **proto_table,
+					  struct kparser_cmd_rsp_hdr *rsp)
+{
+	const struct kparser_glue_flag_field_node *kparsenode;
+	void *realloced_mem;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	*proto_table = kparser_namespace_lookup(KPARSER_NS_FLAG_FIELD_PROTO_TABLE, &arg->key);
+	if (!(*proto_table)) {
+		rsp->op_ret_code = ENOENT;
+		snprintf(rsp->err_str_buf,
+			 sizeof(rsp->err_str_buf),
+			 "%s: Object key not found",
+			 __func__);
+		return false;
+	}
+
+	kparsenode = kparser_namespace_lookup(KPARSER_NS_FLAG_FIELD_NODE_PARSE, &arg->elem_key);
+	if (!kparsenode) {
+		rsp->op_ret_code = ENOENT;
+		snprintf(rsp->err_str_buf,
+			 sizeof(rsp->err_str_buf),
+			 "%s: Object key:{%s:%u} not found",
+			 __func__,
+				arg->elem_key.name,
+				arg->elem_key.id);
+		return false;
+	}
+
+	(*proto_table)->flags_proto_table.num_ents++;
+	realloced_mem = krealloc((*proto_table)->flags_proto_table.entries,
+				 (*proto_table)->flags_proto_table.num_ents *
+				 sizeof(struct kparser_proto_flag_fields_table_entry),
+				 GFP_KERNEL | ___GFP_ZERO);
+	if (!realloced_mem) {
+		rsp->op_ret_code = ENOMEM;
+		snprintf(rsp->err_str_buf,
+			 sizeof(rsp->err_str_buf),
+			 "%s: krealloc() err, ents:%d, size:%lu",
+			 __func__,
+				(*proto_table)->flags_proto_table.num_ents,
+				sizeof(struct kparser_proto_flag_fields_table_entry));
+		return false;
+	}
+	rcu_assign_pointer((*proto_table)->flags_proto_table.entries, realloced_mem);
+
+	(*proto_table)->flags_proto_table.entries[(*proto_table)->flags_proto_table.num_ents -
+		1].flag = arg->optional_value1;
+	(*proto_table)->flags_proto_table.entries[(*proto_table)->flags_proto_table.num_ents -
+		1].node = &kparsenode->node_flag_field;
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return true;
+}
+
+/* create handler for object flag field proto table */
+int kparser_create_flag_field_proto_table(const struct kparser_conf_cmd *conf,
+					  size_t conf_len,
+					  struct kparser_cmd_rsp_hdr **rsp,
+					  size_t *rsp_len, const char *op)
+{
+	struct kparser_glue_proto_flag_fields_table *proto_table = NULL;
+	const struct kparser_conf_table *arg;
+	struct kparser_hkey key;
+	int rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	mutex_lock(&kparser_config_lock);
+
+	arg = &conf->table_conf;
+
+	/* create a table entry */
+	if (arg->add_entry) {
+		if (kparser_create_flag_field_proto_table_ent(arg, &proto_table, *rsp) == false)
+			goto done;
+		goto skip_table_create;
+	}
+
+	if (kparser_conf_key_manager(conf->namespace_id, &arg->key, &key, *rsp, op) != 0) {
+		pr_alert(":%s:%d\n", __func__, __LINE__);
+		goto done;
+	}
+
+	pr_debug("Key: {ID:%u Name:%s}\n", arg->key.id, arg->key.name);
+
+	if (kparser_namespace_lookup(conf->namespace_id, &key)) {
+		(*rsp)->op_ret_code = EEXIST;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Duplicate object key",
+			 __func__);
+		goto done;
+	}
+
+	/* create protocol table */
+	proto_table = kzalloc(sizeof(*proto_table), GFP_KERNEL);
+	if (!proto_table) {
+		(*rsp)->op_ret_code = ENOMEM;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kzalloc() failed", __func__);
+		goto done;
+	}
+
+	proto_table->glue.key = key;
+
+	rc = kparser_namespace_insert(conf->namespace_id,
+				      &proto_table->glue.ht_node_id,
+				      &proto_table->glue.ht_node_name);
+	if (rc) {
+		(*rsp)->op_ret_code = rc;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kparser_namespace_insert() err",
+			 __func__);
+		goto done;
+	}
+
+	proto_table->glue.config.namespace_id = conf->namespace_id;
+	proto_table->glue.config.conf_keys_bv = conf->conf_keys_bv;
+	proto_table->glue.config.table_conf = *arg;
+	proto_table->glue.config.table_conf.key = key;
+	kref_init(&proto_table->glue.refcount);
+
+skip_table_create:
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = key;
+	(*rsp)->object.conf_keys_bv = conf->conf_keys_bv;
+	(*rsp)->object.table_conf = proto_table->glue.config.table_conf;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	if ((*rsp)->op_ret_code != 0)
+		if (proto_table && !arg->add_entry)
+			kparser_free(proto_table);
+
+	synchronize_rcu();
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_FLAG_FIELD_PROTO_TABLE);
+}
+
+/* read handler for object flag field proto table */
+int kparser_read_flag_field_proto_table(const struct kparser_hkey *key,
+					struct kparser_cmd_rsp_hdr **rsp,
+					size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	const struct kparser_glue_proto_flag_fields_table *proto_table;
+	const struct kparser_glue_flag_field_node *parse_node;
+	struct kparser_conf_cmd *objects = NULL;
+	void *realloced_mem;
+	int i;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	proto_table = kparser_namespace_lookup(KPARSER_NS_FLAG_FIELD_PROTO_TABLE, key);
+	if (!proto_table) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found",
+			 __func__);
+		goto done;
+	}
+
+	(*rsp)->key = proto_table->glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = proto_table->glue.config.conf_keys_bv;
+	(*rsp)->object.table_conf = proto_table->glue.config.table_conf;
+
+	for (i = 0; i < proto_table->flags_proto_table.num_ents; i++) {
+		(*rsp)->objects_len++;
+		*rsp_len = *rsp_len + sizeof(struct kparser_conf_cmd);
+		realloced_mem = krealloc(*rsp, *rsp_len, GFP_KERNEL | ___GFP_ZERO);
+		if (!realloced_mem) {
+			pr_alert("%s:krealloc failed for rsp, len:%lu\n",
+				 __func__, *rsp_len);
+			*rsp_len = 0;
+			mutex_unlock(&kparser_config_lock);
+			return KPARSER_ATTR_UNSPEC;
+		}
+		*rsp = realloced_mem;
+
+		objects = (struct kparser_conf_cmd *)(*rsp)->objects;
+		objects[i].namespace_id = proto_table->glue.config.namespace_id;
+		objects[i].table_conf = proto_table->glue.config.table_conf;
+		if (!proto_table->flags_proto_table.entries[i].node)
+			continue;
+		objects[i].table_conf.optional_value1 =
+			proto_table->flags_proto_table.entries[i].flag;
+		parse_node = container_of(proto_table->flags_proto_table.entries[i].node,
+					  struct kparser_glue_flag_field_node,
+					  node_flag_field);
+		objects[i].table_conf.elem_key = parse_node->glue.glue.key;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_FLAG_FIELD_PROTO_TABLE);
+}
+
+/* conevrt and map from netlink's parser to kParser KMOD's parser */
+static inline bool kparser_parser_convert(const struct kparser_conf_parser *conf,
+					  struct kparser_parser *parser)
+{
+	struct kparser_glue_glue_parse_node *node;
+
+	strcpy(parser->name, conf->key.name);
+
+	node = kparser_namespace_lookup(KPARSER_NS_NODE_PARSE, &conf->root_node_key);
+	if (node)
+		rcu_assign_pointer(parser->root_node, &node->parse_node.node);
+	else
+		return false;
+
+	node = kparser_namespace_lookup(KPARSER_NS_NODE_PARSE, &conf->ok_node_key);
+	if (node)
+		rcu_assign_pointer(parser->okay_node, &node->parse_node.node);
+
+	node = kparser_namespace_lookup(KPARSER_NS_NODE_PARSE, &conf->fail_node_key);
+	if (node)
+		rcu_assign_pointer(parser->fail_node, &node->parse_node.node);
+
+	node = kparser_namespace_lookup(KPARSER_NS_NODE_PARSE, &conf->atencap_node_key);
+	if (node)
+		rcu_assign_pointer(parser->atencap_node, &node->parse_node.node);
+
+	parser->cntrs_conf = cntrs_conf;
+
+	parser->config = conf->config;
+	return true;
+}
+
+/* create handler for object parser */
+int kparser_create_parser(const struct kparser_conf_cmd *conf,
+			  size_t conf_len,
+			  struct kparser_cmd_rsp_hdr **rsp,
+			  size_t *rsp_len, const char *op)
+{
+	struct kparser_glue_glue_parse_node *parse_node;
+	struct kparser_glue_parser *kparser = NULL;
+	struct kparser_counters *cntrs = NULL;
+	const struct kparser_conf_parser *arg;
+	struct kparser_parser parser = {};
+	struct kparser_hkey key;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	mutex_lock(&kparser_config_lock);
+
+	arg = &conf->parser_conf;
+
+	cntrs = kzalloc(sizeof(*cntrs), GFP_KERNEL);
+	if (!cntrs) {
+		(*rsp)->op_ret_code = ENOMEM;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: kzalloc() failed, size:%lu",
+			 op, sizeof(*cntrs));
+		goto done;
+	}
+	rcu_assign_pointer(parser.cntrs, cntrs);
+	parser.cntrs_len = sizeof(*cntrs);
+	parser.kparser_start_signature = KPARSERSTARTSIGNATURE;
+	parser.kparser_end_signature = KPARSERENDSIGNATURE;
+	if (!kparser_parser_convert(arg, &parser)) {
+		(*rsp)->op_ret_code = EINVAL;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: parser arg convert error", op);
+		goto done;
+	}
+
+	if (!kparser_cmd_create_pre_process(op, conf, &arg->key, &key,
+					    (void **)&kparser, sizeof(*kparser), *rsp,
+					    offsetof(struct kparser_glue_parser, glue)))
+		goto done;
+
+	kparser->parser = parser;
+
+	INIT_LIST_HEAD(&kparser->glue.owner_list);
+	INIT_LIST_HEAD(&kparser->glue.owned_list);
+
+	if (kparser->parser.root_node) {
+		parse_node = container_of(kparser->parser.root_node,
+					  struct kparser_glue_glue_parse_node,
+					  parse_node.node);
+		if (kparser_link_attach(kparser,
+					KPARSER_NS_PARSER,
+					(const void **)&kparser->parser.root_node,
+					&kparser->glue.refcount,
+					&kparser->glue.owner_list,
+					parse_node,
+					KPARSER_NS_NODE_PARSE,
+					&parse_node->glue.glue.refcount,
+					&parse_node->glue.glue.owned_list,
+					*rsp, op) != 0)
+			goto done;
+	}
+
+	if (kparser->parser.okay_node) {
+		parse_node = container_of(kparser->parser.okay_node,
+					  struct kparser_glue_glue_parse_node,
+					  parse_node.node);
+		if (kparser_link_attach(kparser,
+					KPARSER_NS_PARSER,
+					(const void **)&kparser->parser.okay_node,
+					&kparser->glue.refcount,
+					&kparser->glue.owner_list,
+					parse_node,
+					KPARSER_NS_NODE_PARSE,
+					&parse_node->glue.glue.refcount,
+					&parse_node->glue.glue.owned_list,
+					*rsp, op) != 0)
+			goto done;
+	}
+
+	if (kparser->parser.fail_node) {
+		parse_node = container_of(kparser->parser.fail_node,
+					  struct kparser_glue_glue_parse_node,
+					  parse_node.node);
+		if (kparser_link_attach(kparser,
+					KPARSER_NS_PARSER,
+					(const void **)&kparser->parser.fail_node,
+					&kparser->glue.refcount,
+					&kparser->glue.owner_list,
+					parse_node,
+					KPARSER_NS_NODE_PARSE,
+					&parse_node->glue.glue.refcount,
+					&parse_node->glue.glue.owned_list,
+					*rsp, op) != 0)
+			goto done;
+	}
+
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	if ((*rsp)->op_ret_code != 0) {
+		kparser_free(kparser);
+		kparser_free(cntrs);
+	}
+
+	synchronize_rcu();
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_PARSER);
+}
+
+static bool kparser_dump_protocol_table(const struct kparser_proto_table *obj,
+					struct kparser_cmd_rsp_hdr **rsp, size_t *rsp_len);
+
+/* dump metadata list to netlink msg rsp */
+static bool kparser_dump_metadata_table(const struct kparser_metadata_table *obj,
+					struct kparser_cmd_rsp_hdr **rsp, size_t *rsp_len)
+{
+	const struct kparser_glue_metadata_table *glue_obj;
+	struct kparser_cmd_rsp_hdr *new_rsp = NULL;
+	size_t new_rsp_len = 0;
+	void *realloced_mem;
+	void *ptr;
+	int rc;
+
+	if (!obj)
+		return true;
+
+	rc = alloc_first_rsp(&new_rsp, &new_rsp_len, KPARSER_NS_METALIST);
+	if (rc) {
+		pr_debug("%s:alloc_first_rsp() failed, rc:%d\n",
+			 __func__, rc);
+		return false;
+	}
+
+	glue_obj = container_of(obj, struct kparser_glue_metadata_table, metadata_table);
+
+	/* NOTE: TODO: kparser_config_lock should not be released and reacquired here. Fix later. */
+	mutex_unlock(&kparser_config_lock);
+	rc = kparser_read_metalist(&glue_obj->glue.key,
+				   &new_rsp, &new_rsp_len, false, "read");
+	mutex_lock(&kparser_config_lock);
+
+	if (rc != KPARSER_ATTR_RSP(KPARSER_NS_METALIST))
+		goto error;
+
+	realloced_mem = krealloc(*rsp, *rsp_len + new_rsp_len, GFP_KERNEL | ___GFP_ZERO);
+	if (!realloced_mem)
+		goto error;
+	*rsp = realloced_mem;
+
+	ptr = (*rsp);
+	ptr += (*rsp_len);
+	(*rsp_len) = (*rsp_len) + new_rsp_len;
+	memcpy(ptr, new_rsp, new_rsp_len);
+	kparser_free(new_rsp);
+	new_rsp = NULL;
+
+	return true;
+error:
+	kparser_free(new_rsp);
+
+	return false;
+}
+
+/* dump parse node to netlink msg rsp */
+static bool kparser_dump_parse_node(const struct kparser_parse_node *obj,
+				    struct kparser_cmd_rsp_hdr **rsp, size_t *rsp_len)
+{
+	const struct kparser_glue_glue_parse_node *glue_obj;
+	struct kparser_cmd_rsp_hdr *new_rsp = NULL;
+	size_t new_rsp_len = 0;
+	void *realloced_mem;
+	void *ptr;
+	int rc;
+
+	if (!obj)
+		return true;
+
+	rc = alloc_first_rsp(&new_rsp, &new_rsp_len, KPARSER_NS_NODE_PARSE);
+	if (rc) {
+		pr_debug("%s:alloc_first_rsp() failed, rc:%d\n",
+			 __func__, rc);
+		return false;
+	}
+
+	glue_obj = container_of(obj, struct kparser_glue_glue_parse_node, parse_node.node);
+
+	/* NOTE: TODO: kparser_config_lock should not be released and reacquired here. Fix later. */
+	mutex_unlock(&kparser_config_lock);
+	rc = kparser_read_parse_node(&glue_obj->glue.glue.key,
+				     &new_rsp, &new_rsp_len, false, "read");
+	mutex_lock(&kparser_config_lock);
+
+	if (rc != KPARSER_ATTR_RSP(KPARSER_NS_NODE_PARSE))
+		goto error;
+
+	realloced_mem = krealloc(*rsp, *rsp_len + new_rsp_len, GFP_KERNEL | ___GFP_ZERO);
+	if (!realloced_mem)
+		goto error;
+	*rsp = realloced_mem;
+
+	ptr = (*rsp);
+	ptr += (*rsp_len);
+	(*rsp_len) = (*rsp_len) + new_rsp_len;
+	memcpy(ptr, new_rsp, new_rsp_len);
+	kparser_free(new_rsp);
+	new_rsp = NULL;
+
+	if (!kparser_dump_protocol_table(obj->proto_table, rsp, rsp_len))
+		goto error;
+
+	if (!kparser_dump_metadata_table(obj->metadata_table, rsp, rsp_len))
+		goto error;
+
+	return true;
+error:
+	kparser_free(new_rsp);
+
+	return false;
+}
+
+/* dump protocol table to netlink msg rsp */
+static bool kparser_dump_protocol_table(const struct kparser_proto_table *obj,
+					struct kparser_cmd_rsp_hdr **rsp, size_t *rsp_len)
+{
+	const struct kparser_glue_protocol_table *glue_obj;
+	struct kparser_cmd_rsp_hdr *new_rsp = NULL;
+	size_t new_rsp_len = 0;
+	void *realloced_mem;
+	void *ptr;
+	int rc, i;
+
+	if (!obj)
+		return true;
+
+	rc = alloc_first_rsp(&new_rsp, &new_rsp_len, KPARSER_NS_PROTO_TABLE);
+	if (rc) {
+		pr_debug("%s:alloc_first_rsp() failed, rc:%d\n", __func__, rc);
+		return false;
+	}
+
+	glue_obj = container_of(obj, struct kparser_glue_protocol_table,
+				proto_table);
+
+	/* NOTE: TODO: kparser_config_lock should not be released and reacquired here. Fix later. */
+	mutex_unlock(&kparser_config_lock);
+	rc = kparser_read_proto_table(&glue_obj->glue.key,
+				      &new_rsp, &new_rsp_len, false, "read");
+	mutex_lock(&kparser_config_lock);
+
+	if (rc != KPARSER_ATTR_RSP(KPARSER_NS_PROTO_TABLE))
+		goto error;
+
+	realloced_mem = krealloc(*rsp, *rsp_len + new_rsp_len, GFP_KERNEL | ___GFP_ZERO);
+	if (!realloced_mem)
+		goto error;
+	*rsp = realloced_mem;
+
+	ptr = (*rsp);
+	ptr += (*rsp_len);
+	(*rsp_len) = (*rsp_len) + new_rsp_len;
+	memcpy(ptr, new_rsp, new_rsp_len);
+	kparser_free(new_rsp);
+	new_rsp = NULL;
+
+	for (i = 0; i < glue_obj->proto_table.num_ents; i++)
+		if (!kparser_dump_parse_node(glue_obj->proto_table.entries[i].node,
+					     rsp, rsp_len))
+			goto error;
+
+	return true;
+error:
+	kparser_free(new_rsp);
+
+	return false;
+}
+
+/* dump parser to netlink msg rsp */
+static bool kparser_dump_parser(const struct kparser_glue_parser *kparser,
+				struct kparser_cmd_rsp_hdr **rsp, size_t *rsp_len)
+{
+	/* DEBUG code, if(0) avoids warning for both compiler and checkpatch */
+	if (0)
+		kparser_dump_parser_tree(&kparser->parser);
+
+	kparser_start_new_tree_traversal();
+
+	if (!kparser_dump_parse_node(kparser->parser.root_node, rsp, rsp_len))
+		goto error;
+
+	return true;
+error:
+	return false;
+}
+
+/* read handler for object parser */
+int kparser_read_parser(const struct kparser_hkey *key,
+			struct kparser_cmd_rsp_hdr **rsp,
+			size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	const struct kparser_glue_parser *kparser;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	kparser = kparser_namespace_lookup(KPARSER_NS_PARSER, key);
+	if (!kparser) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf), "%s: Object key not found", op);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = kparser->glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = kparser->glue.config.conf_keys_bv;
+	(*rsp)->object.parser_conf = kparser->glue.config.parser_conf;
+
+	if (recursive_read &&
+	    kparser_dump_parser(kparser, rsp, rsp_len) == false)
+		pr_debug("kparser_dump_parser failed");
+
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_PARSER);
+}
+
+/* delete handler for object parser */
+int kparser_del_parser(const struct kparser_hkey *key,
+		       struct kparser_cmd_rsp_hdr **rsp,
+		       size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	struct kparser_glue_parser *kparser;
+	int rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	kparser = kparser_namespace_lookup(KPARSER_NS_PARSER, key);
+	if (!kparser) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found", op);
+		goto done;
+	}
+
+	if (kparser_link_detach(kparser, &kparser->glue.owner_list,
+				&kparser->glue.owned_list, *rsp) != 0)
+		goto done;
+
+	rc = kparser_namespace_remove(KPARSER_NS_PARSER,
+				      &kparser->glue.ht_node_id, &kparser->glue.ht_node_name);
+	if (rc) {
+		(*rsp)->op_ret_code = rc;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: namespace remove error", op);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = kparser->glue.key;
+	pr_debug("Key: {ID:%u Name:%s}\n", (*rsp)->key.id, (*rsp)->key.name);
+	(*rsp)->object.conf_keys_bv = kparser->glue.config.conf_keys_bv;
+	(*rsp)->object.parser_conf = kparser->glue.config.parser_conf;
+
+	kparser_free(kparser->parser.cntrs);
+	kparser_free(kparser);
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_PARSER);
+}
+
+/* free handler for object parser */
+void kparser_free_parser(void *ptr, void *arg)
+{
+	/* TODO: */
+}
+
+/* handler for object parser lock */
+int kparser_parser_lock(const struct kparser_conf_cmd *conf,
+			size_t conf_len,
+			struct kparser_cmd_rsp_hdr **rsp,
+			size_t *rsp_len, const char *op)
+{
+	const struct kparser_parser *parser;
+	const struct kparser_hkey *key;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	mutex_lock(&kparser_config_lock);
+
+	key = &conf->obj_key;
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	parser = kparser_get_parser(key);
+	if (!parser) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: object key not found", __func__);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = *key;
+	(*rsp)->object.conf_keys_bv = conf->conf_keys_bv;
+	(*rsp)->object.obj_key = *key;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	synchronize_rcu();
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_OP_PARSER_LOCK_UNLOCK);
+}
+
+/* handler for object parser unlock */
+int kparser_parser_unlock(const struct kparser_hkey *key,
+			  struct kparser_cmd_rsp_hdr **rsp,
+			  size_t *rsp_len, __u8 recursive_read, const char *op)
+{
+	const struct kparser_glue_parser *kparser;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	pr_debug("Key: {ID:%u Name:%s}\n", key->id, key->name);
+
+	mutex_lock(&kparser_config_lock);
+
+	kparser = kparser_namespace_lookup(KPARSER_NS_PARSER, key);
+	if (!kparser) {
+		(*rsp)->op_ret_code = ENOENT;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Object key not found", __func__);
+		goto done;
+	}
+
+	if (!kparser_put_parser(&kparser->parser)) {
+		(*rsp)->op_ret_code = EINVAL;
+		snprintf((*rsp)->err_str_buf,
+			 sizeof((*rsp)->err_str_buf),
+			 "%s: Parser unlock failed",
+			 __func__);
+		goto done;
+	}
+
+	snprintf((*rsp)->err_str_buf, sizeof((*rsp)->err_str_buf), "Operation successful");
+	(*rsp)->key = *key;
+	(*rsp)->object.obj_key = *key;
+done:
+	mutex_unlock(&kparser_config_lock);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	return KPARSER_ATTR_RSP(KPARSER_NS_OP_PARSER_LOCK_UNLOCK);
+}
diff --git a/net/kparser/kparser_condexpr.h b/net/kparser/kparser_condexpr.h
new file mode 100644
index 000000000000..247e8cb3f231
--- /dev/null
+++ b/net/kparser/kparser_condexpr.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2022, SiPanda Inc.
+ *
+ * kparser_condexpr.h - kParser conditionals helper and structures header file
+ *
+ * Authors:     Tom Herbert <tom@sipanda.io>
+ *              Pratyush Kumar Khan <pratyush@sipanda.io>
+ */
+
+#ifndef __KPARSER_CONDEXPR_H__
+#define __KPARSER_CONDEXPR_H__
+
+/* Definitions for parameterized conditional expressions */
+
+#include "kparser_types.h"
+#include "kparser_metaextract.h"
+
+/* Evaluate one conditional expression */
+static inline bool kparser_expr_evaluate(const struct kparser_condexpr_expr *expr, void *hdr)
+{
+	__u64 val;
+
+	pr_debug("{%s:%d}: soff:%u len:%u mask:%x type:%d\n",
+		 __func__, __LINE__, expr->src_off, expr->length, expr->mask, expr->type);
+
+	__kparser_metadata_bytes_extract(hdr + expr->src_off, (__u8 *)&val, expr->length, false);
+
+	val &= expr->mask;
+
+	pr_debug("{%s:%d}: type:%d val:%llx expr->value:%u\n",
+		 __func__, __LINE__, expr->type, val, expr->value);
+
+	switch (expr->type) {
+	case KPARSER_CONDEXPR_TYPE_EQUAL:
+		return (val == expr->value);
+	case KPARSER_CONDEXPR_TYPE_NOTEQUAL:
+		return (val != expr->value);
+	case KPARSER_CONDEXPR_TYPE_LT:
+		return (val < expr->value);
+	case KPARSER_CONDEXPR_TYPE_LTE:
+		return (val <= expr->value);
+	case KPARSER_CONDEXPR_TYPE_GT:
+		return (val > expr->value);
+	case KPARSER_CONDEXPR_TYPE_GTE:
+		return (val >= expr->value);
+	default:
+		break;
+	}
+
+	return false;
+}
+#endif /* __KPARSER_CONDEXPR_H__ */
diff --git a/net/kparser/kparser_datapath.c b/net/kparser/kparser_datapath.c
new file mode 100644
index 000000000000..ad2bf2f728d5
--- /dev/null
+++ b/net/kparser/kparser_datapath.c
@@ -0,0 +1,1094 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2022, SiPanda Inc.
+ *
+ * kparser_datapath.c - kParser main datapath source file for parsing logic - data path
+ *
+ * Authors:     Tom Herbert <tom@sipanda.io>
+ *              Pratyush Kumar Khan <pratyush@sipanda.io>
+ */
+
+#include <linux/rhashtable.h>
+#include <linux/skbuff.h>
+#include <net/kparser.h>
+
+#include "kparser.h"
+#include "kparser_condexpr.h"
+#include "kparser_metaextract.h"
+#include "kparser_types.h"
+
+/* Lookup a type in a node table
+ * TODO: as of now, this table is an array, but in future, this needs to be
+ * converted to hash table for performance benefits
+ */
+static const struct kparser_parse_node *lookup_node(int type,
+						    const struct kparser_proto_table *table,
+						    bool *isencap)
+{
+	struct kparser_proto_table_entry __rcu *entries;
+	int i;
+
+	if (!table)
+		return NULL;
+
+	pr_debug("{%s:%d}: type:0x%04x ents:%d\n", __func__, __LINE__, type, table->num_ents);
+
+	for (i = 0; i < table->num_ents; i++) {
+		entries = rcu_dereference(table->entries);
+		pr_debug("{%s:%d}: type:0x%04x evalue:0x%04x\n",
+			 __func__, __LINE__, type, entries[i].value);
+		if (type == entries[i].value) {
+			*isencap = entries[i].encap;
+			return entries[i].node;
+		} else if (ntohs(type) == entries[i].value) {
+			*isencap = entries[i].encap;
+			return entries[i].node;
+		}
+	}
+
+	return NULL;
+}
+
+/* Lookup a type in a node TLV table */
+static const struct kparser_parse_tlv_node
+*lookup_tlv_node(__u8 type,
+		 const struct kparser_proto_tlvs_table *table)
+{
+	int i;
+
+	pr_debug("{%s:%d}: type:%d\n", __func__, __LINE__, type);
+
+	for (i = 0; i < table->num_ents; i++) {
+		pr_debug("{%s:%d}: table_type:%d\n", __func__, __LINE__,
+			 table->entries[i].type);
+		if (type == table->entries[i].type)
+			return table->entries[i].node;
+	}
+
+	return NULL;
+}
+
+/* Lookup a flag-fields index in a protocol node flag-fields table
+ * TODO: This needs to optimized later to use array for better performance
+ */
+static const struct kparser_parse_flag_field_node
+*lookup_flag_field_node(__u32 flag, const struct kparser_proto_flag_fields_table *table)
+{
+	int i;
+
+	for (i = 0; i < table->num_ents; i++) {
+		pr_debug("{%s:%d}:flag:%x eflag[%d]:%x\n",
+			 __func__, __LINE__, flag, i,
+			 table->entries[i].flag);
+		if (flag == table->entries[i].flag)
+			return table->entries[i].node;
+	}
+
+	return NULL;
+}
+
+/* Metadata table processing */
+static int extract_metadata_table(const struct kparser_parser *parser,
+				  const struct kparser_metadata_table *metadata_table,
+				  const void *_hdr, size_t hdr_len, size_t hdr_offset,
+				  void *_metadata, void *_frame,
+				  const struct kparser_ctrl_data *ctrl)
+{
+	struct kparser_metadata_extract *entries;
+	int i, ret;
+
+	pr_debug("{%s:%d}: cnt:%d\n", __func__, __LINE__,
+		 metadata_table->num_ents);
+
+	for (i = 0; i < metadata_table->num_ents; i++) {
+		entries = rcu_dereference(metadata_table->entries);
+		ret = kparser_metadata_extract(parser, entries[i],
+					       _hdr, hdr_len, hdr_offset,
+					       _metadata, _frame, ctrl);
+		if (ret != KPARSER_OKAY)
+			break;
+	}
+	return ret;
+}
+
+/* evaluate next proto parameterized context */
+static int eval_parameterized_next_proto(const struct kparser_parameterized_next_proto *pf,
+					 void *_hdr)
+{
+	__u16 next_proto;
+
+	_hdr += pf->src_off;
+
+	switch (pf->size) {
+	case 1:
+		next_proto = *(__u8 *)_hdr;
+		break;
+	case 2:
+		next_proto = *(__u16 *)_hdr;
+		break;
+	default:
+		return KPARSER_STOP_UNKNOWN_PROTO;
+	}
+
+	return (next_proto & pf->mask) >> pf->right_shift;
+}
+
+/* evaluate len parameterized context */
+static ssize_t eval_parameterized_len(const struct kparser_parameterized_len *pf, void *_hdr)
+{
+	__u32 len;
+
+	_hdr += pf->src_off;
+
+	switch (pf->size) {
+	case 1:
+		len = *(__u8 *)_hdr;
+		break;
+	case 2:
+		len = *(__u16 *)_hdr;
+		break;
+	case 3:
+		len = 0;
+		memcpy(&len, _hdr, 3);
+		break; /* TODO */
+	case 4:
+		len = *(__u32 *)_hdr;
+		break;
+	default:
+		return KPARSER_STOP_LENGTH;
+	}
+
+	len = (len & pf->mask) >> pf->right_shift;
+
+	return (len * pf->multiplier) + pf->add_value;
+}
+
+/* evaluate conditionals */
+static bool eval_cond_exprs_and_table(const struct kparser_condexpr_table *table, void *_hdr)
+{
+	int i;
+
+	for (i = 0; i < table->num_ents; i++)
+		if (!kparser_expr_evaluate(table->entries[i], _hdr))
+			return false;
+
+	return true;
+}
+
+/* evaluate table of conditionals */
+static bool eval_cond_exprs_or_table(const struct kparser_condexpr_table *table, void *_hdr)
+{
+	int i;
+
+	for (i = 0; i < table->num_ents; i++)
+		if (kparser_expr_evaluate(table->entries[i], _hdr))
+			return true;
+
+	return false;
+}
+
+/* evaluate list of table of conditionals */
+static int eval_cond_exprs(const struct kparser_condexpr_tables *tables, void *_hdr)
+{
+	bool res;
+	int i;
+
+	for (i = 0; i < tables->num_ents; i++) {
+		const struct kparser_condexpr_table *table = tables->entries[i];
+
+		pr_debug("{%s:%d}: type:%d err:%d\n", __func__, __LINE__,
+			 table->type, table->default_fail);
+
+		switch (table->type) {
+		case KPARSER_CONDEXPR_TYPE_OR:
+			res = eval_cond_exprs_or_table(table, _hdr);
+			break;
+		case KPARSER_CONDEXPR_TYPE_AND:
+			res = eval_cond_exprs_and_table(table, _hdr);
+			break;
+		}
+		if (!res) {
+			pr_debug("{%s:%d}: i:%d type:%d err:%d\n",
+				 __func__, __LINE__, i, table->type, table->default_fail);
+
+			return table->default_fail;
+		}
+	}
+
+	return KPARSER_OKAY;
+}
+
+/* process one tlv node */
+static int kparser_parse_one_tlv(const struct kparser_parser *parser,
+				 const struct kparser_parse_tlvs_node *parse_tlvs_node,
+				 const struct kparser_parse_tlv_node *parse_tlv_node,
+				 unsigned int flags, void *_obj_ref, void *_hdr,
+				 size_t tlv_len, size_t tlv_offset, void *_metadata,
+				 void *_frame, struct kparser_ctrl_data *ctrl)
+{
+	const struct kparser_parse_tlv_node *next_parse_tlv_node;
+	const struct kparser_metadata_table *metadata_table;
+	const struct kparser_proto_tlv_node *proto_tlv_node;
+	const struct kparser_proto_tlv_node_ops *proto_ops;
+	struct kparser_proto_tlvs_table *overlay_table;
+	int type, ret;
+
+parse_again:
+
+	proto_tlv_node = &parse_tlv_node->proto_tlv_node;
+
+	if (flags & KPARSER_F_DEBUG)
+		pr_debug("kParser parsing TLV %s\n", parse_tlv_node->name);
+
+	pr_debug("{%s:%d}: tlv_len:%lu min_len:%lu\n", __func__, __LINE__,
+		 tlv_len, proto_tlv_node->min_len);
+
+	if (tlv_len < proto_tlv_node->min_len || tlv_len > proto_tlv_node->max_len) {
+		/* Treat check length error as an unrecognized TLV */
+		parse_tlv_node = rcu_dereference(parse_tlvs_node->tlv_wildcard_node);
+		if (parse_tlv_node)
+			goto parse_again;
+		else
+			return parse_tlvs_node->unknown_tlv_type_ret;
+	}
+
+	proto_ops = &proto_tlv_node->ops;
+
+	pr_debug("{%s:%d}: cond_exprs_parameterized:%d\n",
+		 __func__, __LINE__, proto_ops->cond_exprs_parameterized);
+
+	if (proto_ops->cond_exprs_parameterized) {
+		ret = eval_cond_exprs(&proto_ops->cond_exprs, _hdr);
+		if (ret != KPARSER_OKAY)
+			return ret;
+	}
+
+	metadata_table = rcu_dereference(parse_tlv_node->metadata_table);
+	if (metadata_table) {
+		ret = extract_metadata_table(parser,
+					     metadata_table,
+					     _hdr, tlv_len, tlv_offset,
+					     _metadata,
+					     _frame, ctrl);
+		if (ret != KPARSER_OKAY)
+			return ret;
+	}
+
+	overlay_table = rcu_dereference(parse_tlv_node->overlay_table);
+	if (!overlay_table)
+		return KPARSER_OKAY;
+
+	/* We have an TLV overlay  node */
+	if (proto_ops && proto_ops->overlay_type_parameterized)
+		type = eval_parameterized_next_proto(&proto_ops->pfoverlay_type, _hdr);
+	else
+		type = tlv_len;
+
+	if (type < 0)
+		return type;
+
+	/* Get TLV node */
+	next_parse_tlv_node =
+		lookup_tlv_node(type, overlay_table);
+	if (next_parse_tlv_node) {
+		parse_tlv_node = next_parse_tlv_node;
+		goto parse_again;
+	}
+
+	/* Unknown TLV overlay node */
+	next_parse_tlv_node = rcu_dereference(parse_tlv_node->overlay_wildcard_node);
+	if (next_parse_tlv_node) {
+		parse_tlv_node = next_parse_tlv_node;
+		goto parse_again;
+	}
+
+	return parse_tlv_node->unknown_overlay_ret;
+}
+
+/* tlv loop limit validator */
+static int loop_limit_exceeded(int ret, unsigned int disp)
+{
+	switch (disp) {
+	case KPARSER_LOOP_DISP_STOP_OKAY:
+		return KPARSER_STOP_OKAY;
+	case KPARSER_LOOP_DISP_STOP_NODE_OKAY:
+		return KPARSER_STOP_NODE_OKAY;
+	case KPARSER_LOOP_DISP_STOP_SUB_NODE_OKAY:
+		return KPARSER_STOP_SUB_NODE_OKAY;
+	case KPARSER_LOOP_DISP_STOP_FAIL:
+	default:
+		return ret;
+	}
+}
+
+/* process packet value using parameters provided */
+static __u64 eval_get_value(const struct kparser_parameterized_get_value *pf, void *_hdr)
+{
+	__u64 ret;
+
+	(void)__kparser_metadata_bytes_extract(_hdr + pf->src_off, (__u8 *)&ret, pf->size, false);
+
+	return ret;
+}
+
+/* process and parse multiple tlvs */
+static int kparser_parse_tlvs(const struct kparser_parser *parser,
+			      const struct kparser_parse_node *parse_node,
+			      unsigned int flags, void *_obj_ref,
+			      void *_hdr, size_t hdr_len, size_t hdr_offset,
+			      void *_metadata, void *_frame,
+			      const struct kparser_ctrl_data *ctrl)
+{
+	unsigned int loop_cnt = 0, non_pad_cnt = 0, pad_len = 0;
+	const struct kparser_proto_tlvs_table *tlv_proto_table;
+	const struct kparser_parse_tlvs_node *parse_tlvs_node;
+	const struct kparser_proto_tlvs_node *proto_tlvs_node;
+	const struct kparser_parse_tlv_node *parse_tlv_node;
+	struct kparser_ctrl_data tlv_ctrl = {};
+	unsigned int consec_pad = 0;
+	size_t len, tlv_offset;
+	ssize_t off, tlv_len;
+	__u8 *cp = _hdr;
+	int type = -1, ret;
+
+	parse_tlvs_node = (struct kparser_parse_tlvs_node *)parse_node;
+	proto_tlvs_node = (struct kparser_proto_tlvs_node *)&parse_node->tlvs_proto_node;
+
+	pr_debug("{%s:%d}: fixed_start_offset:%d start_offset:%lu\n",
+		 __func__, __LINE__, proto_tlvs_node->fixed_start_offset,
+		 proto_tlvs_node->start_offset);
+	/* Assume hlen marks end of TLVs */
+	if (proto_tlvs_node->fixed_start_offset)
+		off = proto_tlvs_node->start_offset;
+	else
+		off = eval_parameterized_len(&proto_tlvs_node->ops.pfstart_offset, cp);
+
+	pr_debug("{%s:%d}: off:%ld\n", __func__, __LINE__, off);
+
+	if (off < 0)
+		return KPARSER_STOP_LENGTH;
+
+	/* We assume start offset is less than or equal to minimal length */
+	len = hdr_len - off;
+
+	cp += off;
+	tlv_offset = hdr_offset + off;
+
+	pr_debug("{%s:%d}: len:%ld tlv_offset:%ld\n", __func__, __LINE__, len, tlv_offset);
+
+	/* This is the main TLV processing loop */
+	while (len > 0) {
+		if (++loop_cnt > parse_tlvs_node->config.max_loop)
+			return loop_limit_exceeded(KPARSER_STOP_LOOP_CNT,
+						   parse_tlvs_node->config.disp_limit_exceed);
+
+		if (proto_tlvs_node->pad1_enable &&
+		    *cp == proto_tlvs_node->pad1_val) {
+			/* One byte padding, just advance */
+			cp++;
+			tlv_offset++;
+			len--;
+			if (++pad_len > parse_tlvs_node->config.max_plen ||
+			    ++consec_pad > parse_tlvs_node->config.max_c_pad)
+				return loop_limit_exceeded(KPARSER_STOP_TLV_PADDING,
+							   parse_tlvs_node->
+							   config.disp_limit_exceed);
+			continue;
+		}
+
+		if (proto_tlvs_node->eol_enable &&
+		    *cp == proto_tlvs_node->eol_val) {
+			cp++;
+			tlv_offset++;
+			len--;
+
+			/* Hit EOL, we're done */
+			break;
+		}
+
+		if (len < proto_tlvs_node->min_len) {
+			/* Length error */
+			return loop_limit_exceeded(KPARSER_STOP_TLV_LENGTH,
+						   parse_tlvs_node->config.disp_limit_exceed);
+		}
+
+		/* If the len function is not set this degenerates to an
+		 * array of fixed sized values (which maybe be useful in
+		 * itself now that I think about it)
+		 */
+		do {
+			pr_debug("{%s:%d}: len_parameterized:%d min_len:%lu\n",
+				 __func__, __LINE__,
+				 proto_tlvs_node->ops.len_parameterized,
+				 proto_tlvs_node->min_len);
+			if (proto_tlvs_node->ops.len_parameterized) {
+				tlv_len = eval_parameterized_len(&proto_tlvs_node->ops.pflen, cp);
+			} else {
+				tlv_len = proto_tlvs_node->min_len;
+				break;
+			}
+
+			pr_debug("{%s:%d}: tlv_len:%lu\n",
+				 __func__, __LINE__, tlv_len);
+
+			if (!tlv_len || len < tlv_len)
+				return loop_limit_exceeded(KPARSER_STOP_TLV_LENGTH,
+							   parse_tlvs_node->config.
+							   disp_limit_exceed);
+
+			if (tlv_len < proto_tlvs_node->min_len)
+				return loop_limit_exceeded(KPARSER_STOP_TLV_LENGTH,
+							   parse_tlvs_node->config.
+							   disp_limit_exceed);
+		} while (0);
+
+		type = eval_parameterized_next_proto(&proto_tlvs_node->ops.pftype, cp);
+
+		pr_debug("{%s:%d}: type:%d\n", __func__, __LINE__, type);
+
+		if (proto_tlvs_node->padn_enable &&
+		    type == proto_tlvs_node->padn_val) {
+			/* N byte padding, just advance */
+			pad_len += tlv_len;
+			if (pad_len > parse_tlvs_node->config.max_plen ||
+			    ++consec_pad > parse_tlvs_node->config.max_c_pad)
+				return loop_limit_exceeded(KPARSER_STOP_TLV_PADDING,
+							   parse_tlvs_node->config.
+							   disp_limit_exceed);
+			goto next_tlv;
+		}
+
+		/* Get TLV node */
+		tlv_proto_table = rcu_dereference(parse_tlvs_node->tlv_proto_table);
+		if (tlv_proto_table)
+			parse_tlv_node = lookup_tlv_node(type, tlv_proto_table);
+parse_one_tlv:
+		if (parse_tlv_node) {
+			const struct kparser_proto_tlv_node *proto_tlv_node =
+				&parse_tlv_node->proto_tlv_node;
+
+			if (proto_tlv_node) {
+				if (proto_tlv_node->is_padding) {
+					pad_len += tlv_len;
+					if (pad_len > parse_tlvs_node->config.max_plen ||
+					    ++consec_pad > parse_tlvs_node->config.max_c_pad)
+						return loop_limit_exceeded(KPARSER_STOP_TLV_PADDING,
+									   parse_tlvs_node->config.
+									   disp_limit_exceed);
+				} else if (++non_pad_cnt > parse_tlvs_node->config.max_non) {
+					return loop_limit_exceeded(KPARSER_STOP_OPTION_LIMIT,
+								   parse_tlvs_node->
+								   config.disp_limit_exceed);
+				}
+			}
+
+			ret = kparser_parse_one_tlv(parser, parse_tlvs_node,
+						    parse_tlv_node,
+						    flags, _obj_ref, cp, tlv_len,
+						    tlv_offset, _metadata,
+						    _frame, &tlv_ctrl);
+			if (ret != KPARSER_OKAY)
+				return ret;
+		} else {
+			/* Unknown TLV */
+			parse_tlv_node = rcu_dereference(parse_tlvs_node->tlv_wildcard_node);
+			if (parse_tlv_node) {
+				/* If a wilcard node is present parse that
+				 * node as an overlay to this one. The
+				 * wild card node can perform error processing
+				 */
+				goto parse_one_tlv;
+			}
+			/* Return default error code. Returning
+			 * KPARSER_OKAY means skip
+			 */
+			if (parse_tlvs_node->unknown_tlv_type_ret != KPARSER_OKAY)
+				return parse_tlvs_node->unknown_tlv_type_ret;
+		}
+
+		/* Move over current header */
+next_tlv:
+		cp += tlv_len;
+		tlv_offset += tlv_len;
+		len -= tlv_len;
+	}
+
+	return KPARSER_OKAY;
+}
+
+/* process and parse flag fields */
+static ssize_t kparser_parse_flag_fields(const struct kparser_parser *parser,
+					 const struct kparser_parse_node *parse_node,
+					 unsigned int pflags, void *_obj_ref,
+					 void *_hdr, size_t hdr_len,
+					 size_t hdr_offset, void *_metadata,
+					 void *_frame,
+					 const struct kparser_ctrl_data *ctrl,
+					 size_t parse_len)
+{
+	const struct kparser_parse_flag_fields_node *parse_flag_fields_node;
+	const struct kparser_proto_flag_fields_node *proto_flag_fields_node;
+	const struct kparser_parse_flag_field_node *parse_flag_field_node;
+	const struct kparser_metadata_table *metadata_table;
+	ssize_t off = -1, field_len, field_offset, res = 0;
+	const struct kparser_flag_fields *flag_fields;
+	__u32 flags = 0;
+	int i, ret;
+
+	parse_flag_fields_node = (struct kparser_parse_flag_fields_node *)parse_node;
+	proto_flag_fields_node = (struct kparser_proto_flag_fields_node *)&parse_node->proto_node;
+
+	flag_fields = rcu_dereference(proto_flag_fields_node->flag_fields);
+	if (!flag_fields)
+		return KPARSER_OKAY;
+
+	if (proto_flag_fields_node->ops.get_flags_parameterized)
+		flags = eval_get_value(&proto_flag_fields_node->ops.pfget_flags, _hdr);
+
+	/* Position at start of field data */
+	if (proto_flag_fields_node->ops.flag_fields_len)
+		off = proto_flag_fields_node->ops.hdr_length;
+	else if (proto_flag_fields_node->ops.start_fields_offset_parameterized)
+		off = eval_parameterized_len(&proto_flag_fields_node->ops.pfstart_fields_offset,
+					     _hdr);
+	else
+		return KPARSER_STOP_LENGTH;
+
+	if (off < 0)
+		return off;
+
+	if (hdr_offset + off > parse_len)
+		return KPARSER_STOP_LENGTH;
+	_hdr += off;
+	hdr_offset += off;
+
+	pr_debug("{%s:%d}: flag_fields->num_idx:%lu\n", __func__, __LINE__, flag_fields->num_idx);
+
+	for (i = 0; i < flag_fields->num_idx; i++) {
+		off = kparser_flag_fields_offset(i, flags, flag_fields);
+		pr_debug("{%s:%d}: off:%ld pflag:%x flag:%x\n",
+			 __func__, __LINE__, off, flags, flag_fields->fields[i].flag);
+		if (off < 0)
+			continue;
+
+		if (hdr_offset + flag_fields->fields[i].size > parse_len)
+			return KPARSER_STOP_LENGTH;
+
+		res += flag_fields->fields[i].size;
+
+		/* Flag field is present, try to find in the parse node
+		 * table based on index in proto flag-fields
+		 */
+		parse_flag_field_node =
+			lookup_flag_field_node(flag_fields->fields[i].flag,
+					       parse_flag_fields_node->flag_fields_proto_table);
+		if (parse_flag_field_node) {
+			const struct kparser_parse_flag_field_node_ops
+				*ops = &parse_flag_field_node->ops;
+			__u8 *cp = _hdr + off;
+
+			field_len = flag_fields->fields[i].size;
+			field_offset = hdr_offset + off;
+
+			if (field_offset > parse_len)
+				return KPARSER_STOP_LENGTH;
+
+			if (pflags & KPARSER_F_DEBUG)
+				pr_debug("kParser parsing flag-field %s\n",
+					 parse_flag_field_node->name);
+
+			if (eval_cond_exprs(&ops->cond_exprs, cp) < 0)
+				return KPARSER_STOP_COMPARE;
+
+			metadata_table = rcu_dereference(parse_flag_field_node->metadata_table);
+			if (metadata_table) {
+				ret = extract_metadata_table(parser,
+							     parse_flag_field_node->metadata_table,
+							     cp, field_len, field_offset, _metadata,
+							     _frame, ctrl);
+				if (ret != KPARSER_OKAY)
+					return ret;
+			}
+		}
+	}
+
+	return res;
+}
+
+/* process ok/fail/atencap nodes */
+static int __kparser_run_exit_node(const struct kparser_parser *parser,
+				   const struct kparser_parse_node *parse_node,
+				   void *_obj_ref, void *_hdr,
+				   size_t hdr_offset, ssize_t hdr_len,
+				   void *_metadata, void *_frame,
+				   struct kparser_ctrl_data *ctrl,
+				   unsigned int flags)
+{
+	const struct kparser_metadata_table *metadata_table;
+	int ret;
+
+	/* Run an exit parse node. This is an okay_node, fail_node, or
+	 * atencap_node
+	 */
+	metadata_table = rcu_dereference(parse_node->metadata_table);
+	if (metadata_table) {
+		ret = extract_metadata_table(parser, metadata_table, _hdr,
+					     hdr_len, hdr_offset, _metadata,
+					     _frame, ctrl);
+		if (ret != KPARSER_OKAY)
+			return ret;
+	}
+
+	return KPARSER_OKAY;
+}
+
+/* __kparser_parse(): Function to parse a void * packet buffer using a parser instance key.
+ *
+ * parser: Non NULL kparser_get_parser() returned and cached opaque pointer
+ * referencing a valid parser instance.
+ * _hdr: input packet buffer
+ * parse_len: length of input packet buffer
+ * _metadata: User provided metadata buffer. It must be same as configured
+ * metadata objects in CLI.
+ * metadata_len: Total length of the user provided metadata buffer.
+ *
+ * return: kParser error code as defined in include/uapi/linux/kparser.h
+ *
+ * rcu lock must be held before calling this function.
+ */
+int __kparser_parse(const void *obj, void *_hdr, size_t parse_len,
+		    void *_metadata, size_t metadata_len)
+{
+	const struct kparser_parse_node *next_parse_node, *atencap_node;
+	const struct kparser_parse_node *parse_node, *wildcard_node;
+	struct kparser_ctrl_data ctrl = { .ret = KPARSER_OKAY };
+	const struct kparser_metadata_table *metadata_table;
+	const struct kparser_proto_table *proto_table;
+	const struct kparser_proto_node *proto_node;
+	const struct kparser_parser *parser = obj;
+	int type = -1, i, ret, framescnt;
+	struct kparser_counters *cntrs;
+	void *_frame, *_obj_ref = NULL;
+	const void *base_hdr = _hdr;
+	ssize_t hdr_offset = 0;
+	ssize_t hdr_len, res;
+	__u32 frame_num = 0;
+	unsigned int flags;
+	bool currencap;
+
+	if (parser && parser->config.max_encaps > framescnt)
+		framescnt = parser->config.max_encaps;
+
+	if (!parser || !_metadata || metadata_len == 0 || !_hdr || parse_len == 0 ||
+	    (((framescnt * parser->config.frame_size) +
+	       parser->config.metameta_size) > metadata_len)) {
+		pr_debug("{%s:%d}: one or more empty/invalid param(s)\n", __func__, __LINE__);
+		return -EINVAL;
+	}
+
+	if (parser->kparser_start_signature != KPARSERSTARTSIGNATURE ||
+	    parser->kparser_end_signature != KPARSERENDSIGNATURE) {
+		pr_debug("%s:corrupted kparser signature:start:0x%02x, end:0x%02x\n",
+			 __func__, parser->kparser_start_signature, parser->kparser_end_signature);
+		return -EINVAL;
+	}
+
+	if (parse_len < parser->config.metameta_size) {
+		pr_debug("%s: parse buf err, parse_len:%lu, mmd_len:%lu\n",
+			 __func__, parse_len, parser->config.metameta_size);
+		return -EINVAL;
+	}
+
+	_frame = _metadata + parser->config.metameta_size;
+	flags = parser->config.flags;
+
+	ctrl.hdr_base = _hdr;
+	ctrl.node_cnt = 0;
+	ctrl.encap_levels = 0;
+
+	cntrs = rcu_dereference(parser->cntrs);
+	if (cntrs) {
+		/* Initialize parser counters */
+		memset(cntrs, 0, sizeof(parser->cntrs_len));
+	}
+
+	parse_node = rcu_dereference(parser->root_node);
+	if (!parse_node) {
+		pr_debug("%s: root node missing,parser:%s\n", __func__, parser->name);
+		return -ENOENT;
+	}
+
+	/* Main parsing loop. The loop normal teminates when we encounter a
+	 * leaf protocol node, an error condition, hitting limit on layers of
+	 * encapsulation, protocol condition to stop (i.e. flags that
+	 * indicate to stop at flow label or hitting fragment), or
+	 * unknown protocol result in table lookup for next node.
+	 */
+	do {
+		pr_debug("{%s:%d}: Parsing node:%s\n", __func__, __LINE__, parse_node->name);
+		currencap = false;
+		proto_node = &parse_node->proto_node;
+		hdr_len = proto_node->min_len;
+
+		if (++ctrl.node_cnt > parser->config.max_nodes) {
+			ctrl.ret = KPARSER_STOP_MAX_NODES;
+			goto parser_out;
+		}
+		/* Protocol node length checks */
+		if (flags & KPARSER_F_DEBUG)
+			pr_debug("kParser parsing %s\n", parse_node->name);
+
+		if (parse_len < hdr_len) {
+			ctrl.ret = KPARSER_STOP_LENGTH;
+			goto parser_out;
+		}
+
+		do {
+			if (!proto_node->ops.len_parameterized)
+				break;
+
+			hdr_len = eval_parameterized_len(&proto_node->ops.pflen, _hdr);
+
+			pr_debug("{%s:%d}: eval_hdr_len:%ld min_len:%lu\n",
+				 __func__, __LINE__, hdr_len, proto_node->min_len);
+
+			if (hdr_len < proto_node->min_len) {
+				ctrl.ret = hdr_len < 0 ? hdr_len : KPARSER_STOP_LENGTH;
+				goto parser_out;
+			}
+			if (parse_len < hdr_len) {
+				ctrl.ret = KPARSER_STOP_LENGTH;
+				goto parser_out;
+			}
+		} while (0);
+
+		hdr_offset = _hdr - base_hdr;
+		ctrl.pkt_len = parse_len;
+
+		/* Callback processing order
+		 *    1) Extract Metadata
+		 *    2) Process TLVs
+		 *	2.a) Extract metadata from TLVs
+		 *	2.b) Process TLVs
+		 *    3) Process protocol
+		 */
+
+		metadata_table = rcu_dereference(parse_node->metadata_table);
+		/* Extract metadata, per node processing */
+		if (metadata_table) {
+			ctrl.ret = extract_metadata_table(parser,
+							  metadata_table,
+							  _hdr, hdr_len, hdr_offset,
+							  _metadata, _frame, &ctrl);
+			if (ctrl.ret != KPARSER_OKAY)
+				goto parser_out;
+		}
+
+		/* Process node type */
+		switch (parse_node->node_type) {
+		case KPARSER_NODE_TYPE_PLAIN:
+		default:
+			break;
+		case KPARSER_NODE_TYPE_TLVS:
+			/* Process TLV nodes */
+			ctrl.ret = kparser_parse_tlvs(parser,
+						      parse_node, flags,
+						      _obj_ref, _hdr, hdr_len,
+						      hdr_offset, _metadata,
+						      _frame, &ctrl);
+check_processing_return:
+			switch (ctrl.ret) {
+			case KPARSER_STOP_OKAY:
+				goto parser_out;
+			case KPARSER_OKAY:
+				break; /* Go to the next node */
+			case KPARSER_STOP_NODE_OKAY:
+				/* Note KPARSER_STOP_NODE_OKAY means that
+				 * post loop processing is not
+				 * performed
+				 */
+				ctrl.ret = KPARSER_OKAY;
+				goto after_post_processing;
+			case KPARSER_STOP_SUB_NODE_OKAY:
+				ctrl.ret = KPARSER_OKAY;
+				break; /* Just go to next node */
+			default:
+				goto parser_out;
+			}
+			break;
+		case KPARSER_NODE_TYPE_FLAG_FIELDS:
+			/* Process flag-fields */
+			res = kparser_parse_flag_fields(parser, parse_node,
+							flags, _obj_ref,
+							_hdr, hdr_len,
+							hdr_offset,
+							_metadata,
+							_frame,
+							&ctrl, parse_len);
+			if (res < 0) {
+				ctrl.ret = res;
+				goto check_processing_return;
+			}
+			hdr_len += res;
+		}
+
+after_post_processing:
+		/* Proceed to next protocol layer */
+
+		proto_table = rcu_dereference(parse_node->proto_table);
+		wildcard_node = rcu_dereference(parse_node->wildcard_node);
+		if (!proto_table && !wildcard_node) {
+			/* Leaf parse node */
+			pr_debug("{%s:%d}:\n", __func__, __LINE__);
+			goto parser_out;
+		}
+
+		if (proto_table) {
+			do {
+				if (proto_node->ops.cond_exprs_parameterized) {
+					ctrl.ret =
+						eval_cond_exprs(&proto_node->ops.cond_exprs, _hdr);
+					if (ctrl.ret != KPARSER_OKAY)
+						goto parser_out;
+				}
+
+				if (!proto_table)
+					break;
+				type =
+					eval_parameterized_next_proto(&proto_node->ops.pfnext_proto,
+								      _hdr);
+				pr_debug("{%s:%d}: nxt_proto key:%d\n", __func__, __LINE__, type);
+				if (type < 0) {
+					ctrl.ret = type;
+					goto parser_out;
+				}
+
+				/* Get next node */
+				next_parse_node = lookup_node(type, proto_table, &currencap);
+
+				if (next_parse_node)
+					goto found_next;
+			} while (0);
+		}
+
+		/* Try wildcard node. Either table lookup failed to find a
+		 * node or there is only a wildcard
+		 */
+		if (wildcard_node) {
+			/* Perform default processing in a wildcard node */
+			next_parse_node = wildcard_node;
+		} else {
+			/* Return default code. Parsing will stop
+			 * with the inidicated code
+			 */
+			ctrl.ret = parse_node->unknown_ret;
+			goto parser_out;
+		}
+
+found_next:
+		/* Found next protocol node, set up to process */
+		if (!proto_node->overlay) {
+			/* Move over current header */
+			_hdr += hdr_len;
+			parse_len -= hdr_len;
+		}
+
+		parse_node = next_parse_node;
+		if (currencap || proto_node->encap) {
+			/* Check is there is an atencap_node configured for
+			 * the parser
+			 */
+			atencap_node = rcu_dereference(parser->atencap_node);
+			if (atencap_node) {
+				ret = __kparser_run_exit_node(parser,
+							      atencap_node, _obj_ref,
+							      _hdr, hdr_offset, hdr_len,
+							      _metadata, _frame, &ctrl,
+							      flags);
+				if (ret != KPARSER_OKAY)
+					goto parser_out;
+			}
+
+			/* New encapsulation layer. Check against
+			 * number of encap layers allowed and also
+			 * if we need a new metadata frame.
+			 */
+			if (++ctrl.encap_levels > parser->config.max_encaps) {
+				ctrl.ret = KPARSER_STOP_ENCAP_DEPTH;
+				goto parser_out;
+			}
+
+			if (frame_num < parser->config.max_frames) {
+				_frame += parser->config.frame_size;
+				frame_num++;
+			}
+
+			/* Check if parser has counters that need to be reset
+			 * at encap
+			 */
+			if (parser->cntrs)
+				for (i = 0; i < KPARSER_CNTR_NUM_CNTRS; i++)
+					if (parser->cntrs_conf.cntrs[i].reset_on_encap)
+						cntrs->cntr[i] = 0;
+		}
+
+	} while (1);
+
+parser_out:
+	/* Convert PANDA_OKAY to PANDA_STOP_OKAY if parser is exiting normally.
+	 * This means that okay_node will see PANDA_STOP_OKAY in ctrl.ret
+	 */
+	ctrl.ret = ctrl.ret == KPARSER_OKAY ? KPARSER_STOP_OKAY : ctrl.ret;
+
+	parse_node = (ctrl.ret == KPARSER_OKAY || KPARSER_IS_OK_CODE(ctrl.ret)) ?
+		      rcu_dereference(parser->okay_node) : rcu_dereference(parser->fail_node);
+
+	if (!parse_node)
+		return ctrl.ret;
+
+	/* Run an exit parse node. This is either the okay node or the fail
+	 * node that is set in parser config
+	 */
+	ret = __kparser_run_exit_node(parser, parse_node, _obj_ref,
+				      _hdr, hdr_offset, hdr_len,
+				      _metadata, _frame, &ctrl, flags);
+	if (ret != KPARSER_OKAY)
+		ctrl.ret = (ctrl.ret == KPARSER_STOP_OKAY) ? ret : ctrl.ret;
+
+	return ctrl.ret;
+}
+EXPORT_SYMBOL(__kparser_parse);
+
+static inline void *
+kparser_get_parser_ctx(const struct kparser_hkey *kparser_key)
+{
+	void *ptr, *parser;
+
+	if (!kparser_key)
+		return NULL;
+
+	ptr = kparser_namespace_lookup(KPARSER_NS_PARSER, kparser_key);
+	parser = rcu_dereference(ptr);
+	return parser;
+}
+
+/* kparser_parse(): Function to parse a skb using a parser instance key.
+ *
+ * skb: input packet skb
+ * kparser_key: key of the associated kParser parser object which must be
+ *              already created via CLI.
+ * _metadata: User provided metadata buffer. It must be same as configured
+ *            metadata objects in CLI.
+ * metadata_len: Total length of the user provided metadata buffer.
+ *
+ * return: kParser error code as defined in include/uapi/linux/kparser.h
+ */
+int kparser_parse(struct sk_buff *skb,
+		  const struct kparser_hkey *kparser_key,
+		  void *_metadata, size_t metadata_len)
+{
+	struct kparser_glue_parser *k_prsr;
+	struct kparser_parser *parser;
+	void *data, *ptr;
+	size_t pktlen;
+	int err;
+
+	data = skb_mac_header(skb);
+	pktlen = skb_mac_header_len(skb) + skb->len;
+	if (pktlen > KPARSER_MAX_SKB_PACKET_LEN) {
+		skb_pull(skb, KPARSER_MAX_SKB_PACKET_LEN);
+		data = skb_mac_header(skb);
+		pktlen = skb_mac_header_len(skb) + skb->len;
+	}
+
+	err = skb_linearize(skb);
+	if (err < 0)
+		return err;
+	WARN_ON(skb->data_len);
+
+	k_prsr = kparser_get_parser_ctx(kparser_key);
+	if (!k_prsr) {
+		pr_debug("{%s:%d}: parser is not found\n", __func__, __LINE__);
+		return -EINVAL;
+	}
+
+	rcu_read_lock();
+
+	kparser_ref_get(&k_prsr->glue.refcount);
+	parser = &k_prsr->parser;
+
+	ptr = kparser_namespace_lookup(KPARSER_NS_PARSER, kparser_key);
+	k_prsr = rcu_dereference(ptr);
+	parser = &k_prsr->parser;
+	if (!parser) {
+		pr_debug("{%s:%d}:parser htbl lookup failure for key:{%s:%u}\n",
+			 __func__, __LINE__,
+			 kparser_key->name, kparser_key->id);
+		rcu_read_unlock();
+		kparser_ref_put(&k_prsr->glue.refcount);
+		return -ENOENT;
+	}
+
+	err = __kparser_parse(parser, data, pktlen, _metadata, metadata_len);
+
+	rcu_read_unlock();
+
+	kparser_ref_put(&k_prsr->glue.refcount);
+
+	return err;
+}
+EXPORT_SYMBOL(kparser_parse);
+
+/* kparser_get_parser(): Function to get an opaque reference of a parser instance and mark it
+ * immutable so that while actively using, it can not be deleted. The parser is identified by a key.
+ * It marks the associated parser and whole parse tree immutable so that when it is locked, it can
+ * not be deleted.
+ *
+ * kparser_key: key of the associated kParser parser object which must be
+ * already created via CLI.
+ *
+ * return: NULL if key not found, else an opaque parser instance pointer which
+ * can be used in the following APIs 3 and 4.
+ *
+ * NOTE: This call makes the whole parser tree immutable. If caller calls this
+ * more than once, later caller will need to release the same parser exactly that
+ * many times using the API kparser_put_parser().
+ */
+const void *kparser_get_parser(const struct kparser_hkey *kparser_key)
+{
+	struct kparser_glue_parser *k_prsr;
+
+	k_prsr = kparser_get_parser_ctx(kparser_key);
+	if (!k_prsr)
+		return NULL;
+	kparser_ref_get(&k_prsr->glue.refcount);
+
+	return &k_prsr->parser;
+}
+EXPORT_SYMBOL(kparser_get_parser);
+
+/* kparser_put_parser(): Function to return and undo the read only operation done previously by
+ * kparser_get_parser(). The parser instance is identified by using a previously obtained opaque
+ * parser pointer via API kparser_get_parser(). This undo the immutable change so that any component
+ * of the whole parse tree can be deleted again.
+ *
+ * parser: void *, Non NULL opaque pointer which was previously returned by kparser_get_parser().
+ * Caller can use cached opaque pointer as long as system does not restart and kparser.ko is not
+ * reloaded.
+ *
+ * return: boolean, true if put operation is success, else false.
+ *
+ * NOTE: This call makes the whole parser tree deletable for the very last call.
+ */
+bool kparser_put_parser(const void *obj)
+{
+	const struct kparser_parser *parser = obj;
+	struct kparser_glue_parser *k_parser;
+
+	if (!parser)
+		return false;
+	k_parser = container_of(parser, struct kparser_glue_parser, parser);
+	kparser_ref_put(&k_parser->glue.refcount);
+
+	return true;
+}
+EXPORT_SYMBOL(kparser_put_parser);
diff --git a/net/kparser/kparser_main.c b/net/kparser/kparser_main.c
new file mode 100644
index 000000000000..b8607ed427ec
--- /dev/null
+++ b/net/kparser/kparser_main.c
@@ -0,0 +1,325 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2022, SiPanda Inc.
+ *
+ * kParser KMOD main module source file with netlink handlers
+ *
+ * Author:      Pratyush Kumar Khan <pratyush@sipanda.io>
+ */
+
+#include <linux/errno.h>
+#include <linux/idr.h>
+#include <linux/kernel.h>
+#include <linux/kparser.h>
+#include <linux/module.h>
+#include <linux/rtnetlink.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <net/act_api.h>
+#include <net/genetlink.h>
+#include <net/kparser.h>
+#include <net/netlink.h>
+#include <net/pkt_cls.h>
+
+#include "kparser.h"
+
+static int kparser_cli_cmd_handler(struct sk_buff *skb, struct genl_info *info);
+
+/* define netlink msg policies */
+#define NS_DEFINE_POLICY_ATTR_ENTRY(id, struc_name, rsp_struc_name)	\
+	[KPARSER_ATTR_CREATE_##id] = {					\
+		.type = NLA_BINARY,					\
+		.validation_type = NLA_VALIDATE_MIN,			\
+		.min = sizeof(struct struc_name)			\
+	},								\
+	[KPARSER_ATTR_UPDATE_##id] = {					\
+		.type = NLA_BINARY,					\
+		.len = sizeof(struct struc_name),			\
+		.validation_type = NLA_VALIDATE_MIN,			\
+		.min = sizeof(struct struc_name)			\
+	},								\
+	[KPARSER_ATTR_READ_##id] = {					\
+		.type = NLA_BINARY,					\
+		.len = sizeof(struct struc_name),			\
+		.validation_type = NLA_VALIDATE_MIN,			\
+		.min = sizeof(struct struc_name)			\
+	},								\
+	[KPARSER_ATTR_DELETE_##id] = {					\
+		.type = NLA_BINARY,					\
+		.len = sizeof(struct struc_name),			\
+		.validation_type = NLA_VALIDATE_MIN,			\
+		.min = sizeof(struct struc_name)			\
+	},								\
+	[KPARSER_ATTR_RSP_##id] = {					\
+		.type = NLA_BINARY,					\
+		.len = sizeof(struct rsp_struc_name),			\
+		.validation_type = NLA_VALIDATE_MIN,			\
+		.min = sizeof(struct rsp_struc_name)			\
+	}
+
+static const struct nla_policy kparser_nl_policy[KPARSER_ATTR_MAX] = {
+	NS_DEFINE_POLICY_ATTR_ENTRY(KPARSER_NS_CONDEXPRS,
+				    kparser_conf_cmd,
+			kparser_cmd_rsp_hdr),
+	NS_DEFINE_POLICY_ATTR_ENTRY(KPARSER_NS_CONDEXPRS_TABLE,
+				    kparser_conf_cmd,
+			kparser_cmd_rsp_hdr),
+	NS_DEFINE_POLICY_ATTR_ENTRY(KPARSER_NS_CONDEXPRS_TABLES,
+				    kparser_conf_cmd,
+			kparser_cmd_rsp_hdr),
+	NS_DEFINE_POLICY_ATTR_ENTRY(KPARSER_NS_COUNTER,
+				    kparser_conf_cmd,
+			kparser_cmd_rsp_hdr),
+	NS_DEFINE_POLICY_ATTR_ENTRY(KPARSER_NS_COUNTER_TABLE,
+				    kparser_conf_cmd,
+			kparser_cmd_rsp_hdr),
+	NS_DEFINE_POLICY_ATTR_ENTRY(KPARSER_NS_METADATA,
+				    kparser_conf_cmd,
+			kparser_cmd_rsp_hdr),
+	NS_DEFINE_POLICY_ATTR_ENTRY(KPARSER_NS_METALIST,
+				    kparser_conf_cmd,
+			kparser_cmd_rsp_hdr),
+	NS_DEFINE_POLICY_ATTR_ENTRY(KPARSER_NS_NODE_PARSE,
+				    kparser_conf_cmd,
+			kparser_cmd_rsp_hdr),
+	NS_DEFINE_POLICY_ATTR_ENTRY(KPARSER_NS_PROTO_TABLE,
+				    kparser_conf_cmd,
+			kparser_cmd_rsp_hdr),
+	NS_DEFINE_POLICY_ATTR_ENTRY(KPARSER_NS_TLV_NODE_PARSE,
+				    kparser_conf_cmd,
+			kparser_cmd_rsp_hdr),
+	NS_DEFINE_POLICY_ATTR_ENTRY(KPARSER_NS_TLV_PROTO_TABLE,
+				    kparser_conf_cmd,
+			kparser_cmd_rsp_hdr),
+	NS_DEFINE_POLICY_ATTR_ENTRY(KPARSER_NS_FLAG_FIELD,
+				    kparser_conf_cmd,
+			kparser_cmd_rsp_hdr),
+	NS_DEFINE_POLICY_ATTR_ENTRY(KPARSER_NS_FLAG_FIELD_TABLE,
+				    kparser_conf_cmd,
+			kparser_cmd_rsp_hdr),
+	NS_DEFINE_POLICY_ATTR_ENTRY(KPARSER_NS_FLAG_FIELD_NODE_PARSE,
+				    kparser_conf_cmd,
+			kparser_cmd_rsp_hdr),
+	NS_DEFINE_POLICY_ATTR_ENTRY(KPARSER_NS_FLAG_FIELD_PROTO_TABLE,
+				    kparser_conf_cmd,
+			kparser_cmd_rsp_hdr),
+	NS_DEFINE_POLICY_ATTR_ENTRY(KPARSER_NS_PARSER,
+				    kparser_conf_cmd,
+			kparser_cmd_rsp_hdr),
+	NS_DEFINE_POLICY_ATTR_ENTRY(KPARSER_NS_OP_PARSER_LOCK_UNLOCK,
+				    kparser_conf_cmd,
+			kparser_cmd_rsp_hdr),
+};
+
+/* define netlink operations and family */
+static const struct genl_ops kparser_nl_ops[] = {
+	{
+	  .cmd = KPARSER_CMD_CONFIGURE,
+	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+	  .doit = kparser_cli_cmd_handler,
+	  .flags = GENL_ADMIN_PERM,
+	},
+};
+
+struct genl_family kparser_nl_family __ro_after_init = {
+	.hdrsize	= 0,
+	.name		= KPARSER_GENL_NAME,
+	.version	= KPARSER_GENL_VERSION,
+	.maxattr	= KPARSER_ATTR_MAX - 1,
+	.policy		= kparser_nl_policy,
+	.netnsok	= true,
+	.parallel_ops	= true,
+	.module		= THIS_MODULE,
+	.ops		= kparser_nl_ops,
+	.n_ops		= ARRAY_SIZE(kparser_nl_ops),
+};
+
+/* send response to netlink msg requests */
+static int kparser_send_cmd_rsp(int cmd, int attrtype,
+				const struct kparser_cmd_rsp_hdr *rsp,
+				size_t rsp_len, struct genl_info *info)
+{
+	struct sk_buff *msg;
+	size_t msgsz = NLMSG_DEFAULT_SIZE;
+	void *hdr;
+	int ret;
+
+	if (rsp_len > msgsz)
+		msgsz = rsp_len;
+
+	msg = nlmsg_new(msgsz, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
+			  &kparser_nl_family, 0, cmd);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return -ENOBUFS;
+	}
+
+	if (nla_put(msg, attrtype, (int)rsp_len, rsp)) {
+		genlmsg_cancel(msg, hdr);
+		nlmsg_free(msg);
+		return -EMSGSIZE;
+	}
+
+	genlmsg_end(msg, hdr);
+	ret = genlmsg_reply(msg, info);
+
+	// pr_debug("genlmsg_reply() ret:%d\n", ret);
+	return ret;
+}
+
+typedef int kparser_ops(const void *, size_t, struct kparser_cmd_rsp_hdr **, size_t *);
+
+/* define netlink msg processors */
+#define KPARSER_NS_DEFINE_OP_HANDLERS(NS_ID)				\
+	[KPARSER_ATTR_CREATE_##NS_ID] = kparser_config_handler_add,	\
+	[KPARSER_ATTR_UPDATE_##NS_ID] = kparser_config_handler_update,	\
+	[KPARSER_ATTR_READ_##NS_ID] = kparser_config_handler_read,	\
+	[KPARSER_ATTR_DELETE_##NS_ID] = kparser_config_handler_delete,	\
+	[KPARSER_ATTR_RSP_##NS_ID] = NULL
+
+static kparser_ops *kparser_ns_op_handler[KPARSER_ATTR_MAX] = {
+	NULL,
+	KPARSER_NS_DEFINE_OP_HANDLERS(KPARSER_NS_CONDEXPRS),
+	KPARSER_NS_DEFINE_OP_HANDLERS(KPARSER_NS_CONDEXPRS_TABLE),
+	KPARSER_NS_DEFINE_OP_HANDLERS(KPARSER_NS_CONDEXPRS_TABLES),
+	KPARSER_NS_DEFINE_OP_HANDLERS(KPARSER_NS_COUNTER),
+	KPARSER_NS_DEFINE_OP_HANDLERS(KPARSER_NS_COUNTER_TABLE),
+	KPARSER_NS_DEFINE_OP_HANDLERS(KPARSER_NS_METADATA),
+	KPARSER_NS_DEFINE_OP_HANDLERS(KPARSER_NS_METALIST),
+	KPARSER_NS_DEFINE_OP_HANDLERS(KPARSER_NS_NODE_PARSE),
+	KPARSER_NS_DEFINE_OP_HANDLERS(KPARSER_NS_PROTO_TABLE),
+	KPARSER_NS_DEFINE_OP_HANDLERS(KPARSER_NS_TLV_NODE_PARSE),
+	KPARSER_NS_DEFINE_OP_HANDLERS(KPARSER_NS_TLV_PROTO_TABLE),
+	KPARSER_NS_DEFINE_OP_HANDLERS(KPARSER_NS_FLAG_FIELD),
+	KPARSER_NS_DEFINE_OP_HANDLERS(KPARSER_NS_FLAG_FIELD_TABLE),
+	KPARSER_NS_DEFINE_OP_HANDLERS(KPARSER_NS_FLAG_FIELD_NODE_PARSE),
+	KPARSER_NS_DEFINE_OP_HANDLERS(KPARSER_NS_FLAG_FIELD_PROTO_TABLE),
+	KPARSER_NS_DEFINE_OP_HANDLERS(KPARSER_NS_PARSER),
+	KPARSER_NS_DEFINE_OP_HANDLERS(KPARSER_NS_OP_PARSER_LOCK_UNLOCK),
+};
+
+/* netlink msg request handler */
+static int kparser_cli_cmd_handler(struct sk_buff *skb, struct genl_info *info)
+{
+	struct kparser_cmd_rsp_hdr *rsp = NULL;
+	size_t rsp_len = 0;
+	int ret_attr_id;
+	int attr_idx;
+	int rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	for (attr_idx = KPARSER_ATTR_UNSPEC + 1; attr_idx < KPARSER_ATTR_MAX; attr_idx++) {
+		if (!info->attrs[attr_idx] || !kparser_ns_op_handler[attr_idx])
+			continue;
+
+		ret_attr_id = kparser_ns_op_handler[attr_idx](nla_data(info->attrs[attr_idx]),
+							      nla_len(info->attrs[attr_idx]), &rsp,
+							      &rsp_len);
+
+		if (ret_attr_id <= KPARSER_ATTR_UNSPEC || ret_attr_id >= KPARSER_ATTR_MAX) {
+			pr_debug("%s: attr %d handler failed\n", __func__, attr_idx);
+			rc = EIO;
+			goto out;
+		}
+
+		rc = kparser_send_cmd_rsp(KPARSER_CMD_CONFIGURE, ret_attr_id, rsp, rsp_len, info);
+		if (rc) {
+			pr_debug("kparser_send_cmd_rsp() failed,attr:%d, rc:%d\n", attr_idx, rc);
+			rc = EIO;
+			goto out;
+		}
+
+		kfree(rsp);
+		rsp = NULL;
+		rsp_len = 0;
+	}
+
+out:
+	if (rsp)
+		kfree(rsp);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	return rc;
+}
+
+/* kParser callback hooks to be registered in core/filter.c when enabled */
+static inline void init_kparser_hooks(void)
+{
+	kparser_funchooks.kparser_get_parser_hook = &kparser_get_parser;
+	kparser_funchooks.__kparser_parse_hook = &__kparser_parse;
+	kparser_funchooks.kparser_put_parser_hook = &kparser_put_parser;
+}
+
+static inline void deinit_kparser_hooks(void)
+{
+	kparser_funchooks.kparser_get_parser_hook = NULL;
+	kparser_funchooks.__kparser_parse_hook = NULL;
+	kparser_funchooks.kparser_put_parser_hook = NULL;
+}
+
+/* kParser KMOD's init handler */
+static int __init init_kparser(void)
+{
+	int rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	rc = genl_register_family(&kparser_nl_family);
+	if (rc) {
+		pr_debug("genl_register_family failed\n");
+		pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+		return rc;
+	}
+
+	rc = kparser_init();
+	if (rc) {
+		pr_debug("kparser_init() err:%d\n", rc);
+		goto out;
+	}
+	init_kparser_hooks();
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	return rc;
+
+out:
+	rc = genl_unregister_family(&kparser_nl_family);
+	if (rc != 0)
+		pr_debug("kparser_deinit() err:%d\n", rc);
+
+	pr_debug("ERR OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	deinit_kparser_hooks();
+	return rc;
+}
+
+/* kParser KMOD's exit handler */
+static void __exit exit_kparser(void)
+{
+	int rc;
+
+	pr_debug("IN: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+
+	rc = genl_unregister_family(&kparser_nl_family);
+	if (rc != 0)
+		pr_debug("genl_unregister_family() err:%d\n", rc);
+
+	rc = kparser_deinit();
+	if (rc != 0)
+		pr_debug("kparser_deinit() err:%d\n", rc);
+
+	pr_debug("OUT: %s:%s:%d\n", __FILE__, __func__, __LINE__);
+	deinit_kparser_hooks();
+}
+
+module_init(init_kparser);
+module_exit(exit_kparser);
+MODULE_AUTHOR("Pratyush Khan <pratyush@sipanda.io>");
+MODULE_AUTHOR("SiPanda Inc");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Configurable Parameterized Parser in Kernel (KPARSER)");
diff --git a/net/kparser/kparser_metaextract.h b/net/kparser/kparser_metaextract.h
new file mode 100644
index 000000000000..5f3a8f5c74df
--- /dev/null
+++ b/net/kparser/kparser_metaextract.h
@@ -0,0 +1,896 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2022, SiPanda Inc.
+ *
+ * kparser_metaextract.h - kParser metadata helper and structures header file
+ *
+ * Authors:     Tom Herbert <tom@sipanda.io>
+ *              Pratyush Kumar Khan <pratyush@sipanda.io>
+ */
+
+#ifndef __KPARSER_METAEXTRACT_H__
+#define __KPARSER_METAEXTRACT_H__
+
+#include "kparser_types.h"
+
+#include "linux/byteorder/little_endian.h"
+#define __BYTE_ORDER __LITTLE_ENDIAN
+
+#define __BIG_ENDIAN 0
+
+#if __BYTE_ORDER == __BIG_ENDIAN
+#define kparser_htonll(x) (x)
+#define kparser_ntohll(x) (x)
+#elif __BYTE_ORDER == __LITTLE_ENDIAN
+#define kparser_htonll(x)						\
+	(((__u64)htonl((x) & 0xffffffff) << 32) | htonl((x) >> 32))
+#define kparser_ntohll(x)						\
+	(((__u64)ntohl((x) & 0xffffffff) << 32) | ntohl((x) >> 32))
+#else
+#error "Cannot determine endianness"
+#endif
+
+/* Metadata extraction pseudo instructions
+ *
+ * These instructions extract header data and set control data into metadata.
+ * Common fields are:
+ *    - code: Describes the data being written to the metadata. See descriptions
+ *	      below
+ *    - frame: Boolean value. If true then the data is a written to the current
+ *	      metadata frame (frame + dst_off), else the data is written
+ *	      to the metadata base (metadata + dst_off)
+ *    - cntr: Counter. If nonzero the data is written to an array defined
+ *	      by the specified counter. Note that dst_off in this case could
+ *	      be the base off set of an array plus the offset within an
+ *	      element of the array
+ *    - dst_off: Destination offset into the metadata to write the extracted
+ *	      data. This is a nine bits to allow an offset of 0 to 511
+ *	      bytes. In the case of writing a sixteen bit constant,
+ *	      dst_off is an eight byte field that is multiplied by two
+ *	      to derive the target destination offset
+ *
+ * Metadata extraction codes:
+ *    - KPARSER_METADATA_BYTES_EXTRACT: bytes field
+ *	    Extract some number of bytes of header data. The src_off field
+ *	    indicates the source offset in bytes from the current header being
+ *	    processed, and length indicates the number of bytes to be extracted.
+ *	    One is added to the length to get the target length. For example,
+ *	    to extract the IPv4 source address into metadata, src_off would be
+ *	    set to twelve and length would be set to three (that indicates
+ *	    to extract four bytes). If e_bit is true then the bytes are endian
+ *	    swapped before being stored
+ *    - KPARSER_METADATA_NIBBS_EXTRACT: nibbs field
+ *	    Extract some number of nibbles of header data. The src_off field
+ *	    indicates the source offset in nibbles from the current header being
+ *	    processed, and length indicates the number of nibbles to be
+ *	    extracted. Note that nibbles are counted such that the high order
+ *	    nibble of the first byte is nibble zero, and the low order is
+ *	    nibble one. When nibbles are written to be aligned to the
+ *	    destination bytes (e.g. the high order nibble to the first
+ *	    destination byte contains nibble zero). If an off number of nibbles
+ *	    are written, then the last nibble is written to the high order
+ *	    nibble of the last byte, and the low order nibble of the last
+ *	    byte is zero. If e_bit is true then the resultant bytes are endian
+ *	    swapped before being stored
+ *    - KPARSER_METADATA_CONSTANT_BYTE_SET: constant_byte field
+ *	    Set a byte constant in the metadata. The data field contains the
+ *	    value of the byte to be written
+ *    - KPARSER_METADATA_CONSTANT_HWORD_SET: constant_hword field
+ *	    Set a half word (16 bits) constant in the metadata. The data field
+ *	    contains the value of the halfword to be written. Note that dst_off
+ *	    is multiplied by two to derive the target offset
+ *    - KPARSER_METADATA_OFFSET_SET: offset field
+ *	    Set the current absolute offset of a field in a packet. This
+ *	    is the offset in two bytes of the current header being processed
+ *	    plus the value in add_off which is the offset of the field of
+ *	    interest in the current header. For instance, to get the offset of
+ *	    the source IP address add_off would be set to twelve; and for a
+ *	    plain IPv4 Ethernet packet the value written to metadata would
+ *	    be twenty-six (offset of the IPv4 header is fourteen plus twelve
+ *	    which is value of add_off and the offset of the source address
+ *	    in the IPv4 header). If bit_offset is set then the bit offset of
+ *	    the field is written. This is derived as eight times the current
+ *	    header byte offset plus add_off. For example, to extract the
+ *	    bit offset of the fragment offset of IPv4 header, add_off would
+ *	    have the value fifty-one. For a plain IPv4 Ethernet packet, the
+ *	    extract bit offset would then be 163
+ *    - KPARSER_METADATA_CTRL_HDR_LENGTH: control field
+ *	    Write the length of the current header to metadata. The length is
+ *	    written in two bytes. A counter operation may be specified as
+ *	    described below
+ *    - KPARSER_METADATA_CTRL_NUM_NODES: control field
+ *	    Write the current number of parse nodes that have been visited to
+ *	    metadata. The number of nodes is written in two bytes. A counter
+ *	    operation may be specified as described below
+ *    - KPARSER_METADATA_CTRL_NUM_ENCAPS: control field
+ *	    Write the current number of encapsulation levels to metadata. The
+ *	    number of nodes is written in two bytes. A counter operation may be
+ *	    specified as described below
+ *    - KPARSER_METADATA_CTRL_TIMESTAMP: control field
+ *	    Write the receive timestamp of a packet to metadata. The timestamp
+ *	    number of nodes is written in eight bytes. A counter operation may
+ *	    be specified as described below
+ *    - KPARSER_METADATA_CTRL_COUNTER: control_counter field
+ *	    Write the current value of a counter to metadata. The counter is
+ *	    specified in counter_for_data. The counter is written in two bytes.
+ *	    A counter operation may be specified as described below
+ *    - KPARSER_METADATA_CTRL_NOOP: control_noop field
+ *	    "No operation". This pseudo instruction does not write any data.
+ *	    It's primary purpose is to allow counter operations after performing
+ *	    non-control pseudo instructions (note that the non-control variants
+ *	    don't have a cntr_op field)
+ *
+ * There are two operations that may be performed on a counter and that are
+ * expressed in control type pseudo instructions: increment and reset. A
+ * counter operation is set in the cntr_op field of control pseudo instructions.
+ * The defined counter operations are:
+ *    - KPARSER_METADATA_CNTROP_NULL: No counter operation
+ *    - KPARSER_METADATA_CNTROP_INCREMENT: Increment the counter specified
+ *	    in cntr by one. The configuration for the counter is check and
+ *	    if the limit for the counter is exceeded the appropriate behavior
+ *	    is done
+ *    - KPARSER_METADATA_CNTROP_RESET: Reset the counter specified
+ *          in cntr to zero
+ */
+
+/* Metatdata extract codes */
+#define KPARSER_METADATA_BYTES_EXTRACT		0 /* Var bytes */
+#define KPARSER_METADATA_NIBBS_EXTRACT		1 /* Var bytes */
+#define KPARSER_METADATA_CONSTANT_BYTE_SET	2 /* One byte */
+#define KPARSER_METADATA_CONSTANT_HWORD_SET	3 /* Two bytes */
+#define KPARSER_METADATA_OFFSET_SET		4 /* Two bytes */
+#define KPARSER_METADATA_CTRL_HDR_LENGTH	5 /* Two bytes */
+#define KPARSER_METADATA_CTRL_NUM_NODES		6 /* Two bytes */
+#define KPARSER_METADATA_CTRL_NUM_ENCAPS	7 /* Two bytes */
+#define KPARSER_METADATA_CTRL_TIMESTAMP		8 /* Eight bytes */
+#define KPARSER_METADATA_CTRL_RET_CODE		9 /* Four bytes */
+#define KPARSER_METADATA_CTRL_COUNTER		10 /* Two bytes */
+#define KPARSER_METADATA_CTRL_NOOP		11 /* Zero bytes */
+
+#define KPARSER_METADATA_CNTROP_NULL		0
+#define KPARSER_METADATA_CNTROP_INCREMENT	1
+#define KPARSER_METADATA_CNTROP_RESET		2
+
+/* Metadata extraction pseudo instructions
+ * This emulates the custom SiPANDA riscv instructions for metadata extractions,
+ * hence these are called pseudo instructions
+ */
+struct kparser_metadata_extract {
+	union {
+		struct {
+			__u32 code: 4;	// One of KPARSER_METADATA_* ops
+			__u32 frame: 1;	// Write to frame (true) else to meta
+			__u32 cntr: 3;	// Counter number
+			__u32 dst_off: 9; // Target offset in frame or meta
+			__u32 rsvd: 24;
+		} gen;
+		struct {
+			__u32 code: 4;	// One of KPARSER_METADATA_* ops
+			__u32 frame: 1;	// Write to frame (true) else to meta
+			__u32 cntr: 3;	// Counter number
+			__u32 dst_off: 9; // Target offset in frame or meta
+			__u32 e_bit: 1;	// Swap endianness (true)
+			__u32 src_off: 9; // Src offset in header
+			__u32 length: 5; // Byte length to read/write
+		} bytes;
+		struct {
+			__u32 code: 4;	// One of KPARSER_METADATA_* ops
+			__u32 frame: 1;	// Write to frame (true) else to meta
+			__u32 cntr: 3;	// Counter number
+			__u32 dst_off: 9; // Target offset in frame or meta
+			__u32 e_bit: 1;	// Swap endianness (true)
+			__u32 src_off: 10; // Src offset in header
+			__u32 length: 4; // Nibble length to read/write
+		} nibbs;
+		struct {
+			__u32 code: 4;	// One of KPARSER_METADATA_* ops
+			__u32 frame: 1;	// Write to frame (true) else to meta
+			__u32 cntr: 3;	// Counter number
+			__u32 dst_off: 9; // Target offset / 2 in frame or meta
+			__u32 rsvd: 7;
+			__u32 data: 8;	// Byte constant
+		} constant_byte;
+		struct {
+			__u32 code: 4;	// One of KPARSER_METADATA_* ops
+			__u32 frame: 1;	// Write to frame (true) else to meta
+			__u32 cntr: 3;	// Counter number
+			__u32 dst_off: 8; // Target offset / 2 in frame or meta
+			__u32 data: 16;	// Byte constant
+		} constant_hword;
+		struct {
+			__u32 code: 4;	// One of KPARSER_METADATA_* ops
+			__u32 frame: 1;	// Write to frame (true) else to meta
+			__u32 cntr: 3;	// Counter number
+			__u32 dst_off: 9; // Target offset in frame or meta
+			__u32 bit_offset: 1;
+			__u32 rsvd: 2;
+			__u32 add_off: 12; // 3 bits for bit offset
+		} offset;
+		struct {
+			__u32 code: 4;	// One of KPARSER_METADATA_* ops
+			__u32 frame: 1;	// Write to frame (true) else to meta
+			__u32 cntr: 3;	// Counter number
+			__u32 dst_off: 9; // Target offset in frame or meta
+			__u32 cntr_op: 3; // Counter operation
+			__u32 cntr_for_data: 3;
+			__u32 rsvd: 9;
+		} control;
+		struct {
+			__u32 code: 4;	// One of KPARSER_METADATA_* ops
+			__u32 frame: 1;	// Write to frame (true) else to meta
+			__u32 cntr: 3;	// Counter number
+			__u32 cntr_op: 3; // Counter operation
+			__u32 rsvd: 21;
+		} control_noop;
+		__u32 val;
+	};
+};
+
+/* Helper macros to make various pseudo instructions */
+
+#define __KPARSER_METADATA_MAKE_BYTES_EXTRACT(FRAME, SRC_OFF, DST_OFF, LEN, E_BIT, CNTR)	\
+{												\
+	.bytes.code = KPARSER_METADATA_BYTES_EXTRACT,						\
+	.bytes.frame = FRAME,									\
+	.bytes.src_off = SRC_OFF,								\
+	.bytes.dst_off = DST_OFF,								\
+	.bytes.length = LEN - 1, /* Minimum one byte */						\
+	.bytes.e_bit = E_BIT,									\
+	.bytes.cntr = CNTR,									\
+}
+
+static inline struct kparser_metadata_extract
+__kparser_metadata_make_bytes_extract(bool frame, size_t src_off,
+				      size_t dst_off, size_t len,
+				      bool e_bit,
+				      unsigned int cntr)
+{
+	const struct kparser_metadata_extract mde =
+		__KPARSER_METADATA_MAKE_BYTES_EXTRACT(frame, src_off,
+						      dst_off, len,
+						      e_bit, cntr);
+	return mde;
+}
+
+#define __KPARSER_METADATA_MAKE_NIBBS_EXTRACT(FRAME, NIBB_SRC_OFF,				\
+		DST_OFF, NIBB_LEN, E_BIT, CNTR)							\
+{												\
+	.nibbs.code = KPARSER_METADATA_NIBBS_EXTRACT,						\
+	.nibbs.frame = FRAME,									\
+	.nibbs.src_off = NIBB_SRC_OFF,								\
+	.nibbs.dst_off = DST_OFF,								\
+	.nibbs.length = NIBB_LEN - 1, /* Minimum one nibble */					\
+	.nibbs.e_bit = E_BIT,									\
+	.nibbs.cntr = CNTR,									\
+}
+
+static inline struct kparser_metadata_extract
+__kparser_make_make_nibbs_extract(bool frame, size_t nibb_src_off,
+				  size_t dst_off, size_t nibb_len,
+				  bool e_bit, unsigned int cntr)
+{
+	const struct kparser_metadata_extract mde =
+		__KPARSER_METADATA_MAKE_NIBBS_EXTRACT(frame, nibb_src_off,
+						      dst_off, nibb_len,
+						      e_bit, cntr);
+
+	return mde;
+}
+
+#define __KPARSER_METADATA_MAKE_SET_CONST_BYTE(FRAME, DST_OFF, DATA, CNTR)			\
+{												\
+	.constant_byte.code = KPARSER_METADATA_CONSTANT_BYTE_SET,				\
+	.constant_byte.frame = FRAME,								\
+	.constant_byte.dst_off = DST_OFF,							\
+	.constant_byte.data = DATA,								\
+	.constant_byte.cntr = CNTR,								\
+}
+
+static inline struct kparser_metadata_extract
+__kparser_metadata_set_const_byte(bool frame, size_t dst_off,
+				  __u8 data, unsigned int cntr)
+{
+	const struct kparser_metadata_extract mde =
+		__KPARSER_METADATA_MAKE_SET_CONST_BYTE(frame, dst_off,
+						       data, cntr);
+
+	return mde;
+}
+
+#define __KPARSER_METADATA_MAKE_SET_CONST_HALFWORD(FRAME, DST_OFF, DATA, CNTR)			\
+{												\
+	.constant_hword.code =									\
+	KPARSER_METADATA_CONSTANT_HWORD_SET,							\
+	.constant_hword.frame = FRAME,								\
+	.constant_hword.dst_off = DST_OFF,							\
+	.constant_hword.data = DATA,								\
+	.constant_hword.cntr = CNTR,								\
+}
+
+static inline struct kparser_metadata_extract
+__kparser_metadata_set_const_halfword(bool frame, size_t dst_off,
+				      __u16 data,
+				      unsigned int cntr)
+{
+	const struct kparser_metadata_extract mde =
+		__KPARSER_METADATA_MAKE_SET_CONST_HALFWORD(frame, dst_off,
+							   data, cntr);
+
+	return mde;
+}
+
+#define __KPARSER_METADATA_MAKE_OFFSET_SET(FRAME, DST_OFF, BIT_OFFSET, ADD_OFF, CNTR)		\
+{												\
+	.offset.code = KPARSER_METADATA_OFFSET_SET,						\
+	.offset.frame = FRAME,									\
+	.offset.dst_off = DST_OFF,								\
+	.offset.bit_offset = BIT_OFFSET,							\
+	.offset.add_off = ADD_OFF,								\
+	.offset.cntr = CNTR,									\
+}
+
+static inline struct kparser_metadata_extract
+__kparser_metadata_offset_set(bool frame, size_t dst_off,
+			      bool bit_offset, size_t add_off, unsigned int cntr)
+{
+	const struct kparser_metadata_extract mde =
+		__KPARSER_METADATA_MAKE_OFFSET_SET(frame, dst_off,
+						   bit_offset, add_off, cntr);
+	return mde;
+}
+
+#define __KPARSER_METADATA_MAKE_SET_CONTROL_COUNTER(FRAME, DST_OFF, CNTR_DATA, CNTR, CNTR_OP)	\
+{												\
+	.control.code = KPARSER_METADATA_CTRL_COUNTER,						\
+	.control.frame = FRAME,									\
+	.control.dst_off = DST_OFF,								\
+	.control.cntr = CNTR,									\
+	.control.cntr_op = CNTR_OP,								\
+	.control.cntr_for_data = CNTR_DATA,							\
+}
+
+static inline struct kparser_metadata_extract
+__kparser_metadata_set_control_counter(bool frame, size_t dst_off,
+				       unsigned int cntr_data,
+		unsigned int cntr,
+		unsigned int cntr_op)
+{
+	const struct kparser_metadata_extract mde =
+		__KPARSER_METADATA_MAKE_SET_CONTROL_COUNTER(frame,
+							    dst_off, cntr_data, cntr,
+							    cntr_op);
+	return mde;
+}
+
+#define __KPARSER_METADATA_MAKE_SET_CONTROL(FRAME, CODE, DST_OFF, CNTR, CNTR_OP)		\
+{												\
+	.control.code = CODE,									\
+	.control.frame = FRAME,									\
+	.control.dst_off = DST_OFF,								\
+	.control.cntr = CNTR,									\
+	.control.cntr_op = CNTR_OP,								\
+}
+
+static inline struct kparser_metadata_extract
+__kparser_metadata_set_control(bool frame, unsigned int code,
+			       size_t dst_off, unsigned int cntr,
+			       unsigned int cntr_op)
+{
+	const struct kparser_metadata_extract mde =
+		__KPARSER_METADATA_MAKE_SET_CONTROL(frame, code, dst_off,
+						    cntr, cntr_op);
+	return mde;
+}
+
+struct kparser_metadata_table {
+	int num_ents;
+	struct kparser_metadata_extract *entries;
+};
+
+/* Extract functions */
+static inline int __kparser_metadata_bytes_extract(const __u8 *sptr,
+						   __u8 *dptr, size_t length, bool e_bit)
+{
+	__u16 v16;
+	__u32 v32;
+	__u64 v64;
+	int i;
+
+	if (!dptr)
+		return KPARSER_OKAY;
+
+	switch (length) {
+	case sizeof(__u8):
+		*dptr = *sptr;
+		break;
+	case sizeof(__u16):
+		v16 = *(__u16 *)sptr;
+		*((__u16 *)dptr) = e_bit ? ntohs(v16) : v16;
+		break;
+	case sizeof(__u32):
+		v32 = *(__u32 *)sptr;
+		*((__u32 *)dptr) = e_bit ? ntohl(v32) : v32;
+		break;
+	case sizeof(__u64):
+		v64 = *(__u64 *)sptr;
+		*((__u64 *)dptr) = e_bit ? kparser_ntohll(v64) : v64;
+		break;
+	default:
+		if (e_bit) {
+			for (i = 0; i < length; i++)
+				dptr[i] = sptr[length - 1 - i];
+		} else {
+			memcpy(dptr, sptr, length);
+		}
+	}
+
+	return KPARSER_OKAY;
+}
+
+static inline void *metadata_get_dst(size_t dst_off, void *mdata)
+{
+	return &((__u8 *)mdata)[dst_off];
+}
+
+static inline bool __metatdata_validate_counter(const struct kparser_parser *parser,
+						unsigned int cntr)
+{
+	if (!parser) {
+		pr_warn("Metadata counter is set for extraction but no parser is set");
+		return false;
+	}
+
+	if (!parser->cntrs) {
+		pr_warn("Metadata counter is set but no counters are configured for parser");
+		return false;
+	}
+
+	if (cntr >= KPARSER_CNTR_NUM_CNTRS) {
+		pr_warn("Metadata counter %u is greater than maximum %u",
+			cntr, KPARSER_CNTR_NUM_CNTRS);
+		return false;
+	}
+
+	return true;
+}
+
+static inline void *metadata_get_dst_cntr(const struct kparser_parser *parser,
+					  size_t dst_off, void *mdata,
+		unsigned int cntr, int code)
+{
+	const struct kparser_cntr_conf *cntr_conf;
+	__u8 *dptr = &((__u8 *)mdata)[dst_off];
+	size_t step;
+
+	if (!cntr)
+		return dptr;
+
+	cntr--; // Make zero based to access array
+
+	if (!__metatdata_validate_counter(parser, cntr))
+		return dptr;
+
+	cntr_conf = &parser->cntrs_conf.cntrs[cntr];
+
+	if (code != KPARSER_METADATA_CTRL_COUNTER) {
+		if (parser->cntrs->cntr[cntr] >= cntr_conf->array_limit) {
+			if (!cntr_conf->array_limit ||
+			    !cntr_conf->overwrite_last)
+				return NULL;
+			step = cntr_conf->array_limit - 1;
+		} else {
+			step = parser->cntrs->cntr[cntr];
+		}
+
+		dptr += cntr_conf->el_size * step;
+	}
+
+	return dptr;
+}
+
+static inline int __metadata_cntr_operation(const struct kparser_parser *parser,
+					    unsigned int operation, unsigned int cntr)
+{
+	/* cntr 0 means no counter attached, the index starts from 1 in this case
+	 */
+	if (!cntr)
+		return KPARSER_OKAY;
+
+	cntr--; /* Make zero based to access array */
+
+	if (!__metatdata_validate_counter(parser, cntr))
+		return KPARSER_STOP_BAD_CNTR;
+
+	switch (operation) {
+	default:
+	case KPARSER_METADATA_CNTROP_NULL:
+		break;
+	case KPARSER_METADATA_CNTROP_INCREMENT:
+		/* Note: parser is const but
+		 * parser->cntrs->cntr is writable
+		 */
+		if (parser->cntrs->cntr[cntr] <
+		    parser->cntrs_conf.cntrs[cntr].max_value)
+			parser->cntrs->cntr[cntr]++;
+		else if (parser->cntrs_conf.cntrs[cntr].error_on_exceeded)
+			return KPARSER_STOP_CNTR1 - cntr;
+		break;
+	case KPARSER_METADATA_CNTROP_RESET:
+		parser->cntrs->cntr[cntr] = 0;
+		break;
+	}
+
+	return KPARSER_OKAY;
+}
+
+static inline int kparser_metadata_bytes_extract(const struct kparser_parser *parser,
+						 struct kparser_metadata_extract mde,
+						 const void *hdr, void *mdata)
+{
+	__u8 *dptr = metadata_get_dst_cntr(parser, mde.bytes.dst_off, mdata,
+			mde.bytes.cntr, 0);
+	const __u8 *sptr = &((__u8 *)hdr)[mde.bytes.src_off];
+
+	if (!dptr)
+		return KPARSER_OKAY;
+
+	return __kparser_metadata_bytes_extract(sptr, dptr,
+			mde.bytes.length + 1,
+			mde.bytes.e_bit);
+}
+
+static inline int kparser_metadata_nibbs_extract(const struct kparser_parser *parser,
+						 struct kparser_metadata_extract mde,
+						 const void *hdr, void *mdata)
+{
+	__u8 *dptr = metadata_get_dst_cntr(parser, mde.nibbs.dst_off, mdata,
+			mde.nibbs.cntr, 0);
+	const __u8 *sptr = &((__u8 *)hdr)[mde.nibbs.src_off / 2];
+	size_t nibb_len = mde.nibbs.length + 1;
+	__u8 data;
+	int i;
+
+	if (!dptr)
+		return KPARSER_OKAY;
+
+	if (mde.nibbs.src_off % 2 == 0 && nibb_len % 2 == 0) {
+		/* This is effectively a byte transfer case */
+
+		return __kparser_metadata_bytes_extract(sptr, dptr,
+				mde.nibbs.length / 2,
+				mde.nibbs.e_bit);
+	}
+
+	if (mde.nibbs.e_bit) {
+		/* Endianness bit is set. dlen is the number of bytes
+		 * set for output
+		 */
+		size_t dlen = (nibb_len + 1) / 2;
+
+		if (mde.nibbs.src_off % 2) {
+			/* Starting from the odd nibble */
+			if (nibb_len % 2) {
+				/* Odd length and odd start nibble offset. Set
+				 * the reverse of all the bytes after the first
+				 * nibble, and * construct the last byte from
+				 * the low order nibble of the first input byte
+				 */
+				for (i = 0; i < dlen - 1; i++)
+					dptr[i] = sptr[dlen - 1 - i];
+				dptr[i] = sptr[0] & 0xf;
+			} else {
+				/* Even length and n-bit is set. Logically
+				 * shift all the nibbles in the string left and
+				 * then set the reversed bytes.
+				 */
+
+				/* High order nibble of last byte becomes
+				 * low order nibble of first output byte
+				 */
+				data = sptr[dlen] >> 4;
+
+				for (i = 0; i < dlen - 1; i++) {
+					/* Construct intermediate bytes. data
+					 * contains the input high order nibble
+					 * of the next input byte shifted right.
+					 * That value is or'ed with the shifted
+					 * left low order nibble of the current
+					 * byte. The result is set in the
+					 * reversed position in the output
+					 */
+					dptr[i] = data |
+						sptr[dlen - 1 - i] << 4;
+
+					/* Get the next data value */
+					data = sptr[dlen - 1 - i] >> 4;
+				}
+				/* Set the last byte as the or of the last
+				 * data value and the low order nibble of the
+				 * zeroth byte of the input shifted left
+				 */
+				dptr[i] = data | sptr[0] << 4;
+			}
+		} else {
+			/* Odd length (per check above) and n-bit is not
+			 * set. Logically shift all the nibbles in the
+			 * string right and then set the reversed bytes
+			 */
+
+			/* High order nibble of last byte becomes
+			 * low order nibble of first output byte
+			 */
+			data = sptr[dlen - 1] >> 4;
+
+			for (i = 0; i < dlen - 1; i++) {
+				/* Construct intermediate bytes. data contains
+				 * the input high order nibble of the next
+				 * input byte shifted right. That value is
+				 * or'ed with the shifted left low order nibble
+				 * of the current byte. The result is set in the
+				 * reversed position in the output
+				 */
+				dptr[i] = data | sptr[dlen - 2 - i] << 4;
+
+				/* Get next data value */
+				data = sptr[dlen - 2 - i] >> 4;
+			}
+
+			/* Last output byte is set to high oder nibble of first
+			 * input byte shifted right
+			 */
+			dptr[i] = data;
+		}
+	} else {
+		/* No e-bit (no endiannes) */
+
+		size_t byte_len;
+		int ind = 0;
+
+		if (mde.nibbs.src_off % 2) {
+			/* Starting from the odd nibble. Set first output byte
+			 * to masked low order nibble of first input byte
+			 */
+			dptr[0] = sptr[0] & 0xf;
+			ind = 1;
+			nibb_len--;
+		}
+
+		/* Copy all the whole intermediate bytes */
+		byte_len = nibb_len / 2;
+		memcpy(&dptr[ind], &sptr[ind], byte_len);
+
+		if (nibb_len % 2) {
+			/* Have an odd nibble at the endian. Set the last
+			 * output byte to the mask high order nibble of the
+			 * last input byte
+			 */
+			dptr[ind + byte_len] = sptr[ind + byte_len] & 0xf0;
+		}
+	}
+
+	return KPARSER_OKAY;
+}
+
+static inline int kparser_metadata_const_set_byte(const struct kparser_parser *parser,
+						  struct kparser_metadata_extract mde,
+						  void *mdata)
+{
+	__u16 *dptr = metadata_get_dst_cntr(parser, mde.constant_byte.dst_off,
+			mdata, mde.constant_byte.cntr, 0);
+
+	if (dptr)
+		*dptr = mde.constant_byte.data;
+
+	return KPARSER_OKAY;
+}
+
+static inline int kparser_metadata_const_set_hword(const struct kparser_parser *parser,
+						   struct kparser_metadata_extract mde,
+						   void *mdata)
+{
+	__u16 *dptr = metadata_get_dst_cntr(parser, mde.constant_hword.dst_off,
+			mdata, mde.constant_hword.cntr, 0);
+
+	if (dptr)
+		*dptr = mde.constant_hword.data;
+
+	return KPARSER_OKAY;
+}
+
+static inline int kparser_metadata_set_offset(const struct kparser_parser *parser,
+					      struct kparser_metadata_extract mde,
+					      void *mdata, size_t hdr_offset)
+{
+	__u16 *dptr = metadata_get_dst_cntr(parser, mde.offset.dst_off, mdata,
+			mde.offset.cntr, 0);
+
+	if (dptr) {
+		*dptr = mde.offset.bit_offset ?
+			8 * hdr_offset + mde.offset.add_off :
+			hdr_offset + mde.offset.add_off;
+	}
+
+	return KPARSER_OKAY;
+}
+
+static inline int __kparser_metadata_control_extract(const struct kparser_parser *parser,
+						     const struct kparser_metadata_extract mde,
+						     const void *_hdr, size_t hdr_len,
+						     size_t hdr_offset, void *mdata,
+						     const struct kparser_ctrl_data *ctrl)
+{
+	__u16 *dptr = metadata_get_dst_cntr(parser, mde.control.dst_off, mdata,
+			mde.control.cntr, mde.control.code);
+
+	switch (mde.control.code) {
+	case KPARSER_METADATA_CTRL_HDR_LENGTH:
+		if (dptr)
+			*((__u16 *)dptr) = hdr_len;
+		break;
+	case KPARSER_METADATA_CTRL_NUM_NODES:
+		if (dptr)
+			*((__u16 *)dptr) = ctrl->node_cnt;
+		break;
+	case KPARSER_METADATA_CTRL_NUM_ENCAPS:
+		if (dptr)
+			*((__u16 *)dptr) = ctrl->encap_levels;
+		break;
+	case KPARSER_METADATA_CTRL_TIMESTAMP:
+		/* TODO */
+		break;
+	case KPARSER_METADATA_CTRL_COUNTER:
+		if (!__metatdata_validate_counter(parser,
+						  mde.control.cntr_for_data))
+			return KPARSER_STOP_BAD_CNTR;
+		if (dptr)
+			*(__u16 *)dptr = parser->cntrs->cntr[mde.control.cntr_for_data - 1];
+		break;
+	case KPARSER_METADATA_CTRL_RET_CODE:
+		if (dptr)
+			*((int *)dptr) = ctrl->ret;
+		break;
+	case KPARSER_METADATA_CTRL_NOOP:
+		break;
+	default:
+		pr_debug("Unknown extract\n");
+		return KPARSER_STOP_BAD_EXTRACT;
+	}
+
+	return __metadata_cntr_operation(parser, mde.control.cntr_op,
+			mde.control.cntr);
+}
+
+/* Front end functions to process one metadata extraction pseudo instruction
+ * in the context of parsing a packet
+ */
+static inline int kparser_metadata_extract(const struct kparser_parser *parser,
+					   const struct kparser_metadata_extract mde,
+					   const void *_hdr, size_t hdr_len,
+					   size_t hdr_offset, void *_metadata,
+					   void *_frame,
+					   const struct kparser_ctrl_data *ctrl)
+{
+	void *mdata = mde.gen.frame ? _frame : _metadata;
+	int ret;
+
+	switch (mde.gen.code) {
+	case KPARSER_METADATA_BYTES_EXTRACT:
+		ret = kparser_metadata_bytes_extract(parser, mde,
+						     _hdr, mdata);
+		break;
+	case KPARSER_METADATA_NIBBS_EXTRACT:
+		ret = kparser_metadata_nibbs_extract(parser, mde,
+						     _hdr, mdata);
+		break;
+	case KPARSER_METADATA_CONSTANT_BYTE_SET:
+		ret = kparser_metadata_const_set_byte(parser, mde,
+						      mdata);
+		break;
+	case KPARSER_METADATA_CONSTANT_HWORD_SET:
+		ret = kparser_metadata_const_set_hword(parser, mde,
+						       mdata);
+		break;
+	case KPARSER_METADATA_OFFSET_SET:
+		ret = kparser_metadata_set_offset(parser, mde, mdata,
+						  hdr_offset);
+		break;
+	default: /* Should be a control metadata extraction */
+		ret = __kparser_metadata_control_extract(parser, mde,
+							 _hdr,
+							 hdr_len,
+							 hdr_offset,
+							 mdata, ctrl);
+	}
+
+	return ret;
+}
+
+static inline bool kparser_metadata_convert(const struct kparser_conf_metadata *conf,
+					    struct kparser_metadata_extract *mde, int cntridx)
+{
+	__u32 encoding_type;
+
+	switch (conf->type) {
+	case KPARSER_METADATA_HDRDATA:
+		*mde = __kparser_metadata_make_bytes_extract(conf->frame,
+							     conf->soff, conf->doff, conf->len,
+							     conf->e_bit, cntridx);
+		return true;
+
+	case KPARSER_METADATA_HDRDATA_NIBBS_EXTRACT:
+		*mde = __kparser_make_make_nibbs_extract(conf->frame,
+							 conf->soff,
+							 conf->doff,
+							 conf->len,
+							 conf->e_bit,
+							 cntridx);
+		return true;
+
+	case KPARSER_METADATA_BIT_OFFSET:
+		*mde =	__kparser_metadata_offset_set(conf->frame,
+						      conf->doff,
+						      true,
+						      conf->add_off,
+						      cntridx);
+		return true;
+
+	case KPARSER_METADATA_OFFSET:
+		*mde =	__kparser_metadata_offset_set(conf->frame,
+						      conf->doff,
+						      false,
+						      conf->add_off,
+						      cntridx);
+		return true;
+
+	case KPARSER_METADATA_CONSTANT_BYTE:
+		*mde =	__kparser_metadata_set_const_byte(conf->frame,
+							  conf->doff, conf->constant_value,
+				cntridx);
+		return true;
+
+	case KPARSER_METADATA_CONSTANT_HALFWORD:
+		*mde =	__kparser_metadata_set_const_halfword(conf->frame,
+							      conf->doff, conf->constant_value,
+				cntridx);
+		return true;
+
+	case KPARSER_METADATA_COUNTER:
+		*mde = __kparser_metadata_set_control_counter(conf->frame, conf->doff,
+							      cntridx, cntridx,
+							      conf->cntr_op);
+		return true;
+
+	case KPARSER_METADATA_HDRLEN:
+		encoding_type = KPARSER_METADATA_CTRL_HDR_LENGTH;
+		break;
+
+	case KPARSER_METADATA_NUMENCAPS:
+		encoding_type = KPARSER_METADATA_CTRL_NUM_ENCAPS;
+		break;
+
+	case KPARSER_METADATA_NUMNODES:
+		encoding_type = KPARSER_METADATA_CTRL_NUM_NODES;
+		break;
+
+	case KPARSER_METADATA_TIMESTAMP:
+		encoding_type = KPARSER_METADATA_CTRL_TIMESTAMP;
+		break;
+
+	case KPARSER_METADATA_RETURN_CODE:
+		encoding_type = KPARSER_METADATA_CTRL_RET_CODE;
+		break;
+
+	case KPARSER_METADATA_COUNTEROP_NOOP:
+		encoding_type = KPARSER_METADATA_CTRL_NOOP;
+		break;
+
+	default:
+		return false;
+	}
+
+	*mde = __kparser_metadata_set_control(conf->frame, encoding_type, conf->doff,
+					      conf->cntr, conf->cntr_op);
+
+	return true;
+}
+
+#endif /* __KPARSER_METAEXTRACT_H__ */
diff --git a/net/kparser/kparser_types.h b/net/kparser/kparser_types.h
new file mode 100644
index 000000000000..e957c556e012
--- /dev/null
+++ b/net/kparser/kparser_types.h
@@ -0,0 +1,586 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2022, SiPanda Inc.
+ *
+ * kparser_types.h - kParser private data types header file
+ *
+ * Authors:     Tom Herbert <tom@sipanda.io>
+ *              Pratyush Kumar Khan <pratyush@sipanda.io>
+ */
+
+#ifndef __KPARSER_TYPES_H
+#define __KPARSER_TYPES_H
+
+#include <linux/hash.h>
+#include <linux/kparser.h>
+#include <linux/kref.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/rcupdate.h>
+#include <linux/rhashtable-types.h>
+#include <linux/skbuff.h>
+#include <linux/xxhash.h>
+
+/* Sign extend an returned signed value */
+#define KPARSER_EXTRACT_CODE(X) ((__s64)(short)(X))
+#define KPARSER_IS_RET_CODE(X) (KPARSER_EXTRACT_CODE(X) < 0)
+#define KPARSER_IS_NOT_OK_CODE(X) (KPARSER_EXTRACT_CODE(X) <= KPARSER_STOP_FAIL)
+#define KPARSER_IS_OK_CODE(X)						\
+	(KPARSER_IS_RET_CODE(X) && KPARSER_EXTRACT_CODE(X) > KPARSER_STOP_FAIL)
+
+/* A table of conditional expressions, type indicates that the expressions
+ * are or'ed of and'ed
+ */
+struct kparser_condexpr_table {
+	int default_fail;
+	enum kparser_condexpr_types type;
+	unsigned int num_ents;
+	const struct kparser_condexpr_expr __rcu **entries;
+};
+
+/* A table of tables of conditional expressions. This is used to create more
+ * complex expressions using and's and or's
+ */
+struct kparser_condexpr_tables {
+	unsigned int num_ents;
+	const struct kparser_condexpr_table __rcu **entries;
+};
+
+/* Control data describing various values produced while parsing. This is
+ * used an argument to metadata extraction and handler functions
+ */
+struct kparser_ctrl_data {
+	int ret;
+	size_t pkt_len;
+	void *hdr_base;
+	unsigned int node_cnt;
+	unsigned int encap_levels;
+};
+
+/*****************************************************************************/
+
+/* Protocol parsing operations:
+ *
+ * Operations can be specified either as a function or a parameterization
+ * of a parameterized function
+ *
+ * len: Return length of protocol header. If value is NULL then the length of
+ *	the header is taken from the min_len in the protocol node. If the
+ *	return value < 0 (a KPARSER_STOP_* return code value) this indicates an
+ *	error and parsing is stopped. A the return value greater than or equal
+ *	to zero then gives the protocol length. If the returned length is less
+ *	than the minimum protocol length, indicated in min_len by the protocol
+ *	node, then this considered and error.
+ * next_proto: Return next protocol. If value is NULL then there is no
+ *	next protocol. If return value is greater than or equal to zero
+ *	this indicates a protocol number that is used in a table lookup
+ *	to get the next layer protocol node.
+ * cond_exprs: Parameterization only. This describes a set of conditionals
+ *	check before proceeding. In the case of functions being used, these
+ *	conditionals would be in the next_proto or length function
+ */
+
+struct kparser_parse_ops {
+	bool flag_fields_length;
+	bool len_parameterized;
+	struct kparser_parameterized_len pflen;
+	struct kparser_parameterized_next_proto pfnext_proto;
+	bool cond_exprs_parameterized;
+	struct kparser_condexpr_tables cond_exprs;
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
+struct kparser_proto_node {
+	__u8 encap;
+	__u8 overlay;
+	size_t min_len;
+	struct kparser_parse_ops ops;
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
+/* One entry in a protocol table:
+ *	value: protocol number
+ *	node: associated parse node for the protocol number
+ */
+struct kparser_proto_table_entry {
+	int value;
+	bool encap;
+	const struct kparser_parse_node __rcu *node;
+};
+
+/* Protocol table
+ *
+ * Contains a protocol table that maps a protocol number to a parse
+ * node
+ */
+struct kparser_proto_table {
+	int num_ents;
+	struct kparser_proto_table_entry __rcu *entries;
+};
+
+/*****************************************************************************/
+
+struct kparser_cntrs_conf {
+	struct kparser_cntr_conf cntrs[KPARSER_CNTR_NUM_CNTRS];
+};
+
+struct kparser_counters {
+	__u16 cntr[KPARSER_CNTR_NUM_CNTRS];
+};
+
+/*****************************************************************************/
+
+/* Definitions for parsing TLVs
+ *
+ * Operations can be specified either as a function or a parameterization
+ * of a parameterized function
+ *
+ * TLVs are a common protocol header structure consisting of Type, Length,
+ * Value tuple (e.g. for handling TCP or IPv6 HBH options TLVs)
+ */
+
+/* Descriptor for parsing operations of one type of TLV. Fields are:
+ * For struct kparser_proto_tlvs_opts:
+ * start_offset: Returns the offset of TLVs in a header
+ * len: Return length of a TLV. Must be set. If the return value < 0 (a
+ *	KPARSER_STOP_* return code value) this indicates an error and parsing
+ *	is stopped. A the return value greater than or equal to zero then
+ *	gives the protocol length. If the returned length is less than the
+ *	minimum TLV option length, indicated by min_len by the TLV protocol
+ *	node, then this considered and error.
+ * type: Return the type of the TLV. If the return value is less than zero
+ *	(KPARSER_STOP_* value) then this indicates and error and parsing stops
+ */
+
+/* A protocol node for parsing proto with TLVs
+ *
+ * proto_node: proto node
+ * ops: Operations for parsing TLVs
+ * start_offset: When there TLVs start relative the enapsulating protocol
+ *	(e.g. would be twenty for TCP)
+ * pad1_val: Type value indicating one byte of TLV padding (e.g. would be
+ *	for IPv6 HBH TLVs)
+ * pad1_enable: Pad1 value is used to detect single byte padding
+ * eol_val: Type value that indicates end of TLV list
+ * eol_enable: End of list value in eol_val is used
+ * fixed_start_offset: Take start offset from start_offset
+ * min_len: Minimal length of a TLV option
+ */
+struct kparser_proto_tlvs_node {
+	struct kparser_proto_node proto_node;
+	struct kparser_proto_tlvs_opts ops;
+	size_t start_offset;
+	__u8 pad1_val;
+	__u8 padn_val;
+	__u8 eol_val;
+	bool pad1_enable;
+	bool padn_enable;
+	bool eol_enable;
+	bool fixed_start_offset;
+	size_t min_len;
+};
+
+/*****************************************************************************/
+
+/* Definitions and functions for processing and parsing flag-fields */
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
+ * A set of flag-fields is defined in a table of type struct kparser_flag_fields.
+ * Each entry in the table is a descriptor for one flag-field in a protocol and
+ * includes a flag value, mask (for the case of a multi-bit flag), and size of
+ * the cooresponding field. A flag is matched if "(flags & mask) == flag"
+ */
+
+/* Descriptor for a protocol field with flag fields
+ *
+ * Defines the flags and their data fields for one instance a flag field in
+ * a protocol header (e.g. GRE v0 flags):
+ *
+ * num_idx: Number of flag_field structures
+ * fields: List of defined flag fields
+ */
+struct kparser_flag_fields {
+	size_t num_idx;
+	struct kparser_flag_field __rcu *fields;
+};
+
+/* Structure or parsing operations for flag-fields
+ * For struct kparser_proto_flag_fields_ops
+ * Operations can be specified either as a function or a parameterization
+ * of a parameterized function
+ *
+ * flags_offset: Offset of flags in the protocol header
+ * start_fields_offset: Return the offset in the header of the start of the
+ *	flag fields data
+ */
+
+/* A flag-fields protocol node. Note this is a super structure for aKPARSER
+ * protocol node and type is KPARSER_NODE_TYPE_FLAG_FIELDS
+ */
+struct kparser_proto_flag_fields_node {
+	struct kparser_proto_node proto_node;
+	struct kparser_proto_flag_fields_ops ops;
+	const struct kparser_flag_fields __rcu *flag_fields;
+};
+
+/*****************************************************************************/
+
+/* Parse node definition. Defines parsing and processing for one node in
+ * the parse graph of a parser. Contains:
+ *
+ * node_type: The type of the node (plain, TLVs, flag-fields)
+ * unknown_ret: Code to return for a miss on the protocol table and the
+ *	wildcard node is not set
+ * proto_node: Protocol node
+ * ops: Parse node operations
+ * proto_table: Protocol table for next protocol. This must be non-null if
+ *	next_proto is not NULL
+ * wildcard_node: Node use for a miss on next protocol lookup
+ * metadata_table: Table of parameterized metadata operations
+ * thread_funcs: Thread functions
+ */
+struct kparser_parse_node {
+	enum kparser_node_type node_type;
+	char name[KPARSER_MAX_NAME];
+	int unknown_ret;
+	const struct kparser_proto_table __rcu *proto_table;
+	const struct kparser_parse_node __rcu *wildcard_node;
+	const struct kparser_metadata_table __rcu *metadata_table;
+	union {
+		struct kparser_proto_node proto_node;
+		struct kparser_proto_tlvs_node tlvs_proto_node;
+		struct kparser_proto_flag_fields_node flag_fields_proto_node;
+	};
+};
+
+/*****************************************************************************/
+
+/* TLV parse node operations
+ *
+ * Operations to process a single TLV
+ *
+ * Operations can be specified either as a function or a parameterization
+ * of a parameterized function
+ *
+ * extract_metadata: Extract metadata for the node. Input is the meta
+ *	data frame which points to a parser defined metadata structure.
+ *	If the value is NULL then no metadata is extracted
+ * handle_tlv: Per TLV type handler which allows arbitrary processing
+ *	of a TLV. Input is the TLV data and a parser defined metadata
+ *	structure for the current frame. Return value is a parser
+ *	return code: KPARSER_OKAY indicates no errors, KPARSER_STOP* return
+ *	values indicate to stop parsing
+ * check_tlv: Function to validate a TLV
+ * cond_exprs: Parameterization of a set of conditionals to check before
+ *	proceeding. In the case of functions being used, these
+ *      conditionals would be in the check_tlv function
+ */
+
+/* One entry in a TLV table:
+ *	type: TLV type
+ *	node: associated TLV parse structure for the type
+ */
+struct kparser_proto_tlvs_table_entry {
+	int type;
+	const struct kparser_parse_tlv_node __rcu *node;
+};
+
+/* TLV table
+ *
+ * Contains a table that maps a TLV type to a TLV parse node
+ */
+struct kparser_proto_tlvs_table {
+	int num_ents;
+	struct kparser_proto_tlvs_table_entry __rcu *entries;
+};
+
+/* Parse node for parsing a protocol header that contains TLVs to be
+ * parser:
+ *
+ * parse_node: Node for main protocol header (e.g. IPv6 node in case of HBH
+ *	options) Note that node_type is set in parse_node to
+ *	KPARSER_NODE_TYPE_TLVS and that the parse node can then be cast to a
+ *	parse_tlv_node
+ * tlv_proto_table: Lookup table for TLV type
+ * unknown_tlv_type_ret: Code to return on a TLV type lookup miss and
+ *	tlv_wildcard_node is NULL
+ * tlv_wildcard_node: Node to use on a TLV type lookup miss
+ * config: Loop configuration
+ */
+struct kparser_parse_tlvs_node {
+	struct kparser_parse_node parse_node;
+	const struct kparser_proto_tlvs_table __rcu *tlv_proto_table;
+	int unknown_tlv_type_ret;
+	const struct kparser_parse_tlv_node __rcu *tlv_wildcard_node;
+	struct kparser_loop_node_config config;
+};
+
+struct kparser_proto_tlv_node_ops {
+	bool overlay_type_parameterized;
+	struct kparser_parameterized_next_proto pfoverlay_type;
+	bool cond_exprs_parameterized;
+	struct kparser_condexpr_tables cond_exprs;
+};
+
+/* A protocol node for parsing proto with TLVs
+ *
+ * min_len: Minimal length of TLV
+ * max_len: Maximum size of a TLV option
+ * is_padding: Indicates padding TLV
+ */
+struct kparser_proto_tlv_node {
+	size_t min_len;
+	size_t max_len;
+	bool is_padding;
+	struct kparser_proto_tlv_node_ops ops;
+};
+
+/* Parse node for a single TLV. Use common parse node operations
+ * (extract_metadata and handle_proto)
+ *
+ * proto_tlv_node: TLV protocol node
+ * tlv_ops: Operations on a TLV
+ * overlay_table: Lookup table for an overlay TLV
+ * overlay_wildcard_node: Wildcard node to an overlay lookup miss
+ * unknown_overlay_ret: Code to return on an overlay lookup miss and
+ *	overlay_wildcard_node is NULL
+ * name: Name for debugging
+ * metadata_table: Table of parameterized metadata operations
+ * thread_funcs: Thread functions
+ */
+struct kparser_parse_tlv_node {
+	struct kparser_proto_tlv_node proto_tlv_node;
+	struct kparser_proto_tlvs_table __rcu *overlay_table;
+	const struct kparser_parse_tlv_node __rcu *overlay_wildcard_node;
+	int unknown_overlay_ret;
+	char name[KPARSER_MAX_NAME];
+	struct kparser_metadata_table __rcu *metadata_table;
+};
+
+/*****************************************************************************/
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
+ *	return code: KPARSER_OKAY indicates no errors, KPARSER_STOP* return
+ *	values indicate to stop parsing
+ * check_flag_field: Function to validate a flag-field
+ * cond_exprs: Parameterization of a set of conditionals to check before
+ *      proceeding. In the case of functions being used, these
+ *      conditionals would be in the check_flag_field function
+ */
+struct kparser_parse_flag_field_node_ops {
+	struct kparser_condexpr_tables cond_exprs;
+};
+
+/* A parse node for a single flag field
+ *
+ * name: Text name for debugging
+ * metadata_table: Table of parameterized metadata operations
+ * ops: Operations
+ * thread_funcs: Thread functions
+ */
+struct kparser_parse_flag_field_node {
+	char name[KPARSER_MAX_NAME];
+	struct kparser_metadata_table __rcu *metadata_table;
+	struct kparser_parse_flag_field_node_ops ops;
+};
+
+/* One entry in a flag-fields protocol table:
+ *	index: flag-field index (index in a flag-fields table)
+ *	node: associated TLV parse structure for the type
+ */
+struct kparser_proto_flag_fields_table_entry {
+	__u32 flag;
+	const struct kparser_parse_flag_field_node __rcu *node;
+};
+
+/* Flag-fields table
+ *
+ * Contains a table that maps a flag-field index to a flag-field parse node.
+ * Note that the index correlates to an entry in a flag-fields table that
+ * describes the flag-fields of a protocol
+ */
+struct kparser_proto_flag_fields_table {
+	int num_ents;
+	struct kparser_proto_flag_fields_table_entry __rcu *entries;
+};
+
+/* A flag-fields parse node. Note this is a super structure for a KPARSER parse
+ * node and type is KPARSER_NODE_TYPE_FLAG_FIELDS
+ */
+struct kparser_parse_flag_fields_node {
+	struct kparser_parse_node parse_node;
+	const struct kparser_proto_flag_fields_table __rcu
+		*flag_fields_proto_table;
+};
+
+static inline ssize_t __kparser_flag_fields_offset(__u32 targ_idx, __u32 flags,
+						   const struct kparser_flag_fields *flag_fields)
+{
+	ssize_t offset = 0;
+	__u32 mask, flag;
+	int i;
+
+	for (i = 0; i < targ_idx; i++) {
+		flag = flag_fields->fields[i].flag;
+		if (flag_fields->fields[i].endian)
+			flag = ntohs(flag);
+		mask = flag_fields->fields[i].mask ? : flag;
+		if ((flags & mask) == flag)
+			offset += flag_fields->fields[i].size;
+	}
+
+	return offset;
+}
+
+/* Determine offset of a field given a set of flags */
+static inline ssize_t kparser_flag_fields_offset(__u32 targ_idx, __u32 flags,
+						 const struct kparser_flag_fields *flag_fields)
+{
+	__u32 mask, flag;
+
+	flag = flag_fields->fields[targ_idx].flag;
+	if (flag_fields->fields[targ_idx].endian)
+		flag = ntohs(flag);
+	mask = flag_fields->fields[targ_idx].mask ? : flag;
+	if ((flags & mask) != flag) {
+		/* Flag not set */
+		return -1;
+	}
+
+	return __kparser_flag_fields_offset(targ_idx, flags, flag_fields);
+}
+
+/* Check flags are legal */
+static inline bool kparser_flag_fields_check_invalid(__u32 flags, __u32 mask)
+{
+	return !!(flags & ~mask);
+}
+
+/* Retrieve a byte value from a flag field */
+static inline __u8 kparser_flag_fields_get8(const __u8 *fields, __u32 targ_idx,
+					    __u32 flags,
+					    const struct kparser_flag_fields
+					    *flag_fields)
+{
+	ssize_t offset = kparser_flag_fields_offset(targ_idx, flags,
+			flag_fields);
+
+	if (offset < 0)
+		return 0;
+
+	return *(__u8 *)&fields[offset];
+}
+
+/* Retrieve a short value from a flag field */
+static inline __u16 kparser_flag_fields_get16(const __u8 *fields,
+					      __u32 targ_idx,
+		__u32 flags,
+		const struct kparser_flag_fields
+		*flag_fields)
+{
+	ssize_t offset = kparser_flag_fields_offset(targ_idx, flags, flag_fields);
+
+	if (offset < 0)
+		return 0;
+
+	return *(__u16 *)&fields[offset];
+}
+
+/* Retrieve a 32 bit value from a flag field */
+static inline __u32 kparser_get_flag_field32(const __u8 *fields, __u32 targ_idx,
+					     __u32 flags,
+		const struct kparser_flag_fields
+		*flag_fields)
+{
+	ssize_t offset = kparser_flag_fields_offset(targ_idx, flags, flag_fields);
+
+	if (offset < 0)
+		return 0;
+
+	return *(__u32 *)&fields[offset];
+}
+
+/* Retrieve a 64 bit value from a flag field */
+static inline __u64 kparser_get_flag_field64(const __u8 *fields, __u32 targ_idx,
+					     __u32 flags,
+		const struct kparser_flag_fields
+		*flag_fields)
+{
+	ssize_t offset = kparser_flag_fields_offset(targ_idx, flags,
+			flag_fields);
+
+	if (offset < 0)
+		return 0;
+
+	return *(__u64 *)&fields[offset];
+}
+
+/*****************************************************************************/
+
+/* Definition of a KPARSER parser. Fields are:
+ *
+ * name: Text name for the parser
+ * root_node: Root parse node of the parser. When the parser is invoked
+ *	parsing commences at this parse node
+ * okay_node: Processed at parser exit if no error
+ * fail_node: Processed at parser exit if there was an error
+ * parser_type: e.g. KPARSER_GENERIC, KPARSER_OPTIMIZED, KPARSER_KMOD, KPARSER_XDP
+ * parser_entry_point: Function entry point for optimized parser
+ * parser_xdp_entry_point: Function entry point for XDP parser
+ * config: Parser conifguration
+ */
+#define KPARSERSTARTSIGNATURE 0xabcd
+#define KPARSERENDSIGNATURE 0xdcba
+struct kparser_parser {
+	__u16 kparser_start_signature;
+	char name[KPARSER_MAX_NAME];
+	const struct kparser_parse_node __rcu *root_node;
+	const struct kparser_parse_node __rcu *okay_node;
+	const struct kparser_parse_node __rcu *fail_node;
+	const struct kparser_parse_node __rcu *atencap_node;
+	size_t cntrs_len;
+	struct kparser_counters __rcu *cntrs;
+	struct kparser_config config;
+	struct kparser_cntrs_conf cntrs_conf;
+	__u16 kparser_end_signature;
+};
+
+#endif /* __KPARSER_TYPES_H */
-- 
2.34.1

