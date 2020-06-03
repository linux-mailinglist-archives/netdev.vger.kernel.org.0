Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66EF1ECDF7
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 13:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgFCLFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 07:05:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57571 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726013AbgFCLFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 07:05:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591182334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7/UZ1k1Tnz+0aL6W1DGoxSSobfkMGETgBO+uk6FERaM=;
        b=ILSU9p6/VVOB+KkR072dFRPzc8sWZtYoAiqqNbruIEQpO9hoJmUFvJ3Wh76FX0eYJgsg4k
        d7IZ0BCUZDB9PN6r+9Li8HJIjfBJsHpK004m9/nInKYmZiQQWd/pJNhHn3bFwb7AG9dHTh
        K3hl3sLF/it+m3onOht3/FIPbwr6GcE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-OicBOYy8OwyKoBeKRMEQng-1; Wed, 03 Jun 2020 07:05:33 -0400
X-MC-Unique: OicBOYy8OwyKoBeKRMEQng-1
Received: by mail-ej1-f71.google.com with SMTP id z20so616420ejf.23
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 04:05:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=7/UZ1k1Tnz+0aL6W1DGoxSSobfkMGETgBO+uk6FERaM=;
        b=Nql0X2YqiXwkTLih+IAp6ujFmxoOjFOAqkaBLGFMVw1XsvjYCcs60DUNKpocxW4XNf
         j7e31tEfa8y1mNwaNWUhJSYcOY+gro3rYpA9xJHC9ZhCgAe69KcfAIFC5+UxEc6kMIDX
         7TSCtfPaBjefTkh36aDZoVILFkO2JXIMoFHw3tp5aaUmxb6uB0OCxMIVM9L/xEHAABw6
         MuBux3ytubrnWZ2K9LldapfacPZUTs/3gD/7TRWkkiF2kJHP6oAVRZVsMp5g13BKp/uX
         ThIKoktPQUAIfOoN2fUQs7A6gj92gO4roEJEVeQKjDZKp7P550cggXJE6HzuuEV+2I4J
         ljrg==
X-Gm-Message-State: AOAM5330PzB4BC+lJBoXCZbz5A4wJMMIpXia/CW6UUvMU9rJIqcF4JgZ
        DroBVmYO9cE3Y8+F6eEIrS4N6p1bVZqZQfLlninAVeH/8uRQj3izNhv6cxy99pLJ54v9f9dDLzv
        RFhk6SVi1rVoF0Rec
X-Received: by 2002:a05:6402:311c:: with SMTP id dc28mr15417546edb.184.1591182330528;
        Wed, 03 Jun 2020 04:05:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPv1J7mEIffBwXirBApKMnotEG2ItUqEy0W7mVGX7vHKGQMpxhiGMUsPP5lgXN4El4jaQIDg==
X-Received: by 2002:a05:6402:311c:: with SMTP id dc28mr15417508edb.184.1591182330204;
        Wed, 03 Jun 2020 04:05:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id s14sm933965ejd.111.2020.06.03.04.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 04:05:28 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 64AED182797; Wed,  3 Jun 2020 13:05:28 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
In-Reply-To: <20200603024054.GK102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com> <20200526140539.4103528-1-liuhangbin@gmail.com> <87zh9t1xvh.fsf@toke.dk> <20200603024054.GK102436@dhcp-12-153.nay.redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 03 Jun 2020 13:05:28 +0200
Message-ID: <87img8l893.fsf@toke.dk>
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
>> need results from a physical setup in native mode to assess the impact
>> on the native-XDP fast path. The numbers above don't tell much in this
>> regard. I'd also like to see a before/after patch for straight
>> bpf_redirect_map(), since you're messing with the fast path, and we want
>> to make sure it's not causing a performance regression for regular
>> redirect.
>>=20
>> Finally, since the overhead seems to be quite substantial: A comparison
>> with a regular network stack bridge might make sense? After all we also
>> want to make sure it's a performance win over that :)
>
> Hi Toke,
>
> Here is the result I tested with 2 i40e 10G ports on physical machine.
> The pktgen pkt_size is 64.

These numbers seem a bit low (I'm getting ~8.5MPPS on my test machine
for a simple redirect). Some of that may just be performance of the
machine, I guess (what are you running this on?), but please check that
you are not limited by pktgen itself - i.e., that pktgen is generating
traffic at a higher rate than what XDP is processing.

> Bridge forwarding(I use sample/bpf/xdp1 to count the PPS, so there are tw=
o modes data):
> generic mode: 1.32M PPS
> driver mode: 1.66M PPS

I'm not sure I understand this - what are you measuring here exactly?

> xdp_redirect_map:
> generic mode: 1.88M PPS
> driver mode: 2.74M PPS

Please add numbers without your patch applied as well, for comparison.

> xdp_redirect_map_multi:
> generic mode: 1.38M PPS
> driver mode: 2.73M PPS

I assume this is with a single interface only, right? Could you please
add a test with a second interface (so the packet is cloned) as well?
You can just use a veth as the second target device.

-Toke

