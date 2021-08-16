Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DE53ECFAC
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 09:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbhHPHuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 03:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234208AbhHPHty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 03:49:54 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9716CC0617AE
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 00:49:11 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c17so14522840plz.2
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 00:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NbQN4AuwV0GHnfaHxFW5WvlgsjyS23AkKWVKEbm4Kwg=;
        b=PK1s6DlAQPf1srGfDKWPRy1BTgP572V/SYfYIO/qdXRYOU3+Z3V10hrTe/NDRh8CY1
         zgRtdd+Kc7TJttO7zd4I1VVih7eyiSnZmS0y0i4qs1l25p+0SGtzrNhKT2qmkpgAQzu9
         1t21kazBjg7eoDyIJHYrflIWEyXPAYcdNrcRsmdaiocIk3mSmPiMUnBoO8uQWM73Up5C
         IXqoVj+EFf2PJWmfWcoN3/oaHhrvmplyG1eiBcwuSqqToYW5+/N2SSiCEKrqwAOxNCjG
         YNNjIW1hXOanYRGMwMZ0ndQpfxkgKnqHkHFrcsXti4cNRpVF1ZYUVSsSzg1sbLOTCble
         dxIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NbQN4AuwV0GHnfaHxFW5WvlgsjyS23AkKWVKEbm4Kwg=;
        b=fNWFvSzRstoBQjrRncJu+0wPp0ReZW64nEvMfbUmDf4wiPMifw+da+JOD+DnQ9zFhl
         pgXeRD1do9Ka36sAlQrik1c7N8d4hKOrDJNJiP5uSkRFfCVMEY70Uc9mQs9ZJV8OK7dE
         WDHimZiV6DfLC0brAiTVcLDUc34aprKcnqpsVGh1G6dhGDtt1clX3PGLQ5A4RFXhMkGH
         eLzAcTbFMhMzGD3C0KfRhSc3qjWRzWrWBZOQwZKIGcpBUg4k2CGXmtvXRiEGNEKkLu08
         uOqolBEhTv/I1HJ3EoSD4sO/qGQdsCEoP8SqpIf75TAfjxCQKQZtK6nkc5+I8KmZBZKx
         5dbw==
X-Gm-Message-State: AOAM532nMOAm1ZhVm//ClXoSw/hMa6/ciw/dAVfZ/WfOcSwhBLwey17i
        CkKctEsvQjKwZ2bPiXG0w57cuVITFbc=
X-Google-Smtp-Source: ABdhPJwZVqtALgBeEWmuYelTeAGg+AP3RItCdXCIM0QURkbVIoWUZ07oQavV65FYiXmqaBfO+zJyjA==
X-Received: by 2002:a63:5c8:: with SMTP id 191mr15222327pgf.293.1629100150966;
        Mon, 16 Aug 2021 00:49:10 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y13sm10125069pfq.147.2021.08.16.00.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 00:49:10 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2-next] ip/bond: add arp_validate filter support
Date:   Mon, 16 Aug 2021 15:49:05 +0800
Message-Id: <20210816074905.297294-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add arp_validate filter support based on kernel commit 896149ff1b2c
("bonding: extend arp_validate to be able to receive unvalidated arp-only traffic")

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 ip/iplink_bond.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index b01f69a5..59c9e36d 100644
--- a/ip/iplink_bond.c
+++ b/ip/iplink_bond.c
@@ -41,6 +41,9 @@ static const char *arp_validate_tbl[] = {
 	"active",
 	"backup",
 	"all",
+	"filter",
+	"filter_active",
+	"filter_backup",
 	NULL,
 };
 
@@ -152,7 +155,7 @@ static void print_explain(FILE *f)
 		"                [ ad_actor_system LLADDR ]\n"
 		"\n"
 		"BONDMODE := balance-rr|active-backup|balance-xor|broadcast|802.3ad|balance-tlb|balance-alb\n"
-		"ARP_VALIDATE := none|active|backup|all\n"
+		"ARP_VALIDATE := none|active|backup|all|filter|filter_active|filter_backup\n"
 		"ARP_ALL_TARGETS := any|all\n"
 		"PRIMARY_RESELECT := always|better|failure\n"
 		"FAIL_OVER_MAC := none|active|follow\n"
-- 
2.31.1

