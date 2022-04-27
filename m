Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD6A510FED
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 06:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357648AbiD0E0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 00:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357646AbiD0E0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 00:26:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5263113D32
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 21:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651033375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yKatoHCuChnV5P++UEo+XINquKqFQYRhvvehVy2DaeI=;
        b=NBrLIAsdpM9eF3Q+SLpBJANRNG0JWLVMH3svzocxKd6istJMQTMcAmywLuGYPjAyvoPlVk
        tQfOSPV/1NBZFwMLWYpK2PYRcNl9DG8+sts1Yi3EUg89EWk266w4KXrkvKMwNkrLyDWx78
        RZgu4aC4C9kZg0+3/0rvevikXFkbyPk=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-BoCQl640O0GAnZWACYKkSw-1; Wed, 27 Apr 2022 00:22:53 -0400
X-MC-Unique: BoCQl640O0GAnZWACYKkSw-1
Received: by mail-lf1-f71.google.com with SMTP id z35-20020a0565120c2300b004721f8a4e37so259123lfu.20
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 21:22:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yKatoHCuChnV5P++UEo+XINquKqFQYRhvvehVy2DaeI=;
        b=f5eUtWGZYwE6OVt4FHZEG6bA8EBZ+4k42ML9/HUV1BnWLc9EiLpqEFj1SouH93Zqo+
         OOah4dKxbNXcEgnfr3TyeRWnjZnjzTeMLwOIo9SRYwmKLM29g3s3SgVqsmnZ5f4FAZ+2
         P16w7C4c5+6oTSgmyN4qzBg1gwZaOFgd/YmLjZBWZbhzllRr6l1YDfDjTck1wekU1B/N
         WEViOPHCnN0OkayR/wfsdTjg0YwEcEKFF1kLj3VT2QwtNPKuCSeWCFs8Kk9nlrrTJBQv
         f+kEz/ETpLSxOCqiE6FRuuF3vCWZZlOfGIYaO/npqqCRKJ2THAvuMLOeebrbujOyFCU8
         N0ow==
X-Gm-Message-State: AOAM530tBh1WvNhp+1zyg76P0JQ1rGQwgPw737WX6WNVVRWnB2i3LGcR
        6tXREh+fe3RDfXv1T3Ap1DWhBBK0ZNDrghrYgnM2cULLYq3b3Mdpcwv491Brq+HdpjEnSAhsC7x
        Alxzz+bcrgzAbalkN2+aR1TOO1/5RrYKz
X-Received: by 2002:a05:6512:b81:b0:448:b342:513c with SMTP id b1-20020a0565120b8100b00448b342513cmr18857944lfv.257.1651033371606;
        Tue, 26 Apr 2022 21:22:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoKiZRBjrtWpC+KrgtfMsl6pwDB0owXqJM3JzrerMHXaOMCp70SA4MM483v59xZhvDer9Z/U2i7rLMSft14EI=
X-Received: by 2002:a05:6512:b81:b0:448:b342:513c with SMTP id
 b1-20020a0565120b8100b00448b342513cmr18857939lfv.257.1651033371435; Tue, 26
 Apr 2022 21:22:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220424072806.1083189-1-lingshan.zhu@intel.com>
In-Reply-To: <20220424072806.1083189-1-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 27 Apr 2022 12:22:40 +0800
Message-ID: <CACGkMEts+u6gnm1hsT=vhgiHE5CiYns4mydTtnr3LkZMJEzVGA@mail.gmail.com>
Subject: Re: [PATCH] vDPA/ifcvf: fix uninitialized config_vector warning
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 3:36 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> Static checkers are not informed that config_vector is controlled
> by vf->msix_vector_status, which can only be
> MSIX_VECTOR_SHARED_VQ_AND_CONFIG, MSIX_VECTOR_SHARED_VQ_AND_CONFIG
> and MSIX_VECTOR_DEV_SHARED.
>
> This commit uses an "if...elseif...else" code block to tell the
> checkers that it is a complete set, and config_vector can be
> initialized anyway
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/vdpa/ifcvf/ifcvf_main.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 4366320fb68d..9172905fc7ae 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -290,16 +290,16 @@ static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter)
>         struct ifcvf_hw *vf = &adapter->vf;
>         int config_vector, ret;
>
> -       if (vf->msix_vector_status == MSIX_VECTOR_DEV_SHARED)
> -               return 0;
> -
>         if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
> -               /* vector 0 ~ vf->nr_vring for vqs, num vf->nr_vring vector for config interrupt */
>                 config_vector = vf->nr_vring;
> -
> -       if (vf->msix_vector_status ==  MSIX_VECTOR_SHARED_VQ_AND_CONFIG)
> +       else if (vf->msix_vector_status ==  MSIX_VECTOR_SHARED_VQ_AND_CONFIG)
>                 /* vector 0 for vqs and 1 for config interrupt */
>                 config_vector = 1;
> +       else if (vf->msix_vector_status == MSIX_VECTOR_DEV_SHARED)
> +               /* re-use the vqs vector */
> +               return 0;
> +       else
> +               return -EINVAL;
>
>         snprintf(vf->config_msix_name, 256, "ifcvf[%s]-config\n",
>                  pci_name(pdev));
> --
> 2.31.1
>

