Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0868D3950A6
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 13:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhE3LUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 07:20:03 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:54464 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhE3LUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 07:20:03 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id AA3DE200E2B0;
        Sun, 30 May 2021 13:18:24 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be AA3DE200E2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1622373504;
        bh=3njf5qaZwQa4q8ExHo2GrrIcvLzfLI6KDkOrL1aNlFo=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=VPpMnYQE0rMK3ytetuAAaaBqlKVWS/1GDEXqc/nMLIDhHJHqUCyZlxeVQc552/sOD
         KzGzVKXI+IWO0lv9amz7dpDn93AS5Bn/vttoekU7khtClv+aJfn9rFQX7aE7jbq/pY
         M3h1Q5iKe3Ea0OKds3JeSOIB9zzZlQ9zG48bKwLHU0mH5IybIoemqVL0pc5P6pwUFY
         twKtIwaOh34iUIUHJpxAICWSYry2jN53KFWlNX24Le+vFK4jrtjX0yoMRM4+eVLHLC
         YsJHdYeEjSDZHSfB5mgwlE/lPiZJP0wCKj858+lDJWamkKkU+/aOi8yCGkrJm5gw5u
         SQcFcnFyid5OA==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id A2AD36008D455;
        Sun, 30 May 2021 13:18:24 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id VfnNgRuYen5u; Sun, 30 May 2021 13:18:24 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 8CBDE6008D34F;
        Sun, 30 May 2021 13:18:24 +0200 (CEST)
Date:   Sun, 30 May 2021 13:18:24 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Message-ID: <152739558.34126899.1622373504535.JavaMail.zimbra@uliege.be>
In-Reply-To: <20210529140601.1ab9d40e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20210527151652.16074-1-justin.iurman@uliege.be> <20210527151652.16074-4-justin.iurman@uliege.be> <20210529140601.1ab9d40e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Subject: Re: [PATCH net-next v4 3/5] ipv6: ioam: IOAM Generic Netlink API
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF88 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: IOAM Generic Netlink API
Thread-Index: xxMS1gGGZPsTS/2PY2gKBUaywyOSOg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, 27 May 2021 17:16:50 +0200 Justin Iurman wrote:
>> Add Generic Netlink commands to allow userspace to configure IOAM
>> namespaces and schemas. The target is iproute2 and the patch is ready.
>> It will be posted as soon as this patchset is merged. Here is an overview:
>> 
>> $ ip ioam
>> Usage:	ip ioam { COMMAND | help }
>> 	ip ioam namespace show
>> 	ip ioam namespace add ID [ DATA ]
>> 	ip ioam namespace del ID
>> 	ip ioam schema show
>> 	ip ioam schema add ID DATA
>> 	ip ioam schema del ID
>> 	ip ioam namespace set ID schema { ID | none }
>> 
>> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> 
>> +static int ioam6_genl_addns(struct sk_buff *skb, struct genl_info *info)
>> +{
>> +	struct ioam6_pernet_data *nsdata;
>> +	struct ioam6_namespace *ns;
>> +	__be16 ns_id;
>> +	int err;
>> +
>> +	if (!info->attrs[IOAM6_ATTR_NS_ID])
>> +		return -EINVAL;
>> +
>> +	ns_id = cpu_to_be16(nla_get_u16(info->attrs[IOAM6_ATTR_NS_ID]));
>> +	nsdata = ioam6_pernet(genl_info_net(info));
>> +
>> +	mutex_lock(&nsdata->lock);
>> +
>> +	ns = rhashtable_lookup_fast(&nsdata->namespaces, &ns_id, rht_ns_params);
>> +	if (ns) {
>> +		err = -EEXIST;
>> +		goto out_unlock;
>> +	}
>> +
>> +	ns = kzalloc(sizeof(*ns), GFP_KERNEL);
>> +	if (!ns) {
>> +		err = -ENOMEM;
>> +		goto out_unlock;
>> +	}
>> +
>> +	ns->id = ns_id;
>> +
>> +	if (!info->attrs[IOAM6_ATTR_NS_DATA]) {
>> +		ns->data = cpu_to_be64(IOAM6_EMPTY_u64);
>> +	} else {
>> +		ns->data = cpu_to_be64(
>> +				nla_get_u64(info->attrs[IOAM6_ATTR_NS_DATA]));
> 
> Store data in a temporary variable to avoid this long line.

ACK, will do. The reason for it is that I didn't want to increase the stack of ioam6_genl_addns unnecessarily. But I'm OK with that.

> 
>> +	}
> 
> braces unnecessary

ACK.

> 
>> +	err = rhashtable_lookup_insert_fast(&nsdata->namespaces, &ns->head,
>> +					    rht_ns_params);
>> +	if (err)
>> +		kfree(ns);
>> +
>> +out_unlock:
>> +	mutex_unlock(&nsdata->lock);
>> +	return err;
>> +}
>> +
>> +static int ioam6_genl_delns(struct sk_buff *skb, struct genl_info *info)
>> +{
>> +	struct ioam6_pernet_data *nsdata;
>> +	struct ioam6_namespace *ns;
>> +	struct ioam6_schema *sc;
>> +	__be16 ns_id;
>> +	int err;
>> +
>> +	if (!info->attrs[IOAM6_ATTR_NS_ID])
>> +		return -EINVAL;
>> +
>> +	ns_id = cpu_to_be16(nla_get_u16(info->attrs[IOAM6_ATTR_NS_ID]));
>> +	nsdata = ioam6_pernet(genl_info_net(info));
>> +
>> +	mutex_lock(&nsdata->lock);
>> +
>> +	ns = rhashtable_lookup_fast(&nsdata->namespaces, &ns_id, rht_ns_params);
>> +	if (!ns) {
>> +		err = -ENOENT;
>> +		goto out_unlock;
>> +	}
>> +
>> +	sc = ns->schema;
>> +	err = rhashtable_remove_fast(&nsdata->namespaces, &ns->head,
>> +				     rht_ns_params);
>> +	if (err)
>> +		goto out_unlock;
>> +
>> +	if (sc)
>> +		sc->ns = NULL;
> 
> the sc <> ns pointers should be annotated with __rcu, and appropriate
> accessors used. At the very least the need READ/WRITE_ONCE().

I thought that, in this specific case, the mutex would be enough. Note that rcu is used everywhere else for both of them (see patch #2). Could you explain your reasoning? So I guess your comment also applies to other functions here (add/del, etc), where either ns or sc is accessed, right?

> 
>> +	ioam6_ns_release(ns);
>> +
>> +out_unlock:
>> +	mutex_unlock(&nsdata->lock);
>> +	return err;
>> +}
>> +
>> +static int ioam6_genl_addsc(struct sk_buff *skb, struct genl_info *info)
>> +{
>> +	struct ioam6_pernet_data *nsdata;
>> +	int len, len_aligned, err;
>> +	struct ioam6_schema *sc;
>> +	u32 sc_id;
>> +
>> +	if (!info->attrs[IOAM6_ATTR_SC_ID] || !info->attrs[IOAM6_ATTR_SC_DATA])
>> +		return -EINVAL;
>> +
>> +	sc_id = nla_get_u32(info->attrs[IOAM6_ATTR_SC_ID]);
>> +	nsdata = ioam6_pernet(genl_info_net(info));
>> +
>> +	mutex_lock(&nsdata->lock);
>> +
>> +	sc = rhashtable_lookup_fast(&nsdata->schemas, &sc_id, rht_sc_params);
>> +	if (sc) {
>> +		err = -EEXIST;
>> +		goto out_unlock;
>> +	}
>> +
>> +	sc = kzalloc(sizeof(*sc), GFP_KERNEL);
>> +	if (!sc) {
>> +		err = -ENOMEM;
>> +		goto out_unlock;
>> +	}
> 
> Why not store the data after the sc structure?
> 
> u8 data[] + struct_size()?

Indeed, an oversight. I'll move data after the ns pointer at the end of the sc struct and allocate it that way.

> 
>> +	len = nla_len(info->attrs[IOAM6_ATTR_SC_DATA]);
>> +	len_aligned = ALIGN(len, 4);
>> +
>> +	sc->data = kzalloc(len_aligned, GFP_KERNEL);
>> +	if (!sc->data) {
>> +		err = -ENOMEM;
>> +		goto free_sc;
>> +	}
>> +
>> +	sc->id = sc_id;
>> +	sc->len = len_aligned;
>> +	sc->hdr = cpu_to_be32(sc->id | ((u8)(sc->len / 4) << 24));
>> +
>> +	nla_memcpy(sc->data, info->attrs[IOAM6_ATTR_SC_DATA], len);
>> +
>> +	err = rhashtable_lookup_insert_fast(&nsdata->schemas, &sc->head,
>> +					    rht_sc_params);
>> +	if (err)
>> +		goto free_data;
>> +
>> +out_unlock:
>> +	mutex_unlock(&nsdata->lock);
>> +	return err;
>> +free_data:
>> +	kfree(sc->data);
>> +free_sc:
>> +	kfree(sc);
>> +	goto out_unlock;
>> +}
>> +
>> +static int ioam6_genl_ns_set_schema(struct sk_buff *skb, struct genl_info
>> *info)
>> +{
>> +	struct ioam6_pernet_data *nsdata;
>> +	struct ioam6_namespace *ns;
>> +	struct ioam6_schema *sc;
>> +	__be16 ns_id;
>> +	int err = 0;
> 
> No need to init.

ACK.

> 
>> +	u32 sc_id;
>> +
>> +	if (!info->attrs[IOAM6_ATTR_NS_ID] ||
>> +	    (!info->attrs[IOAM6_ATTR_SC_ID] &&
>> +	     !info->attrs[IOAM6_ATTR_SC_NONE]))
>> +		return -EINVAL;
>> +
>> +	ns_id = cpu_to_be16(nla_get_u16(info->attrs[IOAM6_ATTR_NS_ID]));
>> +	nsdata = ioam6_pernet(genl_info_net(info));
>> +
>> +	mutex_lock(&nsdata->lock);
>> +
>> +	ns = rhashtable_lookup_fast(&nsdata->namespaces, &ns_id, rht_ns_params);
>> +	if (!ns) {
>> +		err = -ENOENT;
>> +		goto out_unlock;
>> +	}
>> +
>> +	if (info->attrs[IOAM6_ATTR_SC_NONE]) {
>> +		sc = NULL;
>> +	} else {
>> +		sc_id = nla_get_u32(info->attrs[IOAM6_ATTR_SC_ID]);
>> +		sc = rhashtable_lookup_fast(&nsdata->schemas, &sc_id,
>> +					    rht_sc_params);
>> +		if (!sc) {
>> +			err = -ENOENT;
>> +			goto out_unlock;
>> +		}
>> +	}
>> +
>> +	if (ns->schema)
>> +		ns->schema->ns = NULL;
>> +	ns->schema = sc;
>> +
>> +	if (sc) {
>> +		if (sc->ns)
>> +			sc->ns->schema = NULL;
>> +		sc->ns = ns;
>> +	}
>> +
>> +out_unlock:
>> +	mutex_unlock(&nsdata->lock);
>> +	return err;
>> +}
>> +
>> +static const struct genl_ops ioam6_genl_ops[] = {
>> +	{
>> +		.cmd	= IOAM6_CMD_ADD_NAMESPACE,
>> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>> +		.doit	= ioam6_genl_addns,
>> +		.flags	= GENL_ADMIN_PERM,
>> +	},
>> +	{
>> +		.cmd	= IOAM6_CMD_DEL_NAMESPACE,
>> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>> +		.doit	= ioam6_genl_delns,
>> +		.flags	= GENL_ADMIN_PERM,
>> +	},
>> +	{
>> +		.cmd	= IOAM6_CMD_DUMP_NAMESPACES,
>> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>> +		.start	= ioam6_genl_dumpns_start,
>> +		.dumpit	= ioam6_genl_dumpns,
>> +		.done	= ioam6_genl_dumpns_done,
>> +		.flags	= GENL_ADMIN_PERM,
>> +	},
>> +	{
>> +		.cmd	= IOAM6_CMD_ADD_SCHEMA,
>> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>> +		.doit	= ioam6_genl_addsc,
>> +		.flags	= GENL_ADMIN_PERM,
>> +	},
>> +	{
>> +		.cmd	= IOAM6_CMD_DEL_SCHEMA,
>> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>> +		.doit	= ioam6_genl_delsc,
>> +		.flags	= GENL_ADMIN_PERM,
>> +	},
>> +	{
>> +		.cmd	= IOAM6_CMD_DUMP_SCHEMAS,
>> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>> +		.start	= ioam6_genl_dumpsc_start,
>> +		.dumpit	= ioam6_genl_dumpsc,
>> +		.done	= ioam6_genl_dumpsc_done,
>> +		.flags	= GENL_ADMIN_PERM,
>> +	},
>> +	{
>> +		.cmd	= IOAM6_CMD_NS_SET_SCHEMA,
>> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>> +		.doit	= ioam6_genl_ns_set_schema,
>> +		.flags	= GENL_ADMIN_PERM,
>> +	},
>> +};
> 
> These days I think we should use policy tailored to each op, rather
> than a single policy per family. That way we don't ignore any
> attributes user may specify but kernel doesn't expect.

Is it already implemented that way somewhere, just to give me an example?
