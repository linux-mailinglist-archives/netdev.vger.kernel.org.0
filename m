Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6072AF417
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 15:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgKKOxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 09:53:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727161AbgKKOxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 09:53:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605106398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l5bQ1RwzCeGmlnbRjY4ysxqA1EJK+QA8oSw+5t0ycLQ=;
        b=fzGu2EZ1xz/WLsUy4aqdn/mn5XT5kRfBfR15S9ujgDdLkdZSzj1eT2+N3C6FBs81fIy8cl
        Pag60pyCGpEM6Lp6+uVV2z2gojPHcpxUb62H4sOf1QqawwWrETYpIWgAp2fZ1l9uNtXPY3
        ozjxmRM7Tih5Mg89HBuUYGK9PqPAGm4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-yRbXGUrgNFepVc-q5N_t2g-1; Wed, 11 Nov 2020 09:53:13 -0500
X-MC-Unique: yRbXGUrgNFepVc-q5N_t2g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49668802EDA;
        Wed, 11 Nov 2020 14:53:11 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E164860CD0;
        Wed, 11 Nov 2020 14:53:08 +0000 (UTC)
Date:   Wed, 11 Nov 2020 15:53:07 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Patel, Vedang" <vedang.patel@intel.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     brouer@redhat.com, Saeed Mahameed <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Guedes, Andre" <andre.guedes@intel.com>
Subject: Re: Hardware time stamping support for AF_XDP applications
Message-ID: <20201111155307.4d0171a5@carbon>
In-Reply-To: <65418F25-1795-4FF7-AB04-8DE78F0C8BF5@intel.com>
References: <7299CEB5-9777-4FE4-8DEE-32EF61F6DA29@intel.com>
        <6af7754d5bcba7a7f7d92dc43e1f4206ce470c79.camel@kernel.org>
        <65418F25-1795-4FF7-AB04-8DE78F0C8BF5@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 23:53:41 +0000
"Patel, Vedang" <vedang.patel@intel.com> wrote:

> Hi Saeed,=20
>=20
> > On Nov 10, 2020, at 3:32 PM, Saeed Mahameed <saeed@kernel.org> wrote:
> >=20
> > On Tue, 2020-11-10 at 22:44 +0000, Patel, Vedang wrote: =20
> >> [Sorry if you got the email twice. Resending because it was rejected
> >> by netdev for containing HTML]
> >>=20
> >> Hi Saeed/Jesper,=20
> >>=20
> >> I am working in the Time Sensitive Networking team at Intel. We work
> >> on implementing and upstreaming support for TSN related features for
> >> intel based NICs. Recently we have been adding support for XDP in
> >> i225. One of the features which we want to add support for is passing
> >> the hardware timestamp information to the userspace application
> >> running AF_XDP sockets (for both Tx and Rx). I came across the XDP
> >> Workshop[1] conducted in July 2020 and there you stated that you are
> >> already working on adding support for BTF based metadata to pass
> >> hardware hints for XDP Programs. My understanding (along with a few
> >> questions) of the current state is: =20

Have the i225 XDP support been upstreamed?

Can I buy a i255 NIC for my server, or is this embedded NICs?

Ilias have played with PoC for TSN (on ARM) here:
 https://github.com/xdp-project/xdp-project/blob/master/areas/arm64/xdp_for=
_tsn.org

> > Hi Patel,
> >  =20
> >> * This feature is currently being maintained out of tree. I found
> >> that an RFC Series[2] was posted in June 2018. Are you planning to
> >> post an updated version to be merged in the mainline anytime soon?  =20
> >=20
> > Yes hopefully in the coming couple of weeks.
> >  =20
>
> Sure! I will start testing/developing on top of your branch mentioned
> below for now.

I've also signed up for helping out on this effort.  Notice Andrii (cc)
have already pointed out something that can be improved, and even made
easier.


> >> * I am guessing hardware timestamp is one of the metadata fields
> >> which will be eventually supported? [3] =20
> >=20
> > With BTF formatted metadata it is up to the driver to advertise
> > whatever it can/want :)
> > so yes. =20
>
> I have a very basic question here. From what I understand about BTF,
> I can generate a header file (using bpftool?) containing the BTF data
> format provided by the driver. If so, how can I design an application
> which can work with multiple NICs drivers without recompilation? I am
> guessing there is some sort of =E2=80=9Cmaster list=E2=80=9D of HW hints =
the drivers
> will agree upon?

I recommend that you read Andrii's blogpost:
 https://facebookmicrosites.github.io/bpf/blog/2020/02/19/bpf-portability-a=
nd-co-re.html

I need to learn more about BTF myself, but the way I understand this:
We need to agree on the meaning of struct member names (e.g. rxhash32).
Then you compile BPF with a BTF struct that have this rxhash32 member
name, and at BPF load-time the kernel CO-RE infra will remap the offset
to the rxhash32 offset used by the specific driver.

> >  =20
> >> * The Metadata support will be extended to pass on the hardware hints
> >> to AF_XDP sockets. Are there any rough plans on what metadata will be
> >> transferred? =20
> >=20
> > AF_XDP is not part of my series, but supporting AF_XDP with metadata
> > offlaod is up to the driver to implement, should be straight forward
> > and identical to XDP.

The XDP data_meta area is also transferred into the AF_XDP frame, also
in the copy-mode version of AF_XDP.


> > what meta data to pass is up to the driver. =20
>
> Alright, let me take a closer look at your latest code. I will come
> back will questions if I have any.
> >=20
> >  =20
> >> * The current plan for Tx side only includes passing data from the
> >> application to the driver. Are there any plans to support passing
> >> information (like HW TX timestamp) from driver to the Application?
> >>  =20
> >=20
> > you mean for AF_XDP ? i actually haven't thought about this,=20
> > but we could use TX umem packet buffer headroom to pass TX completion
> > metadata to AF_XDP app, or extend the completion queue entries to host
> > metadata, i am sure that the 1st approach is preferred, but i am not
> > planing to support this in my initial series.=20
> >  =20
> Yeah, I was thinking of using approach 1 as well for this. Let me
> first work on the Rx side. Then we can scope this one out.
>
> >> Finally, is there any way I can help in expediting the development
> >> and upstreaming of this feature? I have been working on studying how
> >> XDP works and can work on implementing some part of this feature if
> >> you would like.
> >>  =20
> >=20
> > Sure,
> > Please feel free to clone and test the following branch if you add
> > support to  your driver and implement offloads for AF_XDP that would be
> > awesome, and i will append your patches to my series before submission.
> >=20
> > it is always great to send new features with multiple use cases and
> > multi vendor support, this will differently expedite submission and
> > acceptance
> >=20
> > My Latest work can be found at:
> >=20
> > https://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git/log/?h=
=3Dtopic/xdp_metadata3
> >=20
> > Please feel free to send me any questions about the code in private or
> > public.
>
> Thanks Saeed for all the information! This is really helpful. :)
> >=20
> > Thanks,
> > Saeed.
> >  =20
> >> Thanks,
> >> Vedang Patel
> >> Software Engineer
> >> Intel Corporation
> >>=20
> >> [1] - https://netdevconf.info/0x14/session.html?workshop-XDP
> >> [2] -=20
> >> https://patchwork.ozlabs.org/project/netdev/cover/20180627024615.17856=
-1-saeedm@mellanox.com/
> >> [3] -=20
> >> https://xdp-project.net/#outline-container-Important-medium-term-tasks=
 =20
>=20



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

