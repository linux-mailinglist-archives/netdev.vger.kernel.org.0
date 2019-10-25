Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0C3E438F
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 08:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392598AbfJYG3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 02:29:01 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36414 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391314AbfJYG3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 02:29:01 -0400
Received: by mail-wm1-f68.google.com with SMTP id c22so746174wmd.1
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 23:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Uv7QcEOlQBDvtRdtXF6xnos8TMTBTVi9pOUYMJH29jg=;
        b=eedgFm6esMZW/u1NErpTXXyCwogYQ7ewX1kDaozdtKzjRz2hNmGutYTTCBM6TpEleM
         jA0hDILQrHLS3fiQQyb1ofzAGMJc6g0Tmz4utl5nDEDvbz0c7O7gU5ZD3FuHl94Rsr6T
         e71PQ8N2BeaoHT/cPQ3j+1Cpad7KCymEPdfrksBcZCm1MLSC6Um4Et56ThhkNcKlXGEw
         HX9ef4/fLVgrQUE2ZiC6DCyxOH9UIIFOEf0f2qHkxJRBJX1jfAgjju4SNIBI00Q44aLu
         59iimz2QvOETixIrvShDhp3oeFrsK5HSTm6YFCc0/jR6d7EAJymfSkaQgYCftmGnOpFY
         SozQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Uv7QcEOlQBDvtRdtXF6xnos8TMTBTVi9pOUYMJH29jg=;
        b=r0uz03zhRC3GVR1BZ7tzY+4ku9CchI7F731iBsGX118mIFBJlmwpGSDkE7Gu54oQC5
         j/eaTTUCY+EwnN19un6uwEKIJix93g6hUgHIJdsua64UOD6XZhad7ctxDwqAgZ/1E5lr
         8N7s6Xn4kZRmxcuIT1pa95azzfBKBORMBwfmuDXr2BaDtSD25u2quShVs1xB6kEnLFQI
         4rDpiR6NzDkHR3LNr8i/BD+E3yiKTVyIFEwA72nfUrgSvcwa1VSUAq6rYdh/267XRJZo
         wVqgdLEnSEo6EFKJEwMqcUmkrdB6Gu1XNw89+KuDdGBvcLjaL9L8Omw4y1o6Gzt+jugh
         669g==
X-Gm-Message-State: APjAAAXWSqOrwCEPz6jhizWsfwoey5nkMYxx757S/DTjX5DCobxX3XNL
        rPo75UnSgnaqaKNqkF0XxHIhvOZf3Ks=
X-Google-Smtp-Source: APXvYqxJejpWMS55PtNYtpn8jYnjPrNEjyqQbiTEgFJnvCI7Vap9ZoUz4FUqah2vKemNvwwMQJLIMw==
X-Received: by 2002:a7b:cb0b:: with SMTP id u11mr1754499wmj.125.1571984938296;
        Thu, 24 Oct 2019 23:28:58 -0700 (PDT)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id r1sm1264050wrw.60.2019.10.24.23.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 23:28:58 -0700 (PDT)
Date:   Fri, 25 Oct 2019 08:28:56 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Matteo Croce <mcroce@redhat.com>
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
Subject: Re: [PATCH net-next 3/4] flow_dissector: extract more ICMP
 information
Message-ID: <20191025062856.GB7325@netronome.com>
References: <20191021200948.23775-1-mcroce@redhat.com>
 <20191021200948.23775-4-mcroce@redhat.com>
 <20191023100009.GC8732@netronome.com>
 <CAGnkfhxg1sXkmiNS-+H184omQaKbp_+_Sy7Vi-9W9qLwGGPU6g@mail.gmail.com>
 <20191023175522.GB28355@netronome.com>
 <CAGnkfhyEB0JU7LPZfYxHiKkryrkzoOs3Krumt1Lph+Q=qx1s8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnkfhyEB0JU7LPZfYxHiKkryrkzoOs3Krumt1Lph+Q=qx1s8A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 02:27:28AM +0200, Matteo Croce wrote:
> On Wed, Oct 23, 2019 at 7:55 PM Simon Horman <simon.horman@netronome.com> wrote:
> >
> > On Wed, Oct 23, 2019 at 12:53:37PM +0200, Matteo Croce wrote:
> > > On Wed, Oct 23, 2019 at 12:00 PM Simon Horman
> > > <simon.horman@netronome.com> wrote:
> > > > On Mon, Oct 21, 2019 at 10:09:47PM +0200, Matteo Croce wrote:
> > > > > +     switch (ih->type) {
> > > > > +     case ICMP_ECHO:
> > > > > +     case ICMP_ECHOREPLY:
> > > > > +     case ICMP_TIMESTAMP:
> > > > > +     case ICMP_TIMESTAMPREPLY:
> > > > > +     case ICMPV6_ECHO_REQUEST:
> > > > > +     case ICMPV6_ECHO_REPLY:
> > > > > +             /* As we use 0 to signal that the Id field is not present,
> > > > > +              * avoid confusion with packets without such field
> > > > > +              */
> > > > > +             key_icmp->id = ih->un.echo.id ? : 1;
> > > >
> > > > Its not obvious to me why the kernel should treat id-zero as a special
> > > > value if it is not special on the wire.
> > > >
> > > > Perhaps a caller who needs to know if the id is present can
> > > > check the ICMP type as this code does, say using a helper.
> > > >
> > >
> > > Hi,
> > >
> > > The problem is that the 0-0 Type-Code pair identifies the echo replies.
> > > So instead of adding a bool is_present value I hardcoded the info in
> > > the ID field making it always non null, at the expense of a possible
> > > collision, which is harmless.
> >
> > Sorry, I feel that I'm missing something here.
> >
> > My reading of the code above is that for the cased types above
> > (echo, echo reply, ...) the id is present. Otherwise it is not.
> > My idea would be to put a check for those types in a helper.
> >
> 
> Something like icmp_has_id(), I like it.
> 
> > I do agree that the override you have used is harmless enough
> > in the context of the only user of the id which appears in
> > the following patch of this series.
> >
> >
> > Some other things I noticed in this patch on a second pass:
> >
> > * I think you can remove the icmp field from struct flow_dissector_key_ports
> >
> 
> You mean flow_dissector_key_icmp maybe?

Yes, sorry for the misinformation.

> > * I think that adding icmp to struct flow_keys should be accompanied by
> >   adding ICMP to flow_keys_dissector_symmetric_keys. But I think this is
> >   not desirable outside of the bonding use-case and rather
> >   the bonding driver should define its own structures that
> >   includes the keys it needs - basically copies of struct flow_keys
> >   and flow_keys_dissector_symmetric_keys with some modifications.
> >
> 
> Just flow_keys_dissector_symmetric_keys or flow_keys_dissector_keys too?
> Anyway, it seems that the bonding uses the flow_dissector only when
> using encap2+3 or encap3+4 hashing, which means decap some known
> tunnels (mpls and gre and pppoe I think).

That is the use case I noticed.

In that case it uses skb_flow_dissect_flow_keys() which in turn
uses struct flow_keys and flow_keys_basic_dissector_keys (which is
assigned to flow_keys_dissector_keys.

Sorry about mentioning flow_keys_dissector_symmetric_keys, I think
that was a copy-paste-error on my side.

In any case, my point is that if you update struct flow_keys then likely
some corresponding change should also be made to one or more of
*__dissector_keys. But such a change would have scope outside of bonding,
which is perhaps undesirable. So it might be better to make local
structures and call __skb_flow_dissect from within the bonding code.


As for other use cases, that do not currently use the dissector,
I think you will need to update them too to get then desired new
feature introduced in patch 4 for those use-cases, which I assume is
desired. Perhaps converting those use-cases to use the flow dissector
is a good way forwards. Perhaps not.

> For the other modes it just uses iph_to_flow_copy_v{4,6}addrs() and
> skb_flow_get_ports(), so maybe we can avoid copying that structure.
> 
> > * Modifying flow_keys_have_l4 affects the behaviour of
> >   skb_get_hash_flowi6() but there is not a corresponding update
> >   to flow_keys_have_l4(). I didn't look at all the other call sites
> >   but it strikes me that this is a) a wide-spread behavioural change
> >   and b) is perhaps not required for the bond-use case.
> 
> Right, no need to alter flow_keys_have_l4() at all.
> 
> I'll send a v2 with those suggestions.
> 
> Thanks,
> --
> Matteo Croce
> per aspera ad upstream
> 
