Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8529E4D4375
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 10:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240794AbiCJJ1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 04:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240755AbiCJJ1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 04:27:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C6BF139CDD
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 01:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646904374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OCsR0r9uS0wgpc8xxw/kTKmIAo73y9wex4vgN/HieVo=;
        b=VfqylWyKhthe2dF9i6R3KY3Sn7SFOMiHGC5sQwZZPhsPpq/0fBgSNyH544DOfziYECEI53
        kiYxXMpVi8jVoc9GBCZXKFmNxrYd77w7wyBvwnNzTZs/fgGx0F30jc0oC23uChgqU49eIT
        JGk9m4dzRUq7w8FLbDwwg1/sun46v0s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-eLsmJ7jTMJe190wNva_bqA-1; Thu, 10 Mar 2022 04:26:12 -0500
X-MC-Unique: eLsmJ7jTMJe190wNva_bqA-1
Received: by mail-wm1-f69.google.com with SMTP id a26-20020a7bc1da000000b003857205ec7cso2064238wmj.2
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 01:26:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=OCsR0r9uS0wgpc8xxw/kTKmIAo73y9wex4vgN/HieVo=;
        b=RZhev6bHc7GVq+IsItMbrzQan21q7R3aY1ExSe1gQFdkG0pWifufphCnW/h0u2RNWF
         qax2TNwOKuVoGWKyAypeI6c2kLN6bHOLLkt/s/AUo87Vu6RPoopMw1vXgo16+2fD75Zg
         Nx6eBWOvXmLAEwZxNLdGrHStO71okknq3JPXFXEUvilhZloLaeWj8SPhIONAmwMES8ZN
         3L07ffYlRn/Qw2locZcCHMnC7EEiEOxMIxWCoxnfPZvXH/VCnGVidxEGaZwbv9JtMp8E
         kqgM/ueHD04l5heOOitfcheh4fT1sh402C/nSsO976pKor3cbiGi/l10P4GNfu0yQQs9
         kXjA==
X-Gm-Message-State: AOAM531eYBAzkhm/FVuFZueWu8KjfoSzjclKi0tSDvt94obzVMRWjozH
        Lyr3j3eLNUfNHZfRSkrDgKvbWKOxxJspzjdX6VnzK1WSPwsPdfzLHSDQO42Oeeq+aRr/+LlAL8z
        FuTcff6IJ9DXZHTfp
X-Received: by 2002:adf:816b:0:b0:203:7fae:a245 with SMTP id 98-20020adf816b000000b002037faea245mr2833106wrm.619.1646904371560;
        Thu, 10 Mar 2022 01:26:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJykeDfBmALn7dIgdVWbFGi07euJkbCT4FwSTVtZq4BSuVbDf0QRpoCOthhfLeTEVLVQW8SAKA==
X-Received: by 2002:adf:816b:0:b0:203:7fae:a245 with SMTP id 98-20020adf816b000000b002037faea245mr2833092wrm.619.1646904371304;
        Thu, 10 Mar 2022 01:26:11 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id u14-20020adfed4e000000b001e3323611e5sm3531633wro.26.2022.03.10.01.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 01:26:10 -0800 (PST)
Message-ID: <813acfa36558d355e6b56b17bd6bce1c67f77296.camel@redhat.com>
Subject: Re: [PATCH v2 net-next] net: add per-cpu storage and net->core_stats
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        jeffreyji <jeffreyji@google.com>,
        Brian Vazquez <brianvv@google.com>
Date:   Thu, 10 Mar 2022 10:26:09 +0100
In-Reply-To: <20220310004603.543196-1-eric.dumazet@gmail.com>
References: <20220310004603.543196-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2022-03-09 at 16:46 -0800, Eric Dumazet wrote:
> @@ -10282,6 +10282,24 @@ void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
>  }
>  EXPORT_SYMBOL(netdev_stats_to_stats64);
>  
> +struct net_device_core_stats *netdev_core_stats_alloc(struct net_device *dev)
> +{
> +	struct net_device_core_stats __percpu *p;
> +
> +	p = alloc_percpu_gfp(struct net_device_core_stats,
> +			     GFP_ATOMIC | __GFP_NOWARN);
> +
> +	if (p && cmpxchg(&dev->core_stats, NULL, p))
> +		free_percpu(p);
> +
> +	p = dev->core_stats;

Don't we need a READ_ONCE() here? if the allocation fails (!p) there is
no memory barrier.

Thanks!

Paolo

