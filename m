Return-Path: <netdev+bounces-4081-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0475A70A971
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 19:22:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D73ED1C20974
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 17:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4D378C0F;
	Sat, 20 May 2023 17:22:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38DA33EE
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 17:22:08 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1867ADF
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 10:22:07 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q0QGl-0007uj-BA; Sat, 20 May 2023 19:21:27 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q0QGY-001aYA-Rt; Sat, 20 May 2023 19:21:14 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q0QGY-006L8N-3j; Sat, 20 May 2023 19:21:14 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vladimir Oltean <olteanv@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Corey Minyard <cminyard@mvista.com>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Kang Chen <void0red@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Rob Herring <robh@kernel.org>,
	Michael Walle <michael@walle.cc>,
	Benjamin Mugnier <benjamin.mugnier@foss.st.com>,
	=?utf-8?q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
	Petr Machata <petrm@nvidia.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Jean Delvare <jdelvare@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Adrien Grassein <adrien.grassein@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>
Cc: netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH net-next] nfc: Switch i2c drivers back to use .probe()
Date: Sat, 20 May 2023 19:21:04 +0200
Message-Id: <20230520172104.359597-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=5777; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=xU9nqhYFOnd/5F9QNv0QPxuFWzfiN5PdPWUqJuv7OLU=; b=owGbwMvMwMXY3/A7olbonx/jabUkhpRMxprutnbRuDsJzwK8RL2qNjnEBf38slnS4fI0Yf2/g itnBCl0MhqzMDByMciKKbLYN67JtKqSi+xc++8yzCBWJpApDFycAjARYQ/2/w7cASKZigdO+cx/ HBqRbV4Qd4PZ1lrvRaX7x+IljX9aPcK7ph1XcIr/1865Im3Xt/Bjp3PN1m3KY3Ze78a8U+Dd1v1 XTuuc41/Bu9CzfP26V5XNCtVGT5qZk575pIZ+L9J/H80tX8GUkiTup7Pn/bejQt93S/52rw0V9Q 8/cD/b1iylxXQn89L064818wIMfzt8PhK70+n6sjNHjbqkr3kIVX//NWG3jlq5V9DrMl6VO0kSH N97vu6TqolY4fu4rkzJKW+Kk3/Hce6/rr1CKnMX8y35GK9svUDtu98KV9WapyUSr/YcbU6srZl0 fRrniojnzy7Ol5i7PajvRPkV86LTKw6crVURc+1YdGsVAA==
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

After commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
call-back type"), all drivers being converted to .probe_new() and then
03c835f498b5 ("i2c: Switch .probe() to not take an id parameter")
convert back to (the new) .probe() to be able to eventually drop
.probe_new() from struct i2c_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

this patch was generated using coccinelle, but I aligned the result to
the per-file indention.

This is one patch for the whole iio subsystem. if you want it split per
driver for improved patch count numbers, please tell me.

This currently fits on top of 6.4-rc1 and next/master. If you apply it
somewhere else and get conflicts, feel free to just drop the files with
conflicts from this patch and apply anyhow. I'll care about the fallout
later then.

Best regards
Uwe

 drivers/nfc/fdp/i2c.c       | 2 +-
 drivers/nfc/microread/i2c.c | 2 +-
 drivers/nfc/nfcmrvl/i2c.c   | 2 +-
 drivers/nfc/nxp-nci/i2c.c   | 2 +-
 drivers/nfc/pn533/i2c.c     | 2 +-
 drivers/nfc/pn544/i2c.c     | 2 +-
 drivers/nfc/s3fwrn5/i2c.c   | 2 +-
 drivers/nfc/st-nci/i2c.c    | 2 +-
 drivers/nfc/st21nfca/i2c.c  | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 1e0f2297f9c6..c1896a1d978c 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -359,7 +359,7 @@ static struct i2c_driver fdp_nci_i2c_driver = {
 		   .name = FDP_I2C_DRIVER_NAME,
 		   .acpi_match_table = fdp_nci_i2c_acpi_match,
 		  },
-	.probe_new = fdp_nci_i2c_probe,
+	.probe = fdp_nci_i2c_probe,
 	.remove = fdp_nci_i2c_remove,
 };
 module_i2c_driver(fdp_nci_i2c_driver);
diff --git a/drivers/nfc/microread/i2c.c b/drivers/nfc/microread/i2c.c
index e72b358a2a12..642df4e0ce24 100644
--- a/drivers/nfc/microread/i2c.c
+++ b/drivers/nfc/microread/i2c.c
@@ -286,7 +286,7 @@ static struct i2c_driver microread_i2c_driver = {
 	.driver = {
 		.name = MICROREAD_I2C_DRIVER_NAME,
 	},
-	.probe_new	= microread_i2c_probe,
+	.probe		= microread_i2c_probe,
 	.remove		= microread_i2c_remove,
 	.id_table	= microread_i2c_id,
 };
diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index 164e2ab859fd..74553134c1b1 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -258,7 +258,7 @@ static const struct i2c_device_id nfcmrvl_i2c_id_table[] = {
 MODULE_DEVICE_TABLE(i2c, nfcmrvl_i2c_id_table);
 
 static struct i2c_driver nfcmrvl_i2c_driver = {
-	.probe_new = nfcmrvl_i2c_probe,
+	.probe = nfcmrvl_i2c_probe,
 	.id_table = nfcmrvl_i2c_id_table,
 	.remove = nfcmrvl_i2c_remove,
 	.driver = {
diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index d4c299be7949..baddaf242d18 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -348,7 +348,7 @@ static struct i2c_driver nxp_nci_i2c_driver = {
 		   .acpi_match_table = ACPI_PTR(acpi_id),
 		   .of_match_table = of_nxp_nci_i2c_match,
 		  },
-	.probe_new = nxp_nci_i2c_probe,
+	.probe = nxp_nci_i2c_probe,
 	.id_table = nxp_nci_i2c_id_table,
 	.remove = nxp_nci_i2c_remove,
 };
diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index 1503a98f0405..438ab9553f7a 100644
--- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -259,7 +259,7 @@ static struct i2c_driver pn533_i2c_driver = {
 		   .name = PN533_I2C_DRIVER_NAME,
 		   .of_match_table = of_match_ptr(of_pn533_i2c_match),
 		  },
-	.probe_new = pn533_i2c_probe,
+	.probe = pn533_i2c_probe,
 	.id_table = pn533_i2c_id_table,
 	.remove = pn533_i2c_remove,
 };
diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 8b0d910bee06..3f6d74832bac 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -953,7 +953,7 @@ static struct i2c_driver pn544_hci_i2c_driver = {
 		   .of_match_table = of_match_ptr(of_pn544_i2c_match),
 		   .acpi_match_table = ACPI_PTR(pn544_hci_i2c_acpi_match),
 		  },
-	.probe_new = pn544_hci_i2c_probe,
+	.probe = pn544_hci_i2c_probe,
 	.id_table = pn544_hci_i2c_id_table,
 	.remove = pn544_hci_i2c_remove,
 };
diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index 2517ae71f9a4..720d4a72493c 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -261,7 +261,7 @@ static struct i2c_driver s3fwrn5_i2c_driver = {
 		.name = S3FWRN5_I2C_DRIVER_NAME,
 		.of_match_table = of_match_ptr(of_s3fwrn5_i2c_match),
 	},
-	.probe_new = s3fwrn5_i2c_probe,
+	.probe = s3fwrn5_i2c_probe,
 	.remove = s3fwrn5_i2c_remove,
 	.id_table = s3fwrn5_i2c_id_table,
 };
diff --git a/drivers/nfc/st-nci/i2c.c b/drivers/nfc/st-nci/i2c.c
index 6b5eed8a1fbe..d20a337e90b4 100644
--- a/drivers/nfc/st-nci/i2c.c
+++ b/drivers/nfc/st-nci/i2c.c
@@ -283,7 +283,7 @@ static struct i2c_driver st_nci_i2c_driver = {
 		.of_match_table = of_match_ptr(of_st_nci_i2c_match),
 		.acpi_match_table = ACPI_PTR(st_nci_i2c_acpi_match),
 	},
-	.probe_new = st_nci_i2c_probe,
+	.probe = st_nci_i2c_probe,
 	.id_table = st_nci_i2c_id_table,
 	.remove = st_nci_i2c_remove,
 };
diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 55f7a2391bb1..064a63db288b 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -597,7 +597,7 @@ static struct i2c_driver st21nfca_hci_i2c_driver = {
 		.of_match_table = of_match_ptr(of_st21nfca_i2c_match),
 		.acpi_match_table = ACPI_PTR(st21nfca_hci_i2c_acpi_match),
 	},
-	.probe_new = st21nfca_hci_i2c_probe,
+	.probe = st21nfca_hci_i2c_probe,
 	.id_table = st21nfca_hci_i2c_id_table,
 	.remove = st21nfca_hci_i2c_remove,
 };

base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
2.39.2


