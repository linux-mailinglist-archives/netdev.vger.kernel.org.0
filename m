Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECED3FB959
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 17:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbhH3PzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 11:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbhH3PzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 11:55:21 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44094C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 08:54:27 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id f6so8315849vsr.3
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 08:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PLyzrosfruM0d3KzH3zxIF3Pq+pL+VvuHAHtqGEtJdo=;
        b=q2KiJf8waItajssAtqs+5YVbe7stGXxe0aeKFNHjsAur2hDY1eIsCpOA0vorOTWsVK
         pDUP2ObWx/USNPGpZVsSKuRpOxmDcToljchOjQCaimzLI11gQf7NwhoLkRBkYyKSk4MC
         QbIxZYo8qzKsTUWl+ggcnQadQpJuCni+YMMvtHprTO6vd7sKCyLbsI7RVfCgsEK0kjJ7
         ka0EVs1fBsYMERSd0Em1ns1Ia8VhsV/eQ1DI4PT2enzOkapq1mrrP7Vsb+HKbdVoCfxf
         Nwgt8ERtptL5MOxqWfOG+lnKunHkkgYmTB06suE4omZck+/ex5q9U+S8R6lUZC47VGq6
         xToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PLyzrosfruM0d3KzH3zxIF3Pq+pL+VvuHAHtqGEtJdo=;
        b=oeC0ATAIqmxlWVdwx89ysR4EuQryzUSQTqyVAVIzwIAZwxavgF/ooD0Em4uLcVFZh8
         7NKoQuVCw6gL9cmS+HqRtCIIeD7/QnJK3fsji8pczvLFKImJnntuapCnYW72XMXOjA8y
         3jPkzG04UxDa8QdGzH5zC1aXbOp+3D4VwDAsVVtRSCgnqoZMNUAoTMmXKqCzMNva4yoZ
         6yPwM2e+JFQdfSVL6xw6l+nSnXvo2qTVb/8JFTkw9Oxf/ZDC6YfZW/iXxw7nTc1Kp1vX
         CIMvntgDj59gJJVs33Mii3L/ZDj7LlUYb3xaLXIZtYq8AsWqQuHfDnFd/Z/Csp74NlXR
         IuhQ==
X-Gm-Message-State: AOAM533blGzxgZVasCRUuKo6+PkzvH/pdnYdbXOA27m94KS6TYnDQ1I6
        8YwfoA8HbWWVDrMiJ/HRruBv5yrOSeuBgvpqYa3nzA==
X-Google-Smtp-Source: ABdhPJwLYFPw/pu4EI3S8ArkDUBAIKLIxtBHnf51JM4LjHuBUaOOQSUKnpXJpBkmzg+KMRYwNwVL8fy84v/d23+tzBU=
X-Received: by 2002:a67:df85:: with SMTP id x5mr15256912vsk.17.1630338866295;
 Mon, 30 Aug 2021 08:54:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210829221615.2057201-1-eric.dumazet@gmail.com>
 <20210829221615.2057201-2-eric.dumazet@gmail.com> <7c8bdee5-66cf-996e-eaea-db3aee6f0d5f@gmail.com>
In-Reply-To: <7c8bdee5-66cf-996e-eaea-db3aee6f0d5f@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 30 Aug 2021 08:54:15 -0700
Message-ID: <CAEA6p_CEqRPd8mUmEfVRxEm75iBcR=5Lo4H9v4v+zTMdN5rhQw@mail.gmail.com>
Subject: Re: [PATCH net 1/2] ipv6: make exception cache less predictible
To:     David Ahern <dsahern@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        Keyu Man <kman001@ucr.edu>, David Ahern <dsahern@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 29, 2021 at 5:39 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 8/29/21 3:16 PM, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Even after commit 4785305c05b2 ("ipv6: use siphash in rt6_exception_hash()"),
> > an attacker can still use brute force to learn some secrets from a victim
> > linux host.
> >
> > One way to defeat these attacks is to make the max depth of the hash
> > table bucket a random value.
> >
> > Before this patch, each bucket of the hash table used to store exceptions
> > could contain 6 items under attack.
> >
> > After the patch, each bucket would contains a random number of items,
> > between 6 and 10. The attacker can no longer infer secrets.
> >
> > This is slightly increasing memory size used by the hash table,
> > we do not expect this to be a problem.
> >
> > Following patch is dealing with the same issue in IPv4.
> >
> > Fixes: 35732d01fe31 ("ipv6: introduce a hash table to store dst cache")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: Keyu Man <kman001@ucr.edu>
> > Cc: Wei Wang <weiwan@google.com>
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  net/ipv6/route.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
>
> Reviewed-by: David Ahern <dsahern@kernel.org>
>
Reviewed-by: Wei Wang <weiwan@google.com>

Thanks Eric!
