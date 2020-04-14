Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6AC1A89F2
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504229AbgDNSm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2504221AbgDNSmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:42:54 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA3AC061A0C;
        Tue, 14 Apr 2020 11:42:54 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id s63so10303836qke.4;
        Tue, 14 Apr 2020 11:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jPj/lMdCvvMjz02VAoL6l68kGgzgU5PratzNUdr8FkM=;
        b=FDOrBtW6JIkCcH3jWSHnM0kaQ4NBncEq4JMN8wWLAsAEnrR3gMEMMX3FbvhrbD6b4I
         lgA2IhywQPBkHT+JTkl7tC0HqcExSb+15GbV5zwSoPO5aMH8GG13N1nOHEImdJmbed9W
         w5UTyiHfO0fLmfdxj7oPy09w79EqfPecYMupOrRuJMNEjXgG5258Ym9BYrB9T5AuDdEw
         QFmt//b8w5QR90YoGKeh0ee/oJ1sISI2T1l6jVoS4IbKMmGQuvvYt6hiDSaVVQViMVq1
         Q6YOjSMppLjSUTYVhgujD2Qz2YG2cGlKX9u6WqS07E0SGWgmPczF1GAGSEhiecNhoeF4
         idTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jPj/lMdCvvMjz02VAoL6l68kGgzgU5PratzNUdr8FkM=;
        b=WhpsMwax7q8AOq+eQ4rnETTrcfLY86vg3vBDCNtaqSsKfyXMA0mo1AUAK/R5bWpoqu
         xxfQACnBtWtn6w7m3oKWysihDA9zj1ZHWnBTSsWvZdwLYE3snFWrt5cLgjbHCnIGxVsw
         ruETARhFvP5rALK/pR9qESjpII5n7KZRcqhGWJWDxttgWVqu/xqwK9tHSMr6cg+yWkFX
         21HuTi0LJQUJn5odKhiVSzvN/2UlN076QnereYbdKB2M5USIY2vk6apGGdmCtMmSlq6E
         bE88I4zKbAd/dQnFitC4NBcFJLJrreeSUngNN/V2Oh6Mmeh9Gbzz/RYAy1uQV4jdotAG
         KHHA==
X-Gm-Message-State: AGi0PubpEKnFg7nYAYIISuml+4hcXOKg5qtvI0qDPTgr5h+tIrH8OUj7
        Umelg2W+tp1AchUm/N/NkCetzV0Ds2/6m7J2NYc=
X-Google-Smtp-Source: APiQypJuX9AbegNin2XRwP7guL93GSLyhkAA4edMIwLPvVPtrQaBnvQHGVNnmcm0Ua0KqcY544Ux3By9elBj9PmXewQ=
X-Received: by 2002:ae9:e854:: with SMTP id a81mr22524112qkg.36.1586889773750;
 Tue, 14 Apr 2020 11:42:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200412055837.2883320-1-andriin@fb.com> <20200413202126.GA36960@rdna-mbp.dhcp.thefacebook.com>
 <CAEf4Bzbf7kuzTnq6d=Jh+hRdUi++vxabZz2oQU=hPh52rztbgg@mail.gmail.com>
 <20200413224412.GA44785@rdna-mbp.dhcp.thefacebook.com> <CAEf4BzY6g6E=_-+fvyEqgWK_-+j2jOL1mFA7wapWW8axZmY=UQ@mail.gmail.com>
 <20200414172409.GA54710@rdna-mbp>
In-Reply-To: <20200414172409.GA54710@rdna-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Apr 2020 11:42:42 -0700
Message-ID: <CAEf4Bza12ajfupEOWzL=bJ0EgUwW8OGcdQUfoLY5JV9YoLoJdg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: always specify expected_attach_type on
 program load if supported
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 10:36 AM Andrey Ignatov <rdna@fb.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> [Mon, 2020-04-13 21:49 -0700]:
> > On Mon, Apr 13, 2020 at 3:44 PM Andrey Ignatov <rdna@fb.com> wrote:
> > >
> > > Andrii Nakryiko <andrii.nakryiko@gmail.com> [Mon, 2020-04-13 15:00 -0700]:
> > > > On Mon, Apr 13, 2020 at 1:21 PM Andrey Ignatov <rdna@fb.com> wrote:
> > > > >
> > > > > Andrii Nakryiko <andriin@fb.com> [Sat, 2020-04-11 22:58 -0700]:
>
> ...
>
> > > > >
> > > > > But I don't have context on all hooks that can be affected by this
> > > > > change and could easily miss something.
> > > > >
> > > > > Ideally it should be verified by tests. Current section_names.c test
> > > > > only verifies what will be returned, but AFAIK there is no test that
> > > > > checks whether provided combination of prog_type/expected_attach_type at
> > > > > load time and attach_type at attach time would actually work both on
> > > > > current and old kernels. Do you think it's possible to add such a
> > > > > selftest? (current libbpf CI supports running on old kernels, doesn't
> > > > > it?)
> > > >
> > > > So all the existing selftests are essentially verifying this, if run
> > > > on old kernel. I don't think libbpf currently runs tests on such old
> > > > kernels, though. But there is no extra selftest that we need to add,
> > > > because every single existing one will execute this piece of libbpf
> > > > logic.
> > >
> > > Apparently existing tests didn't catch the very obvious bug with
> > > BPF_PROG_TYPE_CGROUP_SOCK / BPF_CGROUP_INET_EGRESS invalid combination.
> >
> > Sigh.. yeah. I expected cgroup_link test to fail if that functionality
> > didn't work, but I missed that bpf_program__attach_cgroup() code will
> > use correct expected_attach_type, even if it's not provided to
> > BPF_PROG_LOAD.
> >
> > >
> > > I think it'd be useful to start with at least basic test focused on
> > > expected_attach_type. Then later extend it to new attach types when they're
> > > being added and, ideally, to existing ones.
> >
> > How this test should look like? I can make a test that will work only
> > on new kernel (e.g., by using cgroup program which needs
> > expected_attach_type), but it will fail on old kernels. There doesn't
> > seem to be a way to query expected_attach_type from kernel. Any hints
> > on how to make test that will pass on old and new kernels and will
> > validate expected_attach_type is passed properly?
>
> I think there should be two steps here:
> 1) make a test;
> 2) make the test work on old kernels;
>
> The "1)" should be pretty straightforward: we can just have an object
> with all possible section names and make sure it can be loaded. If
> a program type can have different scenarios, IMO all scenarios should be
> covered.
>
> For example, part of the object for cgroup_skb can look like this:
>
>         #include <linux/bpf.h>
>         #include <bpf/bpf_helpers.h>
>
>         char _license[] SEC("license") = "GPL";
>         int _version SEC("version") = 0;
>
>         SEC("cgroup_skb/ingress")
>         int skb_ret1(struct __sk_buff *skb)
>         {
>                 return 1;
>         }
>
>         /* Support for ret > 1 has different expectations for expected_attach_type */
>         SEC("cgroup_skb/ingress")
>         int skb_ret1(struct __sk_buff *skb)
>         {
>                 return 2;
>         }
>
>         SEC("cgroup_skb/egress")
>         int skb_ret1(struct __sk_buff *skb)
>         {
>                 return 1;
>         }
>
>         /* Support for ret > 1 has different expectations for expected_attach_type */
>         SEC("cgroup_skb/egress")
>         int skb_ret1(struct __sk_buff *skb)
>         {
>                 return 2;
>         }
>
>         /* Compat section name */
>         SEC("cgroup/skb")
>         int skb_ret1(struct __sk_buff *skb)
>         {
>                 return 1;
>         }
>
>         /* ... and then other sections .. */
>
> Some time later attach step can be added according to what kind of
> program it is (e.g. try to attach cgroup programs to a cgroup, etc).
>
> IMO it'd be beneficial for libbpf to have such a simple/single test that
> verifies the very basic thing: simple program for every supported
> section name can be loaded.
>
> And such a test would caught the initial problem with NET_XMIT_CN.


I agree. Though in my defense, those tests should have been added when
corresponding kernel features were added ;-P
Especially the test with [2, 3] returns for cgroup_skb progs. But I'll
prepare a selftest with trivial programs as you outlined them above.
And just test loading them, not attaching.


>
> I checked whether all sections have at least one program in selftests
> and found a bunch that don't:
>
>         09:43:11 0 rdna@dev082.prn2:~/bpf-next$>sed -ne '/static const struct bpf_sec_def section_defs/,/^\};/p' tools/lib/bpf/libbpf.c | awk -F'"' 'NF == 3 {printf "SEC(\"%s\n", $2}' | sort > all_sec_names
>         09:43:19 0 rdna@dev082.prn2:~/bpf-next$>head -n 5 all_sec_names
>         SEC("action
>         SEC("cgroup/bind4
>         SEC("cgroup/bind6
>         SEC("cgroup/connect4
>         SEC("cgroup/connect6
>         09:43:20 0 rdna@dev082.prn2:~/bpf-next$>diff -u all_sec_names <(git grep -ohf all_sec_names tools/testing/selftests/bpf/ | sort -u)
>         --- all_sec_names       2020-04-14 09:43:19.552675629 -0700
>         +++ /dev/fd/63  2020-04-14 09:43:30.967648496 -0700
>         @@ -1,21 +1,13 @@
>         -SEC("action
>         -SEC("cgroup/bind4
>         -SEC("cgroup/bind6
>          SEC("cgroup/connect4
>          SEC("cgroup/connect6
>          SEC("cgroup/dev
>          SEC("cgroup/getsockopt
>         -SEC("cgroup/post_bind4
>         -SEC("cgroup/post_bind6
>         -SEC("cgroup/recvmsg4
>         -SEC("cgroup/recvmsg6
>          SEC("cgroup/sendmsg4
>          SEC("cgroup/sendmsg6
>          SEC("cgroup/setsockopt
>          SEC("cgroup/skb
>          SEC("cgroup_skb/egress
>          SEC("cgroup_skb/ingress
>         -SEC("cgroup/sock
>          SEC("cgroup/sysctl
>          SEC("classifier
>          SEC("fentry/
>         @@ -27,10 +19,7 @@
>          SEC("kretprobe/
>          SEC("lirc_mode2
>          SEC("lsm/
>         -SEC("lwt_in
>         -SEC("lwt_out
>          SEC("lwt_seg6local
>         -SEC("lwt_xmit
>          SEC("perf_event
>          SEC("raw_tp/
>          SEC("raw_tracepoint/
>
> That simple test can provide coverage for such sections.

Actually, if we put all this in a single test, we'll have to disable
it for all kernel versions but the very last, because there will
always be some BPF program type that's not supported on even slightly
older kernel. So maybe for now, I'll just go and add a dummy
cgroup_skb/{ingress, egress} programs to existing selftests for
cgroup_skb programs.

>
> As for "2)" -- I agree, it's not that straightforward: there should be a
> way to check for feature presence in the kernel and skip if feature is
> not present.  AFAIK currently there is no such thing in bpf
> selftests(?). IMO it's fine to postpone this step for later time.
>
> What do you think?

See above, I think each type of program (or at least a class of
programs) should have its dedicated selftest. That way we can
blacklist the ones that are not supposed to succeed on particular
kernel. We do feature detection and skipping of the test only for
features that require very particular setup (e.g., hardware), but not
in general. It's been discussed many times, so far the tendency is to
not do feature detection and test disablement by default.

>
> --
> Andrey Ignatov
