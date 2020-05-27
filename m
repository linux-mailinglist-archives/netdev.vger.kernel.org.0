Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B0B1E3EDD
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729781AbgE0KWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:22:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39715 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725294AbgE0KWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:22:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590574918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DGTsXmZBOnXWALLJ93Bh3zg3e2amhZp5+fELSnd0gNQ=;
        b=jKI7fqboCn1p8biDysJbA+/qcH6BYMw12nspJuxAbo4MG7v7b1raBhxZa58R+i78GgfrwQ
        ehTqeufE/TttNdStAD3VEtYHioZK72CvM+JdmDaRolbpULVX1EMLYXigjo7qadR60Jp3VD
        NSiL2wWEZdJrT+VysmyzfIjWe1EpZE8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-DDmXZPKwMay03wfcLIiD_g-1; Wed, 27 May 2020 06:21:57 -0400
X-MC-Unique: DDmXZPKwMay03wfcLIiD_g-1
Received: by mail-ej1-f70.google.com with SMTP id nw19so8689238ejb.10
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 03:21:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DGTsXmZBOnXWALLJ93Bh3zg3e2amhZp5+fELSnd0gNQ=;
        b=hi/rpRvbVbtEhgLQNO6vj/gtLLG+QyAGrDks+JDdCi1KGWrWzaRjKIeTnBwjtrUxal
         KzgoGBjd9WB3T20157rdxIjzB64LMd4tK/52vshPKV9x8xH8ZosUQ5mR1dxQrKJbGmHK
         N/BW5/L/yIWpKxn0uQqMQjIuDvWXI1GaCJcBCJYvTiu/ZRmgEKDi6dnOpZ2ZlSVlH3nQ
         b8Ps+rD7en4u96418cMvB6nmnzawyQ7InAzclUFcPes+ZavMhDDYpB0huQzCJb+o8UJb
         iMocZHvqm4YT8WinERTK84+lSOPAR/Dt6qi7d1zIfDRrkaTKnFztTK/KwaqjdUFA9vJu
         zuAg==
X-Gm-Message-State: AOAM532H5pENqrTkQrQK8Wp1uH5RmTl2TAwJ7FQRkiP203aJyAcoLECR
        75ZAN0xdb6/GclbgSHEBsW3KwPiBxY+OAQBjYLoTh1GVxpZjcoSrw/A95wiAxMz90WgvBMyzYQO
        X7FDVq4A+AQ+Wl8iP
X-Received: by 2002:a17:906:5210:: with SMTP id g16mr5394429ejm.197.1590574915987;
        Wed, 27 May 2020 03:21:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2IDOYIhlplTt0p7rwOBXYSp12/k03N749FhDrM21+a4R4xMIePpSIW5mE4yARFTWNcOPBjQ==
X-Received: by 2002:a17:906:5210:: with SMTP id g16mr5394407ejm.197.1590574915752;
        Wed, 27 May 2020 03:21:55 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id p25sm1923931eds.76.2020.05.27.03.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 03:21:54 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 27BEA1804EB; Wed, 27 May 2020 12:21:54 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
In-Reply-To: <20200526140539.4103528-1-liuhangbin@gmail.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com> <20200526140539.4103528-1-liuhangbin@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 27 May 2020 12:21:54 +0200
Message-ID: <87zh9t1xvh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> Hi all,
>
> This patchset is for xdp multicast support, which has been discussed
> before[0]. The goal is to be able to implement an OVS-like data plane in
> XDP, i.e., a software switch that can forward XDP frames to multiple
> ports.
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
> needs to be a group (instead of just a single port index), because a
> physical interface can be part of a logical grouping, such as a bond
> device.
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
> The example in patch 2 is functional, but not a lot of effort
> has been made on performance optimisation. I did a simple test(pkt size 64)
> with pktgen. Here is the test result with BPF_MAP_TYPE_DEVMAP_HASH
> arrays:
>
> bpf_redirect_map() with 1 ingress, 1 egress:
> generic path: ~1600k pps
> native path: ~980k pps
>
> bpf_redirect_map_multi() with 1 ingress, 3 egress:
> generic path: ~600k pps
> native path: ~480k pps
>
> bpf_redirect_map_multi() with 1 ingress, 9 egress:
> generic path: ~125k pps
> native path: ~100k pps
>
> The bpf_redirect_map_multi() is slower than bpf_redirect_map() as we loop
> the arrays and do clone skb/xdpf. The native path is slower than generic
> path as we send skbs by pktgen. So the result looks reasonable.

How are you running these tests? Still on virtual devices? We really
need results from a physical setup in native mode to assess the impact
on the native-XDP fast path. The numbers above don't tell much in this
regard. I'd also like to see a before/after patch for straight
bpf_redirect_map(), since you're messing with the fast path, and we want
to make sure it's not causing a performance regression for regular
redirect.

Finally, since the overhead seems to be quite substantial: A comparison
with a regular network stack bridge might make sense? After all we also
want to make sure it's a performance win over that :)

-Toke

