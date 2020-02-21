Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083F1166E09
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 04:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbgBUDqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 22:46:40 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39579 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729539AbgBUDqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 22:46:40 -0500
Received: by mail-pg1-f195.google.com with SMTP id j15so295218pgm.6;
        Thu, 20 Feb 2020 19:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=gFy4vLU4QHt8VKzncVYgTF7NvbxVi7+dmrewDoCCk3s=;
        b=FmcPU0yl+ut23MVUFz1TbRRfUOlRCU0xHbRGb8/t8tCW3q7jhOWCgsXCaSqtwmVgG+
         BLXjzGYWOG0p0wTlI5IyoUEY5RSK1AB+wT81tpzLwF7T+5P2U25B25sFD0GeRvcB0wY9
         JI1pxJnGaskutXLIUuc6UHXFy1Fw8a2+P/a0Hkgwuj/YW7tjgOwRXR0F0NjGPEFrQjd8
         2PzxhUwszesu2fH6GCriEh9nEPKOhtAPIyvEqzvGecKFzOsTW5pgKzp1Jggl4wHOAqu/
         tF41/6H0731IhvJWdAVeGvZSQjpZ6bprCnyFcHwf3xQjfkJgq7VtAZ3ylikgo1CSoMmg
         braQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=gFy4vLU4QHt8VKzncVYgTF7NvbxVi7+dmrewDoCCk3s=;
        b=hxJCEHdBnMxwji5weS/zI0jjemY8OjniAJDq2bPKRCqdmEcQFzrsPIrP+2WeF6PhNA
         FuZ68RFoDrbV03rGBLDL8avVDE4eL1CdteAV41dpDECRk+qlYmCbv9O92VzyTrsNcPax
         TodgHPGpQYNhBJtnxLPP7VM18opa4rFTrfJwPtvQXqAIxV3e0aeP0Ep9LyeO+CDrKGAS
         2UfyiPk6HF5mlqmnIMZksREciTP+KVNt57OAeomziqaMrri1pZFOc9ODJGBnjdUG4J/j
         aAnBriWqxIJ8385mhlnrrCZsy4W31GySStH+2oAlf92ckeC4m83+EjWuzixRaIT1ahRz
         qMXQ==
X-Gm-Message-State: APjAAAU1cg59lWVerKtxftH/fu0+GPjIxrNo6Pfw/mUWIVZ6rGllvSna
        Id/mznGLRpwt/7a5K4nMPXA=
X-Google-Smtp-Source: APXvYqzKDbMy+yPgofkxE1TDn7WZJWKtEjyeVwxqNHUP4I8bswng3v0G2YDEAPhxw9gIqOq5wPvEnA==
X-Received: by 2002:aa7:8545:: with SMTP id y5mr35767486pfn.185.1582256799895;
        Thu, 20 Feb 2020 19:46:39 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t186sm726313pgd.26.2020.02.20.19.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 19:46:39 -0800 (PST)
Date:   Thu, 20 Feb 2020 19:46:31 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Message-ID: <5e4f529760a7d_18d22b0a1febc5b877@john-XPS-13-9370.notmuch>
In-Reply-To: <20200218171023.844439-8-jakub@cloudflare.com>
References: <20200218171023.844439-1-jakub@cloudflare.com>
 <20200218171023.844439-8-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v7 07/11] bpf, sockmap: Let all kernel-land
 lookup values in SOCKMAP/SOCKHASH
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Don't require the kernel code, like BPF helpers, that needs access to
> SOCK{MAP,HASH} map contents to live in net/core/sock_map.c. Expose the
> lookup operation to all kernel-land.
> 
> Lookup from BPF context is not whitelisted yet. While syscalls have a
> dedicated lookup handler.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  net/core/sock_map.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index f48c934d5da0..2e0f465295c3 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -301,7 +301,7 @@ static struct sock *__sock_map_lookup_elem(struct bpf_map *map, u32 key)
>  
>  static void *sock_map_lookup(struct bpf_map *map, void *key)
>  {
> -	return ERR_PTR(-EOPNOTSUPP);
> +	return __sock_map_lookup_elem(map, *(u32 *)key);
>  }
>  
>  static void *sock_map_lookup_sys(struct bpf_map *map, void *key)
> @@ -991,6 +991,11 @@ static void *sock_hash_lookup_sys(struct bpf_map *map, void *key)
>  	return &sk->sk_cookie;
>  }
>  
> +static void *sock_hash_lookup(struct bpf_map *map, void *key)
> +{
> +	return __sock_hash_lookup_elem(map, key);
> +}
> +
>  static void sock_hash_release_progs(struct bpf_map *map)
>  {
>  	psock_progs_drop(&container_of(map, struct bpf_htab, map)->progs);
> @@ -1079,7 +1084,7 @@ const struct bpf_map_ops sock_hash_ops = {
>  	.map_get_next_key	= sock_hash_get_next_key,
>  	.map_update_elem	= sock_hash_update_elem,
>  	.map_delete_elem	= sock_hash_delete_elem,
> -	.map_lookup_elem	= sock_map_lookup,
> +	.map_lookup_elem	= sock_hash_lookup,
>  	.map_lookup_elem_sys_only = sock_hash_lookup_sys,
>  	.map_release_uref	= sock_hash_release_progs,
>  	.map_check_btf		= map_check_no_btf,
> -- 
> 2.24.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
