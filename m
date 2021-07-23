Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFE83D379A
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 11:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhGWIkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 04:40:25 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:34456
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229574AbhGWIkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 04:40:24 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 7CCD33F228
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 09:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627032057;
        bh=aTDeZwBMgFtKPnWXdcaT3ED7J8vSM5/RBLMh7ZrqdvU=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=LTu56HzuohgJhGJku3TsWRyTXyPZ1s6e0k0WnkA8sCEfd30pteFrgPS7cKQ7LQejw
         i1SuxxcxG5m3c3dm3GF0/bI7al4Y6jbsjwZq6x+ndD0dnSKO34ZV7i4Y13CYm0VxnK
         OPBxCDvnekdwlW7TSi2AYE6CcOaRVeCgkFoCVfIKrjQdxYr8D4sZWn132T447ehbz7
         yuhSVFYVDtsLoSRw6QgkeZCuOXvftR2m5JGsCeVssyiSGrfjjPS2xeAPbOiXTJVtbh
         H54+erW+hJ3zy2D5P5g1OLSjEycLHyoY2yogm9k78Io3JRSMOqMPmDVyceAn0DkH6Q
         QPCMmtb0EtmnQ==
Received: by mail-ed1-f70.google.com with SMTP id w17-20020a50fa910000b02903a66550f6f4so379139edr.21
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 02:20:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aTDeZwBMgFtKPnWXdcaT3ED7J8vSM5/RBLMh7ZrqdvU=;
        b=UHFr1lxBq63nc0+kCzcTHlHUlllf6TZFqJIvurhjc0nTJuPB7eBvH0rxeyakkIqrgy
         Pjj46vTtkp1YC+oMN1X3IG3V1SWmn0l8JkMXvO9wXoh88sOM04AvgXxkhm3C9Q8U5/2o
         u/Jc695kCHIZrQ4gsfrYA7qbF39Mo45KFimMpdOH54sLzzig3eB9jy6W/eT9zx97+Da3
         cUvKwcID9V1srOFF55a7JSCHRMZ+PiX3atNewmPyidLoi+EBwH9RLQuJ1SkiwsPbdWry
         79GPqH/pVLMCeEtInsMDdKufjwO9sCFkZPDjMAZmjT6jrNuTDGWAiwDbkixAiZ1Wksvu
         Uc6A==
X-Gm-Message-State: AOAM531juswzVhpfpamYJE4fV/ADYyQP9lYB5Trs8wBHoBuG5cXsLM1p
        GoOSf6QhYpcbPx3BiciEfbRgV4drwuB9Ot0hw4gvLj+xAnfIFYi9/IRgFXmQUUtq6foUlTm7IK5
        t3n9hJ55NW7Di0j0uJCS69HUhGDCjz61eyQ==
X-Received: by 2002:a05:6402:48f:: with SMTP id k15mr4410252edv.262.1627032056930;
        Fri, 23 Jul 2021 02:20:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFWvw+F1lJTRxbZaqbZ3+elmi1lpNeFCfvGnWOh7b792sBrPXWzm9q8WmpJaHOZKdNudcPWg==
X-Received: by 2002:a05:6402:48f:: with SMTP id k15mr4410243edv.262.1627032056837;
        Fri, 23 Jul 2021 02:20:56 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id p23sm13602536edt.71.2021.07.23.02.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 02:20:56 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: port100: constify protocol list array
Date:   Fri, 23 Jul 2021 11:20:34 +0200
Message-Id: <20210723092034.22603-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

File-scope "port100_protocol" array is read-only and passed as pointer
to const, so it can be made a const to increase code safety.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/port100.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index ee9429997565..217c5dfa8549 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -217,7 +217,7 @@ struct port100_protocol {
 	u8 value;
 } __packed;
 
-static struct port100_protocol
+static const struct port100_protocol
 in_protocols[][PORT100_IN_MAX_NUM_PROTOCOLS + 1] = {
 	[NFC_DIGITAL_FRAMING_NFCA_SHORT] = {
 		{ PORT100_IN_PROT_INITIAL_GUARD_TIME,      6 },
@@ -391,7 +391,7 @@ in_protocols[][PORT100_IN_MAX_NUM_PROTOCOLS + 1] = {
 	},
 };
 
-static struct port100_protocol
+static const struct port100_protocol
 tg_protocols[][PORT100_TG_MAX_NUM_PROTOCOLS + 1] = {
 	[NFC_DIGITAL_FRAMING_NFCA_SHORT] = {
 		{ PORT100_TG_PROT_END, 0 },
@@ -1130,7 +1130,7 @@ static int port100_in_set_rf(struct nfc_digital_dev *ddev, u8 rf)
 static int port100_in_set_framing(struct nfc_digital_dev *ddev, int param)
 {
 	struct port100 *dev = nfc_digital_get_drvdata(ddev);
-	struct port100_protocol *protocols;
+	const struct port100_protocol *protocols;
 	struct sk_buff *skb;
 	struct sk_buff *resp;
 	int num_protocols;
@@ -1287,7 +1287,7 @@ static int port100_tg_set_rf(struct nfc_digital_dev *ddev, u8 rf)
 static int port100_tg_set_framing(struct nfc_digital_dev *ddev, int param)
 {
 	struct port100 *dev = nfc_digital_get_drvdata(ddev);
-	struct port100_protocol *protocols;
+	const struct port100_protocol *protocols;
 	struct sk_buff *skb;
 	struct sk_buff *resp;
 	int rc;
-- 
2.27.0

