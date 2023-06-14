Return-Path: <netdev+bounces-10762-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 758A4730279
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:55:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A78DE1C20CF4
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D54F38BFB;
	Wed, 14 Jun 2023 14:55:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78CF2C9C
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:55:28 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1762D1BF9;
	Wed, 14 Jun 2023 07:55:27 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f8cc042ea9so6885355e9.2;
        Wed, 14 Jun 2023 07:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686754525; x=1689346525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T4N1c6zVQK/GqEbZwTQjJCqHfXHnX5xa7l1nDf0Hm1o=;
        b=XUhpmQmpGLIkkPyyztg9FS6mkJm/S+i1/rxI0FinKgy5fImau9FTl8c5yHMWMGCrRP
         Oa5Gq46hVL+JosJ6mBsQQiKy6sKfvVYNwkj3xDmO2hmqY0a3zQYT907/Qdf7aJKpZqnS
         M+ur12nvDU9IGaTsYSvAYKVzerQtm9Co/cW7f6uwqevQIdukkrv63+3rkIWKx79ZVQD5
         C96FAFTWVc+Dkcl+yl2k5Wo43luOAV/uMTfuBRcjAUNw3uU4gEhvRnuVeMZh/BJYnx1K
         s0Tg5YsK/R2VJPnYtId87WqPHj/MV5oiw0oXFhMFjlJ3ApVgbDKmQPx3F2N2uT4gZORQ
         llvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686754525; x=1689346525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T4N1c6zVQK/GqEbZwTQjJCqHfXHnX5xa7l1nDf0Hm1o=;
        b=K0Oa8Ax+X3Y7vA98GE2Nwotph6JbBAzPtFnsp/wD9yg9Kyf81//o8vWExZUw7sY3me
         9cXzS7qokKs2dhssOLk19Z/xpfsgqnlAS2PwmC4h1j4V4G32g9Obqtnr+hPyDZ5soO7H
         Put/2sId0II82kKIt5AMPJmzCh0/IuATC4GNjlL6Vr2LnicuO64gJVMvQlMM65TcO640
         PxrSV3BrtjsC4yVKEM2FupTFNwXqh6s8gxUwX+nftuOlXdHSun+pt5HR9xPqYcuvy13i
         aCpdLsZNDeYlQJbWCPE+Jw0TRduZeL7o+f84mnJXlyDcNVzX0AkvuNkECaqmScrY8QP/
         CRsQ==
X-Gm-Message-State: AC+VfDwC5zEeasi/KLb1nlOdWS5Rj/CvT4bqngvkPH2mq1D/4htGYH8t
	cYRSlhESj/kfoVLCphX0BhWuBCiLGBHI70auHmI=
X-Google-Smtp-Source: ACHHUZ4msgwE+q6HFYQwwH4Mk0z8/+q5/cKdOb2qnWR4s+MB1DC7r49BI4Ozw43XZkMTuGJsmBD2YFfwWrfuLaKzu8U=
X-Received: by 2002:a5d:6949:0:b0:311:101f:6c17 with SMTP id
 r9-20020a5d6949000000b00311101f6c17mr690308wrw.2.1686754525211; Wed, 14 Jun
 2023 07:55:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230614134956.2109252-1-azeemshaikh38@gmail.com> <874jnaf7fv.fsf@kernel.org>
In-Reply-To: <874jnaf7fv.fsf@kernel.org>
From: Azeem Shaikh <azeemshaikh38@gmail.com>
Date: Wed, 14 Jun 2023 10:55:13 -0400
Message-ID: <CADmuW3WEUgnpGXg=ajpRvwON6mFLQD9cPKnhsg35CcNqwcywxA@mail.gmail.com>
Subject: Re: [PATCH v3] wifi: cfg80211: replace strlcpy() with strscpy()
To: Kalle Valo <kvalo@kernel.org>
Cc: linux-hardening@vger.kernel.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	netdev@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 10:24=E2=80=AFAM Kalle Valo <kvalo@kernel.org> wrot=
e:
>
> Azeem Shaikh <azeemshaikh38@gmail.com> writes:
>
> > strlcpy() reads the entire source buffer first.
> > This read may exceed the destination size limit.
> > This is both inefficient and can lead to linear read
> > overflows if a source string is not NUL-terminated [1].
> > In an effort to remove strlcpy() completely [2], replace
> > strlcpy() here with strscpy().
> >
> > Direct replacement is safe here since WIPHY_ASSIGN is only used by
> > TRACE macros and the return values are ignored.
> >
> > [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strl=
cpy
> > [2] https://github.com/KSPP/linux/issues/89
> >
> > Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
> > ---
> > v1: https://lore.kernel.org/all/20230612232301.2572316-1-azeemshaikh38@=
gmail.com/
> > v2: https://lore.kernel.org/all/20230614134552.2108471-1-azeemshaikh38@=
gmail.com/
>
> In the change log (after the "---" line) you should also describe what
> changes you made, more info in the wiki below. In this case it's clear
> as the patch is simple but please keep this in mind for future patches.
>
> No need to resend because of this.
>

Thanks Kalle. I did have the below line in my changelog. For future
patches, do you mean that changelog descriptions need to be more
specific than this? For example - updated title from "x" -> "y"?

> Changes from v1 and v2 - updated patch title.

