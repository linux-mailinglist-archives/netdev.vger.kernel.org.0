Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E3B6B8D9A
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 09:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjCNIje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjCNIjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:39:32 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4276A7D;
        Tue, 14 Mar 2023 01:38:55 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id j3so9652282wms.2;
        Tue, 14 Mar 2023 01:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678783134;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J0gH9t60X5H+d+EPOhmJUOPNnjwzScS+RZ+V8TYNQU0=;
        b=o1lBuo0KGPJpjfNW637YLmkxlz4TUehV8/bqN5UYQSwgHVq3DOZ6Xd4JIoqJ4cmRed
         IX9rGQl/fRc9mjgikQAYm8xx7fzJpXQQvEF0s2XWsDGRtd6jPC44/6b2xuHqp8X2VtAY
         vJQy0f/Eto8OWsTg6VdpwobLkZ/uds0o9bw3I25ZVIaQE6b1DhLZNtflNQnPy71GwfsZ
         R4j7uJ15yDyM9mO0nk8WjDVsP8Bj5XSVgc9GsQt9PrpaBDSyYIS5SsDRepHhdZ8ktQBN
         c58I84aWcThBkTT6IMbAtDqevCp1B0ujkNvyZxgfKNQ7nC835J+6L9gLOAllHYZ4GND9
         /8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678783134;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J0gH9t60X5H+d+EPOhmJUOPNnjwzScS+RZ+V8TYNQU0=;
        b=5f8kcwIfW0rH0EFTJFYfkEd2URY0oXW+xzoL2IRb3X05vPYrFqmzdhVyEP40vTMFI2
         h8fv1ou+8bF44U3owZslY4VVDEi3KC3KNDcVTATVh9AX7tVBmHRUrSclQS1upKnyBO94
         2v8RA35wDixDk3vrIrg80ntfPZeVEHMzeE3+lGTfN1zM3cPAMg6oTGnAI8EL2GGw0Pt2
         gEE4n+6EHCJd/r5B8gQ+w46rr6ik9ZjeyARtGUAElAk0gGqBBwodWEJ+goVGjnFwKQ7K
         LNQ3dkeJqK9mhgDHwo9vDrlruHS7yanwlK6ZPwxMN+dTro0lFT3rVtUp4xbIs7cC8Mfd
         CF2g==
X-Gm-Message-State: AO0yUKVTZx5HIRMFG1U3MUVX43APBncJGkGCIsXlzIi4CSCdnez5jB6c
        0+Tj3uS0ieZfObW2l1+w/vc=
X-Google-Smtp-Source: AK7set+hJzpG+Onzuuam/M4AYM7vgALN6qEK5a1zaGXVEsPsMmE3Q5Wr71PW7qdz2oI6lR1CsUf7wQ==
X-Received: by 2002:a05:600c:3ac8:b0:3ea:edd7:1f24 with SMTP id d8-20020a05600c3ac800b003eaedd71f24mr13234962wms.39.1678783134066;
        Tue, 14 Mar 2023 01:38:54 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id p18-20020adfe612000000b002c3f9404c45sm1496173wrm.7.2023.03.14.01.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 01:38:53 -0700 (PDT)
Date:   Tue, 14 Mar 2023 08:38:51 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Gautam Dawar <gdawar@amd.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@amd.com>, linux-net-drivers@amd.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Subject: Re: [PATCH net-next v2 04/14] sfc: evaluate vdpa support based on FW
 capability CLIENT_CMD_VF_PROXY
Message-ID: <ZBAym05znKuFjJ3G@gmail.com>
Mail-Followup-To: Gautam Dawar <gdawar@amd.com>,
        Jason Wang <jasowang@redhat.com>,
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
 <20230307113621.64153-5-gautam.dawar@amd.com>
 <CACGkMEvUhC3HfizpiM8zxMa2RwgkR=yLm-GDpY120_32aBmWFw@mail.gmail.com>
 <85ad74df-147b-8d27-dd39-cc9d828ada4b@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <85ad74df-147b-8d27-dd39-cc9d828ada4b@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 06:09:19PM +0530, Gautam Dawar wrote:
> 
> On 3/10/23 10:34, Jason Wang wrote:
> > Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> > 
> > 
> > On Tue, Mar 7, 2023 at 7:37 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
> > > Add and update vdpa_supported field to struct efx_nic to true if
> > > running Firmware supports CLIENT_CMD_VF_PROXY capability. This is
> > > required to ensure DMA isolation between MCDI command buffer and guest
> > > buffers.
> > > 
> > > Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> > > ---
> > >   drivers/net/ethernet/sfc/ef100_netdev.c | 26 +++++++++++++++---
> > >   drivers/net/ethernet/sfc/ef100_nic.c    | 35 +++++++++----------------
> > >   drivers/net/ethernet/sfc/ef100_nic.h    |  6 +++--
> > >   drivers/net/ethernet/sfc/ef100_vdpa.h   |  5 ++--
> > >   4 files changed, 41 insertions(+), 31 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
> > > index d916877b5a9a..5d93e870d9b7 100644
> > > --- a/drivers/net/ethernet/sfc/ef100_netdev.c
> > > +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
> > > @@ -355,6 +355,28 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
> > >          efx->state = STATE_PROBED;
> > >   }
> > > 
> > > +static void efx_ef100_update_tso_features(struct efx_nic *efx)
> > > +{
> > > +       struct ef100_nic_data *nic_data = efx->nic_data;
> > > +       struct net_device *net_dev = efx->net_dev;
> > > +       netdev_features_t tso;
> > > +
> > > +       if (!efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3))
> > > +               return;
> > > +
> > > +       tso = NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_PARTIAL |
> > > +             NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
> > > +             NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM;
> > > +
> > > +       net_dev->features |= tso;
> > > +       net_dev->hw_features |= tso;
> > > +       net_dev->hw_enc_features |= tso;
> > > +       /* EF100 HW can only offload outer checksums if they are UDP,
> > > +        * so for GRE_CSUM we have to use GSO_PARTIAL.
> > > +        */
> > > +       net_dev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
> > > +}
> > I don't see a direct relationship between vDPA and the TSO capability.
> > Is this an independent fix?
> This isn't actually fixing any issue. This a minor code refactoring that
> wraps-up updating of the TSO capabilities in a separate function for better
> readability.

There definity was an issue here: the vDPA code now needs access to the NIC
capabilities. For this is should use the efx_ef100_init_datapath_caps below,
but that was also doing this netdev specific stuff.
The solution is to split up efx_ef100_init_datapath_caps into a generic API
that vDPA can use, and this netdev specific API which should not be used by vDPA.

Gautam, you could explain this API split in the description.

Martin

> > 
> > > +
> > >   int ef100_probe_netdev(struct efx_probe_data *probe_data)
> > >   {
> > >          struct efx_nic *efx = &probe_data->efx;
> > > @@ -387,9 +409,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
> > >                                 ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS_DEFAULT);
> > >          efx->mdio.dev = net_dev;
> > > 
> > > -       rc = efx_ef100_init_datapath_caps(efx);
> > > -       if (rc < 0)
> > > -               goto fail;
> > > +       efx_ef100_update_tso_features(efx);
> > > 
> > >          rc = ef100_phy_probe(efx);
> > >          if (rc)
> > > diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> > > index 8cbe5e0f4bdf..ef6e295efcf7 100644
> > > --- a/drivers/net/ethernet/sfc/ef100_nic.c
> > > +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> > > @@ -161,7 +161,7 @@ int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
> > >          return 0;
> > >   }
> > > 
> > > -int efx_ef100_init_datapath_caps(struct efx_nic *efx)
> > > +static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
> > >   {
> > >          MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CAPABILITIES_V7_OUT_LEN);
> > >          struct ef100_nic_data *nic_data = efx->nic_data;
> > > @@ -197,25 +197,15 @@ int efx_ef100_init_datapath_caps(struct efx_nic *efx)
> > >          if (rc)
> > >                  return rc;
> > > 
> > > -       if (efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3)) {
> > > -               struct net_device *net_dev = efx->net_dev;
> > > -               netdev_features_t tso = NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_PARTIAL |
> > > -                                       NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
> > > -                                       NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM;
> > > -
> > > -               net_dev->features |= tso;
> > > -               net_dev->hw_features |= tso;
> > > -               net_dev->hw_enc_features |= tso;
> > > -               /* EF100 HW can only offload outer checksums if they are UDP,
> > > -                * so for GRE_CSUM we have to use GSO_PARTIAL.
> > > -                */
> > > -               net_dev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
> > > -       }
> > >          efx->num_mac_stats = MCDI_WORD(outbuf,
> > >                                         GET_CAPABILITIES_V4_OUT_MAC_STATS_NUM_STATS);
> > >          netif_dbg(efx, probe, efx->net_dev,
> > >                    "firmware reports num_mac_stats = %u\n",
> > >                    efx->num_mac_stats);
> > > +
> > > +       nic_data->vdpa_supported = efx_ef100_has_cap(nic_data->datapath_caps3,
> > > +                                                    CLIENT_CMD_VF_PROXY) &&
> > > +                                  efx->type->is_vf;
> > >          return 0;
> > >   }
> > > 
> > > @@ -806,13 +796,6 @@ static char *bar_config_name[] = {
> > >          [EF100_BAR_CONFIG_VDPA] = "vDPA",
> > >   };
> > > 
> > > -#ifdef CONFIG_SFC_VDPA
> > > -static bool efx_vdpa_supported(struct efx_nic *efx)
> > > -{
> > > -       return efx->type->is_vf;
> > > -}
> > > -#endif
> > > -
> > >   int efx_ef100_set_bar_config(struct efx_nic *efx,
> > >                               enum ef100_bar_config new_config)
> > >   {
> > > @@ -828,7 +811,7 @@ int efx_ef100_set_bar_config(struct efx_nic *efx,
> > > 
> > >   #ifdef CONFIG_SFC_VDPA
> > >          /* Current EF100 hardware supports vDPA on VFs only */
> > > -       if (new_config == EF100_BAR_CONFIG_VDPA && !efx_vdpa_supported(efx)) {
> > > +       if (new_config == EF100_BAR_CONFIG_VDPA && !nic_data->vdpa_supported) {
> > >                  pci_err(efx->pci_dev, "vdpa over PF not supported : %s",
> > >                          efx->name);
> > >                  return -EOPNOTSUPP;
> > > @@ -1208,6 +1191,12 @@ static int ef100_probe_main(struct efx_nic *efx)
> > >                  goto fail;
> > >          }
> > > 
> > > +       rc = efx_ef100_init_datapath_caps(efx);
> > > +       if (rc) {
> > > +               pci_info(efx->pci_dev, "Unable to initialize datapath caps\n");
> > > +               goto fail;
> > > +       }
> > > +
> > >          return 0;
> > >   fail:
> > >          return rc;
> > > diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
> > > index 4562982f2965..117a73d0795c 100644
> > > --- a/drivers/net/ethernet/sfc/ef100_nic.h
> > > +++ b/drivers/net/ethernet/sfc/ef100_nic.h
> > > @@ -76,6 +76,9 @@ struct ef100_nic_data {
> > >          u32 datapath_caps3;
> > >          unsigned int pf_index;
> > >          u16 warm_boot_count;
> > > +#ifdef CONFIG_SFC_VDPA
> > > +       bool vdpa_supported; /* true if vdpa is supported on this PCIe FN */
> > > +#endif
> > >          u8 port_id[ETH_ALEN];
> > >          DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
> > >          enum ef100_bar_config bar_config;
> > > @@ -95,9 +98,8 @@ struct ef100_nic_data {
> > >   };
> > > 
> > >   #define efx_ef100_has_cap(caps, flag) \
> > > -       (!!((caps) & BIT_ULL(MC_CMD_GET_CAPABILITIES_V4_OUT_ ## flag ## _LBN)))
> > > +       (!!((caps) & BIT_ULL(MC_CMD_GET_CAPABILITIES_V7_OUT_ ## flag ## _LBN)))
> > > 
> > > -int efx_ef100_init_datapath_caps(struct efx_nic *efx);
> > >   int ef100_phy_probe(struct efx_nic *efx);
> > >   int ef100_filter_table_probe(struct efx_nic *efx);
> > > 
> > > diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
> > > index f6564448d0c7..90062fd8a25d 100644
> > > --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
> > > +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
> > > @@ -1,7 +1,6 @@
> > >   /* SPDX-License-Identifier: GPL-2.0 */
> > > -/* Driver for Xilinx network controllers and boards
> > > - * Copyright (C) 2020-2022, Xilinx, Inc.
> > > - * Copyright (C) 2022, Advanced Micro Devices, Inc.
> > > +/* Driver for AMD network controllers and boards
> > > + * Copyright (C) 2023, Advanced Micro Devices, Inc.
> > Let's fix this in the patch that introduces this.
> 
> Sure, will fix.
> 
> Thanks
> 
> > 
> > Thanks
> > 
> > 
> > 
> > >    *
> > >    * This program is free software; you can redistribute it and/or modify it
> > >    * under the terms of the GNU General Public License version 2 as published
> > > --
> > > 2.30.1
> > > 
