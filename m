Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E62512082A
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 15:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfLPOHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 09:07:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26273 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727916AbfLPOHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 09:07:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576505261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=drbKTmIeF4DHtRpcMrnxSn2S4ieQP2IV44CecCK7uVU=;
        b=Cw7wdGTI9JZgrFf4+JQlIPb6c56lXCPyx0uB8JTxDKNfWmNbbvOuuOyRmStCzsaJjIgX7D
        2wz/nY4EueNo6FKIxOm4GCBpl8FTu8y41KEtiRDEw4VmQJ9MVKYCNsEEJYMN83QKG9Ozpm
        TL5ih0YjJX+NRNguR2yc3zWIZ83+cVU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-mse-cJ3iNq-VDhio0UtHdg-1; Mon, 16 Dec 2019 09:07:40 -0500
X-MC-Unique: mse-cJ3iNq-VDhio0UtHdg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B71618557C6;
        Mon, 16 Dec 2019 14:07:38 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06B5D5C1D6;
        Mon, 16 Dec 2019 14:07:29 +0000 (UTC)
Date:   Mon, 16 Dec 2019 15:07:28 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Jubran, Samih" <sameehj@amazon.com>
Cc:     "Machulsky, Zorik" <zorik@amazon.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>, brouer@redhat.com,
        Alexei Starovoitov <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: XDP multi-buffer design discussion
Message-ID: <20191216150728.38c50822@carbon>
In-Reply-To: <ec2fd7f6da44410fbaeb021cf984f2f6@EX13D11EUC003.ant.amazon.com>
References: <BA8DC06A-C508-402D-8A18-B715FBA674A2@amazon.com>
        <b28504a3-4a55-d302-91fe-63915e4568d3@iogearbox.net>
        <5FA3F980-29E6-4B91-8150-9F28C0E09C45@amazon.com>
        <20190823084704.075aeebd@carbon>
        <67C7F66A-A3F7-408F-9C9E-C53982BCCD40@amazon.com>
        <20191204155509.6b517f75@carbon>
        <ec2fd7f6da44410fbaeb021cf984f2f6@EX13D11EUC003.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


See answers inlined below (please get an email client that support
inline replies... to interact with this community)

On Sun, 15 Dec 2019 13:57:12 +0000
"Jubran, Samih" <sameehj@amazon.com> wrote:

> I am currently working on writing a design document for the XDP multi
> buff and I am using your proposal as a base.=20

[Base-doc]: https://github.com/xdp-project/xdp-project/blob/master/areas/co=
re/xdp-multi-buffer01-design.org

I will really appreciate if you can write your design document in a
text-based format, and that this can be included in the XDP-project
git-repo.  If you don't want to update the existing document
xdp-multi-buffer01-design.org, I suggest that you instead create
xdp-multi-buffer02-design.org to layout your design proposal.

That said, don't write a huge document... instead interact with
netdev@vger.kernel.org as early as possible, and then update the design
doc with the input you get.  Lets start it now... Cc'ing netdev as this
discussion should also be public.


> I have few questions in mind that weren't addressed in your draft and
> it would be great if you share your thoughts on them.
>=20
> * Why should we provide the fragments to the bpf program if the
> program doesn't access them? If validating the length is what
> matters, we can provide only the full length info to the user with no
> issues.

My Proposal#1 (in [base-doc]) is that XDP only get access to the
first-buffer.  People are welcome to challenge this choice.

There are a several sub-questions and challenges hidden inside this
choice.

As you hint, the total length... spawns some questions we should answer:

 (1) is it relevant to the BPF program to know this, explain the use-case.

 (2) if so, how does BPF prog access info (without slowdown baseline)

 (3) if so, implies driver need to collect frags before calling bpf_prog
    (this influence driver RX-loop design).


> * In case we do need the fragments, should they be modifiable
> (Without helpers) by the xdp developer?=20

It is okay to think about, how we can give access to fragments in the
future. But IMHO we should avoid going too far down that path...
If we just make sure we can extend it later, then it should be enough.


> * What about data_end? I believe it should point to the end of the
> first buffer, correct?

Yes, because this is part of BPF-verifier checks.


> * Should the kernel indicate to the driver somehow that it supports
> multi buf? I suppose this shouldn't be an issue unless somehow the
> patches were back patched to old kernels.
>=20

The other way around.  The driver need to indicate to kernel that is
supports/enabled XDP multi-buffer.  This feature "indication" interface
is unfortunately not available today...

The reason this is needed: the BPF-helper bpf_xdp_adjust_tail() is
allowed to modify xdp_buff->data_end (as also desc in [base-doc]).
Even-though this is only shrink, then it seems very wrong to
change/shrink the first-fragment.

IMHO the BPF-loader (or XDP-attach) should simply reject programs using
bpf_xdp_adjust_tail() on a driver that have enabled XDP-multi-buffer.
This basically also happens today, if trying to attach XDP on a NIC
with large MTU (that requires >=3D two pages).

--Jesper



> > -----Original Message-----
> > From: Jesper Dangaard Brouer <brouer@redhat.com>
> > Sent: Wednesday, December 4, 2019 4:55 PM
> > To: Machulsky, Zorik <zorik@amazon.com>
> > Cc: Daniel Borkmann <borkmann@iogearbox.net>; David Miller
> > <davem@davemloft.net>; Jubran, Samih <sameehj@amazon.com>; Tzalik,
> > Guy <gtzalik@amazon.com>; brouer@redhat.com; Ilias Apalodimas
> > <ilias.apalodimas@linaro.org>; Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com>
> > Subject: Re: XDP_TX in ENA
> >=20
> > On Mon, 2 Dec 2019 08:17:08 +0000
> > "Machulsky, Zorik" <zorik@amazon.com> wrote:
> >  =20
> > > Hi Jesper,
> > >
> > > Just wanted to inform you that Samih (cc-ed) started working on
> > > multi-buffer packets support. I hope it will be OK to reach out to
> > > this forum in case there will be questions during this work. =20
> >=20
> > Great to hear that you are continuing the work.
> >=20
> > I did notice the patchset ("Introduce XDP to ena") from Sameeh, but net-
> > next is currently closed.  I will appreciate if you can Cc both me
> > (brouer@redhat.com) and Ilias Apalodimas <ilias.apalodimas@linaro.org>.
> >=20
> > Ilias have signed up for doing driver XDP reviews.
> >=20
> > --Jesper
> >=20
> >  =20
> > > =EF=BB=BFOn 8/22/19, 11:47 PM, "Jesper Dangaard Brouer" <brouer@redha=
t.com> =20
> > wrote: =20
> > >
> > >     Hi Zorik,
> > >
> > >     How do you plan to handle multi-buffer packets (a.k.a jumbo-frame=
s, and =20
> > >     more)?
> > >
> > >     Most drivers, when XDP gets loaded, just limit the MTU and disabl=
e TSO
> > >     (notice GRO in software is still done). Or reject XDP loading if
> > >     MTU > 3520 or TSO is enabled.
> > >
> > >     You seemed to want XDP multi-buffer support.  For this to happen
> > >     someone needs to work on this.  I've written up a design proposal
> > >     here[1], but I don't have time to work on this... Can you allocate
> > >     resources to work on this?
> > >
> > >     [1] https://github.com/xdp-project/xdp-project/blob/master/areas/=
core/xdp-multi-buffer01-design.org
> > >
> > >     --Jesper
> > >     (top-post as your email client seems to be challenged ;-))


--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

