Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1796056AE38
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 00:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236655AbiGGWPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 18:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236775AbiGGWPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 18:15:43 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0546052A
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 15:15:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a8-20020a25a188000000b0066839c45fe8so14501017ybi.17
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 15:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Au3uQ/I1Gbn+ebx+c7n9vG0a+CqriTF+Pq0TBVnt6HA=;
        b=nrnHZgJ/UnZfiRi54CXeWQySF0JOfWg6mLpVNSqtJDGPQecRTOtFWc11XYz9ncecVU
         Al7pmVKKHZmVuY9BwmhUaIgprjl8yIpwkRku73hgWiqj97hs4S/yyNbFCnm0iKDEqBfZ
         3WbAfjTl04l82dCIDRrX6G6h/KyxCwh3RPDTrazfypjv29hVt4I2ljkbxB16DU4c/94p
         +uibYKDQrMDFredVunbYAevmq7sgdl0w8aO1QTjWmIZK2yY+HdVzBLE9pYqhoy+tlip6
         ulzd5zbJFcjpWLK+FwB6UDVLZLcrKqe/WfdsMGUJpNOzZamQk6ck1F3PxS+DN23w883j
         tJrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Au3uQ/I1Gbn+ebx+c7n9vG0a+CqriTF+Pq0TBVnt6HA=;
        b=rgKom5C43Jq7xo/EN/cWZDral8+z5nmsMm+Y7ACLFXffOkxKm9yUuDAn/nBKyBoMfk
         aJR8rWFV74mSknzGRhRJt6+ee3iMiVCbbfgD2GhJNvr0UxjnSSayLUvd0CujgpMxR/Pj
         IGcP5dCy4geE4sBKs/q5HbygivioKIE2S12pTvD43OG7B6oBF1rSDKVWkg0rQcIUY+F0
         QUAS1q3HWLmyOIbfY0a6nc7OWm2t7u3EgZgDjKhEsFG9rwL59WUvT1+tqTZTo8jTcBgU
         Hguy82M+qlAPU1ejDVwedsAtb1XC3BmBVQyQDwdGgmwVAbOUaYGz+7ZTLuQLMkXiKP7g
         Bliw==
X-Gm-Message-State: AJIora9xbjDlB6vylt+c4zqRqf679YSRP8Yj7nbLH2OTTCfn76sIVgwx
        znC0MtVwdsoDcnIG0gMQOuH8OSCsdOOEVA==
X-Google-Smtp-Source: AGRyM1sA4kT+jQNIjIJgjDVUiLQBLLvwBWkNpIFwdYk4MA6Svpzx58WPse7T9uLMYKmHZ/b0ZlL5Cz4YP4z6nQ==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:dd36:c013:75d8:a382])
 (user=mmandlik job=sendgmr) by 2002:a25:312:0:b0:66e:d230:8aa1 with SMTP id
 18-20020a250312000000b0066ed2308aa1mr158292ybd.264.1657232136309; Thu, 07 Jul
 2022 15:15:36 -0700 (PDT)
Date:   Thu,  7 Jul 2022 15:15:15 -0700
In-Reply-To: <20220707151420.v3.1.Iaf638bb9f885f5880ab1b4e7ae2f73dd53a54661@changeid>
Message-Id: <20220707151420.v3.2.I39885624992dacff236aed268bdaa69107cd1310@changeid>
Mime-Version: 1.0
References: <20220707151420.v3.1.Iaf638bb9f885f5880ab1b4e7ae2f73dd53a54661@changeid>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v3 2/3] Bluetooth: Add sysfs entry to enable/disable devcoredump
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Manish Mandlik <mmandlik@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since device/firmware dump is a debugging feature, we may not need it
all the time. Add a sysfs attribute to enable/disable bluetooth
devcoredump capturing. The default state of this feature would be
disabled and it can be enabled by echoing 1 to enable_coredump sysfs
entry as follow:

$ echo 1 > /sys/class/bluetooth/<device>/enable_coredump

Signed-off-by: Manish Mandlik <mmandlik@google.com>
---

Changes in v3:
- New patch in the series to enable/disable feature via sysfs entry

 net/bluetooth/hci_sysfs.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index 4e3e0451b08c..df0d54a5ae3f 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -91,9 +91,45 @@ static void bt_host_release(struct device *dev)
 	module_put(THIS_MODULE);
 }
 
+#ifdef CONFIG_DEV_COREDUMP
+static ssize_t enable_coredump_show(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct hci_dev *hdev = to_hci_dev(dev);
+
+	return scnprintf(buf, 3, "%d\n", hdev->dump.enabled);
+}
+
+static ssize_t enable_coredump_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct hci_dev *hdev = to_hci_dev(dev);
+
+	/* Consider any non-zero value as true */
+	if (simple_strtol(buf, NULL, 10))
+		hdev->dump.enabled = true;
+	else
+		hdev->dump.enabled = false;
+
+	return count;
+}
+DEVICE_ATTR_RW(enable_coredump);
+#endif
+
+static struct attribute *bt_host_attrs[] = {
+#ifdef CONFIG_DEV_COREDUMP
+	&dev_attr_enable_coredump.attr,
+#endif
+	NULL,
+};
+ATTRIBUTE_GROUPS(bt_host);
+
 static const struct device_type bt_host = {
 	.name    = "host",
 	.release = bt_host_release,
+	.groups = bt_host_groups,
 };
 
 void hci_init_sysfs(struct hci_dev *hdev)
-- 
2.37.0.rc0.161.g10f37bed90-goog

