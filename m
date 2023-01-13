Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0E9668A7F
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 05:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbjAMEAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 23:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbjAMEAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 23:00:37 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08721CFF1
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 20:00:35 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id b9-20020a17090a7ac900b00226ef160dcaso21426036pjl.2
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 20:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xk+SQeZSh4ZOjqjglnM/KaYTEasl87wK6AYFoV9ni48=;
        b=j3Fd1Mar3N0gXBNqzXjongQZCHhgZLaz+cPggF6eJRDqWifuV8D9MviriPbchI1WJA
         y7qZb/m/jgTnca8Nr3zaYFUccyGIUSzT/XDY/hKmEslvhUhpAz3WdmQBK6SK1+dcvGtr
         HO5yFWR90yoOmddNseisK5ATpaFRIUUWVV+mBep5N9PceYpdqQ8FGPi+W8Yzf4vd2olD
         HSYbgG6yofD/oMqY5EPi2GtpgiOyLIEaDmbHXzgrSqnMP8eXCStQ2gW4JrKCywfW5l3y
         AwSYVyMpZqa6kem2r9l2Ls98fpLuA7aoSRjh1QbOfotfjQS98aqapEx9cQd8dT/8kBYZ
         RBLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xk+SQeZSh4ZOjqjglnM/KaYTEasl87wK6AYFoV9ni48=;
        b=RFR5hDyzAlSKUSPjuQh4Jg2mEZiOT26aJHRSm6Orqt38QtqG/OiFQ8efDCXr3udx/6
         R1OU5SnkozlxNYoBgkBBfMm0iVyAQgDCr5OIIlMiWe4o0xPZ5tirw8cjLB7T3g01QTyL
         g7OIPqp9WzMrnNUjBZKOgNJZwRNnLnEa2kFDaDViT0YEK0FYkIK9nnz2smx4wNYPcitZ
         pMrDrq3uRSHhLJMxhYeiHvxfVvRj/HCykP3pU9jx5F4Ukk7PITPH8CD1BM2/syBNxfvl
         TmdTlFn64Y5/vrF78mcZ/lDhARTgaZXIneyz+JDv8oQZNHRd8m5/QYijwgKtoQUD7gX+
         GX8Q==
X-Gm-Message-State: AFqh2kqO6F+7CMdkZoKXygYdZ3pOb2/nAoZl/6nzINrtmYOxhBcZWjsG
        u3A6k6RahJql+wuje2ROvIAueBth4G++7zK5
X-Google-Smtp-Source: AMrXdXuZ42wa6bt6pFOo3AndTHH+0GOohokPGAUGVrzqMIX47GqCH0IJFz1z8qQcm0/7srCiBMQklQ==
X-Received: by 2002:a05:6a21:2d84:b0:b6:386c:d53c with SMTP id ty4-20020a056a212d8400b000b6386cd53cmr11526821pzb.59.1673582435282;
        Thu, 12 Jan 2023 20:00:35 -0800 (PST)
Received: from Laptop-X1 ([2409:8a02:781c:2330:c2cc:a0ba:7da8:3e4b])
        by smtp.gmail.com with ESMTPSA id h4-20020a056a00000400b00582f222f088sm6045407pfk.47.2023.01.12.20.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 20:00:34 -0800 (PST)
Date:   Fri, 13 Jan 2023 12:00:28 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next 2/2] tc: add new attr TCA_EXT_WARN_MSG
Message-ID: <Y8DXXJRa7m9liU+A@Laptop-X1>
References: <20230113034353.2766735-1-liuhangbin@gmail.com>
 <20230113034617.2767057-1-liuhangbin@gmail.com>
 <20230113034617.2767057-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113034617.2767057-2-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Oh, I forgot to add --no-thread when send this patch. Sorry if this makes
any trouble for you.

Hangbin

On Fri, Jan 13, 2023 at 11:46:17AM +0800, Hangbin Liu wrote:
> Currently, when the rule is not to be exclusively executed by the
> hardware, extack is not passed along and offloading failures don't
> get logged. Add a new attr TCA_EXT_WARN_MSG to log the extack message
> so we can monitor the HW failures. e.g.
> 
>   # tc monitor
>   added chain dev enp3s0f1np1 parent ffff: chain 0
>   added filter dev enp3s0f1np1 ingress protocol all pref 49152 flower chain 0 handle 0x1
>     ct_state +trk+new
>     not_in_hw
>           action order 1: gact action drop
>            random type none pass val 0
>            index 1 ref 1 bind 1
> 
>   Warning: mlx5_core: matching on ct_state +new isn't supported.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/uapi/linux/rtnetlink.h | 1 +
>  tc/m_action.c                  | 6 ++++++
>  tc/tc_filter.c                 | 5 +++++
>  tc/tc_qdisc.c                  | 6 ++++++
>  4 files changed, 18 insertions(+)
> 
> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> index f4a540c0..217b25b9 100644
> --- a/include/uapi/linux/rtnetlink.h
> +++ b/include/uapi/linux/rtnetlink.h
> @@ -635,6 +635,7 @@ enum {
>  	TCA_INGRESS_BLOCK,
>  	TCA_EGRESS_BLOCK,
>  	TCA_DUMP_FLAGS,
> +	TCA_EXT_WARN_MSG,
>  	__TCA_MAX
>  };
>  
> diff --git a/tc/m_action.c b/tc/m_action.c
> index b3fd0193..7121c2fb 100644
> --- a/tc/m_action.c
> +++ b/tc/m_action.c
> @@ -590,6 +590,12 @@ int print_action(struct nlmsghdr *n, void *arg)
>  
>  	open_json_object(NULL);
>  	tc_dump_action(fp, tb[TCA_ACT_TAB], tot_acts ? *tot_acts:0, false);
> +
> +	if (tb[TCA_EXT_WARN_MSG]) {
> +		print_string(PRINT_ANY, "Warn", "%s ", rta_getattr_str(tb[TCA_EXT_WARN_MSG]));
> +		print_nl();
> +	}
> +
>  	close_json_object();
>  
>  	return 0;
> diff --git a/tc/tc_filter.c b/tc/tc_filter.c
> index 71be2e81..dac74f58 100644
> --- a/tc/tc_filter.c
> +++ b/tc/tc_filter.c
> @@ -371,6 +371,11 @@ int print_filter(struct nlmsghdr *n, void *arg)
>  		print_nl();
>  	}
>  
> +	if (tb[TCA_EXT_WARN_MSG]) {
> +		print_string(PRINT_ANY, "Warn", "%s ", rta_getattr_str(tb[TCA_EXT_WARN_MSG]));
> +		print_nl();
> +	}
> +
>  	close_json_object();
>  	fflush(fp);
>  	return 0;
> diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
> index 33a6665e..a84602b4 100644
> --- a/tc/tc_qdisc.c
> +++ b/tc/tc_qdisc.c
> @@ -346,6 +346,12 @@ int print_qdisc(struct nlmsghdr *n, void *arg)
>  			print_nl();
>  		}
>  	}
> +
> +	if (tb[TCA_EXT_WARN_MSG]) {
> +		print_string(PRINT_ANY, "Warn", "%s ", rta_getattr_str(tb[TCA_EXT_WARN_MSG]));
> +		print_nl();
> +	}
> +
>  	close_json_object();
>  	fflush(fp);
>  	return 0;
> -- 
> 2.38.1
> 
