Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 404334313A
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 22:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390571AbfFLU4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 16:56:33 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46960 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390503AbfFLU4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 16:56:33 -0400
Received: by mail-qt1-f194.google.com with SMTP id h21so20037476qtn.13
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 13:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=hgV/CiEIlJWIILSVW8jGibEn5u8thvNr5+oTjP3VnLs=;
        b=rmjuNjK0kAMRgu4iGfKElp1iP70egkIDMeoEaW616528yzFiFG3EdzeeUe7kjDvXJA
         X0bs7jyf9WAQoVf5xFcdstrX3iEguGZylSrOztxFP4VxIxhDYRLd9SP7lAkeofgoOSCk
         h1n3AR5yvNLBJgXCi0QVBQPvj3zkuUqym0vbzuZQhV7WUNZkXj5MWXMVVENx6WbhntQj
         l7Wq+E/SWQoG+FwKOH4Zl3OQUk3Xn8IgzCCn7xCUbgubL9diM6UThxhEn7M06D97c2VG
         d4xRMTBwtu1O0J7tn4hjn4ot+n1BG7cr0AQqpoKEeBneZOvnM2xygoE+bleodUYfQwpP
         Z2dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=hgV/CiEIlJWIILSVW8jGibEn5u8thvNr5+oTjP3VnLs=;
        b=UBrOIWowWqvu6ZuYnP68lUr44dfReTGW+uzs4soupOZEL9+AzVc6vau7taB0Kq+LOF
         QkOZOJrKAoczF821lH/7RoSo+mYCeMTYjLlLYRnegevPeHyDCjlfgC9Ng8Xi3JG3QeDZ
         s6mF7Jfwh2vua07Q58edkVFf0g7+pRLs+P1FrMSJVEiZy26ysKSVQLnpwmarCm52Ghzg
         gvUPggeS8y2WwfCnAK4QGCE1PVUE2tXVNgkOEUDnWFEhKUdd42ONZmU4RN+rBBDhJYFL
         T44K4FIbuEZGB4PS+xxoGeVYa17W1DOhp06qRB1VySrV8Pdo1OqWYOsiHyznEh8tRiBa
         1tQA==
X-Gm-Message-State: APjAAAUxdHd/kOVSzQLAXNlivYkhwSr5Iv8ZDpV21lCui6WiLvn1c2kN
        HFs7Vj1MvkgXh9u3iNo9nxaISQ==
X-Google-Smtp-Source: APXvYqxn/XEHvdG1GlmscEu1eACbjgspPlvlp9HH6r9+L1p+oqOBIhAX4GodoEY9Y4dilUDJedQL4g==
X-Received: by 2002:a0c:b036:: with SMTP id k51mr437829qvc.103.1560372991976;
        Wed, 12 Jun 2019 13:56:31 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t67sm385964qkf.34.2019.06.12.13.56.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 13:56:31 -0700 (PDT)
Date:   Wed, 12 Jun 2019 13:56:27 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        peterz@infradead.org
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH] locking/static_key: always define
 static_branch_deferred_inc
Message-ID: <20190612135627.5eac995d@cakuba.netronome.com>
In-Reply-To: <CAF=yD-JAZfEG5JoNEQn60gnucJB1gsrFeT38DieG12NQb9DFnQ@mail.gmail.com>
References: <20190612194409.197461-1-willemdebruijn.kernel@gmail.com>
        <20190612125911.509d79f2@cakuba.netronome.com>
        <CAF=yD-JAZfEG5JoNEQn60gnucJB1gsrFeT38DieG12NQb9DFnQ@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jun 2019 16:25:16 -0400, Willem de Bruijn wrote:
> On Wed, Jun 12, 2019 at 3:59 PM Jakub Kicinski
> <jakub.kicinski@netronome.com> wrote:
> >
> > On Wed, 12 Jun 2019 15:44:09 -0400, Willem de Bruijn wrote:  
> > > From: Willem de Bruijn <willemb@google.com>
> > >
> > > This interface is currently only defined if CONFIG_JUMP_LABEL. Make it
> > > available also when jump labels are disabled.
> > >
> > > Fixes: ad282a8117d50 ("locking/static_key: Add support for deferred static branches")
> > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > >
> > > ---
> > >
> > > The original patch went into 5.2-rc1, but this interface is not yet
> > > used, so this could target either 5.2 or 5.3.  
> >
> > Can we drop the Fixes tag?  It's an ugly omission but not a bug fix.
> >
> > Are you planning to switch clean_acked_data_enable() to the helper once
> > merged?  
> 
> Definitely, can do.
> 
> Perhaps it's easiest to send both as a single patch set through net-next, then?

I'd think so too, perhaps we can get a blessing from Peter for that :)
