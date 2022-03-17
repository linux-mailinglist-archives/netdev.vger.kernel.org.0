Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B094DBF16
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 07:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiCQGQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 02:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiCQGP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 02:15:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93B592A2668
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 22:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647496398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IuVUbU5po4pDsL5Q02wWFZCT4oH7kt1pNvS3SA5iGQw=;
        b=f5y9erUdC1tFG6Bz2oDXH9tJ1ZNQilUXS1k0WZ4XenWtmlFSW21gmEMJ5RS8EL/jxF35xe
        M3H9cdFsCey7JFXlC//wXlg2rZiDswX0DpRG+ThNBkLMNn29KsoOaWUL7QvVS9tp1LZjMx
        XEUyghExluBAu3b466dsc1UQEqnfbcs=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-AnTS2JvMPPiKCjGAwsfzZg-1; Wed, 16 Mar 2022 23:39:31 -0400
X-MC-Unique: AnTS2JvMPPiKCjGAwsfzZg-1
Received: by mail-lf1-f72.google.com with SMTP id z24-20020a056512371800b0043ea4caa07cso1339729lfr.17
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 20:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IuVUbU5po4pDsL5Q02wWFZCT4oH7kt1pNvS3SA5iGQw=;
        b=1cwu+4EV35GfEYBCyPctuO9CXAKDv93A3btjedsBIkpewkf+sKQw5K+by4r31aY/tB
         ltTj65J0CVHlhwfuOJ28vyydhy2U+dv1xfb2/y5ZWK4XJm5jpL/WXpwg9ENR0/gofdci
         qzb/+/GVZTxNHLSiICMECwEdgMC2ifMjLwUw+Y1kJGtywFeQloVTv3LO3zExyF1171ef
         HPrL6LtgZza6pCtqGgzpa+L2LZDB58v5/S6YxvRvG5GGgxG99rt35GKtc9KuZQkNn68n
         qLHB2R0K/9+j7RWiMhNuc3ZncKvf+V5AHsbfNr9Zgu4Vu3F3XJJ7DUmkldUFo3g3Riwe
         +X4w==
X-Gm-Message-State: AOAM5336juyeCV+1Rcyf5Vj147dtfZq3/dAACNWChZ8BE2g21Zd1Hj61
        8HqZ9fH45nt3UHoHY+N0Zz3f2rwMzrcUiUyPlGJ02CsfWrAjEyQ6Ps0sp5cYDQT7OJ4eVz/1eGa
        l4Glp5PsHPRlIDZF3LFnWLS6REHN6eGjA
X-Received: by 2002:ac2:4189:0:b0:448:bc2b:e762 with SMTP id z9-20020ac24189000000b00448bc2be762mr1508960lfh.471.1647488369622;
        Wed, 16 Mar 2022 20:39:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwK0XzZGn35nasn25rxFzAwhFR/SqzlJeKiaVyEcPcYeD18h4oUG7GAWG/QVUE79bFdBETaLdR8yXIgqxOznS4=
X-Received: by 2002:ac2:4189:0:b0:448:bc2b:e762 with SMTP id
 z9-20020ac24189000000b00448bc2be762mr1508956lfh.471.1647488369460; Wed, 16
 Mar 2022 20:39:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220315131358.7210-1-elic@nvidia.com>
In-Reply-To: <20220315131358.7210-1-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 17 Mar 2022 11:39:18 +0800
Message-ID: <CACGkMEuCjdLZ6sRSk3CnH-QVh8wruhJQWFV2fWsujHRvcR0dKg@mail.gmail.com>
Subject: Re: [PATCH] vdpa: Update man page with added support to configure max
 vq pair
To:     Eli Cohen <elic@nvidia.com>
Cc:     dsahern@kernel.org,
        "Hemminger, Stephen" <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Si-Wei Liu <si-wei.liu@oracle.com>, mst <mst@redhat.com>,
        Cindy Lu <lulu@redhat.com>, Parav Pandit <parav@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 9:14 PM Eli Cohen <elic@nvidia.com> wrote:
>
> Update man page to include information how to configure the max
> virtqueue pairs for a vdpa device when creating one.
>
> Signed-off-by: Eli Cohen <elic@nvidia.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  man/man8/vdpa-dev.8 | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8
> index aa21ae3acbd8..432867c65182 100644
> --- a/man/man8/vdpa-dev.8
> +++ b/man/man8/vdpa-dev.8
> @@ -33,6 +33,7 @@ vdpa-dev \- vdpa device configuration
>  .I MGMTDEV
>  .RI "[ mac " MACADDR " ]"
>  .RI "[ mtu " MTU " ]"
> +.RI "[ max_vqp " MAX_VQ_PAIRS " ]"
>
>  .ti -8
>  .B vdpa dev del
> @@ -119,6 +120,11 @@ vdpa dev add name foo mgmtdev vdpa_sim_net mac 00:11:22:33:44:55 mtu 9000
>  Add the vdpa device named foo on the management device vdpa_sim_net with mac address of 00:11:22:33:44:55 and mtu of 9000 bytes.
>  .RE
>  .PP
> +vdpa dev add name foo mgmtdev auxiliary/mlx5_core.sf.1 mac 00:11:22:33:44:55 max_vqp 8
> +.RS 4
> +Add the vdpa device named foo on the management device auxiliary/mlx5_core.sf.1 with mac address of 00:11:22:33:44:55 and max 8 virtqueue pairs
> +.RE
> +.PP
>  vdpa dev del foo
>  .RS 4
>  Delete the vdpa device named foo which was previously created.
> --
> 2.35.1
>

