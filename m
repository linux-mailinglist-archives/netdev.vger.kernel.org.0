Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4442546A5F6
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348150AbhLFTvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348036AbhLFTvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:51:46 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A81C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 11:48:17 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id d10so34493986ybe.3
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 11:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zE1ulM3smkgIbeu9Qoz/KLM3/XHY3V8BoM3iaId8D/8=;
        b=IzGe3XygjtaJwWXXdHYQw13HGXmls41r3N5lt0DrUAu25K4u8tKUlkgjD8nRdob16M
         S6vm8cZHaVszoV93SoxibWoVbqfqobGgeHakpx6oBgM1ZgHBLub4eDHeyJghwfJEruqo
         fvylVshifpVRSzRctH2D+FLBBuihbr7KTAGo+dz1n+99X6BK88FrGdLfByAiweiYHE2W
         9k3UCFA3AIn+8yo9z8b4pXxXtQNhnuNMajlujox/SjtB2J2quCWO9/DpAo6uFrTnROt0
         Aw66t1LZzWU/M6aLVkg7daKdNw/z0GnEZShLR4loaLesKMNWCLlzOFrq9kj9io4txtqT
         AxTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zE1ulM3smkgIbeu9Qoz/KLM3/XHY3V8BoM3iaId8D/8=;
        b=AL8Nwt792j2DYly+K60DEqPl7k7CRmCvkfRp+RdCwHrQD1f0Ib32w2V0vlI6yy419/
         6xBPNs450BJWBOnMCh38e5MDGzAHJDyQ/HavawaFJhIfmf0MtvPU1nlZjMHE5XYgh39b
         GU+yYIyxul1d2dNqIW5SxuA/j8W/JubJRTmNiFajNPg/Ab+lBVAIhwVM5Ac7TRzjkYHL
         VTr6CUmEMfFwoBwuH6edAU6hLSzYMxG0Y/pM+D5/mmdWEOntjyxsAoHf9hYwkdWHhrVB
         4/Gfgr+qSfnQRcfPBDiyOrPIgSyN96oFET9maSZGQzJPVopGto6o8P3A9LEx4tKKWkZh
         9aqg==
X-Gm-Message-State: AOAM531A2jz0lCWbmhGjYqX72iB47dT3QhzM+HlZ2fz3be7XpCiR9RkL
        uQ2cXM3KlPlx3TCYmwhTLrU76GcK4DvK3SInU0fQZg==
X-Google-Smtp-Source: ABdhPJwzxjoH1fkRe7+TR6wi8rPcOsV/Tnhjn8meZDGr6SOrBfIjPKtxBYKdR7QI9Af0PXxU7xJ6fj9T/RJjUOyJ6e8=
X-Received: by 2002:a25:760d:: with SMTP id r13mr48243001ybc.296.1638820096434;
 Mon, 06 Dec 2021 11:48:16 -0800 (PST)
MIME-Version: 1.0
References: <20211025203521.13507-1-hmukos@yandex-team.ru> <20211206191111.14376-1-hmukos@yandex-team.ru>
 <20211206191111.14376-3-hmukos@yandex-team.ru>
In-Reply-To: <20211206191111.14376-3-hmukos@yandex-team.ru>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 6 Dec 2021 11:48:05 -0800
Message-ID: <CANn89iKa4=O_ZO2+mHRVRAJ-y4bbD-G1UMpgtjsXFetJfFz5ew@mail.gmail.com>
Subject: Re: [RFC PATCH v3 net-next 2/4] txhash: Add socket option to control
 TX hash rethink behavior
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        mitradir@yandex-team.ru, tom@herbertland.com, zeil@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 6, 2021 at 11:11 AM Akhmat Karakotov <hmukos@yandex-team.ru> wrote:
>
> Add the SO_TXREHASH socket option to control hash rethink behavior per socket.
> When default mode is set, sockets disable rehash at initialization and use
> sysctl option when entering listen state. setsockopt() overrides default
> behavior.
>
> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
