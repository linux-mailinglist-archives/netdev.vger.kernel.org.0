Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B56DCF994
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 14:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbfJHMMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 08:12:35 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35774 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730768AbfJHMMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 08:12:33 -0400
Received: by mail-qt1-f193.google.com with SMTP id m15so24910340qtq.2
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 05:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YAkr70YH+ASaz/ujbG8kEwG0JtXDGdUFVVoiLhfVswg=;
        b=WtSaordhBxdgXF07sEuWd1GxYwkVGUmHz8mO340rkHsUBKKnmyAp2GICf7GpK4aQ2d
         eq3L8e3RWVCp9msI8I5/0OcYhdXXFuy7kMvzKCwggTDVlk5AT7yO9pu/ftIxL0A+4Rst
         ih4z9CgZK2LxhMtiCJoSq0F1uWRQrrP/e4SYaEEqXH1w6yewJfzCKchl8p0YlSbYGRGj
         /ltDyw2033J1E2lb4ft+tGSFPzw28FLfo8cfLAyLH4ERDXxu76UMNd9ayApFcEYCF0Bq
         fODosBOht9vX4FER39kJ3+ZSTud+VRtSKWsACqNUN+MKAGKE//MOL47zime0732kibUy
         k8yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YAkr70YH+ASaz/ujbG8kEwG0JtXDGdUFVVoiLhfVswg=;
        b=DfnM5JvWnQKeB9COOT/SKrTgQCaBUEsH+b3twnKlGR50/cHXzKoW7uopm78herEk0p
         uvQROAKBTn8IUwZp6gufXPjl7kX90Ic6kItktoCWqGuQ5Kn3XEYQw1Vzg7RM9VhxCqDo
         fAqmiWhXgrZ2uxxsWjbG0rDkVJgBplFPe5wvm18TwYcs8VJ9fN/dtdMIxcAT7V6M0K4K
         L7C7nIvyPCZsGHU9T068wpoW6Ump6rwnAzgtp4ZSGIeSm4f95Gr1T+RuaUbPyLRUVKUr
         yWqKqVHfPtzQD6HfrKp9Cs21PgUD7uXkHX+ndhe+vJdiPbPn8XbeN/XAG1ZJ1VPkiGF4
         hx/w==
X-Gm-Message-State: APjAAAWCFas5LSLL7kKngmeAy+gFTKTNRE6SY15hAUDl23oEgbfbwHO5
        Izz8UekMynsgK5yp67SbaWg=
X-Google-Smtp-Source: APXvYqy/F/3QSwBnXVxvFDr9oQZj6mZe2KgwIAEGvPdlJiJVcQka3WO7NT5G0TJyFytLflBtgh/HVg==
X-Received: by 2002:ac8:3364:: with SMTP id u33mr35476473qta.187.1570536752231;
        Tue, 08 Oct 2019 05:12:32 -0700 (PDT)
Received: from localhost.localdomain ([177.220.176.151])
        by smtp.gmail.com with ESMTPSA id b4sm9506227qkd.121.2019.10.08.05.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 05:12:31 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 5BC89C07B5; Tue,  8 Oct 2019 09:12:29 -0300 (-03)
Date:   Tue, 8 Oct 2019 09:12:29 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] net_sched: fix backward compatibility for
 TCA_ACT_KIND
Message-ID: <20191008121229.GR3431@localhost.localdomain>
References: <20191007202629.32462-2-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007202629.32462-2-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 01:26:29PM -0700, Cong Wang wrote:
> For TCA_ACT_KIND, we have to keep the backward compatibility too,
> and rely on nla_strlcpy() to check and terminate the string with
> a NUL.
> 
> Note for TC actions, nla_strcmp() is already used to compare kind
> strings, so we don't need to fix other places.
> 
> Fixes: 199ce850ce11 ("net_sched: add policy validation for action attributes")
> Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/sched/act_api.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index da99667589f8..4684f2f24b17 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -832,8 +832,7 @@ static struct tc_cookie *nla_memdup_cookie(struct nlattr **tb)
>  }
>  
>  static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
> -	[TCA_ACT_KIND]		= { .type = NLA_NUL_STRING,
> -				    .len = IFNAMSIZ - 1 },
> +	[TCA_ACT_KIND]		= { .type = NLA_STRING },
>  	[TCA_ACT_INDEX]		= { .type = NLA_U32 },
>  	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
>  				    .len = TC_COOKIE_MAX_SIZE },
> @@ -865,8 +864,10 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  			NL_SET_ERR_MSG(extack, "TC action kind must be specified");
>  			goto err_out;
>  		}
> -		nla_strlcpy(act_name, kind, IFNAMSIZ);
> -
> +		if (nla_strlcpy(act_name, kind, IFNAMSIZ) >= IFNAMSIZ) {
> +			NL_SET_ERR_MSG(extack, "TC action name too long");
> +			goto err_out;
> +		}
>  		if (tb[TCA_ACT_COOKIE]) {
>  			cookie = nla_memdup_cookie(tb);
>  			if (!cookie) {
> -- 
> 2.21.0
> 
