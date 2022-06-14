Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A382354BB2C
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 22:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351417AbiFNUTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 16:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358498AbiFNUTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 16:19:02 -0400
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68A7296;
        Tue, 14 Jun 2022 13:18:58 -0700 (PDT)
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 25EKIIaK025319;
        Tue, 14 Jun 2022 22:18:23 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 70E30121689;
        Tue, 14 Jun 2022 22:18:13 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1655237893; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PkEPP3X+XSpLKTRSrvKowQoJhyCHkhoEx08xpXl7uwo=;
        b=S7JejUWzsTFn0NvfTHDkAAfSEn2Y4FEKkYR+LL/pFsMn7o48qQEvv0Tsb6qdcst6MQ+7OR
        2ARYvt2v/0+KW3Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1655237893; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PkEPP3X+XSpLKTRSrvKowQoJhyCHkhoEx08xpXl7uwo=;
        b=wdG1U8mJ0vQiiITstRHrPhv/89mbNAIBXSUVEKGWfKxxSJ0cZ5OjSMQIJD75EDqwKsAS7+
        cu0Zio00QMENU6CYYr69GLjF82o3sSQjIC0ZzfR+T76mndBwIJPhuHF8wb76DAVhGkcMl3
        +QpTNJy+S/g+uRdqLtlwDUeP8ir/PA4Mt2A1jXsAdEtCo+iXOTAVwn0Osq1dOWKEQ+rjfJ
        r+R7vMROq8hw3s3AGqCCpBIBUmg9PFSBrJiDdgvzn7geMKz/818HrBEwGd+Wcfu0piUU/X
        A/ylYQEs/zBEP/yeuDS/ImZZpIM6XoHrYBRtSXEkTNBmutxghhfDy1+8crGfBQ==
Date:   Tue, 14 Jun 2022 22:18:13 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [net-next v1 2/2] seg6: add NEXT-C-SID support for SRv6 End
 behavior
Message-Id: <20220614221813.bd92cc93e4b7eb9d1f2590e8@uniroma2.it>
In-Reply-To: <3c8d69d321e1465be9482285581622fe9947f112.camel@redhat.com>
References: <20220611104750.2724-1-andrea.mayer@uniroma2.it>
        <20220611104750.2724-3-andrea.mayer@uniroma2.it>
        <3c8d69d321e1465be9482285581622fe9947f112.camel@redhat.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,
Thanks for your time. Please see my answers inline.

On Tue, 14 Jun 2022 12:52:42 +0200
Paolo Abeni <pabeni@redhat.com> wrote:

> On Sat, 2022-06-11 at 12:47 +0200, Andrea Mayer wrote:
> > The NEXT-C-SID mechanism described in [1] offers the possibility of
> > encoding several SRv6 segments within a single 128 bit SID address. Such
> > a SID address is called a Compressed SID (C-SID) container. In this way,
> > the length of the SID List can be drastically reduced.
> > 
> > A SID instantiated with the NEXT-C-SID flavor considers an IPv6 address
> > logically structured in three main blocks: i) Locator-Block; ii)
> > Locator-Node Function; iii) Argument.
> > 
> >                         C-SID container
> > +------------------------------------------------------------------+
> > >     Locator-Block      |Loc-Node|            Argument            |
> > >                        |Function|                                |
> > +------------------------------------------------------------------+
> > <--------- B -----------> <- NF -> <------------- A --------------->
> > 
> >    (i) The Locator-Block can be any IPv6 prefix available to the provider;
> > 
> >   (ii) The Locator-Node Function represents the node and the function to
> >        be triggered when a packet is received on the node;
> > 
> >  (iii) The Argument carries the remaining C-SIDs in the current C-SID
> >        container.
> > 
> > The NEXT-C-SID mechanism relies on the "flavors" framework defined in
> > [2]. The flavors represent additional operations that can modify or
> > extend a subset of the existing behaviors.
> > 
> > This patch introduces the support for flavors in SRv6 End behavior
> > implementing the NEXT-C-SID one. An SRv6 End behavior with NEXT-C-SID
> > flavor works as an End behavior but it is capable of processing the
> > compressed SID List encoded in C-SID containers.
> > 
> > An SRv6 End behavior with NEXT-C-SID flavor can be configured to support
> > user-provided Locator-Block and Locator-Node Function lengths. In this
> > implementation, such lengths must be evenly divisible by 8 (i.e. must be
> > byte-aligned), otherwise the kernel informs the user about invalid
> > values with a meaningful error code and message through netlink_ext_ack.
> > 
> > If Locator-Block and/or Locator-Node Function lengths are not provided
> > by the user during configuration of an SRv6 End behavior instance with
> > NEXT-C-SID flavor, the kernel will choose their default values i.e.,
> > 32-bit Locator-Block and 16-bit Locator-Node Function.
> > 
> > [1] - https://datatracker.ietf.org/doc/html/draft-ietf-spring-srv6-srh-compression
> > [2] - https://datatracker.ietf.org/doc/html/rfc8986
> > 
> > Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> > ---
> >  include/uapi/linux/seg6_local.h |  24 +++
> >  net/ipv6/seg6_local.c           | 311 +++++++++++++++++++++++++++++++-
> >  2 files changed, 332 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
> > index 332b18f318f8..7919940c84d0 100644
> > --- a/include/uapi/linux/seg6_local.h
> > +++ b/include/uapi/linux/seg6_local.h
> > @@ -28,6 +28,7 @@ enum {
> >  	SEG6_LOCAL_BPF,
> >  	SEG6_LOCAL_VRFTABLE,
> >  	SEG6_LOCAL_COUNTERS,
> > +	SEG6_LOCAL_FLAVORS,
> >  	__SEG6_LOCAL_MAX,
> >  };
> >  #define SEG6_LOCAL_MAX (__SEG6_LOCAL_MAX - 1)
> > @@ -110,4 +111,27 @@ enum {
> >  
> >  #define SEG6_LOCAL_CNT_MAX (__SEG6_LOCAL_CNT_MAX - 1)
> >  
> > +/* SRv6 End* Flavor attributes */
> > +enum {
> > +	SEG6_LOCAL_FLV_UNSPEC,
> > +	SEG6_LOCAL_FLV_OPERATION,
> > +	SEG6_LOCAL_FLV_LCBLOCK_LEN,
> > +	SEG6_LOCAL_FLV_LCNODE_FN_LEN,
> > +	__SEG6_LOCAL_FLV_MAX,
> > +};
> > +
> > +#define SEG6_LOCAL_FLV_MAX (__SEG6_LOCAL_FLV_MAX - 1)
> > +
> > +/* Designed flavor operations for SRv6 End* Behavior */
> > +enum {
> > +	SEG6_LOCAL_FLV_OP_UNSPEC,
> > +	SEG6_LOCAL_FLV_OP_PSP,
> > +	SEG6_LOCAL_FLV_OP_USP,
> > +	SEG6_LOCAL_FLV_OP_USD,
> > +	SEG6_LOCAL_FLV_OP_NEXT_CSID,
> > +	__SEG6_LOCAL_FLV_OP_MAX
> > +};
> > +
> > +#define SEG6_LOCAL_FLV_OP_MAX (__SEG6_LOCAL_FLV_OP_MAX - 1)
> > +
> >  #endif
> > diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> > index 5ea51ee2ef71..eb31c6c838e3 100644
> > --- a/net/ipv6/seg6_local.c
> > +++ b/net/ipv6/seg6_local.c
> > @@ -73,6 +73,39 @@ struct bpf_lwt_prog {
> >  	char *name;
> >  };
> >  
> > +/* default length values (expressed in bits) for both Locator-Block and
> > + * Locator-Node Function.
> > + *
> > + * Both SEG6_LOCAL_LCBLOCK_DLEN and SEG6_LOCAL_LCNODE_FN_DLEN *must* be:
> > + *    i) greater than 0;
> > + *   ii) evenly divisible by 8. In other terms, the lengths of the
> > + *	 Locator-Block and Locator-Node Function must be byte-aligned (we can
> > + *	 relax this constraint in the future if really needed).
> > + *
> > + * Moreover, a third condition must hold:
> > + *  iii) SEG6_LOCAL_LCBLOCK_DLEN + SEG6_LOCAL_LCNODE_FN_DLEN <= 128.
> > + *
> > + * The correctness of SEG6_LOCAL_LCBLOCK_DLEN and SEG6_LOCAL_LCNODE_FN_DLEN
> > + * values are checked during the kernel compilation. If the compilation stops,
> > + * check the value of these parameters to see if they meet conditions (i), (ii)
> > + * and (iii).
> > + */
> > +#define SEG6_LOCAL_LCBLOCK_DLEN		32
> > +#define SEG6_LOCAL_LCNODE_FN_DLEN	16
> > +
> > +/* Supported Flavor operations are reported in this bitmask */
> > +#define SEG6_LOCAL_FLV_SUPP_OPS	(BIT(SEG6_LOCAL_FLV_OP_NEXT_CSID))
> > +
> > +struct seg6_flavors_info {
> > +	/* Flavor operations */
> > +	__u32 flv_ops;
> > +
> > +	/* Locator-Block length, expressed in bits */
> > +	__u8 lcblock_len;
> > +	/* Locator-Node Function length, expressed in bits*/
> > +	__u8 lcnode_func_len;
> 
> IMHO the above names are misleading. I suggest to use a '_bits' suffix
> instead.
> 

Ok, that looks nice to me, e.g,: lcblock_len -> lcblock_bits.
I keep the other vars/macros consistent, so for instance:
SEG6_LOCAL_LCBLOCK_DLEN -> SEG6_LOCAL_LCBLOCK_DBITS.

We should also update labels such as SEG6_LOCAL_FLV_LCBLOCK_LEN and
SEG6_LOCAL_FLV_LCNODE_FN_LEN used in netlink messages.

> > +};
> > +
> >  enum seg6_end_dt_mode {
> >  	DT_INVALID_MODE	= -EINVAL,
> >  	DT_LEGACY_MODE	= 0,
> > @@ -136,6 +169,8 @@ struct seg6_local_lwt {
> >  #ifdef CONFIG_NET_L3_MASTER_DEV
> >  	struct seg6_end_dt_info dt_info;
> >  #endif
> > +	struct seg6_flavors_info flv_info;
> > +
> >  	struct pcpu_seg6_local_counters __percpu *pcpu_counters;
> >  
> >  	int headroom;
> > @@ -270,8 +305,50 @@ int seg6_lookup_nexthop(struct sk_buff *skb,
> >  	return seg6_lookup_any_nexthop(skb, nhaddr, tbl_id, false);
> >  }
> >  
> > -/* regular endpoint function */
> > -static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> > +static __u8 seg6_flv_lcblock_octects(const struct seg6_flavors_info *finfo)
> > +{
> > +	return finfo->lcblock_len >> 3;
> > +}
> > +
> > +static __u8 seg6_flv_lcnode_func_octects(const struct seg6_flavors_info *finfo)
> > +{
> > +	return finfo->lcnode_func_len >> 3;
> > +}
> > +
> > +static bool seg6_next_csid_is_arg_zero(const struct in6_addr *addr,
> > +				       const struct seg6_flavors_info *finfo)
> > +{
> > +	__u8 fnc_octects = seg6_flv_lcnode_func_octects(finfo);
> > +	__u8 blk_octects = seg6_flv_lcblock_octects(finfo);
> > +	__u8 arg_octects;
> > +	int i;
> > +
> > +	arg_octects = 16 - blk_octects - fnc_octects;
> > +	for (i = 0; i < arg_octects; ++i) {
> > +		if (addr->s6_addr[blk_octects + fnc_octects + i] != 0x00)
> > +			return false;
> > +	}
> > +
> > +	return true;
> > +}
> > +
> > +/* assume that DA.Argument length > 0 */
> > +static void seg6_next_csid_advance_arg(struct in6_addr *addr,
> > +				       const struct seg6_flavors_info *finfo)
> > +{
> > +	__u8 fnc_octects = seg6_flv_lcnode_func_octects(finfo);
> > +	__u8 blk_octects = seg6_flv_lcblock_octects(finfo);
> > +
> > +	/* advance DA.Argument */
> > +	memmove((void *)&addr->s6_addr[blk_octects],
> > +		(const void *)&addr->s6_addr[blk_octects + fnc_octects],
> > +		16 - blk_octects - fnc_octects);
> 
> The void cast should not be needed

yes.

> 
> > +
> > +	memset((void *)&addr->s6_addr[16 - fnc_octects], 0x00, fnc_octects);
> 
> Same here.
> 

yes.

> > +}
> > +
> > +static int input_action_end_core(struct sk_buff *skb,
> > +				 struct seg6_local_lwt *slwt)
> >  {
> >  	struct ipv6_sr_hdr *srh;
> >  
> > @@ -290,6 +367,38 @@ static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> >  	return -EINVAL;
> >  }
> >  
> > +static int end_next_csid_core(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> > +{
> > +	const struct seg6_flavors_info *finfo = &slwt->flv_info;
> > +	struct in6_addr *daddr = &ipv6_hdr(skb)->daddr;
> > +
> > +	if (seg6_next_csid_is_arg_zero(daddr, finfo))
> > +		return input_action_end_core(skb, slwt);
> > +
> > +	/* update DA */
> > +	seg6_next_csid_advance_arg(daddr, finfo);
> > +
> > +	seg6_lookup_nexthop(skb, NULL, 0);
> > +
> > +	return dst_input(skb);
> > +}
> > +
> > +static bool seg6_next_csid_enabled(__u32 fops)
> > +{
> > +	return fops & BIT(SEG6_LOCAL_FLV_OP_NEXT_CSID);
> > +}
> > +
> > +/* regular endpoint function */
> > +static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> > +{
> > +	const struct seg6_flavors_info *finfo = &slwt->flv_info;
> > +
> > +	if (seg6_next_csid_enabled(finfo->flv_ops))
> > +		return end_next_csid_core(skb, slwt);
> > +
> > +	return input_action_end_core(skb, slwt);
> > +}
> > +
> >  /* regular endpoint, and forward to specified nexthop */
> >  static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> >  {
> > @@ -952,7 +1061,8 @@ static struct seg6_action_desc seg6_action_table[] = {
> >  	{
> >  		.action		= SEG6_LOCAL_ACTION_END,
> >  		.attrs		= 0,
> > -		.optattrs	= SEG6_F_LOCAL_COUNTERS,
> > +		.optattrs	= SEG6_F_LOCAL_COUNTERS |
> > +				  SEG6_F_ATTR(SEG6_LOCAL_FLAVORS),
> >  		.input		= input_action_end,
> >  	},
> >  	{
> > @@ -1133,6 +1243,7 @@ static const struct nla_policy seg6_local_policy[SEG6_LOCAL_MAX + 1] = {
> >  	[SEG6_LOCAL_OIF]	= { .type = NLA_U32 },
> >  	[SEG6_LOCAL_BPF]	= { .type = NLA_NESTED },
> >  	[SEG6_LOCAL_COUNTERS]	= { .type = NLA_NESTED },
> > +	[SEG6_LOCAL_FLAVORS]	= { .type = NLA_NESTED },
> >  };
> >  
> >  static int parse_nla_srh(struct nlattr **attrs, struct seg6_local_lwt *slwt,
> > @@ -1552,6 +1663,190 @@ static void destroy_attr_counters(struct seg6_local_lwt *slwt)
> >  	free_percpu(slwt->pcpu_counters);
> >  }
> >  
> > +static const
> > +struct nla_policy seg6_local_flavors_policy[SEG6_LOCAL_FLV_MAX + 1] = {
> > +	[SEG6_LOCAL_FLV_OPERATION]	= { .type = NLA_U32 },
> > +	[SEG6_LOCAL_FLV_LCBLOCK_LEN]	= { .type = NLA_U8 },
> > +	[SEG6_LOCAL_FLV_LCNODE_FN_LEN]	= { .type = NLA_U8 },
> > +};
> > +
> > +/* check whether the lengths of the Locator-Block and Locator-Node Function
> > + * are compatible with the dimension of a C-SID container.
> > + */
> > +static int seg6_chk_next_csid_cfg(__u8 block_len, __u8 func_len)
> > +{
> > +	/* Locator-Block and Locator-Node Function cannot exceed 128 bits */
> > +	if (block_len + func_len > 128)
> > +		return -EINVAL;
> > +
> > +	/* Locator-Block length must be greater than zero and evenly divisible
> > +	 * by 8. There must be room for a Locator-Node Function, at least.
> > +	 */
> > +	if (block_len < 8 || block_len > 120 || (block_len & 0x07))
> 
> The 'block_len < 8' part is not needed, since you later check the 3
> less significant bits can't be set and this is an unsigned number.
> 

Ok, but I need to be sure that block_len must be different from zero. For this
reason, I will replace 'block_len < 8' with 'block_len == 0'.

> > +		return -EINVAL;
> > +
> > +	/* Locator-Node Function length must be greater than zero and evenly
> > +	 * divisible by 8. There must be room for the Locator-Block.
> > +	 */
> > +	if (func_len < 8 || func_len > 120 || (func_len & 0x07))
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +static int seg6_parse_nla_next_csid_cfg(struct nlattr **tb,
> > +					struct seg6_flavors_info *finfo,
> > +					struct netlink_ext_ack *extack)
> > +{
> > +	__u8 func_len = SEG6_LOCAL_LCNODE_FN_DLEN;
> > +	__u8 block_len = SEG6_LOCAL_LCBLOCK_DLEN;
> > +	int rc;
> > +
> > +	if (tb[SEG6_LOCAL_FLV_LCBLOCK_LEN])
> > +		block_len = nla_get_u8(tb[SEG6_LOCAL_FLV_LCBLOCK_LEN]);
> > +
> > +	if (tb[SEG6_LOCAL_FLV_LCNODE_FN_LEN])
> > +		func_len = nla_get_u8(tb[SEG6_LOCAL_FLV_LCNODE_FN_LEN]);
> > +
> > +	rc = seg6_chk_next_csid_cfg(block_len, func_len);
> > +	if (rc < 0) {
> > +		NL_SET_ERR_MSG(extack,
> > +			       "Invalid Locator Block/Node Function lengths");
> > +		return rc;
> > +	}
> > +
> > +	finfo->lcblock_len = block_len;
> > +	finfo->lcnode_func_len = func_len;
> > +
> > +	return 0;
> > +}
> > +
> > +static int parse_nla_flavors(struct nlattr **attrs, struct seg6_local_lwt *slwt,
> > +			     struct netlink_ext_ack *extack)
> > +{
> > +	struct seg6_flavors_info *finfo = &slwt->flv_info;
> > +	struct nlattr *tb[SEG6_LOCAL_FLV_MAX + 1];
> > +	unsigned long fops;
> > +	int rc;
> > +
> > +	rc = nla_parse_nested_deprecated(tb, SEG6_LOCAL_FLV_MAX,
> > +					 attrs[SEG6_LOCAL_FLAVORS],
> > +					 seg6_local_flavors_policy, NULL);
> > +	if (rc < 0)
> > +		return rc;
> > +
> > +	/* this attribute MUST always be present since it represents the Flavor
> > +	 * operation(s) to carry out.
> > +	 */
> > +	if (!tb[SEG6_LOCAL_FLV_OPERATION])
> > +		return -EINVAL;
> > +
> > +	fops = nla_get_u32(tb[SEG6_LOCAL_FLV_OPERATION]);
> > +	if (~SEG6_LOCAL_FLV_SUPP_OPS & fops) {
> 
> Please avoid 'yoda-style' syntax. The compilar warnings will catch the
> eventual mistakes this is supposed to avoid, and the conventional
> syntax is more readable.
> 

Ok, fine!

> > +		NL_SET_ERR_MSG(extack, "Unsupported Flavor operation(s)");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	finfo->flv_ops = fops;
> > +
> > +	if (seg6_next_csid_enabled(fops)) {
> > +		/* Locator-Block and Locator-Node Function lengths can be
> > +		 * provided by the user space. If not, default values are going
> > +		 * to be applied.
> > +		 */
> > +		rc = seg6_parse_nla_next_csid_cfg(tb, finfo, extack);
> > +		if (rc < 0)
> > +			return rc;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int seg6_fill_nla_next_csid_cfg(struct sk_buff *skb,
> > +				       struct seg6_flavors_info *finfo)
> > +{
> > +	if (nla_put_u8(skb, SEG6_LOCAL_FLV_LCBLOCK_LEN, finfo->lcblock_len))
> > +		return -EMSGSIZE;
> > +
> > +	if (nla_put_u8(skb, SEG6_LOCAL_FLV_LCNODE_FN_LEN,
> > +		       finfo->lcnode_func_len))
> > +		return -EMSGSIZE;
> > +
> > +	return 0;
> > +}
> > +
> > +static int put_nla_flavors(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> > +{
> > +	struct seg6_flavors_info *finfo = &slwt->flv_info;
> > +	__u32 fops = finfo->flv_ops;
> > +	struct nlattr *nest;
> > +	int rc;
> > +
> > +	nest = nla_nest_start(skb, SEG6_LOCAL_FLAVORS);
> > +	if (!nest)
> > +		return -EMSGSIZE;
> > +
> > +	if (nla_put_u32(skb, SEG6_LOCAL_FLV_OPERATION, fops)) {
> > +		rc = -EMSGSIZE;
> > +		goto err;
> > +	}
> > +
> > +	if (seg6_next_csid_enabled(fops)) {
> > +		rc = seg6_fill_nla_next_csid_cfg(skb, finfo);
> > +		if (rc < 0)
> > +			goto err;
> > +	}
> > +
> > +	return nla_nest_end(skb, nest);
> > +
> > +err:
> > +	nla_nest_cancel(skb, nest);
> > +	return rc;
> > +}
> > +
> > +static int seg6_cmp_nla_next_csid_cfg(struct seg6_flavors_info *finfo_a,
> > +				      struct seg6_flavors_info *finfo_b)
> > +{
> > +	if (finfo_a->lcblock_len != finfo_b->lcblock_len)
> > +		return 1;
> > +
> > +	if (finfo_a->lcnode_func_len != finfo_b->lcnode_func_len)
> > +		return 1;
> > +
> > +	return 0;
> > +}
> > +
> > +static int cmp_nla_flavors(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
> > +{
> > +	struct seg6_flavors_info *finfo_a = &a->flv_info;
> > +	struct seg6_flavors_info *finfo_b = &b->flv_info;
> > +
> > +	if (finfo_a->flv_ops != finfo_b->flv_ops)
> > +		return 1;
> > +
> > +	if (seg6_next_csid_enabled(finfo_a->flv_ops)) {
> > +		if (seg6_cmp_nla_next_csid_cfg(finfo_a, finfo_b))
> > +			return 1;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int encap_size_flavors(struct seg6_local_lwt *slwt)
> > +{
> > +	struct seg6_flavors_info *finfo = &slwt->flv_info;
> > +	int nlsize;
> > +
> > +	nlsize = nla_total_size(0) +	/* nest SEG6_LOCAL_FLAVORS */
> > +		 nla_total_size(4);	/* SEG6_LOCAL_FLV_OPERATION */
> > +
> > +	if (seg6_next_csid_enabled(finfo->flv_ops))
> > +		nlsize += nla_total_size(1) + /* SEG6_LOCAL_FLV_LCBLOCK_LEN */
> > +			  nla_total_size(1);  /* SEG6_LOCAL_FLV_LCNODE_FN_LEN */
> > +
> > +	return nlsize;
> > +}
> > +
> >  struct seg6_action_param {
> >  	int (*parse)(struct nlattr **attrs, struct seg6_local_lwt *slwt,
> >  		     struct netlink_ext_ack *extack);
> > @@ -1604,6 +1899,10 @@ static struct seg6_action_param seg6_action_params[SEG6_LOCAL_MAX + 1] = {
> >  				    .put = put_nla_counters,
> >  				    .cmp = cmp_nla_counters,
> >  				    .destroy = destroy_attr_counters },
> > +
> > +	[SEG6_LOCAL_FLAVORS]	= { .parse = parse_nla_flavors,
> > +				    .put = put_nla_flavors,
> > +				    .cmp = cmp_nla_flavors },
> >  };
> >  
> >  /* call the destroy() callback (if available) for each set attribute in
> > @@ -1917,6 +2216,9 @@ static int seg6_local_get_encap_size(struct lwtunnel_state *lwt)
> >  			  /* SEG6_LOCAL_CNT_ERRORS */
> >  			  nla_total_size_64bit(sizeof(__u64));
> >  
> > +	if (attrs & SEG6_F_ATTR(SEG6_LOCAL_FLAVORS))
> > +		nlsize += encap_size_flavors(slwt);
> > +
> >  	return nlsize;
> >  }
> >  
> > @@ -1972,6 +2274,9 @@ int __init seg6_local_init(void)
> >  	 */
> >  	BUILD_BUG_ON(SEG6_LOCAL_MAX + 1 > BITS_PER_TYPE(unsigned long));
> >  
> > +	BUILD_BUG_ON(seg6_chk_next_csid_cfg(SEG6_LOCAL_LCBLOCK_DLEN,
> > +					    SEG6_LOCAL_LCNODE_FN_DLEN) != 0);
> > +
> 
> It looks like you are asking too much to the compiler with the above.

Yes, indeed. Definitely, too much :-)

> You can possibly resort open code the relevant test here.
> 

Do you mean something like that?

int __init_seg6_local(void)
{
    [...]
    rc = seg6_chk_next_csid_cfg(SEG6_LOCAL_LCBLOCK_DLEN,
                                SEG6_LOCAL_LCNODE_FN_DLEN);
    if (rc < 0) {
        WARN(1, "seg6: wrong default Locator-Block/Node Function lengths!");
        return rc;
    }

    [...]
}

In this way, the developer who mangles these macros and recompiles the kernel
will not receive any warning at compilation time. Later on, when the kernel is
loaded, the initialization of the inet6 will fail with a log message in the
dmesg. I am not sure if this is a good failure mode.

A variant of this approach is to issue the warning in the dmesg but continue to
load the inet6. In this case if the developer changes the values in a wrong
way, the segment routing next csid will behave in a wrong way (not predictable).

---

Another possibility is to skip any check, since these two macro values are not
supposed to be changed; and if they are changed it is at the risk of the
developer. 

---

There is another possibility that I am trying to implement, which is to create
three small macros to use in seg6_chk_next_csid_cfg(...) and also with
BUILD_BUG_ON(...).

Something like that:

#define __ncsid_chk_bits(blen, flen)	      \
        ((blen) + (flen) > 128)

#define __ncsid_chk_lcblock_bits(blen)        \
        (!(blen) || (blen) > 120 || ((blen) & 0x07))

#define __ncsid_chk_lcnode_fn_bits(flen)      \
        __ncsid_chk_lcblock_bits(flen)

int __init_seg6_local(void)
{
    [...]

    BUILD_BUG_ON(__ncsid_chk_bits(SEG6_LOCAL_LCBLOCK_DLEN,
                                  SEG6_LOCAL_LCNODE_FN_DLEN));
    BUILD_BUG_ON(__ncsid_chk_lcblock_bits(SEG6_LOCAL_LCBLOCK_DLEN));
    BUILD_BUG_ON(__ncsid_chk_lcnode_fn_bits(SEG6_LOCAL_LCNODE_FN_DLEN));

    [...]
}

Since these are only and exclusively macros (and by the way they are very
simple), there should be no problems at compile time.
This approach looks promising to me.

What do you think is the best approach to take in a case like that?

> It would be great if you could add some self-tests on top of the
> iproute2 support.
> 

yes for sure ;-) I will add them to v2.

> Thanks!
> 

you're welcome! and thanks again for your help.

Andrea
