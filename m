Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221AF2A0EA2
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 20:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbgJ3T0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 15:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727526AbgJ3TZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 15:25:40 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836CBC0613D2
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 12:25:40 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t6so3425984plq.11
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 12:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gwqDDwLjsVYw6Whxs6WBNDQqodgj/3KGgtAXZxmlzdc=;
        b=in5Ey64Ooa7h9u9fOLI75hRMHbBrWTVJ4fTHsuIRjGV28rrYyCZIMYHTYv5VM5FGtC
         qi6ok+56l3Jt27UzF3akA9pGaonaWrDiR5n1r2cJTK0M3+dISSQnwks9zKIdsJmVwwkg
         F3zf4CSNqHc+e5eN8drTa+2k0VX4ySRLdoHB4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gwqDDwLjsVYw6Whxs6WBNDQqodgj/3KGgtAXZxmlzdc=;
        b=G/chV5OSSZ6DMl1UK2sQsOWcn81nqUz4tl/uvmiQsTW2ylvo82TfL8+Cf1tXOLmEaY
         hCnLoshGD+4vO+khLYD0pZvMVLEyeVoaIRcfDbSsUj9V9rr2BOWDZpyBOENSCtBT7CRB
         YI/GvGlp4pysHqHZPw8mZOqQ4kjXIrrhT73za0UwNewuH9Dj9IscQy73XgFgLnDGwRrC
         ZHB7zl8w6ueAKmfVgPMljYibFK05cRxprAVtCT1jK/HZqXb5VYuhdbtrCQnoOmjqa5sE
         Ri0m+DWkhxmVzPNz6qPLCodlsJ8dX5XRfEa0iGiKavb2icbtuRQ5kZ8jQw0WnF261lQ8
         g4GQ==
X-Gm-Message-State: AOAM532n+6/92lnyFplGzOhFhF764eyMjojFErvh4LdOxuEhpUQWNj28
        yK5nVs5xRjwRNdqRjSrUCYMA8SwHvmW+fw==
X-Google-Smtp-Source: ABdhPJzS7AYNBywkEkiPG3bwCpsnEKWb+YgsaJTHo362/atJQ2fZSXau2VlI8LwbB6SC2AXEvdlryg==
X-Received: by 2002:a17:902:b192:b029:d2:f08:f85a with SMTP id s18-20020a170902b192b02900d20f08f85amr10218034plr.49.1604085940123;
        Fri, 30 Oct 2020 12:25:40 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w19sm2254173pff.76.2020.10.30.12.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 12:25:39 -0700 (PDT)
Date:   Fri, 30 Oct 2020 12:25:38 -0700
From:   Kees Cook <keescook@chromium.org>
To:     laniel_francis@privacyrequired.com
Cc:     linux-hardening@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH v4 2/3] Modify return value of nla_strlcpy to match that
 of strscpy.
Message-ID: <202010301217.7EF0009E83@keescook>
References: <20201030153647.4408-1-laniel_francis@privacyrequired.com>
 <20201030153647.4408-3-laniel_francis@privacyrequired.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030153647.4408-3-laniel_francis@privacyrequired.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 04:36:46PM +0100, laniel_francis@privacyrequired.com wrote:
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index 2a76a2f5ed88..f9b053b30a7b 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1170,7 +1170,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
>  #ifdef CONFIG_MODULES
>  	if (ops == NULL && kind != NULL) {
>  		char name[IFNAMSIZ];
> -		if (nla_strlcpy(name, kind, IFNAMSIZ) < IFNAMSIZ) {
> +		if (nla_strlcpy(name, kind, IFNAMSIZ) > 0) {
>  			/* We dropped the RTNL semaphore in order to
>  			 * perform the module load.  So, even if we
>  			 * succeeded in loading the module we have to

Oops, I think this should be >= 0 ?

-- 
Kees Cook
