Return-Path: <netdev+bounces-8620-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 622E5724E61
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 22:59:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5ECB1C20B63
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 20:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E21F22E45;
	Tue,  6 Jun 2023 20:59:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CE946BE
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 20:59:49 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852C41707
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:59:47 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-977d0ee1736so480247766b.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 13:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1686085186; x=1688677186;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=plO0E/gRR6obR7X0f7z61pk5JLqitbDO9/ShotqhYRM=;
        b=lMhqJXBbgBNkVZ07rRjuKe9OxS5jjOwUhoSwMnu3/gH9glAfx+bHGFpB4D4m7CqmFG
         r4mwEHA+b7SY1nXk99A7crTjW+SWZRbSW5qjit+1DwYLwuOTtAWTqbJfIYkgTFGcIlbZ
         WsJ5SU6zMF9F6tsvRx4L/dr02eynq5HWguQEIOI2qEBWUxTvOH44Pr5kIhVBZ9Q5ltsG
         MaD2HDtT/1f8N6LCCtmy9idwT7Z3NEICj+OTzcpJFuMCNqdieYB4nQE1axZWsBMQlCtB
         bWcPVJIYKMGps8W4RJ8YKvWgYIQKBHPVSI1f1qQHqD8zwRR+Nf0TQq62/S4YYxzOBzHl
         7ExA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686085186; x=1688677186;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=plO0E/gRR6obR7X0f7z61pk5JLqitbDO9/ShotqhYRM=;
        b=XjTJ8NkJzq2imdzza5vN8Yfe8rkquyJ2/Hyy4VgXLKYybxEEBsg60v4yJKCuLW7IgF
         EnJJaJL7Fh5MbjCpUDuhVT8ngGe3oLZRTJH0uGiCXim/Q5zZjcze5gkMzIvtlFm3hSDx
         fKizQl0+RS2DBVaRARzEP7rRTHqu4BcD5eWJ1rk3Lb8YzxlGjHWV8pXkxGJzdIzKVxAd
         VA2gjRcKDINd2ibXvu6urQTpo8F30x0Jsek/+DdiEOiu0LPsbCWhntt+XbLwEenIQvqx
         S8aafXwFFe0Z2HEB+7Lt8oLvwIkA+ZWVCiQKF3fBdY2vRAvxYNRcDQZlCFlZCclDGEOU
         Ol5A==
X-Gm-Message-State: AC+VfDx/lf3GKROk6D6TCvteuD0rSSKG6d43sW0kDylFdWnLIOYdhKSM
	Jfsw2iexEEjzkZ669hbjk4Gj1Kbm3U77LA==
X-Google-Smtp-Source: ACHHUZ6Is5o/HoD/Yw1NM0ffaDvdYlduHjAh/9LTvtwHA5WIwkS/SggqeJp7e56AQL7sQ1Uot9WK8Q==
X-Received: by 2002:a17:907:6d99:b0:976:6824:ec6d with SMTP id sb25-20020a1709076d9900b009766824ec6dmr3663976ejc.62.1686085185718;
        Tue, 06 Jun 2023 13:59:45 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id l1-20020a17090615c100b0096a742beb68sm5926162ejd.201.2023.06.06.13.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 13:59:45 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From: Zahari Doychev <zahari.doychev@linux.com>
To: netdev@vger.kernel.org
Cc: jhs@mojatatu.com,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	hmehrtens@maxlinear.com,
	aleksander.lobakin@intel.com,
	simon.horman@corigine.com,
	idosch@idosch.org,
	Zahari Doychev <zdoychev@maxlinear.com>
Subject: [PATCH net-next v6 0/3] net: flower: add cfm support
Date: Tue,  6 Jun 2023 22:59:32 +0200
Message-ID: <20230606205935.570850-1-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Zahari Doychev <zdoychev@maxlinear.com>

The first patch adds cfm support to the flow dissector.
The second adds the flower classifier support.
The third adds a selftest for the flower cfm functionality.

iproute2 changes will come in follow up patches.

---
v5->v6
 - do not use NLA_POLICY_NESTED() for cfm_opt_policy attribute

v4->v5
 - fix coding style in flow dissector
 - use strict validation for flower cfm attributes
 - selftest: remove unneeded parameters and configuration
 - selftest: make cfm packet generation code more readable
 - selftest: use the same pref for each filter
 - selftest: check if all filters match

v3->v4
 - use correct size in memchr_inv()
 - remove md level range check and use NLA_POLICY_MAX

v2->v3
 - split the flow dissector and flower changes in separate patches
 - use bit field macros
 - copy separately each cfm key field

v1->v2:
 - add missing comments
 - improve cfm packet dissection
 - move defines to header file
 - fix code formatting
 - remove unneeded attribute defines

rfc->v1:
 - add selftest to the makefile TEST_PROGS.


Zahari Doychev (3):
  net: flow_dissector: add support for cfm packets
  net: flower: add support for matching cfm fields
  selftests: net: add tc flower cfm test

 include/net/flow_dissector.h                  |  21 ++
 include/uapi/linux/pkt_cls.h                  |   9 +
 net/core/flow_dissector.c                     |  30 +++
 net/sched/cls_flower.c                        | 103 +++++++++
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/tc_flower_cfm.sh | 206 ++++++++++++++++++
 6 files changed, 370 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_cfm.sh

-- 
2.41.0


