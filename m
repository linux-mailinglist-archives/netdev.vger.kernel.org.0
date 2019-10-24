Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B69F1E2D1C
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 11:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393044AbfJXJWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 05:22:18 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35445 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733125AbfJXJWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 05:22:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id v6so1843813wmj.0
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 02:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ZE04pxpYdyRA9XdoTz9P68mHI4Lq7kaCFDsvg5rhNDQ=;
        b=H5JCI2DQYx7MmqK/3h/jzgkARGKag8ncdrLjMsqvhSxC/zopgafA5v/eJoTsyKk+mW
         u25AaN6U7l7ipXfxaS3+Gf9O7m+m7gv43a3HngVr/Tr2+FosfZje3zIfh+crL8fazcn1
         geIbBJ3z/Mmz253nHW0W9PWomDDsEkfIWXlLrWcIkGsvouG7JeIwRg4Qs88iiRyJTRuG
         77Q/6paJZhOIyLUAHFslT+GpTixTU69xI/ZQ6pBC9NJLfL+6jVC7RUERJoxhfFaFxE+/
         dyHrovabQ93i48DH8vzS9qIz/+efN+4vFU8jrtkAwZP6M1PSirTDqKn15G2s6gnyFwB2
         WH/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ZE04pxpYdyRA9XdoTz9P68mHI4Lq7kaCFDsvg5rhNDQ=;
        b=ZVlHmZflzDxDovT4HKqgI7cj+D4yHBxyf3aS6rbad+l0PzDkgcbgEa2dGOt3zRaghR
         Xl/qQplX497Vzw6rR6/IpxeRrzEj19R47v3k0zF8sgbtF9RLjP9Ov2cnPrKQTN1BlL1z
         e2S1a5gXzLq6erI0iiAC+LjpIOkddU5Xhj4GieBLzp2CzdP0T/EAoXKI9G7JcxawRVC+
         GuUfH2anUDV2Xgn3AcS/vEV7l6A+FkCMHHfiDQr3jO35zQ2p3g5LOKiT+98MJxSMwnsS
         0ET9bPjLvaTZ2AZiBBvwoQyo+nVH/gIgJJv0gg4XXoc9zSPLVWa1F6b5/ve53CWbmuJY
         Yn9A==
X-Gm-Message-State: APjAAAU+rwUx1FPlDD4kwO2LcvJ3qQQ/8iKzXRKkCDpfoTyskyl0gsgO
        1b5cUqDG+qKtwSYnvwfdb03bUN2viBg=
X-Google-Smtp-Source: APXvYqwWLj6L6TKs78ndUuP77XJVxWCBVDt/hgEtNwju3aljWTPIu5XSVW6kdi7dJ0z0XxkP2zLokA==
X-Received: by 2002:a1c:a90f:: with SMTP id s15mr3931818wme.100.1571908934614;
        Thu, 24 Oct 2019 02:22:14 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:e8f7:125b:61e9:733d])
        by smtp.gmail.com with ESMTPSA id c16sm12055975wrw.32.2019.10.24.02.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 02:22:13 -0700 (PDT)
Date:   Thu, 24 Oct 2019 10:22:13 +0100
From:   Matthias Maennich <maennich@google.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jessica Yu <jeyu@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Will Deacon <will@kernel.org>
Subject: Re: Module loading problem since 5.3
Message-ID: <20191024092213.GA199239@google.com>
References: <20191014085235.GW16384@42.do-not-panic.com>
 <20191014144440.GG35313@google.com>
 <20191016125030.GH16384@42.do-not-panic.com>
 <20191016133710.GB35139@google.com>
 <20191018121848.GB11244@42.do-not-panic.com>
 <20191023104940.GD27616@google.com>
 <20191023123551.GJ11244@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191023123551.GJ11244@42.do-not-panic.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 12:35:51PM +0000, Luis Chamberlain wrote:
>On Wed, Oct 23, 2019 at 11:49:40AM +0100, Matthias Maennich wrote:
>> On Fri, Oct 18, 2019 at 12:18:48PM +0000, Luis Chamberlain wrote:
>> > On Wed, Oct 16, 2019 at 02:37:10PM +0100, Matthias Maennich wrote:
>> > > On Wed, Oct 16, 2019 at 12:50:30PM +0000, Luis Chamberlain wrote:
>> > > > On Mon, Oct 14, 2019 at 03:44:40PM +0100, Matthias Maennich wrote:
>> > > > > Hi Luis!
>> > > > >
>> > > > > On Mon, Oct 14, 2019 at 08:52:35AM +0000, Luis Chamberlain wrote:
>> > > > > > On Fri, Oct 11, 2019 at 09:26:05PM +0200, Heiner Kallweit wrote:
>> > > > > > > On 10.10.2019 19:15, Luis Chamberlain wrote:
>> > > > > > > >
>> > > > > > > >
>> > > > > > > > On Thu, Oct 10, 2019, 6:50 PM Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> wrote:
>> > > > > > > >
>> > > > > > > >        MODULE_SOFTDEP("pre: realtek")
>> > > > > > > >
>> > > > > > > >     Are you aware of any current issues with module loading
>> > > > > > > >     that could cause this problem?
>> > > > > > > >
>> > > > > > > >
>> > > > > > > > Nope. But then again I was not aware of
>> > > > > > > > MODULE_SOFTDEP(). I'd encourage an extension to
>> > > > > > > > lib/kmod.c or something similar which stress tests this.
>> > > > > > > > One way that comes to mind to test this is to allow a
>> > > > > > > > new tests case which loads two drives which co depend on
>> > > > > > > > each other using this macro. That'll surely blow things
>> > > > > > > > up fast. That is, the current kmod tests uses
>> > > > > > > > request_module() or get_fs_type(), you'd want a new test
>> > > > > > > > case with this added using then two new dummy test
>> > > > > > > > drivers with the macro dependency.
>> > > > > > > >
>> > > > > > > > If you want to resolve this using a more tested path,
>> > > > > > > > you could have request_module() be used as that is
>> > > > > > > > currently tested. Perhaps a test patch for that can rule
>> > > > > > > > out if it's the macro magic which is the issue.
>> > > > > > > >
>> > > > > > > >   Luis
>> > > > > > >
>> > > > > > > Maybe issue is related to a bug in introduction of symbol namespaces, see here:
>> > > > > > > https://lkml.org/lkml/2019/10/11/659
>> > > > > >
>> > > > > > Can you have your user with issues either revert 8651ec01daed or apply the fixes
>> > > > > > mentioned by Matthias to see if that was the issue?
>> > > > > >
>> > > > > > Matthias what module did you run into which let you run into the issue
>> > > > > > with depmod? I ask as I think it would be wise for us to add a test case
>> > > > > > using lib/test_kmod.c and tools/testing/selftests/kmod/kmod.sh for the
>> > > > > > regression you detected.
>> > > > >
>> > > > > The depmod warning can be reproduced when using a symbol that is built
>> > > > > into vmlinux and used from a module. E.g. with CONFIG_USB_STORAGE=y and
>> > > > > CONFIG_USB_UAS=m, the symbol `usb_stor_adjust_quirks` is built in with
>> > > > > namespace USB_STORAGE and depmod stumbles upon this emitting the
>> > > > > following warning (e.g. during make modules_install).
>> > > > >
>> > > > >  depmod: WARNING: [...]/uas.ko needs unknown symbol usb_stor_adjust_quirks
>
>But this was an issue only when the symbol namespace stuff was used?
>Or do we know if it regressed other generic areas of the kernel?

The only known regression was caused by the changed ksymtab entry name
as pointed out above. (Userland) tools depending on that representation
might report issues. That is what [1] addresses by not requiring that
name change any longer and reverting to the previous scheme.

>
>> > > > > As there is another (less intrusive) way of implementing the namespace
>> > > > > feature, I posted a patch series [1] on last Thursday that should
>> > > > > mitigate the issue as the ksymtab entries depmod eventually relies on
>> > > > > are no longer carrying the namespace in their names.
>> > > > >
>> > > > > Cheers,
>> > > > > Matthias
>> > > > >
>> > > > > [1] https://lore.kernel.org/lkml/20191010151443.7399-1-maennich@google.com/
>> > > >
>> > > > Yes but kmalloc() is built-in, and used by *all* drivers compiled as
>> > > > modules, so why was that not an issue?
>> >
>> > > In ksymtab, namespaced symbols had the format
>> > >
>> > >  __ksymtab_<NAMESPACE>.<symbol>
>> > >
>> > > while symbols without namespace would still use the old format
>> > >
>> > >  __ksymtab_<symbol>
>> >
>> > Ah, I didn't see the symbol namespace patches, good stuff!
>> >
>> > > These are also the names that are extracted into System.map (using
>> > > scripts/mksysmap). Depmod is reading the System.map and for symbols used
>> > > by modules that are in a namespace, it would not find a match as it does
>> > > not understand the namespace notation. Depmod would still not emit a
>> > > warning for symbols without namespace as their format did not change.
>
>Now that I reviewed the symbol namespace implementation, and its
>respective new fixes, it would seem to me that the issue is an after
>thought issue with old userspace tools not being able to grock a new
>expected format for symbol namespaces, and so with old kmod you'd run
>into the depmod warning any time symbol namespaces are used.
>
>Is that correct?
>
>If so, I can't see how this issue could affect the reported issue in
>this thread, where folks seem to be detecting a regression where a
>module dependency is not being loaded. That is, I don't see how the
>symbol namespace stuff could regress existing older symbols, specially
>if the EXPORT_SYMBOL_NS() stuff is not used yet.
>
>If this is correct the issue reported with r8169 may be different,
>unless the implementation had some side consequences or issues which
>we may not yet be aware of.
>

I don't disagree that the issue that started the thread could be caused
by a different problem. I was merely responding to the question how to
reproduce the outstanding issues in the symbol namespaces that caused
depmod to emit a warning.

>Having the user with what may be a regression with r8169 and module
>dependency loading try to revert 8651ec01daed would be good to see if
>the issue goes away.
>
>> > Can we have a test case for this to ensure we don't regress on this
>> > again? Or put another way, what test cases were implemented for symbol
>> > namespaces?
>>
>> While modpost and kernel/module.c are the tests at build and runtime
>> resp. to enforce proper use of symbol namespaces,
>
>Well clearly it can also be buggy :)

Again, not disagreeing.

>
>> I could imagine to test for the proper layout in the ksymtab entries
>
>Do we not have this already done at compile time?

Modpost (now) depends on the proper layout to validate namespaces at
modpost time. But that does not guard against e.g. growth of that entry.

>
>> (
>> note, as mentioned
>> earlier there are some fixes in flight to finalize the layout).
>
>Reviewed now, thanks for the lore URL reference!
>
>> In addition, I could imagine adding a test that tries to load a module
>> that uses symbols from a namespace without importing it. The kernel
>> should deny loading or complain about it (depending on the
>> configuration). These are also some of the test cases I had when working
>> on that feature. I did not implement these as automated tests though. I
>> will put that on my list but help with that would be very welcome.
>
>Happy to help with that, sure. Now that I grok the namespace kmod issue,
>indeed tools/testing/selftests/kmod/kmod.sh and lib/test_kmod.c could be
>extended with a new test case for namespaces. Two demo test drivers
>would be written which allow for testing the different cases. Let me
>know if the suggestion is unclear or if you have any questions about the
>code.

I would like to defer this work until the fixes are in. That will
hopefully be -rc5. One additional test case could be to check that the
symbol namespaces required by the module's symbol use are consistent
with the declared imports via modinfo.

Thanks for your input!

Cheers,
Matthias

>
>  Luis
