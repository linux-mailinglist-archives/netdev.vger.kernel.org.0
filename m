Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D809C4EBDA6
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 11:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244820AbiC3Jaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 05:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244814AbiC3Jai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 05:30:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 261B92ED47
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 02:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648632530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e3lvh5/HNNYMc+YnF6UpSFPF4QWEH7G+wbhZFWF+qBM=;
        b=cFzcaItkhmPT/54Cv1sz/MpHFwYT5WhtyycNDXaoFlwCOCmaz09up0a/+A/RRLPSOlxKTW
        a9qxfH7EtPjqtGGbctLSoxdLBAaN3ndJPuUzIYNXezsuJ8q7e9ZtlvtYE2TSBWMLChnRe3
        yC9PylOVlwD5p77Bl2M70KXcT7pwaQo=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-drYK7nurPXiNJpqkoph6Fg-1; Wed, 30 Mar 2022 05:28:48 -0400
X-MC-Unique: drYK7nurPXiNJpqkoph6Fg-1
Received: by mail-il1-f199.google.com with SMTP id f18-20020a926a12000000b002be48b02bc6so11095116ilc.17
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 02:28:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e3lvh5/HNNYMc+YnF6UpSFPF4QWEH7G+wbhZFWF+qBM=;
        b=Q0yRwQiiRER9etA9557bVrLZ4EWqAd0sOeW2jWHTMchxvj87guJ9PhhM4EkFs3aEBh
         KVoLc0KsksxpmvcZdYAzxhsC4u3PqrJH49OUpFHugz4J7gNawfj6XccAjpR1RVzGtrUa
         SAexsLEyfYqnBS6CPOea0oj4PrqJ9MXPA/6gdoQ3W2KD40hbyQ2f98CAEYXcB4Q7027X
         SdsqjNPTK6d43WTKxw/gRrzxywS3DThcqwC1oABaCjcZDRVNyO8TqpTrH1STo+eeojub
         FLnsQiihwkjFtFGTc4FqCesr0I30ox5esNbTjhFWZMEJ4AcyuD+wQsfX6Z+QzuX0hgUc
         VBYA==
X-Gm-Message-State: AOAM531XSVsNLjw2a579Xw94FAork3hPPrEhsxPgRTn8qIhgQ1izi/GN
        aINXAqRBOXLEeXaVjeGkS1Ve2wcW8oTtC18t6s7xUszlyEgny0eA1ZmXmdc1g6OF7rtPrAefQrX
        NKkMffChneo9ZdCCRIa3zFEAcVWfkJNXi
X-Received: by 2002:a05:6602:154d:b0:64c:5fab:4076 with SMTP id h13-20020a056602154d00b0064c5fab4076mr10965108iow.169.1648632527733;
        Wed, 30 Mar 2022 02:28:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkjhSj+rD7v0OzPBCEoScFUIZvK2HrGnCInP9SEks8o3l6WAgSv3s5hfjAyYZAt3i+eDNiWpYe7yZU6WphnMM=
X-Received: by 2002:a05:6602:154d:b0:64c:5fab:4076 with SMTP id
 h13-20020a056602154d00b0064c5fab4076mr10965101iow.169.1648632527530; Wed, 30
 Mar 2022 02:28:47 -0700 (PDT)
MIME-Version: 1.0
References: <164857006953.8140.3265568858101821256.stgit@palantir17.mph.net>
In-Reply-To: <164857006953.8140.3265568858101821256.stgit@palantir17.mph.net>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Wed, 30 Mar 2022 11:28:36 +0200
Message-ID: <CACT4ouco5oPQ9-qAwU0MgeK_+9K_1UmO0O9o3vofDbTTULY7eA@mail.gmail.com>
Subject: Re: [PATCH net] sfc: Avoid NULL pointer dereference on systems
 without numa awareness
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Edward Cree <ecree.xilinx@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 6:08 PM Martin Habets <habetsm.xilinx@gmail.com> wr=
ote:
>
> On such systems cpumask_of_node() returns NULL, which bitmap
> operations are not happy with.
>
> Fixes: c265b569a45f ("sfc: default config to 1 channel/core in local NUMA=
 node only")
> Fixes: 09a99ab16c60 ("sfc: set affinity hints in local NUMA node only")
> Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
> ---
>  drivers/net/ethernet/sfc/efx_channels.c |   11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethern=
et/sfc/efx_channels.c
> index d6fdcdc530ca..f9064532beb6 100644
> --- a/drivers/net/ethernet/sfc/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/efx_channels.c
> @@ -91,11 +91,9 @@ static unsigned int count_online_cores(struct efx_nic =
*efx, bool local_node)
>         }
>
>         cpumask_copy(filter_mask, cpu_online_mask);
> -       if (local_node) {
> -               int numa_node =3D pcibus_to_node(efx->pci_dev->bus);
> -
> -               cpumask_and(filter_mask, filter_mask, cpumask_of_node(num=
a_node));
> -       }
> +       if (local_node)
> +               cpumask_and(filter_mask, filter_mask,
> +                           cpumask_of_pcibus(efx->pci_dev->bus));
>
>         count =3D 0;
>         for_each_cpu(cpu, filter_mask) {
> @@ -386,8 +384,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
>  #if defined(CONFIG_SMP)
>  void efx_set_interrupt_affinity(struct efx_nic *efx)
>  {
> -       int numa_node =3D pcibus_to_node(efx->pci_dev->bus);
> -       const struct cpumask *numa_mask =3D cpumask_of_node(numa_node);
> +       const struct cpumask *numa_mask =3D cpumask_of_pcibus(efx->pci_de=
v->bus);
>         struct efx_channel *channel;
>         unsigned int cpu;
>
>

Reviewed-by: =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com>

--=20
=C3=8D=C3=B1igo Huguet

