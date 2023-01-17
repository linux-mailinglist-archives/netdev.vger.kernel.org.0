Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27AA66D9B0
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236076AbjAQJTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236616AbjAQJSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:18:35 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B1136FD5;
        Tue, 17 Jan 2023 01:13:32 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id vw16so10663333ejc.12;
        Tue, 17 Jan 2023 01:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5RK9gx2FO2xj5E74GBbtpYVjWU7Emn8D8XATkVEU73c=;
        b=D9HrA7pT1mwiAD78O1+F9zB38a8vxWno1Pv48KGKFeJEW8YZlXdhCPfaUafbb/9QXI
         Eb0unpSD/GF21wHdSMM+6gwcM+MlwEMf87bb9dZ8z9z7Zq6a0mbOlTuOhq/SHyECZ2Hu
         Qv4t21zon64F6ccLIeVA6z5IEQGU4bQTr7tleUYgHQMRIiu4yabAUqXWQssvd40+Dy/C
         yw8ryBMhlqp1jC4zhcB7q9EJM5y9mExLYw8FEWc/Gfq+VTJKzwFpA534U6X1yKGvGlBN
         3rHs+R0C4ApVgcJrypC2Two/ExqtVBJeA82qDF3drI2MGvpB2yNj1YoHD4p0FIBulkW4
         CLZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5RK9gx2FO2xj5E74GBbtpYVjWU7Emn8D8XATkVEU73c=;
        b=Puhl2z42RWlKcEJoKFDAMMKep8TebiQTuPpBra7fTWAF67VFayn+Rh4WhQXbkrhUuJ
         HjHxE5vasQsrmNpSN1rmcip04Dici6odrqM5Th2J61IHO6fEzkffXRELCZJdwTGvb046
         ErTQsgTpIbuSBF/552uwPpoU4ClyNp6M3Z9ANkBHzd5Ff6Wzj0xGS3w+e6CRPsYPDpeG
         N8XAXKq7rDOwcB9N5TduCz2RtgEy0mt3UXFlybqJ1EE2xRv+jWS1HyHZWziAXaX1uWrO
         tCaVmfNRs3wvy6N2n90Htx0e36HUMIOhqi+YTkJiwZ4xGi1N+G6mGim+4FzpGIM2znJO
         d+tg==
X-Gm-Message-State: AFqh2kr8C8sHGrfBYrv5pvuwD+UFU4oArG02U9s7UCiGeopdfgBlludq
        aDHqYKHQkY+elgclRq0RefY=
X-Google-Smtp-Source: AMrXdXsTE/VTZ//e99q1EewemnPQEv3c/W1akaXWmo5Oq/kEk/1Hzva1+qeFtfNWU8BmYXwf3UPxVg==
X-Received: by 2002:a17:906:b004:b0:872:aa82:ac56 with SMTP id v4-20020a170906b00400b00872aa82ac56mr1663786ejy.47.1673946811060;
        Tue, 17 Jan 2023 01:13:31 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id kz14-20020a17090777ce00b007c17b3a4163sm13080885ejc.15.2023.01.17.01.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 01:13:30 -0800 (PST)
Date:   Tue, 17 Jan 2023 10:13:30 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
Subject: Re: [PATCH net-next 1/1] ethtool/plca: fix potential NULL pointer
 access
Message-ID: <Y8ZmupvQv/N8561y@gvm01>
References: <6bb97c2304d9ab499c2831855f6bf3f6ee2b8676.1673913385.git.piergiorgio.beruto@gmail.com>
 <20230117003426.pzioywqybaxq4pzm@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117003426.pzioywqybaxq4pzm@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 02:34:26AM +0200, Vladimir Oltean wrote:
> On Tue, Jan 17, 2023 at 12:57:19AM +0100, Piergiorgio Beruto wrote:
> > Fix problem found by syzbot dereferencing a device pointer.
> > 
> > Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> > Reported-by: syzbot+8cf35743af243e5f417e@syzkaller.appspotmail.com
> > Fixes: 8580e16c28f3 ("net/ethtool: add netlink interface for the PLCA RS")
> > ---
> >  net/ethtool/plca.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/net/ethtool/plca.c b/net/ethtool/plca.c
> > index be7404dc9ef2..bc3d31f99998 100644
> > --- a/net/ethtool/plca.c
> > +++ b/net/ethtool/plca.c
> > @@ -155,6 +155,8 @@ int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
> >  		return ret;
> >  
> >  	dev = req_info.dev;
> > +	if(!dev)
> > +		return -ENODEV;
> 
> Shouldn't be necessary. The fact that you pass "true" to the
> "require_dev" argument of ethnl_parse_header_dev_get() takes care
> specifically of that.
> 
> Looking at that syzbot report, it looks like you solved it with commit
> 28dbf774bc87 ("plca.c: fix obvious mistake in checking retval"). Or was
> that not the only issue?
Oh, I believe you are correct.
I probably confused which version the bug was reported against.

Please, ignore this patch...
Thanks!

Piergiorgio

> 
> >  
> >  	rtnl_lock();
> >  
> > -- 
> > 2.37.4
> > 
