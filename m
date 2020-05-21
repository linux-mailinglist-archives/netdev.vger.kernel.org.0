Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F731DD2EA
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 18:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgEUQRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 12:17:00 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:57777 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726808AbgEUQQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 12:16:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6CADC580809;
        Thu, 21 May 2020 12:16:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 21 May 2020 12:16:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=kNc6lgzUfio/s/PMCLaEvgBESQW
        hHtxfEasiSLQp52M=; b=BayGMfRr4tcBubrBSX5ud/nARBgGwoVGmRfY+2JFyNo
        j345DqzLPFupy0ELJvZ7SDoN28p8g21TNr4E4zC6m1/firVE7IE3UCwshbUSlghm
        xuO/08Mk1mds0gS3DsddbvQ9aSPwGCXy0L2n4PdMnExYWuMfBV8+gWsE4wssadAH
        pLTIaBRSHwq7NojOYG9rXe+0VShli16pvrn2II0gxw6WKblvUb5BlymtlL3zS5Ai
        TNNmhvKYvD1oAGdQLf28HnzSpyw1OsvULIfZGoXiHEgkGgFZdDui3VjE3TrgNvTa
        TWfm2KaEHo96gOfJETfHRq/9umOyXyv3W6i5nYL7WkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=kNc6lg
        zUfio/s/PMCLaEvgBESQWhHtxfEasiSLQp52M=; b=dQDUlCOqDmxoaQL1giZ8UO
        HbE2KIgb2i2GPLO7aAG7hSOfl9aVWNlFCO3NKDhzlLp/1ACBDSAIpvmXEoCE4quO
        0Pg+otdaB9cawqmILYIZbqwZ1uG8jA3it2Io61O8VjHq2V1bwU4A+JxkfBY8KPMY
        vHmgJ5rS+o29x4TPkA9c5+GRsPKJEi71zQO/hoI0FTUN+sne7oFmMPT4m0wQZ7YC
        u3cPlz8chEOpkV6IDc4erqcWOVpM3dUpWmMsSS1cKN58b4GS1AS8x85JZSeHMFNr
        ZZgUx485TXVWanuFVLuyCCM70lyYgwhBHRrw2qkSVjfMb97Im7s/Wm4c9oJM95ig
        ==
X-ME-Sender: <xms:eKnGXhrazoVLBpbWxVzHz6cew0eiI7KMxNYigdodfT_bRIIoHzPnwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduuddgleefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:eanGXjpV9LTqttp8lkgQj1t5Vnvx11LoqmLetOYBMi5R4BkKBIkUEw>
    <xmx:eanGXuO9cmXcZFeDp41mvJPoS_ZO-wix437YKc1qWsi9PAR_ow02PA>
    <xmx:eanGXs43nHRqJcD4QuxlJa6MUyVpmUEcVP0P4f3mAE6HaTbAoMd0jQ>
    <xmx:eqnGXrJt1dt9wWec63Gdp-iFGm2TPTXWzqTngn9SHC3-Z_SqBSNR4w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 903F33280068;
        Thu, 21 May 2020 12:16:56 -0400 (EDT)
Date:   Thu, 21 May 2020 18:16:23 +0200
From:   Greg KH <greg@kroah.com>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Matthew Wilcox <willy@infradead.org>, adobriyan@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        ebiederm@xmission.com, bernd.edlinger@hotmail.de,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [External] Re: [PATCH] files: Use rcu lock to get the file
 structures for better performance
Message-ID: <20200521161623.GA3502608@kroah.com>
References: <20200521123835.70069-1-songmuchun@bytedance.com>
 <20200521152117.GC28818@bombadil.infradead.org>
 <CAMZfGtVxPevhTy8LMpKUtkk1jX86doiPD0nOTRuKg25+8Vz=ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZfGtVxPevhTy8LMpKUtkk1jX86doiPD0nOTRuKg25+8Vz=ag@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 12:06:46AM +0800, Muchun Song wrote:
> On Thu, May 21, 2020 at 11:21 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Thu, May 21, 2020 at 08:38:35PM +0800, Muchun Song wrote:
> > > There is another safe way to get the file structure without
> > > holding the files->file_lock. That is rcu lock, and this way
> > > has better performance. So use the rcu lock instead of the
> > > files->file_lock.
> >
> > What makes you think this is safe?  Are you actually seeing contention
> > on this spinlock?
> >
> 
> I have read the doc which is in the Documentation/filesystems/files.txt.
> If my understanding is correct, I think it is safe to use rcu lock.

Did you test this and prove that it is safe and "faster"?  If so, you
always have to show that in your changelog.  Please fix it up and
resend.

thanks,

greg k-h
