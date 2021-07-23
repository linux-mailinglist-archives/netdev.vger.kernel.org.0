Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4E83D3EDA
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhGWQwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:52:23 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:41599 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhGWQwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 12:52:22 -0400
Received: by mail-pl1-f172.google.com with SMTP id e14so3921812plh.8;
        Fri, 23 Jul 2021 10:32:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4Gy1tDqQLfJ9cQoNR0QoqWZQDvrm3bO+ArzHssSxoWo=;
        b=khw0oQvMKFbUQar/p9GoM2IUbIpxDrjK3CxYL+7qX4bRPMm/qufbPpIIfa7cZ87DoL
         jzXeySeH2tDh3s8U7FuPLAgKDapRPN9TepCWMyZUNAkSUDn+5OAxKAYSOxo3tutli+qz
         OjCoLbXkGDiNqzmW0e2JKtB0ye2K43eqf2MDNfczXBwXc3IjvLTTPCGlIVGTVDONflnn
         5qFjuGiIj+A/S6OXGa5tpo9HsuGpn4WU41fLzcXsJi3szJzo/fycWy2QDBiJzxLvB7xp
         hTFsBuB/mNoMwc/AEQw50PY/AyjjPVs8R3FKmKYQG3HCQQwvF2DRhJiSPNkQi/lzeIaf
         v2aQ==
X-Gm-Message-State: AOAM531N7qPJhoCv/au2w00q32+DfnSCIFccOGbAXFnqQcx1OnS0PlPd
        ynt2WFEWbGqGUI2HpFpCT6k=
X-Google-Smtp-Source: ABdhPJzKUmB24ujosMnylQGn9LUgkwy8UQ6nEjLnkyTrVI/rJWclOvSpWnnzX0Yh5poOLDH1PrkbAQ==
X-Received: by 2002:a17:90a:8043:: with SMTP id e3mr3040632pjw.32.1627061574882;
        Fri, 23 Jul 2021 10:32:54 -0700 (PDT)
Received: from garbanzo ([191.96.121.239])
        by smtp.gmail.com with ESMTPSA id q21sm34626650pff.55.2021.07.23.10.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 10:32:53 -0700 (PDT)
Date:   Fri, 23 Jul 2021 10:32:50 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Shuah Khan <skhan@linuxfoundation.org>, tj@kernel.org,
        shuah@kernel.org, akpm@linux-foundation.org, rafael@kernel.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andriin@fb.com, daniel@iogearbox.net, atenart@kernel.org,
        alobakin@pm.me, weiwan@google.com, ap420073@gmail.com,
        jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] selftests: add tests_sysfs module
Message-ID: <20210723173250.u6444kg7a5ktnyiv@garbanzo>
References: <20210703004632.621662-1-mcgrof@kernel.org>
 <20210703004632.621662-2-mcgrof@kernel.org>
 <YPgF2VAoxPIiKWX1@kroah.com>
 <20210722223449.ot5272wpc6o5uzlk@garbanzo>
 <YPqcIzKpEXftpZM8@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPqcIzKpEXftpZM8@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 12:38:27PM +0200, Greg KH wrote:
> On Thu, Jul 22, 2021 at 03:34:49PM -0700, Luis Chamberlain wrote:
> > kunit relies on UML and UML is a simple one core architecture, to start
> > with.
> 
> I thought the UML requirement was long gone, are you sure it is still
> present?

It's *the* way to run kunit.

> > This means I cannot run tests for multicore with it, which is
> > where many races do happen! Yes, you can run kunit on other
> > architectures, but all that is new.
> 
> What do you mean by "new"?  It should work today, in today's kernel
> tree, right?

That was experimental. And I know no one using it.

> > In this case kunit is not ideal given I want to mimic something in
> > userspace interaction, and expose races through error injection and
> > if we can use as many cores to busy races out.
> 
> Can you not do that with kunit?  If not, why not?

kunit requires codifying everything in C, what we need is a lot of
flexibility to do all sorts of races in userspace, and actually use
userspace tools.

I am *not* going to even try to rewrite my selftest as a kunit test.
It is just not going to happen.

  Luis
