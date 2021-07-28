Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A103D85F7
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 04:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbhG1C4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 22:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbhG1C4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 22:56:23 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28957C061757;
        Tue, 27 Jul 2021 19:56:21 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b7so660828wri.8;
        Tue, 27 Jul 2021 19:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zLiCtDrbfM7Zil6a+2UAV/7Kv2nTAUKX/1fK+JXbJlE=;
        b=SdCAh9tmMIHWmyLgeE7UTkk0c82Yqw8PdKWmYEUkX24qABw8bE7sUAIGxPXOxotFWQ
         WRHEv3rdPGdKaCTBUouWNjDAuI5QIqepqq63fHxTcR/GK/L0CLyh+HuBvF0IfgU8g+a8
         36BECF5m6WHJhGYbp+l3+ppWdE4i6owKBedQ5iXH9WBZp+7BgEhydzC+8IHisv+yUKCe
         cCo1XaXcNIkczVyRVTJHkeSP55FgKM0z4d0e6m6dRhkn0aVyLYXTrp5ycfmr8aCsWM/H
         nqlLWHwANg412Xv2mI29P4fXU8xqzPETHIxJWwbwktlZm87ztJdRiIG2MSqb/0Zn4iYh
         iurg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zLiCtDrbfM7Zil6a+2UAV/7Kv2nTAUKX/1fK+JXbJlE=;
        b=C57msJZ1ZunrcddGeQ8fO3TKBvX3mYql0BnFCmQj7GyErILzBE6o/I2VpWSwawTy2m
         DZARgRej8JTnNXVabuPVZRpM7BX67syBeaaYAkIL1YRpE6wR31mg+9UKGy1wRyasLxF9
         2OxzQiRB7rROhWTBQwj9C4jQeP+Ll3jva1fhOjHWdkEPLAQfa7jdu/AQsk/mBtydjpsV
         oDvQUoG0qfIHajYOaFs9zw7QnJimqCCjyiL+gzFvdoBTFVsj/3D7Hut80vBqTVgFljfT
         hQtmoUMySXL5RWiDxWEZKpByPOyMY8z7Kvd5vPc6Fxq2x6P4OhXXnGdxSdCahzFSQXzq
         W4nQ==
X-Gm-Message-State: AOAM530cCOpSn/iy64hCtl43L2+YlzPicV5suQY5cdo2FoJSQHeH/rzQ
        3UWKUEzOt56iGCGedGjYbq28NJ/Gi5gKcARyTic=
X-Google-Smtp-Source: ABdhPJzjKwD+pb4dnF/eE4NjV85CIBBaBgD3h6emxoxO89BpLf7h5UbGNGRHm/pgBqw3odC58ghLWukWzMfceXtyqto=
X-Received: by 2002:adf:f80f:: with SMTP id s15mr13613565wrp.330.1627440979654;
 Tue, 27 Jul 2021 19:56:19 -0700 (PDT)
MIME-Version: 1.0
References: <599e6c1fdcc50f16597380118c9b3b6790241d50.1627439903.git.marcelo.leitner@gmail.com>
In-Reply-To: <599e6c1fdcc50f16597380118c9b3b6790241d50.1627439903.git.marcelo.leitner@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 27 Jul 2021 22:56:10 -0400
Message-ID: <CADvbK_c44QfUkW5ZUcNWKuQaagPqdL5_qi7KGbmp4qgorb3X4g@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix return value check in __sctp_rcv_asconf_lookup
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 10:41 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> As Ben Hutchings noticed, this check should have been inverted: the call
> returns true in case of success.
>
> Reported-by: Ben Hutchings <ben@decadent.org.uk>
> Fixes: 0c5dc070ff3d ("sctp: validate from_addr_param return")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sctp/input.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index eb3c2a34a31c64d5322f326613f4a4a02f8c902e..5ef86fdb11769d9c8a32219c5c7361fc34217b02 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c
> @@ -1203,7 +1203,7 @@ static struct sctp_association *__sctp_rcv_asconf_lookup(
>         if (unlikely(!af))
>                 return NULL;
>
> -       if (af->from_addr_param(&paddr, param, peer_port, 0))
> +       if (!af->from_addr_param(&paddr, param, peer_port, 0))
>                 return NULL;
>
>         return __sctp_lookup_association(net, laddr, &paddr, transportp);
> --
> 2.31.1
>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
