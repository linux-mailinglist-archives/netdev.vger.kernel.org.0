Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D503F1EED68
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 23:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgFDVjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 17:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgFDVjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 17:39:18 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19851C08C5C0;
        Thu,  4 Jun 2020 14:39:18 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jgxZr-0001Jg-Vu; Thu, 04 Jun 2020 23:39:08 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id E240BFFBE0; Thu,  4 Jun 2020 23:39:05 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mm@kvack.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 01/10] x86/mm/numa: Remove uninitialized_var() usage
In-Reply-To: <202006040728.8797FAA4@keescook>
References: <20200603233203.1695403-2-keescook@chromium.org> <874krr8dps.fsf@nanos.tec.linutronix.de> <202006040728.8797FAA4@keescook>
Date:   Thu, 04 Jun 2020 23:39:05 +0200
Message-ID: <87zh9i7bpi.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
>> > -#define NODE_NOT_IN_PAGE_FLAGS
>> > +#define NODE_NOT_IN_PAGE_FLAGS 1
>> 
>> but if we ever lose the 1 then the above will silently compile the code
>> within the IS_ENABLED() section out.
>
> That's true, yes. I considered two other ways to do this:
>
> 1) smallest patch, but more #ifdef:
> 2) medium size, weird style:
>
> and 3 is what I sent: biggest, but removes #ifdef
>
> Any preference?

From a readbility POV I surely prefer #3. i"m just wary. Add a big fat
comment to the define might mitigate that, hmm?

Thanks,

        tglx
