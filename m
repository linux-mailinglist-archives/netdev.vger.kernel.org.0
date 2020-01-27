Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D03A714A144
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbgA0J5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:57:04 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46649 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgA0J5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:57:03 -0500
Received: by mail-pf1-f194.google.com with SMTP id k29so2164941pfp.13
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XTZ9jYmARcxcUqNSgJ92mqSuSKing5nfHNpX2lOwrxo=;
        b=StvSNnbvJ/7KriZb5+l+s9CwiBBULYb4iucfNM9TVkBN/DqR6GUKXFCZVF+6M8WjVq
         KgFykfD8fjrwiYulTSHR8azQSr8gxjR6Xy6D/FrfeNzNOi61J8ZH2E1y+IWQwzyrLd/h
         a8sdyHNhNLe9KPWoeymUbuobiTAVZxd5EZFss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XTZ9jYmARcxcUqNSgJ92mqSuSKing5nfHNpX2lOwrxo=;
        b=ZzCU/e3D4BTXu5YxzsMAmaPny2lGmI5Vge1hcpJaL3srpMznEeroAepYi3Jw4+e04W
         evozR1JAfGWrNsz1G30Wnx2YEzBcDPkc9Lywz8zZXfBmWSUExLMFmiNe1N87VGP2t6JS
         iHD5Jy5EIUp7w26+t68rW1OTmrBTYZV6v98bxwUn9QL68oAKzy7gzvES8+ARzeaVswar
         RHIuycMIYBya2p9he2MTxq6+P9YeOydh1T/Ib+Mg0lnK1mRHcEtZyHAnrAh/o93wnkG0
         LE2GKHTAYQhQ5PF8Ka9sEFORIGx9GVk4EGuINA4y+rWYRUstHxD2Dkvba+ttoNApJxaa
         CH3A==
X-Gm-Message-State: APjAAAVR8PwY5s0GqiNNMLIlgqdUFHvpwInyJOj/PNImmAWak1LUqH4m
        ZzC2VTzDxAU8D/Dsw/cjGAr39w==
X-Google-Smtp-Source: APXvYqzuvwe/q2iTJut0NxQ/kLfb5RbF6/43tqyPI1GikVBJ5exC35vpmHy0nuXGB1OpcmglnCm3ag==
X-Received: by 2002:aa7:8007:: with SMTP id j7mr15527362pfi.71.1580119023187;
        Mon, 27 Jan 2020 01:57:03 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm15232594pfg.145.2020.01.27.01.57.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jan 2020 01:57:02 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 03/15] bnxt_en: Remove the setting of dev_port.
Date:   Mon, 27 Jan 2020 04:56:15 -0500
Message-Id: <1580118987-30052-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
References: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev_port is meant to distinguish the network ports belonging to
the same PCI function.  Our devices only have one network port
associated with each PCI function and so we should not set it for
correctness.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4d790bc..6c0c926 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6998,7 +6998,6 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 
 		pf->fw_fid = le16_to_cpu(resp->fid);
 		pf->port_id = le16_to_cpu(resp->port_id);
-		bp->dev->dev_port = pf->port_id;
 		memcpy(pf->mac_addr, resp->mac_address, ETH_ALEN);
 		pf->first_vf_id = le16_to_cpu(resp->first_vf_id);
 		pf->max_vfs = le16_to_cpu(resp->max_vfs);
-- 
2.5.1

