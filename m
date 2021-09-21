Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEE8412FFD
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 10:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhIUIOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 04:14:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27904 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230508AbhIUIOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 04:14:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632211962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PwBUVVtsJHhOv14YYtGqRLEtGD/RYWBYKUPNk/X9piI=;
        b=YiTCsVFioP5tO393ok7jjv1JcWN/GOqx4weEUFjWh1GHUUaWrQaEYb2sFZVEr4CCgcgE/Z
        gRYaqaChQ2TOhL+z3fKFoGLjz7Wd0Gwj6OAL036LPPrfxYzWvkjlDsAswnOo5QtR8HiEH6
        K/irTRBWVZEe7hi7nXfPlfbc5cZEspY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-mkHfYcSpM-KlP51_WX0bBw-1; Tue, 21 Sep 2021 04:12:41 -0400
X-MC-Unique: mkHfYcSpM-KlP51_WX0bBw-1
Received: by mail-qv1-f72.google.com with SMTP id z8-20020a056214040800b00380dea65c01so6766052qvx.4
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 01:12:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=PwBUVVtsJHhOv14YYtGqRLEtGD/RYWBYKUPNk/X9piI=;
        b=rTIjzEf44s9CfV+FrLhJlx0QM+yuumtdFukomooeJGUhBwYOuig1fQ7Fxdfh259/xZ
         /zz69UAKBKqCFNZJ6+XAB7srx3uPD947S1iH0Pop42n3hA9YaXafna/ogyLJ50UQhb6P
         iXG7kn5Bo6NbqPgakNzntBsNrWDZ9ELS1IXZM5jzNT8TlqiW8S8T7Te83ixLVlC09xXb
         M3UhX5ncYyaGZunkzhfimvHGCjo54nhP5uXhhyknEyob9zrgrz6Fglks3qN3lydfzPZ4
         9ffw4TxjHGj9fzvJlpXsrlIl3NHzxcclt7dLV8xOGYpOMSEeDP7cPpRDh9sNmnOUNt08
         /C3g==
X-Gm-Message-State: AOAM533umTBnDnnswasIG9JbC2cAVhFZ1KHmVwaIQRdBoSbfv2kGw9AV
        1ZRaWQ1KhzSI2y21B3SrCXoC0ScMCTySLPSh6R/8k8xng6pKs6qOw3MAZ3ARJ7NmH1PFQ1+IvzN
        1evxDy/VfwxzzVPqBxfzhU8tgvTupCsXp
X-Received: by 2002:ac8:3d51:: with SMTP id u17mr27469822qtf.348.1632211960708;
        Tue, 21 Sep 2021 01:12:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykGtL87jR6HlwGG1KM0K5tu/IUnpv4qtvZ/EBDUgXAtneNUt3VnhKya9wydlzFXccpzoDa1GzYD8lEO8xS6io=
X-Received: by 2002:ac8:3d51:: with SMTP id u17mr27469802qtf.348.1632211960380;
 Tue, 21 Sep 2021 01:12:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210920153454.433252-1-atenart@kernel.org> <b3bee3ec-72c0-0cbf-d1ce-65796907812f@gmail.com>
In-Reply-To: <b3bee3ec-72c0-0cbf-d1ce-65796907812f@gmail.com>
From:   Luis Tomas Bolivar <ltomasbo@redhat.com>
Date:   Tue, 21 Sep 2021 10:12:29 +0200
Message-ID: <CAAxCcbsrjvp=vP_0Nz+pYCVMDWSxnDAjdVXWYczNZfaAtc6kZw@mail.gmail.com>
Subject: Re: [PATCH net-next] openvswitch: allow linking a VRF to an OVS bridge
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 5:45 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 9/20/21 9:34 AM, Antoine Tenart wrote:
> > There might be questions about the setup in which a VRF is linked to an
> > OVS bridge; I cc'ed Luis Tom=C3=A1s who wrote the article.
>
> My head just exploded. You want to make an L3 device a port of an L2
> device.
>
> Can someone explain how this is supposed to work and why it is even
> needed? ie., given how an OVS bridge handles packets and the point of a
> VRF device (to direct lookups to a table), the 2 are at odds in my head.
>

Hi David,

Thanks for your comment. And yes you are right, this probably is a bit
of an odd setup. That said, OVS is not pure L2 as it knows about IPs
and it is doing virtual routing too (we can say it is 2.5 xD)

What we want to achieve is something similar to what is shown in slide 100
here http://schd.ws/hosted_files/ossna2017/fe/vrf-tutorial-oss.pdf, but ins=
tead
of connecting the VRF bridge directly to containers, we have a single ovs
bridge (where the OpenStack VMs are connected to) where we connect the
vrfs in different (ovs) ports (so that the traffic in the way out of OVS ca=
n be
redirected to the right VRF).

The initial part is pretty much the same as in the slide 100:
1) creating the vrf
   - ip link add vrf-1001 type vrf table 1001
2) vxlan device, in our case associated to the loopback,
for ECMP (instead of associate both nics/vlan devices to the VRF)
   - ip link add vxlan-1001 type vxlan id 1001 dstport 4789 local L_IP
nolearning
3) create the linux bridge device
   - ip link add name br-1001 type bridge stp_state 0
4) link the 3 above
   - ip link set br-1001 master vrf-1001 (bridge to vrf)
   - ip link set vxlan-1001 master br-1001 (vxlan to bridge)

Then, I'm attaching the vrf device also as an ovs bridge port, so that
traffic (together with some ip routes in the vrf routing table) can be
redirected
to OVS, and the (OpenStack) virtual networking happens there
(br-ex is the ovs bridge)
   - ovs-vsctl add-port br-ex vrf-1001
   - ip route show vrf vrf-1001
       10.0.0.0/26 via 172.24.4.146 dev br-ex
       (redirect traffic to OpenStack subnet 10.0.0.0/26 to br-ex)
       172.24.4.146 dev br-ex scope link

Perhaps there is a better way of connecting this?
I tried (without success) to create a veth device and set one end on
the linux bridge and the other on the OVS bridge.

Best regards,
Luis

