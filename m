Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F33410B088
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 14:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfK0Np6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 08:45:58 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45315 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfK0Np5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 08:45:57 -0500
Received: by mail-qt1-f195.google.com with SMTP id 30so25342660qtz.12;
        Wed, 27 Nov 2019 05:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tim0z48P/Ho4XX4rxvSqCrBEA1TS21VHvg9AxGU9cUo=;
        b=loxi/+dyFPwW34NQEBvyXRBAXz7R51jVt1JzJNfdmksHqZYiuGv678bpygS7AyTcyG
         px+L3G+F1bImhNWDkGnnts4PZBFKzn29ElHqENqeJv1jppPnXdKDAmjzBQQ6sVRfg1xr
         6Xfzx7m2O343J2pCvuzBOP4K5kf/9uPJ/oE+wqljaY9Ng7Bu1p1RFWJoM6v+MbwS9sYM
         pDH3hHrynI7szJWf2fIkuEKXn/ODjn9YzmNKfc21I/3WWe20Xm003fsEk4AA3xVIUytY
         NlVAaF6dWfgsLRkRWEenDkwjZ5yvHsIBi1f1CHuL9tm84B/RkoY0FpUXgT3EMDwHhcNy
         FCag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tim0z48P/Ho4XX4rxvSqCrBEA1TS21VHvg9AxGU9cUo=;
        b=MSZpqcY3Tp2Tve+W7eLd4vYi7zS/9UeHKMr194FkFg5cJZOhQ9DNNYOaNpbvXHIIbG
         QTS7WE2BDsLECgGoqIyMeGJlP05pqy3q5B+VluCnvwllTqnkYYWzIkresS6/UU8Veaum
         8NOq5lBpadNh6x+lMtM+pWhD/IMU6ddOid9Jop3kat0LCEURxRRS7MtkEDy/t7eIgPuR
         63Hejp/i4SQQZX0hYIUa0s0idsaH8zzdwvIUzX3P2dDcb4OEh/uDdgOHfRp5/WuvoUtZ
         SfiyzboguzWwBb0b+f7kwzykeSIWLebw+ls/HMC06uOt9Cjd5E7QCOtO3nzC/CsWXPkq
         aBrQ==
X-Gm-Message-State: APjAAAVbXRP5XZU+JuB/wnRTdLOQVD+Uj9ck95HF08lI4XpuHJ9dbpSq
        w6NbjTAc+tXU9GsyHuiMBASoiHZjIE4=
X-Google-Smtp-Source: APXvYqwAPqmAF3/Vr+h2lq/WTBPNZOERbfyeIOC6lgge2oHvISvxGhaZJm/IbCgWQsceKUt1cm3bEA==
X-Received: by 2002:ac8:198b:: with SMTP id u11mr26214987qtj.133.1574862356632;
        Wed, 27 Nov 2019 05:45:56 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id y200sm6435632qkb.1.2019.11.27.05.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 05:45:56 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id A79E740D3E; Wed, 27 Nov 2019 10:45:53 -0300 (-03)
Date:   Wed, 27 Nov 2019 10:45:53 -0300
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH] libbpf: Use PRIu64 for sym->st_value to fix build on 32-bit
 arches
Message-ID: <20191127134553.GC22719@kernel.org>
References: <20191126183451.GC29071@kernel.org>
 <87d0dexyij.fsf@toke.dk>
 <20191126190450.GD29071@kernel.org>
 <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com>
 <20191126221018.GA22719@kernel.org>
 <20191126221733.GB22719@kernel.org>
 <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com>
 <20191126231030.GE3145429@mini-arch.hsd1.ca.comcast.net>
 <20191126155228.0e6ed54c@cakuba.netronome.com>
 <20191127013901.GE29071@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127013901.GE29071@kernel.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another fix I'm carrying in my perf/core branch,

Regards,

- Arnaldo

commit 98bb09f90a0ae33125fabc8f41529345382f1498
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Wed Nov 27 09:26:54 2019 -0300

    libbpf: Use PRIu64 for sym->st_value to fix build on 32-bit arches
    
    The st_value field is a 64-bit value, so use PRIu64 to fix this error on
    32-bit arches:
    
      In file included from libbpf.c:52:
      libbpf.c: In function 'bpf_program__record_reloc':
      libbpf_internal.h:59:22: error: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'Elf64_Addr' {aka 'const long long unsigned int'} [-Werror=format=]
        libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
                            ^~~~~~~~~~
      libbpf_internal.h:62:27: note: in expansion of macro '__pr'
       #define pr_warn(fmt, ...) __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
                                 ^~~~
      libbpf.c:1822:4: note: in expansion of macro 'pr_warn'
          pr_warn("bad call relo offset: %lu\n", sym->st_value);
          ^~~~~~~
      libbpf.c:1822:37: note: format string is defined here
          pr_warn("bad call relo offset: %lu\n", sym->st_value);
                                         ~~^
                                         %llu
    
    Fixes: 1f8e2bcb2cd5 ("libbpf: Refactor relocation handling")
    Cc: Alexei Starovoitov <ast@kernel.org>
    Cc: Andrii Nakryiko <andriin@fb.com>
    Link: https://lkml.kernel.org/n/tip-iabs1wq19c357bkk84p7blif@git.kernel.org
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b20f82e58989..6b0eae5c8a94 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1819,7 +1819,7 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 			return -LIBBPF_ERRNO__RELOC;
 		}
 		if (sym->st_value % 8) {
-			pr_warn("bad call relo offset: %lu\n", sym->st_value);
+			pr_warn("bad call relo offset: %" PRIu64 "\n", sym->st_value);
 			return -LIBBPF_ERRNO__RELOC;
 		}
 		reloc_desc->type = RELO_CALL;
