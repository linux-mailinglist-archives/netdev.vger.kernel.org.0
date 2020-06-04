Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02601EE9E9
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 19:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbgFDR6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 13:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730383AbgFDR6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 13:58:01 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B85C08C5C4
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 10:58:01 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id c12so6961031qkk.13
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 10:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ylFM7xcrRPttXnSFsxxMsniM496bjo9TahOp0BQ4KWQ=;
        b=dp1MW0oLsIVpf8P1GqlJ7ywKbTALgi380UyzwJhLZxxjLZbExXSS3+DNraBRJx+RxA
         2YNRIqPWKCJwUAt2Ionyk91M424aXFCth771TTbwhKuAi/5z09C6/Wr39Wytw6IFYat4
         ROGMU+gTfjKOfKx/KnMfK4lHl61/+H90NG+NU9ft1Ad329Ugd8oNWQRmnDyTDrH84VcG
         NHqJ/pa7Z8WtA7tv5ssR9OBolcmhh/Z0Chu/DqhjQRZD68jbMjVitMLn9/18eeVfDBtl
         W6iFo32dBc0/Xz9TBC1xS9lWFSwriSPTsiMKkjJI2/Fy1v0kJA0h8NiDLZa3m0zxOiRF
         iMLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ylFM7xcrRPttXnSFsxxMsniM496bjo9TahOp0BQ4KWQ=;
        b=ftxptuSKVp9Lmik6V3/z0Lu+ADQQ6GK2oyHmuXtoFUFz7CSFkHD1LJeeSZB5RTodVI
         fKDlBEPfTpbjrkQRQ1tsN2yYbhoRDiK/quR2PeXzdly064MI4vJ/FC0zpm6iWK81wG6I
         T5YFNNH8yMLiZ/jwY8XE6l9Qas2FhhsJW8kvTzNfW8+Pyb+LArQBVWjpLmwLQ75tJgOJ
         3ZQn5BTmlLTMmpgcgVI3hBfHpA9CuvE6VZueE0EPu539SXl09rf2NpEjXWK1ipRYBWN0
         SeWsvk740qPudg2dbc76IYuOd91/c5rayp0mYEWuj7ZuHgybM75VNTH9zDGIcMuEk9Nm
         z+6g==
X-Gm-Message-State: AOAM531Jk0D3A4mTBc3BYo8FqP34WBlt3uDpzxlsJNzoS041U4vpEHxa
        TNszabcqTzHrIFzwoiq1YmoH8IxCgG8=
X-Google-Smtp-Source: ABdhPJzYt2lslt13YiEsonKEZ+jBx4HFt1d65mCYXH6vxqHPQIS81ppOdKBUfUx77lLK8R8poNgzug==
X-Received: by 2002:ae9:ebd2:: with SMTP id b201mr5788109qkg.409.1591293480332;
        Thu, 04 Jun 2020 10:58:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id t43sm5788444qtj.85.2020.06.04.10.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 10:57:59 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.93)
        (envelope-from <jgg@ziepe.ca>)
        id 1jgu7r-001H95-GE; Thu, 04 Jun 2020 14:57:59 -0300
Date:   Thu, 4 Jun 2020 14:57:59 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
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
Subject: Re: [PATCH 09/10] treewide: Remove uninitialized_var() usage
Message-ID: <20200604175759.GQ6578@ziepe.ca>
References: <20200603233203.1695403-1-keescook@chromium.org>
 <20200603233203.1695403-10-keescook@chromium.org>
 <20200604132306.GO6578@ziepe.ca>
 <202006040757.0DFC3F28E@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202006040757.0DFC3F28E@keescook>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 07:59:40AM -0700, Kees Cook wrote:
> On Thu, Jun 04, 2020 at 10:23:06AM -0300, Jason Gunthorpe wrote:
> > On Wed, Jun 03, 2020 at 04:32:02PM -0700, Kees Cook wrote:
> > > Using uninitialized_var() is dangerous as it papers over real bugs[1]
> > > (or can in the future), and suppresses unrelated compiler warnings
> > > (e.g. "unused variable"). If the compiler thinks it is uninitialized,
> > > either simply initialize the variable or make compiler changes.
> > > 
> > > I preparation for removing[2] the[3] macro[4], remove all remaining
> > > needless uses with the following script:
> > > 
> > > git grep '\buninitialized_var\b' | cut -d: -f1 | sort -u | \
> > > 	xargs perl -pi -e \
> > > 		's/\buninitialized_var\(([^\)]+)\)/\1/g;
> > > 		 s:\s*/\* (GCC be quiet|to make compiler happy) \*/$::g;'
> > > 
> > > drivers/video/fbdev/riva/riva_hw.c was manually tweaked to avoid
> > > pathological white-space.
> > > 
> > > No outstanding warnings were found building allmodconfig with GCC 9.3.0
> > > for x86_64, i386, arm64, arm, powerpc, powerpc64le, s390x, mips, sparc64,
> > > alpha, and m68k.
> > 
> > At least in the infiniband part I'm confident that old gcc versions
> > will print warnings after this patch.
> > 
> > As the warnings are wrong, do we care? Should old gcc maybe just -Wno-
> > the warning?
> 
> I *think* a lot of those are from -Wmaybe-uninitialized, but Linus just
> turned that off unconditionally in v5.7:
> 78a5255ffb6a ("Stop the ad-hoc games with -Wno-maybe-initialized")

Yah, that alone is justification enough to do this purge.

Jason
