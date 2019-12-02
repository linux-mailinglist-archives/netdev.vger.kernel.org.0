Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA88E10F1F9
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 22:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfLBVPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 16:15:45 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45432 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725865AbfLBVPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 16:15:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575321343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dqtlBsiEAqeGMc0cL3Eo0rcvGHxRZBHUuo8q1j2NE4s=;
        b=ILAzbY0PU2kloVq4uycxYtge/33vndV+/uxMcJYoB28XYuNleM4IlVsLUbMsG0Z0L33Kcf
        Z0iih1v8/HsPXfCZYlfF8JnONHWmPZ2yK87gynw/xrgkmQDweU5tqZshc6WsYSgkBM9SJ5
        6UVqo7HOlu0nxsXnwNWGEL3HbCpDXzE=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-fgLCiZa4M-2IUeDq_VWBrA-1; Mon, 02 Dec 2019 16:15:39 -0500
Received: by mail-lj1-f198.google.com with SMTP id c24so140223ljk.0
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 13:15:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/ouSM1lVnL67PQdTS392czOikDoAX/1OhtnSM6w3ioA=;
        b=aR1tHSBsO4zprZQ/hy/8sSkUeDR4oVf9syDLBmOPlK3tvqRB1yh2K4GuHTXGmj558s
         zVJADR4REq2PU5nVd+XIByw5EARQGfHeyBdlWigr4NtCnc/X4UT7HUip1NRHnOsyZQJ7
         JqKnnPudot9TnOmhnAAYdLgAH0lNPLpXvVCJ40iOl2lEOUDThsUOQ6bXGWRzOvAXJraO
         cwIY4HUTN7NSLb7D/+TLkSwfsoHgyLWBxV6CXzDS4V8hMf/B9wGdLyzBv2XPPVYnSHGx
         7ErTfNTTebNcalQWt2iAf1yJfeVeYh4WQuo3nYrboEH9GXVxVW0SCjbi+JuHNVzbEwAJ
         Ct9w==
X-Gm-Message-State: APjAAAUzslq+4J7nU4LBaXJDUpmMWAZE06ounuil5YQthvZnlLRegjWO
        15XG+98xpqKtWoEo8kenT4ZD9jXVihHPuq3lsECYc3t5/bM68vAErQ1ekkq2U4ByGqBMYAzCu48
        dp/comtwXKSfjbw4H
X-Received: by 2002:a19:7513:: with SMTP id y19mr705307lfe.78.1575321338272;
        Mon, 02 Dec 2019 13:15:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqziTKggxyGWF5SicqNPqS1v54yq5kpVC6lMuqwhb8Et+uHGtiCio39/jHThcVA8JC6aYFLaUw==
X-Received: by 2002:a19:7513:: with SMTP id y19mr705299lfe.78.1575321338031;
        Mon, 02 Dec 2019 13:15:38 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m15sm340543ljg.4.2019.12.02.13.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 13:15:37 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 002971804D1; Mon,  2 Dec 2019 22:15:35 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCHv4 0/6] perf/bpftool: Allow to link libbpf dynamically
In-Reply-To: <CAEf4BzY_D9JHjuU6K=ciS70NSy2UvSm_uf1NfN_tmFz1445Jiw@mail.gmail.com>
References: <20191202131847.30837-1-jolsa@kernel.org> <CAEf4BzY_D9JHjuU6K=ciS70NSy2UvSm_uf1NfN_tmFz1445Jiw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 02 Dec 2019 22:15:35 +0100
Message-ID: <87wobepgy0.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: fgLCiZa4M-2IUeDq_VWBrA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, Dec 2, 2019 at 5:19 AM Jiri Olsa <jolsa@kernel.org> wrote:
>>
>> hi,
>> adding support to link bpftool with libbpf dynamically,
>> and config change for perf.
>>
>> It's now possible to use:
>>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=3D1
>>
>> which will detect libbpf devel package and if found, link it with bpftoo=
l.
>>
>> It's possible to use arbitrary installed libbpf:
>>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=3D1 LIBBPF_DIR=3D/tmp/libb=
pf/
>>
>> I based this change on top of Arnaldo's perf/core, because
>> it contains libbpf feature detection code as dependency.
>>
>> Also available in:
>>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>>   libbpf/dyn
>>
>> v4 changes:
>>   - based on Toke's v3 post, there's no need for additional API exports:
>>
>>     Since bpftool uses bits of libbpf that are not exported as public AP=
I in
>>     the .so version, we also pass in libbpf.a to the linker, which allow=
s it to
>>     pick up the private functions from the static library without having=
 to
>>     expose them as ABI.
>
> Whoever understands how this is supposed to work, can you please
> explain? From reading this, I think what we **want** is:
>
> - all LIBBPF_API-exposed APIs should be dynamically linked against libbpf=
.so;
> - everything else used from libbpf (e.g., netlink APIs), should come
> from libbpf.a.
>
> Am I getting the idea right?
>
> If yes, are we sure it actually works like that in practice? I've
> compiled with LIBBPF_DYNAMIC=3D1, and what I see is that libelf, libc,
> zlib, etc functions do have relocations against them in ".rela.plt"
> section. None of libbpf exposed APIs, though, have any of such
> relocations. Which to me suggests that they are just statically linked
> against libbpf.a and libbpf.so is just recorded in ELF as a dynamic
> library dependency because of this extra -lbpf flag. Which kind of
> defeats the purpose of this whole endeavor, no?
>
> I'm no linker expert, though, so I apologize if I got it completely
> wrong, would really appreciate someone to detail this a bit more.
> Thanks!

Ah, that is my mistake: I was getting dynamic libbpf symbols with this
approach, but that was because I had the version of libbpf.so in my
$LIBDIR that had the patch to expose the netlink APIs as versioned
symbols; so it was just pulling in everything from the shared library.

So what I was going for was exactly what you described above; but it
seems that doesn't actually work. Too bad, and sorry for wasting your
time on this :/

-Toke

