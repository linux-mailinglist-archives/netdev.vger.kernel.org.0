Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77360177A52
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729872AbgCCPXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:23:21 -0500
Received: from mail-pg1-f179.google.com ([209.85.215.179]:41070 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgCCPXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:23:21 -0500
Received: by mail-pg1-f179.google.com with SMTP id b1so1676045pgm.8;
        Tue, 03 Mar 2020 07:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4uMBpBOIqm/0ynEGtQaKGFxamPX39BjBfVI0h30VeRw=;
        b=lkQFBtFY5SssVVeURD1b+Ig/VAaDBsj0Uon3Dc7y1oG1ZR44CH94pHe5BO2M905iPx
         Yr5vf/kJ9rO+zv1cubjBfMmGjCzhvVyuDl3yBJLeXc0IEUHyHOY+XYCYolUX77AnT0Bz
         QOTVu8meED63CJQsVjL4Lw2q7JRfLPlCn9NALSq7Tnxg1r7v2KSY6KXwdUaq3Von/e/w
         zKukd0NWkRpWsCZt2+B0/zZYm//tAZX6kZRWK90xtGczsXK7vR9NAJHlRG12T4+le02B
         u1DFFEvfrhng8x5L8D2sTHRKBbqDzkdY4NGd79kAgvs+7czuO/0VyW+HlHfCjYdEnYmP
         7vwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4uMBpBOIqm/0ynEGtQaKGFxamPX39BjBfVI0h30VeRw=;
        b=hA12Qm+DxxRTeVF8oIkS4/URwvfx1HU8Lcx6Nyg4bSqqP9HKw3LJ2TJub4MNWaKpgf
         dMC/kq3EET3ING9hZ+Is5DOJIqG0fjc+bMXMzOVfB4KuylzVcTZfcFMKnyzx/JeHuf7Y
         gnwyzOC/WFHmeGmcSnHn/i3QzJR6enblpFdmc5c10s9U9Iz6YHfj6SrLwrQenAi0+KPB
         QnFpEJqCXrRGgAXUxWFcOV3GkPATGaqbqX7hB7Sc0Vn8RLsbEZ4+27KmdCgouWnDcQR4
         RYa7bwQhUy4maU4D0zLMdWn0fF8mz33XkH2QxwdfgYb7sLYPvdZ+OWdEu3ELR4v6ql5Y
         yiqg==
X-Gm-Message-State: ANhLgQ0TnGrCw7zRPX5VCcy3p7YZmfZWDpvvIcpd8bQcPoGOlRx6HRO4
        FR2evMah+0dcL9xSCRGfzI4=
X-Google-Smtp-Source: ADFU+vuRN7jJ258kwfeGpP/dSM8ifMkULad01Zm3gSV1dVGJ1Jx7ViJeQWzznpvDUUpJFuukaYibnw==
X-Received: by 2002:a63:3d48:: with SMTP id k69mr4368726pga.395.1583249000145;
        Tue, 03 Mar 2020 07:23:20 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id h65sm2827515pfg.12.2020.03.03.07.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 07:23:19 -0800 (PST)
Date:   Tue, 3 Mar 2020 07:23:17 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jonathan Cameron <jic23@kernel.org>,
        "Christopher S. Hall" <christopher.s.hall@intel.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        jacob.e.keller@intel.com, "David S. Miller" <davem@davemloft.net>,
        Sean V Kelley <sean.v.kelley@intel.com>
Subject: Re: [Intel PMC TGPIO Driver 0/5] Add support for Intel PMC Time GPIO
 Driver with PHC interface changes to support additional H/W Features
Message-ID: <20200303152317.GA7971@localhost>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <87eevf4hnq.fsf@nanos.tec.linutronix.de>
 <20200224224059.GC1508@skl-build>
 <87mu95ne3q.fsf@nanos.tec.linutronix.de>
 <CACRpkdadbWvsnyrH_+sRha2C0fJU0EFEO9UyO7wHybZT-R1jzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdadbWvsnyrH_+sRha2C0fJU0EFEO9UyO7wHybZT-R1jzA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 02:00:48PM +0100, Linus Walleij wrote:
> 
> That looks like something I/we would want to support all the way
> to userspace so people can do their funny industrial stuff in some
> standard manner.

...

> HW timestamps would be something more elaborate and
> nice CLOCK_HW_SPECIFIC or so. Some of the IIO sensors also
> have that, we just don't expose it as of now.

It is worth considering whether it makes sense to somehow unify gpio,
iio, and the phc pin subsystems.  In my view, a big chunk of work
would be to have something like the "clock tree" for gpios and clock
lines.  This tree would describe the HW connectivity between (at
least) MAC/PHY clocks and IOs, gpio controllers, audio/video codecs,
and so on.

Also, there is that comedi thing in staging.  If it has a chance ever
to leave staging, then I think it would also benefit from integration
into gpio/iio world.

Thanks,
Richard


