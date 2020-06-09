Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E341F2B5E
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732141AbgFIAPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:15:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45868 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731822AbgFIAOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 20:14:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591661681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HD882eS9OH3S3VV1WViNWe8Js+sPqHEy08aEq1E9ORs=;
        b=e292e6VDfxpnOcKfNWo/X1TNPIIPwQAWNTcVckfrJVIss4/zqOX1L+NTIVxTAgotCHIbJv
        rrOoHagX7Q4hHFJo56yHhY2B/Up9MpKd/Hq8Kyh7lsHWmcHQniJ+sP9LONXeWFuMZWzWty
        wjc3pcfuMqj+xG4zT/MKsh//RlUzj78=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-UE0fzoAGN6C7KdkhVIsUEA-1; Mon, 08 Jun 2020 20:14:39 -0400
X-MC-Unique: UE0fzoAGN6C7KdkhVIsUEA-1
Received: by mail-io1-f72.google.com with SMTP id c5so11966535ioh.2
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 17:14:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HD882eS9OH3S3VV1WViNWe8Js+sPqHEy08aEq1E9ORs=;
        b=tWiK1qxQnga0+uIBDQPRV+gvIyY2/AmRr3/E6dte5UMJBuo196pktgiQxm7EwTCW6d
         rI0WwJIa5a2hNfCrUW/RskmF0Bxa/74ic/SggpvFThZ/S8ljNnKH/XiHvZFMba79wjAC
         50UIvcM2lP3nrlpZm3TWfd2lPPZqBoxDMysK/Zqn3IrpRhj6Zd45bYRDI1otkhX2QRHk
         4b4dM97T9w3UxqP5N5M2OIc5jUjrJzjM2MjUxXfs6VzN0RnhNRFdy7yyoPTzws+btIS8
         +3FdawNrunPvo9TrAALZpPb7d9x1NB8FYEwyfrvf0FYwxKdD6blaa1qQB0z2Rdu9uWLE
         sRjg==
X-Gm-Message-State: AOAM531YOvjWAuf3vcmLZZ1dXxa23ZeR+LoESAn/ncjUY4GMpLP5lfll
        HaJcT24uMb0ZHG/NOYmbgVzVV18CKwNWdTsA+gI6D/Hi2+SuTNeWbY350a4sNWWt69yKYyRk/D+
        Q3AhcrtZ72qBOUSBj/jAp1X4kzGsMoqlL
X-Received: by 2002:a92:4899:: with SMTP id j25mr25560327ilg.168.1591661679100;
        Mon, 08 Jun 2020 17:14:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzELESE+K/wYsirvszqaNXPPRRvDprGl6QEl149kIe4qX3GOTtJp+ATld3JvWRLCQNPe8wmFXSgJgJDrnUrPSE=
X-Received: by 2002:a92:4899:: with SMTP id j25mr25560307ilg.168.1591661678726;
 Mon, 08 Jun 2020 17:14:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200608210058.37352-1-jarod@redhat.com> <20200608210058.37352-4-jarod@redhat.com>
 <20717.1591660112@famine>
In-Reply-To: <20717.1591660112@famine>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Mon, 8 Jun 2020 20:14:28 -0400
Message-ID: <CAKfmpSfkgC20w3Bp1PCfNJaADU7Hhkk5u9+2cMH+6--b_9cn4Q@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] bonding: support hardware encryption offload
 to slaves
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 8, 2020 at 7:48 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> Jarod Wilson <jarod@redhat.com> wrote:
>
> >Currently, this support is limited to active-backup mode, as I'm not sure
> >about the feasilibity of mapping an xfrm_state's offload handle to
> >multiple hardware devices simultaneously, and we rely on being able to
> >pass some hints to both the xfrm and NIC driver about whether or not
> >they're operating on a slave device.
> >
> >I've tested this atop an Intel x520 device (ixgbe) using libreswan in
> >transport mode, succesfully achieving ~4.3Gbps throughput with netperf
> >(more or less identical to throughput on a bare NIC in this system),
> >as well as successful failover and recovery mid-netperf.
> >
> >v2: rebase on latest net-next and wrap with #ifdef CONFIG_XFRM_OFFLOAD
> >v3: add new CONFIG_BOND_XFRM_OFFLOAD option and fix shutdown path
> >
> >CC: Jay Vosburgh <j.vosburgh@gmail.com>
> >CC: Veaceslav Falico <vfalico@gmail.com>
> >CC: Andy Gospodarek <andy@greyhouse.net>
> >CC: "David S. Miller" <davem@davemloft.net>
> >CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> >CC: Jakub Kicinski <kuba@kernel.org>
> >CC: Steffen Klassert <steffen.klassert@secunet.com>
> >CC: Herbert Xu <herbert@gondor.apana.org.au>
> >CC: netdev@vger.kernel.org
> >CC: intel-wired-lan@lists.osuosl.org
> >Signed-off-by: Jarod Wilson <jarod@redhat.com>
> >
> >Signed-off-by: Jarod Wilson <jarod@redhat.com>
> >---
> > drivers/net/Kconfig             |  11 ++++
> > drivers/net/bonding/bond_main.c | 111 +++++++++++++++++++++++++++++++-
> > include/net/bonding.h           |   3 +
> > 3 files changed, 122 insertions(+), 3 deletions(-)
> >
> >diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> >index c7d310ef1c83..938c4dd9bfb9 100644
> >--- a/drivers/net/Kconfig
> >+++ b/drivers/net/Kconfig
> >@@ -56,6 +56,17 @@ config BONDING
> >         To compile this driver as a module, choose M here: the module
> >         will be called bonding.
> >
> >+config BONDING_XFRM_OFFLOAD
> >+      bool "Bonding driver IPSec XFRM cryptography-offload pass-through support"
> >+      depends on BONDING
> >+      depends on XFRM_OFFLOAD
> >+      default y
> >+      select XFRM_ALGO
> >+      ---help---
> >+        Enable support for IPSec offload pass-through in the bonding driver.
> >+        Currently limited to active-backup mode only, and requires slave
> >+        devices that support hardware crypto offload.
> >+
>
>         Why is this a separate Kconfig option?  Is it reasonable to
> expect users to enable XFRM_OFFLOAD but not BONDING_XFRM_OFFLOAD?

I'd originally just wrapped it with XFRM_OFFLOAD, but in an
overabundance of caution, thought maybe gating it behind its own flag
was better. I didn't get any feedback on the initial posting, so I've
been sort of winging it. :)

> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> >index a25c65d4af71..01b80cef492a 100644
> >--- a/drivers/net/bonding/bond_main.c
> >+++ b/drivers/net/bonding/bond_main.c
...
> >@@ -4560,6 +4663,8 @@ void bond_setup(struct net_device *bond_dev)
> >                               NETIF_F_HW_VLAN_CTAG_FILTER;
> >
> >       bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
> >+      if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP))
> >+              bond_dev->hw_features |= BOND_ENC_FEATURES;
>
>         Why is adding the ESP features to hw_features (here, and added
> to BOND_ENC_FEATURES, above) not behind CONFIG_BONDING_XFRM_OFFLOAD?
>
>         If adding these features makes sense regardless of the
> XFRM_OFFLOAD configuration, then shouldn't this change to feature
> handling be a separate patch?  The feature handling is complex, and is
> worth its own patch so it stands out in the log.

No, that would be an oversight by me. The build bot yelled at me on v1
about builds with XFRM_OFFLOAD not enabled, and I neglected to wrap
that bit too.

I'll do that in the next revision. I'm also fine with dropping the
extra kconfig and just using XFRM_OFFLOAD for all of it, if that's
sufficient.

-- 
Jarod Wilson
jarod@redhat.com

