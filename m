Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEF33F33C1
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 20:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhHTS2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 14:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236378AbhHTS2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 14:28:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F86C061756;
        Fri, 20 Aug 2021 11:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tdQqeccCak7gZvzJh0sTAGQqu+YU4rsLzWI4kGslWng=; b=ZJbBe6oXsxX7AoqefdSkvbjVKX
        P5f7bDtiCLrra3haNmrU9N9PCmgaNVQ5s/CNFqinUSqm4Qc/Jnk9gM9hVkQzYqGyZbqN8D70oNeeE
        Xvyrwn0m9SzLjkao8fmr7ydM/5Xhiks8Z6mqMbYL+0PnJGDerVm9q+bngGnHRsXlMwzv8Wm9u/RQN
        67qOSlYM5mos5r+CRhC630VaCVtW7wNULIkBGJDl+s+l0hkEUmzg6EzmIWL5VVWXP9t/mQJU/jihx
        RPpHOVJGWmqyuoxA/Wb2nbldQOg6ZTwjd9PxbLAjIs2N4FRTEhrAhohu3r3RVPRFZiDQTLy+wHi/A
        smy81+gg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mH9DC-006qfn-8u; Fri, 20 Aug 2021 18:26:17 +0000
Date:   Fri, 20 Aug 2021 19:25:50 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Joe Perches <joe@perches.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        LukasBulwahn <lukas.bulwahn@gmail.com>,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        linux-csky@vger.kernel.org
Subject: Re: What is the oldest perl version being used with the kernel ?
 update oldest supported to 5.14 ?
Message-ID: <YR/zrjiCwnzMMcmA@casper.infradead.org>
References: <37ec9a36a5f7c71a8e23ab45fd3b7f20efd5da24.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37ec9a36a5f7c71a8e23ab45fd3b7f20efd5da24.camel@perches.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 10:27:59AM -0700, Joe Perches wrote:
> Perl 5.8 is nearly 20 years old now.
> 
> https://en.wikipedia.org/wiki/Perl_5_version_history
> 
> checkpatch uses regexes that are incompatible with perl versions
> earlier than 5.10, but these uses are currently runtime checked
> and skipped if the perl version is too old.  This runtime checking
> skips several useful tests.
> 
> There is also some desire for tools like kernel-doc, checkpatch and
> get_maintainer to use a common library of regexes and functions:
> https://lore.kernel.org/lkml/YR2lexDd9N0sWxIW@casper.infradead.org/
> 
> It'd be useful to set the minimum perl version to something more modern.
> 
> I believe perl 5.14, now only a decade old, is a reasonable target.
> 
> Any objections or suggestions for a newer minimum version?

Not an objection per se, but some data points.

Oracle Linux 5 (released 2007, still under support) has perl 5.8.8
Oracle Linux 6 (released 2011) has perl 5.10.1
Oracle Linux 7 (released 2014) has perl 5.16.3
Oracle Linux 8 (released 2019) has perl 5.26.3

I don't know that we need to be able to build on a distro from 2007
or even from 2011.  I think it's reasonable to require updating to a
2014 distro in order to build a 2021 kernel.

For comparison, we currently require gcc-4.9 to build the kernel, and
4.9.0 was released in 2014.  So perl-5.16 wouldn't be an unreasonable
requirement, I believe.
