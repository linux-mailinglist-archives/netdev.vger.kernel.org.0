Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB95108E61
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 14:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbfKYNDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 08:03:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40128 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727298AbfKYNDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 08:03:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574686999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EKh0kRl1xUZgQvrIbrNg+jQHWEueimCxZj+p1K9U7N0=;
        b=QANKq4rI8UhFptiRrQ6naGGnjAe/w0z79viDOOfPD9y7H/jB9Jo7nJAqq4baLGZoPTSQ+g
        92b0RFE2eYs0TU9Q2eTCJh/DreNL0tZNvJL6+4GHnRIWDhCDXIsSuOxJ7rBsN5mjQnNYnl
        /UFTEDEgB2/pfzWFLJokP8osl+yUdK4=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-YzdHlCzUMhqEk9QQL5236A-1; Mon, 25 Nov 2019 08:03:18 -0500
Received: by mail-lf1-f71.google.com with SMTP id d16so3123242lfm.14
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 05:03:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=20gNfbLGU6iaInGTNeDvk9czbFUxUSG9YN7fSeSG9N8=;
        b=rFUw/JPT35nQPaL+rCg2F7vDrsSuUGL8E2VCMFPY+NFafNzJSQ1e1QLX7xYPQjGCPk
         5dcflm3+z6M5nuaoEiu/andsC4BVAXqWsZ+ZonXH/tA94GVkbsB8xrpZ4I0k/ft8ouT4
         Q7xad4gzgmxW482Zw0WJ2s+z70H2MA4TtFCoZH1u9MWlQMSqoPNcHMrk1UhPdluGZjYC
         AaJwzn8ssD2zIvkYQxE+LhWoQfIf9lvW9/cf5jWZ6ZsUISk5fEwvrtT6PdMgFBUG3dZP
         V269Esdk409xHhC95DiVqXF+k2H2o9r4v4sLyzenWvAjsIwVfnDzzyp2a6UCvvOyPW00
         l5OQ==
X-Gm-Message-State: APjAAAWgpn9+Yd25QCx18sQsD4S8+HXD7Byud+0WAxzrDivm1PkoyLG8
        7JiZUhWUxB+nUkyKiwh5yhyzf5T3nT0+vr9Bca44lrQSQ5t+aHTRxyK6QCFovq74pF4UPD5SmZi
        2dGFjqdGLnjNm9Bd2
X-Received: by 2002:a05:651c:1025:: with SMTP id w5mr22503821ljm.68.1574686996744;
        Mon, 25 Nov 2019 05:03:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqzIZ3glIOH8nbgqJTaeY2EQ3/a80pf7N5WOJxQ/cBsRzT23Y2i53Epi3ktj6g8NqK/WtKGZtg==
X-Received: by 2002:a05:651c:1025:: with SMTP id w5mr22503789ljm.68.1574686996442;
        Mon, 25 Nov 2019 05:03:16 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g5sm3595027lfc.11.2019.11.25.05.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 05:03:15 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AEAD21818BF; Mon, 25 Nov 2019 14:03:14 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
In-Reply-To: <c96d99ce-5fdd-dfa5-f013-ce11c6c8cfda@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com> <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch> <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com> <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch> <87h840oese.fsf@toke.dk> <5db128153c75_549d2affde7825b85e@john-XPS-13-9370.notmuch> <87sgniladm.fsf@toke.dk> <a7f3d86b-c83c-7b0d-c426-684b8dfe4344@gmail.com> <87zhhmrz7w.fsf@toke.dk> <b2ecf3e6-a8f1-cfd9-0dd3-e5f4d5360c0b@gmail.com> <87zhhhnmg8.fsf@toke.dk> <640418c3-54ba-cd62-304f-fd9f73f25a42@gmail.com> <87blthox30.fsf@toke.dk> <c1b7ff64-6574-74c7-cd6b-5aa353ec80ce@gmail.com> <87lfsiocj5.fsf@toke.dk> <6e08f714-6284-6d0d-9cbe-711c64bf97aa@gmail.com> <87k17xcwoq.fsf@toke.dk> <db38dee6-1db9-85f3-7a0c-0bcee13b12ea@gmail.com> <8736eg5do2.fsf@toke.dk> <c96d99ce-5fdd-dfa5-f013-ce11c6c8cfda@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 25 Nov 2019 14:03:14 +0100
Message-ID: <87zhgk152l.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: YzdHlCzUMhqEk9QQL5236A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toshiaki Makita <toshiaki.makita1@gmail.com> writes:

> On 2019/11/22 20:54, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>>=20
>>> On 2019/11/18 19:20, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>>>>
>>>> [... trimming the context a bit ...]
>>>>
>>>>>>>> Take your example of TC rules: You were proposing a flow like this=
:
>>>>>>>>
>>>>>>>> Userspace TC rule -> kernel rule table -> eBPF map -> generated XD=
P
>>>>>>>> program
>>>>>>>>
>>>>>>>> Whereas what I mean is that we could do this instead:
>>>>>>>>
>>>>>>>> Userspace TC rule -> kernel rule table
>>>>>>>>
>>>>>>>> and separately
>>>>>>>>
>>>>>>>> XDP program -> bpf helper -> lookup in kernel rule table
>>>>>>>
>>>>>>> Thanks, now I see what you mean.
>>>>>>> You expect an XDP program like this, right?
>>>>>>>
>>>>>>> int xdp_tc(struct xdp_md *ctx)
>>>>>>> {
>>>>>>> =09int act =3D bpf_xdp_tc_filter(ctx);
>>>>>>> =09return act;
>>>>>>> }
>>>>>>
>>>>>> Yes, basically, except that the XDP program would need to parse the
>>>>>> packet first, and bpf_xdp_tc_filter() would take a parameter struct =
with
>>>>>> the parsed values. See the usage of bpf_fib_lookup() in
>>>>>> bpf/samples/xdp_fwd_kern.c
>>>>>>
>>>>>>> But doesn't this way lose a chance to reduce/minimize the program t=
o
>>>>>>> only use necessary features for this device?
>>>>>>
>>>>>> Not necessarily. Since the BPF program does the packet parsing and f=
ills
>>>>>> in the TC filter lookup data structure, it can limit what features a=
re
>>>>>> used that way (e.g., if I only want to do IPv6, I just parse the v6
>>>>>> header, ignore TCP/UDP, and drop everything that's not IPv6). The lo=
okup
>>>>>> helper could also have a flag argument to disable some of the lookup
>>>>>> features.
>>>>>
>>>>> It's unclear to me how to configure that.
>>>>> Use options when attaching the program? Something like
>>>>> $ xdp_tc attach eth0 --only-with ipv6
>>>>> But can users always determine their necessary features in advance?
>>>>
>>>> That's what I'm doing with xdp-filter now. But the answer to your seco=
nd
>>>> question is likely to be 'probably not', so it would be good to not ha=
ve
>>>> to do this :)
>>>>
>>>>> Frequent manual reconfiguration when TC rules frequently changes does
>>>>> not sound nice. Or, add hook to kernel to listen any TC filter event
>>>>> on some daemon and automatically reload the attached program?
>>>>
>>>> Doesn't have to be a kernel hook; we could enhance the userspace tooli=
ng
>>>> to do it. Say we integrate it into 'tc':
>>>>
>>>> - Add a new command 'tc xdp_accel enable <iface> --features [ipv6,etc]=
'
>>>> - When adding new rules, add the following logic:
>>>>     - Check if XDP acceleration is enabled
>>>>     - If it is, check whether the rule being added fits into the curre=
nt
>>>>       'feature set' loaded on that interface.
>>>>       - If the rule needs more features, reload the XDP program to one
>>>>         with the needed additional features.
>>>>       - Or, alternatively, just warn the user and let them manually
>>>>         replace it?
>>>
>>> Ok, but there are other userspace tools to configure tc in wild.
>>> python and golang have their own netlink library project.
>>> OVS embeds TC netlink handling code in itself. There may be more tools =
like this.
>>> I think at least we should have rtnl notification about TC and monitor =
it
>>> from daemon, if we want to reload the program from userspace tools.
>>=20
>> A daemon would be one way to do this in cases where it needs to be
>> completely dynamic. My guess is that there are lots of environments
>> where that is not required, and where a user/administrator could
>> realistically specify ahead of time which feature set they want to
>> enable XDP acceleration for. So in my mind the way to go about this is
>> to implement the latter first, then add dynamic reconfiguration of it on
>> top when (or if) it turns out to be necessary...
>
> Hmm, but I think there is big difference between a daemon and a cli tool.
> Shouldn't we determine the design considering future usage?

Sure, we should make sure the design doesn't exclude either option. But
we also shouldn't end up in a "the perfect is the enemy of the good"
type of situation. And the kernel-side changes are likely to be somewhat
independent of what the userspace management ends up looking like...

-Toke

