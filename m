Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 215A7199563
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 13:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730543AbgCaLeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 07:34:10 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29081 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730503AbgCaLeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 07:34:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585654449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HrO6qnvFCLDk5NO+OpOmNPceTFDvqZ+epiw6rusbJ10=;
        b=jHul6kWQECZTZh2u/uXD2lBqoI4cthV3Xs5tNT62JAzAZCjCFV3O7rJI12Yc83bY/iKohi
        I19NweSk1EgnsER402iSCLNLIGnFRUaxiHw6ib1oFfuNbsKLlSDdGw7+Tsp7DiKTSFA+pb
        FCLJd/1Y6urOI0HHOQui93s7u2Gw9AE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-QJJjezy4OmS-sCEFKK4zsg-1; Tue, 31 Mar 2020 07:34:07 -0400
X-MC-Unique: QJJjezy4OmS-sCEFKK4zsg-1
Received: by mail-lf1-f71.google.com with SMTP id q22so8741539lfj.23
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 04:34:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=HrO6qnvFCLDk5NO+OpOmNPceTFDvqZ+epiw6rusbJ10=;
        b=LkSaKbr4U0soWEEImI9uSx0awHLhXyMOBtKK4jxiKyxYxUX3ubbokrM5YhrUrffUY5
         fIO+RL1147WoU9x9fFjuSK7Tj9BgpRZWfCpz8Y4Sfgw2GqyUiE0LqknbSMeIxLSGQcSq
         z4kZxO4y8QHOXRPURJRC+RjGpDKeq/FdyC2/3CnSSqkbgHqntMaM1HCPiZweVrZWZruD
         BnsYjZbc96AXF2pg/h3yfT5l5rzsoTqBXF1cNW0DLHiJO5NBH+OvBYV93UV+FyF8BtVf
         7Jk8iu1m3uQGFbS9mYguT/iM0AIkikuChTsglxQNAdg8lCoDRkxX1M+2qks8f3+XZ9KD
         4d4A==
X-Gm-Message-State: AGi0PuaQrrxmMAPNCpHMkbRqZLbZ0XQFLcWQgCj8YsiSC9K9MixujZN+
        UyhyloDEH5jpk7ZRfBQKa+cWVl48LHMsRcVTUEQt29guxfo5P66VYcJ/LjW2iHkKNSe5zmPgpBW
        5dQmCyEBOnC2QkJey
X-Received: by 2002:a2e:7606:: with SMTP id r6mr9642595ljc.118.1585654446230;
        Tue, 31 Mar 2020 04:34:06 -0700 (PDT)
X-Google-Smtp-Source: APiQypIk+2lmWU41DZ0mTC8ILVxl4F/NkjA59ewgq4K6VwG8uzR822Z12+u9WfLaCIJYb76YCOla4A==
X-Received: by 2002:a2e:7606:: with SMTP id r6mr9642573ljc.118.1585654445979;
        Tue, 31 Mar 2020 04:34:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v22sm8418906ljj.67.2020.03.31.04.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 04:34:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D114518158D; Tue, 31 Mar 2020 13:34:00 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Edward Cree <ecree@solarflare.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <20200331040112.5tvvubsf6ij4eupb@ast-mbp>
References: <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com> <87pncznvjy.fsf@toke.dk> <20200326195859.u6inotgrm3ubw5bx@ast-mbp> <87imiqm27d.fsf@toke.dk> <20200327230047.ois5esl35s63qorj@ast-mbp> <87lfnll0eh.fsf@toke.dk> <20200328022609.zfupojim7see5cqx@ast-mbp> <87eetcl1e3.fsf@toke.dk> <CAEf4Bzb+GSf8cE_rutiaeZOtAuUick1+RnkCBU=Z+oY_36ArSA@mail.gmail.com> <53515939-00bb-174c-bc55-f90eaceac2a3@solarflare.com> <20200331040112.5tvvubsf6ij4eupb@ast-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 31 Mar 2020 13:34:00 +0200
Message-ID: <87k130iwrb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Mon, Mar 30, 2020 at 04:41:46PM +0100, Edward Cree wrote:
>> On 29/03/2020 21:23, Andrii Nakryiko wrote:
>> > But you can't say the same about other XDP applications that do not
>> > use libxdp. So will your library come with a huge warning
>> What about a system-wide policy switch to decide whether replacing/
>> =C2=A0removing an XDP program without EXPECTED_FD is allowed?=C2=A0 That=
 way
>> =C2=A0the sysadmin gets to choose whether it's the firewall or the packet
>> =C2=A0analyser that breaks, rather than baking a policy into the design.
>> Then libxdp just needs to say in the README "you might want to turn
>> =C2=A0on this switch".=C2=A0 Or maybe it defaults to on, and the other p=
rogram
>> =C2=A0has to talk you into turning it off if it wants to be 'ill-behaved=
'.
>
> yeah. something like this can work for xdp only, but
> it won't work for tc, since ownership is missing.
> It looks like such policy knob will bere-inventing bpf_link for
> one specific xdp case only because xdp has one program per attachment.

You keep talking about this as though bpf_link was the existing API and
we're discussing adding another, when in reality it's the other way
around.

> Imagine it was easy to come up with sensible policy and allow
> multiple progs in xdp hook.
> How would you implement such policy knob?
> processA attaches prog XDP_A. processB attaches prog XDP-B.
> Unless they start tagging their indivdual programs with BTF tags
> (as Toke is planning to do) there is no way to tell them apart.
> Then processA can iterate all progs in a hook, finds its prog
> based on tag and tell kernel: "find and replace an xdp prog with old_fd
> with new_fd on this ifindex".
> Kinda works, but it doesn't stop processB to accidently detach prog XDP_A
> that was installed by processA.
>
> The kernel job is to share the system resources. Like memory, cpu time.
> The hook is such resource too. The owner concept part of bpf_link
> allows such sharing.

FWIW I actually agree that the bpf_link ownership concept makes sense
for the individual attachments in a multi-prog hook; including for XDP.
And I've started thinking about whether the bpf_link fd can work as the
reference being returned by libxdp after a component program is
attached. I have some reservations, but I'll start a new thread on that
once I'm a bit further along with it...

[...]

> XDP is the hardest, since it does single prog only.
> That's what we're trying to solve with libdispatcher.
> I think if it goes well it can become part of the kernel and kernel
> will do multi prog XDP attach. And all hooks will be symmetrical.

Now *that* I'd like to see! I've said from the beginning that I think
XDP multi-prog should be part of the kernel, so if we can get there via
this detour I'm all for it.

> But looking at the size of this thread and still lots of
> misunderstanding about basic concept like bpf_link I'm not hopeful
> that libdispatcher will ever become part of the kernel.

I don't share your pessimism. If we can stop writing off honest
disagreement about design tradeoffs as just "misunderstanding", I think
we can get there.

-Toke

