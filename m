Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787826993B4
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 12:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjBPL6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 06:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBPL6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 06:58:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A5753540
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 03:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676548637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sp7C8N9iKhdlUU7FBPTb/LNgpBzXZPmHreMYm6mmt+o=;
        b=HzeZu0PoZWKrxrB3iEaVwBz7zk4MQxjsezz8AztLJM9NU5tp7qPs1VqhkSkx9ZKJk4r1wR
        jw7My0Z9/E10gygXG7DbpFQz11gzAeJDCWQrg94W1+RvoIqtFBi15W4Y2Nsex8LF/KMAGv
        PNYgIzVngXJ1cdkrpaCnObGIP2V9ksk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-126-e5HFdrXlPPCBs83Yx-sR1g-1; Thu, 16 Feb 2023 06:57:16 -0500
X-MC-Unique: e5HFdrXlPPCBs83Yx-sR1g-1
Received: by mail-qv1-f71.google.com with SMTP id k15-20020a0cd68f000000b00535261af1b1so940932qvi.13
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 03:57:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Sp7C8N9iKhdlUU7FBPTb/LNgpBzXZPmHreMYm6mmt+o=;
        b=JStUcBLHtAoa7bMMpOfylo3Bt6NkGfirSNNsefI49yTWcvUwZuGIwX9tjlLCI8lZnO
         fY/gpNj0u20sHtBZC7rxwgjREyGGjza7arZthrkrccd66arySoskcrQa3+h6X5vAa7VF
         7+SmM3nzTtmhHoZvREF8yo94ibT21zwFTHoTAqvoicB+nzGWlulhbnkCiGzJ0hFc6uwE
         pr+Xd79dhQP0jAh4q37yD7zjTZgfQo9lREpEnR42RKUr4pCp/kKmsdyuMTn4rKCx0tis
         8gUI4VQt/K5j24K81jVQXbKcGl2NwLuSQg4vjWTDh3cWOZt+XE2ONLp6Cehc3O709oxw
         4/yA==
X-Gm-Message-State: AO0yUKXgy6zwc6IRU1/Z5qjQ8FbZ12FETPErGygW8ah1y51G3fwspz0q
        CXPB+B1sg4cmxPO+/d6c6Po6Jb6eyl1yfk4l2EGEVgaaerk4WoPZLFJhU/KfdCSCVSbUU5gQnxu
        ShL1svtZfMTYAehYt
X-Received: by 2002:ac8:7e90:0:b0:3b6:309e:dfe1 with SMTP id w16-20020ac87e90000000b003b6309edfe1mr10568806qtj.3.1676548635617;
        Thu, 16 Feb 2023 03:57:15 -0800 (PST)
X-Google-Smtp-Source: AK7set9hNYyxleQKssZEK/kp0PjM70E+31LGS+jOzBKRnf8Q29p1d0LWPyGkv1KPU4L1ItMBMLIn+g==
X-Received: by 2002:ac8:7e90:0:b0:3b6:309e:dfe1 with SMTP id w16-20020ac87e90000000b003b6309edfe1mr10568780qtj.3.1676548635359;
        Thu, 16 Feb 2023 03:57:15 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id j67-20020a37b946000000b0073b2e248e58sm1020297qkf.107.2023.02.16.03.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 03:57:14 -0800 (PST)
Message-ID: <3f874bb8638258d131fcb764714b12b5a4c9eb39.camel@redhat.com>
Subject: Re: [PATCH net-next v2 1/3] vxlan: Expose helper vxlan_build_gbp_hdr
From:   Paolo Abeni <pabeni@redhat.com>
To:     Gavin Li <gavinl@nvidia.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavi Teitz <gavi@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Date:   Thu, 16 Feb 2023 12:57:11 +0100
In-Reply-To: <20230215094102.36844-2-gavinl@nvidia.com>
References: <20230215094102.36844-1-gavinl@nvidia.com>
         <20230215094102.36844-2-gavinl@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-02-15 at 11:41 +0200, Gavin Li wrote:
> vxlan_build_gbp_hdr will be used by other modules to build gbp option in
> vxlan header according to gbp flags.
>=20
> Signed-off-by: Gavin Li <gavinl@nvidia.com>
> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Acked-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/vxlan/vxlan_core.c | 20 --------------------
>  include/net/vxlan.h            | 20 ++++++++++++++++++++
>  2 files changed, 20 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_cor=
e.c
> index b1b179effe2a..bd44467a5a39 100644
> --- a/drivers/net/vxlan/vxlan_core.c
> +++ b/drivers/net/vxlan/vxlan_core.c
> @@ -2140,26 +2140,6 @@ static bool route_shortcircuit(struct net_device *=
dev, struct sk_buff *skb)
>  	return false;
>  }
> =20
> -static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags,
> -				struct vxlan_metadata *md)
> -{
> -	struct vxlanhdr_gbp *gbp;
> -
> -	if (!md->gbp)
> -		return;
> -
> -	gbp =3D (struct vxlanhdr_gbp *)vxh;
> -	vxh->vx_flags |=3D VXLAN_HF_GBP;
> -
> -	if (md->gbp & VXLAN_GBP_DONT_LEARN)
> -		gbp->dont_learn =3D 1;
> -
> -	if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
> -		gbp->policy_applied =3D 1;
> -
> -	gbp->policy_id =3D htons(md->gbp & VXLAN_GBP_ID_MASK);
> -}
> -
>  static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, u32 vxflags,
>  			       __be16 protocol)
>  {
> diff --git a/include/net/vxlan.h b/include/net/vxlan.h
> index bca5b01af247..02b01a6034a2 100644
> --- a/include/net/vxlan.h
> +++ b/include/net/vxlan.h
> @@ -566,4 +566,24 @@ static inline bool vxlan_fdb_nh_path_select(struct n=
exthop *nh,
>  	return true;
>  }
> =20
> +static inline void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags=
,
> +				       const struct vxlan_metadata *md)

Calling this helper causes a warning on patch 3 due to different types
for the 2nd argument. The warning could be addressed there with an
explicit cast but it looks like 'vxflags' is not used at all here.

I suggest to add a preparation patch dropping such argument (and the
same for vxlan_build_gpe_hdr(), still in the same patch), should be
cleaner.

Thanks,

Paolo

