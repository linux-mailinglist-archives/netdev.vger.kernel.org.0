Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365A251D4E2
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 11:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390603AbiEFJsI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 May 2022 05:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235926AbiEFJsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 05:48:07 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E310E309
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 02:44:23 -0700 (PDT)
Received: from mail-wm1-f42.google.com ([209.85.128.42]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MQy0N-1nQa823vpn-00NwsF for <netdev@vger.kernel.org>; Fri, 06 May 2022
 11:44:21 +0200
Received: by mail-wm1-f42.google.com with SMTP id k126so4095213wme.2
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 02:44:21 -0700 (PDT)
X-Gm-Message-State: AOAM530luWF96E1qO84tTpiqEi0KOV3c/nwklGQziLDJZLaJjUg7pG/9
        2bHVRbxJRA//lyP/JDhV7OwFlrFq50OF4HUN09M=
X-Google-Smtp-Source: ABdhPJw674cI+pdA3oV/AEeEt4eKbh3MctCt9mOfVrjt0xhdmh9s7Xx+DtmywUr9l/up+ycGJVjrsipvLvigAJlKg0A=
X-Received: by 2002:a05:600c:4f0f:b0:394:54c1:f5b3 with SMTP id
 l15-20020a05600c4f0f00b0039454c1f5b3mr9324422wmq.33.1651830261595; Fri, 06
 May 2022 02:44:21 -0700 (PDT)
MIME-Version: 1.0
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com> <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
 <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
 <eec5e665-0c89-a914-006f-4fce3f296699@gmail.com> <YnP1nOqXI4EO1DLU@lunn.ch>
 <510bd08b-3d46-2fc8-3974-9d99fd53430e@gmail.com> <CAK8P3a0Rouw8jHHqGhKtMu-ks--bqpVYj_+u4-Pt9VoFOK7nMw@mail.gmail.com>
 <306e9713-5c37-8c6a-488b-bc07f8b8b274@gmail.com>
In-Reply-To: <306e9713-5c37-8c6a-488b-bc07f8b8b274@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 6 May 2022 11:44:05 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1nR2VHYJsTy6aCz9qeZD0M2PYNyYgVwUj=_TOJvwCLwg@mail.gmail.com>
Message-ID: <CAK8P3a1nR2VHYJsTy6aCz9qeZD0M2PYNyYgVwUj=_TOJvwCLwg@mail.gmail.com>
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
X-Provags-ID: V03:K1:ml63v7AdlgWKa0P92ncS8hNHCP1EVq5PM1o9W9yiugBYXWdYPev
 8EqipSTzTvJPVxizc6KrRV9OsqqxJ7pWypge7m8mgCLCzYcyq3XRGb2d4jk0mpdhJL58GSx
 mCyrwoZFX3G9dTarEWRHpvtmOBMgG+M1azAoKiHHGnuA0pKEKol4iRcTwMiurrWclfgjRYh
 +dVgs1IDFM4/fBF5KZEgA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:F7lxRvfy3uM=:RuM1sbTPhdgHi++1pNl5Yl
 fpGFbuGpG2fG7GkCSVKCKicwf4LTDAmyjIAlLb6wCnNULt/yfAfCRBuqXqUTeXc55xH46SL2U
 XqoOk801csv+1AjkxieE4oDewgRn5PQ8Ek9XZOK6lR9zpvfAh4FalPCJI0hswgRBnJ6kvyG4S
 Pdb7Xwz5qAKffO4wXiQDpG/teTC/JPXFwF/FFkL2CIf0BPVltzir3P7sZB5H4ZxJcPauyL18E
 H7XUA+2Eiitl9rPhKaxiymJ7uW1UQjq6JAGVPePRP9lXg2zzDTx0jAm5ghAZ9ExrxE8Cj9XPo
 0qG3P04/4r1w45QoFezhkhFOxbYpXzZFHZL/fngyGcbiRhi28fJAfQEZJ6hZIrX2mznLK5hYV
 H4JSc8Q6/gaBxE0Ws1B0ZkOphZmzsTrwmZcgpIJ+smCUxn1cz7uEwsRWCoCQwnnnN8MhvDhEA
 fGz7XAk5uucuINAQea1riUJRRg7PW7zLTFz5tuk0cYYdlz1JXFBTvXYXC+dHhY0+2bYyZ0MNw
 ATKxyYbUuYmapc/O5qsIMVRwblWFO7HvVwmtBlceV8pPprY0rphEbIZFt7I9BVOeG1u+WkV2D
 fcqQmf/qomrpszCXcawld0NoPdZf7zg3J4fdwj4PVKeQDSWWNEuFW3TGxLMXModTaScN9Ydc7
 9YU8kV00sjHd5fF6qp8ZUWoz3yBXbmHX9TdWptqPjEBEDIcaJ7+PEib8lhqxI+2ppS8TJuOsH
 6KQBMq12BYUEjJP/YfQszGI6sr+G9k+3hsmExyHs5a84d7N0pvijJW1KqqfA9vHgzf8fRWv+g
 +qcbouO8nI35zzgmDzkuZGfoCWxEduLPkwLzKyrmnoHcWsFbwY=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 6, 2022 at 10:55 AM Rafał Miłecki <zajec5@gmail.com> wrote:
> On 6.05.2022 10:45, Arnd Bergmann wrote:
> > On Fri, May 6, 2022 at 9:44 AM Rafał Miłecki <zajec5@gmail.com> wrote:
> >> With
> >> echo 1 > /sys/class/net/eth0/queues/rx-0/rps_cpus
> >> my NAT speeds were jumping between 2 speeds:
> >> 284 Mbps / 408 Mbps
> >
> > Can you try using 'numactl -C' to pin the iperf processes to
> > a particular CPU core? This may be related to the locality of
> > the user process relative to where the interrupts end up.
>
> I run iperf on x86 machines connected to router's WAN and LAN ports.
> It's meant to emulate end user just downloading from / uploading to
> Internet some data.
>
> Router's only task is doing masquarade NAT here.

Ah, makes sense. Can you observe the CPU usage to be on
a particular core in the slow vs fast case then?

        Arnd
