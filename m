Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F4839F122
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhFHInq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhFHInp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:43:45 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6DFC061574
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 01:41:53 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso1797934pjb.5
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 01:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LJLi9BhF+LiFNRjDPUmJyFD+uMa3FNUXRrTewLNrVvg=;
        b=YMoMPkMzOdknJkSCxwrfnQEJUlQOFnyOHCQzuM95FAikMw17xO5CkI7DnGQWvpePhy
         XxDgvGdX8FRI8djNwwzQ7KOcx/RQs2VQaAxqfSKaN06V//NtAWan16kdgU5OE6SqBb8C
         ihVX3vQ68wzkcx4Dml+4iD8QA7nAs0oO9Rpk0RB7zVDtVyaK4tKXgBBwafA0pGr5o25/
         koZyZgkjp+yVFENOFMmC7Lz28RqOs3Fl5fPmha5nU3A6O33gkD1ktW4MnalPgjMu+YJr
         sqXHrhWoKrDLoqcLzYhnOb+tpkUheWGMjBakQkpCngjbqQQalohxSyXFWx5yC+yAP+/Y
         B0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LJLi9BhF+LiFNRjDPUmJyFD+uMa3FNUXRrTewLNrVvg=;
        b=M7FaXTgwZjWzkHhJr5sekxdl3CRgY+Nzxp+tS4bRv0SxjDADbMmPuCkf0rOgydnhTd
         zS5I80fvGVqg43+iToaD77Bu7h84or84KpUut9P8IJSSb+chJ4ooBI0l42BYXTriIn/w
         cn1vfOk39Ddcjwv44haFnpXfifHwT+bDH3bo7TGrvnW7JRV0LEUwqia2RV2LCm5yk7PY
         1FJd6A3E8B7SC15563VAWHrFRLTubXSjB9UPZb/M+U80wDUDBSIc/GnxFHy6lDGXWowB
         p3ZPAuzzTpz9LNAV6hU41gcQZZnuXn5KUxD5n7pW+xtRmSMjqsbp2Ir88iiGQcbJqEKl
         E+ig==
X-Gm-Message-State: AOAM532rdTODWWFpBo9mUZrMEtrKIr38+iUdLhJpbYuUlLxZ3Wc3wJI/
        4a5oZfCuReYpxasauEByiUO6kMQ4OHS8ZjB/HlEjMeYyWCwcN1xi
X-Google-Smtp-Source: ABdhPJxfMNAjLkZ52tEdGM+okCpTDfBp5W9UFvvIcwnSj3aSgX/KMogzksKup7OrSz/9H1ZbgCA4RY2iwMR+km9+6dQ=
X-Received: by 2002:a17:90a:d590:: with SMTP id v16mr24579215pju.205.1623141713015;
 Tue, 08 Jun 2021 01:41:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210608040241.10658-1-ryazanov.s.a@gmail.com> <20210608040241.10658-9-ryazanov.s.a@gmail.com>
In-Reply-To: <20210608040241.10658-9-ryazanov.s.a@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 8 Jun 2021 10:51:03 +0200
Message-ID: <CAMZdPi-24bQUKWQK7fnuOdD85dSqys9-twUggbrbZUAGvOnRKA@mail.gmail.com>
Subject: Re: [PATCH 08/10] net: wwan: core: implement TIOCINQ ioctl
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Jun 2021 at 06:02, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> It is quite common for a userpace program to fetch the buffered amount
> of data in the rx queue to avoid the read block. Implement the TIOCINQ
> ioctl to make the migration to the WWAN port usage smooth.
>
> Despite the fact that the read call will return no more data than the
> size of a first skb in the queue, TIOCINQ returns the entire amount of
> buffered data (sum of all queued skbs). This is done to prevent the
> breaking of programs that optimize reading, avoiding it if the buffered
> amount of data is too small.
>
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
