Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F8E5EF373
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 12:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbiI2KaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 06:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235442AbiI2KaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 06:30:02 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEE75725E;
        Thu, 29 Sep 2022 03:29:58 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 0C9B0C021; Thu, 29 Sep 2022 12:29:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1664447395; bh=q1JuDuxPM80imtWmD4gg39v+nFleKhM8uTwldv2ouMY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qFHIJSNKsUpzlB82+YMXWrMjlPhHYLSiMIZeyC0U3KHaS868TlScqVdEeHMhzlzu7
         XWMsJLz4+IFtMBcm5YHsVH8N36wR25FJFmW+T7nWWve18ngcSoX2mkOoPzhzX8YmhL
         C7Pm6wHAl98nbfpzI0JxDyHA6KXPcPfnFwyHjhRdFNVmAjxj3t/la/Uir3y5p/IcMU
         8JqQ4D1AYTvHlMmQmALUWWc/eoSfUAawzRtrjR4a/OFF+VoQ39JDQ0hWolaBYFqEBR
         uZA8YKjkOp49f+9mS0RmqKaPBECvUyWBkvBgoYSrz4dainWZCdVc5slkbXSikWGDuU
         DT8QN5Uqg5njQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id E1839C009;
        Thu, 29 Sep 2022 12:29:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1664447393; bh=q1JuDuxPM80imtWmD4gg39v+nFleKhM8uTwldv2ouMY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rznw3nVdTw/N22lYinrDRHbBvshtkZrX7+LAx6hZITG1omSNQxUg56Jz0PWNd/2sn
         aBO4JfJHUmJ5Ev7+2FOllEfaOQwLMB0SL5vuUdwTbDTxSlFBb0lrmIO2fjgFzkIMZO
         TCNvtODBNURRovM9apRQGOTEHmzSI8l868BjU/JSbJixZHjH79sO9rXjp6YnMhRcYV
         +FcxMWKodYEY+/SkON6go4Qc03su0dGKqAAyTaP+kWikGXmTFbFE1+tSazdLFW2Uvl
         PK+Qv3e82PW1tuwZV4nvSIY5P5515phZTDf3wQX3TCIKhjH7AI4GrzUsvajoAY0HZ1
         OrKbJk9azbUPw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 3d07a534;
        Thu, 29 Sep 2022 10:29:48 +0000 (UTC)
Date:   Thu, 29 Sep 2022 19:29:33 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     v9fs-developer@lists.sourceforge.net, linux_oss@crudebyte.com,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, lucho@ionkov.net, netdev@vger.kernel.org,
        syzbot+de52531662ebb8823b26@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/2] 9p: destroy client in symmetric order
Message-ID: <YzVzjR4Yz3Oo3JS+@codewreck.org>
References: <cover.1664442592.git.leonro@nvidia.com>
 <743fc62b2e8d15c84e234744e3f3f136c467752d.1664442592.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <743fc62b2e8d15c84e234744e3f3f136c467752d.1664442592.git.leonro@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leon Romanovsky wrote on Thu, Sep 29, 2022 at 12:37:56PM +0300:
> Make sure that all variables are initialized and released in correct
> order.

Haven't tried running or compiling, comments out of my head that might
be wrong below

> 
> Reported-by: syzbot+de52531662ebb8823b26@syzkaller.appspotmail.com

You're adding this report tag but I don't see how you fix that failure.
What you need is p9_tag_cleanup(clnt) from p9_client_destroy -- I assume
this isn't possible for any fid to be allocated at this point so the fid
destroying loop is -probably- optional.

I would assume it is needed from p9_client_version failures.


> Signed-off-by: Leon Romanovsky <leon@kernel.org>
> ---
>  net/9p/client.c | 37 ++++++++++++-------------------------
>  1 file changed, 12 insertions(+), 25 deletions(-)
> 
> diff --git a/net/9p/client.c b/net/9p/client.c
> index aaa37b07e30a..8277e33506e7 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -179,7 +179,6 @@ static int parse_opts(char *opts, struct p9_client *clnt)
>  				goto free_and_return;
>  			}
>  
> -			v9fs_put_trans(clnt->trans_mod);

Pretty sure you'll be "leaking transports" if someone tries to pass
trans=foo multiple times; this can't be removed...(continues below)...


>  			clnt->trans_mod = v9fs_get_trans_by_name(s);
>  			if (!clnt->trans_mod) {
>  				pr_info("Could not find request transport: %s\n",
> @@ -187,7 +186,7 @@ static int parse_opts(char *opts, struct p9_client *clnt)
>  				ret = -EINVAL;
>  			}
>  			kfree(s);
> -			break;
> +			goto free_and_return;

... unless you also break the whole parsing, with this asking for -o
trans=virtio,msize=1M will just ignore the msize argument.
(or anything else that follows)

I appreciate that you're trying to avoid the get_default_trans below,
but unless you just remember the last string and try to get it get/put
trans is the most straight forward way to go.


(Note you just got me to try weird parsing and my old version was
double-puting these modules because of the put_trans below in this
function echoes with the client destroy. That'd just require removing
the put here though (or nulling after put), yet another invariant I had
wrongly assumed... Anyway.)


>  		case Opt_legacy:
>  			clnt->proto_version = p9_proto_legacy;
>  			break;
> @@ -211,9 +210,14 @@ static int parse_opts(char *opts, struct p9_client *clnt)
>  		}
>  	}
>  
> +	clnt->trans_mod = v9fs_get_default_trans();
> +	if (!clnt->trans_mod) {
> +		ret = -EPROTONOSUPPORT;
> +		p9_debug(P9_DEBUG_ERROR,
> +			 "No transport defined or default transport\n");
> +	}
> +
>  free_and_return:
> -	if (ret)
> -		v9fs_put_trans(clnt->trans_mod);

(oh, and if you parse options after trans= you'll need some sort of
escape hatch here...)

>  	kfree(tmp_options);
>  	return ret;
>  }
> @@ -956,19 +960,14 @@ static int p9_client_version(struct p9_client *c)
>  
>  struct p9_client *p9_client_create(const char *dev_name, char *options)
>  {
> -	int err;
>  	struct p9_client *clnt;
>  	char *client_id;
> +	int err = 0;
>  
> -	err = 0;
> -	clnt = kmalloc(sizeof(*clnt), GFP_KERNEL);
> +	clnt = kzalloc(sizeof(*clnt), GFP_KERNEL);
>  	if (!clnt)
>  		return ERR_PTR(-ENOMEM);
>  
> -	clnt->trans_mod = NULL;
> -	clnt->trans = NULL;
> -	clnt->fcall_cache = NULL;
> -
>  	client_id = utsname()->nodename;
>  	memcpy(clnt->name, client_id, strlen(client_id) + 1);
>  
> @@ -980,16 +979,6 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
>  	if (err < 0)
>  		goto free_client;
>  
> -	if (!clnt->trans_mod)
> -		clnt->trans_mod = v9fs_get_default_trans();
> -
> -	if (!clnt->trans_mod) {
> -		err = -EPROTONOSUPPORT;
> -		p9_debug(P9_DEBUG_ERROR,
> -			 "No transport defined or default transport\n");
> -		goto free_client;
> -	}
> -
>  	p9_debug(P9_DEBUG_MUX, "clnt %p trans %p msize %d protocol %d\n",
>  		 clnt, clnt->trans_mod, clnt->msize, clnt->proto_version);
>  
> @@ -1044,9 +1033,8 @@ void p9_client_destroy(struct p9_client *clnt)
>  
>  	p9_debug(P9_DEBUG_MUX, "clnt %p\n", clnt);
>  
> -	if (clnt->trans_mod)
> -		clnt->trans_mod->close(clnt);
> -
> +	kmem_cache_destroy(clnt->fcall_cache);

Pretty sure kmem_cache used to issue a warning when we did that (hence
me trying to move it up on allocation) -- at this point there can still
be in flight requests we need to finish freeing before we can destroy
the cache.

> +	clnt->trans_mod->close(clnt);
>  	v9fs_put_trans(clnt->trans_mod);
>  
>  	idr_for_each_entry(&clnt->fids, fid, id) {
> @@ -1056,7 +1044,6 @@ void p9_client_destroy(struct p9_client *clnt)
>  
>  	p9_tag_cleanup(clnt);
>  
> -	kmem_cache_destroy(clnt->fcall_cache);
>  	kfree(clnt);
>  }
>  EXPORT_SYMBOL(p9_client_destroy);

--
Dominique
