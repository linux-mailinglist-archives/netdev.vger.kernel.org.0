Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36A6A908FA
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 21:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbfHPTwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 15:52:39 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41255 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfHPTwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 15:52:38 -0400
Received: by mail-pf1-f193.google.com with SMTP id 196so3623812pfz.8;
        Fri, 16 Aug 2019 12:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BsYRIWt7zgiLsYRkEbHKo3EPHhpbpjVq3H8U3w5nr8I=;
        b=XPVLpvmSGjDqAepn2Df5xVHA1UUZ9+xOQU2OlgeKUqfIGCBsbEfEy0Zoey7BlQkrxP
         CzJXdnPEYwh8oebCjhRRR7HCTZnGEE/rOqVAagxXSISdJUy9W2MAf4If6WWkvEXkWCck
         ymVDHu84P27/6BDid5eyjZWLIk1gQ5WPwy9I5RyJBIK246xZ618VNNL3GdJOSnqdYHm5
         A/pw57bMUosyPVDSBFrYOCmrjtNnAjQHTNuxW+kKH6AWLQA3ltn1bCzgczbPe12pBTtr
         oDlKuKhKPMj6G8jOkS8idVDtPeThndVdW6O22sVbM1HXETi2nYA1wdK1SSZEQqVP8yF0
         k5Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BsYRIWt7zgiLsYRkEbHKo3EPHhpbpjVq3H8U3w5nr8I=;
        b=VivxObsxO+OiYsZnoyaPOf4+ZDrsGmewuMtBAgBcmzm8WuAQvrXZ7R7HbgPAA15MPd
         NV0pquuUeNatDoB7hr7yWvYgog77O15k9QIdz+NqwP4CWaUSU2Eu25J0fMgzfqhaNnHk
         J9N4u4U/Stmpgnsc+TjkXS7DFVu9WUwbiDoZWU22drFwUToheiuiV6FX/G69VAsY8qqK
         ZxICcVsZtK8lYfwNrhpPqWfM4lN8FwLMug/gEoxKCQozlfaRFJ+2cYbMKc6R0uNomJrS
         wpBT+q42FloP3B5lMXC6r5GsJ57HprRiKVk5T+UFG9gbybiCYhU4ieEIjzQlXrWkFX6y
         ck4A==
X-Gm-Message-State: APjAAAWLV/otEumKgGyn8Mk1UpwP+fJR5mAt/g58jKTTBELd718tywW/
        PUIUspcMuF4m/dka1V4QRMY=
X-Google-Smtp-Source: APXvYqzrd7QyPzjL0x3MzSJ9v0FfGA12R+uv7HUBgJeM5ogLLZzOB/z+CjGaACxHJtQGH1TFe78JVA==
X-Received: by 2002:aa7:9799:: with SMTP id o25mr12431962pfp.74.1565985157546;
        Fri, 16 Aug 2019 12:52:37 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:79ad])
        by smtp.gmail.com with ESMTPSA id 97sm6005173pjz.12.2019.08.16.12.52.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 12:52:36 -0700 (PDT)
Date:   Fri, 16 Aug 2019 12:52:35 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jordan Glover <Golden_Miller83@protonmail.ch>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Daniel Colascione <dancol@google.com>,
        Song Liu <songliubraving@fb.com>,
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
Message-ID: <20190816195233.vzqqbqrivnooohq6@ast-mbp.dhcp.thefacebook.com>
References: <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com>
 <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com>
 <HG0x24u69mnaMFKuxHVAzHpyjwsD5-U6RpqFRua87wGWQCHg00Q8ZqPeA_5kJ9l-d6oe0cXa4HyYXMnOO0Aofp_LcPcQdG0WFV21z1MbgcE=@protonmail.ch>
 <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com>
 <CALCETrUv+g+cb79FJ1S4XuV0K=kowFkPXpzoC99svoOfs4-Kvg@mail.gmail.com>
 <20190815230808.2o2qe7a72cwdce2m@ast-mbp.dhcp.thefacebook.com>
 <fkD3fs46a1YnR4lh0tEG-g3tDnDcyZuzji7bAUR9wujPLLl75ZhI8Yk-H1jZpSugO7qChVeCwxAMmxLdeoF2QFS3ZzuYlh7zmeZOmhDJxww=@protonmail.ch>
 <alpine.DEB.2.21.1908161158490.1873@nanos.tec.linutronix.de>
 <lGGTLXBsX3V6p1Z4TkdzAjxbNywaPS2HwX5WLleAkmXNcnKjTPpWnP6DnceSsy8NKt5NBRBbuoAb0woKTcDhJXVoFb7Ygk3Skfj8j6rVfMQ=@protonmail.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lGGTLXBsX3V6p1Z4TkdzAjxbNywaPS2HwX5WLleAkmXNcnKjTPpWnP6DnceSsy8NKt5NBRBbuoAb0woKTcDhJXVoFb7Ygk3Skfj8j6rVfMQ=@protonmail.ch>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 16, 2019 at 11:33:57AM +0000, Jordan Glover wrote:
> On Friday, August 16, 2019 9:59 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Fri, 16 Aug 2019, Jordan Glover wrote:
> >
> > > "systemd --user" service? Trying to do so will fail with:
> > > "Failed to apply ambient capabilities (before UID change): Operation not permitted"
> > > I think it's crucial to clear that point to avoid confusion in this discussion
> > > where people are talking about different things.
> > > On the other hand running "systemd --system" service with:
> > > User=nobody
> > > AmbientCapabilities=CAP_NET_ADMIN
> > > is perfectly legit and clears some security concerns as only privileged user
> > > can start such service.
> >
> > While we are at it, can we please stop looking at this from a systemd only
> > perspective. There is a world outside of systemd.
> >
> > Thanks,
> >
> > tglx
> 
> If you define:
> 
> "systemd --user" == unprivileged process started by unprivileged user
> "systemd --system" == process started by privileged user but run as another
> user which keeps some of parent user privileges and drops others
> 
> you can get rid of "systemd" from the equation.
> 
> "systemd --user" was the example provided by Alexei when asked about the usecase
> but his description didn't match what it does so it's not obvious what the real
> usecase is. I'm sure there can be many more examples and systemd isn't important
> here in particular beside to understand this specific example.

It's both of the above when 'systemd' is not taken literally.
To earlier Thomas's point: the use case is not only about systemd.
There are other containers management systems.
I've used 'systemd-like' terminology as an attempt to explain that such
daemons are trusted signed binaries that can be run as pid=1.
Sometimes it's the later:
"process started by privileged user but run as another user which keeps
some of parent user privileges and drops others".
Sometimes capability delegation to another container management daemon
is too cumbersome, so it's easier to use suid bit on that other daemon.
So it will become like the former:
"sort-of unprivileged process started by unprivileged user."
where daemon has suid and drops most of the capabilities as it starts.
Let's not focus on the model being good or bad security wise.
The point that those are the use cases that folks are thinking about.
That secondary daemon can be full root just fine.
All outer and inner daemons can be root.
These daemons need to drop privileges to make the system safer ==
less prone to corruption due to bugs in themselves. Not necessary security bugs.

