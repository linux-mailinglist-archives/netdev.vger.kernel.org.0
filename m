Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2D7300479
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 14:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbhAVNpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 08:45:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23303 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727431AbhAVNp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 08:45:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611323042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LSafo57XtoKmdAn5PBIKq/sD9HXNlfcWGv5QuK9i20k=;
        b=FNLs0BfKlGAG+yR71/d5Tq8/QP3xfKQNIjYsWJOf5kwT82I0AmfT7khlMlE8OUFb+YCQyA
        fYcSLaSUZjiOnmVc4rF3HDyAZK814s3ettZk5+5cazEX5K/KRsAFwHzHfZ7OiLCjRD6AEJ
        OABgEoixDkKc4PoQBssXfBB3YQSdVOc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-mrsE89NhMNGTnVlmnKC8zw-1; Fri, 22 Jan 2021 08:44:00 -0500
X-MC-Unique: mrsE89NhMNGTnVlmnKC8zw-1
Received: by mail-ed1-f72.google.com with SMTP id j11so2168468edy.20
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 05:44:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=LSafo57XtoKmdAn5PBIKq/sD9HXNlfcWGv5QuK9i20k=;
        b=JsIaTAIOqG0h52v1TB9xpGPVyNTNBYC5LJOD/jGdU2CiazHukRLdISbcHHgHDyLNy0
         MI+jlItFrnT679Wa7qTRzdmq7+ZWra/gtkQV5noM9KpUd9CPMWStduIqNdsPfz2EN3Ji
         afucm1MRAaKO0aEQ2Y1vced+EfybgD/iiZGvefpiTT3jP++mXriBdEreqqam0m7HofwZ
         A//sEgzaZ4vIMzxmKHFFMPlIfF2ilQ0iUimcMHf+lbCKCHuUuIZkRAzWWaWyc0qyX026
         lIiP0GgU4NksaoCC5yaavo7Zftgp/8iVckvW5OVYEfXJlC1y0I+BpYFHgHWK2n41zQax
         Izrw==
X-Gm-Message-State: AOAM53002GP2x0fCMv828d7EVS4ZMlnFpl5RHphAdW5Tb0YaAmWjxCzF
        DxC9liLqM4J2u1oP3jwjTZ/TYGRQYPs5m7kIfwjaHUqihj5WvasYBcXXOY6Vpyxyi5Jsa0VsnPv
        skNQfHYzccD1RxJm0
X-Received: by 2002:a17:906:e107:: with SMTP id gj7mr2838894ejb.298.1611323039166;
        Fri, 22 Jan 2021 05:43:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxjiAzopOSQb0d8E60yMSe4IQdJw/VTogdIniZWKot5knFrakF0xavAktfiTf5jaUiMXp7lPQ==
X-Received: by 2002:a17:906:e107:: with SMTP id gj7mr2838886ejb.298.1611323038991;
        Fri, 22 Jan 2021 05:43:58 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id j7sm4440018ejj.27.2021.01.22.05.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 05:43:58 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C9B25180338; Fri, 22 Jan 2021 14:43:57 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCHv16 bpf-next 0/6] xdp: add a new helper for dev map
 multicast support
In-Reply-To: <20210122074652.2981711-1-liuhangbin@gmail.com>
References: <20210120022514.2862872-1-liuhangbin@gmail.com>
 <20210122074652.2981711-1-liuhangbin@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 22 Jan 2021 14:43:57 +0100
Message-ID: <87v9bp5boi.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> This patch is for xdp multicast support. which has been discussed before[=
0],
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
> The 1st patch is Jesper's run devmap xdp_prog later in bulking step.
> The 2st patch add a new bpf arg to allow NULL map pointer.
> The 3rd patch add the new bpf_redirect_map_multi() helper.
> The 4-6 patches are for usage sample and testing purpose.
>
> I did same perf tests with the following topo:
>
> ---------------------             ---------------------
> | Host A (i40e 10G) |  ---------- | eno1(i40e 10G)    |
> ---------------------             |                   |
>                                   |   Host B          |
> ---------------------             |                   |
> | Host C (i40e 10G) |  ---------- | eno2(i40e 10G)    |
> ---------------------    vlan2    |          -------- |
>                                   | veth1 -- | veth0| |
>                                   |          -------- |
>                                   --------------------|
> On Host A:
> # pktgen/pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_=
mac -s 64
>
> On Host B(Intel(R) Xeon(R) CPU E5-2690 v3 @ 2.60GHz, 128G Memory):
> Use xdp_redirect_map and xdp_redirect_map_multi in samples/bpf for testin=
g.
> The veth0 in netns load dummy drop program. The forward_map max_entries in
> xdp_redirect_map_multi is modify to 4.
>
> Here is the perf result with 5.10 rc6:
>
> The are about +/- 0.1M deviation for native testing
> Version             | Test                                    | Generic |=
 Native | Native + 2nd
> 5.10 rc6            | xdp_redirect_map        i40e->i40e      |    2.0M |=
   9.1M |  8.0M
> 5.10 rc6            | xdp_redirect_map        i40e->veth      |    1.7M |=
  11.0M |  9.7M
> 5.10 rc6 + patch1   | xdp_redirect_map        i40e->i40e      |    2.0M |=
   9.5M |  7.5M
> 5.10 rc6 + patch1   | xdp_redirect_map        i40e->veth      |    1.7M |=
  11.6M |  9.1M
> 5.10 rc6 + patch1-6 | xdp_redirect_map        i40e->i40e      |    2.0M |=
   9.5M |  7.5M
> 5.10 rc6 + patch1-6 | xdp_redirect_map        i40e->veth      |    1.7M |=
  11.6M |  9.1M
> 5.10 rc6 + patch1-6 | xdp_redirect_map_multi  i40e->i40e      |    1.7M |=
   7.8M |  6.4M
> 5.10 rc6 + patch1-6 | xdp_redirect_map_multi  i40e->veth      |    1.4M |=
   9.3M |  7.5M
> 5.10 rc6 + patch1-6 | xdp_redirect_map_multi  i40e->i40e+veth |    1.0M |=
   3.2M |  2.7M
>
> Last but not least, thanks a lot to Toke, Jesper, Jiri and Eelco for
> suggestions and help on implementation.

Nice work, and thank you for sticking with this! With the last couple of
fixes discussed for patch 1, when you resubmit please add my:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

for the series!

-Toke

