Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5E7DC8EAE
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbfJBQn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:43:59 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:42858 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfJBQn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:43:59 -0400
Received: by mail-io1-f41.google.com with SMTP id n197so58402368iod.9;
        Wed, 02 Oct 2019 09:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=9O1I/h9tZc82rrgXO7BG0a4YJeZOH28FNHYGfeapIF0=;
        b=UUN1d8Ppqdxg9rh0LJQnaoRMwgdMF/uPl6dnZyiuig+JNYCs8oXdJ3JXytEHPZMnbA
         b7U+4joTLpT2b+0agu/PGSxi1EO+N2bvJCu8sLIU731Zgh1pnM5EUmfuUQTKUQPTM8al
         gKT4Dk7G9ZbJQJs7B9WQyQAjB8e/DYj0CM1Pxbtwx7QN9FloRC3qSAkKWHIZhQACms31
         D1A4UNwsr0GuRpsbHJIDi0yK68IZZoBJ6B0xWpvd/HvG24vraRmVVigFbilg0DZRFMvi
         CX2+ep4B0+dtgzGYq+tpZ3c83BEHPtQxQkiRthAwge1h7CqAIzLYX3EGe7MxQG7P1QoQ
         jMoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=9O1I/h9tZc82rrgXO7BG0a4YJeZOH28FNHYGfeapIF0=;
        b=IxUM9hOE3rII4/8FytOTGKtQKm9FxEfvdn1LhdR5/+twBgoumg4IgMKgrXCiAIu5N6
         Vn2f1FdprUwlCb11FgsjQZIqbLHPTjChjWF3w59+qItMG4K55MFeLkZli4VI0rda24Ny
         qzDwEpDTkiFRg0QY8M13fTjs6DjzICwUyNFrKHTAC8m8HZJK5ra3673XIv9SUmezWGom
         RMkuFXxStcWZQQz+havYCRWgL9FOQP/jOVicStjzp3eY+baOK2GcNyj/PefGvFBkK1X6
         AnXPUiEqrmJUBFgsZXk0OrErKWhHlRNnLOOZ2eLvJh7kLu1rV7YTlfLEY15QRTKkRq9z
         4rIw==
X-Gm-Message-State: APjAAAVadetOTkBo8BROhoprkcBxQwwAEfn1HEpDDnwGeloOCje561fe
        FI0y7/eFHor2+uUZXCtv4UU=
X-Google-Smtp-Source: APXvYqyXHSiL9fRCRagAgm0YTgbTurfN3YkPu0OPosSJZoNpJv3+I34sOnQSoJquW2EWOcCSqnqbnA==
X-Received: by 2002:a02:cd05:: with SMTP id g5mr4907223jaq.52.1570034638105;
        Wed, 02 Oct 2019 09:43:58 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p7sm8278714ilh.10.2019.10.02.09.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 09:43:57 -0700 (PDT)
Date:   Wed, 02 Oct 2019 09:43:49 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5d94d3c5a238f_22502b00ea21a5b4e9@john-XPS-13-9370.notmuch>
In-Reply-To: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
Subject: RE: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> This series adds support for executing multiple XDP programs on a singl=
e
> interface in sequence, through the use of chain calls, as discussed at =
the Linux
> Plumbers Conference last month:
> =

> https://linuxplumbersconf.org/event/4/contributions/460/
> =

> # HIGH-LEVEL IDEA
> =

> The basic idea is to express the chain call sequence through a special =
map type,
> which contains a mapping from a (program, return code) tuple to another=
 program
> to run in next in the sequence. Userspace can populate this map to expr=
ess
> arbitrary call sequences, and update the sequence by updating or replac=
ing the
> map.
> =

> The actual execution of the program sequence is done in bpf_prog_run_xd=
p(),
> which will lookup the chain sequence map, and if found, will loop throu=
gh calls
> to BPF_PROG_RUN, looking up the next XDP program in the sequence based =
on the
> previous program ID and return code.
> =

> An XDP chain call map can be installed on an interface by means of a ne=
w netlink
> attribute containing an fd pointing to a chain call map. This can be su=
pplied
> along with the XDP prog fd, so that a chain map is always installed tog=
ether
> with an XDP program.
> =

> # PERFORMANCE
> =

> I performed a simple performance test to get an initial feel for the ov=
erhead of
> the chain call mechanism. This test consists of running only two progra=
ms in
> sequence: One that returns XDP_PASS and another that returns XDP_DROP. =
I then
> measure the drop PPS performance and compare it to a baseline of just a=
 single
> program that only returns XDP_DROP.
> =

> For comparison, a test case that uses regular eBPF tail calls to sequen=
ce two
> programs together is also included. Finally, because 'perf' showed that=
 the
> hashmap lookup was the largest single source of overhead, I also added =
a test
> case where I removed the jhash() call from the hashmap code, and just u=
se the
> u32 key directly as an index into the hash bucket structure.
> =

> The performance for these different cases is as follows (with retpoline=
s disabled):

retpolines enabled would also be interesting.

> =

> | Test case                       | Perf      | Add. overhead | Total o=
verhead |
> |---------------------------------+-----------+---------------+--------=
--------|
> | Before patch (XDP DROP program) | 31.0 Mpps |               |        =
        |
> | After patch (XDP DROP program)  | 28.9 Mpps |        2.3 ns |        =
 2.3 ns |

IMO even 1 Mpps overhead is too much for a feature that is primarily abou=
t
ease of use. Sacrificing performance to make userland a bit easier is har=
d
to justify for me when XDP _is_ singularly about performance. Also that i=
s
nearly 10% overhead which is fairly large. So I think going forward the
performance gab needs to be removed.

> | XDP tail call                   | 26.6 Mpps |        3.0 ns |        =
 5.3 ns |
> | XDP chain call (no jhash)       | 19.6 Mpps |       13.4 ns |        =
18.7 ns |
> | XDP chain call (this series)    | 17.0 Mpps |        7.9 ns |        =
26.6 ns |
> =

> From this it is clear that while there is some overhead from this mecha=
nism; but
> the jhash removal example indicates that it is probably possible to opt=
imise the
> code to the point where the overhead becomes low enough that it is acce=
ptable.

I'm missing why 'in theory' at least this can't be made as-fast as tail c=
alls?
Again I can't see why someone would lose 30% of their performance when a =
userland
program could populate a tail call map for the same effect. Sure userland=
 would
also have to enforce some program standards/conventions but it could be d=
one and
at 30% overhead that pain is probably worth it IMO.

My thinking though is if we are a bit clever chaining and tail calls coul=
d be
performance-wise equivalent?

I'll go read the patches now ;)

.John

> =

> # PATCH SET STRUCTURE
> This series is structured as follows:
> =

> - Patch 1: Prerequisite
> - Patch 2: New map type
> - Patch 3: Netlink hooks to install the chain call map
> - Patch 4: Core chain call logic
> - Patch 5-7: Bookkeeping updates to tools
> - Patch 8: Libbpf support for installing chain call maps
> - Patch 9: Selftests with example user space code
> =

> The whole series is also available in my git repo on kernel.org:
> https://git.kernel.org/pub/scm/linux/kernel/git/toke/linux.git/log/?h=3D=
xdp-multiprog-01
> =
