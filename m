Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0861195C2
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729435AbfLJVXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:23:12 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:38751 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727640AbfLJVXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 16:23:11 -0500
X-Originating-IP: 209.85.217.47
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
        (Authenticated sender: pshelar@ovn.org)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 499B1FF803
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 21:23:09 +0000 (UTC)
Received: by mail-vs1-f47.google.com with SMTP id y195so14241264vsy.5
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 13:23:09 -0800 (PST)
X-Gm-Message-State: APjAAAXYD7qLD0iYgRLzOBE9wQBm4FAdU1naWWhhISK+Xq6qsIF2SLNf
        JhfZhNPIHUzVessx/fjpkSA70E5UKneo+53w6PU=
X-Google-Smtp-Source: APXvYqyEvhA8VvcFrNOFCMFCm6Bp2D/wLqaKZEqwDMhYSwf7Jq0b7cefjEDydM5jk6c3DTDlZFn12Fmo3u7GIyiN85s=
X-Received: by 2002:a67:d007:: with SMTP id r7mr25984861vsi.93.1576012988020;
 Tue, 10 Dec 2019 13:23:08 -0800 (PST)
MIME-Version: 1.0
References: <cover.1575964218.git.martin.varghese@nokia.com> <c7b6eaa599aff9167b4123efb5b990e3afb20d15.1575964218.git.martin.varghese@nokia.com>
In-Reply-To: <c7b6eaa599aff9167b4123efb5b990e3afb20d15.1575964218.git.martin.varghese@nokia.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Tue, 10 Dec 2019 13:22:56 -0800
X-Gmail-Original-Message-ID: <CAOrHB_BSi57EwqQ6RWzK55-ADhT_z4_fyMVrGacMMO-BXFoREA@mail.gmail.com>
Message-ID: <CAOrHB_BSi57EwqQ6RWzK55-ADhT_z4_fyMVrGacMMO-BXFoREA@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] openvswitch: New MPLS actions for layer 2 tunnelling
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 12:17 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> From: Martin Varghese <martin.varghese@nokia.com>
>
> The existing PUSH MPLS & POP MPLS actions inserts & removes MPLS header
> between ethernet header and the IP header. Though this behaviour is fine
> for L3 VPN where an IP packet is encapsulated inside a MPLS tunnel, it
> does not suffice the L2 VPN (l2 tunnelling) requirements. In L2 VPN
> the MPLS header should encapsulate the ethernet packet.
>
> The new mpls actions PTAP_PUSH_MPLS & PTAP_POP_MPLS inserts and removes
> MPLS header from start of the packet respectively.
>
> PTAP_PUSH_MPLS - Inserts MPLS header at the start of the packet.
> @ethertype - Ethertype of MPLS header.
>
> PTAP_POP_MPLS - Removes MPLS header from the start of the packet.
> @ethertype - Ethertype of next header following the popped MPLS header.
>              Value 0 in ethertype indicates the tunnelled packet is
>              ethernet.
>
Did you considered using existing MPLS action to handle L2 tunneling
packet ? It can be done by adding another parameter to the MPLS
actions.
