Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0F829D804
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387486AbgJ1W24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387479AbgJ1W2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:28:54 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FC0C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:28:54 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id p45so714070qtb.5
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NFjdCwH8uZDzpkoTGhXZwrz2A1HCcPwlQB4d2MDLWCc=;
        b=JPlrXvuWRHYFHrAOdr6j0U4mhMRbe7QCTLNhIMPHHznxB6ARAhwp6KeLLEwLcKEtfG
         aVNSrALNywmcZmt9f3hG3Y0+cXmcFMJXNjcIHxBHGWso6/xf2BBydXXH3hZa/1J6uMZL
         tOKZy6ymj7nxvUUmstkrFtXMHhfYB16IlJpUx28W3eecNbeY96lcnS6cbLebQe7bY+gy
         9KNhy8ooJpZbWsWbaKTMfjxoDdalK9uySxvggAwueO9FrAVeRmAt94vZyyojCkNaMjWJ
         dduG8OQMkyaGe6v9IdEwzFVtX8mZisS1kD8+MRdNunV6BDiusPe3sb7ieAotySC2l4JU
         /fzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NFjdCwH8uZDzpkoTGhXZwrz2A1HCcPwlQB4d2MDLWCc=;
        b=RhKl95YXhZv+AWLiG3nwP/v6XJNexF/+0zt/KYQBzLF+KktKGzEKP5aqbEX78m2UQR
         rZEO9v88CMpbB2vOvV1U7eHMV3+mQevgI5auTctOEhL6GflixN5pyHNWcGo8fw+Pm/5V
         0g4nz3hWE/JQaLbPyIKG7m1AjStnu9YX1EOFQ2tTYX/hhCV04vQksZGmKLN+wkHVX10Y
         N1lfKi0oSI13djszZ6HR7aHA9klGXz/I7obcHcYFRdO1YVvBJAJ6scZLWo2JnLsDTArS
         i6C2aFbml6xUP1P6wUwYqwHDf7HpmOnzppFYPxbQEFaXpdyKHi2kv7J7j21GZ2Em1fuN
         5tWg==
X-Gm-Message-State: AOAM533OBSFBZ1DoR8jGHb+aW2XhFnpcBx8lor8uWynhnUuTPJXDFcnp
        K7u3Lc37ZOZer/cbaK3F8wpTEYSkKDhHP7+bAdsghNBbt5Y=
X-Google-Smtp-Source: ABdhPJxZ04b1omZBkMCILhqmW2sFZUp30uCsUBn46yEyZ+UQxbamebp+rV7q9vSBOxWsP9XkFSiV7pZnG73LqFY7bp0=
X-Received: by 2002:a02:95ea:: with SMTP id b97mr700089jai.16.1603913728536;
 Wed, 28 Oct 2020 12:35:28 -0700 (PDT)
MIME-Version: 1.0
References: <1f6cab15bbd15666795061c55563aaf6a386e90e.1603708007.git.gnault@redhat.com>
 <CAM_iQpVBpdJyzfexy8Vnxqa7wH0MhcxkatzQhdOtrskg=dva+A@mail.gmail.com> <20201027213951.GA13892@pc-2.home>
In-Reply-To: <20201027213951.GA13892@pc-2.home>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 28 Oct 2020 12:35:17 -0700
Message-ID: <CAM_iQpWX3xw2uQbVsMNwEBhnKoKGoQgPYpws1Bvpe5M5rWrExQ@mail.gmail.com>
Subject: Re: [PATCH v2 net] net/sched: act_mpls: Add softdep on mpls_gso.ko
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Alexander Ovechkin <ovov@yandex-team.ru>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 2:39 PM Guillaume Nault <gnault@redhat.com> wrote:
>
> On Tue, Oct 27, 2020 at 10:28:29AM -0700, Cong Wang wrote:
> > On Mon, Oct 26, 2020 at 4:23 AM Guillaume Nault <gnault@redhat.com> wrote:
> > >
> > > TCA_MPLS_ACT_PUSH and TCA_MPLS_ACT_MAC_PUSH might be used on gso
> > > packets. Such packets will thus require mpls_gso.ko for segmentation.
> >
> > Any reason not to call request_module() at run time?
>
> So that mpls_gso would be loaded only when initialising the
> TCA_MPLS_ACT_PUSH or TCA_MPLS_ACT_MAC_PUSH modes?

Yes, exactly.

>
> That could be done, but the dependency on mpls_gso wouldn't be visible
> anymore with modinfo. I don't really mind, I just felt that such
> information could be important for the end user.

I think the dependency is determined at run time based on
TCA_MPLS_ACT_*, so it should be reflected at run time, rather than at
compile time.

If loading mpls_gso even when not needed is not a big deal, I am fine
with your patch too.

Thanks.
