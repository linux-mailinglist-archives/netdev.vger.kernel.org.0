Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDB06F2984
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 18:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjD3QfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 12:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjD3QfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 12:35:19 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47731992
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 09:35:17 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-50bc34b98edso875179a12.3
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 09:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1682872516; x=1685464516;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T8IcPHHbYbm6imoBTgrOuHJCS1nwhdxYUgIib86VhAs=;
        b=KYJjeVKvhqsIS/kq5RYw0yLSYDl5l0qa7tMXNsbPa57LXs+86T+0CJZZ9zndKHT18e
         apDyMglatKheLnVT4/4xdvdZHdl1upTHakT16U1h+DwGh+VPigmIYFNbwf/2k1kBP7DG
         7Kraeq/FgSI20f0PMsbp6QitYZ9IrN2tBwQQ4zXbQe3EPlmV0mG4ZHYlH1RRVz8XNa53
         5l3VyAdcndgehXsiR7FCENv7WpTEOI2kFYWEGuTat9biNbOeFvk2/SA3uLfIDT2Qf3dI
         vFBQlKHGTcfF5AmMeNm7jVdH9afp12ACYcrIwBk7+COIJbE8g+byo1B4z6oYl3liiNOp
         /npg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682872516; x=1685464516;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T8IcPHHbYbm6imoBTgrOuHJCS1nwhdxYUgIib86VhAs=;
        b=lpczLPHQ36QhSpMg1hvAsI+eIFhoYeoZdfOXip8VG68F5hlJJQvSyr4hR1y8nSgRsK
         NjfRvE3MdqOPN1WDpdIe8EDF+uzZB/VCV26rga6HACZ0oeFcEIabxOuKkryr9jSqDCiy
         JkrZjtkTt2Fcujo0+zC4kaHEG3cAN2/zrJFmz+buu91aswmY21qqqWwaVg0MCCoEernK
         6cOL3NNkqpP4DBdAO2BlcJv05/c/qPvi7E5y1X0STOdBy470zISrQGY5tweiufzrSdVV
         dlBkwFojOp/8jrav4RBnsYZiVEnFuvnA2fNDhZUCJ95aE3xB6ar0r33VcOzaHbmr6aC/
         wG1A==
X-Gm-Message-State: AC+VfDy1qJ4tInkVc45/FKetkB6D561dQKui9s2VMEcIYLJf8GTH7pV0
        1Cys7iQDqf1nHQN3n4czU74=
X-Google-Smtp-Source: ACHHUZ7yQ6JbXQWI34aHV05Ufy3sQ0V/AuZ8rJGvmZWfc3S3ESFNynmDSY2vkiNkR2og10zMfl3gFA==
X-Received: by 2002:a05:6402:190:b0:508:5062:8d8c with SMTP id r16-20020a056402019000b0050850628d8cmr3805961edv.22.1682872515897;
        Sun, 30 Apr 2023 09:35:15 -0700 (PDT)
Received: from tycho (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id bf18-20020a0564021a5200b00506b88e4f17sm11243693edb.68.2023.04.30.09.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 09:35:15 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
Date:   Sun, 30 Apr 2023 18:35:13 +0200
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v4 2/3] net: flower: add support for matching
 cfm fields
Message-ID: <yabevxsc5uqezsjwjalqbnliu2yspl3v2drspd5a6a76nxdjon@47q7jzo2r3bl>
References: <20230425211630.698373-1-zahari.doychev@linux.com>
 <20230425211630.698373-3-zahari.doychev@linux.com>
 <ZE6AFQuv+yi7RxUL@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZE6AFQuv+yi7RxUL@shredder>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 30, 2023 at 05:49:57PM +0300, Ido Schimmel wrote:
> On Tue, Apr 25, 2023 at 11:16:29PM +0200, Zahari Doychev wrote:
> > diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> > index cc49256d5318..5d77da484a88 100644
> > --- a/net/sched/cls_flower.c
> > +++ b/net/sched/cls_flower.c
> > @@ -11,6 +11,7 @@
> >  #include <linux/rhashtable.h>
> >  #include <linux/workqueue.h>
> >  #include <linux/refcount.h>
> > +#include <linux/bitfield.h>
> >  
> >  #include <linux/if_ether.h>
> >  #include <linux/in6.h>
> > @@ -71,6 +72,7 @@ struct fl_flow_key {
> >  	struct flow_dissector_key_num_of_vlans num_of_vlans;
> >  	struct flow_dissector_key_pppoe pppoe;
> >  	struct flow_dissector_key_l2tpv3 l2tpv3;
> > +	struct flow_dissector_key_cfm cfm;
> >  } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
> >  
> >  struct fl_flow_mask_range {
> > @@ -720,7 +722,7 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
> >  	[TCA_FLOWER_KEY_PPPOE_SID]	= { .type = NLA_U16 },
> >  	[TCA_FLOWER_KEY_PPP_PROTO]	= { .type = NLA_U16 },
> >  	[TCA_FLOWER_KEY_L2TPV3_SID]	= { .type = NLA_U32 },
> > -
> > +	[TCA_FLOWER_KEY_CFM]		= { .type = NLA_NESTED },
> 
> "fl_policy" is used with nla_parse_nested_deprecated(). You can enable
> strict validation for new attributes using the following diff:
> 
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index fc9037685458..6bccfc1722ad 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -615,7 +615,8 @@ static void *fl_get(struct tcf_proto *tp, u32 handle)
>  }
>  
>  static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
> -       [TCA_FLOWER_UNSPEC]             = { .type = NLA_UNSPEC },
> +       [TCA_FLOWER_UNSPEC]             = { .strict_start_type =
> +                                               TCA_FLOWER_KEY_CFM },
>         [TCA_FLOWER_CLASSID]            = { .type = NLA_U32 },
>         [TCA_FLOWER_INDEV]              = { .type = NLA_STRING,
>                                             .len = IFNAMSIZ },
> 
> >  };

thanks, noted.

> >  
> >  static const struct nla_policy
> > @@ -769,6 +771,11 @@ mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
> >  	[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL]    = { .type = NLA_U32 },
> >  };
> >  
> > +static const struct nla_policy cfm_opt_policy[TCA_FLOWER_KEY_CFM_OPT_MAX] = {
> > +	[TCA_FLOWER_KEY_CFM_MD_LEVEL]	= NLA_POLICY_MAX(NLA_U8, 7),
> 
> Instead of 7, can you use FIELD_MAX(FLOW_DIS_CFM_MDL_MASK) like you did
> in the previous version?
> 

It seems that the macro can be use only inside functions. I wanted to use it
but I was getting the following error:

linux/include/linux/bitfield.h:86:9: error: braced-group within expression allowed only inside a function

thanks
Zahari

> > +	[TCA_FLOWER_KEY_CFM_OPCODE]	= { .type = NLA_U8 },
> > +};
