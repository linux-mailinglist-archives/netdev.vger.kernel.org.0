Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2E2DE4098
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 02:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730752AbfJYA2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 20:28:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50575 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728445AbfJYA2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 20:28:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571963297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u/ZOKafSqcbNjqFdVZXED/KJXRu4OrJLpD9UUq91aWI=;
        b=SMp3ZpI5ar/bAtyGT1SHFnpN7PAvHCa7qdb3grBS77MWuLkRIlzbwbtC8U9YW7Ci8uaVH1
        mslVVlVfXewOqnnJXTi8cegffA2Igu1IU+jp5VugcJHii1VYG4H0kQSGBDVn/xh/6LsAdW
        XqVmhfssZgbFNL+sTPW9KV1fMwXfPEE=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-Gbj-evKwO7Gl0nJZfPYZ5A-1; Thu, 24 Oct 2019 20:28:07 -0400
Received: by mail-lf1-f72.google.com with SMTP id d11so115002lfj.3
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 17:28:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f/h48WimOkxwuWTFiUpPnQ+AjLWqpj9bNjA3x7P2LxY=;
        b=PerPOmR+QwCo8r8c9uqWFRMZlZFUGwgTC5euh/T4mA+NkecNLwyVwDSJkTW5GTBgEd
         9xGdrpLLBnxDoeg757Wc5PSmstRnwR0hfHghCk8vkLBBV1yj8KXSeoPuLN52R8RXcCjt
         TrRwqlGzNXT9z1s9pj6UAPeUrICq4Th1UNpzbdpf+oR5aJCo9n9EGX1+7zeakmJWczTZ
         qQ9Pt0HFCVAFaa26qTKzmoJ+YNpRGfxQMYHW6ruVlhIa9kku3eWQF65COff9Wkwu3flP
         SspD3evPV1d8IXUXhsAPtvte4/4p+wsS2eIS3Q+Yce+B6iLSWMz8eXWcP6imB3o0FEAx
         DJ5Q==
X-Gm-Message-State: APjAAAUPs26LFzt1cN6CEywjF8EGjzRNRFM32qYASVrGTfW9CI/8tS8N
        rrwqQUqf5zkvZ364og7lF1K+dg6OSUdyq47wqKZOqRGXmPvrRA+Hn0jCFvJChRaqcY3BAQ9WF9y
        8uVA53jyb3i+bqPICsi6uLbjm9PFiyP8Q
X-Received: by 2002:a19:22c4:: with SMTP id i187mr501155lfi.152.1571963286002;
        Thu, 24 Oct 2019 17:28:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqym7fXeLAILTlm6k1G46RUJImDXCll6Wg9ol9S+dM0yK8R9moFI+ZU3df0ukjTnsrZDz4UD/s6A4arXkCsnm3c=
X-Received: by 2002:a19:22c4:: with SMTP id i187mr501098lfi.152.1571963284768;
 Thu, 24 Oct 2019 17:28:04 -0700 (PDT)
MIME-Version: 1.0
References: <20191021200948.23775-1-mcroce@redhat.com> <20191021200948.23775-4-mcroce@redhat.com>
 <20191023100009.GC8732@netronome.com> <CAGnkfhxg1sXkmiNS-+H184omQaKbp_+_Sy7Vi-9W9qLwGGPU6g@mail.gmail.com>
 <20191023175522.GB28355@netronome.com>
In-Reply-To: <20191023175522.GB28355@netronome.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 25 Oct 2019 02:27:28 +0200
Message-ID: <CAGnkfhyEB0JU7LPZfYxHiKkryrkzoOs3Krumt1Lph+Q=qx1s8A@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] flow_dissector: extract more ICMP information
To:     Simon Horman <simon.horman@netronome.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>
X-MC-Unique: Gbj-evKwO7Gl0nJZfPYZ5A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 7:55 PM Simon Horman <simon.horman@netronome.com> w=
rote:
>
> On Wed, Oct 23, 2019 at 12:53:37PM +0200, Matteo Croce wrote:
> > On Wed, Oct 23, 2019 at 12:00 PM Simon Horman
> > <simon.horman@netronome.com> wrote:
> > > On Mon, Oct 21, 2019 at 10:09:47PM +0200, Matteo Croce wrote:
> > > > +     switch (ih->type) {
> > > > +     case ICMP_ECHO:
> > > > +     case ICMP_ECHOREPLY:
> > > > +     case ICMP_TIMESTAMP:
> > > > +     case ICMP_TIMESTAMPREPLY:
> > > > +     case ICMPV6_ECHO_REQUEST:
> > > > +     case ICMPV6_ECHO_REPLY:
> > > > +             /* As we use 0 to signal that the Id field is not pre=
sent,
> > > > +              * avoid confusion with packets without such field
> > > > +              */
> > > > +             key_icmp->id =3D ih->un.echo.id ? : 1;
> > >
> > > Its not obvious to me why the kernel should treat id-zero as a specia=
l
> > > value if it is not special on the wire.
> > >
> > > Perhaps a caller who needs to know if the id is present can
> > > check the ICMP type as this code does, say using a helper.
> > >
> >
> > Hi,
> >
> > The problem is that the 0-0 Type-Code pair identifies the echo replies.
> > So instead of adding a bool is_present value I hardcoded the info in
> > the ID field making it always non null, at the expense of a possible
> > collision, which is harmless.
>
> Sorry, I feel that I'm missing something here.
>
> My reading of the code above is that for the cased types above
> (echo, echo reply, ...) the id is present. Otherwise it is not.
> My idea would be to put a check for those types in a helper.
>

Something like icmp_has_id(), I like it.

> I do agree that the override you have used is harmless enough
> in the context of the only user of the id which appears in
> the following patch of this series.
>
>
> Some other things I noticed in this patch on a second pass:
>
> * I think you can remove the icmp field from struct flow_dissector_key_po=
rts
>

You mean flow_dissector_key_icmp maybe?

> * I think that adding icmp to struct flow_keys should be accompanied by
>   adding ICMP to flow_keys_dissector_symmetric_keys. But I think this is
>   not desirable outside of the bonding use-case and rather
>   the bonding driver should define its own structures that
>   includes the keys it needs - basically copies of struct flow_keys
>   and flow_keys_dissector_symmetric_keys with some modifications.
>

Just flow_keys_dissector_symmetric_keys or flow_keys_dissector_keys too?
Anyway, it seems that the bonding uses the flow_dissector only when
using encap2+3 or encap3+4 hashing, which means decap some known
tunnels (mpls and gre and pppoe I think).
For the other modes it just uses iph_to_flow_copy_v{4,6}addrs() and
skb_flow_get_ports(), so maybe we can avoid copying that structure.

> * Modifying flow_keys_have_l4 affects the behaviour of
>   skb_get_hash_flowi6() but there is not a corresponding update
>   to flow_keys_have_l4(). I didn't look at all the other call sites
>   but it strikes me that this is a) a wide-spread behavioural change
>   and b) is perhaps not required for the bond-use case.

Right, no need to alter flow_keys_have_l4() at all.

I'll send a v2 with those suggestions.

Thanks,
--
Matteo Croce
per aspera ad upstream

