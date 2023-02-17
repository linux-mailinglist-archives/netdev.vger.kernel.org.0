Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676C169B094
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 17:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjBQQUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 11:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjBQQUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 11:20:06 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9896EF3E
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 08:19:30 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id ee31so7742078edb.3
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 08:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7F73Fyb0jEh4e0L6G8jShNslMS1kqMlMD21roCmjT4A=;
        b=ghMoTDB6xESkMZKUwur1brQsAOpwXR4XLjE3xUms6X7v66WTCyKQ8G1Gdih936QaYK
         P7z1lHO+qRFvRTrUF3vPlKExM5g6GPo48uFZUWbeIjr8+qEcwmTHsbP+b/k9RpY+qpjt
         GcaIYhRGAOVLrTZZrJ2RxEoHrHeYArDfntQ/I2FrnNlqOVxExfWr/IK9V2FLhAAGn59B
         0lg9QlhRw45jg6AtBLqHIxqF4isNwmxFlqRAJnIiFBYajV7rKxEl9UenFH99b5TSMXV3
         sJu/vioobZ9bsvhd90G/RpSzZAw9Iichw9NZWUPDtV6SxCjmha6CJXAetXsC/LlZQsVR
         OEpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7F73Fyb0jEh4e0L6G8jShNslMS1kqMlMD21roCmjT4A=;
        b=5gF/92DXiONaRgQzTnq4dd65BBkF1QMsMOIYXovpXI/7KoCq9hT3USwsiHfOuAwYbf
         FqO7Ezl0zUPIZavFqFYE7BXZE10M96/lSnBULcxzWanQXG88bcnyB6n5VkKCKmEIOSF/
         NsNRmg45ImVjkt5RSsJIOzRGLeQxTjXp3HCBsKGYUUDR9us/jwc8e9XKtDdGlxA509Vv
         pGspBh7kzL/pYCFI2/B0EsZ/aM0uF9HAhd+NPIWnS9NEshFewy4ze1mt+Id843GXk9xn
         sBoEfAHXIuwaKSWLwTD4R9GyAyKqAwlwPX6+ZZBcnYyXwwewEg/0ON1O3dJPaoVBdwgk
         tavg==
X-Gm-Message-State: AO0yUKXUL1+a7KbaktDzmpN6LkjAengicWMVPxIpmAbmBhZr7l/NNd8O
        8DHSpVa6vsfOhCxsotUFkeA=
X-Google-Smtp-Source: AK7set+1vX4S8PvWLivGUzvdcWkJ/lrOBmIht0vAsbnmqkBpBVoVon+KvkE52f3ijYTl2EGjZefshg==
X-Received: by 2002:a17:907:8b89:b0:8b1:7891:19e8 with SMTP id tb9-20020a1709078b8900b008b1789119e8mr4592482ejc.44.1676650763015;
        Fri, 17 Feb 2023 08:19:23 -0800 (PST)
Received: from tycho (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id i27-20020a17090671db00b008b17ca37966sm1425958ejk.148.2023.02.17.08.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 08:19:22 -0800 (PST)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
Date:   Fri, 17 Feb 2023 17:19:20 +0100
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next 1/2] net: flower: add support for matching cfm
 fields
Message-ID: <20230217161920.gs3b2fbc5k73fput@tycho>
References: <20230215192554.3126010-1-zahari.doychev@linux.com>
 <20230215192554.3126010-2-zahari.doychev@linux.com>
 <e4863729-4ddc-f6cc-85f2-333bd996fc6a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4863729-4ddc-f6cc-85f2-333bd996fc6a@intel.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


[...]

> > +/**
> > + * struct flow_dissector_key_cfm
> > + *
> > + */
> 
> ???
> 
> Without a proper kernel-doc, this makes no sense. So either remove this
> comment or make a kernel-doc from it, describing the structure and each
> its member (I'd go for kernel-doc :P).
> 

I will fix this.

> > +struct flow_dissector_key_cfm {
> > +	u8	mdl:3,
> > +		ver:5;
> > +	u8	opcode;
> > +};
> > +
> >  enum flow_dissector_key_id {
> >  	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
> >  	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
> > @@ -329,6 +339,7 @@ enum flow_dissector_key_id {
> >  	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_vlans */
> >  	FLOW_DISSECTOR_KEY_PPPOE, /* struct flow_dissector_key_pppoe */
> >  	FLOW_DISSECTOR_KEY_L2TPV3, /* struct flow_dissector_key_l2tpv3 */
> > +	FLOW_DISSECTOR_KEY_CFM, /* struct flow_dissector_key_cfm */
> >  
> >  	FLOW_DISSECTOR_KEY_MAX,
> >  };
> > diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> > index 648a82f32666..d55f70ccfe3c 100644
> > --- a/include/uapi/linux/pkt_cls.h
> > +++ b/include/uapi/linux/pkt_cls.h
> > @@ -594,6 +594,8 @@ enum {
> >  
> >  	TCA_FLOWER_KEY_L2TPV3_SID,	/* be32 */
> >  
> > +	TCA_FLOWER_KEY_CFM,
> 
> Each existing definitions within this enum have a comment mentioning the
> corresponding type (__be32, __u8 and so on), why doesn't this one?
> 

I was following the other nest option attributes which don't have
a comment but sure I can add one or probably change the name to
include the opts prefix.

> > +
> >  	__TCA_FLOWER_MAX,
> >  };
> >  
> > @@ -702,6 +704,16 @@ enum {
> >  	TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST = (1 << 1),
> >  };
> >  
> > +enum {
> > +	TCA_FLOWER_KEY_CFM_OPT_UNSPEC,
> > +	TCA_FLOWER_KEY_CFM_MD_LEVEL,
> > +	TCA_FLOWER_KEY_CFM_OPCODE,
> > +	__TCA_FLOWER_KEY_CFM_OPT_MAX,
> > +};
> > +
> > +#define TCA_FLOWER_KEY_CFM_OPT_MAX \
> > +		(__TCA_FLOWER_KEY_CFM_OPT_MAX - 1)
> 
> This fits into one line...
> Can't we put it into the enum itself?
> 

I can fix this but putting it into the enum makes it different from the 
other defintions. So I am not quire sure on that.

> > +
> >  #define TCA_FLOWER_MASK_FLAGS_RANGE	(1 << 0) /* Range-based match */
> >  
> >  /* Match-all classifier */
> > diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> > index 25fb0bbc310f..adb23d31f199 100644
> > --- a/net/core/flow_dissector.c
> > +++ b/net/core/flow_dissector.c
> > @@ -547,6 +547,41 @@ __skb_flow_dissect_arp(const struct sk_buff *skb,
> >  	return FLOW_DISSECT_RET_OUT_GOOD;
> >  }
> >  
> > +static enum flow_dissect_ret
> > +__skb_flow_dissect_cfm(const struct sk_buff *skb,
> > +		       struct flow_dissector *flow_dissector,
> > +		       void *target_container, const void *data,
> > +		       int nhoff, int hlen)
> > +{
> > +	struct flow_dissector_key_cfm *key_cfm;
> > +	struct cfm_common_hdr {
> 
> I don't see this type used anywhere else in the code, so you can leave
> it anonymous.

noted.

> 
> > +		__u8 mdlevel_version;
> > +		__u8 opcode;
> > +		__u8 flags;
> > +		__u8 tlv_offset;
> 
> This is a purely-kernel-side structure, so use simply `u8` here for each
> of them.

I will fix it.

> 
> > +	} *hdr, _hdr;
> > +#define CFM_MD_LEVEL_SHIFT	5
> > +#define CFM_MD_VERSION_MASK	0x1f
> > +
> > +	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_CFM))
> > +		return FLOW_DISSECT_RET_OUT_GOOD;
> > +
> > +	hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr), data,
> > +				   hlen, &_hdr);
> > +	if (!hdr)
> > +		return FLOW_DISSECT_RET_OUT_BAD;
> > +
> > +	key_cfm = skb_flow_dissector_target(flow_dissector,
> > +					    FLOW_DISSECTOR_KEY_CFM,
> > +					    target_container);
> > +
> > +	key_cfm->mdl = hdr->mdlevel_version >> CFM_MD_LEVEL_SHIFT;
> > +	key_cfm->ver = hdr->mdlevel_version & CFM_MD_VERSION_MASK;
> 
> I'd highly recommend using FIELD_GET() here.
> 
> Or wait, why can't you just use one structure for both FD and the actual
> header? You only need two fields going next to each other, so you could
> save some cycles by just directly assigning them (I mean, just define
> the fields you need, not the whole header since you use only first two
> fields).
> 

I am not sure if get this completely. I understand we can reduce the
struct size be removing the not needed fields but we still need to
use the FIELD_GET here. Please correct me if my understanding is wrong.

> > +	key_cfm->opcode = hdr->opcode;
> > +
> > +	return  FLOW_DISSECT_RET_OUT_GOOD;
> > +}
> > +
> >  static enum flow_dissect_ret
> >  __skb_flow_dissect_gre(const struct sk_buff *skb,
> >  		       struct flow_dissector_key_control *key_control,
> > @@ -1390,6 +1425,12 @@ bool __skb_flow_dissect(const struct net *net,
> >  		break;
> >  	}
> >  
> > +	case htons(ETH_P_CFM): {
> > +		fdret = __skb_flow_dissect_cfm(skb, flow_dissector,
> > +					       target_container, data,
> > +					       nhoff, hlen);
> > +		break;
> > +	}
> >  	default:
> >  		fdret = FLOW_DISSECT_RET_OUT_BAD;
> >  		break;
> > diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> > index 885c95191ccf..91f2268e1577 100644
> > --- a/net/sched/cls_flower.c
> > +++ b/net/sched/cls_flower.c
> > @@ -71,6 +71,7 @@ struct fl_flow_key {
> >  	struct flow_dissector_key_num_of_vlans num_of_vlans;
> >  	struct flow_dissector_key_pppoe pppoe;
> >  	struct flow_dissector_key_l2tpv3 l2tpv3;
> > +	struct flow_dissector_key_cfm cfm;
> >  } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
> >  
> >  struct fl_flow_mask_range {
> > @@ -711,7 +712,7 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
> >  	[TCA_FLOWER_KEY_PPPOE_SID]	= { .type = NLA_U16 },
> >  	[TCA_FLOWER_KEY_PPP_PROTO]	= { .type = NLA_U16 },
> >  	[TCA_FLOWER_KEY_L2TPV3_SID]	= { .type = NLA_U32 },
> > -
> > +	[TCA_FLOWER_KEY_CFM]		= { .type = NLA_NESTED },
> >  };
> >  
> >  static const struct nla_policy
> > @@ -760,6 +761,12 @@ mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
> >  	[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL]    = { .type = NLA_U32 },
> >  };
> >  
> > +static const struct nla_policy
> > +cfm_opt_policy[TCA_FLOWER_KEY_CFM_OPT_MAX + 1] = {
> 
> Why not just use %__TCA_FLOWER_KEY_CFM_OPT_MAX here which is the same? I
> know it's not how it's been done historically, but anyway.

I was looking again at the other definitions here.

> 
> > +	[TCA_FLOWER_KEY_CFM_MD_LEVEL]		= { .type = NLA_U8 },
> > +	[TCA_FLOWER_KEY_CFM_OPCODE]		= { .type = NLA_U8 },
> > +};
> > +
> >  static void fl_set_key_val(struct nlattr **tb,
> >  			   void *val, int val_type,
> >  			   void *mask, int mask_type, int len)
> > @@ -1644,6 +1651,67 @@ static bool is_vlan_key(struct nlattr *tb, __be16 *ethertype,
> >  	return false;
> >  }
> >  
> > +#define CFM_MD_LEVEL_MASK 0x7
> 
> Can all those definitions be located in one place in some header file
> instead of being scattered across several C files? You'll need them one
> day and forget where you place them, some other developers won't know
> they are somewhere in C files and decide they're not defined in the kernel.
> 

I can try to move them to a header file. I see some attributes have
their own header with defines only. 

> > +static int fl_set_key_cfm_md_level(struct nlattr **tb,
> > +				   struct fl_flow_key *key,
> > +				   struct fl_flow_key *mask,
> > +				   struct netlink_ext_ack *extack)
> > +{
> > +	u8 level;
> > +
> > +	if (!tb[TCA_FLOWER_KEY_CFM_MD_LEVEL])
> > +		return 0;
> > +
> > +	level = nla_get_u8(tb[TCA_FLOWER_KEY_CFM_MD_LEVEL]);
> > +	if (level & ~CFM_MD_LEVEL_MASK) {
> > +		NL_SET_ERR_MSG_ATTR(extack,
> > +				    tb[TCA_FLOWER_KEY_CFM_MD_LEVEL],
> > +				    "cfm md level must be 0-7");
> > +		return -EINVAL;
> > +	}
> > +	key->cfm.mdl = level;
> > +	mask->cfm.mdl = CFM_MD_LEVEL_MASK;
> > +
> > +	return 0;
> > +}
> > +
> > +static void fl_set_key_cfm_opcode(struct nlattr **tb,
> > +				  struct fl_flow_key *key,
> > +				  struct fl_flow_key *mask,
> > +				  struct netlink_ext_ack *extack)
> > +{
> > +	if (!tb[TCA_FLOWER_KEY_CFM_OPCODE])
> > +		return;
> > +
> > +	fl_set_key_val(tb, &key->cfm.opcode,
> > +		       TCA_FLOWER_KEY_CFM_OPCODE,
> > +		       &mask->cfm.opcode,
> > +		       TCA_FLOWER_UNSPEC,
> > +		       sizeof(key->cfm.opcode));
> 
> I think at least some of these fit into the previous line, there's no
> need to break lines just to break them or have one argument per line.
> 

I will improve this.

[...]

> +	if (mask->cfm.mdl &&
> > +	    nla_put_u8(skb,
> > +		       TCA_FLOWER_KEY_CFM_MD_LEVEL,
> > +		       key->cfm.mdl)) {
> 
> Also weird linewrapping.
> 
> > +		err = -EMSGSIZE;
> > +		goto err_cfm_opts;
> > +	}
> > +
> > +	if (mask->cfm.opcode &&
> > +	    nla_put_u8(skb,
> > +		       TCA_FLOWER_KEY_CFM_OPCODE,
> > +		       key->cfm.opcode)) {
> 
> (same)
> 

I will fix both lines as well.

Many thanks
Zahari

> > +		err = -EMSGSIZE;
> > +		goto err_cfm_opts;
> > +	}
> > +
> > +	nla_nest_end(skb, opts);
> > +
> > +	return 0;
> > +
> > +err_cfm_opts:
> > +	nla_nest_cancel(skb, opts);
> > +	return err;
> > +}
> > +
> >  static int fl_dump_key_options(struct sk_buff *skb, int enc_opt_type,
> >  			       struct flow_dissector_key_enc_opts *enc_opts)
> >  {
> > @@ -3266,6 +3379,9 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
> >  			     sizeof(key->hash.hash)))
> >  		goto nla_put_failure;
> >  
> > +	if (fl_dump_key_cfm(skb, key, mask))
> > +		goto nla_put_failure;
> > +
> >  	return 0;
> >  
> >  nla_put_failure:
> 
> Thanks,
> Olek
