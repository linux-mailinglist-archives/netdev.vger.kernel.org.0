Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3424A9BDC
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359653AbiBDPUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:20:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48609 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359644AbiBDPUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:20:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643988021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+q46W6c4toAQsTdMEsRGsiR5ZgOxsHkl9SQEX7EvK04=;
        b=KbMUKtcR8fNqGYtkDg6mi5pGI8W37h7jclj9jiHVG5DoNsRIPq5OnMshOEsYVj+Fr7tRx6
        c/g6z470gI3JmSv1RE3B5U6sBmLgmXdhhwPcqGmHUWk4KCgPdw0d8xSdHke3My78qyRPFO
        NWTuM7pOC3FMJy8b8JIKXcyHnLHYsI0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-7gfq23rePvut0WM_tc2BqA-1; Fri, 04 Feb 2022 10:20:19 -0500
X-MC-Unique: 7gfq23rePvut0WM_tc2BqA-1
Received: by mail-ed1-f69.google.com with SMTP id v15-20020a50a44f000000b004094f4a8f3bso3462675edb.0
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 07:20:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+q46W6c4toAQsTdMEsRGsiR5ZgOxsHkl9SQEX7EvK04=;
        b=E3DVrw4Q8AZewRBDCnMP4NCtuy+U1d/Pg6C9ulnE/hmbrLAFLV95uw7RFRgWmxcckW
         aK3yOBf7YiEPqUX/dlMGjH1oAy3FbWQzCLW6AaU0PIo3mUzjR+8t43T2kQ2s0O2hKY8F
         Z6G9MJ9Fglr3iF9sfmE0W8bzepL+mY1vBZWVInMhKfKKA3EFP8NokngkdCSuprFtIuJk
         yDFKbrKtAhLFeT8J6NA8c0uh5UPzGHTOfh2M6kQ/S07iNM59rSb7eFBu9ZxHh/h9Fbtn
         tH8Gx1LoeJJ/ROhayKC2gJIYLA58o32/EWblvhQhqMNug9RZBbxFSI8hjKtQNTeytPzH
         ipmQ==
X-Gm-Message-State: AOAM533Nr9h7GpJ5huXnUAUyAhE7OYjUBEkbHyAMOWCm5oHDHLIdZqOy
        2hqZkr8tuZV0/GBFJtAevxEQQ951A4E5vZANX/xPLjwsXGGMBHC1kRvEgWbyuASuLW6TRlNEvEs
        XAqwqdK6gfT6Ud4Xg
X-Received: by 2002:a17:906:794b:: with SMTP id l11mr3031438ejo.760.1643988017359;
        Fri, 04 Feb 2022 07:20:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwSYyiKmfl2Gd0G8ZZlWKALFgw+5rgN6Bz7b8FzRYyJNdebkWK3OcH6557glemQNFvsMQVi2w==
X-Received: by 2002:a17:906:794b:: with SMTP id l11mr3031413ejo.760.1643988017093;
        Fri, 04 Feb 2022 07:20:17 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id p12sm748709ejd.180.2022.02.04.07.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 07:20:16 -0800 (PST)
Date:   Fri, 4 Feb 2022 16:20:14 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [RFC] failing selftests/bpf/test_offload.py
Message-ID: <Yf1ELsA5yhhBrJnf@krava>
References: <20220130225101.47514-1-jolsa@kernel.org>
 <87k0egt5b8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k0egt5b8.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 02:15:07PM +0100, Toke Høiland-Jørgensen wrote:
> Jiri Olsa <jolsa@redhat.com> writes:
> 
> > hi,
> > I have failing test_offload.py with following output:
> >
> >   # ./test_offload.py
> >   ...
> >   Test bpftool bound info reporting (own ns)...
> >   FAIL: 3 BPF maps loaded, expected 2
> >     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 1177, in <module>
> >       check_dev_info(False, "")
> >     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 645, in check_dev_info
> >       maps = bpftool_map_list(expected=2, ns=ns)
> >     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 190, in bpftool_map_list
> >       fail(True, "%d BPF maps loaded, expected %d" %
> >     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 86, in fail
> >       tb = "".join(traceback.extract_stack().format())
> >
> > it fails to detect maps from bpftool's feature detection,
> > that did not make it yet through deferred removal
> >
> > with the fix below I have this subtest passed, but it fails
> > further on:
> >
> >   # ./test_offload.py
> >   ...
> >   Test bpftool bound info reporting (own ns)...
> >   Test bpftool bound info reporting (other ns)...
> >   Test bpftool bound info reporting (remote ns)...
> >   Test bpftool bound info reporting (back to own ns)...
> >   Test bpftool bound info reporting (removed dev)...
> >   Test map update (no flags)...
> >   Test map update (exists)...
> >   Test map update (noexist)...
> >   Test map dump...
> >   Test map dump...
> >   Traceback (most recent call last):
> >     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 1251, in <module>
> >       _, entries = bpftool("map dump id %d" % (m["id"]))
> >     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 169, in bpftool
> >       return tool("bpftool", args, {"json":"-p"}, JSON=JSON, ns=ns,
> >     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 155, in tool
> >       ret, stdout = cmd(ns + name + " " + params + args,
> >     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 109, in cmd
> >       return cmd_result(proc, include_stderr=include_stderr, fail=fail)
> >     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 131, in cmd_result
> >       raise Exception("Command failed: %s\n%s" % (proc.args, stderr))
> >   Exception: Command failed: bpftool -p map dump id 4325
> >
> > the test seems to expect maps having BTF loaded, which for some reason
> > did not happen, so the test fails with bpftool pretty dump fail
> >
> > the test loads the object with 'ip link ...', which I never touched,
> > so I wanted ask first before I dive in, perhaps I miss some setup
> >
> > thoughts? ;-)
> 
> It looks like the test_offload.py has been using 'bpftool -p' since its
> inception (in commit: 417ec26477a5 ("selftests/bpf: add offload test
> based on netdevsim") introduced in December 2017), so this sounds like a
> regression in bpftool?
> 
> -Toke
> 

right, looks like this commit:
  e5043894b21f ("bpftool: Use libbpf_get_error() to check error")

forced btf for pretty map dump.. change below fixes the test for me,
I'll send full patchset for this later

thanks,
jirka


---
 tools/bpf/bpftool/map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index c66a3c979b7a..2ccf85042e75 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -862,6 +862,7 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 	prev_key = NULL;
 
 	if (wtr) {
+		errno = 0;
 		btf = get_map_kv_btf(info);
 		err = libbpf_get_error(btf);
 		if (err) {
-- 
2.34.1

