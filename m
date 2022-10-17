Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA32600772
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 09:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiJQHNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 03:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiJQHN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 03:13:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3872C21818
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 00:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665990806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5fTVp4OVTG6rY4QVgkRM3QvqSda6IStVSl2Tqf98Buk=;
        b=ZouhmGXgHHzzms+PiL4h5Ng87g0+hZSn8AX2X+AZG6A/EVaT00DNRbiTl4m8iasPGCjevJ
        UF+TWTS99mDl+BuoafVI4giNJs1ahhkk6DT17/FkyGUedV68YfkunQhV7hBhHialfX+1WQ
        93RZdPO1xVFFDN5fmgi36zGbYhnDrKQ=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-102-mvFTcxRuMI2xlxT4UMGsHw-1; Mon, 17 Oct 2022 03:13:24 -0400
X-MC-Unique: mvFTcxRuMI2xlxT4UMGsHw-1
Received: by mail-ot1-f69.google.com with SMTP id t11-20020a9d590b000000b00655fad88dacso4589032oth.1
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 00:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5fTVp4OVTG6rY4QVgkRM3QvqSda6IStVSl2Tqf98Buk=;
        b=lItqTUIhP3raRoYUtWl7UAh9PaHkuVl6dvXspQMhY1LegBueriveYgO7Q4224jyyoL
         gPqb9zUSKieoigk5drVzfTYhLGx1emuMor8qwbqNIVTePajXb1RHRQYacqOwgQA5U30W
         ooZP29KFYrXoVWJnLraaiNyPmhEEdGoJZVy9bImKCrBAFDg/hZl8wAJKwof5qb2u9Jb/
         EWwj9mlcSQ2UTO+YxoyPVrcvNtrxYzDWZE6bQwtr5snE53He4Arf7/mjr+xsW53UWhcp
         d9M7je+Aud/TBBPte4DIuJgxlhiV9AcYH0DOfY7ns+Ownv0ALD9O4n5Ksxil4rRV+sXx
         J//g==
X-Gm-Message-State: ACrzQf2znm4NQXj95xtMfOuxsF8DzsKv813I0NdkswjNoVz/8E2skpb6
        fI3bB/tjwj8DlG8T+cUInQ+4hmP6gUrkM2spHRfE/CJD+UwUyN0/rx21utG8WdBBWUjcNKJsoVX
        UO6yW/MdQAPMSjI1XHnRoANQQeHvoMvZc
X-Received: by 2002:a9d:7dcf:0:b0:661:dc25:ba0 with SMTP id k15-20020a9d7dcf000000b00661dc250ba0mr4361013otn.201.1665990804264;
        Mon, 17 Oct 2022 00:13:24 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5w2TQ1qg7Z4fJ33aSGv0yWzwdHUgvvlH9/BUV8fqcqyPkS9/6Fx7DcsIVVM1WRSdFFla4yTMVHdOQ6RYDWT9Y=
X-Received: by 2002:a9d:7dcf:0:b0:661:dc25:ba0 with SMTP id
 k15-20020a9d7dcf000000b00661dc250ba0mr4361008otn.201.1665990804072; Mon, 17
 Oct 2022 00:13:24 -0700 (PDT)
MIME-Version: 1.0
References: <20221014094152.5570-1-lingshan.zhu@intel.com>
In-Reply-To: <20221014094152.5570-1-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 17 Oct 2022 15:13:12 +0800
Message-ID: <CACGkMEu_pKJukgKuPbTksfemRrfFCb9qbu0iVDKx0O8HL-8q1w@mail.gmail.com>
Subject: Re: [PATCH] iproute2/vdpa: Add support for reading device features
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, stephen@networkplumber.org, dsahern@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        hang.yuan@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 5:50 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> This commit implements support for reading vdpa device
> features in iproute2.
>
> Example:
> $ vdpa dev config show vdpa0
> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 4 mtu 1500
>   negotiated_features MRG_RXBUF CTRL_VQ MQ VERSION_1 ACCESS_PLATFORM
>   dev_features MTU MAC MRG_RXBUF CTRL_VQ MQ ANY_LAYOUT VERSION_1 ACCESS_PLATFORM
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

Note that Si Wei proposed to unify the two new attributes:


> ---
>  vdpa/vdpa.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index b73e40b4..89844e92 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -87,6 +87,8 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
>         [VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
>         [VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
>         [VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
> +       [VDPA_ATTR_DEV_FEATURES] = MNL_TYPE_U64,
> +       [VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
>  };
>
>  static int attr_cb(const struct nlattr *attr, void *data)
> @@ -482,7 +484,7 @@ static const char * const *dev_to_feature_str[] = {
>
>  #define NUM_FEATURE_BITS 64
>
> -static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
> +static void print_features(struct vdpa *vdpa, uint64_t features, bool devf,
>                            uint16_t dev_id)
>  {
>         const char * const *feature_strs = NULL;
> @@ -492,7 +494,7 @@ static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
>         if (dev_id < ARRAY_SIZE(dev_to_feature_str))
>                 feature_strs = dev_to_feature_str[dev_id];
>
> -       if (mgmtdevf)
> +       if (devf)
>                 pr_out_array_start(vdpa, "dev_features");
>         else
>                 pr_out_array_start(vdpa, "negotiated_features");
> @@ -771,6 +773,15 @@ static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
>                 val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]);
>                 print_features(vdpa, val_u64, false, dev_id);
>         }
> +       if (tb[VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES]) {
> +               uint16_t dev_id = 0;
> +
> +               if (tb[VDPA_ATTR_DEV_ID])
> +                       dev_id = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_ID]);
> +
> +               val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES]);
> +               print_features(vdpa, val_u64, true, dev_id);
> +       }
>  }
>
>  static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
> --
> 2.31.1
>

