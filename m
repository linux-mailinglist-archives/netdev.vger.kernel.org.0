Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312ED606BBD
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 00:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJTWz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 18:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiJTWz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 18:55:57 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A263219A20A
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 15:55:44 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id p6-20020a17090a748600b002103d1ef63aso1104484pjk.1
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 15:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cj0CH83gG502oU3XoyUvan58JOVquo6gEhkWxu6syvA=;
        b=DWI323io4MlnG9mZWvKL+Z1nreAWi5G6EUWK13mpJBRC2tO0Rh6oIclRw0yRfd5W/d
         s0PgKUYoK+SKSPh8NlzkJfzEmld7Ju4i8ywLL6vbtgwQuRtfzrYEDQ9+e8tC2GQWo6Kl
         N3P8Fem1xr8ioafs3NmDTkO+sOiye3JbUNchNvfc6Fbl1dx/4JVIGBZ24m56TZ0Qw1wu
         /saBPbn0esXYAYDYRaXfWMd6seYtkRuSlsLtBK/TVujVubMjyTtqxBdvDM556GfpHskl
         oinW+/MuugN1eiccRrBDnQo1irD6ysfVFV3HxTIdNlgY0B6ZXQxYoSf28dojgTMXYxti
         EHlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cj0CH83gG502oU3XoyUvan58JOVquo6gEhkWxu6syvA=;
        b=0aHbIvqCAkxbE1aPFqP8VXtZMZGmZWb59oXRHqcNmr4Q/+g2ibBGFzVPZItqQnL0c3
         qq3XN2pQa2mEBYOC6k2saGEDdnBjrd/W+6/md/uRAgecvVWBsrCdQsHi4qEz+kKGFoJm
         mld+58fzO6UlTcfWZffqDl1MuKPS655MDs18/kIuHx6Hhagn51FkCAElhdIGAXfSZ6Az
         hW00I3RYFJz8bljfXxQxexF/poSAqKmHHJEb4I7omhKFxN+xC1UrdRxJp6mpA7QH33LS
         UPKeNlkYQs024Lgp70M3iA81/lhBCHFICCVIfvS+GDYU+bkxm0hPTH2kajosoAaVcoFI
         613g==
X-Gm-Message-State: ACrzQf3tjqdd1XzIny8QIdI9oamZRIcqdPNUplFQd/G+OJo90LuD/ZaC
        pclD5v3rKNpDpq/E3EihC75KpQ==
X-Google-Smtp-Source: AMsMyM7xu8+xvqWY3jJ1ibBaZl6XXcj+/fwoWgCdqgZIvkseoRwZ0PNDPWe94+Iy8lLHNvFVmRhCjw==
X-Received: by 2002:a17:90b:4c86:b0:20d:402d:6155 with SMTP id my6-20020a17090b4c8600b0020d402d6155mr52693449pjb.229.1666306543213;
        Thu, 20 Oct 2022 15:55:43 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i6-20020a628706000000b00553b37c7732sm13771966pfe.105.2022.10.20.15.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 15:55:42 -0700 (PDT)
Date:   Thu, 20 Oct 2022 22:55:39 +0000
From:   Carlos Llamas <cmllamas@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, liuwei.a@oppo.com
Subject: Re: [PATCH net] inet: fully convert sk->sk_rx_dst to RCU rules
Message-ID: <Y1HR61VKKNFRv/X9@google.com>
References: <20211220143330.680945-1-eric.dumazet@gmail.com>
 <Y1G4HufHb+sEIUD6@google.com>
 <CANn89iJsZsmw9+RryFzMhEBqdqUMD=LRkJZ85k1ksdAzypfefg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJsZsmw9+RryFzMhEBqdqUMD=LRkJZ85k1ksdAzypfefg@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 02:53:06PM -0700, Eric Dumazet wrote:
> On Thu, Oct 20, 2022 at 2:05 PM Carlos Llamas <cmllamas@google.com> wrote:
> >
> > On Mon, Dec 20, 2021 at 06:33:30AM -0800, Eric Dumazet wrote:
> 
> >
> > Eric, this patch was picked for v5.15 stable and I wonder whether this
> > needs to be backported to older branches too. The Fixes commit quoted
> > here seems to go back all the way to v3.5. Would you know?
> 
> I guess nobody cared to address some merge conflicts on older kernel versions.
> 
> If you want, you could handle the backport, this patch can help some
> rare race windows
> on preemptable kernels.

Sounds good, I'll have a look at backporting this patch.
