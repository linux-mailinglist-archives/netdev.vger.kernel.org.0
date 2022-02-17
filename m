Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D714B9C1D
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 10:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238735AbiBQJg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 04:36:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiBQJgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 04:36:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6050813CE9
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 01:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645090598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B+N27hwfG1S57FWUNj3G4z//wMJ/xVpoK9HEsMi21xM=;
        b=QE7leN+fSGHF3Jj1+cJcDGVuTslGEfDidVq8vPAFwKvo1IVMowSg/3ZtVZrh8DIi+G/zrt
        JUAgca5orXx9c8H5iEpjVvx+H5a0UtEDR2RbADNckT9ry7PApIrNC6Ig4sI3vRdrO7ZkHS
        I0jcky94h60bAeNaqchLdF7eFgj7s/Q=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-ozA5eEovOeqmhC5OgurfOg-1; Thu, 17 Feb 2022 04:36:37 -0500
X-MC-Unique: ozA5eEovOeqmhC5OgurfOg-1
Received: by mail-qv1-f72.google.com with SMTP id gi11-20020a056214248b00b0042c2cc3c1b9so4676656qvb.9
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 01:36:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=B+N27hwfG1S57FWUNj3G4z//wMJ/xVpoK9HEsMi21xM=;
        b=nMzZ5wcq9jhntLED0HRnwn4ld+kiHbYKfHhueHpEeLuUa0hjc0ylCcB5z4mAYUhhlx
         xYGDWQw4JEdPZZT8dd6B4H/vgly9zctL9U25rkq+U7zRR01eZ3fIzEC3p444q5vrsh2P
         8Nutwo95tIGGsZAzx/6o0qZz2P3fSL/wFlw400Y4jRqNZqWyOQBEE7kvsT5k+XepwOne
         b8sggo42+qSJwPMB2HwDvJnYgzjzmewM4Nf/6gOSZiFLGseU3LfQVKXtMuERgh24Vap8
         4mR5rmWq5q0TWz/HZ598h1DfUvCs8nt68rF0i7tAGWlO47GpHuPELDii/seElSzz3GZG
         VSEQ==
X-Gm-Message-State: AOAM531NF+dAlgdChPLmT52QrpXnguu41Dk3OqCIZflG7qseMXt5/bUy
        D2/hYgNrDoLSzHHLJnTYJIvY3AB9+bYKsQYyFtvUbjCJSC15tgDMGBuJfQFb8FIeNoz8ESyPmp0
        EX5sM/6JwQc8+qcDX
X-Received: by 2002:ad4:5e8b:0:b0:42d:6b:2333 with SMTP id jl11-20020ad45e8b000000b0042d006b2333mr1183652qvb.93.1645090596614;
        Thu, 17 Feb 2022 01:36:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyaMpB9NRiJQNqgxcMPS9raDRUXc6yL1/7iIPhsVoRKxKch7t5UgcFOay1brdaQiTgEQD85wQ==
X-Received: by 2002:ad4:5e8b:0:b0:42d:6b:2333 with SMTP id jl11-20020ad45e8b000000b0042d006b2333mr1183646qvb.93.1645090596367;
        Thu, 17 Feb 2022 01:36:36 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-112-206.dyn.eolo.it. [146.241.112.206])
        by smtp.gmail.com with ESMTPSA id y21sm1691083qtn.62.2022.02.17.01.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 01:36:35 -0800 (PST)
Message-ID: <f7fe09cfe1a88e3f5fcc6eb0c1287e6a04c06d46.camel@redhat.com>
Subject: Re: [PATCH net-next v2] net: gro: Fix a 'directive in macro's
 argument list' sparse warning
From:   Paolo Abeni <pabeni@redhat.com>
To:     Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Date:   Thu, 17 Feb 2022 10:36:32 +0100
In-Reply-To: <20220217080755.19195-1-gal@nvidia.com>
References: <20220217080755.19195-1-gal@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-02-17 at 10:07 +0200, Gal Pressman wrote:
> Following the cited commit, sparse started complaining about:
> ../include/net/gro.h:58:1: warning: directive in macro's argument list
> ../include/net/gro.h:59:1: warning: directive in macro's argument list
> 
> Fix that by moving the defines out of the struct_group() macro.
> 
> Fixes: de5a1f3ce4c8 ("net: gro: minor optimization for dev_gro_receive()")
> Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> Acked-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
> Changelog -
> v1->v2: https://lore.kernel.org/netdev/20220216103100.9489-1-gal@nvidia.com/
> * Add a comment and fix alignment
> ---
>  include/net/gro.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/gro.h b/include/net/gro.h
> index a765fedda5c4..867656b0739c 100644
> --- a/include/net/gro.h
> +++ b/include/net/gro.h
> @@ -35,6 +35,9 @@ struct napi_gro_cb {
>  	/* jiffies when first packet was created/queued */
>  	unsigned long age;
>  
> +/* Used in napi_gro_cb::free */
> +#define NAPI_GRO_FREE             1
> +#define NAPI_GRO_FREE_STOLEN_HEAD 2
>  	/* portion of the cb set to zero at every gro iteration */
>  	struct_group(zeroed,
>  
> @@ -55,8 +58,6 @@ struct napi_gro_cb {
>  
>  		/* Free the skb? */
>  		u8	free:2;
> -#define NAPI_GRO_FREE		  1
> -#define NAPI_GRO_FREE_STOLEN_HEAD 2
>  
>  		/* Used in foo-over-udp, set in udp[46]_gro_receive */
>  		u8	is_ipv6:1;

LGTM, thanks!

Acked-by: Paolo Abeni <pabeni@redhat.com>

