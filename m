Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521CF3B540E
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 17:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhF0Pi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 11:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhF0Pi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 11:38:56 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B8BC061574;
        Sun, 27 Jun 2021 08:36:31 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id v13so7438844ple.9;
        Sun, 27 Jun 2021 08:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L9vx7ZeAYb0qC/JQDEJmS9u06mQwchRQpGl0dOYAjeA=;
        b=g9B+A86Nftnm3ZY9UvA/yBWiqlKFtga69gAE0UmiiWfeZJ/ed6VHcSaBOdrW+KF27i
         oN+4h336cM4mwDDjhY0wUkr1t9mAEEODxkzVaFH/gku2BE5W07CY8pvKIxqRErCormAB
         DIAop3isHl+A6BC5XQdfLlKPQn6ee5hHhcf6rSOm3xuS8biobIPL8M2Islh7zprAZhsP
         pcqodJc/+yMbasODXv/jx2JrK84wNcKEHY19P5Jlno/kYCvjLbvBi1WOh9NaFDw4Pyh+
         CWVG89CUiihlkXVhwfVpxDdSHXx07raViTE2YU93kj9F3ZDx/hK5WGG8wgpnc5NnWch4
         Blrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=L9vx7ZeAYb0qC/JQDEJmS9u06mQwchRQpGl0dOYAjeA=;
        b=MJyi6sFy51dAswWReSKHHGBaNF5Ff8gHETw+fpibGmsBwP9d5U1uyurIgfJdYgWIfx
         ngjglXpHe2L/3BQ99STeZWwCZGM/qYwFm7skDIWzj4mJCwQUHGNxdM9HuRp3zMx90ORs
         5jp8UoBYcbyteJxBWuHQW92YD0rSsUxu4MaGiUNNQMFb/3+cRTGWsIqdFoylWMbS7zfS
         gGXdRvN7yj7+pxqHo5onM2TR0fJobl9cyftx4TPdd28CoVCFILBpWrp//6gF3ofZziR8
         z54zPjaZS+4Qx5E0KZHdGvK6qWp4a5UKbiDKSpdUESTYH5yAGWoWav8PiaLM76M6wbbX
         U/4g==
X-Gm-Message-State: AOAM5329Ua5nNn76hBpVEElgEh+3FtKHBGBU98Q/5LeoPszzW/cQMQZ5
        aSTt20rRQbVTlPRho+JoKy8=
X-Google-Smtp-Source: ABdhPJyCo1HlAWtR8urbZkDHgPOP+9X/YN8qWPeRVAIIj6OSP3uiqk13JUY0c3c4YwIMorjX/+T6Ow==
X-Received: by 2002:a17:903:2082:b029:127:9b96:a6f5 with SMTP id d2-20020a1709032082b02901279b96a6f5mr16724972plc.55.1624808191497;
        Sun, 27 Jun 2021 08:36:31 -0700 (PDT)
Received: from balhae.hsd1.ca.comcast.net ([2601:647:4801:c8d0:d3c0:a839:951e:acc3])
        by smtp.gmail.com with ESMTPSA id v1sm11515170pjg.19.2021.06.27.08.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 08:36:30 -0700 (PDT)
Sender: Namhyung Kim <namhyung@gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ian Rogers <irogers@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] bpf: Allow bpf_get_current_ancestor_cgroup_id for tracing
Date:   Sun, 27 Jun 2021 08:36:27 -0700
Message-Id: <20210627153627.824198-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow the helper to be called from tracing programs.  This is needed
to handle cgroup hiererachies in the program.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/bpf_trace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 7a52bc172841..64bd2d84367f 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1017,6 +1017,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 #ifdef CONFIG_CGROUPS
 	case BPF_FUNC_get_current_cgroup_id:
 		return &bpf_get_current_cgroup_id_proto;
+	case BPF_FUNC_get_current_ancestor_cgroup_id:
+		return &bpf_get_current_ancestor_cgroup_id_proto;
 #endif
 	case BPF_FUNC_send_signal:
 		return &bpf_send_signal_proto;
-- 
2.32.0.93.g670b81a890-goog

