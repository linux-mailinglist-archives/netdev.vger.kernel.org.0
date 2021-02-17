Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3719131D546
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 07:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhBQGHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 01:07:19 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:54226 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbhBQGGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 01:06:50 -0500
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 11H5ggsD032612;
        Wed, 17 Feb 2021 00:42:42 -0500
Received: from pbmxdp03.intersil.corp (pbmxdp03.pb.intersil.com [132.158.200.224])
        by pbmsgap02.intersil.com with ESMTP id 36p9tmscnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 00:42:42 -0500
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp03.intersil.corp (132.158.200.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Wed, 17 Feb 2021 00:42:40 -0500
Received: from localhost (132.158.202.108) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 17 Feb 2021 00:42:40 -0500
From:   <vincent.cheng.xh@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v3 net-next 4/7] ptp: ptp_clockmatrix: Clean-up dev_*() messages.
Date:   Wed, 17 Feb 2021 00:42:15 -0500
Message-ID: <1613540538-23792-5-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1613540538-23792-1-git-send-email-vincent.cheng.xh@renesas.com>
References: <1613540538-23792-1-git-send-email-vincent.cheng.xh@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_02:2021-02-16,2021-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 phishscore=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170042
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

Code clean-up.

* Remove unnecessary \n termination from dev_*() messages.
* Remove 'char *fmt' to define strings to stay within 80 column
  limit.  Not needed since coding guidelines increased to
  100 columns limit.
  Keeping format in place allows static code checkers to
  validate the arguments.
* Tighten up vertical spacing.

Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 122 +++++++++++++++---------------------------
 1 file changed, 43 insertions(+), 79 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index f597e4f..eec0a74 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -160,7 +160,6 @@ static int idtcm_xfer_read(struct idtcm *idtcm,
 	struct i2c_client *client = idtcm->client;
 	struct i2c_msg msg[2];
 	int cnt;
-	char *fmt = "i2c_transfer failed at %d in %s, at addr: %04X!\n";
 
 	msg[0].addr = client->addr;
 	msg[0].flags = 0;
@@ -176,14 +175,12 @@ static int idtcm_xfer_read(struct idtcm *idtcm,
 
 	if (cnt < 0) {
 		dev_err(&client->dev,
-			fmt,
-			__LINE__,
-			__func__,
-			regaddr);
+			"i2c_transfer failed at %d in %s, at addr: %04x!",
+			__LINE__, __func__, regaddr);
 		return cnt;
 	} else if (cnt != 2) {
 		dev_err(&client->dev,
-			"i2c_transfer sent only %d of %d messages\n", cnt, 2);
+			"i2c_transfer sent only %d of %d messages", cnt, 2);
 		return -EIO;
 	}
 
@@ -199,7 +196,6 @@ static int idtcm_xfer_write(struct idtcm *idtcm,
 	/* we add 1 byte for device register */
 	u8 msg[IDTCM_MAX_WRITE_COUNT + 1];
 	int cnt;
-	char *fmt = "i2c_master_send failed at %d in %s, at addr: %04X!\n";
 
 	if (count > IDTCM_MAX_WRITE_COUNT)
 		return -EINVAL;
@@ -211,10 +207,8 @@ static int idtcm_xfer_write(struct idtcm *idtcm,
 
 	if (cnt < 0) {
 		dev_err(&client->dev,
-			fmt,
-			__LINE__,
-			__func__,
-			regaddr);
+			"i2c_master_send failed at %d in %s, at addr: %04x!",
+			__LINE__, __func__, regaddr);
 		return cnt;
 	}
 
@@ -238,7 +232,7 @@ static int idtcm_page_offset(struct idtcm *idtcm, u8 val)
 
 	if (err) {
 		idtcm->page_offset = 0xff;
-		dev_err(&idtcm->client->dev, "failed to set page offset\n");
+		dev_err(&idtcm->client->dev, "failed to set page offset");
 	} else {
 		idtcm->page_offset = val;
 	}
@@ -330,7 +324,7 @@ static int wait_for_boot_status_ready(struct idtcm *idtcm)
 
 	} while (i);
 
-	dev_warn(&idtcm->client->dev, "%s timed out\n", __func__);
+	dev_warn(&idtcm->client->dev, "%s timed out", __func__);
 
 	return -EBUSY;
 }
@@ -811,7 +805,7 @@ static int _idtcm_set_dpll_scsr_tod(struct idtcm_channel *channel,
 
 		if (++count > 20) {
 			dev_err(&idtcm->client->dev,
-				"Timed out waiting for the write counter\n");
+				"Timed out waiting for the write counter");
 			return -EIO;
 		}
 	}
@@ -877,7 +871,7 @@ static int _idtcm_settime_deprecated(struct idtcm_channel *channel,
 
 	if (err) {
 		dev_err(&idtcm->client->dev,
-			"%s: Set HW ToD failed\n", __func__);
+			"%s: Set HW ToD failed", __func__);
 		return err;
 	}
 
@@ -1079,14 +1073,14 @@ static int idtcm_state_machine_reset(struct idtcm *idtcm)
 
 			if (status == 0xA0) {
 				dev_dbg(&idtcm->client->dev,
-					"SM_RESET completed in %d ms\n",
-					i * 100);
+					"SM_RESET completed in %d ms", i * 100);
 				break;
 			}
 		}
 
 		if (!status)
-			dev_err(&idtcm->client->dev, "Timed out waiting for CM_RESET to complete\n");
+			dev_err(&idtcm->client->dev,
+				"Timed out waiting for CM_RESET to complete");
 	}
 
 	return err;
@@ -1182,12 +1176,12 @@ static int set_pll_output_mask(struct idtcm *idtcm, u16 addr, u8 val)
 static int set_tod_ptp_pll(struct idtcm *idtcm, u8 index, u8 pll)
 {
 	if (index >= MAX_TOD) {
-		dev_err(&idtcm->client->dev, "ToD%d not supported\n", index);
+		dev_err(&idtcm->client->dev, "ToD%d not supported", index);
 		return -EINVAL;
 	}
 
 	if (pll >= MAX_PLL) {
-		dev_err(&idtcm->client->dev, "Pll%d not supported\n", pll);
+		dev_err(&idtcm->client->dev, "Pll%d not supported", pll);
 		return -EINVAL;
 	}
 
@@ -1205,8 +1199,7 @@ static int check_and_set_masks(struct idtcm *idtcm,
 	switch (regaddr) {
 	case TOD_MASK_ADDR:
 		if ((val & 0xf0) || !(val & 0x0f)) {
-			dev_err(&idtcm->client->dev,
-				"Invalid TOD mask 0x%hhx\n", val);
+			dev_err(&idtcm->client->dev, "Invalid TOD mask 0x%02x", val);
 			err = -EINVAL;
 		} else {
 			idtcm->tod_mask = val;
@@ -1237,14 +1230,14 @@ static void display_pll_and_masks(struct idtcm *idtcm)
 	u8 i;
 	u8 mask;
 
-	dev_dbg(&idtcm->client->dev, "tod_mask = 0x%02x\n", idtcm->tod_mask);
+	dev_dbg(&idtcm->client->dev, "tod_mask = 0x%02x", idtcm->tod_mask);
 
 	for (i = 0; i < MAX_TOD; i++) {
 		mask = 1 << i;
 
 		if (mask & idtcm->tod_mask)
 			dev_dbg(&idtcm->client->dev,
-				"TOD%d pll = %d    output_mask = 0x%04x\n",
+				"TOD%d pll = %d    output_mask = 0x%04x",
 				i, idtcm->channel[i].pll,
 				idtcm->channel[i].output_mask);
 	}
@@ -1265,19 +1258,16 @@ static int idtcm_load_firmware(struct idtcm *idtcm,
 	if (firmware) /* module parameter */
 		snprintf(fname, sizeof(fname), "%s", firmware);
 
-	dev_dbg(&idtcm->client->dev, "requesting firmware '%s'\n", fname);
+	dev_dbg(&idtcm->client->dev, "requesting firmware '%s'", fname);
 
 	err = request_firmware(&fw, fname, dev);
-
 	if (err) {
 		dev_err(&idtcm->client->dev,
-			"Failed at line %d in func %s!\n",
-			__LINE__,
-			__func__);
+			"Failed at line %d in %s!", __LINE__, __func__);
 		return err;
 	}
 
-	dev_dbg(&idtcm->client->dev, "firmware size %zu bytes\n", fw->size);
+	dev_dbg(&idtcm->client->dev, "firmware size %zu bytes", fw->size);
 
 	rec = (struct idtcm_fwrc *) fw->data;
 
@@ -1288,7 +1278,7 @@ static int idtcm_load_firmware(struct idtcm *idtcm,
 
 		if (rec->reserved) {
 			dev_err(&idtcm->client->dev,
-				"bad firmware, reserved field non-zero\n");
+				"bad firmware, reserved field non-zero");
 			err = -EINVAL;
 		} else {
 			regaddr = rec->hiaddr << 8;
@@ -1559,10 +1549,8 @@ static int idtcm_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 	err = _idtcm_gettime(channel, ts);
 
 	if (err)
-		dev_err(&idtcm->client->dev,
-			"Failed at line %d in func %s!\n",
-			__LINE__,
-			__func__);
+		dev_err(&idtcm->client->dev, "Failed at line %d in %s!",
+			__LINE__, __func__);
 
 	mutex_unlock(&idtcm->reg_lock);
 
@@ -1583,9 +1571,7 @@ static int idtcm_settime_deprecated(struct ptp_clock_info *ptp,
 
 	if (err)
 		dev_err(&idtcm->client->dev,
-			"Failed at line %d in func %s!\n",
-			__LINE__,
-			__func__);
+			"Failed at line %d in %s!", __LINE__, __func__);
 
 	mutex_unlock(&idtcm->reg_lock);
 
@@ -1606,9 +1592,7 @@ static int idtcm_settime(struct ptp_clock_info *ptp,
 
 	if (err)
 		dev_err(&idtcm->client->dev,
-			"Failed at line %d in func %s!\n",
-			__LINE__,
-			__func__);
+			"Failed at line %d in %s!", __LINE__, __func__);
 
 	mutex_unlock(&idtcm->reg_lock);
 
@@ -1628,9 +1612,7 @@ static int idtcm_adjtime_deprecated(struct ptp_clock_info *ptp, s64 delta)
 
 	if (err)
 		dev_err(&idtcm->client->dev,
-			"Failed at line %d in func %s!\n",
-			__LINE__,
-			__func__);
+			"Failed at line %d in %s!", __LINE__, __func__);
 
 	mutex_unlock(&idtcm->reg_lock);
 
@@ -1650,9 +1632,7 @@ static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
 		err = idtcm_do_phase_pull_in(channel, delta, 0);
 		if (err)
 			dev_err(&idtcm->client->dev,
-				"Failed at line %d in func %s!\n",
-				__LINE__,
-				__func__);
+				"Failed at line %d in %s!", __LINE__, __func__);
 		return err;
 	}
 
@@ -1670,9 +1650,7 @@ static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
 
 	if (err)
 		dev_err(&idtcm->client->dev,
-			"Failed at line %d in func %s!\n",
-			__LINE__,
-			__func__);
+			"Failed at line %d in %s!", __LINE__, __func__);
 
 	mutex_unlock(&idtcm->reg_lock);
 
@@ -1694,9 +1672,7 @@ static int idtcm_adjphase(struct ptp_clock_info *ptp, s32 delta)
 
 	if (err)
 		dev_err(&idtcm->client->dev,
-			"Failed at line %d in func %s!\n",
-			__LINE__,
-			__func__);
+			"Failed at line %d in %s!", __LINE__, __func__);
 
 	mutex_unlock(&idtcm->reg_lock);
 
@@ -1718,9 +1694,7 @@ static int idtcm_adjfine(struct ptp_clock_info *ptp,  long scaled_ppm)
 
 	if (err)
 		dev_err(&idtcm->client->dev,
-			"Failed at line %d in func %s!\n",
-			__LINE__,
-			__func__);
+			"Failed at line %d in %s!", __LINE__, __func__);
 
 	mutex_unlock(&idtcm->reg_lock);
 
@@ -1741,9 +1715,8 @@ static int idtcm_enable(struct ptp_clock_info *ptp,
 			err = idtcm_perout_enable(channel, false, &rq->perout);
 			if (err)
 				dev_err(&channel->idtcm->client->dev,
-					"Failed at line %d in func %s!\n",
-					__LINE__,
-					__func__);
+					"Failed at line %d in %s!",
+					__LINE__, __func__);
 			return err;
 		}
 
@@ -1755,9 +1728,7 @@ static int idtcm_enable(struct ptp_clock_info *ptp,
 		err = idtcm_perout_enable(channel, true, &rq->perout);
 		if (err)
 			dev_err(&channel->idtcm->client->dev,
-				"Failed at line %d in func %s!\n",
-				__LINE__,
-				__func__);
+				"Failed at line %d in %s!", __LINE__, __func__);
 		return err;
 	default:
 		break;
@@ -2025,7 +1996,6 @@ static void idtcm_set_version_info(struct idtcm *idtcm)
 	u16 product_id;
 	u8 hw_rev_id;
 	u8 config_select;
-	char *fmt = "%d.%d.%d, Id: 0x%04x  HW Rev: %d  OTP Config Select: %d\n";
 
 	idtcm_read_major_release(idtcm, &major);
 	idtcm_read_minor_release(idtcm, &minor);
@@ -2044,7 +2014,9 @@ static void idtcm_set_version_info(struct idtcm *idtcm)
 	else
 		idtcm->deprecated = 1;
 
-	dev_info(&idtcm->client->dev, fmt, major, minor, hotfix,
+	dev_info(&idtcm->client->dev,
+		 "%d.%d.%d, Id: 0x%04x  HW Rev: %d  OTP Config Select: %d",
+		 major, minor, hotfix,
 		 product_id, hw_rev_id, config_select);
 }
 
@@ -2203,9 +2175,7 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 		err = idtcm_enable_tod_sync(channel);
 		if (err) {
 			dev_err(&idtcm->client->dev,
-				"Failed at line %d in func %s!\n",
-				__LINE__,
-				__func__);
+				"Failed at line %d in %s!", __LINE__, __func__);
 			return err;
 		}
 	}
@@ -2214,16 +2184,14 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 	err = idtcm_get_pll_mode(channel, &channel->pll_mode);
 	if (err) {
 		dev_err(&idtcm->client->dev,
-			"Error: %s - Unable to read pll mode\n", __func__);
+			"Error: %s - Unable to read pll mode", __func__);
 		return err;
 	}
 
 	err = idtcm_enable_tod(channel);
 	if (err) {
 		dev_err(&idtcm->client->dev,
-			"Failed at line %d in func %s!\n",
-			__LINE__,
-			__func__);
+			"Failed at line %d in %s!", __LINE__, __func__);
 		return err;
 	}
 
@@ -2238,7 +2206,7 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 	if (!channel->ptp_clock)
 		return -ENOTSUPP;
 
-	dev_info(&idtcm->client->dev, "PLL%d registered as ptp%d\n",
+	dev_info(&idtcm->client->dev, "PLL%d registered as ptp%d",
 		 index, channel->ptp_clock->index);
 
 	return 0;
@@ -2279,7 +2247,6 @@ static int idtcm_probe(struct i2c_client *client,
 	struct idtcm *idtcm;
 	int err;
 	u8 i;
-	char *fmt = "Failed at %d in line %s with channel output %d!\n";
 
 	/* Unused for now */
 	(void)id;
@@ -2304,7 +2271,7 @@ static int idtcm_probe(struct i2c_client *client,
 
 	if (err)
 		dev_warn(&idtcm->client->dev,
-			 "loading firmware failed with %d\n", err);
+			 "loading firmware failed with %d", err);
 
 	wait_for_chip_ready(idtcm);
 
@@ -2314,17 +2281,14 @@ static int idtcm_probe(struct i2c_client *client,
 				err = idtcm_enable_channel(idtcm, i);
 				if (err) {
 					dev_err(&idtcm->client->dev,
-						fmt,
-						__LINE__,
-						__func__,
-						i);
+						"idtcm_enable_channel %d failed!", i);
 					break;
 				}
 			}
 		}
 	} else {
 		dev_err(&idtcm->client->dev,
-			"no PLLs flagged as PHCs, nothing to do\n");
+			"no PLLs flagged as PHCs, nothing to do");
 		err = -ENODEV;
 	}
 
-- 
2.7.4

