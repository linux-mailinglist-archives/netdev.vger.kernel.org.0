Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DB95024F3
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 07:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350098AbiDOFyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 01:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350100AbiDOFx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 01:53:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41C9C4925D
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 22:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650001891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kvg7qjjzcKhlXPuJQVCJWvizFmo4t6XFmtZYkK1Ck7I=;
        b=h6SGCZBOmuGbgQNIwHPbClLXpOlxJbsEY/PzFrwYh7HZlwI0LdJgmeK4SASpredtKdD4Kc
        PKgyj+g6NUHdGtOoC/OMyKb9HkjtD+yz1T7txBeKzyC5lYiyqLKL9yOqAPvgHELXcvLrDT
        rCEsP2waLNeZEQ03+laqBHboYi+sUXM=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-Y522lgehOZ6J8Q3jtd0liA-1; Fri, 15 Apr 2022 01:51:29 -0400
X-MC-Unique: Y522lgehOZ6J8Q3jtd0liA-1
Received: by mail-lf1-f70.google.com with SMTP id w25-20020a05651234d900b0044023ac3f64so3196510lfr.0
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 22:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kvg7qjjzcKhlXPuJQVCJWvizFmo4t6XFmtZYkK1Ck7I=;
        b=K3xuXp1fePFmjZ750vuw0uQ6qmWmmkrGbGsR7jenyn9XlyQMSx69YQ8+gJE8JT0aPa
         3QJ+xzw7zyH8nutIp/ILlkl+7KGW/KDakp/XqhYf1DhDLhR5CY73VGrbkvOS35oB57Z8
         QUjoa7LZqqjb6WsbeIGUD8dW1V2wH+U0RWAUq9FUFu0OuhDGk3LVBOW6nEgX+1G57A1y
         g6yKbr0LS3PWyoG774A2gKfc9LdA8s1dD9XkNRZvOMYjhPY9WCzAbtBkTeroYxQBpt6W
         NXy6UxGrtVcxNrFT/dDxrfaixHwVHWFQMDt2zS7YNcUhjxj7u5uaNTOpMD+6B/ha8bOi
         q1pQ==
X-Gm-Message-State: AOAM531aAlH7EcUu2hub/jI07Wnyxh285m+s4Q4zvJ/la3dJMLCP/2K7
        BHUr4nbTQFD60Kgqp6WbY57BC04F/37CUOX61IbgocxnTynBuIGNvzcpZmuOk2CoH7k57xmYeKz
        yGWBlJDqE1rwUzznOf8tygNVLe7z3W1+f
X-Received: by 2002:ac2:4189:0:b0:448:bc2b:e762 with SMTP id z9-20020ac24189000000b00448bc2be762mr4045057lfh.471.1650001887930;
        Thu, 14 Apr 2022 22:51:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyS9hHKM21VRW0UY8Ve1Cbt+BdOhiCFLW4MX1/5XpMUr29jtbfQMNmVD64dtIZ4cj74T8I09XLXvQC8wZy8ZJ4=
X-Received: by 2002:ac2:4189:0:b0:448:bc2b:e762 with SMTP id
 z9-20020ac24189000000b00448bc2be762mr4045051lfh.471.1650001887708; Thu, 14
 Apr 2022 22:51:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220408121013.54709-1-lingshan.zhu@intel.com>
 <f3f60d6e-a506-bd58-d763-848beb0e4c26@redhat.com> <09a3613f-514b-c769-b8a0-25899b3d3159@intel.com>
In-Reply-To: <09a3613f-514b-c769-b8a0-25899b3d3159@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 15 Apr 2022 13:51:16 +0800
Message-ID: <CACGkMEuLW_PypyiPVcNz-B5FWNpkzLWwzC0eaZsCih+PbNt3Cg@mail.gmail.com>
Subject: Re: [PATCH] vDPA/ifcvf: assign nr_vring to the MSI vector of
 config_intr by default
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 5:16 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrot=
e:
>
>
>
> On 4/13/2022 4:14 PM, Jason Wang wrote:
> >
> > =E5=9C=A8 2022/4/8 =E4=B8=8B=E5=8D=888:10, Zhu Lingshan =E5=86=99=E9=81=
=93:
> >> This commit assign struct ifcvf_hw.nr_vring to the MSIX vector of the
> >> config interrupt by default in ifcvf_request_config_irq().
> >> ifcvf_hw.nr_vring is the most likely and the ideal case for
> >> the device config interrupt handling, means every virtqueue has
> >> an individual MSIX vector(0 ~ nr_vring - 1), and the config interrupt
> >> has
> >> its own MSIX vector(number nr_vring).
> >>
> >> This change can also make GCC W =3D 2 happy, silence the
> >> "uninitialized" warning.
> >>
> >> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> >> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> >> ---
> >>   drivers/vdpa/ifcvf/ifcvf_main.c | 8 ++++----
> >>   1 file changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c
> >> b/drivers/vdpa/ifcvf/ifcvf_main.c
> >> index 4366320fb68d..b500fb941dab 100644
> >> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> >> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> >> @@ -290,13 +290,13 @@ static int ifcvf_request_config_irq(struct
> >> ifcvf_adapter *adapter)
> >>       struct ifcvf_hw *vf =3D &adapter->vf;
> >>       int config_vector, ret;
> >>   +    /* vector 0 ~ vf->nr_vring for vqs, num vf->nr_vring vector
> >> for config interrupt */
> >
> >
> > The comment is right before this patch, but probably wrong for
> > MSIX_VECTOR_DEV_SHARED.
> This comment is for the case when every vq and config interrupt has its
> own vector, how
> about a better comment "The ideal the default case, vector 0 ~
> vf->nr_vring for vqs, num vf->nr_vring vector for config interrupt"

Actually, I suggest to remove the comment since the code can explain itself=
.

> >
> >
> >> +    config_vector =3D vf->nr_vring;
> >> +
> >> +    /* re-use the vqs vector */
> >>       if (vf->msix_vector_status =3D=3D MSIX_VECTOR_DEV_SHARED)
> >>           return 0;
> >>   -    if (vf->msix_vector_status =3D=3D MSIX_VECTOR_PER_VQ_AND_CONFIG=
)
> >> -        /* vector 0 ~ vf->nr_vring for vqs, num vf->nr_vring vector
> >> for config interrupt */
> >> -        config_vector =3D vf->nr_vring;
> >> -
> >>       if (vf->msix_vector_status =3D=3D MSIX_VECTOR_SHARED_VQ_AND_CONF=
IG)
> >>           /* vector 0 for vqs and 1 for config interrupt */
> >>           config_vector =3D 1;
> >
> >
> > Actually, I prefer to use if ... else ... here.
> IMHO, if else may lead to mistakes.
>
> The code:
>          /* The ideal the default case, vector 0 ~ vf->nr_vring for vqs,
> num vf->nr_vring vector for config interrupt */
>          config_vector =3D vf->nr_vring;
>
>          /* re-use the vqs vector */
>          if (vf->msix_vector_status =3D=3D MSIX_VECTOR_DEV_SHARED)
>                  return 0;
>
>          if (vf->msix_vector_status =3D=3D MSIX_VECTOR_SHARED_VQ_AND_CONF=
IG)
>                  /* vector 0 for vqs and 1 for config interrupt */
>                  config_vector =3D 1;
>
>
> here by default config_vector =3D vf->nr_vring;
> If msix_vector_status =3D=3D MSIX_VECTOR_DEV_SHARED, it will reuse the de=
v
> shared vector, means using the vector(value 0) for data-vqs.
> If msix_vector_status =3D=3D MSIX_VECTOR_SHARED_VQ_AND_CONFIG, it will us=
e
> vector=3D1(vector 0 for data-vqs).
>
> If we use if...else, it will be:
>
>          /* re-use the vqs vector */
>          if (vf->msix_vector_status =3D=3D MSIX_VECTOR_DEV_SHARED)
>                  return 0;
>          else
>                  config_vector =3D 1;
>
> This looks like config_vector can only be 0(re-used vector for the
> data-vqs, which is 0) or 1. It shadows the ideal and default case
> config_vector =3D vf->nr_vring

I meant something like

if (DEV_SHARED)
    return 0;
else if  (SHARED_VQ_AND_CONFIG)
    config_vector =3D 1
else if (PER_VQ_AND_CONFIG)
    config_vector =3D vf->nr_vring
else
    return -EINVAL;

or using a switch here.

(We get the warning because there's no way for the checker to know
that msix_vector_status must be DEV_SHARED, SHARED_VQ_AND_CONFIG and
PER_VQ_AND_CONFIG).

Thanks

>
> Thanks,
> Zhu Lingshan
>
> >
> > Thanks
> >
> >
>

