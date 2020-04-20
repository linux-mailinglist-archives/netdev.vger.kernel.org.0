Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EE71AFF15
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 02:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgDTADi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 20:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725947AbgDTADh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 20:03:37 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C97C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 17:03:37 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w2so6006654edx.4
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 17:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9XWofAVQkjwidFtFUDcNUdf83dNoUggf1miPbWtg11U=;
        b=qbkemFXf2+qCGXxw8A3wYNmJRjb7704c4ChXeACsSCbEGpx/ui3l/sGGedoom1S0tk
         BVXlSBsL1vKPYoIOfq75U3kVZF5LQGkA04HpvlmO2R4ZLXA4HzsZElDBq8PLdSAwDmfo
         ASTTJnytMMGXvOy1VP3mbkIVm/MY0H2FU7JDoaqfIQ9C2Vaz3GpUKRZG8KsOILOrD9Wx
         uU0xDECTLAU9lWF33s8V9ga+vGWJYFy/DPayqPMyGew+2F85oHpp+QgeVqjybKkWgxRI
         o8fujxb53KZWhc3H9b6N+Fd36A2VyoQjL5iJrV7ygyHCa3psJWgYhp5qQSgnVe10GGQu
         xtBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9XWofAVQkjwidFtFUDcNUdf83dNoUggf1miPbWtg11U=;
        b=Kazz5fFkgmXmG18xCUJr7TNXgHEYeftQK0+4rRaDtIzeRtfqJORytpB7fQZ6w0Ef71
         ZFRlaavKN4L3gWPhqeV2r6THezTHObTwXQ0AzyK9EAyvgTGu6QG2l51L2gMwWSpKth2V
         B7uby3gNWgktwDrJdv0v2w2t21WA67hWICZl4rE58lR7fstLIvc1ZpXrddAqQnU+glCy
         /5qIqx9JZhdhYVm/K10yHwifUWNpcwlvFZVaHj/wDMA9m1GWarhKG/esY8T9avzHouAm
         J/rmDllUA+BLEqmyJDaR7PPsJepYKM4O30dBgqts7HciIXUWIDttMmgoIM4IXo4sQsVJ
         RndA==
X-Gm-Message-State: AGi0PuZEBuuwTnhu+jr9Yq/e8BIE4Qcro5OoEplqb0m98GbCHG1kS8tt
        CELCmC3vJz8XUfsOueIaFWBUx3/ZkES4Aejcsol9Pg==
X-Google-Smtp-Source: APiQypKNzHLRqOycG2Qy2+7B4rLXItG6Fo2fFLRt5yvaCZ8lYTJrxHjVnQgZsAmex0kXmm5CMVK2/GqgTBFAlA9Hgd4=
X-Received: by 2002:a50:aca3:: with SMTP id x32mr12372250edc.368.1587341014539;
 Sun, 19 Apr 2020 17:03:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200417190308.32598-1-olteanv@gmail.com> <20200419073307.uhm3w2jhsczpchvi@ws.localdomain>
 <CA+h21hrvSjRwDORZosxDt5YA+uMckaypT51f-COr+wtB7EjVAQ@mail.gmail.com> <20200419182534.o42v5fiw34qxhenu@ws.localdomain>
In-Reply-To: <20200419182534.o42v5fiw34qxhenu@ws.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 20 Apr 2020 03:03:23 +0300
Message-ID: <CA+h21hoBxX3GWQ7+ehov2eGzhsqodH9RjN0FfVTW6beFFjETBQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: deal with problematic
 MAC_ETYPE VCAP IS2 rules
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, Po Liu <po.liu@nxp.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Mingkai Hu <mingkai.hu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Allan,

On Sun, 19 Apr 2020 at 21:25, Allan W. Nielsen
<allan.nielsen@microchip.com> wrote:
>
> On 19.04.2020 17:20, Vladimir Oltean wrote:
> >EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> >
> >On Sun, 19 Apr 2020 at 10:33, Allan W. Nielsen
> ><allan.nielsen@microchip.com> wrote:
> >>
> >> Hi,
> >>
> >> Sorry I did not manage to provide feedback before it was merged (I will
> >> need to consult some of my colleagues Monday before I can provide the
> >> foll feedback).
> >>
> >> There are many good things in this patch, but it is not only good.
> >>
> >> The problem is that these TCAMs/VCAPs are insanely complicated and it is
> >> really hard to make them fit nicely into the existing tc frame-work
> >> (being hard does not mean that we should not try).
> >>
> >> In this patch, you try to automatic figure out who the user want the
> >> TCAM to be configured. It works for 1 use-case but it breaks others.
> >>
> >> Before this patch you could do a:
> >>      tc filter add dev swp0 ingress protocol ipv4 \
> >>              flower skip_sw src_ip 10.0.0.1 action drop
> >>      tc filter add dev swp0 ingress \
> >>              flower skip_sw src_mac 96:18:82:00:04:01 action drop
> >>
> >> But the second rule would not apply to the ICMP over IPv4 over Ethernet
> >> packet, it would however apply to non-IP packets.
> >>
> >> With this patch it not possible. Your use-case is more common, but the
> >> other one is not unrealistic.
> >>
> >> My concern with this, is that I do not think it is possible to automatic
> >> detect how these TCAMs needs to be configured by only looking at the
> >> rules installed by the user. Trying to do this automatic, also makes the
> >> TCAM logic even harder to understand for the user.
> >>
> >> I would prefer that we by default uses some conservative default
> >> settings which are easy to understand, and then expose some expert
> >> settings in the sysfs, which can be used to achieve different
> >> behavioral.
> >>
> >> Maybe forcing MAC_ETYPE matches is the most conservative and easiest to
> >> understand default.
> >>
> >> But I do seem to recall that there is a way to allow matching on both
> >> SMAC and SIP (your original motivation). This may be a better default
> >> (despite that it consumes more TCAM resources). I will follow up and
> >> check if this is possible.
> >>
> >> Vladimir (and anyone else whom interested): would you be interested in
> >> spending some time discussion the more high-level architectures and
> >> use-cases on how to best integrate this TCAM architecture into the Linux
> >> kernel. Not sure on the outlook for the various conferences, but we
> >> could arrange some online session to discuss this.
> >>
> >> /Allan
> >>
> >
> >And yes, we would be very interested in attending a call for syncing
> >up on integrating the TCAM hardware with the flow offload
> >infrastructure from Linux. Actually at the moment we are trying to add
> >support for offloaded VLAN retagging with the VCAP IS1 and ES0 blocks.
>
> Sounds good - lets spend some time to talk discuss this and see what
> comes out of it.
>
> Ido, if you want to join us, pleaes comment with your preferences. If
> others want to join please let me know.
>
> I can setup a meeting in WebEx or Teams. I'm happy to join on other
> platformws if you prefer. They both works fine from Linux in Chrome and
> FireFox (sometimes tricky to get the sound working in FF).
>
> Proposed agenda:
>
> - Cover the TCAM architecture in Ocelot/Felix (just to make sure we are
>    all on the same page).
> - Present some use-cases MCHP would like to address in future.
> - Open discussion.
>
> I think we will need something between 30-120 minutes depending on how
> the discussion goes.
>
> We are in CEST time - and I'm okay to attend from 7-22.
>
> What about you.
>
> /Allan

From my side I am available for the entire time interval you
mentioned, since the time zone in Bucharest (GMT+3) is rather close to
Copenhagen. Our colleagues from NXP Beijing might also be interested,
which is probably going to restrict the time interval to the first
half of the day. And you can also schedule for Tuesday if tomorrow is
on too short notice.
Both WebEx and Teams should work, with a slight preference to Teams
since NXP people are already using it.

Thanks,
-Vladimir
