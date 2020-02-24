Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47943169FE9
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgBXIY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:24:57 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36529 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgBXIY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 03:24:56 -0500
Received: by mail-pf1-f195.google.com with SMTP id 185so4973116pfv.3
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 00:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=es-iitr-ac-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=lhlKxXAIvhacc2714cSl7CgN47VyLjNdXE5+TJ+pWfc=;
        b=iVRInhr+0XNetO76iReb1HcqRUj2veJmpOz2VGFnl2Wxi+8TPSjiu/xM/adgh6XmCK
         8Vk6u/EjOINY+qvQ7ISa91IkBrWENxEMunIgH0aMBekN48kC+rBPr5JyAEUo45egz+Tp
         cAfVlus1c+zANML1yovm8FDV01jcNS6RpGQajOVBDCK+/Jjc/UJNt13m1yDXbJXfPS4M
         QAqcA/H6ZQ2ZJC+3y7NBZgnRHOcGHpQmT90FXX4cLkHmg4AhWA2om8knIKC7EegqlEK1
         HwC07FQ6y/BIblr71lhZuxonaXOkd4NCVQG97jtEN56rZ5z7djSpq3XiLZDJB2BvC/Ns
         iMGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=lhlKxXAIvhacc2714cSl7CgN47VyLjNdXE5+TJ+pWfc=;
        b=d6+6ckPsoCNJp5COxT0/1epzJ1H2Oi0manLQYP+VT+Za+Kp7Ec4zTwTNTcB7LUUexP
         pbWcTVpWeX8Z/3dvQBMmeBf8f+pO3xZNn77yAKT+AN1aQtMT1oJeASAjZPNCg2XHxBtu
         K2LNCHQJ3nueg/v5pfAPDCmOKjgTu9h7VJkubqvc5a0p8oj8+YSXMb04IcWTX8JCF/JW
         6xviMb/fB++t9sNnH+yNXT8DgnkaYW34wuM3Zf/tPZrlHGfFmZEBP/X/iLiH71sSXwsU
         sPuLiI5SygcWEv5m48XzggVVl4Ova+L28mEhwHV2nZF23eNWWFPBrt+Ip1xuc/4zAvHY
         6jng==
X-Gm-Message-State: APjAAAX/SCg7TsSmJDVxBv4ROKqqvrayNivzXjgvPT2NIqgNV+FgjhON
        57oH/5jSKO8kbFhdKbxwFSOpnA==
X-Google-Smtp-Source: APXvYqw7fF7F0dn1XMTNUKU+SpQUH74ObcV+LpB7LmVe/J4gIU4K/TSo0CCwfrQ6XOBMin29oU+CKw==
X-Received: by 2002:aa7:84c4:: with SMTP id x4mr50338458pfn.144.1582532696231;
        Mon, 24 Feb 2020 00:24:56 -0800 (PST)
Received: from kaaira-HP-Pavilion-Notebook ([103.37.201.170])
        by smtp.gmail.com with ESMTPSA id g12sm11515210pfh.170.2020.02.24.00.24.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 Feb 2020 00:24:55 -0800 (PST)
Date:   Mon, 24 Feb 2020 13:54:48 +0530
From:   Kaaira Gupta <kgupta@es.iitr.ac.in>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] staging: qlge: emit debug and dump at same level
Message-ID: <20200224082448.GA6826@kaaira-HP-Pavilion-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify code in ql_mpi_core_to_log() by calling print_hex_dump()
instead of existing functions so that the debug and dump are
emitted at the same KERN_<LEVEL>

Signed-off-by: Kaaira Gupta <kgupta@es.iitr.ac.in>
---

changes since v1: make code of ql_mpi_core_to_log() simpler.
changes since v2: directly call the function instead of defining a
macro.
changes since v3: Remove prefix string.

----
---
 drivers/staging/qlge/qlge_dbg.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index c7af2548d119..0c5f6859e645 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1324,27 +1324,10 @@ void ql_mpi_core_to_log(struct work_struct *work)
 {
 	struct ql_adapter *qdev =
 		container_of(work, struct ql_adapter, mpi_core_to_log.work);
-	u32 *tmp, count;
-	int i;
 
-	count = sizeof(struct ql_mpi_coredump) / sizeof(u32);
-	tmp = (u32 *)qdev->mpi_coredump;
-	netif_printk(qdev, drv, KERN_DEBUG, qdev->ndev,
-		     "Core is dumping to log file!\n");
-
-	for (i = 0; i < count; i += 8) {
-		pr_err("%.08x: %.08x %.08x %.08x %.08x %.08x "
-			"%.08x %.08x %.08x\n", i,
-			tmp[i + 0],
-			tmp[i + 1],
-			tmp[i + 2],
-			tmp[i + 3],
-			tmp[i + 4],
-			tmp[i + 5],
-			tmp[i + 6],
-			tmp[i + 7]);
-		msleep(5);
-	}
+	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET,
+		       32, 4, qdev->mpi_coredump,
+		       sizeof(*qdev->mpi_coredump), false);
 }
 
 #ifdef QL_REG_DUMP
-- 
2.17.1

