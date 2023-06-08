Return-Path: <netdev+bounces-9337-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2DE47288D4
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06452281790
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 399651F930;
	Thu,  8 Jun 2023 19:40:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1F0168CE
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 19:40:09 +0000 (UTC)
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11557134
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 12:40:08 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 3f1490d57ef6-ba8cd61ee2dso3074111276.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 12:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1686253207; x=1688845207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5dJBCTsq9Xw5p421JbO2Khi1BzsFXDH5KI5pOiwejyE=;
        b=T8+ajB0IGaul1f4L9rSxr7/sO33HCz42RRag+mNL8dvn6SBlBQFzcr/KANcsaZnvaj
         ZwPFxcHeRf3RARJ2g31tSBQQjG8/c9VridAq3j+SXN5jvfDA1REreBx4NySPMG0DLtsQ
         BteLRnXcaZMUP5zSDD4PYcpg/A0L0NqBeRO+CsdKlh9lqxI/uZdGa/kFjliAnIKX/2m6
         acYZnOJVy4sQscQUCBe5mRkVrbG4vwEH6dQ8ABBVlRfnj6olPHwjyN/tn+Mb1iXFJ13X
         HSywuz+7HXNrV3/5QlE911s1K/2jEIxDWwLcMrc0vUEhAUr5TUyNERJpj60wWa1FUCAj
         8Gjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686253207; x=1688845207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5dJBCTsq9Xw5p421JbO2Khi1BzsFXDH5KI5pOiwejyE=;
        b=aRQdTJ/oxnUzOPA353jq/GryRDtWlof2c20lD/W6/MlK3EA6QLz+LqJo2gfa/z8FfY
         ai+9W4STphZMA4aooYXxFTWxpsvRQ3igKgaeimnhAbWo6MyYN1lJzF1ymvInx8/gmXEP
         P5R+U/CEaQHFVDGknxIV3vx1Dr+UWFGNzzLScvhv6Nk9AupewQQ/ueVDIWEu4oGKuel8
         i6Bes1GdzJxTZtBqh8+QpjpPWEtkeJVAHSqWJOb6rdxz8Nz8B1yoyFQbbBGaa9QBuHYE
         AOI64cX0/UHvr8lekAT5DJu6jWahOvdyurH02LWl28wTzDQkLNZyQBWXywTsjmCM4D/C
         y3vw==
X-Gm-Message-State: AC+VfDxxUCSP4N3821aemJZEsWUQ0yCqMOxjko6NXqRS+9V67I5e+4+v
	D13cOnZNsPETtbRQVgsXVrtjYGY9p3l9z+jG0rfzpHbPF8vFfnc=
X-Google-Smtp-Source: ACHHUZ49nh4oyyb4CFZgWniE1i3Pa7CJZ8qs4NQxwbKEeSQhylZPIIIuabe6hbeH2QUXqSwGtIouVaoc/kjRFSbDY34=
X-Received: by 2002:a81:6ccd:0:b0:569:ef2b:e20 with SMTP id
 h196-20020a816ccd000000b00569ef2b0e20mr482524ywc.23.1686253207277; Thu, 08
 Jun 2023 12:40:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230608191304.253977-2-paul@paul-moore.com>
In-Reply-To: <20230608191304.253977-2-paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 8 Jun 2023 15:39:56 -0400
Message-ID: <CAHC9VhTcLJRc-8z86Re1=5HxSQkvgr0cSH_TArAOuC+jGr3PzQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: move labeled networking to "supported"
To: linux-security-module@vger.kernel.org
Cc: netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 3:13=E2=80=AFPM Paul Moore <paul@paul-moore.com> wro=
te:
>
> My current employer, Microsoft, cares very much about the development
> and maintenance of the upstream Linux Kernel so we can consider
> labeled networking to be "supported" according to the definition in
> MAINTAINERS:
>
>   S: *Status*, one of the following:
>       Supported:  Someone is actually paid to look after this.
>       Maintained: Someone actually looks after it.
>       ...
>
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

FYI, I just merged this via lsm/next.

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7e0b87d5aa2e..8818cd866009 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14667,7 +14667,7 @@ NETWORKING [LABELED] (NetLabel, Labeled IPsec, SE=
CMARK)
>  M:     Paul Moore <paul@paul-moore.com>
>  L:     netdev@vger.kernel.org
>  L:     linux-security-module@vger.kernel.org
> -S:     Maintained
> +S:     Supported
>  W:     https://github.com/netlabel
>  F:     Documentation/netlabel/
>  F:     include/net/calipso.h
> --
> 2.41.0

--=20
paul-moore.com

