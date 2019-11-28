Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55AFF10CDE6
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 18:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfK1RbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 12:31:00 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38714 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbfK1RbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 12:31:00 -0500
Received: by mail-wm1-f66.google.com with SMTP id z19so12527121wmk.3
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 09:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zPi4qAcwwOIG6Iw2Xgr8xLE5ahSrH5V3+nLKSimpK0s=;
        b=vcGIM9q2njynpuucsM7GXEsxupGt8lTyqDWbhuPtYTYxxAlkFUgM5UH0FuZAYYalQS
         BriKIHTs9lsH9PP7+Kf16DcJ6DknUQY+gU+a6m3e4e1glG5XXQXq9Twwp7RSoxIFbgf/
         KX3/Q1y3uPLHFDIm7aio4nqzwGxBsPjZMYicehLWsrusZWc9Zzl1JVpXP1msqjN1+8/Z
         02iGWK5u8i9kO7fuYGZN2q9a4kPpV16zdtvnsvokc89PcTtbebkFCaHRW0JQkwmNidL5
         6tlJOJ3cGu9C70pVFQe5RBumUrR8QonslQXVj2BOVyn/FcRpRmVjGnQC8k7zroWP7g6k
         UWIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=zPi4qAcwwOIG6Iw2Xgr8xLE5ahSrH5V3+nLKSimpK0s=;
        b=Zpa8+eg0yFERuB2KLIJ25krmCrF3YBKcd8gGDbeIaMbwC9d5fsj4IVD+YUest7L3+S
         OUQH1+oieqG9bf8JZr+E0BVgTOx62kgmpMV8GQGk9J84F3PpkBo7TLtUY0PVbLWEVWdQ
         UyHOp0TKW7NKSn+APFeqKGQGfVRQEXIJVynnMzrEaDWxUaX3meBgg4EiXQgC8LybeGg/
         9M5FardCKZ2BG4Od6fir4QGBmwxXwjyeIJwOO879STgE3LdWAOvQHR/dABYdUNR97QqO
         lA9lQeKaDospo07UcN3tI1aNFyQZYo9hTXa+azJaF9nZUYeGTmoPzcIS7zWplRjKqkaa
         TK5A==
X-Gm-Message-State: APjAAAX44i0ArSePseX8rXKaZp/j8cauDqCUnW1a3E4IynvWKNnTKPTo
        82wvD96egQmauoPB3X6QQ6k4Sw==
X-Google-Smtp-Source: APXvYqzycodok2qlyxSE0ct+E5zIBDEdQiOvS2TjlzBpodKnq6apT30ydygyW9WIYxxCokM2Z8SXWA==
X-Received: by 2002:a05:600c:2049:: with SMTP id p9mr10658003wmg.128.1574962255744;
        Thu, 28 Nov 2019 09:30:55 -0800 (PST)
Received: from [192.168.1.9] ([194.53.187.153])
        by smtp.gmail.com with ESMTPSA id t8sm1336569wrp.69.2019.11.28.09.30.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Nov 2019 09:30:54 -0800 (PST)
Subject: Re: [PATCH bpf v3] bpftool: Allow to link libbpf dynamically
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
References: <20191128160712.1048793-1-toke@redhat.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Message-ID: <04154e60-a5d6-5ce5-2fbe-89437108fdc6@netronome.com>
Date:   Thu, 28 Nov 2019 17:30:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191128160712.1048793-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-11-28 17:07 UTC+0100 ~ Toke Høiland-Jørgensen <toke@redhat.com>
> From: Jiri Olsa <jolsa@kernel.org>
> 
> Currently we support only static linking with kernel's libbpf
> (tools/lib/bpf). This patch adds LIBBPF_DYNAMIC compile variable
> that triggers libbpf detection and bpf dynamic linking:
> 
>   $ make -C tools/bpf/bpftool make LIBBPF_DYNAMIC=1
> 
> If libbpf is not installed, build (with LIBBPF_DYNAMIC=1) stops with:
> 
>   $ make -C tools/bpf/bpftool LIBBPF_DYNAMIC=1
>     Auto-detecting system features:
>     ...                        libbfd: [ on  ]
>     ...        disassembler-four-args: [ on  ]
>     ...                          zlib: [ on  ]
>     ...                        libbpf: [ OFF ]
> 
>   Makefile:102: *** Error: No libbpf devel library found, please install libbpf-devel or libbpf-dev.
> 
> Adding LIBBPF_DIR compile variable to allow linking with
> libbpf installed into specific directory:
> 
>   $ make -C tools/lib/bpf/ prefix=/tmp/libbpf/ install_lib install_headers
>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1 LIBBPF_DIR=/tmp/libbpf/
> 
> It might be needed to clean build tree first because features
> framework does not detect the change properly:
> 
>   $ make -C tools/build/feature clean
>   $ make -C tools/bpf/bpftool/ clean
> 
> Since bpftool uses bits of libbpf that are not exported as public API in
> the .so version, we also pass in libbpf.a to the linker, which allows it to
> pick up the private functions from the static library without having to
> expose them as ABI.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
> v3:
>   - Keep $(LIBBPF) in $LIBS, and just add -lbpf on top
>   - Fix typo in error message
> v2:
>   - Pass .a file to linker when dynamically linking, so bpftool can use
>     private functions from libbpf without exposing them as API.

Thanks for the changes!

Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
