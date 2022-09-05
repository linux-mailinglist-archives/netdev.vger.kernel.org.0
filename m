Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA73F5AD867
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 19:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237123AbiIERco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 13:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236801AbiIERcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 13:32:42 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938245A3C8;
        Mon,  5 Sep 2022 10:32:41 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id p16so18338646ejb.9;
        Mon, 05 Sep 2022 10:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=88RvRU4ThtDB+LtTsoJu6zAQGFmOnQzmalV+PKKcYX0=;
        b=ZMjUlTSjsvyvuViz6o0KelDAws8H+GU3P5JZJHSaSzK1ZN0bLVMlIZx22d0MOS3Roz
         JPn3o7AwgLfk357T3um0ofDEGl8sHhfWA3ZBRz3s1nSPZCALhoJCzXZoYhlUR/x5BVZ2
         YIFFIjhWPZQqjeObY8SIYvORpaaDDmuj37g8UlWcoxOq0F8xm0AJwgXVEI0JjyQGD8up
         dbVd7jCOdKllEYYRYD+mwvpMXF4o5FjZ6ANhqccofA+dP4S5bxXjRLoVDFoWBXRhX0IL
         UsaI+Kg93WR8OlPi6SUztnVPDEUmv5VolL3eREhRiikKx1iSR2KdUxZjDCNs9TaZtKkB
         0PQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=88RvRU4ThtDB+LtTsoJu6zAQGFmOnQzmalV+PKKcYX0=;
        b=Gy0geq9QbYJsYc4O1oNpRv9zoteZve/7+DRkBQYzoeUSel0dePq4c0VPpdQ6BhiCZp
         wG1yJRN0igXtUtWUAutkmtRZhk3rzMRDoiDxgg3jU9/KtcvUonSXhxURQzcncn0cECQy
         jV8yNei8jxozKRxFja9FJm5OSrHbIbaO4qGrV8MYvL9HarBSgiemz0hPFP9XVMOILgdC
         LMoPLDJVaIgvPz/qZRaVOfL5UBtRuq/0pCTRPdzcxzDf/ZC3TKnmghoPGYm8a9jzR0sN
         R+gz7DDYyGGyxUhjH80WaT5qckvy5GDNrkPfVnuAfcqjDdgRwy+x1V419Hr+tDamQAn0
         66RA==
X-Gm-Message-State: ACgBeo3oG3ahyTBFxDy38nqa/JORWZ6JuXE5kqlWmS8kHhjGOzEyYhHF
        L6ZmjJAVBXJCuve8wjQAWz2mIWXwCg==
X-Google-Smtp-Source: AA6agR6XiECda7DbpsPoLOhCgSz7f263f954LjGex1UvoUKxY/0M+xypaz5mgANtg3gVFUU6x282AA==
X-Received: by 2002:a17:907:728d:b0:731:8396:ea86 with SMTP id dt13-20020a170907728d00b007318396ea86mr36637006ejc.361.1662399160091;
        Mon, 05 Sep 2022 10:32:40 -0700 (PDT)
Received: from localhost.localdomain ([46.53.251.11])
        by smtp.gmail.com with ESMTPSA id q37-20020a05640224a500b00448176872f7sm6766273eda.81.2022.09.05.10.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 10:32:38 -0700 (PDT)
Date:   Mon, 5 Sep 2022 20:32:36 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: setns() affecting other threads in 5.10.132 and 6.0
Message-ID: <YxYytPTFwYr7vBTo@localhost.localdomain>
References: <d9f7a7d26eb5489e93742e57e55ebc02@AcuMS.aculab.com>
 <fcf51181f86e417285a101059d559382@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fcf51181f86e417285a101059d559382@AcuMS.aculab.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 05, 2022 at 09:54:34AM +0000, David Laight wrote:
> 7055197705709c59b8ab77e6a5c7d46d61edd96e
> Author: Alexey Dobriyan <adobriyan@gmail.com>
>     Cc: Al Viro <viro@zeniv.linux.org.uk>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> c6c75deda813
> 1fde6f21d90f
> 
> > -----Original Message-----
> > From: David Laight <David.Laight@ACULAB.COM>
> > Sent: 04 September 2022 15:05
> > 
> > Sometime after 5.10.105 (5.10.132 and 6.0) there is a change that
> > makes setns(open("/proc/1/ns/net")) in the main process change
> > the behaviour of other process threads.

Not again...

> > I don't know how much is broken, but the following fails.
> > 
> > Create a network namespace (eg "test").
> > Create a 'bond' interface (eg "test0") in the namespace.
> > 
> > Then /proc/net/bonding/test0 only exists inside the namespace.
> > 
> > However if you run a program in the "test" namespace that does:
> > - create a thread.
> > - change the main thread to in "init" namespace.
> > - try to open /proc/net/bonding/test0 in the thread.
> > then the open fails.
> > 
> > I don't know how much else is affected and haven't tried
> > to bisect (I can't create bonds on my normal test kernel).
> 
> I've now bisected it.
> Prior to change 7055197705709c59b8ab77e6a5c7d46d61edd96e
>     proc: fix dentry/inode overinstantiating under /proc/${pid}/net
> the setns() had no effect of either thread.
> Afterwards both threads see the entries in the init namespace.
> 
> However I think that in 5.10.105 the setns() did affect
> the thread it was run in.
> That might be the behaviour before c6c75deda813.
>     proc: fix lookup in /proc/net subdirectories after setns(2)
> 
> There is also the earlier 1fde6f21d90f
>     proc: fix /proc/net/* after setns(2)
> 
> From the commit messages it does look as though setns() should
> change what is seen, but just for the current thread.
> So it is currently broken - and has been since 5.18.0-rc4
> and whichever stable branches the change was backported to.
> 
> 	David
> 
> > 
> > The test program below shows the problem.
> > Compile and run as:
> > # ip netns exec test strace -f test_prog /proc/net/bonding/test0
> > 
> > The second open by the child should succeed, but fails.
> > 
> > I can't see any changes to the bonding code, so I suspect
> > it is something much more fundamental.
> > It might only affect /proc/net, but it might also affect
> > which namespace sockets get created in.

How? setns(2) acts on "current", and sockets are created from
current->nsproxy->net_ns?

> > IIRC ls -l /proc/n/task/*/ns gives the correct namespaces.

> > 
> > 	David
> > 
> > 
> > #define _GNU_SOURCE
> > 
> > #include <fcntl.h>
> > #include <unistd.h>
> > #include <poll.h>
> > #include <pthread.h>
> > #include <sched.h>
> > 
> > #define delay(secs) poll(0,0, (secs) * 1000)
> > 
> > static void *thread_fn(void *file)
> > {
> >         delay(2);
> >         open(file, O_RDONLY);
> > 
> >         delay(5);
> >         open(file, O_RDONLY);
> > 
> >         return NULL;
> > }
> > 
> > int main(int argc, char **argv)
> > {
> >         pthread_t id;
> > 
> >         pthread_create(&id, NULL, thread_fn, argv[1]);
> > 
> >         delay(1);
> >         open(argv[1], O_RDONLY);
> > 
> >         delay(2);
> >         setns(open("/proc/1/ns/net", O_RDONLY), 0);
> > 
> >         delay(1);
> >         open(argv[1], O_RDONLY);
> > 
> >         delay(4);
> > 
> >         return 0;
> > }

Can you test before this one? This is where it all started.

	commit 1da4d377f943fe4194ffb9fb9c26cc58fad4dd24
	Author: Alexey Dobriyan <adobriyan@gmail.com>
	Date:   Fri Apr 13 15:35:42 2018 -0700

	    proc: revalidate misc dentries
