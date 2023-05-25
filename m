Return-Path: <netdev+bounces-5334-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14764710D8E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:47:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DC501C20E9D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B58E0107AC;
	Thu, 25 May 2023 13:47:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CF21079D
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 13:47:41 +0000 (UTC)
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49279197
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 06:47:40 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-5619032c026so7595137b3.1
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 06:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685022459; x=1687614459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hvX3qTYnWmFe+W70V5JCbvykxTeA+ozEK9uZ5GQt4so=;
        b=q2nzyAvWejUD3JwR7mFGQPT2GPWeaVIEeaFR/7oUXDoDkjI262vYRp7uITJhm38K4g
         upLwGmxLF+ZBT0Wt7HbiVX6ykWWIDZp3Mz6q52Xx0uYDkOJaVqkOqg5ir58fI8ADb2YM
         1vtADouc4aX/U0dSoHAlHGn8Ek0q5R5ozG5/oU/l4b+lHgq7Y+Pst4Uw/btzgwsbj4dC
         bxQ+xjA7JDTKRN3DDTWsIZquxnFaWFng6dkdYrlMib9gT6NKdQqDDVSKuXc0ArDxO8Jn
         qvZiZS4fX/4HXTsXGLKhMhTqVtgrKEGQEebKeBDb2vy2Di6/bSl6fzBnf5gDxNVQH2Xt
         Ku7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685022459; x=1687614459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hvX3qTYnWmFe+W70V5JCbvykxTeA+ozEK9uZ5GQt4so=;
        b=TuXrAKCQNUylJQ7v9C1FeNkECM/8om7JJllTE63Bwuju82alFN914QpyppJEJ5PeZV
         +hNhfRBSMOKoH6RQeS8lDeKVOwUJW0zlwqQj26KFVSkDk/g9vqwZLTruqC5r/4GscoHL
         q3uJvyBt1OavErWKk8o31/7QXACES1pWBgSblmderC5f/xeDNXzZjln3g/FISwNbvv6c
         9kie4vQfAUMPzi3uG696P7353RTjfuKaw68iuIbQXpNQSRcHPOkM9N6+udkv1deE7Maz
         NDRVJRVOEgLUuxGEOwN24YuXGQOXn0Ygg14gzzVNBqpDblKhzTrQgrn8QqJX2DYi1B2M
         p1iQ==
X-Gm-Message-State: AC+VfDy5qcL00+K8eGWvtpGd4uaN3OumSvVERji7H7yh8jajaieB+yfq
	v5gM82WaVGQGcpfVppe54GwqiOA/C5whdRbabY0F1yYl98s2sH3v
X-Google-Smtp-Source: ACHHUZ7y8gATzBWNHSdzx5J9bh9s6aYETJ1C8/dygpgpBavsOQ8azBCpcw01ORvU0zwyW0QsR5nbg5dxKgdYsiiDjgM=
X-Received: by 2002:a81:9c51:0:b0:55a:ec:6de4 with SMTP id n17-20020a819c51000000b0055a00ec6de4mr21696722ywa.10.1685022459535;
 Thu, 25 May 2023 06:47:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230523140342.2672713-1-linus.walleij@linaro.org>
 <20230524221147.5791ba3a@kernel.org> <20230524221247.1dc731a8@kernel.org>
In-Reply-To: <20230524221247.1dc731a8@kernel.org>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 25 May 2023 15:47:27 +0200
Message-ID: <CACRpkdbUrEZ1FAqMCq35z+g3NF1gx_9c_0vhQw6ioqkyOwaAnw@mail.gmail.com>
Subject: Re: [PATCH] xen/netback: Pass (void *) to virt_to_page()
To: Jakub Kicinski <kuba@kernel.org>
Cc: Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>, xen-devel@lists.xenproject.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 7:12=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
> On Wed, 24 May 2023 22:11:47 -0700 Jakub Kicinski wrote:
> > On Tue, 23 May 2023 16:03:42 +0200 Linus Walleij wrote:
> > > virt_to_page() takes a virtual address as argument but
> > > the driver passes an unsigned long, which works because
> > > the target platform(s) uses polymorphic macros to calculate
> > > the page.
> > >
> > > Since many architectures implement virt_to_pfn() as
> > > a macro, this function becomes polymorphic and accepts both a
> > > (unsigned long) and a (void *).
> > >
> > > Fix this up by an explicit (void *) cast.
> >
> > Paul, Wei, looks like netdev may be the usual path for this patch
> > to flow thru, although I'm never 100% sure with Xen.
> > Please ack or LUK if you prefer to direct the patch elsewhere?
>
> Ugh, Wei already acked this, sorry for the noise.

Don't worry about it Jakub, it's queued in the asm-generic tree
along with patches making things give nasty compile messages
if they are not typed right, we try to keep down the level of noise
this way: silence it while fixing the root cause.

If you prefer to take it into the net tree that works too but no need.

Yours,
Linus Walleij

