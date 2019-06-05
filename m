Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 060A7355FF
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 06:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFEEby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 00:31:54 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40768 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfFEEby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 00:31:54 -0400
Received: by mail-pf1-f194.google.com with SMTP id u17so14075452pfn.7
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 21:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h1V1JTpHLfSLsEyClpP3JlLVVqBgfhltWylQuuVYmiI=;
        b=JdZ8UObMUZtUfR7FKSl9l9HK2VXqkNUr65eNgazYkEQbFQ5N9kYlwz89HQHz+reWfT
         oUj4wuIyZ14T2p1+D7unxG1fehqD3/FcjK4XX1lUB/HRxUZ6LSE8jFWUIqf6K4umnnsl
         LKDyrjAXf+pcABTI2S9m0+dIkE4R6JJ+sSfnfETjTKhKT9kUaz5jCBiuT+Scu5iIgGw4
         X5W3sylnbjFWC3in2AXzm1Idr59MEZyOlYkO4/Xx6LZR+FgcAMt8ra7JDv6uArS6B9bU
         4fN5H03N4zAuMPfx1/zRK1uZJkbBc4G1DflDycauURNJhN+8EIXAxIUS4pkepEfjOlIY
         hu8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h1V1JTpHLfSLsEyClpP3JlLVVqBgfhltWylQuuVYmiI=;
        b=Pd36jvQsDhHSfuGzhOfzffAvbbZFqSHAR3axIoZ/W5HmdpQ8D/Jc9YVomsnoypNEpM
         hfhqvEdXThJdp4Y1U1hCflc9W6OxdErfCV6hQwtx/0/aJ9OROpjqJoAG2cak5ns3EMjZ
         HvhN9T+Qqroq0/D/fPn0D9Obl3JxNwoe1Cri96o5Pkt5KD0x/6C/iDpDp2RW+jo9Vp/x
         AevszvlG41ZkY+BVgrIJrOCkOHHNvX7TcfZy/TLT5bveMYIcIo5JCRtgIocdtln7MUwL
         ILT/2FN8OCnguiuS1BcliW0bhocjfKAFlnho3EpfIrEJDm2MIIVgxBviQPFC1+M8eE7S
         hMUg==
X-Gm-Message-State: APjAAAXqu+BIfFi7IPlgjNq3cF6OvEZ2S98GhxXEDN34FNmq6LU66eqB
        4I82MNoO8Vk5281/vUo7xv4vPVb87T3Q6FJnl2C0mKtF
X-Google-Smtp-Source: APXvYqw66xm5PJbiwa5+PP8Q3PQqprMood2pWcDHjOJioWa44xYan/khCbGDypHHQVyYV7c/q/5kAq5Ng6b7siLURqY=
X-Received: by 2002:a63:1d05:: with SMTP id d5mr1605856pgd.157.1559709113681;
 Tue, 04 Jun 2019 21:31:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190530083508.i52z5u25f2o7yigu@sesse.net>
In-Reply-To: <20190530083508.i52z5u25f2o7yigu@sesse.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 4 Jun 2019 21:31:42 -0700
Message-ID: <CAM_iQpX-fJzVXc4sLndkZfD4L-XJHCwkndj8xG2p7zY04k616g@mail.gmail.com>
Subject: Re: EoGRE sends undersized frames without padding
To:     "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 2:08 AM Steinar H. Gunderson
<steinar+kernel@gunderson.no> wrote:
>
> Hi,
>
> I'm trying to connect some VMs over EoGRE (using gretap on my side):
>
>   ip link add foo type gretap remote <remote> local <local>
>
> This works fine for large packets, but the system in the other end
> drops smaller packets, such as ARP requests and small ICMP pings.

Is the other end Linux too?

>
> After looking at the GRE packets in Wireshark, it turns out the Ethernet
> packets within the EoGRE packet is undersized (under 60 bytes), and Linux
> doesn't pad them. I haven't found anything in RFC 7637 that says anything
> about padding, so I would assume it should conform to the usual Ethernet
> padding rules, ie., pad to at least ETH_ZLEN. However, nothing in Linux' IP
> stack seems to actually do this, which means that when the packet is
> decapsulated in the other end and put on the (potentially virtual) wire,
> it gets dropped. The other system properly pads its small frames when sending
> them.


If the packet doesn't go through any real wire, it could still be accepted
by Linux even when it is smaller than ETH_ZLEN, I think. Some hardware
switches pad for ETH_ZLEN when it goes through a real wire.

So, how is your packet routed between different VM? Via a Linux bridge?


>
> Is there a way to get around this, short of looping the packets out through a
> physical wire to get the padding? Is it simply a bug? I've been testing with
> 4.19.28, but it doesn't look like git master has any changes in this area.
>

It is still too early to say it is a bug. Is this a regression?

Thanks.
