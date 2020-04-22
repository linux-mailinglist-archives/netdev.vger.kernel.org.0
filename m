Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA8D1B4D58
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 21:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgDVT2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 15:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726056AbgDVT2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 15:28:55 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E3EC03C1A9;
        Wed, 22 Apr 2020 12:28:54 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id k22so2429008eds.6;
        Wed, 22 Apr 2020 12:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4eHXvH1GDSckReIfUt4f8dPPiIKiU77VF1j9+W80uRQ=;
        b=uP/akETD4Vrnve92vVb/IdfXa33kcUNoReGjk2EFxDlRxxvgTfCx/O1XGnHkAySkQD
         ubwoL1j/AzgcwCUeuTmwgej97lfen5MpXb+JPt8Rkmpsn2RX+GrRDF3G0E9W4gWGr3y8
         3cFJu02+dBj6qRCc3zfQcB8E0UecHmeEpSElzx9kxOgH3FOaLiFcu+eDJVCWePf3xLxc
         7oxq48VCBot3zepcu+jlumW5b8Xmpi2HbCw7LYlV0kGxDjqF4D2cpH911gMF4Cte9dLo
         4eIcKINvfwUTUPDCkXpxvzcMfYcTht10ALztBX22buJ7PGCVm4FPX2kyHNQ/ERuxRQZ+
         Uf5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4eHXvH1GDSckReIfUt4f8dPPiIKiU77VF1j9+W80uRQ=;
        b=lgOEZH3KOkaDzY4lj67rRgxhfhsris7IVCBMTR+o4feJxA4/gtwZ0SKj1eEdMew+k+
         ygJ94Q7k2A63kuGulF5HWBVcptNDjIVZOIh0MbqqcR6jFNlzxExtcAwnlhH+A5lza/H/
         tu2AM7FxSk8xj+yoZEQboITdS0+A3EnVnLj2xKlKdxX9xxWL9uzpVzEYtQ1MyNkWr839
         7Jqeqt+7UVc/Y1wv46NKlxj2M7Q1XLCjDRT1gSVaOJI4umuW4lVWYur5QHZlOE8nN9M4
         0KC4hKaac+KJ7rMD8WFBiqPwqUwbGl1MhIbvLAi71g2nQQNUMppXeZMXtUeHBsCqt5Cx
         Tuwg==
X-Gm-Message-State: AGi0PuaqkDc2PyVUXDp20W8xGl260XF9sq0X4CA4xQ7x6WJK77jrucrD
        FMrg1A+hk2yGfsuj+ctSQxaYkiV3KjcQiMUGUN8=
X-Google-Smtp-Source: APiQypI7OeDRVTXbyCq1O3B/kdlwU1xDJ3TrABi9IgyUeSvz5pdUmQcw/lj4bMN9FStfuPpjznzaR3gi6ZQgFZa1j/c=
X-Received: by 2002:a50:aca3:: with SMTP id x32mr154548edc.368.1587583733380;
 Wed, 22 Apr 2020 12:28:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200418011211.31725-5-Po.Liu@nxp.com> <20200422024852.23224-1-Po.Liu@nxp.com>
 <20200422024852.23224-2-Po.Liu@nxp.com> <20200422191910.gacjlviegrjriwcx@ws.localdomain>
In-Reply-To: <20200422191910.gacjlviegrjriwcx@ws.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 22 Apr 2020 22:28:42 +0300
Message-ID: <CA+h21hrZiRq2-8Dx31X_rwgJ2Lkp6eF9H7M3cOyiBAWs0_xxhw@mail.gmail.com>
Subject: Re: [v3,net-next 1/4] net: qos: introduce a gate control flow action
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Po Liu <Po.Liu@nxp.com>, "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        leon@kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, Murali Karicheri <m-karicheri2@ti.com>,
        Andre Guedes <andre.guedes@linux.intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Allan,

On Wed, 22 Apr 2020 at 22:20, Allan W. Nielsen
<allan.nielsen@microchip.com> wrote:
>
> Hi Po,
>
> Nice to see even more work on the TSN standards in the upstream kernel.
>
> On 22.04.2020 10:48, Po Liu wrote:
> >EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> >
> >Introduce a ingress frame gate control flow action.
> >Tc gate action does the work like this:
> >Assume there is a gate allow specified ingress frames can be passed at
> >specific time slot, and be dropped at specific time slot. Tc filter
> >chooses the ingress frames, and tc gate action would specify what slot
> >does these frames can be passed to device and what time slot would be
> >dropped.
> >Tc gate action would provide an entry list to tell how much time gate
> >keep open and how much time gate keep state close. Gate action also
> >assign a start time to tell when the entry list start. Then driver would
> >repeat the gate entry list cyclically.
> >For the software simulation, gate action requires the user assign a time
> >clock type.
> >
> >Below is the setting example in user space. Tc filter a stream source ip
> >address is 192.168.0.20 and gate action own two time slots. One is last
> >200ms gate open let frame pass another is last 100ms gate close let
> >frames dropped. When the frames have passed total frames over 8000000
> >bytes, frames will be dropped in one 200000000ns time slot.
> >
> >> tc qdisc add dev eth0 ingress
> >
> >> tc filter add dev eth0 parent ffff: protocol ip \
> >           flower src_ip 192.168.0.20 \
> >           action gate index 2 clockid CLOCK_TAI \
> >           sched-entry open 200000000 -1 8000000 \
> >           sched-entry close 100000000 -1 -1
>
> First of all, it is a long time since I read the 802.1Qci and when I did
> it, it was a draft. So please let me know if I'm completly off here.
>
> I know you are focusing on the gate control in this patch serie, but I
> assume that you later will want to do the policing and flow-meter as
> well. And it could make sense to consider how all of this work
> toghether.
>
> A common use-case for the policing is to have multiple rules pointing at
> the same policing instance. Maybe you want the sum of the traffic on 2
> ports to be limited to 100mbit. If you specify such action on the
> individual rule (like done with the gate), then you can not have two
> rules pointing at the same policer instance.
>
> Long storry short, have you considered if it would be better to do
> something like:
>
>    tc filter add dev eth0 parent ffff: protocol ip \
>             flower src_ip 192.168.0.20 \
>             action psfp-id 42
>
> And then have some other function to configure the properties of psfp-id
> 42?
>
>
> /Allan
>

It is very good that you brought it up though, since in my opinion too
it is a rather important aspect, and it seems that the fact this
feature is already designed-in was a bit too subtle.

"psfp-id" is actually his "index" argument.

You can actually do this:
tc filter add dev eth0 ingress \
        flower skip_hw dst_mac 01:80:c2:00:00:0e \
        action gate index 1 clockid CLOCK_TAI \
        base-time 200000000000 \
        sched-entry OPEN 200000000 -1 -1 \
        sched-entry CLOSE 100000000 -1 -1
tc filter add dev eth0 ingress \
        flower skip_hw dst_mac 01:80:c2:00:00:0f \
        action gate index 1

Then 2 filters get created with the same action:

tc -s filter show dev swp2 ingress
filter protocol all pref 49151 flower chain 0
filter protocol all pref 49151 flower chain 0 handle 0x1
  dst_mac 01:80:c2:00:00:0f
  skip_hw
  not_in_hw
        action order 1:
        priority wildcard       clockid TAI     flags 0x6404f
        base-time 200000000000                  cycle-time 300000000
         cycle-time-ext 0
         number    0    gate-state open         interval 200000000
         ipv wildcard    max-octets wildcard
         number    1    gate-state close        interval 100000000
         ipv wildcard    max-octets wildcard
        pipe
         index 2 ref 2 bind 2 installed 168 sec used 168 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

filter protocol all pref 49152 flower chain 0
filter protocol all pref 49152 flower chain 0 handle 0x1
  dst_mac 01:80:c2:00:00:0e
  skip_hw
  not_in_hw
        action order 1:
        priority wildcard       clockid TAI     flags 0x6404f
        base-time 200000000000                  cycle-time 300000000
         cycle-time-ext 0
         number    0    gate-state open         interval 200000000
         ipv wildcard    max-octets wildcard
         number    1    gate-state close        interval 100000000
         ipv wildcard    max-octets wildcard
        pipe
         index 2 ref 2 bind 2 installed 168 sec used 168 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

Actually my only concern is that maybe this mechanism should (?) have
been more generic. At the moment, this patch series implements it via
a TCA_GATE_ENTRY_INDEX netlink attribute, so every action which wants
to be shared across filters needs to reinvent this wheel.

Thoughts, everyone?

Thanks,
-Vladimir
