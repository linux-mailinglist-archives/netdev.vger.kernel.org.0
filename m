Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8346C92E8
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 22:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfJBUes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 16:34:48 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42153 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfJBUer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 16:34:47 -0400
Received: by mail-io1-f66.google.com with SMTP id n197so353987iod.9;
        Wed, 02 Oct 2019 13:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=R8qRCvTuArkNMmSIp9k7fBA7Fd9wKT3Ft5lVzIbWZ/E=;
        b=dkaT7NL3cQU3zdS0xDGPfx0w+UWaRPJjfGSPT05mref4a5QvrgLcd25mENHXitcgA1
         05w2yjeLGlms32sIXQQdadqM1avpOblwGpcdLmu2bXJ2+NztlDBUIw+nOZk2fzfQumt3
         qct2ae2sRUGG3tlTyXEAEP23avg/mMu2kJ2vRhb+Njwo8nAmX/ezwhgWsCnIIZIf2adV
         gWGbRJU0AymTcHMeEtoxYAnAFdcrkXZ32YZjxRnAbn3M3sQ/imQnE+WL64+GTWmqdEF1
         atVGI/tCxPCUpMjjWp4nqBh0t+Qt1dGiFzuxFRW9R4ac96qk2YR8E3tKVQB3XcQzNfAh
         WHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=R8qRCvTuArkNMmSIp9k7fBA7Fd9wKT3Ft5lVzIbWZ/E=;
        b=W797rEpUygIhw0UQ7LKZtt2uV2djU7nZXH8kPlOJFGi3ZRILcPIyqNszXMUS/wS2qM
         wjM+v3VwPlUtUsLjUBmFrmsCivGXupLFQbT2/8GMA4gkjJLQoTs3onOtj0mtFdQk2Se0
         7WE2C5lgqvIHwhXxhbJ0HfFyMsIt+YfJznRYjOpRTiuhAhTCqaqyvADNM8OMKvORS57o
         yWUoJAPDuM6oyz7oznM4m9lqtLtUdWwWBJM/wriw0z06CPcGCQhaB4UFWYvmT/Bku2uK
         ZEerpHKOuEOxBr9Lrt39T9Hdj5jTm0vvYap1I/dWJtbVbBVibP1P7jyzbI+7UAEzja+1
         PJzA==
X-Gm-Message-State: APjAAAXNwQd/TdZvyQ6xpYW1Iyuci2WbzBs00tiqUVwkW5W/UZKNTjfq
        Y+BLPfZ+aiRNOWNewp5Hw9I=
X-Google-Smtp-Source: APXvYqzA5nqQkAH1GUDA5ILLtffZHfJwb9fffM898ljZXjfvzS5jLpAXelk7ERufFtEzdQPAmCGPnw==
X-Received: by 2002:a92:9906:: with SMTP id p6mr6112446ili.57.1570048486677;
        Wed, 02 Oct 2019 13:34:46 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 28sm311224ilq.61.2019.10.02.13.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 13:34:45 -0700 (PDT)
Date:   Wed, 02 Oct 2019 13:34:38 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
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
Message-ID: <5d9509de4acb6_32c02ab4bb3b05c052@john-XPS-13-9370.notmuch>
In-Reply-To: <8736gbro8x.fsf@toke.dk>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
 <alpine.LRH.2.20.1910021540270.24629@dhcp-10-175-191-98.vpn.oracle.com>
 <87bluzrwks.fsf@toke.dk>
 <5d94d188e4cca_22502b00ea21a5b425@john-XPS-13-9370.notmuch>
 <8736gbro8x.fsf@toke.dk>
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
> John Fastabend <john.fastabend@gmail.com> writes:
> =

> > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> Alan Maguire <alan.maguire@oracle.com> writes:
> >> =

> >> > On Wed, 2 Oct 2019, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> >
> >> >> This series adds support for executing multiple XDP programs on a=
 single
> >> >> interface in sequence, through the use of chain calls, as discuss=
ed at the Linux
> >> >> Plumbers Conference last month:
> >> >> =

> >> >> https://linuxplumbersconf.org/event/4/contributions/460/
> >> >> =

> >> >> # HIGH-LEVEL IDEA
> >> >> =

> >> >> The basic idea is to express the chain call sequence through a sp=
ecial map type,
> >> >> which contains a mapping from a (program, return code) tuple to a=
nother program
> >> >> to run in next in the sequence. Userspace can populate this map t=
o express
> >> >> arbitrary call sequences, and update the sequence by updating or =
replacing the
> >> >> map.
> >> >> =

> >> >> The actual execution of the program sequence is done in bpf_prog_=
run_xdp(),
> >> >> which will lookup the chain sequence map, and if found, will loop=
 through calls
> >> >> to BPF_PROG_RUN, looking up the next XDP program in the sequence =
based on the
> >> >> previous program ID and return code.
> >> >> =

> >> >> An XDP chain call map can be installed on an interface by means o=
f a new netlink
> >> >> attribute containing an fd pointing to a chain call map. This can=
 be supplied
> >> >> along with the XDP prog fd, so that a chain map is always install=
ed together
> >> >> with an XDP program.
> >> >> =

> >> >
> >> > This is great stuff Toke!
> >> =

> >> Thanks! :)
> >> =

> >> > One thing that wasn't immediately clear to me - and this may be ju=
st
> >> > me - is the relationship between program behaviour for the XDP_DRO=
P
> >> > case and chain call execution. My initial thought was that a progr=
am
> >> > in the chain XDP_DROP'ping the packet would terminate the call cha=
in,
> >> > but on looking at patch #4 it seems that the only way the call cha=
in
> >> > execution is terminated is if
> >> >
> >> > - XDP_ABORTED is returned from a program in the call chain; or
> >> =

> >> Yes. Not actually sure about this one...
> >> =

> >> > - the map entry for the next program (determined by the return val=
ue
> >> >   of the current program) is empty; or
> >> =

> >> This will be the common exit condition, I expect
> >> =

> >> > - we run out of entries in the map
> >> =

> >> You mean if we run the iteration counter to zero, right?
> >> =

> >> > The return value of the last-executed program in the chain seems t=
o be
> >> > what determines packet processing behaviour after executing the ch=
ain
> >> > (_DROP, _TX, _PASS, etc). So there's no way to both XDP_PASS and
> >> > XDP_TX a packet from the same chain, right? Just want to make sure=

> >> > I've got the semantics correct. Thanks!
> >> =

> >> Yeah, you've got all this right. The chain call mechanism itself doe=
sn't
> >> change any of the underlying fundamentals of XDP. I.e., each packet =
gets
> >> exactly one verdict.
> >> =

> >> For chaining actual XDP programs that do different things to the pac=
ket,
> >> I expect that the most common use case will be to only run the next
> >> program if the previous one returns XDP_PASS. That will make the mos=
t
> >> semantic sense I think.
> >> =

> >> But there are also use cases where one would want to match on the ot=
her
> >> return codes; such as packet capture, for instance, where one might
> >> install a capture program that would carry forward the previous retu=
rn
> >> code, but do something to the packet (throw it out to userspace) fir=
st.
> >> =

> >> For the latter use case, the question is if we need to expose the
> >> previous return code to the program when it runs. You can do things
> >> without it (by just using a different program per return code), but =
it
> >> may simplify things if we just expose the return code. However, sinc=
e
> >> this will also change the semantics for running programs, I decided =
to
> >> leave that off for now.
> >> =

> >> -Toke
> >
> > In other cases where programs (e.g. cgroups) are run in an array the
> > return codes are 'AND'ed together so that we get
> >
> >    result1 & result2 & ... & resultN
> =

> How would that work with multiple programs, though? PASS -> DROP seems
> obvious, but what if the first program returns TX? Also, programs may
> want to be able to actually override return codes (e.g., say you want t=
o
> turn DROPs into REDIRECTs, to get all your dropped packets mirrored to
> your IDS or something).

In general I think either you hard code a precedence that will have to
be overly conservative because if one program (your firewall) tells XDP
to drop the packet and some other program redirects it, passes, etc. that=

seems incorrect to me. Or you get creative with the precedence rules and
they become complex and difficult to manage, where a drop will drop a pac=
ket
unless a previous/preceding program redirects it, etc. I think any hard
coded precedence you come up with will make some one happy and some other=

user annoyed. Defeating the programability of BPF.

Better if its programmable. I would prefer to pass the context into the
next program then programs can build their own semantics. Then leave
the & of return codes so any program can if needed really drop a packet.
The context could be pushed into a shared memory region and then it
doesn't even need to be part of the program signature.

.John=
