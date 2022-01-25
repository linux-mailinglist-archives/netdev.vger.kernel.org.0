Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DB049ACE0
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 08:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392394AbiAYHEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 02:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S248892AbiAYECo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 23:02:44 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757F9C06175A
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 16:43:58 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id d15-20020a17090a110f00b001b4e7d27474so939262pja.2
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 16:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=od4rMtYriWTB6JboVlJHqLIQ9gjgFdqPV5Mgxa99KZU=;
        b=7WbFYKgGzcF4hN+pxpyU1b1rmXqgX/rNlLaRT+nUmen4tRYdiynKREeFpy33PH4IvI
         s7byIqo9cU6zJSfbd3DJqzqRhRlPA8AGj6xUxBBXNlCXzi3K7x5oYFzvcc4nSOW7U31T
         36UtXEslwKyUG3WU64qWqpgS/ZAkg3gBNBsPI2tSLA4jIyQb+tSbwYoBfn0LXEzh+EdK
         gVdSN/5VvKcU8w17lNDBXFYBjcyuIV2xR0kXPm3fmIusPvIeq7Ua4SeKfdwjMKmLi7qW
         /TXsW1UGbSTGYsedizQ19so56IhKW0xiOHqmX0Bn2KCGSKwG1vQZZl4zumVaKuosxsT4
         i87g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=od4rMtYriWTB6JboVlJHqLIQ9gjgFdqPV5Mgxa99KZU=;
        b=umIMLnuxn4YhsVci3Kqgv4k1GTYmp+xFJyGoUUiGmC9xljLq5FSqtExop+rRogfpir
         eAIDV8azRtuMa/M/1ZDiudc9k0Gw57nfxursDe9+4kG8/nWhImKvwDQdk/rVXlhqPcWg
         vMOm9aJt9/F0UgJaBp53yrWXxjIojZRo2RwRlfyiT9F5We1rygXuECpbwgfruw1CAvEJ
         jF/U0g9QeBHTgAhlWVpnQJLUziqKDoM3a+AVSgiiMc0YUtg/1hZFnEOp7Fmdu15Klk6S
         MUMRK7xvle4DvuQuxgpys1gowbJJO9uXJsJSkik6l/kmi29GXeB2jLg3+/yuzsZoKsfG
         OYFw==
X-Gm-Message-State: AOAM532e4/hjWm4lY+xKhn0av3i9tfTibKVKq/lYGt47CcVmNYrHR81k
        BytVHp8lDKcxIZiN12ScgyOMYA==
X-Google-Smtp-Source: ABdhPJzGeRhSXNwlhEgcj/7i8GzE+tD1aga0ERRKMF606CXM+61P8bFo81rb4fRzVPfSI+tCAGu5sQ==
X-Received: by 2002:a17:90b:1c91:: with SMTP id oo17mr905746pjb.104.1643071437992;
        Mon, 24 Jan 2022 16:43:57 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id q7sm16338752pfs.37.2022.01.24.16.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 16:43:57 -0800 (PST)
Date:   Mon, 24 Jan 2022 16:43:54 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, Wen Liang <wenliang@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2 v3 1/2] tc: u32: add support for json output
Message-ID: <20220124164354.7be21b1c@hermes.local>
In-Reply-To: <Ye8abWbX5TZngvIS@tc2>
References: <cover.1641493556.git.liangwen12year@gmail.com>
        <0670d2ea02d2cbd6d1bc755a814eb8bca52ccfba.1641493556.git.liangwen12year@gmail.com>
        <20220106143013.63e5a910@hermes.local>
        <Ye7vAmKjAQVEDhyQ@tc2>
        <20220124105016.66e3558c@hermes.local>
        <Ye8abWbX5TZngvIS@tc2>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 22:30:21 +0100
Andrea Claudi <aclaudi@redhat.com> wrote:

> On Mon, Jan 24, 2022 at 10:50:16AM -0800, Stephen Hemminger wrote:
> > On Mon, 24 Jan 2022 19:25:06 +0100
> > Andrea Claudi <aclaudi@redhat.com> wrote:
> >   
> > > On Thu, Jan 06, 2022 at 02:30:13PM -0800, Stephen Hemminger wrote:  
> > > > On Thu,  6 Jan 2022 13:45:51 -0500
> > > > Wen Liang <liangwen12year@gmail.com> wrote:
> > > >     
> > > > >  	} else if (sel && sel->flags & TC_U32_TERMINAL) {
> > > > > -		fprintf(f, "terminal flowid ??? ");
> > > > > +		print_bool(PRINT_ANY, "terminal_flowid", "terminal flowid ??? ", true);    
> > > > 
> > > > This looks like another error (ie to stderr) like the earlier case
> > > >    
> > > 
> > > Hi Stephen,
> > > Sorry for coming to this so late, but this doesn't look like an error to me.
> > > 
> > > As far as I can see, TC_U32_TERMINAL is set in this file together with
> > > CLASSID or when "action" or "policy" are used. The latter case should be
> > > the one that this else branch should catch.
> > > 
> > > Now, "terminal flowid ???" looks to me like a message printed when we
> > > don't actually have a flowid to show, and indeed that is specified when
> > > this flag is set (see the comment at line 1169). As such this is
> > > probably more a useless log message, than an error one.
> > > 
> > > If this is the case, we can probably maintain this message on the
> > > PRINT_FP output (only to not break script parsing this bit of info out
> > > there), and disregard this bit of info on the JSON output.
> > > 
> > > What do you think?
> > > 
> > > Regards,
> > > Andrea
> > >   
> > 
> > Just always put the same original message on stderr.
> >   
> 
> Let me phrase my case better: I think the "terminal flowid" message
> should not be on stderr, as I don't think this is an error message.
> 
> Indeed, "terminal flowid ???" is printed every time we use "action" or
> "policy" (see my previous email for details), even when no error is
> present and cls_u32 is working ok. In these cases, not having a flowid
> is legitimate and not an error.
> 
> As this is the case, I think the proper course of action is to have this
> message printed out only in non-json output to preserve the same output
> of older iproute versions. It would be even better if we decide to
> remove this message altogether, as it is not adding any valuable info to
> the user.

Agree, I have never used this obscure corner of u32 so will defer to others.
But the existing message is unhelpful and looks like a bug.
The output should be clear and correct for both json and non-json cases;
and any ??? kind of output should be reserved for cases where some bogus
result is being returned by the kernel.  Some version skew, or partial
result of previous operation maybe.
