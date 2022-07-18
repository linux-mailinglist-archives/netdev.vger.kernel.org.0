Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C6F577ADA
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 08:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiGRGV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 02:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiGRGVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 02:21:06 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4F213F06
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 23:21:04 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 72so9743936pge.0
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 23:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CVq3dVEEvOgnOAyLU8UyqOXSkvxA0sLFqcrPIhm2XBo=;
        b=JdV91REWlQvUHUirS4xIFZBIbwKx/egvjBE5X1Ryxf2JZECbUV2nHLNoEJKwGfOmjx
         aAgJ1x+pFl7HZ/WM/W4OJK/velzyQp05Hjsc0PQ6tA9/NuaUodtqRwcdT+QOBwSGitQU
         Cj1qYHXe1UQ3uK8dURFrb8ljGn3mYKWCt73OQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CVq3dVEEvOgnOAyLU8UyqOXSkvxA0sLFqcrPIhm2XBo=;
        b=uoIpZT3E4nkVKznIsRC7FK6UAN2pNImBgUtXhk1OJnYjIT6uWITrJEAt5Nc0su3Gio
         1syTgnnjmFtufbqNF+LO6VAsrkttWKeWe7PbRoLKVHLDOvzH23cbbOerHAsomQU82fA3
         22YEuactbNG09KGTcBapVH3pP4GDXth4QrjX48FBb02dPrXgrcF8vU9yuWbIDDy23ODk
         vlwzPvOjqWg9jkJpo8EwTWIo18xpz8gvxX67IetCWhG+6k8LafDAoZPm77b/7UxdxKWE
         HtXtn5tw6+FYtGkRP4B4sJsuizmYrV9PINo7pFTp97iWXoGBi6UyTL3bBTItIuzC+10V
         Q/sA==
X-Gm-Message-State: AJIora+pxhwpt6ktVBVhZD5J8LbjD3/qlBa9fWHQw62RCWgxazsTiZzY
        Wk6pxVrBIxnbBzrD+cfPZXkIrQ==
X-Google-Smtp-Source: AGRyM1uqFm35/QxRvn9dw/vG7PgiYXfilkRzhUPF68kcsHvTZ69RxBsWGMtaYlwcfsEgX9dOY6XhOQ==
X-Received: by 2002:aa7:8a02:0:b0:528:9f42:4fcf with SMTP id m2-20020aa78a02000000b005289f424fcfmr26765862pfa.28.1658125263825;
        Sun, 17 Jul 2022 23:21:03 -0700 (PDT)
Received: from rahul_yocto_ubuntu18.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h22-20020a170902f7d600b0016c4fe627eesm8360164plw.241.2022.07.17.23.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 23:21:03 -0700 (PDT)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     jiri@nvidia.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org,
        stephen@networkplumber.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, leon@kernel.org, linux-doc@vger.kernel.org,
        corbet@lwn.net, michael.chan@broadcom.com,
        andrew.gospodarek@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH net-next v3 1/3] devlink: introduce framework for selftests
Date:   Mon, 18 Jul 2022 11:50:30 +0530
Message-Id: <20220718062032.22426-2-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220718062032.22426-1-vikas.gupta@broadcom.com>
References: <0220707182950.29348-1-vikas.gupta@broadcom.com>
 <20220718062032.22426-1-vikas.gupta@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000061608105e40e5f31"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000061608105e40e5f31

Add a framework for running selftests.
Framework exposes devlink commands and test suite(s) to the user
to execute and query the supported tests by the driver.

Below are new entries in devlink_nl_ops
devlink_nl_cmd_selftests_list_doit/dumpit: To query the supported
selftests by the drivers.
devlink_nl_cmd_selftests_run: To execute selftests. Users can
provide a test mask for executing group tests or standalone tests.

Documentation/networking/devlink/ path is already part of MAINTAINERS &
the new files come under this path. Hence no update needed to the
MAINTAINERS

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
---
 .../networking/devlink/devlink-selftests.rst  |  38 +++
 include/net/devlink.h                         |  20 ++
 include/uapi/linux/devlink.h                  |  29 +++
 net/core/devlink.c                            | 216 ++++++++++++++++++
 4 files changed, 303 insertions(+)
 create mode 100644 Documentation/networking/devlink/devlink-selftests.rst

diff --git a/Documentation/networking/devlink/devlink-selftests.rst b/Documentation/networking/devlink/devlink-selftests.rst
new file mode 100644
index 000000000000..0e9727895987
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-selftests.rst
@@ -0,0 +1,38 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+=================
+Devlink Selftests
+=================
+
+The ``devlink-selftests`` API allows executing selftests on the device.
+
+Tests Mask
+==========
+The ``devlink-selftests`` command should be run with a mask indicating
+the tests to be executed.
+
+Tests Description
+=================
+The following is a list of tests that drivers may execute.
+
+.. list-table:: List of tests
+   :widths: 5 90
+
+   * - Name
+     - Description
+   * - ``DEVLINK_SELFTEST_FLASH``
+     - Devices may have the firmware on non-volatile memory on the board, e.g.
+       flash. This particular test helps to run a flash selftest on the device.
+       Implementation of the test is left to the driver/firmware.
+
+example usage
+-------------
+
+.. code:: shell
+
+    # Query selftests supported on the devlink device
+    $ devlink dev selftests show DEV
+    # Query selftests supported on all devlink devices
+    $ devlink dev selftests show
+    # Executes selftests on the device
+    $ devlink dev selftests run DEV test flash
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 88c701b375a2..9d8fc09f2c39 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1509,6 +1509,26 @@ struct devlink_ops {
 				    struct devlink_rate *parent,
 				    void *priv_child, void *priv_parent,
 				    struct netlink_ext_ack *extack);
+	/**
+	 * selftests_check() - queries if selftest is supported
+	 * @devlink: Devlink instance
+	 * @test_id: test index
+	 * @extack: extack for reporting error messages
+	 *
+	 * Return: True if test is supported by the driver
+	 */
+	bool (*selftest_check)(struct devlink *devlink, int test_id,
+			       struct netlink_ext_ack *extack);
+	/**
+	 * selftest_run() - Runs a selftest
+	 * @devlink: Devlink instance
+	 * @test_id: test index
+	 * @extack: extack for reporting error messages
+	 *
+	 * Return: Result of the test
+	 */
+	u8 (*selftest_run)(struct devlink *devlink, int test_id,
+			   struct netlink_ext_ack *extack);
 };
 
 void *devlink_priv(struct devlink *devlink);
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index b3d40a5d72ff..469846f40e6d 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -136,6 +136,9 @@ enum devlink_command {
 	DEVLINK_CMD_LINECARD_NEW,
 	DEVLINK_CMD_LINECARD_DEL,
 
+	DEVLINK_CMD_SELFTESTS_LIST,	/* can dump */
+	DEVLINK_CMD_SELFTESTS_RUN,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
@@ -276,6 +279,31 @@ enum {
 #define DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS \
 	(_BITUL(__DEVLINK_FLASH_OVERWRITE_MAX_BIT) - 1)
 
+/* Commonly used test cases */
+enum devlink_selftest_attr {
+	DEVLINK_SELFTEST_ATTR_UNSPEC,
+	DEVLINK_SELFTEST_ATTR_FLASH,		/* flag */
+
+	__DEVLINK_SELFTEST_ATTR_MAX,
+	DEVLINK_SELFTEST_ATTR_MAX = __DEVLINK_SELFTEST_ATTR_MAX - 1
+};
+
+enum devlink_selftest_result {
+	DEVLINK_SELFTEST_SKIP,
+	DEVLINK_SELFTEST_PASS,
+	DEVLINK_SELFTEST_FAIL
+};
+
+enum devlink_selftest_result_attr {
+	DEVLINK_SELFTEST_ATTR_RESULT_UNSPEC,
+	DEVLINK_SELFTEST_ATTR_RESULT,		/* nested */
+	DEVLINK_SELFTEST_ATTR_TEST_ID,		/* u32, devlink_selftest_attr */
+	DEVLINK_SELFTEST_ATTR_TEST_STATUS,	/* u8, devlink_selftest_result */
+
+	__DEVLINK_SELFTEST_ATTR_RES_MAX,
+	DEVLINK_SELFTEST_ATTR_RES_MAX = __DEVLINK_SELFTEST_ATTR_RES_MAX - 1
+};
+
 /**
  * enum devlink_trap_action - Packet trap action.
  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
@@ -576,6 +604,7 @@ enum devlink_attr {
 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
 
+	DEVLINK_ATTR_SELFTESTS_INFO,		/* nested */
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index a9776ea923ae..57a9a183e1d1 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -198,6 +198,10 @@ static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_
 				 DEVLINK_PORT_FN_STATE_ACTIVE),
 };
 
+static const struct nla_policy devlink_selftest_nl_policy[DEVLINK_SELFTEST_ATTR_MAX + 1] = {
+	[DEVLINK_SELFTEST_ATTR_FLASH] = { .type = NLA_FLAG },
+};
+
 static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
 #define DEVLINK_REGISTERED XA_MARK_1
 
@@ -4791,6 +4795,206 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 	return ret;
 }
 
+static int
+devlink_nl_selftests_fill(struct sk_buff *msg, struct devlink *devlink,
+			  u32 portid, u32 seq, int flags,
+			  struct netlink_ext_ack *extack)
+{
+	struct nlattr *selftests_list;
+	void *hdr;
+	int err;
+	int i;
+
+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags,
+			  DEVLINK_CMD_SELFTESTS_LIST);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	err = -EMSGSIZE;
+	if (devlink_nl_put_handle(msg, devlink))
+		goto err_cancel_msg;
+
+	selftests_list = nla_nest_start(msg, DEVLINK_ATTR_SELFTESTS_INFO);
+	if (!selftests_list)
+		goto err_cancel_msg;
+
+	for (i = 1; i < DEVLINK_SELFTEST_ATTR_MAX + 1; i++) {
+		if (devlink->ops->selftest_check(devlink, i, extack)) {
+			err = nla_put_flag(msg, i);
+			if (err)
+				goto err_cancel_msg;
+		}
+	}
+
+	nla_nest_end(msg, selftests_list);
+
+	genlmsg_end(msg, hdr);
+
+	return 0;
+
+err_cancel_msg:
+	genlmsg_cancel(msg, hdr);
+	return err;
+}
+
+static int devlink_nl_cmd_selftests_list_doit(struct sk_buff *skb,
+					      struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct sk_buff *msg;
+	int err;
+
+	if (!devlink->ops->selftest_check)
+		return -EOPNOTSUPP;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = devlink_nl_selftests_fill(msg, devlink, info->snd_portid,
+					info->snd_seq, 0, info->extack);
+	if (err) {
+		nlmsg_free(msg);
+		return err;
+	}
+
+	return genlmsg_reply(msg, info);
+}
+
+static int devlink_nl_cmd_selftests_list_dumpit(struct sk_buff *msg,
+						struct netlink_callback *cb)
+{
+	struct devlink *devlink;
+	int start = cb->args[0];
+	unsigned long index;
+	int idx = 0;
+	int err = 0;
+
+	mutex_lock(&devlink_mutex);
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
+		if (!devlink_try_get(devlink))
+			continue;
+
+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
+			goto retry;
+
+		if (idx < start || !devlink->ops->selftest_check)
+			goto inc;
+
+		mutex_lock(&devlink->lock);
+		err = devlink_nl_selftests_fill(msg, devlink,
+						NETLINK_CB(cb->skb).portid,
+						cb->nlh->nlmsg_seq, NLM_F_MULTI,
+						cb->extack);
+		mutex_unlock(&devlink->lock);
+		if (err) {
+			devlink_put(devlink);
+			break;
+		}
+inc:
+		idx++;
+retry:
+		devlink_put(devlink);
+	}
+	mutex_unlock(&devlink_mutex);
+
+	if (err != -EMSGSIZE)
+		return err;
+
+	cb->args[0] = idx;
+	return msg->len;
+}
+
+static int devlink_selftest_result_put(struct sk_buff *skb, int test_id,
+				       u8 result)
+{
+	struct nlattr *result_attr;
+
+	result_attr = nla_nest_start(skb, DEVLINK_SELFTEST_ATTR_RESULT);
+	if (!result_attr)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(skb, DEVLINK_SELFTEST_ATTR_TEST_ID, test_id) ||
+	    nla_put_u8(skb, DEVLINK_SELFTEST_ATTR_TEST_STATUS, result))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, result_attr);
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, result_attr);
+	return -EMSGSIZE;
+}
+
+static int devlink_nl_cmd_selftests_run(struct sk_buff *skb,
+					struct genl_info *info)
+{
+	struct nlattr *tb[DEVLINK_SELFTEST_ATTR_MAX + 1];
+	struct devlink *devlink = info->user_ptr[0];
+	struct nlattr *attrs, *tests_info;
+	struct sk_buff *msg;
+	void *hdr;
+	int err;
+	int i;
+
+	if (!devlink->ops->selftest_run)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[DEVLINK_ATTR_SELFTESTS_INFO])
+		return -EINVAL;
+
+	attrs = info->attrs[DEVLINK_ATTR_SELFTESTS_INFO];
+
+	err = nla_parse_nested(tb, DEVLINK_SELFTEST_ATTR_MAX, attrs,
+			       devlink_selftest_nl_policy, info->extack);
+	if (err < 0)
+		return err;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = -EMSGSIZE;
+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
+			  &devlink_nl_family, 0, DEVLINK_CMD_SELFTESTS_RUN);
+	if (!hdr)
+		goto free_msg;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto genlmsg_cancel;
+
+	tests_info = nla_nest_start(msg, DEVLINK_ATTR_SELFTESTS_INFO);
+	if (!tests_info)
+		goto genlmsg_cancel;
+
+	for (i = 1; i < DEVLINK_SELFTEST_ATTR_MAX + 1; i++) {
+		u8 res;
+
+		if (nla_get_flag(tb[i])) {
+			res = devlink->ops->selftest_run(devlink, i,
+							 info->extack);
+			err = devlink_selftest_result_put(msg, i, res);
+			if (err)
+				goto selftests_list_nest_cancel;
+		}
+	}
+
+	nla_nest_end(msg, tests_info);
+
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_reply(msg, info);
+
+selftests_list_nest_cancel:
+	nla_nest_cancel(msg, tests_info);
+genlmsg_cancel:
+	genlmsg_cancel(msg, hdr);
+free_msg:
+	nlmsg_free(msg);
+	return err;
+}
+
 static const struct devlink_param devlink_param_generic[] = {
 	{
 		.id = DEVLINK_PARAM_GENERIC_ID_INT_ERR_RESET,
@@ -8997,6 +9201,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_SELFTESTS_INFO] = { .type = NLA_NESTED },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
@@ -9356,6 +9561,17 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.doit = devlink_nl_cmd_trap_policer_set_doit,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = DEVLINK_CMD_SELFTESTS_LIST,
+		.doit = devlink_nl_cmd_selftests_list_doit,
+		.dumpit = devlink_nl_cmd_selftests_list_dumpit
+		/* can be retrieved by unprivileged users */
+	},
+	{
+		.cmd = DEVLINK_CMD_SELFTESTS_RUN,
+		.doit = devlink_nl_cmd_selftests_run,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_family devlink_nl_family __ro_after_init = {
-- 
2.31.1


--00000000000061608105e40e5f31
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
I7qKxvF8Yo7eGTnHRTa99J+6yTd88AKVuhM5TEhpC8cS7qvrQXJje+Uing2xWC4FH76LEWIFH0Pt
x8C1WoCU0ClXHU/XfzH2mYrFANBSCeP1Co6QdEfRAgMBAAGjggHZMIIB1TAOBgNVHQ8BAf8EBAMC
BaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJlLmdsb2JhbHNp
Z24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYIKwYBBQUHMAGG
NWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwME0G
A1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqGOGh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3JsMCMGA1UdEQQc
MBqBGHZpa2FzLmd1cHRhQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSME
GDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUUc6J11rH3s6PyZQ0zIVZHIuP20Yw
DQYJKoZIhvcNAQELBQADggEBALvCjXn9gy9a2nU/Ey0nphGZefIP33ggiyuKnmqwBt7Wk/uDHIIc
kkIlqtTbo0x0PqphS9A23CxCDjKqZq2WN34fL5MMW83nrK0vqnPloCaxy9/6yuLbottBY4STNuvA
mQ//Whh+PE+DZadqiDbxXbos3IH8AeFXH4A1zIqIrc0Um2/CSD/T6pvu9QrchtvemfP0z/f1Bk+8
QbQ4ARVP93WV1I13US69evWXw+mOv9VnejShU9PMcDK203xjXbBOi9Hm+fthrWfwIyGoC5aEf7vd
PKkEDt4VZ9RbudZU/c3N8+kURaHNtrvu2K+mQs5w/AF7HYZThqmOzQJnvMRjuL8xggJtMIICaQIB
ATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhH
bG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwYjepatB64S625eswwDQYJ
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFhdaoaOu6xw+f307lAjwlQSVNHQqFWkaAsg
fe9bjDqsMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDcxODA2
MjEwNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQByLR8zupYKCb4weGcvs2ArLpOtF9EF1Qs8GcAJMJaLRIYq/wUpTCVz
mjPxrQnT1mJeuF6tPGOOO4/e8EzfiIalQrMDiRBfFyGYV/753m1K5xskiGtVoyATLVTIrBJYq+iY
uOE/BIjqF9BpS7UtrDpoEUGooGTADnT+DyPwSZnfpbds6sWmJ1hqZFBZICyg/o0o/KNXEDy6Gxxg
e5sy3P5eeI1mXhxsCQU/zlAb2h49tChMpnnmp1n8I4ivWTYV6DaGbYTiA52GuaBrVp/L7sCBEQEs
AlhtdDZBIqGa6aKsGmExcxxJWj9tM48sSKK94O9AhWXUwQQb/dY6V+fE22Bb
--00000000000061608105e40e5f31--
