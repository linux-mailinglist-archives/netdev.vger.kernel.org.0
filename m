Return-Path: <netdev+bounces-8512-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45D9B72464D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:37:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00CB1280D5F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC101DF51;
	Tue,  6 Jun 2023 14:37:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1D0633
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 14:37:15 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE26D10DE
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:37:10 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-5147f7d045bso9014315a12.2
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 07:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1686062229; x=1688654229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p4LxxvlEvUcL1/sPjxRkKkMMHp6nr6k7ynxUzNeTYNU=;
        b=KCP5O8k71N2VtgVTyFlzquFzZx1fY5QbzPUPs32/Xp2HQTM9VsOjP6fb7bxPewFZKj
         /CSnvbWP9f7N5F3UCNbTevQiGzCzQ2hFe1AFRxznvIbx0YSIxDantAMTU5QP7exqKB0e
         s4az/2+GHferYJS569aGBxkUuWpL0p426layxtscNheSJUmd/08IiXb59gknPiZC07bp
         DSH7s/rxxm8fpWcDNyGR3CL7kmqltRlvYBrk0ML1sFBLoSvfGf7hujzbL5+P6spTcOOA
         Iy3+cMkcaFvIXgvYylgdWkl46RkHpExVbmwzBPQqnKzqR5cF0Ann9WwgH8oz1Cjyfbxk
         H4SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686062229; x=1688654229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p4LxxvlEvUcL1/sPjxRkKkMMHp6nr6k7ynxUzNeTYNU=;
        b=CS2xrBhht40YGZ0jx+TcSrRQ5pCEHVZZepJzz2pfZPHM78zm7WetIrRTom6I5UJuY5
         FifPCePU0fHR/ObO/7z7NvuRB/O3c5CMLLML1+mv5naJky+hC2UKG4s5/BBFsgRudWfO
         hlY5pvyZfCIj39aR/f4mUKjUzSBssYDPlBfgB46QZOAjHfP4R4s6SitZi0GdaTJwFYdZ
         LGbuQl4QGCJdyMhYIjKAabQngmQtK2IKWKg7cvtXCGEqxsnMBWHVPzkPB3QNVKnsKuCp
         wEs7kN4h5ursL6frqifvLpkVn6PY4TkL9Iog7u4nVSjrbdm1zTEAfFINTKSpbYvcmKzv
         eAHw==
X-Gm-Message-State: AC+VfDzPesrLaOuh7uktCR2SK2XOGEgDa0pi9/BavP+NFrj8WFOAhAEW
	OYCYK+A0If0VoDm/GChZTok=
X-Google-Smtp-Source: ACHHUZ57GjSJlHWRc/gqC7FyFMqqqzHyEAlSTCzKS+eAFLlJcDjz41WXcDYU5raliL5ransjNKQvqQ==
X-Received: by 2002:aa7:d8cd:0:b0:514:9eda:6f1d with SMTP id k13-20020aa7d8cd000000b005149eda6f1dmr2350031eds.20.1686062228722;
        Tue, 06 Jun 2023 07:37:08 -0700 (PDT)
Received: from tycho (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id i15-20020aa7dd0f000000b005163a6c9f18sm5121831edv.53.2023.06.06.07.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 07:37:08 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
Date: Tue, 6 Jun 2023 16:37:06 +0200
From: Zahari Doychev <zahari.doychev@linux.com>
To: Ido Schimmel <idosch@idosch.org>
Cc: netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com, 
	jiri@resnulli.us, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, hmehrtens@maxlinear.com, aleksander.lobakin@intel.com, 
	simon.horman@corigine.com, Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v5 2/3] net: flower: add support for matching
 cfm fields
Message-ID: <bjx6dm2d57fnlfjbc2mij2i4xaw673pn7gizql4nfbo2pyjedv@o4vhjb6cgfdb>
References: <20230604115825.2739031-1-zahari.doychev@linux.com>
 <20230604115825.2739031-3-zahari.doychev@linux.com>
 <ZH2Qd0UwIUTPBSWc@shredder>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH2Qd0UwIUTPBSWc@shredder>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 10:36:23AM +0300, Ido Schimmel wrote:
> On Sun, Jun 04, 2023 at 01:58:24PM +0200, Zahari Doychev wrote:
> > From: Zahari Doychev <zdoychev@maxlinear.com>
> > 
> > Add support to the tc flower classifier to match based on fields in CFM
> > information elements like level and opcode.
> > 
> > tc filter add dev ens6 ingress protocol 802.1q \
> > 	flower vlan_id 698 vlan_ethtype 0x8902 cfm mdl 5 op 46 \
> > 	action drop
> > 
> > Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > ---
> >  include/uapi/linux/pkt_cls.h |   9 ++
> >  net/sched/cls_flower.c       | 195 ++++++++++++++++++++++++++---------
> >  2 files changed, 158 insertions(+), 46 deletions(-)
> > 
> > diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> > index 00933dda7b10..7865f5a9885b 100644
> > --- a/include/uapi/linux/pkt_cls.h
> > +++ b/include/uapi/linux/pkt_cls.h
> > @@ -596,6 +596,8 @@ enum {
> >  
> >  	TCA_FLOWER_L2_MISS,		/* u8 */
> >  
> > +	TCA_FLOWER_KEY_CFM,		/* nested */
> > +
> >  	__TCA_FLOWER_MAX,
> >  };
> >  
> > @@ -704,6 +706,13 @@ enum {
> >  	TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST = (1 << 1),
> >  };
> >  
> > +enum {
> > +	TCA_FLOWER_KEY_CFM_OPT_UNSPEC,
> > +	TCA_FLOWER_KEY_CFM_MD_LEVEL,
> > +	TCA_FLOWER_KEY_CFM_OPCODE,
> > +	TCA_FLOWER_KEY_CFM_OPT_MAX,
> > +};
> > +
> >  #define TCA_FLOWER_MASK_FLAGS_RANGE	(1 << 0) /* Range-based match */
> >  
> >  /* Match-all classifier */
> > diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> > index e02ecabbb75c..b32f5423721b 100644
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
> > @@ -617,6 +619,58 @@ static void *fl_get(struct tcf_proto *tp, u32 handle)
> >  	return __fl_get(head, handle);
> >  }
> >  
> > +static const struct nla_policy
> > +enc_opts_policy[TCA_FLOWER_KEY_ENC_OPTS_MAX + 1] = {
> > +	[TCA_FLOWER_KEY_ENC_OPTS_UNSPEC]        = {
> > +		.strict_start_type = TCA_FLOWER_KEY_ENC_OPTS_VXLAN },
> > +	[TCA_FLOWER_KEY_ENC_OPTS_GENEVE]        = { .type = NLA_NESTED },
> > +	[TCA_FLOWER_KEY_ENC_OPTS_VXLAN]         = { .type = NLA_NESTED },
> > +	[TCA_FLOWER_KEY_ENC_OPTS_ERSPAN]        = { .type = NLA_NESTED },
> > +	[TCA_FLOWER_KEY_ENC_OPTS_GTP]		= { .type = NLA_NESTED },
> > +};
> > +
> > +static const struct nla_policy
> > +geneve_opt_policy[TCA_FLOWER_KEY_ENC_OPT_GENEVE_MAX + 1] = {
> > +	[TCA_FLOWER_KEY_ENC_OPT_GENEVE_CLASS]      = { .type = NLA_U16 },
> > +	[TCA_FLOWER_KEY_ENC_OPT_GENEVE_TYPE]       = { .type = NLA_U8 },
> > +	[TCA_FLOWER_KEY_ENC_OPT_GENEVE_DATA]       = { .type = NLA_BINARY,
> > +						       .len = 128 },
> > +};
> > +
> > +static const struct nla_policy
> > +vxlan_opt_policy[TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX + 1] = {
> > +	[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP]         = { .type = NLA_U32 },
> > +};
> > +
> > +static const struct nla_policy
> > +erspan_opt_policy[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX + 1] = {
> > +	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER]        = { .type = NLA_U8 },
> > +	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX]      = { .type = NLA_U32 },
> > +	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR]        = { .type = NLA_U8 },
> > +	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID]       = { .type = NLA_U8 },
> > +};
> > +
> > +static const struct nla_policy
> > +gtp_opt_policy[TCA_FLOWER_KEY_ENC_OPT_GTP_MAX + 1] = {
> > +	[TCA_FLOWER_KEY_ENC_OPT_GTP_PDU_TYPE]	   = { .type = NLA_U8 },
> > +	[TCA_FLOWER_KEY_ENC_OPT_GTP_QFI]	   = { .type = NLA_U8 },
> > +};
> > +
> > +static const struct nla_policy
> > +mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
> > +	[TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH]    = { .type = NLA_U8 },
> > +	[TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL]      = { .type = NLA_U8 },
> > +	[TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS]      = { .type = NLA_U8 },
> > +	[TCA_FLOWER_KEY_MPLS_OPT_LSE_TC]       = { .type = NLA_U8 },
> > +	[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL]    = { .type = NLA_U32 },
> > +};
> > +
> > +static const struct nla_policy cfm_opt_policy[TCA_FLOWER_KEY_CFM_OPT_MAX] = {
> > +	[TCA_FLOWER_KEY_CFM_MD_LEVEL]	= NLA_POLICY_MAX(NLA_U8,
> > +						FLOW_DIS_CFM_MDL_MAX),
> > +	[TCA_FLOWER_KEY_CFM_OPCODE]	= { .type = NLA_U8 },
> > +};
> > +
> >  static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
> >  	[TCA_FLOWER_UNSPEC]		= { .strict_start_type =
> >  						TCA_FLOWER_L2_MISS },
> > @@ -725,52 +779,7 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
> >  	[TCA_FLOWER_KEY_PPP_PROTO]	= { .type = NLA_U16 },
> >  	[TCA_FLOWER_KEY_L2TPV3_SID]	= { .type = NLA_U32 },
> >  	[TCA_FLOWER_L2_MISS]		= NLA_POLICY_MAX(NLA_U8, 1),
> > -};
> > -
> > -static const struct nla_policy
> > -enc_opts_policy[TCA_FLOWER_KEY_ENC_OPTS_MAX + 1] = {
> > -	[TCA_FLOWER_KEY_ENC_OPTS_UNSPEC]        = {
> > -		.strict_start_type = TCA_FLOWER_KEY_ENC_OPTS_VXLAN },
> > -	[TCA_FLOWER_KEY_ENC_OPTS_GENEVE]        = { .type = NLA_NESTED },
> > -	[TCA_FLOWER_KEY_ENC_OPTS_VXLAN]         = { .type = NLA_NESTED },
> > -	[TCA_FLOWER_KEY_ENC_OPTS_ERSPAN]        = { .type = NLA_NESTED },
> > -	[TCA_FLOWER_KEY_ENC_OPTS_GTP]		= { .type = NLA_NESTED },
> > -};
> > -
> > -static const struct nla_policy
> > -geneve_opt_policy[TCA_FLOWER_KEY_ENC_OPT_GENEVE_MAX + 1] = {
> > -	[TCA_FLOWER_KEY_ENC_OPT_GENEVE_CLASS]      = { .type = NLA_U16 },
> > -	[TCA_FLOWER_KEY_ENC_OPT_GENEVE_TYPE]       = { .type = NLA_U8 },
> > -	[TCA_FLOWER_KEY_ENC_OPT_GENEVE_DATA]       = { .type = NLA_BINARY,
> > -						       .len = 128 },
> > -};
> > -
> > -static const struct nla_policy
> > -vxlan_opt_policy[TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX + 1] = {
> > -	[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP]         = { .type = NLA_U32 },
> > -};
> > -
> > -static const struct nla_policy
> > -erspan_opt_policy[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX + 1] = {
> > -	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER]        = { .type = NLA_U8 },
> > -	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX]      = { .type = NLA_U32 },
> > -	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR]        = { .type = NLA_U8 },
> > -	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID]       = { .type = NLA_U8 },
> > -};
> > -
> > -static const struct nla_policy
> > -gtp_opt_policy[TCA_FLOWER_KEY_ENC_OPT_GTP_MAX + 1] = {
> > -	[TCA_FLOWER_KEY_ENC_OPT_GTP_PDU_TYPE]	   = { .type = NLA_U8 },
> > -	[TCA_FLOWER_KEY_ENC_OPT_GTP_QFI]	   = { .type = NLA_U8 },
> > -};
> > -
> > -static const struct nla_policy
> > -mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
> > -	[TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH]    = { .type = NLA_U8 },
> > -	[TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL]      = { .type = NLA_U8 },
> > -	[TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS]      = { .type = NLA_U8 },
> > -	[TCA_FLOWER_KEY_MPLS_OPT_LSE_TC]       = { .type = NLA_U8 },
> > -	[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL]    = { .type = NLA_U32 },
> > +	[TCA_FLOWER_KEY_CFM]		= NLA_POLICY_NESTED(cfm_opt_policy),
> 
> I didn't suggest NLA_POLICY_NESTED() in previous versions because:
> 
> 1. The code churn in this patch where different policies need to be
> relocated.
> 
> 2. AFAIK, rtnetlink does not support policy dump (unlike genl) which
> makes this change quite meaningless.
> 
> No strong preference whether to keep it or drop it, but the purely
> mechanical change of relocating policies need to be split into a patch
> of its own.

I would then drop the policy reloacation and resend like you originally
proposed.

Thanks
Zahari

> 
> And I'm sorry about the conflict with the "TCA_FLOWER_L2_MISS" stuff. I
> assumed you would send v5 earlier.
> 
> >  };
> 

