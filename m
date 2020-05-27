Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22531E46EC
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 17:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389606AbgE0PE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 11:04:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50826 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389460AbgE0PE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 11:04:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590591894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qr7OxEt1QJEAD3/EjwZkaROGZzj+XI0pON0f2WeIOYs=;
        b=PlzRQDBC1FmduTXdBtKg6bDaQYPr64aqRNdyW/Q43Om3SmC/NJggwBTE7M+cVBrgHZdhq0
        v78mHduiLQBfLnW/riqL4KyPZWqSAb6VXnsYQy6xUDKdG60c/S1njnXjILfk2pnDcTrvKt
        0P/jCEakBMv6VbtYIdu7XUqMuhmhG1g=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-Bcy0vT-bMcaeSKx95p487Q-1; Wed, 27 May 2020 11:04:53 -0400
X-MC-Unique: Bcy0vT-bMcaeSKx95p487Q-1
Received: by mail-ed1-f72.google.com with SMTP id g10so10223336edt.3
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 08:04:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Qr7OxEt1QJEAD3/EjwZkaROGZzj+XI0pON0f2WeIOYs=;
        b=jIpUjfFsTP0mNrYHmKjQVaCDWLsnorErV/oF23pee6QQBHWgUg7VIYDpcqU2hWS9qG
         JRRn3M3azpWMVCbY42rC2XbaDMbc7JrVf+Hv1FtRWT1VPMuShNCNs/kb0GKf2HOKowu+
         jRI8E6ZiWBkDyWpKf8Qf79dUeMfKZmqL76s6IIO8x6zmXyyuTRcYPZue5kmkzTErLXBL
         UDFFQ1d44T2bZec50M1EGPXI2poNCBCTLfK2ICV98GLNhUSSAo1nM4e/kbgr24v6eWiy
         QvqPDD7kd8Zj0/udNtVw1/enI9A3n6TEgUP6A/hlhTSpzMVVUxGZjqUGJ5cLwHx3aeb+
         1aHw==
X-Gm-Message-State: AOAM533hYdqfX+jN/443cGvENMY3BF8KLhgwRHrAkDl3z28xypzmnXpO
        rUrTF/Plh0iwhwd/9NFZLk5F/epG2scHLyYtSYfODXbX5dnEi2GZoed5MgwjDr+zI8rANt0P5qg
        E6f6uchxc8GL/YL8X
X-Received: by 2002:a05:6402:1bd9:: with SMTP id ch25mr23311821edb.15.1590591891818;
        Wed, 27 May 2020 08:04:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZGgRsQd9KcCTrN+xjOaW1vuqPXmVXk/QUZUn9Agnb7kGPRsBR//GMP/QALEzGNkek0SmasA==
X-Received: by 2002:a05:6402:1bd9:: with SMTP id ch25mr23311797edb.15.1590591891572;
        Wed, 27 May 2020 08:04:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id af15sm3050774ejc.89.2020.05.27.08.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 08:04:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 462571804EB; Wed, 27 May 2020 17:04:50 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
In-Reply-To: <20200527123858.GH102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com> <20200526140539.4103528-1-liuhangbin@gmail.com> <87zh9t1xvh.fsf@toke.dk> <20200527123858.GH102436@dhcp-12-153.nay.redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 27 May 2020 17:04:50 +0200
Message-ID: <87lfld1krx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> On Wed, May 27, 2020 at 12:21:54PM +0200, Toke H=C3=83=C6=92=C3=82=C2=B8i=
land-J=C3=83=C6=92=C3=82=C2=B8rgensen wrote:
>> > The example in patch 2 is functional, but not a lot of effort
>> > has been made on performance optimisation. I did a simple test(pkt siz=
e 64)
>> > with pktgen. Here is the test result with BPF_MAP_TYPE_DEVMAP_HASH
>> > arrays:
>> >
>> > bpf_redirect_map() with 1 ingress, 1 egress:
>> > generic path: ~1600k pps
>> > native path: ~980k pps
>> >
>> > bpf_redirect_map_multi() with 1 ingress, 3 egress:
>> > generic path: ~600k pps
>> > native path: ~480k pps
>> >
>> > bpf_redirect_map_multi() with 1 ingress, 9 egress:
>> > generic path: ~125k pps
>> > native path: ~100k pps
>> >
>> > The bpf_redirect_map_multi() is slower than bpf_redirect_map() as we l=
oop
>> > the arrays and do clone skb/xdpf. The native path is slower than gener=
ic
>> > path as we send skbs by pktgen. So the result looks reasonable.
>>=20
>> How are you running these tests? Still on virtual devices? We really
>
> I run it with the test topology in patch 2/2. The test is run on physical
> machines, but I use veth interface. Do you mean use a physical NIC driver
> for testing?

Yes, sorry, when I said 'physical machine' I should have also 'physical
NIC'. We really need to know how the performance of this is on the XDP
fast path, i.e., when there are no skbs involved at all.

> BTW, when using pktgen, I got an panic because the skb don't have enough
> header room. The code path looks like
>
> do_xdp_generic()
>   - netif_receive_generic_xdp()
>     - skb_headroom(skb) < XDP_PACKET_HEADROOM
>       - pskb_expand_head()
>         - BUG_ON(skb_shared(skb))
>
> So I added a draft patch for pktgen, not sure if it has any influence.

Hmm, as Jesper said pktgen was really not intended to be used this way,
so I guess that's why. I guess I'll let him comment on whether he thinks
it's worth fixing; or you could send this as a proper patch and see if
anyone complains about it ;)

-Toke

