Return-Path: <netdev+bounces-5678-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6CEB7126BD
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:34:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 779BB1C210A0
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0170168D8;
	Fri, 26 May 2023 12:34:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B2E168D7
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 12:34:02 +0000 (UTC)
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A5AE64
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:33:28 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-75cbbb10c69so37535085a.2
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685104361; x=1687696361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQC2LiSG4zGxWR/uYO2BhK2NyF2T7h/DUf35YB215j0=;
        b=RS4J0/LH69TZg5z1Y35fncO/NUIOVnJhmSbWoAwrXEQR+6f4S/JeLmiAsQ5IAH5Qu+
         Tj/M1PQG1RXjrlD5Q3OwR6sDcvACTgDP0A1j58b2Z4lkvDgfbLwS+ek7NkSkM0XliXhA
         0EpkR0QjxgxmfLEFHefXq24a7T06m+NRT4C1Ilivc1s0GyqIImiqfzbllVenT+V7J0nD
         c1EV6c5OP9i3EYrOUI0oHWA5vTn7c8SHpLaT+knu7Xo8c3MrC6iWHl0f72sGkEoCB1cE
         asq+EDcJMOocAUn7vghHBkRgctBGK7Lzqeb65SjgtcMWyjI3lyhqAAlQsQYL0y/HjDy+
         TM1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685104361; x=1687696361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IQC2LiSG4zGxWR/uYO2BhK2NyF2T7h/DUf35YB215j0=;
        b=CA/Zh47zJUYhs+sSOj9z6nYpis+tPQD8x3bm95cLDdnwVvvjzcH9Np/v8N4QoU6Yba
         jmympOinKMoXtrmr9wg8zLdXNGUe0nHR/oR4I/4s6FLCRJjNfDH9o/8hIjRGSNDZYPGV
         oiqOjlLhC9pNj5QjewGv8hM032vy7eO/E++k/Px4ZJTCXr0XazwRDWxv3K2gyLPMWRVs
         f8BJv2ukXXwA/N837H+Pm4mKiFhSAPNYjztDX3i4gffrE6Pif5VL1XBOVaFyin5A4bk+
         r4u/mr1qCOSQbs76jRh3T8FMcy1MleI4aeuhZtV9WAq1M/vrrdZT7PAdaHXaR/lFtfwj
         v5gw==
X-Gm-Message-State: AC+VfDxj869sRw50J58j2poMu6nm3MvqjvINFn2KMVqE10Bl7WhQ/4Yg
	ocxv3x0OwzWFVDq7gd1jFauAQBNGAhyj67+3
X-Google-Smtp-Source: ACHHUZ5ZrpB5vDg8JrWqbctl+BU0xF/k4LRi+vFqmKKXXOWH39erL8fqXg0rFNF8KxPYy5yA5oZ5Dw==
X-Received: by 2002:a05:6214:e49:b0:5ef:5144:9d2f with SMTP id o9-20020a0562140e4900b005ef51449d2fmr1337695qvc.20.1685104361522;
        Fri, 26 May 2023 05:32:41 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id d13-20020a05620a166d00b007595614c17bsm1121026qko.57.2023.05.26.05.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 05:32:41 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v1 2/4] tools: ynl: Initialise fixed headers to 0 in genetlink-legacy
Date: Fri, 26 May 2023 13:32:21 +0100
Message-Id: <20230526123223.35755-3-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230526123223.35755-1-donald.hunter@gmail.com>
References: <20230526123223.35755-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This eliminates the need for e.g. --json '{"dp-ifindex":0}' which is not
too big a deal for ovs but will get tiresome for fixed header structs that
have many members.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 tools/net/ynl/lib/ynl.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 7c7a54d6841c..4e0811ec5a8d 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -541,7 +541,7 @@ class YnlFamily(SpecFamily):
         if op.fixed_header:
             fixed_header_members = self.consts[op.fixed_header].members
             for m in fixed_header_members:
-                value = vals.pop(m.name)
+                value = vals.pop(m.name) if m.name in vals else 0
                 format = NlAttr.get_format(m.type, m.byte_order)
                 msg += format.pack(value)
         for name, value in vals.items():
-- 
2.40.0


