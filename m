Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B707E147036
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 19:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAWSAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 13:00:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25830 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728139AbgAWSAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 13:00:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579802432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SURp79mQ1aWheXmLFMLuyPYyGs6CsMhHsW05tKmUFK4=;
        b=Iv4L1YCc+MkIlPkgR2uhIoI4Khw6YCsNtVKkrp8YnBtRoAG4VKzsdPkrDv6bIwR0rdHe6u
        RQtwQ2oQjmwhHU5gUN+qn95uLkJ5qraCLh+B1fdGuHXMQuMzzu8wyOBs0BomCyjYNJvjIw
        ww7zkz5Hwm2gkweOI8HfHlbYb/Sqfps=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-2PMM2LVAOMGoWiZO5HK-3g-1; Thu, 23 Jan 2020 13:00:30 -0500
X-MC-Unique: 2PMM2LVAOMGoWiZO5HK-3g-1
Received: by mail-lj1-f199.google.com with SMTP id b15so1324243ljp.7
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 10:00:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=SURp79mQ1aWheXmLFMLuyPYyGs6CsMhHsW05tKmUFK4=;
        b=Ie9jBR1k3MsEJPikBrTgJk70TW2yalQ+Ogbv7fIfzE68WCiPqPS7jDSUWmc7zH4SZM
         G9J8wnM94Tsc5c4BjcYOyKliU3lKMM7HQmbOxlcEb7jWx2C1j5D6hE+/rr6AczS/ZRc4
         Pq4m49CE1vu30Ag0G+3YS+PjyhrLNT2kwY7ceU1Rj20V7D+ocJ0wAHx8/hAsAAH1NJ/I
         QrcwUwg5487SA/HbPSOfrRmY5qv6Wf7LELsB90ok4CzTP/hRcMrC2yBd7Fx06ALGq6tq
         eSS9k6Fx++geKxdve3BFU+t/wefvSBI38D60zJSg5rXbA7oWZk5/rQLCBJUw9n5JFX9o
         7w7A==
X-Gm-Message-State: APjAAAWTtJedTTXS57dnWxDNJxi9ZNdapYly2u5WrDtk7NnL7XVTdsJ+
        H4Bk85bm3x7WHWQ7VUIlTwzQCuXAM+KEGjJZjNjCfXRUN5G1hSAFBV9N87IlLo529wZ8z4U50kb
        XL+eVs1ycbDrtFZBm
X-Received: by 2002:a2e:9850:: with SMTP id e16mr24414429ljj.268.1579802428492;
        Thu, 23 Jan 2020 10:00:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqyRwHWHzj+J0uta8wK+tThtX1pIIGq7EzlgTqPKQIzaYpX99w0BfJZwpfpKPST4R3QLN3JWCA==
X-Received: by 2002:a2e:9850:: with SMTP id e16mr24414422ljj.268.1579802428258;
        Thu, 23 Jan 2020 10:00:28 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id z3sm1680663ljh.83.2020.01.23.10.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 10:00:27 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D1ADB18006C; Thu, 23 Jan 2020 19:00:26 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Luigi Rizzo <lrizzo@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com
Subject: Re: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb linearization
In-Reply-To: <CAMOZA0K-0LOGMXdFecRUHmyoOmOUabsgvzwA35jB-T=5tzV_TA@mail.gmail.com>
References: <20200122203253.20652-1-lrizzo@google.com> <875zh2bis0.fsf@toke.dk> <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net> <CAMOZA0K-0LOGMXdFecRUHmyoOmOUabsgvzwA35jB-T=5tzV_TA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 23 Jan 2020 19:00:26 +0100
Message-ID: <878slyhx39.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luigi Rizzo <lrizzo@google.com> writes:

> On Thu, Jan 23, 2020 at 7:48 AM Daniel Borkmann <daniel@iogearbox.net> wr=
ote:
>>
>> On 1/23/20 10:53 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> > Luigi Rizzo <lrizzo@google.com> writes:
>> >
>> >> Add a netdevice flag to control skb linearization in generic xdp mode.
>> >> Among the various mechanism to control the flag, the sysfs
>> >> interface seems sufficiently simple and self-contained.
>> >> The attribute can be modified through
>> >>      /sys/class/net/<DEVICE>/xdp_linearize
>> >> The default is 1 (on)
>>
>> Needs documentation in Documentation/ABI/testing/sysfs-class-net.
>>
>> > Erm, won't turning off linearization break the XDP program's ability to
>> > do direct packet access?
>>
>> Yes, in the worst case you only have eth header pulled into linear secti=
on. :/
>> In tc/BPF for direct packet access we have bpf_skb_pull_data() helper wh=
ich can
>> pull in up to X bytes into linear section on demand. I guess something l=
ike this
>> could be done for XDP context as well, e.g. generic XDP would pull when =
non-linear
>> and native XDP would have nothing todo (though in this case you end up w=
riting the
>> prog specifically for generic XDP with slowdown when you'd load it on na=
tive XDP
>> where it's linear anyway, but that could/should be documented if so).
>
> There was some discussion on multi-segment xdp
> https://www.spinics.net/lists/netdev/msg620140.html
> https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-mul=
ti-buffer01-design.org
>
> with no clear decision as far as I can tell.
>
> I wanted to point out that linearization might be an issue for native
> xdp as well (specifically with NICs that do header split, LRO,
> scatter-gather, MTU pagesize ...) and having to unconditionally pay
> the linearization cost (or disable the above features) by just loading
> an xdp program may be a big performance hit.

Right, sure, but then I'd rather fix it for all of XDP instead of
introduce (more) differences between native and generic mode...

-Toke

