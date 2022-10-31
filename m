Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCAF3614030
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 22:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiJaVyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 17:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiJaVxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 17:53:53 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDA8140C9;
        Mon, 31 Oct 2022 14:53:52 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id b2so32827950eja.6;
        Mon, 31 Oct 2022 14:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zdYNF6EUojfs0G57LtoPct7Uq38+dK+sU9/t/CK1zr8=;
        b=dd3qB6WAJlYsE9wP/tCQU7sxRC0VEJ+ENYOIJBZ9x1nxKLDOs+gxPbNJ3JcbqZzMUj
         Eu1uqtwJ71JjtASe52CsARhT8J0G08u+lioi2hLW9JmLWGw7JZxUbj2v2+Vz9/oF0wFY
         BP3gIMhTMlj0zsGsTlDK22Jh0xeEOsszTlclrU6JrJG+M60xmKqiZkTw5H+cWGFgzWdz
         VTU7V95R2LMK5ShBWu+/7YNP227U1iesGBdzg4lvecjema4ij3HNVmUmi+Tb0MEQ4MF3
         zP27dLqDAqqgQG2un5DQlD8wGVvNKYf2wbcrl1/h1YbAV9NYmUUgOdu0OusLw1QvagHc
         J6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zdYNF6EUojfs0G57LtoPct7Uq38+dK+sU9/t/CK1zr8=;
        b=W9igpE1lZPqc9Cqj+F+Vr6yEzOq5uQqCXfcCcwPIFcqpTNs7PRVrfyc2eI9IVKGLnd
         yOrAsMVpw7lm31ykd7JGnVDvKlNdbk7TEknB2Nbv5mQndAvV1S+hUrXm+RD35eRhhS0s
         KxeMhqTMAKbViB58Elg4N899wxsReagvrxKVBM7ny/W6msAwqbWfKGYQjhXftLt+4h3C
         Rs2TbRipSzNznAZamMISVWah83Tx2rQmyRjQ8IQKhRCJqNh/zwpI9vtD0oC1xdcebhzK
         sZ/2ZuI/89JSnx+HI6lPU9+dm9XQ3SOAhbwc1GufRnzxaZJdTaeOLUq2JXQ5xqiv5+x/
         iskg==
X-Gm-Message-State: ACrzQf1ACYWENtRAD+WVCs3WiK4uTiwbdw+iJ/LIDPL1aIyg/nNHCAd0
        BzXrfsekjZNXijLy37M9E/o=
X-Google-Smtp-Source: AMsMyM6pc1rzE48OuKtJA/UAndbhX4M038/lkAK/YL+GR70D+HcyrJb+6UgD49Sp1aS0c3T2KUkr9g==
X-Received: by 2002:a17:907:6d94:b0:7ad:95fd:d1e4 with SMTP id sb20-20020a1709076d9400b007ad95fdd1e4mr15608353ejc.233.1667253230605;
        Mon, 31 Oct 2022 14:53:50 -0700 (PDT)
Received: from krava ([83.240.62.146])
        by smtp.gmail.com with ESMTPSA id l1-20020a1709067d4100b00782e3cf7277sm3416697ejp.120.2022.10.31.14.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 14:53:49 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 31 Oct 2022 22:53:47 +0100
To:     Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bpf@vger.kernel.org
Subject: Re: Linux 6.1-rc3 build fail in include/linux/bpf.h
Message-ID: <Y2BD6xZ108lv3j7J@krava>
References: <439d8dc735bb4858875377df67f1b29a@AcuMS.aculab.com>
 <Y1+8zIdf8mgQXwHg@krava>
 <Y1/oBlK0yFk5c/Im@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y1/oBlK0yFk5c/Im@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 04:21:42PM +0100, Peter Zijlstra wrote:
> On Mon, Oct 31, 2022 at 01:17:16PM +0100, Jiri Olsa wrote:
> > On Mon, Oct 31, 2022 at 11:14:31AM +0000, David Laight wrote:
> > > The 6.1-rc3 sources fail to build because bpf.h unconditionally
> > > #define BPF_DISPATCHER_ATTRIBUTES __attribute__((patchable_function_entry(5)))
> > > for X86_64 builds.
> > > 
> > > I'm pretty sure that should depend on some other options
> > > since the compiler isn't required to support it.
> > > (The gcc 7.5.0 on my Ubunti 18.04 system certainly doesn't)
> > > 
> > > The only other reference to that attribute is in the definition
> > > of 'notrace' in compiler.h.
> > 
> > I guess we need to make some __has_attribute check and make all that conditional
> > 
> > cc-ing Peter
> 
> Does something crazy like the below work? It compiles but is otherwise
> totally untested.

looks good

it has now the ftrace nop and the jump to the dispatcher image
or the bpf_dispatcher_nop_func.. great :)

	bpf_dispatcher_xdp_func:

	ffffffff81cc87b0 <load1+0xcc87b0>:
	ffffffff81cc87b0:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
	ffffffff81cc87b5:       e9 a6 fe 65 ff          jmp    0xffffffff81328660

tests work for me..  Toke, Björn, could you please check?

thanks,
jirka


> 
> ---
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 9e7d46d16032..7d7a00306d19 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -953,6 +953,10 @@ struct bpf_dispatcher {
>  	void *rw_image;
>  	u32 image_off;
>  	struct bpf_ksym ksym;
> +#ifdef CONFIG_HAVE_STATIC_CALL
> +	struct static_call_key *sc_key;
> +	void *sc_tramp;
> +#endif
>  };
>  
>  static __always_inline __nocfi unsigned int bpf_dispatcher_nop_func(
> @@ -970,6 +974,20 @@ struct bpf_trampoline *bpf_trampoline_get(u64 key,
>  					  struct bpf_attach_target_info *tgt_info);
>  void bpf_trampoline_put(struct bpf_trampoline *tr);
>  int arch_prepare_bpf_dispatcher(void *image, void *buf, s64 *funcs, int num_funcs);
> +
> +
> +#ifdef CONFIG_HAVE_STATIC_CALL
> +#define BPF_DISPATCH_CALL(name)	static_call(bpf_dispatcher_##name##_call)(ctx, insnsi, bpf_func)
> +
> +#define __BPF_DISPATCHER_SC_INIT(_name)				\
> +	.sc_key = &STATIC_CALL_KEY(_name),			\
> +	.sc_tramp = STATIC_CALL_TRAMP_ADDR(_name),
> +
> +#else
> +#define BPF_DISPATCH_CALL(name)	bpf_func(ctx, insnsi)
> +#define __BPF_DISPATCHER_SC_INIT(name)
> +#endif
> +
>  #define BPF_DISPATCHER_INIT(_name) {				\
>  	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
>  	.func = &_name##_func,					\
> @@ -981,32 +999,29 @@ int arch_prepare_bpf_dispatcher(void *image, void *buf, s64 *funcs, int num_func
>  		.name  = #_name,				\
>  		.lnode = LIST_HEAD_INIT(_name.ksym.lnode),	\
>  	},							\
> +	__BPF_DISPATCHER_SC_INIT(_name##_call)			\
>  }
>  
> -#ifdef CONFIG_X86_64
> -#define BPF_DISPATCHER_ATTRIBUTES __attribute__((patchable_function_entry(5)))
> -#else
> -#define BPF_DISPATCHER_ATTRIBUTES
> -#endif
> -
>  #define DEFINE_BPF_DISPATCHER(name)					\
> -	notrace BPF_DISPATCHER_ATTRIBUTES				\
> +	DEFINE_STATIC_CALL(bpf_dispatcher_##name##_call, bpf_dispatcher_nop_func); \
>  	noinline __nocfi unsigned int bpf_dispatcher_##name##_func(	\
>  		const void *ctx,					\
>  		const struct bpf_insn *insnsi,				\
>  		bpf_func_t bpf_func)					\
>  	{								\
> -		return bpf_func(ctx, insnsi);				\
> +		return BPF_DISPATCH_CALL(name);				\
>  	}								\
>  	EXPORT_SYMBOL(bpf_dispatcher_##name##_func);			\
>  	struct bpf_dispatcher bpf_dispatcher_##name =			\
>  		BPF_DISPATCHER_INIT(bpf_dispatcher_##name);
> +
>  #define DECLARE_BPF_DISPATCHER(name)					\
>  	unsigned int bpf_dispatcher_##name##_func(			\
>  		const void *ctx,					\
>  		const struct bpf_insn *insnsi,				\
>  		bpf_func_t bpf_func);					\
>  	extern struct bpf_dispatcher bpf_dispatcher_##name;
> +
>  #define BPF_DISPATCHER_FUNC(name) bpf_dispatcher_##name##_func
>  #define BPF_DISPATCHER_PTR(name) (&bpf_dispatcher_##name)
>  void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
> diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
> index fa64b80b8bca..1ca8bd6da6bb 100644
> --- a/kernel/bpf/dispatcher.c
> +++ b/kernel/bpf/dispatcher.c
> @@ -4,6 +4,7 @@
>  #include <linux/hash.h>
>  #include <linux/bpf.h>
>  #include <linux/filter.h>
> +#include <linux/static_call.h>
>  
>  /* The BPF dispatcher is a multiway branch code generator. The
>   * dispatcher is a mechanism to avoid the performance penalty of an
> @@ -106,7 +107,6 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
>  {
>  	void *old, *new, *tmp;
>  	u32 noff;
> -	int err;
>  
>  	if (!prev_num_progs) {
>  		old = NULL;
> @@ -128,11 +128,10 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
>  			return;
>  	}
>  
> -	err = bpf_arch_text_poke(d->func, BPF_MOD_JUMP, old, new);
> -	if (err || !new)
> -		return;
> +	__static_call_update(d->sc_key, d->sc_tramp, new ?: &bpf_dispatcher_nop_func);
>  
> -	d->image_off = noff;
> +	if (new)
> +		d->image_off = noff;
>  }
>  
>  void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
