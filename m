Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3BEC17B854
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 09:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgCFIba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 03:31:30 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28017 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725905AbgCFIba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 03:31:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583483489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=anyf/HBUELE5YJWGa0J0v1pQ0FRx+AM26oFHPhDmyy0=;
        b=bbUYBv9gpKgNbX2Dg9KG/tKYjn4TymYECucF4v4T25sWhIe3CNsRQe2ijQ+vngutFYg1dI
        u6DjjcHIi230gKeKHX+mlzNI/SHaDtNDFWYAPKQyxa4RM4pVugsnMOFSHMI8Yn/SbF1qfQ
        4kKbEPjvk/62jXhIu3DzqMDO+4Mtb+w=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-q78gfWDgN3mhO92lmRz-iA-1; Fri, 06 Mar 2020 03:31:27 -0500
X-MC-Unique: q78gfWDgN3mhO92lmRz-iA-1
Received: by mail-wr1-f71.google.com with SMTP id x14so675245wrv.23
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 00:31:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=anyf/HBUELE5YJWGa0J0v1pQ0FRx+AM26oFHPhDmyy0=;
        b=m1zvsC2xAxZAWPjfkrCROYmhhQKImvmYB9b3GlC7zEezQZxuVkdDLbX0N/H0mqa04H
         lwe8f+cgyipS+jCPmNWYeXXoN/yuFxaVxokbm1sRkvtQPKvPinDui89tlxj/nM26HqLH
         T/G2kF3y8XkPlOPWwE2S2UKtOl1ggewMSzL2QzVYpmkuDrd5AxLVAL18YoCVlOnmnsKZ
         eFfi0hdtgcf642kgaSKWxWkyxX+KGXwwZ2ozdfN8wDWb0tfCxHBcIGTI2TEecgd7tWg+
         kG1+Ao15FV22Ehq+GshKdBu0v7p3qJ77or88A+T0BgH9ChQZJ+qhqLKUmuzwWsy85YYx
         yOQA==
X-Gm-Message-State: ANhLgQ1YiULPEVpSX5wdloYBSHDhn+YVl27VTpv8B7kXiKtsTzGatlcU
        Kyyx3gd+7aVAedvT9UIymUF2VHzUG+YzCr0MfqKz9eZXP8vgP5BsgFAdHkekHWmS0VJX/ujjAFL
        8GASygV62lhrS/YND
X-Received: by 2002:a5d:4450:: with SMTP id x16mr2883716wrr.106.1583483486503;
        Fri, 06 Mar 2020 00:31:26 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtR1zARrU8iNkBiEiZb8J4A8aag/v5zIuXfO0iWMRBKkwC55n3uVDPg9HVxNOsBGVUm5F+Zug==
X-Received: by 2002:a5d:4450:: with SMTP id x16mr2883685wrr.106.1583483486205;
        Fri, 06 Mar 2020 00:31:26 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v14sm9374972wrr.34.2020.03.06.00.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 00:31:25 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3CB9418034F; Fri,  6 Mar 2020 09:31:23 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel abstraction
In-Reply-To: <7b674384-1131-59d4-ee2f-5a17824c1eca@iogearbox.net>
References: <87pndt4268.fsf@toke.dk> <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net> <ccbc1e49-45c1-858b-1ad5-ee503e0497f2@fb.com> <87k1413whq.fsf@toke.dk> <20200304043643.nqd2kzvabkrzlolh@ast-mbp> <87h7z44l3z.fsf@toke.dk> <20200304154757.3tydkiteg3vekyth@ast-mbp> <874kv33x60.fsf@toke.dk> <20200305163444.6e3w3u3a5ufphwhp@ast-mbp> <473a3e8a-03ea-636c-f054-3c960bf0fdbd@iogearbox.net> <20200305225027.nazs3gtlcw3gjjvn@ast-mbp> <7b674384-1131-59d4-ee2f-5a17824c1eca@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 06 Mar 2020 09:31:23 +0100
Message-ID: <878skd3mw4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 3/5/20 11:50 PM, Alexei Starovoitov wrote:
>> On Thu, Mar 05, 2020 at 11:34:18PM +0100, Daniel Borkmann wrote:
>>> On 3/5/20 5:34 PM, Alexei Starovoitov wrote:
>>>> On Thu, Mar 05, 2020 at 11:37:11AM +0100, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>>>>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>>>>> On Wed, Mar 04, 2020 at 08:47:44AM +0100, Toke H=C3=B8iland-J=C3=B8r=
gensen wrote:
>>> [...]
>>>>> Anyway, what I was trying to express:
>>>>>
>>>>>> Still that doesn't mean that pinned link is 'immutable'.
>>>>>
>>>>> I don't mean 'immutable' in the sense that it cannot be removed ever.
>>>>> Just that we may end up in a situation where an application can see a
>>>>> netdev with an XDP program attached, has the right privileges to modi=
fy
>>>>> it, but can't because it can't find the pinned bpf_link. Right? Or am=
 I
>>>>> misunderstanding your proposal?
>>>>>
>>>>> Amending my example from before, this could happen by:
>>>>>
>>>>> 1. Someone attaches a program to eth0, and pins the bpf_link to
>>>>>      /sys/fs/bpf/myprog
>>>>>
>>>>> 2. eth0 is moved to a different namespace which mounts a new sysfs at
>>>>>      /sys
>>>>>
>>>>> 3. Inside that namespace, /sys/fs/bpf/myprog is no longer accessible,=
 so
>>>>>      xdp-loader can't get access to the original bpf_link; but the XDP
>>>>>      program is still attached to eth0.
>>>>
>>>> The key to decide is whether moving netdev across netns should be allo=
wed
>>>> when xdp attached. I think it should be denied. Even when legacy xdp
>>>> program is attached, since it will confuse user space managing part.
>>>
>>> There are perfectly valid use cases where this is done already today (m=
inus
>>> bpf_link), for example, consider an orchestrator that is setting up the=
 BPF
>>> program on the device, moving to the newly created application pod duri=
ng
>>> the CNI call in k8s, such that the new pod does not have the /sys/fs/bp=
f/
>>> mount instance and if unprivileged cannot remove the BPF prog from the =
dev
>>> either. We do something like this in case of ipvlan, meaning, we attach=
 a
>>> rootlet prog that calls into single slot of a tail call map, move it to=
 the
>>> application pod, and only out of Cilium's own pod and it's pod-local bp=
f fs
>>> instance we manage the pinned tail call map to update the main programs=
 in
>>> that single slot w/o having to switch any netns later on.
>>=20
>> Right. You mentioned this use case before, but I managed to forget about=
 it.
>> Totally makes sense for prog to stay attached to netdev when it's moved.
>> I think pod manager would also prefer that pod is not able to replace
>> xdp prog from inside the container. It sounds to me that steps 1,2,3 abo=
ve
>> is exactly the desired behavior. Otherwise what stops some application
>> that started in a pod to override it?
>
> Generally, yes, and it shouldn't need to care nor see what is happening in
> /sys/fs/bpf/ from the orchestrator at least (or could potentially have its
> own private mount under /sys/fs/bpf/ or elsewhere). Ideally, the behavior
> should be that orchestrator does all the setup out of its own namespace,
> then moves everything over to the newly created target namespace and e.g.
> only if the pod has the capable(cap_sys_admin) permissions, it could mess
> around with anything attached there, or via similar model as done in [0]
> when there is a master device.

Yup, I can see how this can be a reasonable use case where you *would*
want the locking. However, my concern is that there should be a way for
an admin to recover from this (say, if it happens by mistake, or a
misbehaving application). Otherwise, I fear we'll end up with support
cases where the only answer is "try rebooting", which is obviously not
ideal.

> Last time I looked, there is a down/up cycle on the dev upon netns
> migration and it flushes e.g. attached qdiscs afaik, so there are
> limitations that still need to be addressed. Not sure atm if same is
> happening to XDP right now.

XDP programs will stay attached. devmaps (for redirect) have a notifier
that will remove devices when they move out of a namespace. Not sure if
there are any other issues with netns moves somewhere.

> In this regards veth devices are a bit nicer to work with since
> everything can be attached on hostns ingress w/o needing to worry on
> the peer dev in the pod's netns.

Presumably the XDP EGRESS hook that David Ahern is working on will make
this doable for XDP on veth as well?

-Toke

