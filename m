Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379863B54AC
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 20:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhF0SfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 14:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbhF0SfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 14:35:23 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCCFC061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 11:32:58 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so11303351pjs.2
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 11:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3N3UJcn59TufBpNZ56xt6oHLC+gYtiohMn2l5DkuJ7g=;
        b=Sf6QIvPTjSQxo5u9fJsF3wbqYEyJQTJA6MNwUl8MeywmhV7/PgKeK/9+VF1f+SRS9L
         cyVafEwnJ6s1Nl88rvleFidCUNn//ldsFH+6YfOm3YKT506nmUxRpvBlE0Jus7zoeou2
         hIh+4hMKkD4hBfmbUXyAXJIQUfTdW2Yu2+T8vY74LsEbr3yIqNPCgCakEpVn3AMt72fi
         8w7V9CV9JFzilf2hUqjTECZjMua8MWw0Etr71I1utjG/zBgN0+AlzARPo0qdalboxZot
         CLkMGKyUhzH9Ld5W49rM0sshRY3q4AcfD+lOweDEOFkBrQl9AOhs3BWBWksKPNCzzeGY
         WiCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3N3UJcn59TufBpNZ56xt6oHLC+gYtiohMn2l5DkuJ7g=;
        b=SwSUxxnYbkjYnURkdKmDioMSDG8imkH228gTAXZehxVhNVDfzJV56s1tLRdRrdCqBS
         wO6wow0qkd66p/D14PpgM91aHh0zu7qW1Cc+E57lPFWWSPNEkY5/f1sIpYbkJU4VhlvQ
         2Vyll/Mv+s98hu+nDsQmhD2DUlJrIREkfWuvyjztRe5g/B9LFXRYGr9NIcSwdk4oEG/G
         ncCRV9wBoXyoAtRKLy2aXuD02dtklsfj1g41sKvwDGttwkQNdEwGgE/NoGqermuwBU9Q
         aMyw61rjSjZSvz/c/7f1QuqIu7m2D9d1l2vqlq6nnXmT9IXiDiYex3SgxK0E/N5WxW5x
         /l4g==
X-Gm-Message-State: AOAM533UaaRfP8lnCaCKubFtL6+402cdgWc0Q9DcGPGULrXHkVuDNCNo
        WH6aN22kFnbX0aHbHiVCv7zF0vVmsGBJthUYDfI=
X-Google-Smtp-Source: ABdhPJyoAC2pj46MKJjgU+CvZ0MVO6RNu5RWltWxD1jXmhAdN9htsGp8mx4w/dCRF0KGHpq/jHruvWUGPj69uHjQQRE=
X-Received: by 2002:a17:902:694b:b029:118:b8b1:1e23 with SMTP id
 k11-20020a170902694bb0290118b8b11e23mr18948543plt.31.1624818777830; Sun, 27
 Jun 2021 11:32:57 -0700 (PDT)
MIME-Version: 1.0
References: <0124A7CD-1C46-4BC2-A18C-9B03DD57B8B8@itu.dk>
In-Reply-To: <0124A7CD-1C46-4BC2-A18C-9B03DD57B8B8@itu.dk>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 27 Jun 2021 11:32:47 -0700
Message-ID: <CAM_iQpWC0arAJsY2Y+SKzYwaiyGDwQ61mopriEK9Q9EsPnwgTw@mail.gmail.com>
Subject: Re: [PATCH] net: sched: Add support for packet bursting.
To:     Niclas Hedam <nhed@itu.dk>
Cc:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 5:03 AM Niclas Hedam <nhed@itu.dk> wrote:
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
> index 79a699f106b1..826d1dee6601 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -594,6 +594,7 @@ enum {
>         TCA_NETEM_DELAY_DIST,
>         TCA_NETEM_REORDER,
>         TCA_NETEM_CORRUPT,
> +       TCA_NETEM_BURSTING,
>         TCA_NETEM_LOSS,
>         TCA_NETEM_RATE,
>         TCA_NETEM_ECN,

You can't add a new enum in the middle, as it is UAPI.

Thanks.
