Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AD51E4E26
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 21:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgE0TaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 15:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgE0TaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 15:30:06 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD19C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 12:30:05 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id be9so21256514edb.2
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 12:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AHlUILqDLnNJwZRJq0U7jG9CyRJfHPvbETI9OAEBntU=;
        b=QY/67reDyheH7ZG6gqRefgHKJhwP8BeT0pKCbFP2UI/KTx5b0JHev9trVAkGaVyutX
         QH6xP1qZ4w1LxsRx/7eskZPrm67AU1UJpEOdoG70Z6ZSEjn1QVos8bCHrJWCMtHmSUEp
         LjzjuFKWH24xhSp8u1Gk484MMjlFXNXQUc2t026xPUYIbBENxvB+x0bB3uiaF9/B3sSs
         TUOtU6jFGiktcDBgXGEWIyYXjynETuRXvUFdsktTQ5RrJf+Pw7frwgqX4yeOF6xEh2ua
         y8ynOH7Em7adNBu6wn1w84LGy5n9gHjrI/IrTXINwu1flf08dIDqoa2CJwhiPwjM0flh
         1FoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AHlUILqDLnNJwZRJq0U7jG9CyRJfHPvbETI9OAEBntU=;
        b=g/6G1WaJYNVOUWVImiCLuwLKcCZgwAVFZJ/b2vFR9D46oQOIxm09xNfNxICfHmmOog
         TWU8lfB6YhUbW03Tv7sju7GWMRil2au92z0LAhkqdGaPT8/uLlkQDzMY/YmxPpq6XFDg
         Yg/y+ZdKJ8MksPEcyiXs3OrkdkqjrwX7FC9wP9pSHU/JYZYXQGcbxIZtPWF4ECiuggW1
         CsXvYp/I0thQLhrg3rOFgfOsP8t2XYUkCa1mLx3tMRd6Yu8MqiTiSNUMmYsue6fpgNb0
         +ZKFuiytzC+cNf09ukcjj2jyA6PWQ1NMSEinps4Llyu/ApHTUAAa++A6KPYmHVG1VXdz
         REfw==
X-Gm-Message-State: AOAM531htw+S/IJY+SN44WD6rC23xgvRPaa92qHAulDqyzfk4ApjxlA+
        314ZEaXjcf297aSt4vI9ZCr8qAVIM0tZ/SRYyjP+y6iX
X-Google-Smtp-Source: ABdhPJyYarta102h+9rh+LsFVjVeWngGxwAWJ50/ctXmT3QmGvzCkKMMr+WdynKEcee09gQArsYBqycnolnCYEFv1vs=
X-Received: by 2002:a50:bf03:: with SMTP id f3mr26365997edk.368.1590607804129;
 Wed, 27 May 2020 12:30:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200527165527.1085151-1-olteanv@gmail.com> <87v9khjkui.fsf@intel.com>
In-Reply-To: <87v9khjkui.fsf@intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 27 May 2020 22:29:53 +0300
Message-ID: <CA+h21hqKT6i804Bp8ie+Tvdktq2Yn2wekeH0tBdTqsd0oWoQJA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: sja1105: offload the Credit-Based
 Shaper qdisc
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On Wed, 27 May 2020 at 21:25, Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Hi,
>
> Vladimir Oltean <olteanv@gmail.com> writes:
>
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > SJA1105, being AVB/TSN switches, provide hardware assist for the
> > Credit-Based Shaper as described in the IEEE 8021Q-2018 document.
> >
> > First generation has 10 shapers, freely assignable to any of the 4
> > external ports and 8 traffic classes, and second generation has 16
> > shapers.
> >
> > We also need to provide a dummy implementation of mqprio qdisc offload,
> > since this seems to be necessary for shaping any traffic class other
> > than zero.
> >
> > The Credit-Based Shaper tables are accessed through the dynamic
> > reconfiguration interface, so we have to restore them manually after a
> > switch reset. The tables are backed up by the static config only on
> > P/Q/R/S, and we don't want to add custom code only for that family,
> > since the procedure that is in place now works for both.
> >
> > Tested with the following commands:
> >
> > data_rate_kbps=34000
> > port_transmit_rate_kbps=1000000
> > idleslope=$data_rate_kbps
> > sendslope=$(($idleslope - $port_transmit_rate_kbps))
> > locredit=$((-0x7fffffff))
> > hicredit=$((0x7fffffff))
> > tc qdisc add dev sw1p3 root handle 1: mqprio num_tc 8
>
> This (and implementing the dummy mqprio offload callback) seem a bit
> hackish: I am reading this is more a way to bypass mqprio parameter
> validation (the priority to queue mapping) than anything else.
>
> And I don't think that accepting any parameters without doing any
> validation is really what you want.
>
> Question:
>
> $ tc qdisc replace dev $IFACE parent root handle 100 mqprio \
>       num_tc 3 \
>       map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>       queues 1@0 1@1 1@2 \
>       hw 0
>
> $ tc qdisc replace dev $IFACE handle 200 parent 100:1 cbs \
>       idleslope 100000 sendslope -900000 hicredit 150 locredit -1362 \
>       offload 1
>
> Why doesn't something like this work for your hardware?
>
>
> Cheers,
> --
> Vinicius

No, it absolutely does, thanks.
I had tried a few combinations of tc mqprio commands with hw 0, and
they all returned this cryptic:

tc qdisc add dev swp2 root handle 100 mqprio num_tc 8 map 0 1 2 3 4 5 6 7 hw 0
RTNETLINK answers: Invalid argument
tc qdisc add dev swp2 root handle 100 mqprio num_tc 8 hw 0
RTNETLINK answers: Invalid argument

which I had absolutely no desire to debug, especially since the same
commands, with hw 1, were accepted.
I just chose to be deliberately wrong, knowing that it's the quickest
way to find out the real solution :)

Cheers,
-Vladimir
