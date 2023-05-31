Return-Path: <netdev+bounces-6713-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32E6871794A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:59:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B42D1C20D6E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09ED8BA29;
	Wed, 31 May 2023 07:59:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0762AD5F
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:59:07 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A257E53
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:58:58 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f60dfc6028so56836375e9.1
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685519937; x=1688111937;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LGoVMkHiLGD64s03Y6+AFjuEJ/YkfPkSNgwpozijN6E=;
        b=qpRVmSbM34qqrH3gCx8n/suiBR131xb9ZKYYmYExMuWV3Awb1ou96gvKFE8WKkLtWy
         6ynBunEvz5k0ixVtgEpDcABbi1n57mZJZbs6ilqM8FMO+P5RzD2xBAjeKJT02Fq8lyfK
         POpe/MwOY4D58UyuaPJAhgZNxm0+O+Cqpoa5ZlQd2tE9wXmfHOo0EIRcB4zG7RDWNRs1
         FZDRZlEJA/fMYbTUzYf8RlOvpAodqgxr//acmFAASaD8EcKa1CaqNfrccXDETzaLWwn4
         P5WUgvzSn630/95baknVapsYOZTwgIrev04E6KJ6IBCY0NENQIewnXwSNuHnEcr4d08A
         UXgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685519937; x=1688111937;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LGoVMkHiLGD64s03Y6+AFjuEJ/YkfPkSNgwpozijN6E=;
        b=hYl4Ts57mBxlR8UbarsNJ/AUf4lg68dz+D1wSlV2KNERoLL+DmHakGQD9H1L49T7Mq
         nLonc+FR4UvgvrMZQNU+xYxQPygv83UY4neMxgLcgyja28nWQgTztvWdFYqrAPKj7HDu
         F1KUVi9acVJQfMRQEDLO8UAMkoZTp9BNsNLQ+DCF07ibIsJbhBByUD6KbOXGHzUBbcXy
         NjHhOMCK1JoS+9Te97DICi2S9u9sOZub9BBD/z0V+nQvzoiIpxIlILZFR5ey2Pg6uLEv
         5StWiAMF4P2xg5WG0Imm/t9Qm3cF72KRkMsjwfWQlgnLw/DxDQTzPv+owmB7nPmVtN7d
         9lEQ==
X-Gm-Message-State: AC+VfDwNRrHOOLEi7XPeX/4Yzl1Ob9/IL23f3ck37VrprWTqbrBcm68j
	SGXz3iM7z1VieyH6oPBEX4WuIw==
X-Google-Smtp-Source: ACHHUZ58AYa3MbtCcRUbj2mx8+2x0cns1qme0y7htZXh4dwN06OjOF6OPHWMbG5Q32MOUvkb2dNK7Q==
X-Received: by 2002:a05:600c:b44:b0:3f2:48dc:5e02 with SMTP id k4-20020a05600c0b4400b003f248dc5e02mr3192671wmr.27.1685519937097;
        Wed, 31 May 2023 00:58:57 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id s26-20020a7bc39a000000b003f42328b5d9sm19765106wmj.39.2023.05.31.00.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 00:58:54 -0700 (PDT)
Date: Wed, 31 May 2023 10:58:51 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: NeilBrown <neilb@suse.de>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna@kernel.org>,
	"J. Bruce Fields" <bfields@redhat.com>, linux-nfs@vger.kernel.org,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] nfsd: fix double fget() bug in __write_ports_addfd()
Message-ID: <9279444f-b113-41ad-afaa-c6b550104906@kili.mountain>
References: <9c90e813-c7fb-4c90-b52b-131481640a78@kili.mountain>
 <168548566376.23533.14778348024215909777@noble.neil.brown.name>
 <58fd7e35-ba6c-432e-8e02-9c5476c854b4@kili.mountain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58fd7e35-ba6c-432e-8e02-9c5476c854b4@kili.mountain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 10:48:09AM +0300, Dan Carpenter wrote:
>  	err = nfsd_create_serv(net);
>  	if (err != 0)
> -		return err;
> +		goto out_put_sock;
>  
> -	err = svc_addsock(nn->nfsd_serv, fd, buf, SIMPLE_TRANSACTION_LIMIT, cred);
> +	err = svc_addsock(nn->nfsd_serv, so, buf, SIMPLE_TRANSACTION_LIMIT, cred);
> +	if (err)
> +		goto out_put_net;

Oops.  This change is wrong.  svc_addsock() actually does return
positive values on success.

>  
> -	if (err >= 0 &&
> -	    !nn->nfsd_serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
> +	if (!nn->nfsd_serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
>  		svc_get(nn->nfsd_serv);
>  
>  	nfsd_put(net);
> +	return 0;

Also wrong (same bug).

> +
> +out_put_net:
> +	nfsd_put(net);
> +out_put_sock:
> +	sockfd_put(so);
>  	return err;
>  }

regards,
dan carpenter

