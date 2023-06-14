Return-Path: <netdev+bounces-10770-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C52EA7303B3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:23:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 120B728146E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:23:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F085101EB;
	Wed, 14 Jun 2023 15:23:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743D5DDBF
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:23:19 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE431C3;
	Wed, 14 Jun 2023 08:23:17 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-311099fac92so846073f8f.0;
        Wed, 14 Jun 2023 08:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686756196; x=1689348196;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qhf32x37vTVya41Yn/yYo21KaAVD4j09MI6p+WfuOew=;
        b=aB7MHRSZQBZBZwM8Uy53rKUb+dAJM7WTeXpr8dYqkWfP/g5y/6m5DPRmiR4a+L0TD7
         5EC4FVC2i9suYbmZEEwOHiIHXwinruiPw9supcH4QHObo0zu0nwk+MfKbDtAfFBfx7fj
         vMT3KPIzhI5EhDEi/6vTpyVjIXcCTs/5EWh/M4PxFjA968BpzHTGlPUOx2h7UaeeB5Rw
         Psrh71AulEQ/L8T2nTi8+JWjMvOyiitRQQVOs64MIfjHSeb4cFhifPfiHD9JQO7bXENt
         5qKeqsUGTFSpC/dfAyIrxowYmwIHv5/tHdZJ02RmL3futuwo1sksttwhibK1HewEjqMb
         K/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686756196; x=1689348196;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qhf32x37vTVya41Yn/yYo21KaAVD4j09MI6p+WfuOew=;
        b=KOb/3YC2YsqQpbCNgj2sO7DtI0QPWqCYvD5//P15K9QxrE9qVazX7hNklYPbNWIhCO
         0TL9ovm5L9Q9P6FfOVEVF9jg7cCPX0GwbsXaDjELqUrpQevkOtsQf79jTEPHYJv4UFnh
         BliISEoJv8N+U7o3DnQm838gh9bTz+faE6eGRunzObmllsjwHWLyfqrSYlHf8GqTJj4q
         tfSH72YEJmE/nVeaxoq2y+zZtHCKFStM0sZXt79guw4SD40TXIPMRnpuNhYUaaYtiQkN
         B38zHEIXa9wqpogxsUrI+hkF4VRTZf6PdFSrTT3tqlVxXeiKE+9kQAM/km4J5vVhQhsO
         kzPg==
X-Gm-Message-State: AC+VfDxMtrvBmU28JJ5gjPSTZ03Jitiw4kZqfSg6TBZHw4FBi+gaaG/T
	6GUmsayi/wumlc4v8VLg9GDWxgufNotRWyeY1Jg=
X-Google-Smtp-Source: ACHHUZ4dBnhZLONvjP6mCHhadCKYEhrkmEpVxotqFkfSDi0sq67OmByiUVQzk3EBkY5MgdLJezKpJqr/cStWi6yeCcE=
X-Received: by 2002:a5d:69ce:0:b0:30e:3d9a:9955 with SMTP id
 s14-20020a5d69ce000000b0030e3d9a9955mr9705064wrw.52.1686756195948; Wed, 14
 Jun 2023 08:23:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230614134956.2109252-1-azeemshaikh38@gmail.com>
 <874jnaf7fv.fsf@kernel.org> <CADmuW3WEUgnpGXg=ajpRvwON6mFLQD9cPKnhsg35CcNqwcywxA@mail.gmail.com>
 <875y7qcbxo.fsf@kernel.org>
In-Reply-To: <875y7qcbxo.fsf@kernel.org>
From: Azeem Shaikh <azeemshaikh38@gmail.com>
Date: Wed, 14 Jun 2023 11:23:04 -0400
Message-ID: <CADmuW3U6WU7f0ifZun615xNoZAwvH-R8=2JMqCngp7rpeu5-GQ@mail.gmail.com>
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

On Wed, Jun 14, 2023 at 11:15=E2=80=AFAM Kalle Valo <kvalo@kernel.org> wrot=
e:
>
> Azeem Shaikh <azeemshaikh38@gmail.com> writes:
>
> > On Wed, Jun 14, 2023 at 10:24=E2=80=AFAM Kalle Valo <kvalo@kernel.org> =
wrote:
> >
> >>
> >> Azeem Shaikh <azeemshaikh38@gmail.com> writes:
> >>
> >> > strlcpy() reads the entire source buffer first.
> >> > This read may exceed the destination size limit.
> >> > This is both inefficient and can lead to linear read
> >> > overflows if a source string is not NUL-terminated [1].
> >> > In an effort to remove strlcpy() completely [2], replace
> >> > strlcpy() here with strscpy().
> >> >
> >> > Direct replacement is safe here since WIPHY_ASSIGN is only used by
> >> > TRACE macros and the return values are ignored.
> >> >
> >> > [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#s=
trlcpy
> >> > [2] https://github.com/KSPP/linux/issues/89
> >> >
> >> > Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
> >> > ---
> >> > v1: https://lore.kernel.org/all/20230612232301.2572316-1-azeemshaikh=
38@gmail.com/
> >> > v2: https://lore.kernel.org/all/20230614134552.2108471-1-azeemshaikh=
38@gmail.com/
> >>
> >> In the change log (after the "---" line) you should also describe what
> >> changes you made, more info in the wiki below. In this case it's clear
> >> as the patch is simple but please keep this in mind for future patches=
.
> >>
> >> No need to resend because of this.
> >>
> >
> > Thanks Kalle. I did have the below line in my changelog. For future
> > patches, do you mean that changelog descriptions need to be more
> > specific than this? For example - updated title from "x" -> "y"?
> >
> >> Changes from v1 and v2 - updated patch title.
>
> Ah, I missed that because the format was not what we usually use. I
> recommend something like this:
>
> v3:
>
> * add bar
>
> v2:
>
> * https://
> * fix foo
>
> v1:
>
> * https://
>

Got it, thanks a lot!

