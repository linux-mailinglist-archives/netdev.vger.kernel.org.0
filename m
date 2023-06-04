Return-Path: <netdev+bounces-7755-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C149572167B
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 13:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46F131C2097D
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 11:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB295244;
	Sun,  4 Jun 2023 11:58:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824BB23A8
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 11:58:40 +0000 (UTC)
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E41DA
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 04:58:38 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-5147e40bbbbso5493459a12.3
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 04:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1685879917; x=1688471917;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=9U2ISGOXBj61E5nsd6ry6e4F9DhXHkTGse56SQYyvsE=;
        b=DE+sHBaN+wkpS+YRkhxBYnEs0ZMmknGb6Cjhqw9oBrZSOW+iUS9QrmC3waiXiQQSH0
         f7ga6aYNXxOqR248JXZjx9cucTKGp1/uL4Q65o5jKf00n4EiDm7oWfoLmTzsh+vAlNRN
         aNuXQuZWn5o8KsZ9mdFFaI5G5EjVSOjVctR9lN8WtTHc8RMHH+A2Jz69Gun4pSjjEdrg
         hhaT/nPT4r6nT5YpMLnzN5KSBCrZYc6pG7KxSH4sSASnKlwQK6kWZv04cbzJ3omdhe0n
         PlXAzGmT6tIJ4uTKaTPUXk3dnmzeMdCsGlO1b0+e/3Fspt8SJujs7gmSsHa48YdjketM
         v49g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685879917; x=1688471917;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9U2ISGOXBj61E5nsd6ry6e4F9DhXHkTGse56SQYyvsE=;
        b=XSc0eIqoGmf+ABcaDlhZnrnzI2m7cVf/g3qOItwxgpD2itVgB/70VbvoPvYeKR5SDX
         pGzasQpynfEFJjx8C7s6FbMzYiRQgmDOQyUEhE4FHoPBw/T0NGwTm46sg+D0Zcyue6u9
         sfzZ8RGLtoEE1NE4sshEduhOblroYRUHBUtAHcuzEaEYKxG0yj57KsJi4HpXACwktRei
         EzDh1S1yXOQ/6j7H2lPSzpBqivilCimCMsDxAgAIvPkgLUwvPelxpRus9AxBFpKle0Zr
         nrJ/uGOMH8L0ET4QKGQoFONIKcFi+tToV1p3WNkCHPEPrgFUT61ofI5KF6ORInkVo4x5
         dJpw==
X-Gm-Message-State: AC+VfDyBOu9Mn4Roehr+MvCzhhScYu5cN0+/JGGzbwXnYCM/BfeUkHur
	MkJBixqpHAr+zbI1JFmqQwmyOf3ufXdOBw==
X-Google-Smtp-Source: ACHHUZ7uF7UYIeiWygEP2tDAMbJ+Rptd1v0lVaX+azrtyzYUJOId2sbFfIGQds2a1s4n3GIFq3hr9w==
X-Received: by 2002:aa7:d591:0:b0:514:a0a7:7e7a with SMTP id r17-20020aa7d591000000b00514a0a77e7amr5177264edq.30.1685879917157;
        Sun, 04 Jun 2023 04:58:37 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id bc10-20020a056402204a00b00510de087302sm2706489edb.47.2023.06.04.04.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 04:58:36 -0700 (PDT)
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
Subject: [PATCH net-next v5 0/3] net: flower: add cfm support
Date: Sun,  4 Jun 2023 13:58:22 +0200
Message-Id: <20230604115825.2739031-1-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.40.1
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
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Zahari Doychev <zdoychev@maxlinear.com>

The first patch adds cfm support to the flow dissector.
The second adds the flower classifier support.
The third adds a selftest for the flower cfm functionality.

iproute2 changes will come in follow up patches.

---
v4->v5
 - fix coding style in flow dissector
 - use strict validation for flower cfm attributes
 - selftest: remove unused ip address configuration
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
 net/sched/cls_flower.c                        | 195 +++++++++++++----
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/tc_flower_cfm.sh | 206 ++++++++++++++++++
 6 files changed, 416 insertions(+), 46 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_cfm.sh

-- 
2.40.1


