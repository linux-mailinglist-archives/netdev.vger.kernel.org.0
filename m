Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBD85CAF7E
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732820AbfJCTpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:45:22 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36581 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732794AbfJCTpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 15:45:22 -0400
Received: by mail-io1-f66.google.com with SMTP id b136so8384415iof.3;
        Thu, 03 Oct 2019 12:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=i5SRW650j5BJ90wvzZtErCHhM3AAQmPhx67wAeJSpaE=;
        b=lNAphGycOeDj6QtECZ/Gg7yiian3Joe5vR2N2xdzY5RdK/BMVnlOMXwoTBVNAggGaA
         IrA83jXUoMwNS1kfKvyh5KI5zeGx5fv7TtNwf7+nJaYqpRvXg3Q9PCsI9laKYlcwmAQk
         AxrgKBfVV7ethuCw4KqPu+YBB/hwJpTqA9WLD2N0TlQwMmUhB0kK4xic09MFIePk/Nlj
         wN8XyNuZcI1JSuZRRHhxNZmkkL2adPYUHqNDakIMCk6KIlJ2vRGkbaL5zelRbbvsHY9h
         05g5AdHMQEC2vE8CDWKVtMuGhlmVviABTAGs1Y5m0KOKePrPRhKUVG8gyDyGRsmYU9ym
         +IkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=i5SRW650j5BJ90wvzZtErCHhM3AAQmPhx67wAeJSpaE=;
        b=B60g4PT1pedBwUMaZ0A1o8kc1OvowDCi/rE4XhhGm4K45lK8+sLBm2kihOHboikDCE
         7v8exlV6hc7UYUlh6DyIt6cLtqK96jZQ3NifbNrhZGJxzpyfSZJOVgbFjDueu5O0jqAK
         z414SwrG3/2xja4FC/IvVIuKzQPW//PkNV/rY7z0InUNgnsxn4Qezj7dRvXZZ0yWFtPg
         jYgYKbwfxLpKno6s+LuNJKaqvhvOBOgQt+VCVtkbr1nIwuN9wzDcwkGyu+nYsXu6siFz
         ojWffiDYPmyerhYIqvc3AKfr1ksD4c52Ez/hjGue+trzsAvfVjIYc1NPLZlkaLn/KnKf
         /e3w==
X-Gm-Message-State: APjAAAVi0SLQt7HJAjtqIDTD5ZTnkAw5VoMgEEiAdArZ+PScmJQjDY+M
        oMpK+Q8QrYyvZMrVG/tHs9L7YzCF+QI=
X-Google-Smtp-Source: APXvYqxH2EjjZF+LHI91v2I6AbwTMsxXYDEayQGidXUkgnWqtTPgX/C4I0vw07Gt3AqKLOsgefhyog==
X-Received: by 2002:a5d:8f81:: with SMTP id l1mr2916814iol.47.1570131920687;
        Thu, 03 Oct 2019 12:45:20 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s201sm1526243ios.83.2019.10.03.12.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 12:45:20 -0700 (PDT)
Date:   Thu, 03 Oct 2019 12:45:11 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, brouer@redhat.com
Message-ID: <5d964fc7c247b_55732aec43fe05c45@john-XPS-13-9370.notmuch>
In-Reply-To: <20191003120923.2a8ec190@carbon>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
 <alpine.LRH.2.20.1910021540270.24629@dhcp-10-175-191-98.vpn.oracle.com>
 <87bluzrwks.fsf@toke.dk>
 <5d94d188e4cca_22502b00ea21a5b425@john-XPS-13-9370.notmuch>
 <8736gbro8x.fsf@toke.dk>
 <5d9509de4acb6_32c02ab4bb3b05c052@john-XPS-13-9370.notmuch>
 <87ftkaqng9.fsf@toke.dk>
 <20191003120923.2a8ec190@carbon>
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

Jesper Dangaard Brouer wrote:
> On Thu, 03 Oct 2019 09:48:22 +0200
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
> =

> > John Fastabend <john.fastabend@gmail.com> writes:
> > =

> > > Toke H=C3=B8iland-J=C3=B8rgensen wrote:  =

> > >> John Fastabend <john.fastabend@gmail.com> writes:
> > >>   =

> > >> > Toke H=C3=B8iland-J=C3=B8rgensen wrote:  =

> > >> >> Alan Maguire <alan.maguire@oracle.com> writes:
> > >> >>   =

> > >> >> > On Wed, 2 Oct 2019, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > >> >> >  =

> > >> >> >> This series adds support for executing multiple XDP programs=
 on a single
> > >> >> >> interface in sequence, through the use of chain calls, as di=
scussed at the Linux
> > >> >> >> Plumbers Conference last month:
> > >> >> >> =

> > >> >> >> https://linuxplumbersconf.org/event/4/contributions/460/
> > >> >> >> =

> > >> >> >> # HIGH-LEVEL IDEA
> > >> >> >> =

> > >> >> >> The basic idea is to express the chain call sequence through=
 a special map type,
> > >> >> >> which contains a mapping from a (program, return code) tuple=
 to another program
> > >> >> >> to run in next in the sequence. Userspace can populate this =
map to express
> > >> >> >> arbitrary call sequences, and update the sequence by updatin=
g or replacing the
> > >> >> >> map.
> > >> >> >> =

> > >> >> >> The actual execution of the program sequence is done in bpf_=
prog_run_xdp(),
> > >> >> >> which will lookup the chain sequence map, and if found, will=
 loop through calls
> > >> >> >> to BPF_PROG_RUN, looking up the next XDP program in the sequ=
ence based on the
> > >> >> >> previous program ID and return code.
> > >> >> >> =

> > >> >> >> An XDP chain call map can be installed on an interface by me=
ans of a new netlink
> > >> >> >> attribute containing an fd pointing to a chain call map. Thi=
s can be supplied
> > >> >> >> along with the XDP prog fd, so that a chain map is always in=
stalled together
> > >> >> >> with an XDP program.
> > >> >> >>   =

> > >> >> >
> > >> >> > This is great stuff Toke!  =

> > >> >> =

> > >> >> Thanks! :)
> > >> >>   =

> > >> >> > One thing that wasn't immediately clear to me - and this may =
be just
> > >> >> > me - is the relationship between program behaviour for the XD=
P_DROP
> > >> >> > case and chain call execution. My initial thought was that a =
program
> > >> >> > in the chain XDP_DROP'ping the packet would terminate the cal=
l chain,
> > >> >> > but on looking at patch #4 it seems that the only way the cal=
l chain
> > >> >> > execution is terminated is if
> > >> >> >
> > >> >> > - XDP_ABORTED is returned from a program in the call chain; o=
r  =

> > >> >> =

> > >> >> Yes. Not actually sure about this one...
> > >> >>   =

> > >> >> > - the map entry for the next program (determined by the retur=
n value
> > >> >> >   of the current program) is empty; or  =

> > >> >> =

> > >> >> This will be the common exit condition, I expect
> > >> >>   =

> > >> >> > - we run out of entries in the map  =

> > >> >> =

> > >> >> You mean if we run the iteration counter to zero, right?
> > >> >>   =

> > >> >> > The return value of the last-executed program in the chain se=
ems to be
> > >> >> > what determines packet processing behaviour after executing t=
he chain
> > >> >> > (_DROP, _TX, _PASS, etc). So there's no way to both XDP_PASS =
and
> > >> >> > XDP_TX a packet from the same chain, right? Just want to make=
 sure
> > >> >> > I've got the semantics correct. Thanks!  =

> > >> >> =

> > >> >> Yeah, you've got all this right. The chain call mechanism itsel=
f doesn't
> > >> >> change any of the underlying fundamentals of XDP. I.e., each pa=
cket gets
> > >> >> exactly one verdict.
> > >> >> =

> > >> >> For chaining actual XDP programs that do different things to th=
e packet,
> > >> >> I expect that the most common use case will be to only run the =
next
> > >> >> program if the previous one returns XDP_PASS. That will make th=
e most
> > >> >> semantic sense I think.
> > >> >> =

> > >> >> But there are also use cases where one would want to match on t=
he other
> > >> >> return codes; such as packet capture, for instance, where one m=
ight
> > >> >> install a capture program that would carry forward the previous=
 return
> > >> >> code, but do something to the packet (throw it out to userspace=
) first.
> > >> >> =

> > >> >> For the latter use case, the question is if we need to expose t=
he
> > >> >> previous return code to the program when it runs. You can do th=
ings
> > >> >> without it (by just using a different program per return code),=
 but it
> > >> >> may simplify things if we just expose the return code. However,=
 since
> > >> >> this will also change the semantics for running programs, I dec=
ided to
> > >> >> leave that off for now.
> > >> >> =

> > >> >> -Toke  =

> > >> >
> > >> > In other cases where programs (e.g. cgroups) are run in an array=
 the
> > >> > return codes are 'AND'ed together so that we get
> > >> >
> > >> >    result1 & result2 & ... & resultN  =

> =

> But the XDP return codes are not bit values, so AND operation doesn't
> make sense to me.
> =

> > >> =

> > >> How would that work with multiple programs, though? PASS -> DROP s=
eems
> > >> obvious, but what if the first program returns TX? Also, programs =
may
> > >> want to be able to actually override return codes (e.g., say you w=
ant to
> > >> turn DROPs into REDIRECTs, to get all your dropped packets mirrore=
d to
> > >> your IDS or something).  =

> > >
> > > In general I think either you hard code a precedence that will have=
 to
> > > be overly conservative because if one program (your firewall) tells=

> > > XDP to drop the packet and some other program redirects it, passes,=

> > > etc. that seems incorrect to me. Or you get creative with the
> > > precedence rules and they become complex and difficult to manage,
> > > where a drop will drop a packet unless a previous/preceding program=

> > > redirects it, etc. I think any hard coded precedence you come up wi=
th
> > > will make some one happy and some other user annoyed. Defeating the=

> > > programability of BPF.  =

> > =

> > Yeah, exactly. That's basically why I punted on that completely.
> > Besides, technically you can get this by just installing different
> > programs in each slot if you really need it.
> =

> I would really like to avoid hard coding precedence.  I know it is
> "challenging" that we want to allow overruling any XDP return code, but=

> I think it makes sense and it is the most flexible solution.
> =

> =

> > > Better if its programmable. I would prefer to pass the context into=

> > > the next program then programs can build their own semantics. Then
> > > leave the & of return codes so any program can if needed really dro=
p a
> > > packet. The context could be pushed into a shared memory region and=

> > > then it doesn't even need to be part of the program signature.  =

> > =

> > Since it seems I'll be going down the rabbit hole of baking this into=

> > the BPF execution environment itself, I guess I'll keep this in mind =
as
> > well. Either by stuffing the previous program return code into the
> > context object(s), or by adding a new helper to retrieve it.
> =

> I would like to see the ability to retrieve previous program return
> code, and a new helper would be the simplest approach.  As this could
> potentially simplify and compact the data-structure.

But I'm a bit lost here. I think similar to Alexei comment.

Sounds like you want 'something' that implements a graph of functions,
where depending on the return code of the function you call the next
function in the graph. And you want the edges on that graph to be
programmable so that depending on the administrators configuration
the graph may be built differently?

The more I think about this it seems that you want a BPF program
that is generated from a configuration file to chain together whatever
the administrator asks for. Then you don't need any kernel bits
other than what we have. Of course we can optimize with shared libs
and such as we go but I'm not seeing the missing piece. Use proper
calls instead of tail calls and you can get return codes to handle
however you like. It requires a bit of cooperation from the ids
writers to build you a function to call but that should be simply
their normal xdp hook. Maybe the verifier needs a bit of extra
smarts to follow ctx types into calls I'm not sure.


User says via some fancy gui or yaml or ... build this


                                      ----- XDP_PASS
                                      |
                                      |
 XDP_firefwall --- pass ---> XDP_IDS ------ XDP_DROP
                |
                -- drop ------------------> XDP_DROP

generate the file and load it. This seems to be the advantage of
BPF here you can build whatever you like, make the rules however
complex you like, and build any precedent on the return codes you
like.

.John


> =

> -- =

> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer


