Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973433DF18A
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbhHCPbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:31:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236868AbhHCPa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628004645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ef5H/YzWjPRhpmEEex0YbOyxkXYC0ZJIajn0GIxKBlE=;
        b=Ge5aL2LJYyL7SFUN4/8+uzVsGUyeqEYdDDb48hSvxnjfaSV82T+lIm94FU1RWi9k4TmkFi
        Cs8tbhGOKi50b6b+XPumM34mHUbCBvRQ2i7U9Zg/fQuoHjG5K2Bb7Wurot1WjYUL9jGlRW
        00bOvdsFE1cOQxZqw/DPYEXJd+bACuA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-ojMoIMsQNmKHeidaRhUeLw-1; Tue, 03 Aug 2021 11:30:44 -0400
X-MC-Unique: ojMoIMsQNmKHeidaRhUeLw-1
Received: by mail-ed1-f71.google.com with SMTP id b13-20020a056402278db029039c013d5b80so10672150ede.7
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 08:30:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ef5H/YzWjPRhpmEEex0YbOyxkXYC0ZJIajn0GIxKBlE=;
        b=COnysyqs4xbEb22KRTphYaf6nO/rclaHoHsyDCEase3a4t5gt+ZQ32vC2JiJbHkKBi
         jXnN+x1ICBAX1xdWyytEwPNkd/F6HcOBWXfRgJKZEZUq/yf33QnymTskf6XCDYzt0A6z
         LhlJIDVIMqcNVR9oTfl/Il+2q8xN9EN4kTT1ePeFg2bQiqjhpcy5/pGrLqYMu7AZjpju
         zvA6k6xa0OsYLM0XHOuPSszfO/mpPDCqT3XsJCVX/gtSv1bktHlv3+Wt1u7pD+6arBXs
         OvtLyDhOOj0YwqS2mXcwTsr2dm9Oh10hsZVpbJ9pRiFsnG92vPErdlrv3cRYomiFkqdi
         RlWg==
X-Gm-Message-State: AOAM531gC1LbvZQ2unkl2TMO+YBYAX8lNXSPouBt3qFjXdRXf+W9eizn
        DhD2t0nQhox1e+osrBMtjK5fb5ORQS3NZPrVgDDnJlYcXNfG9fF8fnKJ62G7DoFZl29A5fCQsgW
        pWYJXHRWFLlXIsxkX
X-Received: by 2002:a17:906:1da1:: with SMTP id u1mr20660408ejh.307.1628004643324;
        Tue, 03 Aug 2021 08:30:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxf6rV1ZatT2GQ6a3+XcXIUCr6rut+vBVs6RfI7E2ACDBMkrHwlwXE3OZTZ7a4m4dn8RViNBQ==
X-Received: by 2002:a17:906:1da1:: with SMTP id u1mr20660382ejh.307.1628004643075;
        Tue, 03 Aug 2021 08:30:43 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id b17sm4094598edd.27.2021.08.03.08.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 08:30:42 -0700 (PDT)
Subject: Re: [PATCH 00/38] Replace deprecated CPU-hotplug
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
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
        virtualization@lists.linux-foundation.org, x86@kernel.org
References: <20210803141621.780504-1-bigeasy@linutronix.de>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <83dc5dfd-1ed0-f428-826f-fb819911fc89@redhat.com>
Date:   Tue, 3 Aug 2021 17:30:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210803141621.780504-1-bigeasy@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sebastien,

On 8/3/21 4:15 PM, Sebastian Andrzej Siewior wrote:
> This is a tree wide replacement of the deprecated CPU hotplug functions
> which are only wrappers around the actual functions.
> 
> Each patch is independent and can be picked up by the relevant maintainer.

Ok; and I take it that then also is the plan for merging these ?

FWIW I'm fine with the drivers/platform/x86 patch going upstream
through some other tree if its easier to keep the set together ...

Regards,

Hans



> 
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Amit Kucheria <amitk@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Ben Segall <bsegall@google.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: cgroups@vger.kernel.org
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: coresight@lists.linaro.org
> Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Gonglei <arei.gonglei@huawei.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Jean Delvare <jdelvare@suse.com>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Joe Lawrence <joe.lawrence@redhat.com>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Julian Wiedmann <jwi@linux.ibm.com>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Karol Herbst <karolherbst@gmail.com>
> Cc: Karsten Graul <kgraul@linux.ibm.com>
> Cc: kvm-ppc@vger.kernel.org
> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Leo Yan <leo.yan@linaro.org>
> Cc: linux-acpi@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-edac@vger.kernel.org
> Cc: linux-hwmon@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mips@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-pm@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-raid@vger.kernel.org
> Cc: linux-s390@vger.kernel.org
> Cc: live-patching@vger.kernel.org
> Cc: Mark Gross <mgross@linux.intel.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Mike Leach <mike.leach@linaro.org>
> Cc: Mike Travis <mike.travis@hpe.com>
> Cc: Miroslav Benes <mbenes@suse.cz>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: nouveau@lists.freedesktop.org
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Pekka Paalanen <ppaalanen@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: platform-driver-x86@vger.kernel.org
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: rcu@vger.kernel.org
> Cc: Robin Holt <robinmholt@gmail.com>
> Cc: Song Liu <song@kernel.org>
> Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Steve Wahl <steve.wahl@hpe.com>
> Cc: Stuart Hayes <stuart.w.hayes@gmail.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: virtualization@lists.linux-foundation.org
> Cc: x86@kernel.org
> Cc: Zefan Li <lizefan.x@bytedance.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> 
> Sebastian
> 

