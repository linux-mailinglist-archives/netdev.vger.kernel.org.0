Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261D73501DB
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 16:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbhCaOFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 10:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235946AbhCaOFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 10:05:30 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B375C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 07:05:30 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id h13so22455861eds.5
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 07:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g2bD4amL10BzrtMo/Kvv+fqs6MjxWVm6XFw6bIsPC+w=;
        b=Vgy19Hrc5YiFrhmUbrdyTqcwPNOixjuBtfwqhoF5bGfGyPPRF1SbE3bw5ZmMnpEtGR
         90D0BBvueB/CcU+mn2D9xVU78+GazEZpgeA2ow6hdrO3Kq4N2mFCSkXOwm3eQSABhhUp
         C/rO8nJFssVcBhDi5ACoZ05f86q2w3elcfFYyqMC1yKeEQfDb2On+mi/43WvXZr8fR9n
         RiAn/mkRM6EGEwmz+VTkXDzTLdzrAQbqpMvTKNXvMSsnu4iFrV4LYt6i2iL3tRGplATg
         bJRxjz1+RTMD02jK/JEzemwyaRI1+blwAGIvFgSQwqdosgjXL0YJuB1HzQ7A2Sy+b0cx
         0cIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g2bD4amL10BzrtMo/Kvv+fqs6MjxWVm6XFw6bIsPC+w=;
        b=LAkbyRJwMv/b7yKKLz7dq10ppeXpqIldReb3Z8rA4nKruLLkNoghO2iiVe0OoIV7i6
         G0kBJRpNVM1U7dYsYWoALb+coggQjW3dS62ozdyFP/3yJfutz1s4ayuqmGjyGgXUrRlm
         X//qPjTR2xUqKelVz4aMRahGd72OJWHWKmnZGn8+juh/kKblTM9plveoxqa6wbukAaiA
         2/EhlIzZCsiZvDpoYVyUakIZY16NHsfDoT3vshOh/fI9MlJv+r0Irg7UMuWE3Eez5mSE
         gEkDdBNEJMeL6NNoWE1j2qiPp7zQY4Ehuxt+oiICpzHHQDOEJm5Xn1fhwj61hilIAFR+
         ZiQQ==
X-Gm-Message-State: AOAM530Rvkg7zEstczHfMwvofKd/lMykjuciyIJrR1+LQcp0nJx/8I89
        iZ73eZ6d9Q75bksesHH61+kHHbOlzAI=
X-Google-Smtp-Source: ABdhPJyGrHj7BMcM05XX+fSEg6mK8eLxHFF8vMAlvccwiPwvmtyP8L2dDl6zlZwHTZPtcYfD7BMkWw==
X-Received: by 2002:aa7:cc03:: with SMTP id q3mr4012127edt.366.1617199528647;
        Wed, 31 Mar 2021 07:05:28 -0700 (PDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id g21sm1292086ejd.6.2021.03.31.07.05.27
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 07:05:27 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id z2so19818495wrl.5
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 07:05:27 -0700 (PDT)
X-Received: by 2002:a5d:6104:: with SMTP id v4mr3802891wrt.275.1617199526894;
 Wed, 31 Mar 2021 07:05:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210317221959.4410-1-ishaangandhi@gmail.com> <f65cb281-c6d5-d1c9-a90d-3281cdb75620@gmail.com>
 <5E97397E-7028-46E8-BC0D-44A3E30C41A4@gmail.com> <45eff141-30fb-e8af-5ca5-034a86398ac9@gmail.com>
 <CA+FuTSd9kEnU3wysOVE21xQeC_M3c7Rm80Y72Ep8kvHaoyox+w@mail.gmail.com>
 <6a7f33a5-13ca-e009-24ac-fde59fb1c080@gmail.com> <a41352e8-6845-1031-98ab-6a8c62e44884@gmail.com>
 <5A3D866B-F2BF-4E30-9C2E-4C8A2CFABDF2@gmail.com> <CAJByZJBNMqVDXjcOGCJHGcAv+sT4oEv1FD608TpA_e-J2a3L2w@mail.gmail.com>
 <BL0PR05MB5316A2F5C2F1A727FA0190F3AE649@BL0PR05MB5316.namprd05.prod.outlook.com>
 <994ee235-2b1f-bec8-6f3d-bb73c1a76c3a@gmail.com> <BL0PR05MB5316527A1739025552EB8BB6AE7E9@BL0PR05MB5316.namprd05.prod.outlook.com>
 <BL0PR05MB531617E730233A4913B4C5B3AE7E9@BL0PR05MB5316.namprd05.prod.outlook.com>
In-Reply-To: <BL0PR05MB531617E730233A4913B4C5B3AE7E9@BL0PR05MB5316.namprd05.prod.outlook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 31 Mar 2021 10:04:49 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdvyknXTj+5d1O4+6SE3Hp+EA4TgRWpqaS6NUy_39vTOQ@mail.gmail.com>
Message-ID: <CA+FuTSdvyknXTj+5d1O4+6SE3Hp+EA4TgRWpqaS6NUy_39vTOQ@mail.gmail.com>
Subject: Re: rfc5837 and rfc8335
To:     Ron Bonica <rbonica@juniper.net>
Cc:     David Ahern <dsahern@gmail.com>, Zachary Dodds <zdodds@gmail.com>,
        Ishaan Gandhi <ishaangandhi@gmail.com>,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "junipeross20@cs.hmc.edu" <junipeross20@cs.hmc.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 3:40 PM Ron Bonica <rbonica@juniper.net> wrote:
>
> Folks,
>
> Andreas reminds me that you may have the same questions regarding RFC 833=
5.....
>
> The practice of assigning globally reachable IP addresses to infrastructu=
re interfaces cost network operators money. Normally, they number an interf=
ace from a IPv4  /30. Currently, a /30 costs 80 USD and the price is only e=
xpected to rise. Furthermore, most IP Address Management (IPAM) systems lic=
ense by the address block. The more globally reachable addresses you use, t=
he more you pay.
>
> They would prefer to use:
>
> - IPv4 unnumbered interfaces
> - IPv6 interfaces that have only link-local addresses
>
>                                                                     Ron

Thanks for the context, Ron.

That sounds reasonable to me. Andreas's patch series has also been
merged by now.


>
>
>
> Juniper Business Use Only
>
> -----Original Message-----
> From: Ron Bonica
> Sent: Monday, March 29, 2021 10:50 AM
> To: David Ahern <dsahern@gmail.com>; Zachary Dodds <zdodds@gmail.com>; Is=
haan Gandhi <ishaangandhi@gmail.com>
> Cc: Andreas Roeseler <andreas.a.roeseler@gmail.com>; David Miller <davem@=
davemloft.net>; Network Development <netdev@vger.kernel.org>; Stephen Hemmi=
nger <stephen@networkplumber.org>; Willem de Bruijn <willemdebruijn.kernel@=
gmail.com>; junipeross20@cs.hmc.edu
> Subject: RE: rfc5837 and rfc8335
>
> David,
>
> Juniper networks is motivated to promote RFC 5837 now, as opposed to elev=
en years ago, because the deployment of parallel links between routers is b=
ecoming more common
>
> Large network operators frequently require more than 400 Gbps connectivit=
y between their backbone routers. However, the largest interfaces available=
 can only handle 400 Gbps. So, parallel links are required. Moreover, it is=
 frequently cheaper to deploy 4 100 Gbps interfaces than a single 400 Gbps =
interface. So, it is not uncommon to see two routers connected by many, par=
allel 100 Gbps links. RFC 5837 allows a network operator to trace a packet =
interface to interface, as opposed to node to node.
>
> I think that you are correct in saying that:
>
> - LINUX is more likely to be implemented on a host than a router
> - Therefore, LINUX hosts will  not send RFC 5837 ICMP extensions often
>
> However, LINUX hosts are frequently used in network management stations. =
Therefore, it would be very useful if LINUX hosts could parse and display i=
ncoming RFC 5837 extensions, just as they display RFC 4950 ICMP extensions.

But the patch series under review adds support to generate such packets.


> Juniper networks plans to support RFC 5837 on one platform in an upcoming=
 release and on other platforms soon after that.
>
>                                                                          =
        Ron
>
>
>
>
> Juniper Business Use Only
>
> -----Original Message-----
> From: David Ahern <dsahern@gmail.com>
> Sent: Wednesday, March 24, 2021 11:19 PM
> To: Ron Bonica <rbonica@juniper.net>; Zachary Dodds <zdodds@gmail.com>; I=
shaan Gandhi <ishaangandhi@gmail.com>
> Cc: Andreas Roeseler <andreas.a.roeseler@gmail.com>; David Miller <davem@=
davemloft.net>; Network Development <netdev@vger.kernel.org>; Stephen Hemmi=
nger <stephen@networkplumber.org>; Willem de Bruijn <willemdebruijn.kernel@=
gmail.com>; junipeross20@cs.hmc.edu
> Subject: Re: rfc5837 and rfc8335
>
> [External Email. Be cautious of content]
>
>
> On 3/23/21 10:39 AM, Ron Bonica wrote:
> > Hi Folks,
> >
> >
> >
> > The rationale for RFC 8335 can be found in Section 5.0 of that document=
.
> > Currently, ICMP ECHO and ECHO RESPONSE messages can be used to
> > determine the liveness of some interfaces. However, they cannot
> > determine the liveness of:
> >
> >
> >
> >   * An unnumbered IPv4 interface
> >   * An IPv6 interface that has only a link-local address
> >
> >
> >
> > A router can have hundreds, or even thousands of interfaces that fall
> > into these categories.
> >
> >
> >
> > The rational for RFC 5837 can be found in the Introduction to that
> > document. When a node sends an ICMP TTL Expired message, the node
> > reports that a packet has expired on it. However, the source address
> > of the ICMP TTL Expired message doesn't necessarily identify the
> > interface upon which the packet arrived. So, TRACEROUTE can be relied
> > upon to identify the nodes that a packet traverses along its delivery
> > path. But it cannot be relied upon to identify the interfaces that a
> > packet traversed along its deliver path.
> >
> >
>
> It's not a question of the rationale; the question is why add this suppor=
t to Linux now? RFC 5837 is 11 years old. Why has no one cared to add suppo=
rt before now? What tooling supports it? What other NOS'es support it to re=
ally make the feature meaningful? e.g., Do you know what Juniper products s=
upport RFC 5837 today?
>
> More than likely Linux is the end node of the traceroute chain, not the t=
ransit or path nodes. With Linux, the ingress interface can lost in the lay=
ers (NIC port, vlan, bond, bridge, vrf, macvlan), and to properly support e=
ither you need to return information about the right one.
> Unnumbered interfaces can make that more of a challenge.
