Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2CA40CBBB
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 19:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhIORbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 13:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhIORbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 13:31:14 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D56C061575
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 10:29:54 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id t10so1928958lfd.8
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 10:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4S1PpO9lSJ1Wd14e9W10Q5srPqp9E33rs5In3v8xrMY=;
        b=GTLjtWThlHkBmvJjm7fPtNRGZxgG1v/Ezlyl1qwawF4nFPPPbOtQ38afgqOVBZkE9Y
         7BDnKe0sdvrriLk4V8cb/oLDj/udRmTmayzUQt6So8TH/irylPIXxXu6E9fHTjZYPYaN
         IdE+pLbFBQROltsNzEuDKruLxoC3GW+Q6cyk4guzFwalIahADOK4YPb9hUCGfO8saH1i
         ybSSoolKqzU0dbbqlUQ2P9qdok/lNf6yhE9RK0PMimnlfTW9x1E4XOLE3MRau2aSJSQ8
         mE9wbSu2cvh3c5grzm6RUiHC+E8h94cfbYQoCoiHB0q5rpnCj6bsKjtEPPpQ2DMzddSY
         6ktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4S1PpO9lSJ1Wd14e9W10Q5srPqp9E33rs5In3v8xrMY=;
        b=w09yR3u5WQ0yuBk9Oo9OhzjKNCsHqMfTRaZIlcU+cc7PsyIo/Fipk4IeXNgrj3trnY
         /PFTq25SgQWlsDqQt9ZsjY3fEJzKNpg+m+H+kHicxH5S2V6tVQLj9lYKcLgfjGRwf6Cc
         SbsZwqfy+paUwBhf25Fk6+WLzlc+YbPobNQTynk8qa3djgE+1iVIOeCr16Zbzb1SpAzO
         R/NOyEVMX2GAYkbeiAdFzBSB/okqqeYXQMC+gR18Zk332GbiVbEFjXVFla7UJmhvsbES
         U+kzwuYieo3Asy07FlupThmeOnWMZz0L7Fgzr0trAoRbjaoF8syDOBPUjk4U7TW4W5lp
         fo2Q==
X-Gm-Message-State: AOAM530Ehz7Wge8LEC2waVU5vsmhVLk37N71uY+RvfAvhOzUpYMbQPH2
        zfyb3o4UZee4sSfh09ToBLUxdOH3DzXqDXJwI5Lcbg==
X-Google-Smtp-Source: ABdhPJxPv77SBv93nfxD287C8pPVAUUQThYvtWfSSSEj45L4OF4d5Q4/3ayV/E7681T6fn+NKeJmv3OgU8eFhDY/51s=
X-Received: by 2002:a05:6512:3ba0:: with SMTP id g32mr805734lfv.216.1631726992841;
 Wed, 15 Sep 2021 10:29:52 -0700 (PDT)
MIME-Version: 1.0
References: <a507efa7-066b-decf-8605-89cdb0ac1951.ref@schaufler-ca.com>
 <a507efa7-066b-decf-8605-89cdb0ac1951@schaufler-ca.com> <CAHC9VhR9SKX_-SAmtcCj+vuUvcdq-SWzKs86BKMjBcC8GhJ1gg@mail.gmail.com>
 <dd58bbf5-7983-ca26-c335-6bf8e492fcaa@schaufler-ca.com>
In-Reply-To: <dd58bbf5-7983-ca26-c335-6bf8e492fcaa@schaufler-ca.com>
From:   "Jiang Wang ." <jiang.wang@bytedance.com>
Date:   Wed, 15 Sep 2021 10:29:42 -0700
Message-ID: <CAP_N_Z8CWhpCDyyQAwM4hkEw0P_6DYTAUMtwKU4zp0+oSb+Mtw@mail.gmail.com>
Subject: Re: Re: Regression in unix stream sockets with the Smack LSM
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Casey,

Thanks for the detailed report.  I will check what causes the read to fail.

Regards,

Jiang

On Wed, Sep 15, 2021 at 9:52 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> On 9/13/2021 4:47 PM, Paul Moore wrote:
> > On Mon, Sep 13, 2021 at 6:53 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >> Commit 77462de14a43f4d98dbd8de0f5743a4e02450b1d
> >>
> >>         af_unix: Add read_sock for stream socket types
> >>
> >> introduced a regression in UDS socket connections for the Smack LSM.
> >> I have not tracked done the details of why the change broke the code,
> >> but this is where bisecting the kernel indicates the problem lies, and
> >> I have verified that reverting this change repairs the problem.
> >>
> >> You can verify the problem with the Smack test suite:
> >>
> >>         https://github.com/smack-team/smack-testsuite.git
> >>
> >> The failing test is tests/uds-access.sh.
> >>
> >> I have not looked to see if there's a similar problem with SELinux.
> >> There may be, but if there isn't it doesn't matter, there's still a
> >> bug.
> > FWIW, the selinux-testsuite tests ran clean today with v5.15-rc1 (it
> > looks like this code is only in v5.15) but as Casey said, a regression
> > is a regression.
> >
> > Casey, what actually fails on the Smack system with this commit?
>
> This problem occurs with security=none as well as with security=smack.
>
> There isn't a problem with connect, that always works correctly.
> The problem is an unexpected read() failure in the connecting process.
> This doesn't occur all the time, and sometimes happens in the first
> of my two tests, sometimes the second, sometimes neither and, you guessed
> it, sometimes both.
>
> Here's a sample socat log demonstrating the problem. The first run,
> ending at "uds-access RC=0" behaves as expected. The second, ending
> at "uds-access RC=1", demonstrates the read failure. This case was
> run with Smack enabled, but I see the same problem with the same
> unpredictability on the same kernel with security=none.
>
> I've tried to convince myself that there's a flaw in the way I've
> set up the scripts. They've been pretty robust and I've never seen
> socat behaving erratically before. I've instrumented the kernel
> code and all the security checks are behaving as expected. Plus,
> as I mentioned above, the problem also occurs without an LSM.
>
> 2021/09/15 08:49:50 socat[2215] D getpid()
> 2021/09/15 08:49:50 socat[2215] D getpid() -> 2215
> 2021/09/15 08:49:50 socat[2215] D setenv("SOCAT_PID", "2215", 1)
> 2021/09/15 08:49:50 socat[2215] D setenv() -> 0
> 2021/09/15 08:49:50 socat[2215] D setenv("SOCAT_PPID", "2215", 1)
> 2021/09/15 08:49:50 socat[2215] D setenv() -> 0
> 2021/09/15 08:49:50 socat[2215] I socat by Gerhard Rieger and contributors - see www.dest-unreach.org
> 2021/09/15 08:49:50 socat[2215] I This product includes software developed by the OpenSSL Project for use in the OpenSSL Toolkit. (http://www.openssl.org/)
> 2021/09/15 08:49:50 socat[2215] I This product includes software written by Tim Hudson (tjh@cryptsoft.com)
> 2021/09/15 08:49:50 socat[2215] D socat version 1.7.4.1 on Jan 27 2021 00:00:00
> 2021/09/15 08:49:50 socat[2215] D setenv("SOCAT_VERSION", "1.7.4.1", 1)
> 2021/09/15 08:49:50 socat[2215] D setenv() -> 0
> 2021/09/15 08:49:50 socat[2215] D running on Linux version #58 SMP Wed Sep 15 08:40:38 PDT 2021, release 5.15.0-rc1bisect, machine x86_64
>
> 2021/09/15 08:49:50 socat[2215] D argv[0]: "socat"
> 2021/09/15 08:49:50 socat[2215] D argv[1]: "-d"
> 2021/09/15 08:49:50 socat[2215] D argv[2]: "-d"
> 2021/09/15 08:49:50 socat[2215] D argv[3]: "-d"
> 2021/09/15 08:49:50 socat[2215] D argv[4]: "-d"
> 2021/09/15 08:49:50 socat[2215] D argv[5]: "-"
> 2021/09/15 08:49:50 socat[2215] D argv[6]: "UNIX-CONNECT:./targets/uds-notroot/uds-access-socket"
> 2021/09/15 08:49:50 socat[2215] D sigaction(1, 0x7fffaec50b50, 0x0)
> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> 2021/09/15 08:49:50 socat[2215] D sigaction(2, 0x7fffaec50b50, 0x0)
> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> 2021/09/15 08:49:50 socat[2215] D sigaction(3, 0x7fffaec50b50, 0x0)
> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> 2021/09/15 08:49:50 socat[2215] D sigaction(4, 0x7fffaec50b50, 0x0)
> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> 2021/09/15 08:49:50 socat[2215] D sigaction(6, 0x7fffaec50b50, 0x0)
> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> 2021/09/15 08:49:50 socat[2215] D sigaction(7, 0x7fffaec50b50, 0x0)
> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> 2021/09/15 08:49:50 socat[2215] D sigaction(8, 0x7fffaec50b50, 0x0)
> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> 2021/09/15 08:49:50 socat[2215] D sigaction(11, 0x7fffaec50b50, 0x0)
> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> 2021/09/15 08:49:50 socat[2215] D sigaction(15, 0x7fffaec50b50, 0x0)
> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> 2021/09/15 08:49:50 socat[2215] D signal(13, 0x1)
> 2021/09/15 08:49:50 socat[2215] D signal() -> 0x0
> 2021/09/15 08:49:50 socat[2215] D atexit(0x55aa5d645110)
> 2021/09/15 08:49:50 socat[2215] D atexit() -> 0
> 2021/09/15 08:49:50 socat[2215] D xioopen("-")
> 2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
> 2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f0139d0
> 2021/09/15 08:49:50 socat[2215] D malloc(1024)
> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f013d30
> 2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
> 2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f014140
> 2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
> 2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f014bc0
> 2021/09/15 08:49:50 socat[2215] D isatty(0)
> 2021/09/15 08:49:50 socat[2215] D isatty() -> 0
> 2021/09/15 08:49:50 socat[2215] D isatty(1)
> 2021/09/15 08:49:50 socat[2215] D isatty() -> 0
> 2021/09/15 08:49:50 socat[2215] D malloc(128)
> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f014f00
> 2021/09/15 08:49:50 socat[2215] D malloc(128)
> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f014f90
> 2021/09/15 08:49:50 socat[2215] N reading from and writing to stdio
> 2021/09/15 08:49:50 socat[2215] D xioopen("UNIX-CONNECT:./targets/uds-notroot/uds-access-socket")
> 2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
> 2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f015020
> 2021/09/15 08:49:50 socat[2215] D malloc(1024)
> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f015360
> 2021/09/15 08:49:50 socat[2215] D malloc(128)
> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f015770
> 2021/09/15 08:49:50 socat[2215] N opening connection to AF=1 "./targets/uds-notroot/uds-access-socket"
> 2021/09/15 08:49:50 socat[2215] D socket(1, 1, 0)
> 2021/09/15 08:49:50 socat[2215] I socket(1, 1, 0) -> 5
> 2021/09/15 08:49:50 socat[2215] D fcntl(5, 2, 1)
> 2021/09/15 08:49:50 socat[2215] D fcntl() -> 0
> 2021/09/15 08:49:50 socat[2215] D connect(5, {1,AF=1 "./targets/uds-notroot/uds-access-socket"}, 41)
> 2021/09/15 08:49:50 socat[2215] D connect() -> 0
> 2021/09/15 08:49:50 socat[2215] D getsockname(5, 0x7fffaec50580, 0x7fffaec50564{112})
> 2021/09/15 08:49:50 socat[2215] D getsockname(, {AF=1 "<anon>"}, {2}) -> 0
> 2021/09/15 08:49:50 socat[2215] N successfully connected from local address AF=1 "uds-notroot/ud\xEE\xEE\xEE\xEEcess-socket")\n"
> 2021/09/15 08:49:50 socat[2215] I resolved and opened all sock addresses
> 2021/09/15 08:49:50 socat[2215] D posix_memalign(0x7fffaec50b28, 4096, 16385)
> 2021/09/15 08:49:50 socat[2215] D posix_memalign(...) -> 0
> 2021/09/15 08:49:50 socat[2215] N starting data transfer loop with FDs [0,1] and [5,5]
> 2021/09/15 08:49:50 socat[2215] D data loop: sock1->eof=0, sock2->eof=0, closing=0, wasaction=1, total_to={0.000000}
> 2021/09/15 08:49:50 socat[2215] D select(6, &0x21, &0x22, &0x0, NULL/0.000000)
> 2021/09/15 08:49:50 socat[2215] D select -> (, 0x21, 0x22, 0x0, NULL/0.000000), 4
> 2021/09/15 08:49:50 socat[2215] D read(0, 0x55aa5f016000, 8192)
> 2021/09/15 08:49:50 socat[2215] D read -> 4
> 2021/09/15 08:49:50 socat[2215] D write(5, 0x55aa5f016000, 4)
> Pop
> 2021/09/15 08:49:50 socat[2215] D write -> 4
> 2021/09/15 08:49:50 socat[2215] I transferred 4 bytes from 0 to 5
> 2021/09/15 08:49:50 socat[2215] D read(5, 0x55aa5f016000, 8192)
> 2021/09/15 08:49:50 socat[2215] D read -> 4
> 2021/09/15 08:49:50 socat[2215] D write(1, 0x55aa5f016000, 4)
> Pop
> 2021/09/15 08:49:50 socat[2215] D write -> 4
> 2021/09/15 08:49:50 socat[2215] I transferred 4 bytes from 5 to 1
> 2021/09/15 08:49:50 socat[2215] D data loop: sock1->eof=0, sock2->eof=0, closing=0, wasaction=1, total_to={0.000000}
> 2021/09/15 08:49:50 socat[2215] D select(6, &0x21, &0x22, &0x0, NULL/0.000000)
> 2021/09/15 08:49:50 socat[2215] D select -> (, 0x21, 0x22, 0x0, NULL/0.000000), 4
> 2021/09/15 08:49:50 socat[2215] D read(0, 0x55aa5f016000, 8192)
> 2021/09/15 08:49:50 socat[2215] D read -> 0
> 2021/09/15 08:49:50 socat[2215] D read(5, 0x55aa5f016000, 8192)
> 2021/09/15 08:49:50 socat[2215] D read -> 0
> 2021/09/15 08:49:50 socat[2215] N socket 1 (fd 0) is at EOF
> 2021/09/15 08:49:50 socat[2215] I shutdown(5, 1)
> 2021/09/15 08:49:50 socat[2215] D shutdown()  -> 0
> 2021/09/15 08:49:50 socat[2215] N socket 2 (fd 5) is at EOF
> 2021/09/15 08:49:50 socat[2215] I shutdown(5, 2)
> 2021/09/15 08:49:50 socat[2215] D shutdown()  -> 0
> 2021/09/15 08:49:50 socat[2215] N exiting with status 0
> 2021/09/15 08:49:50 socat[2215] D exit(0)
> 2021/09/15 08:49:50 socat[2215] D starting xioexit()
> 2021/09/15 08:49:50 socat[2215] D finished xioexit()
> uds-access RC=0
> 2021/09/15 08:49:52 socat[2240] D getpid()
> 2021/09/15 08:49:52 socat[2240] D getpid() -> 2240
> 2021/09/15 08:49:52 socat[2240] D setenv("SOCAT_PID", "2240", 1)
> 2021/09/15 08:49:52 socat[2240] D setenv() -> 0
> 2021/09/15 08:49:52 socat[2240] D setenv("SOCAT_PPID", "2240", 1)
> 2021/09/15 08:49:52 socat[2240] D setenv() -> 0
> 2021/09/15 08:49:52 socat[2240] I socat by Gerhard Rieger and contributors - see www.dest-unreach.org
> 2021/09/15 08:49:52 socat[2240] I This product includes software developed by the OpenSSL Project for use in the OpenSSL Toolkit. (http://www.openssl.org/)
> 2021/09/15 08:49:52 socat[2240] I This product includes software written by Tim Hudson (tjh@cryptsoft.com)
> 2021/09/15 08:49:52 socat[2240] D socat version 1.7.4.1 on Jan 27 2021 00:00:00
> 2021/09/15 08:49:52 socat[2240] D setenv("SOCAT_VERSION", "1.7.4.1", 1)
> 2021/09/15 08:49:52 socat[2240] D setenv() -> 0
> 2021/09/15 08:49:52 socat[2240] D running on Linux version #58 SMP Wed Sep 15 08:40:38 PDT 2021, release 5.15.0-rc1bisect, machine x86_64
>
> 2021/09/15 08:49:52 socat[2240] D argv[0]: "socat"
> 2021/09/15 08:49:52 socat[2240] D argv[1]: "-d"
> 2021/09/15 08:49:52 socat[2240] D argv[2]: "-d"
> 2021/09/15 08:49:52 socat[2240] D argv[3]: "-d"
> 2021/09/15 08:49:52 socat[2240] D argv[4]: "-d"
> 2021/09/15 08:49:52 socat[2240] D argv[5]: "-"
> 2021/09/15 08:49:52 socat[2240] D argv[6]: "UNIX-CONNECT:./targets/uds-notroot/uds-access-socket"
> 2021/09/15 08:49:52 socat[2240] D sigaction(1, 0x7ffcca7e26c0, 0x0)
> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> 2021/09/15 08:49:52 socat[2240] D sigaction(2, 0x7ffcca7e26c0, 0x0)
> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> 2021/09/15 08:49:52 socat[2240] D sigaction(3, 0x7ffcca7e26c0, 0x0)
> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> 2021/09/15 08:49:52 socat[2240] D sigaction(4, 0x7ffcca7e26c0, 0x0)
> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> 2021/09/15 08:49:52 socat[2240] D sigaction(6, 0x7ffcca7e26c0, 0x0)
> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> 2021/09/15 08:49:52 socat[2240] D sigaction(7, 0x7ffcca7e26c0, 0x0)
> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> 2021/09/15 08:49:52 socat[2240] D sigaction(8, 0x7ffcca7e26c0, 0x0)
> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> 2021/09/15 08:49:52 socat[2240] D sigaction(11, 0x7ffcca7e26c0, 0x0)
> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> 2021/09/15 08:49:52 socat[2240] D sigaction(15, 0x7ffcca7e26c0, 0x0)
> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> 2021/09/15 08:49:52 socat[2240] D signal(13, 0x1)
> 2021/09/15 08:49:52 socat[2240] D signal() -> 0x0
> 2021/09/15 08:49:52 socat[2240] D atexit(0x560590a15110)
> 2021/09/15 08:49:52 socat[2240] D atexit() -> 0
> 2021/09/15 08:49:52 socat[2240] D xioopen("-")
> 2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
> 2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e899d0
> 2021/09/15 08:49:52 socat[2240] D malloc(1024)
> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e89d30
> 2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
> 2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e8a140
> 2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
> 2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e8abc0
> 2021/09/15 08:49:52 socat[2240] D isatty(0)
> 2021/09/15 08:49:52 socat[2240] D isatty() -> 0
> 2021/09/15 08:49:52 socat[2240] D isatty(1)
> 2021/09/15 08:49:52 socat[2240] D isatty() -> 0
> 2021/09/15 08:49:52 socat[2240] D malloc(128)
> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8af00
> 2021/09/15 08:49:52 socat[2240] D malloc(128)
> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8af90
> 2021/09/15 08:49:52 socat[2240] N reading from and writing to stdio
> 2021/09/15 08:49:52 socat[2240] D xioopen("UNIX-CONNECT:./targets/uds-notroot/uds-access-socket")
> 2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
> 2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e8b020
> 2021/09/15 08:49:52 socat[2240] D malloc(1024)
> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8b360
> 2021/09/15 08:49:52 socat[2240] D malloc(128)
> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8b770
> 2021/09/15 08:49:52 socat[2240] N opening connection to AF=1 "./targets/uds-notroot/uds-access-socket"
> 2021/09/15 08:49:52 socat[2240] D socket(1, 1, 0)
> 2021/09/15 08:49:52 socat[2240] I socket(1, 1, 0) -> 5
> 2021/09/15 08:49:52 socat[2240] D fcntl(5, 2, 1)
> 2021/09/15 08:49:52 socat[2240] D fcntl() -> 0
> 2021/09/15 08:49:52 socat[2240] D connect(5, {1,AF=1 "./targets/uds-notroot/uds-access-socket"}, 41)
> 2021/09/15 08:49:52 socat[2240] D connect() -> 0
> 2021/09/15 08:49:52 socat[2240] D getsockname(5, 0x7ffcca7e20f0, 0x7ffcca7e20d4{112})
> 2021/09/15 08:49:52 socat[2240] D getsockname(, {AF=1 "<anon>"}, {2}) -> 0
> 2021/09/15 08:49:52 socat[2240] N successfully connected from local address AF=1 "uds-notroot/ud\xEE\xEE\xEE\xEEcess-socket")\n"
> 2021/09/15 08:49:52 socat[2240] I resolved and opened all sock addresses
> 2021/09/15 08:49:52 socat[2240] D posix_memalign(0x7ffcca7e2698, 4096, 16385)
> 2021/09/15 08:49:52 socat[2240] D posix_memalign(...) -> 0
> 2021/09/15 08:49:52 socat[2240] N starting data transfer loop with FDs [0,1] and [5,5]
> 2021/09/15 08:49:52 socat[2240] D data loop: sock1->eof=0, sock2->eof=0, closing=0, wasaction=1, total_to={0.000000}
> 2021/09/15 08:49:52 socat[2240] D select(6, &0x21, &0x22, &0x0, NULL/0.000000)
> 2021/09/15 08:49:52 socat[2240] D select -> (, 0x1, 0x22, 0x0, NULL/0.000000), 3
> 2021/09/15 08:49:52 socat[2240] D read(0, 0x560591e8c000, 8192)
> 2021/09/15 08:49:52 socat[2240] D read -> 5
> 2021/09/15 08:49:52 socat[2240] D write(5, 0x560591e8c000, 5)
> 2021/09/15 08:49:52 socat[2240] D write -> 5
> 2021/09/15 08:49:52 socat[2240] I transferred 5 bytes from 0 to 5
> 2021/09/15 08:49:52 socat[2240] D data loop: sock1->eof=0, sock2->eof=0, closing=0, wasaction=1, total_to={0.000000}
> 2021/09/15 08:49:52 socat[2240] D select(6, &0x21, &0x20, &0x0, NULL/0.000000)
> 2021/09/15 08:49:52 socat[2240] D select -> (, 0x1, 0x20, 0x0, NULL/0.000000), 2
> 2021/09/15 08:49:52 socat[2240] D read(0, 0x560591e8c000, 8192)
> 2021/09/15 08:49:52 socat[2240] D read -> 0
> 2021/09/15 08:49:52 socat[2240] N socket 1 (fd 0) is at EOF
> 2021/09/15 08:49:52 socat[2240] I shutdown(5, 1)
> 2021/09/15 08:49:52 socat[2240] D shutdown()  -> 0
> 2021/09/15 08:49:52 socat[2240] D data loop: sock1->eof=3, sock2->eof=0, closing=1, wasaction=1, total_to={0.000000}
> 2021/09/15 08:49:52 socat[2240] D select(6, &0x20, &0x0, &0x0, &0.500000)
> Snap
> 2021/09/15 08:49:52 socat[2240] D select -> (, 0x20, 0x0, 0x0, &0.500000), 1
> 2021/09/15 08:49:52 socat[2240] D read(5, 0x560591e8c000, 8192)
> 2021/09/15 08:49:52 socat[2240] D read -> -1
> 2021/09/15 08:49:52 socat[2240] E read(5, 0x560591e8c000, 8192): Invalid argument
> 2021/09/15 08:49:52 socat[2240] N exit(1)
> 2021/09/15 08:49:52 socat[2240] D starting xioexit()
> 2021/09/15 08:49:52 socat[2240] I shutdown(5, 2)
> 2021/09/15 08:49:52 socat[2240] D shutdown()  -> 0
> 2021/09/15 08:49:52 socat[2240] D finished xioexit()
> uds-access RC=1
>
>
>
>
