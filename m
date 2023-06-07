Return-Path: <netdev+bounces-8839-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 629FB725FB9
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:41:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 773FA1C20E8F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2593D210A;
	Wed,  7 Jun 2023 12:41:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105F8626;
	Wed,  7 Jun 2023 12:41:05 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD751BF5;
	Wed,  7 Jun 2023 05:40:37 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-516a0546230so551959a12.3;
        Wed, 07 Jun 2023 05:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686141596; x=1688733596;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hQn0uFJCpJmXCmOjjUjAo32a6wELEyxybu3QCQdKk+w=;
        b=bv6hmv2YOewAE7kjkWMOVJmTObd3L/faqOwrXginYUwm21qYyRIJzStoFTUNs2YgoE
         fcRDRzyCaC65CDT85Sl1sYiKHSeFvrmswE/ODpQwPGQIe952ATGdAgHgSWOZKQhGU+ir
         GdIAKR4MqubC9TZy2Mt2UJTOJtBluVXG02bpZBQ318vY//DKo1BDvpw4Pa8m+ryCoAoj
         OQTyvomDkiRwboC4u3m8hbiNlPrWgl2cJArQwEeX+VMlxVqMD27jLJL+39hJpw5/3xCb
         aqjTfTQHRJYzx5eAlyKHF//hV0lLl/bG8ojCZ5B5LZvnvOktb1sE58njba3Xafan0e+i
         Nftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686141596; x=1688733596;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hQn0uFJCpJmXCmOjjUjAo32a6wELEyxybu3QCQdKk+w=;
        b=TiyUxO1nCoCutKb1htyd5aA+rc0qNl5zZyrIG06+Ep5Z5O8QZCutKkt4/Q+bdATJEW
         IuG85xYJWoi3gryEZLSqSsC0iYDo+zsx94hEfyvqoge0fP3ALmp4SsnDg43F2JQWlbOi
         1OsLf3Sub7cs0hH0GV7HrOYO6T2/6G107p/4lWnAdsTauEWytMkYOffIj6dki+jfv4ki
         VJ8ywcaXtcgEX6EtfOnXybUGq9b8gm6QX80Csp5tVJ44IMkVmuRnf/RmX3SSnkuwoIWg
         3/n0CQlSnMIczSt2gazp5oj7OFCczmCw8MrIIjinVcmIqCNRShzVKwmdEZ8SBhF1Wrmh
         6z3w==
X-Gm-Message-State: AC+VfDziyAt3QlqvVOGntgpfcktJl0DIVUajETtL3Wu+c8ItDYePAUp7
	wn5jljsdvXO8NQl3XNo+NsOiG4U8ZpC6jnVDNLY=
X-Google-Smtp-Source: ACHHUZ5Eh44eDjG3RkZNH5AkQmsbiHi9keicnz4mxbPsfBxR7ahInzXb0pw3Ji16qhGi48b7TAM7Zg==
X-Received: by 2002:aa7:c1c4:0:b0:514:a452:3f5 with SMTP id d4-20020aa7c1c4000000b00514a45203f5mr3944373edp.32.1686141595779;
        Wed, 07 Jun 2023 05:39:55 -0700 (PDT)
Received: from localhost (tor-exit-48.for-privacy.net. [185.220.101.48])
        by smtp.gmail.com with ESMTPSA id w8-20020aa7dcc8000000b00514a6d05de9sm6126356edu.88.2023.06.07.05.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 05:39:55 -0700 (PDT)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Maxim Mikityanskiy <maxim@isovalent.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mykola Lysenko <mykolal@fb.com>,
	Shuah Khan <shuah@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>
Subject: [PATCH bpf v4 0/2] Fix verifier id tracking of scalars on spill
Date: Wed,  7 Jun 2023 15:39:49 +0300
Message-Id: <20230607123951.558971-1-maxtram95@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,
	RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Maxim Mikityanskiy <maxim@isovalent.com>

See the details in the commit message (TL/DR: under CAP_BPF, the
verifier can incorrectly conclude that a scalar is zero while in
fact it can be crafted to a predefined number.)

v1 and v2 were sent off-list.

v2 changes:

Added more tests, migrated them to inline asm, started using
bpf_get_prandom_u32, switched to a more bulletproof dead branch check
and modified the failing spill test scenarios so that an unauthorized
access attempt is performed in both branches.

v3 changes:

Dropped an improvement not necessary for the fix, changed the Fixes tag.

v4 changes:

Dropped supposedly redundant tests, kept the ones that result in
different verifier verdicts. Dropped the variable that is not yet
useful in this patch. Rephrased the commit message with Daniel's
suggestions.

Maxim Mikityanskiy (2):
  bpf: Fix verifier id tracking of scalars on spill
  selftests/bpf: Add test cases to assert proper ID tracking on spill

 kernel/bpf/verifier.c                         |  3 +
 .../selftests/bpf/progs/verifier_spill_fill.c | 79 +++++++++++++++++++
 2 files changed, 82 insertions(+)

-- 
2.40.1


