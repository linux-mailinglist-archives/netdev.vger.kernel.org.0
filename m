Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E516461A3EC
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 23:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiKDWLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 18:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKDWLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 18:11:03 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643E52AE03
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 15:11:00 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id p16so3750047wmc.3
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 15:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=mDdFuTxc1NgIN17h4Sdpyhktg1KC+gZR966Qefhv/qY=;
        b=cG5lhiU6PhSS80azjo5xUxluwEkyvJoP9GJo9FVNCrjCUVU+ZP0eeNSNqqFMlWlMIk
         HMDknrh4NqIYfpxSI5xSMUNjwFDwzLVFvsMVMBaLfpiGdNpxVzNgSGS78xWB4FQIi/qE
         wOCwrsyOsmKdT3iq7rjjmVu4ZUVyvZXRfCPFMY1N+Nl2tS7X1e3xdhmJMDjzuYwoZZSr
         PwCruyu8BI4rHxEhI0IgpPKZqrb77Tjgl8W1oTVchA2cpdH0cYda6l6xqja6GWbfWLHF
         4jNLDA2rFUCNRMHbcuqaT0SCu5QnoPKyD7/1HdpaPwisbppYDN0z9UQejI5bmOrtSQW/
         I7XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mDdFuTxc1NgIN17h4Sdpyhktg1KC+gZR966Qefhv/qY=;
        b=HfZtYfX+1ZQGcuYJRtD1jXgIs6YD5le4h/mG6fJVWO4sSVxqNqIP+NqaBsLPZjm46n
         OZOikQrGWwHqRM2O9Rzf7258FJIpaIoddBHwpawXPcdEe1H84BprMrYHZ4ezQ2e7qLW7
         4rTNjVEGnBVkN5tEB11+n3NQxEspX5hn6LSc0uUdtNF+FPleP+RII6UOQG2w2xmiz9Pc
         +tEqVGIl75p2e3D4ghaDjoVtevIzdY99upoST5Z7qqJm4g+WI0q3QmtJwxvSPQMx0dXO
         V4DQ5whpK6IEnxAK8Tf/aHV2bah6R9+l2P4rRYy5ENLBaIRmNozHavB5zbNF3QAItGzr
         Pltw==
X-Gm-Message-State: ACrzQf1rVQ8STuFVclUoxNGzHDpooiSeYHP50pGye40jbabBfnbcRqF/
        qD56FjZW2t5yD4dlCN77Mval6A==
X-Google-Smtp-Source: AMsMyM770RhGUechExYdaw0drE9ht9azt0T4IhGS7QvBHcMDswEP8Kk4qlGWIkWKPUVR32ubwzyrfw==
X-Received: by 2002:a1c:f009:0:b0:3b4:9398:49c9 with SMTP id a9-20020a1cf009000000b003b4939849c9mr35213286wmb.174.1667599859051;
        Fri, 04 Nov 2022 15:10:59 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:58af:dfc5:5988:a97d? ([2a01:e0a:b41:c160:58af:dfc5:5988:a97d])
        by smtp.gmail.com with ESMTPSA id g17-20020a5d46d1000000b0022efc4322a9sm435410wrs.10.2022.11.04.15.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 15:10:58 -0700 (PDT)
Message-ID: <cea8a3b5-135b-efc6-ae8d-2a27c1db3b5f@6wind.com>
Date:   Fri, 4 Nov 2022 23:10:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v2 12/13] genetlink: allow families to use split
 ops directly
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, gnault@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de
References: <20221102213338.194672-1-kuba@kernel.org>
 <20221102213338.194672-13-kuba@kernel.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20221102213338.194672-13-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 02/11/2022 à 22:33, Jakub Kicinski a écrit :
> Let families to hook in the new split ops.
> 
> They are more flexible and should not be much larger than
> full ops. Each split op is 40B while full op is 48B.
> Devlink for example has 54 dos and 19 dumps, 2 of the dumps
> do not have a do -> 56 full commands = 2688B.
> Split ops would have taken 2920B, so 9% more space while
> allowing individual per/post doit and per-type policies.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/net/genetlink.h |   5 ++
>  net/netlink/genetlink.c | 158 +++++++++++++++++++++++++++++++++-------
>  2 files changed, 137 insertions(+), 26 deletions(-)
> 
> diff --git a/include/net/genetlink.h b/include/net/genetlink.h
> index 4be7989c451b..d21210709f84 100644
> --- a/include/net/genetlink.h
> +++ b/include/net/genetlink.h
> @@ -46,6 +46,9 @@ struct genl_info;
>   * @n_ops: number of operations supported by this family
>   * @small_ops: the small-struct operations supported by this family
>   * @n_small_ops: number of small-struct operations supported by this family
> + * @split_ops: the split do/dump form of operation definition
> + * @n_split_ops: number of entries in @split_ops, not that with split do/dump
> + *	ops the number of entries is not the same as number of commands
>   *
>   * Attribute policies (the combination of @policy and @maxattr fields)
>   * can be attached at the family level or at the operation level.
> @@ -63,6 +66,7 @@ struct genl_family {
>  	u8			parallel_ops:1;
>  	u8			n_ops;
>  	u8			n_small_ops;
> +	u8			n_split_ops;
>  	u8			n_mcgrps;
>  	u8			resv_start_op;
>  	const struct nla_policy *policy;
> @@ -74,6 +78,7 @@ struct genl_family {
>  					     struct genl_info *info);
>  	const struct genl_ops *	ops;
>  	const struct genl_small_ops *small_ops;
> +	const struct genl_split_ops *split_ops;
>  	const struct genl_multicast_group *mcgrps;
>  	struct module		*module;
>  
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 0a4f1470f442..e95b984fcfe6 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -118,6 +118,16 @@ static const struct genl_family *genl_family_find_byname(char *name)
>  	return NULL;
>  }
>  
> +struct genl_op_iter {
> +	const struct genl_family *family;
> +	struct genl_split_ops doit;
> +	struct genl_split_ops dumpit;
> +	int cmd_idx;
> +	int entry_idx;
> +	u32 cmd;
> +	u8 flags;
> +};
> +
>  static void genl_op_from_full(const struct genl_family *family,
>  			      unsigned int i, struct genl_ops *op)
>  {
> @@ -176,6 +186,47 @@ static int genl_get_cmd_small(u32 cmd, const struct genl_family *family,
>  	return -ENOENT;
>  }
>  
> +static void genl_op_from_split(struct genl_op_iter *iter)
> +{
> +	const struct genl_family *family = iter->family;
> +	int i, cnt = 0;
> +
> +	i = iter->entry_idx - family->n_ops - family->n_small_ops;
> +
> +	if (family->split_ops[i + cnt].flags & GENL_CMD_CAP_DO) {
> +		iter->doit = family->split_ops[i + cnt];
> +		cnt++;
> +	} else {
> +		memset(&iter->doit, 0, sizeof(iter->doit));
> +	}
> +
> +	if (family->split_ops[i + cnt].flags & GENL_CMD_CAP_DUMP) {
> +		iter->dumpit = family->split_ops[i + cnt];
> +		cnt++;
> +	} else {
> +		memset(&iter->dumpit, 0, sizeof(iter->dumpit));
> +	}
> +
> +	WARN_ON(!cnt);
> +	iter->entry_idx += cnt;
> +}
> +
> +static int
> +genl_get_cmd_split(u32 cmd, u8 flag, const struct genl_family *family,
> +		   struct genl_split_ops *op)
> +{
> +	int i;
> +
> +	for (i = 0; i < family->n_split_ops; i++)
> +		if (family->split_ops[i].cmd == cmd &&
> +		    family->split_ops[i].flags & flag) {
> +			*op = family->split_ops[i];
> +			return 0;
> +		}
> +
> +	return -ENOENT;
> +}
> +
>  static int
>  genl_cmd_full_to_split(struct genl_split_ops *op,
>  		       const struct genl_family *family,
> @@ -227,50 +278,60 @@ genl_get_cmd(u32 cmd, u8 flags, const struct genl_family *family,
>  	err = genl_get_cmd_full(cmd, family, &full);
>  	if (err == -ENOENT)
>  		err = genl_get_cmd_small(cmd, family, &full);
> -	if (err) {
> -		memset(op, 0, sizeof(*op));
> -		return err;
> -	}
> +	/* Found one of legacy forms */
> +	if (err == 0)
> +		return genl_cmd_full_to_split(op, family, &full, flags);
>  
> -	return genl_cmd_full_to_split(op, family, &full, flags);
> +	err = genl_get_cmd_split(cmd, flags, family, op);
> +	if (err)
> +		memset(op, 0, sizeof(*op));
> +	return err;
>  }
>  
> -struct genl_op_iter {
> -	const struct genl_family *family;
> -	struct genl_split_ops doit;
> -	struct genl_split_ops dumpit;
> -	int i;
> -	u32 cmd;
> -	u8 flags;
> -};
> -
>  static bool
>  genl_op_iter_init(const struct genl_family *family, struct genl_op_iter *iter)
>  {
>  	iter->family = family;
> -	iter->i = 0;
> +	iter->cmd_idx = 0;
> +	iter->entry_idx = 0;
>  
>  	iter->flags = 0;
>  
> -	return iter->family->n_ops + iter->family->n_small_ops;
> +	return iter->family->n_ops +
> +		iter->family->n_small_ops +
> +		iter->family->n_split_ops;
>  }
>  
>  static bool genl_op_iter_next(struct genl_op_iter *iter)
>  {
>  	const struct genl_family *family = iter->family;
> +	bool legacy_op = true;
>  	struct genl_ops op;
>  
> -	if (iter->i < family->n_ops)
> -		genl_op_from_full(family, iter->i, &op);
> -	else if (iter->i < family->n_ops + family->n_small_ops)
> -		genl_op_from_small(family, iter->i - family->n_ops, &op);
> -	else
> +	if (iter->entry_idx < family->n_ops) {
> +		genl_op_from_full(family, iter->entry_idx, &op);
> +	} else if (iter->entry_idx < family->n_ops + family->n_small_ops) {
> +		genl_op_from_small(family, iter->entry_idx - family->n_ops,
> +				   &op);
> +	} else if (iter->entry_idx <
> +		   family->n_ops + family->n_small_ops + family->n_split_ops) {
> +		legacy_op = false;
> +		/* updates entry_idx */
> +		genl_op_from_split(iter);
> +	} else {
>  		return false;
> +	}
>  
> -	iter->i++;
> +	iter->cmd_idx++;
>  
> -	genl_cmd_full_to_split(&iter->doit, family, &op, GENL_CMD_CAP_DO);
> -	genl_cmd_full_to_split(&iter->dumpit, family, &op, GENL_CMD_CAP_DUMP);
> +	if (legacy_op) {
> +		iter->entry_idx++;
> +
> +		genl_cmd_full_to_split(&iter->doit, family,
> +				       &op, GENL_CMD_CAP_DO);
> +		genl_cmd_full_to_split(&iter->dumpit, family,
> +				       &op, GENL_CMD_CAP_DUMP);
> +	}
>  
>  	iter->cmd = iter->doit.cmd | iter->dumpit.cmd;
>  	iter->flags = iter->doit.flags | iter->dumpit.flags;
> @@ -286,7 +347,7 @@ genl_op_iter_copy(struct genl_op_iter *dst, struct genl_op_iter *src)
>  
>  static unsigned int genl_op_iter_idx(struct genl_op_iter *iter)
>  {
> -	return iter->i;
> +	return iter->cmd_idx;
>  }
>  
>  static int genl_allocate_reserve_groups(int n_groups, int *first_id)
> @@ -454,12 +515,24 @@ static void genl_unregister_mc_groups(const struct genl_family *family)
>  	}
>  }
>  
> +static bool genl_split_op_check(const struct genl_split_ops *op)
> +{
> +	if (WARN_ON(hweight8(op->flags & (GENL_CMD_CAP_DO |
> +					  GENL_CMD_CAP_DUMP)) != 1))
> +		return true;
> +	if (WARN_ON(!op->maxattr || !op->policy))
> +		return true;
> +	return false;
> +}
> +
>  static int genl_validate_ops(const struct genl_family *family)
>  {
>  	struct genl_op_iter i, j;
> +	unsigned int s;
>  
>  	if (WARN_ON(family->n_ops && !family->ops) ||
> -	    WARN_ON(family->n_small_ops && !family->small_ops))
> +	    WARN_ON(family->n_small_ops && !family->small_ops) ||
> +	    WARN_ON(family->n_split_ops && !family->split_ops))
>  		return -EINVAL;
>  
>  	for (genl_op_iter_init(family, &i); genl_op_iter_next(&i); ) {
> @@ -477,6 +550,39 @@ static int genl_validate_ops(const struct genl_family *family)
>  		}
>  	}
>  
> +	if (family->n_split_ops) {
> +		if (genl_split_op_check(&family->split_ops[0]))
> +			return -EINVAL;
> +	}
> +
> +	for (s = 1; s < family->n_split_ops; s++) {
> +		const struct genl_split_ops *a, *b;
> +
> +		a = &family->split_ops[s - 1];
> +		b = &family->split_ops[s];
> +
> +		if (genl_split_op_check(b))
> +			return -EINVAL;
> +
> +		/* Check sort order */
> +		if (a->cmd < b->cmd)
> +			continue;
If I understand correctly, the goal of the below checks, between a and b, is to
enforce flags consitency between the do and the dump.
Does this work if the cmds in the struct genl_split_ops are declared randomly (
ie the do and the dump are separated by another cmd)?

Except that, for the whole series:
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

> +
> +		if (a->internal_flags != b->internal_flags ||
> +		    ((a->flags ^ b->flags) & ~(GENL_CMD_CAP_DO |
> +					       GENL_CMD_CAP_DUMP))) {
> +			WARN_ON(1);
> +			return -EINVAL;
> +		}
> +
> +		if ((a->flags & GENL_CMD_CAP_DO) &&
> +		    (b->flags & GENL_CMD_CAP_DUMP))
> +			continue;
> +
> +		WARN_ON(1);
> +		return -EINVAL;
> +	}
> +
>  	return 0;
>  }
>  
