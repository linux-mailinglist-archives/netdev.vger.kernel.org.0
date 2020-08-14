Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDAA24453E
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 09:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgHNHIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 03:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgHNHIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 03:08:44 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF948C061757
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 00:08:43 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id i10so8894589ljn.2
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 00:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uPbmn/u6g9gKyCwRFx78Ln8dhwRaKx1gs+n42Nu7NAo=;
        b=BxNt+9mWfNNJTTzoL96Zv/fvOr+0b0g7nZfiRCjhDAzt7Qpu5g+mMldRmzL4Awajn2
         nECkkTFJf7e6iTsXGX0KQ32WKzbuIF6TdM2Ysk3wYjj2MgPHLmAjRZ6+soFtgNkY2VZ5
         YxpmtHudzvF1bozOcSmJplwADl/FOHmj29xg+v4VdlzOHRTGciNQ8vrCrvbNu1z9zOgu
         Lj4Jmb7NIofDSe8POL9odaWmGjy+uFOVbMicN0ljR/iAguaaNxYkDyMflx+/ZO+VgD8g
         eN528dkI8Npo6sVvWOM/iyVzQ4b+FuV68czcmfk2fPobj5GzEtsRbPMlc7CXDUiyKN+K
         HLyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uPbmn/u6g9gKyCwRFx78Ln8dhwRaKx1gs+n42Nu7NAo=;
        b=pyFpe7bvpMum/HQib2UmLnSVhq7cL2zV1mHzNGMNQwChuuhzYjjxm9ZCO7pvetIGCo
         snZS3ypwaEX5uxj5tYvccRPwWrMiDxuuASKj356Jw2AURErYSlywImaF4ucKT1fQ5Ppl
         zZvJ0PK7nhBr5fDI2iJi0TL5MeIGw3JIURNYriqRWrlalOFx+dmBCYiYxFebc2eV1Ubf
         s9X6jaxHPBWZyD0qnXhMJmmu7mLb7M9yJ7SqgWD1o67KzsgGrlrKtTZSulKfwzESE7sl
         +Df1MnXwDxtpuAaj5cgA0OtGDG3MaloWyxP+2kgetLQGQojY/yWGgRrufmIbzzTUpBgh
         AuQg==
X-Gm-Message-State: AOAM53002BLsAlz4B6U7RhEDvO7zamuafW0EECaTpYrP+HwsBZDPToyX
        QqwPuA8gvVognQlVoT4sUbfa1+lISDTSWAqHCFA=
X-Google-Smtp-Source: ABdhPJzm75kAIrlIPs0GNnEHP7yXUoQI3JB623nqPUcxrWEZvaN8iY7I5jkpHTCTCMopzpXnqeaBkZnfE9UgJNh/+UI=
X-Received: by 2002:a2e:8999:: with SMTP id c25mr728879lji.430.1597388921873;
 Fri, 14 Aug 2020 00:08:41 -0700 (PDT)
MIME-Version: 1.0
References: <CANXY5y+iuzMg+4UdkPJW_Efun30KAPL1+h2S7HeSPp4zOrVC7g@mail.gmail.com>
 <c508eeba-c62d-e4d9-98e2-333c76c90161@gmail.com> <CANXY5y+gfZuGvv+pjzDOLS8Jp8ZUFpAmNw7k53O6cDuyB1PCnw@mail.gmail.com>
 <1b4ebdb3-8840-810a-0d5e-74e2cf7693bf@gmail.com> <CANXY5yJeCeC_FaQHx0GPn88sQCog59k2vmu8o-h6yRrikSQ3vQ@mail.gmail.com>
 <deb7a653-a01b-da4f-c58e-15b6c0c51d75@gmail.com> <CANXY5yKNOkBWUTVjOCBBPfACTV_R89ydiOi=YiOZ92in_VEp4w@mail.gmail.com>
 <962617e5-9dec-6715-d550-4cf3ee414cf6@gmail.com>
In-Reply-To: <962617e5-9dec-6715-d550-4cf3ee414cf6@gmail.com>
From:   mastertheknife <mastertheknife@gmail.com>
Date:   Fri, 14 Aug 2020 10:08:30 +0300
Message-ID: <CANXY5yKW=+e1CsoXCb0p_+6n8ZLz4eoOQz_5OkrrjYF6mpU9ZQ@mail.gmail.com>
Subject: Re: PMTUD broken inside network namespace with multipath routing
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

It's on a production system, vmbr2 is a bridge with eth.X VLAN
interface inside for the connectivity on that 252.0/24 network. vmbr2
has address 192.168.252.5 in that case
192.168.252.250 and 192.168.252.252 are CentOS8 LXCs on another host,
with libreswan inside for any/any IPSECs with VTi interfaces.

Everything is kernel 5.4.44 LTS

I wish i could fully reproduce all of it in a script, but i am not
sure how to create such hops that return this ICMP

Thank you,
Kfir


On Wed, Aug 12, 2020 at 10:21 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 8/12/20 6:37 AM, mastertheknife wrote:
> > Hello David,
> >
> > I tried and it seems i can reproduce it:
> >
> > # Create test NS
> > root@host:~# ip netns add testns
> > # Create veth pair, veth0 in host, veth1 in NS
> > root@host:~# ip link add veth0 type veth peer name veth1
> > root@host:~# ip link set veth1 netns testns
> > # Configure veth1 (NS)
> > root@host:~# ip netns exec testns ip addr add 192.168.252.209/24 dev veth1
> > root@host:~# ip netns exec testns ip link set dev veth1 up
> > root@host:~# ip netns exec testns ip route add default via 192.168.252.100
> > root@host:~# ip netns exec testns ip route add 192.168.249.0/24
> > nexthop via 192.168.252.250 nexthop via 192.168.252.252
> > # Configure veth0 (host)
> > root@host:~# brctl addif vmbr2 veth0
>
> vmbr2's config is not defined.
>
> ip li add vmbr2 type bridge
> ip li set veth0 master vmbr2
> ip link set veth0 up
>
> anything else? e.g., address for vmbr2? What holds 192.168.252.250 and
> 192.168.252.252
