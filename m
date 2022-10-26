Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77FEC60D924
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 04:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiJZCRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 22:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbiJZCRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 22:17:12 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA99D8ECE
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 19:17:09 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso843377pjc.5
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 19:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0cQmrfoDym+v44QTaT6wM+3ISQsPfLOluxO0jA7h2Ec=;
        b=wKj+pdn8ufcU0tuTPrj+2kD4ngl+nn7uRn132Xfc3BFQ8RgtEV0Sk8xlQWHQPY8iI0
         Z1HvYlfEe6qCIyIXGq/Y9q3mXE/5I4lSVrKi+8nvtxT15rElU/ehy09GRoTWJCzzdcBx
         9UoKxmOyJ6y5QwU3eQ+gUy1aw5JHF8GLndQmVDhp3GuWSYGQ15LrqsZ2uJwswCyvhKW5
         f06q0FsMPL6sEBDtgJFeDGw8ZeSw7mamJpshm0LLmOJyFwtvCrcKgqfn7eESoFWW01n0
         H2b/R6IyLeQx9uH+HhKQIW6fkdI1G76ARV3vlMN/qUdzkHU0kwiMB2icsOzV5rnRbvSe
         jpGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0cQmrfoDym+v44QTaT6wM+3ISQsPfLOluxO0jA7h2Ec=;
        b=GXW5/OV1T2RSOvAZI/VskJoTbtcKF9eLJqM0J6c6Q4kINuvpAeSFVjBpkaKiV2Uqnq
         IqUn/Po/6GArCihDSPnmJ+51BoULj4oQZ7rrQi1PIOzWF+imVbKtZaoEUFP2vogm18pI
         4jQq2asVFfHNpwVYDc2KEvdbCmi9nkrNmRk0iTzEf0fDdDaLKQR2njFt9mTNMt+j3rj2
         JQGJeHfYuFL5untZvorm5mKJ3omV9kvKgA+Nz7Pf8Ru797RqoYpdGEdtu3ypPugkHgAK
         Cxj92aj55ZolNdeFnlBuoTW0dQs2OmXbL2UyACsA+xH/LBSNCsCihzWfWRfrR2KaKcAE
         h2tw==
X-Gm-Message-State: ACrzQf2RuRilba3x3iO/KZDqYrZE7X0ySWLwaFelhjl0uKFcR+jj9HhI
        Xfi39viy+7O8m7sXbXj0aKlq7w==
X-Google-Smtp-Source: AMsMyM4MP8eZMwVQqqmyhPhNg4g2hagkv0dT675c2qo6GdKtQb/rXbOwjlKkAPh5lM9GN9Y5HSAB+w==
X-Received: by 2002:a17:90b:17ca:b0:20d:76bb:3f8c with SMTP id me10-20020a17090b17ca00b0020d76bb3f8cmr1528345pjb.28.1666750628705;
        Tue, 25 Oct 2022 19:17:08 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id w12-20020a17090a4f4c00b0020ab246ac79sm230898pjl.47.2022.10.25.19.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 19:17:08 -0700 (PDT)
Date:   Tue, 25 Oct 2022 19:17:06 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Benjamin Poirier <bpoirier@nvidia.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH iproute2] ip-monitor: Do not error out when
 RTNLGRP_STATS is not available
Message-ID: <20221025191706.7c240d6a@hermes.local>
In-Reply-To: <20221025222909.1112705-1-bpoirier@nvidia.com>
References: <20220922082854.5aa1bffe@hermes.local>
        <20221025222909.1112705-1-bpoirier@nvidia.com>
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

On Wed, 26 Oct 2022 07:29:09 +0900
Benjamin Poirier <bpoirier@nvidia.com> wrote:

> Following commit 4e8a9914c4d4 ("ip-monitor: Include stats events in default
> and "all" cases"), `ip monitor` fails to start on kernels which do not
> contain linux.git commit 5fd0b838efac ("net: rtnetlink: Add UAPI toggle for
> IFLA_OFFLOAD_XSTATS_L3_STATS") because the netlink group RTNLGRP_STATS
> doesn't exist:
> 
>  $ ip monitor
>  Failed to add stats group to list
> 
> When "stats" is not explicitly requested, change the error to a warning so
> that `ip monitor` and `ip monitor all` continue to work on older kernels.
> 
> Note that the same change is not done for RTNLGRP_NEXTHOP because its value
> is 32 and group numbers <= 32 are always supported; see the comment above
> netlink_change_ngroups() in the kernel source. Therefore
> NETLINK_ADD_MEMBERSHIP 32 does not error out even on kernels which do not
> support RTNLGRP_NEXTHOP.
> 
> Reported-by: Stephen Hemminger <stephen@networkplumber.org>
> Fixes: 4e8a9914c4d4 ("ip-monitor: Include stats events in default and "all" cases")
> Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
> ---
>  ip/ipmonitor.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/ip/ipmonitor.c b/ip/ipmonitor.c
> index 8a72ea42..45e4e8f1 100644
> --- a/ip/ipmonitor.c
> +++ b/ip/ipmonitor.c
> @@ -195,6 +195,8 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
>  int do_ipmonitor(int argc, char **argv)
>  {
>  	unsigned int groups = 0, lmask = 0;
> +	/* "needed" mask */
> +	unsigned int nmask;
>  	char *file = NULL;
>  	int ifindex = 0;
>  
> @@ -253,6 +255,7 @@ int do_ipmonitor(int argc, char **argv)
>  	ipneigh_reset_filter(ifindex);
>  	ipnetconf_reset_filter(ifindex);
>  
> +	nmask = lmask;
>  	if (!lmask)
>  		lmask = IPMON_L_ALL;
>  
> @@ -328,8 +331,11 @@ int do_ipmonitor(int argc, char **argv)
>  
>  	if (lmask & IPMON_LSTATS &&
>  	    rtnl_add_nl_group(&rth, RTNLGRP_STATS) < 0) {
> +		if (!(nmask & IPMON_LSTATS))
> +			fprintf(stderr, "Warning: ");
>  		fprintf(stderr, "Failed to add stats group to list\n");
> -		exit(1);
> +		if (nmask & IPMON_LSTATS)
> +			exit(1);
>  	}
>  
>  	if (listen_all_nsid && rtnl_listen_all_nsid(&rth) < 0)

You still end up warning on older kernels. My version is simpler.
All needs to not include lstats
