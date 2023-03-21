Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39456C3157
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 13:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjCUMRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 08:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCUMRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 08:17:30 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF8D303CC;
        Tue, 21 Mar 2023 05:17:29 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v25so9980122wra.12;
        Tue, 21 Mar 2023 05:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679401047;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KO2LXokOrq3c8XBmHuF7vc+LBuS8LWoa+ic4XBzrjdA=;
        b=mQCjt1LxxDtHOtUML8080wKChKB70tZkmTVqa15LHUpnyCgSoGsLvEmvJxaJ/slH+P
         vceJPsJA/Q8He6TCYvmw2rLR/Q/mNMADFxhh4CiiJjQGfLXaPcsWn9BOngWvyDvp/KsZ
         fOYvXTqvyhnzK5GGIt1liZ+HjYBPZQT7SUgnqDsejfaI6cSJ9UkhIhg+YdzWUi2Ayuo1
         HP9dyZxV1Yszt0jz77joT02oMv9/4YpsvzJ6k7AvAvrGZhgTXBFlUIhW5Ff8pCksza05
         QS3CnszwFCclRo1kcwrPG/zFusjbQcFyF7OCjLclAdFcFJ/MC3FGuEsHMq/IPEVWcNL5
         +lsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679401047;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KO2LXokOrq3c8XBmHuF7vc+LBuS8LWoa+ic4XBzrjdA=;
        b=fij3VpjpYsg4PUp5ewY3vLvdAqgpUceJlVN8CIjnYdJKg9p6fvHqQPmw32VTnLE/yk
         +X6jTNHYvZSY4yoh+WSM3bFSRAvbP5awHP6/DT08ogtEcf9NLDYm0l3/591XiTi63cSF
         uPiU9PJy6R1reh2xVZGXmReS1kunau4wBUElc+trd6xY3aJvt34AnyBGUfBHJ0I46S5d
         Ju7RDbXIre/Xj0TKZ3AlUBYUu/+sD2ZuMxoMuQQ/tIZq9StTojaUeLleLCV9x5NDvanz
         UbyZqPs9nfO2l1Ywff/3ncyohu5Y5CCDtkEz1gtkHSfxVdy5OmJx1/3VxQHcINve2mFF
         xHTA==
X-Gm-Message-State: AO0yUKVLd/yKxo0g6OJpZenMAepeJatPnhx4i+XRIGDt6vo1xwXAMI2n
        rvus0rNColopeA34NPAJZIqXXX/knWQ=
X-Google-Smtp-Source: AK7set+Z9VFDtp3Gt9UaNFIMiaOgv3tgsB2Lfkg5s9W8tVch7YSNIWIfpqY4rkyyZ9NQZ8kxaqwgPA==
X-Received: by 2002:adf:f605:0:b0:2d0:58f9:a6b with SMTP id t5-20020adff605000000b002d058f90a6bmr11792668wrp.13.1679401047576;
        Tue, 21 Mar 2023 05:17:27 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id a7-20020adff7c7000000b002c70ce264bfsm11285167wrq.76.2023.03.21.05.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 05:17:27 -0700 (PDT)
Date:   Tue, 21 Mar 2023 12:17:25 +0000
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
Message-ID: <ZBmgVcwUGql24hDm@gmail.com>
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
 <ZBLcKs+IsgJBjqeT@gmail.com>
 <CACGkMEtOV7pcMZ2=bdUr4BtE4ZTf0wZZSdTB8+OQrwHiZrHrEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEtOV7pcMZ2=bdUr4BtE4ZTf0wZZSdTB8+OQrwHiZrHrEA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 11:52:02AM +0800, Jason Wang wrote:
> On Thu, Mar 16, 2023 at 5:07 PM Martin Habets <habetsm.xilinx@gmail.com> wrote:
> >
> > On Wed, Mar 15, 2023 at 01:11:23PM +0800, Jason Wang wrote:
> > >
> > > 在 2023/3/13 19:50, Martin Habets 写道:
> > > > On Fri, Mar 10, 2023 at 01:04:14PM +0800, Jason Wang wrote:
> > > > > On Tue, Mar 7, 2023 at 7:36 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
> > > > > > A function personality defines the location and semantics of
> > > > > > registers in the BAR. EF100 NICs allow different personalities
> > > > > > of a PCIe function and changing it at run-time. A total of three
> > > > > > function personalities are defined as of now: EF100, vDPA and
> > > > > > None with EF100 being the default.
> > > > > > For now, vDPA net devices can be created on a EF100 virtual
> > > > > > function and the VF personality will be changed to vDPA in the
> > > > > > process.
> > > > > >
> > > > > > Co-developed-by: Martin Habets <habetsm.xilinx@gmail.com>
> > > > > > Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
> > > > > > Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> > > > > > ---
> > > > > >   drivers/net/ethernet/sfc/ef100.c     |  6 +-
> > > > > >   drivers/net/ethernet/sfc/ef100_nic.c | 98 +++++++++++++++++++++++++++-
> > > > > >   drivers/net/ethernet/sfc/ef100_nic.h | 11 ++++
> > > > > >   3 files changed, 111 insertions(+), 4 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
> > > > > > index 71aab3d0480f..c1c69783db7b 100644
> > > > > > --- a/drivers/net/ethernet/sfc/ef100.c
> > > > > > +++ b/drivers/net/ethernet/sfc/ef100.c
> > > > > > @@ -429,8 +429,7 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
> > > > > >          if (!efx)
> > > > > >                  return;
> > > > > >
> > > > > > -       probe_data = container_of(efx, struct efx_probe_data, efx);
> > > > > > -       ef100_remove_netdev(probe_data);
> > > > > > +       efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_NONE);
> > > > > >   #ifdef CONFIG_SFC_SRIOV
> > > > > >          efx_fini_struct_tc(efx);
> > > > > >   #endif
> > > > > > @@ -443,6 +442,7 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
> > > > > >          pci_disable_pcie_error_reporting(pci_dev);
> > > > > >
> > > > > >          pci_set_drvdata(pci_dev, NULL);
> > > > > > +       probe_data = container_of(efx, struct efx_probe_data, efx);
> > > > > >          efx_fini_struct(efx);
> > > > > >          kfree(probe_data);
> > > > > >   };
> > > > > > @@ -508,7 +508,7 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
> > > > > >                  goto fail;
> > > > > >
> > > > > >          efx->state = STATE_PROBED;
> > > > > > -       rc = ef100_probe_netdev(probe_data);
> > > > > > +       rc = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_EF100);
> > > > > >          if (rc)
> > > > > >                  goto fail;
> > > > > >
> > > > > > diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> > > > > > index 4dc643b0d2db..8cbe5e0f4bdf 100644
> > > > > > --- a/drivers/net/ethernet/sfc/ef100_nic.c
> > > > > > +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> > > > > > @@ -772,6 +772,99 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
> > > > > >          return 0;
> > > > > >   }
> > > > > >
> > > > > > +/* BAR configuration.
> > > > > > + * To change BAR configuration, tear down the current configuration (which
> > > > > > + * leaves the hardware in the PROBED state), and then initialise the new
> > > > > > + * BAR state.
> > > > > > + */
> > > > > > +struct ef100_bar_config_ops {
> > > > > > +       int (*init)(struct efx_probe_data *probe_data);
> > > > > > +       void (*fini)(struct efx_probe_data *probe_data);
> > > > > > +};
> > > > > > +
> > > > > > +static const struct ef100_bar_config_ops bar_config_ops[] = {
> > > > > > +       [EF100_BAR_CONFIG_EF100] = {
> > > > > > +               .init = ef100_probe_netdev,
> > > > > > +               .fini = ef100_remove_netdev
> > > > > > +       },
> > > > > > +#ifdef CONFIG_SFC_VDPA
> > > > > > +       [EF100_BAR_CONFIG_VDPA] = {
> > > > > > +               .init = NULL,
> > > > > > +               .fini = NULL
> > > > > > +       },
> > > > > > +#endif
> > > > > > +       [EF100_BAR_CONFIG_NONE] = {
> > > > > > +               .init = NULL,
> > > > > > +               .fini = NULL
> > > > > > +       },
> > > > > > +};
> > > > > This looks more like a mini bus implementation. I wonder if we can
> > > > > reuse an auxiliary bus here which is more user friendly for management
> > > > > tools.
> > > > When we were in the design phase of vDPA for EF100 it was still called
> > > > virtbus, and the virtbus discussion was in full swing at that time.
> > > > We could not afford to add risk to the project by depending on it, as
> > > > it might not have been merged at all.
> > >
> > >
> > > Right.
> > >
> > >
> > > > If we were doing the same design now I would definitely consider using
> > > > the auxiliary bus.
> > > >
> > > > Martin
> > >
> > >
> > > But it's not late to do the change now. Auxiliary bus has been used by a lot
> > > of devices (even with vDPA device). The change looks not too complicated.
> >
> > I'm surprised you think this would not be complicated. From my view it would
> > require redesign, redevelopment and retest of vdpa which would take months. That is
> > assuming we can get some of the resources back.
> 
> I think I'm fine if we agree to do it sometime in the future.

We have projects on the roadmap that will need to use auxbus for this.
The timeline for that is not clear to me at the moment.

> >
> > > This looks more scalable and convenient for management layer.
> >
> > There is not much difference for the management layer, it uses the vdpa tool now
> > and it would do so with the auxiliary bus.
> 
> At the vDPA level it doesn't make too much difference.
> 
> > The difference is that with the
> > auxiliary bus users would have to load another module for sfc vDPA support.
> 
> The policy is fully under the control of the management instead of the
> hard-coding policy now, more below.
> 
> > Are we maybe on 2 different trains of thought here?
> 
> If I read the code correct, when VF is probed:
> 
> 1) vDPA mgmtdev is registered
> 2) netdev is probed, bar config set to netdev
> 
> This means when user want to create vDPA device
> 
> 1) unregister netdev
> 2) vDPA is probed, bar config set to vDPA
> 
> And when vDPA device is deleted:
> 
> 1) unregister vDPA
> 2) netdev is probed, bat config set to netdev

Your analysis is correct. We have a requirement to initially create a
netdev for new VFs. This was done to maintain backward compatibility with
earlier Solarflare NICs.
For new products I can try to change this default behaviour. I definitely
see a trend towards a core "PCI" layer and different layers on top of that.
The auxiliary bus will have a significant role to play here.

> There would be a lot of side effects for the mandated policy of
> registering/unregistering netdevs like udev events etc when adding and
> removing vDPA devices.

I agree. During our testing we cam across versions of systemd that will
cause a spike in the load when creating many netdevs.

Martin

> 
> Thanks
> 
> >
> > Martin
> >
