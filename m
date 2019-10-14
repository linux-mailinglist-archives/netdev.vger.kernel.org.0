Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE38D603D
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 12:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbfJNKcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 06:32:48 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39562 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731249AbfJNKcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 06:32:48 -0400
Received: by mail-pf1-f194.google.com with SMTP id v4so10163815pff.6;
        Mon, 14 Oct 2019 03:32:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=V5pDezJMqf7oBE4C6VaBNE4QDw+JTPxLDOjnj3y+UOk=;
        b=ICINQid/0VBRZxLomGE7hpWae1lCd3Gz6vrf7uqRm7w5wSA778kqExUiP3shKlJ09d
         uk2DVdisOhKMGJ37YwtnI/jCwv6FMTj6OJ8fyggx0+OEyzLGZsfyqb3kxj+AByRDTrSm
         i2yc14NAiYSvDN485Db02AgsvjGX430RQPgTyKv+uUN9AlIEmE4I+qqBmoIxSYK6z5R8
         rCVK8jeIfOIFwGL8vaLKuZK+AZU5taq2zHbv31ZSJgZTbLiTfQxQMabPyE1Lzl930qab
         PkW4j1qD0b7brkHA/01+mv3Q1RS4PayAn5g0rpX0CBsqAihQ2DlSoHy/jd3mH0bf9kN5
         +GNA==
X-Gm-Message-State: APjAAAWHcGEO4jMjeJ/CfZAhFpvlU8b7GJQn2hq41YrJ854jkauPPjTf
        8f4cArha6xWQenWu6NVGV+E=
X-Google-Smtp-Source: APXvYqzUKM8jlBvgeShDu4Jyl84yxBpb6tYRPxHAgxlA2z1yj14ICSjujoBlncNY5Siu7MZrwFiivw==
X-Received: by 2002:aa7:8287:: with SMTP id s7mr32204175pfm.82.1571049167485;
        Mon, 14 Oct 2019 03:32:47 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id f17sm15806366pgd.8.2019.10.14.03.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 03:32:46 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id D23D84021A; Mon, 14 Oct 2019 10:32:45 +0000 (UTC)
Date:   Mon, 14 Oct 2019 10:32:45 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Module loading problem since 5.3
Message-ID: <20191014103245.GC16384@42.do-not-panic.com>
References: <8132cf72-0ae1-48ae-51fb-1a01cf00c693@gmail.com>
 <CAB=NE6XdVXMnq7pgmXxv4Qicu7=xrtQC-b2sXAfVxiAq68NMKg@mail.gmail.com>
 <875eecfb-618a-4989-3b9f-f8272b8d3746@gmail.com>
 <20191014100143.GA6525@linux-8ccs>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191014100143.GA6525@linux-8ccs>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 12:01:44PM +0200, Jessica Yu wrote:
> +++ Heiner Kallweit [11/10/19 21:26 +0200]:
> > On 10.10.2019 19:15, Luis Chamberlain wrote:
> > > 
> > > 
> > > On Thu, Oct 10, 2019, 6:50 PM Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> wrote:
> > > 
> > >        MODULE_SOFTDEP("pre: realtek")
> > > 
> > >     Are you aware of any current issues with module loading
> > >     that could cause this problem?
> > > 
> > > 
> > > Nope. But then again I was not aware of MODULE_SOFTDEP(). I'd encourage an extension to lib/kmod.c or something similar which stress tests this. One way that comes to mind to test this is to allow a new tests case which loads two drives which co depend on each other using this macro. That'll surely blow things up fast. That is, the current kmod tests uses request_module() or get_fs_type(), you'd want a new test case with this added using then two new dummy test drivers with the macro dependency.
> > > 
> > > If you want to resolve this using a more tested path, you could have request_module() be used as that is currently tested. Perhaps a test patch for that can rule out if it's the macro magic which is the issue.
> > > 
> > >   Luis
> > > 
> > Maybe issue is related to a bug in introduction of symbol namespaces, see here:
> > https://lkml.org/lkml/2019/10/11/659
> 
> If you're running into depmod and module loading issues with kernels >=5.3-rc1,
> it's likely due to the namespaces patchset and we're working on
> getting all the kinks fixed. Could you please ask the bug reporter to
> try the latest -rc kernel with these set of fixes applied on top?
> 
>   https://lore.kernel.org/linux-modules/20191010151443.7399-1-maennich@google.com/
> 
> They fix a known depmod issue caused by our __ksymtab naming scheme,
> which is being reverted in favor of extracting the namespace from
> __kstrtabns and __ksymtab_strings. These fixes will be in by -rc4.

Jessica, thanks! Do we have a test case to catch this proactively in
the future? If not can one be written?

  Luis
