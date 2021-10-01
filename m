Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F6041F508
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 20:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355846AbhJAShW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 14:37:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355797AbhJAShO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 14:37:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE89A61A7D;
        Fri,  1 Oct 2021 18:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633113330;
        bh=CFY8rWfSbLSFLzHuVSiOyly9QkUwNhS5Ga01Vncxabc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NrPeTy36ORB8Dhe80oz1WIvELeyb8061TCPN9NAN+hsfz6ZRoFl8I7hO5IcU/511w
         SZuXuN+seRirF2ebw1b+7COzAlsyXaeWfV1dsqtNyJ9Lz1VdAYw96ATUqYuusNNKnu
         wAGs6pTZRjKqShV0nJTvdFhHowrysv6dqLWXgBI+xEYluNCVmRpnziNWlHghh49/C+
         euCoNifLNev0O7ri2rgun/LOIwqorrk9x+JeBoP4UOOBgt6pZrkys2BYqqSUCHZ6xP
         9LZwCnkbA0WJCZARriOUu6R+4QrS70+ZtNaxi94KKXyidQeU1RosJ4H9vzbvr/QSCD
         tIw/saul02CGg==
Date:   Fri, 1 Oct 2021 11:35:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20211001113528.79f35460@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YVbO/kit/mjWTrv6@lore-desk>
References: <cover.1631289870.git.lorenzo@kernel.org>
        <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACAyw9-8t8RpJgJUTd7u6bOLnJ1xQsgK7z37QrL9T1FUaJ7WNQ@mail.gmail.com>
        <87v92jinv7.fsf@toke.dk>
        <CACAyw99S9v658UyiKz3ad4kja7rDNfYv+9VOXZHCUOtam_C8Wg@mail.gmail.com>
        <CAADnVQ+XXGUxzqMdbPMYf+t_ViDkqvGDdogrmv-wH-dckzujLw@mail.gmail.com>
        <20210929122229.1d0c4960@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87mtnvi0bc.fsf@toke.dk>
        <YVbO/kit/mjWTrv6@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 Oct 2021 11:03:58 +0200 Lorenzo Bianconi wrote:
> Can you please check if the code above is aligned to current requirements or if
> it is missing something?
> If this code it is fine, I guess we have two option here:
> - integrate the commits above in xdp multi-buff series (posting v15) and work on
>   the verfier code in parallel (if xdp_mb_pointer helper is not required from day0)
> - integrate verfier changes in xdp multi-buff series, drop bpf_xdp_load_bytes
>   helper (probably we will still need bpf_xdp_store_bytes) and introduce
>   bpf_xdp_pointer as new ebpf helper.

It wasn't clear to me that we wanted bpf_xdp_load_bytes() to exist.
But FWIW no preference here.
