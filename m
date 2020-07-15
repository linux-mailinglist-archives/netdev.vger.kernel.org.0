Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642DD221182
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgGOPsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:48:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29693 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725798AbgGOPsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:48:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594828091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mAVCEGRw2hjVGzvX2wIOGOGQY8/1Rn8qD8f8geB5l10=;
        b=BU7DH9M9H1td2Y6mrcCLQJl4+t85wXRxeGZJdWyFN4SEM1sX+E/k0Mn9jDYi2n5wosarda
        6eIiGNhrjsuZAtHVdN2Bz4LZeSUWsOTpUin6Xfj8i4GHu0/d9h6prV1rchZBIMKwnl7Xe9
        zehWcFmMNTe7tuGrINQ7ZJ9qNVrhSPE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-pwxXM_WdPpeHsRcrNCKvmQ-1; Wed, 15 Jul 2020 11:48:07 -0400
X-MC-Unique: pwxXM_WdPpeHsRcrNCKvmQ-1
Received: by mail-wr1-f69.google.com with SMTP id o25so1537437wro.16
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 08:48:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mAVCEGRw2hjVGzvX2wIOGOGQY8/1Rn8qD8f8geB5l10=;
        b=tpLft9jh16fl86i/ys3sgQZk4LSLJaQYw55TWZvty1KpF2EpTrcpHuBNwq7io5uaNh
         0kz29suhcxleCd/E3wZg9scmY2APbkm0ddfrEooEplgZw1eCiz/WAjuTEqyQf2WutZfJ
         yqcfoXrCIKoAIuFr1Pjfeh7MuKcLuN3QExiGNLryWI78dN3bvB2s0gBNWoAoECy4LDxr
         E9MlZBWdBafwIIm1BnCViriaUrnNegBZ1jysj8zQRz10HVvbMj5E51lQ170JdOQAC/s+
         diYrVcCg4CnbxsHesHnOwMVBdspeIK1ioV7y+7CNZFAfFfqv096Js3A64GAcdx4N62fT
         R8Ug==
X-Gm-Message-State: AOAM532ucisCoq+h0sCABn7kzpvXJG/tXGn7PUzPEWc26Cvtvs52yQMb
        9+tOvy/3rBwnpiOPKrjD6B3itIJYw9K7ZuebF2TwFjTQg32EW0DYiU4PIu8tnIF2Wiqd2osPObL
        9TwYbKZJaGnKUTM3Q
X-Received: by 2002:a7b:ce14:: with SMTP id m20mr89410wmc.129.1594828085620;
        Wed, 15 Jul 2020 08:48:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqEkoAIN0fbRpT8du/zOHwjP3wY76yjt+pclJP2f398IdbQ0VEbE2E+yJdDu42jOek70hBDA==
X-Received: by 2002:a7b:ce14:: with SMTP id m20mr89361wmc.129.1594828085145;
        Wed, 15 Jul 2020 08:48:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q7sm3938344wrs.27.2020.07.15.08.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 08:48:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9649C1804F0; Wed, 15 Jul 2020 17:48:03 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kicinski@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Takshak Chahande <ctakshak@fb.com>
Subject: Re: [PATCH bpf-next 2/7] bpf, xdp: add bpf_link-based XDP attachment API
In-Reply-To: <CAEf4BzYMaKgJOA3koGkcThXriTGAOKGxjhQXYSNT9sVEFbS7ig@mail.gmail.com>
References: <20200710224924.4087399-1-andriin@fb.com> <20200710224924.4087399-3-andriin@fb.com> <877dv6gpxd.fsf@toke.dk> <CAEf4BzY7qRsdcdhzf2--Bfgo-GB=ZoKKizOb+OHO7o2PMiNubA@mail.gmail.com> <87v9ipg8jd.fsf@toke.dk> <CAEf4BzYVEqFUJybw3kjG6E6w12ocr2ncRz7j15GNNGG4BXJMTw@mail.gmail.com> <87lfjlg4fg.fsf@toke.dk> <CAEf4BzYMaKgJOA3koGkcThXriTGAOKGxjhQXYSNT9sVEFbS7ig@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 15 Jul 2020 17:48:03 +0200
Message-ID: <87y2nkeq4s.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

>> Yup, that was helpful, thanks! I think our difference of opinion on this
>> stems from the same place as our disagreement about point 2.: You are
>> assuming that an application that uses XDP sticks around and holds on to
>> its bpf_link, while I'm assuming it doesn't (and so has to rely on
>> pinning for any persistence). In the latter case you don't really gain
>> much from the bpf_link auto-cleanup, and whether it's a prog fd or a
>> link fd you go find in your bpffs doesn't make that much difference...
>
> Right. But if I had to pick just one implementation (prog fd-based vs
> bpf_link), I'd stick with bpf_link because it is flexible enough to
> "emulate" prog fd attachment (through BPF FS), but the same isn't true
> about prog fd attachment emulating bpf_link. That's it. I really don't
> enjoy harping on that point, but it feels to be silently dismissed all
> the time based on one particular arrangement for particular existing
> XDP flow.

It can; kinda. But you introduce a dependency on bpffs that wasn't there
before, and you end up with resources that are kept around in the kernel
if the interface disappears (because they are still pinned). So I
consider it a poor emulation.

>> >> >> I was under the impression that forcible attachment of bpf_links was
>> >> >> already possible, but looking at the code now it doesn't appear to be?
>> >> >> Wasn't that the whole point of BPF_LINK_GET_FD_BY_ID? I.e., that a
>> >> >> sysadmin with CAP_SYS_ADMIN privs could grab the offending bpf_link FD
>> >> >> and force-remove it? I certainly think this should be added before we
>> >> >> expand bpf_link usage any more...
>> >> >
>> >> > I still maintain that killing processes that installed the bpf_link is
>> >> > the better approach. Instead of letting the process believe and act as
>> >> > if it has an active XDP program, while it doesn't, it's better to
>> >> > altogether kill/restart the process.
>> >>
>> >> Killing the process seems like a very blunt tool, though. Say it's a
>> >> daemon that attaches XDP programs to all available interfaces, but you
>> >> want to bring down an interface for some one-off maintenance task, but
>> >> the daemon authors neglected to provide an interface to tell the daemon
>> >> to detach from specific interfaces. If your only option is to kill the
>> >> daemon, you can't bring down that interface without disrupting whatever
>> >> that daemon is doing with XDP on all the other interfaces.
>> >>
>> >
>> > I'd rather avoid addressing made up hypothetical cases, really. Get
>> > better and more flexible daemon?
>>
>> I know you guys don't consider an issue to be real until it has already
>> crashed something in production. But some of us don't have the luxury of
>> your fast issue-discovered-to-fix-shipped turnaround times; so instead
>> we have to go with the old-fashioned way of thinking about how things
>> can go wrong ahead of time, and making sure we're prepared to handle
>> issues if (or, all too often, when) they occur. And it's frankly
>> tiresome to have all such efforts be dismissed as "made up
>> hypotheticals". Please consider that the whole world does not operate
>> like your org, and that there may be legitimate reasons to do things
>> differently.
>>
>
> Having something that breaks production is a very hard evidence of a
> problem and makes it easier to better understand a **real** issue well
> and argue why something has to be solved or prevented. But it's not a
> necessary condition, of course. It's just that made up hypotheticals
> aren't necessarily good ways to motivate a feature, because all too
> often it turns out to be just that, hypothetical issue, while the real
> issue is different enough to warrant a different and better solution.
> By being conservative with adding features, we are trying to not make
> unnecessary design and API mistakes, because in the kernel they are
> here to stay forever.

I do appreciate the need to be conservative with the interfaces we add,
and I am aware of the maintenance burden. And it's not like I want
contingencies for any hypothetical I can think of put into the kernel
ahead of time (talk about a never-ending process :)). What I'm asking
for is just that something be argued on its merits, instead of
*automatically* being dismissed as "hypothetical". I.e., the difference
between "that can be handled by..." or "that is not likely to occur
because...", as opposed to "that has not happened yet, so come back when
it does".

> In your example, I'd argue that the design of that daemon is bad if it
> doesn't allow you to control what's attached where, and how to detach
> it without breaking completely independent network interfaces. That
> should be the problem that has to be solved first, IMO. And just
> because in some scenarios it might be **convenient** to force-detach
> bpf_link, is in no way a good justification (in my book) to add that
> feature, especially if there are other (and arguably safer) ways to
> achieve the same **troubleshooting** effect.

See this is actually what was I asking for - considering a question on
its merits; so thank you! And yeah, it would be a poorly designed
daemon, but I'm not quite convinced that such daemons won't show up and
be put into production by, say, someone running an enterprise operating
system :)

Anyway, let's leave that particular issue aside for now, and I'll circle
back to adding the force-remove if needed once I've thought this over a
bit more.

>> That being said...
>>
>> > This force-detach functionality isn't hard to add, but so far we had
>> > no real reason to do that. Once we do have such use cases, we can add
>> > it, if we agree it's still a good idea.
>>
>> ...this is fair enough, and I guess I should just put this on my list of
>> things to add. I was just somehow under the impression that this had
>> already been added.
>>
>
> So, overall, do I understand correctly that you are in principle not
> opposed to adding BPF XDP link, or you still have some concerns that
> were not addressed?

Broadly speaking yeah, I am OK with adding this as a second interface. I
am still concerned about the "locking in place" issued we discussed
above, but that can be addressed later. I am also a little concerned
about adding a second interface for configuring an interface that has to
take the RTNL lock etc; but those are mostly details, I suppose.

Unfortunately I won't have to review the latest version of your patch
set to look at those details before I go on vacation (sorry about that :/).
I guess I'll just have to leave that to you guys to take care of...

-Toke

