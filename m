Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACAF51071C7
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 12:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbfKVLzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 06:55:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41774 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726714AbfKVLzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 06:55:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574423700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DMDYnns1qVOSm1cc8Vao44i/3MIyZ9c5XNLvlT2x5vM=;
        b=GD0wUy/A8mmimzzS4Mu7O/2I4Bfojbu9nTFVcaC91xcY4DDcJkPUsHY3jQcgJL5i20qAZ8
        qV62iLIagkoHKyA14OVyfg9Dp9Ofb+al7HmLOBH7NvBxcCWx0uRjNu7YhgL6+r4nfczrtd
        2fz4ouM0MdzKxDX3EuC0iW6VZdS549o=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-YDMsUQc7MeS-rTwyxVwEKw-1; Fri, 22 Nov 2019 06:54:57 -0500
Received: by mail-lf1-f72.google.com with SMTP id q13so1139111lfc.10
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 03:54:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=o8pUXAifARpSrDKSBJaNt5ENQJECJNnZCKegH2kb4Hs=;
        b=pjRRtr1EMjL7iitXBP0+gmU/BhdYBiZ/ocsqU/r1TErfLHbsLS7YAxTKTlxtl40/53
         rPxZMiSQy+CshPLMTFc5sxk8ncU7GjdmurRY+1X482iIi/bUSpix89U+Z61yS7eAb7OP
         VMN9ExzWSNRbIegD9e3TyCMwhh7ktax7qeqViIhCM/NXB77DGs1fXCnvlmbgsUtACqXd
         cGo5HEn2jG+H1XSgvPfNdL3Q3ldczUukj47l1bq+ll4nXa5hJIWMV5OXcVtOM5iFZGjQ
         zE1zpz2rWT2JnY0QhQNbt+hnLPf/o6PhApezPpCe48WEP7mvhBRI/uKULpK/YiLqevMP
         /5VA==
X-Gm-Message-State: APjAAAWwE2HfbvtbO0EOgXoOLncUMZ9kyFc5kd6NNnm+tjO36rg5QtlT
        eithY+g40eY/YXROoC08MD6hwZPGgmpX7AdsL0yqGgkLSxrn1HEVnI5bvvK2rBbUxQPypVJ5sap
        oGF/YeTekxpPQh8zj
X-Received: by 2002:a2e:9e45:: with SMTP id g5mr10920221ljk.58.1574423695795;
        Fri, 22 Nov 2019 03:54:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqwhrvuBI1rw6q9oenfA2KBU5izLk8TMS60wbl3/LPn2Rh+BzYFbs3SmixPagla0IwOnRzEFaA==
X-Received: by 2002:a2e:9e45:: with SMTP id g5mr10920188ljk.58.1574423695476;
        Fri, 22 Nov 2019 03:54:55 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id x12sm2978878lfq.52.2019.11.22.03.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 03:54:54 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9B7E51800B9; Fri, 22 Nov 2019 12:54:53 +0100 (CET)
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
In-Reply-To: <db38dee6-1db9-85f3-7a0c-0bcee13b12ea@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com> <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch> <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com> <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch> <87h840oese.fsf@toke.dk> <5db128153c75_549d2affde7825b85e@john-XPS-13-9370.notmuch> <87sgniladm.fsf@toke.dk> <a7f3d86b-c83c-7b0d-c426-684b8dfe4344@gmail.com> <87zhhmrz7w.fsf@toke.dk> <b2ecf3e6-a8f1-cfd9-0dd3-e5f4d5360c0b@gmail.com> <87zhhhnmg8.fsf@toke.dk> <640418c3-54ba-cd62-304f-fd9f73f25a42@gmail.com> <87blthox30.fsf@toke.dk> <c1b7ff64-6574-74c7-cd6b-5aa353ec80ce@gmail.com> <87lfsiocj5.fsf@toke.dk> <6e08f714-6284-6d0d-9cbe-711c64bf97aa@gmail.com> <87k17xcwoq.fsf@toke.dk> <db38dee6-1db9-85f3-7a0c-0bcee13b12ea@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 22 Nov 2019 12:54:53 +0100
Message-ID: <8736eg5do2.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: YDMsUQc7MeS-rTwyxVwEKw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toshiaki Makita <toshiaki.makita1@gmail.com> writes:

> On 2019/11/18 19:20, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>>=20
>> [... trimming the context a bit ...]
>>=20
>>>>>> Take your example of TC rules: You were proposing a flow like this:
>>>>>>
>>>>>> Userspace TC rule -> kernel rule table -> eBPF map -> generated XDP
>>>>>> program
>>>>>>
>>>>>> Whereas what I mean is that we could do this instead:
>>>>>>
>>>>>> Userspace TC rule -> kernel rule table
>>>>>>
>>>>>> and separately
>>>>>>
>>>>>> XDP program -> bpf helper -> lookup in kernel rule table
>>>>>
>>>>> Thanks, now I see what you mean.
>>>>> You expect an XDP program like this, right?
>>>>>
>>>>> int xdp_tc(struct xdp_md *ctx)
>>>>> {
>>>>> =09int act =3D bpf_xdp_tc_filter(ctx);
>>>>> =09return act;
>>>>> }
>>>>
>>>> Yes, basically, except that the XDP program would need to parse the
>>>> packet first, and bpf_xdp_tc_filter() would take a parameter struct wi=
th
>>>> the parsed values. See the usage of bpf_fib_lookup() in
>>>> bpf/samples/xdp_fwd_kern.c
>>>>
>>>>> But doesn't this way lose a chance to reduce/minimize the program to
>>>>> only use necessary features for this device?
>>>>
>>>> Not necessarily. Since the BPF program does the packet parsing and fil=
ls
>>>> in the TC filter lookup data structure, it can limit what features are
>>>> used that way (e.g., if I only want to do IPv6, I just parse the v6
>>>> header, ignore TCP/UDP, and drop everything that's not IPv6). The look=
up
>>>> helper could also have a flag argument to disable some of the lookup
>>>> features.
>>>
>>> It's unclear to me how to configure that.
>>> Use options when attaching the program? Something like
>>> $ xdp_tc attach eth0 --only-with ipv6
>>> But can users always determine their necessary features in advance?
>>=20
>> That's what I'm doing with xdp-filter now. But the answer to your second
>> question is likely to be 'probably not', so it would be good to not have
>> to do this :)
>>=20
>>> Frequent manual reconfiguration when TC rules frequently changes does
>>> not sound nice. Or, add hook to kernel to listen any TC filter event
>>> on some daemon and automatically reload the attached program?
>>=20
>> Doesn't have to be a kernel hook; we could enhance the userspace tooling
>> to do it. Say we integrate it into 'tc':
>>=20
>> - Add a new command 'tc xdp_accel enable <iface> --features [ipv6,etc]'
>> - When adding new rules, add the following logic:
>>    - Check if XDP acceleration is enabled
>>    - If it is, check whether the rule being added fits into the current
>>      'feature set' loaded on that interface.
>>      - If the rule needs more features, reload the XDP program to one
>>        with the needed additional features.
>>      - Or, alternatively, just warn the user and let them manually
>>        replace it?
>
> Ok, but there are other userspace tools to configure tc in wild.
> python and golang have their own netlink library project.
> OVS embeds TC netlink handling code in itself. There may be more tools li=
ke this.
> I think at least we should have rtnl notification about TC and monitor it
> from daemon, if we want to reload the program from userspace tools.

A daemon would be one way to do this in cases where it needs to be
completely dynamic. My guess is that there are lots of environments
where that is not required, and where a user/administrator could
realistically specify ahead of time which feature set they want to
enable XDP acceleration for. So in my mind the way to go about this is
to implement the latter first, then add dynamic reconfiguration of it on
top when (or if) it turns out to be necessary...

-Toke

