Return-Path: <netdev+bounces-9576-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CFDE729DFE
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:13:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 262691C20D53
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B8418AED;
	Fri,  9 Jun 2023 15:13:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFC4182BE
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 15:13:50 +0000 (UTC)
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CBF210D
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:13:49 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-39c82204e62so668365b6e.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 08:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686323628; x=1688915628;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KU2DNQsADzeSCdfagw3B5yRJY1gPQJPXOlwtQ8tuBn4=;
        b=qkQcKlu3TnGYSH944UPDE64ypCHe0lIYQuC4Z9fwEewUI7lKeyssjNazNnF9s/qqwS
         qSXiVoTmbCBRgfPX0c5li4cOFxnMKPnFPgmSLK52zDEaJlX/aLho7OonFpD9FZmJPwzP
         MfBRVGbSsZDQTTtcyM4lT8kWk8zxza8phAlSbcb4nmt78iwKAJHYqOrC4m0ufagiYo2Z
         /zHYdcfTQ7RwDxfvcTqCqtOt+HirwR2dQc3Af3HK01Ebb37PO0YEQ5QEK+Kx4VU0UVAN
         6LGf+GU4GcqhLQUl1hm5+1vlYEqExUMljumcWdD7UOM2WvTQkAkaT9WLTIfOocxbSxuD
         BoTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686323628; x=1688915628;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KU2DNQsADzeSCdfagw3B5yRJY1gPQJPXOlwtQ8tuBn4=;
        b=gldyewLx+qDY0FDymT1nKNfzl54CWcGOJez4aKz+HGafWdEySZVUUXWl+5OSd8PzUG
         6iomD918J3IxqDYIGRGfTxAyIS3zH+KxMVR730KwAt1/HD/DN5BxwpYi3NFQhskkw91x
         hvW+h5lfjzshaF4/gbEFR+kBeoORZKg+44kyapkbUf4C9gJ46Nc5ajhg+5khLI9xnfL1
         pmebJ9t1Gke6iLRkOvBZpCtfZr7jbc5bhD16f71dXkZTipnb3R4/v1J1XqAi3tteD1Mw
         r4pw2mGs4e3fAggReARK1P1FYgSSFKCQZB51pDBBWLtQT1mg7b5liIB6G3VqydT9Ik0A
         zV3g==
X-Gm-Message-State: AC+VfDxAeBJ1rY2droPdgNO5yNsvNSv8PhxPSn0xreNtZylzYWDajuq7
	/q5Q054efJxO0rfd+1c9Z4gvJSkt9KoGi4/WiSM=
X-Google-Smtp-Source: ACHHUZ6BfIcweAsMVa88ZOcJvHNwW/s/j5DBJct32CdSd8C+ydD4nOv8Tzmei3gtV0putKpAK0mJiQ==
X-Received: by 2002:a05:6808:3090:b0:398:45e0:38c0 with SMTP id bl16-20020a056808309000b0039845e038c0mr2176459oib.15.1686323627027;
        Fri, 09 Jun 2023 08:13:47 -0700 (PDT)
Received: from rogue-one.tail33bf8.ts.net ([2804:14d:5c5e:44fb:643a:b27d:4a69:3b94])
        by smtp.gmail.com with ESMTPSA id z2-20020aca3302000000b0038ee0c3b38esm1536449oiz.44.2023.06.09.08.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 08:13:46 -0700 (PDT)
From: Pedro Tammela <pctammela@mojatatu.com>
To: netdev@vger.kernel.org
Cc: tgraf@suug.ch,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [RFC PATCH net-next 0/4] rhashtable: length helper for rhashtable and rhltable
Date: Fri,  9 Jun 2023 12:13:28 -0300
Message-Id: <20230609151332.263152-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Whenever someone wants to retrieve the total number of elements in a
rhashtable/rhltable it needs to open code the access to 'nelems'.
Therefore provide a helper for such operation and convert two accesses as
an example.

Pedro Tammela (4):
  rhashtable: add length helper for rhashtable and rhltable
  rhashtable: use new length helpers
  net/ipv4: use rhashtable length helper
  net/ipv6: use rhashtable length helper

 include/linux/rhashtable.h | 16 ++++++++++++++++
 lib/rhashtable.c           |  2 +-
 lib/test_rhashtable.c      |  4 ++--
 net/ipv4/proc.c            |  3 ++-
 net/ipv6/proc.c            |  3 ++-
 5 files changed, 23 insertions(+), 5 deletions(-)

-- 
2.39.2


