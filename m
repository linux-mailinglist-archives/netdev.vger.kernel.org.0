Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93081D350F
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 17:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgENP11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 11:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgENP10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 11:27:26 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11417C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 08:27:26 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id s19so2680917edt.12
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 08:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IHmn/ZQsIouNuG+LNQHSRWeVN2u0gvkSDyEt1hPpsW8=;
        b=rBVmgsRFwoYiaIn9AIWuM5oXY+buQaCmOMbUmC6MxIrGacBrDHX3qSZNRZ2Kk48sTb
         jRoDUF2ADJnWZh00Dnosgc90HY8S9eJcgQi45h7SplbRpkbkboUPpR/6rI1NARqfTFIS
         Uu4xHhbB4sG22tckm/J4heA6A8stpWgga2J3iWYBBJ00jTkYGV7yfysHz6XyWcmEreQ5
         BjQUxKv+KsdDn/klwI3NRsLwBtg54KYiRIeVbY1Pdjl88THgksZbxJ5KbOEaTzGt7rk3
         HQ7YMqoCFD92OgvVRlILFQZzB4DL3W1kkxctZeLcVo/b05VdM+rH/DMroOya1FE89S0Z
         oMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IHmn/ZQsIouNuG+LNQHSRWeVN2u0gvkSDyEt1hPpsW8=;
        b=WintJ4HPIQFnv42ZTCEhspua+NU0PmYE2oin5IF96mco3oz+O707S3CWKujUTY3HHy
         efh+ACmZqPGcVv6VABV9w/7zh+uN7D6pffW6wBFz02RYsV5OAWhOR4SO33005TgUBZD6
         RaWpOGAUxqeOBii37ZX2+UZg8ZIbm2rlT4HnIT73fEGNxYYRAr1hInB5l8zkDQS1JtBc
         q46KQWOI6tgb+vHvcy4ERac1LcOZal3SDhaaqkZqRJbtLSZ02GvkIo50aVzqJYDa72WP
         lFEk+LZGJu6s1Crrw+oaxrOKJLK6QrEA7IWpANbRo6j8Hgy6sEnE6UlbSyfhiBQO1FN2
         kAUA==
X-Gm-Message-State: AOAM533+Nq1Cv+eTMvM5MBL0wHNMvN/dzN1i1NDyHfIYLymaYpIzxfhr
        dlzW8ycHX/Br8llaUPmY6FDy8I3NVgN+XRTuPgk=
X-Google-Smtp-Source: ABdhPJy0jiGzktGdZEUQFbYn7szdX8acd/jStdEqRxnP4VdxoGAKyU8AKGQ6gYFiPBfOqbjNN5LCV5SSnkKBVSuTuIg=
X-Received: by 2002:a05:6402:2d4:: with SMTP id b20mr4680973edx.118.1589470044626;
 Thu, 14 May 2020 08:27:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200511202046.20515-1-olteanv@gmail.com> <525db137-0748-7ae1-ed7f-ee2c74820436@gmail.com>
 <CA+h21hqbiMfm+h994eV=7vRghapJm7HzybauQcggLhfs7At+fg@mail.gmail.com> <5d60fb20-f0df-7c02-e8d4-1963ffaf79d5@gmail.com>
In-Reply-To: <5d60fb20-f0df-7c02-e8d4-1963ffaf79d5@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 14 May 2020 18:27:13 +0300
Message-ID: <CA+h21hrGMZTiig_u+5opg05hitR9VXjmYfzfO4W8K9e5NNY3Fw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] DSA: promisc on master, generic flow
 dissector code
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Tue, 12 May 2020 at 03:03, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/11/2020 4:52 PM, Vladimir Oltean wrote:
> > On Tue, 12 May 2020 at 02:28, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >>
> >>
> >>
> >> On 5/11/2020 1:20 PM, Vladimir Oltean wrote:
> >>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >>>
> >>> The initial purpose of this series was to implement the .flow_dissect
> >>> method for sja1105 and for ocelot/felix. But on Felix this posed a
> >>> problem, as the DSA headers were of different lengths on RX and on TX.
> >>> A better solution than to just increase the smaller one was to also try
> >>> to shrink the larger one, but in turn that required the DSA master to be
> >>> put in promiscuous mode (which sja1105 also needed, for other reasons).
> >>>
> >>> Finally, we can add the missing .flow_dissect methods to ocelot and
> >>> sja1105 (as well as generalize the formula to other taggers as well).
> >>
> >> On a separate note, do you have any systems for which it would be
> >> desirable that the DSA standalone port implemented receive filtering? On
> >> BCM7278 devices, the Ethernet MAC connected to the switch is always in
> >> promiscuous mode, and so we rely on the switch not to flood the CPU port
> >> unnecessarily with MC traffic (if nothing else), this is currently
> >> implemented in our downstream kernel, but has not made it upstream yet,
> >> previous attempt was here:
> >>
> >> https://www.spinics.net/lists/netdev/msg544361.html
> >>
> >> I would like to revisit that at some point.
> >> --
> >> Florian
> >
> > Yes, CPU filtering of traffic (not just multicast) is one of the
> > problems we're facing. I'll take a look at your patches and maybe I'll
> > pick them up.
>
> The part that modifies DSA to program the known MC addresses should
> still be largely applicable, there were essentially two problems that I
> was facing, which could be tackled separately.
>
> 1) flooding of unknown MC traffic on DSA standalone ports is not very
> intuitive if you come from NICs that did filtering before. We should
> leverage a DSA switch driver's ability to support port_egress_floods and
> support port_mdb_add and combine them to avoid flooding the CPU port.
>

Could you clarify one thing for me:
- SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED is supposed to sync/unsync all
known multicast {mac, vid} addresses to the hardware filtering table
- SWITCHDEV_ATTR_ID_BRIDGE_MROUTER is supposed to toggle flooding of
unknown multicast addresses to the CPU
- What is BR_MCAST_FLOOD from SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS
supposed to do? The same thing?

> 2) Programming of known multicast addresses for VLAN devices on top of
> DSA standalone ports while the switch implements global VLAN filtering.
> In that case when we get to the DSA slave device's ndo_set_rx_mode() we
> have lost all information about which VID the MAC address is coming from
> so we cannot insert the MAC address with the correct VID to support
> proper filtering. TI's cpsw driver implements a super complicated scheme
> to solve that problem and this was worked on by Ivan in a more generic
> and usable form: https://lwn.net/Articles/780783/

So you're thinking of pulling his vlan_dev_get_addr_vid API and
syncing {DMAC, VID} addresses to the DSA slave ports by installing mdb
rules (or fdb in case of unicast filtering) on the CPU port?

But I think the only thing that would make global VLAN filtering more
complicated than the general case is that we would have to:
- deny switch ports from being enslaved to a VLAN-unaware bridge if
there is at least one other DSA slave in this switch that has
addresses with a non-pvid VLAN in its RX filter
- deny changes to the VLAN filtering state of any bridge that spans a
switch which has at least a port with a non-pvid VLAN in its RX filter
Am I missing something?

Also, for unicast filtering, I believe you would agree to leverage
port_egress_floods(unicast=false), and have the DSA core install one
fdb entry on the CPU port per each slave netdevice MAC address. Sadly,
for that to work, we'd have to keep our own parallel reference
counting in dsa_slave_sync_unsync_fdb_addr (because the refcount in
__hw_addr_sync_dev is per slave device and not per cpu port).

Last but not least, how do you see the CPU membership of VLANs problem
being approached? Using Ivan's vlan_dev_get_addr_vid API, only let the
CPU see traffic from a particular VLAN if there is any upper 8021q net
device installed on any DSA slave? What should happen when we bridge a
DSA slave port? Let the flood gates open? If the DSA slave is bridged
only with other DSA slaves from the same switch, hopefully the answer
is no. Hopefully we can open the flood gates only when bridging with a
foreign interface.

> --
> Florian

Thanks,
-Vladimir
