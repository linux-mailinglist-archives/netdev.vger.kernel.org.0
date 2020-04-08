Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF9A31A2A18
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 22:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730207AbgDHULH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 16:11:07 -0400
Received: from mail-ed1-f48.google.com ([209.85.208.48]:35452 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729682AbgDHULG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 16:11:06 -0400
Received: by mail-ed1-f48.google.com with SMTP id c7so10376951edl.2
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 13:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eCYsZLS97QLhKKwuI7DX5hcVxNYmnHqtRLK0/roj1yw=;
        b=QrnE96NYonSTuqC2Lf9wb7Rw7D91RdvI3JGbaMUUhbXEtRUzo4UDraRP9zezs24vil
         vJlewn1zZak+1XSqg2dtM0jKR8uRsIrzJByf8qJXrudE6lqwi1z3XYHj7mdkwG1Urz3i
         XZqOlu8N4UZciQux2Zm1HlCkOMUwrXDvwr0LTABPCxNngiJqBUZ/WT+eTXdQk4pwO2TQ
         JED1mWbL15hgk/Opb2OzCFOlF83Vrh48hNwMHF2ACnUfxCcyHkoPvYBQlbU1QOrOt5nb
         +7889IkFepOuYrUHNeXMnBO41ngt/RrZ0LOQvkLeJzpKjHPI7vlIsUs7aeRubLNdLBPk
         SaeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eCYsZLS97QLhKKwuI7DX5hcVxNYmnHqtRLK0/roj1yw=;
        b=KIR5geaW+4Lkq+3FzckKSb0WAGBCd4zuOBMt2mGeITkVT+l+8XB6q4UwxJyatOhb3h
         rbhyqdRk1Hc+QhH4pZpa2m+lrr/pgzgCUl2QCfOsnopYZW8Qq3T6BVUZM/nlt20K3g1F
         9QjppxenCdZZz/UPX1EfutPH3Voe4qZNc9JJLTZB//PxBlRUKxd6Ho2QAA2IxfS3804u
         qTbuZWzZdBU4j2Sc36+5rVfl7EngIE24DyADXaQMVfdKCexvtpxrksfpN8uNMTSrqqvq
         3qrq5MLpb/rTwxvxF7IT8/Qq70iZAWDdxB0m9U79ngc5cixhczAGkThH1bbtNaQ8Idaz
         r0tQ==
X-Gm-Message-State: AGi0PubsCCIncY6+t/hTmJ1bISGJcnLxkT/ENeyo0cr0eq/KaTPvqMtE
        AHJXtzqy/2WqDglEDeBMKhzMmNXV34l0YbQpUJw=
X-Google-Smtp-Source: APiQypJZB/rSARRvWFlw59iUUAsultMOoTWXKqYbrlUdexd6Ag83oxXjIeySkR1pJz1A8NYMQ/zX2VW2EIiS8QnpIlw=
X-Received: by 2002:a17:906:9359:: with SMTP id p25mr8531071ejw.184.1586376664260;
 Wed, 08 Apr 2020 13:11:04 -0700 (PDT)
MIME-Version: 1.0
References: <ef16b5bb-4115-e540-0ffd-1531e5982612@gmail.com>
 <CA+h21hrtUg9Xxwxfe+N6MkY2eSjjDTQc+sTtRwYW4kf_u3quwA@mail.gmail.com> <5efb57cc-d783-ed70-73c1-3114f4952520@gmail.com>
In-Reply-To: <5efb57cc-d783-ed70-73c1-3114f4952520@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 8 Apr 2020 23:10:53 +0300
Message-ID: <CA+h21hpG64V4OhF0yRa-HfBYo9EoZDP8P-y3WT==w4WUrNVkLQ@mail.gmail.com>
Subject: Re: Changing devlink port flavor dynamically for DSA
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Apr 2020 at 23:05, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 4/8/2020 12:51 PM, Vladimir Oltean wrote:
> > Hi Florian,
> >
> > On Sun, 5 Apr 2020 at 23:42, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >>
> >> Hi all,
> >>
> >> On a BCM7278 system, we have two ports of the switch: 5 and 8, that
> >> connect to separate Ethernet MACs that the host/CPU can control. In
> >> premise they are both interchangeable because the switch supports
> >> configuring the management port to be either 5 or 8 and the Ethernet
> >> MACs are two identical instances.
> >>
> >> The Ethernet MACs are scheduled differently across the memory controller
> >> (they have different bandwidth and priority allocations) so it is
> >> desirable to select an Ethernet MAC capable of sustaining bandwidth and
> >> latency for host networking. Our current (in the downstream kernel) use
> >> case is to expose port 5 solely as a control end-point to the user and
> >> leave it to the user how they wish to use the Ethernet MAC behind port
> >> 5. Some customers use it to bridge Wi-Fi traffic, some simply keep it
> >> disabled. Port 5 of that switch does not make use of Broadcom tags in
> >> that case, since ARL-based forwarding works just fine.
> >>
> >> The current Device Tree representation that we have for that system
> >> makes it possible for either port to be elected as the CPU port from a
> >> DSA perspective as they both have an "ethernet" phandle property that
> >> points to the appropriate Ethernet MAC node, because of that the DSA
> >> framework treats them as CPU ports.
> >>
> >> My current line of thinking is to permit a port to be configured as
> >> either "cpu" or "user" flavor and do that through devlink. This can
> >> create some challenges but hopefully this also paves the way for finally
> >> supporting "multi-CPU port" configurations. I am thinking something like
> >> this would be how I would like it to be configured:
> >>
> >> # First configure port 8 as the new CPU port
> >> devlink port set pci/0000:01:00.0/8 type cpu
> >> # Now unmap port 5 from being a CPU port
> >> devlink port set pci/0000:01:00.0/1 type eth
> >>
> >> and this would do a simple "swap" of all user ports being now associated
> >> with port 8, and no longer with port 5, thus permitting port 5 from
> >> becoming a standard user port. Or maybe, we need to do this as an atomic
> >> operation in order to avoid a switch being configured with no CPU port
> >> anymore, so something like this instead:
> >>
> >> devlink port set pci/0000:01:00.0/5 type eth mgmt pci/0000:01:00.0/8
> >>
> >> The latter could also be used to define groups of ports within a switch
> >> that has multiple CPU ports, e.g.:
> >>
> >> # Ports 1 through 4 "bound" to CPU port 5:
> >>
> >> for i in $(seq 0 3)
> >> do
> >>         devlink port set pci/0000:01:00.0/$i type eth mgmt pci/0000:01:00.0/5
> >> done
> >>
> >> # Ports 7 bound to CPU port 8:
> >>
> >> devlink port set pci/0000:01:00.0/1 type eth mgmt pci/0000:01:00.0/8
> >>
> >> Let me know what you think!
> >>
> >> Thanks
> >> --
> >> Florian
> >
> > What is missing from your argumentation is what would the new devlink
> > mechanism of changing the CPU port bring for your particular use case.
> > I mean you can already remove the "ethernet" device tree property from
> > port 5 and end up exactly with the configuration that you want, no?
>
> That's what I do in our downstream tree for now, should I submit this
> upstream? I doubt it would be accepted.
> --
> Florian

This is exactly what we do for the NXP LS1028A (ocelot/felix driver),
where we enable just one of the 2 CPU ports by default (and the other
one, just as a simple user port in the very few situations that
require it):
https://github.com/torvalds/linux/blob/master/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi#L943
Although to be fair, for LS1028A we can't even dream of enabling DSA
tagging on both CPU ports at the same time, since there is a hardware
limitation in place that only a single port may carry DSA tags at any
given moment in time.

-Vladimir
