Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C5F219428
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 01:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgGHXOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 19:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgGHXOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 19:14:48 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224D4C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 16:14:48 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y2so387241ioy.3
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 16:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bawm1qdRqZMifHT0oDE9TS4ZfVsKk3gISLw9AOHjoVY=;
        b=C9VDJByuvezG8WEb2jHCBsn6jUIZ0sTgdZrExm3xy+GwJa3u3rKqliJHmm4MlNgOpM
         /BBRMG+m4mJiNCxoBU8lI926JpP8ZF8Lt34/tcvhS+EH9qXyevGltCiT8ioSBRGREGpJ
         mV5Rl8U0C6QsvKbrBe4nMOixUvU2B99mhbblaGp4kMUC9Jv8RDGi2Lb5hk3PpmiXAwLC
         a2TLWLG7Oy6oiXVyq6BAddITpAi9QpCvSMvGy3sejQr7GHpsymCF+RsuaJW+BmtYar3u
         4lTIFL/65+KMsXVoRwrXKuKbtqvWqubDVdYcsVw8Ki63UQFFlTjWAbOVQ0X2FuLeGZee
         cW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bawm1qdRqZMifHT0oDE9TS4ZfVsKk3gISLw9AOHjoVY=;
        b=Chzpiwlz3vQ7/g/7e1EGN0O8Y/VJQmRMGeSZOjX0Fa/FlvxltvDkaM5PBm6DPC+DlE
         Qsb6i7Oi64fNAss1JI80CE+VmLIDWIJy4p/GG84pzf6PZ4qOLOXNWaEmZoRBuoEamqQU
         Tkj99p4jxvDCj2H5CKE41oSD4pfGRmLT5GEr5R3ANuYMqd/lRDGUyniDHOBXQ3e+HRy4
         XXkWCuAofGyWJPdNRx/X2jeLauqi9nR8TjBnp1lrGcuB6vP4ZxmeJRLqgxR3yvlZUIR3
         d5+2cRm1/avnqkQ3xHRuh2f7TOnVfgzzP/ugeWaVQOa4aJ7dR1hfGT3v+1dSJkMWRfVa
         Ocvg==
X-Gm-Message-State: AOAM530HshQGVuj7a4PiGpZ3eTVNCfQpltU+3+i5i1iUW2ikeyZ54BTd
        Vb5P4klyyQw90oQzLvlGGHKLDSyuckqLk9Mv9Ns=
X-Google-Smtp-Source: ABdhPJw+70yPL7vX38nAF1HneBymTXarBxEW+LLdGNu0XUZEcubt1jXH1aGJpD+dDhCSX1w3PTcpoPSq6ShD1sNx2Cs=
X-Received: by 2002:a05:6638:cc7:: with SMTP id e7mr67702646jak.87.1594250087268;
 Wed, 08 Jul 2020 16:14:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200707212434.3244001-1-kuba@kernel.org> <20200707212434.3244001-8-kuba@kernel.org>
 <CAKgT0Udi60-zs08eppC-5roPnpi_r4nAV53xovG8xfnovUtS4A@mail.gmail.com> <20200708142545.66057f36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200708142545.66057f36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 8 Jul 2020 16:14:36 -0700
Message-ID: <CAKgT0UcOSducbD1Lg1ADmnrGnaGvNM0Fb-098eUdnaKewuB8Ew@mail.gmail.com>
Subject: Re: [PATCH net-next 7/9] ixgbe: convert to new udp_tunnel_nic infra
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        edwin.peer@broadcom.com,
        "Tantilov, Emil S" <emil.s.tantilov@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Michal Kubecek <mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 2:25 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 8 Jul 2020 10:00:36 -0700 Alexander Duyck wrote:
> > On Tue, Jul 7, 2020 at 2:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > Make use of new common udp_tunnel_nic infra. ixgbe supports
> > > IPv4 only, and only single VxLAN and Geneve ports (one each).
> > >
> > > I'm dropping the confusing piece of code in ixgbe_set_features().
> > > ndo_udp_tunnel_add and ndo_udp_tunnel_del did not check if RXCSUM
> > > is enabled, so this code was either unnecessary or buggy anyway.
> >
> > The code is unnecessary from what I can tell. I suspect the reason for
> > adding the code was because the port values are used when performing
> > the Rx checksum offload. However we never disable it in hardware, and
> > the software path in ixgbe_rx_checksum will simply disable the related
> > code anyway since we cannot set skb->encapsulation if RXCSUM is
> > disabled.
> >
> > With that said moving this to a separate patch might be preferable as
> > it would make the patch more readable.
>
> Ack on all points!
>
> > > -static void ixgbe_clear_udp_tunnel_port(struct ixgbe_adapter *adapter, u32 mask)
> > > +static int ixgbe_udp_tunnel_sync(struct net_device *dev, unsigned int table)
> > >  {
> > > +       struct ixgbe_adapter *adapter = netdev_priv(dev);
> > >         struct ixgbe_hw *hw = &adapter->hw;
> > > -       u32 vxlanctrl;
> > > -
> > > -       if (!(adapter->flags & (IXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE |
> > > -                               IXGBE_FLAG_GENEVE_OFFLOAD_CAPABLE)))
> > > -               return;
> > > +       struct udp_tunnel_info ti;
> > >
> > > -       vxlanctrl = IXGBE_READ_REG(hw, IXGBE_VXLANCTRL) & ~mask;
> > > -       IXGBE_WRITE_REG(hw, IXGBE_VXLANCTRL, vxlanctrl);
> > > -
> > > -       if (mask & IXGBE_VXLANCTRL_VXLAN_UDPPORT_MASK)
> > > -               adapter->vxlan_port = 0;
> > > +       udp_tunnel_nic_get_port(dev, table, 0, &ti);
> > > +       if (!table)
> > > +               adapter->vxlan_port = ti.port;
> > > +       else
> > > +               adapter->geneve_port = ti.port;
> >
> > So this !table thing is a bit hard to read. It might be more useful if
> > you had a define that made it clear that the expectation is that entry
> > 0 is a VXLAN table and entry 1 is the GENEVE.
>
> How about:
>
> if (ti.type == UDP_TUNNEL_TYPE_VXLAN)
>
> Tunnel info will have the type.

That would work too.

> > >
> > > -       if (mask & IXGBE_VXLANCTRL_GENEVE_UDPPORT_MASK)
> > > -               adapter->geneve_port = 0;
> > > +       IXGBE_WRITE_REG(hw, IXGBE_VXLANCTRL,
> > > +                       ntohs(adapter->vxlan_port) |
> > > +                       ntohs(adapter->geneve_port) <<
> > > +                               IXGBE_VXLANCTRL_GENEVE_UDPPORT_SHIFT);
> > > +       return 0;
> > >  }
> >
> > I'm assuming the new logic will call this for all entries in the
> > tables regardless of if they are set or not. If so I suppose this is
> > fine.
>
> Yup, I think this is preferred form of sync for devices which just
> write registers. I wrote it for NFP initially but it seems to work
> in more places.
>
> The driver can query the entire table and will get either the port
> or 0 if port is not set.

Okay, sounds good.

> > >  #ifdef CONFIG_IXGBE_DCB
> > >  /**
> > >   * ixgbe_configure_dcb - Configure DCB hardware
> > > @@ -6227,6 +6242,7 @@ static void ixgbe_init_dcb(struct ixgbe_adapter *adapter)
> > >  /**
> > >   * ixgbe_sw_init - Initialize general software structures (struct ixgbe_adapter)
> > >   * @adapter: board private structure to initialize
> > > + * @netdev: network interface device structure
> > >   * @ii: pointer to ixgbe_info for device
> > >   *
> > >   * ixgbe_sw_init initializes the Adapter private data structure.
> > > @@ -6234,6 +6250,7 @@ static void ixgbe_init_dcb(struct ixgbe_adapter *adapter)
> > >   * OS network device settings (MTU size).
> > >   **/
> > >  static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
> > > +                        struct net_device *netdev,
> > >                          const struct ixgbe_info *ii)
> > >  {
> > >         struct ixgbe_hw *hw = &adapter->hw;
> >
> > There is no need to add the argument. It should be accessible via
> > adapter->netdev, or for that matter you could pass the netdev and drop
> > the adapter and just pull it out via netdev_priv since the two are all
> > contained in the same structure anyway. Another option would be to
> > just pull the logic out of this section and put it in a switch
> > statement of its own in the probe function.
>
> Hm, new switch section definitely looks best. I'll do that.
>
> > > @@ -6332,7 +6349,7 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
> > >                         adapter->flags2 |= IXGBE_FLAG2_TEMP_SENSOR_CAPABLE;
> > >                 break;
> > >         case ixgbe_mac_x550em_a:
> > > -               adapter->flags |= IXGBE_FLAG_GENEVE_OFFLOAD_CAPABLE;
> > > +               netdev->udp_tunnel_nic_info = &ixgbe_udp_tunnels_x550em_a;
> > >                 switch (hw->device_id) {
> > >                 case IXGBE_DEV_ID_X550EM_A_1G_T:
> > >                 case IXGBE_DEV_ID_X550EM_A_1G_T_L:
> > > @@ -6359,7 +6376,8 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
> > >  #ifdef CONFIG_IXGBE_DCA
> > >                 adapter->flags &= ~IXGBE_FLAG_DCA_CAPABLE;
> > >  #endif
> > > -               adapter->flags |= IXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE;
> > > +               if (!netdev->udp_tunnel_nic_info)
> > > +                       netdev->udp_tunnel_nic_info = &ixgbe_udp_tunnels_x550;
> > >                 break;
> > >         default:
> > >                 break;
> >
> > Not a fan of the !udp_tunnel_nic_info check, but I understand you are
> > having to do it because of the fall-through.
>
> Yup.
>
> > > @@ -6798,8 +6816,7 @@ int ixgbe_open(struct net_device *netdev)
> > >
> > >         ixgbe_up_complete(adapter);
> > >
> > > -       ixgbe_clear_udp_tunnel_port(adapter, IXGBE_VXLANCTRL_ALL_UDPPORT_MASK);
> > > -       udp_tunnel_get_rx_info(netdev);
> > > +       udp_tunnel_nic_reset_ntf(netdev);
> > >
> > >         return 0;
> >
> > So I went looking through the earlier patches for an explanation of
> > udp_tunnel_nic_reset_ntf. It might be useful to have some doxygen
> > comments with the declaration explaining what it does and when/why we
> > should use it.
>
> Looks like I hated the need for this one so much I forgot to document
> it :S
>
> I was hoping the core can issue all the callbacks just based on netdev
> notifications, but it seems like most drivers have internal resets
> procedures which require re-programming the ports :( Hence this helper
> was born.
>
> I'll document it like this:
>
>  * Called by the driver to inform the core that the entire UDP tunnel port
>  * state has been lost, usually due to device reset. Core will assume device
>  * forgot all the ports and issue .set_port and .sync_table callbacks as
>  * necessary.
>
>
> Thanks for the review! I'll post v2 in a couple hours hoping someone
> else will find time to review :S

Thanks, this does appear to do quite a bit to simplify the driver code.

- Alex
