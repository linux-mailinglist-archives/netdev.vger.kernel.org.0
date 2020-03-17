Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAD0188F45
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 21:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgCQUrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 16:47:17 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40819 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgCQUrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 16:47:17 -0400
Received: by mail-pf1-f195.google.com with SMTP id l184so12589152pfl.7
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 13:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/ZMNFVo7Tsi5t68rALsYOvDVbYQdbqGTWKL9lb3JvuE=;
        b=c9nyhi39KsZWTsbpDFXgSXKk3n7yOwp3uxTzHaQnVDIM13uJ4QnSSw/aQZXKdFL1ei
         88iumTiBDgVcsVpOXraZRTpCQZJC4n/haKrhbtsyJ1arprcZ2hNrICrMgesDskYlzrHL
         m0keVQltdevZKhucb9zYrQJdR6L7RgUiKoNJ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/ZMNFVo7Tsi5t68rALsYOvDVbYQdbqGTWKL9lb3JvuE=;
        b=Ytxt7MdV38lLy7TTAZvBSO/fMQ0jjy+qnflxVPRllTzblDn81F4/NpqP2Vw5AihTCO
         UZkmId054eQnHd+XNUHmxuvmmS0kNprc+AmyFaLiqquSOCQF9Ka721rZIFVFcjhMPcdw
         3U19YFBRFogpCICicuo6yvPR2HAXbbTh903Uqi/DUVEPMB35UViCMMspd+222m896pBm
         99ej7MzI9cHcylIYrHiu/Yem75BNp0cF93fW81GeGwOzIMRMsn2B+Qnw2aB84QWFWAJ3
         di7DcY69KFIWCkOM9t+F3C0nVVxMR72opBP520l7oS2AAFzqUyY/mnmNp0x9F2fj9Oy6
         2GSw==
X-Gm-Message-State: ANhLgQ33Kmj9q9MYFV+X45ew9OIz7N/1kgQ70YkWdBKlBiFqi47YT+59
        U6JXxw6n3SrGWIBwTmriNAQTXg==
X-Google-Smtp-Source: ADFU+vu6/iwKJHS7qAmilHd6qy3wjFZHBgJSRKd1VFcdNCaGVajZVzYQ5jIB8zxApm9ZrQs3cBrUsw==
X-Received: by 2002:a62:de83:: with SMTP id h125mr607859pfg.161.1584478035217;
        Tue, 17 Mar 2020 13:47:15 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j21sm258232pji.13.2020.03.17.13.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 13:47:14 -0700 (PDT)
Date:   Tue, 17 Mar 2020 13:47:13 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     shuah@kernel.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com, Tim.Bird@sony.com
Subject: Re: [PATCH v3 0/6] kselftest: add fixture parameters
Message-ID: <202003171346.C4E287D@keescook>
References: <20200316225647.3129354-1-kuba@kernel.org>
 <20200316155917.5ba8db1c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316155917.5ba8db1c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 03:59:17PM -0700, Jakub Kicinski wrote:
> On Mon, 16 Mar 2020 15:56:40 -0700 Jakub Kicinski wrote:
> > Hi!
> > 
> > Shuah please consider applying to the kselftest tree.
> > 
> > This set is an attempt to make running tests for different
> > sets of data easier. The direct motivation is the tls
> > test which we'd like to run for TLS 1.2 and TLS 1.3,
> > but currently there is no easy way to invoke the same
> > tests with different parameters.
> > 
> > Tested all users of kselftest_harness.h.
> > 
> > v2:
> >  - don't run tests by fixture
> >  - don't pass params as an explicit argument
> > 
> > v3:
> >  - go back to the orginal implementation with an extra
> >    parameter, and running by fixture (Kees);
> >  - add LIST_APPEND helper (Kees);
> >  - add a dot between fixture and param name (Kees);
> >  - rename the params to variants (Tim);
> > 
> > v1: https://lore.kernel.org/netdev/20200313031752.2332565-1-kuba@kernel.org/
> > v2: https://lore.kernel.org/netdev/20200314005501.2446494-1-kuba@kernel.org/
> 
> Ugh, sorry I forgot to realign things after the rename :S
> 
> I'll send a whitespace-only v4 in a hour, allowing a little bit 
> of time in case there are some comments already.

No worries! I think a few small changes are needed for a v5 (please
carry my Acked-bys with for v5). Thanks for working on this; I love it!
:)

-Kees

-- 
Kees Cook
