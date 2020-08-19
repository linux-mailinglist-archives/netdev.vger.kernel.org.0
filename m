Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5337C24A996
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgHSWlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgHSWla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:41:30 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2729C061383;
        Wed, 19 Aug 2020 15:41:29 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id j13so99265pjd.4;
        Wed, 19 Aug 2020 15:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ejbU9wiMvRABH95+7vVgeFIowVeF650G8x7BsTQc4xM=;
        b=fPSQeyfOR8pxiw9y+HfuBmp02HhWUmvpRcO6pUEaYTG5nPEu62ffgQVmuI4te7kccI
         lIVIPdNM03idJM2nWNOKZ69hxjS0kP0de//8vW/Z8sFN/o6ahM1TU1WPFQvHNg2aLudB
         tfg9E7bMn4tiemv0Rli+6TFKNqXx8htc5Uy0kZtsGmKfJnJEIL1FIepLS7UdZ32eYl6k
         bUcGQtAm3eJTe1EXi6ImxdEj3B41uP5AC+lUxpnUSb4HhcEss5GLVI2j9N+X/eTmpvuk
         7cNsHbaiFiBDZVQMsXZsQp68qOpAAJrmebi35vitrrvLQDspdGE0w3amkx7ohyus/p0p
         MxFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ejbU9wiMvRABH95+7vVgeFIowVeF650G8x7BsTQc4xM=;
        b=P3qpH477XKdo65Cch6qi4yt//OTmY6U4OJBujE3RgPe7kR2n8s747vSoF89S+rvxVe
         /j9S4BFe56dD0V41YhOrQdIuXU8uCTJd4wMSx1VxxjlrQ+wVrD4gZ0ZlAwf5l3pSek9z
         CzRpzDQNPj1zjLu6FPqTDcOg2NhPEi4py3/hVBPi1sRDBaEXVoBVUOoCtMYNSrpB1kSi
         vVVHiDjuDkO31cobcILT2smp89pQuFFhRCe8jy0ZkBd911fX+rhJknVwUQZlQq5Xuq/I
         blG+ULIXzZAQ+fW5gxh2bveFoeCRT2jxMKGXoOR+pGQ8Wl7cE8csZ7ulRSwY4p7piMqu
         hL5A==
X-Gm-Message-State: AOAM532cBttPX/nPKhQohsjf2l0bQ/EBO2xlEKHpnBDvN0AAChUSp3Ja
        KB859PUtYH7slu9XgTPL6NU=
X-Google-Smtp-Source: ABdhPJzUzXp7NEbydKWCfez4krNStXJtwrBEI9AlFXJnczBqndXt31EHxlQQHUEtTj/xUL6jdM0bKQ==
X-Received: by 2002:a17:90a:eb18:: with SMTP id j24mr103652pjz.76.1597876889512;
        Wed, 19 Aug 2020 15:41:29 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v78sm252407pfc.121.2020.08.19.15.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 15:41:28 -0700 (PDT)
Date:   Wed, 19 Aug 2020 15:41:21 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, jakub@cloudflare.com,
        john.fastabend@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5f3daa91265a7_1b0e2ab87245e5c05@john-XPS-13-9370.notmuch>
In-Reply-To: <5f3d982f51f22_2c9b2adeefb585bccb@john-XPS-13-9370.notmuch>
References: <20200819092436.58232-1-lmb@cloudflare.com>
 <20200819092436.58232-6-lmb@cloudflare.com>
 <5f3d982f51f22_2c9b2adeefb585bccb@john-XPS-13-9370.notmuch>
Subject: RE: [PATCH bpf-next 5/6] bpf: sockmap: allow update from BPF
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Lorenz Bauer wrote:
> > Allow calling bpf_map_update_elem on sockmap and sockhash from a BPF
> > context. The synchronization required for this is a bit fiddly: we
> > need to prevent the socket from changing it's state while we add it
> > to the sockmap, since we rely on getting a callback via
> > sk_prot->unhash. However, we can't just lock_sock like in
> > sock_map_sk_acquire because that might sleep. So instead we disable
> > softirq processing and use bh_lock_sock to prevent further
> > modification.
> > 
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > ---
> >  kernel/bpf/verifier.c |  6 ++++--
> >  net/core/sock_map.c   | 24 ++++++++++++++++++++++++
> >  2 files changed, 28 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 47f9b94bb9d4..421fccf18dea 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -4254,7 +4254,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
> >  		    func_id != BPF_FUNC_map_delete_elem &&
> >  		    func_id != BPF_FUNC_msg_redirect_map &&
> >  		    func_id != BPF_FUNC_sk_select_reuseport &&
> > -		    func_id != BPF_FUNC_map_lookup_elem)
> > +		    func_id != BPF_FUNC_map_lookup_elem &&
> > +		    func_id != BPF_FUNC_map_update_elem)
> >  			goto error;
> >  		break;
> >  	case BPF_MAP_TYPE_SOCKHASH:
> > @@ -4263,7 +4264,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
> >  		    func_id != BPF_FUNC_map_delete_elem &&
> >  		    func_id != BPF_FUNC_msg_redirect_hash &&
> >  		    func_id != BPF_FUNC_sk_select_reuseport &&
> > -		    func_id != BPF_FUNC_map_lookup_elem)
> > +		    func_id != BPF_FUNC_map_lookup_elem &&
> > +		    func_id != BPF_FUNC_map_update_elem)
> 
> I lost track of a detail here, map_lookup_elem should return
> PTR_TO_MAP_VALUE_OR_NULL but if we want to feed that back into
> the map_update_elem() we need to return PTR_TO_SOCKET_OR_NULL
> and then presumably have a null check to get a PTR_TO_SOCKET
> type as expect.
> 
> Can we use the same logic for expected arg (previous patch) on the
> ret_type. Or did I miss it:/ Need some coffee I guess.

OK, I tracked this down. It looks like we rely on mark_ptr_or_null_reg()
to update the reg->tyype to PTR_TO_SOCKET. I do wonder if it would be
a bit more straight forward to do something similar to the previous
patch and refine it earlier to PTR_TO_SOCKET_OR_NULL, but should be
safe as-is for now.

I still have the below question though.

> 
> >  			goto error;
> >  		break;
> >  	case BPF_MAP_TYPE_REUSEPORT_SOCKARRAY:
> > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > index 018367fb889f..b2c886c34566 100644
> > --- a/net/core/sock_map.c
> > +++ b/net/core/sock_map.c
> > @@ -603,6 +603,28 @@ int sock_map_update_elem_sys(struct bpf_map *map, void *key,
> >  	return ret;
> >  }
> >  
> > +static int sock_map_update_elem(struct bpf_map *map, void *key,
> > +				void *value, u64 flags)
> > +{
> > +	struct sock *sk = (struct sock *)value;
> > +	int ret;
> > +
> > +	if (!sock_map_sk_is_suitable(sk))
> > +		return -EOPNOTSUPP;
> > +
> > +	local_bh_disable();
> > +	bh_lock_sock(sk);
> 
> How do ensure we are not being called from some context which
> already has the bh_lock_sock() held? It seems we can call map_update_elem()
> from any context, kprobes, tc, xdp, etc.?
> 
> > +	if (!sock_map_sk_state_allowed(sk))
> > +		ret = -EOPNOTSUPP;
> > +	else if (map->map_type == BPF_MAP_TYPE_SOCKMAP)
> > +		ret = sock_map_update_common(map, *(u32 *)key, sk, flags);
> > +	else
> > +		ret = sock_hash_update_common(map, key, sk, flags);
> > +	bh_unlock_sock(sk);
> > +	local_bh_enable();
> > +	return ret;
> > +}
> > +
> >  BPF_CALL_4(bpf_sock_map_update, struct bpf_sock_ops_kern *, sops,
> >  	   struct bpf_map *, map, void *, key, u64, flags)
> >  {
> > @@ -687,6 +709,7 @@ const struct bpf_map_ops sock_map_ops = {
> >  	.map_free		= sock_map_free,
> >  	.map_get_next_key	= sock_map_get_next_key,
> >  	.map_lookup_elem_sys_only = sock_map_lookup_sys,
> > +	.map_update_elem	= sock_map_update_elem,
> >  	.map_delete_elem	= sock_map_delete_elem,
> >  	.map_lookup_elem	= sock_map_lookup,
> >  	.map_release_uref	= sock_map_release_progs,
> > @@ -1180,6 +1203,7 @@ const struct bpf_map_ops sock_hash_ops = {
> >  	.map_alloc		= sock_hash_alloc,
> >  	.map_free		= sock_hash_free,
> >  	.map_get_next_key	= sock_hash_get_next_key,
> > +	.map_update_elem	= sock_map_update_elem,
> >  	.map_delete_elem	= sock_hash_delete_elem,
> >  	.map_lookup_elem	= sock_hash_lookup,
> >  	.map_lookup_elem_sys_only = sock_hash_lookup_sys,
> > -- 
> > 2.25.1
> > 
> 
> 


