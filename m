Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A1B38F9BE
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 06:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhEYFBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 01:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhEYFBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 01:01:13 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72751C061574;
        Mon, 24 May 2021 21:59:44 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ml1-20020a17090b3601b029015f9b1ebce0so3218987pjb.5;
        Mon, 24 May 2021 21:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PKeNwZRTr+D06+jG5Id1bvIpJJd2FGpww9/7oGsZ1k4=;
        b=I5DlM5uDdlmPhxqD0aj9HdlMQldlqmzFF6ldrTl+o+YDKR5B5WzFFATuFSurdvB6Y8
         sTTRRfJj5LQLWb0FZ32ah3QBgwqJ83pU4mzY2BdUM5Ti7kHWRVsSzQeF0nfwKf791leh
         nE6WXtVxT4HnyK8/rX0OsGWWWTTYIHjHM5A8F9mQvgR7Ojxpf0h460HMz4S1UoMsTr3f
         21poGfAAgXMpQgc/44s0W9kZki6macP/Z0k0LaxdMgRa6TVgltorp6vI6m6dFO7A5ZZ/
         25M/P6Gnr5buHCVaN60Gg7QgEE7QMaFtCViDOiuG/hYWhiS3DSiF3OqgYB+4VJLXZ+Oo
         FXSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PKeNwZRTr+D06+jG5Id1bvIpJJd2FGpww9/7oGsZ1k4=;
        b=sKk8G3cYc2NVwRhGXavQLHnxDUJ8/j5KtzI+PLx7QG2hsWVCdN8kjC65ezJvZTN6Ec
         Qpn5RUGZ6SxP6T08A+W9yJ58JxzNku7V8E6hZ/x0Ha2GPBhV67UNl8nRrm7/0mh1vIvK
         OlNlr17XJ+37rlfGYC51ZUtNMVC+HHjqLfpYKtruwEti93ob2or9XCruon1O8aWXfVlN
         DFH8XZ6YCiVffCBqZjlEMHQ+V9HES7Re3jHLkla8bGKgWuLS/8AAe40epUwrz0LWDK9I
         cd5vaPj0j1DOqpPxFb1EnAadouxre1UrO6JGU1mMAMXhnForeKrthUlkf6tQf36aPRYM
         xM7A==
X-Gm-Message-State: AOAM5331M1mLACcIXSkRTIAuktwuFYWqELkChHky14sThxnt2CE/SFW9
        El2IER3xHis7sS3Z+zWygG2XaeZeluxkoftPH2A=
X-Google-Smtp-Source: ABdhPJyVpN482lxlIVo6gu3nMkXiVOncN2uznmEfqAaKKMTyv30zFbJGwU8r9gsebRgAGzxBYNFXiZIWQeqYnEr71lM=
X-Received: by 2002:a17:902:b781:b029:ef:6721:b956 with SMTP id
 e1-20020a170902b781b02900ef6721b956mr28673586pls.70.1621918783098; Mon, 24
 May 2021 21:59:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com>
 <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com> <CAM_iQpU-Cvpf-+9R0ZdZY+5Dv+stfodrH0MhvSgryv_tGiX7pA@mail.gmail.com>
In-Reply-To: <CAM_iQpU-Cvpf-+9R0ZdZY+5Dv+stfodrH0MhvSgryv_tGiX7pA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 24 May 2021 21:59:31 -0700
Message-ID: <CAM_iQpVYBNkjDeo+2CzD-qMnR4-2uW+QdMSf_7ohwr0NjgipaQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 8:16 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sun, May 23, 2021 at 9:01 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, May 21, 2021 at 2:37 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > Hi, Alexei
> > >
> > > On Thu, May 20, 2021 at 11:52 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > Introduce 'struct bpf_timer' that can be embedded in most BPF map types
> > > > and helpers to operate on it:
> > > > long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags)
> > > > long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
> > > > long bpf_timer_del(struct bpf_timer *timer)
> > >
> > > Like we discussed, this approach would make the timer harder
> > > to be independent of other eBPF programs, which is a must-have
> > > for both of our use cases (mine and Jamal's). Like you explained,
> > > this requires at least another program array, a tail call, a mandatory
> > > prog pinning to work.
> >
> > That is simply not true.
>
> Which part is not true? The above is what I got from your explanation.

I tried to write some code sketches to use your timer to implement
our conntrack logic, below shows how difficult it is to use, it does not
even include the user-space part where eBPF programs are put
into the program array.


struct {
       __uint(type, BPF_MAP_TYPE_HASH);
       __uint(max_entries, 1000);
       __type(key, struct tuple);
       __type(value, struct foo);
} conntrack SEC(".maps");

struct map_elem {
       struct bpf_timer timer;
       struct bpf_map *target;
       u32 expires;
};

struct {
       __uint(type, BPF_MAP_TYPE_HASH);
       __uint(max_entries, 1000);
       __type(key, int);
       __type(value, struct map_elem);
} timers SEC(".maps");

struct {
        __uint(type, BPF_MAP_TYPE_PROG_ARRAY);
        __uint(key_size, sizeof(u32));
        __uint(value_size, sizeof(u32));
        __uint(max_entries, 8);
} jmp_table SEC(".maps");

static __u64
cleanup_conntrack(struct bpf_map *map, struct tuple *key, struct foo *val,
                 struct callback_ctx *data)
{
        if (val.expires < now)
                bpf_map_delete_elem(conntrack, key);
}

static int timer_cb(struct bpf_map *map, int *key, struct map_elem *val)
{
       bpf_for_each_map_elem(val->target, cleanup_conntrack, ....);
       /* re-arm the timer again to execute after 1 msec */
       bpf_timer_mod(&val->timer, 1);
       return 0;
}

SEC("prog/0")
int install_timer(void)
{
       struct map_elem *val;
       int key = 0;

       val = bpf_map_lookup_elem(&timers, &key);
       if (val) {
               bpf_timer_init(&val->timer, timer_cb, 0);
               bpf_timer_mod(&val->timer, val->expires);
       }
}

SEC("prog/1")
int mod_timer(void)
{
       struct map_elem *val;
       int key = 0;

       val = bpf_map_lookup_elem(&timers, &key);
       if (val) {
               // XXX: how do we know if a timer has been installed?
               bpf_timer_mod(&val->timer, val->expires);
       }
}

SEC("ingress")
void ingress(struct __sk_buff *skb)
{
        struct tuple tuple;
        // extract tuple from skb

        if (bpf_map_lookup_elem(&timers, &key) == NULL)
                bpf_tail_call(NULL, &jmp_table, 0);
                // here is not reachable unless failure
        val = bpf_map_lookup_elem(&conntrack, &tuple);
        if (val && val->expires < now) {
                bpf_tail_call(NULL, &jmp_table, 1);
                // here is not reachable unless failure
        }
}

SEC("egress")
void egress(struct __sk_buff *skb)
{
        struct tuple tuple;
        // extract tuple from skb

        if (bpf_map_lookup_elem(&timers, &key) == NULL)
                bpf_tail_call(NULL, &jmp_table, 0);
                // here is not reachable unless failure
        val = bpf_map_lookup_elem(&conntrack, &tuple);
        if (val && val->expires < now) {
                bpf_tail_call(NULL, &jmp_table, 1);
                // here is not reachable unless failure
        }
}
