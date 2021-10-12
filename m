Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677B142A43B
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 14:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236322AbhJLMV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 08:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236196AbhJLMVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 08:21:22 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D86EC061570;
        Tue, 12 Oct 2021 05:19:21 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r10so66435053wra.12;
        Tue, 12 Oct 2021 05:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=03i5veaw+3wEhcIVcLi8yrVX1/lz5YJgt5bBwuuFTcY=;
        b=AKIZWvlnCP1Vl+qMMA1/pdRLrjBJT+LymaZz+D0eNAKccfy9KX08xq5M13QUhdhUGN
         3Uwh1rG1TKQ0FOH9IS2Ai+IZXCiu+UkFf9364rFDTBevSaYpPmRatqTb4IBoHeYI4RJE
         yXVXnKNbtJc7ppQeFaskD/5HSVjP9dsNq9wJe02g30OQXMOh2N/cDdVPTHXsbLE65OSl
         lRLX78LAnMA1Vq3W2tQYgdb5qbzlGuKe88eKnXDaRy6lAvuqFmIKo3cwqtvJOBWFZwWX
         Qir8tDRhXuMTzgXjO2T3KL4YkZTeuhjqtwL1rVhlHh19l7gtbWRTmJLE2TsULecJXLRA
         niFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=03i5veaw+3wEhcIVcLi8yrVX1/lz5YJgt5bBwuuFTcY=;
        b=1xgZPSxalwuh2IdECeUfBg6eKL+2+4K1cec6k0lHLjbYxQbal4M9YAsz0eQhxzj+N7
         E5UTeH5ZNQogsszmZoS1EAwoKgx/iCrTQnE+bZSbOGJh8BsZ/sFVwVNqKrXQYwof6BxH
         /Io72D+LltYKnkFAZtu+hwz6lN763YGwM6KFfiUfcwH29lJ9wEWjnjurMVtQTzx5uo1V
         zuEKb1t9dUouWvihAMsSLVCaihoDBYRJrDXFeE58p3Axkf6L9rJjl5vCJUpbqK4Wu/Wk
         U+HKLHqEZcJv5bPmG2kRnYoZNBD4RNCDn0i9laC2d9D5yuNEVoCKJjvrb4OxEXpRaBiU
         j6pA==
X-Gm-Message-State: AOAM532EnhFG4rUw/2Iq0Buk80sgKiwHNZu15ZRB4Kno4BioBLvmTuI1
        sT0qTytKRolB6evoKO9jxaDXnUKLcIsB2JuCWjE=
X-Google-Smtp-Source: ABdhPJyVi1rE9sDedLQwt/ftkfJjClojCOo4wMCVbGzQjCiBYHAC+JLedDwCLwSii0ypJ+X6RTpub0kRbFrT8j6lwcI=
X-Received: by 2002:a1c:4b15:: with SMTP id y21mr5129300wma.4.1634041159681;
 Tue, 12 Oct 2021 05:19:19 -0700 (PDT)
MIME-Version: 1.0
References: <346934f2ad88d64589fa9a942aed844443cf7110.1634028240.git.lucien.xin@gmail.com>
 <20211012100204.GB2942@breakpoint.cc> <YWVjtzBnhsB83H7R@salvia>
In-Reply-To: <YWVjtzBnhsB83H7R@salvia>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 12 Oct 2021 20:19:08 +0800
Message-ID: <CADvbK_fnw0jQNSijB5a4SRxgYPx0jpz83etT__gC8N=cFdQ2cQ@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: ip6t_rt: fix rt0_hdr parsing in rt_mt6
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 6:30 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Tue, Oct 12, 2021 at 12:02:04PM +0200, Florian Westphal wrote:
> > Xin Long <lucien.xin@gmail.com> wrote:
> > > In rt_mt6(), when it's a nonlinear skb, the 1st skb_header_pointer()
> > > only copies sizeof(struct ipv6_rt_hdr) to _route that rh points to.
> > > The access by ((const struct rt0_hdr *)rh)->reserved will overflow
> > > the buffer. So this access should be moved below the 2nd call to
> > > skb_header_pointer().
> > >
> > > Besides, after the 2nd skb_header_pointer(), its return value should
> > > also be checked, othersize, *rp may cause null-pointer-ref.
> >
> > Patch looks good but I think you can just axe these pr_debug statements
> > instead of moving them.
> >
> > Before pr_debug conversion these statments were #if-0 out, I don't think
> > they'll be missed if they are removed.
>
> Agreed.
Posted v2. Thanks.
