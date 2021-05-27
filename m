Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE1639387A
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 23:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235486AbhE0WBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 18:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhE0WBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 18:01:06 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C004AC061574;
        Thu, 27 May 2021 14:59:21 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id s6so2515745edu.10;
        Thu, 27 May 2021 14:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=3wP1Dp7OoJKSDcXYoU4kPPWEijQ9ArnJlrL3hh6yVWo=;
        b=A1XrXZRMPxkB43Kj3tv3Dya26LjoC3TwFx2ZyPMZwBhcKsEWfvpVs+TYc33i6Et8wF
         QRVA/jXlly43Q2BVzuKO2GHZiN6fEdKD9yanvtNOZQSjWzZ+c9cUQer9Mb2Xm8hJnMKH
         7i9k9Q6RvXcbj5hVWJiLaO6Zsm/jKWM2kI1qUBzho6NRduw4TUoDY6AroKHekd8TccNe
         8R3IwmJVd5729AzcfcekzcuzvhHmD3tc8/Jtwa+ffjU4mP19dtx9kteqeg69p3DFStox
         mcpxtNl5F7ZFNKNBADawOc+8nDLDc36KqylPYHiNoBX251SOwgXNaoobYEyvN4Qhipkw
         kXTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3wP1Dp7OoJKSDcXYoU4kPPWEijQ9ArnJlrL3hh6yVWo=;
        b=RFho5kOE0eeaLTFf2sPzZanFeXJxXjTqNeOWMfWSAw/8CsnO/nQtB018y/UczoHxhC
         j1ZhaqpATTmqCPgBbu/8VfRvXtU645k9kFWI2jIJxAvhjUAqW4apyQCX8e1kp+en5bc4
         rM4MTdlPbQ5hqZRsX91QbpUna/PXmzpisuXw+PnP1sS3lkocXnbv0SeVePbFTaOlAk55
         rBK/PQzELN6i5Qs6JN1eqTzrIYc2FPJfjufjw1C8IvMX3hba5Ku6u1NTkmTIomAxIGDJ
         W3pF0sLtleB1g+NMbFdziqfUepZxS26PW1RQRwpvRl0aB84wnpyggQJlphZllNWfjkL6
         3Ueg==
X-Gm-Message-State: AOAM530mnrEG8bclkZ3YI+Hh5fJxAjsd0RtavDeiyMurXa5VbQFzbpbN
        HYF/0mRbCLFy25XnCFul4nQ=
X-Google-Smtp-Source: ABdhPJzf6gBT8wETHH3TfnUNOXHuTVaIOLsnLgVUGTPJDKwJs8v79uYOfFAIvg/OlZUdhPaTitaLbg==
X-Received: by 2002:aa7:cb8d:: with SMTP id r13mr6570920edt.184.1622152760402;
        Thu, 27 May 2021 14:59:20 -0700 (PDT)
Received: from mail ([2a02:a03f:b7fe:f700:3419:e8b9:6c41:d43c])
        by smtp.gmail.com with ESMTPSA id gl20sm1533847ejb.5.2021.05.27.14.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 14:59:19 -0700 (PDT)
Date:   Thu, 27 May 2021 23:59:18 +0200
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Richard Fitzgerald <rf@opensource.cirrus.com>, pmladek@suse.com,
        rostedt@goodmis.org, sergey.senozhatsky@gmail.com,
        andriy.shevchenko@linux.intel.com, w@1wt.eu, lkml@sdf.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.cirrus.com
Subject: Re: [PATCH 1/2] lib: test_scanf: Fix incorrect use of type_min()
 with unsigned types
Message-ID: <20210527215918.tgdxpnic6m4kuvwl@mail>
References: <20210524155941.16376-1-rf@opensource.cirrus.com>
 <20210524155941.16376-2-rf@opensource.cirrus.com>
 <a3396d45-4720-ee30-6493-b19f90c74e54@rasmusvillemoes.dk>
 <0650840d-1b7d-3bc0-c04f-3a22ddc1ced1@opensource.cirrus.com>
 <ce344f9a-b184-3bc5-2873-b741047d292d@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ce344f9a-b184-3bc5-2873-b741047d292d@rasmusvillemoes.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 12:30:02PM +0200, Rasmus Villemoes wrote:
> On 25/05/2021 12.10, Richard Fitzgerald wrote:
> > On 25/05/2021 10:55, Rasmus Villemoes wrote:
> >> On 24/05/2021 17.59, Richard Fitzgerald wrote:
> >>> sparse was producing warnings of the form:
> >>>
> >>>   sparse: cast truncates bits from constant value (ffff0001 becomes 1)
> >>>
> >>> The problem was that value_representable_in_type() compared unsigned
> >>> types
> >>> against type_min(). But type_min() is only valid for signed types
> >>> because
> >>> it is calculating the value -type_max() - 1.
> > 
> > Ok, I see I was wrong about that. It does in fact work safely. Do you
> > want me to update the commit message to remove this?
> 
> Well, it was the "is only valid for signed types" I reacted to, so yes,
> please reword.
> 
> >> ... and casts that to (T), so it does produce 0 as it should. E.g. for
> >> T==unsigned char, we get
> >>
> >> #define type_min(T) ((T)((T)-type_max(T)-(T)1))
> >> (T)((T)-255 - (T)1)
> >> (T)(-256)
> >>
> > 
> > sparse warns about those truncating casts.
> 
> That's sad. As the comments and commit log indicate, I was very careful
> to avoid gcc complaining, even with various -Wfoo that are not normally
> enabled in a kernel build. I think sparse is wrong here. Cc += Luc.

Well, there is a cast and it effectively truncates the upper bits
of the constant, so sparse is kinda right but ... months ago I once
investigated these warnings and in all cases but one the use of the
cast was legit. Most of them was for:
1) a 32-bit constant that was (via some macro) split as two 16-bit
   constants which were then written to some 16-bit HW registers.
   The problem would not happen if the macro would use a AND mask
   instead of a cast but it seems that people tend to refer the cast,
   I think it's the wrong choice but eh.

2) some generic macro that do things like:
   #define macro(size, value) \
	switch (size) {
	case 1:
		... (u8) value;
	case 2:
		... (u16) value;
	...

    x = macro(sizeof(int), 0xffff0001);

   So, each time the macro is used for 32-bit, the code still contains
   a cast of the value to some smaller type, even if all uses are OK.
   The problem here is that these warnings are issued by sparse well
   before it can know that the code is dead and when it know it, these
   casts are already eliminated.

I'm sure this warning can sometimes catch a real problem but most of
the time it's not, just false warnings.

I think it would be best to disable this warning by default, but IIRC
this has already be discussed (years ago) and there was some opposition.
Maybe enabling it only at W=2 or something. I dunno.

-- Luc
