Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0882269E11
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 07:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgIOFvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 01:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgIOFvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 01:51:20 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A76C06174A;
        Mon, 14 Sep 2020 22:51:20 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f18so1274033pfa.10;
        Mon, 14 Sep 2020 22:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TMg87JRx8eEsPjAPTRFHhCmta+gxJvIx+r8SoSGKiIE=;
        b=hhxHBDPq0a1er3XaVMT8g3XaDu7cF8LCJoHGBV5OERrgfgKPcLi7dV1BawwOCNfepa
         kptrqst9Q20XL4kPjWsK0GNcZu7Bhjr47XhynxZQf5O4Wn93CapKQe37DI3xVKBaYs/5
         Ngl/pAfBdLAPW1Euf7AUwHxUiA8nOVq3EDPbMeOH/VqCaOOWDbBgVrhP7VSLVIlZDUYS
         XWh/YyoRJTmWBuF36A2j1lGKsoZ7EOh7o4bbNNHaUiavDy4NUHqBKkdz4rHwurSLQMtZ
         Jm2BwG8pjiuNKyyqq7ZpkH9GtiJ5/kDSnlobvanoGFdndULtSEqpYRYdPviSjwLX567j
         OLCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TMg87JRx8eEsPjAPTRFHhCmta+gxJvIx+r8SoSGKiIE=;
        b=f3ulXdvEYS9Y8gjqjGD3tvz+jBrTlAPxdyGwl+KCkDA7qau9PWE3B1vBWtMQn8Mw4m
         lTXm9Ho65Vzhr0j+2TwYDFIawTa5HksO8Y6X8BV15z0lYOlisZ6r0W9rjnmjOiwhfEZX
         D3UowAyNdQE+BcW5KJPeDhme9z4WTK0NPuyvhzjIZhL2gIeggEvYGJUUkcdITLIXfm7f
         k/p9aBWI0yNuHy1jV/ySHSdawO79N9EvmqFjDMQ6EDaHSEP6zKkDhFprdZS//56PNIc0
         wHatve9Rzy1TUpEcrfOGUWO+o7ZSS2QjK0ykY1zMlUmV7zYUriMNefTa8+3XRScXUPDo
         6b9A==
X-Gm-Message-State: AOAM531NPPYPFnPpPkjPbpvvOJgo8q+vIi1qHDksRCyS7MJmcHVbOwYp
        G2PByTW02oKe1n5PwhOdz0U=
X-Google-Smtp-Source: ABdhPJylSfFDoid3x9u/XfZidYVeaQfza7R0zyjgFVOKz9yfY7lZZutMsFMCZaPk2NlfC86Lt8zLqQ==
X-Received: by 2002:aa7:81d5:0:b029:142:2501:39fa with SMTP id c21-20020aa781d50000b0290142250139famr418631pfn.73.1600149079587;
        Mon, 14 Sep 2020 22:51:19 -0700 (PDT)
Received: from Thinkpad ([45.118.167.197])
        by smtp.gmail.com with ESMTPSA id ms16sm10847414pjb.55.2020.09.14.22.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 22:51:18 -0700 (PDT)
Date:   Tue, 15 Sep 2020 11:21:10 +0530
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f7204dcf3df4bb4ce42c@syzkaller.appspotmail.com,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Necip Fazil Yildiran <necip@google.com>
Subject: Re: [PATCH] idr: remove WARN_ON_ONCE() when trying to check id
Message-ID: <20200915055110.GB7980@Thinkpad>
References: <20200914071724.202365-1-anmol.karan123@gmail.com>
 <20200914110803.GL6583@casper.infradead.org>
 <20200914184755.GB213347@Thinkpad>
 <20200914192655.GW6583@casper.infradead.org>
 <20200915051331.GA7980@Thinkpad>
 <20200915052642.GO899@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915052642.GO899@sol.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello sir,

> > I hope the patch will get merged soon.
> 
> No need to "hope"; you could split up Matthew's patch yourself, and test and
> send the resulting patches.  From the above thread, it looks like the networking
> developers want one patch to fix the improper use of GFP_ATOMIC (which is the
> bug reported by syzbot), and a separate patch to convert qrtr to use the XArray.
>

Sure sir I will look into it.

> 
> > also, i have tried a patch for this bug
> > 
> > Link: https://syzkaller.appspot.com/bug?extid=3b14b2ed9b3d06dcaa07
> > 
> > can you please guide me little how should i proceede with it, and 
> > also syzbot tested it.  
> 
> Looks like something timer-related.  You'll need to investigate more, write and
> test a fix, and send it to the appropriate kernel mailing lists and developers
> (which will probably be different from the ones receiving this current thread).
> 

My bad sir, will send it to the appropriate list.

Thanks  
Anmol
