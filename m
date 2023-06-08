Return-Path: <netdev+bounces-9193-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 892E3727D59
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:57:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42359281695
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29CEBC8E7;
	Thu,  8 Jun 2023 10:57:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A423A3D
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:57:02 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF3CE57
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 03:57:00 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-977d55ac17bso89362866b.3
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 03:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1686221819; x=1688813819;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=xjahsimHvMtm2HBuy1SNLFnDgRIDtPV+Dsl5+mr6m7s=;
        b=dkOffaqRd0O9ZQ5EddGuYD4jBoJe2nMagFHvl1CZVoAM5Q55IYZ/f0gg4d5bEK+3Cj
         M/C89APsfZQh7FTU3emygrc2WFeJ2oP2LRUmsXEieOVuJCJgHydPtGKL4b6YCiyndLqp
         T5nrnUg4xM7W5YZ/2zsIuSwhuspWqvR7+jrRf3qxMFYnyGl+y4oM9k8AprL3R/6oHf37
         +LnJ/h28/5zOnZKSEaR92z/k8gpFMun7lb/hRkDZ0FsxRR3LVVkSzbakr75+hWB3dA6W
         O6vYp4HNCnzBzklylVXH3rKDLOcEtovL1bjkFiklSZdVEGgbY6tZMp2GnC99P0cNFGk1
         5m3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686221819; x=1688813819;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xjahsimHvMtm2HBuy1SNLFnDgRIDtPV+Dsl5+mr6m7s=;
        b=KitkuAWwK84m3qOo4Kvao/mNKXPlXxZf12H4ci2MEbH5d38DjxvI78RoSsvvihMLq5
         dgsbcbInKtT+g6ItBwBkUXZ5Bis37drDU44HcnC7xJ7Xh9/LWBMKND0zRVFBJBqNihfo
         tEmhnqNh316JvowLbswSaC9eflskmLW+bNgKKHn+qakuJri9/+PuZtMYWHNwxggOmCK9
         M4/IWYd2Aitb5FPBzqBlx23NODvs+5O4cUEm8aFnAN5ouZPe2ZCG3KwMrYL8VRKRMIgy
         3tNnJunScegmlpjI7E8vD0I0FiUzwlu6meRhrrmQOe2LZKP4EhsuD9/craj5YxkOgQqo
         Vxvw==
X-Gm-Message-State: AC+VfDzGzvofec8n5oGBrdsNaHKEdSHD9QhSfisRUeQR17Q8M4BDRqYe
	ybEWXpTmazf1O1N1Mqv4y/Yw6VmJgrdYhw==
X-Google-Smtp-Source: ACHHUZ4F+Ev1NJhFelkj/4R36zFuwbnHJvODQCJJIvHeshyZxwzC990xsjbJF4Y+y7jib7FynScPLA==
X-Received: by 2002:a17:907:7214:b0:961:2956:2ed9 with SMTP id dr20-20020a170907721400b0096129562ed9mr9288197ejc.25.1686221819089;
        Thu, 08 Jun 2023 03:56:59 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id t23-20020a1709064f1700b0094f07545d40sm522719eju.220.2023.06.08.03.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 03:56:58 -0700 (PDT)
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
Subject: [PATCH net-next v7 0/3] net: flower: add cfm support
Date: Thu,  8 Jun 2023 12:56:45 +0200
Message-ID: <20230608105648.266575-1-zahari.doychev@linux.com>
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
v6->v7
 - make fl_set_key_cfm_md_level() void

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
 net/sched/cls_flower.c                        | 102 +++++++++
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/tc_flower_cfm.sh | 206 ++++++++++++++++++
 6 files changed, 369 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_cfm.sh

-- 
2.41.0


