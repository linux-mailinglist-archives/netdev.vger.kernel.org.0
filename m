Return-Path: <netdev+bounces-224-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D51CE6F6227
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 01:39:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF8A51C21026
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 23:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2D1E570;
	Wed,  3 May 2023 23:39:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC37DF6B
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 23:39:49 +0000 (UTC)
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1548B93D2
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 16:39:42 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4f004cc54f4so7285330e87.3
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 16:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683157180; x=1685749180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0HXkL02VMoC0EFrNenqQE5y6I1Ub1UB/43vTjoNPWKs=;
        b=f63IrZVQh0muDnnVAfW9U5SmV3nM6A5XPVB0wQEqHmtHGw7bHmGgZIgGFFJzooYmdS
         A0pb1vTKRQMeVlyt+Qxyer0lt9PhfS9VztQSzEGXb8nPl7ueH+qnajLEbyf5HDH4MMWv
         jOsJpkpEczuG8qknOv7FgR9IuJ98fU/msDrlagCXKMBRsdqRVEgGbuKigTNgnIKcdDW0
         gYZjkCIVs/AUMo2CQstMe6LnTqyfr8TXq0/WxzhF/oZxSH77O9u3/uR/H6r3ytvRHSVn
         PPKONNgK7zfd5jKfy8Gj48qha0YcmcZpfXSM87Zhxgl0Ea3ByO/2EUUE5E6qLRWl9+fu
         6AjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683157180; x=1685749180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0HXkL02VMoC0EFrNenqQE5y6I1Ub1UB/43vTjoNPWKs=;
        b=HPEyB9aPVnv61carVTotEs0ezyHYR8UN0zdUPVGKEs1eIuygQ1Dml34IJKd/8s/MhE
         H66l2mrVyglv/pCc7+ktz3LG3lDhWb1yZzuA55xAM5Njc4EizP5JD+Go9OrIem+XpBOJ
         pVqXS8QKzpuxfuSFYRIQTwCM6iBc3wCXV6mg6IZBXYZk4q/OA4oC8KUPMB7QemgXN+jl
         Y+ggqKfJQJEcmrKC5LrCIW7giKU6nTOPC8OqLZOKfBJ77khSZ0zmeMH4xki4OJYW5aLt
         ebhp3S6sNbEEe0ZKuoNBsecIQBSsSamto6OllfN2+DFn364ELsx6xnuONKh49UF3/TMr
         wPqA==
X-Gm-Message-State: AC+VfDzJEWOANXKlmt+Ck/gh+Q0ruLPVp4hLAuIEGQcgkSIsCmlfg6GZ
	oaiRHy+S8gAWQAT7aYi9JljsDQBgwI8SnQ9gZAo=
X-Google-Smtp-Source: ACHHUZ4BS3m/bqg8+QLeHM8WJVElceYZxOaIae3Zi3b1d5POM6FGj1LLQjUyd8WYKIkc1JfpJM0/dqShqXDzQtMcV5w=
X-Received: by 2002:a2e:3507:0:b0:2ac:7782:b0c1 with SMTP id
 z7-20020a2e3507000000b002ac7782b0c1mr525719ljz.46.1683157180067; Wed, 03 May
 2023 16:39:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJGXZLjLXrUzz4S9C7SqeyszMMyjR6RRu52y1fyh_d6gRqFHdA@mail.gmail.com>
 <20230503113528.315485f1@hermes.local>
In-Reply-To: <20230503113528.315485f1@hermes.local>
From: Aleksey Shumnik <ashumnik9@gmail.com>
Date: Thu, 4 May 2023 02:39:29 +0300
Message-ID: <CAJGXZLgC-D9owgVdkE2nybEvLme_VsVGMdb6dKuGK0a2+5Vq+A@mail.gmail.com>
Subject: Re: [BUG] Dependence of routing cache entries on the ignore-df flag
To: stephen@networkplumber.org
Cc: netdev@vger.kernel.org, waltje@uwalt.nl.mugnet.org, 
	Jakub Kicinski <kuba@kernel.org>, gw4pts@gw4pts.ampr.org, kuznet@ms2.inr.ac.ru, 
	"willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>, gnault@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 3, 2023 at 9:35=E2=80=AFPM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Wed, 3 May 2023 18:01:03 +0300
> Aleksey Shumnik <ashumnik9@gmail.com> wrote:
>
> > Might you answer the questions:
> > 1. How the ignore-df flag and adding entries to the routing cache is
> > connected? In which kernel files may I look to find this connection?
> > 2. Is this behavior wrong?
> > 3. Is there any way to completely disable the use of the routing
> > cache? (as far as I understand, it used to be possible to set the
> > rhash_entries parameter to 0, but now there is no such parameter)
> > 4. Why is an entry added to the routing cache if a suitable entry was
> > eventually found in the arp table (it is added directly, without being
> > temporarily added to the routing table)?
>
> What kernel version.

Sorry, I didn't specify the kernel version.
I'm using kernel version 6.1.15

> The route cache has been completely removed from the kernel for a long ti=
me.

Yes, I even found a commit in which this was done
89aef8921bfbac22f00e04f8450f6e447db13e42.
This is my question, it is strange that the routing cache is still
used in version 6 of the kernel. In my first letter I wrote how to
reproduce such behavior, which seems to be erroneous.
I also ask you to pay attention to the fact that this error is
reproduced if the ignore-df flag is set on the interface.

