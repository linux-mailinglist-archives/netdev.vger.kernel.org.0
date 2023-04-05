Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5A96D7880
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237346AbjDEJge convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Apr 2023 05:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237384AbjDEJga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:36:30 -0400
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CB01B0
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:35:58 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-lZTY_q3lNfqd9xwmIt7Hjg-1; Wed, 05 Apr 2023 05:35:03 -0400
X-MC-Unique: lZTY_q3lNfqd9xwmIt7Hjg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC6BF801206;
        Wed,  5 Apr 2023 09:35:02 +0000 (UTC)
Received: from hog (unknown [10.39.192.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 80A90440BC;
        Wed,  5 Apr 2023 09:35:01 +0000 (UTC)
Date:   Wed, 5 Apr 2023 11:35:00 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Message-ID: <ZC1AxMVXKjuB6eoE@hog>
References: <20230329122107.22658-1-ehakim@nvidia.com>
 <20230329122107.22658-2-ehakim@nvidia.com>
 <ZCROr7DhsoRyU1qP@hog>
 <20230329184201.GB831478@unreal>
 <ZCXEmUQgswOBoRqR@hog>
 <20230330185656.GZ831478@unreal>
 <ZCXx4oJfnzcAKX65@hog>
 <IA1PR12MB63531CD8C6B1844376658439AB929@IA1PR12MB6353.namprd12.prod.outlook.com>
 <ZCwd11LpAUqda0eC@hog>
 <IA1PR12MB63530C8E09827E3C3402E17EAB939@IA1PR12MB6353.namprd12.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <IA1PR12MB63530C8E09827E3C3402E17EAB939@IA1PR12MB6353.namprd12.prod.outlook.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=1.9 required=5.0 tests=RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-04-04, 14:37:58 +0000, Emeel Hakim wrote:
> 
> 
> > -----Original Message-----
> > From: Sabrina Dubroca <sd@queasysnail.net>
> > Sent: Tuesday, 4 April 2023 15:54
> > To: Emeel Hakim <ehakim@nvidia.com>
> > Cc: Leon Romanovsky <leon@kernel.org>; davem@davemloft.net;
> > kuba@kernel.org; pabeni@redhat.com; edumazet@google.com;
> > netdev@vger.kernel.org
> > Subject: Re: [PATCH net-next v2 1/4] vlan: Add MACsec offload operations for
> > VLAN interface
> > 
> > External email: Use caution opening links or attachments
> > 
> > 
> > 2023-04-03, 09:29:28 +0000, Emeel Hakim wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Sabrina Dubroca <sd@queasysnail.net>
> > > > Sent: Thursday, 30 March 2023 23:33
> > > > To: Leon Romanovsky <leon@kernel.org>
> > > > Cc: Emeel Hakim <ehakim@nvidia.com>; davem@davemloft.net;
> > > > kuba@kernel.org; pabeni@redhat.com; edumazet@google.com;
> > > > netdev@vger.kernel.org
> > > > Subject: Re: [PATCH net-next v2 1/4] vlan: Add MACsec offload
> > > > operations for VLAN interface
> > > >
> > > > External email: Use caution opening links or attachments
> > > >
> > > >
> > > > 2023-03-30, 21:56:56 +0300, Leon Romanovsky wrote:
> > > > > On Thu, Mar 30, 2023 at 07:19:21PM +0200, Sabrina Dubroca wrote:
> > > > > > 2023-03-29, 21:42:01 +0300, Leon Romanovsky wrote:
> > > > > > > On Wed, Mar 29, 2023 at 04:43:59PM +0200, Sabrina Dubroca wrote:
> > > > > > > > 2023-03-29, 15:21:04 +0300, Emeel Hakim wrote:
> > > > > > > > > Add support for MACsec offload operations for VLAN driver
> > > > > > > > > to allow offloading MACsec when VLAN's real device
> > > > > > > > > supports Macsec offload by forwarding the offload request to it.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
> > > > > > > > > ---
> > > > > > > > > V1 -> V2: - Consult vlan_features when adding
> > NETIF_F_HW_MACSEC.
> > > > > > > >
> > > > > > > > Uh? You're not actually doing that? You also dropped the
> > > > > > > > changes to vlan_dev_fix_features without explaining why.
> > > > > > >
> > > > > > > vlan_dev_fix_features() relies on real_dev->vlan_features
> > > > > > > which was set in mlx5 part of this patch.
> > > > > > >
> > > > > > >   643 static netdev_features_t vlan_dev_fix_features(struct net_device
> > *dev,
> > > > > > >   644         netdev_features_t features)
> > > > > > >   645 {
> > > > > > >   ...
> > > > > > >   649
> > > > > > >   650         lower_features = netdev_intersect_features((real_dev-
> > > > >vlan_features |
> > > > > > >   651                                                     NETIF_F_RXCSUM),
> > > > > > >   652                                                    real_dev->features);
> > > > > > >
> > > > > > > This part ensure that once real_dev->vlan_features and
> > > > > > > real_dev->features have NETIF_F_HW_MACSEC, the returned
> > > > > > > features will
> > > > include NETIF_F_HW_MACSEC too.
> > > > > >
> > > > > > Ok, thanks.
> > > > > >
> > > > > > But back to the issue of vlan_features, in vlan_dev_init: I'm
> > > > > > not convinced NETIF_F_HW_MACSEC should be added to hw_features
> > > > > > based on
> > > > > > ->features. That would result in a new vlan device that can't
> > > > > > ->offload
> > > > > > macsec at all if it was created at the wrong time (while the
> > > > > > lower device's macsec offload was temporarily disabled).
> > > > >
> > > > > Sorry, I'm new to this netdev features zoo, but if I read
> > > > > correctly Documentation/networking/netdev-features.rst, the
> > > > > ->features is the list of enabled ones:
> > > > >
> > > > >    29  2. netdev->features set contains features which are currently enabled
> > > > >    30     for a device.  This should be changed only by network core or in
> > > > >    31     error paths of ndo_set_features callback.
> > > > >
> > > > > And user will have a chance to disable it for VLAN because it was
> > > > > added to ->hw_features:
> > > > >
> > > > >    24  1. netdev->hw_features set contains features whose state may
> > possibly
> > > > >    25     be changed (enabled or disabled) for a particular device by user's
> > > > >    26     request.  This set should be initialized in ndo_init callback and not
> > > > >    27     changed later.
> > > > >
> > > > > So how can VLAN be created with NETIF_F_HW_MACSEC while real_dev
> > > > > mcasec offload is disabled?
> > > >
> > > > I'm proposing that be VLAN device be created with the capability
> > > > (->hw_features contains NETIF_F_HW_MACSEC) but disabled (->features
> > > > doesn't contain NETIF_F_HW_MACSEC). That way, if NETIF_F_HW_MACSEC
> > > > is re-enabled on the lower device, you don't need to destroy the
> > > > VLAN device to enable macsec offload on it as well. You still won't
> > > > be able to enable macsec offload on the VLAN device unless it's active on the
> > real NIC.
> > > >
> > > > I think whether the lower device currently has NETIF_F_HW_MACSEC
> > > > should only affect whether you can enable the feature on the vlan
> > > > device right now. What feature is enabled at creation time should be
> > irrelevant.
> > >
> > > Thanks for the proposal Sabrina, I'm also new to this netdev features
> > > zone so IIUC your'e proposing that we have NETIF_F_HW_MACSEC added to
> > > the dev->hw_features upon vlan_dev_init, but disabled (we don’t add it
> > > to dev->features) , and upon vlan_dev_fix_features we check if the
> > > real_device have NETIF_F_HW_MACSEC enabled (after the intersect with the
> > real_dev->vlan_features) and if so we add it to the features.
> > >
> > > So something like:
> > >
> > > static int vlan_dev_init(struct net_device *dev) { ...
> > >       dev->features |= dev->hw_features | NETIF_F_LLTX;
> > >       dev->hw_features |= NETIF_F_HW_MACSEC; ...
> > > }
> > 
> > That would be adding the NETIF_F_HW_MACSEC to all VLAN devices, whether
> > the lower device advertises this feature or not. That's wrong.
> > 
> > 
> > What I had in mind was:
> > 
> >         if (real_dev->vlan_features & NETIF_F_HW_MACSEC)
> >                 dev->hw_features |= NETIF_F_HW_MACSEC;
> > 
> > 
> > And we should enable it by default when the lower device has it enabled, which
> > would be the case with this:
> > 
> > @@ -572,6 +572,9 @@ static int vlan_dev_init(struct net_device *dev)
> >                            NETIF_F_HIGHDMA | NETIF_F_SCTP_CRC |
> >                            NETIF_F_ALL_FCOE;
> > 
> > +       if (real_dev->vlan_features & NETIF_F_HW_MACSEC)
> > +               dev->hw_features |= NETIF_F_HW_MACSEC;
> > +
> >         dev->features |= dev->hw_features | NETIF_F_LLTX;
> >         netif_inherit_tso_max(dev, real_dev);
> >         if (dev->features & NETIF_F_VLAN_FEATURES)
> > 
> > 
> > What I meant by "but disabled" in my previous email was that if the lower device
> > currently has NETIF_F_HW_MACSEC, the new vlan device should also have it
> > disabled, not that it should always be disabled on creation.
> > 
> 
> Thanks for the explanation its clear for me now, I tested it and its working for me.
> I agree with this approach.
> I can prepare a new version if we are closed on everything.
> Should I send a v3 (since previous v3 got discarded) or I send it as a v4 ?

I'd call that v4 so that nobody gets confused. It's going to be
different from the v3 you already posted. I'm going through the
patches again, I have a couple of other comments.

-- 
Sabrina

