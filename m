Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10AB84BD4A1
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 05:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343731AbiBUESg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 23:18:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbiBUESf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 23:18:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 637F7B02
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 20:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645417090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XPvcfmMLgUD29Jl+0qIlNj/HSITkccGuA6rRi8S7CIc=;
        b=Iw0smOJTUXNCtTHYekUkOFgAfVlOpPYnR0P82784CYWqNA170qEKOw63hmlVQyc0WT27yF
        q7nshonvlXxuJUQHxSVtL3975S411vGf377+tUHPiVvaVZr03KFhRHGFosHcp2D0FhlhUy
        Sv1P34d6ELD0SRqgXAflIR5em3A+77U=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-NTMRZPexM8mXQ-B-NAfSCA-1; Sun, 20 Feb 2022 23:18:09 -0500
X-MC-Unique: NTMRZPexM8mXQ-B-NAfSCA-1
Received: by mail-pg1-f197.google.com with SMTP id d192-20020a6336c9000000b00372eb4c4bf4so8763192pga.8
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 20:18:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XPvcfmMLgUD29Jl+0qIlNj/HSITkccGuA6rRi8S7CIc=;
        b=kZJ167Rftrxyl6TqoG/UVhY6wS62TLdezmwZoMrWiuVCqD0VvwA83jjNuN0dOo7oQn
         a0uVsorqrPFmtXjU8cI5Ro34AcrnV+CByOyJwu/KIb/kYcQ1l3fVVfjskSqROtY/MYQH
         UKnYzjJquN2GtsmKnm8zi3SVFHQvzvAo85hk02innkw8ZyWvdBYCCwDJrU0z9dPBkVO1
         WIq/xMNDtzSOpC0JFL7jU9sRG6x0bVctVB3/M2rrUIHFiSfAfv5NUf1w65KbLayFKqpZ
         DfTCM1usEyjn7sr6RWVMSOBmZumTvMLAo/jgoDCBwYezQPY5WRG4HFvLeX4/DB16gsxT
         Du3g==
X-Gm-Message-State: AOAM531CDLAwu7Xo6yZfN73sQCx87H42Qdg3WY2VXQfK50fKa2j671Ik
        0AQ8LTnc6htmOVApRDjQisCXxQVyPl918Js7GfITc14nx8iKlV1ePzVEMydx1zag7EMxgPZkJi1
        jJ0UWy3cpiFqB/XXD
X-Received: by 2002:a17:90b:e89:b0:1b5:f4e4:7fd7 with SMTP id fv9-20020a17090b0e8900b001b5f4e47fd7mr19947687pjb.79.1645417087988;
        Sun, 20 Feb 2022 20:18:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwJaK3kKom8SApGW6QJMnk3DuJSUTdUkHF+xRIEilLJ63YSAuIt0wTS2DSFvwxNHabNFzmw4Q==
X-Received: by 2002:a17:90b:e89:b0:1b5:f4e4:7fd7 with SMTP id fv9-20020a17090b0e8900b001b5f4e47fd7mr19947668pjb.79.1645417087730;
        Sun, 20 Feb 2022 20:18:07 -0800 (PST)
Received: from [10.72.12.96] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g11sm11312896pfj.83.2022.02.20.20.18.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Feb 2022 20:18:07 -0800 (PST)
Message-ID: <b36e4a63-7fac-212a-2d6b-e267d49c5e72@redhat.com>
Date:   Mon, 21 Feb 2022 12:18:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v2 4/4] vdpa: Support reading device features
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     lulu@redhat.com, si-wei.liu@oracle.com
References: <20220217123024.33201-1-elic@nvidia.com>
 <20220217123024.33201-5-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220217123024.33201-5-elic@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/2/17 下午8:30, Eli Cohen 写道:
> When showing the available management devices, check if
> VDPA_ATTR_DEV_SUPPORTED_FEATURES feature is available and print the
> supported features for a management device.
>
> Examples:
> $ vdpa mgmtdev show
> auxiliary/mlx5_core.sf.1:
>    supported_classes net
>    max_supported_vqs 257
>    dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS CTRL_VQ MQ \
>                 CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
>
> $ vdpa -jp mgmtdev show
> {
>      "mgmtdev": {
>          "auxiliary/mlx5_core.sf.1": {
>              "supported_classes": [ "net" ],
>              "max_supported_vqs": 257,
>              "dev_features": [
> "CSUM","GUEST_CSUM","MTU","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ","MQ",\
> "CTRL_MAC_ADDR","VERSION_1","ACCESS_PLATFORM" ]
>          }
>      }
> }
>
> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
>   vdpa/include/uapi/linux/vdpa.h |  1 +
>   vdpa/vdpa.c                    | 14 +++++++++++++-
>   2 files changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> index a3ebf4d4d9b8..96ccbf305d14 100644
> --- a/vdpa/include/uapi/linux/vdpa.h
> +++ b/vdpa/include/uapi/linux/vdpa.h
> @@ -42,6 +42,7 @@ enum vdpa_attr {
>   
>   	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
>   	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
> +	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
>   
>   	/* new attributes must be added above here */
>   	VDPA_ATTR_MAX,
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index 78736b1422b6..bdc366880ab9 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -84,6 +84,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
>   	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
>   	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
>   	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
> +	[VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
>   };
>   
>   static int attr_cb(const struct nlattr *attr, void *data)
> @@ -494,13 +495,14 @@ static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
>   static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
>   				struct nlattr **tb)
>   {
> +	uint64_t classes = 0;
>   	const char *class;
>   	unsigned int i;
>   
>   	pr_out_handle_start(vdpa, tb);
>   
>   	if (tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]) {
> -		uint64_t classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
> +		classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
>   		pr_out_array_start(vdpa, "supported_classes");
>   
>   		for (i = 1; i < 64; i++) {
> @@ -522,6 +524,16 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
>   		print_uint(PRINT_ANY, "max_supported_vqs", "  max_supported_vqs %d", num_vqs);
>   	}
>   
> +	if (tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]) {
> +		uint64_t features;
> +
> +		features  = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]);
> +		if (classes & BIT(VIRTIO_ID_NET))
> +			print_features(vdpa, features, true, VIRTIO_ID_NET);
> +		else
> +			print_features(vdpa, features, true, 0);


I wonder what happens if we try to read a virtio_blk device consider:

static const char * const *dev_to_feature_str[] = {
         [VIRTIO_ID_NET] = net_feature_strs,
};

Thanks


> +	}
> +
>   	pr_out_handle_end(vdpa);
>   }
>   

