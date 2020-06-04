Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C681EE539
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 15:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgFDNXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 09:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728376AbgFDNXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 09:23:08 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC521C08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 06:23:08 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id q14so5125722qtr.9
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 06:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zd56CSP9N2M4FrfN9ySWd7Nzjr+sOLOVU8sX9ZsvxYk=;
        b=Z1SifWi8Glj9s1ZlViEQIoOzrtW4kQqhJPAuBmH8BuAfTlSORzOP5/aBkVIpDCF065
         4tet6nf/xexKbX9HERYTEiH7bvvMa7jEzJZJ+Y9NbTVNdXZMe5cuQGHU5U8XYpc6rEpA
         0M5eGOL/GQzV1R+AsSeBTDbzXk+YExg+XOlZLmxAbhKhBOAjkHQZ06AbVHRZdzvZiU7w
         cHe+L3V8vNXxybekuzSoIvOp1xxWvK8SbdjJVplyLz5vYnbOtUIAIDcZULCyq5qUdBWf
         hegDa8ghfSlITKfZUXou8d2OJHz3pI/kZh5/E9mjrrfnPUc08cS9ulbxQPmbEBYY1pID
         +u9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zd56CSP9N2M4FrfN9ySWd7Nzjr+sOLOVU8sX9ZsvxYk=;
        b=UaLobfX2efqhEiPM+SjKtXeYNleokoViQtBGFuVIGv+gHOcLIu/nJ3P7WZikG+fXnw
         RzR/ev2vn3yPxighpX/ITVRHi9PjId6x5JRZ08KeUdbrs909zY+XWhq/FKQEssv+5lUr
         D8o6CC3vX/16YWrOLgTTvq5l863v7vlFffcLO3JIxOCdKgugn1MmpgMef3VhcE2fA/tG
         ALDxC/+JsnPaE/iN266e8jtwytj2tH4Pbvu7faik8/fNjT0+FlV+GjgwuvlnxCgvKEeO
         lqtauASluuEFljgkC2IpSN/MJ2w/kFmRAigInI8po7F0PXAFq8Isv0XYQf09oSEZaL+q
         I96g==
X-Gm-Message-State: AOAM531fjK3aJ3Jmt4ELeMLj5vPw7T9JggSC4ZPYOA8mUamEHu9bHhZg
        9riAePrpGAZF92KoO+UGbzDevTBA3QI=
X-Google-Smtp-Source: ABdhPJxRZn/pXIUEkZhANETiTogTGf06kqn6Gs1x5NZFGFUPmFe5McyxpBqwN0tWHmbj+GOZ4kP/eQ==
X-Received: by 2002:aed:3fa5:: with SMTP id s34mr4444014qth.343.1591276988114;
        Thu, 04 Jun 2020 06:23:08 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id 126sm4330150qkj.89.2020.06.04.06.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 06:23:07 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.93)
        (envelope-from <jgg@ziepe.ca>)
        id 1jgppq-001CIj-Sr; Thu, 04 Jun 2020 10:23:06 -0300
Date:   Thu, 4 Jun 2020 10:23:06 -0300
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
Message-ID: <20200604132306.GO6578@ziepe.ca>
References: <20200603233203.1695403-1-keescook@chromium.org>
 <20200603233203.1695403-10-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603233203.1695403-10-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 04:32:02PM -0700, Kees Cook wrote:
> Using uninitialized_var() is dangerous as it papers over real bugs[1]
> (or can in the future), and suppresses unrelated compiler warnings
> (e.g. "unused variable"). If the compiler thinks it is uninitialized,
> either simply initialize the variable or make compiler changes.
> 
> I preparation for removing[2] the[3] macro[4], remove all remaining
> needless uses with the following script:
> 
> git grep '\buninitialized_var\b' | cut -d: -f1 | sort -u | \
> 	xargs perl -pi -e \
> 		's/\buninitialized_var\(([^\)]+)\)/\1/g;
> 		 s:\s*/\* (GCC be quiet|to make compiler happy) \*/$::g;'
> 
> drivers/video/fbdev/riva/riva_hw.c was manually tweaked to avoid
> pathological white-space.
> 
> No outstanding warnings were found building allmodconfig with GCC 9.3.0
> for x86_64, i386, arm64, arm, powerpc, powerpc64le, s390x, mips, sparc64,
> alpha, and m68k.

At least in the infiniband part I'm confident that old gcc versions
will print warnings after this patch.

As the warnings are wrong, do we care? Should old gcc maybe just -Wno-
the warning?

Otherwise the IB bits look ok to me

Acked-by: Jason Gunthorpe <jgg@mellanox.com>

Jason
