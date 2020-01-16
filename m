Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87CE913DB81
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgAPNWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:22:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46191 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729039AbgAPNWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 08:22:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579180952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AWpuQHcBbygSpBN7ABbdtVDoB9ax/6rmGowy3CAmlec=;
        b=huQNSAuCK+zIdyOJvE4o6iRiSayc1gRatXP/aajKrH0lIg0ke1lNkEsBoLXuAMJv08J0b8
        sQhExHfluxsQkRCabVT6ZaXoPNTeaeUG6NKsu61Hj8UvlEHkhDl5kjP6hGcyV/Uax25z3J
        vDLtFR90qW15iq9g41HXVg5ek/9jGK4=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-92Exn7RjPRyUbdS_wRYTbA-1; Thu, 16 Jan 2020 08:22:27 -0500
X-MC-Unique: 92Exn7RjPRyUbdS_wRYTbA-1
Received: by mail-lj1-f197.google.com with SMTP id z2so5129981ljh.16
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 05:22:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AWpuQHcBbygSpBN7ABbdtVDoB9ax/6rmGowy3CAmlec=;
        b=FXB6GWhxUDZ5XHdG3cv/f1Ln6ERXe0BL0wupzhawUoJ6veUqbKHNS0TUDXA563B+Ac
         upEgPzWLZ0SBdbdepdlNDmTCmhO1nKuEkvuMWfyNEq0Q15pvt0RZuLr8t7qklBzbPl0y
         BsFjLcgkU2Fe74f4BhzfJq1JwJOrJXEDPi/aHgE5PMTXDHEa+Y9X5D/+7B8dGTN3LSaI
         xPIckwGkPuypH7Rj2IPy/PubLks595i/1BOkbbC+DobXSOPQ5ZmN0jb+2f7l/xUCJbW9
         xcN7V5iUgppWALuDQiPvG39r08eFEheCxTTTyR9D/uBswfR121SECVrD+OaU+JaUUahh
         lvAQ==
X-Gm-Message-State: APjAAAUktKwF36syVuzVnT8sWkEZuvpP9LEo5d7ZC97NzMPjCO0+s3V7
        uYGYuGA3Zq4pGZmELB9dqjlIDaukVucCj5v3rCSPmu2fJAlZtQNzdWvxQEsju85AyKYj8LCI6Bz
        06DPJcBQoxehMW/KC
X-Received: by 2002:a19:22cc:: with SMTP id i195mr2462148lfi.148.1579180946446;
        Thu, 16 Jan 2020 05:22:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqyjxl2n++cCTXnIW0e4orep7eH+lXINSmpl5V70FmQByQF+7BUBdLnD1uznN+1Kd1WC9tpf5w==
X-Received: by 2002:a19:22cc:: with SMTP id i195mr2462134lfi.148.1579180946289;
        Thu, 16 Jan 2020 05:22:26 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id y11sm12233392lfc.27.2020.01.16.05.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 05:22:25 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0044A1804D9; Thu, 16 Jan 2020 14:22:22 +0100 (CET)
Subject: [PATCH bpf-next v3 10/11] tools/runqslower: Remove tools/lib/bpf from
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
Date:   Thu, 16 Jan 2020 14:22:22 +0100
Message-ID: <157918094293.1357254.438435835284838644.stgit@toke.dk>
In-Reply-To: <157918093154.1357254.7616059374996162336.stgit@toke.dk>
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk>
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

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/bpf/runqslower/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
index c0512b830805..d474608159f5 100644
--- a/tools/bpf/runqslower/Makefile
+++ b/tools/bpf/runqslower/Makefile
@@ -5,7 +5,7 @@ LLC := llc
 LLVM_STRIP := llvm-strip
 DEFAULT_BPFTOOL := $(OUTPUT)/sbin/bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
-LIBBPF_INCLUDE := -I$(abspath ../../lib) -I$(abspath ../../lib/bpf)
+LIBBPF_INCLUDE := -I$(abspath ../../lib)
 LIBBPF_SRC := $(abspath ../../lib/bpf)
 CFLAGS := -g -Wall
 

