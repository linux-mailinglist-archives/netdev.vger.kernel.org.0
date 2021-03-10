Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB198334944
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhCJU7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 15:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbhCJU7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 15:59:36 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6037C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 12:59:36 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 18so12958658pfo.6
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 12:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x/rIuUerFp6JubXsUurUxMlwHMqoisLVHa0WvFsQbL8=;
        b=B0ZLQVDWjn4y7pLVZujCoeaez/tpfcbcE/ZZV1LX2GR1pZ+CTp1UKP7SK+Oit37+N/
         DFTJl49OL+uiIShO0msVmQQ3lm1KffSqOUfvZijAtqm2gKOalVLaUrbtXc9TZttB7bxL
         Q4Tebn15gm1KjmCfbbWyyreEdgG/UiwREpZlY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x/rIuUerFp6JubXsUurUxMlwHMqoisLVHa0WvFsQbL8=;
        b=JDmDAvCxRNVnBZpncHUnYyE5Se8wGks/Wr+qco+reXQptIVTidlaRlEzoWC27q3kES
         fQ6t/Qpr5kEsuzHd6N4dj4nDRFsf5+dd8eEeswSWZkNVuz07+Ll5XEwzujs5rubMVU5d
         mFbPo/Biy+IUVi88EYuyBU0g49TKqrHH+gZ13IEN7BljipH4dey8JfxHwARtCHl/NM9m
         r0oHXFdv+N+jxzfkKs8VhVN2/zQ02ToobVmY82E6wQNOFKPrs0PyNvziYhXBgVvc1C+A
         qbQ9GOLueW629/XOoNd5B3ctKN98Odljv0NebN4dCrQqUK7iq4+0sC9JVcDIKeiFvFR9
         wMOw==
X-Gm-Message-State: AOAM532m9T0A0yRztFHkb5X4A5lRB1izOiLcRwCTHdyMisxVOLCvfvE4
        5OrG9DKMVX+JGviJcDVHad5GJg==
X-Google-Smtp-Source: ABdhPJyZj3AEQP5Tj4hxNcyzdkEL+doUtUI/QMY/gMP+lqsGJcJ9K8XjGKLaQ03GzBGr7CMyipW4fw==
X-Received: by 2002:a63:2cc4:: with SMTP id s187mr4239672pgs.438.1615409976136;
        Wed, 10 Mar 2021 12:59:36 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id fv9sm268554pjb.23.2021.03.10.12.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 12:59:35 -0800 (PST)
Date:   Wed, 10 Mar 2021 12:59:34 -0800
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
Message-ID: <202103101254.1DBEE1082@keescook>
References: <20210305094850.GA141221@embeddedor>
 <871rct67n2.fsf@codeaurora.org>
 <202103101107.BE8B6AF2@keescook>
 <2e425bd8-2722-b8a8-3745-4a3f77771906@gmail.com>
 <202103101141.92165AE@keescook>
 <90baba5d-53a1-c7b1-495d-5902e9b04a72@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90baba5d-53a1-c7b1-495d-5902e9b04a72@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 02:51:24PM -0500, Jes Sorensen wrote:
> On 3/10/21 2:45 PM, Kees Cook wrote:
> > On Wed, Mar 10, 2021 at 02:31:57PM -0500, Jes Sorensen wrote:
> >> On 3/10/21 2:14 PM, Kees Cook wrote:
> >>> Hm, this conversation looks like a miscommunication, mainly? I see
> >>> Gustavo, as requested by many others[1], replacing the fallthrough
> >>> comments with the "fallthrough" statement. (This is more than just a
> >>> "Clang doesn't parse comments" issue.)
> >>>
> >>> This could be a tree-wide patch and not bother you, but Greg KH has
> >>> generally advised us to send these changes broken out. Anyway, this
> >>> change still needs to land, so what would be the preferred path? I think
> >>> Gustavo could just carry it for Linus to merge without bothering you if
> >>> that'd be preferred?
> >>
> >> I'll respond with the same I did last time, fallthrough is not C and
> >> it's ugly.
> > 
> > I understand your point of view, but this is not the consensus[1] of
> > the community. "fallthrough" is a macro, using the GCC fallthrough
> > attribute, with the expectation that we can move to the C17/C18
> > "[[fallthrough]]" statement once it is finalized by the C standards
> > body.
> 
> I don't know who decided on that, but I still disagree. It's an ugly and
> pointless change that serves little purpose. We shouldn't have allowed
> the ugly /* fall-through */ comments in either, but at least they didn't
> mess with the code. I guess when you give someone an inch, they take a mile.
> 
> Last time this came up, the discussion was that clang refused to fix
> their brokenness and therefore this nonsense was being pushed into the
> kernel. It's still a pointless argument, if clang can't fix it's crap,
> then stop using it.
> 
> As Kalle correctly pointed out, none of the previous comments to this
> were addressed, the patches were just reposted as fact. Not exactly a
> nice way to go about it either.

Do you mean changing the commit log to re-justify these changes? I
guess that could be done, but based on the thread, it didn't seem to
be needed. The change is happening to match the coding style consensus
reached to give the kernel the flexibility to move from a gcc extension
to the final C standards committee results without having to do treewide
commits again (i.e. via the macro).

-- 
Kees Cook
