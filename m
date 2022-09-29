Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6EFD5EFD63
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 20:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiI2Sut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 14:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiI2Suq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 14:50:46 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330C61288AA;
        Thu, 29 Sep 2022 11:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=43Bm+bBoRaRR+2CN2BJpeoxNTszzj/pxlsTL7mDcESU=; b=GVUM5KR6fHt9XdiDoVJrZqfcoL
        r/e9D/TQUE+AJR8c/fQm15wrRx52nFHosHwTIUUqC5+j4kIKz2gdg9dhm5XSwR/a1bmFZRmjdTo5i
        cTjumOhhiHJI61pA7uN+7Ll7xSVF1rCEnP9tmfmN6v4DNBx1Dqsr22cQGvKHV7AMQPw7U+ZzHLOme
        Aer4VBauT1WxQVqR4ufIOwN8o9rSnG2IyFt1Z14DT+9tDhqKYizE3y/lWlqOH+FcH1FKByMg4FgfG
        674TTQN/fn1dWmyDCZzlYmdS4OcB7wge5HZDs0fM6+y/OdT17zg4dIUGhNq+8UiCO3VT5pmoNo+H3
        /ZQ/agEg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1odycG-0053z2-1i;
        Thu, 29 Sep 2022 18:50:36 +0000
Date:   Thu, 29 Sep 2022 19:50:36 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 3/4] proc: Point /proc/net at /proc/thread-self/net
 instead of /proc/self/net
Message-ID: <YzXo/DIwq65ypHNH@ZenIV>
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
 <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 11:21:36AM -0700, Linus Torvalds wrote:
> On Thu, Sep 29, 2022 at 8:22 AM David Laight <David.Laight@aculab.com> wrote:
> >
> > This was applied and then reverted by Linus (I can't find anything
> > in the LKML archive) - see git show 155134fef - because of
> > issues with apparmor and dhclient.
> 
> lkml archive link:
> 
>   https://lore.kernel.org/all/CADDKRnDD_W5yJLo2otWXH8oEgmGdMP0N_p7wenBQbh17xKGZJg@mail.gmail.com/
> 
> in case anybody cares.
> 
> I wonder if the fix is to replace the symlink with a hardcoded lookup
> (ie basically make it *act* like a hardlink - we don't really support
> hardlinked directories, but we could basically fake the lookup in
> proc). Since the problem was AppArmor reacting to the name in the
> symlink.
> 
> Al added the participants so that he can say "hell no".

What do you mean?  Lookup on "net" in /proc returning what, exactly?
What would that dentry have for ->d_parent?
