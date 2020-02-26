Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C1616F9A1
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgBZIfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:35:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35624 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726425AbgBZIfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 03:35:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582706104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5yARALmnL1WYSsmPg0kY7kccKehBg+4EWgh2EPe0+cE=;
        b=VCPBK2fwgAbF0QFnqukGjFShrkwGGupWT7oHGK02pdnKNxf9kw+hmC3up0YIKyIySwakmB
        lzyovEhEq7mdZzL+TcfV4O4gCtZ6oafweZAlhPhCYGCWQ7HgDmJSz4ZVxgD4jntYNvBfQ0
        Z+A0MIGqkyQYjnez44YNQMlwE/VelTw=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-aiecN2ofP3qTsxREvP9NcQ-1; Wed, 26 Feb 2020 03:34:55 -0500
X-MC-Unique: aiecN2ofP3qTsxREvP9NcQ-1
Received: by mail-lf1-f72.google.com with SMTP id u20so425141lfu.18
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 00:34:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=5yARALmnL1WYSsmPg0kY7kccKehBg+4EWgh2EPe0+cE=;
        b=KPNvRlP1Inv8NhWaXQweq3VWlhno2RtdGMhufpcnl4XNTXWttiI1/LPhzxlwHZKB3Z
         ck7bett1Vh7PVzNUWYtBZPE9cD01lCA1jIssTvt0v4glZ4LesV98kl9go7boqiVEHmWs
         EMbculwsp83VyqnERzasUHXkGMmAzsJfbwsYeQOHiNK9dIAtR4+3QNq1NiNWDiUNnka1
         Ass+QVAnj/PAjaUoNJeQXIRf3Or6cvrxJJ+aBIPHoqqwpRQzStyTUtwbXWE90/4H9726
         sEOq0yJq/GyBdzpxTIigP9GKFAG9SXXRHXLIcuqT/eWPWxqCSdbh22S6op+gu5G8VkUT
         isiQ==
X-Gm-Message-State: ANhLgQ20Jif0nEcr3Y9vAhXhL6XfxdutMe7C8S396ELMWGum5MOBtscX
        07cs0ySVORt75uTZTppEBeoLnPyyrVAM/FFRdGqCARwZbA8ULQlsoLCXnTDF1q6HtSdZCiLAXnP
        xKtbSRJ8fOXMu+nTi
X-Received: by 2002:a2e:98ca:: with SMTP id s10mr2221620ljj.160.1582706094337;
        Wed, 26 Feb 2020 00:34:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqyQNUNJjfGmFl4jXHLcYR67uf3D0c2wx9zW+9pBQGW0cwJuS9R3Uu1tBD0pKBBYUPkm2uzKag==
X-Received: by 2002:a2e:98ca:: with SMTP id s10mr2221611ljj.160.1582706094064;
        Wed, 26 Feb 2020 00:34:54 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id j7sm731051ljg.25.2020.02.26.00.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 00:34:53 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7B142180362; Wed, 26 Feb 2020 09:34:51 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for using XDP
In-Reply-To: <20200226032204-mutt-send-email-mst@kernel.org>
References: <20200226005744.1623-1-dsahern@kernel.org> <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com> <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com> <87wo89zroe.fsf@toke.dk> <20200226032204-mutt-send-email-mst@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 26 Feb 2020 09:34:51 +0100
Message-ID: <87r1yhzqz8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> On Wed, Feb 26, 2020 at 09:19:45AM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> David Ahern <dsahern@gmail.com> writes:
>>=20
>> > On 2/25/20 8:00 PM, Jason Wang wrote:
>> >>=20
>> >> On 2020/2/26 =E4=B8=8A=E5=8D=888:57, David Ahern wrote:
>> >>> From: David Ahern <dahern@digitalocean.com>
>> >>>
>> >>> virtio_net currently requires extra queues to install an XDP program,
>> >>> with the rule being twice as many queues as vcpus. From a host
>> >>> perspective this means the VM needs to have 2*vcpus vhost threads
>> >>> for each guest NIC for which XDP is to be allowed. For example, a
>> >>> 16 vcpu VM with 2 tap devices needs 64 vhost threads.
>> >>>
>> >>> The extra queues are only needed in case an XDP program wants to
>> >>> return XDP_TX. XDP_PASS, XDP_DROP and XDP_REDIRECT do not need
>> >>> additional queues. Relax the queue requirement and allow XDP
>> >>> functionality based on resources. If an XDP program is loaded and
>> >>> there are insufficient queues, then return a warning to the user
>> >>> and if a program returns XDP_TX just drop the packet. This allows
>> >>> the use of the rest of the XDP functionality to work without
>> >>> putting an unreasonable burden on the host.
>> >>>
>> >>> Cc: Jason Wang <jasowang@redhat.com>
>> >>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> >>> Signed-off-by: David Ahern <dahern@digitalocean.com>
>> >>> ---
>> >>> =C2=A0 drivers/net/virtio_net.c | 14 ++++++++++----
>> >>> =C2=A0 1 file changed, 10 insertions(+), 4 deletions(-)
>> >>>
>> >>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> >>> index 2fe7a3188282..2f4c5b2e674d 100644
>> >>> --- a/drivers/net/virtio_net.c
>> >>> +++ b/drivers/net/virtio_net.c
>> >>> @@ -190,6 +190,8 @@ struct virtnet_info {
>> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* # of XDP queue pairs currently use=
d by the driver */
>> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16 xdp_queue_pairs;
>> >>> =C2=A0 +=C2=A0=C2=A0=C2=A0 bool can_do_xdp_tx;
>> >>> +
>> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* I like... big packets and I cannot=
 lie! */
>> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool big_packets;
>> >>> =C2=A0 @@ -697,6 +699,8 @@ static struct sk_buff *receive_small(stru=
ct
>> >>> net_device *dev,
>> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 len =3D xdp.data_end - xdp.data;
>> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 break;
>> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case XDP_TX:
>> >>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
if (!vi->can_do_xdp_tx)
>> >>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 goto err_xdp;
>> >>=20
>> >>=20
>> >> I wonder if using spinlock to synchronize XDP_TX is better than dropp=
ing
>> >> here?
>> >
>> > I recall you suggesting that. Sure, it makes for a friendlier user
>> > experience, but if a spinlock makes this slower then it goes against t=
he
>> > core idea of XDP.
>>=20
>> IMO a spinlock-arbitrated TX queue is something that should be available
>> to the user if configured (using that queue abstraction Magnus is
>> working on), but not the default, since as you say that goes against the
>> "performance first" mantra of XDP.
>>=20
>> -Toke
>
> OK so basically there would be commands to configure which TX queue is
> used by XDP. With enough resources default is to use dedicated queues.
> With not enough resources default is to fail binding xdp program
> unless queues are specified. Does this sound reasonable?

Yeah, that was the idea. See this talk from LPC last year for more
details: https://linuxplumbersconf.org/event/4/contributions/462/

> It remains to define how are changes in TX queue config handled.
> Should they just be disallowed as long as there's an active XDP program?

Well that would depend on what is possible for each device, I guess? But
we already do block some reconfiguration if an XDP program is loaded
(such as MTU changes), so there is some precedence for that :)

-Toke

