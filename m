Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757C83F3011
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241217AbhHTPtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240952AbhHTPt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 11:49:29 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A9CC061757
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 08:48:51 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so14102888pjr.1
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 08:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+X4tplmtLpNByUEVXOfNbGWn8TfE6IQ/s3keb98s9Zw=;
        b=TQi9mHrog4hPanBaikdC3rkAqhWlJoZ9vaxMBbVCpuTo6U3O8D/l7D3vj3Dwl9Evpk
         9+Ar2w4FVMAo3iFJgQJ24Rf/5z+Jb9VcsmknpA1sA/dgnc+y+KKgkLyHTejrjon296vl
         nVvqNextVO6bfDk20DLfoQeW8dUpsfILdnoVs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+X4tplmtLpNByUEVXOfNbGWn8TfE6IQ/s3keb98s9Zw=;
        b=EViH+rpWGsSvzArwMsCkuiPP5DLn3HwcO1xaR5WL2fUKbSMDxeJEd/KUQ6tNtp49/y
         GDz1ZHqb00bAtSe1GFJjBraSJ7NL1rX/kLpCkq1TTPGDzXN66n0Hj8+RjaNl9+tx21CO
         KrNUM6k72FYUwKabX9IVXllmhJQdzaqOj6F2hLr2Q1mUOzqimCT6rEuaoIJJbgjHHAj8
         lU5A+dZdqgH9Z9kLviMzCy+T7bXMkoPPOlxeZJGnt2O2Ktc11DjQfbc0bz7MlBkcPYZC
         0o6MSevvqI1HLPnOln+PfY9akJLs6Bt4++sqhdFjy1QU64B1+u8PVKUmn2PcsKvK6u/m
         mu9w==
X-Gm-Message-State: AOAM533RUIKFweWQnVneYoxFHBu7QC84sCex9pu9akasPTXnC7dsqE6b
        XIvPeCEiHg5BUDu/UJcX60cKOg==
X-Google-Smtp-Source: ABdhPJy28AqDYlCk7fSw2jInR24wvj759kZeVQ/aeXK5FOKx4YXAZlQAlIPt57DIYl/oWb05ha9YZQ==
X-Received: by 2002:a17:90a:f0d1:: with SMTP id fa17mr1603893pjb.33.1629474531324;
        Fri, 20 Aug 2021 08:48:51 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q21sm6457593pjg.55.2021.08.20.08.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 08:48:50 -0700 (PDT)
Date:   Fri, 20 Aug 2021 08:48:49 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 22/63] HID: cp2112: Use struct_group() for memcpy()
 region
Message-ID: <202108200848.E9DB1511A@keescook>
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-23-keescook@chromium.org>
 <nycvar.YFH.7.76.2108201501340.15313@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.2108201501340.15313@cbobk.fhfr.pm>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 03:01:43PM +0200, Jiri Kosina wrote:
> On Tue, 17 Aug 2021, Kees Cook wrote:
> 
> > In preparation for FORTIFY_SOURCE performing compile-time and run-time
> > field bounds checking for memcpy(), memmove(), and memset(), avoid
> > intentionally writing across neighboring fields.
> > 
> > Use struct_group() in struct cp2112_string_report around members report,
> > length, type, and string, so they can be referenced together. This will
> > allow memcpy() and sizeof() to more easily reason about sizes, improve
> > readability, and avoid future warnings about writing beyond the end of
> > report.
> > 
> > "pahole" shows no size nor member offset changes to struct
> > cp2112_string_report.  "objdump -d" shows no meaningful object
> > code changes (i.e. only source line number induced differences.)
> > 
> > Cc: Jiri Kosina <jikos@kernel.org>
> > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > Cc: linux-input@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Applied, thanks.

I'm not sure if my other HTML email got through, but please don't apply
these to separate trees -- struct_group() is introduced as part of this
series.

-- 
Kees Cook
