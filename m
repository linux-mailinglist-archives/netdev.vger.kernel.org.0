Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E05742A5A5
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236898AbhJLN2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:28:24 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44259 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236956AbhJLN2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:28:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D44B65C01A5;
        Tue, 12 Oct 2021 09:26:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 12 Oct 2021 09:26:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=X6Ai1eODWgXQwJSt8txvCNeFPkgXTzl84olHA8sAyGI=; b=O/xm4DC6
        PC+t/PBjSC7NMZ2WxFsMKQad7lM0E7OC9Ut1hz3nunoZBTmlKB8mBy1Nb0dbcAc+
        LsyMSBaWK6E4r4j6XfkQlYGsh2sRl2eWD3884M1pTLGycbqAFsBQzPMBynm6677I
        /WokFV6inCMZ/OIYHvbiaDMfnM9WlvKNk+OfKh+mBtCLVtGl07nEgSJBw5GXKQ8m
        bzm9L3ys9sWjn8bDnmvx/epT30b/otKWx5kHKvfL00nq5IpfbbwfwtM5kTJcfTjY
        r4/MXT316b/LqlkCPbeur4w8Az0yotOy0wxSOwilv+HjSCViexy48npXzCVOjh17
        tEveiijSDQjDxw==
X-ME-Sender: <xms:9YxlYUC1lLUATgaHd650TLIOkQbhZ6YOVFk4am0hL3_GXJHxtmO2cQ>
    <xme:9YxlYWjIHsrUoyL3PhtqLO9NSNXbBeHPapYvM4BXvyXNDoxHDYzaKUlrwjIxi6aDB
    R4zoBefigZLUwQ>
X-ME-Received: <xmr:9YxlYXkcaZ45e_bxDSZlt1LDE-XCErJBNY6Ai7f1VAUdymA_Yl3ndWuuosIgfz6CQbYzwmjVJrKIedRohP3WOQnEk9J_J3iHPuaju7yhzBE4Eg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepheenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:9YxlYaxBxVSP3m7qCIeV3fKgrtlQvLr5JU2zCyaYjC-jZ1tABpXX5Q>
    <xmx:9YxlYZRC0T8bzGxHr-8zEZP-tOZP4711kqNjqB168BCjTiqbx_Ro5A>
    <xmx:9YxlYVbtQGcB8tPbFyM-Aaw1wEL7bteo0zXXBDjgIeiYzPCv1m79Ng>
    <xmx:9YxlYXMyu0N853-s39GNAH4Anw1yrhbyPMvaOJo1-l08JjomUhvpLg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 09:26:11 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 10/14] netlink: eeprom: Export a function to request an EEPROM page
Date:   Tue, 12 Oct 2021 16:25:21 +0300
Message-Id: <20211012132525.457323-11-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012132525.457323-1-idosch@idosch.org>
References: <20211012132525.457323-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The function will be used by the EEPROM parsing code (e.g., cmis.c) to
request a specific page for parsing.

All the data buffers used to store EEPROM page contents are stored on a
linked list that is flushed on exit. This relieves callers from the need
to explicitly free the requested pages.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 netlink/extapi.h        |  11 +++++
 netlink/module-eeprom.c | 105 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+)

diff --git a/netlink/extapi.h b/netlink/extapi.h
index 91bf02b5e3be..129e2931d01d 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -48,6 +48,9 @@ int nl_getmodule(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
 
+int nl_get_eeprom_page(struct cmd_context *ctx,
+		       struct ethtool_module_eeprom *request);
+
 #else /* ETHTOOL_ENABLE_NETLINK */
 
 static inline void netlink_run_handler(struct cmd_context *ctx __maybe_unused,
@@ -73,6 +76,14 @@ static inline void nl_monitor_usage(void)
 {
 }
 
+static inline int
+nl_get_eeprom_page(struct cmd_context *ctx __maybe_unused,
+		   struct ethtool_module_eeprom *request __maybe_unused)
+{
+	fprintf(stderr, "Netlink not supported by ethtool.\n");
+	return -EOPNOTSUPP;
+}
+
 #define nl_gset			NULL
 #define nl_sset			NULL
 #define nl_permaddr		NULL
diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c
index 101d5943c2bc..ee5508840157 100644
--- a/netlink/module-eeprom.c
+++ b/netlink/module-eeprom.c
@@ -341,6 +341,110 @@ static void decoder_print(void)
 }
 #endif
 
+static struct list_head eeprom_page_list = LIST_HEAD_INIT(eeprom_page_list);
+
+struct eeprom_page_entry {
+	struct list_head list;	/* Member of eeprom_page_list */
+	void *data;
+};
+
+static int eeprom_page_list_add(void *data)
+{
+	struct eeprom_page_entry *entry;
+
+	entry = malloc(sizeof(*entry));
+	if (!entry)
+		return -ENOMEM;
+
+	entry->data = data;
+	list_add(&entry->list, &eeprom_page_list);
+
+	return 0;
+}
+
+static void eeprom_page_list_flush(void)
+{
+	struct eeprom_page_entry *entry;
+	struct list_head *head, *next;
+
+	list_for_each_safe(head, next, &eeprom_page_list) {
+		entry = (struct eeprom_page_entry *) head;
+		free(entry->data);
+		list_del(head);
+		free(entry);
+	}
+}
+
+static int get_eeprom_page_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_MODULE_EEPROM_DATA + 1] = {};
+	struct ethtool_module_eeprom *request = data;
+	DECLARE_ATTR_TB_INFO(tb);
+	u8 *eeprom_data;
+	int ret;
+
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return ret;
+
+	if (!tb[ETHTOOL_A_MODULE_EEPROM_DATA])
+		return MNL_CB_ERROR;
+
+	eeprom_data = mnl_attr_get_payload(tb[ETHTOOL_A_MODULE_EEPROM_DATA]);
+	request->data = malloc(request->length);
+	if (!request->data)
+		return MNL_CB_ERROR;
+	memcpy(request->data, eeprom_data, request->length);
+
+	ret = eeprom_page_list_add(request->data);
+	if (ret < 0)
+		goto err_list_add;
+
+	return MNL_CB_OK;
+
+err_list_add:
+	free(request->data);
+	return MNL_CB_ERROR;
+}
+
+int nl_get_eeprom_page(struct cmd_context *ctx,
+		       struct ethtool_module_eeprom *request)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsock;
+	struct nl_msg_buff *msg;
+	int ret;
+
+	if (!request || request->i2c_address > ETH_I2C_MAX_ADDRESS)
+		return -EINVAL;
+
+	nlsock = nlctx->ethnl_socket;
+	msg = &nlsock->msgbuff;
+
+	ret = nlsock_prep_get_request(nlsock, ETHTOOL_MSG_MODULE_EEPROM_GET,
+				      ETHTOOL_A_MODULE_EEPROM_HEADER, 0);
+	if (ret < 0)
+		return ret;
+
+	if (ethnla_put_u32(msg, ETHTOOL_A_MODULE_EEPROM_LENGTH,
+			   request->length) ||
+	    ethnla_put_u32(msg, ETHTOOL_A_MODULE_EEPROM_OFFSET,
+			   request->offset) ||
+	    ethnla_put_u8(msg, ETHTOOL_A_MODULE_EEPROM_PAGE,
+			  request->page) ||
+	    ethnla_put_u8(msg, ETHTOOL_A_MODULE_EEPROM_BANK,
+			  request->bank) ||
+	    ethnla_put_u8(msg, ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS,
+			  request->i2c_address))
+		return -EMSGSIZE;
+
+	ret = nlsock_sendmsg(nlsock, NULL);
+	if (ret < 0)
+		return ret;
+	return nlsock_process_reply(nlsock, get_eeprom_page_reply_cb,
+				    (void *)request);
+}
+
 int nl_getmodule(struct cmd_context *ctx)
 {
 	struct cmd_params getmodule_cmd_params = {};
@@ -425,6 +529,7 @@ int nl_getmodule(struct cmd_context *ctx)
 	}
 
 cleanup:
+	eeprom_page_list_flush();
 	cache_free();
 	return ret;
 }
-- 
2.31.1

