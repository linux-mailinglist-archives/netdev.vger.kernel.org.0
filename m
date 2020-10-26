Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75C8298ACC
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 11:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771910AbgJZKyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 06:54:08 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55228 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1771840AbgJZKyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 06:54:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id w23so10036363wmi.4
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 03:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yiNMa6xPQrJIpuyp/0urSXFKrH6T16qpG1JKmd9RQpI=;
        b=x1rOh5hsUnSHBj+pP1HAvNjFSYXYjq80GFMreuprwL+yPQgnC9reSnPZ/GeuIVRh6v
         atE+d7Oqngcat7l7Dx/eam+VR4kY/VBS+FVOanN4d07qyHpMy2wUB2bzoNLDQoxw+ALk
         2eoxh5DT4RGm3T+Rj9SWy2AmtksEi8WDRUzrMRzB+lTgPFEODhfz/Qj2x1kkR5mlMI44
         x2FVx6tagDFFO8Z/oxsAxohD83vGHq7MYW+xcv8CLigxWRAK34gf9U4xy8IgQpD36TMp
         m4Z0t6vDywrzZ34M0qHamBiaLyYaLSPB2xMBtepg51OWRCg/BMvMrSvoOn6owBTipTsh
         sVaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yiNMa6xPQrJIpuyp/0urSXFKrH6T16qpG1JKmd9RQpI=;
        b=HhMN2R3u+NooRYtKqHrFctJllLzjJP0IqKgSfcsiqi+VGfh/h0EDx3e/JQ2rdU4/T/
         ro1MOaEdVtzn6daTIgb9sP9h8EiXXAMN4HBCWypo2ilMmFmzJp3fEPgRopfNsiU6+trD
         0+QkLYiX9CAKvfVPD0JVNu/XHj37aYSg5E6nIXVxdtr4r7ZuLfBxOgTrErd1FspitAqv
         jfIZ/QSqe4h/onh1y0uIFoVV/SW/l/eErjyA32gWNTmI+PbTONs/nbpLa2Z6yGGYKKjU
         Qse4WLnABfpVUAxj3+eGI01gd13UIP+VWXWmNUGu57v0fctyXosBB11MseFeR5ZovCZc
         THdQ==
X-Gm-Message-State: AOAM533LI237tnihFN9p5q//+U43dd6nnC1H1X5UnyImTZEXX0Tidozr
        dVJpygnO0q6c0K6Dzaa4xiaKKw==
X-Google-Smtp-Source: ABdhPJxlmTtcKZexMuwqqZxPj6Ktwjq+m5phRCYo17F3udp1+Uf9Tf3JpqVbtHAZdG9vVk8vsuARmg==
X-Received: by 2002:a1c:1f89:: with SMTP id f131mr16121739wmf.10.1603709644030;
        Mon, 26 Oct 2020 03:54:04 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-190-206.w2-15.abo.wanadoo.fr. [2.15.39.206])
        by smtp.gmail.com with ESMTPSA id y4sm19121696wmj.2.2020.10.26.03.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 03:54:03 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <jdelvare@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH] hwmon: pmbus: shrink code and remove pmbus_do_remove()
Date:   Mon, 26 Oct 2020 11:53:52 +0100
Message-Id: <20201026105352.20359-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

The only action currently performed in pmbus_do_remove() is removing the
debugfs hierarchy. We can schedule a devm action at probe time and remove
pmbus_do_remove() entirely from all pmbus drivers.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/hwmon/pmbus/adm1266.c      |  1 -
 drivers/hwmon/pmbus/adm1275.c      |  1 -
 drivers/hwmon/pmbus/bel-pfe.c      |  1 -
 drivers/hwmon/pmbus/ibm-cffps.c    |  1 -
 drivers/hwmon/pmbus/inspur-ipsps.c |  1 -
 drivers/hwmon/pmbus/ir35221.c      |  1 -
 drivers/hwmon/pmbus/ir38064.c      |  1 -
 drivers/hwmon/pmbus/irps5401.c     |  1 -
 drivers/hwmon/pmbus/isl68137.c     |  1 -
 drivers/hwmon/pmbus/lm25066.c      |  1 -
 drivers/hwmon/pmbus/ltc2978.c      |  1 -
 drivers/hwmon/pmbus/ltc3815.c      |  1 -
 drivers/hwmon/pmbus/max16064.c     |  1 -
 drivers/hwmon/pmbus/max16601.c     |  1 -
 drivers/hwmon/pmbus/max20730.c     |  1 -
 drivers/hwmon/pmbus/max20751.c     |  1 -
 drivers/hwmon/pmbus/max31785.c     |  1 -
 drivers/hwmon/pmbus/max34440.c     |  1 -
 drivers/hwmon/pmbus/max8688.c      |  1 -
 drivers/hwmon/pmbus/mp2975.c       |  1 -
 drivers/hwmon/pmbus/pmbus.c        |  1 -
 drivers/hwmon/pmbus/pmbus.h        |  1 -
 drivers/hwmon/pmbus/pmbus_core.c   | 20 +++++++++-----------
 drivers/hwmon/pmbus/pxe1610.c      |  1 -
 drivers/hwmon/pmbus/tps40422.c     |  1 -
 drivers/hwmon/pmbus/tps53679.c     |  1 -
 drivers/hwmon/pmbus/ucd9000.c      |  1 -
 drivers/hwmon/pmbus/ucd9200.c      |  1 -
 drivers/hwmon/pmbus/xdpe12284.c    |  1 -
 drivers/hwmon/pmbus/zl6100.c       |  1 -
 30 files changed, 9 insertions(+), 40 deletions(-)

diff --git a/drivers/hwmon/pmbus/adm1266.c b/drivers/hwmon/pmbus/adm1266.c
index c7b373ba92f2..4d2e4ddcfbfd 100644
--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -502,7 +502,6 @@ static struct i2c_driver adm1266_driver = {
 		   .of_match_table = adm1266_of_match,
 		  },
 	.probe_new = adm1266_probe,
-	.remove = pmbus_do_remove,
 	.id_table = adm1266_id,
 };
 
diff --git a/drivers/hwmon/pmbus/adm1275.c b/drivers/hwmon/pmbus/adm1275.c
index e7997f37b266..38a6515b0763 100644
--- a/drivers/hwmon/pmbus/adm1275.c
+++ b/drivers/hwmon/pmbus/adm1275.c
@@ -797,7 +797,6 @@ static struct i2c_driver adm1275_driver = {
 		   .name = "adm1275",
 		   },
 	.probe_new = adm1275_probe,
-	.remove = pmbus_do_remove,
 	.id_table = adm1275_id,
 };
 
diff --git a/drivers/hwmon/pmbus/bel-pfe.c b/drivers/hwmon/pmbus/bel-pfe.c
index 2c5b853d6c7f..aed7542d7ce5 100644
--- a/drivers/hwmon/pmbus/bel-pfe.c
+++ b/drivers/hwmon/pmbus/bel-pfe.c
@@ -121,7 +121,6 @@ static struct i2c_driver pfe_pmbus_driver = {
 		   .name = "bel-pfe",
 	},
 	.probe_new = pfe_pmbus_probe,
-	.remove = pmbus_do_remove,
 	.id_table = pfe_device_id,
 };
 
diff --git a/drivers/hwmon/pmbus/ibm-cffps.c b/drivers/hwmon/pmbus/ibm-cffps.c
index 2fb7540ee952..d6bbbb223871 100644
--- a/drivers/hwmon/pmbus/ibm-cffps.c
+++ b/drivers/hwmon/pmbus/ibm-cffps.c
@@ -617,7 +617,6 @@ static struct i2c_driver ibm_cffps_driver = {
 		.of_match_table = ibm_cffps_of_match,
 	},
 	.probe_new = ibm_cffps_probe,
-	.remove = pmbus_do_remove,
 	.id_table = ibm_cffps_id,
 };
 
diff --git a/drivers/hwmon/pmbus/inspur-ipsps.c b/drivers/hwmon/pmbus/inspur-ipsps.c
index be493182174d..88c5865c4d6f 100644
--- a/drivers/hwmon/pmbus/inspur-ipsps.c
+++ b/drivers/hwmon/pmbus/inspur-ipsps.c
@@ -216,7 +216,6 @@ static struct i2c_driver ipsps_driver = {
 		.of_match_table = of_match_ptr(ipsps_of_match),
 	},
 	.probe_new = ipsps_probe,
-	.remove = pmbus_do_remove,
 	.id_table = ipsps_id,
 };
 
diff --git a/drivers/hwmon/pmbus/ir35221.c b/drivers/hwmon/pmbus/ir35221.c
index 5fadb1def49f..3aebeb1443fd 100644
--- a/drivers/hwmon/pmbus/ir35221.c
+++ b/drivers/hwmon/pmbus/ir35221.c
@@ -137,7 +137,6 @@ static struct i2c_driver ir35221_driver = {
 		.name	= "ir35221",
 	},
 	.probe_new	= ir35221_probe,
-	.remove		= pmbus_do_remove,
 	.id_table	= ir35221_id,
 };
 
diff --git a/drivers/hwmon/pmbus/ir38064.c b/drivers/hwmon/pmbus/ir38064.c
index 9ac563ce7dd8..46f17c4b4873 100644
--- a/drivers/hwmon/pmbus/ir38064.c
+++ b/drivers/hwmon/pmbus/ir38064.c
@@ -53,7 +53,6 @@ static struct i2c_driver ir38064_driver = {
 		   .name = "ir38064",
 		   },
 	.probe_new = ir38064_probe,
-	.remove = pmbus_do_remove,
 	.id_table = ir38064_id,
 };
 
diff --git a/drivers/hwmon/pmbus/irps5401.c b/drivers/hwmon/pmbus/irps5401.c
index 44aeafcbd56c..93ef6d64a33a 100644
--- a/drivers/hwmon/pmbus/irps5401.c
+++ b/drivers/hwmon/pmbus/irps5401.c
@@ -55,7 +55,6 @@ static struct i2c_driver irps5401_driver = {
 		   .name = "irps5401",
 		   },
 	.probe_new = irps5401_probe,
-	.remove = pmbus_do_remove,
 	.id_table = irps5401_id,
 };
 
diff --git a/drivers/hwmon/pmbus/isl68137.c b/drivers/hwmon/pmbus/isl68137.c
index 7cad76e07f70..2bee930d3900 100644
--- a/drivers/hwmon/pmbus/isl68137.c
+++ b/drivers/hwmon/pmbus/isl68137.c
@@ -324,7 +324,6 @@ static struct i2c_driver isl68137_driver = {
 		   .name = "isl68137",
 		   },
 	.probe_new = isl68137_probe,
-	.remove = pmbus_do_remove,
 	.id_table = raa_dmpvr_id,
 };
 
diff --git a/drivers/hwmon/pmbus/lm25066.c b/drivers/hwmon/pmbus/lm25066.c
index 429172a42902..c75a6bf39641 100644
--- a/drivers/hwmon/pmbus/lm25066.c
+++ b/drivers/hwmon/pmbus/lm25066.c
@@ -508,7 +508,6 @@ static struct i2c_driver lm25066_driver = {
 		   .name = "lm25066",
 		   },
 	.probe_new = lm25066_probe,
-	.remove = pmbus_do_remove,
 	.id_table = lm25066_id,
 };
 
diff --git a/drivers/hwmon/pmbus/ltc2978.c b/drivers/hwmon/pmbus/ltc2978.c
index 9a024cf70145..7e53fa95b92d 100644
--- a/drivers/hwmon/pmbus/ltc2978.c
+++ b/drivers/hwmon/pmbus/ltc2978.c
@@ -875,7 +875,6 @@ static struct i2c_driver ltc2978_driver = {
 		   .of_match_table = of_match_ptr(ltc2978_of_match),
 		   },
 	.probe_new = ltc2978_probe,
-	.remove = pmbus_do_remove,
 	.id_table = ltc2978_id,
 };
 
diff --git a/drivers/hwmon/pmbus/ltc3815.c b/drivers/hwmon/pmbus/ltc3815.c
index 8328fb367ad6..e45e14d26c9a 100644
--- a/drivers/hwmon/pmbus/ltc3815.c
+++ b/drivers/hwmon/pmbus/ltc3815.c
@@ -200,7 +200,6 @@ static struct i2c_driver ltc3815_driver = {
 		   .name = "ltc3815",
 		   },
 	.probe_new = ltc3815_probe,
-	.remove = pmbus_do_remove,
 	.id_table = ltc3815_id,
 };
 
diff --git a/drivers/hwmon/pmbus/max16064.c b/drivers/hwmon/pmbus/max16064.c
index 26e7f5ef9d7f..d79add99083e 100644
--- a/drivers/hwmon/pmbus/max16064.c
+++ b/drivers/hwmon/pmbus/max16064.c
@@ -103,7 +103,6 @@ static struct i2c_driver max16064_driver = {
 		   .name = "max16064",
 		   },
 	.probe_new = max16064_probe,
-	.remove = pmbus_do_remove,
 	.id_table = max16064_id,
 };
 
diff --git a/drivers/hwmon/pmbus/max16601.c b/drivers/hwmon/pmbus/max16601.c
index 71bb74e27a5c..a960b86e72d2 100644
--- a/drivers/hwmon/pmbus/max16601.c
+++ b/drivers/hwmon/pmbus/max16601.c
@@ -302,7 +302,6 @@ static struct i2c_driver max16601_driver = {
 		   .name = "max16601",
 		   },
 	.probe_new = max16601_probe,
-	.remove = pmbus_do_remove,
 	.id_table = max16601_id,
 };
 
diff --git a/drivers/hwmon/pmbus/max20730.c b/drivers/hwmon/pmbus/max20730.c
index 57923d72490c..bb0f38d9cfcc 100644
--- a/drivers/hwmon/pmbus/max20730.c
+++ b/drivers/hwmon/pmbus/max20730.c
@@ -779,7 +779,6 @@ static struct i2c_driver max20730_driver = {
 		.of_match_table = max20730_of_match,
 	},
 	.probe_new = max20730_probe,
-	.remove = pmbus_do_remove,
 	.id_table = max20730_id,
 };
 
diff --git a/drivers/hwmon/pmbus/max20751.c b/drivers/hwmon/pmbus/max20751.c
index 921e92d82aec..9d42f82fdd99 100644
--- a/drivers/hwmon/pmbus/max20751.c
+++ b/drivers/hwmon/pmbus/max20751.c
@@ -43,7 +43,6 @@ static struct i2c_driver max20751_driver = {
 		   .name = "max20751",
 		   },
 	.probe_new = max20751_probe,
-	.remove = pmbus_do_remove,
 	.id_table = max20751_id,
 };
 
diff --git a/drivers/hwmon/pmbus/max31785.c b/drivers/hwmon/pmbus/max31785.c
index 839b957bc03e..e5a9f4019cd5 100644
--- a/drivers/hwmon/pmbus/max31785.c
+++ b/drivers/hwmon/pmbus/max31785.c
@@ -390,7 +390,6 @@ static struct i2c_driver max31785_driver = {
 		.of_match_table = max31785_of_match,
 	},
 	.probe_new = max31785_probe,
-	.remove = pmbus_do_remove,
 	.id_table = max31785_id,
 };
 
diff --git a/drivers/hwmon/pmbus/max34440.c b/drivers/hwmon/pmbus/max34440.c
index f4cb196aaaf3..dad66b3c0116 100644
--- a/drivers/hwmon/pmbus/max34440.c
+++ b/drivers/hwmon/pmbus/max34440.c
@@ -521,7 +521,6 @@ static struct i2c_driver max34440_driver = {
 		   .name = "max34440",
 		   },
 	.probe_new = max34440_probe,
-	.remove = pmbus_do_remove,
 	.id_table = max34440_id,
 };
 
diff --git a/drivers/hwmon/pmbus/max8688.c b/drivers/hwmon/pmbus/max8688.c
index 4b2239a6afd3..329dc851fc59 100644
--- a/drivers/hwmon/pmbus/max8688.c
+++ b/drivers/hwmon/pmbus/max8688.c
@@ -183,7 +183,6 @@ static struct i2c_driver max8688_driver = {
 		   .name = "max8688",
 		   },
 	.probe_new = max8688_probe,
-	.remove = pmbus_do_remove,
 	.id_table = max8688_id,
 };
 
diff --git a/drivers/hwmon/pmbus/mp2975.c b/drivers/hwmon/pmbus/mp2975.c
index 1c3e2a9453b1..60fbdb371332 100644
--- a/drivers/hwmon/pmbus/mp2975.c
+++ b/drivers/hwmon/pmbus/mp2975.c
@@ -758,7 +758,6 @@ static struct i2c_driver mp2975_driver = {
 		.of_match_table = of_match_ptr(mp2975_of_match),
 	},
 	.probe_new = mp2975_probe,
-	.remove = pmbus_do_remove,
 	.id_table = mp2975_id,
 };
 
diff --git a/drivers/hwmon/pmbus/pmbus.c b/drivers/hwmon/pmbus/pmbus.c
index 20f1af9165c2..a1b4260e75b2 100644
--- a/drivers/hwmon/pmbus/pmbus.c
+++ b/drivers/hwmon/pmbus/pmbus.c
@@ -238,7 +238,6 @@ static struct i2c_driver pmbus_driver = {
 		   .name = "pmbus",
 		   },
 	.probe_new = pmbus_probe,
-	.remove = pmbus_do_remove,
 	.id_table = pmbus_id,
 };
 
diff --git a/drivers/hwmon/pmbus/pmbus.h b/drivers/hwmon/pmbus/pmbus.h
index 88a5df2633fb..4c30ec89f5bf 100644
--- a/drivers/hwmon/pmbus/pmbus.h
+++ b/drivers/hwmon/pmbus/pmbus.h
@@ -490,7 +490,6 @@ void pmbus_clear_faults(struct i2c_client *client);
 bool pmbus_check_byte_register(struct i2c_client *client, int page, int reg);
 bool pmbus_check_word_register(struct i2c_client *client, int page, int reg);
 int pmbus_do_probe(struct i2c_client *client, struct pmbus_driver_info *info);
-int pmbus_do_remove(struct i2c_client *client);
 const struct pmbus_driver_info *pmbus_get_driver_info(struct i2c_client
 						      *client);
 int pmbus_get_fan_rate_device(struct i2c_client *client, int page, int id,
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 170a9f82ca61..996393339be3 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -2388,6 +2388,13 @@ static int pmbus_debugfs_set_pec(void *data, u64 val)
 DEFINE_DEBUGFS_ATTRIBUTE(pmbus_debugfs_ops_pec, pmbus_debugfs_get_pec,
 			 pmbus_debugfs_set_pec, "%llu\n");
 
+static void pmbus_remove_debugfs(void *data)
+{
+	struct dentry *entry = data;
+
+	debugfs_remove_recursive(entry);
+}
+
 static int pmbus_init_debugfs(struct i2c_client *client,
 			      struct pmbus_data *data)
 {
@@ -2523,7 +2530,8 @@ static int pmbus_init_debugfs(struct i2c_client *client,
 		}
 	}
 
-	return 0;
+	return devm_add_action_or_reset(data->dev,
+					pmbus_remove_debugfs, data->debugfs);
 }
 #else
 static int pmbus_init_debugfs(struct i2c_client *client,
@@ -2610,16 +2618,6 @@ int pmbus_do_probe(struct i2c_client *client, struct pmbus_driver_info *info)
 }
 EXPORT_SYMBOL_GPL(pmbus_do_probe);
 
-int pmbus_do_remove(struct i2c_client *client)
-{
-	struct pmbus_data *data = i2c_get_clientdata(client);
-
-	debugfs_remove_recursive(data->debugfs);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(pmbus_do_remove);
-
 struct dentry *pmbus_get_debugfs_dir(struct i2c_client *client)
 {
 	struct pmbus_data *data = i2c_get_clientdata(client);
diff --git a/drivers/hwmon/pmbus/pxe1610.c b/drivers/hwmon/pmbus/pxe1610.c
index fa5c5dd29b7a..da27ce34ee3f 100644
--- a/drivers/hwmon/pmbus/pxe1610.c
+++ b/drivers/hwmon/pmbus/pxe1610.c
@@ -131,7 +131,6 @@ static struct i2c_driver pxe1610_driver = {
 			.name = "pxe1610",
 			},
 	.probe_new = pxe1610_probe,
-	.remove = pmbus_do_remove,
 	.id_table = pxe1610_id,
 };
 
diff --git a/drivers/hwmon/pmbus/tps40422.c b/drivers/hwmon/pmbus/tps40422.c
index edbdfa809d51..f7f00ab6f46c 100644
--- a/drivers/hwmon/pmbus/tps40422.c
+++ b/drivers/hwmon/pmbus/tps40422.c
@@ -43,7 +43,6 @@ static struct i2c_driver tps40422_driver = {
 		   .name = "tps40422",
 		   },
 	.probe_new = tps40422_probe,
-	.remove = pmbus_do_remove,
 	.id_table = tps40422_id,
 };
 
diff --git a/drivers/hwmon/pmbus/tps53679.c b/drivers/hwmon/pmbus/tps53679.c
index db2bdf2a1f02..ba838fa311c3 100644
--- a/drivers/hwmon/pmbus/tps53679.c
+++ b/drivers/hwmon/pmbus/tps53679.c
@@ -251,7 +251,6 @@ static struct i2c_driver tps53679_driver = {
 		.of_match_table = of_match_ptr(tps53679_of_match),
 	},
 	.probe_new = tps53679_probe,
-	.remove = pmbus_do_remove,
 	.id_table = tps53679_id,
 };
 
diff --git a/drivers/hwmon/pmbus/ucd9000.c b/drivers/hwmon/pmbus/ucd9000.c
index f8017993e2b4..a15e6fe3e425 100644
--- a/drivers/hwmon/pmbus/ucd9000.c
+++ b/drivers/hwmon/pmbus/ucd9000.c
@@ -621,7 +621,6 @@ static struct i2c_driver ucd9000_driver = {
 		.of_match_table = of_match_ptr(ucd9000_of_match),
 	},
 	.probe_new = ucd9000_probe,
-	.remove = pmbus_do_remove,
 	.id_table = ucd9000_id,
 };
 
diff --git a/drivers/hwmon/pmbus/ucd9200.c b/drivers/hwmon/pmbus/ucd9200.c
index e111e25e1619..47cc7ca9d329 100644
--- a/drivers/hwmon/pmbus/ucd9200.c
+++ b/drivers/hwmon/pmbus/ucd9200.c
@@ -201,7 +201,6 @@ static struct i2c_driver ucd9200_driver = {
 		.of_match_table = of_match_ptr(ucd9200_of_match),
 	},
 	.probe_new = ucd9200_probe,
-	.remove = pmbus_do_remove,
 	.id_table = ucd9200_id,
 };
 
diff --git a/drivers/hwmon/pmbus/xdpe12284.c b/drivers/hwmon/pmbus/xdpe12284.c
index c95ac934fde4..f8bc0f41cd5f 100644
--- a/drivers/hwmon/pmbus/xdpe12284.c
+++ b/drivers/hwmon/pmbus/xdpe12284.c
@@ -160,7 +160,6 @@ static struct i2c_driver xdpe122_driver = {
 		.of_match_table = of_match_ptr(xdpe122_of_match),
 	},
 	.probe_new = xdpe122_probe,
-	.remove = pmbus_do_remove,
 	.id_table = xdpe122_id,
 };
 
diff --git a/drivers/hwmon/pmbus/zl6100.c b/drivers/hwmon/pmbus/zl6100.c
index e8bda340482b..69120ca7aaa8 100644
--- a/drivers/hwmon/pmbus/zl6100.c
+++ b/drivers/hwmon/pmbus/zl6100.c
@@ -396,7 +396,6 @@ static struct i2c_driver zl6100_driver = {
 		   .name = "zl6100",
 		   },
 	.probe_new = zl6100_probe,
-	.remove = pmbus_do_remove,
 	.id_table = zl6100_id,
 };
 
-- 
2.29.1

