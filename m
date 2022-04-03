Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21394F0A08
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349420AbiDCNyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234624AbiDCNyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:54:54 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCE731DCA;
        Sun,  3 Apr 2022 06:52:59 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id k14so6271479pga.0;
        Sun, 03 Apr 2022 06:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lb9cPlyZwbStjJwtyos1H7UNpKKI/uQ50C7n0HV1cmg=;
        b=ol6dX4/RtXYE+ytChjwpGHAuwCbbdB+IDdiEcpvJWXpiVphTPkjv1IExQ1ToaZBRPu
         OirK0Fh3acKTV0wMXIyYsW0gAGxwd93cHemJXGVi343rUkb3CofTeBtD/IbwmvqRgcp6
         mm8cjNF6iwZ5xNK0MChgKrW5uZaYk+CFZiDnY6euVi4lsAYZPrDaopFbn8/K7v2Jwcun
         joCAlYFgRC/pgwILgk78kJAO57R8XW1CroNlNEDl+TvzTcfppFATaSdB75brzaPQARAI
         /estsAqNQZhFh7XxreulgNXdAD661VIYq7Wr8bkTpPmmLyhb+Ukr9CCo3EFhqIgeKbgG
         X8qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lb9cPlyZwbStjJwtyos1H7UNpKKI/uQ50C7n0HV1cmg=;
        b=Du9vzMVJsficRpVysV1Tvciyj0eACq/lTSjP6sHrDb0adw3sKp7VbPYWlR3BktTEvu
         /zKvMspVxim7msV95cPl9HXlrmerCxHYB9nil6eTw/1QI2k81hIwbzVTsLnbhJofTUW/
         /+72CzX1LJShvvcxzN/YhVXixfgn/h3dbEC8gDBNg1TLPYTlDc4zuALa6HWkM9wFlWaf
         i8EmeNX4pedcJAHONknYg0o2jhue4NTHotiBtmExQXbMrpPozB54a5CAoB5B+OI3eQks
         aVKP4WuCTuCFCIG7ljkIQR5D/9HmbIF0aGuH17SGEOMYw6qLNdrhFfUh46TNHx1SXXgf
         txwA==
X-Gm-Message-State: AOAM5327vKHVoStncxX0hbGsA01vcytnS5L5gGs+eSFr7dCFGONmEgOr
        NkQxTSDZnwYuz+JJ0CAi2Yw=
X-Google-Smtp-Source: ABdhPJwiZvhSxAJo5R0Aey3Vtd57SMUkDnTvtPt3vFc3D9SvrciCNUo3WSE9GJBrMxz2huPRfTrHUA==
X-Received: by 2002:a63:2b05:0:b0:398:677b:f460 with SMTP id r5-20020a632b05000000b00398677bf460mr22523433pgr.592.1648993978755;
        Sun, 03 Apr 2022 06:52:58 -0700 (PDT)
Received: from localhost.localdomain ([223.74.191.143])
        by smtp.gmail.com with ESMTPSA id k20-20020aa788d4000000b004fb07f819c1sm8933299pff.50.2022.04.03.06.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:52:58 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] selftests/bpf: Fix cd_flavor_subdir() of test_progs
Date:   Sun,  3 Apr 2022 21:52:45 +0800
Message-Id: <20220403135245.1713283-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when we run test_progs with just executable file name, for
example 'PATH=. test_progs-no_alu32', cd_flavor_subdir() will not check
if test_progs is running as a flavored test runner and switch into
corresponding sub-directory.

This will cause test_progs-no_alu32 executed by the
'PATH=. test_progs-no_alu32' command to run in the wrong directory and
load the wrong BPF objects.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 tools/testing/selftests/bpf/test_progs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 2ecb73a65206..0a4b45d7b515 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -761,8 +761,10 @@ int cd_flavor_subdir(const char *exec_name)
 	const char *flavor = strrchr(exec_name, '/');
 
 	if (!flavor)
-		return 0;
-	flavor++;
+		flavor = exec_name;
+	else
+		flavor++;
+
 	flavor = strrchr(flavor, '-');
 	if (!flavor)
 		return 0;
-- 
2.35.1

