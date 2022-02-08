Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A9F4ADDD6
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 17:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382596AbiBHQBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 11:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381557AbiBHQBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 11:01:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD248C06157A
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 08:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644336075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I1wYQcALmzzp3eC1Kv9MyB7va4H/QkIUUQ+lvknf2po=;
        b=D6+v8o9Edw7YJtFKgWNsZ3A0EsrlWP7OTw3ayhqv+MWG5LG9jHVCoq3jHKOBmqViyeuLiq
        TKrNCCChouc7uJO4bL9mD++mI3WwYH03V0BH7LzRf2kL1EK3DA5VeuSbhBnCQ/oxAxUsXg
        ZUt8PRknK0CkElmD4eMQXlzcP/0137Q=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-LnslDa_QMtiEl96BYOAAcw-1; Tue, 08 Feb 2022 11:01:14 -0500
X-MC-Unique: LnslDa_QMtiEl96BYOAAcw-1
Received: by mail-qt1-f200.google.com with SMTP id d25-20020ac84e39000000b002d1cf849207so13810683qtw.19
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 08:01:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=I1wYQcALmzzp3eC1Kv9MyB7va4H/QkIUUQ+lvknf2po=;
        b=yPeM/fSZpIN12WdeytrqTMIeSPQMk2Lli3NKBDjTm49DIaJpNvgcoZwrNGkck+mHLx
         C7awxWkKnLETblroUbHALbVyMa5tRLXSx8LmPDehCRqEtTaLdw/MR7Z6x8cqMWWh7CQN
         c2mXhPxz0AKTCrY7i7M2BXWVd4x7lESG/lq4DYRExl3B9bz+42FMu37roTiZhHXuyJ5Z
         CLPu4OA3Be8AMM3hyyawf4tn6+5u39s7xzblzWYem6BY2n+SxEe3OgnMJxeNoiQK81Hw
         hfJEaFDNdOQH0FwrxVzm/QRjxDloMhElkc19WIyi+kgloyS37UC95VdGshcG7Upnar2a
         7pqg==
X-Gm-Message-State: AOAM530Aubw6/knEPaD417ivoY+QPvRdxGpopKJaozMBDemc/UYgSuB3
        GDelaDLVZ07wGYWTKKSBwsNA6cOazlxdi2j1Vc3le6E36mqzEOMCbXcXvss1H7fwIYuAQhWdeWf
        FyQgGg5kMmd4GTfFy
X-Received: by 2002:a05:6214:2402:: with SMTP id fv2mr3581280qvb.9.1644336073085;
        Tue, 08 Feb 2022 08:01:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx9xYpQIzQXvKpdRdFAJVedmOkOWIXhZG1xIX9Mpv3pOBzgATnhlRQx/QiOqbkA6Pc8H2YY6w==
X-Received: by 2002:a05:6214:2402:: with SMTP id fv2mr3581250qvb.9.1644336072750;
        Tue, 08 Feb 2022 08:01:12 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id b10sm7585437qtb.34.2022.02.08.08.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 08:01:12 -0800 (PST)
Message-ID: <a62abfeb0c06bf8be7f4fa271e2bcdef9d86c550.camel@redhat.com>
Subject: Re: [PATCH] net: fix wrong network header length
From:   Paolo Abeni <pabeni@redhat.com>
To:     Maciej =?UTF-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Lina Wang <lina.wang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Kernel hackers <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Willem Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>
Date:   Tue, 08 Feb 2022 17:01:07 +0100
In-Reply-To: <CANP3RGe8ko=18F2cr0_hVMKw99nhTyOCf4Rd_=SMiwBtQ7AmrQ@mail.gmail.com>
References: <20220208025511.1019-1-lina.wang@mediatek.com>
         <0300acca47b10384e6181516f32caddda043f3e4.camel@redhat.com>
         <CANP3RGe8ko=18F2cr0_hVMKw99nhTyOCf4Rd_=SMiwBtQ7AmrQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Steffen
On Tue, 2022-02-08 at 04:57 -0800, Maciej Żenczykowski wrote:
> On Tue, Feb 8, 2022 at 12:25 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > 
> > Hello,
> > 
> > On Tue, 2022-02-08 at 10:55 +0800, Lina Wang wrote:
> > > When clatd starts with ebpf offloaing, and NETIF_F_GRO_FRAGLIST is enable,
> > > several skbs are gathered in skb_shinfo(skb)->frag_list. The first skb's
> > > ipv6 header will be changed to ipv4 after bpf_skb_proto_6_to_4,
> > > network_header\transport_header\mac_header have been updated as ipv4 acts,
> > > but other skbs in frag_list didnot update anything, just ipv6 packets.
> > > 
> > > udp_queue_rcv_skb will call skb_segment_list to traverse other skbs in
> > > frag_list and make sure right udp payload is delivered to user space.
> > > Unfortunately, other skbs in frag_list who are still ipv6 packets are
> > > updated like the first skb and will have wrong transport header length.
> > > 
> > > e.g.before bpf_skb_proto_6_to_4,the first skb and other skbs in frag_list
> > > has the same network_header(24)& transport_header(64), after
> > > bpf_skb_proto_6_to_4, ipv6 protocol has been changed to ipv4, the first
> > > skb's network_header is 44,transport_header is 64, other skbs in frag_list
> > > didnot change.After skb_segment_list, the other skbs in frag_list has
> > > different network_header(24) and transport_header(44), so there will be 20
> > > bytes difference,that is difference between ipv6 header and ipv4 header.
> > 
> > > Actually, there are two solutions to fix it, one is traversing all skbs
> > > and changing every skb header in bpf_skb_proto_6_to_4, the other is
> > > modifying frag_list skb's header in skb_segment_list.
> > 
> > I don't think the above should be addressed into the GSO layer. The
> > ebpf program is changing the GRO packet in arbitrary way violating the
> > GSO packet constraint - arguably, it's corrupting the packet.
> > 
> > I think it would be better change the bpf_skb_proto_6_to_4() to
> > properly handle FRAGLIST GSO packets.
> > 
> > If traversing the segments become too costly, you can try replacing
> > GRO_FRAGLIST with GRO_UDP_FWD.
> 
> Yeah, I don't know...
> 
> I've considered that we could perhaps fix the 6to4 helper, and 4to6 helper...
> but then I think every *other* helper / code path that plays games
> with the packet header needs fixing as well,
> ie. everything dealing with encap/decap, vlan, etc..
> 
> At that point it seems to me like it's worth fixing here rather than
> in all those other places.
> 
> In general it seems gro fraglist as implemented is just a bad idea...
> Packets (and things we treat like packets) really should only have 1 header.
> GRO fraglist - as implemented - violates this pretty fundamental assumption.
> As such it seems to be on the gro fraglist implementation to deal with it.
> That to me seems to mean it should be fixed here, and not elsewhere.

@Steffen: IIRC GRO_FRAGLIST was originally added to support some
forwarding scenarios. Now we have GRO_UDP_FWD which should be quite
comparable. I'm wondering if the latter feature addresses your use
case, too.

If so, could we consider deprecating (and in a longer run, drop) the
GRO_FRAGLIST feature? 

Thanks!

Paolo

