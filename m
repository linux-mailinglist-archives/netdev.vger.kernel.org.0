Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92FDA16618E
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 16:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgBTP5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 10:57:02 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35390 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbgBTP5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 10:57:00 -0500
Received: by mail-ed1-f67.google.com with SMTP id c7so2245621edu.2
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 07:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lNcX9OwXnxTPnZRmXVGk/qKltgg3X2cli1OxMFjoREA=;
        b=RmCwi/vArsZeZONQJpzpXIrAa+DBDSJzGonV2Mr9vtUAjHYDtmc84VTyvEo7TeCoXU
         nNLZQoReOld1uHkJN/NQcd1VrkyTIJ3FuvmfBgResvouXbp4B7aijbTpZ/7Lv4V1rPT+
         lg6+jIgebIKQKjqreaUdmjraXGwf5+SEuWRlObDJ6+AETCLksZ5KZiLlHT6lH4X+DF1n
         QTrplwtETqmHehbz7sEgmH47f/bR7nPriFKyDy0PFrgOQWLYxiWqWb+zSwlwamBQvJ6U
         ctEFiQsxz8cHgwSolPg9UN/cfltRG0JQG3xIVYFeqr84sRZ8jZd1cACzqhb6gdtMJYJe
         uU9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lNcX9OwXnxTPnZRmXVGk/qKltgg3X2cli1OxMFjoREA=;
        b=BWVRhKVqi79NzrK+7HpoZ7TeSDty0Dv5jLzgJkNbDq12QFfzW+8sGPC0ZfY7LySe2f
         iJyxDFQHL5HUFHwKihMSHDNgcye2wjLr72U7EVn+NpKJ90gtqaelzO/RWPAWYzQ6PIou
         2f9k24G4iByn1vE9Lsd89Bo9DkTNwTih1A8lJzD5rBybg7c6HDDfg88k1YnF4sePQqdi
         YJFT7YZpjME0YiggGtJxCYAWJTBYWaYIG3Z3oUQ8XUE9C8Vz9s/EipUCdUSbjTUNn6yF
         bBHzmtVJOpx1rIln3PYghu5/arPZhQIsweo0e4R1X5/iDePRUQ5JRUzLc1fKOdpuKuAy
         iJ6A==
X-Gm-Message-State: APjAAAUgybrSz1aT8OkomaWmvZgKN6K7TBjbQhrQWNlBrAirzacJMMjK
        wt0jyzgBjuXeIRhNLyHa7sm/R8Yz4vVX3y+HdrE=
X-Google-Smtp-Source: APXvYqwSIYtOf5zp7YjChuioz5acspMiN1ZDmQsDLYt2LWq8ThCsa9tcU3M3UMWHt59a57CuLUIfIFysD4UObFHWy28=
X-Received: by 2002:a17:906:1e48:: with SMTP id i8mr28244840ejj.189.1582214218213;
 Thu, 20 Feb 2020 07:56:58 -0800 (PST)
MIME-Version: 1.0
References: <20200217150058.5586-1-olteanv@gmail.com> <20200218113159.qiema7jj2b3wq5bb@lx-anielsen.microsemi.net>
 <CA+h21hpAowv50TayymgbHXY-d5GZABK_rq+Z3aw3fngLUaEFSQ@mail.gmail.com>
 <20200218140111.GB10541@lunn.ch> <20200219101739.65ucq6a4dmlfgfki@lx-anielsen.microsemi.net>
 <CA+h21hp5NQNJJ5agMPAZ+edaZ+ouSjTJ8DypYR5Htx3ZT5iSYA@mail.gmail.com> <20200220132329.43s6tq3xsoo7htuz@lx-anielsen.microsemi.net>
In-Reply-To: <20200220132329.43s6tq3xsoo7htuz@lx-anielsen.microsemi.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 20 Feb 2020 17:56:47 +0200
Message-ID: <CA+h21hpALimQbwrdSbfApMHuUsEohXnDs8X-Z85Q-1r08-651A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: Workaround to allow traffic
 to CPU in standalone mode
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Feb 2020 at 15:23, Allan W. Nielsen
<allan.nielsen@microchip.com> wrote:
>
> Horatiu and I have looked further into this, done a few experiments, and
> discussed with the HW engineers who have a more detailed version of how
> the chips are working and how Ocelot and Felix differs.
>
> Here are our findings:
>
> - The most significant bit in the PGID table is "special" as it is a
>    CPU-copy bit.

Wow.
Looking at the code after this realization, it is so confusing to call
the NPI port "ocelot->cpu" now, since it doesn't benefit from this
"privilege" that a "real" CPU port (from the Ocelot hardware
perspective) has.
Not to mention how strange it is for the hardware to behave this way.

> - This bit is not being used in the source filtering!

So BIT(6) on Felix and BIT(11) on Ocelot are just being interpreted
for the first and second PGID lookup (destination and aggregation
masks) but not for source masks? Don't you want to actually document
this somewhere?

So the frame is copied to the CPU based on the AND between first and
second lookup, and to all the other ports, including the NPI port,
based on the first, second and third PGID lookup.
So frames can reach the NPI port directly, via 3 PGID lookups, or
indirectly, via 2 PGID lookups. What I did is make the direct path
work. You're suggesting me to set the indirect mode up.

> This means that
>    your original patch can be applied without breaking Ocelot (the
>    uninitialized cpu field must be fixed though).

So my patch makes the Felix NPI port work in an unintended way and
does not affect Ocelot in any way. Roger.

>    - Still I do not think we should do this as it is not the root-casuse
> - In Felix we have 2 ways to get frames to the CPU, in Ocelot we have 1
>    (Ocelot also has two if it uses an NPI port, but it does not do that
>    in the current driver).
>    - In Felix you can get frames to the CPU by either using the CPU port
>      (port 6), or by using the NPI port (which can be any in the range of
>      0-5).
>      - But you should only use the CPU port, and not the NPI port
>        directly. Using the NPI port directly will cause the two targets
>        to behave differently, and this is not what we do when testing all
>        the use-cases on the switch.

Differently in what way?

>    - In Ocelot you can only get frames to the CPU by using the CPU port
>      (port 11).
>
> Due to this, I very much think you need to fix this, such that Felix
> always port 6 to reach the CPU (with the exception of writing
> QSYS_EXT_CPU_CFG where you "connect" the CPU queue/port to the NPI
> port).
>

What PGIDs should I use for the NPI port if I use it with indirection
via port 6?

> If you do this change, then the Ocelot and Felix should start to work in
> the same way.
>
> Then, if you want the CPU to be part of the unicast flooding (this is
> where this discussion started), then you should add the CPU port to the
> PGID entry pointed at in ANA:ANA:FLOODING:FLD_UNICAST. This should be
> done for Felix and not for Ocelot.

No, the question is why don't _you_ want the CPU to be in the
FLD_UNICAST PGID (which is PGID_UC). The distinction you're making
between Felix and Ocelot here is quite arbitrary, and seems to be
based just on "your CPU is more powerful".

So right now, multicast and broadcast traffic goes to PGID_MC (61),
and unknown unicast goes to PGID_UC (60).
The destination ports mask for PGID_MC is
GENMASK(ocelot->num_phys_ports, 0) - 0x7f for me, 0xfff for you.
The destination ports mask for PGID_UC is
GENMASK(ocelot->num_phys_ports - 1, 0) - this is the hardware default
value - 0x3f for me, 0x7ff for you.
So you are keeping the non-physical CPU port in the destination mask
for broadcast, but not in that for unknown unicast. In the way the
system is configured, it is still susceptible to broadcast storms. So
I don't think there is any real benefit in crippling the system like
this. If port 6 was in PGID_UC by default, I would have never bat an
eye and more than likely never needed to know the gory details.

Is it possible to set up policers for traffic going to CPU? I _did_
see this phrase already in the manual:

"Frames where the DMAC lookup returned a PGID with the CPU port set
are always forwarded to the CPU even when the frame
is policed by the storm policers."

So the traffic I'm seeing now on the NPI port is not copied to the
CPU, it is forwarded.
If there's no other way to set up storm policers for the mode you're
suggesting me to change Felix to, then I would respectfully keep it
the way it is right now.

>
> If you want the analyser (where the MAC table sits), to "learn" the CPU
> MAC (which is needed if you do not want to have the CPU mac as a static
> entry in the MAC-table), then you need to set the 'src-port' to 6 (if it
> is Ocelot then it will be 11) in the IFH:
>

Please tell me more about this. Don't I need to set BYPASS=1 for
frames to go on the front-panel port specified in DEST? And doesn't
BYPASS=1 mean no source MAC learning for injected traffic?
As much as I would like the analyzer to run, I won't do it if it is
going to compromise xmit from Linux. I don't want traffic sent from
Linux to an unknown unicast in standalone mode to be flooded to all
front-panel ports with no way for me to control it.

> anielsen@lx-anielsen ~ $ ef hex ifh-oc1 help
> ifh-oc1          Injection Frame Header for Ocelot1
>
> Specify the ifh-oc1 header by using one or more of the following fields:
> - Name ------------ offset:width --- Description --------------------------
>    bypass              +  0:  1  Skip analyzer processing
>    b1-rew-mac          +  1:  1  Replace SMAC address
>    b1-rew-op           +  2:  9  Rewriter operation command
>    b0-masq             +  1:  1  Enable masquerading
>    b0-masq-port        +  2:  4  Masquerading port
>    rew-val             + 11: 32  Receive time stamp
>    res1                + 43: 17  Reserved
>    dest                + 60: 12  Destination set for the frame. Dest[11] is the CPU
>    res2                + 72:  9  Reserved
>    src-port            + 81:  4  The port number where the frame was injected (0-12)  <------------------- THIS FIELD
>    res3                + 85:  2  Reserved
>    trfm-timer          + 87:  4  Timer for periodic transmissions (1..8). If zero then normal injection
>    res4                + 91:  6  Reserved
>    dp                  + 97:  1  Drop precedence level after policing
>    pop-cnt             + 98:  2  Number of VLAN tags that must be popped
>    cpuq                +100:  8  CPU extraction queue mask
>    qos-class           +108:  3  Classified QoS class
>    tag-type            +111:  1  Tag information's associated Tag Protocol Identifier (TPID)
>    pcp                 +112:  3  Classified PCP
>    dei                 +115:  1  Classified DEI
>    vid                 +116: 12  Classified VID
>
>
> /Allan
>

Thanks,
-Vladimir
