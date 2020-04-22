Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72E11B4DF8
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 22:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgDVUF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 16:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725779AbgDVUF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 16:05:57 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF40C03C1A9;
        Wed, 22 Apr 2020 13:05:57 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id f82so3244268ilh.8;
        Wed, 22 Apr 2020 13:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Xw3SluUqEV6Dcus+DaT8e6xQrR+AQO/E/D6ih0GzeD0=;
        b=CyS+ynH71ki+YJPjlxz1hBv+LXYl4ILW6jmkRbKWgiAZdKXtGWDYIXr9uZidi9SlmW
         WsWRL2XpgsOHt5e4k75kW4R7K96kNriryVBN6zl3TmPHeU/DOwm+48c5E/3dq50f/SI+
         G7K0fdjPR/LOwmbBWjyDVxsY9Zcz0rVAjqhJtLFEaYN4Kpbizt0HvfkfRUmme40j9OP+
         LTB6J+CbesvBXuHz+Y2YDoihlayzLyhwjpOEINvwOE9XF05xmm+HZwiE3RQVP/oqT0kS
         +jCjlCfB27rx6vtAGjWHpMApvN/6PgTTwigN8npgFPHBwgUt1k/WWZygSC0AQJaToRlY
         7pZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Xw3SluUqEV6Dcus+DaT8e6xQrR+AQO/E/D6ih0GzeD0=;
        b=jZSKPQiAqqzi/Nvlu55+N4+7gvcgwE2UXvWC4Xz9t8zZ0p9X5RXNd18MeRt43qvPZP
         tfuC7BarMxrA2gKGypXZTQ3hv2NljHPmeUeCQl33vkQQrltcrVzg8+6jLrEYo8NUiox0
         4h+yryrWqRKG4dsjwJXtmzblQisi1uXPqwzVb2iLONXhAyme0eCP1vI1818xLhhrFZXU
         0htBy1XA8kYZqUynZrmzUmF7DSDuf9jUwtetmAKd5tQk3SGCzs2FOUIpqXH4ZP9FLzrO
         Pg7JCh965o0XigBpjloH3FfS+F4GvnSTKmiM/U7DOSgyoh1UPyn8bGYVcU8vJDpR6zb8
         wLiw==
X-Gm-Message-State: AGi0PuadjsEwjqT1DSCRVcIavPTBJb83O5+h2WcmgzlCRtRr20pQDbqO
        WdApmnU3jvPm+jTE0olWw9IRrp4SkldvibSh72w=
X-Google-Smtp-Source: APiQypLA6rfyq5iysKbMF3E/bLPKjBS2o/ZGybhQgd+qAuG5aybxGINyfc3iCOabGaQC8z+V6zkaG0zXNpEVwyRHGYY=
X-Received: by 2002:a92:dc0d:: with SMTP id t13mr93915iln.287.1587585957053;
 Wed, 22 Apr 2020 13:05:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200418011211.31725-5-Po.Liu@nxp.com> <20200422024852.23224-1-Po.Liu@nxp.com>
 <20200422024852.23224-2-Po.Liu@nxp.com> <20200422191910.gacjlviegrjriwcx@ws.localdomain>
 <CA+h21hrZiRq2-8Dx31X_rwgJ2Lkp6eF9H7M3cOyiBAWs0_xxhw@mail.gmail.com>
In-Reply-To: <CA+h21hrZiRq2-8Dx31X_rwgJ2Lkp6eF9H7M3cOyiBAWs0_xxhw@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 22 Apr 2020 13:05:45 -0700
Message-ID: <CAA93jw6fAyKHCLGD8vsXXz1yGPwXk5tOzWXDMbbn3z3Kw5P8PA@mail.gmail.com>
Subject: Re: [v3,net-next 1/4] net: qos: introduce a gate control flow action
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Po Liu <Po.Liu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        michael.chan@broadcom.com, vishal@chelsio.com,
        Saeed Mahameed <saeedm@mellanox.com>, leon@kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        simon.horman@netronome.com,
        Pablo Neira Ayuso <pablo@netfilter.org>, moshe@mellanox.com,
        Murali Karicheri <m-karicheri2@ti.com>,
        Andre Guedes <andre.guedes@linux.intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 12:31 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Allan,
>
> On Wed, 22 Apr 2020 at 22:20, Allan W. Nielsen
> <allan.nielsen@microchip.com> wrote:
> >
> > Hi Po,
> >
> > Nice to see even more work on the TSN standards in the upstream kernel.
> >
> > On 22.04.2020 10:48, Po Liu wrote:
> > >EXTERNAL EMAIL: Do not click links or open attachments unless you know=
 the content is safe
> > >
> > >Introduce a ingress frame gate control flow action.
> > >Tc gate action does the work like this:
> > >Assume there is a gate allow specified ingress frames can be passed at
> > >specific time slot, and be dropped at specific time slot. Tc filter
> > >chooses the ingress frames, and tc gate action would specify what slot
> > >does these frames can be passed to device and what time slot would be
> > >dropped.
> > >Tc gate action would provide an entry list to tell how much time gate
> > >keep open and how much time gate keep state close. Gate action also
> > >assign a start time to tell when the entry list start. Then driver wou=
ld
> > >repeat the gate entry list cyclically.
> > >For the software simulation, gate action requires the user assign a ti=
me
> > >clock type.
> > >
> > >Below is the setting example in user space. Tc filter a stream source =
ip
> > >address is 192.168.0.20 and gate action own two time slots. One is las=
t
> > >200ms gate open let frame pass another is last 100ms gate close let
> > >frames dropped. When the frames have passed total frames over 8000000
> > >bytes, frames will be dropped in one 200000000ns time slot.
> > >
> > >> tc qdisc add dev eth0 ingress
> > >
> > >> tc filter add dev eth0 parent ffff: protocol ip \
> > >           flower src_ip 192.168.0.20 \
> > >           action gate index 2 clockid CLOCK_TAI \
> > >           sched-entry open 200000000 -1 8000000 \
> > >           sched-entry close 100000000 -1 -1
> >
> > First of all, it is a long time since I read the 802.1Qci and when I di=
d
> > it, it was a draft. So please let me know if I'm completly off here.
> >
> > I know you are focusing on the gate control in this patch serie, but I
> > assume that you later will want to do the policing and flow-meter as
> > well. And it could make sense to consider how all of this work
> > toghether.
> >
> > A common use-case for the policing is to have multiple rules pointing a=
t
> > the same policing instance. Maybe you want the sum of the traffic on 2
> > ports to be limited to 100mbit. If you specify such action on the
> > individual rule (like done with the gate), then you can not have two
> > rules pointing at the same policer instance.
> >
> > Long storry short, have you considered if it would be better to do
> > something like:
> >
> >    tc filter add dev eth0 parent ffff: protocol ip \
> >             flower src_ip 192.168.0.20 \
> >             action psfp-id 42
> >
> > And then have some other function to configure the properties of psfp-i=
d
> > 42?
> >
> >
> > /Allan
> >
>
> It is very good that you brought it up though, since in my opinion too
> it is a rather important aspect, and it seems that the fact this
> feature is already designed-in was a bit too subtle.
>
> "psfp-id" is actually his "index" argument.
>
> You can actually do this:
> tc filter add dev eth0 ingress \
>         flower skip_hw dst_mac 01:80:c2:00:00:0e \
>         action gate index 1 clockid CLOCK_TAI \
>         base-time 200000000000 \
>         sched-entry OPEN 200000000 -1 -1 \
>         sched-entry CLOSE 100000000 -1 -1
> tc filter add dev eth0 ingress \
>         flower skip_hw dst_mac 01:80:c2:00:00:0f \
>         action gate index 1
>
> Then 2 filters get created with the same action:
>
> tc -s filter show dev swp2 ingress
> filter protocol all pref 49151 flower chain 0
> filter protocol all pref 49151 flower chain 0 handle 0x1
>   dst_mac 01:80:c2:00:00:0f
>   skip_hw
>   not_in_hw
>         action order 1:
>         priority wildcard       clockid TAI     flags 0x6404f
>         base-time 200000000000                  cycle-time 300000000
>          cycle-time-ext 0
>          number    0    gate-state open         interval 200000000
>          ipv wildcard    max-octets wildcard
>          number    1    gate-state close        interval 100000000
>          ipv wildcard    max-octets wildcard
>         pipe
>          index 2 ref 2 bind 2 installed 168 sec used 168 sec
>         Action statistics:
>         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>         backlog 0b 0p requeues 0
>
> filter protocol all pref 49152 flower chain 0
> filter protocol all pref 49152 flower chain 0 handle 0x1
>   dst_mac 01:80:c2:00:00:0e
>   skip_hw
>   not_in_hw
>         action order 1:
>         priority wildcard       clockid TAI     flags 0x6404f
>         base-time 200000000000                  cycle-time 300000000
>          cycle-time-ext 0
>          number    0    gate-state open         interval 200000000
>          ipv wildcard    max-octets wildcard
>          number    1    gate-state close        interval 100000000
>          ipv wildcard    max-octets wildcard
>         pipe
>          index 2 ref 2 bind 2 installed 168 sec used 168 sec
>         Action statistics:
>         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>         backlog 0b 0p requeues 0
>
> Actually my only concern is that maybe this mechanism should (?) have
> been more generic. At the moment, this patch series implements it via
> a TCA_GATE_ENTRY_INDEX netlink attribute, so every action which wants
> to be shared across filters needs to reinvent this wheel.
>
> Thoughts, everyone?

I don't have anything valuable to add, aside from commenting this
whole thing makes my brain hurt.

> Thanks,
> -Vladimir



--=20
Make Music, Not War

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-435-0729
