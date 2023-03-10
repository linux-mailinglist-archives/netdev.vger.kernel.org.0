Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0106B35ED
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 06:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjCJFHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 00:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjCJFHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 00:07:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C042AE11F
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 21:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678424756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P84h/nY9p0mcJuFb9UEVOJQpR9dBzvHf088c6tPlxuU=;
        b=dAwi9FDaSMBwGJSbYm1zvLXQmFvfBVEn4DXje/Sa9qWWnUlXSFo+hP4rdtzf910TfBnLS6
        HZGUGU1sXEnBXmCvunq3E93l+v9U47YQIdnzPEbpl/U+pi2KzfpP9TfswXVNUtatLblr+j
        6wMIRc8DwRBprmby6ThWCwx/BViNcJk=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-idQEbOkAO9CLYMJ7dCUIHA-1; Fri, 10 Mar 2023 00:05:54 -0500
X-MC-Unique: idQEbOkAO9CLYMJ7dCUIHA-1
Received: by mail-ot1-f70.google.com with SMTP id y14-20020a056830208e00b006943ddbfb7eso1884656otq.5
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 21:05:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678424753;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P84h/nY9p0mcJuFb9UEVOJQpR9dBzvHf088c6tPlxuU=;
        b=S1y121bo/2kH8DnzYrbdMmi2n468HmCrHnyLs5AFB9LW905Yuh1Wil1XkqGiAVs8VM
         y+/FxozmiAi9kZmrtrLLufqgsEbEHpGPgzs8UzSh8BsSARxRhSF1fokSVfy5RXNN1xZb
         BDiNpVBRofaVoh2OHo6l4XfBcIchf7KsX7WCYGjhpZOIhhQOAn2399+dPQRBLcXmErA6
         aXTiKHGuLJnlAx9sZXzQvGLFTllNhxfaKfXdpv/jEqUQYIqivII8aSDyscvBiG5oRftv
         gc4OI9qGJZyfwSmhSVkQRHcaA4qCqtgMlmd8S13gTWbJ5bvIDPRGX7Kl8iOSydLSBDsV
         LGkw==
X-Gm-Message-State: AO0yUKW/AcDAtjQyQb2NN7MYOiJdmaSGeHwruvhjjdR3sqDSthv6LDoz
        mEwnIe8zBwKvpOyPXGBNFqWLddLvvJvT/2tDZdOlZSq4qMIRYRDQEWLyHZC/3P1o7eJy2/vLC0G
        V26fbi1tTqxMJwt/AkhDxv48GfxuLOWpbaI4ef3dVbEo=
X-Received: by 2002:a05:6870:c384:b0:175:31d3:e12d with SMTP id g4-20020a056870c38400b0017531d3e12dmr8636885oao.9.1678424753280;
        Thu, 09 Mar 2023 21:05:53 -0800 (PST)
X-Google-Smtp-Source: AK7set8Iz29RQDH4L5Ux4WkOD6n6YPY4bKozWJTtvpHGUerPsUQx5mvRnYY54Nv7n9BHs6GEb54vFNvORaiYBotUa8g=
X-Received: by 2002:a05:6870:c384:b0:175:31d3:e12d with SMTP id
 g4-20020a056870c38400b0017531d3e12dmr8636881oao.9.1678424753111; Thu, 09 Mar
 2023 21:05:53 -0800 (PST)
MIME-Version: 1.0
References: <20230307113621.64153-1-gautam.dawar@amd.com> <20230307113621.64153-14-gautam.dawar@amd.com>
In-Reply-To: <20230307113621.64153-14-gautam.dawar@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 10 Mar 2023 13:05:41 +0800
Message-ID: <CACGkMEuY4KoiZKswjMDNfoeUTqUagXye-_qe-iP2JJq0schObQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 13/14] sfc: update vdpa device MAC address
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 7, 2023 at 7:38=E2=80=AFPM Gautam Dawar <gautam.dawar@amd.com> =
wrote:
>
> As the VF MAC address can now be updated using `devlink port function set=
`

What happens if we run this while the vpda is being used by a VM?

> interface, fetch the vdpa device MAC address from the underlying VF durin=
g
> vdpa device creation.
>
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>  drivers/net/ethernet/sfc/ef100_vdpa.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet=
/sfc/ef100_vdpa.c
> index 30ca4ab00175..32182a01f6a5 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
> @@ -272,6 +272,18 @@ static int get_net_config(struct ef100_vdpa_nic *vdp=
a_nic)
>         vdpa_nic->net_config.max_virtqueue_pairs =3D
>                 cpu_to_efx_vdpa16(vdpa_nic, vdpa_nic->max_queue_pairs);
>
> +       rc =3D ef100_get_mac_address(efx, vdpa_nic->mac_address,
> +                                  efx->client_id, true);
> +       if (rc) {
> +               dev_err(&vdpa_nic->vdpa_dev.dev,
> +                       "%s: Get MAC for vf:%u failed:%d\n", __func__,
> +                       vdpa_nic->vf_index, rc);
> +               return rc;
> +       }

Can this override what is provisioned by the userspace?

Thanks


> +
> +       if (is_valid_ether_addr(vdpa_nic->mac_address))
> +               vdpa_nic->mac_configured =3D true;
> +
>         rc =3D efx_vdpa_get_mtu(efx, &mtu);
>         if (rc) {
>                 dev_err(&vdpa_nic->vdpa_dev.dev,
> --
> 2.30.1
>

