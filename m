Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92FF5185B32
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 09:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgCOIdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 04:33:05 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36312 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbgCOIdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 04:33:05 -0400
Received: by mail-pg1-f193.google.com with SMTP id z4so1984867pgu.3;
        Sun, 15 Mar 2020 01:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Mc91MOfwvy0Krn8xqZ+9eQ5qoxXVwyTfd8xLMYOaUhA=;
        b=gUjQj0QaIXIolLufw1MTw01hCZkugAmnahw2dGNurUXkraFV5bat8RP+TeYi1QIzZL
         mSvJJ8/LRjA8PSZ8duqmQL/aDIDF34HdZgrquYdObEr1R4WgPZu4WSadOSTqAKJcxsE8
         ErgjJuvy96CEOlsNqNqZqW2thet038HemrXGGZfHDykopdtjJRBVd9IC+fBhO+bHTpRG
         kx5BkKJCt4YB7DSfAohiADTPfBKk2Kkx8CogvwULf6fK+zSq0N3rK1UuvtBHzwq8Kird
         7vpiovZpK2myt8Bj0G1VjIa6gXu/ZwjSL8ietEMafWBZTdrPBQH6kR8lvyY7fuD9TDYD
         TFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Mc91MOfwvy0Krn8xqZ+9eQ5qoxXVwyTfd8xLMYOaUhA=;
        b=fTcfTyzczXCeeRAmUdDIx0HseT3zgxlhhA5qP0NVYSxdRJ7QXLAYgiMPwbfVx1JBC+
         7CqK5PUnXwmBIQbL3/jmZyz5bYhd8q10hDeAXAAAxctEeGq5NaHrLFONqR7DEo31lJMd
         1veU+wYwZkcMpXNrZlJxdwXGHDlPzQl9+ck4ndZuLcLzO5vHlAjPvwtoPRjP+5lXp8wg
         uG2FhkYMk8IkQtz56moXGL+9ww6URgKro77UKngmK4Jx9oEnfOB+jEV1DiZIN6u4CuIX
         wuw4ZuMpJC5pFHkFvLWSF9XwUvo/fWIGqHHJKGzyEyJhfue+5baqUedPlJw446hmSNGG
         SbAQ==
X-Gm-Message-State: ANhLgQ1QxZhbIMLwI20LTLCfjX1KiuPlQEYLe66bWwOsMkX4EjhmEkN1
        lTZ5HPPbqZde5TUn9YdpSAAGwmBbCnTcyQ==
X-Google-Smtp-Source: ADFU+vtCxwSyuEhkrTP4rZfIOCpK8kOyO8QPh77dTyImimqs3E4RAkEVtdIznCjghWxOgUwXb+vm+g==
X-Received: by 2002:a63:6c8a:: with SMTP id h132mr19335055pgc.301.1584261181934;
        Sun, 15 Mar 2020 01:33:01 -0700 (PDT)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id c207sm23181609pfb.47.2020.03.15.01.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2020 01:33:01 -0700 (PDT)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, ethercflow@gmail.com
Subject: [PATCH] bpf: Fix ___bpf_kretprobe_args1(x) macro definition.
Date:   Sun, 15 Mar 2020 04:32:52 -0400
Message-Id: <20200315083252.22274-1-ethercflow@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use PT_REGS_RC instead of PT_REGS_RET to get ret currectly.

Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
---
 tools/lib/bpf/bpf_tracing.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index b0c9ae5c73b5..f3f3c3fb98cb 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -390,7 +390,7 @@ ____##name(struct pt_regs *ctx, ##args)
 
 #define ___bpf_kretprobe_args0() ctx
 #define ___bpf_kretprobe_args1(x) \
-	___bpf_kretprobe_args0(), (void *)PT_REGS_RET(ctx)
+	___bpf_kretprobe_args0(), (void *)PT_REGS_RC(ctx)
 #define ___bpf_kretprobe_args(args...) \
 	___bpf_apply(___bpf_kretprobe_args, ___bpf_narg(args))(args)
 
-- 
2.17.1

