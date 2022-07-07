Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3C356AAE5
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 20:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbiGGSeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 14:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236704AbiGGScb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 14:32:31 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E856068C
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 11:30:23 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id e132so20028137pgc.5
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 11:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OriDeEWxl1oSXLeFmUsGaJdRMhwJBw2mqDkwWYMz1+w=;
        b=DPXFEtI60WMsqw8LQWtXsDi1ltsCDUd98G5aw0ypEVU7pryFstLtAS/HAS54gS43Yx
         57T3r0f8NV7/Xb+xYohZ5i1fbqvPrCr0a4BAUnP5Ffq62Unrk7G+mXvhn2jY8nSyzIQm
         lXpZ/XPeBmYVb4Hjtw/DFN6B5SB6SsFnVEGpw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OriDeEWxl1oSXLeFmUsGaJdRMhwJBw2mqDkwWYMz1+w=;
        b=Rcycd+THKcz7djV0mu7r6RQTxnQSBefNodKk45oEGkk0VFQRQKenFqT/CHu9rKULvl
         AbJZJD08zpYqt2i4s9zcPftyDtEj6vFYAMeJQVbrKAABaDA+G5rAynKuy6UKBMA968sX
         FVv5un9riJQXHmkduMiwjphEk0zTPfvfU86f6xpMsOSQFekmJLsYN0aySrfXPtQO5JCG
         Z8pWKaBZb8UhbthLPCvWyjWDKk2F67mzNGnLon7e1qdIRjfldUqFIebzZkspnIef3whN
         aqGPsOw9V1rk0qoCkoRY7MnJ9K40ECgmBylpUyJ8MMpbZtOQt3p1u0fqQ3m41IZFIqkn
         jJYg==
X-Gm-Message-State: AJIora97DDeTmWFtT9VcZIC7o+2iKugZjVEBj4l7nBe1xiEnuEExRIIV
        l1yXTAnZqQHR9Ka+nAj1IU7b/g==
X-Google-Smtp-Source: AGRyM1sIipm971ZqE89vxyMR6A9r0jRVO+ByhiVDOSeV0G11NXpRaleySzrZb3j/tFPOUKz2DeefPQ==
X-Received: by 2002:a17:90b:507:b0:1ee:de8c:6aa2 with SMTP id r7-20020a17090b050700b001eede8c6aa2mr6879982pjz.105.1657218621336;
        Thu, 07 Jul 2022 11:30:21 -0700 (PDT)
Received: from rahul_yocto_ubuntu18.ibn.broadcom.net ([192.19.252.250])
        by smtp.gmail.com with ESMTPSA id pj9-20020a17090b4f4900b001ef92e0e7c1sm7132234pjb.10.2022.07.07.11.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 11:30:20 -0700 (PDT)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     jiri@nvidia.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org,
        stephen@networkplumber.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, leon@kernel.org, linux-doc@vger.kernel.org,
        corbet@lwn.net, michael.chan@broadcom.com,
        andrew.gospodarek@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH net-next v2 1/3] devlink: introduce framework for selftests
Date:   Thu,  7 Jul 2022 23:59:48 +0530
Message-Id: <20220707182950.29348-2-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220707182950.29348-1-vikas.gupta@broadcom.com>
References: <20220628164241.44360-1-vikas.gupta@broadcom.com>
 <20220707182950.29348-1-vikas.gupta@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000045976205e33b4761"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000045976205e33b4761

Add a framework for running selftests.
Framework exposes devlink commands and test suite(s) to the user
to execute and query the supported tests by the driver.

Below are new entries in devlink_nl_ops
devlink_nl_cmd_selftests_show: To query the supported selftests
by the driver.
devlink_nl_cmd_selftests_run: To execute selftests. Users can
provide a test mask for executing group tests or standalone tests.

Documentation/networking/devlink/ path is already part of MAINTAINERS &
the new files come under this path. Hence no update needed to the
MAINTAINERS

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
---
 .../networking/devlink/devlink-selftests.rst  |  34 +++++
 include/net/devlink.h                         |  30 ++++
 include/uapi/linux/devlink.h                  |  26 ++++
 net/core/devlink.c                            | 144 ++++++++++++++++++
 4 files changed, 234 insertions(+)
 create mode 100644 Documentation/networking/devlink/devlink-selftests.rst

diff --git a/Documentation/networking/devlink/devlink-selftests.rst b/Documentation/networking/devlink/devlink-selftests.rst
new file mode 100644
index 000000000000..796d38f77038
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-selftests.rst
@@ -0,0 +1,34 @@
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
+     - Runs a flash test on the device.
+
+example usage
+-------------
+
+.. code:: shell
+
+    # Query selftests supported on the device
+    $ devlink dev selftests show DEV
+    # Executes selftests on the device
+    $ devlink dev selftests run DEV test {flash | all}
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 2a2a2a0c93f7..cb7c378cf720 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1215,6 +1215,18 @@ enum {
 	DEVLINK_F_RELOAD = 1UL << 0,
 };
 
+#define DEVLINK_SELFTEST_FLASH_TEST_NAME "flash"
+
+static inline const char *devlink_selftest_name(int test)
+{
+	switch (test) {
+	case DEVLINK_SELFTEST_FLASH_BIT:
+		return DEVLINK_SELFTEST_FLASH_TEST_NAME;
+	default:
+		return "unknown";
+	}
+}
+
 struct devlink_ops {
 	/**
 	 * @supported_flash_update_params:
@@ -1509,6 +1521,24 @@ struct devlink_ops {
 				    struct devlink_rate *parent,
 				    void *priv_child, void *priv_parent,
 				    struct netlink_ext_ack *extack);
+	/**
+	 * selftests_show() - Shows selftests supported by device
+	 * @devlink: Devlink instance
+	 * @extack: extack for reporting error messages
+	 *
+	 * Return: test mask supported by driver
+	 */
+	u32 (*selftests_show)(struct devlink *devlink,
+			      struct netlink_ext_ack *extack);
+	/**
+	 * selftests_run() - Runs selftests
+	 * @devlink: Devlink instance
+	 * @tests_mask: tests to be run by driver
+	 * @results: test results by driver
+	 * @extack: extack for reporting error messages
+	 */
+	void (*selftests_run)(struct devlink *devlink, u32 tests_mask,
+			      u8 *results, struct netlink_ext_ack *extack);
 };
 
 void *devlink_priv(struct devlink *devlink);
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index b3d40a5d72ff..1dba262328b9 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -136,6 +136,9 @@ enum devlink_command {
 	DEVLINK_CMD_LINECARD_NEW,
 	DEVLINK_CMD_LINECARD_DEL,
 
+	DEVLINK_CMD_SELFTESTS_SHOW,
+	DEVLINK_CMD_SELFTESTS_RUN,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
@@ -276,6 +279,25 @@ enum {
 #define DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS \
 	(_BITUL(__DEVLINK_FLASH_OVERWRITE_MAX_BIT) - 1)
 
+/* Commonly used test cases */
+enum {
+	DEVLINK_SELFTEST_FLASH_BIT,
+
+	__DEVLINK_SELFTEST_MAX_BIT,
+	DEVLINK_SELFTEST_MAX_BIT = __DEVLINK_SELFTEST_MAX_BIT - 1
+};
+
+#define DEVLINK_SELFTEST_FLASH _BITUL(DEVLINK_SELFTEST_FLASH_BIT)
+
+#define DEVLINK_SELFTESTS_MASK \
+	(_BITUL(__DEVLINK_SELFTEST_MAX_BIT) - 1)
+
+enum {
+	DEVLINK_SELFTEST_SKIP,
+	DEVLINK_SELFTEST_PASS,
+	DEVLINK_SELFTEST_FAIL
+};
+
 /**
  * enum devlink_trap_action - Packet trap action.
  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
@@ -576,6 +598,10 @@ enum devlink_attr {
 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
 
+	DEVLINK_ATTR_SELFTESTS_MASK,		/* u32 */
+	DEVLINK_ATTR_TEST_RESULT,		/* nested */
+	DEVLINK_ATTR_TEST_NAME,			/* string */
+	DEVLINK_ATTR_TEST_RESULT_VAL,		/* u8 */
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index db61f3a341cb..0b7341ab6379 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4794,6 +4794,136 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 	return ret;
 }
 
+static int devlink_selftest_name_put(struct sk_buff *skb, int test)
+{
+	const char *name = devlink_selftest_name(test);
+	if (nla_put_string(skb, DEVLINK_ATTR_TEST_NAME, name))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int devlink_nl_cmd_selftests_show(struct sk_buff *skb,
+					 struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct sk_buff *msg;
+	unsigned long tests;
+	int err = 0;
+	void *hdr;
+	int test;
+
+	if (!devlink->ops->selftests_show)
+		return -EOPNOTSUPP;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
+			  &devlink_nl_family, 0, DEVLINK_CMD_SELFTESTS_SHOW);
+	if (!hdr)
+		goto free_msg;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto genlmsg_cancel;
+
+	tests = devlink->ops->selftests_show(devlink, info->extack);
+
+	for_each_set_bit(test, &tests, __DEVLINK_SELFTEST_MAX_BIT) {
+		err = devlink_selftest_name_put(msg, test);
+		if (err)
+			goto genlmsg_cancel;
+	}
+
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_reply(msg, info);
+
+genlmsg_cancel:
+	genlmsg_cancel(msg, hdr);
+free_msg:
+	nlmsg_free(msg);
+	return err;
+}
+
+static int devlink_selftest_result_put(struct sk_buff *skb, int test,
+				       u8 result)
+{
+	const char *name = devlink_selftest_name(test);
+	struct nlattr *result_attr;
+
+	result_attr = nla_nest_start_noflag(skb, DEVLINK_ATTR_TEST_RESULT);
+	if (!result_attr)
+		return -EMSGSIZE;
+
+	if (nla_put_string(skb, DEVLINK_ATTR_TEST_NAME, name) ||
+	    nla_put_u8(skb, DEVLINK_ATTR_TEST_RESULT_VAL, result))
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
+	u8 test_results[DEVLINK_SELFTEST_MAX_BIT + 1] = {};
+	struct devlink *devlink = info->user_ptr[0];
+	unsigned long tests;
+	struct sk_buff *msg;
+	u32 tests_mask;
+	void *hdr;
+	int err = 0;
+	int test;
+
+	if (!devlink->ops->selftests_run)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[DEVLINK_ATTR_SELFTESTS_MASK])
+		return -EINVAL;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
+			  &devlink_nl_family, 0, DEVLINK_CMD_SELFTESTS_RUN);
+	if (!hdr)
+		goto free_msg;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto genlmsg_cancel;
+
+	tests_mask = nla_get_u32(info->attrs[DEVLINK_ATTR_SELFTESTS_MASK]);
+
+	devlink->ops->selftests_run(devlink, tests_mask, test_results,
+				    info->extack);
+	tests = tests_mask;
+
+	for_each_set_bit(test, &tests, __DEVLINK_SELFTEST_MAX_BIT) {
+		err = devlink_selftest_result_put(msg, test,
+						  test_results[test]);
+		if (err)
+			goto genlmsg_cancel;
+	}
+
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_reply(msg, info);
+
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
@@ -9000,6 +9130,8 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_SELFTESTS_MASK] = NLA_POLICY_MASK(NLA_U32,
+							DEVLINK_SELFTESTS_MASK),
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
@@ -9361,6 +9493,18 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.doit = devlink_nl_cmd_trap_policer_set_doit,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = DEVLINK_CMD_SELFTESTS_SHOW,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = devlink_nl_cmd_selftests_show,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = DEVLINK_CMD_SELFTESTS_RUN,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = devlink_nl_cmd_selftests_run,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_family devlink_nl_family __ro_after_init = {
-- 
2.31.1


--00000000000045976205e33b4761
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
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJV01h7Gy2UuXF9PkKzqyEGAOHy4qs5VXWaD
wqyHRAKkMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDcwNzE4
MzAyMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQAT9oreYTotqPdWrS3swhb1fvUIU5IiUIyXgTP4/sdQy8ACTkdTdTyh
nh983ZKqbbIQRrLw5OSbwDTi0MnQ2iyZxA0H6eZAITflbfp8H7ka2z3WScQMOlJDs5iOsv94SiJT
NWe3V2y4oYgcoJhcZOlAZR8NR+b0NursKwUP9+Qdoj2NdbXFetHgWWBGXdurqrr8K3Loied29Lut
bCS+VSdg6EWnhHH5DqJak5TPqSHG/z4Nb1qIu/CW06Et3BNI+J0SC0Bvk/wannac/P0hi9bYtiX6
p1yE0K6cgvOdjSjCCrj7oGC8zlzclZpTw+CKJONQ3tYjez/HnY+u1RTn+kdI
--00000000000045976205e33b4761--
