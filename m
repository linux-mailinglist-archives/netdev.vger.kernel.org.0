Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D903CB795
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 14:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239761AbhGPM6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 08:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239708AbhGPM6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 08:58:51 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3AAC06175F
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 05:55:55 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id g22so3934254lfu.0
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 05:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7YVe12K3kAf74Lw6w7FM9BISBfQ+xdkVlpPe2xtnZxw=;
        b=S1/f9dxk1+qzNpT4FBDWITbM6Bgtq5eX45j8wxtciNfUAcIAlC1LzMee1hh0QkZ0HY
         lg+mFnaoj2vPn6A8SZR+yhktxiJ770BndjMgvWPgp2bjQDPDLKG7wc5ZgxKBf6/OoOB8
         MwrpPg4hSlzZp0AdZGujKVaYhlCIkkA23YJabdnHyafUisZIxmQhpcTlK7s4GqSN7vDu
         v0ZIav43+PieP8CTwmsV1uh8ZK+Tw6wObkgvCEoxiR2Ko17xbGGEdqkwAh8OfvS/+QMM
         QS/BlBO10sHKcfRLUWuvikVte6UouWZydyHvyLNMH4rjhNwyFsM/fw9GUf8aR2RX7lqs
         MIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7YVe12K3kAf74Lw6w7FM9BISBfQ+xdkVlpPe2xtnZxw=;
        b=lxYsOAppFT3FgHTTlZoGzhPI7TKJ+ES90EBPtTl+a1DzMmH5/61RgvnzvlSSxifhqZ
         TknqkjzcKeJRv1q8C7Ko3OmvR3yPgYVvN+MV39nd2Ok46/zwyKu7aTXfsDSp9IkTvicA
         lQdCrZGB7WMD+FXI7PCqkeFb//OytVeYxSKweYpAgNwLCXYGol3/BH6sFRbSQhkQ7rbU
         pPqiHA4yYxKabo7pDDa2Z7KBP6QeP9kb2d+ZMSQu4khKEtIQZIDcWiJuCX0UjzTzA466
         aw5MT2wwIU6j0wQJq+TMRlTUz3oOlKeCDVKQTkD42uYVuTeYLUqUWk4UkKQSld6gWHxv
         0rpA==
X-Gm-Message-State: AOAM5334B7uA+ZsgqTZU/eCfRYpVLvm7uOf/d4QpECfSwRRy8tLPiS0/
        EGeZFlmxhFjS/0bkysUMQsXaBNt227UzrYG+5DzRQQ==
X-Google-Smtp-Source: ABdhPJx+HIGg3Y9xkRL86NYygrweddq6ORDe7x5BfHspoT3DPnWcPBwHfdoy5Z5CHNMssXXoldgyVbAxDgfFUDKaPxA=
X-Received: by 2002:ac2:4d86:: with SMTP id g6mr7369704lfe.549.1626440153821;
 Fri, 16 Jul 2021 05:55:53 -0700 (PDT)
MIME-Version: 1.0
References: <8664122a-99d3-7199-869a-781b21b7e712@virtuozzo.com>
 <919bd022-075e-98a7-cefb-89b5dee80ae8@virtuozzo.com> <CALvZod5Kxrj3T99CEd8=OaoW8CwKtHOVhno58_nNOqjR2y=x6Q@mail.gmail.com>
 <3a60b936-b618-6cef-532a-97bbdb957fb1@virtuozzo.com>
In-Reply-To: <3a60b936-b618-6cef-532a-97bbdb957fb1@virtuozzo.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Fri, 16 Jul 2021 05:55:42 -0700
Message-ID: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
Subject: Re: [PATCH v4 00/16] memcg accounting from OpenVZ
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     Tejun Heo <tj@kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Roman Gushchin <guro@fb.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jeff Layton <jlayton@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Jiri Slaby <jirislaby@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Serge Hallyn <serge@hallyn.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zefan Li <lizefan.x@bytedance.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 9:11 PM Vasily Averin <vvs@virtuozzo.com> wrote:
>
> On 7/15/21 8:11 PM, Shakeel Butt wrote:
> > On Tue, Apr 27, 2021 at 11:51 PM Vasily Averin <vvs@virtuozzo.com> wrote:
> >>
> >> OpenVZ uses memory accounting 20+ years since v2.2.x linux kernels.
> >> Initially we used our own accounting subsystem, then partially committed
> >> it to upstream, and a few years ago switched to cgroups v1.
> >> Now we're rebasing again, revising our old patches and trying to push
> >> them upstream.
> >>
> >> We try to protect the host system from any misuse of kernel memory
> >> allocation triggered by untrusted users inside the containers.
> >>
> >> Patch-set is addressed mostly to cgroups maintainers and cgroups@ mailing
> >> list, though I would be very grateful for any comments from maintainersi
> >> of affected subsystems or other people added in cc:
> >>
> >> Compared to the upstream, we additionally account the following kernel objects:
> >> - network devices and its Tx/Rx queues
> >> - ipv4/v6 addresses and routing-related objects
> >> - inet_bind_bucket cache objects
> >> - VLAN group arrays
> >> - ipv6/sit: ip_tunnel_prl
> >> - scm_fp_list objects used by SCM_RIGHTS messages of Unix sockets
> >> - nsproxy and namespace objects itself
> >> - IPC objects: semaphores, message queues and share memory segments
> >> - mounts
> >> - pollfd and select bits arrays
> >> - signals and posix timers
> >> - file lock
> >> - fasync_struct used by the file lease code and driver's fasync queues
> >> - tty objects
> >> - per-mm LDT
> >>
> >> We have an incorrect/incomplete/obsoleted accounting for few other kernel
> >> objects: sk_filter, af_packets, netlink and xt_counters for iptables.
> >> They require rework and probably will be dropped at all.
> >>
> >> Also we're going to add an accounting for nft, however it is not ready yet.
> >>
> >> We have not tested performance on upstream, however, our performance team
> >> compares our current RHEL7-based production kernel and reports that
> >> they are at least not worse as the according original RHEL7 kernel.
> >
> > Hi Vasily,
> >
> > What's the status of this series? I see a couple patches did get
> > acked/reviewed. Can you please re-send the series with updated ack
> > tags?
>
> Technically my patches does not have any NAKs. Practically they are still them merged.
> I've expected Michal will push it, but he advised me to push subsystem maintainers.
> I've asked Tejun to pick up the whole patch set and I'm waiting for his feedback right now.
>
> I can resend patch set once again, with collected approval and with rebase to v5.14-rc1.
> However I do not understand how it helps to push them if patches should be processed through
> subsystem maintainers. As far as I understand I'll need to split this patch set into
> per-subsystem pieces and sent them to corresponded maintainers.
>

Usually these kinds of patches (adding memcg accounting) go through mm
tree but if there are no dependencies between the patches and a
consensus that each subsystem maintainer picks the corresponding patch
then that is fine too.
