Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E57E6BCA57
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjCPJHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCPJHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:07:06 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F572470E;
        Thu, 16 Mar 2023 02:06:54 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id l1so795470wry.12;
        Thu, 16 Mar 2023 02:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678957612;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4WHcZNRiCX3AtKFoDdmE6eIWpwePjmyS80ddQuXHYjs=;
        b=Bo4PAaL7W/6BVyFx23vNNyzS8zzY3yIwy6iFpEuSwpwyn0ZAISFoGaNxADLVBsBxQi
         nEW8oz9O55P7wq8WxnV94lp225UOHio8ozl6TNPXDHMOjcYNM/4my/TWzqK5oC6vxO+S
         vKT/WF+niaod2GnR+39K7ENzDtbxeCoFLqoxJvbJel+gz/HENr9NKnG2EAMmFHxE5PUy
         nZRi7G9hId5MB4KS7ynP6ftkt+y8bagcPUhLy0bJLnXAcJTx5mgUEpa6Tlfio7WpTXok
         a2Sqf1NKT1eK2UotHCH41AUlVjuuWh3PW62uIAP+Mv9ezw0VImG+uv6rFD7zmLRbphAK
         6mjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678957612;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4WHcZNRiCX3AtKFoDdmE6eIWpwePjmyS80ddQuXHYjs=;
        b=Z2QGOngWa9u7u/ayzThaHKzP1OcSN5Mn8c2g9m5abePYyTF+NJS01Y6k/tdMJQIC3m
         QAbARgRNqEHejujkyqHltDzW/V17nUZLepsjC9UUBiM6SLahSxP+VD4TsMipqiuVy6KA
         w6RxKPV7Ui40Gip7HJGnNWnJCy6w0+uGp5m/iCupAC+Lu4uAN7TzhUc6SeedRtFYMgWA
         Web1Q/tqRa/ec9Mrp2cYdV5T2ht6DzRTfynIS9cItBLdQq1yWckAm2zFzgzei81WvbUP
         QqSXLJYoRdPJ77Hx+ftHPtdixztTQsqP0GE+BqXgcNnJTogmp1BcDCO4cbvr7RPOQJcH
         r6Fg==
X-Gm-Message-State: AO0yUKWpXJzU+uVCkcAmvVOwoTJXlYrPvAgzi8lQ/XOCb2hvy7OlnjKH
        TfFV3yS0/WKGtF/Jg+yGB60=
X-Google-Smtp-Source: AK7set+ylPHTdcUVYHob29j9/tVt8mNpuALzVehfWS6qMfe5Y1TvNPF10sUbf/RnZhu8+EiyYu1hOg==
X-Received: by 2002:adf:dc8c:0:b0:2ce:a7df:c115 with SMTP id r12-20020adfdc8c000000b002cea7dfc115mr4769494wrj.41.1678957612544;
        Thu, 16 Mar 2023 02:06:52 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id b6-20020a5d4d86000000b002c5706f7c6dsm6674947wru.94.2023.03.16.02.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 02:06:52 -0700 (PDT)
Date:   Thu, 16 Mar 2023 09:06:50 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Gautam Dawar <gautam.dawar@amd.com>, linux-net-drivers@amd.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Subject: Re: [PATCH net-next v2 01/14] sfc: add function personality support
 for EF100 devices
Message-ID: <ZBLcKs+IsgJBjqeT@gmail.com>
Mail-Followup-To: Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@amd.com>, linux-net-drivers@amd.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
References: <20230307113621.64153-1-gautam.dawar@amd.com>
 <20230307113621.64153-2-gautam.dawar@amd.com>
 <CACGkMEubKv-CGgTdTbt=Ja=pbazXT3nOGY9f_VtRwrOsmf8-rw@mail.gmail.com>
 <ZA8OBEDECFI4grXG@gmail.com>
 <071329fe-7215-235c-06b7-f17bf69d872b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <071329fe-7215-235c-06b7-f17bf69d872b@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 01:11:23PM +0800, Jason Wang wrote:
> 
> 在 2023/3/13 19:50, Martin Habets 写道:
> > On Fri, Mar 10, 2023 at 01:04:14PM +0800, Jason Wang wrote:
> > > On Tue, Mar 7, 2023 at 7:36 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
> > > > A function personality defines the location and semantics of
> > > > registers in the BAR. EF100 NICs allow different personalities
> > > > of a PCIe function and changing it at run-time. A total of three
> > > > function personalities are defined as of now: EF100, vDPA and
> > > > None with EF100 being the default.
> > > > For now, vDPA net devices can be created on a EF100 virtual
> > > > function and the VF personality will be changed to vDPA in the
> > > > process.
> > > > 
> > > > Co-developed-by: Martin Habets <habetsm.xilinx@gmail.com>
> > > > Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
> > > > Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> > > > ---
> > > >   drivers/net/ethernet/sfc/ef100.c     |  6 +-
> > > >   drivers/net/ethernet/sfc/ef100_nic.c | 98 +++++++++++++++++++++++++++-
> > > >   drivers/net/ethernet/sfc/ef100_nic.h | 11 ++++
> > > >   3 files changed, 111 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
> > > > index 71aab3d0480f..c1c69783db7b 100644
> > > > --- a/drivers/net/ethernet/sfc/ef100.c
> > > > +++ b/drivers/net/ethernet/sfc/ef100.c
> > > > @@ -429,8 +429,7 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
> > > >          if (!efx)
> > > >                  return;
> > > > 
> > > > -       probe_data = container_of(efx, struct efx_probe_data, efx);
> > > > -       ef100_remove_netdev(probe_data);
> > > > +       efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_NONE);
> > > >   #ifdef CONFIG_SFC_SRIOV
> > > >          efx_fini_struct_tc(efx);
> > > >   #endif
> > > > @@ -443,6 +442,7 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
> > > >          pci_disable_pcie_error_reporting(pci_dev);
> > > > 
> > > >          pci_set_drvdata(pci_dev, NULL);
> > > > +       probe_data = container_of(efx, struct efx_probe_data, efx);
> > > >          efx_fini_struct(efx);
> > > >          kfree(probe_data);
> > > >   };
> > > > @@ -508,7 +508,7 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
> > > >                  goto fail;
> > > > 
> > > >          efx->state = STATE_PROBED;
> > > > -       rc = ef100_probe_netdev(probe_data);
> > > > +       rc = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_EF100);
> > > >          if (rc)
> > > >                  goto fail;
> > > > 
> > > > diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> > > > index 4dc643b0d2db..8cbe5e0f4bdf 100644
> > > > --- a/drivers/net/ethernet/sfc/ef100_nic.c
> > > > +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> > > > @@ -772,6 +772,99 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
> > > >          return 0;
> > > >   }
> > > > 
> > > > +/* BAR configuration.
> > > > + * To change BAR configuration, tear down the current configuration (which
> > > > + * leaves the hardware in the PROBED state), and then initialise the new
> > > > + * BAR state.
> > > > + */
> > > > +struct ef100_bar_config_ops {
> > > > +       int (*init)(struct efx_probe_data *probe_data);
> > > > +       void (*fini)(struct efx_probe_data *probe_data);
> > > > +};
> > > > +
> > > > +static const struct ef100_bar_config_ops bar_config_ops[] = {
> > > > +       [EF100_BAR_CONFIG_EF100] = {
> > > > +               .init = ef100_probe_netdev,
> > > > +               .fini = ef100_remove_netdev
> > > > +       },
> > > > +#ifdef CONFIG_SFC_VDPA
> > > > +       [EF100_BAR_CONFIG_VDPA] = {
> > > > +               .init = NULL,
> > > > +               .fini = NULL
> > > > +       },
> > > > +#endif
> > > > +       [EF100_BAR_CONFIG_NONE] = {
> > > > +               .init = NULL,
> > > > +               .fini = NULL
> > > > +       },
> > > > +};
> > > This looks more like a mini bus implementation. I wonder if we can
> > > reuse an auxiliary bus here which is more user friendly for management
> > > tools.
> > When we were in the design phase of vDPA for EF100 it was still called
> > virtbus, and the virtbus discussion was in full swing at that time.
> > We could not afford to add risk to the project by depending on it, as
> > it might not have been merged at all.
> 
> 
> Right.
> 
> 
> > If we were doing the same design now I would definitely consider using
> > the auxiliary bus.
> > 
> > Martin
> 
> 
> But it's not late to do the change now. Auxiliary bus has been used by a lot
> of devices (even with vDPA device). The change looks not too complicated.

I'm surprised you think this would not be complicated. From my view it would
require redesign, redevelopment and retest of vdpa which would take months. That is
assuming we can get some of the resources back.

> This looks more scalable and convenient for management layer.

There is not much difference for the management layer, it uses the vdpa tool now
and it would do so with the auxiliary bus. The difference is that with the
auxiliary bus users would have to load another module for sfc vDPA support.
Are we maybe on 2 different trains of thought here?

Martin
