Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B528866C340
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 16:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbjAPPH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 10:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbjAPPHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 10:07:33 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1F023652;
        Mon, 16 Jan 2023 06:55:16 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id hw16so56824862ejc.10;
        Mon, 16 Jan 2023 06:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xhSjTBHJmXYr2emRMWv3c425aCY5/G3WkEL4j7Ip0kQ=;
        b=cV/I5vBODDPK7L593lHoMfZf/+UbRNsgzNF5uZOlvyKmXVhajdjyOWq6V84XbvI2Hn
         IY3A0t3epQZFcXTOqpXzuHJJFLFVICKkEhQT83qaLvBcgmGX/MRjY++zz5YvmNohVLSs
         QFSUvKEohycu4uRlzKMWxoyH6N1AkxPh/hR1P6cfqtL3WaCH7jNHyeV2m6HzDHnPMHJp
         QVkMhU4c4i7JhTV8IT11y6tek7GLDSsvJfsGzpA0bXxQmBlAwJPFiHnehDqM1eeaHKdN
         KX4+lSMcy0uCa3cGPiVgRJZLwolXHfVY0zQM4o5cgi+Dvt/JdaziT+/uQpPP5dhBvctp
         2TVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xhSjTBHJmXYr2emRMWv3c425aCY5/G3WkEL4j7Ip0kQ=;
        b=EBmU0/8eZVKaCssUqaWsVbr9GzO64wAHVXep5qH0Kzgh3xwjSD7Pxoj4WgTRRLFqK4
         TnQKFC1Dng9kOSQdkbT2qxfcD2Unq6yLWvaCK1auAdVuv5JOwO6BmXqNUEEvLoht7xLN
         BurttFYginXMAB8jQLNsXcOxd+kMLZZUN9QZR95vnYzlw6HCzI98BbTZBHEwsecDlrCi
         +fucWV/zufiQRZnO6TxiRtalooytmeiNCvCQuPXVp2+mFhJHXfmQmIAegy2W4Yuf1Xzs
         kTsrQfL0Z7j1Mga9oW5MAzvmlSQEnC5mWPhZIqbKuANJ4wYoM4yHZVe1OpItHIjjofP9
         Y6oQ==
X-Gm-Message-State: AFqh2krvpFBs4f7Oky68OUSkqvmwWSjYdXzwXIbegHnU6iJTeEpoeCeA
        KDgLTAgYoYLQUhEf76YHftc=
X-Google-Smtp-Source: AMrXdXuZLt2ra5d96V1ap4oZOPYmynDnhh0oRM2DexK1QMtc0nYqpKlsGTQkzhysV/ttrIrUy4DRrg==
X-Received: by 2002:a17:906:704a:b0:83f:cbc0:1b30 with SMTP id r10-20020a170906704a00b0083fcbc01b30mr74170693ejj.10.1673880914876;
        Mon, 16 Jan 2023 06:55:14 -0800 (PST)
Received: from Tanmay.. (ip5f5ad41d.dynamic.kabel-deutschland.de. [95.90.212.29])
        by smtp.gmail.com with ESMTPSA id q14-20020a1709066b0e00b0074134543f82sm12145666ejr.90.2023.01.16.06.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 06:55:14 -0800 (PST)
From:   Tanmay Bhushan <007047221b@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tanmay Bhushan <007047221b@gmail.com>
Subject: [PATCH] ipv6: Remove extra counter pull before gc
Date:   Mon, 16 Jan 2023 15:55:00 +0100
Message-Id: <20230116145500.44699-1-007047221b@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_STARTS_WITH_NUMS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per cpu entries are no longer used in consideration
for doing gc or not. Remove the extra per cpu entries
pull to directly check for time and perform gc.

Signed-off-by: Tanmay Bhushan <007047221b@gmail.com>
---
 net/ipv6/route.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index b643dda68d31..76889ceeead9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3294,10 +3294,6 @@ static void ip6_dst_gc(struct dst_ops *ops)
 	unsigned int val;
 	int entries;
 
-	entries = dst_entries_get_fast(ops);
-	if (entries > ops->gc_thresh)
-		entries = dst_entries_get_slow(ops);
-
 	if (time_after(rt_last_gc + rt_min_interval, jiffies))
 		goto out;
 
-- 
2.34.1

