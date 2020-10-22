Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4851295998
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 09:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507437AbgJVHtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 03:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507357AbgJVHtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 03:49:01 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E31BC0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 00:49:00 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id b15so570524iod.13
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 00:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L7aXNxKtMvJuK4rnlW8fZi/bTz4HUnu1byV946OlXzM=;
        b=O4ncpQgNUtbAs/ross0tO7FFrbPhHKFnGv9ToJXUqD28OWLUAnK3pOSqa0WLYTIs/G
         e+vmmmr35ndoS0+5Bz9R+cSrO6SpbCnF0bWJP9Ri9TG7ngpr1wG+NeZDfTu3sEhI1iH1
         B4ultSmgZTJGC8cX8zlrTlxa45ApGliFTeX19P/F0w3+3NOuLbnc4mcFj8eCNTtpoaA/
         Nkg7ms3Sg2YmYY7b1x5q4Rjqzrhx+wfrQxLwSKylY4zwb8rqzYvgQhZssN229VAoayU0
         xW4cf9f1/IfObsy3ui20MZnWZI9BHjaNzYsCm8u2tj7B/1zNom+IXoz5sCLv9Tj9Z4iy
         DfDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L7aXNxKtMvJuK4rnlW8fZi/bTz4HUnu1byV946OlXzM=;
        b=G6/ajMuGupdo+LwHCiRH2s7jcZHcChzwxGp4h78cgBca0x44TKr5fCdEgVFcEz+zJI
         tpj749wk0xi7kT1iPub1oCapd9/XgOn086YgtnCS88tqjMfMkXzA0DuaUi2lselvNFoY
         8sE8/+YQGZAsQv+ESdUg/Wn0xYfOKfTT0LXg4CTY1IQUNcg/wRgz2us1rcmnEF7xNlTx
         R9lz1ptGIHpKXZjEqdGm0B9t627UKbHRW8eeTFUsEkxor/IfrH0BrWP94IG22X+YTxoy
         cRYuub9b3Ob8RU+x1OdWkIIs5T0RNLcXjkQOWpSWrYLPx/gkM0HAlP5FYexw686XMkPt
         HYCA==
X-Gm-Message-State: AOAM530txELrE5FlATInuCZ92P48rC9bmm1HT+hYFiPden+P60shqZsI
        NF6rzgG4MtHIEBOQWscqYYN/U8BNtWHzegnFyMVhLw==
X-Google-Smtp-Source: ABdhPJz0X1TPvQK3HptvMDy28ipL4cV1+9gXjFxE8+kIpJvEA7T/YA4tzuoi45sKUo3g5SXASLmBPTQVKCxjYrxw8Kk=
X-Received: by 2002:a02:7350:: with SMTP id a16mr781738jae.53.1603352939678;
 Thu, 22 Oct 2020 00:48:59 -0700 (PDT)
MIME-Version: 1.0
References: <20201022064146.79873-1-keli@akamai.com>
In-Reply-To: <20201022064146.79873-1-keli@akamai.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 22 Oct 2020 09:48:48 +0200
Message-ID: <CANn89iJxBMph1EZX9mYOjHsex-6thhTqSLpXA-1RDGv-QBhxaw@mail.gmail.com>
Subject: Re: [PATCH net v2] net: Properly typecast int values to set sk_max_pacing_rate
To:     Ke Li <keli@akamai.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kli@udel.edu,
        Ji Li <jli@akamai.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 8:42 AM Ke Li <keli@akamai.com> wrote:
>
> In setsockopt(SO_MAX_PACING_RATE) on 64bit systems, sk_max_pacing_rate,
> after extended from 'u32' to 'unsigned long', takes unintentionally
> hiked value whenever assigned from an 'int' value with MSB=1, due to
> binary sign extension in promoting s32 to u64, e.g. 0x80000000 becomes
> 0xFFFFFFFF80000000.
>
> Thus inflated sk_max_pacing_rate causes subsequent getsockopt to return
> ~0U unexpectedly. It may also result in increased pacing rate.
>
> Fix by explicitly casting the 'int' value to 'unsigned int' before
> assigning it to sk_max_pacing_rate, for zero extension to happen.
>
> Fixes: 76a9ebe811fb ("net: extend sk_pacing_rate to unsigned long")
> Signed-off-by: Ji Li <jli@akamai.com>
> Signed-off-by: Ke Li <keli@akamai.com>
> Cc: Eric Dumazet <edumazet@google.com>
> ---
> v2: wrap the line in net/core/filter.c to less than 80 chars.

SGTM (the other version was also fine, the 80 chars rule has been
relaxed/changed to 100 recently)

Reviewed-by: Eric Dumazet <edumazet@google.com>
