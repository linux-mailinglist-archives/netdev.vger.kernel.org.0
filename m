Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230852AFB3B
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 23:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgKKWS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 17:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgKKWS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 17:18:57 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A5AC0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 14:18:56 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id z21so5369339lfe.12
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 14:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BuYTBaQsDTQREtL4p6gROBHOxCBVgRCf00slCPTEeRU=;
        b=rsz0ogKTmybTrre9jLsQmf2FlLFWZiIlq0p3j8M+PUuOiBFh9jGu1P2NO5Z93CdHAN
         HIrP9YeuxxsCqE4c5QL+rmpoBUdCFYT2+FxDYnwcXnntscD48Dj1YPEnZnpyJyVqNLcD
         dDEKY1i4v00/cIeM2fqJVVJ9g8XnKk7r659ZOFvSi2sUbOQVefzdkdwWzq62XWpyxD36
         8am1yi6wuh7RGrmQBXGoyqbkbBDBZYZWKyqt8QFcXEODeZRZIdVtxePcQAXwLfBzceef
         jody6ioWIgSesI3OIPfZg+Mu5wJe9auDEgJc3GjRcHg56QFA4uKyRJPqK+pzbe2Oj8nL
         AhMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BuYTBaQsDTQREtL4p6gROBHOxCBVgRCf00slCPTEeRU=;
        b=UcNxsj7HOPd5GdrBkydMHonuvNZHW8nQS1htQ8xaw+vlpgDPktX8qgFOedkeHdaBmY
         nnFeOUp85uNZq1fAJB6EqfksCka/zdFBLMdZ6TIYLCwrtgGh9NkSZAszga8OH7l5urs9
         /9mfFFBLIaiPbtFpTmHKoXyE0+qx3ahk5TUB8UX/rYuPwOXqQkPoAzFIWd6up3z2JXQ/
         b8wnJY4k74YzYfZlSuSra5H0o1Sw8800ueeC0aqmHzammUQF6j6MIWvoslRD1DmxJlk6
         lA1j6AEP55IgG8D0Fv7wdapiw0ol1DkkXfTVWtaopK/qTpdSCImyLZIma/Zb6xZ7YgVQ
         XaBA==
X-Gm-Message-State: AOAM533yBmAoQ6gce4r/fbUdRshYUuI0LgMbyuzjLnhRnhFgf65yQU4t
        kHXr+7DJHMtSlcBqpoqry8xdp7ePZpc/5twA008=
X-Google-Smtp-Source: ABdhPJwXqWuT0zhlA1XmwmBLIkBO73DGoUsB/ZaZDr9yBEKGb8Hc5i3+SIWG5pAecws2B91l4/V8GqH+7WA7scZzz/k=
X-Received: by 2002:ac2:50c1:: with SMTP id h1mr9861659lfm.333.1605133134966;
 Wed, 11 Nov 2020 14:18:54 -0800 (PST)
MIME-Version: 1.0
References: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
 <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
In-Reply-To: <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 11 Nov 2020 19:18:43 -0300
Message-ID: <CAOMZO5CYVDmCh-qxeKw0eOW6docQYxhZ5WA6ruxjcP+aYR6=LA@mail.gmail.com>
Subject: Re: net: fec: rx descriptor ring out of order
To:     Kegl Rohit <keglrohit@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andy Duan <fugang.duan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 11:27 AM Kegl Rohit <keglrohit@gmail.com> wrote:
>
> Hello!
>
> We are using a imx6q platform.
> The fec interface is used to receive a continuous stream of custom /
> raw ethernet packets. The packet size is fixed ~132 bytes and they get
> sent every 250=C2=B5s.
>
> While testing I observed spontaneous packet delays from time to time.
> After digging down deeper I think that the fec peripheral does not
> update the rx descriptor status correctly.

What is the kernel version that you are using?
