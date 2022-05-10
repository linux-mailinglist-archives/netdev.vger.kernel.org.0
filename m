Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800E1521796
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 15:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242950AbiEJN15 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 May 2022 09:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243508AbiEJN05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 09:26:57 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306E41BDD82
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 06:19:52 -0700 (PDT)
Received: from mail-yb1-f178.google.com ([209.85.219.178]) by
 mrelayeu.kundenserver.de (mreue009 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MIxBa-1nU0HU329i-00KNMr for <netdev@vger.kernel.org>; Tue, 10 May 2022
 15:19:50 +0200
Received: by mail-yb1-f178.google.com with SMTP id e12so30609202ybc.11
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 06:19:50 -0700 (PDT)
X-Gm-Message-State: AOAM530IH5ZSEl8ufVjSzgKxxiGWRwNmudHnbj3PzI3TeyRc+6M5ECME
        jZjQvuOJmMlwMeBGwMtBjR8kSERFRPV/Afmb/uU=
X-Google-Smtp-Source: ABdhPJyKG1HrMLArySY+0xy/vk4lZ1LlIpR/iPULdBoojqOHJ9bJ0kqtXmoKJqzpXeeNs6dNux+oAJOr5cusX7FerHo=
X-Received: by 2002:a25:31c2:0:b0:641:660f:230f with SMTP id
 x185-20020a2531c2000000b00641660f230fmr18074134ybx.472.1652188789518; Tue, 10
 May 2022 06:19:49 -0700 (PDT)
MIME-Version: 1.0
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com> <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
 <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
 <eec5e665-0c89-a914-006f-4fce3f296699@gmail.com> <YnP1nOqXI4EO1DLU@lunn.ch>
 <510bd08b-3d46-2fc8-3974-9d99fd53430e@gmail.com> <CAK8P3a0Rouw8jHHqGhKtMu-ks--bqpVYj_+u4-Pt9VoFOK7nMw@mail.gmail.com>
 <306e9713-5c37-8c6a-488b-bc07f8b8b274@gmail.com> <CAK8P3a1nR2VHYJsTy6aCz9qeZD0M2PYNyYgVwUj=_TOJvwCLwg@mail.gmail.com>
 <46a4a91b-e068-4b87-f707-f79486b23f67@gmail.com>
In-Reply-To: <46a4a91b-e068-4b87-f707-f79486b23f67@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 10 May 2022 15:19:32 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3=64B7er2QiCBBcskjxbiiG2-fDCpDWR8OD15v9GiOVQ@mail.gmail.com>
Message-ID: <CAK8P3a3=64B7er2QiCBBcskjxbiiG2-fDCpDWR8OD15v9GiOVQ@mail.gmail.com>
Subject: Re: Optimizing kernel compilation / alignments for network performance
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Felix Fietkau <nbd@nbd.name>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:70yVkaX7cRfpvDlg1/wgDPfj8Hga25rcVg6RoLwAWPfB6LZfuMr
 lPB6G+irt2wHWLBUEaT8iVuqIk6/kYFH3/t7LWywlbFi1b3V5Kugk2WHyF1NzEccfDnXJSj
 gS9C41pvxNApw7x5bugalqo9U/E0+MbN/fAC9KV46ZX69D9PeX5+7YlVlVIFQueoJE77526
 ltMEaoxuB+psux8/+Klzw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:r9+GkpDt298=:+1kYgfXJLrssgUz7nyUWX+
 1ETUtcYGZqgdLj//faYOiCgOSGpeELZZCSTbaKaSrAfnPUewY9JJnS1CMThMSdnFcWyHD+v2C
 aPKHKRBkfdpDPNMDqKlZ1JgzJmQpWL68zWegriUxmIAvJzF9WarPzyrzmyQxrmImbQO3j3Kim
 Nsf2QjqOSVQoVtt6/mEQENqvPSZc3ircb3Zhi45NeQ55f5azc1NOlbxe8TpJMFAD+DYe5sKI4
 NdpoztFoHMRFd8Fq0aTmZkK+U8DFumx+Do09pMAduJHhzr5EzvOG+/CgaqMLXSkDkYhooSyNP
 XCTOvv23JCImA+0dK1J85KRcMvyNrOYEgghlE7JzBu9G66AI0duJiyeqSbdQ3lhEonTwgg1Y/
 gEwLG70Rl4M0VyaNYRkPBpXNt8C1xxMN9OUBDNbYM8Q1xBbm2rv4bQ0+sqXqW0+wDP+Q8hs4X
 y+uRfUk23+S97VWGmXxqJO/3YPHOrn8U0xposO6PST/jhcd5OKTpWTbp0mGE7NmhAP691tdmx
 1LGZ3NxibtiMe+kPURR4GaMr9BA9+FzjwJNAxDWRDFFN2+4ku+yDLGCIM83ogNPuijUOKCvNE
 0IdWJqvoFjnl6YY7wEsFZfvROeHcBxdCIIkSX4EgaF51mzxlwAo7rz9JrkR8N9Va0lb0NvQbQ
 fehCoSFCCUGFnBkD7Ro/Eh4rx3INq4tFKhMzxZt7Z9kRoE+N05UPEiq4cMr5byOfkDqjx2z+k
 X3gDt3HPGRcdFQ6a4GrgYeoVxErVLID4lGUoeFv2jHzLrjK+hGyvJMB2rVBegrKcZ2MOUVo0C
 2pZdYw9iq5cleabNLV9/iDm9+dN9DGWX0AnZtHpwTnBDcmuxZRWLu6265cTZLLOHEQaOytBcu
 +ejT2xnVlCkPPi8fGqgpn9Bq0JoB52/a2STFUHQRk=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_BL,RCVD_IN_MSPIKE_ZBI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 2:51 PM Rafał Miłecki <zajec5@gmail.com> wrote:
> On 6.05.2022 11:44, Arnd Bergmann wrote:
>
> My router has a single swtich so I use two VLANs:
> eth0.1 - LAN
> eth0.2 - WAN
> (VLAN traffic is routed to correct ports by switch). On top of that I
> have "br-lan" bridge interface briding eth0.1 and wireless interfaces.
>
> For all that time I had /sys/class/net/br-lan/queues/rx-0/rps_cpus set
> to 3. So bridge traffic was randomly handled by CPU 0 or CPU 1.
>
> So if I assign specific CPU core to each of two interfaces, e.g.:
> echo 1 > /sys/class/net/eth0/queues/rx-0/rps_cpus
> echo 2 > /sys/class/net/br-lan/queues/rx-0/rps_cpus
> things get stable.
>
> With above I get stable 419 Mb/s (CPUs load: 100% + 64%) on every iperf
> session.

Ah, very nice! One part of the mystery is solved then I guess.

       Arnd
