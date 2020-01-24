Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB643148B44
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 16:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388032AbgAXPbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 10:31:04 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36477 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387599AbgAXPbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 10:31:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579879862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7h5WWYpXM0AhhqzCXx3HLitAXt17+79fmo2qQPvwnK4=;
        b=C2o3b9BOknM4nj5J5thdUDkwsjAv1KFAhbTdZLIba/M5jv32YQ+HO1C3G0zh+Sm8iPRPug
        Nsa0D26Rv3GmEyeIe/L4zYDXaQN0s06+hzLuc4iUeajLTkEy8VUM9fUjDWi3xc4nSANjvB
        JxC7mf+tnPfFcv4Y+Tg5db6m+V5ETkk=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-fXLAgzWQMXi4QH677PeD3Q-1; Fri, 24 Jan 2020 10:30:55 -0500
X-MC-Unique: fXLAgzWQMXi4QH677PeD3Q-1
Received: by mail-lf1-f70.google.com with SMTP id v19so352671lfg.2
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 07:30:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=7h5WWYpXM0AhhqzCXx3HLitAXt17+79fmo2qQPvwnK4=;
        b=mb+1NyQOfE8BUwH6T5C8URJY+fUCAjq8Bse3XLCtvKmSyhcx7nrnhveqGtlQRKktaa
         8cC2nUUwPwDhosC+BYijR7MMhiMrnayOzX/v4Kk2DgGHQ5hodq9PFK5/PI4q4uTVVkWk
         q3bbDbpHD6YWT8kgSwsstW9zyeBr/fOcv5dwTaQPlWje9K1MSa9JCT0DX0DyazIS6GSJ
         DeJbTKV73MkabhIboWSbrkbPBtDJOGTSCbi8835ByjJ/QJ/mtQUQ19WE1j7Xb83vT9ez
         MrTd3d4Kpwd3guMfUTrqEKUFaHUS/gPhwkWvTcM3po7omPACsASdJAVMeXgtwZuCnYdb
         m0RQ==
X-Gm-Message-State: APjAAAVRvz5ZhOpSGA8FUhHWvlgMDzJOSrWDFwLYs/ujIiXmfn6hRKK+
        /HRtOk1JS9jWO6Toj6QDKCYSud3qPxK+Hry2JsiWylW9kEaBVtitK5K+dwRzMsr0kho0jky74/F
        OoJ9/3K9xYC8aS+Rw
X-Received: by 2002:a2e:7812:: with SMTP id t18mr2669635ljc.289.1579879853884;
        Fri, 24 Jan 2020 07:30:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqxsaUBPnOaFMegKrVMDPjpOsDoWTWZc2Icnpi+kKG4aDBmCkSxuBZ57z0F8tlH+zfN7GZSy0w==
X-Received: by 2002:a2e:7812:: with SMTP id t18mr2669625ljc.289.1579879853600;
        Fri, 24 Jan 2020 07:30:53 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 144sm2955991lfi.67.2020.01.24.07.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 07:30:52 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5A3D8180073; Fri, 24 Jan 2020 16:30:52 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Luigi Rizzo <lrizzo@google.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com
Subject: Re: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb linearization
In-Reply-To: <CAMOZA0+neBeXKDyQYxwP0MqC9TqGWV-d3S83z_EACH=iOEb6mw@mail.gmail.com>
References: <20200122203253.20652-1-lrizzo@google.com> <875zh2bis0.fsf@toke.dk> <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net> <87blqui1zu.fsf@toke.dk> <CAMOZA0Kmf1=ULJnbBUVKKjUyzqj2JKfp5ub769SNav5=B7VA5Q@mail.gmail.com> <875zh2hx20.fsf@toke.dk> <CAMOZA0JSZ2iDBk4NOUyNLVE_KmRzYHyEBmQWF+etnpcp=fe0kQ@mail.gmail.com> <b22e86ef-e4dd-14a3-fb1b-477d9e61fefa@iogearbox.net> <87r1zpgosp.fsf@toke.dk> <CAMOZA0+neBeXKDyQYxwP0MqC9TqGWV-d3S83z_EACH=iOEb6mw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Jan 2020 16:30:52 +0100
Message-ID: <87r1zog9cj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luigi Rizzo <lrizzo@google.com> writes:

> On Fri, Jan 24, 2020 at 1:57 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>
>> > On 1/23/20 7:06 PM, Luigi Rizzo wrote:
>> >> On Thu, Jan 23, 2020 at 10:01 AM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
>> >>> Luigi Rizzo <lrizzo@google.com> writes:
>> >>>> On Thu, Jan 23, 2020 at 8:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
>> >>>>> Daniel Borkmann <daniel@iogearbox.net> writes:
>> >>>>>> On 1/23/20 10:53 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >>>>>>> Luigi Rizzo <lrizzo@google.com> writes:
>> >>>>>>>
>> >>>>>>>> Add a netdevice flag to control skb linearization in generic xd=
p mode.
>> >>>>>>>> Among the various mechanism to control the flag, the sysfs
>> >>>>>>>> interface seems sufficiently simple and self-contained.
>> >>>>>>>> The attribute can be modified through
>> >>>>>>>>      /sys/class/net/<DEVICE>/xdp_linearize
>> >>>>>>>> The default is 1 (on)
>> >>>>>>
>> >>>>>> Needs documentation in Documentation/ABI/testing/sysfs-class-net.
>> >>>>>>
>> >>>>>>> Erm, won't turning off linearization break the XDP program's abi=
lity to
>> >>>>>>> do direct packet access?
>> >>>>>>
>> >>>>>> Yes, in the worst case you only have eth header pulled into linear
>> >>>>>> section. :/
>> >>>>>
>> >>>>> In which case an eBPF program could read/write out of bounds since=
 the
>> >>>>> verifier only verifies checks against xdp->data_end. Right?
>> >>>>
>> >>>> Why out of bounds? Without linearization we construct xdp_buff as f=
ollows:
>> >>>>
>> >>>> mac_len =3D skb->data - skb_mac_header(skb);
>> >>>> hlen =3D skb_headlen(skb) + mac_len;
>> >>>> xdp->data =3D skb->data - mac_len;
>> >>>> xdp->data_end =3D xdp->data + hlen;
>> >>>> xdp->data_hard_start =3D skb->data - skb_headroom(skb);
>> >>>>
>> >>>> so we shouldn't go out of bounds.
>> >>>
>> >>> Hmm, right, as long as it's guaranteed that the bit up to hlen is
>> >>> already linear; is it? :)
>> >>
>> >> honest question: that would be skb->len - skb->data_len, isn't that
>> >> the linear part by definition ?
>> >
>> > Yep, that's the linear part by definition. Generic XDP with ->data/->d=
ata_end is in
>> > this aspect no different from tc/BPF where we operate on skb context. =
Only linear part
>> > can be covered from skb (unless you pull in more via helper for the
>> > latter).
>>
>> OK, but then why are we linearising in the first place? Just to get
>> sufficient headroom?
>
> Looking at the condition in the if() it is both to make sufficient
> headroom available and have linear data so the bpf code can access all
> the packet data.

Ohhh, didn't realise that linearising also changes skb_headlen() - makes
so much more sense now :)

> My motivation for this change is that enforcing those guarantees has
> significant cost (even for native xdp in the cases I mentioned - mtu >
> 1 page, hw LRO, header split), and this is an interim solution to make
> generic skb usable without too much penalty.

Sure, that part I understand; I just don't like that this "interim"
solution makes generic and native XDP diverge further in their
semantics...

> In the long term I think it would be good if the xdp program could
> express its requirements at load time ("i just need header, I need at
> least 18 bytes of headroom..") and have the netdev or nic driver
> reconfigure as appropriate.

This may be interesting to include in the XDP feature detection
capabilities we've been discussing for some time. Our current thinking
is that the verifier should detect what a program does, rather than the
program having to explicitly declare what features it needs. See
https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org#note=
s-implementation-plan
for some notes on this :)

-Toke

