Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5675D1EE488
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 14:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgFDMhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 08:37:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47638 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725939AbgFDMhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 08:37:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591274249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kquYy76F09s7QEUlaaL68R25XV+jPzvTQWOpQnKqdsU=;
        b=Z518ro9zDlGZ6KvvWUUAvdF7t1JSQ/UoY2Fd1XsEn398luV/MD+s+L9P7Qz0Q4iCGySjUR
        kSUmsju/nm3NhKhyeaiTE4wNTB0Zt82xRappAzGrI0vvV/x7GbYqFl0XJY33GKqWZwDKR7
        LozqQNw/ykpY4gYIV3KftuuUnrZWp4E=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-0uQVopa_MKazLqRGbslYwQ-1; Thu, 04 Jun 2020 08:37:26 -0400
X-MC-Unique: 0uQVopa_MKazLqRGbslYwQ-1
Received: by mail-ej1-f69.google.com with SMTP id f27so2074866ejt.17
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 05:37:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=kquYy76F09s7QEUlaaL68R25XV+jPzvTQWOpQnKqdsU=;
        b=NSHdGI3gBpcLYFtd+ySL4kmDaPcsGW+oB7fkdwAfWMTgk4yCWa/baWHZQd4XSX3AUu
         3k0bdKt0Lr0xyjBlVPl+ty3g2K6Bp7spc0iiwH8Dc4X6gXgFNpH2C5SE5V4PaEH3vXDh
         lNEHqzdLkLuHBRtbubk7dXlTQ8tR10KpL7PWZrX0wpiDRPvFA0OXP6Pfacmxms5rxuAt
         /1c1G85F8kwGC8VdPIYDbQunCJJndwoUKyPkMe01kmJX1sfWgZPvu/EETGRN+PLqu2Aa
         yTKyULhqNjwnSduXr3BqZWivl4rMOaRtyX0alLK389fFZjn7uE9u853uoWtSSQJKt9Bp
         wAtA==
X-Gm-Message-State: AOAM532ElriRYzSu+PM0mymM5AL2sRCy+HCqAhYB8ysI70+P+YkpI0CP
        +tLNga5XO+esI7FAqi6ZZb+hrpaqkGmTTzxsR89//hzdOCtXpsQMqcNHlN1dhTYxhQ8gAzSvWI4
        N1ZOg2XOhnkS+19es
X-Received: by 2002:a17:906:fac8:: with SMTP id lu8mr3598287ejb.432.1591274245408;
        Thu, 04 Jun 2020 05:37:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwtK/NJDmkwOA7EmXWCJdVOxnGffbfyIv6uAhKOfD4ukSuFgGRK7ZcnswcuNIvygwt7MLdwIA==
X-Received: by 2002:a17:906:fac8:: with SMTP id lu8mr3598266ejb.432.1591274245094;
        Thu, 04 Jun 2020 05:37:25 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e4sm2244682edy.17.2020.06.04.05.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 05:37:24 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8AD65182797; Thu,  4 Jun 2020 14:37:23 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
In-Reply-To: <20200604121212.GM102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com> <20200526140539.4103528-1-liuhangbin@gmail.com> <87zh9t1xvh.fsf@toke.dk> <20200603024054.GK102436@dhcp-12-153.nay.redhat.com> <87img8l893.fsf@toke.dk> <20200604040940.GL102436@dhcp-12-153.nay.redhat.com> <871rmvkvwn.fsf@toke.dk> <20200604121212.GM102436@dhcp-12-153.nay.redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 04 Jun 2020 14:37:23 +0200
Message-ID: <87bllzj9bw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> On Thu, Jun 04, 2020 at 11:44:24AM +0200, Toke H=C3=83=C6=92=C3=82=C2=B8i=
land-J=C3=83=C6=92=C3=82=C2=B8rgensen wrote:
>> Hangbin Liu <liuhangbin@gmail.com> writes:
>> > Here is the test topology, which looks like
>> >
>> >  Host A    |     Host B        |        Host C
>> >  eth0      +    eth0 - eth1    +        eth0
>> >
>> > I did pktgen sending on Host A, forwarding on Host B.
>> > Host B is a Dell PowerEdge R730 (128G memory, Intel(R) Xeon(R) CPU E5-=
2690 v3)
>> > eth0, eth1 is an onboard i40e 10G driver
>> >
>> > Test 1: add eth0, eth1 to br0 and test bridge forwarding
>> > Test 2: Test xdp_redirect_map(), eth0 is ingress, eth1 is egress
>> > Test 3: Test xdp_redirect_map_multi(), eth0 is ingress, eth1 is egress
>>=20
>> Right, that all seems reasonable, but that machine is comparable to
>> my test machine, so you should be getting way more than 2.75 MPPS on a
>> regular redirect test. Are you bottlenecked on pktgen or something?
>
> Yes, I found the pktgen is bottleneck. I only use 1 thread.
> By using the cmd you gave to me
> ./pktgen_sample03_burst_single_flow.sh  -i eno1 -d 192.168.200.1 -m f8:bc=
:12:14:11:20 -t 4  -s 64
>
> Now I could get higher speed.
>
>>=20
>> Could you please try running Jesper's ethtool stats poller:
>> https://github.com/netoptimizer/network-testing/blob/master/bin/ethtool_=
stats.pl
>
> Nice tool.
>
>> > I though you want me also test with bridge forwarding. Am I missing so=
mething?
>>=20
>> Yes, but what does this mean:
>> > (I use sample/bpf/xdp1 to count the PPS, so there are two modes data):
>>=20
>> or rather, why are there two numbers? :)
>
> Just as it said, to test bridge forwarding speed. I use the xdp tool
> sample/bpf/xdp1 to count the PPS. But there are two modes when attach xdp
> to eth0, general and driver mode. So there are 2 number..
>
> Now I use the ethtool_stats.pl to count forwarding speed and here is the =
result:
>
> With kernel 5.7(ingress i40e, egress i40e)
> XDP:
> bridge: 1.8M PPS
> xdp_redirect_map:
>   generic mode: 1.9M PPS
>   driver mode: 10.4M PPS

Ah, now we're getting somewhere! :)

> Kernel 5.7 + my patch(ingress i40e, egress i40e)
> bridge: 1.8M
> xdp_redirect_map:
>   generic mode: 1.86M PPS
>   driver mode: 10.17M PPS

Right, so this corresponds to a ~2ns overhead (10**9/10400000 -
10**9/10170000). This is not too far from being in the noise, I suppose;
is the difference consistent?

> xdp_redirect_map_multi:
>   generic mode: 1.53M PPS
>   driver mode: 7.22M PPS
>
> Kernel 5.7 + my patch(ingress i40e, egress veth)
> xdp_redirect_map:
>   generic mode: 1.38M PPS
>   driver mode: 4.15M PPS
> xdp_redirect_map_multi:
>   generic mode: 1.13M PPS
>   driver mode: 3.55M PPS
>
> Kernel 5.7 + my patch(ingress i40e, egress i40e + veth)
> xdp_redirect_map_multi:
>   generic mode: 1.13M PPS
>   driver mode: 3.47M PPS
>
> I added a group that with i40e ingress and veth egress, which shows
> a significant drop on the speed. It looks like veth driver is a bottlenec=
k,
> but I don't have more i40e NICs on the test bed...

I suspect this may be because veth ends up creating an SKB for each
packet after receiving the frame on the peer device (even though it's
immediately dropped). Could you please try adding an XDP program that
drops the packets on the veth peer of your target, and see if that
helps?

-Toke

