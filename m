Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167063B9DB7
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 10:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhGBIxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 04:53:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230432AbhGBIw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 04:52:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625215826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=idGFJiYbbrfRZhGeXXIhSqzFn63Lgkfff+ycqPA09E4=;
        b=i0Be3hb9r1caPCzBWGh9eg/8QwJDG+r7zZNt7TAK7RUE/LknFR37p1g5EoRMQ7ip6U/KZT
        WuLJU7lGarM2DOvW+WAIl+Pa0OAYEtW06B7FtKT8LDQ4MamZ/aPDQZ6kiA726WX8KR2LBF
        /17pzOeZfpsr4KkThj9YcvtFHLIBlyw=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-syIlf_nDMdiLKP5sQz-akw-1; Fri, 02 Jul 2021 04:50:25 -0400
X-MC-Unique: syIlf_nDMdiLKP5sQz-akw-1
Received: by mail-pj1-f72.google.com with SMTP id c5-20020a17090a1d05b029016f9eccfcd6so4841042pjd.0
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 01:50:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=idGFJiYbbrfRZhGeXXIhSqzFn63Lgkfff+ycqPA09E4=;
        b=f1XoD3yEk+ULGIIkfTnIOh4RTluXx7i+yKJ+BCbwLYPSIStXBzEXzmlFXaupUARLWv
         xzpOXoXNOexub+16SCkqQRACkUAtcsur39AwOujaVDu18HcqluJlBqrMCH8kmbOxfp62
         WXsy4WUsZIkAMPlvrU79OZFQEn864jLg1rLg+Z5VX3/N4HMlzdUWobgul4TKy6nqh9LT
         Rz01a7fPvhmspVRbavn2zVXmdT5GtCABdJyZKEvD/ayn3gsYF9xLCBlLKpRZ0Aq+7GLz
         6eeYgxZHXJCda0A5RB4mgyVXkL1wAMT4UX0QjlI/uJLEVF341i4rdp6+DNLn+zk0gJsx
         gPGw==
X-Gm-Message-State: AOAM530EAv9b0UKPVeVnv5JMMeYNtuTf7UM/dIo3ZzF1hjMSTQQ3xOzi
        cdi7N9jPvyO8D79W2+QkzUMgbICzGx6Lv5QBCdJ11a+zwHN4BJJD09uGwVrej58taovZNa0CNlM
        jZcjNXYjxzdIS6C0r
X-Received: by 2002:a63:d811:: with SMTP id b17mr757449pgh.286.1625215824938;
        Fri, 02 Jul 2021 01:50:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydIQX2I2G2PSODiZsW8zZUHFAreLKSrE4JAOpDSzzUkzXFgrdVzkCNTmd3AQu+bOBg45o7SA==
X-Received: by 2002:a63:d811:: with SMTP id b17mr757428pgh.286.1625215824699;
        Fri, 02 Jul 2021 01:50:24 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v3sm2765189pfb.126.2021.07.02.01.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 01:50:24 -0700 (PDT)
Subject: Re: [PATCH v3 3/5] vhost_net: remove virtio_net_hdr validation, let
 tun/tap do it themselves
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "Michael S.Tsirkin" <mst@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org>
 <20210624123005.1301761-3-dwmw2@infradead.org>
 <b339549d-c8f1-1e56-2759-f7b15ee8eca1@redhat.com>
 <bfad641875aff8ff008dd7f9a072c5aa980703f4.camel@infradead.org>
 <1c6110d9-2a45-f766-9d9a-e2996c14b748@redhat.com>
 <72dfecd426d183615c0dd4c2e68690b0e95dd739.camel@infradead.org>
 <80f61c54a2b39cb129e8606f843f7ace605d67e0.camel@infradead.org>
 <99496947-8171-d252-66d3-0af12c62fd2c@redhat.com>
 <cdf3fe3ceff17bc2a5aaf006577c1cb0bef40f3a.camel@infradead.org>
 <500370cc-d030-6c2d-8e96-533a3533a8e2@redhat.com>
 <aa70346d6983a0146b2220e93dac001706723fe3.camel@infradead.org>
 <b6192a2a-0226-2767-46b2-ae61494a8ae7@redhat.com>
 <1d5b8251e8d9e67613295d5b7f51c49c1ee8c0a8.camel@infradead.org>
 <ccf524ce-17f8-3763-0f86-2afbcf6aa6fc@redhat.com>
 <511df01a3641c2010d875a61161d6da7093abd4a.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <505413fd-f148-b8d8-425d-69e7dcf53548@redhat.com>
Date:   Fri, 2 Jul 2021 16:50:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <511df01a3641c2010d875a61161d6da7093abd4a.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/7/2 下午4:08, David Woodhouse 写道:
> On Fri, 2021-07-02 at 11:13 +0800, Jason Wang wrote:
>> 在 2021/7/2 上午1:39, David Woodhouse 写道:
>>> Right, but the VMM (or the guest, if we're letting the guest choose)
>>> wouldn't have to use it for those cases.
>>
>> I'm not sure I get here. If so, simply write to TUN directly would work.
> As noted, that works nicely for me in OpenConnect; I just write it to
> the tun device *instead* of putting it in the vring. My TX latency is
> now fine; it's just RX which takes *two* scheduler wakeups (tun wakes
> vhost thread, wakes guest).


Note that busy polling is used for KVM to improve the latency as well. 
It was enabled by default if I was not wrong.


>
> But it's not clear to me that a VMM could use it. Because the guest has
> already put that packet *into* the vring. Now if the VMM is in the path
> of all wakeups for that vring, I suppose we *might* be able to contrive
> some hackish way to be 'sure' that the kernel isn't servicing it, so we
> could try to 'steal' that packet from the ring in order to send it
> directly... but no. That's awful :)


Yes.


>
> I do think it'd be interesting to look at a way to reduce the latency
> of the vring wakeup especially for that case of a virtio-net guest with
> a single small packet to send. But realistically speaking, I'm unlikely
> to get to it any time soon except for showing the numbers with the
> userspace equivalent and observing that there's probably a similar win
> to be had for guests too.
>
> In the short term, I should focus on what we want to do to finish off
> my existing fixes.


I think so.


> Did we have a consensus on whether to bother
> supporting PI?


Michael, any thought on this?


>   As I said, I'm mildly inclined to do so just because it
> mostly comes out in the wash as we fix everything else, and making it
> gracefully *refuse* that setup reliably is just as hard.
>
> I think I'll try to make the vhost-net code much more resilient to
> finding that tun_recvmsg() returns a header other than the sock_hlen it
> expects, and see how much still actually needs "fixing" if we can do
> that.


Let's see how well it goes.


>
>
>> I think the design is to delay the tx checksum as much as possible:
>>
>> 1) host RX -> TAP TX -> Guest RX -> Guest TX -> TX RX -> host TX
>> 2) VM1 TX -> TAP RX -> switch -> TX TX -> VM2 TX
>>
>> E.g  if the checksum is supported in all those path, we don't need any
>> software checksum at all in the above path. And if any part is not
>> capable of doing checksum, the checksum will be done by networking core
>> before calling the hard_start_xmit of that device.
> Right, but in *any* case where the 'device' is going to memcpy the data
> around (like tun_put_user() does), it's a waste of time having the
> networking core do a *separate* pass over the data just to checksum it.


See below.


>
>>>>> We could similarly do a partial checksum in tun_get_user() and hand it
>>>>> off to the network stack with ->ip_summed == CHECKSUM_PARTIAL.
>>>> I think that's is how it is expected to work (via vnet header), see
>>>> virtio_net_hdr_to_skb().
>>> But only if the "guest" supports it; it doesn't get handled by the tun
>>> device. It *could*, since we already have the helpers to checksum *as*
>>> we copy to/from userspace.
>>>
>>> It doesn't help for me to advertise that I support TX checksums in
>>> userspace because I'd have to do an extra pass for that. I only do one
>>> pass over the data as I encrypt it, and in many block cipher modes the
>>> encryption of the early blocks affects the IV for the subsequent
>>> blocks... do I can't just go back and "fix" the checksum at the start
>>> of the packet, once I'm finished.
>>>
>>> So doing the checksum as the packet is copied up to userspace would be
>>> very useful.
>>
>> I think I get this, but it requires a new TUN features (and maybe make
>> it userspace controllable via tun_set_csum()).
> I don't think it's visible to userspace at all; it's purely between the
> tun driver and the network stack. We *always* set NETIF_F_HW_CSUM,
> regardless of what the user can cope with. And if the user *didn't*
> support checksum offload then tun will transparently do the checksum
> *during* the copy_to_iter() (in either tun_put_user_xdp() or
> tun_put_user()).
>
> Userspace sees precisely what it did before. If it doesn't support
> checksum offload then it gets a pre-checksummed packet just as before.
> It's just that the kernel will do that checksum *while* it's already
> touching the data as it copies it to userspace, instead of in a
> separate pass.


So I kind of get what did you meant:

1) Don't disable NETIF_F_HW_CSUM in tun_set_csum() even if userspace 
clear TUN_F_CSUM.
2) Use csum iov iterator helper in tun_put_user() and tun_put_user_xdp()

It may help for the performance since we get better cache locality if 
userspace doesn't support checksum offload.

But in this case we need to know if userspace can do the checksum 
offload which we don't need to care previously (via NETIF_F_HW_CSUM).

And we probably need to sync with tun_set_offload().


>
> Although actually, for my *benchmark* case with iperf3 sending UDP, I
> spotted in the perf traces that we actually do the checksum as we're
> copying from userspace in the udp_sendmsg() call. There's a check in
> __ip_append_data() which looks to see if the destination device has
> HW_CSUM|IP_CSUM features, and does the copy-and-checksum if not. There
> are definitely use cases which *don't* have that kind of optimisation
> though, and packets that would reach tun_net_xmit() with CHECKSUM_NONE.
> So I think it's worth looking at.


Yes.

Thanks

