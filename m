Return-Path: <netdev+bounces-10053-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA70472BCBA
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:33:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 162411C20B3A
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53E1617AA2;
	Mon, 12 Jun 2023 09:25:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4910D111A1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:25:48 +0000 (UTC)
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805FC5240
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:25:45 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id d75a77b69052e-3f9a81da5d7so316181cf.0
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686561944; x=1689153944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MSSAFm6+La0WYoIdzdJ2avWuWJ5iicl8dG6XgVp+olQ=;
        b=zZps9/nxLxCtnv5ZhZR8AYZPyMufWje3CcLJRlAg/i/29S9gt4HxXzx6YUU07CJ0Xw
         TaFaE1h5HNNtq7ESaOcRJp6oq2rV2nuDuAI9ywPVcajyYRBqACVV0meILNibQBXrIRaq
         SxtekwESF9/Btl7FT5CyiEkx7/t0JnKAwWT9uuAuITp2jENeIB2aIgeo+04rH7o11bM9
         x1HPjg3dnQSz+nVaKF9gFva1wXrW7YawgaVx9Uuq/WXurTMvDwaQlzksC5k8KmlTS9lc
         VeC5YWjBR36ci0QcEuAJCGnyvJHYMAskCeROdpC4/aLkgd9Lwn7S6OwgiIjAdNx/RYA3
         GCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686561944; x=1689153944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MSSAFm6+La0WYoIdzdJ2avWuWJ5iicl8dG6XgVp+olQ=;
        b=DnVO8+UkAWGat8jH1umCs0QgByPos/Y01FP7aNN8THv0xYtKyiPY6xnLgAKJ12ktj/
         K5IdkbA+7ISnrYVIvDrlCLFPXPIIfAIUEUTDLg/sPhEi/LbkzG/H6p8bFL7iAg5djbq2
         CyHdJiwYmiEiiMirNbDlPDzH+vTCaHyf41xn+0qZ/1bjb19s1Su7I5T91UEl+GeBXJ/K
         vG8r87mdJAfdimKKxCZdkGSyMyyqBVDtmKNC2tTtBHbSJWnHSP6QvaYwNskhbCEYADhU
         7edIieCk06RdF8ehK3S+LqL4F5Q1UNeYv1xm7W8/BqWhB0t9kmxM6l7sJ5IPfLoS+v4D
         6bXA==
X-Gm-Message-State: AC+VfDyCLT3GvNWhSNTycT7AEbMoLvyWoF4iyVjbUo6DDRhjOs/IRbi6
	ffzdu8a+rHn7k6b1KWDd2c4cuehjEs9nQSILVohncQ==
X-Google-Smtp-Source: ACHHUZ51aDjv0JS+PAW08rSBNZ0RJJgZL+Bg/FxemASKSUJ4kWa+tvdS4Bq5PZqqsY+jjxVBUm5vyTI/8xdZMyYInwU=
X-Received: by 2002:ac8:7f15:0:b0:3f7:ff4a:eae5 with SMTP id
 f21-20020ac87f15000000b003f7ff4aeae5mr311442qtk.12.1686561944340; Mon, 12 Jun
 2023 02:25:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230608202628.837772-1-aleksandr.mikhalitsyn@canonical.com> <20230608202628.837772-5-aleksandr.mikhalitsyn@canonical.com>
In-Reply-To: <20230608202628.837772-5-aleksandr.mikhalitsyn@canonical.com>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 12 Jun 2023 11:25:33 +0200
Message-ID: <CANn89iKHxT_yFRE9StCF0QzzYENxAn9E-QxvgB0cA13tEGFXig@mail.gmail.com>
Subject: Re: [PATCH net-next v7 4/4] af_unix: Kconfig: make CONFIG_UNIX bool
To: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Leon Romanovsky <leon@kernel.org>, 
	David Ahern <dsahern@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, 
	Christian Brauner <brauner@kernel.org>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Lennart Poettering <mzxreary@0pointer.de>, Luca Boccassi <bluca@debian.org>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 10:27=E2=80=AFPM Alexander Mikhalitsyn
<aleksandr.mikhalitsyn@canonical.com> wrote:
>
> Let's make CONFIG_UNIX a bool instead of a tristate.
> We've decided to do that during discussion about SCM_PIDFD patchset [1].
>
> [1] https://lore.kernel.org/lkml/20230524081933.44dc8bea@kernel.org/
>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: Lennart Poettering <mzxreary@0pointer.de>
> Cc: Luca Boccassi <bluca@debian.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com=
>

Reviewed-by: Eric Dumazet <edumazet@google.com>

