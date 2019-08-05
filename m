Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73DE882580
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 21:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbfHETV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 15:21:28 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35575 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHETV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 15:21:27 -0400
Received: by mail-pg1-f195.google.com with SMTP id n4so4954518pgv.2;
        Mon, 05 Aug 2019 12:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HlOsSOgT1gT1zJxSf+hUIvzQARn9MCqtNx5Lk0Ak0xs=;
        b=m4AFlJzQUHOhkP3i+afM4Na4yQfCiy7TV/H2wsb4ED0Yisc/C4jHXlcQ5AIGv8oCPC
         RrR7Xn/bHfSXFU/vmc+Q/o4p8zb+mLg09PlYiIZVPXh/garjq/NFJiZ7LQnihNvmJEmp
         ohIQfLIQXiKcfHULKPqfR6KIJuMmLiQ/UuWkjgi2rHSW2zX5cU3HLP5Huw1u2bR8h/IX
         g48t4+abhMtR1eIIXM3F5Sf2u24T8vSm+OBLPedvJxFGM0dL5cbQYSy0KuinwASXzclw
         /IpMI2g8hF2SZndOQCLy0X1APH4BjQmbKj2Fd3rIxmKKEQQpNhAbgrLdvhu4LjuEsBsv
         sp8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HlOsSOgT1gT1zJxSf+hUIvzQARn9MCqtNx5Lk0Ak0xs=;
        b=oqsZo0EvcmRxUbfgVSWjqgWIZoimp0XBh4npmXnjNQdIhDmwPZxSiF79Petn1P66D8
         EgsjbJWSgMjoyJilkNhG0aHsw8xmT/Nz+jcOYgT5ygktJR1SVBo8eoucwNYTnxaPULTV
         0RSMi8KsonXgS5d+Y8mGUlvMsOsFKrABl2VJ4PuOLrIpue4cUEoFdhyo1MicJd0WINPE
         0/G0UeFnlt8enp2kNoLIiOmm/BtdAg/aMo5WV4iT3MfZhrQHFenEZk4tgazVnzqq/f4O
         tCnAe79Pc49UsOTParGQWwppjyHaveIU/gzrWfIIudn6S/eKTTGDmKZU7TTGwtZnRUaZ
         fc+A==
X-Gm-Message-State: APjAAAX+/KI+7cWc+en+XDWa0rKF/rkGXayS2rpRe9j0pOXwOqX+9UsY
        Qal0d2R3JxoM4isw1Ooenrw=
X-Google-Smtp-Source: APXvYqyEZCcbktmkCy9fTIyYwfVOIzU+9/TBOeiMpCnpwTT8r+dDa8u2sSBpTtiDrAOWUYRoM6NPbw==
X-Received: by 2002:a63:ed55:: with SMTP id m21mr16164160pgk.343.1565032886241;
        Mon, 05 Aug 2019 12:21:26 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::1:8a30])
        by smtp.gmail.com with ESMTPSA id m11sm69705033pgl.8.2019.08.05.12.21.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 12:21:25 -0700 (PDT)
Date:   Mon, 5 Aug 2019 12:21:24 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Message-ID: <20190805192122.laxcaz75k4vxdspn@ast-mbp>
References: <369476A8-4CE1-43DA-9239-06437C0384C7@fb.com>
 <CALCETrUpVMrk7aaf0trfg9AfZ4fy279uJgZH7V+gZzjFw=hUxA@mail.gmail.com>
 <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com>
 <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com>
 <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com>
 <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
 <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
 <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 10:23:10AM -0700, Andy Lutomirski wrote:
> 
> I refreshed the branch again.  I had a giant hole in my previous idea
> that we could deprivilege program loading: some BPF functions need
> privilege.  Now I have a changelog comment to that effect and a patch
> that sketches out a way to addressing this.
> 
> I don't think I'm going to have time soon to actually get any of this
> stuff mergeable, and it would be fantastic if you or someone else who
> likes working of bpf were to take this code and run with it.  Feel
> free to add my Signed-off-by, and I'd be happy to help review.

Thanks a lot for working on patches and helping us with the design!

Can you resend the patches to the mailing list?
It's kinda hard to reply/review to patches that are somewhere in the web.
I'm still trying to understand the main idea.
If I'm reading things correctly:
patch 1 "add access permissions to bpf fds"
  just passes the flags ?
patch 2 "Don't require mknod() permission to pin an object" 
 makes sense in isolation.
patch 3 "Allow creating all program types without privilege"
  is not right.
patch 4 "Add a way to mark functions as requiring privilege"
 is an interesting idea, but I don't think it helps that much.

So the main thing we're trying to solve with augmented bpf syscall
and/or /dev/bpf is to be able to use root-only features of bpf when
trused process already dropped root permissions.
These features include bpf2bpf calls, bounded loops, special maps (like LPM), etc.

Attaching to a cgroup already has file based permission checks.
The user needs to open cgroup directory to attach.
acls on cgroup dir can already be used to prevent attaching to
certain parts of cgroup hierarchy.

It seems this discussion is centered around making /dev/bpf to
let unpriv (and not trusted) users (humans) to do bpf.
That's not quite the case.
It's a good use case, but not the one we're after at the moment.
In our enviroment bpftrace, bpftool, all bcc tools are pre-installed
and the users (humans) can simply 'sudo' to run them.
Adding suid bit to installed bpftool binary is doable, but there is no need.
'sudo' works just fine.
What we need is to drop privileges sooner in daemons like systemd.
Container management daemon runs in the nested containers.
These trusted daemons need to have access to full bpf, but they
don't want to be root all the time.
They cannot flip back and forth via seteuid to root every time they
need to do bpf.
Hence the idea is to have a file that this daemon can open,
then drop privileges and still keep doing bpf things because FD is held.
Outer container daemon can pass this /dev/bpf's FD to inner daemon, etc.
This /dev/bpf would be accessible to root only.
There is no desire to open it up to non-root.

It seems there is concern that /dev/bpf is unnecessary special.
How about we combine bpffs and /dev/bpf ideas?
Like we can have a special file name in bpffs.
The root would do 'touch /sys/fs/bpf/privileges' and it would behave
just like /dev/bpf, but now it can be in any bpffs directory and acls
to bpffs mount would work as-is.

CAP_BPF is also good idea. I think for the enviroment where untrusted
and unprivileged users want to run 'bpftrace' that would be perfect mechanism.
getcap /bin/bpftrace would have cap_bpf, cap_kprobe and whatever else.
Sort of like /bin/ping.
But I don't see how cap_bpf helps to solve our trusted root daemon problem.
imo open ("/sys/fs/bpf/privileges") and pass that FD into bpf syscall
is the only viable mechanism.

Note the verifier does very different amount of work for unpriv vs root.
It does speculative execution analysis, pointer leak checks for unpriv.
So we gotta pass special flag to the verifier to make it act like it's
loading a program for root.

