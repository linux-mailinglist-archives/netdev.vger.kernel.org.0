Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939C8200036
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 04:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbgFSCaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 22:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgFSCaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 22:30:02 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E82BC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 19:30:01 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a45so3969715pje.1
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 19:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uw3OX6rtMGJGRHbABuVjkvmn/Gjsd0Hf58lh6cd3QXw=;
        b=RaLoKCBVwoWo1tLXPXtcKaTrzR4MwK8dOSFigvY0dDmTA5+MH7qGZXqRFaOWxCeA8b
         7ReKiELpFg+y42xdDTHrsB77aBWYdVyoohUnnp2afrQib/YC1LblgsNxjgbSkjf+/kyu
         ggAxXT3VZy7xfUOMx5j1Hsmd4v3HKAKgSFFOBCV4M5bzuDnfwy4gBohPRy4UnCfcG7xK
         D2Yijzp3w6tWNaVBTDi9jXsElj/xWEuRMY9Ceo4DfIsxV9xEYB40WyWi1uu2T/52i1C2
         UkY32xuhnAmgCnMM4F+KQxXQvClA19rvKu79Ed3h14czSUlcw34vvDaSBRaaFJOOcDo9
         FPSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uw3OX6rtMGJGRHbABuVjkvmn/Gjsd0Hf58lh6cd3QXw=;
        b=pClHZ0q8M6uCzxI8hVFi0ptehU2U2VsBp3MWMjGvuCbGYPDm2He8haDhRGTwWIsxZ4
         BIWY2YpKihavSZsqDZeZRPMj9Fg2LJTrOfkH7Nem8FUOhGsQaVGHvts5Zxwnf4R/YFq9
         BG8AVq165fCLN+iSb6Xds/TbzuYH6OvECvoEGI+WgNT2pbVD9SwMmxeoGDD7yBu3UD8J
         c52R4YrsuQZdYoz3GI0+CjNlcLQdsy7/WWe0wKQbl9WffAHoJN9C651gF2ncU7LhbsYN
         8ElN/YdlulWbIF1V2Zbjz9CCzSIpHAKN3lX5wWbAdjPWaIbN/jAAt6XSmODLLCkqDejm
         nALQ==
X-Gm-Message-State: AOAM533kpuWb+6ZZkW4yDMUUI5Et4vR1sOdNkiZQic9mWM7ux6ZoCLAD
        Z9DIS/XoNh3JQQmVpV1Si6noEqftjfM=
X-Google-Smtp-Source: ABdhPJw6NOln40umJeW7oELgKuttJXz/WmdG6HfOG+GYPAhPXFVlLachNf/q1sjBPT4VZUVMUX75mg==
X-Received: by 2002:a17:90a:250b:: with SMTP id j11mr1369129pje.194.1592533800547;
        Thu, 18 Jun 2020 19:30:00 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u19sm4434341pfk.98.2020.06.18.19.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 19:30:00 -0700 (PDT)
Date:   Fri, 19 Jun 2020 10:29:50 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     netdev@vger.kernel.org, lucien.xin@gmail.com,
        Simon Horman <simon.horman@netronome.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2] tc: m_tunnel_key: fix geneve opt output
Message-ID: <20200619022950.GY102436@dhcp-12-153.nay.redhat.com>
References: <20200618104420.499155-1-liuhangbin@gmail.com>
 <70911c86d54033c956cb06593858f6e0111eb58a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70911c86d54033c956cb06593858f6e0111eb58a.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 01:25:46PM +0200, Davide Caratti wrote:
> On Thu, 2020-06-18 at 18:44 +0800, Hangbin Liu wrote:
> > Commit f72c3ad00f3b changed the geneve option output from "geneve_opt"
> > to "geneve_opts", which may break the program compatibility. Reset
> > it back to geneve_opt.
> > 
> > Fixes: f72c3ad00f3b ("tc: m_tunnel_key: add options support for vxlan")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> >  tc/m_tunnel_key.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tc/m_tunnel_key.c b/tc/m_tunnel_key.c
> > index bfec9072..0074f744 100644
> > --- a/tc/m_tunnel_key.c
> > +++ b/tc/m_tunnel_key.c
> > @@ -534,7 +534,7 @@ static void tunnel_key_print_geneve_options(struct rtattr *attr)
> >  	struct rtattr *i = RTA_DATA(attr);
> >  	int ii, data_len = 0, offset = 0;
> >  	int rem = RTA_PAYLOAD(attr);
> > -	char *name = "geneve_opts";
> > +	char *name = "geneve_opt";
> >  	char strbuf[rem * 2 + 1];
> >  	char data[rem * 2 + 1];
> >  	uint8_t data_r[rem];
> 
> ... by the way, this patch does not look good to me. It fixes program
> compatibility for 
> 
> # tc action show 
> 
> but at the same time, I think it breaks program compatibility for
> 
> # tc -j action show

Ah, sorry, I'm not familiar with json output and forgot to check it.
Thanks for the remind.

> 
> see below: looking at commit f72c3ad00f3b,
> 
>  static void tunnel_key_print_tos_ttl(FILE *f, char *name,
> @@ -519,8 +586,7 @@ static int print_tunnel_key(struct action_util *au, FILE *f, struct rtattr *arg)
>                                         tb[TCA_TUNNEL_KEY_ENC_KEY_ID]);
>                 tunnel_key_print_dst_port(f, "dst_port",
>                                           tb[TCA_TUNNEL_KEY_ENC_DST_PORT]);
> -               tunnel_key_print_key_opt("geneve_opts",
> -                                        tb[TCA_TUNNEL_KEY_ENC_OPTS]);
> +               tunnel_key_print_key_opt(tb[TCA_TUNNEL_KEY_ENC_OPTS])
> 
> here "name" was "geneve_opts", with the 's', and it was used here:
> 
> 		open_json_array(PRINT_JSON, name);
> 
> so, the proper way to restore script compatibility is to do something
> like:
> 
> -	print_string(PRINT_FP, name, "\t%s ", name);
> +	print_string(PRINT_FP, NULL, "\t%s ", "geneve_opt");
> 
> yes, we can "harmonize" like Simon proposed, but then the fix in the
> (currently broken) tdc test case should accept both 'geneve_opts' and
> 'geneve_opt'. Something similar has been done in the past for act_ife 
> see net.git commit 91fa038d9446 ("selftests: tc-testing: fix parsing of
> ife type").

From semantics, it looks more reasonable to output "geneve_opts" as the
parameter is "geneve_opts", which is also symmetry with vxlan.

So I'm going to fix the tdc to accept both 'geneve_opts' and 'geneve_opt'.

Thanks
Hangbin
