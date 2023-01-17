Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3032066DA2F
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbjAQJmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbjAQJlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:41:09 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85A9524F;
        Tue, 17 Jan 2023 01:40:07 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id k8so15436899wrc.9;
        Tue, 17 Jan 2023 01:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=THhjTlzh4Q1QKe7vc6e+LLqrfDal4EePNtipGdR1YJc=;
        b=iwPF0CMT/C5eoSllHfEljDINf5D6bMfvuN95gcRDFOcDD86ysmH5HD54XcBdbZs5iI
         WbY5rkKqw3XsC9qR8QIqzQxfcGsNW61ORCoOkDhWV0xPn2UIrPCRvbfXiEp2vEBEMUV2
         TllrUFElKXoWel8sre6WHs2AkkBeaIIWcyy6rE8vA+dsWF16HZ1r4H69KnLxvub6wZuo
         lyDula8KxGvHm04z8x91vjCBu3MLSOY5KCzqC3eWHb6MiyaTLYbqQ7MvcYGc4g6P2E+n
         /z6Dsn6vHNqEIRwgWGz1o6ile/h6J/2zY+Gn//+qkTO6jVpSGlL0nEt4OnPiAauPdVTM
         AWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=THhjTlzh4Q1QKe7vc6e+LLqrfDal4EePNtipGdR1YJc=;
        b=24iVbn1tzLdZKvnsoavAKANyLpNL46iWYpJjjO8mWFJB1eIrSJxmHKBDKJx1ZyNnh4
         KBOgN+/D9F2zEpqalYCOFhgUw9QORry0GCYELKRk/3w+gaNVvO7qRWJSWSAgNY7Gbs62
         UR/ezorU5QqF5JaE8RA3kfoe7zRTRIDDMII2LbTmWf1jAsnTw/XwwnAp8lANoVcVwiV9
         gm35Sfm82dA04/amSFOB56ZRSKCs4Ig94pSxcsy5wjtbv3sxQXiKIDZuB9UWZZUf+8F+
         7Kng5dVm+iZFfnyTCbG+32Hy8zXIHkFF3+ow3MWmi6VS8mMk1EFhKANU0QaomX0j9ind
         k/Tw==
X-Gm-Message-State: AFqh2kqIq0TWdrKClZe/iNoqeMHHju/0juK1WWI9mkfj0LD3yvkPC8Ea
        FTohhVaZWr0JMK/+XRImKhs=
X-Google-Smtp-Source: AMrXdXuaVTlQRWuKLXI3mMTjwxspgpIFicHEHtoe1Jkq4/bPn5ZULiXU+wGqHS5xSjdLOJMZNFt3Lw==
X-Received: by 2002:a5d:610a:0:b0:2bd:fd25:788c with SMTP id v10-20020a5d610a000000b002bdfd25788cmr2210383wrt.21.1673948406450;
        Tue, 17 Jan 2023 01:40:06 -0800 (PST)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id i15-20020a05600011cf00b00294176c2c01sm28026169wrx.86.2023.01.17.01.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 01:40:06 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 17 Jan 2023 10:40:03 +0100
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Paul Moore <paul@paul-moore.com>
Subject: Re: [Patch bpf-next 2/2] bpf: remove a redundant parameter of
 bpf_prog_free_id()
Message-ID: <Y8Zs8yU7rg2FtCBQ@krava>
References: <20230117060249.912679-1-xiyou.wangcong@gmail.com>
 <20230117060249.912679-3-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117060249.912679-3-xiyou.wangcong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 10:02:49PM -0800, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> The second parameter of bpf_prog_free_id() is always true,
> hence can be just eliminated.

hi,
Paul did this already:
  https://lore.kernel.org/bpf/20230106154400.74211-2-paul@paul-moore.com/

it's in bpf/master now

bpf_map_free_id change lgtm, but might be better
to sync with bpf/master first

jirka

> 
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/linux/bpf.h  |  2 +-
>  kernel/bpf/offload.c |  2 +-
>  kernel/bpf/syscall.c | 23 +++++------------------
>  3 files changed, 7 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 3558c192871c..2c0d2383cea0 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1832,7 +1832,7 @@ void bpf_prog_inc(struct bpf_prog *prog);
>  struct bpf_prog * __must_check bpf_prog_inc_not_zero(struct bpf_prog *prog);
>  void bpf_prog_put(struct bpf_prog *prog);
>  
> -void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock);
> +void bpf_prog_free_id(struct bpf_prog *prog);
>  void bpf_map_free_id(struct bpf_map *map);
>  
>  struct btf_field *btf_record_find(const struct btf_record *rec,
> diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
> index ae6d5a5c0798..658032e294ed 100644
> --- a/kernel/bpf/offload.c
> +++ b/kernel/bpf/offload.c
> @@ -217,7 +217,7 @@ static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
>  		offload->offdev->ops->destroy(prog);
>  
>  	/* Make sure BPF_PROG_GET_NEXT_ID can't find this dead program */
> -	bpf_prog_free_id(prog, true);
> +	bpf_prog_free_id(prog);
>  
>  	list_del_init(&offload->offloads);
>  	kfree(offload);
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 1eaa1a18aef7..b56f65328d9c 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1988,7 +1988,7 @@ static int bpf_prog_alloc_id(struct bpf_prog *prog)
>  	return id > 0 ? 0 : id;
>  }
>  
> -void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock)
> +void bpf_prog_free_id(struct bpf_prog *prog)
>  {
>  	unsigned long flags;
>  
> @@ -2000,18 +2000,10 @@ void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock)
>  	if (!prog->aux->id)
>  		return;
>  
> -	if (do_idr_lock)
> -		spin_lock_irqsave(&prog_idr_lock, flags);
> -	else
> -		__acquire(&prog_idr_lock);
> -
> +	spin_lock_irqsave(&prog_idr_lock, flags);
>  	idr_remove(&prog_idr, prog->aux->id);
>  	prog->aux->id = 0;
> -
> -	if (do_idr_lock)
> -		spin_unlock_irqrestore(&prog_idr_lock, flags);
> -	else
> -		__release(&prog_idr_lock);
> +	spin_unlock_irqrestore(&prog_idr_lock, flags);
>  }
>  
>  static void __bpf_prog_put_rcu(struct rcu_head *rcu)
> @@ -2057,13 +2049,13 @@ static void bpf_prog_put_deferred(struct work_struct *work)
>  	__bpf_prog_put_noref(prog, true);
>  }
>  
> -static void __bpf_prog_put(struct bpf_prog *prog, bool do_idr_lock)
> +void bpf_prog_put(struct bpf_prog *prog)
>  {
>  	struct bpf_prog_aux *aux = prog->aux;
>  
>  	if (atomic64_dec_and_test(&aux->refcnt)) {
>  		/* bpf_prog_free_id() must be called first */
> -		bpf_prog_free_id(prog, do_idr_lock);
> +		bpf_prog_free_id(prog);
>  
>  		if (in_irq() || irqs_disabled()) {
>  			INIT_WORK(&aux->work, bpf_prog_put_deferred);
> @@ -2073,11 +2065,6 @@ static void __bpf_prog_put(struct bpf_prog *prog, bool do_idr_lock)
>  		}
>  	}
>  }
> -
> -void bpf_prog_put(struct bpf_prog *prog)
> -{
> -	__bpf_prog_put(prog, true);
> -}
>  EXPORT_SYMBOL_GPL(bpf_prog_put);
>  
>  static int bpf_prog_release(struct inode *inode, struct file *filp)
> -- 
> 2.34.1
> 
