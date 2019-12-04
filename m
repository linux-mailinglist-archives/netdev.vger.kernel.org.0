Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5EE11351C
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 19:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbfLDSkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 13:40:19 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39125 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728271AbfLDSkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 13:40:19 -0500
Received: by mail-lj1-f194.google.com with SMTP id e10so461077ljj.6
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 10:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=MPUgt8BKK8jntMpPJJpiSxrSzMem1sQgZ2v86URinXA=;
        b=q8nNR2JnYKwS3g9vjbQ3LUk+rSLD9sMW5X6tYyysV5UGJQTejC8CEhjzojGmF56EJg
         MzrOIkU2eI//hos+tVVTrz5UrbWRNr188CTiCTjgseET0IO5HsgGi/tcJl8p4jNM3BwH
         rtyt3Qsk4yAmL7hhGfYpgbk5xtCDX3V1e2SxNcC/yOx8qbJ3VhBYvd70O1llAIjC1o+z
         Y0DfWuMLJIv9pOZgsTPNrQBJggY4rEzKIdZTTE7qMFEtYny79ScbaKo8zrhKmCpBi5sa
         wUnV4WeWDl0kk1rWTPbFh2DZtV0r/bw9ujOIk6ekRJhvxNeqVCbK4C3bZQ71bT1DV4eZ
         D1Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MPUgt8BKK8jntMpPJJpiSxrSzMem1sQgZ2v86URinXA=;
        b=HsSY01z4f/9VfZ7JV9jB4zfjlrjL/2oEUGuGjniPuhx7v/uFD43UBgzohPMfFo8SPC
         Lzmltkj/buRPuxz1tM5Y1DtMYUeb6XNEJT4QcaWtBpnLc7Kxes5r5ErLYhSLUGVY/P3+
         5ajN96UiWB5+57L98FLzMz4tBJUakeTb0Agb1ZCVK+8zBGmc/vMn8/R+HVXw0xedaGYg
         H7HwMipSFgW/Oe0B6Z7zOq/hNZ90Pv0nl9zWN9yJmj8pZVC62XxEvSYGBD46ZBlzSeSy
         IygvjnusqG5FGwSircpjwFRMhkFtr5qQAdHVxpeFTgyYRihRqaTDjG/Se2Y9pfiBKMC/
         4THg==
X-Gm-Message-State: APjAAAWZ4MR7Zg6TWZLERfbisEe6wY8HCK5MZW91XUKJuN7AOrDslS8q
        IOQ69NimS/S5Jgz2Nqjqgnfy5Q==
X-Google-Smtp-Source: APXvYqwdXIR+tb8hZ6Ua2SQCwf0XVGUGg7xt5ESgNSXxlS0m4rBtdDw61DUznFeBsV4bTXIUOIjh/A==
X-Received: by 2002:a2e:84d0:: with SMTP id q16mr2935643ljh.138.1575484816865;
        Wed, 04 Dec 2019 10:40:16 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a24sm3584077ljp.97.2019.12.04.10.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 10:40:16 -0800 (PST)
Date:   Wed, 4 Dec 2019 10:39:55 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        John Hurley <john.hurley@netronome.com>,
        Colin Ian King <colin.king@canonical.com>,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] nfp: abm: fix memory leak in
 nfp_abm_u32_knode_replace
Message-ID: <20191204103955.63c4d9af@cakuba.netronome.com>
In-Reply-To: <20190927015157.20070-1-navid.emamdoost@gmail.com>
References: <20190925215314.10cf291d@cakuba.netronome.com>
        <20190927015157.20070-1-navid.emamdoost@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Sep 2019 20:51:46 -0500, Navid Emamdoost wrote:
> In nfp_abm_u32_knode_replace if the allocation for match fails it should
> go to the error handling instead of returning. Updated other gotos to
> have correct errno returned, too.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
> Changes in v2:
> 	- Reused err variable for erorr value returning.
> Changes in v3:
> 	- Fix the err value in the first goto, and fix subject prefix.

Ugh damn this. Apparently this "fix" has made the news:

https://news.softpedia.com/news/canonical-releases-major-kernel-security-update-for-ubuntu-19-10-and-18-04-lts-528433.shtml

https://nvd.nist.gov/vuln/detail/CVE-2019-19076

and (a) it would be a damn control path, root-only memory leak, but
also (b) upon closer inspection there is no leak here at all!

We don't need to delete the entry if we failed to allocate it...
The delete path is in case the entry for the handle is changed, but 
if we're trying to allocate one anew there can't be any on the list.

Congratulations to whoever classified this as a security fix.

I will send a revert, and go ask for the CVE to be marked invalid.
What a waste of time. I should have paid more attention :/

> diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
> index 23ebddfb9532..9f8a1f69c0c4 100644
> --- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
> +++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
> @@ -176,8 +176,10 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
>  	u8 mask, val;
>  	int err;
>  
> -	if (!nfp_abm_u32_check_knode(alink->abm, knode, proto, extack))
> +	if (!nfp_abm_u32_check_knode(alink->abm, knode, proto, extack)) {
> +		err = -EOPNOTSUPP;
>  		goto err_delete;
> +	}
>  
>  	tos_off = proto == htons(ETH_P_IP) ? 16 : 20;
>  
> @@ -198,14 +200,18 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
>  		if ((iter->val & cmask) == (val & cmask) &&
>  		    iter->band != knode->res->classid) {
>  			NL_SET_ERR_MSG_MOD(extack, "conflict with already offloaded filter");
> +			err = -EOPNOTSUPP;
>  			goto err_delete;
>  		}
>  	}
>  
>  	if (!match) {
>  		match = kzalloc(sizeof(*match), GFP_KERNEL);
> -		if (!match)
> -			return -ENOMEM;
> +		if (!match) {
> +			err = -ENOMEM;
> +			goto err_delete;
> +		}
> +
>  		list_add(&match->list, &alink->dscp_map);
>  	}
>  	match->handle = knode->handle;
> @@ -221,7 +227,7 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
>  
>  err_delete:
>  	nfp_abm_u32_knode_delete(alink, knode);
> -	return -EOPNOTSUPP;
> +	return err;
>  }
>  
>  static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,

