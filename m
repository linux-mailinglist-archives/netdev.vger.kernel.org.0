Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6CFC8E78
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfJBQe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:34:28 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40754 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJBQe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:34:27 -0400
Received: by mail-io1-f65.google.com with SMTP id h144so58313634iof.7;
        Wed, 02 Oct 2019 09:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=L5yzv1HKm2KvXDWTbTeXvO+EhVNRDX+DbnXraQLBFn0=;
        b=lFSnoA1vCQpaBdmO0hm7yIKAyoyWDoNwr7eXT187a3yItzzUqNF4p7h9h0/VDB8hUU
         jm438X7eGij266KCQ0y61xgk9bmYwzDJwjY80G/uIrLyXk/Yhr4COgnnqueB/V62JQpK
         r+ZdfLoovwWH9fMeqv5uJSu2Qz2yFsv3KZe4DHfEY8OeyVyDOC6IGO0OnpPNa5x11VGs
         UvoVMLV9tV1Wlil4QncV7WPhcvIEM4wVfbrgvr8iJnf1O5JddZ7FLnZNeOhNpxp6fMxn
         uQEv0WaKEj4wGGfx4+ixlEu/i+H8PekTXF9C9WrPq704L2bLOwsl3dFw0WySKBxTJcG4
         VT4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=L5yzv1HKm2KvXDWTbTeXvO+EhVNRDX+DbnXraQLBFn0=;
        b=TMXS5ei6+cF2WqsOZosKOSfj2QVbcqBaCS+ZkRb9fRQL4ssFPU7TDxauiL1yq7LRgn
         ONGxnMjVQ5LAiIlwAvlw+XIkpHwgNUqBLSO0MvzPp+nb/M49Q4mC09jEDBFnEODSVlE2
         4g59G5+mSEEPSjXzwWSQNKA2brwgHxbbMjmbGXvUcehndsyqCHa14iRzwCg4zD/i/Iz9
         Fjd0qK1S95F+4GW/SHKuu5OHfkMlRl1j/o7QP/Zy+tZs+dyHWw/7cmzRRQQOtF0HbntQ
         Hnz5e0n288+SEQ/EOrdU69e9RDfvkYKEXqvfo/lGzlpke/5F9MD0nCgp6ZR04lZO2o3k
         NZ9A==
X-Gm-Message-State: APjAAAVM3VVIzS/h/FJ2hFVtl8uQc5AwPTShvG83goEGPZ4A8bf7VLwf
        oACnMCHTRxiQTmkYuTj50Sg=
X-Google-Smtp-Source: APXvYqx2XYfRz9ULn6fLoAoZ7Ax/aD7xiyHVHTjdgCOEfj4pxYMon+wDfzZN+JyL6TDwiG7t6gklQg==
X-Received: by 2002:a02:7405:: with SMTP id o5mr4836748jac.44.1570034066364;
        Wed, 02 Oct 2019 09:34:26 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d26sm5063049ioc.16.2019.10.02.09.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 09:34:25 -0700 (PDT)
Date:   Wed, 02 Oct 2019 09:34:16 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alan Maguire <alan.maguire@oracle.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5d94d188e4cca_22502b00ea21a5b425@john-XPS-13-9370.notmuch>
In-Reply-To: <87bluzrwks.fsf@toke.dk>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
 <alpine.LRH.2.20.1910021540270.24629@dhcp-10-175-191-98.vpn.oracle.com>
 <87bluzrwks.fsf@toke.dk>
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
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
> Alan Maguire <alan.maguire@oracle.com> writes:
> =

> > On Wed, 2 Oct 2019, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >
> >> This series adds support for executing multiple XDP programs on a si=
ngle
> >> interface in sequence, through the use of chain calls, as discussed =
at the Linux
> >> Plumbers Conference last month:
> >> =

> >> https://linuxplumbersconf.org/event/4/contributions/460/
> >> =

> >> # HIGH-LEVEL IDEA
> >> =

> >> The basic idea is to express the chain call sequence through a speci=
al map type,
> >> which contains a mapping from a (program, return code) tuple to anot=
her program
> >> to run in next in the sequence. Userspace can populate this map to e=
xpress
> >> arbitrary call sequences, and update the sequence by updating or rep=
lacing the
> >> map.
> >> =

> >> The actual execution of the program sequence is done in bpf_prog_run=
_xdp(),
> >> which will lookup the chain sequence map, and if found, will loop th=
rough calls
> >> to BPF_PROG_RUN, looking up the next XDP program in the sequence bas=
ed on the
> >> previous program ID and return code.
> >> =

> >> An XDP chain call map can be installed on an interface by means of a=
 new netlink
> >> attribute containing an fd pointing to a chain call map. This can be=
 supplied
> >> along with the XDP prog fd, so that a chain map is always installed =
together
> >> with an XDP program.
> >> =

> >
> > This is great stuff Toke!
> =

> Thanks! :)
> =

> > One thing that wasn't immediately clear to me - and this may be just
> > me - is the relationship between program behaviour for the XDP_DROP
> > case and chain call execution. My initial thought was that a program
> > in the chain XDP_DROP'ping the packet would terminate the call chain,=

> > but on looking at patch #4 it seems that the only way the call chain
> > execution is terminated is if
> >
> > - XDP_ABORTED is returned from a program in the call chain; or
> =

> Yes. Not actually sure about this one...
> =

> > - the map entry for the next program (determined by the return value
> >   of the current program) is empty; or
> =

> This will be the common exit condition, I expect
> =

> > - we run out of entries in the map
> =

> You mean if we run the iteration counter to zero, right?
> =

> > The return value of the last-executed program in the chain seems to b=
e
> > what determines packet processing behaviour after executing the chain=

> > (_DROP, _TX, _PASS, etc). So there's no way to both XDP_PASS and
> > XDP_TX a packet from the same chain, right? Just want to make sure
> > I've got the semantics correct. Thanks!
> =

> Yeah, you've got all this right. The chain call mechanism itself doesn'=
t
> change any of the underlying fundamentals of XDP. I.e., each packet get=
s
> exactly one verdict.
> =

> For chaining actual XDP programs that do different things to the packet=
,
> I expect that the most common use case will be to only run the next
> program if the previous one returns XDP_PASS. That will make the most
> semantic sense I think.
> =

> But there are also use cases where one would want to match on the other=

> return codes; such as packet capture, for instance, where one might
> install a capture program that would carry forward the previous return
> code, but do something to the packet (throw it out to userspace) first.=

> =

> For the latter use case, the question is if we need to expose the
> previous return code to the program when it runs. You can do things
> without it (by just using a different program per return code), but it
> may simplify things if we just expose the return code. However, since
> this will also change the semantics for running programs, I decided to
> leave that off for now.
> =

> -Toke

In other cases where programs (e.g. cgroups) are run in an array the
return codes are 'AND'ed together so that we get

   result1 & result2 & ... & resultN

The result is if any program returns a drop then the packet should
be dropped, but all programs at least "see" the packet. There was
a lot of debate over this semantic and I think in hind sight it
actually works pretty well so any chaining in XDP should also keep
those semantics. For things like redirect we can already, even in
the same program, do multiple calls to the redirect helper and it
will overwrite the last call so those semantics can stay the same.

.John=
