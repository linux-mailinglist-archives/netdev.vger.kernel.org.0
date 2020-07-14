Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BBB21F133
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 14:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgGNM3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 08:29:31 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57876 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726041AbgGNM3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 08:29:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594729768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M1tJQgrbek3QI28HACPK1H60w+RS294RJhZIW4zv/pw=;
        b=Fye7uwjGPBQxE0rUR8vSxt8p2zDpDE0fF7M7/dEiXqtL6yP6jzZXRhGXLUwGzIdxsUICqU
        gDN7SRK8exUXjZlGiKUqwa77FcIlcdU0PcwaxzD2N+0JjsEue4E6BeJNV29pkTMmAft23v
        PlGWKM7qX0++OM3UT+uMB1DOBz1ktPs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-C5z_ABIeMYW9M0QFNR5iHA-1; Tue, 14 Jul 2020 08:29:25 -0400
X-MC-Unique: C5z_ABIeMYW9M0QFNR5iHA-1
Received: by mail-wm1-f70.google.com with SMTP id o13so3722708wmh.9
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 05:29:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=M1tJQgrbek3QI28HACPK1H60w+RS294RJhZIW4zv/pw=;
        b=Q+D88TFU1yPCDy08hYI8a6LynuzJ90DWqu79Adk+TQS4L4o0cAs9wKJfMXrpcDqpW6
         E2/diFqqNKqEN2CnXZrumwjpUQ8s05d+dmPB+4hpPTjEXCKQVqCnm9lVGS2x1P5yZvaq
         0waTjcN4PeQ3wL8UxEllL8z5OUOyFqBT27N851u5VcBW0NG7VsQBQE/3pfHtUMKXig2T
         tk0qSQwwBne96jhQE7ynUGCME/u3tQ504dqlD/dr+ijvPIfHsrsnhBSt6O5I2WpUPfyg
         EY7XSUrpLmPHSN7rb0fNrgSD8kjrmfw4VCfqnwzLEPfIEmWLdeNeG30dD25iTYobI02V
         GmuA==
X-Gm-Message-State: AOAM532bRzwZ2WXPs06QRa+sz3szrAKELjmDx/3bOTHB9qnKQNFk1NKX
        aUHtHKDp2vCEXXZzytIK4jVlw3pHLnlMB6SrIkUZ8dpuVwS5ePEig3jLIVsKgBerT74RVG9dB4v
        hGwzoO88J8AMlgLgN
X-Received: by 2002:a7b:c8c2:: with SMTP id f2mr4038478wml.57.1594729763849;
        Tue, 14 Jul 2020 05:29:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMcLTiDBY47ikR7IpxmOAOaUvTQRyYGGqEG4fWigSZAdh7jGA66uqGW0xExbdW0gzRYc7fhA==
X-Received: by 2002:a7b:c8c2:: with SMTP id f2mr4038448wml.57.1594729763602;
        Tue, 14 Jul 2020 05:29:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id d18sm29804962wrj.8.2020.07.14.05.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 05:29:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 34607180653; Tue, 14 Jul 2020 14:29:21 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCHv7 bpf-next 0/3] xdp: add a new helper for dev map multicast support
In-Reply-To: <20200714063257.1694964-1-liuhangbin@gmail.com>
References: <20200709013008.3900892-1-liuhangbin@gmail.com> <20200714063257.1694964-1-liuhangbin@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 14 Jul 2020 14:29:21 +0200
Message-ID: <87imeqgtzy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> This patch is for xdp multicast support. which has been discussed before[0],
> The goal is to be able to implement an OVS-like data plane in XDP, i.e.,
> a software switch that can forward XDP frames to multiple ports.
>
> To achieve this, an application needs to specify a group of interfaces
> to forward a packet to. It is also common to want to exclude one or more
> physical interfaces from the forwarding operation - e.g., to forward a
> packet to all interfaces in the multicast group except the interface it
> arrived on. While this could be done simply by adding more groups, this
> quickly leads to a combinatorial explosion in the number of groups an
> application has to maintain.
>
> To avoid the combinatorial explosion, we propose to include the ability
> to specify an "exclude group" as part of the forwarding operation. This
> needs to be a group (instead of just a single port index), because there
> may have multi interfaces you want to exclude.
>
> Thus, the logical forwarding operation becomes a "set difference"
> operation, i.e. "forward to all ports in group A that are not also in
> group B". This series implements such an operation using device maps to
> represent the groups. This means that the XDP program specifies two
> device maps, one containing the list of netdevs to redirect to, and the
> other containing the exclude list.
>
> To achieve this, I re-implement a new helper bpf_redirect_map_multi()
> to accept two maps, the forwarding map and exclude map. If user
> don't want to use exclude map and just want simply stop redirecting back
> to ingress device, they can use flag BPF_F_EXCLUDE_INGRESS.
>
> The 2nd and 3rd patches are for usage sample and testing purpose, so there
> is no effort has been made on performance optimisation. I did same tests
> with pktgen(pkt size 64) to compire with xdp_redirect_map(). Here is the
> test result(the veth peer has a dummy xdp program with XDP_DROP directly):
>
> Version         | Test                                   | Native | Generic
> 5.8 rc1         | xdp_redirect_map       i40e->i40e      |  10.0M |   1.9M
> 5.8 rc1         | xdp_redirect_map       i40e->veth      |  12.7M |   1.6M
> 5.8 rc1 + patch | xdp_redirect_map       i40e->i40e      |  10.0M |   1.9M
> 5.8 rc1 + patch | xdp_redirect_map       i40e->veth      |  12.3M |   1.6M
> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->i40e      |   7.2M |   1.5M
> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->veth      |   8.5M |   1.3M
> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->i40e+veth |   3.0M |  0.98M
>
> The bpf_redirect_map_multi() is slower than bpf_redirect_map() as we loop
> the arrays and do clone skb/xdpf. The native path is slower than generic
> path as we send skbs by pktgen. So the result looks reasonable.
>
> Last but not least, thanks a lot to Jiri, Eelco, Toke and Jesper for
> suggestions and help on implementation.
>
> [0] https://xdp-project.net/#Handling-multicast
>
> v7: Fix helper flag check
>     Limit the *ex_map* to use DEVMAP_HASH only and update function
>     dev_in_exclude_map() to get better performance.

Did it help? The performance numbers in the table above are the same as
in v6...

-Toke

