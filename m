Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678323D9954
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 01:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbhG1XOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 19:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbhG1XOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 19:14:40 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9501C061765
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 16:14:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ca5so7444250pjb.5
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 16:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cp/1gwQbxKm35mFKd4TC2EFL1W+EtjwqZdL50egUVws=;
        b=g6KzbBrSxn/nD5fbAKhLB3KhfMjP/EBF+i23w0kpmbqop6NS+P75BVA3oYPWAQv5TN
         jVsYj83mHem2R5QZIvfE5d5URqJJQjsLnk9ETh7AN/rE48OqfmjnQNOSXEPIuAu+rr1g
         LBym6tSkzsztfvOHVLJCIdl6Clmjoz1sl02aM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cp/1gwQbxKm35mFKd4TC2EFL1W+EtjwqZdL50egUVws=;
        b=R6xCjyDXom2e9lMDwNDSX22zcoccAI05fv4a/9rlgUix5j/a3FgSPk26FrMpl0dJTS
         kFvO6DxEDY3PwoTekBLiHwQV8MFfKkD7v7j7xfHM/0Xe3vP7RiyVJNpWH6jquzwgzM0Z
         Di+s9saNfu7CaPmwifJwpuexIK9onLhW3pPQDITWj8oWJEr2SlzOGaPQOy+RxPdQg7dz
         Q1zz7EQUAiAnHZh2bCJrglFKomrr4jf2yk+13jWG5dkkuUnjOzqyHSdyMYr+xtRxVKkI
         LaOlhTig98D78XoqvbncDIQMs97mHkjYKiZbhvKK79weauwrdPh7E/VW6cLZuKXU03/Q
         dHUQ==
X-Gm-Message-State: AOAM530hjgkxf8359/GTaQhc9Atf7fDUEFyB6hSLXFUJYf4jDH/u9toS
        KrW0KISZ517cNnZUskHEDJDx5g==
X-Google-Smtp-Source: ABdhPJx1kv+LtzCaHLxEQ+7p9oKRsC6DgKBut532PtzT8ERKet67b0w3z4Vqt6OM2ER7XfKqYAMq8Q==
X-Received: by 2002:a63:5a08:: with SMTP id o8mr1175343pgb.120.1627514077222;
        Wed, 28 Jul 2021 16:14:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 16sm1132146pfu.109.2021.07.28.16.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 16:14:36 -0700 (PDT)
Date:   Wed, 28 Jul 2021 16:14:35 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 02/64] mac80211: Use flex-array for radiotap header bitmap
Message-ID: <202107281602.4D9ED671@keescook>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-3-keescook@chromium.org>
 <20210728073556.GP1931@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728073556.GP1931@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 10:35:56AM +0300, Dan Carpenter wrote:
> On Tue, Jul 27, 2021 at 01:57:53PM -0700, Kees Cook wrote:
> > In preparation for FORTIFY_SOURCE performing compile-time and run-time
> > field bounds checking for memcpy(), memmove(), and memset(), avoid
> > intentionally writing across neighboring fields.
> > 
> > The it_present member of struct ieee80211_radiotap_header is treated as a
> > flexible array (multiple u32s can be conditionally present). In order for
> > memcpy() to reason (or really, not reason) about the size of operations
> > against this struct, use of bytes beyond it_present need to be treated
> > as part of the flexible array. Add a union/struct to contain the new
> > "bitmap" member, for use with trailing presence bitmaps and arguments.
> > 
> > Additionally improve readability in the iterator code which walks
> > through the bitmaps and arguments.
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  include/net/ieee80211_radiotap.h | 24 ++++++++++++++++++++----
> >  net/mac80211/rx.c                |  2 +-
> >  net/wireless/radiotap.c          |  5 ++---
> >  3 files changed, 23 insertions(+), 8 deletions(-)
> > 
> > diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
> > index c0854933e24f..101c1e961032 100644
> > --- a/include/net/ieee80211_radiotap.h
> > +++ b/include/net/ieee80211_radiotap.h
> > @@ -39,10 +39,26 @@ struct ieee80211_radiotap_header {
> >  	 */
> >  	__le16 it_len;
> >  
> > -	/**
> > -	 * @it_present: (first) present word
> > -	 */
> > -	__le32 it_present;
> > +	union {
> > +		/**
> > +		 * @it_present: (first) present word
> > +		 */
> > +		__le32 it_present;
> > +
> > +		struct {
> > +			/* The compiler makes it difficult to overlap
> > +			 * a flex-array with an existing singleton,
> > +			 * so we're forced to add an empty named
> > +			 * variable here.
> > +			 */
> > +			struct { } __unused;
> > +
> > +			/**
> > +			 * @bitmap: all presence bitmaps
> > +			 */
> > +			__le32 bitmap[];
> > +		};
> > +	};
> >  } __packed;
> 
> This patch is so confusing...

Right, unfortunately your patch doesn't work under the strict memcpy().
:(

Here are the constraints I navigated to come to the original patch I
sent:

* I need to directly reference a flexible array for the it_present
  pointer because pos is based on it, and the compiler thinks pos
  walks off the end of the struct:

	In function 'fortify_memcpy_chk',
	    inlined from 'ieee80211_add_rx_radiotap_header' at net/mac80211/rx.c:652:3:
	./include/linux/fortify-string.h:285:4: warning: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()?  [-Wattribute-warning]
	  285 |    __write_overflow_field();
	      |    ^~~~~~~~~~~~~~~~~~~~~~~~

* It's churn/fragile to change the sizeof(), so I can't just do:
	-	__le32 it_present;
	+	__le32 it_bitmap[];

* I want to use a union:
	-	__le32 it_present;
	+	union {
	+		__le32 it_present;
	+		__le32 it_bitmap[];
	+	};
* ... but I can't actually use a union because of compiler constraints
  on flexible array members:
	./include/net/ieee80211_radiotap.h:50:10: error: flexible array member in union
	   50 |   __le32 it_optional[];
	      |          ^~~~~~~~~~~

* So I came to the horrible thing I original sent. :P

If I could escape the __le32 *it_present incrementing, I could use a
simple change:
	 	__le32 it_present;
	+	__le32 it_optional[];


> Btw, after the end of the __le32 data there is a bunch of other le64,
> u8 and le16 data so the struct is not accurate or complete.

Hm, docs seem to indicate that the packet format is multiples of u32?
*shrug*

Hmpf.

-Kees

-- 
Kees Cook
