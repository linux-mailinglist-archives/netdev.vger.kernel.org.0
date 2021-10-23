Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191814384F7
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 21:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhJWTfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 15:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhJWTew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 15:34:52 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D86FC061348
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:33 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so5397102pjb.3
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=92kKs2aFwXVwtwF2gg1HPInmDVMYCaO5tWc3htrXuAo=;
        b=A1MosmwtE1mg6V8rKmvr3lMqo15+Iwb1Ye9+zopuF5uOMYBR4tCSuF/y7C5hrNH6XF
         p6mmc0Nh3z6XfarnWwIl/HLPK7LoharBwOuyPf05Z0yh2Rfk9jD0FqRI0lDMIMQZHIxO
         0PmytTeOEmq3Yfr+YBs9Kn+RlLwZEyLGd3e+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=92kKs2aFwXVwtwF2gg1HPInmDVMYCaO5tWc3htrXuAo=;
        b=LEj8ZX3IPCtu/2hytkWOZzKctPvhh/GhAX/L9KPGUVcWJI1BP9XI0KmsIR73OliAuM
         zIe/ljbrj+kOoXGhfRXfiImiut85+5r47s1B+50F06dxrXbP7FpkW3aLcXs/15uS75BW
         1KYkvAo9ULcP0r/imQ9CGfb5p1iUQuk/2HqoNGFv4zrWbq6tyjRXVbmSfiNyfTrhl+ec
         L0RTS6wGUspx6iOhZqX8v6ZmLSxi7jpxyA3CEaIO+3BhXidwQyZ+ITogiFJIdTBtMutV
         qGbytoSiBVQiHjmEL9bwYwHMh4LcYs20K2VKWa2rSJ1oEzahxj9UElDipSOf4EXbXu18
         yYOQ==
X-Gm-Message-State: AOAM5329R/tMIGGTDtJzpBibZBZyLC6b7GukBq8a7/m5NCQYxwLFYjN8
        ggyVNqcMZ/DtFJRjdGKS79hpwQ==
X-Google-Smtp-Source: ABdhPJzdw4GPsf+Uib0M327+7WYREVWs/979CpABrFGh8mJYZQ60wslruxafTEzCIUV6NHPGuPlQwA==
X-Received: by 2002:a17:902:7106:b0:13f:aaf4:3e91 with SMTP id a6-20020a170902710600b0013faaf43e91mr7472495pll.84.1635017552402;
        Sat, 23 Oct 2021 12:32:32 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f7sm2461532pfv.152.2021.10.23.12.32.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Oct 2021 12:32:31 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, jiri@nvidia.com
Subject: [PATCH net-next 11/19] bnxt_en: move coredump functions into dedicated file
Date:   Sat, 23 Oct 2021 15:31:58 -0400
Message-Id: <1635017526-16963-12-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
References: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000767c5805cf0a30b5"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000767c5805cf0a30b5

From: Edwin Peer <edwin.peer@broadcom.com>

Change bnxt_get_coredump() and bnxt_get_coredump_length() to non-static
functions.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/Makefile   |   2 +-
 .../ethernet/broadcom/bnxt/bnxt_coredump.c    | 372 ++++++++++++++++++
 .../ethernet/broadcom/bnxt/bnxt_coredump.h    |  51 +++
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 356 -----------------
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  43 --
 5 files changed, 424 insertions(+), 400 deletions(-)
 create mode 100644 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c

diff --git a/drivers/net/ethernet/broadcom/bnxt/Makefile b/drivers/net/ethernet/broadcom/bnxt/Makefile
index c6ef7ec2c115..2bc2b707d6ee 100644
--- a/drivers/net/ethernet/broadcom/bnxt/Makefile
+++ b/drivers/net/ethernet/broadcom/bnxt/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_BNXT) += bnxt_en.o
 
-bnxt_en-y := bnxt.o bnxt_hwrm.o bnxt_sriov.o bnxt_ethtool.o bnxt_dcb.o bnxt_ulp.o bnxt_xdp.o bnxt_ptp.o bnxt_vfr.o bnxt_devlink.o bnxt_dim.o
+bnxt_en-y := bnxt.o bnxt_hwrm.o bnxt_sriov.o bnxt_ethtool.o bnxt_dcb.o bnxt_ulp.o bnxt_xdp.o bnxt_ptp.o bnxt_vfr.o bnxt_devlink.o bnxt_dim.o bnxt_coredump.o
 bnxt_en-$(CONFIG_BNXT_FLOWER_OFFLOAD) += bnxt_tc.o
 bnxt_en-$(CONFIG_DEBUG_FS) += bnxt_debugfs.o
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
new file mode 100644
index 000000000000..3e23fce3771e
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
@@ -0,0 +1,372 @@
+/* Broadcom NetXtreme-C/E network driver.
+ *
+ * Copyright (c) 2021 Broadcom Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include "bnxt_hsi.h"
+#include "bnxt.h"
+#include "bnxt_hwrm.h"
+#include "bnxt_coredump.h"
+
+static int bnxt_hwrm_dbg_dma_data(struct bnxt *bp, void *msg,
+				  struct bnxt_hwrm_dbg_dma_info *info)
+{
+	struct hwrm_dbg_cmn_input *cmn_req = msg;
+	__le16 *seq_ptr = msg + info->seq_off;
+	struct hwrm_dbg_cmn_output *cmn_resp;
+	u16 seq = 0, len, segs_off;
+	dma_addr_t dma_handle;
+	void *dma_buf, *resp;
+	int rc, off = 0;
+
+	dma_buf = hwrm_req_dma_slice(bp, msg, info->dma_len, &dma_handle);
+	if (!dma_buf) {
+		hwrm_req_drop(bp, msg);
+		return -ENOMEM;
+	}
+
+	hwrm_req_timeout(bp, msg, HWRM_COREDUMP_TIMEOUT);
+	cmn_resp = hwrm_req_hold(bp, msg);
+	resp = cmn_resp;
+
+	segs_off = offsetof(struct hwrm_dbg_coredump_list_output,
+			    total_segments);
+	cmn_req->host_dest_addr = cpu_to_le64(dma_handle);
+	cmn_req->host_buf_len = cpu_to_le32(info->dma_len);
+	while (1) {
+		*seq_ptr = cpu_to_le16(seq);
+		rc = hwrm_req_send(bp, msg);
+		if (rc)
+			break;
+
+		len = le16_to_cpu(*((__le16 *)(resp + info->data_len_off)));
+		if (!seq &&
+		    cmn_req->req_type == cpu_to_le16(HWRM_DBG_COREDUMP_LIST)) {
+			info->segs = le16_to_cpu(*((__le16 *)(resp +
+							      segs_off)));
+			if (!info->segs) {
+				rc = -EIO;
+				break;
+			}
+
+			info->dest_buf_size = info->segs *
+					sizeof(struct coredump_segment_record);
+			info->dest_buf = kmalloc(info->dest_buf_size,
+						 GFP_KERNEL);
+			if (!info->dest_buf) {
+				rc = -ENOMEM;
+				break;
+			}
+		}
+
+		if (info->dest_buf) {
+			if ((info->seg_start + off + len) <=
+			    BNXT_COREDUMP_BUF_LEN(info->buf_len)) {
+				memcpy(info->dest_buf + off, dma_buf, len);
+			} else {
+				rc = -ENOBUFS;
+				break;
+			}
+		}
+
+		if (cmn_req->req_type ==
+				cpu_to_le16(HWRM_DBG_COREDUMP_RETRIEVE))
+			info->dest_buf_size += len;
+
+		if (!(cmn_resp->flags & HWRM_DBG_CMN_FLAGS_MORE))
+			break;
+
+		seq++;
+		off += len;
+	}
+	hwrm_req_drop(bp, msg);
+	return rc;
+}
+
+static int bnxt_hwrm_dbg_coredump_list(struct bnxt *bp,
+				       struct bnxt_coredump *coredump)
+{
+	struct bnxt_hwrm_dbg_dma_info info = {NULL};
+	struct hwrm_dbg_coredump_list_input *req;
+	int rc;
+
+	rc = hwrm_req_init(bp, req, HWRM_DBG_COREDUMP_LIST);
+	if (rc)
+		return rc;
+
+	info.dma_len = COREDUMP_LIST_BUF_LEN;
+	info.seq_off = offsetof(struct hwrm_dbg_coredump_list_input, seq_no);
+	info.data_len_off = offsetof(struct hwrm_dbg_coredump_list_output,
+				     data_len);
+
+	rc = bnxt_hwrm_dbg_dma_data(bp, req, &info);
+	if (!rc) {
+		coredump->data = info.dest_buf;
+		coredump->data_size = info.dest_buf_size;
+		coredump->total_segs = info.segs;
+	}
+	return rc;
+}
+
+static int bnxt_hwrm_dbg_coredump_initiate(struct bnxt *bp, u16 component_id,
+					   u16 segment_id)
+{
+	struct hwrm_dbg_coredump_initiate_input *req;
+	int rc;
+
+	rc = hwrm_req_init(bp, req, HWRM_DBG_COREDUMP_INITIATE);
+	if (rc)
+		return rc;
+
+	hwrm_req_timeout(bp, req, HWRM_COREDUMP_TIMEOUT);
+	req->component_id = cpu_to_le16(component_id);
+	req->segment_id = cpu_to_le16(segment_id);
+
+	return hwrm_req_send(bp, req);
+}
+
+static int bnxt_hwrm_dbg_coredump_retrieve(struct bnxt *bp, u16 component_id,
+					   u16 segment_id, u32 *seg_len,
+					   void *buf, u32 buf_len, u32 offset)
+{
+	struct hwrm_dbg_coredump_retrieve_input *req;
+	struct bnxt_hwrm_dbg_dma_info info = {NULL};
+	int rc;
+
+	rc = hwrm_req_init(bp, req, HWRM_DBG_COREDUMP_RETRIEVE);
+	if (rc)
+		return rc;
+
+	req->component_id = cpu_to_le16(component_id);
+	req->segment_id = cpu_to_le16(segment_id);
+
+	info.dma_len = COREDUMP_RETRIEVE_BUF_LEN;
+	info.seq_off = offsetof(struct hwrm_dbg_coredump_retrieve_input,
+				seq_no);
+	info.data_len_off = offsetof(struct hwrm_dbg_coredump_retrieve_output,
+				     data_len);
+	if (buf) {
+		info.dest_buf = buf + offset;
+		info.buf_len = buf_len;
+		info.seg_start = offset;
+	}
+
+	rc = bnxt_hwrm_dbg_dma_data(bp, req, &info);
+	if (!rc)
+		*seg_len = info.dest_buf_size;
+
+	return rc;
+}
+
+static void
+bnxt_fill_coredump_seg_hdr(struct bnxt *bp,
+			   struct bnxt_coredump_segment_hdr *seg_hdr,
+			   struct coredump_segment_record *seg_rec, u32 seg_len,
+			   int status, u32 duration, u32 instance)
+{
+	memset(seg_hdr, 0, sizeof(*seg_hdr));
+	memcpy(seg_hdr->signature, "sEgM", 4);
+	if (seg_rec) {
+		seg_hdr->component_id = (__force __le32)seg_rec->component_id;
+		seg_hdr->segment_id = (__force __le32)seg_rec->segment_id;
+		seg_hdr->low_version = seg_rec->version_low;
+		seg_hdr->high_version = seg_rec->version_hi;
+	} else {
+		/* For hwrm_ver_get response Component id = 2
+		 * and Segment id = 0
+		 */
+		seg_hdr->component_id = cpu_to_le32(2);
+		seg_hdr->segment_id = 0;
+	}
+	seg_hdr->function_id = cpu_to_le16(bp->pdev->devfn);
+	seg_hdr->length = cpu_to_le32(seg_len);
+	seg_hdr->status = cpu_to_le32(status);
+	seg_hdr->duration = cpu_to_le32(duration);
+	seg_hdr->data_offset = cpu_to_le32(sizeof(*seg_hdr));
+	seg_hdr->instance = cpu_to_le32(instance);
+}
+
+static void
+bnxt_fill_coredump_record(struct bnxt *bp, struct bnxt_coredump_record *record,
+			  time64_t start, s16 start_utc, u16 total_segs,
+			  int status)
+{
+	time64_t end = ktime_get_real_seconds();
+	u32 os_ver_major = 0, os_ver_minor = 0;
+	struct tm tm;
+
+	time64_to_tm(start, 0, &tm);
+	memset(record, 0, sizeof(*record));
+	memcpy(record->signature, "cOrE", 4);
+	record->flags = 0;
+	record->low_version = 0;
+	record->high_version = 1;
+	record->asic_state = 0;
+	strscpy(record->system_name, utsname()->nodename,
+		sizeof(record->system_name));
+	record->year = cpu_to_le16(tm.tm_year + 1900);
+	record->month = cpu_to_le16(tm.tm_mon + 1);
+	record->day = cpu_to_le16(tm.tm_mday);
+	record->hour = cpu_to_le16(tm.tm_hour);
+	record->minute = cpu_to_le16(tm.tm_min);
+	record->second = cpu_to_le16(tm.tm_sec);
+	record->utc_bias = cpu_to_le16(start_utc);
+	strcpy(record->commandline, "ethtool -w");
+	record->total_segments = cpu_to_le32(total_segs);
+
+	if (sscanf(utsname()->release, "%u.%u", &os_ver_major, &os_ver_minor) != 2)
+		netdev_warn(bp->dev, "Unknown OS release in coredump\n");
+	record->os_ver_major = cpu_to_le32(os_ver_major);
+	record->os_ver_minor = cpu_to_le32(os_ver_minor);
+
+	strscpy(record->os_name, utsname()->sysname, sizeof(record->os_name));
+	time64_to_tm(end, 0, &tm);
+	record->end_year = cpu_to_le16(tm.tm_year + 1900);
+	record->end_month = cpu_to_le16(tm.tm_mon + 1);
+	record->end_day = cpu_to_le16(tm.tm_mday);
+	record->end_hour = cpu_to_le16(tm.tm_hour);
+	record->end_minute = cpu_to_le16(tm.tm_min);
+	record->end_second = cpu_to_le16(tm.tm_sec);
+	record->end_utc_bias = cpu_to_le16(sys_tz.tz_minuteswest * 60);
+	record->asic_id1 = cpu_to_le32(bp->chip_num << 16 |
+				       bp->ver_resp.chip_rev << 8 |
+				       bp->ver_resp.chip_metal);
+	record->asic_id2 = 0;
+	record->coredump_status = cpu_to_le32(status);
+	record->ioctl_low_version = 0;
+	record->ioctl_high_version = 0;
+}
+
+static int __bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
+{
+	u32 ver_get_resp_len = sizeof(struct hwrm_ver_get_output);
+	u32 offset = 0, seg_hdr_len, seg_record_len, buf_len = 0;
+	struct coredump_segment_record *seg_record = NULL;
+	struct bnxt_coredump_segment_hdr seg_hdr;
+	struct bnxt_coredump coredump = {NULL};
+	time64_t start_time;
+	u16 start_utc;
+	int rc = 0, i;
+
+	if (buf)
+		buf_len = *dump_len;
+
+	start_time = ktime_get_real_seconds();
+	start_utc = sys_tz.tz_minuteswest * 60;
+	seg_hdr_len = sizeof(seg_hdr);
+
+	/* First segment should be hwrm_ver_get response */
+	*dump_len = seg_hdr_len + ver_get_resp_len;
+	if (buf) {
+		bnxt_fill_coredump_seg_hdr(bp, &seg_hdr, NULL, ver_get_resp_len,
+					   0, 0, 0);
+		memcpy(buf + offset, &seg_hdr, seg_hdr_len);
+		offset += seg_hdr_len;
+		memcpy(buf + offset, &bp->ver_resp, ver_get_resp_len);
+		offset += ver_get_resp_len;
+	}
+
+	rc = bnxt_hwrm_dbg_coredump_list(bp, &coredump);
+	if (rc) {
+		netdev_err(bp->dev, "Failed to get coredump segment list\n");
+		goto err;
+	}
+
+	*dump_len += seg_hdr_len * coredump.total_segs;
+
+	seg_record = (struct coredump_segment_record *)coredump.data;
+	seg_record_len = sizeof(*seg_record);
+
+	for (i = 0; i < coredump.total_segs; i++) {
+		u16 comp_id = le16_to_cpu(seg_record->component_id);
+		u16 seg_id = le16_to_cpu(seg_record->segment_id);
+		u32 duration = 0, seg_len = 0;
+		unsigned long start, end;
+
+		if (buf && ((offset + seg_hdr_len) >
+			    BNXT_COREDUMP_BUF_LEN(buf_len))) {
+			rc = -ENOBUFS;
+			goto err;
+		}
+
+		start = jiffies;
+
+		rc = bnxt_hwrm_dbg_coredump_initiate(bp, comp_id, seg_id);
+		if (rc) {
+			netdev_err(bp->dev,
+				   "Failed to initiate coredump for seg = %d\n",
+				   seg_record->segment_id);
+			goto next_seg;
+		}
+
+		/* Write segment data into the buffer */
+		rc = bnxt_hwrm_dbg_coredump_retrieve(bp, comp_id, seg_id,
+						     &seg_len, buf, buf_len,
+						     offset + seg_hdr_len);
+		if (rc && rc == -ENOBUFS)
+			goto err;
+		else if (rc)
+			netdev_err(bp->dev,
+				   "Failed to retrieve coredump for seg = %d\n",
+				   seg_record->segment_id);
+
+next_seg:
+		end = jiffies;
+		duration = jiffies_to_msecs(end - start);
+		bnxt_fill_coredump_seg_hdr(bp, &seg_hdr, seg_record, seg_len,
+					   rc, duration, 0);
+
+		if (buf) {
+			/* Write segment header into the buffer */
+			memcpy(buf + offset, &seg_hdr, seg_hdr_len);
+			offset += seg_hdr_len + seg_len;
+		}
+
+		*dump_len += seg_len;
+		seg_record =
+			(struct coredump_segment_record *)((u8 *)seg_record +
+							   seg_record_len);
+	}
+
+err:
+	if (buf)
+		bnxt_fill_coredump_record(bp, buf + offset, start_time,
+					  start_utc, coredump.total_segs + 1,
+					  rc);
+	kfree(coredump.data);
+	*dump_len += sizeof(struct bnxt_coredump_record);
+	if (rc == -ENOBUFS)
+		netdev_err(bp->dev, "Firmware returned large coredump buffer\n");
+	return rc;
+}
+
+int bnxt_get_coredump(struct bnxt *bp, u16 dump_type, void *buf, u32 *dump_len)
+{
+	if (dump_type == BNXT_DUMP_CRASH) {
+#ifdef CONFIG_TEE_BNXT_FW
+		return tee_bnxt_copy_coredump(buf, 0, *dump_len);
+#else
+		return -EOPNOTSUPP;
+#endif
+	} else {
+		return __bnxt_get_coredump(bp, buf, dump_len);
+	}
+}
+
+u32 bnxt_get_coredump_length(struct bnxt *bp, u16 dump_type)
+{
+	u32 len = 0;
+
+	if (dump_type == BNXT_DUMP_CRASH)
+		len = BNXT_CRASH_DUMP_LEN;
+	else
+		__bnxt_get_coredump(bp, NULL, &len);
+	return len;
+}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.h
index 09c22f8fe399..b1a1b2fffb19 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.h
@@ -10,6 +10,10 @@
 #ifndef BNXT_COREDUMP_H
 #define BNXT_COREDUMP_H
 
+#include <linux/utsname.h>
+#include <linux/time.h>
+#include <linux/rtc.h>
+
 struct bnxt_coredump_segment_hdr {
 	__u8 signature[4];
 	__le32 component_id;
@@ -63,4 +67,51 @@ struct bnxt_coredump_record {
 	__u8 ioctl_high_version;
 	__le16 rsvd3[313];
 };
+
+#define BNXT_CRASH_DUMP_LEN	(8 << 20)
+
+#define COREDUMP_LIST_BUF_LEN		2048
+#define COREDUMP_RETRIEVE_BUF_LEN	4096
+
+struct bnxt_coredump {
+	void		*data;
+	int		data_size;
+	u16		total_segs;
+};
+
+#define BNXT_COREDUMP_BUF_LEN(len) ((len) - sizeof(struct bnxt_coredump_record))
+
+struct bnxt_hwrm_dbg_dma_info {
+	void *dest_buf;
+	int dest_buf_size;
+	u16 dma_len;
+	u16 seq_off;
+	u16 data_len_off;
+	u16 segs;
+	u32 seg_start;
+	u32 buf_len;
+};
+
+struct hwrm_dbg_cmn_input {
+	__le16 req_type;
+	__le16 cmpl_ring;
+	__le16 seq_id;
+	__le16 target_id;
+	__le64 resp_addr;
+	__le64 host_dest_addr;
+	__le32 host_buf_len;
+};
+
+struct hwrm_dbg_cmn_output {
+	__le16 error_code;
+	__le16 req_type;
+	__le16 seq_id;
+	__le16 resp_len;
+	u8 flags;
+	#define HWRM_DBG_CMN_FLAGS_MORE	1
+};
+
+int bnxt_get_coredump(struct bnxt *bp, u16 dump_type, void *buf, u32 *dump_len);
+u32 bnxt_get_coredump_length(struct bnxt *bp, u16 dump_type);
+
 #endif
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index fe832f97f905..bb3f3529987b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3614,362 +3614,6 @@ static int bnxt_reset(struct net_device *dev, u32 *flags)
 	return 0;
 }
 
-static int bnxt_hwrm_dbg_dma_data(struct bnxt *bp, void *msg,
-				  struct bnxt_hwrm_dbg_dma_info *info)
-{
-	struct hwrm_dbg_cmn_input *cmn_req = msg;
-	__le16 *seq_ptr = msg + info->seq_off;
-	struct hwrm_dbg_cmn_output *cmn_resp;
-	u16 seq = 0, len, segs_off;
-	dma_addr_t dma_handle;
-	void *dma_buf, *resp;
-	int rc, off = 0;
-
-	dma_buf = hwrm_req_dma_slice(bp, msg, info->dma_len, &dma_handle);
-	if (!dma_buf) {
-		hwrm_req_drop(bp, msg);
-		return -ENOMEM;
-	}
-
-	hwrm_req_timeout(bp, msg, HWRM_COREDUMP_TIMEOUT);
-	cmn_resp = hwrm_req_hold(bp, msg);
-	resp = cmn_resp;
-
-	segs_off = offsetof(struct hwrm_dbg_coredump_list_output,
-			    total_segments);
-	cmn_req->host_dest_addr = cpu_to_le64(dma_handle);
-	cmn_req->host_buf_len = cpu_to_le32(info->dma_len);
-	while (1) {
-		*seq_ptr = cpu_to_le16(seq);
-		rc = hwrm_req_send(bp, msg);
-		if (rc)
-			break;
-
-		len = le16_to_cpu(*((__le16 *)(resp + info->data_len_off)));
-		if (!seq &&
-		    cmn_req->req_type == cpu_to_le16(HWRM_DBG_COREDUMP_LIST)) {
-			info->segs = le16_to_cpu(*((__le16 *)(resp +
-							      segs_off)));
-			if (!info->segs) {
-				rc = -EIO;
-				break;
-			}
-
-			info->dest_buf_size = info->segs *
-					sizeof(struct coredump_segment_record);
-			info->dest_buf = kmalloc(info->dest_buf_size,
-						 GFP_KERNEL);
-			if (!info->dest_buf) {
-				rc = -ENOMEM;
-				break;
-			}
-		}
-
-		if (info->dest_buf) {
-			if ((info->seg_start + off + len) <=
-			    BNXT_COREDUMP_BUF_LEN(info->buf_len)) {
-				memcpy(info->dest_buf + off, dma_buf, len);
-			} else {
-				rc = -ENOBUFS;
-				break;
-			}
-		}
-
-		if (cmn_req->req_type ==
-				cpu_to_le16(HWRM_DBG_COREDUMP_RETRIEVE))
-			info->dest_buf_size += len;
-
-		if (!(cmn_resp->flags & HWRM_DBG_CMN_FLAGS_MORE))
-			break;
-
-		seq++;
-		off += len;
-	}
-	hwrm_req_drop(bp, msg);
-	return rc;
-}
-
-static int bnxt_hwrm_dbg_coredump_list(struct bnxt *bp,
-				       struct bnxt_coredump *coredump)
-{
-	struct bnxt_hwrm_dbg_dma_info info = {NULL};
-	struct hwrm_dbg_coredump_list_input *req;
-	int rc;
-
-	rc = hwrm_req_init(bp, req, HWRM_DBG_COREDUMP_LIST);
-	if (rc)
-		return rc;
-
-	info.dma_len = COREDUMP_LIST_BUF_LEN;
-	info.seq_off = offsetof(struct hwrm_dbg_coredump_list_input, seq_no);
-	info.data_len_off = offsetof(struct hwrm_dbg_coredump_list_output,
-				     data_len);
-
-	rc = bnxt_hwrm_dbg_dma_data(bp, req, &info);
-	if (!rc) {
-		coredump->data = info.dest_buf;
-		coredump->data_size = info.dest_buf_size;
-		coredump->total_segs = info.segs;
-	}
-	return rc;
-}
-
-static int bnxt_hwrm_dbg_coredump_initiate(struct bnxt *bp, u16 component_id,
-					   u16 segment_id)
-{
-	struct hwrm_dbg_coredump_initiate_input *req;
-	int rc;
-
-	rc = hwrm_req_init(bp, req, HWRM_DBG_COREDUMP_INITIATE);
-	if (rc)
-		return rc;
-
-	hwrm_req_timeout(bp, req, HWRM_COREDUMP_TIMEOUT);
-	req->component_id = cpu_to_le16(component_id);
-	req->segment_id = cpu_to_le16(segment_id);
-
-	return hwrm_req_send(bp, req);
-}
-
-static int bnxt_hwrm_dbg_coredump_retrieve(struct bnxt *bp, u16 component_id,
-					   u16 segment_id, u32 *seg_len,
-					   void *buf, u32 buf_len, u32 offset)
-{
-	struct hwrm_dbg_coredump_retrieve_input *req;
-	struct bnxt_hwrm_dbg_dma_info info = {NULL};
-	int rc;
-
-	rc = hwrm_req_init(bp, req, HWRM_DBG_COREDUMP_RETRIEVE);
-	if (rc)
-		return rc;
-
-	req->component_id = cpu_to_le16(component_id);
-	req->segment_id = cpu_to_le16(segment_id);
-
-	info.dma_len = COREDUMP_RETRIEVE_BUF_LEN;
-	info.seq_off = offsetof(struct hwrm_dbg_coredump_retrieve_input,
-				seq_no);
-	info.data_len_off = offsetof(struct hwrm_dbg_coredump_retrieve_output,
-				     data_len);
-	if (buf) {
-		info.dest_buf = buf + offset;
-		info.buf_len = buf_len;
-		info.seg_start = offset;
-	}
-
-	rc = bnxt_hwrm_dbg_dma_data(bp, req, &info);
-	if (!rc)
-		*seg_len = info.dest_buf_size;
-
-	return rc;
-}
-
-static void
-bnxt_fill_coredump_seg_hdr(struct bnxt *bp,
-			   struct bnxt_coredump_segment_hdr *seg_hdr,
-			   struct coredump_segment_record *seg_rec, u32 seg_len,
-			   int status, u32 duration, u32 instance)
-{
-	memset(seg_hdr, 0, sizeof(*seg_hdr));
-	memcpy(seg_hdr->signature, "sEgM", 4);
-	if (seg_rec) {
-		seg_hdr->component_id = (__force __le32)seg_rec->component_id;
-		seg_hdr->segment_id = (__force __le32)seg_rec->segment_id;
-		seg_hdr->low_version = seg_rec->version_low;
-		seg_hdr->high_version = seg_rec->version_hi;
-	} else {
-		/* For hwrm_ver_get response Component id = 2
-		 * and Segment id = 0
-		 */
-		seg_hdr->component_id = cpu_to_le32(2);
-		seg_hdr->segment_id = 0;
-	}
-	seg_hdr->function_id = cpu_to_le16(bp->pdev->devfn);
-	seg_hdr->length = cpu_to_le32(seg_len);
-	seg_hdr->status = cpu_to_le32(status);
-	seg_hdr->duration = cpu_to_le32(duration);
-	seg_hdr->data_offset = cpu_to_le32(sizeof(*seg_hdr));
-	seg_hdr->instance = cpu_to_le32(instance);
-}
-
-static void
-bnxt_fill_coredump_record(struct bnxt *bp, struct bnxt_coredump_record *record,
-			  time64_t start, s16 start_utc, u16 total_segs,
-			  int status)
-{
-	time64_t end = ktime_get_real_seconds();
-	u32 os_ver_major = 0, os_ver_minor = 0;
-	struct tm tm;
-
-	time64_to_tm(start, 0, &tm);
-	memset(record, 0, sizeof(*record));
-	memcpy(record->signature, "cOrE", 4);
-	record->flags = 0;
-	record->low_version = 0;
-	record->high_version = 1;
-	record->asic_state = 0;
-	strscpy(record->system_name, utsname()->nodename,
-		sizeof(record->system_name));
-	record->year = cpu_to_le16(tm.tm_year + 1900);
-	record->month = cpu_to_le16(tm.tm_mon + 1);
-	record->day = cpu_to_le16(tm.tm_mday);
-	record->hour = cpu_to_le16(tm.tm_hour);
-	record->minute = cpu_to_le16(tm.tm_min);
-	record->second = cpu_to_le16(tm.tm_sec);
-	record->utc_bias = cpu_to_le16(start_utc);
-	strcpy(record->commandline, "ethtool -w");
-	record->total_segments = cpu_to_le32(total_segs);
-
-	if (sscanf(utsname()->release, "%u.%u", &os_ver_major, &os_ver_minor) != 2)
-		netdev_warn(bp->dev, "Unknown OS release in coredump\n");
-	record->os_ver_major = cpu_to_le32(os_ver_major);
-	record->os_ver_minor = cpu_to_le32(os_ver_minor);
-
-	strscpy(record->os_name, utsname()->sysname, sizeof(record->os_name));
-	time64_to_tm(end, 0, &tm);
-	record->end_year = cpu_to_le16(tm.tm_year + 1900);
-	record->end_month = cpu_to_le16(tm.tm_mon + 1);
-	record->end_day = cpu_to_le16(tm.tm_mday);
-	record->end_hour = cpu_to_le16(tm.tm_hour);
-	record->end_minute = cpu_to_le16(tm.tm_min);
-	record->end_second = cpu_to_le16(tm.tm_sec);
-	record->end_utc_bias = cpu_to_le16(sys_tz.tz_minuteswest * 60);
-	record->asic_id1 = cpu_to_le32(bp->chip_num << 16 |
-				       bp->ver_resp.chip_rev << 8 |
-				       bp->ver_resp.chip_metal);
-	record->asic_id2 = 0;
-	record->coredump_status = cpu_to_le32(status);
-	record->ioctl_low_version = 0;
-	record->ioctl_high_version = 0;
-}
-
-static int __bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
-{
-	u32 ver_get_resp_len = sizeof(struct hwrm_ver_get_output);
-	u32 offset = 0, seg_hdr_len, seg_record_len, buf_len = 0;
-	struct coredump_segment_record *seg_record = NULL;
-	struct bnxt_coredump_segment_hdr seg_hdr;
-	struct bnxt_coredump coredump = {NULL};
-	time64_t start_time;
-	u16 start_utc;
-	int rc = 0, i;
-
-	if (buf)
-		buf_len = *dump_len;
-
-	start_time = ktime_get_real_seconds();
-	start_utc = sys_tz.tz_minuteswest * 60;
-	seg_hdr_len = sizeof(seg_hdr);
-
-	/* First segment should be hwrm_ver_get response */
-	*dump_len = seg_hdr_len + ver_get_resp_len;
-	if (buf) {
-		bnxt_fill_coredump_seg_hdr(bp, &seg_hdr, NULL, ver_get_resp_len,
-					   0, 0, 0);
-		memcpy(buf + offset, &seg_hdr, seg_hdr_len);
-		offset += seg_hdr_len;
-		memcpy(buf + offset, &bp->ver_resp, ver_get_resp_len);
-		offset += ver_get_resp_len;
-	}
-
-	rc = bnxt_hwrm_dbg_coredump_list(bp, &coredump);
-	if (rc) {
-		netdev_err(bp->dev, "Failed to get coredump segment list\n");
-		goto err;
-	}
-
-	*dump_len += seg_hdr_len * coredump.total_segs;
-
-	seg_record = (struct coredump_segment_record *)coredump.data;
-	seg_record_len = sizeof(*seg_record);
-
-	for (i = 0; i < coredump.total_segs; i++) {
-		u16 comp_id = le16_to_cpu(seg_record->component_id);
-		u16 seg_id = le16_to_cpu(seg_record->segment_id);
-		u32 duration = 0, seg_len = 0;
-		unsigned long start, end;
-
-		if (buf && ((offset + seg_hdr_len) >
-			    BNXT_COREDUMP_BUF_LEN(buf_len))) {
-			rc = -ENOBUFS;
-			goto err;
-		}
-
-		start = jiffies;
-
-		rc = bnxt_hwrm_dbg_coredump_initiate(bp, comp_id, seg_id);
-		if (rc) {
-			netdev_err(bp->dev,
-				   "Failed to initiate coredump for seg = %d\n",
-				   seg_record->segment_id);
-			goto next_seg;
-		}
-
-		/* Write segment data into the buffer */
-		rc = bnxt_hwrm_dbg_coredump_retrieve(bp, comp_id, seg_id,
-						     &seg_len, buf, buf_len,
-						     offset + seg_hdr_len);
-		if (rc && rc == -ENOBUFS)
-			goto err;
-		else if (rc)
-			netdev_err(bp->dev,
-				   "Failed to retrieve coredump for seg = %d\n",
-				   seg_record->segment_id);
-
-next_seg:
-		end = jiffies;
-		duration = jiffies_to_msecs(end - start);
-		bnxt_fill_coredump_seg_hdr(bp, &seg_hdr, seg_record, seg_len,
-					   rc, duration, 0);
-
-		if (buf) {
-			/* Write segment header into the buffer */
-			memcpy(buf + offset, &seg_hdr, seg_hdr_len);
-			offset += seg_hdr_len + seg_len;
-		}
-
-		*dump_len += seg_len;
-		seg_record =
-			(struct coredump_segment_record *)((u8 *)seg_record +
-							   seg_record_len);
-	}
-
-err:
-	if (buf)
-		bnxt_fill_coredump_record(bp, buf + offset, start_time,
-					  start_utc, coredump.total_segs + 1,
-					  rc);
-	kfree(coredump.data);
-	*dump_len += sizeof(struct bnxt_coredump_record);
-	if (rc == -ENOBUFS)
-		netdev_err(bp->dev, "Firmware returned large coredump buffer\n");
-	return rc;
-}
-
-static int bnxt_get_coredump(struct bnxt *bp, u16 dump_type, void *buf, u32 *dump_len)
-{
-	if (dump_type == BNXT_DUMP_CRASH) {
-#ifdef CONFIG_TEE_BNXT_FW
-		return tee_bnxt_copy_coredump(buf, 0, *dump_len);
-#else
-		return -EOPNOTSUPP;
-#endif
-	} else {
-		return __bnxt_get_coredump(bp, buf, dump_len);
-	}
-}
-
-static u32 bnxt_get_coredump_length(struct bnxt *bp, u16 dump_type)
-{
-	u32 len = 0;
-
-	if (dump_type == BNXT_DUMP_CRASH)
-		len = BNXT_CRASH_DUMP_LEN;
-	else
-		__bnxt_get_coredump(bp, NULL, &len);
-	return len;
-}
-
 static int bnxt_set_dump(struct net_device *dev, struct ethtool_dump *dump)
 {
 	struct bnxt *bp = netdev_priv(dev);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
index bbf184c63b0a..4f7eaba65dcb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
@@ -22,49 +22,6 @@ struct bnxt_led_cfg {
 	u8 rsvd;
 };
 
-#define COREDUMP_LIST_BUF_LEN		2048
-#define COREDUMP_RETRIEVE_BUF_LEN	4096
-
-struct bnxt_coredump {
-	void		*data;
-	int		data_size;
-	u16		total_segs;
-};
-
-#define BNXT_COREDUMP_BUF_LEN(len) ((len) - sizeof(struct bnxt_coredump_record))
-
-struct bnxt_hwrm_dbg_dma_info {
-	void *dest_buf;
-	int dest_buf_size;
-	u16 dma_len;
-	u16 seq_off;
-	u16 data_len_off;
-	u16 segs;
-	u32 seg_start;
-	u32 buf_len;
-};
-
-struct hwrm_dbg_cmn_input {
-	__le16 req_type;
-	__le16 cmpl_ring;
-	__le16 seq_id;
-	__le16 target_id;
-	__le64 resp_addr;
-	__le64 host_dest_addr;
-	__le32 host_buf_len;
-};
-
-struct hwrm_dbg_cmn_output {
-	__le16 error_code;
-	__le16 req_type;
-	__le16 seq_id;
-	__le16 resp_len;
-	u8 flags;
-	#define HWRM_DBG_CMN_FLAGS_MORE	1
-};
-
-#define BNXT_CRASH_DUMP_LEN	(8 << 20)
-
 #define BNXT_LED_DFLT_ENA				\
 	(PORT_LED_CFG_REQ_ENABLES_LED0_ID |		\
 	 PORT_LED_CFG_REQ_ENABLES_LED0_STATE |		\
-- 
2.18.1


--000000000000767c5805cf0a30b5
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQbQYJKoZIhvcNAQcCoIIQXjCCEFoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3EMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBUwwggQ0oAMCAQICDBB5T5jqFt6c/NEwmzANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxNDE0MTRaFw0yMjA5MjIxNDQzNDhaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDE1pY2hhZWwgQ2hhbjEoMCYGCSqGSIb3DQEJ
ARYZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBANtwBQrLJBrTcbQ1kmjdo+NJT2hFaBFsw1IOi34uVzWz21AZUqQkNVktkT740rYuB1m1No7W
EBvfLuKxbgQO2pHk9mTUiTHsrX2CHIw835Du8Co2jEuIqAsocz53NwYmk4Sj0/HqAfxgtHEleK2l
CR56TX8FjvCKYDsIsXIjMzm3M7apx8CQWT6DxwfrDBu607V6LkfuHp2/BZM2GvIiWqy2soKnUqjx
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAyUNYR8kViYl3Us4xCbVlTJ/dwdqzeL
Z0fthCLoQNd9MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTAy
MzE5MzIzM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCWiH6RJAoKtpGOz0FU0Y4O1YJWejhvsL14DvdDvIKp4pPWhrrq
n8ZKHKPq1CLHHJ97BZGmIDKULyiuK4uNl9pM988zN2il6l1MB1tkPAYGDclm27KT+7smuOe4HHTz
2y9YlF4zNgj6ka3SexrOd+Jt/8jh38GsCWuiXpr4R9djVwKnsTB9lHaMI/oGdnHJP2lXE2fEzoDM
ikIBanlux4CaP3SymoUtAT2xcdiQ2CTSic4UEuZsYPtw1vze1WOdqjbHiSbJU2ySofoBS6fkyzyi
loiQIDLcuNQ96+mbunBMb9qGd/d+4mFmU2OtDuumniKa6GBtm9Tdey9kK59ARUZH
--000000000000767c5805cf0a30b5--
