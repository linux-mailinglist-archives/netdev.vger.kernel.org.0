Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611D46B769B
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 12:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjCMLu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 07:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjCMLuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 07:50:55 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE2F1F5D9;
        Mon, 13 Mar 2023 04:50:34 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id q16so11032529wrw.2;
        Mon, 13 Mar 2023 04:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678708231;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MQkO3bNjfDZTPsKjKjkeiWgKjnfeFXYWqiq0U8sP28c=;
        b=I6SmvYVf6/vYubevFK7R4BxTHmIQRQ0Cw+9fdI17dmeOcI32GEb8WNxmAm9xhzgapR
         q3c4bZaZPnLL4bAAQLN2UzgumYcBL2/ycu8lMf8qyrzCpf0p2HiZcoX83NqrXv8j+sGv
         8H7cOU+fNL7WaHKtywTCP+vMnS576OwAy4K2QDbAHVZw+IS1CRH6tahnAPLw7cp63yAs
         wbJETD2YXD7SLWC4C7Dc3h96lqZcxx3P5EodvF2pNnXZlAtxLC40u3yGuv06AiAqi21C
         YhpkEiyI2rTJ9QFv0FtlK+8bLFYPktr3ToLzqR2562QLPKRPdjuG1I2mfjCiyFZeJxwm
         E/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678708231;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MQkO3bNjfDZTPsKjKjkeiWgKjnfeFXYWqiq0U8sP28c=;
        b=DJN45TvN8IGAzY23h5befNITUobOHK1EnCcj/tMXs6u8GqEEIGvTCfxgjcCZNg3blR
         qpqI4Q2Q+6h8cTtua1gtQICjapoi0KNw26A7N+gEKTY9tyg3M29fYiOd0VLecRhZZ2B7
         FR1KnUQOi6v/2m5NEvFhAUyB/8gd7VQMyPwGVfvFD2UZ5i+KUV2DJ5y/yl3Dqmp6MSvq
         MOU0AdD5+yd7faT4IzwgA/SlbC3tEf/i1Ect6BTxUqrHElC6BGs3+bfVgrIk4WeX0gTe
         6eNfd2cerEBd7850LCd+Gv7JVx/+PaEL9u/L/0Y7E/jjRfrE4eC2HbP9HD+uKXoB0Anf
         mcyg==
X-Gm-Message-State: AO0yUKVLfxFerVLM5x4m/AeTRDM0LGr+QwEvCnSVSFRm2LdufUn9TeR5
        VbjxN4ZAuQEIQroygn57Cs4=
X-Google-Smtp-Source: AK7set8jDzzgQx7MxQ0HXB2uJzgj1vNydQukO9RzFwhMEuF6CSAX6uqGYca78y8qG3Xh3VzefAsLpg==
X-Received: by 2002:adf:eac7:0:b0:2c7:161e:702f with SMTP id o7-20020adfeac7000000b002c7161e702fmr22845151wrn.47.1678708230908;
        Mon, 13 Mar 2023 04:50:30 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id s11-20020a5d4ecb000000b002c70851fdd8sm7668027wrv.75.2023.03.13.04.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 04:50:30 -0700 (PDT)
Date:   Mon, 13 Mar 2023 11:50:28 +0000
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
Message-ID: <ZA8OBEDECFI4grXG@gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEubKv-CGgTdTbt=Ja=pbazXT3nOGY9f_VtRwrOsmf8-rw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 01:04:14PM +0800, Jason Wang wrote:
> On Tue, Mar 7, 2023 at 7:36 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
> >
> > A function personality defines the location and semantics of
> > registers in the BAR. EF100 NICs allow different personalities
> > of a PCIe function and changing it at run-time. A total of three
> > function personalities are defined as of now: EF100, vDPA and
> > None with EF100 being the default.
> > For now, vDPA net devices can be created on a EF100 virtual
> > function and the VF personality will be changed to vDPA in the
> > process.
> >
> > Co-developed-by: Martin Habets <habetsm.xilinx@gmail.com>
> > Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
> > Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> > ---
> >  drivers/net/ethernet/sfc/ef100.c     |  6 +-
> >  drivers/net/ethernet/sfc/ef100_nic.c | 98 +++++++++++++++++++++++++++-
> >  drivers/net/ethernet/sfc/ef100_nic.h | 11 ++++
> >  3 files changed, 111 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
> > index 71aab3d0480f..c1c69783db7b 100644
> > --- a/drivers/net/ethernet/sfc/ef100.c
> > +++ b/drivers/net/ethernet/sfc/ef100.c
> > @@ -429,8 +429,7 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
> >         if (!efx)
> >                 return;
> >
> > -       probe_data = container_of(efx, struct efx_probe_data, efx);
> > -       ef100_remove_netdev(probe_data);
> > +       efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_NONE);
> >  #ifdef CONFIG_SFC_SRIOV
> >         efx_fini_struct_tc(efx);
> >  #endif
> > @@ -443,6 +442,7 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
> >         pci_disable_pcie_error_reporting(pci_dev);
> >
> >         pci_set_drvdata(pci_dev, NULL);
> > +       probe_data = container_of(efx, struct efx_probe_data, efx);
> >         efx_fini_struct(efx);
> >         kfree(probe_data);
> >  };
> > @@ -508,7 +508,7 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
> >                 goto fail;
> >
> >         efx->state = STATE_PROBED;
> > -       rc = ef100_probe_netdev(probe_data);
> > +       rc = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_EF100);
> >         if (rc)
> >                 goto fail;
> >
> > diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> > index 4dc643b0d2db..8cbe5e0f4bdf 100644
> > --- a/drivers/net/ethernet/sfc/ef100_nic.c
> > +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> > @@ -772,6 +772,99 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
> >         return 0;
> >  }
> >
> > +/* BAR configuration.
> > + * To change BAR configuration, tear down the current configuration (which
> > + * leaves the hardware in the PROBED state), and then initialise the new
> > + * BAR state.
> > + */
> > +struct ef100_bar_config_ops {
> > +       int (*init)(struct efx_probe_data *probe_data);
> > +       void (*fini)(struct efx_probe_data *probe_data);
> > +};
> > +
> > +static const struct ef100_bar_config_ops bar_config_ops[] = {
> > +       [EF100_BAR_CONFIG_EF100] = {
> > +               .init = ef100_probe_netdev,
> > +               .fini = ef100_remove_netdev
> > +       },
> > +#ifdef CONFIG_SFC_VDPA
> > +       [EF100_BAR_CONFIG_VDPA] = {
> > +               .init = NULL,
> > +               .fini = NULL
> > +       },
> > +#endif
> > +       [EF100_BAR_CONFIG_NONE] = {
> > +               .init = NULL,
> > +               .fini = NULL
> > +       },
> > +};
> 
> This looks more like a mini bus implementation. I wonder if we can
> reuse an auxiliary bus here which is more user friendly for management
> tools.

When we were in the design phase of vDPA for EF100 it was still called
virtbus, and the virtbus discussion was in full swing at that time.
We could not afford to add risk to the project by depending on it, as
it might not have been merged at all.
If we were doing the same design now I would definitely consider using
the auxiliary bus.

Martin
