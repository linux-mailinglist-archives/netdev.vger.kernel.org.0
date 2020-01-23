Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427DE14703E
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 19:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgAWSBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 13:01:19 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43571 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727278AbgAWSBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 13:01:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579802477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7gK71JlCzBoRH7otpv/ay7u+HyQWajh+HxtE6qASG7U=;
        b=GXK4G0okv8qRuiUoCnUUZ3HAUzFGc3oh8DjnQxUti8mlA+4T2cffx5m7zxr85Ctk1YlAbT
        tIqY4CWDgDHFgUDNoPyqofIgDao8SIEB6FNrN8Y7T3USc3cfit+e16oMexZiVJNqdVTEmD
        tGmYjAJ2XubGuRQYSc+ZKS7DBEZTHhA=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-Bol5oLZ7Obm4io64ewwAQw-1; Thu, 23 Jan 2020 13:01:15 -0500
X-MC-Unique: Bol5oLZ7Obm4io64ewwAQw-1
Received: by mail-lf1-f71.google.com with SMTP id q16so628513lfa.13
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 10:01:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=7gK71JlCzBoRH7otpv/ay7u+HyQWajh+HxtE6qASG7U=;
        b=UAeUKG3sZsjn0zaZo3s0ERImjGPkWuDRAfwPBL+z2cXDuXmUe12eC+K+VM5JSY1PXG
         Kkq4I4rH1H2fg2LPC4nmnKU7msuQjjQfYOEEAQ5N7eMLIJ4dKfWkvq4ILI2+iTi4BONn
         hvwHMJKSF3VRsw50Rh84RVUugNiBNfdv6ZwMRQfRosqpSntBAC+nQTh2HUo6G4ph5fEo
         yeWQzglRV8AKPChBCNtKqoWZh1AGTsVVArDBtci+00fYrtObq1hakm1fK7cuRmWy3cor
         HKkouKhFtZ69D+iKjHzLbnDXCfFEylX3OuU7sHKUpKgMWh9psrf9YzsFmkcud9qPDP8Y
         mwcQ==
X-Gm-Message-State: APjAAAWwmGhaE47W/yaqDmG1m/PYlKbJOpdDPVEWg39xx9tvKI9yeyQf
        mh/wqFxPZ+c0pKXU8RBNSvelBhCznZmWK0cXkBxB80X+xlSOkXBslu87eEgn5k1es9WVvCYdNo+
        JwZd1YROzuYX5UsT/
X-Received: by 2002:a19:6b11:: with SMTP id d17mr5206678lfa.168.1579802473366;
        Thu, 23 Jan 2020 10:01:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqxoJgqRiLvQh2YV5H34g8zgN+5u5hhn6hZLc7vtwmZCAYdKX2wRjyJUXoW7FVAEn4JlIFMM8Q==
X-Received: by 2002:a19:6b11:: with SMTP id d17mr5206671lfa.168.1579802473155;
        Thu, 23 Jan 2020 10:01:13 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id p15sm1469130lfo.88.2020.01.23.10.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 10:01:12 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B8A7018006C; Thu, 23 Jan 2020 19:01:11 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Luigi Rizzo <lrizzo@google.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com
Subject: Re: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb linearization
In-Reply-To: <CAMOZA0Kmf1=ULJnbBUVKKjUyzqj2JKfp5ub769SNav5=B7VA5Q@mail.gmail.com>
References: <20200122203253.20652-1-lrizzo@google.com> <875zh2bis0.fsf@toke.dk> <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net> <87blqui1zu.fsf@toke.dk> <CAMOZA0Kmf1=ULJnbBUVKKjUyzqj2JKfp5ub769SNav5=B7VA5Q@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 23 Jan 2020 19:01:11 +0100
Message-ID: <875zh2hx20.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luigi Rizzo <lrizzo@google.com> writes:

> On Thu, Jan 23, 2020 at 8:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>
>> > On 1/23/20 10:53 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >> Luigi Rizzo <lrizzo@google.com> writes:
>> >>
>> >>> Add a netdevice flag to control skb linearization in generic xdp mod=
e.
>> >>> Among the various mechanism to control the flag, the sysfs
>> >>> interface seems sufficiently simple and self-contained.
>> >>> The attribute can be modified through
>> >>>     /sys/class/net/<DEVICE>/xdp_linearize
>> >>> The default is 1 (on)
>> >
>> > Needs documentation in Documentation/ABI/testing/sysfs-class-net.
>> >
>> >> Erm, won't turning off linearization break the XDP program's ability =
to
>> >> do direct packet access?
>> >
>> > Yes, in the worst case you only have eth header pulled into linear
>> > section. :/
>>
>> In which case an eBPF program could read/write out of bounds since the
>> verifier only verifies checks against xdp->data_end. Right?
>
> Why out of bounds? Without linearization we construct xdp_buff as follows:
>
> mac_len =3D skb->data - skb_mac_header(skb);
> hlen =3D skb_headlen(skb) + mac_len;
> xdp->data =3D skb->data - mac_len;
> xdp->data_end =3D xdp->data + hlen;
> xdp->data_hard_start =3D skb->data - skb_headroom(skb);
>
> so we shouldn't go out of bounds.

Hmm, right, as long as it's guaranteed that the bit up to hlen is
already linear; is it? :)

-Toke

