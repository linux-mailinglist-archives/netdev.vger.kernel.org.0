Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56A9213159
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 04:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgGCCfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 22:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGCCfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 22:35:51 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4EAC08C5C1;
        Thu,  2 Jul 2020 19:35:51 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gc9so6749465pjb.2;
        Thu, 02 Jul 2020 19:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=356EHQ0cHMEVkYqLfbIWT5ow6CJqCepSrNitIr5l14k=;
        b=aTur/YM4SNLK77iAZM7noIbulj8Lc9VcwVJKnrKmbfHwy3c17XY4pnNwMaFOxemfFN
         pq5Y5TVq3MEqBF6pFYBgaWltPQAp6c2Ph2IbsebHuoOMKpvEyIpCkHKMiSxn8ywrxCI0
         mUgkQJiCuQ9uly7ki3e6WrrzeJFPbqKgYsUpMbz4vaeAMMIpmwG6+mzS6VAEwMUrf8Iq
         MGP5sBzswGQKq/fA1IbnYzjofjS5O2eo7Ai1pX80w6PxeXCgrxcQANDFI/cFXuvYfa+Q
         rxVrOXIBIMwYv9cnDYEbYaCYM5yedF4mW/WJZzfpuUbN43161sRfIu1BC2+bglpgiz9c
         3YXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=356EHQ0cHMEVkYqLfbIWT5ow6CJqCepSrNitIr5l14k=;
        b=S+HOCtf0+qcRUczlKCE6z9rLHTPDdFL5jTRO57jfNTLITYifx7OXWnniBvk914dE9a
         Dc7SRs5EpYbsqY6Ir/LCEAsFCrF1LNy2PqkfLlZdFkHq2clvknEfvh1cVxXn1xxH0oYH
         IcqrUH/DVJEvOE7QZSi91/Z9m2DCXeAS8unX34JYpkOSyGvD4S1z/2PvVIs8eHE4Yt30
         GaqQ//ZbD3IW43SBmaJ2cbPaoxOyLuYIWm7LCwyaBtoScM92e1JT1Brw++CEf0YvwOh0
         fjJ5/53lmPQe6MhzJOoEpf1Xc3hcdudshnq6j57bY7lu0I34UP4cGgfeW3d7X89jM50B
         v6Wg==
X-Gm-Message-State: AOAM532dzbnCbdiMrPSiX2slWCT5Gi6Px384r/vtGZ1/qRYhPuW/pczU
        kI+A1AAKC/Buu0yGUqzo5gw=
X-Google-Smtp-Source: ABdhPJyUCQIUl5sO+6PrVGMPWOQgBcdV3YfS3m0VP1U8UeEf33wmksk2oaqmFZGUJ3H7xH0TU8845Q==
X-Received: by 2002:a17:90a:ab96:: with SMTP id n22mr5682594pjq.52.1593743750964;
        Thu, 02 Jul 2020 19:35:50 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4afb])
        by smtp.gmail.com with ESMTPSA id a5sm2562444pjq.48.2020.07.02.19.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 19:35:50 -0700 (PDT)
Date:   Thu, 2 Jul 2020 19:35:47 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 3/3] bpf: Add kernel module with user mode
 driver that populates bpffs.
Message-ID: <20200703023547.qpu74obn45qvb2k7@ast-mbp.dhcp.thefacebook.com>
References: <20200702200329.83224-1-alexei.starovoitov@gmail.com>
 <20200702200329.83224-4-alexei.starovoitov@gmail.com>
 <CAHk-=wgP8g-9RdVh_AHHi9=Jpw2Qn=sSL8j9DqhqGyTtG+MWBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgP8g-9RdVh_AHHi9=Jpw2Qn=sSL8j9DqhqGyTtG+MWBA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 06:05:29PM -0700, Linus Torvalds wrote:
> On Thu, Jul 2, 2020 at 1:03 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > The BPF program dump_bpf_prog() in iterators.bpf.c is printing this data about
> > all BPF programs currently loaded in the system. This information is unstable
> > and will change from kernel to kernel.
> 
> If so, it should probably be in debugfs, not in /sys/fs/

/sys/fs/bpf/ is just a historic location where we chose to mount bpffs.
iirc iproute2 picked that location and systemd followed.
bpffs itself is not a single mount and not sharing anything with sysfs or debugfs.
By default it's not mounted anywhere.
Every instance is independent and can contain only pinned BPF objects:
progs, maps, links.
Folks are using bpffs to store BPF objects that need to survive the life time
of the process that created those objects.
Another use is to share that BPF object with another process.
Like firewall service can load bpf prog attach to netdev and pin bpf map
with firewall rules in some /var/my_firewall/bpf/my_fw_rules.
Then another process can do map lookup/delete on that map if it can access the path.
I've seen such use case in production.
As far as preloading "progs" and "maps" iterators into bpffs the following
works just as well:
$ mkdir /aa
$ mount bpffs /aa -t bpf
$ ll /aa
total 4
drwxrwxrwt  2 root root    0 Jul  2 00:27 .
drwxr-xr-x 19 root root 4096 Jul  2 00:09 ..
-rw-------  1 root root    0 Jul  2 00:27 maps
-rw-------  1 root root    0 Jul  2 00:27 progs
$ cat /aa/progs
  id name            pages attached
  17    dump_bpf_map     1 bpf_iter_bpf_map
  18   dump_bpf_prog     1 bpf_iter_bpf_prog

May be I misunderstood what you meant?
