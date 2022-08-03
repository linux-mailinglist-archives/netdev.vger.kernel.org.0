Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265DA588B10
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 13:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbiHCLYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 07:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiHCLYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 07:24:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6A841CFEB
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 04:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659525843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3FOcvqJbUoGHDDUFPqQYrb80yq1QgKC3KQgj7v11X3w=;
        b=cOtz+O67Fd26DcIgwP4UoKMdZZTvrFM24fywoocUG5+jDiDs5dHN1bwKKAA3g2YoOsSEHP
        4yG85xq2cqq+lWFDGT/sdqOpInhKQPZ3aFh16ZhlLJ8W92BuD7KzvCDcVXm2uaczjg6HOD
        z9eimZLlpqXLbcroTv24N09XGapefJk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-IF9MAhFVMmOz_o26xpfPKg-1; Wed, 03 Aug 2022 07:24:02 -0400
X-MC-Unique: IF9MAhFVMmOz_o26xpfPKg-1
Received: by mail-qt1-f200.google.com with SMTP id e3-20020ac84b43000000b0033efb06a30aso619258qts.22
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 04:24:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3FOcvqJbUoGHDDUFPqQYrb80yq1QgKC3KQgj7v11X3w=;
        b=oKTiUJlm+hrkxTHp763APuZz9gBkQeu1T1H9V2QqcLyI1CegmpbhYATQ3oXm5CSi7v
         Zy0MapEg++hyCsWcys3U0qQDHFYYO8UdGLFD3zLTzSJ/OBAMS4+A29m5Aid2vBFFFCC/
         CT8GSnyYeR2G2H8nWOOaY1/9JPHaMUW0Xl1M4YtvtaM5kcZjIx7nMYjKYFPowYh5x+4n
         TzTJ2JsOCFzFNS6GGBFKqHcyB/JBK4Pa8038lLCiIA/0dzuvLssokOkl0ctoQwR8Qiq/
         WphWHcs3bSAx751/4eEeejMr8LcFrB0HWFDlTtS//kb6n/OvLOMMT5lQLkNkMoQYoBfS
         sT1Q==
X-Gm-Message-State: AJIora/MjN3N1lJHeB0NVoK7o07pZnSxlrWk//vYyzP0WoJEcHtajf5e
        IDhsnFZ2762+jHKMIS5zfwfzWvKflXkk1MZ5F99+uMu5uZp4ZO65Pe6bXUCAak/tC1TExZuFqtN
        33XX6a3dtDR5PAMA3
X-Received: by 2002:a05:622a:247:b0:31f:1ede:840b with SMTP id c7-20020a05622a024700b0031f1ede840bmr21715038qtx.564.1659525841368;
        Wed, 03 Aug 2022 04:24:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tz5KSr5SVrnhkcL1Hcg5mE7G3xX8TvBx1o0yHreZukVEWfYCkszcC3wldnfhHBqw0mSOSLXA==
X-Received: by 2002:a05:622a:247:b0:31f:1ede:840b with SMTP id c7-20020a05622a024700b0031f1ede840bmr21715005qtx.564.1659525841139;
        Wed, 03 Aug 2022 04:24:01 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id m26-20020ac866da000000b00339163a06fcsm3147288qtp.6.2022.08.03.04.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 04:24:00 -0700 (PDT)
Date:   Wed, 3 Aug 2022 13:23:54 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Matthias May <matthias.may@westermo.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        maord@nvidia.com, lariel@nvidia.com, vladbu@nvidia.com,
        cmi@nvidia.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-rdma@vger.kernel.org, nicolas.dichtel@6wind.com,
        eyal.birger@gmail.com, jesse@nicira.com, linville@tuxdriver.com,
        daniel@iogearbox.net, hadarh@mellanox.com, ogerlitz@mellanox.com,
        willemb@google.com, martin.varghese@nokia.com
Subject: Re: [PATCH v2 net 1/4] geneve: do not use RT_TOS for IPv6 flowlabel
Message-ID: <20220803112354.GA29408@pc-4.home>
References: <20220802120935.1363001-1-matthias.may@westermo.com>
 <20220802120935.1363001-2-matthias.may@westermo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802120935.1363001-2-matthias.may@westermo.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 02:09:32PM +0200, Matthias May wrote:
> According to Guillaume Nault RT_TOS should never be used for IPv6.

While I obviously agree with this statement, I don't think it brings
much information to other people reading the commit message. Even
though the cover letter has more information, it won't be immediately
available to people reading the patch. Also the cover letter will be
lost if the patch gets picked up for the -stable trees.

Appart from that, I'm fine with the patch of course.

> Fixes: 3a56f86f1be6a ("geneve: handle ipv6 priority like ipv4 tos")
> Signed-off-by: Matthias May <matthias.may@westermo.com>
> ---
> v1 -> v2:
>  - Fix spacing of "Fixes" tag.
>  - Add missing CCs
> ---
>  drivers/net/geneve.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> index 4c380c06f178..e1a4480e6f17 100644
> --- a/drivers/net/geneve.c
> +++ b/drivers/net/geneve.c
> @@ -877,8 +877,7 @@ static struct dst_entry *geneve_get_v6_dst(struct sk_buff *skb,
>  		use_cache = false;
>  	}
>  
> -	fl6->flowlabel = ip6_make_flowinfo(RT_TOS(prio),
> -					   info->key.label);
> +	fl6->flowlabel = ip6_make_flowinfo(prio, info->key.label);
>  	dst_cache = (struct dst_cache *)&info->dst_cache;
>  	if (use_cache) {
>  		dst = dst_cache_get_ip6(dst_cache, &fl6->saddr);
> -- 
> 2.35.1
> 

