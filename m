Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE6D4B0782
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 08:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236626AbiBJHuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 02:50:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236619AbiBJHuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 02:50:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB9C8103D
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 23:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644479419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4KIGxXInQ1uI9ZOUE3GlaQZVi6kzbYigWmFUhCjtrL8=;
        b=T762G19bL4rLKbBd5Cvpw9pgav9f5RgOacqda1q1Q2U9TqGMu41T84oIkdj239zeMla7cN
        Gsth60n8GiT4HwAlj2mkeKIfrIq0bgG+8pM8ybd9PNSa08KT0cCxvYeGGkX0l3bTlTLikd
        9nDHKCOKYX55BqIhnbzuJeArvIVONkY=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-K6rZzrT_NeuGBTBpnXlXZQ-1; Thu, 10 Feb 2022 02:50:17 -0500
X-MC-Unique: K6rZzrT_NeuGBTBpnXlXZQ-1
Received: by mail-lf1-f69.google.com with SMTP id u14-20020a196a0e000000b0044139d17aceso1138978lfu.15
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 23:50:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4KIGxXInQ1uI9ZOUE3GlaQZVi6kzbYigWmFUhCjtrL8=;
        b=sqrO7E4iCDCxE0Lp+cFUk8uQ03llf/bM/pSnqNY8JmVZ5XsNWzwYEJRsrkR/t4CMdz
         y8Q2EidFgBIvxJ+bnVM0AzLalDfg580KyU3O111SHpAuyV21o0yD4WF/TT+vprviPqBZ
         jWj1Vyofx2ZqmdEoUvaoxwj2RoKjLbuUmuB1/VwU/sb1Vy4jfeLOT2t4BU7DExxPfg26
         UbyT9Yi4hISVkWazsHId5jw0QLuKTm92q4xjEerdGYpfiXjrP9qifyj4+hDQTqXwOjPk
         95eA6lkcEngb4SaZuqZhkNIDpeQDrq7zF27FOvaWe337+gAXw0dSd6WbRqo43rvSMGEf
         lxFg==
X-Gm-Message-State: AOAM531B6j0qorPdV7r+7Qfttm1dvyxqMnEDWTSHD/yVXKSaYGmoldih
        RzQrgWJQtJpD0gE3hnz5+rrAdaDxGY7ZbUO/fAKNvZZMb1UgflvyGRI+cldVF5O42tOrtnr48HJ
        pmvPEw+vyV+9FkyseA9vxN+kdKG0X8bwk
X-Received: by 2002:a2e:a80c:: with SMTP id l12mr4194927ljq.107.1644479416059;
        Wed, 09 Feb 2022 23:50:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxsEcgufsx0ybeJs0c96UO3or4xMWNHOBShvaMPPIehWygx9rYD5a1UYqQmbmeI8OCRIxIfTCqT1zcZ9qtd0ag=
X-Received: by 2002:a2e:a80c:: with SMTP id l12mr4194917ljq.107.1644479415872;
 Wed, 09 Feb 2022 23:50:15 -0800 (PST)
MIME-Version: 1.0
References: <20220207125537.174619-1-elic@nvidia.com> <20220207125537.174619-2-elic@nvidia.com>
In-Reply-To: <20220207125537.174619-2-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 10 Feb 2022 15:50:04 +0800
Message-ID: <CACGkMEtbVdaFDeecZXRUQH6n3xVemf9HAMv0EnX-PJyaB8GNwQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] vdpa: Remove unsupported command line option
To:     Eli Cohen <elic@nvidia.com>
Cc:     "Hemminger, Stephen" <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Jianbo Liu <jianbol@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 7, 2022 at 8:56 PM Eli Cohen <elic@nvidia.com> wrote:
>
> "-v[erbose]" option is not supported.
> Remove it.
>
> Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
> Signed-off-by: Eli Cohen <elic@nvidia.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  vdpa/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index f048e470c929..4ccb564872a0 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -711,7 +711,7 @@ static void help(void)
>         fprintf(stderr,
>                 "Usage: vdpa [ OPTIONS ] OBJECT { COMMAND | help }\n"
>                 "where  OBJECT := { mgmtdev | dev }\n"
> -               "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] }\n");
> +               "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] }\n");
>  }
>
>  static int vdpa_cmd(struct vdpa *vdpa, int argc, char **argv)
> --
> 2.34.1
>

