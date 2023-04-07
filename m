Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03EF56DB661
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 00:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjDGWVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 18:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjDGWV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 18:21:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53201CA1C
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 15:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680906048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sh3HFtUiIveDO9geaO+OZn8WlGzmk7g/J+bfhfYbiM0=;
        b=DxV1QUsumDVf18s06z5ouFRtG3DZnAn/96DeO72jle4ZHQlBqPQJfCdUlSl4dN1fkavK+4
        I4uLgdPnLgGBM3CxLBzrAjjmqPiljym41YhoP3FaJJB719KGZEO5EXdc4wSLB5JR8nR7ck
        Jwww8MBKwDTOZAJdxTChSgDcCV+Bpt8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-b0IdubQiO-qPdNqU1AhyHw-1; Fri, 07 Apr 2023 18:20:44 -0400
X-MC-Unique: b0IdubQiO-qPdNqU1AhyHw-1
Received: by mail-ed1-f69.google.com with SMTP id c1-20020a0564021f8100b004acbe232c03so53743494edc.9
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 15:20:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680906043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sh3HFtUiIveDO9geaO+OZn8WlGzmk7g/J+bfhfYbiM0=;
        b=BM4OuVTtqKWSn8C6swqas5C4RD7RI/LxlLuZGjbNDKB2a+ybm/kSMbQuNvkG3iDQRx
         KICtHu7hIYbhF2jcWd3S2UhQCOprnBy270nZg8BKumRYsiz0++O7wOYfD59XPuPS/35r
         fhpNV1K//AXUGUwl9ZktbgqD/pmvb2ws+TF/bWGB4UfixsKnG9pe26aWqWNOzZeXTOal
         cN4mkZMOKkZDfDoQfHi1ohhrzZIvhc3mNWqJO4qXvxiLdr6qnPKR8Fta1ZXwQJBLS1g1
         DMZabHySYKLAxbtbRkBpMfwkndTN7WMKvmWMpeU6xKVDWCTddU1QUs5MgOijWlBDRLIq
         S4Wg==
X-Gm-Message-State: AAQBX9fC82FU7SXg5Df6eAvPhrptzXhS8N80QjJq5FQaQnvyeCJXpgKM
        GcEb60iGP3CSdHkfQEdozOBoqlzZbL+L3tju6spuTkWKB3nvBxbjwyhghUTgWdItEpgWKVkEh+s
        QNd4SQSXYmxBAb3P4bZB2fZxRgeUSehyy
X-Received: by 2002:a17:906:4690:b0:930:1178:2220 with SMTP id a16-20020a170906469000b0093011782220mr95635ejr.40.1680906043580;
        Fri, 07 Apr 2023 15:20:43 -0700 (PDT)
X-Google-Smtp-Source: AKy350YdjKda8XASC+CGeDn5cjd4gS1Y/aghaO307w7qLJjZRB6caA9JHIcZMQpdfghKjBDxdNH4Y7CosJWEoPZL8sM=
X-Received: by 2002:a17:906:4690:b0:930:1178:2220 with SMTP id
 a16-20020a170906469000b0093011782220mr95627ejr.40.1680906043336; Fri, 07 Apr
 2023 15:20:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230407095301.45858-1-chenaotian2@163.com>
In-Reply-To: <20230407095301.45858-1-chenaotian2@163.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Fri, 7 Apr 2023 18:20:32 -0400
Message-ID: <CAK-6q+gpRPxquCSCfPB+9Ym+1PTu9Z+qzC+PHj_K94nSGUbTWA@mail.gmail.com>
Subject: Re: [PATCH] ieee802154: hwsim: Fix possible memory leaks
To:     Chen Aotian <chenaotian2@163.com>
Cc:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        miquel.raynal@bootlin.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernelorg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Apr 7, 2023 at 5:55=E2=80=AFAM Chen Aotian <chenaotian2@163.com> wr=
ote:
>
> After replacing e->info, it is necessary to free the old einfo.
>
> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> Signed-off-by: Chen Aotian <chenaotian2@163.com>
> ---
>  drivers/net/ieee802154/mac802154_hwsim.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee8=
02154/mac802154_hwsim.c
> index 8445c2189..6e7e10b17 100644
> --- a/drivers/net/ieee802154/mac802154_hwsim.c
> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> @@ -685,7 +685,7 @@ static int hwsim_del_edge_nl(struct sk_buff *msg, str=
uct genl_info *info)
>  static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *inf=
o)
>  {
>         struct nlattr *edge_attrs[MAC802154_HWSIM_EDGE_ATTR_MAX + 1];
> -       struct hwsim_edge_info *einfo;
> +       struct hwsim_edge_info *einfo, *einfo_old;
>         struct hwsim_phy *phy_v0;
>         struct hwsim_edge *e;
>         u32 v0, v1;
> @@ -723,8 +723,10 @@ static int hwsim_set_edge_lqi(struct sk_buff *msg, s=
truct genl_info *info)
>         list_for_each_entry_rcu(e, &phy_v0->edges, list) {
>                 if (e->endpoint->idx =3D=3D v1) {
>                         einfo->lqi =3D lqi;
> +                       einfo_old =3D rcu_dereference(e->info);
>                         rcu_assign_pointer(e->info, einfo);

nitpick rcu_replace_pointer() can be used here.*

- Alex

