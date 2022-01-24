Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77ED4988E1
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343675AbiAXSvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241998AbiAXSuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:50:20 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283DEC061768
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:50:20 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so40115pjb.1
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yuP3JDrbE6w16wPOTgWLhiK+udMBbZoSXXJhWY6oMP8=;
        b=zxkxTW+9acUf0u//PY9kK56asbZsoVoNtMmEJsBtfEjuPk7/EPMle7/43OunqC/m3E
         GuhzOEZJOukfeHOkj/xO9FYsqrlDFRrdywI90eysBYcIB51KLXLRfTfIs6useuVNWlrI
         /oyubgKz14b5TUsmaoRfxF+tQhemJ+Hpxi5iaW43fkMHAlykgovX7oHhmhIxdt/SYoM7
         sQ9zgL5sfeSEDmcW+F0Uei1lxbiNZysjbkRvtXaBrjUA9jf4ykexTk+Bnwg9VQ7+cOmm
         75YiZLL2Ww+FP82+dLuewqMVPl6qNPMljSS7fETm9O6TTHQs+vMjmu9VffKUiyV+jxJT
         vMQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yuP3JDrbE6w16wPOTgWLhiK+udMBbZoSXXJhWY6oMP8=;
        b=rBNNuyn1nqaGiCnSUrDk5/RBOW1mO/MS8PvYrOEcb1TYqrqTjWwtRHSplXYjVlLO5X
         gEI5bmlK9wejDIjFD2Kl5kNklkZ5ZNzx8RYDmZfYzrm3t4DR+Hu+z6p0JW1WrKX90hBw
         sWg4NcfKJgjzHTLBVas7pklukFhAGM6UlMuu4nKEOmCziNjqtgcaHm5STDv5+L6ywO0l
         gTjR0y9jKjnExuGLvr6nmkzkCJXsdHaVReJvwd3VZPF2AwpjWE+fWDGIS6DI/bx/iCbU
         RhWqbo26LtnXXQCc0PA8ljfloyoYR3j7JNIwoVruJ8VWS2TgQB7JDOgYxhItFGiUcUHC
         1DrQ==
X-Gm-Message-State: AOAM530wDNQl/h1nFci6ydx5hukVnWp5Cg/q3XhIusvNrUEji6yz5Yk5
        nmsChq4madd/wnwx+ZDLdtw1Qg==
X-Google-Smtp-Source: ABdhPJyclNtljVfeDeMfCbtRj3ct7p+kytbzqZsWDcKQztVULvGYJgGq3foSn2iPNwJGvwxZWdRcxw==
X-Received: by 2002:a17:90b:2351:: with SMTP id ms17mr3187998pjb.186.1643050219557;
        Mon, 24 Jan 2022 10:50:19 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id mw14sm106330pjb.6.2022.01.24.10.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:50:19 -0800 (PST)
Date:   Mon, 24 Jan 2022 10:50:16 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, Wen Liang <wenliang@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2 v3 1/2] tc: u32: add support for json output
Message-ID: <20220124105016.66e3558c@hermes.local>
In-Reply-To: <Ye7vAmKjAQVEDhyQ@tc2>
References: <cover.1641493556.git.liangwen12year@gmail.com>
        <0670d2ea02d2cbd6d1bc755a814eb8bca52ccfba.1641493556.git.liangwen12year@gmail.com>
        <20220106143013.63e5a910@hermes.local>
        <Ye7vAmKjAQVEDhyQ@tc2>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 19:25:06 +0100
Andrea Claudi <aclaudi@redhat.com> wrote:

> On Thu, Jan 06, 2022 at 02:30:13PM -0800, Stephen Hemminger wrote:
> > On Thu,  6 Jan 2022 13:45:51 -0500
> > Wen Liang <liangwen12year@gmail.com> wrote:
> >   
> > >  	} else if (sel && sel->flags & TC_U32_TERMINAL) {
> > > -		fprintf(f, "terminal flowid ??? ");
> > > +		print_bool(PRINT_ANY, "terminal_flowid", "terminal flowid ??? ", true);  
> > 
> > This looks like another error (ie to stderr) like the earlier case
> >  
> 
> Hi Stephen,
> Sorry for coming to this so late, but this doesn't look like an error to me.
> 
> As far as I can see, TC_U32_TERMINAL is set in this file together with
> CLASSID or when "action" or "policy" are used. The latter case should be
> the one that this else branch should catch.
> 
> Now, "terminal flowid ???" looks to me like a message printed when we
> don't actually have a flowid to show, and indeed that is specified when
> this flag is set (see the comment at line 1169). As such this is
> probably more a useless log message, than an error one.
> 
> If this is the case, we can probably maintain this message on the
> PRINT_FP output (only to not break script parsing this bit of info out
> there), and disregard this bit of info on the JSON output.
> 
> What do you think?
> 
> Regards,
> Andrea
> 

Just always put the same original message on stderr.
