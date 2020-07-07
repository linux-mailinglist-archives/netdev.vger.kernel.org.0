Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6502175B3
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 19:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgGGR4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 13:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbgGGR4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 13:56:45 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4EAC061755;
        Tue,  7 Jul 2020 10:56:44 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f5so35131398ljj.10;
        Tue, 07 Jul 2020 10:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=s4ASXWRqt7B/fSAjfNTkmF4ncRZJGdBqXXpHtUFPDvo=;
        b=cjrGDumGQU3hV8ADB/oAZCirX/i/FhVQU5lKQsB0f/MDCsKCseSYWqK24HlxflKOVx
         +IG7hETH2Oblm1REM1sEdqbMbIX+KjgtpSYbL5Y98EgLoRH27rH+27Wju09vgKZmFBGa
         h1j9WgnSL/C3S6Tjt4v4i9CqMU+sLfkrGbhI+OH1iMrFgLr8NEsWzGS6m27O6J6KRIkc
         Mz7bw9sY0wuL2C7hgK85eW3Ssw9GTEuS9vtl0fSqJPnXqWlYmiSHC5ltaATcBkPExdox
         aKONdLMytbYHlSCCQzcbQYMgraPFp51rsWQ8xo8cHs7qvONZANvhvwwBKr45Jfp0dnHe
         k3WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=s4ASXWRqt7B/fSAjfNTkmF4ncRZJGdBqXXpHtUFPDvo=;
        b=qpmldu8d99ztwdwsJPnYqjfuSSMR7X+4kN1bN/DnMMSwUAYHOnf3K8mYn2hheK56yh
         cPijYwJ58ESPRt3Ew1ePIHkMggyPSM8rjxX65pcciRDxcCpfcoYAPcTLqxPCAhTCLlWP
         7VQNPsHywmKaFz5IbwfL5yNO5ZmFesfEA5FQ7NbtVNEb2vboFcl2J3kuKL37ydXf5ZiE
         smGbE195Kw/G6F24Xhk8GgcxGFEGgDj7hFhlHf+V8leLyOSIz0AgyIc8hjBLg1pTnWuy
         G61DhJOUC6NUBSmN+9E0+p5VvcD0ePrG6IegYdZncCSb52C4ZT0Hkx7pwML+2oSUvLDp
         +xzA==
X-Gm-Message-State: AOAM533NVed1EWhc853iTZYSe7waX0EY7rtOfXvSXYPh++R1TvxWWvDy
        5UUdI23FZhfovcdKQ+g82e0=
X-Google-Smtp-Source: ABdhPJw9ocGXnFi3OkjyF7UUNhB8Fz5ZxAaswtgQ/mqjKfTsB4+vMoKofcU3MPsuwHA1dS8/wyKACw==
X-Received: by 2002:a2e:9316:: with SMTP id e22mr29068635ljh.393.1594144603196;
        Tue, 07 Jul 2020 10:56:43 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id k11sm307187ljg.37.2020.07.07.10.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 10:56:42 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH  3/5] net: fec: initialize clock with 0 rather than
 current kernel time
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200706142616.25192-4-sorganov@gmail.com>
        <20200706152721.3j54m73bm673zlnj@skbuf> <874kqksdrb.fsf@osv.gnss.ru>
        <20200707063651.zpt6bblizo5r3kir@skbuf> <87sge371hv.fsf@osv.gnss.ru>
        <20200707164329.pm4p73nzbsda3sfv@skbuf> <87sge345ho.fsf@osv.gnss.ru>
        <20200707171233.et6zrwfqq7fddz2r@skbuf>
Date:   Tue, 07 Jul 2020 20:56:41 +0300
In-Reply-To: <20200707171233.et6zrwfqq7fddz2r@skbuf> (Vladimir Oltean's
        message of "Tue, 7 Jul 2020 20:12:33 +0300")
Message-ID: <87zh8b1a5i.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> On Tue, Jul 07, 2020 at 08:09:07PM +0300, Sergey Organov wrote:
>> Vladimir Oltean <olteanv@gmail.com> writes:
>> 
>> > On Tue, Jul 07, 2020 at 07:07:08PM +0300, Sergey Organov wrote:
>> >> Vladimir Oltean <olteanv@gmail.com> writes:
>> >> >
>> >> > What do you mean 'no ticking', and what do you mean by 'non-initialized
>> >> > clock' exactly? I don't know if the fec driver is special in any way, do
>> >> > you mean that multiple runs of $(phc_ctl /dev/ptp0 get) from user space
>> >> > all return 0? That is not at all what is to be expected, I think. The
>> >> > PHC is always ticking. Its time is increasing.
>> >> 
>> >> That's how it is right now. My point is that it likely shouldn't. Why is
>> >> it ticking when nobody needs it? Does it draw more power due to that?
>> >> 
>> >> > What would be that initialization procedure that makes it tick, and
>> >> > who is doing it (and when)?
>> >> 
>> >> The user space code that cares, obviously. Most probably some PTP stack
>> >> daemon. I'd say that any set clock time ioctl() should start the clock,
>> >> or yet another ioctl() that enables/disables the clock, whatever.
>> >> 
>> >
>> > That ioctl doesn't exist, at least not in PTP land. This also addresses
>> > your previous point.
>> 
>> struct timespec ts;
>> ...
>> clock_settime(clkid, &ts)
>> 
>> That's the starting point of my own code, and I bet it's there in PTP
>> for Linux, as well as in PTPD, as I fail to see how it could possibly
>> work without it.
>> 
>
> This won't stop it from ticking, which is what we were talking about,
> will it?

It won't. Supposedly it'd force clock (that doesn't tick by default and
stays at 0) to start ticking.

If the ability to stop the clock is in fact useful (I don't immediately
see how it could), and how to do it if it is, is a separate issue. I'd
then expect clock_stop(clkid), or clock_settime(clkid, NULL) to do the
job.

Thanks,
-- Sergey
