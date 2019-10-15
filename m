Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16F44D9188
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405266AbfJPMuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:50:46 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42688 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405261AbfJPMup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 08:50:45 -0400
Received: by mail-pf1-f195.google.com with SMTP id q12so14668413pff.9
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 05:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hl/zJ24exPBtsd4D9jhU0PgrTp5EPCF1EdhKd9WfCXQ=;
        b=tcPns1soO74Xraxa3tSyJrmrtbQgaTmp4L16jqJpbBd7Kb5f9LBCpvUy/ZFRyAnDMZ
         PXbqfcfKpQouSiC1oYyHbNyvtsDd0ojiUNzpEInpbBnhW/XWLBmzaMXuqNKOIM3SZWtI
         TH5q+D+RLadFiz2SrZESvPxzLvM/ej8m4DloDDI/CpX/1MreEMGowDY6GLJaHPLsX8ww
         EMdxJ/XP8m9RDFJp4LjEpmN0TkgcIfajxLNT6IoJULjc1TyAbhOprUb0/brToQsqo+p5
         OKvf/MVImLcy1EyTmiltfmvZkdmaqf2pFE35ydj7dLJO02l/yc03XCG/lSuKvgY8skSd
         NtVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hl/zJ24exPBtsd4D9jhU0PgrTp5EPCF1EdhKd9WfCXQ=;
        b=lqjxmCPB0SoIFRKuRPYQbeX5m27YPOu+nyGGtD6ezLMQXhgD6kMG+i4kkGHsvQvSx8
         SFswnsRBwz15b7Lnl2MNf9i1BYVw8yprpNs1gZdpTpLWk7qi1jd2SZaeMUdNz6lipvR7
         mlmsP/RePRIXiP9ZvwWxwyD8f7doHrYHahMq730TGwFbsvn2NPWmxZjIM9JA/0ACwBz5
         FysaViVM7bVIDxls3+FCbSqHw51sks86iT0VOQX+48KweB+hcBtKwhURPkr9c/+7cgmq
         oEiOUbOb2J/f1jFgmRyYUW6JV4BUtKWxvfNJFjR6o6ClkyPkmOXEwWiXPvH8NPLFrBTz
         qMEQ==
X-Gm-Message-State: APjAAAVnhmUv9MRu1iRhmUcZBgrQ6UxT8txSldvUt2vExA4bcSqibJBt
        8T+RFf05QM5cRdSCnI1fEks=
X-Google-Smtp-Source: APXvYqy1t+hjdDNEtGhEXCdh8vhHC6IALgvZqvR8sJmYUGXUUuf93hioGzPSrP6vCQZFOtjOsYk1CQ==
X-Received: by 2002:aa7:8a97:: with SMTP id a23mr44744748pfc.76.1571230244590;
        Wed, 16 Oct 2019 05:50:44 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d19sm2747339pjz.5.2019.10.16.05.50.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 05:50:43 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4 06/10] net: openvswitch: simplify the flow_hash
Date:   Tue, 15 Oct 2019 18:30:36 +0800
Message-Id: <1571135440-24313-7-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Simplify the code and remove the unnecessary BUILD_BUG_ON.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Greg Rose <gvrose8192@gmail.com>
---
 net/openvswitch/flow_table.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index a10d421..3e3d345 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -432,13 +432,9 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
 static u32 flow_hash(const struct sw_flow_key *key,
 		     const struct sw_flow_key_range *range)
 {
-	int key_start = range->start;
-	int key_end = range->end;
-	const u32 *hash_key = (const u32 *)((const u8 *)key + key_start);
-	int hash_u32s = (key_end - key_start) >> 2;
-
+	const u32 *hash_key = (const u32 *)((const u8 *)key + range->start);
 	/* Make sure number of hash bytes are multiple of u32. */
-	BUILD_BUG_ON(sizeof(long) % sizeof(u32));
+	int hash_u32s = range_n_bytes(range) >> 2;
 
 	return jhash2(hash_key, hash_u32s, 0);
 }
-- 
1.8.3.1

