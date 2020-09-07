Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE5125F7B9
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgIGKTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbgIGKTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 06:19:40 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B03C061574
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 03:19:40 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id nw23so17519146ejb.4
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 03:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FKt9Ni9znuL/T5DiGGNRnDoYpXehn3oQFsifjWsLIGg=;
        b=jly9ZVPylGHnaA+MOBaKixpbQj5+JlStiySeH3qn/+1+oel+sLn8P3AxtDuy86A9E2
         aBA7e02V9MlJkZWCwqGAO7lNmM8GX+GrZrx1zk5w0+fCUh1EpztHwVAWcJDVm9Y7fEGg
         2m5QsBOnlUHDNyPcxyZe09vLh+RPWnGTVP9UWCWEu+ngMY1yHWJt5DpSUPcpYLU+gqN0
         mgNSUeC3kxF7QdjK6Hs+mWgqPWS6pIxQAHaCY7jL7bsnKzSuqLlvNb+pV/zovO7EzOVS
         asLiNuvQxlLLbdHrnWFFP0FrkPfHk5/5uyXqZJittIhL9QkDkhiE5Gv7JwRM8eVzgpfW
         GKNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FKt9Ni9znuL/T5DiGGNRnDoYpXehn3oQFsifjWsLIGg=;
        b=QDvSYzrcVZWTda8olRzq5Cy/i5zQqd4GiAZt6M9k9F2jfIQZVNeWPXrzKbHiwSnBT7
         Z7+Nc+ryx7jRUWqa4+HshnS5GQCEuc5DNCjXFSLHoXbfVIddtMksRhzgojkwCaCGe+Mf
         Az4eYvzbZ5IrW99juUsa2Tg5FGGIYKYhgtezloNLcu9IbqWZsAs9uCdYExluC9S2VMbU
         xn0NsakI56hlforlPF4DBWHDnOuQrJVuMSLp9IxVWjRftcxSqcNUwME3jfu0PVSypkuY
         WuZ4LfVIDk+pJLwroyKPdcz+Eiuuvz0wkFmOtBq7JwTgsxLdf6myZtbYKMzuRLmjdbNn
         7JFw==
X-Gm-Message-State: AOAM5307CDp6lt8ylduttPAkdEG9RUha7rF6PtdoR7xnQxf+iE7ggZpt
        pCK2Mw0klR+4ysgsC7t6CW6IdA==
X-Google-Smtp-Source: ABdhPJzbbal6iYv3ya8B+7Go7waH2YQEAoZAbOw0/xIqd5/TAyHQHCWvPWecDtmFJ7wSJlJjsd9i7w==
X-Received: by 2002:a17:906:3e81:: with SMTP id a1mr19854774ejj.227.1599473979033;
        Mon, 07 Sep 2020 03:19:39 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id i15sm6834108edf.82.2020.09.07.03.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 03:19:38 -0700 (PDT)
Date:   Mon, 7 Sep 2020 12:19:36 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-net] netfilter: conntrack: nf_conncount_init is
 failing with IPv6 disabled
Message-ID: <20200907101934.GA3739@netronome.com>
References: <159897212470.60236.5737844268627410321.stgit@ebuild>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159897212470.60236.5737844268627410321.stgit@ebuild>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Pablo, netfilter-devel@vger.kernel.org

On Tue, Sep 01, 2020 at 04:56:02PM +0200, Eelco Chaudron wrote:
> The openvswitch module fails initialization when used in a kernel
> without IPv6 enabled. nf_conncount_init() fails because the ct code
> unconditionally tries to initialize the netns IPv6 related bit,
> regardless of the build option. The change below ignores the IPv6
> part if not enabled.
> 
> Note that the corresponding _put() function already has this IPv6
> configuration check.
> 
> Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> ---
>  net/netfilter/nf_conntrack_proto.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
> index 95f79980348c..47e9319d2cf3 100644
> --- a/net/netfilter/nf_conntrack_proto.c
> +++ b/net/netfilter/nf_conntrack_proto.c
> @@ -565,6 +565,7 @@ static int nf_ct_netns_inet_get(struct net *net)
>  	int err;
>  
>  	err = nf_ct_netns_do_get(net, NFPROTO_IPV4);
> +#if IS_ENABLED(CONFIG_IPV6)
>  	if (err < 0)
>  		goto err1;
>  	err = nf_ct_netns_do_get(net, NFPROTO_IPV6);
> @@ -575,6 +576,7 @@ static int nf_ct_netns_inet_get(struct net *net)
>  err2:
>  	nf_ct_netns_put(net, NFPROTO_IPV4);
>  err1:
> +#endif
>  	return err;
>  }
>  
> 
