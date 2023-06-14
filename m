Return-Path: <netdev+bounces-10566-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 993B472F15F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 03:11:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 456612812B8
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 01:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C9AE37E;
	Wed, 14 Jun 2023 01:11:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0FD37D
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 01:11:08 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E341FCC;
	Tue, 13 Jun 2023 18:11:06 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-977e7d6945aso30980166b.2;
        Tue, 13 Jun 2023 18:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686705064; x=1689297064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rNmNSkN2nUQ4erTOiloLjh5uXFX2hxtEy1bY/ri8psM=;
        b=Ka2QXTHKDoV+pK9fLz5xT8OSiplGvUI3Pt3Bb/WMmgdeRDBIBytac4qKyJz0O2NOGv
         GBRpLhNe7DjZKOcNMli+QTwsGONRrIZit1w2vR26tTUPAMEyHp6IDnOmphA93WIBeCZH
         /8DfvGKImpAspDNCzLgkp8l603AulsqZWe9AogaBQiIe68zlcHvgutamQ/rIh/eoFJ/h
         Q9V5MpZB/fYizz7BPPvQJZHhcY6KzOEQHce1/1mf22OUdxGUl/HOzgzutc65edFFvFL+
         5WJLvHqyQtOlmQCoiDWhcMx9bHMn6LWNbP8ICuT6fzX60CbRa0aOGaCaUJDbk+HRd7Yt
         PrYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686705064; x=1689297064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rNmNSkN2nUQ4erTOiloLjh5uXFX2hxtEy1bY/ri8psM=;
        b=Y79v/QgHS/GBcdnV7skZHnG7pVcjNucAICx8aZSyDmvXTSIwL7UwI9kMp10sDAGZU/
         X+x5KSFnT/jLT0NoAB+Im5WfFoMPViBNBktySaX5DI5NCTiJoGyjO2F7CLhYTNF0ujmq
         v2U13af4dJT48+3VIbyZxnuIe4VNzsB8ysfrVRn1MxA7KHLKYsuGPuPoeAxZUJhdM+Zv
         0tiNZZdsvhx9gTieUh4VSxT8j98hJuu53XbuGKPnY7IhPfdNs3pDDjngSU4rXMYIRMtM
         YQ+o3pDdSvrN6usYnjF4x/hYdGFBqyK8kxAk4kc+m8VNN5dKYyw1bxm2892j3lNERsdw
         dTLg==
X-Gm-Message-State: AC+VfDxYy/9Grk6m9pytVM+FJFwVAy4zwIbP0VMvHAb03xyvnn0l4R5T
	cLM1aE4Ph99kvJQamUYZVyT5Kg1c+NM7o9S4t7Y=
X-Google-Smtp-Source: ACHHUZ5vEIaVspP9yIdBExWOWFrWANCD0y4fe2QC7FKs0sez8qAvO9bcu1JPK+o+PhaSS8CnVw5Cu4Xrsl2onDQaCWQ=
X-Received: by 2002:a17:907:707:b0:96a:b12d:2fdf with SMTP id
 xb7-20020a170907070700b0096ab12d2fdfmr13995224ejb.12.1686705064320; Tue, 13
 Jun 2023 18:11:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230614001246.538643-1-azeemshaikh38@gmail.com> <7E4A66A6-0B58-43AF-B9E0-62087F2EA11C@kernel.org>
In-Reply-To: <7E4A66A6-0B58-43AF-B9E0-62087F2EA11C@kernel.org>
From: Azeem Shaikh <azeemshaikh38@gmail.com>
Date: Tue, 13 Jun 2023 21:10:53 -0400
Message-ID: <CADmuW3VcK4zH0oOi8JxsdNvVwfxz+hf-aabLtf4xOJuYtM+jzA@mail.gmail.com>
Subject: Re: [PATCH v2] SUNRPC: Remove strlcpy
To: Kees Cook <kees@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org, 
	Neil Brown <neilb@suse.de>, Olga Kornievskaia <kolga@netapp.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Tom Talpey <tom@talpey.com>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 9:04=E2=80=AFPM Kees Cook <kees@kernel.org> wrote:
>
> On June 13, 2023 5:12:46 PM PDT, Azeem Shaikh <azeemshaikh38@gmail.com> w=
rote:
> >strlcpy() reads the entire source buffer first.
> >This read may exceed the destination size limit.
> >This is both inefficient and can lead to linear read
> >overflows if a source string is not NUL-terminated [1].
> >In an effort to remove strlcpy() completely [2], replace
> >strlcpy() here with sysfs_emit().
> >
> >Direct replacement is safe here since the getter in kernel_params_ops
> >handles -errno return [3].
> >
> >[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlc=
py
> >[2] https://github.com/KSPP/linux/issues/89
> >[3] https://elixir.bootlin.com/linux/v6.4-rc6/source/include/linux/modul=
eparam.h#L52
> >
> >Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
> >---
> > net/sunrpc/svc.c |    8 ++++----
> > 1 file changed, 4 insertions(+), 4 deletions(-)
> >
> >diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
> >index e6d4cec61e47..77326f163801 100644
> >--- a/net/sunrpc/svc.c
> >+++ b/net/sunrpc/svc.c
> >@@ -109,13 +109,13 @@ param_get_pool_mode(char *buf, const struct kernel=
_param *kp)
> >       switch (*ip)
> >       {
> >       case SVC_POOL_AUTO:
> >-              return strlcpy(buf, "auto\n", 20);
> >+              return sysfs_emit(buf, "auto\n");
> >       case SVC_POOL_GLOBAL:
> >-              return strlcpy(buf, "global\n", 20);
> >+              return sysfs_emit(buf, "global\n");
> >       case SVC_POOL_PERCPU:
> >-              return strlcpy(buf, "percpu\n", 20);
> >+              return sysfs_emit(buf, "percpu\n");
> >       case SVC_POOL_PERNODE:
> >-              return strlcpy(buf, "pernode\n", 20);
> >+              return sysfs_emit(buf, "pernode\n");
> >       default:
> >               return sprintf(buf, "%d\n", *ip);
>
> Please replace the sprintf too (and then the Subject could be "use sysfs_=
emit" or so).

Ah sorry, I missed the "replace default sprintf too" part in the
previous thread. Resending.

>
> -Kees
>
>
>
> --
> Kees Cook

