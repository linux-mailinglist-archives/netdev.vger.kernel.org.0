Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43624353551
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 21:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbhDCTlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 15:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbhDCTlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 15:41:22 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440E7C061788
        for <netdev@vger.kernel.org>; Sat,  3 Apr 2021 12:41:19 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id b2-20020a7bc2420000b029010be1081172so3804386wmj.1
        for <netdev@vger.kernel.org>; Sat, 03 Apr 2021 12:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f97he6tXvo+XX/wWWviq15fo7VP+I5fFMXX56WqbxvU=;
        b=MoKiqDTZqEWYAyTCbWBjXOUOCfKBe46sKVDFR174ko8QTxl+7Dy++qSioxLFZqg0uX
         1jGARxkXnt1SVTv7haGPXGrXPcTjHwfNernIrKNf80pXPvG6OutjN0jRCKK2Deb/UGC3
         A8kymcJqLLzIeqA6h/K5vNoU2XkZYN76X3k9O0YRU2MOEeHhACDEunn4f+ii2wq+4BIv
         iBWNQPaqUrSKJoBHJII7FpjFDXFWe78hzIMKwRLB3NGIK0z3gO+86lBfFWARhcPsbqHu
         ZvRub0vwEq2wxfaAug3E3h+ww825uqBRFvnarRezvPI4hAJSLT/Qxedf4UHQyDvfydSB
         eJnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f97he6tXvo+XX/wWWviq15fo7VP+I5fFMXX56WqbxvU=;
        b=eHTscH0RAP++3uEpsXgInZU8/ge8xGbhZSqgqTSFk1oGuoDd+xfudrDwb8qv5MFXYt
         ONdFEU3ur72ekuYTj9LQW7BciZVDM09mLJsAh4O7zf576co9sVD/JO4uo8GmHnPsQJU6
         7/0MjSUEkDOf0Oej2M8ZOBS1DmvLXNVwSQ5E5oZTKE92kGaq/2OCGdq+Wy/3Ol4HyDzH
         DFodGaLvHfESuJ8I3YxVLPb6MU9RhgfN8nZVlyunho2FqjH+aexTzYtvtxOfBhREpSjX
         /ltImxyiK6FZCWdPvYxqbwVtwPRy+T10aCI0rmjaXagfSrIig6NKrQjDFzfobKJCaFSH
         8qMg==
X-Gm-Message-State: AOAM531/TfHDVcjY5WTnEA8vzNpZqtyJro9L+f5xBJm+1oNXXXdZiQ31
        3hvhkeVmJBP1zGOuSFZH/xa0pQ==
X-Google-Smtp-Source: ABdhPJyHrXiKJVoriHtqQAuWoRDRjBejdDXmle+qxxJNpzki6ugEAGyxs3GP7mTFiHH9tV3nMCco5g==
X-Received: by 2002:a1c:6a03:: with SMTP id f3mr18026464wmc.179.1617478877854;
        Sat, 03 Apr 2021 12:41:17 -0700 (PDT)
Received: from equinox (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.a.1.e.e.d.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:dfde:e1a0::2])
        by smtp.gmail.com with ESMTPSA id h6sm8030214wrr.21.2021.04.03.12.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 12:41:17 -0700 (PDT)
Date:   Sat, 3 Apr 2021 20:41:15 +0100
From:   Phillip Potter <phil@philpotter.co.uk>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: initialize local variables in net/ipv6/mcast.c and
 net/ipv4/igmp.c
Message-ID: <YGjE29JgJFQG/C97@equinox>
References: <20210402173617.895-1-phil@philpotter.co.uk>
 <d2334631-4b3a-48e5-5305-7320adc50909@gmail.com>
 <YGdeAK3BwWSnDwRX@equinox>
 <37f4c845-e63b-87b8-29ec-b28d895326cd@gmail.com>
 <05c984b6-140d-112e-9151-4aea6e8e5a80@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05c984b6-140d-112e-9151-4aea6e8e5a80@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 02, 2021 at 11:12:36PM +0200, Eric Dumazet wrote:
> 
> 
> On 4/2/21 10:53 PM, Eric Dumazet wrote:
> > 
> > 
> > On 4/2/21 8:10 PM, Phillip Potter wrote:
> >> On Fri, Apr 02, 2021 at 07:49:44PM +0200, Eric Dumazet wrote:
> >>>
> >>>
> >>> On 4/2/21 7:36 PM, Phillip Potter wrote:
> >>>> Use memset to initialize two local buffers in net/ipv6/mcast.c,
> >>>> and another in net/ipv4/igmp.c. Fixes a KMSAN found uninit-value
> >>>> bug reported by syzbot at:
> >>>> https://syzkaller.appspot.com/bug?id=0766d38c656abeace60621896d705743aeefed51
> >>>
> >>>
> >>> According to this link, the bug no longer triggers.
> >>>
> >>> Please explain why you think it is still there.
> >>>
> >>
> >> Dear Eric,
> >>
> >> It definitely still triggers, tested it on the master branch of
> >> https://github.com/google/kmsan last night. The patch which fixes the
> >> crash on that page is the same patch I've sent in.
> > 
> > Please send the full report (stack trace)
> 
> I think your patch just silences the real problem.
> 
> The issue at hand is that TUNSETLINK changes dev->type without making
> any change to dev->addr_len
> 
> This is the real issue.
> 
> If you care about this, please fix tun driver.
> 

Dear Eric,

Thank you for pointing me in the right direction. I will do as you
suggest.

Regards,
Phil
