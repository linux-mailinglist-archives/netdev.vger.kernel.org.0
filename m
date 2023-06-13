Return-Path: <netdev+bounces-10506-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4115272EC1A
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:42:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06D042810BD
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:42:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C74B3D394;
	Tue, 13 Jun 2023 19:42:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA8D136A
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 19:42:16 +0000 (UTC)
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5187D1A5
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:42:15 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1b3a9e5bf6aso22568395ad.3
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1686685335; x=1689277335;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZxEcj49+vGwYkRgl1icr+yGC9c7gL0eXEsyVyEAa72I=;
        b=QDF6XybuuSbESC6lsMPSOgkZPqsKAZRVX6eAzuQeJFFgsCxewr0dbZQsAQcrNv/Jt/
         cUwNgWA3FaBmym/Q0URJfdCq/RYEH3el9I+AIsJg4wNI/j3dqAL883+nv6ycCEqwu8Is
         szTUB9KYgk+4+OrfO9cFjQmr2dHKH1dCCXOEo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686685335; x=1689277335;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZxEcj49+vGwYkRgl1icr+yGC9c7gL0eXEsyVyEAa72I=;
        b=gDO6nUB3AdjejzSZ8zETSmhPQYH2EfXLeSJgjwOSh4p98VG6A95/FuBcJkb8ZwMxat
         a6gRJJx8p9anSooTrWzYXGod4dAO7rVddv7Qc0QoPmrDus5gKj0JAYGoyoU4C6/qEQyE
         zg7izPHY0x7JVDhYeLuyIPWTQzCzAeGLi6IXRNn8vDDXn8tzYz7AJUDF0Y/ADYN9hVLU
         tdkpIs9O6InSLIudmNkp0WwpNpwRZEZGMKkpbwIUVr9S23ojrbL01fFiweCtVMBIXToY
         5p4FBXFcvKNaTazqCuSANTF9qTlzBl642k/Q6SjX8m8fCD4BTjQH2DnYLssHfuaGPOra
         nhDA==
X-Gm-Message-State: AC+VfDyy6/APmijmNDq9sE8it9vgn/i3cM8CigronbDhDGq80c5Q3X6d
	ZUjbzQgDV0EEZxu1HCaikz5X/Q==
X-Google-Smtp-Source: ACHHUZ4ASqDKrvZKerhnxXxdgCYThmTm+1P/kHDzqnN8JNmhcPCltk7Mdv4E+dofJzdv0DLD1v2ZjQ==
X-Received: by 2002:a17:902:e88f:b0:1b3:ebda:6563 with SMTP id w15-20020a170902e88f00b001b3ebda6563mr2783752plg.53.1686685334830;
        Tue, 13 Jun 2023 12:42:14 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id t10-20020a170902bc4a00b001b3c48d01d0sm3902plz.65.2023.06.13.12.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 12:42:14 -0700 (PDT)
Date: Tue, 13 Jun 2023 12:42:13 -0700
From: Kees Cook <keescook@chromium.org>
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Azeem Shaikh <azeemshaikh38@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	Neil Brown <neilb@suse.de>, Olga Kornievskaia <kolga@netapp.com>,
	Dai Ngo <dai.ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Replace strlcpy with strscpy
Message-ID: <202306131238.92CBED5@keescook>
References: <20230613004054.3539554-1-azeemshaikh38@gmail.com>
 <01E2FCED-7EB6-4D06-8BB0-FB0D141B546E@oracle.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01E2FCED-7EB6-4D06-8BB0-FB0D141B546E@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 02:18:06PM +0000, Chuck Lever III wrote:
> 
> 
> > On Jun 12, 2023, at 8:40 PM, Azeem Shaikh <azeemshaikh38@gmail.com> wrote:
> > 
> > strlcpy() reads the entire source buffer first.
> > This read may exceed the destination size limit.
> > This is both inefficient and can lead to linear read
> > overflows if a source string is not NUL-terminated [1].
> > In an effort to remove strlcpy() completely [2], replace
> > strlcpy() here with strscpy().
> 
> Using sprintf() seems cleaner to me: it would get rid of
> the undocumented naked integer. Would that work for you?

This is changing the "get" routine for reporting module parameters out
of /sys. I think the right choice here is sysfs_emit(), as it performs
the size tracking correctly. (Even the "default" sprintf() call should
be replaced too, IMO.)

> 
> 
> > Direct replacement is safe here since the getter in kernel_params_ops
> > handles -errorno return [3].
> 
> s/errorno/errno/
> 
> 
> > [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> > [2] https://github.com/KSPP/linux/issues/89
> > [3] https://elixir.bootlin.com/linux/v6.4-rc6/source/include/linux/moduleparam.h#L52
> > 
> > Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
> > ---
> > net/sunrpc/svc.c |    8 ++++----
> > 1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
> > index e6d4cec61e47..e5f379c4fdb3 100644
> > --- a/net/sunrpc/svc.c
> > +++ b/net/sunrpc/svc.c
> > @@ -109,13 +109,13 @@ param_get_pool_mode(char *buf, const struct kernel_param *kp)
> > switch (*ip)
> > {
> > case SVC_POOL_AUTO:
> > - return strlcpy(buf, "auto\n", 20);
> > + return strscpy(buf, "auto\n", 20);

e.g.
	return sysfs_emit(buf, "auto\n");
...

> > case SVC_POOL_GLOBAL:
> > - return strlcpy(buf, "global\n", 20);
> > + return strscpy(buf, "global\n", 20);
> > case SVC_POOL_PERCPU:
> > - return strlcpy(buf, "percpu\n", 20);
> > + return strscpy(buf, "percpu\n", 20);
> > case SVC_POOL_PERNODE:
> > - return strlcpy(buf, "pernode\n", 20);
> > + return strscpy(buf, "pernode\n", 20);
> > default:
> > return sprintf(buf, "%d\n", *ip);

and:

	return sysfs_emit(buf, "%d\n", *ip);


-Kees

-- 
Kees Cook

