Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 678ABE53C7
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388758AbfJYSZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:25:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32694 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730910AbfJYSZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 14:25:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572027905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gpL0tiZ7ZvTpKHYqeVvtPVaneT6iyxgClaTwMuQnmiY=;
        b=B1dD3S04DTromfKmu65Ahd4t7SLbF1TjXgyGffRhOnw+gtw/6ODs/f/nAboUoZbgrrlVzd
        ZYxZgMfgNbuJv7OE4HgGqYNjW0e1nmxILUF7Yp/A3rLnwbYbpmViAz9OCX69GbSlF+joGk
        90dw5iuNfSKgH8wvFZ76k6+kk/XD2KE=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-DxOtNQW8N3SK1pXjJFg-gg-1; Fri, 25 Oct 2019 14:24:58 -0400
Received: by mail-lf1-f69.google.com with SMTP id n26so735176lfe.17
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 11:24:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hwxwHUFldaHiw/ve54tXNOQDx8dDdKblWoTuR69Lalw=;
        b=LGQ585cj0tVvaaJxmZY767Ej2t+I35IUGthekkPgHMaeudUesMJBN8mx0Ox6G/iCCr
         aVHNZZorgECOGoGsSfwNTgYV28j6YqzRcMUpNMg9yB41+uWYAEb2bkuzZSsFZprnR6OO
         LqXLF1NbfKFr5Dp4n7rEPAzrlLU10FVW15VWbDH7HXmq2+r60mP6o+vX541xE5VluxN4
         bU1QuOt4ah4NwJNTDu8+Hc70D1LNhUS+2urY0CFtZEx5OzP9mvzH5cJoKA05oGh3iYZd
         ynJw9ZWSgRKm34bYOZjeeTkV/ZAm7sygEKa63vk9zcgG7cwmIJvGg8CT7u2ljvdqrAS+
         Jjmw==
X-Gm-Message-State: APjAAAVpH5cihRblmIkRSTuZSEWHVTei+N2eqM6F5p/W6o9yIpz6wcey
        qHXRDWvYv6ySb1nNXcOsb47E2CWE+WhEVUclmDCpSGBsgEQnoDLR6Rtlyu2Vr3qwYOcRF637ZVX
        XnY7/dn0W7iqV7nv0UHKR39t/2yDwcSyu
X-Received: by 2002:ac2:4184:: with SMTP id z4mr3703644lfh.46.1572027897094;
        Fri, 25 Oct 2019 11:24:57 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxcroZ7ZQWfAsvw9a2WpzbkAKx1Fn+m841z70yrgS7cNmUSNV2kwxLR3+SrAmYg1l3UTcg5snxJpTe/BNhaIl8=
X-Received: by 2002:ac2:4184:: with SMTP id z4mr3703622lfh.46.1572027896700;
 Fri, 25 Oct 2019 11:24:56 -0700 (PDT)
MIME-Version: 1.0
References: <20191021200948.23775-1-mcroce@redhat.com> <20191021200948.23775-4-mcroce@redhat.com>
 <20191023100009.GC8732@netronome.com> <CAGnkfhxg1sXkmiNS-+H184omQaKbp_+_Sy7Vi-9W9qLwGGPU6g@mail.gmail.com>
 <20191023175522.GB28355@netronome.com> <CAGnkfhyEB0JU7LPZfYxHiKkryrkzoOs3Krumt1Lph+Q=qx1s8A@mail.gmail.com>
 <20191025062856.GB7325@netronome.com>
In-Reply-To: <20191025062856.GB7325@netronome.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 25 Oct 2019 20:24:20 +0200
Message-ID: <CAGnkfhzN=P+j5n3A2RrRTseHgqMU1-5CsRd8xonZ2mLBtNoJ_g@mail.gmail.com>
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
X-MC-Unique: DxOtNQW8N3SK1pXjJFg-gg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 8:29 AM Simon Horman <simon.horman@netronome.com> w=
rote:
>
> On Fri, Oct 25, 2019 at 02:27:28AM +0200, Matteo Croce wrote:
> > On Wed, Oct 23, 2019 at 7:55 PM Simon Horman <simon.horman@netronome.co=
m> wrote:
> > >
> > > On Wed, Oct 23, 2019 at 12:53:37PM +0200, Matteo Croce wrote:
> > > > On Wed, Oct 23, 2019 at 12:00 PM Simon Horman
> > > > <simon.horman@netronome.com> wrote:
> > > > > On Mon, Oct 21, 2019 at 10:09:47PM +0200, Matteo Croce wrote:
> > > > > > +     switch (ih->type) {
> > > > > > +     case ICMP_ECHO:
> > > > > > +     case ICMP_ECHOREPLY:
> > > > > > +     case ICMP_TIMESTAMP:
> > > > > > +     case ICMP_TIMESTAMPREPLY:
> > > > > > +     case ICMPV6_ECHO_REQUEST:
> > > > > > +     case ICMPV6_ECHO_REPLY:
> > > > > > +             /* As we use 0 to signal that the Id field is not=
 present,
> > > > > > +              * avoid confusion with packets without such fiel=
d
> > > > > > +              */
> > > > > > +             key_icmp->id =3D ih->un.echo.id ? : 1;
> > > > >
> > > > > Its not obvious to me why the kernel should treat id-zero as a sp=
ecial
> > > > > value if it is not special on the wire.
> > > > >
> > > > > Perhaps a caller who needs to know if the id is present can
> > > > > check the ICMP type as this code does, say using a helper.
> > > > >
> > > >
> > > > Hi,
> > > >
> > > > The problem is that the 0-0 Type-Code pair identifies the echo repl=
ies.
> > > > So instead of adding a bool is_present value I hardcoded the info i=
n
> > > > the ID field making it always non null, at the expense of a possibl=
e
> > > > collision, which is harmless.
> > >
> > > Sorry, I feel that I'm missing something here.
> > >
> > > My reading of the code above is that for the cased types above
> > > (echo, echo reply, ...) the id is present. Otherwise it is not.
> > > My idea would be to put a check for those types in a helper.
> > >
> >
> > Something like icmp_has_id(), I like it.
> >
> > > I do agree that the override you have used is harmless enough
> > > in the context of the only user of the id which appears in
> > > the following patch of this series.
> > >
> > >
> > > Some other things I noticed in this patch on a second pass:
> > >
> > > * I think you can remove the icmp field from struct flow_dissector_ke=
y_ports
> > >
> >
> > You mean flow_dissector_key_icmp maybe?
>
> Yes, sorry for the misinformation.
>
> > > * I think that adding icmp to struct flow_keys should be accompanied =
by
> > >   adding ICMP to flow_keys_dissector_symmetric_keys. But I think this=
 is
> > >   not desirable outside of the bonding use-case and rather
> > >   the bonding driver should define its own structures that
> > >   includes the keys it needs - basically copies of struct flow_keys
> > >   and flow_keys_dissector_symmetric_keys with some modifications.
> > >
> >
> > Just flow_keys_dissector_symmetric_keys or flow_keys_dissector_keys too=
?
> > Anyway, it seems that the bonding uses the flow_dissector only when
> > using encap2+3 or encap3+4 hashing, which means decap some known
> > tunnels (mpls and gre and pppoe I think).
>
> That is the use case I noticed.
>
> In that case it uses skb_flow_dissect_flow_keys() which in turn
> uses struct flow_keys and flow_keys_basic_dissector_keys (which is
> assigned to flow_keys_dissector_keys.
>
> Sorry about mentioning flow_keys_dissector_symmetric_keys, I think
> that was a copy-paste-error on my side.
>

np

> In any case, my point is that if you update struct flow_keys then likely
> some corresponding change should also be made to one or more of
> *__dissector_keys. But such a change would have scope outside of bonding,
> which is perhaps undesirable. So it might be better to make local
> structures and call __skb_flow_dissect from within the bonding code.
>

What drawbacks will it have to have the ICMP dissector enabled with
flow_keys_dissector_keys?

I see three options here:
1. add the ICMP key in flow_keys_dissector_keys and change the
flow_dissector behaviour, when dealing with echoes
2. do a local copy in the bonding code
3. leave flow_keys_dissector_keys as is, so the bonding will balance
echoes only when not decapping tunnels

I don't really know if option 1 could be a bug or a feature, sure
option 2 is safer. That can be changed later easily anyway.

>
> As for other use cases, that do not currently use the dissector,
> I think you will need to update them too to get then desired new
> feature introduced in patch 4 for those use-cases, which I assume is
> desired. Perhaps converting those use-cases to use the flow dissector
> is a good way forwards. Perhaps not.
>

I don't really know why the bonding doesn't use the dissector.
Performance? Anyway, maybe converting the bonding to
the flow_dissector would make sense, this can be done in the future.
I have to talk with the bonding maintainers to understand what's
behind this choice.

--=20
Matteo Croce
per aspera ad upstream

