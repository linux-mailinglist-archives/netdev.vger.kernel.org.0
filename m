Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8A12C88FE
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 17:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgK3QJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 11:09:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50137 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727719AbgK3QJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 11:09:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606752468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z9I0c/dd5Q0R8BZ2NpwwypMm4g9XV24/FLTuN3n5dJk=;
        b=ck3dNFs59duD+wLHY9wpTyBRL5/SIagmCpccYSWBdUmoFWrqEqthZU5dg4CLXDGB8bfF12
        Gu/moeRYIZc7CDvuZs3kmf5cRGvKW5B/eceNv8TJhHosCvjdh+tY7F3jokXDGnbHmHzxSs
        ElHClI9pY6a8LHkTYcGEu1XMsPvBPXU=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-sajidVbINuu4HxbjezLILg-1; Mon, 30 Nov 2020 11:07:45 -0500
X-MC-Unique: sajidVbINuu4HxbjezLILg-1
Received: by mail-qk1-f198.google.com with SMTP id u67so807903qkd.6
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 08:07:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=z9I0c/dd5Q0R8BZ2NpwwypMm4g9XV24/FLTuN3n5dJk=;
        b=pLbFycQVY/0tk6yZawAkgTPiH4ztzUCsJGlFvvAm2BoHeBSZvCYo1U3CBxazmh3WAl
         fka1k0KFXAfq0UTuTclpp+luqkydI1ZYngXNAJsQRKeVg8siFwEszCkxDGs4xNmGmFDZ
         1rPV2puGaPUtbM/JSuM1sAEGjnaQT4W5BVAQ4xmir+knlHvjihWuPvyiMKyBOMmnnF0r
         4QsRE2du+DDp46QPJ1NFp1U2FZ8LLcjFirZYL7lBve2TLvK8POSdEKE+vP7oH7sE4EU9
         BexrGpKShfy13NbWftTGWhfFqsOwOBLoQ/z4grHFXcIVXhFHKVrd2dPcqE6XR4zlD4ps
         gcgg==
X-Gm-Message-State: AOAM5317kRwezStfaR6nWuC5kyJRyPTR83Z0Hze2TdQNYsL8+QcA6VY0
        U4VGT3WWs1mJId0HgMfby4Trbq8Bt/ZteSTEA10wNq6qZe89eIdR38u3O4WLKu6IeBOewsz8lCa
        GeTxhHYzBVzpF3Uhn
X-Received: by 2002:a05:6214:481:: with SMTP id ay1mr22920283qvb.54.1606752463819;
        Mon, 30 Nov 2020 08:07:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzym/zy6ISLRjexISKW/i4kC8v70fcW5z1pj1xNE6c1gNNOed5dqgeJieAHqXvvZ4TW/ELNfQ==
X-Received: by 2002:a05:6214:481:: with SMTP id ay1mr22920234qvb.54.1606752463200;
        Mon, 30 Nov 2020 08:07:43 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 13sm12673607qkl.121.2020.11.30.08.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 08:07:42 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 47BE6181AD4; Mon, 30 Nov 2020 17:07:39 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        brouer@redhat.com
Subject: Re: [PATCHv2 bpf-next] samples/bpf: add xdp program on egress for
 xdp_redirect_map
In-Reply-To: <20201130161249.18f7ca43@carbon>
References: <20201110124639.1941654-1-liuhangbin@gmail.com>
 <20201126084325.477470-1-liuhangbin@gmail.com>
 <54642499-57d7-5f03-f51e-c0be72fb89de@fb.com>
 <20201130075107.GB277949@localhost.localdomain>
 <20201130103208.6d5305e2@carbon>
 <20201130131020.GC277949@localhost.localdomain>
 <20201130161249.18f7ca43@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 30 Nov 2020 17:07:39 +0100
Message-ID: <87im9mygj8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Mon, 30 Nov 2020 21:10:20 +0800
> Hangbin Liu <liuhangbin@gmail.com> wrote:
>
>> On Mon, Nov 30, 2020 at 10:32:08AM +0100, Jesper Dangaard Brouer wrote:
>> > > I plan to write a example about vlan header modification based on egress
>> > > index. I will post the patch later.  
>> > 
>> > I did notice the internal thread you had with Toke.  I still think it
>> > will be more simple to modify the Ethernet mac addresses.  Adding a
>> > VLAN id tag is more work, and will confuse benchmarks.  You are  
>> 
>> I plan to only modify the vlan id if there has. 
>
> This sentence is not complete, but because of the internal thread I
> know/assume that you mean, that you will only modify the vlan id if
> there is already another VLAN tag in the packet. Let me express that
> this is not good enough. This is not a feasible choice.
>
>> If you prefer to modify the mac address, which way you'd like? Set
>> src mac to egress interface's MAC?
>
> Yes, that will be a good choice, to use the src mac from the egress
> interface.  This would simulate part of what is needed for L3/routing.
>
> Can I request that the dst mac is will be the incoming src mac?
> Or if you are user-friendly add option that allows to set dst mac.

One issue with this is that I think it would be neat if we could output
the egress ifindex as part of the packet data, to verify that different
packets can get different content (in the multicast case). If we just
modify the MAC address this is difficult. I guess we could just decide
to step on one byte in the src MAC or something, but VLAN tags seemed
like an obvious alternative :)

-Toke

