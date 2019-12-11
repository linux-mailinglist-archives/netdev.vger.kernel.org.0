Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7934711B881
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 17:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbfLKQVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 11:21:48 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36264 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728912AbfLKQVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 11:21:47 -0500
Received: by mail-lf1-f68.google.com with SMTP id n12so17180423lfe.3
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 08:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9+dtV+M9iZYRqhoG+AqRAuO5pcKMIzqtz8v8DdzhGqY=;
        b=SbjqM2ODKehYk9SmsKSmcVA1wbAp8f9RxIfGF3yszl7Rpd/WVpD/GYeGTTFEKIyIuX
         XHU1FmMrrd3zQwg7Y6e1BelHzoGwjvCUximULUHlJvFwlDFsJnmO1S8vkuFt0Bt/8BRm
         mbynfnki93Ivwshksj3SJ2nqec7srZhjMWCPGMprCwlCsKCNynHsY5/TqjOR0TSk9Fw4
         TfSJdKnebnmvUdb0QoQQld9fp5Dj7cF04DRZxNFQiQbz0PCmF7sFahu/PzSxBonNwmY4
         wY//83O94DtLMQAlI9u7wQA6dxBXEEzsEb7VVm3IQsjfFVXrOf/BVbgc5Li79f4d8uB1
         +WjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9+dtV+M9iZYRqhoG+AqRAuO5pcKMIzqtz8v8DdzhGqY=;
        b=RtsCQsdgiTkdsLsi1nObx3dNWHhznkP4rLE4u37EgTrmUqskyHlamCZAfsLaPGeUHf
         rzZP2KXehK4LtwnevcfYO90WLZeH8s++44dj7iSWFSrTgAezDsA8Y1kzjvsSxAcaMpnd
         bGiJA/Y3U5MrzzrNle1MCDd7Nec51PwNIK1X6t2sOIp0rbdIZR7CbtgTmzs+Q6dWR+C9
         7acdyz0WjjMzzgcdIA0nzMcYVwbYIBbRXjyQQpf41wwbGOa+PNh29X4MUhBiB1AFb+FY
         pStFUIlV7ewSJP49Nch3ue+rzoit0TcOEepeR8/LM9meNPdY4AjDeV4RQjqzIruH91JJ
         PDlw==
X-Gm-Message-State: APjAAAWieOroi/N8Ene4rHmQnTYuImMVsepBMre3TOSdxWqSophpRPAi
        fNRBCebvysVowsVmhuj2C51pGeQuSbwY7cvbWnD+
X-Google-Smtp-Source: APXvYqyZ1ajHPuym4W3z4v6wVy6MZfzVlviDS1BRcZl71BwQ1OyRyhfTdoHXnxGNhdjdZaW+vFw8k+1L00KxXE56tGQ=
X-Received: by 2002:a19:86d7:: with SMTP id i206mr2675499lfd.119.1576081304311;
 Wed, 11 Dec 2019 08:21:44 -0800 (PST)
MIME-Version: 1.0
References: <20191206214934.11319-1-jolsa@kernel.org> <20191209121537.GA14170@linux.fritz.box>
 <CAHC9VhQdOGTj1HT1cwvAdE1sRpzk5mC+oHQLHgJFa3vXEij+og@mail.gmail.com>
 <d387184e-9c5f-d5b2-0acb-57b794235cbd@iogearbox.net> <CAHC9VhRDsEDGripZRrVNcjEBEEULPk+0dRp-uJ3nmmBK7B=sYQ@mail.gmail.com>
 <20191210153652.GA14123@krava> <CAHC9VhSa_B-VJOa_r8OcNrm0Yd_t1j3otWhKHgganSDx5Ni=Tg@mail.gmail.com>
 <20191211131955.GC23383@linux.fritz.box>
In-Reply-To: <20191211131955.GC23383@linux.fritz.box>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 11 Dec 2019 11:21:33 -0500
Message-ID: <CAHC9VhQqiD7BBGwLYuQVySG84iwR9MJh8GZuTU3xCBm7GLn8hw@mail.gmail.com>
Subject: Re: [PATCHv3] bpf: Emit audit messages upon successful prog load and unload
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-audit@redhat.com,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 8:20 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> On Tue, Dec 10, 2019 at 05:45:59PM -0500, Paul Moore wrote:
> > On Tue, Dec 10, 2019 at 10:37 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > On Mon, Dec 09, 2019 at 06:53:23PM -0500, Paul Moore wrote:
> > > > On Mon, Dec 9, 2019 at 6:19 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > > On 12/9/19 3:56 PM, Paul Moore wrote:
> > > > > > On Mon, Dec 9, 2019 at 7:15 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > > >> On Fri, Dec 06, 2019 at 10:49:34PM +0100, Jiri Olsa wrote:
> > > > > >>> From: Daniel Borkmann <daniel@iogearbox.net>
> > > > > >>>
> > > > > >>> Allow for audit messages to be emitted upon BPF program load and
> > > > > >>> unload for having a timeline of events. The load itself is in
> > > > > >>> syscall context, so additional info about the process initiating
> > > > > >>> the BPF prog creation can be logged and later directly correlated
> > > > > >>> to the unload event.
> > > > > >>>
> > > > > >>> The only info really needed from BPF side is the globally unique
> > > > > >>> prog ID where then audit user space tooling can query / dump all
> > > > > >>> info needed about the specific BPF program right upon load event
> > > > > >>> and enrich the record, thus these changes needed here can be kept
> > > > > >>> small and non-intrusive to the core.
> > > > > >>>
> > > > > >>> Raw example output:
> > > > > >>>
> > > > > >>>    # auditctl -D
> > > > > >>>    # auditctl -a always,exit -F arch=x86_64 -S bpf
> > > > > >>>    # ausearch --start recent -m 1334
> > > > > >>>    ...
> > > > > >>>    ----
> > > > > >>>    time->Wed Nov 27 16:04:13 2019
> > > > > >>>    type=PROCTITLE msg=audit(1574867053.120:84664): proctitle="./bpf"
> > > > > >>>    type=SYSCALL msg=audit(1574867053.120:84664): arch=c000003e syscall=321   \
> > > > > >>>      success=yes exit=3 a0=5 a1=7ffea484fbe0 a2=70 a3=0 items=0 ppid=7477    \
> > > > > >>>      pid=12698 auid=1001 uid=1001 gid=1001 euid=1001 suid=1001 fsuid=1001    \
> > > > > >>>      egid=1001 sgid=1001 fsgid=1001 tty=pts2 ses=4 comm="bpf"                \
> > > > > >>>      exe="/home/jolsa/auditd/audit-testsuite/tests/bpf/bpf"                  \
> > > > > >>>      subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
> > > > > >>>    type=UNKNOWN[1334] msg=audit(1574867053.120:84664): prog-id=76 op=LOAD
> > > > > >>>    ----
> > > > > >>>    time->Wed Nov 27 16:04:13 2019
> > > > > >>>    type=UNKNOWN[1334] msg=audit(1574867053.120:84665): prog-id=76 op=UNLOAD
> > > > > >>>    ...
> > > > > >>>
> > > > > >>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > > > > >>> Co-developed-by: Jiri Olsa <jolsa@kernel.org>
> > > > > >>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > > >>
> > > > > >> Paul, Steve, given the merge window is closed by now, does this version look
> > > > > >> okay to you for proceeding to merge into bpf-next?
> > > > > >
> > > > > > Given the change to audit UAPI I was hoping to merge this via the
> > > > > > audit/next tree, is that okay with you?
> > > > >
> > > > > Hm, my main concern is that given all the main changes are in BPF core and
> > > > > usually the BPF subsystem has plenty of changes per release coming in that we'd
> > > > > end up generating unnecessary merge conflicts. Given the include/uapi/linux/audit.h
> > > > > UAPI diff is a one-line change, my preference would be to merge via bpf-next with
> > > > > your ACK or SOB added. Does that work for you as well as?
> > > >
> > > > I regularly (a few times a week) run the audit and SELinux tests
> > > > against Linus+audit/next+selinux/next to make sure things are working
> > > > as expected and that some other subsystem has introduced a change
> > > > which has broken something.  If you are willing to ensure the tests
> > > > get run, including your new BPF audit tests I would be okay with that;
> > > > is that acceptable?
> > >
> > > would you please let me know which tree this landed at the end?
> >
> > I think that's what we are trying to figure out - Daniel?
>
> Yeah, sounds reasonable wrt running tests to make sure nothing breaks. In that
> case I'd wait for your ACK or SOB to proceed with merging into bpf-next. Thanks
> Paul!

As long as you're going to keep testing this, here ya go :)

Acked-by: Paul Moore <paul@paul-moore.com>

(also, go ahead and submit that PR for audit-testsuite - thanks!)

-- 
paul moore
www.paul-moore.com
