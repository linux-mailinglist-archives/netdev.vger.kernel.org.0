Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7BC639727
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 17:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiKZQXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 11:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiKZQWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 11:22:50 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF1416588;
        Sat, 26 Nov 2022 08:22:47 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so5472187pjo.3;
        Sat, 26 Nov 2022 08:22:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qpk5NRZGXT6wrXMKM9BCDiOE6+iPJ0S6rC3xQ1EVYCc=;
        b=PcvQ7SBhzOJybY6+jatfIAbtpni76oCLbPDJ5hc5isiyOAtuRnAnCarpbJ4tzisVXU
         kdpFTPOsDcn7G66NXoCUgX9Ht3adGoFzCIWmpfGcvQPlNKESUlH04lsTPrAzSu0lLIvn
         +osLHYK6J9SMA28fYLX4pq4o8nWJhKgMGQvrlditRvMF9zPohPHuzxpKKIRD9xd4P6s2
         GN0dOAYE+dGPIiQG2L5he9dMtncbAC6vlC+87U5JO5EDukE9KQ096D++5+nRDjMFZpg1
         kzXzMHAFfuTc1O1a5DaCOhhPfHWVXQn3n2uBTgvdlo7auSBEMArpt+/sXy974twJEzqg
         yzxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qpk5NRZGXT6wrXMKM9BCDiOE6+iPJ0S6rC3xQ1EVYCc=;
        b=0UqHK3XmLeqUaRRCeNhaDD1x70XrGo3LUUnlPUTiwNgB47/OEK/AeFC8ElxpKg3/zA
         uOa4L0nxXcL6Dkr9nxV3/msT0PyEFz9LamW1PzCHE+IyTKgMKVB4HHlb43hp3TqRF/Xr
         zJPrK2eA/JVBJ+7WfkrtRQUtJpCdK06BoKz/bwsyCv5b7MnvK4asKxacXoqAIr/qMq1F
         v1tpELmCN00YseJuma6WcjSSqV7Dr7TokdrP4E4xU8LJJJPXia/rQpAcJwJ6a1ub/z0/
         AXE5ZepMPYWR3xPkO0qS3W12b/K0TcRh1DPLGPOklWPcexawf7os1o2BZat6BzVg1JfM
         5img==
X-Gm-Message-State: ANoB5pnIkRA6FvsBUuMSCIgvmhDXFQsmo75/Ox85pdhylgjZ5AWSB8LY
        mpnWN5z5kS21KYd+7+3wUtWFg1JzVvfpJw==
X-Google-Smtp-Source: AA0mqf4halsh85pz1Q+OGUUHUQMqK2ByYwfdWQSW1PvJE4KBID1RYyl0RKhK1cWpAGU6sxw7irqu3w==
X-Received: by 2002:a17:902:d191:b0:189:1d93:1435 with SMTP id m17-20020a170902d19100b001891d931435mr24457444plb.105.1669479766928;
        Sat, 26 Nov 2022 08:22:46 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id y14-20020a63e24e000000b00460ea630c1bsm4169601pgj.46.2022.11.26.08.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Nov 2022 08:22:46 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-can@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 5/6] can: etas_es58x: report the firmware version through ethtool
Date:   Sun, 27 Nov 2022 01:22:10 +0900
Message-Id: <20221126162211.93322-6-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement ethtool_ops::get_drvinfo() in order to report the firmware
version.

Firmware version 0.0.0 has a special meaning and just means that we
could not parse the product information string. In such case, do
nothing (i.e. leave the .fw_version string empty).

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---

*N.B.* Drivers had to also fill ethtool_drvinfo::driver and
ethtool_drvinfo::bus_info. Starting this month, this is not needed
anymore because of commit edaf5df22cb8 ("ethtool: ethtool_get_drvinfo:
populate drvinfo fields even if callback exits").

  https://git.kernel.org/netdev/net-next/c/edaf5df22cb8
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index e81ef23d8698..12968aef41af 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1979,7 +1979,28 @@ static const struct net_device_ops es58x_netdev_ops = {
 	.ndo_eth_ioctl = can_eth_ioctl_hwts,
 };
 
+/**
+ * es58x_get_drvinfo() - Get the firmware version.
+ * @netdev: CAN network device.
+ * @drvinfo: Driver information.
+ *
+ * Populate @drvinfo with the firmware version. The core will populate
+ * the rest.
+ */
+static void es58x_get_drvinfo(struct net_device *netdev,
+			      struct ethtool_drvinfo *drvinfo)
+{
+	struct es58x_device *es58x_dev = es58x_priv(netdev)->es58x_dev;
+	struct es58x_sw_version *fw_ver = &es58x_dev->firmware_version;
+
+	if (es58x_sw_version_is_set(fw_ver))
+		snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
+			 "%02u.%02u.%02u",
+			 fw_ver->major, fw_ver->minor, fw_ver->revision);
+}
+
 static const struct ethtool_ops es58x_ethtool_ops = {
+	.get_drvinfo = es58x_get_drvinfo,
 	.get_ts_info = can_ethtool_op_get_ts_info_hwts,
 };
 
-- 
2.37.4

