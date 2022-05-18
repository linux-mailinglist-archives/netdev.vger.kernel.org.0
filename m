Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C1252B071
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 04:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbiERCTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 22:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbiERCTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 22:19:02 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE861B96;
        Tue, 17 May 2022 19:19:01 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id i24so811145pfa.7;
        Tue, 17 May 2022 19:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i8M8Z58/S4T70xu3ij6nwxp0vCG1VpWVG/K86RO/OHQ=;
        b=oRpBaAQfMPXFHgxB0PgucXXcDl6TY/CTTaxyyDRbv/VsfyDOXQ0393OJvGm1s9zgWx
         dkErw99zOrw/OB55QKRSS5dE8PzpUt2MldLrJ28y9rQspOVY6PLbRn8T0jBY25H45w7w
         RKJN4y6YhIjjN0kQ2kbRWQ/a+IZdUZG1H4orncHmutwALOUhxcUOUD3o9xNVjyWbnMHH
         Wlc1Ar3CGCax1ZhIBeN+n83ncZNjY8M8veNTaIkGoI0L4YGvs1b1zDZdqDSoCjtXyrLf
         LoibZ0Uq96wDWhGLkhnBcX2fmhRnAIsS8EN51ohKL6KUYuB4qsWWKlM7nQdeHUwG5vNb
         qJ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i8M8Z58/S4T70xu3ij6nwxp0vCG1VpWVG/K86RO/OHQ=;
        b=t8prXJNHgB9rzD8duYaNkluDGibS8zMsy3Kv0tPyUGTQmb37WZxD6XLT4j6YqW0ftc
         Si+avbfEwXp8gQL2ubg3ESYYeY9Bki+gW+OYrNaREl9jU7FdOp/zqzqGcylrVbEGbQbX
         ou/CA4qLM60RpG9xfP5fhD2EltN7J1pLQjMgGxOithZ4Hlx/k3uOYkO2j3VCGaM5DGdh
         rmo472R33njqIzBXoyWlIqfoD1RoD/yiHLqh8mfMZu1FBDWwd5pPU0mWZaCl0pIcFFvc
         Ya2uj2nmOWvX8J7y9mbmfQWeDhfecPI0DvDCl/ztLW5DCPtfNicbiVwKcOadaD5OeLuF
         y/EA==
X-Gm-Message-State: AOAM5337p2WBUV451exC7YmGtk4AslKBU7492P/L0u+Ud8Xd9/mW6XhK
        Y6Cf9sy7F9u0ZE7AxedsCiE=
X-Google-Smtp-Source: ABdhPJxxBCnKg3Xt8Ke3h78/qoXSL7J69Mh7fytNPHTnM6cZz283dQhxfZHuGFAOQg/TlYZ+0piWTA==
X-Received: by 2002:a63:574d:0:b0:3db:4d75:70f3 with SMTP id h13-20020a63574d000000b003db4d7570f3mr21614428pgm.10.1652840341200;
        Tue, 17 May 2022 19:19:01 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f23-20020a170902ab9700b0015e8d4eb26dsm283271plr.183.2022.05.17.19.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 19:19:00 -0700 (PDT)
Date:   Wed, 18 May 2022 10:18:53 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     andy@greyhouse.net, davem@davemloft.net, dsahern@gmail.com,
        eric.dumazet@gmail.com, j.vosburgh@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com,
        vfalico@gmail.com, vladimir.oltean@nxp.com,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 net] bonding: fix missed rcu protection
Message-ID: <YoRXjeCR2bbr5qzF@Laptop-X1>
References: <20220517082312.805824-1-liuhangbin@gmail.com>
 <a4ed2a83d38a58b0984edb519382c867204b7ea2.1652804144.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4ed2a83d38a58b0984edb519382c867204b7ea2.1652804144.git.jtoppins@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 01:32:58PM -0400, Jonathan Toppins wrote:
> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
> ---
> RESEND, list still didn't receive my last version
> 
> The diffstat is slightly larger but IMO a slightly more readable version.
> When I was reading v2 I found myself jumping around.

Hi Jon,

Thanks for the commit. But..

> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 38e152548126..f9d27b63c454 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -5591,23 +5591,32 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
>  	const struct ethtool_ops *ops;
>  	struct net_device *real_dev;
>  	struct phy_device *phydev;
> +	int ret = 0;
>  
> +	rcu_read_lock();
>  	real_dev = bond_option_active_slave_get_rcu(bond);
> -	if (real_dev) {
> -		ops = real_dev->ethtool_ops;
> -		phydev = real_dev->phydev;
> -
> -		if (phy_has_tsinfo(phydev)) {
> -			return phy_ts_info(phydev, info);
> -		} else if (ops->get_ts_info) {
> -			return ops->get_ts_info(real_dev, info);
> -		}
> -	}
> +	if (real_dev)
> +		dev_hold(real_dev);
> +	rcu_read_unlock();
> +
> +	if (!real_dev)
> +		goto software;
>  
> +	ops = real_dev->ethtool_ops;
> +	phydev = real_dev->phydev;
> +
> +	if (phy_has_tsinfo(phydev))
> +		ret = phy_ts_info(phydev, info);
> +	else if (ops->get_ts_info)
> +		ret = ops->get_ts_info(real_dev, info);
	else {
		dev_put(real_dev);
		goto software;
	}

Here we need another check and goto software if !phy_has_tsinfo() and
no ops->get_ts_info. With this change we also have 2 goto and dev_put().

> +
> +	dev_put(real_dev);
> +	return ret;
> +
> +software:
>  	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
>  				SOF_TIMESTAMPING_SOFTWARE;
>  	info->phc_index = -1;
> -
>  	return 0;
>  }

As Jakub remind, dev_hold() and dev_put() can take NULL now. So how about
this new patch:

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 38e152548126..b5c5196e03ee 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5591,16 +5591,23 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 	const struct ethtool_ops *ops;
 	struct net_device *real_dev;
 	struct phy_device *phydev;
+	int ret = 0;
 
+	rcu_read_lock();
 	real_dev = bond_option_active_slave_get_rcu(bond);
+	dev_hold(real_dev);
+	rcu_read_unlock();
+
 	if (real_dev) {
 		ops = real_dev->ethtool_ops;
 		phydev = real_dev->phydev;
 
 		if (phy_has_tsinfo(phydev)) {
-			return phy_ts_info(phydev, info);
+			ret = phy_ts_info(phydev, info);
+			goto out;
 		} else if (ops->get_ts_info) {
-			return ops->get_ts_info(real_dev, info);
+			ret = ops->get_ts_info(real_dev, info);
+			goto out;
 		}
 	}
 
@@ -5608,7 +5615,9 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 				SOF_TIMESTAMPING_SOFTWARE;
 	info->phc_index = -1;
 
-	return 0;
+out:
+	dev_put(real_dev);
+	return ret;
 }

Thanks
Hangbin
