Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 761E015FBB4
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 01:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgBOApG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 19:45:06 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41592 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbgBOApG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 19:45:06 -0500
Received: by mail-pg1-f194.google.com with SMTP id 70so5752080pgf.8;
        Fri, 14 Feb 2020 16:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ubyDc/J45m18NS4YhmhXALa8rTe8ybSZrRD+88QTVz8=;
        b=aQI8jJdcVlV2Xbe8n7UDjRM938M5ezgxBDtphW031gKtvYAnlX3hPOhONCU1KvIsuM
         4DpKl813EYkyE+zzFtF4lj2cXma3k3QCo4KPbi+39Ms+G7GY4WpvERtIaRuidBrnN5eg
         RqVP7wg0QDWdAQNQXmo7zWWd49RAzPhoY/osIoN0FLPUKrJSDsu2IE7LSnZoWu/OSBqr
         nitt4C7vVFQiyBzNjcJhIS4RnghgP3z2PN8/P9ftXnGvLKGxWp47rJjOOLN5oDy69XhW
         S31g0yJnahyW9QKv8yxTJAhpF1QBBUNj7Ypw/99Gqn2QrPlFuXzSOzjFcpFdBD0Ceq+h
         IDrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ubyDc/J45m18NS4YhmhXALa8rTe8ybSZrRD+88QTVz8=;
        b=HXSVxEv08gXp1kwIiQIRbEjp9dvlZZpuiTOo4cy4msSYip5/9Exaj2Y3jK77iBEHST
         Qvz/onBOOjNc51yZkp3nylrfV/Gl5o9/wipIg1v1BMk0Y/LBz7Z0EgmJXiJu4aaekf/d
         e/88NzoXUsDgeJFspy5XaU1TTwecSDyGWl/fKFvMlbbyZQTnmJkAgVyyHJG94ZS7D6gL
         BymJCjB+m3+h1fl44hVg1ChAdUQOiKUAx8W9SkTyYK/xKfJ1qF1/XdgmHmAU1uuzstHK
         mkI4gO5PksrcfEyShwM08JsD91CrxkqPouitgoHUu5HymeinJ2Q1JGEltm6MwesPsAzP
         ezEg==
X-Gm-Message-State: APjAAAUqfcgZ6AxwjaRqa+MN/05qwHCWcfA7ROh5Yc96R1PTTnjug0VU
        P3Ou8ciiH41lrK8xH5GQn5A=
X-Google-Smtp-Source: APXvYqxQgxFAC/7PTEjrNE1hLwHK6xX5L9aa6Ust6YfFaTt/kgP19YfVsc0gFJkkWNqsKcY1FkEc9Q==
X-Received: by 2002:a63:214e:: with SMTP id s14mr6113738pgm.428.1581727504842;
        Fri, 14 Feb 2020 16:45:04 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::6:17ee])
        by smtp.gmail.com with ESMTPSA id s124sm8744488pfc.57.2020.02.14.16.45.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Feb 2020 16:45:04 -0800 (PST)
Date:   Fri, 14 Feb 2020 16:45:02 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        ast@kernel.org, daniel@iogearbox.net
Subject: Re: [RFC bpf-next 3/4] bpftool: introduce "prog profile" command
Message-ID: <20200215004500.gs3ylstfo3aksfbp@ast-mbp>
References: <20200213210115.1455809-1-songliubraving@fb.com>
 <20200213210115.1455809-4-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213210115.1455809-4-songliubraving@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 01:01:14PM -0800, Song Liu wrote:
> With fentry/fexit programs, it is possible to profile BPF program with
> hardware counters. Introduce bpftool "prog profile", which measures key
> metrics of a BPF program.
> 
> bpftool prog profile command creates per-cpu perf events. Then it attaches
> fentry/fexit programs to the target BPF program. The fentry program saves
> perf event value to a map. The fexit program reads the perf event again,
> and calculates the difference, which is the instructions/cycles used by
> the target program.
> 
> Example input and output:
> 
>   ./bpftool prog profile 20 id 810 cycles instructions
>   cycles: duration 20 run_cnt 1368 miss_cnt 665
>           counter 503377 enabled 668202 running 351857
>   instructions: duration 20 run_cnt 1368 miss_cnt 707
>           counter 398625 enabled 502330 running 272014
> 
> This command measures cycles and instructions for BPF program with id
> 810 for 20 seconds. The program has triggered 1368 times. cycles was not
> measured in 665 out of these runs, because of perf event multiplexing
> (some perf commands are running in the background). In these runs, the BPF
> program consumed 503377 cycles. The perf_event enabled and running time
> are 668202 and 351857 respectively.

if (diff.enabled > diff.running) increment miss_cnt.
Why show this to users?
I think 'miss_cnt' the users will interpret as data is bogus,
but it only means that the counter was multiplexed.
The data is still accurate, no?
This condition will probably be hit fairly often, no?

>  tools/bpf/bpftool/profiler.skel.h         | 820 ++++++++++++++++++++++

I think bpftool needs to be build twice to avoid this.

Could you change the output format to be 'perf stat' like:
         55,766.51 msec task-clock                #    0.996 CPUs utilized
             4,891      context-switches          #    0.088 K/sec
                31      cpu-migrations            #    0.001 K/sec
         1,806,065      page-faults               #    0.032 M/sec
   166,819,295,451      cycles                    #    2.991 GHz                      (50.12%)
   251,115,795,764      instructions              #    1.51  insn per cycle           (50.10%)

Also printing 'duration' is unnecessary. The user specified it at the command
line and it doesn't need to be reported back to the user.
Can you also make it optional? Until users Ctrl-C's bpftool ?
So it may look like:
$ ./bpftool prog profile id 810 cycles instructions
             1,368      run_cnt
           503,377      cycles
           398,625      instructions         # 0.79 insn per cycle

Computing additional things like 'insn per cycle' do help humans to
pay attention the issue. Like <1 ipc is not great and the next step
would be to profile this program for cache misses.
