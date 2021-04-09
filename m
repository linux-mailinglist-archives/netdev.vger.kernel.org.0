Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC8C35A762
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbhDITqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:46:53 -0400
Received: from mout.gmx.net ([212.227.17.20]:39269 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233883AbhDITql (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 15:46:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1617997367;
        bh=iNspAAUXd0TGc9idWuqJezj9FgSbVIrdnHkC34OI6ys=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=ldsXgBGJ3GSKvmbTxvP1itO26Qt3rKVAXa7HCeRwn7x6vvwIVyKAuuWMT/9Mbs/eq
         eUjUvdYyHT2oPnald/g3Raad9aGgTRMlgrGQZ1cKX9WKZtuOkezCA/ZBkxeKHYWicC
         dFguhZZAb4murEW3qrRROxlPjGsI5cEXZ4497eEg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.181.63]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1My36N-1lmD5l41nT-00zVNp; Fri, 09
 Apr 2021 21:42:47 +0200
Subject: Re: [PATCH v2 1/1] kernel.h: Split out panic and oops helpers
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
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
        linux-fsdevel@vger.kernel.org
Cc:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
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
        Sebastian Reichel <sre@kernel.org>,
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
References: <20210409100250.25922-1-andriy.shevchenko@linux.intel.com>
From:   Helge Deller <deller@gmx.de>
Message-ID: <cef5d4ba-9d91-7249-3ba4-c7f1c89ab119@gmx.de>
Date:   Fri, 9 Apr 2021 21:41:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210409100250.25922-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:A9ZHNG4WxpUBFm/OLrSjy4wmvepyAKfJ/9J0GMwZPVvou+WL0jt
 juhLu46u1kS+URbP+8+Pw+p7oQ3JpIMBAMo3AEr85dJ6auKoY3YWnT5NDC8TMlGFgRljwyK
 +Z8x/lMp3a1Sj6G+ejcETzf/1wuAwQ3HVr+B/sOgfO9g9aKIA+KstHHg98r0RbXaN5gO1f1
 c2FCqtclGkoW83386bLAQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QTiAIr1d9DU=:ouDY+zoQbxd0AYwIoqdq7+
 aGg5cjuhFxN4dPlhbUVe4gHa8V6O/ob8/GYNsz48eMGoWdTSBWNdigEx/P3CeG5ajt1K/D1wj
 ZsuimGcNU/JIwDEC4hAa9wiKwplSRt9GyqnNpMymPpOincerI2QNIINtkESpmD/MQtIZKWIBd
 LzLZQt5g5JHyD7KSRX3CSO3kxsUbUK397UnmPrlbBzZiG2Ki8L87whx1HhStGiOawVNU3NX1U
 1qJ/Q2KXhaSRyDrR5JobMbpVJ16dZyIPC+nB+S5uAuxAgE/sFmpim0FlFwngs3hHA1Ua7nKDx
 vaviKH0ZdVtdmwFCmPWXldfwgaGRXmcVHieN8y3Cf4AES1arvvUXfDdU8TlIFPlMWolAfy75b
 aF6Vq+x5W46hFMRh+gkaDVvXSN0IJLemCnzysIaYGHy5hfBua6u7o+npWjwJ1MLna90v6WJqp
 qtsmLRv7qq9JD3rE3mLnbgCeyikpDMiwYezxJc5y085Nda4MocVjIUyHwfrItCcTJy+6nK+32
 QtS5ysQPbZtg/0BLTkwmTgg1C9wyCqJwqSPkJHKs0fedY3Cg4AmlYSUFZ+l1+yWlahYNrwIjD
 1LvXS6jFdPgrwM0Bw5zEn5iTaVsN3Dpg/BK7RBEnkSXG2EhjbG0P5JyU6ZQFlyoWZsOBl1Dnp
 9RlHsz3O6/vJl501tNpFzFkE9v1fbjuJiCnsWIZVHwcbxwgsYWs1VvePFQoqRLQUoGWk7YlQ8
 Mycnfd16TOkM/BTklN35/8ZoVz9X6VjMTLQhDSDUL5LeX75GwKdRnpVjwg+mpqmINujIEDZVj
 bRIcfuM8kM4QXmEUEjmqZoVNDqdo0531mNm3kN19X3Wj5I9ywhlJarAEaPUOs1zKkdzPb4HdC
 +5ul9M6a4WBWbT5U1mKmQOeT0D6MCEGVKv+v/aWQ+A07Sxs9cad/sxt/XXniiusfDTtv1wpHL
 48xz68wHDUi6JHhewqK39v9CUwOqs24U/FOrqR6QogsoMdeib8LB3HQXiJzJhPuxnfQKT5n0E
 2KocVJOLOCpFD00uImKyPG4urooQInY0CgXuaTbgwb2QXtNz/HWsnU7bcGH95t//ETUS0YST/
 HIEC4Jt3JrZiU2K24JZ5uAUtc1tWcvMl+zNPO7uqbferwivk7BjAs0A1bkS3994pg0p9gu7e6
 IGlScHPk65VIaL0560ZSSQDJOn/n987RThMli+dnKucI6xieqz82byl0Okk5UU49D7L5Y=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/21 12:02 PM, Andy Shevchenko wrote:
> kernel.h is being used as a dump for all kinds of stuff for a long time.
> Here is the attempt to start cleaning it up by splitting out panic and
> oops helpers.
>
> There are several purposes of doing this:
> - dropping dependency in bug.h
> - dropping a loop by moving out panic_notifier.h
> - unload kernel.h from something which has its own domain
>
> At the same time convert users tree-wide to use new headers, although
> for the time being include new header back to kernel.h to avoid twisted
> indirected includes for existing users.
>
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

Acked-by: Helge Deller <deller@gmx.de> # parisc

Helge
