Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56CA2A48E2
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 16:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgKCPEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 10:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728323AbgKCPDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 10:03:43 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C07C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 07:03:42 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id 2so19345200ljj.13
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 07:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ct04FNhnTBRZCJDDcsgffT/bJ5Sja3lXBGRYTvBKBIA=;
        b=nACLGPiFOuBrhOzcXD3cwtg34kV6q1WGcEV5dxrjZGfH9lsrdcfXhHUSl+QW7Y2idY
         NH1PKMB5j8DPVqBsHkEQImvaocOd65+KA9bfRHfyleUXcjJR0A9N9JWjIvsVfI3aMQrm
         ME/9OZ02YJcMMDNP8QDVHc+EHrfVEOXleUsVkODNkDTN7bpsCbXVH2aNQlzQSyxveudH
         tYVtA1IO9qUrbMUXJJU/ifpEqdaE1cKYCA/LuUAd9trBQwON5Kl+nHwDv64KyAFtzxt6
         I4O32RYbXOe3+vrkPjzzGx0Ei14e1AF6e+ZUEn3WEINFCCBwhfFxy/o4Eafbq6x/9jY7
         H6cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ct04FNhnTBRZCJDDcsgffT/bJ5Sja3lXBGRYTvBKBIA=;
        b=qTjtjuC2u2FCpOTjjU8AGFzvPOSEnv9ceown7PAWkU5/UC5zgMbCOZuX4aZyNTQPry
         W9uBKScWrIIBOh2R7NG+mU5gbi9ilFjIMYThQRp0QvUU0UsWW5h8i1m8AEiUP00tNUzb
         /kc4XZ49L0zjwhdMWqobw9/DRv3XXPtZPKpfi7s+cS9sNM52nShkTV0bthzr3hW+TSUF
         N7iGD3F2m13XjUd0YA8ylo0IQcgHWE+g/FiFheB7krx3jw2HnVv6P4QnQM4IxlE6FJvo
         pPGizCCvkpYwi8NGZlMkgszsE4AHsqEBhPhCuTDpb6BDGCD93iSyWGh2cnBtUR/Jx4L6
         cXNg==
X-Gm-Message-State: AOAM533g1545N9kHoQ3dwtBRlvlwdKKDJ2Em+kW5kSRmhC/drONlHwuT
        Nvv4I0VbEwb9oQeR0P4W+2dWEANAxewnwPtR2uqAL5PFQmyGxw==
X-Google-Smtp-Source: ABdhPJxcPXKq1w3vxqaeFU1MW1ZWziKAfd/5z9CW+P09mVv9dBcLrA+LA1P4/BLsRycNW8rlC+rGTWSZaT5dXQyzhck=
X-Received: by 2002:a2e:9c94:: with SMTP id x20mr8161216lji.33.1604415821147;
 Tue, 03 Nov 2020 07:03:41 -0800 (PST)
MIME-Version: 1.0
References: <20201103023217.27685-1-ajderossi@gmail.com> <20201103120515.GA10759@gondor.apana.org.au>
In-Reply-To: <20201103120515.GA10759@gondor.apana.org.au>
From:   Anthony DeRossi <ajderossi@gmail.com>
Date:   Tue, 3 Nov 2020 07:03:29 -0800
Message-ID: <CAKkLME1ZGj0OQYbe-xhv5c7vyD9WApB7CsGuQmKZLiYRunG6BQ@mail.gmail.com>
Subject: Re: [PATCH ipsec] xfrm: Pass template address family to xfrm_state_look_at
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     netdev@vger.kernel.org, steffen.klassert@secunet.com,
        davem@davemloft.net, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 4:05 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Nov 02, 2020 at 06:32:19PM -0800, Anthony DeRossi wrote:
> > This fixes a regression where valid selectors are incorrectly skipped
> > when xfrm_state_find is called with a non-matching address family (e.g.
> > when using IPv6-in-IPv4 ESP in transport mode).
> >
> > The state's address family is matched against the template's family
> > (encap_family) in xfrm_state_find before checking the selector in
> > xfrm_state_look_at.  The template's family should also be used for
> > selector matching, otherwise valid selectors may be skipped.
> >
> > Fixes: e94ee171349d ("xfrm: Use correct address family in xfrm_state_find")
> > Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
> > ---
> >  net/xfrm/xfrm_state.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Your patch reintroduces the same bug that my patch was trying to
> fix, namely that when you do the comparison on flow you must use
> the original family and not some other value.

My mistake, I misunderstood the original bug.

Anthony
