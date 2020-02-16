Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC1891606E6
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 23:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgBPWWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 17:22:17 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:52125 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgBPWWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 17:22:17 -0500
X-Originating-IP: 209.85.222.43
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
        (Authenticated sender: pshelar@ovn.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 8CB781C0004;
        Sun, 16 Feb 2020 22:22:14 +0000 (UTC)
Received: by mail-ua1-f43.google.com with SMTP id f7so5471468uaa.8;
        Sun, 16 Feb 2020 14:22:14 -0800 (PST)
X-Gm-Message-State: APjAAAXOuO0FtgIz44XaZ5s7sSxC0Gag4k/bRYp9ZDN8KXc6i7bm1drZ
        yfKiiRnuPx9eCOwQkgrowMIJu/k8F4Ynorpg4yk=
X-Google-Smtp-Source: APXvYqx2go22AofIyIP98/l6l45UOkLo/JVU6KDf6hZMx9X9FgplBl+/pgthlodHMYDcGG1odYWa6E/YfMjVrHqpEXI=
X-Received: by 2002:ab0:4753:: with SMTP id i19mr6353393uac.70.1581891733184;
 Sun, 16 Feb 2020 14:22:13 -0800 (PST)
MIME-Version: 1.0
References: <20200215132056.42124-1-mcroce@redhat.com>
In-Reply-To: <20200215132056.42124-1-mcroce@redhat.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sun, 16 Feb 2020 14:22:02 -0800
X-Gmail-Original-Message-ID: <CAOrHB_AgZJAc4oD+9pxuUEvepVK1RstD8veC5gfj1m4rhKPROg@mail.gmail.com>
Message-ID: <CAOrHB_AgZJAc4oD+9pxuUEvepVK1RstD8veC5gfj1m4rhKPROg@mail.gmail.com>
Subject: Re: [PATCH net-next v5] openvswitch: add TTL decrement action
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bindiya Kurle <bindiyakurle@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Ben Pfaff <blp@ovn.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Jeremy Harris <jgh@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 15, 2020 at 5:21 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> New action to decrement TTL instead of setting it to a fixed value.
> This action will decrement the TTL and, in case of expired TTL, drop it
> or execute an action passed via a nested attribute.
> The default TTL expired action is to drop the packet.
>
> Supports both IPv4 and IPv6 via the ttl and hop_limit fields, respectively.
>
> Tested with a corresponding change in the userspace:
>
>     # ovs-dpctl dump-flows
>     in_port(2),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},1
>     in_port(1),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},2
>     in_port(1),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:2
>     in_port(2),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:1
>
>     # ping -c1 192.168.0.2 -t 42
>     IP (tos 0x0, ttl 41, id 61647, offset 0, flags [DF], proto ICMP (1), length 84)
>         192.168.0.1 > 192.168.0.2: ICMP echo request, id 386, seq 1, length 64
>     # ping -c1 192.168.0.2 -t 120
>     IP (tos 0x0, ttl 119, id 62070, offset 0, flags [DF], proto ICMP (1), length 84)
>         192.168.0.1 > 192.168.0.2: ICMP echo request, id 388, seq 1, length 64
>     # ping -c1 192.168.0.2 -t 1
>     #
>
> Co-developed-by: Bindiya Kurle <bindiyakurle@gmail.com>
> Signed-off-by: Bindiya Kurle <bindiyakurle@gmail.com>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---

Thanks!

Acked-by: Pravin B Shelar <pshelar@ovn.org>
