Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77C5C16F97C
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgBZITv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:19:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57811 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727311AbgBZITv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 03:19:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582705190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dlYksXQEZrSSpU84ghw6po3EDvEKVk217QVwvxPuf5E=;
        b=cuB3RQW3k5s+uuIjINgO+sH2X31wfkT6aSZBJZFZ3aV1o4PJSMD1nrFx84B3zHA4BkcSf0
        D1gD+z4HXJg/JQvqcvIFJgcPYssLjCrQZa58+4GcZF46Ax/3Z5ERiso1paQMwSrEG1bIE7
        XdB7cF2u16AKF3KBnZu4EvAPLnsV+Wk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-UzGHp0n7PBWc3JBuCLmUGA-1; Wed, 26 Feb 2020 03:19:48 -0500
X-MC-Unique: UzGHp0n7PBWc3JBuCLmUGA-1
Received: by mail-wr1-f72.google.com with SMTP id d9so1118304wrv.21
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 00:19:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=dlYksXQEZrSSpU84ghw6po3EDvEKVk217QVwvxPuf5E=;
        b=m/7tRmbrqNfjx5F85bFnQUZO94P8SGcTwCpkKvRtdgp0OyPF0XCFmpzI/YFjDuIJo2
         brAPcf7cOpE5/SBAl6bf/XIRp85XoYCU9+4QXUV3qUAPVr/sNotSYkcU19K9HkZ6/uiM
         vJGsZ8k66/WthhgyN0/oAYawfxqJgdVlkZOIRSnLaA7aQRYQ5yX1xHOrbPgnvg7kdAJ1
         hIXp1fg7IlMSVxwQyHM6+PCH5OgJNr/BL9kqQDYS/fADz3vGE2PuW3ZxTwgKbpfT+6gc
         gmRZslgT/2XUGZACKK6PYEh3RqwbWIoeND6Jedirp9SZZIZkDSd+x4W7LPNVPPotDbDm
         J5Fw==
X-Gm-Message-State: APjAAAVT+HJDTdd5H0wG56be/reiKfLYbRp3U+dLyou5IX2U7uzzrEte
        uHRUYUAwQ/vp5dFqNEORLPo6eiTO1R4yCt70w82VVrJ+30CKkFJzIRdUbMqTNsOwWyQuYYN5IzG
        PY7WrAFTMsy/DSXvt
X-Received: by 2002:a7b:c318:: with SMTP id k24mr4237485wmj.54.1582705187451;
        Wed, 26 Feb 2020 00:19:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqzF3GINK9QF1gZrgw3Wjos/4FZ9XRlxCmXYErdolEG86Sp89PZgGbzo0g5J58loMsKJGk9UiQ==
X-Received: by 2002:a7b:c318:: with SMTP id k24mr4237456wmj.54.1582705187200;
        Wed, 26 Feb 2020 00:19:47 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a198sm1964052wme.12.2020.02.26.00.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 00:19:46 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 027C7180362; Wed, 26 Feb 2020 09:19:45 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        David Ahern <dahern@digitalocean.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for using XDP
In-Reply-To: <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com>
References: <20200226005744.1623-1-dsahern@kernel.org> <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com> <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 26 Feb 2020 09:19:45 +0100
Message-ID: <87wo89zroe.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 2/25/20 8:00 PM, Jason Wang wrote:
>>=20
>> On 2020/2/26 =E4=B8=8A=E5=8D=888:57, David Ahern wrote:
>>> From: David Ahern <dahern@digitalocean.com>
>>>
>>> virtio_net currently requires extra queues to install an XDP program,
>>> with the rule being twice as many queues as vcpus. From a host
>>> perspective this means the VM needs to have 2*vcpus vhost threads
>>> for each guest NIC for which XDP is to be allowed. For example, a
>>> 16 vcpu VM with 2 tap devices needs 64 vhost threads.
>>>
>>> The extra queues are only needed in case an XDP program wants to
>>> return XDP_TX. XDP_PASS, XDP_DROP and XDP_REDIRECT do not need
>>> additional queues. Relax the queue requirement and allow XDP
>>> functionality based on resources. If an XDP program is loaded and
>>> there are insufficient queues, then return a warning to the user
>>> and if a program returns XDP_TX just drop the packet. This allows
>>> the use of the rest of the XDP functionality to work without
>>> putting an unreasonable burden on the host.
>>>
>>> Cc: Jason Wang <jasowang@redhat.com>
>>> Cc: Michael S. Tsirkin <mst@redhat.com>
>>> Signed-off-by: David Ahern <dahern@digitalocean.com>
>>> ---
>>> =C2=A0 drivers/net/virtio_net.c | 14 ++++++++++----
>>> =C2=A0 1 file changed, 10 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index 2fe7a3188282..2f4c5b2e674d 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -190,6 +190,8 @@ struct virtnet_info {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* # of XDP queue pairs currently used b=
y the driver */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16 xdp_queue_pairs;
>>> =C2=A0 +=C2=A0=C2=A0=C2=A0 bool can_do_xdp_tx;
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* I like... big packets and I cannot li=
e! */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool big_packets;
>>> =C2=A0 @@ -697,6 +699,8 @@ static struct sk_buff *receive_small(struct
>>> net_device *dev,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 len =3D xdp.data_end - xdp.data;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 break;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case XDP_TX:
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if =
(!vi->can_do_xdp_tx)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 goto err_xdp;
>>=20
>>=20
>> I wonder if using spinlock to synchronize XDP_TX is better than dropping
>> here?
>
> I recall you suggesting that. Sure, it makes for a friendlier user
> experience, but if a spinlock makes this slower then it goes against the
> core idea of XDP.

IMO a spinlock-arbitrated TX queue is something that should be available
to the user if configured (using that queue abstraction Magnus is
working on), but not the default, since as you say that goes against the
"performance first" mantra of XDP.

-Toke

