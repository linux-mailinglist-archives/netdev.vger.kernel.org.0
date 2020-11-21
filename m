Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE4D2BBD70
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 06:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgKUFjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 00:39:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32040 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbgKUFjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 00:39:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605937159;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xENM7tt6/BDscE51yBedRq8lEPjdWgxJMWQR4dV6MkM=;
        b=HoTG8Sl1HQTGBjGcrnMqPiQodvw0ZngNm8825hojUuVOL0eQwfFeAuuOzu3QsIc+CE5rOR
        q/unxJ94Vx3xUJ0IjQqNsA4izlwl/30xhCV+kovuNnRuAgz/HqEhIiBcByS29xdHD3rxKU
        4WPGd7sGzk1F/n7b844eed75UAfFBEk=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-6AUQQfaDPui-ILLWuHpSrw-1; Sat, 21 Nov 2020 00:39:16 -0500
X-MC-Unique: 6AUQQfaDPui-ILLWuHpSrw-1
Received: by mail-qk1-f198.google.com with SMTP id 141so9781462qkh.18
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 21:39:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=xENM7tt6/BDscE51yBedRq8lEPjdWgxJMWQR4dV6MkM=;
        b=I0H44vY8vVQYMPE6oarA6vWl6y8T+4Jx7RF8ewx1claM1W/mRw6Q3THlkPoFWzlOa9
         rjMtYyDvuaM9p9cc/HppFgSGz+eEAa7FSFBg9Drw1ykTVgL+/veoBP//rUc9heEW4Nqq
         RQW1lrY8Zcx5Jbbru1HqhC4wmHzha1f2yKhSci0+aZ5Z8nx7XKf75zHvHi05Ey5SzuCC
         OeMOQDq06+9Yj4/skvBFezfMIBp5W1XUD/Pn9o4kSwPXop9rSoTx8ruW9sc55oItz7i4
         wOEM8gaNVx5NfNA7wKYkEg1hAWBEbUhijAyoSJ6OkQ3FnZ3DiSZlZVaSJ8AaEAFnCkCm
         nVwA==
X-Gm-Message-State: AOAM531wjMwRQnmvKbKuJAN8R/wePCXWwujhKAMaXHdbiFRkMNcoE/oy
        B1gTSEY7b4SZ5DuFcB4UgLJ/FxrJcT6vbVwOJHP8wB+xZiirula1JYyjk+AWetmTtaIXuJ0IvQB
        DCU19wBb9Wd8Yo2yvu+HokYO5uVi4FsNH
X-Received: by 2002:a05:620a:2296:: with SMTP id o22mr19693702qkh.143.1605937156186;
        Fri, 20 Nov 2020 21:39:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy3kCXM1Gi3g5rnPV1w8+wg/ljCB92BuZRpkbzRMbG7pS7AhRsbEXvsrVAhSfX5cCYQtUHeUHJcPyeleEDJ+DY=
X-Received: by 2002:a05:620a:2296:: with SMTP id o22mr19693688qkh.143.1605937155982;
 Fri, 20 Nov 2020 21:39:15 -0800 (PST)
MIME-Version: 1.0
References: <20201119162527.GB9877@fuller.cnet> <CA+aaKfCMa1sOa6bMXFAaP6Wb=5ZgoAcnZAaP9aBmWwOzaAtcHw@mail.gmail.com>
 <CA+aaKfD_6qdNVRgr2TdDeuOau1UCFzRqWRB8iM-_GHV7mMrcsg@mail.gmail.com> <6e43ea1e-b166-f60e-9dd1-e907108a3b12@iogearbox.net>
In-Reply-To: <6e43ea1e-b166-f60e-9dd1-e907108a3b12@iogearbox.net>
Reply-To: marcel@redhat.com
From:   Marcel Apfelbaum <mapfelba@redhat.com>
Date:   Sat, 21 Nov 2020 07:39:04 +0200
Message-ID: <CA+aaKfBy0TOd6J2=8X5rY+ky2LnxYyZjpPjqYCZoU8bEsbDMRQ@mail.gmail.com>
Subject: Re: [kuba@kernel.org: Re: [PATCH net-next v2 0/3] net: introduce rps_default_mask]
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Marcel Apfelbaum <marcel@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Fri, Nov 20, 2020 at 11:56 PM Daniel Borkmann <daniel@iogearbox.net> wro=
te:
>
> On 11/20/20 6:39 PM, Marcel Apfelbaum wrote:
> > +netdev
> > [Sorry for the second email, I failed to set the text-only mode]
> > On Fri, Nov 20, 2020 at 7:30 PM Marcel Apfelbaum <mapfelba@redhat.com> =
wrote:
> [...]
> >>> ---------- Forwarded message ----------
> >>> From: Jakub Kicinski <kuba@kernel.org>
> >>> To: Paolo Abeni <pabeni@redhat.com>
> >>> Cc: Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org, Jonath=
an Corbet <corbet@lwn.net>, "David S. Miller" <davem@davemloft.net>, Shuah =
Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kselftest@vger.ke=
rnel.org, Marcelo Tosatti <mtosatti@redhat.com>, Daniel Borkmann <daniel@io=
gearbox.net>
> >>> Bcc:
> >>> Date: Wed, 4 Nov 2020 11:42:26 -0800
> >>> Subject: Re: [PATCH net-next v2 0/3] net: introduce rps_default_mask
> >>> On Wed, 04 Nov 2020 18:36:08 +0100 Paolo Abeni wrote:
> >>>> On Tue, 2020-11-03 at 08:52 -0800, Jakub Kicinski wrote:
> >>>>> On Tue, 03 Nov 2020 16:22:07 +0100 Paolo Abeni wrote:
> >>>>>> The relevant use case is an host running containers (with the rela=
ted
> >>>>>> orchestration tools) in a RT environment. Virtual devices (veths, =
ovs
> >>>>>> ports, etc.) are created by the orchestration tools at run-time.
> >>>>>> Critical processes are allowed to send packets/generate outgoing, =
it gets a network-interface
> >>>> upstart job just as it does on a real host.
> >>>>
> >>>>>> network traffic - but any interrupt is moved away from the related
> >>>>>> cores, so that usual incoming network traffic processing does not
> >>>>>> happen there.
> >>>>>>
> >>>>>> Still an xmit operation on a virtual devices may be transmitted vi=
a ovs
> >>>>>> or veth, with the relevant forwarding operation happening in a sof=
tirq
> >>>>>> on the same CPU originating the packet.
> >>>>>>
> >>>>>> RPS is configured (even) on such virtual devices to move away the
> >>>>>> forwarding from the relevant CPUs.
> >>>>>>
> >>>>>> As Saeed noted, such configuration could be possibly performed via=
 some
> >>>>>> user-space daemon monitoring network devices and network namespace=
s
> >>>>>> creation. That will be anyway prone to some race: the orchestation=
 tool
> >>>>>> may create and enable the netns and virtual devices before the dae=
mon
> >>>>>> has properly set the RPS mask.
> >>>>>>
> >>>>>> In the latter scenario some packet forwarding could still slip in =
the
> >>>>>> relevant CPU, causing measurable latency. In all non RT scenarios =
the
> >>>>>> above will be likely irrelevant, but in the RT context that is not
> >>>>>> acceptable - e.g. it causes in real environments latency above the
> >>>>>> defined limits, while the proposed patches avoid the issue.
> >>>>>>
> >>>>>> Do you see any other simple way to avoid the above race?
> >>>>>>
> >>>>>> Please let me know if the above answers your doubts,
> >>>>>
> >>>>> Thanks, that makes it clearer now.
> >>>>>
> >>>>> Depending on how RT-aware your container management is it may or ma=
y not
> >>>>> be the right place to configure this, as it creates the veth interf=
ace.
> >>>>> Presumably it's the container management which does the placement o=
f
> >>>>> the tasks to cores, why is it not setting other attributes, like RP=
S?
> >>
> >> The CPU isolation is done statically at system boot by setting Linux k=
ernel parameters,
> >> So the container management component, in this case the Machine Config=
uration Operator (for Openshift)
> >> or the K8s counterpart can't really help. (actually they would help if=
 a global RPS mask would exist)
> >>
> >> I tried to tweak the rps_cpus mask using the container management stac=
k, but there
> >> is no sane way to do it, please let me get a little into the details.
> >>
> >> The k8s orchestration component that deals with injecting the network =
device(s) into the
> >> container is CNI, which is interface based and implemented by a lot of=
 plugins, making it
> >> hardly feasible to go over all the existing plugins and change them. A=
lso what about
> >> the 3rd party ones?
> >>
> >> Writing a new CNI plugin and chain it into the existing one is also no=
t an option AFAIK,
> >> they work at the network level and do not have access to sysfs (they h=
andle the network namespaces).
> >> Even if it would be possible (I don't have a deep CNI understanding), =
it will require a cluster global configuration
> >> that is actually needed only for some of the cluster nodes.
>
> CNI chaining would be ugly, agree, but in a typical setting you'd have th=
e CNI plugin
> itself which is responsible to set up the Pod for communication to the ou=
tside world;
> part of it would be creation of devices and moving them into the target n=
etns, and
> then you also typically have an agent running in kube-system namespace in=
 the hostns
> to which the CNI plugin talks to via IPC e.g. to set up IPAM and other st=
ate. Such
> agent usually sets up all sort of knobs for the networking layer upon boo=
tstrap.

The main issue is that CNI is networking related, but the way to set
the RPS is by writing to /sys which is not considered network namespace
related and is read only inside the containers.

> Assuming you have a cluster where only some of the nodes have RT kernel, =
these would
> likely have special node annotations in K8s so you could select them to r=
un certain
> workloads on it.. couldn't such agent be taught to be RT-aware and set up=
 all the
> needed knobs?

I do agree this part may be doable, sadly is by far not the biggest problem=
.

> Agree it's a bit ugly to change the relevant CNI plugins to be RT-aware,
> but what if you also need other settings in future aside from RPS mask fo=
r RT? At some
> point you'd likely end up having to extend these anyway, no?
>

All networking changes are fair play, however setting the RPS mask
is related to networking but not a networking operation per se - is a
cross-domain operation (network namespace/mount namespace).

Thank you for your response,
Marcel

[...]

