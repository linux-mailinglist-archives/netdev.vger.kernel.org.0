Return-Path: <netdev+bounces-3340-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9C23706835
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:33:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66B1628177A
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6CB9211C;
	Wed, 17 May 2023 12:33:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA26C31EE2
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:33:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF0A1720
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 05:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684326797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8z2vZD/Mt9cHAxNPllMtq5Gn202/y1MZsQVh5pJbJGM=;
	b=ib+M0AL8v9877lvme7UrMuz2yL57uu8VI6R7XiC8iAZxjn6GOAxWJY/R2BYZc69Pvs7jhA
	jOTrRuCpiOl/rvf21NMBL2xy/vUFWHHGWX9EZFa7WVma6B7gYCn7hME0YjrqOEzIWG5rUs
	Scx3GDsOhHg9Q1MbzS7Zw3CAsD6leq4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-6u1MRAg8P9qbkoMHS43KmA-1; Wed, 17 May 2023 08:33:16 -0400
X-MC-Unique: 6u1MRAg8P9qbkoMHS43KmA-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-62115d818ecso10728336d6.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 05:33:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684326795; x=1686918795;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8z2vZD/Mt9cHAxNPllMtq5Gn202/y1MZsQVh5pJbJGM=;
        b=ejR5U+YhxFkptyN894cf1SEZ0eMgc5QRGSDnVmqj9wa4dNW2W6uCcZSCb53bmt4t50
         KTtIyoiA3/HpXc8+jwQAnD13HQ5wwuIAtPzbQ0HKN7SEa4lIg4jhtQzPRo7+viAVksT3
         ol+OFPT2+ZCtI6m1ENcNk92DKQUy7DQUColR5QvZvT6LcB+g/raQ5qXRucKMsPI4q+F6
         4QZ47BN5yClcWgwPY4GLqp2tbsQFkhFzBOokF62tWMkwVuGZrIu6u7HW3sf18xw4J6d0
         n6UztaJJCcw08pe0twtye5N/1HXqKAWByE428YpC/J1fftdUymthUJ0A86XH0fWO/eCC
         CNMg==
X-Gm-Message-State: AC+VfDxygXEzqyIC9mjM0I8pKll75e0X6TzXahzognyusTkXXh3p19kR
	sB5y43s6/72236/S+bz9e1TCJ+XtqUzNubufL+Ebhz0GFxif3f72ellSXNg5myfgopDXPl9+Zbm
	1QmrlfFDi9aMHwFh9
X-Received: by 2002:a05:6214:501b:b0:5ef:45a7:a3c0 with SMTP id jo27-20020a056214501b00b005ef45a7a3c0mr64278013qvb.27.1684326795652;
        Wed, 17 May 2023 05:33:15 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6lcwZCrP5ym6tgc0dTs+Pyybh7A+czybYSDpfRXvVjBpMBMbt7jNR80EZ4gMhVuD96wNBLdQ==
X-Received: by 2002:a05:6214:501b:b0:5ef:45a7:a3c0 with SMTP id jo27-20020a056214501b00b005ef45a7a3c0mr64277993qvb.27.1684326795438;
        Wed, 17 May 2023 05:33:15 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j5-20020a37c245000000b007595df328dcsm564251qkm.115.2023.05.17.05.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 05:33:15 -0700 (PDT)
From: Tom Rix <trix@redhat.com>
To: johannes@sipsolutions.net,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	nathan@kernel.org,
	ndesaulniers@google.com
Cc: linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Tom Rix <trix@redhat.com>
Subject: [PATCH] lib80211: remove unused variables iv32 and iv16
Date: Wed, 17 May 2023 08:33:10 -0400
Message-Id: <20230517123310.873023-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

clang with W=1 reports
net/wireless/lib80211_crypt_tkip.c:667:7: error: variable 'iv32'
  set but not used [-Werror,-Wunused-but-set-variable]
                u32 iv32 = tkey->tx_iv32;
                    ^
This variable not used so remove it.
Then remove a similar iv16 variable.
Remove the comment because the length is returned.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/wireless/lib80211_crypt_tkip.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index 1b4d6c87a5c5..9b411b6a7b5d 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -662,12 +662,6 @@ static int lib80211_tkip_get_key(void *key, int len, u8 * seq, void *priv)
 	memcpy(key, tkey->key, TKIP_KEY_LEN);
 
 	if (seq) {
-		/* Return the sequence number of the last transmitted frame. */
-		u16 iv16 = tkey->tx_iv16;
-		u32 iv32 = tkey->tx_iv32;
-		if (iv16 == 0)
-			iv32--;
-		iv16--;
 		seq[0] = tkey->tx_iv16;
 		seq[1] = tkey->tx_iv16 >> 8;
 		seq[2] = tkey->tx_iv32;
-- 
2.27.0


