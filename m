Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793823E19C0
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 18:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhHEQmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 12:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhHEQmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 12:42:14 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB65C061765;
        Thu,  5 Aug 2021 09:41:58 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id i10-20020a05600c354ab029025a0f317abfso6807097wmq.3;
        Thu, 05 Aug 2021 09:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FPukj0sc+USjJnTorQ63Q8/krzolyQ2sY5zYNJxrZDo=;
        b=WmBlcTbAHtBl+yyJN/NxbZVW2zlQ9P34ZkiJhQfLIovDVDrNm0RD+WDN9hi/8qqAN5
         YPtCqYSFNjML8MCIZmmTetC/ISG8lRWojsdOc4oT23bgZQD6Lv6auIovuo8/sUj/TdqG
         ntqt8btgZQhoyaLM9/s4jwS13pU1A9U81O4R34TwXDDKQ33SdbPmzo+1ScIFXZ8bnLEU
         Nk9jGkMm9Y2xgmwtPuaG5S6uZ9Kd8TZ1IverZrYXnw4hsPNPokGdIrrfGEWelayQ3sSc
         32eEq7Q25njbCi6dotbPkSI/gqAyG2qV2HmCA83K8DGN3YVkrivRREpJf2LBRO4PgC/x
         UOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FPukj0sc+USjJnTorQ63Q8/krzolyQ2sY5zYNJxrZDo=;
        b=ADfGvyDWB42hhqFPikceWI+nknmpdne2bIAdZPdMuzAnYIYhEKeRP3gtA1tsiadmpG
         to98q5Kq9LWL3vuJLhSNs5dWYyP+KBab02qUQi4cFf+m4koUaKoOZ0nPe1Xc2yzC/F6x
         puoG8ni981yV6u5xoGpAK25E08Eg1+1LFEYht6OhmY1pwQmQZSYUmqXR7gjRuk5E5Z3G
         IHPYoMfLE9oIh7xBEsk3D1O1Qi6m5xrcRyB3RIQFLOjBP68Jj8itHBzAwcXem5Ii8qnt
         x8KwPkMCNtGtN4P+GAsokOq/tT48kaXLq1yuLDy618Z5goQaZr/nQrJJMediTmyxQvJY
         Nk3w==
X-Gm-Message-State: AOAM5328Oa+ppcXVqLxQPbE8Wck0H+ZTHRXGpkCs35nqSRdm1oz0+v1D
        iuQXRja/QZtG2G8b8B1EuIs=
X-Google-Smtp-Source: ABdhPJxjeciPuz3Y6G6V0UiOjBsGcL7vPRp1WDtha3ArtQVyYe7wjx7XSIEkPmhp1Oc+yA1lmv6PnQ==
X-Received: by 2002:a7b:c939:: with SMTP id h25mr15605379wml.13.1628181716774;
        Thu, 05 Aug 2021 09:41:56 -0700 (PDT)
Received: from localhost.localdomain ([5.170.128.83])
        by smtp.gmail.com with ESMTPSA id o17sm6755884wru.11.2021.08.05.09.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 09:41:56 -0700 (PDT)
From:   Jose Blanquicet <blanquicet@gmail.com>
X-Google-Original-From: Jose Blanquicet <josebl@microsoft.com>
Cc:     blanquicet@gmail.com, Jose Blanquicet <josebl@microsoft.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Florent Revest <revest@chromium.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/bpf: Fix bpf-iter-tcp4 test to print correctly the dest IP
Date:   Thu,  5 Aug 2021 18:40:36 +0200
Message-Id: <20210805164044.527903-1-josebl@microsoft.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, this test is incorrectly printing the destination port
in place of the destination IP.

Signed-off-by: Jose Blanquicet <josebl@microsoft.com>
---
 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c b/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
index 2e4775c35414..92267abb462f 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
@@ -121,7 +121,7 @@ static int dump_tcp_sock(struct seq_file *seq, struct tcp_sock *tp,
 	}
 
 	BPF_SEQ_PRINTF(seq, "%4d: %08X:%04X %08X:%04X ",
-		       seq_num, src, srcp, destp, destp);
+		       seq_num, src, srcp, dest, destp);
 	BPF_SEQ_PRINTF(seq, "%02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d ",
 		       state,
 		       tp->write_seq - tp->snd_una, rx_queue,
-- 
2.25.1

