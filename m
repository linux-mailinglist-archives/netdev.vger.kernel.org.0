Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34482BB192
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 18:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgKTRjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 12:39:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728820AbgKTRjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 12:39:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605893977;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k79nRRwuaLmMfVjEedZrAfuZMjECPDf1iyKjzsLMa9s=;
        b=D+OERA4qlQykMFDj7epUIZ+W2zBdhhW+rePM34FBoNXWglWr/Uupp4o5EA4XCV2RZU4Xfl
        +shk9KxwiRmx5DNpmRWwnUXFiMpqFl+k1jG7l/F2XCC0yhQckJOrARBQIq0New1iLL19g0
        ySOd3KnqsIOVVoA5Xs2gKsaVVbDQXYk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-gvgqJAMuOh6j1IZTR2cNXg-1; Fri, 20 Nov 2020 12:39:35 -0500
X-MC-Unique: gvgqJAMuOh6j1IZTR2cNXg-1
Received: by mail-qv1-f71.google.com with SMTP id u19so7682049qvx.4
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 09:39:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=k79nRRwuaLmMfVjEedZrAfuZMjECPDf1iyKjzsLMa9s=;
        b=Pjnd8+K7Bzdi+5z2ezRg/zPiP/wcN7v5p1DzMn5+hVMlJpv1InsMO1SZWrC0m6878B
         1mvpPT2VN9rgupumrIxmN7FiyWgkS9bj8lXVKmwha8qGRw4gaOYjDUh1PhHF6ly6dTsI
         3ID87eUC2ZTONda9PKNFVgDFogjj4VZ4iAar8aP4v1ZPFPWFZ+1rcObve7JaIHzFO9Kq
         /J17KuYGC4GSfpwqiWF8g5nXYtUUPNwiqWq1LAViqELD+BdUGDKlqGk9WVaDrUeGttbU
         2bet3J6XcmgxYdNQEhsBJe8YoZvo8DZ59Xgq6gNxbu+mLD6eVGeuTC7nyMGScd0v5YQN
         Cr9w==
X-Gm-Message-State: AOAM5326Wfvp3iC0LDqExCMcOyT8UEW9k7i8CBQUXApdSqMmhp7S9RfR
        +370F2BpjZszFAuEx7d5kfhMSsC0cfVKLZCdfVZgvvFmgzyiMay4YU9K4p3TgpURrJNPpVgoxS3
        gX3DAe6RWa/v3pdeQZcIfoDdmbifWmkB4
X-Received: by 2002:ad4:4e2f:: with SMTP id dm15mr16739064qvb.7.1605893975000;
        Fri, 20 Nov 2020 09:39:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzE2jexl6RMjRxH8DXU42xINL9zOavX3aTaG8dWKzC5C7AKjV+EUloodH5V5Rd3eEkUaSBcfw3MTYuI4TgcCvk=
X-Received: by 2002:ad4:4e2f:: with SMTP id dm15mr16739041qvb.7.1605893974801;
 Fri, 20 Nov 2020 09:39:34 -0800 (PST)
MIME-Version: 1.0
References: <20201119162527.GB9877@fuller.cnet> <CA+aaKfCMa1sOa6bMXFAaP6Wb=5ZgoAcnZAaP9aBmWwOzaAtcHw@mail.gmail.com>
In-Reply-To: <CA+aaKfCMa1sOa6bMXFAaP6Wb=5ZgoAcnZAaP9aBmWwOzaAtcHw@mail.gmail.com>
Reply-To: marcel@redhat.com
From:   Marcel Apfelbaum <mapfelba@redhat.com>
Date:   Fri, 20 Nov 2020 19:39:24 +0200
Message-ID: <CA+aaKfD_6qdNVRgr2TdDeuOau1UCFzRqWRB8iM-_GHV7mMrcsg@mail.gmail.com>
Subject: Re: [kuba@kernel.org: Re: [PATCH net-next v2 0/3] net: introduce rps_default_mask]
To:     Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+netdev
[Sorry for the second email, I failed to set the text-only mode]

On Fri, Nov 20, 2020 at 7:30 PM Marcel Apfelbaum <mapfelba@redhat.com> wrot=
e:
>
> Hi,
>
>>
>>
>> ---------- Forwarded message ----------
>> From: Jakub Kicinski <kuba@kernel.org>
>> To: Paolo Abeni <pabeni@redhat.com>
>> Cc: Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org, Jonathan =
Corbet <corbet@lwn.net>, "David S. Miller" <davem@davemloft.net>, Shuah Kha=
n <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kselftest@vger.kerne=
l.org, Marcelo Tosatti <mtosatti@redhat.com>, Daniel Borkmann <daniel@iogea=
rbox.net>
>> Bcc:
>> Date: Wed, 4 Nov 2020 11:42:26 -0800
>> Subject: Re: [PATCH net-next v2 0/3] net: introduce rps_default_mask
>> On Wed, 04 Nov 2020 18:36:08 +0100 Paolo Abeni wrote:
>> > On Tue, 2020-11-03 at 08:52 -0800, Jakub Kicinski wrote:
>> > > On Tue, 03 Nov 2020 16:22:07 +0100 Paolo Abeni wrote:
>> > > > The relevant use case is an host running containers (with the rela=
ted
>> > > > orchestration tools) in a RT environment. Virtual devices (veths, =
ovs
>> > > > ports, etc.) are created by the orchestration tools at run-time.
>> > > > Critical processes are allowed to send packets/generate outgoing, =
it gets a network-interface
>> > upstart job just as it does on a real host.
>> >
>> > > > network traffic - but any interrupt is moved away from the related
>> > > > cores, so that usual incoming network traffic processing does not
>> > > > happen there.
>> > > >
>> > > > Still an xmit operation on a virtual devices may be transmitted vi=
a ovs
>> > > > or veth, with the relevant forwarding operation happening in a sof=
tirq
>> > > > on the same CPU originating the packet.
>> > > >
>> > > > RPS is configured (even) on such virtual devices to move away the
>> > > > forwarding from the relevant CPUs.
>> > > >
>> > > > As Saeed noted, such configuration could be possibly performed via=
 some
>> > > > user-space daemon monitoring network devices and network namespace=
s
>> > > > creation. That will be anyway prone to some race: the orchestation=
 tool
>> > > > may create and enable the netns and virtual devices before the dae=
mon
>> > > > has properly set the RPS mask.
>> > > >
>> > > > In the latter scenario some packet forwarding could still slip in =
the
>> > > > relevant CPU, causing measurable latency. In all non RT scenarios =
the
>> > > > above will be likely irrelevant, but in the RT context that is not
>> > > > acceptable - e.g. it causes in real environments latency above the
>> > > > defined limits, while the proposed patches avoid the issue.
>> > > >
>> > > > Do you see any other simple way to avoid the above race?
>> > > >
>> > > > Please let me know if the above answers your doubts,
>> > >
>> > > Thanks, that makes it clearer now.
>> > >
>> > > Depending on how RT-aware your container management is it may or may=
 not
>> > > be the right place to configure this, as it creates the veth interfa=
ce.
>> > > Presumably it's the container management which does the placement of
>> > > the tasks to cores, why is it not setting other attributes, like RPS=
?
>
>
> The CPU isolation is done statically at system boot by setting Linux kern=
el parameters,
> So the container management component, in this case the Machine Configura=
tion Operator (for Openshift)
> or the K8s counterpart can't really help. (actually they would help if a =
global RPS mask would exist)
>
> I tried to tweak the rps_cpus mask using the container management stack, =
but there
> is no sane way to do it, please let me get a little into the details.
>
> The k8s orchestration component that deals with injecting the network dev=
ice(s) into the
> container is CNI, which is interface based and implemented by a lot of pl=
ugins, making it
> hardly feasible to go over all the existing plugins and change them. Also=
 what about
> the 3rd party ones?
>
> Writing a new CNI plugin and chain it into the existing one is also not a=
n option AFAIK,
> they work at the network level and do not have access to sysfs (they hand=
le the network namespaces).
> Even if it would be possible (I don't have a deep CNI understanding), it =
will require a cluster global configuration
> that is actually needed only for some of the cluster nodes.
>
> Another approach is to set the RPS configuration from the inside(of the c=
ontainer),
> but the /sys mount is read only for unprivileged containers, so we lose a=
gain.
>
> That leaves us with a host daemon hack:
> Since the virtual network devices are created in the host namespace and
> then "moved" into the container, we can listen to some udev event
> and write to the rps_cpus file after the virtual netdev is created and be=
fore
> it is moved (as stated above, the work is done by a CNI plugin implementa=
tion).
> That is of course extremely racy and not a valid solution.
>
>
>>
>> >
>> > The container orchestration is quite complex, and I'm unsure isolation
>> > and networking configuration are performed (or can be performed) by th=
e
>> > same precess (without an heavy refactor).
>> >
>> > On the flip hand, the global rps mask knob looked quite
>> > straightforward to me.
>>
>> I understand, but I can't shake the feeling this is a hack.
>>
>> Whatever sets the CPU isolation should take care of the RPS settings.
>
>
> Sadly it can't be done, please see above.
>
>>
>>
>> > Possibly I can reduce the amount of new code introduced by this
>> > patchset removing some code duplication
>> > between rps_default_mask_sysctl() and flow_limit_cpu_sysctl(). Would
>> > that make this change more acceptable? Or should I drop this
>> > altogether?
>>
>> I'm leaning towards drop altogether, unless you can get some
>> support/review tags from other netdev developers. So far it
>> appears we only got a down vote from Saeed.
>>
>
> Any solution that will allow the user space to avoid the
> network soft IRQs on specific CPUs would be welcome.
>
> The proposed global mask is a solution, maybe there other ways?
>
> Thanks,
> Marcel

