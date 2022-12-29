Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E2E658F30
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 17:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbiL2QoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 11:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbiL2Qnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 11:43:52 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF46FA199;
        Thu, 29 Dec 2022 08:43:51 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id bx10so17888533wrb.0;
        Thu, 29 Dec 2022 08:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=irH1XmQtG5dO1L6/FH3q43QSzL37yuS1O7l4CdF6kPc=;
        b=WLw+oWEJlXYA0Lx2/GVzVskqZ/SV256M7X8MiNX49OLu3WVCTUbNhsxBrcft4VrMqC
         ap27rmkhHACSaT+QjEEDZ5m25FVDD3qCU7darpBttRPgStssqlkTLjy5WBBOe0Y0zsle
         /ftfOdS+H/nLsyI5W5gQh9B9kr/1Tqw32CVxWKH4miGUk0vnssHw7Q27RBeQUZVgnqDr
         FOp3lpO1Zrs0lvfvx2zM7pn+C0yoXuiebIRV50muMunlmYGxcODKIWbk4IpImsio0Kxq
         oB6r0CUqah4gQlRz3/bZEYL08dAMJ9zouzjHSvOJmpn4DTfjBk95fv4J5aVwT0k6NNwr
         ohdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=irH1XmQtG5dO1L6/FH3q43QSzL37yuS1O7l4CdF6kPc=;
        b=ppBedEUBuCsOC/S7ioHLZN3JI7UpnZlBkmm0vh3hh+Nf9bQ31cO/Pf2lgH/hJCxAB4
         e9R0LWiYnb0+ybdIrPrAWRnGLTkb5IdadFhkm4nbz6vmDw2BdxYUrdLqPAtzE5IHIL2S
         MpxWuyyxeXaNl/Y7CHZ4pqMY+swqOVzmLTx9BcmYAhZ15stzx7psuUKPDuaB6HnHCAh3
         yut8wPaf0AMWbG1wij+bvbSIT1EB8WER2UIq6NuFtfrNWI0hyJYRby1Bj8QxsomsZ7Q4
         e0B20QUCaYgZnpVHaIRXxoJittBWnPcuxPOVUIq8xr7eIIRq7WLdIa9K+PVYtEnKCU8f
         m2ZQ==
X-Gm-Message-State: AFqh2kqcDrGVxz1c4DcHmP0CBqBE2CnN7ZlarbZg/zDGcUtsvYJJ+7Fn
        PhAFdxEECiMksh3PBby+EbU=
X-Google-Smtp-Source: AMrXdXv28VkEZ5sOn/DqK+rX7ddJi/uJdFhsRLzaxmIePG0+vjdDdHXFmOm5pwEGYcH7Guymr1ZP2Q==
X-Received: by 2002:a5d:534e:0:b0:277:e258:cccd with SMTP id t14-20020a5d534e000000b00277e258cccdmr10766922wrv.15.1672332230378;
        Thu, 29 Dec 2022 08:43:50 -0800 (PST)
Received: from localhost.localdomain (host-82-55-238-56.retail.telecomitalia.it. [82.55.238.56])
        by smtp.googlemail.com with ESMTPSA id t18-20020a5d42d2000000b00288a3fd9248sm4326586wrr.91.2022.12.29.08.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 08:43:50 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ronald Wahl <ronald.wahl@raritan.com>, stable@vger.kernel.org
Subject: [net PATCH v2 2/5] net: dsa: tag_qca: fix wrong MGMT_DATA2 size
Date:   Thu, 29 Dec 2022 17:33:33 +0100
Message-Id: <20221229163336.2487-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221229163336.2487-1-ansuelsmth@gmail.com>
References: <20221229163336.2487-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was discovered that MGMT_DATA2 can contain up to 28 bytes of data
instead of the 12 bytes written in the Documentation by accounting the
limit of 16 bytes declared in Documentation subtracting the first 4 byte
in the packet header.

Update the define with the real world value.

Tested-by: Ronald Wahl <ronald.wahl@raritan.com>
Fixes: c2ee8181fddb ("net: dsa: tag_qca: add define for handling mgmt Ethernet packet")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v5.18+
---
 include/linux/dsa/tag_qca.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index b1b5720d89a5..ee657452f122 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -45,8 +45,8 @@ struct sk_buff;
 					QCA_HDR_MGMT_COMMAND_LEN + \
 					QCA_HDR_MGMT_DATA1_LEN)
 
-#define QCA_HDR_MGMT_DATA2_LEN		12 /* Other 12 byte for the mdio data */
-#define QCA_HDR_MGMT_PADDING_LEN	34 /* Padding to reach the min Ethernet packet */
+#define QCA_HDR_MGMT_DATA2_LEN		28 /* Other 28 byte for the mdio data */
+#define QCA_HDR_MGMT_PADDING_LEN	18 /* Padding to reach the min Ethernet packet */
 
 #define QCA_HDR_MGMT_PKT_LEN		(QCA_HDR_MGMT_HEADER_LEN + \
 					QCA_HDR_LEN + \
-- 
2.37.2

