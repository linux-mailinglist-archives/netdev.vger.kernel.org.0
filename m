Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED32165F85C
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 01:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbjAFAyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 19:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbjAFAyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 19:54:14 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B248F6953B
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 16:54:12 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id c8-20020a17090a4d0800b00225c3614161so3688226pjg.5
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 16:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X8PK6iMT/WLR6fGo0Ba+6J6ETk2Nj4JN0VxvFIeJVWA=;
        b=EBii/tDfbllLfxmKQTGC9eGsQZP+JzWZOU/OcdmUIgHLkC5xS57g4BMby3hbySWsS2
         V26vX1md0xLo2kkPlQpwhRWGMvHqsMJ65OoEufClT9WrYX5FkGKdOy7FNNGWltnRp0Q0
         GTSkqqVcMG0LElj6VdoDtDD+Pw8gpZPTCjGAk1iNmca3jtt1bAa8BQ45BfgBoNz7KcI7
         wGE+xR5cA4SzB7mKKkBhMVYTxcM/tWaMARBBQeFs62uX1/t6FSl8DIbj0Cyf2FUkjUyH
         oRzCiiaTtews6BN2dxSqpqxeHyRplf03nohD5T/x0DG6sCnpZ10OMN0L7dOWzfHtsoVJ
         Vmkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X8PK6iMT/WLR6fGo0Ba+6J6ETk2Nj4JN0VxvFIeJVWA=;
        b=Q7A5om4fLoUMssXEwHmbYtDh1MHz1LJj5Gq4o8JgYFg7lonpaMXxPSGgpcE1NgEW20
         HGVScniJrAcQT1dUU7+89KnpMlofxmZi5F06KyOg1r+dRYZHYAmf31bM+B+g5zUprThv
         94P/aEdAxFKiIbI2dNu0SWAULiO6R1th13m8W6m313tJqxp+wQKts7hXyGdl1v5R7cqJ
         w2NGtoZ3eZqAGyPe3dArFL2O5HxYiWZfI92Gy5ZJawMXaaYhV/xjS+OGrS2IuwpiP/Vl
         sQymkMp0KZYmBGtnoQ4h9DyIPbtUJAZhK7Wdl08ooYlB8jgsPyKd622Oh0fzoqRUSmDi
         sM7g==
X-Gm-Message-State: AFqh2kqYXQStaEQBUDoRZBidRNQVMKvKdp0BHq9bil6DV1qysya+2Mdn
        CU6bjDj7CN8srsNgobSj9CAbcXupr7PbOWE7
X-Google-Smtp-Source: AMrXdXtVBi+j81fCaXrykdipyHeiDqS6xqXZohTCBWugFO+GWUU2uHK6Zm+V7GiCrlReeS+rCUdLzA==
X-Received: by 2002:a05:6a21:3a94:b0:9d:efbe:52c3 with SMTP id zv20-20020a056a213a9400b0009defbe52c3mr65315934pzb.51.1672966452003;
        Thu, 05 Jan 2023 16:54:12 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id g19-20020a635213000000b0044ed37dbca8sm18511134pgb.2.2023.01.05.16.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 16:54:11 -0800 (PST)
Date:   Thu, 5 Jan 2023 16:54:10 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Max Tottenham <mtottenh@akamai.com>
Cc:     <netdev@vger.kernel.org>, <johunt@akamai.com>
Subject: Re: [PATCH iproute2-next] tc: Add JSON output to tc-class
Message-ID: <20230105165410.06a44d94@hermes.local>
In-Reply-To: <20230105142013.243810-2-mtottenh@akamai.com>
References: <20230105142013.243810-1-mtottenh@akamai.com>
        <20230105142013.243810-2-mtottenh@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Jan 2023 09:20:13 -0500
Max Tottenham <mtottenh@akamai.com> wrote:

>   * Add JSON formatted output to the `tc class show ...` command.
>   * Add JSON formatted output for the htb qdisc classes.
> 
> Signed-off-by: Max Tottenham <mtottenh@akamai.com>
> ---

This should target main not next because it does not require
any kernel changes.

> 
> diff --git a/tc/q_htb.c b/tc/q_htb.c
> index b5f95f67..c4e36f27 100644
> --- a/tc/q_htb.c
> +++ b/tc/q_htb.c
> @@ -307,27 +307,36 @@ static int htb_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>  		    RTA_PAYLOAD(tb[TCA_HTB_CEIL64]) >= sizeof(ceil64))
>  			ceil64 = rta_getattr_u64(tb[TCA_HTB_CEIL64]);
>  
> -		tc_print_rate(PRINT_FP, NULL, "rate %s ", rate64);
> +		tc_print_rate(PRINT_ANY, "rate", "rate %s ", rate64);
>  		if (hopt->rate.overhead)
> -			fprintf(f, "overhead %u ", hopt->rate.overhead);
> +			print_int(PRINT_ANY, "overhead", "overhead %u ", hopt->rate.overhead);

Should be print_uint() here.

>  		buffer = tc_calc_xmitsize(rate64, hopt->buffer);
>  
> -		tc_print_rate(PRINT_FP, NULL, "ceil %s ", ceil64);
> +		tc_print_rate(PRINT_ANY, "ceil", "ceil %s ", ceil64);
>  		cbuffer = tc_calc_xmitsize(ceil64, hopt->cbuffer);
>  		linklayer = (hopt->rate.linklayer & TC_LINKLAYER_MASK);
>  		if (linklayer > TC_LINKLAYER_ETHERNET || show_details)
> -			fprintf(f, "linklayer %s ", sprint_linklayer(linklayer, b3));
> +			print_string(PRINT_ANY, "linklayer", "linklayer %s ", sprint_linklayer(linklayer, b3));
>  		if (show_details) {
> -			print_size(PRINT_FP, NULL, "burst %s/", buffer);
> -			fprintf(f, "%u ", 1<<hopt->rate.cell_log);
> -			print_size(PRINT_FP, NULL, "mpu %s ", hopt->rate.mpu);
> -			print_size(PRINT_FP, NULL, "cburst %s/", cbuffer);
> -			fprintf(f, "%u ", 1<<hopt->ceil.cell_log);
> -			print_size(PRINT_FP, NULL, "mpu %s ", hopt->ceil.mpu);
> -			fprintf(f, "level %d ", (int)hopt->level);
> +			open_json_object("details");

The convention in iproute output is not to put extra details into
a sub object.

> +			char burst_buff[64] = {0};
> +			char rate_string[64] = {0};

These convention in iproute is to use SPRINT_BUF() macro and not to do unnecessary
initialization.

> +			sprint_size(buffer, burst_buff);
> +			snprintf(rate_string,  64, "%s/%u", burst_buff, 1<<hopt->rate.cell_log);

For an application using JSON best to make the size and cell_log two different objects.
This would also simplify the code since there would be one less temporary buffer.

> +
> +			print_string(PRINT_ANY, "burst", "burst %s ", rate_string);
> +			print_size(PRINT_ANY, "mpu_rate", "mpu %s ", hopt->rate.mpu);
> +
> +			sprint_size(cbuffer, burst_buff);
> +			snprintf(rate_string,  64, "%s/%u", burst_buff, 1<<hopt->ceil.cell_log);
> +			print_string(PRINT_ANY, "cburst", "cburst %s ", rate_string);
> +
> +			print_size(PRINT_ANY, "mpu_ceil", "mpu %s ", hopt->ceil.mpu);
> +			print_int(PRINT_ANY, "level", "level %d ", (int)hopt->level);
> +			close_json_object();
>  		} else {
> -			print_size(PRINT_FP, NULL, "burst %s ", buffer);
> -			print_size(PRINT_FP, NULL, "cburst %s ", cbuffer);
> +			print_size(PRINT_ANY, "burst", "burst %s ", buffer);
> +			print_size(PRINT_ANY, "cburst", "cburst %s", cbuffer);
>  		}
>  		if (show_raw)
>  			fprintf(f, "buffer [%08x] cbuffer [%08x] ",
> @@ -369,9 +378,11 @@ static int htb_print_xstats(struct qdisc_util *qu, FILE *f, struct rtattr *xstat
>  		return -1;
>  
>  	st = RTA_DATA(xstats);
> -	fprintf(f, " lended: %u borrowed: %u giants: %u\n",
> -		st->lends, st->borrows, st->giants);
> -	fprintf(f, " tokens: %d ctokens: %d\n", st->tokens, st->ctokens);
> +	print_uint(PRINT_ANY, "lended", " lended: %u ", st->lends);
> +	print_uint(PRINT_ANY, "borrowed", "borrowed: %u ", st->borrows);
> +	print_uint(PRINT_ANY, "giants", "giants: %u\n", st->giants);

Don't embed newline in format, instead use print_nl().
Then the command support single line mode.

> +	print_int(PRINT_ANY, "tokens", " tokens: %d ", st->tokens);
> +	print_int(PRINT_ANY, "ctokens", "ctokens: %d\n", st->ctokens);

Another case of print_nl()

>  	return 0;
>  }
>  
> diff --git a/tc/tc_class.c b/tc/tc_class.c
> index 1297d152..7788a667 100644
> --- a/tc/tc_class.c
> +++ b/tc/tc_class.c
> @@ -316,6 +316,8 @@ int print_class(struct nlmsghdr *n, void *arg)
>  		return -1;
>  	}
>  
> +	open_json_object(NULL);
> +
>  	if (show_graph) {
>  		graph_node_add(t->tcm_parent, t->tcm_handle, TCA_RTA(t), len);
>  		return 0;

Graph mode is not json ready.

> @@ -335,7 +337,7 @@ int print_class(struct nlmsghdr *n, void *arg)
>  	}
>  
>  	if (n->nlmsg_type == RTM_DELTCLASS)
> -		fprintf(fp, "deleted ");
> +		print_bool(PRINT_ANY, "deleted", "deleted ", true);

There are two ways of representing a flag: bool or using null.
Since this a presence style flag, the convention is to use print_null().


>  
>  	abuf[0] = 0;
>  	if (t->tcm_handle) {
> @@ -344,22 +346,24 @@ int print_class(struct nlmsghdr *n, void *arg)
>  		else
>  			print_tc_classid(abuf, sizeof(abuf), t->tcm_handle);
>  	}
> -	fprintf(fp, "class %s %s ", rta_getattr_str(tb[TCA_KIND]), abuf);
> +	print_string(PRINT_ANY, "class", "class %s ",  rta_getattr_str(tb[TCA_KIND]));
> +	print_string(PRINT_ANY, "handle", "%s ", abuf);
>  
>  	if (filter_ifindex == 0)
> -		fprintf(fp, "dev %s ", ll_index_to_name(t->tcm_ifindex));
> +		print_string(PRINT_ANY, "dev", "dev %s ", ll_index_to_name(t->tcm_ifindex));

Device name should be printed with color.

>  
>  	if (t->tcm_parent == TC_H_ROOT)
> -		fprintf(fp, "root ");
> +		print_bool(PRINT_ANY, "root", "root ", true);
>  	else {
>  		if (filter_qdisc)
>  			print_tc_classid(abuf, sizeof(abuf), TC_H_MIN(t->tcm_parent));
>  		else
>  			print_tc_classid(abuf, sizeof(abuf), t->tcm_parent);
> -		fprintf(fp, "parent %s ", abuf);
> +		print_string(PRINT_ANY, "parent", "parent %s ", abuf);
>  	}
>  	if (t->tcm_info)
> -		fprintf(fp, "leaf %x: ", t->tcm_info>>16);
> +		print_0xhex(PRINT_ANY, "leaf", "leaf %x", t->tcm_info>>16);
> +
>  	q = get_qdisc_kind(RTA_DATA(tb[TCA_KIND]));
>  	if (tb[TCA_OPTIONS]) {
>  		if (q && q->print_copt)
> @@ -367,19 +371,21 @@ int print_class(struct nlmsghdr *n, void *arg)
>  		else
>  			fprintf(stderr, "[cannot parse class parameters]");
>  	}
> -	fprintf(fp, "\n");
> +	print_string(PRINT_FP, NULL, "\n", NULL);

Use print_nl() instead.

>  	if (show_stats) {
>  		struct rtattr *xstats = NULL;
> -
> +		open_json_object("stats");

>  		if (tb[TCA_STATS] || tb[TCA_STATS2]) {
>  			print_tcstats_attr(fp, tb, " ", &xstats);
> -			fprintf(fp, "\n");
> +			print_string(PRINT_FP, NULL, "\n", NULL);
>  		}
>  		if (q && (xstats || tb[TCA_XSTATS]) && q->print_xstats) {
>  			q->print_xstats(q, fp, xstats ? : tb[TCA_XSTATS]);
> -			fprintf(fp, "\n");
> +			print_string(PRINT_FP, NULL, "\n", NULL);
>  		}
> +		close_json_object();
>  	}
> +	close_json_object();
>  	fflush(fp);
>  	return 0;
>  }
> @@ -450,11 +456,12 @@ static int tc_class_list(int argc, char **argv)
>  		perror("Cannot send dump request");
>  		return 1;
>  	}
> -
> +	new_json_obj(json);
>  	if (rtnl_dump_filter(&rth, print_class, stdout) < 0) {
>  		fprintf(stderr, "Dump terminated\n");
>  		return 1;
>  	}
> +	delete_json_obj();
>  
>  	if (show_graph)
>  		graph_cls_show(stdout, &buf[0], &root_cls_list, 0);

