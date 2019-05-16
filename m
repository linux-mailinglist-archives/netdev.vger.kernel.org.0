Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7E81FE4F
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 06:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfEPESY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 00:18:24 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:38346 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfEPESX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 00:18:23 -0400
Received: by mail-it1-f195.google.com with SMTP id i63so3950138ita.3
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 21:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yNoKTbkr+ksN4KMRcqedLTsbcbbeubcCmoYJRntLqQ4=;
        b=fpLwuXpEbreCIWrIbGgVwh6oiF8h7+U7ht7aPCdHU5DgS268NUPyof3LOxBVjR/BnH
         I1cLZzZz3JRIdojFg1J0d5767jIxTMYWh6uOGXXU5P8tC/dR7TdJOdqckH8UBM242n4c
         065/maFZXUXuNpJKXSE+dJjYmrfLF89HCrZs60Kq4/J8aAmDnx7LexseWbTBnwLBKT0q
         DEDxY/V0uJxoZX8sP1dTKJNBhEn17r2nXRum0hATvpykXBRNwCMOzdaY/JHGljRuWiG8
         FDE9ALOozdMWFe1zco2xziYXG+UiV3szx3Nczjkj1H68pU6KwTNnFQQzdPB7Vuf4mvxJ
         Lz9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yNoKTbkr+ksN4KMRcqedLTsbcbbeubcCmoYJRntLqQ4=;
        b=WXzHNqDrHq+4lAnB60ZfnKHdP2vAOAU+NVN185uq7qhdxpXgSutsSf8UgCKgFr16qG
         cgeQWAUvr5ISZ41I0r0xvo7P1r6aTtA8Yu5+I1+mTs+Nk74yQm3ipfl08FvafyzTrOKV
         CznTGveqbzBjH5tLAyHEwR9NEh4xORbnchDVwBRGuS5nnrzZUgQ4o8PerzMs21kIqYsd
         t3Fsk6rCsDrkDrnXUV09CLfqizunokyxmIsNyTqkUHuEkmIEoqYBlPAEvPx6jfBggrAH
         5cJUcjE4GZf1gSmb9M1zEBk3N7caA7Mwi+/kOHKrqrqjmpciOe49htj56rvGm/n7UvXU
         k/ww==
X-Gm-Message-State: APjAAAWOayDPqI6RTrYTjKQ8DEk13a4doFeC5dhfkSZFnKBBQvtbCccM
        7atSV2iZfVGwV6DuIvvHpgyoY4OAfG4ntGYadNa6dW+p
X-Google-Smtp-Source: APXvYqyBT7t+724zzHXMMnbmGdeSKC9A2BUsAnpeWYqtvaR3BjU5bqJsrwjvx0Bf1Q8Pvb6vQ0ffDghdt9TYO7RBbYQ=
X-Received: by 2002:a24:eb09:: with SMTP id h9mr12095909itj.14.1557980302713;
 Wed, 15 May 2019 21:18:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190515004610.102519-1-tracywwnj@gmail.com> <20190515215052.vqku4gohestbkldj@kafai-mbp>
 <CAEA6p_AA2Xy==jrEWcWuRN2xk3Wz-MqdPC32HtRP90vPH_KmhQ@mail.gmail.com> <6ab0f808-bcd9-0f6f-9d88-c1272493b6d9@gmail.com>
In-Reply-To: <6ab0f808-bcd9-0f6f-9d88-c1272493b6d9@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 15 May 2019 21:18:09 -0700
Message-ID: <CAEA6p_DGhD-nONPcjom+H3LPUVQEgHi826-We9LadrKis9NQ7A@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: fix src addr routing with the exception table
To:     David Ahern <dsahern@gmail.com>
Cc:     Martin Lau <kafai@fb.com>, Wei Wang <tracywwnj@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 5:07 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 5/15/19 6:03 PM, Wei Wang wrote:
> > Thanks Martin.
> > Changing __rt6_find_exception_xxx() might not be easy cause other
> > callers of this function does not really need to back off and use
> > another saddr.
> > And the validation of the result is a bit different for different callers.
> > What about add a new helper for the above 2 cases and just call that
> > from both places?
>
> Since this needs to be backported to stable releases, I would say
> simplest patch for that is best.
>
> I have changes queued for this area once net-next opens; I can look at
> consolidating as part of that.

Thanks David... In that case, I would prefer to stick with the current version.
Martin, what do you think?
