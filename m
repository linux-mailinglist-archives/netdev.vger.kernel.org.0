Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D145F142BA3
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 14:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgATNHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 08:07:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45318 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729050AbgATNG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 08:06:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579525615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KsPh+K2sGLcZZLAcEa0kQAsvwcVmMWDpkU86Oyeqz+o=;
        b=CGafp+6AcscDmOKb7TOukKRU/pAENkXcEorcv9QzCspgqK4AAMjZl6jxrW/DK3PVUDjdQb
        wtGph+d4ueshXXNVTrmpKWvYG9S4cFIlTT99kYG7SL2EncsMFyWPwvh++jnG9/pjJZLVzl
        pg7QomFc2x9Y+OOsgKJ7090M927wFc0=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-LWbUKT88PL-15aPWGnmRPA-1; Mon, 20 Jan 2020 08:06:54 -0500
X-MC-Unique: LWbUKT88PL-15aPWGnmRPA-1
Received: by mail-lj1-f197.google.com with SMTP id y24so7534602ljc.19
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 05:06:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=KsPh+K2sGLcZZLAcEa0kQAsvwcVmMWDpkU86Oyeqz+o=;
        b=Nvz5MPE52dCNS9bSqs37UBCnHDzNQSFuF9kYf/5h3X5JG8rrjUo89Dl5LaMa8b7czG
         HK7kZ5T3ftFERGPyiw0pGtz+Qlguo1KWb+wRvoduW4PxVIqK9k1u/EdrUa7pAZI09mea
         iFXCkIclszTFGx73TVJOeyeY5yOMEju6K716DP+CBQO8fyu+9YegcF/hTaKdSNRk+rqU
         XvkuKpo5Sgl2C3pPZd+WTE8LwYYBEBdBX3xczhZzpUt/zS2h9jvxWEa9Db2jvYY2jODW
         8Dr/pIzT+mn8CqMrvxV83FrZSagXHj9KimkCfg6m8io8g1mopT+dhOf5eAmkAbVz6SYL
         5cVw==
X-Gm-Message-State: APjAAAXvjA8CkgzuJnLFoXV/P6R1c6EexcMYpX2Iv5VbTaxdMdR17qre
        3PpgAjd0muyi5939ZL0eNxK9dECEfepONFx3WL7GJ8vKcLuO24eF10mPGGmD0y4r0WuwswaJLlI
        Z815couIi5W5A9ALY
X-Received: by 2002:a2e:7a13:: with SMTP id v19mr13537752ljc.43.1579525612612;
        Mon, 20 Jan 2020 05:06:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqxq7D+NOw8boRnGBWgzLuvcBMZuEgfqik8rj3u7ynVqVlOwh9aSescMWf6m9o80N+P1u7Do7g==
X-Received: by 2002:a2e:7a13:: with SMTP id v19mr13537712ljc.43.1579525612235;
        Mon, 20 Jan 2020 05:06:52 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id u9sm16734044lji.49.2020.01.20.05.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 05:06:51 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 567801804D8; Mon, 20 Jan 2020 14:06:50 +0100 (CET)
Subject: [PATCH bpf-next v5 09/11] tools/runqslower: Remove tools/lib/bpf from
 include path
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Mon, 20 Jan 2020 14:06:50 +0100
Message-ID: <157952561027.1683545.1976265477926794138.stgit@toke.dk>
In-Reply-To: <157952560001.1683545.16757917515390545122.stgit@toke.dk>
References: <157952560001.1683545.16757917515390545122.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

Since we are now consistently using the bpf/ prefix on #include directives,
we don't need to include tools/lib/bpf in the include path. Remove it to
make sure we don't inadvertently introduce new includes without the prefix.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/bpf/runqslower/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
index b7b2230f807b..b90044caf270 100644
--- a/tools/bpf/runqslower/Makefile
+++ b/tools/bpf/runqslower/Makefile
@@ -6,7 +6,7 @@ LLVM_STRIP := llvm-strip
 DEFAULT_BPFTOOL := $(OUTPUT)/sbin/bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
 LIBBPF_SRC := $(abspath ../../lib/bpf)
-INCLUDES := -I$(OUTPUT) -I$(abspath ../../lib) -I$(abspath ../../lib/bpf)
+INCLUDES := -I$(OUTPUT) -I$(abspath ../../lib)
 CFLAGS := -g -Wall
 
 # Try to detect best kernel BTF source

