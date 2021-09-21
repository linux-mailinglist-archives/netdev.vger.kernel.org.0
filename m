Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32C6413271
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 13:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhIULVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 07:21:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232229AbhIULVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 07:21:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632223221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wlp4l6KsMSE4UIALBbO+kUAmjYb5DxVcjPiEbtC7FII=;
        b=KRfpJX7g6r0y2TlltU1a1oV9Bh51JsXL9mNYuwSbEuEf5sIwTRwudk+ZY1CVMJ7upHcVq/
        zJz95KiuVnSe38gHhTQRjxRK7Vgf1AoCtkQVoB4vKYrrcA3isK1u5wOYoyJwB7Cw9y6elc
        aP5mzezC0gwX/cMHkkTwob4057/JX3I=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53--EE-DnP3OFSsn3hb7BcfXw-1; Tue, 21 Sep 2021 07:20:20 -0400
X-MC-Unique: -EE-DnP3OFSsn3hb7BcfXw-1
Received: by mail-qk1-f197.google.com with SMTP id s18-20020a05620a255200b00433885d4fa7so3664066qko.4
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 04:20:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wlp4l6KsMSE4UIALBbO+kUAmjYb5DxVcjPiEbtC7FII=;
        b=YXuO3YbDmrwaaI2nm5IQl3C8mkgT+LRn/kOQpEFIyumEahOitYW3VSe47X4cvcMKjz
         iCr/mrNYEjWjq/ID6GyA3i6XOd2kItYsHLG6yJTH6Pdr7FwDpC7ormtplztgjQCmCpRW
         gLAGx6yeHhIlMfis71QSFW8LTOn9S8GE5AC8uZRgMxvYghP4mUXADQnQGeukVsRyD1+E
         x3q30IxBH7ZePeKP4iJuvzOERGfHSBV6G44Y/fL3miUoeH3c7EwgXHRNcsL016FFu6gg
         pXsavGMCQpC4Se0RuYcVZrGwpb0scZacg8H5TDbLZZ36vjP2vLRiGRAUY5eye+8f9gYa
         9Q8A==
X-Gm-Message-State: AOAM530sTNORXiF0yOwPPFLYKa1tNiGhQyF/bwNzP92DgpOKzoVXw8FP
        JMELqsHpsnpUyo4vqSWP+yGbmcqFsWMpGFU88mV96EHWAemoga1pwIU7n//siT1cDHmvE7mk2Gf
        0DgPA32PUPy+Z2QyqegfAHxE6RrGQhgQ7
X-Received: by 2002:a05:620a:1354:: with SMTP id c20mr28894051qkl.335.1632223219458;
        Tue, 21 Sep 2021 04:20:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIRh35UekDw9jlkp6FcbQKeoUs9fcolR5OZ9lLt2R0t6MZu/zfN1TeDsSlrFa0xBPAQY8cl76imliYQAWYjJk=
X-Received: by 2002:a05:620a:1354:: with SMTP id c20mr28894026qkl.335.1632223219158;
 Tue, 21 Sep 2021 04:20:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210920153454.433252-1-atenart@kernel.org> <b3bee3ec-72c0-0cbf-d1ce-65796907812f@gmail.com>
 <CAAxCcbsrjvp=vP_0Nz+pYCVMDWSxnDAjdVXWYczNZfaAtc6kZw@mail.gmail.com>
In-Reply-To: <CAAxCcbsrjvp=vP_0Nz+pYCVMDWSxnDAjdVXWYczNZfaAtc6kZw@mail.gmail.com>
From:   Luis Tomas Bolivar <ltomasbo@redhat.com>
Date:   Tue, 21 Sep 2021 13:20:08 +0200
Message-ID: <CAAxCcbsBTey=tSznn55BanA2H5PXitgfuC8DFg543nYjT0-igQ@mail.gmail.com>
Subject: Re: [PATCH net-next] openvswitch: allow linking a VRF to an OVS bridge
To:     David Ahern <dsahern@gmail.com>
Cc:     Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, pshelar@ovn.org, dsahern@kernel.org,
        dev@openvswitch.org, netdev@vger.kernel.org,
        Eelco Chaudron <echaudro@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 10:12 AM Luis Tomas Bolivar <ltomasbo@redhat.com> w=
rote:
>
> On Mon, Sep 20, 2021 at 5:45 PM David Ahern <dsahern@gmail.com> wrote:
> >
> > On 9/20/21 9:34 AM, Antoine Tenart wrote:
> > > There might be questions about the setup in which a VRF is linked to =
an
> > > OVS bridge; I cc'ed Luis Tom=C3=A1s who wrote the article.
> >
> > My head just exploded. You want to make an L3 device a port of an L2
> > device.
> >
> > Can someone explain how this is supposed to work and why it is even
> > needed? ie., given how an OVS bridge handles packets and the point of a
> > VRF device (to direct lookups to a table), the 2 are at odds in my head=
.
> >
>
> Hi David,
>
> Thanks for your comment. And yes you are right, this probably is a bit
> of an odd setup. That said, OVS is not pure L2 as it knows about IPs
> and it is doing virtual routing too (we can say it is 2.5 xD)
>
> What we want to achieve is something similar to what is shown in slide 10=
0
> here http://schd.ws/hosted_files/ossna2017/fe/vrf-tutorial-oss.pdf, but i=
nstead
> of connecting the VRF bridge directly to containers, we have a single ovs
> bridge (where the OpenStack VMs are connected to) where we connect the
> vrfs in different (ovs) ports (so that the traffic in the way out of OVS =
can be
> redirected to the right VRF).
>
> The initial part is pretty much the same as in the slide 100:
> 1) creating the vrf
>    - ip link add vrf-1001 type vrf table 1001
> 2) vxlan device, in our case associated to the loopback,
> for ECMP (instead of associate both nics/vlan devices to the VRF)
>    - ip link add vxlan-1001 type vxlan id 1001 dstport 4789 local L_IP
> nolearning
> 3) create the linux bridge device
>    - ip link add name br-1001 type bridge stp_state 0
> 4) link the 3 above
>    - ip link set br-1001 master vrf-1001 (bridge to vrf)
>    - ip link set vxlan-1001 master br-1001 (vxlan to bridge)
>
> Then, I'm attaching the vrf device also as an ovs bridge port, so that
> traffic (together with some ip routes in the vrf routing table) can be
> redirected
> to OVS, and the (OpenStack) virtual networking happens there
> (br-ex is the ovs bridge)
>    - ovs-vsctl add-port br-ex vrf-1001
>    - ip route show vrf vrf-1001
>        10.0.0.0/26 via 172.24.4.146 dev br-ex
>        (redirect traffic to OpenStack subnet 10.0.0.0/26 to br-ex)
>        172.24.4.146 dev br-ex scope link
>
> Perhaps there is a better way of connecting this?
> I tried (without success) to create a veth device and set one end on
> the linux bridge and the other on the OVS bridge.

Follow up on this. I found the mistake I was making on the veth-pair
addition configuration (ovs flow was setting the wrong mac address
before sending the traffic through the veth device to the vrf). And it
indeed works connecting the VRF to the OVS bridge by using a veth pair
instead of directly plugin the VRF device as an OVS port.

>
> Best regards,
> Luis



--=20
LUIS TOM=C3=81S BOL=C3=8DVAR
Principal Software Engineer
Red Hat
Madrid, Spain
ltomasbo@redhat.com

