Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7983C3DEFDF
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236477AbhHCOQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbhHCOQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:16:48 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3671AC061757;
        Tue,  3 Aug 2021 07:16:37 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628000193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Qkfc7lxCqn4p3B20wjfjiLsyLpuZIa2kIlbDitBY8sw=;
        b=fStBYY9cDOofnMkMc6JUcZVYcNWx/eg2N05Pb/o7ef6JJTcTG48t+GioJgBl+eXKMJGEgi
        TVCeDR+EwHJjgdulnpLwVy12sseYnaixefw5o14vk+2PAOm/LUlJHLssIOZ+nJyuRxaM3r
        fCCG5ZeBAdz/Q3kIzOJQstWW7ST+mFehWQwEJk+hKZizcoepZD/zOgz+f7GO7oZ2MtK2DY
        wm7slubFVtLqvtY6o7cEl9ZIw3mvJ35go7HuaiPxyi+ESejsT+e0qaP6D0Fis4EUqsKcRu
        JGNGT0BYA9PAUGHVfsb3cVOtZwFCr59O6V6ObVy+T4OF395mknhLgwpLJFiGUg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628000193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Qkfc7lxCqn4p3B20wjfjiLsyLpuZIa2kIlbDitBY8sw=;
        b=pGmFmcj1u+vX59p9gWCClfCslb9a1WxY2Pwa8q+HwkfzdAY6X/r9JgYaxIXaCJOpPNDW2W
        rceMZSe2cSwuwVDA==
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Amit Kucheria <amitk@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Segall <bsegall@google.com>,
        Borislav Petkov <bp@alien8.de>, cgroups@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        coresight@lists.linaro.org,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "David S. Miller" <davem@davemloft.net>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gonglei <arei.gonglei@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Jean Delvare <jdelvare@suse.com>,
        Jiri Kosina <jikos@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        John Stultz <john.stultz@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Karol Herbst <karolherbst@gmail.com>,
        Karsten Graul <kgraul@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>,
        Leo Yan <leo.yan@linaro.org>, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, live-patching@vger.kernel.org,
        Mark Gross <mgross@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mel Gorman <mgorman@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Mike Leach <mike.leach@linaro.org>,
        Mike Travis <mike.travis@hpe.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>, netdev@vger.kernel.org,
        nouveau@lists.freedesktop.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
        Pekka Paalanen <ppaalanen@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        platform-driver-x86@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, rcu@vger.kernel.org,
        Robin Holt <robinmholt@gmail.com>, Song Liu <song@kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steve Wahl <steve.wahl@hpe.com>,
        Stuart Hayes <stuart.w.hayes@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Tejun Heo <tj@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Tony Luck <tony.luck@intel.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        Zefan Li <lizefan.x@bytedance.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 00/38] Replace deprecated CPU-hotplug
Date:   Tue,  3 Aug 2021 16:15:43 +0200
Message-Id: <20210803141621.780504-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a tree wide replacement of the deprecated CPU hotplug functions
which are only wrappers around the actual functions.

Each patch is independent and can be picked up by the relevant maintainer.

Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Amit Kucheria <amitk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: cgroups@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: coresight@lists.linaro.org
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Gonglei <arei.gonglei@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Julian Wiedmann <jwi@linux.ibm.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Karol Herbst <karolherbst@gmail.com>
Cc: Karsten Graul <kgraul@linux.ibm.com>
Cc: kvm-ppc@vger.kernel.org
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-edac@vger.kernel.org
Cc: linux-hwmon@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-pm@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-raid@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: live-patching@vger.kernel.org
Cc: Mark Gross <mgross@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Mike Travis <mike.travis@hpe.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: netdev@vger.kernel.org
Cc: nouveau@lists.freedesktop.org
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Pekka Paalanen <ppaalanen@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: platform-driver-x86@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: rcu@vger.kernel.org
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Song Liu <song@kernel.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Steve Wahl <steve.wahl@hpe.com>
Cc: Stuart Hayes <stuart.w.hayes@gmail.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: virtualization@lists.linux-foundation.org
Cc: x86@kernel.org
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Zhang Rui <rui.zhang@intel.com>

Sebastian

