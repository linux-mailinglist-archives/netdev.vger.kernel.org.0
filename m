Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF6728E3ED
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 18:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbgJNQEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 12:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729064AbgJNQEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 12:04:10 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B17C0613D3
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 09:04:09 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id c20so51545pfr.8
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 09:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=spoyQPu6unWe3hyCBCgrr8waF85sTMvIJTyW48sWfoA=;
        b=AiIWMH5jq290wNUTegpNANqevFS7bRDeZeFN2D0NiW7KrKlYzsdQgb4I121bVKlWY3
         VHGwGh//NhkTSSjGm6G2MDrIveUR/92orKfnM8s6Tg3ul+9AHFT4oiKLC+mUC02N1WwP
         AUJKyOZapBd6EkWya/8OdSxCiMyIkhUrGqeWt5/V2vrq+LmEKPy1avcE4VzqCLja79zk
         SWTTMRU4RjVwUuSi9BtZCBM9a7D9/Ogr+3/gxMqig/183oQ4kPNFfICULpTTAenvkx2l
         wrB2bQ9D2NbYQpY9gGgGYPvesHoYrzaDEsRD/mGfwr5JhIzy3hyAYedNyUL9qENzlP0f
         tuog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=spoyQPu6unWe3hyCBCgrr8waF85sTMvIJTyW48sWfoA=;
        b=RhOqwzFtsoYDwuLrHBMpbkyewuZW0jXqgmV3FYafIamDcNDFrwYvSepc/LPY+5sv0D
         /VnWA2xn7WJuRc+dg+Ifth5/tOV1wYilzH2xYGq0qPW9Gj/CrOozGSBV1/eEmOxeu+Vr
         Fhqt8Fphc2Ss/NngiB7qA6h+5R/XSFKYRziBCaatX1kkpS2b/BiyLGXaPfS+di9bv/gU
         fyGncyFuXLPlSi+/VKawnxUuEcWQCzLwIivfUz5qnR5bbUVTKlYjR19n9MKS3jqhSidE
         nkvbRQSiu4h6vB4riWYZwEOOVPEqI0NRA7RH3eTXoRn95aP3cB5slR4yWE3mbQfVQbi0
         2/IA==
X-Gm-Message-State: AOAM5336Z/KYvh9uOLK5mtMcHvvzwuvyQliTRnkRlyQxUHcPYOKI4KLh
        VQtf3ymvWjxwlXcnEOJeTj/UUJ2is/r6B2YSWzTklg==
X-Google-Smtp-Source: ABdhPJxUx1HXe0unvgaYZ0qxNTxPY2Py0eHVcdkb51fZJNRv1i5qRWjjWvsxXeKHUesKKuuBw2dFuZkfqrwjf0gff/U=
X-Received: by 2002:a62:78d5:0:b029:154:ebc0:c92c with SMTP id
 t204-20020a6278d50000b0290154ebc0c92cmr64329pfc.24.1602691449016; Wed, 14 Oct
 2020 09:04:09 -0700 (PDT)
MIME-Version: 1.0
References: <20201009170202.103512-1-a.nogikh@gmail.com> <20201009170202.103512-2-a.nogikh@gmail.com>
In-Reply-To: <20201009170202.103512-2-a.nogikh@gmail.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Wed, 14 Oct 2020 18:03:58 +0200
Message-ID: <CAAeHK+z6NLcwviYdGWZ4seoAr9-5Xa5ryonkU1wHOy0uAVpUKw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] kernel: make kcov_common_handle consider the
 current context
To:     Aleksandr Nogikh <a.nogikh@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Aleksandr Nogikh <nogikh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 7:02 PM Aleksandr Nogikh <a.nogikh@gmail.com> wrote:
>
> From: Aleksandr Nogikh <nogikh@google.com>
>
> kcov_common_handle is a method that is used to obtain a "default" KCOV
> remote handle of the current process. The handle can later be passed
> to kcov_remote_start in order to collect coverage for the processing
> that is initiated by one process, but done in another. For details see
> Documentation/dev-tools/kcov.rst and comments in kernel/kcov.c.
>
> Presently, if kcov_common_handle is called in a hard IRQ context, it
> will return a handle for the interrupted process. This may lead to
> unreliable and incorrect coverage collection.

FWIW it's the same for soft IRQ context.

>
> Adjust the behavior of kcov_common_handle in the following way. If it
> is called in a task context, return the common handle for the
> currently running task. Otherwise, return 0. It will make the returned
> value more reliable and also will make it possible to use
> kcov_remote_handle in routines that can be called from any context.
>
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> ---
> v2:
> * Added this patch to the series.
> ---
>  kernel/kcov.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/kernel/kcov.c b/kernel/kcov.c
> index 6b8368be89c8..80bfe71bbe13 100644
> --- a/kernel/kcov.c
> +++ b/kernel/kcov.c
> @@ -1023,6 +1023,8 @@ EXPORT_SYMBOL(kcov_remote_stop);
>  /* See the comment before kcov_remote_start() for usage details. */
>  u64 kcov_common_handle(void)
>  {
> +       if (!in_task())
> +               return 0;
>         return current->kcov_handle;
>  }
>  EXPORT_SYMBOL(kcov_common_handle);
> --
> 2.28.0.1011.ga647a8990f-goog
>

Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
