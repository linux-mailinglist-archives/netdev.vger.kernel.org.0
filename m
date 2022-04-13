Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756E04FF18C
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbiDMIRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbiDMIRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:17:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2FD361BEB6
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649837686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JaCjRDhcAQlFYlhtWNYdWseSonfQzqPpylM0vuUlol8=;
        b=LTdivFfElLyQTThP3NCVszMsCLegk9G8E1jD5phEJFkOQSViV9eTzUR3T6u5G5nqKsTyzE
        rUxDqf7bkJAhgx8jZFf9UnIGKKfZBxvJj+ZguKKuucrjAJDP3RiAkMU0LwFMT7lTv5wqCZ
        ZfNpHZWiOG7pn6do18TIpVQVrbaQ+mk=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-wHoNS8T7Pu-Qvs5N7qDD2A-1; Wed, 13 Apr 2022 04:14:37 -0400
X-MC-Unique: wHoNS8T7Pu-Qvs5N7qDD2A-1
Received: by mail-pj1-f70.google.com with SMTP id c9-20020a17090a1d0900b001caaf769af6so861830pjd.2
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:14:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JaCjRDhcAQlFYlhtWNYdWseSonfQzqPpylM0vuUlol8=;
        b=isI2yWbVpIct6E9nmGjlKSqqXOd+w0gAM8kzjqh/o/pqadmNdSKF+TyIiwOAltNJu7
         QehiREyIROSw0imtz57rawuAZt9fjYQpAhcJAjVuTpkIAc7EmxyhmDp0r4JgZQla4hqw
         6oY6NqTowbeFyCh5ZiupuGoCDkANu+mbqHv48bYBL0yVh75M7+2xJ8e/RgHZHTG+Sxh5
         8IsVT2n6z4yPaVH/yKu8GAB1REqNQMTICaUsYsR1na8OWacfMpqxowvMDbAtdeP+LOhn
         Z6lzPydOUoLxpYAYqW9lTWanU6BvpDzpJX6HTAjQRyZ296mBMTP10lP/AXG1sB8y7ZnY
         qnfA==
X-Gm-Message-State: AOAM533L/Kjxi0mQFx7FjE0D+BTYe+LQ0SEN+pP/8SGu4ELXhe2tsWjA
        s8VPFIBx8P/efpN3sdpCLKNWX55NaTZQgSTvmqMlgMu/0J06eWbqDoWlqFTEvdNif1cRalVh96C
        AM0P0rjpI3cR8+rlT
X-Received: by 2002:a17:903:1249:b0:154:c472:de6b with SMTP id u9-20020a170903124900b00154c472de6bmr41955314plh.38.1649837676525;
        Wed, 13 Apr 2022 01:14:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+ajsGKGH1EatN+KQ2iXpuRaWGLXVOtaxxTRwpviTqMpWsY8kzjD8kvbSeAKA1g9Dz34bxIg==
X-Received: by 2002:a17:903:1249:b0:154:c472:de6b with SMTP id u9-20020a170903124900b00154c472de6bmr41955301plh.38.1649837676273;
        Wed, 13 Apr 2022 01:14:36 -0700 (PDT)
Received: from [10.72.13.223] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d26-20020aa797ba000000b00505f0ed6494sm5963955pfq.192.2022.04.13.01.14.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 01:14:35 -0700 (PDT)
Message-ID: <f3f60d6e-a506-bd58-d763-848beb0e4c26@redhat.com>
Date:   Wed, 13 Apr 2022 16:14:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] vDPA/ifcvf: assign nr_vring to the MSI vector of
 config_intr by default
Content-Language: en-US
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20220408121013.54709-1-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220408121013.54709-1-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/4/8 下午8:10, Zhu Lingshan 写道:
> This commit assign struct ifcvf_hw.nr_vring to the MSIX vector of the
> config interrupt by default in ifcvf_request_config_irq().
> ifcvf_hw.nr_vring is the most likely and the ideal case for
> the device config interrupt handling, means every virtqueue has
> an individual MSIX vector(0 ~ nr_vring - 1), and the config interrupt has
> its own MSIX vector(number nr_vring).
>
> This change can also make GCC W = 2 happy, silence the
> "uninitialized" warning.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 4366320fb68d..b500fb941dab 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -290,13 +290,13 @@ static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter)
>   	struct ifcvf_hw *vf = &adapter->vf;
>   	int config_vector, ret;
>   
> +	/* vector 0 ~ vf->nr_vring for vqs, num vf->nr_vring vector for config interrupt */


The comment is right before this patch, but probably wrong for 
MSIX_VECTOR_DEV_SHARED.


> +	config_vector = vf->nr_vring;
> +
> +	/* re-use the vqs vector */
>   	if (vf->msix_vector_status == MSIX_VECTOR_DEV_SHARED)
>   		return 0;
>   
> -	if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
> -		/* vector 0 ~ vf->nr_vring for vqs, num vf->nr_vring vector for config interrupt */
> -		config_vector = vf->nr_vring;
> -
>   	if (vf->msix_vector_status ==  MSIX_VECTOR_SHARED_VQ_AND_CONFIG)
>   		/* vector 0 for vqs and 1 for config interrupt */
>   		config_vector = 1;


Actually, I prefer to use if ... else ... here.

Thanks


