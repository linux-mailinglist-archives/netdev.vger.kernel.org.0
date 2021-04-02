Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4C9352EF9
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 20:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbhDBSKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 14:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbhDBSKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 14:10:13 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EB6C061788
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 11:10:12 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id f22-20020a7bc8d60000b029010c024a1407so4661909wml.2
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 11:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0+42j5c9C3lnZRYmM2fmnkvuNubUgtRuZ5/m95qULpE=;
        b=eEowShh4ooiHTH8jvSwGwrRH9tPgimJRq+ApGJEizC+0CwayQuOdZt1jWAIu8EICs8
         o3JiWgE+7WkHNvS04My/6aGm+TBHvuof9htqscfHZ/sD9ERyw5Ga5gtniZe5AruSqwOz
         UJl5npiOVCDAku9JQtDz647qybqSYQs0QF8IxF2Gq3eWAkzX6Rde0IqzB7JsAiyOerQl
         qjt/voWLioqmv08BRGMQaTWAScvnLNCWQXv7+tzpNMyyiZopxexHyVfgtD9oKP4ETonk
         2uea6gXi0d8otkDd7RLz4ItiSHqMYTdfh8JyR8OLzLrqj4iQpEHno+TM3Fbz2COjMPyo
         AiZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0+42j5c9C3lnZRYmM2fmnkvuNubUgtRuZ5/m95qULpE=;
        b=CdUFtKME007y8WOR0Mj0j+CUtuAk/euDJBk0O68zz7lkz9ypcgWmKCbh7bjVkNTU/j
         2riCmZVlqmcBeDp8VS+MWRm2pfZ9xIWZdxqcSM96IkTOu9M41n0fynB6kBAhFBN69pjS
         HiWEsDjYDm1pXoDR/hEa+CusRc8ydEFgEQ+nosanG+Eh/eXERMn+iU91t3aabd1eCM8o
         lr+Qcy2DfvE8SnSyfARyGYBwDLsJqE4XjdEhWu0AJmFpj1e3PgpS+63oAbFOctsj0oq3
         FjZ/B279PYIQRBrWPvk5f+H3XPYgjD6LY4+Ua7sSgTbL1pJ/weq89QN6a1f875nrNnE1
         4e6w==
X-Gm-Message-State: AOAM530QIAKfraQMFq4acvFXVCtZ0RBXaYuMm3FO7lMxEuszFv+MrWWP
        ug0NJh6e70ZrC8yMU9vlC0tWWg==
X-Google-Smtp-Source: ABdhPJxsqKyWReOmuCLtGGGPDS9aUEr3WeEguoYbBOQZlhqtUBGgV1MPgCR0zTNa2wH/NSoZiZiG5w==
X-Received: by 2002:a1c:f715:: with SMTP id v21mr14185277wmh.187.1617387011194;
        Fri, 02 Apr 2021 11:10:11 -0700 (PDT)
Received: from equinox (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.a.1.e.e.d.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:dfde:e1a0::2])
        by smtp.gmail.com with ESMTPSA id j9sm12493297wmi.24.2021.04.02.11.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 11:10:10 -0700 (PDT)
Date:   Fri, 2 Apr 2021 19:10:08 +0100
From:   Phillip Potter <phil@philpotter.co.uk>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: initialize local variables in net/ipv6/mcast.c and
 net/ipv4/igmp.c
Message-ID: <YGdeAK3BwWSnDwRX@equinox>
References: <20210402173617.895-1-phil@philpotter.co.uk>
 <d2334631-4b3a-48e5-5305-7320adc50909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2334631-4b3a-48e5-5305-7320adc50909@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 02, 2021 at 07:49:44PM +0200, Eric Dumazet wrote:
> 
> 
> On 4/2/21 7:36 PM, Phillip Potter wrote:
> > Use memset to initialize two local buffers in net/ipv6/mcast.c,
> > and another in net/ipv4/igmp.c. Fixes a KMSAN found uninit-value
> > bug reported by syzbot at:
> > https://syzkaller.appspot.com/bug?id=0766d38c656abeace60621896d705743aeefed51
> 
> 
> According to this link, the bug no longer triggers.
> 
> Please explain why you think it is still there.
> 

Dear Eric,

It definitely still triggers, tested it on the master branch of
https://github.com/google/kmsan last night. The patch which fixes the
crash on that page is the same patch I've sent in.

Regards,
Phil
