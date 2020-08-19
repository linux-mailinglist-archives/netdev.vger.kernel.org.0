Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CB524A867
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 23:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgHSVXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 17:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgHSVXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 17:23:07 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83BCC061757;
        Wed, 19 Aug 2020 14:23:04 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ep8so21454pjb.3;
        Wed, 19 Aug 2020 14:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=btY89Txg+8uaXE0k0GApRaRoixmsf2CD33KKqig2JcQ=;
        b=uzGckYbhvmooulRyFafT6ihfOPKIF3wD0VVYp08F1KTsV6GQTLy+MqNj1NqzMjTF3g
         m74g7SgX+o4fWuCrwpeauKvO88vPJYSbPRWJmUhRVFb6CEF1lu2gnSVIg2M+PyscrGMb
         qXhkWcXtMvZKgPBcajRe374uxFD3eKZrin8HS7AU0FM3yloN8BuGshyAYcAHHZSBatxY
         F2Rm7SSdxtXvywadIZrLg6H/vIcNYqiLHyWqR0KDhhgAKklyqyHUQxXO9LnFGEEycTjh
         CkY5Jk57xzAX/VZtiZxdjxpKBk2PcjcmdgK6AqEHLfs5Rmu+x9RyfRY/JUNm0GhdOcEP
         ct2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=btY89Txg+8uaXE0k0GApRaRoixmsf2CD33KKqig2JcQ=;
        b=gvpqSQeKr3JCwNduBwrFMVvCWNDtorXo9j7TFCMw6Y2io5Hr6goNP4fMzDuwsiquNV
         ZAgx1VMr7AELA/512Itek8Jgzh/tW0dQ+PDJRiDvJSrU6LLV0SPmAvM8ISbleTGy1eJg
         j8Rs65ZPgMseG9FjfCDCSSSsjJ+Zj3+gYLBeTVj/k4ooDyomot76nIPMnjdNxykXfqCQ
         0ae2/EqAPg+v4Xe0eKfZi0xPr5iwFqKaZS9TW2nn1M2Rm1BpkClVz6UbcNpNlPbc4MHm
         URx0nNg//LPrqxPXKebLUTK7No88j5WX4EKljpIueagd5XYKgynDqlWJDPSbOjpopEWL
         BGkA==
X-Gm-Message-State: AOAM533xLqJQmKcptmlL/GXns43hGLv5AccQBrl5Ia+CHYFWp4Rn4bug
        a9dtmE/TSoJmz9jmtYJGOs0=
X-Google-Smtp-Source: ABdhPJxO0ZtsTvP5Luy+Pe9LO6rJvGHTAXst7+degYUTQtrp2fp92aQk0C79bjai40irJIiUd7B4Lw==
X-Received: by 2002:a17:902:b7c2:: with SMTP id v2mr82656plz.34.1597872184330;
        Wed, 19 Aug 2020 14:23:04 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b20sm138503pfp.140.2020.08.19.14.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 14:23:03 -0700 (PDT)
Date:   Wed, 19 Aug 2020 14:22:55 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, jakub@cloudflare.com,
        john.fastabend@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5f3d982f51f22_2c9b2adeefb585bccb@john-XPS-13-9370.notmuch>
In-Reply-To: <20200819092436.58232-6-lmb@cloudflare.com>
References: <20200819092436.58232-1-lmb@cloudflare.com>
 <20200819092436.58232-6-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next 5/6] bpf: sockmap: allow update from BPF
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> Allow calling bpf_map_update_elem on sockmap and sockhash from a BPF
> context. The synchronization required for this is a bit fiddly: we
> need to prevent the socket from changing it's state while we add it
> to the sockmap, since we rely on getting a callback via
> sk_prot->unhash. However, we can't just lock_sock like in
> sock_map_sk_acquire because that might sleep. So instead we disable
> softirq processing and use bh_lock_sock to prevent further
> modification.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  kernel/bpf/verifier.c |  6 ++++--
>  net/core/sock_map.c   | 24 ++++++++++++++++++++++++
>  2 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 47f9b94bb9d4..421fccf18dea 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -4254,7 +4254,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>  		    func_id != BPF_FUNC_map_delete_elem &&
>  		    func_id != BPF_FUNC_msg_redirect_map &&
>  		    func_id != BPF_FUNC_sk_select_reuseport &&
> -		    func_id != BPF_FUNC_map_lookup_elem)
> +		    func_id != BPF_FUNC_map_lookup_elem &&
> +		    func_id != BPF_FUNC_map_update_elem)
>  			goto error;
>  		break;
>  	case BPF_MAP_TYPE_SOCKHASH:
> @@ -4263,7 +4264,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>  		    func_id != BPF_FUNC_map_delete_elem &&
>  		    func_id != BPF_FUNC_msg_redirect_hash &&
>  		    func_id != BPF_FUNC_sk_select_reuseport &&
> -		    func_id != BPF_FUNC_map_lookup_elem)
> +		    func_id != BPF_FUNC_map_lookup_elem &&
> +		    func_id != BPF_FUNC_map_update_elem)

I lost track of a detail here, map_lookup_elem should return
PTR_TO_MAP_VALUE_OR_NULL but if we want to feed that back into
the map_update_elem() we need to return PTR_TO_SOCKET_OR_NULL
and then presumably have a null check to get a PTR_TO_SOCKET
type as expect.

Can we use the same logic for expected arg (previous patch) on the
ret_type. Or did I miss it:/ Need some coffee I guess.

>  			goto error;
>  		break;
>  	case BPF_MAP_TYPE_REUSEPORT_SOCKARRAY:
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 018367fb889f..b2c886c34566 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -603,6 +603,28 @@ int sock_map_update_elem_sys(struct bpf_map *map, void *key,
>  	return ret;
>  }
>  
> +static int sock_map_update_elem(struct bpf_map *map, void *key,
> +				void *value, u64 flags)
> +{
> +	struct sock *sk = (struct sock *)value;
> +	int ret;
> +
> +	if (!sock_map_sk_is_suitable(sk))
> +		return -EOPNOTSUPP;
> +
> +	local_bh_disable();
> +	bh_lock_sock(sk);

How do ensure we are not being called from some context which
already has the bh_lock_sock() held? It seems we can call map_update_elem()
from any context, kprobes, tc, xdp, etc.?

> +	if (!sock_map_sk_state_allowed(sk))
> +		ret = -EOPNOTSUPP;
> +	else if (map->map_type == BPF_MAP_TYPE_SOCKMAP)
> +		ret = sock_map_update_common(map, *(u32 *)key, sk, flags);
> +	else
> +		ret = sock_hash_update_common(map, key, sk, flags);
> +	bh_unlock_sock(sk);
> +	local_bh_enable();
> +	return ret;
> +}
> +
>  BPF_CALL_4(bpf_sock_map_update, struct bpf_sock_ops_kern *, sops,
>  	   struct bpf_map *, map, void *, key, u64, flags)
>  {
> @@ -687,6 +709,7 @@ const struct bpf_map_ops sock_map_ops = {
>  	.map_free		= sock_map_free,
>  	.map_get_next_key	= sock_map_get_next_key,
>  	.map_lookup_elem_sys_only = sock_map_lookup_sys,
> +	.map_update_elem	= sock_map_update_elem,
>  	.map_delete_elem	= sock_map_delete_elem,
>  	.map_lookup_elem	= sock_map_lookup,
>  	.map_release_uref	= sock_map_release_progs,
> @@ -1180,6 +1203,7 @@ const struct bpf_map_ops sock_hash_ops = {
>  	.map_alloc		= sock_hash_alloc,
>  	.map_free		= sock_hash_free,
>  	.map_get_next_key	= sock_hash_get_next_key,
> +	.map_update_elem	= sock_map_update_elem,
>  	.map_delete_elem	= sock_hash_delete_elem,
>  	.map_lookup_elem	= sock_hash_lookup,
>  	.map_lookup_elem_sys_only = sock_hash_lookup_sys,
> -- 
> 2.25.1
> 


