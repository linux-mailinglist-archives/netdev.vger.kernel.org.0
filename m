Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91151C4CA3
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgEEDXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgEEDXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:23:38 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F1DC061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 20:23:37 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id c10so1003757qka.4
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 20:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s0lgDpHLpwa/t0IeNKPAfYSLzC/5U4RbG+OgRJZdjEQ=;
        b=kXbqqjEa7vkGsvm8BVzzMBt/f5KR1zugFs7aL+XzIP/Vhwj3QvLBKrDR+6+AXaTvu+
         +OftV/4m5l9vKlccsAiU1juGljFhFrwb2Re/4MEaUd2OxKp0rdcdab/OnE9DvXAaww+u
         PKY47gFz7fbnrrwDCu5HwaK5EtBjhEeVCVgziDK572XJbT/KZikr1xkcIysaIGjf/Jy/
         VO7TiXa9bwD4+ed4hst1s41jLxZxFDd+3WaRdy1WA0DDASz2QgkE0sdJbJyMcrwZmX0+
         E/42sYrkrBVV75JYKK4LEYQuQz6x5GwzfTypdt39qjahTjoVD3dYk5NlV0V/XBI9Aela
         SJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s0lgDpHLpwa/t0IeNKPAfYSLzC/5U4RbG+OgRJZdjEQ=;
        b=m9kId1sicy7s3PfXzLJoxxa70SiFjWXuEbMC56jZ6y2NEc897A3r/0mMfjv31P1XQs
         DgqF985UYZxwHatx78x6u1jduJ+BiuFiIB77TFZwG5bU+x33F+cla9I4VswLBigbmAkV
         8IHjaaFjg2zk2aFoL6xHzMOSe2TYxtPu3YKyXNzx7MbEzRsC36mP1N2/3RwSMr9ff+l5
         4z7zCA3XXSfXZoAPZxp9W+kPzQqOD6jiBG1Rk/O4vHzjFxSFU/HDqwi1KkM5bDmmZ5J8
         vhZ+iNA2VtqwQ2aikUrFGENsujFlcfOEdOWV9KQ3Ty+2P6w80PJvWwSAgaKfLl3Ctw6w
         bAOg==
X-Gm-Message-State: AGi0PuYIw4o8OGYiiaPyKc13pEsbN32RfbD6MdXTdDLaLQf1TYT3NQrG
        YYn3y315N7yOo3FzpxGfQcZFHCru
X-Google-Smtp-Source: APiQypJStVNDNz9C2LpQufRj4nphEjlCupjYmKX72xTSXmdqLBMrTdAiMne0mKIoHdhTitseOqlJgw==
X-Received: by 2002:ae9:ee0a:: with SMTP id i10mr1571999qkg.367.1588649016154;
        Mon, 04 May 2020 20:23:36 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:4fe:5250:d314:f77b? ([2601:282:803:7700:4fe:5250:d314:f77b])
        by smtp.googlemail.com with ESMTPSA id y52sm719221qth.38.2020.05.04.20.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 20:23:35 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 1/5] nexthop: support for fdb ecmp nexthops
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        idosch@mellanox.com, jiri@mellanox.com, petrm@mellanox.com
References: <1588631301-21564-1-git-send-email-roopa@cumulusnetworks.com>
 <1588631301-21564-2-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0d535a96-addf-111c-0418-7b313300e3f7@gmail.com>
Date:   Mon, 4 May 2020 21:23:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588631301-21564-2-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/20 4:28 PM, Roopa Prabhu wrote:
>  include/net/nexthop.h        |  14 ++++++
>  include/uapi/linux/nexthop.h |   1 +
>  net/ipv4/nexthop.c           | 101 +++++++++++++++++++++++++++++++++----------
>  3 files changed, 93 insertions(+), 23 deletions(-)

pretty cool that you can extend this from routes to fdb entries with
such a small change stat.

> 
> diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> index c440ccc..3ad4e97 100644
> --- a/include/net/nexthop.h
> +++ b/include/net/nexthop.h
> @@ -26,6 +26,7 @@ struct nh_config {
>  	u8		nh_family;
>  	u8		nh_protocol;
>  	u8		nh_blackhole;
> +	u8		nh_fdb;
>  	u32		nh_flags;
>  
>  	int		nh_ifindex;
> @@ -52,6 +53,7 @@ struct nh_info {
>  
>  	u8			family;
>  	bool			reject_nh;
> +	bool			fdb_nh;
>  
>  	union {
>  		struct fib_nh_common	fib_nhc;
> @@ -80,6 +82,7 @@ struct nexthop {
>  	struct rb_node		rb_node;    /* entry on netns rbtree */
>  	struct list_head	fi_list;    /* v4 entries using nh */
>  	struct list_head	f6i_list;   /* v6 entries using nh */
> +	struct list_head        fdb_list;   /* fdb entries using this nh */
>  	struct list_head	grp_list;   /* nh group entries using this nh */
>  	struct net		*net;
>  
> @@ -88,6 +91,7 @@ struct nexthop {
>  	u8			protocol;   /* app managing this nh */
>  	u8			nh_flags;
>  	bool			is_group;
> +	bool			is_fdb_nh;
>  
>  	refcount_t		refcnt;
>  	struct rcu_head		rcu;
> @@ -304,4 +308,14 @@ static inline void nexthop_path_fib6_result(struct fib6_result *res, int hash)
>  int nexthop_for_each_fib6_nh(struct nexthop *nh,
>  			     int (*cb)(struct fib6_nh *nh, void *arg),
>  			     void *arg);
> +
> +static inline struct nh_info *nexthop_path_fdb(struct nexthop *nh,  u32 hash)

this is used in the next patch. Any way to not leak the nh_info struct
into vxlan code? Right now nh_info is only used in nexthop.{c,h}.

> +{
> +	struct nh_info *nhi;
> +
> +	nh = nexthop_select_path(nh, hash);
> +	nhi = rcu_dereference(nh->nh_info);
> +
> +	return nhi;
> +}
>  #endif
> diff --git a/include/uapi/linux/nexthop.h b/include/uapi/linux/nexthop.h
> index 7b61867..19a234a 100644
> --- a/include/uapi/linux/nexthop.h
> +++ b/include/uapi/linux/nexthop.h
> @@ -48,6 +48,7 @@ enum {
>  	 */
>  	NHA_GROUPS,	/* flag; only return nexthop groups in dump */
>  	NHA_MASTER,	/* u32;  only return nexthops with given master dev */
> +	NHA_FDB,	/* nexthop belongs to a bridge fdb */

please add the 'type' to the comment; I tried to make this uapi file
completely self-documenting. ie., no one should have to consult the code
to know what kind of attribute NHA_FDB is.

>  
>  	__NHA_MAX,
>  };
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 3957364..98f8d2a 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -33,6 +33,7 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
>  	[NHA_ENCAP]		= { .type = NLA_NESTED },
>  	[NHA_GROUPS]		= { .type = NLA_FLAG },
>  	[NHA_MASTER]		= { .type = NLA_U32 },
> +	[NHA_FDB]		= { .type = NLA_FLAG },
>  };
>  
>  static unsigned int nh_dev_hashfn(unsigned int val)
> @@ -107,6 +108,7 @@ static struct nexthop *nexthop_alloc(void)
>  		INIT_LIST_HEAD(&nh->fi_list);
>  		INIT_LIST_HEAD(&nh->f6i_list);
>  		INIT_LIST_HEAD(&nh->grp_list);
> +		INIT_LIST_HEAD(&nh->fdb_list);
>  	}
>  	return nh;
>  }
> @@ -227,6 +229,9 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
>  	if (nla_put_u32(skb, NHA_ID, nh->id))
>  		goto nla_put_failure;
>  
> +	if (nh->is_fdb_nh && nla_put_flag(skb, NHA_FDB))
> +		goto nla_put_failure;
> +
>  	if (nh->is_group) {
>  		struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
>  
> @@ -241,7 +246,7 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
>  		if (nla_put_flag(skb, NHA_BLACKHOLE))
>  			goto nla_put_failure;
>  		goto out;
> -	} else {
> +	} else if (!nh->is_fdb_nh) {
>  		const struct net_device *dev;
>  
>  		dev = nhi->fib_nhc.nhc_dev;
> @@ -393,6 +398,7 @@ static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
>  	unsigned int len = nla_len(tb[NHA_GROUP]);
>  	struct nexthop_grp *nhg;
>  	unsigned int i, j;
> +	u8 nhg_fdb = 0;
>  
>  	if (len & (sizeof(struct nexthop_grp) - 1)) {
>  		NL_SET_ERR_MSG(extack,
> @@ -421,6 +427,8 @@ static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
>  		}
>  	}
>  
> +	if (tb[NHA_FDB])
> +		nhg_fdb = 1;
>  	nhg = nla_data(tb[NHA_GROUP]);
>  	for (i = 0; i < len; ++i) {
>  		struct nexthop *nh;
> @@ -432,11 +440,16 @@ static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
>  		}
>  		if (!valid_group_nh(nh, len, extack))
>  			return -EINVAL;
> +		if (nhg_fdb && !nh->is_fdb_nh) {
> +			NL_SET_ERR_MSG(extack, "FDB Multipath group can only have fdb nexthops");
> +			return -EINVAL;
> +		}

you should check the reverse as well -- non-nhg_fdb can not use an fdb
nh. ie., a group can not be a mix of fdb and route entries.

Make sure the selftests covers the permutations as well.

>  	}
>  	for (i = NHA_GROUP + 1; i < __NHA_MAX; ++i) {
>  		if (!tb[i])
>  			continue;
> -
> +		if (tb[NHA_FDB])
> +			continue;
>  		NL_SET_ERR_MSG(extack,
>  			       "No other attributes can be set in nexthop groups");
>  		return -EINVAL;


