Return-Path: <netdev+bounces-221-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 621246F5FF4
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 22:16:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95258281817
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 20:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81B4ABE5D;
	Wed,  3 May 2023 20:16:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745D9DF44
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 20:16:03 +0000 (UTC)
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E4D9008
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 13:15:31 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-94f7a7a3351so1081230166b.2
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 13:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1683144929; x=1685736929;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lDXPHFc8bD1fIdJW+036nVAJoJcg5BRFBoU1YEshWLU=;
        b=ekURvzXz7isgKnvapcsA97dTtk4w0bwSLfJTc31O22NN/wSYegu7i3TCjn/irNHXEk
         QjITunay8Vl+BNPbe3VGZHRwPIf3LAmQ7rPcYi7ocEp27oqH6T2e4pCZ6v6hVGYlel3D
         X/XL2xNpTfc8Rmd3dJlVT9wFIlPrJpcFRuxRoCDYe2oL5rl5C2bAJGJnsGhbJwf9oPSu
         PLLf0lKSNr4kEckw39ALEHBzED1brCHLr1/rtPsqYDMbHB6gKkf68pOagVGycQMx3U4m
         2V+7rHQCQ12wej8qV73nV2mBBOr1H8mMKH1UzdNoOYna8zmzo/sRd4+5687yLmTZSwfJ
         hNdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683144929; x=1685736929;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lDXPHFc8bD1fIdJW+036nVAJoJcg5BRFBoU1YEshWLU=;
        b=RMi3ZW4bERJJAtk/AhTVaLUcnKSFVNT5+yVtAkmjBfyknaVR6MRTCySJF3y6VAQTeA
         Sk3VKka+/pOGMd8SLyGa8VUimmLO113evHdlupOjJCGeO4PKPlp7rPXshaY5AkpfMws4
         xHLgKA4wZjZgx8c2rclKRxPCF1j+NGVQ92UGo0gS/vRGBePPAGZ/acaR+LIPHS9PpRT2
         LG26rjgzcdesWPVUbG9XaongIjUODs4N18KDbE2q4zOSJPyOQF3QrKpjugzSXPTrvvEL
         wJ2rMqC8m0qCeYvOuYW2tVrfNHuHHOl7dXgoql/gp/HJno/TVw296UTMiq4CQ//KP9X/
         5KZA==
X-Gm-Message-State: AC+VfDwHlDMlT5vTANDTwH+U+mOdUNbzMd5fC0Wez6fi2QylFyk1gmHJ
	RP3AeNVkdScUgeZqCJaKqaM=
X-Google-Smtp-Source: ACHHUZ6atgdKt1NUVDJmIGriCe9/lZ7efnIM0H+Ld1Ov38D0Tiw4EvW/JcgSKk+DT7IkLeubr7w7CQ==
X-Received: by 2002:a17:906:9c84:b0:94e:1069:151d with SMTP id fj4-20020a1709069c8400b0094e1069151dmr5283585ejc.10.1683144929258;
        Wed, 03 May 2023 13:15:29 -0700 (PDT)
Received: from tycho (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id vv1-20020a170907a68100b00957278cfb2dsm16338923ejc.79.2023.05.03.13.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 13:15:28 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
Date: Wed, 3 May 2023 22:15:27 +0200
From: Zahari Doychev <zahari.doychev@linux.com>
To: Ido Schimmel <idosch@idosch.org>
Cc: netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com, 
	jiri@resnulli.us, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, hmehrtens@maxlinear.com, aleksander.lobakin@intel.com, 
	simon.horman@corigine.com, Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v4 2/3] net: flower: add support for matching
 cfm fields
Message-ID: <j6nx4m5li4lazpm5garenctjpyftsqva4x3jd27mdgb4qti3xs@dvrgcqm24hbx>
References: <20230425211630.698373-1-zahari.doychev@linux.com>
 <20230425211630.698373-3-zahari.doychev@linux.com>
 <ZE6AFQuv+yi7RxUL@shredder>
 <yabevxsc5uqezsjwjalqbnliu2yspl3v2drspd5a6a76nxdjon@47q7jzo2r3bl>
 <ZE9ij6it2lvS0SFB@shredder>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZE9ij6it2lvS0SFB@shredder>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 01, 2023 at 09:56:15AM +0300, Ido Schimmel wrote:
> On Sun, Apr 30, 2023 at 06:35:13PM +0200, Zahari Doychev wrote:
> > On Sun, Apr 30, 2023 at 05:49:57PM +0300, Ido Schimmel wrote:
> > > On Tue, Apr 25, 2023 at 11:16:29PM +0200, Zahari Doychev wrote:
> > > > +static const struct nla_policy cfm_opt_policy[TCA_FLOWER_KEY_CFM_OPT_MAX] = {
> > > > +	[TCA_FLOWER_KEY_CFM_MD_LEVEL]	= NLA_POLICY_MAX(NLA_U8, 7),
> > > 
> > > Instead of 7, can you use FIELD_MAX(FLOW_DIS_CFM_MDL_MASK) like you did
> > > in the previous version?
> > > 
> > 
> > It seems that the macro can be use only inside functions. I wanted to use it
> > but I was getting the following error:
> > 
> > linux/include/linux/bitfield.h:86:9: error: braced-group within expression allowed only inside a function
> 
> I see. Another option that I personally find better than hard-coding 7
> is the below:

I was thinking about the same. I will change it in the next version.

Thanks,
Zahari

> 
> diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> index 479b66b11d2d..52f30906b210 100644
> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -317,6 +317,7 @@ struct flow_dissector_key_cfm {
>  };
>  
>  #define FLOW_DIS_CFM_MDL_MASK GENMASK(7, 5)
> +#define FLOW_DIS_CFM_MDL_MAX 7
>  
>  enum flow_dissector_key_id {
>         FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 5d77da484a88..85fc77063866 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -772,7 +772,8 @@ mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
>  };
>  
>  static const struct nla_policy cfm_opt_policy[TCA_FLOWER_KEY_CFM_OPT_MAX] = {
> -       [TCA_FLOWER_KEY_CFM_MD_LEVEL]   = NLA_POLICY_MAX(NLA_U8, 7),
> +       [TCA_FLOWER_KEY_CFM_MD_LEVEL]   = NLA_POLICY_MAX(NLA_U8,
> +                                                        FLOW_DIS_CFM_MDL_MAX),
>         [TCA_FLOWER_KEY_CFM_OPCODE]     = { .type = NLA_U8 },
>  };

