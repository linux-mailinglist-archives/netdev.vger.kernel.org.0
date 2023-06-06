Return-Path: <netdev+bounces-8630-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45E7E724EEF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 23:43:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA4AB280FAA
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 21:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC442D268;
	Tue,  6 Jun 2023 21:43:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A5DFBED;
	Tue,  6 Jun 2023 21:43:03 +0000 (UTC)
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71912A7;
	Tue,  6 Jun 2023 14:43:02 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-568ba7abc11so84913787b3.3;
        Tue, 06 Jun 2023 14:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686087781; x=1688679781;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8Qd3leHBZXL65adtqzIuuiBwzKYu8gVLn0CzrJMva+A=;
        b=QmmajwtImCF8XWN2wj3A0JNAhODVkCREP0xCzphKurEwz2hJGAM/RZpHX3lb3oYYmC
         +NF19vzdy5CgaGKm58RuQHCMYBmMSI/eZVxIKMUq5n2mpwR8N8FSGnhKMNS+QVq9oBBR
         I5kHuUVh6EJzbJcDrzvRvH34jFtd/COzisdOmr+ei3qzV6w+/cZpAlvWbhePt0hgH9Mz
         3bJcrDmQdPxTwxoMAhFFxV6u6vr/o2s2zBwT6ns458YOjwSi5VmRMCK9Wq3Tl7v3ZorC
         k0YwLXu19VTBkJia/xNJhLx0hhAsTufrVwrlO7ARpcYpzizYoKgRpCVXBXiFd3pISHBJ
         IeZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686087781; x=1688679781;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Qd3leHBZXL65adtqzIuuiBwzKYu8gVLn0CzrJMva+A=;
        b=GaSZoqWAQ8PFrE8ZfEY/7NSYGNzm83EO8VUJXSmiAjUkwXNuUDVOfGlq+HbrAN0Z27
         TbZb/suVgjJ7/3Hp0O9b6UI12Da/zlzzhZAXbdzFEDdBOLqzyzq1kBWJkMzXSTqjky0g
         g/eOH6AqrIoUFS+BLFvE5ES0vadjUjwYh7bAaTpaycI6MWb3aw1WRZeK3rWb0tO507L9
         NDOpYoTnXVcF+it4HDdlOld2heQsBacAB3+R2/kCGGEJhRXZEnj2VX+XoUsnxD4rwuu7
         zZkslP4fcomxw1+z6QVN3a1pugPtJP1vhn3K0FW4F0B4oPO/ABwMcQqcPcVTfThiU0XZ
         dRjg==
X-Gm-Message-State: AC+VfDw5N6Dr1fkJTqKM6TqdyhRBBfS7EKC0NZUlpLOlqRWOu2/I59vP
	3kmvEQDnY3HfH8vVw3CzWIWLTHNuZxyj1+Vb
X-Google-Smtp-Source: ACHHUZ5XYtu511QohPo4GimxrlO+kI/nU6S3mAI0T9qJrachNz1cJuAHte75+A46PSLK7iobcUDH0w==
X-Received: by 2002:a81:6887:0:b0:565:bb04:53fa with SMTP id d129-20020a816887000000b00565bb0453famr3821272ywc.10.1686087781092;
        Tue, 06 Jun 2023 14:43:01 -0700 (PDT)
Received: from localhost ([87.118.116.103])
        by smtp.gmail.com with ESMTPSA id d22-20020aa78e56000000b0064f3bde4981sm7290194pfr.34.2023.06.06.14.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 14:43:00 -0700 (PDT)
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
Subject: [PATCH bpf v3 0/2] Fix BPF verifier bypass on scalar spill
Date: Wed,  7 Jun 2023 00:42:44 +0300
Message-Id: <20230606214246.403579-1-maxtram95@gmail.com>
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
verifier can be fooled to think that a scalar is zero while in fact it's
your predefined number.)

v1 and v2 were sent off-list.

v2 changes:

Added more tests, migrated them to inline asm, started using
bpf_get_prandom_u32, switched to a more bulletproof dead branch check
and modified the failing spill test scenarios so that an unauthorized
access attempt is performed in both branches.

v3 changes:

Dropped an improvement not necessary for the fix, changed the Fixes tag.

Maxim Mikityanskiy (2):
  bpf: Fix verifier tracking scalars on spill
  selftests/bpf: Add test cases to assert proper ID tracking on spill

 kernel/bpf/verifier.c                         |   7 +
 .../selftests/bpf/progs/verifier_spill_fill.c | 198 ++++++++++++++++++
 2 files changed, 205 insertions(+)

-- 
2.40.1


