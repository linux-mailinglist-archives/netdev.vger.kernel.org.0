Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9024885F8
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbiAHUrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiAHUq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:46:59 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0B4C061746
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 12:46:59 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id n16so8687071plc.2
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 12:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2CmMkcLMupEBjGGLQZwEV/RJ8zBm1D0fwzw031sSOqU=;
        b=0rPYRnKNRhtlMYo+umF2B60X6BEycU3ZJgf0/ppnv67ilsdZAz6Ue6f1fciZHysZ+F
         +aqe7y80PCj7zqVsTCYjMoWo2k0EOFERwbQQqb0zfz2brgaPmE44KmxKk14N7ANGJZtG
         oIm3aq1n+rVLsdz7W2B32keycCV8Pqlne/LKs4TWWNMtSKeQSNCdTUiVW9IL0FeZwOLS
         qEJnpYkgtscL+BY6mYgiycuv2PN86t35V0+fWE0eKkE35RC5PVZtu/hU6m50NSlUoscF
         lOLNYEgt8xKZI2fUCun9MFomVVC1SPXBmhQ2pm0EK2aAThchswzcOn7q2pjPriae/qVE
         vRFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2CmMkcLMupEBjGGLQZwEV/RJ8zBm1D0fwzw031sSOqU=;
        b=TbSb1kG+lLQUC13KMrwCcgUFgsQ79taeI+K0Nrnu0I6EvvPq6E5maCiC+C58zfcy7b
         OMq9NZ0pELNZM/BapAWhhdccxhSaDrR2PmsnRB+grhHjXqZHJeQttF/+JGAn/RZuTKLe
         /XaoPFR8tLA27xI6lBc7iAFImZrqv7ViHFegWrkbE6CYdTunqnHdHk0JGaEiu+jvjmyo
         qg4gp1zuVmT6EiDOSiH1qtdArKs0fW31Z8AU1HMEDKiRObo4yB2mvD9Qbh6J2Fqhsya3
         VzdNuIDoWKAU1LFOra00tO6f4QcwZ6JeLNtxP39UysS0x287IFmwl2c6y/0U73EXBmSA
         Swug==
X-Gm-Message-State: AOAM530yA1mAQdvdQ47ZwzXkdBsV4/XrytMY3dFWHNkrHktyWkmTZltM
        rs9B7mYnNwHYXY3CmlRBj3Ds73+AWn/9IQ==
X-Google-Smtp-Source: ABdhPJybsjb8lYpmoxR7mNlp+CNZ+az4HuON5Xe1NNOpEPE3svNcxFGDLVWLO3SwzdxiVNt7bnjhvA==
X-Received: by 2002:aa7:9705:0:b0:4bb:6897:6b80 with SMTP id a5-20020aa79705000000b004bb68976b80mr70449787pfg.21.1641674819025;
        Sat, 08 Jan 2022 12:46:59 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u71sm2129393pgd.68.2022.01.08.12.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 12:46:58 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 08/11] ipl2tp: fix clang warning
Date:   Sat,  8 Jan 2022 12:46:47 -0800
Message-Id: <20220108204650.36185-9-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220108204650.36185-1-sthemmin@microsoft.com>
References: <20220108204650.36185-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang complains about passing non-format string.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/ipl2tp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ip/ipl2tp.c b/ip/ipl2tp.c
index 77bc3249c7ec..569723581ec2 100644
--- a/ip/ipl2tp.c
+++ b/ip/ipl2tp.c
@@ -191,8 +191,9 @@ static int delete_session(struct l2tp_parm *p)
 	return 0;
 }
 
-static void print_cookie(const char *name, const char *fmt,
-			 const uint8_t *cookie, int len)
+static void __attribute__((format(printf, 2, 0)))
+print_cookie(const char *name, const char *fmt,
+	     const uint8_t *cookie, int len)
 {
 	char abuf[32];
 	size_t n;
-- 
2.30.2

