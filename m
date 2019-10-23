Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B307E1AB7
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 14:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390114AbfJWMf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 08:35:56 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42044 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731301AbfJWMfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 08:35:55 -0400
Received: by mail-qt1-f193.google.com with SMTP id w14so31962999qto.9;
        Wed, 23 Oct 2019 05:35:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=vI3RYjWfCttZtB8m2IZ917jkIIYZoL6wV/Fzo1xerU4=;
        b=TIgSbz60Quim7WmVDyxRNUG5vfStDXzuEpuBNaHBFKO4buI+48awBj7Sx+ssq+flBn
         DiZZLwsmYKtnmOwaMmMu3P9Z/xYolq0azzSlf3XWy1yfjKu5P2E1QOfP4O6She3ub8YT
         OY9XcrsB/nkuRy/tflFQ5mK9nZxg/L1afH7tU4YOvyUBmWYsFNkyLKx+RAV6/2tYKElp
         JzfajBnkTUKPVwrOGas3bnZR0+hZVsh1rUtRv4449f42z/LwN7yRwF2wbOcLdFdZju98
         iU48fq9naW55CmIO6tB1/IATmHwhYvar+gVeL4FRrxjreamNMNkZUzl8f4I30T/meTRs
         /UFg==
X-Gm-Message-State: APjAAAUw/EAWA44m9uAhmmIhw9L6If24fMjZvnux/xwiFnFKUevr3sFm
        Gg24omcWpTTLMgaQbmRpSdA=
X-Google-Smtp-Source: APXvYqwzk9ZG0+4J0w1emRb5XApt6R3YxG/s6e6C+PL7C8b6PG3qCKQ6EmMvBKjDibbZFbgmWj21fA==
X-Received: by 2002:ac8:2670:: with SMTP id v45mr8892181qtv.233.1571834154163;
        Wed, 23 Oct 2019 05:35:54 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id h129sm3538019qke.49.2019.10.23.05.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 05:35:52 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id C79EF40244; Wed, 23 Oct 2019 12:35:51 +0000 (UTC)
Date:   Wed, 23 Oct 2019 12:35:51 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Matthias Maennich <maennich@google.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jessica Yu <jeyu@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Will Deacon <will@kernel.org>
Subject: Re: Module loading problem since 5.3
Message-ID: <20191023123551.GJ11244@42.do-not-panic.com>
References: <20191014085235.GW16384@42.do-not-panic.com>
 <20191014144440.GG35313@google.com>
 <20191016125030.GH16384@42.do-not-panic.com>
 <20191016133710.GB35139@google.com>
 <20191018121848.GB11244@42.do-not-panic.com>
 <20191023104940.GD27616@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191023104940.GD27616@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 11:49:40AM +0100, Matthias Maennich wrote:
> On Fri, Oct 18, 2019 at 12:18:48PM +0000, Luis Chamberlain wrote:
> > On Wed, Oct 16, 2019 at 02:37:10PM +0100, Matthias Maennich wrote:
> > > On Wed, Oct 16, 2019 at 12:50:30PM +0000, Luis Chamberlain wrote:
> > > > On Mon, Oct 14, 2019 at 03:44:40PM +0100, Matthias Maennich wrote:
> > > > > Hi Luis!
> > > > >
> > > > > On Mon, Oct 14, 2019 at 08:52:35AM +0000, Luis Chamberlain wrote:
> > > > > > On Fri, Oct 11, 2019 at 09:26:05PM +0200, Heiner Kallweit wrote:
> > > > > > > On 10.10.2019 19:15, Luis Chamberlain wrote:
> > > > > > > >
> > > > > > > >
> > > > > > > > On Thu, Oct 10, 2019, 6:50 PM Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> wrote:
> > > > > > > >
> > > > > > > >        MODULE_SOFTDEP("pre: realtek")
> > > > > > > >
> > > > > > > >     Are you aware of any current issues with module loading
> > > > > > > >     that could cause this problem?
> > > > > > > >
> > > > > > > >
> > > > > > > > Nope. But then again I was not aware of
> > > > > > > > MODULE_SOFTDEP(). I'd encourage an extension to
> > > > > > > > lib/kmod.c or something similar which stress tests this.
> > > > > > > > One way that comes to mind to test this is to allow a
> > > > > > > > new tests case which loads two drives which co depend on
> > > > > > > > each other using this macro. That'll surely blow things
> > > > > > > > up fast. That is, the current kmod tests uses
> > > > > > > > request_module() or get_fs_type(), you'd want a new test
> > > > > > > > case with this added using then two new dummy test
> > > > > > > > drivers with the macro dependency.
> > > > > > > >
> > > > > > > > If you want to resolve this using a more tested path,
> > > > > > > > you could have request_module() be used as that is
> > > > > > > > currently tested. Perhaps a test patch for that can rule
> > > > > > > > out if it's the macro magic which is the issue.
> > > > > > > >
> > > > > > > >   Luis
> > > > > > >
> > > > > > > Maybe issue is related to a bug in introduction of symbol namespaces, see here:
> > > > > > > https://lkml.org/lkml/2019/10/11/659
> > > > > >
> > > > > > Can you have your user with issues either revert 8651ec01daed or apply the fixes
> > > > > > mentioned by Matthias to see if that was the issue?
> > > > > >
> > > > > > Matthias what module did you run into which let you run into the issue
> > > > > > with depmod? I ask as I think it would be wise for us to add a test case
> > > > > > using lib/test_kmod.c and tools/testing/selftests/kmod/kmod.sh for the
> > > > > > regression you detected.
> > > > >
> > > > > The depmod warning can be reproduced when using a symbol that is built
> > > > > into vmlinux and used from a module. E.g. with CONFIG_USB_STORAGE=y and
> > > > > CONFIG_USB_UAS=m, the symbol `usb_stor_adjust_quirks` is built in with
> > > > > namespace USB_STORAGE and depmod stumbles upon this emitting the
> > > > > following warning (e.g. during make modules_install).
> > > > >
> > > > >  depmod: WARNING: [...]/uas.ko needs unknown symbol usb_stor_adjust_quirks

But this was an issue only when the symbol namespace stuff was used?
Or do we know if it regressed other generic areas of the kernel?

> > > > > As there is another (less intrusive) way of implementing the namespace
> > > > > feature, I posted a patch series [1] on last Thursday that should
> > > > > mitigate the issue as the ksymtab entries depmod eventually relies on
> > > > > are no longer carrying the namespace in their names.
> > > > >
> > > > > Cheers,
> > > > > Matthias
> > > > >
> > > > > [1] https://lore.kernel.org/lkml/20191010151443.7399-1-maennich@google.com/
> > > >
> > > > Yes but kmalloc() is built-in, and used by *all* drivers compiled as
> > > > modules, so why was that not an issue?
> > 
> > > In ksymtab, namespaced symbols had the format
> > > 
> > >  __ksymtab_<NAMESPACE>.<symbol>
> > > 
> > > while symbols without namespace would still use the old format
> > > 
> > >  __ksymtab_<symbol>
> > 
> > Ah, I didn't see the symbol namespace patches, good stuff!
> > 
> > > These are also the names that are extracted into System.map (using
> > > scripts/mksysmap). Depmod is reading the System.map and for symbols used
> > > by modules that are in a namespace, it would not find a match as it does
> > > not understand the namespace notation. Depmod would still not emit a
> > > warning for symbols without namespace as their format did not change.

Now that I reviewed the symbol namespace implementation, and its
respective new fixes, it would seem to me that the issue is an after
thought issue with old userspace tools not being able to grock a new
expected format for symbol namespaces, and so with old kmod you'd run
into the depmod warning any time symbol namespaces are used.

Is that correct?

If so, I can't see how this issue could affect the reported issue in
this thread, where folks seem to be detecting a regression where a
module dependency is not being loaded. That is, I don't see how the
symbol namespace stuff could regress existing older symbols, specially
if the EXPORT_SYMBOL_NS() stuff is not used yet.

If this is correct the issue reported with r8169 may be different,
unless the implementation had some side consequences or issues which
we may not yet be aware of.

Having the user with what may be a regression with r8169 and module
dependency loading try to revert 8651ec01daed would be good to see if
the issue goes away.

> > Can we have a test case for this to ensure we don't regress on this
> > again? Or put another way, what test cases were implemented for symbol
> > namespaces?
> 
> While modpost and kernel/module.c are the tests at build and runtime
> resp. to enforce proper use of symbol namespaces,

Well clearly it can also be buggy :)

> I could imagine to test for the proper layout in the ksymtab entries

Do we not have this already done at compile time?

> (
> note, as mentioned
> earlier there are some fixes in flight to finalize the layout).

Reviewed now, thanks for the lore URL reference!

> In addition, I could imagine adding a test that tries to load a module
> that uses symbols from a namespace without importing it. The kernel
> should deny loading or complain about it (depending on the
> configuration). These are also some of the test cases I had when working
> on that feature. I did not implement these as automated tests though. I
> will put that on my list but help with that would be very welcome.

Happy to help with that, sure. Now that I grok the namespace kmod issue,
indeed tools/testing/selftests/kmod/kmod.sh and lib/test_kmod.c could be
extended with a new test case for namespaces. Two demo test drivers
would be written which allow for testing the different cases. Let me
know if the suggestion is unclear or if you have any questions about the
code.

  Luis
