Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110BD359DE7
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 13:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbhDILtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 07:49:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232295AbhDILtj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 07:49:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D3AB6115B;
        Fri,  9 Apr 2021 11:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617968966;
        bh=wSgw8vqxkTcKSyPgvD8ke8joz3MElmiOLTRjt10EyxQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r257Sg1OggCxGJg5bCTag7NFuCUtM6bBbQPGssOeudpQTueqANF9k8caCST6j+GGs
         mhq+777ZkQwKVhOaru41hweVqSWj04b/XsU8h7+ydnyEF2kONVWjrmWmJI81FX2inh
         1I5q5flBzM6rB5dvZupRSAfvTfk2iRV4KJ8C1mZTY2vPCzbW73c/T7i/07hy3SI8DF
         8mRhhs2yT0V+iCISJxvGjQqPD7ppY2j6k1JTxquPWqltBrBwD9Eqf+usc+F86rClEv
         1sWx6Xv2N6pfdBPoJd3B8urT8gi+vY7QJWCh4h6thPfMXLecWCPm/VUEaLlVYX5ru+
         /QWkr+ISokV9Q==
Received: by earth.universe (Postfix, from userid 1000)
        id 877D23C0C96; Fri,  9 Apr 2021 13:49:24 +0200 (CEST)
Date:   Fri, 9 Apr 2021 13:49:24 +0200
From:   Sebastian Reichel <sre@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Liu <wei.liu@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Mike Rapoport <rppt@kernel.org>,
        Corey Minyard <cminyard@mvista.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Jason J. Herne" <jjherne@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Michael Kelley <mikelley@microsoft.com>,
        Joe Perches <joe@perches.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Scott Branden <scott.branden@broadcom.com>,
        Olof Johansson <olof@lixom.net>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Wang Wenhu <wenhu.wang@vivo.com>,
        Marek Czerski <ma.czerski@gmail.com>,
        Hongbo Yao <yaohongbo@huawei.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-um@lists.infradead.org, linux-hyperv@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-xtensa@linux-xtensa.org,
        openipmi-developer@lists.sourceforge.net,
        linux-clk@vger.kernel.org, linux-edac@vger.kernel.org,
        coresight@lists.linaro.org, linux-leds@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-staging@lists.linux.dev, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-arch@vger.kernel.org,
        kexec@lists.infradead.org, rcu@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>, Alex Elder <elder@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Jens Frederich <jfrederich@gmail.com>,
        Daniel Drake <dsd@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH v2 1/1] kernel.h: Split out panic and oops helpers
Message-ID: <20210409114924.6dpefx26px7aeuaj@earth.universe>
References: <20210409100250.25922-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="c2qg5eip4k7clkwy"
Content-Disposition: inline
In-Reply-To: <20210409100250.25922-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--c2qg5eip4k7clkwy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 09, 2021 at 01:02:50PM +0300, Andy Shevchenko wrote:
> kernel.h is being used as a dump for all kinds of stuff for a long time.
> Here is the attempt to start cleaning it up by splitting out panic and
> oops helpers.
>=20
> There are several purposes of doing this:
> - dropping dependency in bug.h
> - dropping a loop by moving out panic_notifier.h
> - unload kernel.h from something which has its own domain
>=20
> At the same time convert users tree-wide to use new headers, although
> for the time being include new header back to kernel.h to avoid twisted
> indirected includes for existing users.
>=20
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Acked-by: Mike Rapoport <rppt@linux.ibm.com>
> Acked-by: Corey Minyard <cminyard@mvista.com>
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Kees Cook <keescook@chromium.org>
> Acked-by: Wei Liu <wei.liu@kernel.org>
> Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> v2:
>  - fixed all errors with allmodconfig on x86_64 (Andrew)
>  - checked with allyesconfig on x86_64
>  - additionally grepped source code for panic notifier list usage
>    and converted all users
>  - elaborated commit message (Luis)
>  - collected given tags (incl. Andrew's SoB, see below)
>=20
> I added Andrew's SoB since part of the fixes I took from him. Andrew,
> feel free to amend or tell me how you want me to do.
>=20
> [...]
>  drivers/power/reset/ltc2952-poweroff.c        |  1 +
> [...]

Acked-by: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--c2qg5eip4k7clkwy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmBwPzkACgkQ2O7X88g7
+poVqw//cO5+glgFxA2CU4t3EHFTzSR2pExNCOensIzn/2YcvKlq6RBiaVlO87al
zfq//z42WEWWRFkl4NeyjJx6ueQGo5Hk7qQiPRQhgt55UiQsizdAFXK4u97lVQ68
7V2xDT3MlQ/vc+LG3vZBcSGMIoupHDqbYU2kF8xlBhdwuF1lr44NDxRTRsVErgor
hlvEGYmwSTIg8aEkLt6Da/elDscG08MDU+vv6KLaSiruCN+RtgZGin9gv3Xu+KUi
PhPU9ZOAfi6duIQdKmdXiAZ8Vlp/43yzeo80t/XUyiEy7Yq+qtsP6YXHlSWlPJnV
Zz3ifkmNn7YFWd+iOeTe3oTfVIAtg4w/uX184urC+t242MBSeqEkHt7/1TJR2UAx
8s9NtSaCLUPuFLPO9s8t6nP4kQ4HN3BoxMvgessqguLZtSg3n1Z4+ZE8veoYHQD3
Vwz58nFLYkMxRB/pFq6dkXv6uPXTbreYkWuUFsDIao2+FVDkMp81DqE86K2li2d6
/B6jSmObDmG/aryJn+hoHhCEJSfLnaszENAc0toFvCGYU9D5Com1A74gdztMgOvf
CB4G04azFTgeTjX5JB6r7KXrcZ08bzspk/lo5H9fx+SLki6gFb88zNqBOLcnMM0d
FZFNMmZ543wUtAsJSxqObtKeAcjitPcaURrh6sWiRuJkndGtmNY=
=QA06
-----END PGP SIGNATURE-----

--c2qg5eip4k7clkwy--
