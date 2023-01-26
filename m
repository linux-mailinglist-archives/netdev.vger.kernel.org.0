Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6F267D8B8
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 23:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbjAZWpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 17:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjAZWpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 17:45:02 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58B2E3B3
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 14:45:01 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id qx13so9061327ejb.13
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 14:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iE05OBNMo3ni76Q952FJPiDeCM0tKQpiRcc9yap5LRk=;
        b=OCpuwxPm3MTKC4NFGxVbHE33IbNPBEo1Y6BEUx6MiRbPDf8mc32vn4xArGwTO8Pv5w
         FCo1dJVl/Vppujf9pqTTwrbVpz3WSI3sp2tXZZPoLEnXtNTWe09mYY95dZOo51VDSxFd
         oqDZTQsRpYw2CNEcx5SI80I4CB6Zk28FUL49vE7EfvAWcfAjDd8Yo6wyya+JQ2VMPFU8
         x+ymjnoOGIo6DbUxtKl82JiWneVXFH8Ov2LVnIMLJsSAEwmV/oEwJTBDYvOesW22dQ42
         nTkUbIOOy21HZJ5jLSqJsywOUcdjjSsvuoVQysYpAOVTT8BZYnbPXW9bNUuTwsF7rt6O
         reJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iE05OBNMo3ni76Q952FJPiDeCM0tKQpiRcc9yap5LRk=;
        b=MYm+YPnCe8fu/UVbk26kETbNzVt6sVyrjs/2GQL9Eovy5N3KZCXqV9w5pc6YbTS0Ko
         sC8o52eGw/E2v67aO3D44jpq2cZBuHTgk6D5MDKdR+4CYFYBhLpZBS3wmk+ofLy7rv9Z
         gfGdhMvQRPSyFqHR/vPIbeELbKyo3eAoC37GIgeF4Fnott2TlOabogapUu98yw+rLqyo
         LB6NZ5JILcxmTYC5ARryaxrNkgq+d81pzAao8hbBVI8/QrqeLRL4aOcwZIQA1Mvcsc6b
         CGaUZZ3C5aaVivIUHeqZnf8Xm1BriVjTdRJjPVjgeJ8vc6qOYLAvAJG0WLENq11p2eyt
         5xiA==
X-Gm-Message-State: AFqh2kqTgHD1CMtzl/yct9slPS/dWlo6GFYxFrB7rU5rhFntNpKLlkCH
        thYty7FkzBDEpa6zzyNPuuM=
X-Google-Smtp-Source: AMrXdXv7cSA9mZU4ret8ZfwrSyEIZliZVv6tq0jWHn6l9bxs8rwyAN01+t9ZKySG9jVFaRLKHF3FxA==
X-Received: by 2002:a17:906:70c7:b0:84c:a863:ebe6 with SMTP id g7-20020a17090670c700b0084ca863ebe6mr31751015ejk.43.1674773100137;
        Thu, 26 Jan 2023 14:45:00 -0800 (PST)
Received: from skbuf ([188.27.185.224])
        by smtp.gmail.com with ESMTPSA id ke24-20020a17090798f800b008639ddec882sm1223855ejc.56.2023.01.26.14.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 14:44:59 -0800 (PST)
Date:   Fri, 27 Jan 2023 00:44:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        bridge@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next] netlink: provide an ability to set default
 extack message
Message-ID: <20230126224457.lc2ly5k77gkhycwa@skbuf>
References: <2919eb55e2e9b92265a3ba600afc8137a901ae5f.1674760340.git.leon@kernel.org>
 <20230126223213.riq6i2gdztwuinwi@skbuf>
 <20230126143723.7593ce0b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126143723.7593ce0b@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 02:37:23PM -0800, Jakub Kicinski wrote:
> > I would somewhat prefer not doing this, and instead introducing a new
> > NL_SET_ERR_MSG_WEAK() of sorts.
> 
> That'd be my preference too, FWIW. It's only the offload cases which
> need this sort of fallback.
> 
> BTW Vladimir, I remember us discussing this. I was searching the
> archive as you sent this, but can't find the thread. Mostly curious
> whether I flip flipped on this or I'm not completely useless :)

What we discussed was on a patch of mine fixing "if (!extack->_msg)" to
"if (extack && !extack->_msg)". I never proposed a new macro wrapper
(you did), but I didn't do it at the time because it was a patch for
"net", and I forgot to put a reminder for the next net->net-next merge.
https://lore.kernel.org/netdev/20220822182523.6821e176@kernel.org/
And from there, out of sight, out of mind.
