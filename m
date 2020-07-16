Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2FC221AE5
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 05:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgGPDlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 23:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbgGPDlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 23:41:13 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BD6C061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 20:41:13 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 5so3131298oty.11
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 20:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FQ0M73wEPTnTu2JJVlbKLC6O8iQNMw8waRsk63jGz3k=;
        b=iOr19jSJ0Bi6kqTerHRodA60mW2hZxTdvpN6onEzb1/HkbnE8HxK0NpxDwmJ4q4wSN
         SQUY3b19Lq3ZWvwqcQDyueyveNAvEnk4L6PG30zlwvabtoc8bz/sjqLfN4pVqsnK2OdQ
         KAjfFT9ztbHZnC3H1JecbgIhvfY1UUKm2cjPiWcWaNDC7YQ2syYK8LHcC9eqafPdhqim
         Kezw4gBOMSTZxj4+trj8d+hoS46VnU85EKiHKRYuRnVFPjhTEjwIXtruVKhf2ZOUO87Y
         nwDYLUpMXWvTmToXIBGWkNnzoLckKOV2gBJwch3TIpDw+u4eYWNZxSX8kJBkCQpUX91G
         z85A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FQ0M73wEPTnTu2JJVlbKLC6O8iQNMw8waRsk63jGz3k=;
        b=aL1K/es1h2RwsO9qByqJt0p7W0oQjCA1ezMdfne1d6ob3mCD3Q6EJppvHF4kzDBP3G
         yJ1QvjL+thxKQ5oHseG6xVs5UPCmbICKbFWM19F6dCuI96Htjs7DdQdj0zlqNua+YVY7
         onNn4ukor3ZFVI1T/+vn73nrWTss4842sGlGQlN9dkMERpyckUqn+Qr1KIWhkFqUnjSq
         tBmkmzkwWmphoI0WjL+ZKplbx+ezMqe1CBYrLgvVxRu6w5QV+SmyDH2/Ky5q7YU0HB/R
         q2ezUQ+pW390aWrVwgRS3jaGh9q5KOY7LHnCKSxM0b4obkwRHh10J4nL1/bQe5rl1nUF
         gPTA==
X-Gm-Message-State: AOAM5305TIx4/0zr3WAfa4XTn2PzP26R6Ix/05Y19Z7619AwyW2jV2gi
        A7gx1hjwDyTgf5TvH1+uNousWz6fQer/HviJlhGdHjtn4e0=
X-Google-Smtp-Source: ABdhPJzl372zK3SnJmwLceEJqDWUfHiB4n774UEGcDsdL6KTeTkPqC+7dH2J6jXjwAK7m8tuiD2OouTAQdJOR02CjPk=
X-Received: by 2002:a9d:4e82:: with SMTP id v2mr2739156otk.278.1594870872729;
 Wed, 15 Jul 2020 20:41:12 -0700 (PDT)
MIME-Version: 1.0
References: <6a31-5f0efa80-3d-68593a00@242352203>
In-Reply-To: <6a31-5f0efa80-3d-68593a00@242352203>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Thu, 16 Jul 2020 11:41:01 +0800
Message-ID: <CAD=hENcYJwkL-mjgJd5OZ0B4tHz2Q9kuqQ8iHid=9TWgyvR=+Q@mail.gmail.com>
Subject: Re: Bonding driver unexpected behaviour
To:     "pbl@bestov.io" <pbl@bestov.io>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 8:49 PM pbl@bestov.io <pbl@bestov.io> wrote:
>
> I'm attempting to set up the bonding driver on two gretap interfaces, gretap15 and gretap16
> but I'm observing unexpected (to me) behaviour.
> The underlying interfaces for those two are respectively intra15 (ipv4: 10.88.15.100/24) and
> intra16 (ipv4: 10.88.16.100/24). These two are e1000 virtual network cards, connected through
> virtual cables. As such, I would exclude any hardware issues. As a peer, I have another Linux
> system configured similarly (ipv4s: 10.88.15.200 on intra15, 10.88.16.200 on intra16).
>
> The gretap tunnels work as expected. They have the following ipv4 addresses:
>           host           peer
> gretap15  10.188.15.100  10.188.15.200
> gretap16  10.188.16.100  10.188.16.200
>
> When not enslaved by the bond interface, I'm able to exchange packets in the tunnel using the
> internal ip addresses.
>
> I then set up the bonding driver as follows:
> # ip link add bond-15-16 type bond
> # ip link set bond-15-16 type bond mode active-backup
> # ip link set gretap15 down
> # ip link set gretap16 down
> # ip link set gretap15 master bond-15-16
> # ip link set gretap16 master bond-15-16
> # ip link set bond-15-16 mtu 1462
> # ip addr add 10.42.42.100/24 dev bond-15-16
> # ip link set bond-15-16 type bond arp_interval 100 arp_ip_target 10.42.42.200
> # ip link set bond-15-16 up
>
> I do the same on the peer system, inverting the interface and ARP target IP addresses.
>
> At this point, IP communication using the addresses on the bond interfaces works as expected.
> E.g.
> # ping 10.24.24.200
> gets responses from the other peer.
> Using tcpdump on the other peer shows the GRE packets coming into intra15, and identical ICMP
> packets coming through gretap15 and bond-15-16.
>
> If I then disconnect the (virtual) network cable of intra15, the bonding driver switches to
> intra16, as the GRE tunnel can no longer pass packets. However, despite having primary_reselect=0,
> when I reconnect the network cable of intra15, the driver doesn't switch back to gretap15. In fact,
> it doesn't even attempt sending any probes through it.
>
> Fiddling with the cables (e.g. reconnecting intra15 and then disconnecting intra16) and/or bringing
> the bond interface down and up usually results in the driver ping-ponging a bit between gretap15
> and gretap16, before usually settling on gretap16 (but never on gretap15, it seems). Or,
> sometimes, it results in the driver marking both slaves down and not doing anything ever again
> until manual intervention (e.g. manually selecting a new active_slave, or down -> up).
>
> Trying to ping the gretap15 address of the peer (10.188.15.200) from the host while gretap16 is the
> active slave results in ARP traffic being temporarily exchanged on gretap15. I'm not sure whether
> it originates from the bonding driver, as it seems like the generated requests are the cartesian
> product of all address couples on the network segments of gretap15 and bond-15-16 (e.g. who-has
> 10.188.15.100 tell 10.188.15.100, who-has 10.188.15.100 tell 10.188.15.200, ..., who-hash
> 10.42.42.200 tell 10.42.42.200).

Please check this
https://developers.redhat.com/blog/2019/05/17/an-introduction-to-linux-virtual-interfaces-tunnels/#gre

Perhaps gretap only forwards ip (with L2 header) packets.

Possibly "arp -s" could help to workaround this.

Zhu Yanjun
>
> uname -a:
> Linux fo-gw 4.19.0-9-amd64 #1 SMP Debian 4.19.118-2+deb10u1 (2020-06-07) x86_64 GNU/Linux
> (same on peer system)
>
> Am I misunderstanding how the driver works? Have I made any mistakes in the configuration?
>
> Best regards,
> Riccardo P. Bestetti
>
