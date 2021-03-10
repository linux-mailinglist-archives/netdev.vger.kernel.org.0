Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632CF334841
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbhCJTqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbhCJTqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 14:46:00 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F84C061763
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:45:59 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id n9so11132057pgi.7
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BJYD8kGOE3d4gG0u9+B19YeSgl7l3H9zK5f/9NcjXMk=;
        b=bZBjBaNsv0TDWwx/QRnncqUY8oYcDKqxppArNwD41l8lNZi7Bj4tLmVLso31iED2JD
         zVvHI18T1ucr+t+2BQvHyfqKw3p4NqG1OlKdcIyjxtN9jt2Q7dLafHqEAJk52zuzq6wD
         M97srajC/uUzLEpVnpUdpFCnOqxLweO+Hhb9o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BJYD8kGOE3d4gG0u9+B19YeSgl7l3H9zK5f/9NcjXMk=;
        b=MQ8m3zxrCLFVf7F9mN4BaHcPOPrp3M1f4t3X2nCnT9+9qiG4290tweG1UEkep4lOYg
         ciHf3PcXbyR3qeh0b3C6OwtYyxttPklxibu8dTqpAmXj8QK87qB+6vGdhAuokaXpKwT/
         8FNpHrluKrnedjGKJUcZERGr0Pe0ubJNWZi8WQzJ4m6Rh5tbEYiOBbYmOgE5wgfHXVXI
         Plc5NeoE2u3W/4HCy8NIv7jx1SsPOMmcwN3hO/0bEuQ/5Y5hjlOKjFqQPnc2wtjGIjVN
         sZmLGPa4uwDphgx1jJjQR+3tZ77Lo7+z00vBAAK86XzXsj0jBRZ1CoL9k7RdZQxUvs4G
         stww==
X-Gm-Message-State: AOAM533VH3Ew210K6c5QxI0fdyYlC2sSoXhvOTueRsM7PzhA6qvNHKcW
        NPDNtvsDPDeQzSqdOWX1r+5JDw==
X-Google-Smtp-Source: ABdhPJyCAQutIIaU3PRV2tWklYgHuvTXH7vAfzv3Byy9gARLippJaGEpfYPJspq4LoAf4jfIu8Dm9A==
X-Received: by 2002:aa7:96ab:0:b029:1f6:2d3:3c91 with SMTP id g11-20020aa796ab0000b02901f602d33c91mr4600355pfk.10.1615405559514;
        Wed, 10 Mar 2021 11:45:59 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u7sm273628pfh.150.2021.03.10.11.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 11:45:58 -0800 (PST)
Date:   Wed, 10 Mar 2021 11:45:57 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH RESEND][next] rtl8xxxu: Fix fall-through warnings for
 Clang
Message-ID: <202103101141.92165AE@keescook>
References: <20210305094850.GA141221@embeddedor>
 <871rct67n2.fsf@codeaurora.org>
 <202103101107.BE8B6AF2@keescook>
 <2e425bd8-2722-b8a8-3745-4a3f77771906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e425bd8-2722-b8a8-3745-4a3f77771906@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 02:31:57PM -0500, Jes Sorensen wrote:
> On 3/10/21 2:14 PM, Kees Cook wrote:
> > On Fri, Mar 05, 2021 at 03:40:33PM +0200, Kalle Valo wrote:
> >> "Gustavo A. R. Silva" <gustavoars@kernel.org> writes:
> >>
> >>> In preparation to enable -Wimplicit-fallthrough for Clang, fix
> >>> multiple warnings by replacing /* fall through */ comments with
> >>> the new pseudo-keyword macro fallthrough; instead of letting the
> >>> code fall through to the next case.
> >>>
> >>> Notice that Clang doesn't recognize /* fall through */ comments as
> >>> implicit fall-through markings.
> >>>
> >>> Link: https://github.com/KSPP/linux/issues/115
> >>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> >>
> >> It's not cool that you ignore the comments you got in [1], then after a
> >> while mark the patch as "RESEND" and not even include a changelog why it
> >> was resent.
> >>
> >> [1] https://patchwork.kernel.org/project/linux-wireless/patch/d522f387b2d0dde774785c7169c1f25aa529989d.1605896060.git.gustavoars@kernel.org/
> > 
> > Hm, this conversation looks like a miscommunication, mainly? I see
> > Gustavo, as requested by many others[1], replacing the fallthrough
> > comments with the "fallthrough" statement. (This is more than just a
> > "Clang doesn't parse comments" issue.)
> > 
> > This could be a tree-wide patch and not bother you, but Greg KH has
> > generally advised us to send these changes broken out. Anyway, this
> > change still needs to land, so what would be the preferred path? I think
> > Gustavo could just carry it for Linus to merge without bothering you if
> > that'd be preferred?
> 
> I'll respond with the same I did last time, fallthrough is not C and
> it's ugly.

I understand your point of view, but this is not the consensus[1] of
the community. "fallthrough" is a macro, using the GCC fallthrough
attribute, with the expectation that we can move to the C17/C18
"[[fallthrough]]" statement once it is finalized by the C standards
body.

-Kees

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#implicit-switch-case-fall-through

-- 
Kees Cook
