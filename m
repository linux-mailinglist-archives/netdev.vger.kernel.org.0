Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38C21FB47B
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 16:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgFPOec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 10:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgFPOeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 10:34:31 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A22C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 07:34:31 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id o15so21722787ejm.12
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 07:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=O591g5+RZBhRkdZV73wJpRUbF0/DO5xVmTs597eh870=;
        b=FRKPET5r0gN6DTeZjB9On0SjnG1Knumxb7FJwosFjlLJ0I73oPL+mMOVKrbDUQL3xr
         d7KYgj27zAgRsJ6ryGFuTWLOGjETwVLhqLhOjqSonXIvBVJ9OS5N06oasfEQ+irKGZLY
         /fmWM1n+xvQkzqUxOjCQHdx8OISa9Kztk1zmgEX4hRoYXDej4LZtlLpyfnw86KXoUCzB
         3WaR9K2utOt2Ibn/vaKeCKM9McCzop+g6W/RLPM7d1+MMaXylvUscOceqCvMWK8nHLsx
         Vd9nAWkEFJPM7UQgtJ3Q/VEP7kQEWg7fGO8ABS//ZbvNgV5hk5awH9Xjp+Gw72aeWGma
         rkGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=O591g5+RZBhRkdZV73wJpRUbF0/DO5xVmTs597eh870=;
        b=CLR4OwG45XVf0dgPdZBnhJqdvoNb4CDyg1xCPqKlF2UlU2IbDZYzXuy6MFSIdbuNHa
         UWeq+flAzN0cBTFoTX325TjG6ysrAHgigizLePL3aalX/qQOAsNadpnW5c/gKDB+xOzT
         nfhvdUAy2rIUKBU7kkI/ALwZ3J1eRZ2dToZrI/Mg/UzfMzs4FfnVgX/4FF3NigUlJO9U
         2ywyhmK/l5gwC8DUnBcjAHb8FERnzt899tsn/AD4XhDdkPA2b4nIkSNEcvp+KvMtlbM1
         TpM7qYOcnvqCBsrhE/8MHc9CJHhPTfNOWyQ/9HpR32dG9fscFlBm81IAtF8aDWyaxfR2
         nnEw==
X-Gm-Message-State: AOAM531DVCTqqn6n6ItMlbldXUZE8As6zVozOqZnx+qn1scbJv14TVGx
        OXU2vOkmGn/KjbPYEbyEMFu8GdSfuXE=
X-Google-Smtp-Source: ABdhPJx+9QaL1UYU7j+CfGXZwVXun4z8muKvEiH7RsqOWozrYjvJPkcFK3+q9toumaPVEq6BnxpN8A==
X-Received: by 2002:a17:907:9d8:: with SMTP id bx24mr3005295ejc.517.1592318070101;
        Tue, 16 Jun 2020 07:34:30 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id 64sm10154750eda.85.2020.06.16.07.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 07:34:29 -0700 (PDT)
Date:   Tue, 16 Jun 2020 16:34:28 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pablo@netfilter.org,
        vladbu@mellanox.com
Subject: Re: [PATCH net v3 2/4] flow_offload: fix incorrect cb_priv check for
 flow_block_cb
Message-ID: <20200616143427.GA8084@netronome.com>
References: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
 <1592277580-5524-3-git-send-email-wenxu@ucloud.cn>
 <20200616105123.GA21396@netronome.com>
 <aee3192c-7664-580b-1f37-9003c91f185b@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aee3192c-7664-580b-1f37-9003c91f185b@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 10:20:46PM +0800, wenxu wrote:
> 
> 在 2020/6/16 18:51, Simon Horman 写道:
> > On Tue, Jun 16, 2020 at 11:19:38AM +0800, wenxu@ucloud.cn wrote:
> >> From: wenxu <wenxu@ucloud.cn>
> >>
> >> In the function __flow_block_indr_cleanup, The match stataments
> >> this->cb_priv == cb_priv is always false, the flow_block_cb->cb_priv
> >> is totally different data with the flow_indr_dev->cb_priv.
> >>
> >> Store the representor cb_priv to the flow_block_cb->indr.cb_priv in
> >> the driver.
> >>
> >> Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
> >> Signed-off-by: wenxu <wenxu@ucloud.cn>
> > Hi Wenxu,
> >
> > I wonder if this can be resolved by using the cb_ident field of struct
> > flow_block_cb.
> >
> > I observe that mlx5e_rep_indr_setup_block() seems to be the only call-site
> > where the value of the cb_ident parameter of flow_block_cb_alloc() is
> > per-block rather than per-device. So part of my proposal is to change
> > that.
> 
> I check all the xxdriver_indr_setup_block. It seems all the cb_ident parameter of
> 
> flow_block_cb_alloc is per-block. Both in the nfp_flower_setup_indr_tc_block
> 
> and bnxt_tc_setup_indr_block.
> 
> 
> nfp_flower_setup_indr_tc_block:
> 
> struct nfp_flower_indr_block_cb_priv *cb_priv;
> 
> block_cb = flow_block_cb_alloc(nfp_flower_setup_indr_block_cb,
>                                                cb_priv, cb_priv,
>                                                nfp_flower_setup_indr_tc_release);
> 
> 
> bnxt_tc_setup_indr_block:
> 
> struct bnxt_flower_indr_block_cb_priv *cb_priv;
> 
> block_cb = flow_block_cb_alloc(bnxt_tc_setup_indr_block_cb,
>                                                cb_priv, cb_priv,
>                                                bnxt_tc_setup_indr_rel);
> 
> 
> And the function flow_block_cb_is_busy called in most place. Pass the
> 
> parameter as cb_priv but not cb_indent .

Thanks, I see that now. But I still think it would be useful to understand
the purpose of cb_ident. It feels like it would lead to a clean solution
to the problem you have highlighted.

> > The other part of my proposal is to make use of cb_ident in
> > __flow_block_indr_cleanup(). Which does seem to match the intended
> > purpose of cb_ident. Perhaps it would also be good to document what
> > the intended purpose of cb_ident (and the other fields of struct
> > flow_block_cb) is.
> >
> > Compile tested only.
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> > index a62bcf0cf512..4de6fcae5252 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> > @@ -438,7 +438,7 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev,
> >  		list_add(&indr_priv->list,
> >  			 &rpriv->uplink_priv.tc_indr_block_priv_list);
> >  
> > -		block_cb = flow_block_cb_alloc(setup_cb, indr_priv, indr_priv,
> > +		block_cb = flow_block_cb_alloc(setup_cb, rpriv, indr_priv,
> >  					       mlx5e_rep_indr_block_unbind);
> >  		if (IS_ERR(block_cb)) {
> >  			list_del(&indr_priv->list);
> > diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> > index b288d2f03789..d281fb182894 100644
> > --- a/net/core/flow_offload.c
> > +++ b/net/core/flow_offload.c
> > @@ -373,14 +373,13 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
> >  EXPORT_SYMBOL(flow_indr_dev_register);
> >  
> >  static void __flow_block_indr_cleanup(void (*release)(void *cb_priv),
> > -				      void *cb_priv,
> > +				      void *cb_ident,
> >  				      struct list_head *cleanup_list)
> >  {
> >  	struct flow_block_cb *this, *next;
> >  
> >  	list_for_each_entry_safe(this, next, &flow_block_indr_list, indr.list) {
> > -		if (this->release == release &&
> > -		    this->cb_priv == cb_priv) {
> > +		if (this->release == release && this->cb_ident == cb_ident) {
> >  			list_move(&this->indr.list, cleanup_list);
> >  			return;
> >  		}
> >
