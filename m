Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AECA3671A3B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjARLQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjARLQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:16:07 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769387E683;
        Wed, 18 Jan 2023 02:28:41 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d2so13305065wrp.8;
        Wed, 18 Jan 2023 02:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gzsqNrbxHo0OcC1GphGJCSObntaxHh0Sxvj/Esx93IQ=;
        b=ilzZZfcSWcirWUeK0XagMp7feRsjm2KUvtSIRAOV4BzlMNPb2j/wSUUgJVcax0i6Zk
         FqRXHfhUBYTg4Valawe/kFf/cdtqnGfeCNDdUOv5AKTTDE//KQ+w6tUd2lON6/wLtmGE
         2bgnrkJQ4jXTadZXAqHYPvUMkQWPijq3KAK1GbnCYZuAT7orhR2OnHJcLIf3YitzN9vz
         1v8LfZCSQn6EZE95hUJ8UBeetfpzLzSJSv/NfKcXUwKRipwc00oLTdiuBtidjCcDdqZn
         a1O5e6fjWtndFhpfmNkSvSgPLaNLg7uuVHEKG+pyce3e9BHoHTNMXQrBdvcvfUC2+fWR
         EYuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gzsqNrbxHo0OcC1GphGJCSObntaxHh0Sxvj/Esx93IQ=;
        b=nvGrbKocnon5gqyfiMwhYqmeCJyCSOLIQaizWnsUnvwueixfJjzwaRC/+SMfLaN+20
         KM7+8EmW9c2oLILNXeEDwpZAL1ExtYRsEIBaR0lSEfW6NqJLZ+Y1S77BKRB79o28YRAe
         w4R/0LDuLP0M41MCmV5cfXz1DBJbFy0K3Pm3RwbJUPrCaagLFKb4HtUOj/4/5E/nce+v
         Lx1wEMwfr3AbUS7R/Cs+L+hZRnYBT3dsHczUMiWgeqTQ5Pu46HfVO3hZHZXAM+Gk+xpY
         CFbP3cq/yE8bOJLKlSgeeryXOfGraIQ87hReWMQZbRIz/bASzpdC37ZdiRf6UJdAUV4G
         h+7A==
X-Gm-Message-State: AFqh2kpLaiE3TUDtEkq8YO5fmW88yon6/Dk6/lCdLMI35RDxWon+ewUE
        6rDUq/xTW18GT/d0oIm6cdA=
X-Google-Smtp-Source: AMrXdXsonIed5RGvJTUyf5EJoU7UgpQhvl1SGxYWo4geApiRoNMiyzngTeNP1o/94hxuQ3koLTFs4A==
X-Received: by 2002:adf:ea02:0:b0:2bd:f549:e4c with SMTP id q2-20020adfea02000000b002bdf5490e4cmr5423080wrm.14.1674037719901;
        Wed, 18 Jan 2023 02:28:39 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id l7-20020a5d6747000000b002b57bae7174sm31400907wrw.5.2023.01.18.02.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 02:28:39 -0800 (PST)
Date:   Wed, 18 Jan 2023 13:28:21 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Christian Eggers <ceggers@arri.de>
Cc:     UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: dsa: microchip: ptp: Fix error code in
 ksz_hwtstamp_set()
Message-ID: <Y8fJxSvbl7UNVHh/@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to return negative error codes here but the copy_to/from_user()
functions return the number of bytes remaining to be copied.

Fixes: c59e12a140fb ("net: dsa: microchip: ptp: Initial hardware time stamping support")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 drivers/net/dsa/microchip/ksz_ptp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index a66a256f8814..4e22a695a64c 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -416,9 +416,8 @@ int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 
 	prt = &dev->ports[port];
 
-	ret = copy_from_user(&config, ifr->ifr_data, sizeof(config));
-	if (ret)
-		return ret;
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
 
 	ret = ksz_set_hwtstamp_config(dev, prt, &config);
 	if (ret)
@@ -426,7 +425,10 @@ int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 
 	memcpy(&prt->tstamp_config, &config, sizeof(config));
 
-	return copy_to_user(ifr->ifr_data, &config, sizeof(config));
+	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
+		return -EFAULT;
+
+	return 0;
 }
 
 static ktime_t ksz_tstamp_reconstruct(struct ksz_device *dev, ktime_t tstamp)
-- 
2.35.1

