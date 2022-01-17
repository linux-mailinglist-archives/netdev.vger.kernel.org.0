Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7126490FE1
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiAQRu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241537AbiAQRuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:50:24 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D208FC06161C
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:23 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id n8so8816089plc.3
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UUg0KVM1F2nGgkcMTYO5rXPQ677Wz5yHiXolPtOt8ts=;
        b=hS+TTf5M5xjgFWI/tekFPoRn3Q5fTz6k1bv4aotlhKMBV2QgM1I+sNLpAGg0BejwRD
         azywjmWcIsBKx1FEJ4lME5bc9xdVw8sMxe99myj9FYbaVuoEgTNhCZiSxTgITTDtusKp
         +7v+n6IiZtkVBKGxQPCRy0LVg5lQfrO6BBEFug0s0tyjruqslPSUOeH9bUtcVWKHeih8
         zjhUv6aRXb6ujlCn7c3Ny6k4y8PKIRn16069XzVUcgHjuwQuiRFWP45awJ73hWEfUkra
         4jekAAlXP9BJnlvVnosrM76U001goVvMoPrGa2JI9ZGqySrROQqvuk7l+XteY4jh+83N
         P4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UUg0KVM1F2nGgkcMTYO5rXPQ677Wz5yHiXolPtOt8ts=;
        b=NdOo/Wu4JVL1ou4al9zHbdTyNyIJUXr9UWBlBMPzrqjABjzzyiYDPY48EoyI2juAbC
         QwN7k8nh0+wUsRSiCkpJmA8QdI4evALmlf2Y98IzA3vJSlg9GsA3kdUh6BeI5p1mhM74
         dlGlhErAO0XhwDDs135GQH1SO/+BaMFmeR4OOURqcpbW7dgYcnxRPEKLY4lVIWh1/v03
         LM3Ngy0c/k4+XYMrtf+MXzL7sQ2J2O9zKL+Np2HvjozgFF/SzdnNGcUNqe/fphU4Raot
         Bbugk7kCjzQ+UELuvF6up0HhPSO4oh+sWFTXVlL7QHjWORmJA5LupLNEKtuVKickmyrd
         iEpQ==
X-Gm-Message-State: AOAM530e0b/INiSR6O5esmydA5JI4PdjAv8JBulNDITWeDwTkiRjINTa
        Nm/CRo9EfaWMfm7oVS6/swqmMzXsOGmp+w==
X-Google-Smtp-Source: ABdhPJxUcZ56cpDQljvCRkTzGSZeiS5Z/7x1Dai8Z+Po5IOHXrHC1XxVUY8R1qpelDlMD7+Rn4D90A==
X-Received: by 2002:a17:902:ab16:b0:14a:912d:4502 with SMTP id ik22-20020a170902ab1600b0014a912d4502mr15557583plb.93.1642441823051;
        Mon, 17 Jan 2022 09:50:23 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id q19sm15819117pfk.131.2022.01.17.09.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 09:50:22 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v3 iproute2-next 01/11] tc: add format attribute to tc_print_rate
Date:   Mon, 17 Jan 2022 09:50:09 -0800
Message-Id: <20220117175019.13993-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220117175019.13993-1-stephen@networkplumber.org>
References: <20220117175019.13993-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This catches future errors and silences warning from Clang.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/tc_util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 48065897cee7..6d5eb754831a 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -247,7 +247,8 @@ int get_percent_rate64(__u64 *rate, const char *str, const char *dev)
 	return get_rate64(rate, r_str);
 }
 
-void tc_print_rate(enum output_type t, const char *key, const char *fmt,
+void __attribute__((format(printf, 3, 0)))
+tc_print_rate(enum output_type t, const char *key, const char *fmt,
 		   unsigned long long rate)
 {
 	print_rate(use_iec, t, key, fmt, rate);
-- 
2.30.2

