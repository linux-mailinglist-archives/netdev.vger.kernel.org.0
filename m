Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9710D3DF370
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237758AbhHCRB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237457AbhHCQ5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:57:47 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2486CC06179E
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 09:56:02 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id f13so29771049edq.13
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 09:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eBJZV4O8XqLZmUle+XYxNsAo4PLygqVj1lvOHmXGbrk=;
        b=WnyDdptfkBp/K5nPQjxXqIgv75CUc6nd0Lj3hMeU+gD3xeYZETv7cl2BFx85Fia7+b
         hUH/Xm6Clv+XA2YQDkzyRwWoCWofkTGrpfUmH9vyK1HpgpCpw0Viy+6g+LUbDfDzcsfg
         rCYcGSFhVEz8iU4G5tRSQTs9/+bBWkdXiKeCCTS7V5u2AL9kFg4YSXY5VNSZIQEkhCaT
         ppO9jLOFnVTfalP0K+0W4U4U7Wh25KWhqVQI8830huZsO3ixAPJ9ABRBy5GZD3YAFWa0
         JOMxlMqovrmSgte1q67zvi2+FPC70uLTvZOiCayEW94Ekx1IvZHvXVf+MDjasHj6ZzCf
         xzaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eBJZV4O8XqLZmUle+XYxNsAo4PLygqVj1lvOHmXGbrk=;
        b=s0eETKJYva+yPLenhW+TzNwl1cghhwZJ9r5zomK+CtTEdNnbIklfXhgDgYjIoet23q
         yx4oqCi53avbfFGoNN5J/nwQmwhL2tw4kEXrY9owxz767tSRjpDgxqSvrpFtkVODiAZq
         IvUzQlfNopNGmheLi4yA6Zfj3laXD6+SdsVncKkxBNEWh6df9YdWZDHC8YYXBMTkqrpD
         NWLDzHHdGxC9nSmMob6M2Pa4XDlWX99W5VMdpVa5IIJvv+2XlBuW0hkqvpVK0Vmxn7G9
         PrjlscONt28jzSs0o38B6QaOiXQoJlyyhxs7iEJePmaFuG6Y9ylpAXwDuXB5K9KUJdOX
         uxng==
X-Gm-Message-State: AOAM5312G7A0bGtVCEyiy82IKIB97S07XXN7X5D5JObtJqU39zgC3rlr
        uIxP9jCQv6R8yABqJGAFUPc=
X-Google-Smtp-Source: ABdhPJxb8HP73h9zqwTR14yN1DGkMWWXzvujubdU0J5HfGqA0BhmbFvDiA+AKbMxXuj1Nq61gppC2g==
X-Received: by 2002:a05:6402:1458:: with SMTP id d24mr26983001edx.281.1628009760742;
        Tue, 03 Aug 2021 09:56:00 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id e7sm8754630edk.3.2021.08.03.09.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:56:00 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 7/8] dpaa2-switch: add a prefix to HW ethtool stats
Date:   Tue,  3 Aug 2021 19:57:44 +0300
Message-Id: <20210803165745.138175-8-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803165745.138175-1-ciorneiioana@gmail.com>
References: <20210803165745.138175-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

In the next patch, we'll add support for also exporting the MAC
statistics in the ethtool stats. Annotate already present HW stats with
a suggestive prefix.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../freescale/dpaa2/dpaa2-switch-ethtool.c    | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
index 5a460dcc6f4e..20912fb67b9e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
@@ -15,18 +15,18 @@ static struct {
 	enum dpsw_counter id;
 	char name[ETH_GSTRING_LEN];
 } dpaa2_switch_ethtool_counters[] =  {
-	{DPSW_CNT_ING_FRAME,		"rx frames"},
-	{DPSW_CNT_ING_BYTE,		"rx bytes"},
-	{DPSW_CNT_ING_FLTR_FRAME,	"rx filtered frames"},
-	{DPSW_CNT_ING_FRAME_DISCARD,	"rx discarded frames"},
-	{DPSW_CNT_ING_BCAST_FRAME,	"rx b-cast frames"},
-	{DPSW_CNT_ING_BCAST_BYTES,	"rx b-cast bytes"},
-	{DPSW_CNT_ING_MCAST_FRAME,	"rx m-cast frames"},
-	{DPSW_CNT_ING_MCAST_BYTE,	"rx m-cast bytes"},
-	{DPSW_CNT_EGR_FRAME,		"tx frames"},
-	{DPSW_CNT_EGR_BYTE,		"tx bytes"},
-	{DPSW_CNT_EGR_FRAME_DISCARD,	"tx discarded frames"},
-	{DPSW_CNT_ING_NO_BUFF_DISCARD,	"rx discarded no buffer frames"},
+	{DPSW_CNT_ING_FRAME,		"[hw] rx frames"},
+	{DPSW_CNT_ING_BYTE,		"[hw] rx bytes"},
+	{DPSW_CNT_ING_FLTR_FRAME,	"[hw] rx filtered frames"},
+	{DPSW_CNT_ING_FRAME_DISCARD,	"[hw] rx discarded frames"},
+	{DPSW_CNT_ING_BCAST_FRAME,	"[hw] rx bcast frames"},
+	{DPSW_CNT_ING_BCAST_BYTES,	"[hw] rx bcast bytes"},
+	{DPSW_CNT_ING_MCAST_FRAME,	"[hw] rx mcast frames"},
+	{DPSW_CNT_ING_MCAST_BYTE,	"[hw] rx mcast bytes"},
+	{DPSW_CNT_EGR_FRAME,		"[hw] tx frames"},
+	{DPSW_CNT_EGR_BYTE,		"[hw] tx bytes"},
+	{DPSW_CNT_EGR_FRAME_DISCARD,	"[hw] tx discarded frames"},
+	{DPSW_CNT_ING_NO_BUFF_DISCARD,	"[hw] rx nobuffer discards"},
 };
 
 #define DPAA2_SWITCH_NUM_COUNTERS	ARRAY_SIZE(dpaa2_switch_ethtool_counters)
-- 
2.31.1

