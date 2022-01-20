Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B234955C8
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 22:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377755AbiATVGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 16:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377753AbiATVGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 16:06:50 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAB6C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:06:50 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id v74so3474562pfc.1
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dCXc67pt8Jt9WPkWWhpXKc8ZSTesRo6/JrRH8mgsFwY=;
        b=wyjYGIFt/KZyhYKeLZl1VYoOPJTKhOuIjmWegzCtnqiUOBX8xjOCz8b4CxKbRtaKzJ
         72f12AAQx30Bl/SfCEM30iScJNETyVdarAlT0EarSFyDHtFtLJtEU/oif/StxWnT6vA/
         tmMPW3uOZuFXy9xhVniKjS99otR+Rta7l7X4s6iddM7/OCf1xyGLSE36XWKftYJFx+u6
         YxzbRGqn47XY3yor03YreCAA1+ibUZtHYjm/3VcNnmpe3+mvdguGSBvBrVkBJd3fym/m
         ntbeoTWqZ2dtFzZq5tBPEjPI5Rc/YyTXiFPDmUR6IsUThF+zBYjOtmQenyZ72sMldf6L
         pYRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dCXc67pt8Jt9WPkWWhpXKc8ZSTesRo6/JrRH8mgsFwY=;
        b=BpVq3heRkzSBollXl9do9md3nNCrNWscKJXD90XE7H1/1CNxQaG93txL765RetHjON
         IcHiDX6ygE2JdM15n4/E7j0No35Yb0SXDG9Gt5y5Mu6OeJbQFvhANb4KJ9ryNWxFyFUe
         9PDlOV+6hCxDe56++V0cr+tN8Oi4isCP9+vXcEF6zGGokFACXATU9JlY7zHnN/hxpEnx
         em81W1te9DKj/qkU6LiZ+OHAbU0KMMwLSUDf08iP6mNwA2uBObtG4HKh37Z6idAmy4Xl
         HznA2ekaADVINxpHXPszrRfVA1562Hy2Y1R62rPJUhO8vz0VCF2Knmk7Ejs+kArujTLw
         QzsQ==
X-Gm-Message-State: AOAM533EeS8BUlM8tFwRf0dSt4rhBzSMK52DtUjfM9YAI+StNUYmRfOk
        erOfp49d3q2cMQ01lcFez4RGEygVWNK7rw==
X-Google-Smtp-Source: ABdhPJywuU1CD9XM533bEkgLpxGDyp8+JUSITeeXFNYXy7qQ9g8fGNHimSU44Rb70mllwwaD0YoLCw==
X-Received: by 2002:a63:3808:: with SMTP id f8mr455390pga.435.1642712809641;
        Thu, 20 Jan 2022 13:06:49 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id c2sm4668064pfv.68.2022.01.20.13.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 13:06:49 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>, jiri@mellanox.com
Subject: [PATCH iproute2] tc/action: print error to stderr
Date:   Thu, 20 Jan 2022 13:06:46 -0800
Message-Id: <20220120210646.189197-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Error messages should go to stderr even if using JSON.

Fixes: 2704bd625583 ("tc: jsonify actions core")
Cc: jiri@mellanox.com
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/m_action.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tc/m_action.c b/tc/m_action.c
index b16882a345dc..ee32aeda98fd 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -466,10 +466,8 @@ tc_print_action(FILE *f, const struct rtattr *arg, unsigned short tot_acts)
 			print_nl();
 			print_uint(PRINT_ANY, "order",
 				   "\taction order %u: ", i);
-			if (tc_print_one_action(f, tb[i]) < 0) {
-				print_string(PRINT_FP, NULL,
-					     "Error printing action\n", NULL);
-			}
+			if (tc_print_one_action(f, tb[i]) < 0)
+				fprintf(stderr, "Error printing action\n");
 			close_json_object();
 		}
 
-- 
2.30.2

