Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453B066E19C
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjAQPFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbjAQPEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:04:43 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2448E402E7;
        Tue, 17 Jan 2023 07:04:36 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id r132so15532464oif.10;
        Tue, 17 Jan 2023 07:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GfzRjVqZOgKHMd37XorWuzaDCz8WOqhomaL0sln2ZUU=;
        b=hI5U4D55JaoBBaMSkFb064qyoamsIotz+3b7NEdREfdh/7uoO7q+/kuggQYJRwhdO7
         nTE8ouV9G397qLveN0eKI9WfwvSfNT6DixH9k8Iaoz/YAP1yuI5qMgZkxIC8kUTpr9PT
         EAoFFi2akBF0jX4TlW9eNDJENK+rAfPUO+r74jZMNIHTjswwXGL2hEfycvwN/8Ps4HUE
         xOhUv6+N+kZonfPG+P+DvbkZDBusy94BlIU0debkfNnb/By8NXWR5boJFfQTaNhW4+Bp
         k9Xsj+pgRwOzgc2jYelcpMfv+4tyP6jdSMtTwe2zAf3yFjNRNZw7/fpzFgzIzd3otjxY
         9FbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GfzRjVqZOgKHMd37XorWuzaDCz8WOqhomaL0sln2ZUU=;
        b=d20TVFNcYHijLIwDVaL4I5FvCRD99onQvH2Zpw2bGx4mNVbos6l7LtWpMoLXD5bR1Y
         LmuSzXumiviMh7DayIZN50KS1+AIERo/dmNwytiYamfSIyj84eRJGPBsT0DOslzwhYPQ
         Ufoeau1tL/DWCaga5UtAG/Af6jms5OLCzWjJNqWPD5veen6F9VE/Tj5FVKdl6LDn9aFI
         5vTZGATbItPhxaywz59aODF+F4448Lfuv5IUOuX/LctWaoaGi2ksr97Pm04IPT7yRe2q
         enxK0KuLMVLKBq3RFg89Po/PxAt5h4RkWXioo/VUqcCldzoyrcYrijtLO2fL981hNmvH
         mn0Q==
X-Gm-Message-State: AFqh2kqhSD6UBuGhANyKHGJKfGzwCYbA4N9qnXMONM7gVEcGjS4LcHWZ
        1qnCX11xgIeHX2VafaGRC2mZFvw3LuU=
X-Google-Smtp-Source: AMrXdXv7K2Gw3e9yXPpqR9Yk6Caikg9fxWjjGZYl4xIoAtPLDH8why8ml2NdiapzZ5WlnUzvUMxSKQ==
X-Received: by 2002:a05:6808:4284:b0:369:8960:43b1 with SMTP id dq4-20020a056808428400b00369896043b1mr702812oib.43.1673967875267;
        Tue, 17 Jan 2023 07:04:35 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f013:7189:754f:dfa5:a770:f05f])
        by smtp.gmail.com with ESMTPSA id c132-20020aca358a000000b003646062e83bsm9814713oia.29.2023.01.17.07.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 07:04:34 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id AF9084AD1F3; Tue, 17 Jan 2023 12:04:32 -0300 (-03)
Date:   Tue, 17 Jan 2023 12:04:32 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ozsh@nvidia.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v2 1/7] net: flow_offload: provision conntrack
 info in ct_metadata
Message-ID: <Y8a5AOxlm5XsrYtT@t14s.localdomain>
References: <20230113165548.2692720-1-vladbu@nvidia.com>
 <20230113165548.2692720-2-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113165548.2692720-2-vladbu@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 05:55:42PM +0100, Vlad Buslov wrote:
...
>  struct flow_match {
> @@ -288,6 +289,7 @@ struct flow_action_entry {
>  		} ct;
>  		struct {
>  			unsigned long cookie;
> +			enum ip_conntrack_info ctinfo;
>  			u32 mark;
>  			u32 labels[4];
>  			bool orig_dir;
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 0ca2bb8ed026..515577f913a3 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -187,6 +187,7 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
>  	/* aligns with the CT reference on the SKB nf_ct_set */
>  	entry->ct_metadata.cookie = (unsigned long)ct | ctinfo;
                                                   ^^^^^^^^^^^

>  	entry->ct_metadata.orig_dir = dir == IP_CT_DIR_ORIGINAL;
> +	entry->ct_metadata.ctinfo = ctinfo;

tcf_ct_flow_table_restore_skb() is doing:
        enum ip_conntrack_info ctinfo = cookie & NFCT_INFOMASK;

Not sure if it really needs this duplication then.

>  
>  	act_ct_labels = entry->ct_metadata.labels;
>  	ct_labels = nf_ct_labels_find(ct);
> -- 
> 2.38.1
> 
