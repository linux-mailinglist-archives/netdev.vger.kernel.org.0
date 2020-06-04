Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBB51EDBB2
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 05:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgFDDdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 23:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbgFDDdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 23:33:50 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CFCC03E96D;
        Wed,  3 Jun 2020 20:33:50 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id h7so3704600otr.3;
        Wed, 03 Jun 2020 20:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MtysUER1l5a/zqtCZtWbYXE2kDcmWMdAVlNOZNySUKQ=;
        b=hAU6iC7SzuADMG5Aos+RZHGnFaCQ8z6d36F+7W8dHx8UydKYHSdkcMT8w6CUcGNzag
         njj37uaHb1XsQkeNNgODWxw+JmIPSJFsiOzWaiRts6JwLN85uBohYPmIU0IknkNXqApb
         3XrfusUHfNL5s13uf3b2DyoPaSWSJxflMEAZNaYtnurxuCdr4w+7UzwHmt4ux1uoSJZY
         VRuPqpiBPltoh715g3N7dXpDuR406aK9rtLam9pcwGJmc9amafFSMtWft6BzB9EYs6D1
         9LU1A/I8cVMacSajcwltKX+v5EE6MYClw1IEQtopq+DleI/1RwWeGJEmC369juox9UBM
         UuWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MtysUER1l5a/zqtCZtWbYXE2kDcmWMdAVlNOZNySUKQ=;
        b=Sc4IajXj4akqsV6dvHiCf8jQkjb6qGNpAcob1BNfmBUKiAav99/6MIDz2q42rr5Xwk
         3sQAHokI/nXFg5FewBOYMxprajRK64irjQem+FHLK1d5j3iebdRqsS+qnbV7HyDQM33I
         3dx9R60nOvYwGdEqGeQhqvNpXqqEI8Wux2fadZsnAolcucZb1r6Gwzuv9qWxWnDTRJpv
         24jqx183DfHn0SA22r6+xnmhOIZZDbaJ2s5GQRckuuDDNs3gXuNesdnPoeiG50JLgv2L
         07nObGXASETj1Wb4DEoPcplTNSJtcSzfvWgXnDYefcOOE0OYT1KX1DQtZIp62Ouam0cR
         /GsQ==
X-Gm-Message-State: AOAM532YfDpFqWzl4HQXXWDYawKYiIYNQ43YsET4etYORY0dKXXRRZqm
        8iDnmyc+SfpiWbnnPqtptjI=
X-Google-Smtp-Source: ABdhPJwauBmbuSyRfNNxnZntj92z7/qBAcGhEUztVFaDTipPYCkr+MSp0RGhU7FWUD4z+qoEhiCdIA==
X-Received: by 2002:a9d:7387:: with SMTP id j7mr2354350otk.157.1591241630021;
        Wed, 03 Jun 2020 20:33:50 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:4111:8b00::3])
        by smtp.gmail.com with ESMTPSA id z13sm969120oom.3.2020.06.03.20.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 20:33:49 -0700 (PDT)
Date:   Wed, 3 Jun 2020 20:33:47 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mm@kvack.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 00/10] Remove uninitialized_var() macro
Message-ID: <20200604033347.GA3962068@ubuntu-n2-xlarge-x86>
References: <20200603233203.1695403-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603233203.1695403-1-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 04:31:53PM -0700, Kees Cook wrote:
> Using uninitialized_var() is dangerous as it papers over real bugs[1]
> (or can in the future), and suppresses unrelated compiler warnings
> (e.g. "unused variable"). If the compiler thinks it is uninitialized,
> either simply initialize the variable or make compiler changes.
> 
> As recommended[2] by[3] Linus[4], remove the macro.
> 
> Most of the 300 uses don't cause any warnings on gcc 9.3.0, so they're in
> a single treewide commit in this series. A few others needed to actually
> get cleaned up, and I broke those out into individual patches.
> 
> -Kees
> 
> [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
> [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
> [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
> [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
> 
> Kees Cook (10):
>   x86/mm/numa: Remove uninitialized_var() usage
>   drbd: Remove uninitialized_var() usage
>   b43: Remove uninitialized_var() usage
>   rtlwifi: rtl8192cu: Remove uninitialized_var() usage
>   ide: Remove uninitialized_var() usage
>   clk: st: Remove uninitialized_var() usage
>   spi: davinci: Remove uninitialized_var() usage
>   checkpatch: Remove awareness of uninitialized_var() macro
>   treewide: Remove uninitialized_var() usage
>   compiler: Remove uninitialized_var() macro

I applied all of these on top of cb8e59cc8720 and ran a variety of
builds with clang for arm32, arm64, mips, powerpc, s390, and x86_64 [1]
and only saw one warning pop up (which was about a variable being
unused, commented on patch 9 about it). No warnings about uninitialized
variables came up; clang's -Wuninitialized was not impacted by
78a5255ffb6a ("Stop the ad-hoc games with -Wno-maybe-initialized") so it
should have caught anything egregious.

[1]: https://github.com/nathanchance/llvm-kernel-testing

For the series, consider it:

Tested-by: Nathan Chancellor <natechancellor@gmail.com> [build]
