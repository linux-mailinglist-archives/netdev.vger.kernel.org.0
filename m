Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8053347B5
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbhCJTPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbhCJTO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 14:14:59 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48220C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:14:59 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id n17so5407901plc.7
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xGBOjaqoqW2el6rCcu+fky2Vrwvc5fZUNN0jvRZFDBY=;
        b=hAXXb+tmOovSqMUvNZJDl98EM9SVnhRBnkvVzwjL4AQ0uE7/v01OfGii0FOxLVoqq2
         cbC81qnrxMpkm4MMx6+CVsmwkfMNFeSUC5PJ3ARoWa0pPZAginJWwpsYkT4egGZv64Kk
         s7eEg1cVdscSQECYuNv20esXEvopj9DCYS09Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xGBOjaqoqW2el6rCcu+fky2Vrwvc5fZUNN0jvRZFDBY=;
        b=glY4CUnZvU4f4gHQKAg273XhV04VU4/QkiuSEFmcn8+BSmg9+aoxJxNCVXaD1pzwMI
         3hqsEm63Mk3IlvZmYwuTscSsxwM7eF1O3WMFddxxzaJYKuXfkhhHSjEiuV6eP0AQqLg9
         DJDxZiqgOubujKeozK/qluJp5oMXoGFRh2pX1eeLO/mLNNiNxtkS3gl0i7QyIz8Ufctt
         QBJUcnoVj8lbxej6ul19vf1MKCuvVVXGqIaTSyBHMJyKWG2aFUn2PSiiN1ukzGZ68tC9
         VDim//fLmke3ba8THRmrBc3xd7OYpc94ug8Mae8+MYGTkDxaYWGzxigPrIOd/GxYNZr7
         k/AQ==
X-Gm-Message-State: AOAM530CWkCGzSHhwWUusLYTZrZ3rQJtjioAGR8FenyvGgtXUu0gK4RF
        aylr7zaTzecHwuM1Tnlri+EMcA==
X-Google-Smtp-Source: ABdhPJwSmY4D3emq145W7IE+QGbsVU4sEdgWdnmGVa6a0Vakk3f/Swawg8CPtfNPC/29G3yc/RVE7A==
X-Received: by 2002:a17:902:ce88:b029:e6:3a3c:2f65 with SMTP id f8-20020a170902ce88b02900e63a3c2f65mr4322549plg.66.1615403698597;
        Wed, 10 Mar 2021 11:14:58 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t5sm252777pgl.89.2021.03.10.11.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 11:14:57 -0800 (PST)
Date:   Wed, 10 Mar 2021 11:14:56 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH RESEND][next] rtl8xxxu: Fix fall-through warnings for
 Clang
Message-ID: <202103101107.BE8B6AF2@keescook>
References: <20210305094850.GA141221@embeddedor>
 <871rct67n2.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rct67n2.fsf@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 05, 2021 at 03:40:33PM +0200, Kalle Valo wrote:
> "Gustavo A. R. Silva" <gustavoars@kernel.org> writes:
> 
> > In preparation to enable -Wimplicit-fallthrough for Clang, fix
> > multiple warnings by replacing /* fall through */ comments with
> > the new pseudo-keyword macro fallthrough; instead of letting the
> > code fall through to the next case.
> >
> > Notice that Clang doesn't recognize /* fall through */ comments as
> > implicit fall-through markings.
> >
> > Link: https://github.com/KSPP/linux/issues/115
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> It's not cool that you ignore the comments you got in [1], then after a
> while mark the patch as "RESEND" and not even include a changelog why it
> was resent.
> 
> [1] https://patchwork.kernel.org/project/linux-wireless/patch/d522f387b2d0dde774785c7169c1f25aa529989d.1605896060.git.gustavoars@kernel.org/

Hm, this conversation looks like a miscommunication, mainly? I see
Gustavo, as requested by many others[1], replacing the fallthrough
comments with the "fallthrough" statement. (This is more than just a
"Clang doesn't parse comments" issue.)

This could be a tree-wide patch and not bother you, but Greg KH has
generally advised us to send these changes broken out. Anyway, this
change still needs to land, so what would be the preferred path? I think
Gustavo could just carry it for Linus to merge without bothering you if
that'd be preferred?

-Kees

[1] https://git.kernel.org/linus/294f69e662d1570703e9b56e95be37a9fd3afba5

-- 
Kees Cook
