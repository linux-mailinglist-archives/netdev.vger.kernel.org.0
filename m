Return-Path: <netdev+bounces-9106-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C20B8727458
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 03:35:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 250701C20F91
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 01:35:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE78BA52;
	Thu,  8 Jun 2023 01:35:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F924A42
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 01:35:02 +0000 (UTC)
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDC410DE
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 18:35:00 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6537d2a8c20so1170b3a.2
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 18:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1686188100; x=1688780100;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=q35+122v177u1oXgEARMn4wcb/ndxc+dM09dftPyTLs=;
        b=E13FclcKUM66JZx0UhbDsx3l84JjLW9sm2PXE621hO4RBOcVfW2phJjCNoz1ptrYkT
         8jxnu/j9AQbLODnSIkhkpHgEx04RdvwXKga/K1FUzseS61lem4uydEpXkTYnWUc8501s
         4toxcYKksemrCmT9GSg50UjCgF3jeU1CqMviPWMUVTBRZ0cI0L7Jo+Go/Xiv2BLf4lps
         +BxToVkwaPa5w1mHRqLHmboH/l0hJyos9oAGMGqlw33CfynpG+wgNzja/TZPgJ36bj/Q
         JYhcxbVOIbC5GTt/aRO+Mg9xBbaJZXKHVjjOoZDnuWgSOkaMrJ+B/KzJHPRUWdop87hx
         wRzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686188100; x=1688780100;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q35+122v177u1oXgEARMn4wcb/ndxc+dM09dftPyTLs=;
        b=W3oN5LBw497WJ9XYn5kBw7dpKaIXO5888GqxMJQXiac/2Rbc03Wyr9EJhDVHnSMqb2
         GZZjGhWmCblPL3HFfInwIIvXYgfwK2SsEZcXWmGs9u3zQElMk4MUYxj0KIAvXhaapULW
         Qxm2UjyTGnYmicniKL8ng3E4xa3+SGHqyAr1tQoxn1V5HxrL+v7uMpK8bVsAYdBu06dR
         SP0QtFhjwKiw+h4NZbbhUXm7eJjXpVl3eoSLetKxGWr2qboXQIfAzNMWFeYhUJmXyvdT
         g9zMH60w9j/CcvzU/5TaVDOglidW5qLY6DHZivphqpqFNGFnOEzpA0ltJCSwCdd2BbVc
         FmxA==
X-Gm-Message-State: AC+VfDykeGCMH1ZsYk7ulgAdG53IOlnJY/nwUgPgGQWsZjwLZ8hoQgKT
	LohDxTpoOIwMY3iVkmoNsnINgMHeJPTd0uXz0AQKX+mQ
X-Google-Smtp-Source: ACHHUZ4veYHRNkM/KUhxJNarvzo//HSNKTNQpNtoFudeHgIKsAbrlrb+4ymKK5oojD+MvelnekAOtw==
X-Received: by 2002:a17:902:c20b:b0:1b0:4727:69d4 with SMTP id 11-20020a170902c20b00b001b0472769d4mr3197627pll.54.1686188099762;
        Wed, 07 Jun 2023 18:34:59 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902e54a00b001b01448ba72sm119241plf.215.2023.06.07.18.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 18:34:59 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] rt_names: check for malloc() failure
Date: Wed,  7 Jun 2023 18:34:54 -0700
Message-Id: <20230608013454.15813-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fixes issue reported by Gcc 13 analayzer.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 lib/rt_names.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/rt_names.c b/lib/rt_names.c
index b441e98f8078..68db74e301ff 100644
--- a/lib/rt_names.c
+++ b/lib/rt_names.c
@@ -81,6 +81,10 @@ rtnl_hash_initialize(const char *file, struct rtnl_hash_entry **hash, int size)
 			continue;
 
 		entry = malloc(sizeof(*entry));
+		if (entry == NULL) {
+			fprintf(stderr, "malloc error: for entry\n");
+			break;
+		}
 		entry->id   = id;
 		entry->name = strdup(namebuf);
 		entry->next = hash[id & (size - 1)];
-- 
2.39.2


