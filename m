Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F3D2918AC
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 19:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgJRRml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 13:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgJRRmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 13:42:40 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0ADC061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 10:42:40 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id o70so6893365ybc.1
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 10:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=grEEOjWPHP+ilrKXRPjq0W0VBnmQoooVR3iGQhng0pk=;
        b=k7rbk5lMU3yIhVU5tmDr+JFn9c+vCxB7Ohi+conh47ZdoxjegZ4dPfdGbxp9ZAav93
         /m/C47jOFYh6ccUog3+JVxa6LvsnhC3LaH8cqWdVdJ4BJTkQjjQz5+esdsH07YveMLGl
         zLCFCV76ALECf872PDzVcNe7nM3+3jDceCt4ktfFkcf5MH5uaIg7/rVVglL5QqkctlHV
         5mg5NY3ZRFNuq0lvlr5IK/Eybj6/WG/kjs8uw7Un+ny+b8p/8BzJ41YUtGXeHA9hfcKL
         N+QbevKs7N0KY5wLzWeeXL1CyNPUdyi+7sRn9HvEcXUn82tErCGXd0Ss+Bx4wj6Gcf94
         Maig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=grEEOjWPHP+ilrKXRPjq0W0VBnmQoooVR3iGQhng0pk=;
        b=FZmbUw6yzUuogwo5Fpnc7pGJBkf3MliR4T+Ce65MQHCuusIegYX8u4zh1LJ9UwkS6n
         njXpB1mePXBbvDfvow5+RxWuun7PZLSdi/YlOoHTfs2679FmfNWsaUnMsMOGfm9uJLuH
         pfBpqzfLam6GHxJnTfmq7xPFGiWh57wAfedbR8FAC80AJSARpXkWQOalgmvWixx7bTzb
         nicymExOmZEt8frEm9xERqtfzdgf7Jlcn1T4IX6MaifV/RPcNO8DuJ3ry26AYnRPFYjS
         Uj5WvmRxa68qJJJ2VWGmPNYaIjDdyqf4jtMIHIdNSmStCPrE7dvLxYCY8sRYqT8PpwH5
         BPTA==
X-Gm-Message-State: AOAM531gCtEGLRitGzWRYBxam1HLOszs8jff/pro+F39BANCh3Qw516c
        2mVjFI52z34AECcrocxmDEswN7j/58SH0tZxEfG98Bf604y2FQ==
X-Google-Smtp-Source: ABdhPJwRFuNj6BJBL0tnvJ4Py8ZC6ioRn+pBOBB7z/HMIcujP3DqxkELls/tmu/Y6bsjQKAZfvUEGQXLozQ/m2W6TFw=
X-Received: by 2002:a5b:4d2:: with SMTP id u18mr15689174ybp.56.1603042959495;
 Sun, 18 Oct 2020 10:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ3xEMiOtDe5OeC8oT2NyVu5BEmH_eLgAAH4voLqejWgsvG4xQ@mail.gmail.com>
 <20201015183352.o4zmciukdrdvvdj4@two.firstfloor.org>
In-Reply-To: <20201015183352.o4zmciukdrdvvdj4@two.firstfloor.org>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Sun, 18 Oct 2020 20:42:28 +0300
Message-ID: <CAJ3xEMgKfgbpxzxx595bG=bRM-ETm4vJfWALR3p-wVzzcHxHSw@mail.gmail.com>
Subject: Re: perf measure for stalled cycles per instruction on newer Intel processors
To:     Andi Kleen <andi@firstfloor.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 9:33 PM Andi Kleen <andi@firstfloor.org> wrote:
> On Thu, Oct 15, 2020 at 05:53:40PM +0300, Or Gerlitz wrote:
> > Earlier Intel processors (e.g E5-2650) support the more of classical
> > two stall events (for backend and frontend [1]) and then perf shows
> > the nice measure of stalled cycles per instruction - e.g here where we
> > have IPC of 0.91 and CSPI (see [2]) of 0.68:
>
> Don't use it. It's misleading on a out-of-order CPU because you don't
> know if it's actually limiting anything.
>
> If you want useful bottleneck data use --topdown.

So running again, this time with the below params, I got this output
where all the right most column is colored red. I wonder what can be
said on the amount/ratio of stalls for this app - if you can maybe recommend
some posts of yours to better understand that, I saw some comment in the
perf-stat man page and some lwn article but wasn't really able to figure it out.

FWIW, the kernel is 5.5.7-100.fc30.x86_64 and the CPU E5-2650 0

$ perf stat  --topdown -a  taskset -c 0 $APP

[...]

 Performance counter stats for 'system wide':

                                    retiring      bad speculation
 frontend bound        backend bound
S0-D0-C0           1                24.9%                 1.1%
       16.1%                57.9%
S0-D0-C1           1                16.3%                 1.3%
       17.3%                65.1%
S0-D0-C2           1                17.0%                 1.2%
       15.3%                66.5%
S0-D0-C3           1                18.3%                 0.8%
        8.2%                72.8%
S0-D0-C4           1                18.1%                 0.8%
        8.5%                72.6%
S0-D0-C5           1                17.6%                 0.8%
       10.0%                71.6%
S0-D0-C6           1                18.3%                 0.7%
        7.4%                73.6%
S0-D0-C7           1                15.4%                 1.4%
       22.1%                61.2%
S1-D0-C0           1                15.9%                 1.4%
       16.4%                66.3%
S1-D0-C1           1                21.9%                 2.6%
       16.9%                58.5%
S1-D0-C2           1                20.8%                 3.7%
       17.1%                58.4%
S1-D0-C3           1                17.8%                 1.0%
        9.2%                72.1%
S1-D0-C4           1                17.8%                 1.0%
        9.0%                72.2%
S1-D0-C5           1                17.8%                 1.0%
        9.0%                72.2%
S1-D0-C6           1                17.4%                 1.4%
       12.8%                68.4%
S1-D0-C7           1                23.6%                 4.3%
       17.2%                55.0%

      13.341823591 seconds time elapsed

while running with perf stat -d gives this:

$ perf stat   -d taskset -c 0 $APP

Performance counter stats for 'taskset -c 0 ./main.gcc9.3.1':

         15,075.30 msec task-clock                #    0.900 CPUs
utilized
               199      context-switches          #    0.013 K/sec
                 1      cpu-migrations            #    0.000 K/sec
           117,987      page-faults               #    0.008 M/sec
    40,907,365,540      cycles                    #    2.714 GHz
    26,431,604,986      stalled-cycles-frontend   #   64.61% frontend
cycles idle
    21,734,615,045      stalled-cycles-backend    #   53.13% backend
cycles idle
    35,339,765,469      instructions              #    0.86  insn per
cycle
                                                  #    0.75  stalled
cycles per insn
