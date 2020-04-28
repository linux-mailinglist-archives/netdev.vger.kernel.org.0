Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480EF1BC086
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 16:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgD1OEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 10:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbgD1OEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 10:04:39 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B68FC03C1A9;
        Tue, 28 Apr 2020 07:04:39 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f15so207632plr.3;
        Tue, 28 Apr 2020 07:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o3REHNUx7YXxWwyhjTdlhGVucNu+IKUyQxb5soNgEtI=;
        b=VnGaLA11O0rc39D9FomuZJdmxO6pV03ohvZl2kh35cR2LTEWBq7fzRNmL/SI1hjSfg
         zR1KZ2QCzDt4a7G5V6lSS+KQJl/RHO1rqxxfekxvundLKRmuFY5u31bMgUMTnEQO3puL
         ULFk7I/+LgnysegkkxHUQFW9sT3xWnQd2Yheezc6mTEPEjep68AKEUk7k6oNCTlTJdVa
         5HAjnZCYd9qknZWxVNNeGbb33+St1ZKXmJA/Ms0bBOmkvBAa0hJJLgNAAdU6sbPajNXK
         flbEuZ/UJzyuP0H5458fIDGvHmcNDi7tdc016I4H9/FxohNB/a4/FPnzPKAOeF+oSynY
         nl2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o3REHNUx7YXxWwyhjTdlhGVucNu+IKUyQxb5soNgEtI=;
        b=YudJeFPEwIP/OwiQFCaezu7Yv9q+sDhSPfl6YZ/8nSauB87b5+ZTIwUtIG5P4/y6oW
         hbe0VSXveHSC67czEE9pJgwlenrdv6vEUCp5ERyq3ueCkCmB2r0XJl0IkXk6TNroLjf/
         8IDaLI/pt0cwVOUfjzzrFNVBQ+aBKQq5OJLuMHp4ZbRZI68KW7jSO3zj4IvyQ5snbv0a
         Mueb5DlAAw8ALTivQMzwqSIp5nmL5b7DJ+VnV4dq3vsL73h7XjcfzlGqqlYB23MYocMr
         GWuR1UTQ6iL+Jn85T76YNxXlI6g7DfrdH3veyQiBxrL9auA1TJHSxW9Rx1Fpe/3ZEAbJ
         AAYg==
X-Gm-Message-State: AGi0PuZ7/myaEfxgsmfUMF5g2ozKePdsipb3cluq416AoqdYiKxbfzy7
        GXkuMOIK2Cc13QSu4Ks9YYOrCM8bmq/qojk2R0aQsuvB
X-Google-Smtp-Source: APiQypKgGf1tgdCajQ7ZAS2Hwh1bMvd0jXpGaokhaXQphahgWvnFS3p7BFLsG5U5oSg1JiCu+BzOyCMCIWKqXECDkIo=
X-Received: by 2002:a17:90a:364c:: with SMTP id s70mr5240310pjb.143.1588082678744;
 Tue, 28 Apr 2020 07:04:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200425125737.5245-1-zhengdejin5@gmail.com> <CAHp75VceH08X5oWSCXhx8O0Bsx9u=Tm+DVQowG+mC3Vs2=ruVQ@mail.gmail.com>
 <20200428032453.GA32072@nuc8i5> <acdfcb8d-9079-1340-09d5-2c10383f9c26@microchip.com>
 <20200428131159.GA2128@nuc8i5>
In-Reply-To: <20200428131159.GA2128@nuc8i5>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 28 Apr 2020 17:04:32 +0300
Message-ID: <CAHp75VdAuo=UiTa+xJ8qFqbxqHVeL_M6nahhzXKbGHqvovoKMA@mail.gmail.com>
Subject: Re: [PATCH net v1] net: macb: fix an issue about leak related system resources
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, yash.shah@sifive.com,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <Claudiu.Beznea@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 4:12 PM Dejin Zheng <zhengdejin5@gmail.com> wrote:
> On Tue, Apr 28, 2020 at 10:42:56AM +0200, Nicolas Ferre wrote:
> > On 28/04/2020 at 05:24, Dejin Zheng wrote:
> > > On Mon, Apr 27, 2020 at 01:33:41PM +0300, Andy Shevchenko wrote:
> > > > On Sat, Apr 25, 2020 at 3:57 PM Dejin Zheng <zhengdejin5@gmail.com> wrote:
> > > > >
> > > > > A call of the function macb_init() can fail in the function
> > > > > fu540_c000_init. The related system resources were not released
> > > > > then. use devm_ioremap() to replace ioremap() for fix it.
> > > > >
> > > >
> > > > Why not to go further and convert to use devm_platform_ioremap_resource()?
> > > >
> > > devm_platform_ioremap_resource() will call devm_request_mem_region(),
> > > and here did not do it.
> >
> > And what about devm_platform_get_and_ioremap_resource()? This would
> > streamline this whole fu540_c000_init() function.
> >
> Nicolas, the function devm_platform_get_and_ioremap_resource() will also
> call devm_request_mem_region(), after call it, These IO addresses will
> be monopolized by this driver. the devm_ioremap() and ioremap() are not
> do this. if this IO addresses will be shared with the other driver, call
> devm_platform_get_and_ioremap_resource() may be fail.

I guess request region is a right thing to do. If driver is sharing
this IO region with something else, it is a delayed bomb attack and
has to be fixed.




-- 
With Best Regards,
Andy Shevchenko
