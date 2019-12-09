Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1601117BD7
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 00:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfLIXxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 18:53:37 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37750 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfLIXxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 18:53:37 -0500
Received: by mail-lj1-f193.google.com with SMTP id u17so17723383lja.4
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 15:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8PYO3gKOvpQJUKoPD4Ucl8MVrwdN3gMad52iHtR/vZs=;
        b=uNIvwKuUJUxV53loQOeaM/o9OzquvKgMQxAKv1tzc1Hl0aojhv/hJfrHlMebF56Ed1
         wBUZJH4bUGx/OPdnE0tB56rphcIyScW02U1GuxlJAXr3D1dWj05IjfiZhEpES96gX21+
         cVLRpYDN+8Yqdt6/JLICWCKQrgxGRIxeGJXKz4UuDjp+FHlYc0mnLxAu60In87Ml8Ico
         n8AM+kuo6M8gLio4E71FslY0sR7A8HekUsePuvTGpITXka9+h2sbyJ/dn8pov+U2Yv+F
         SnSg8Z33ik5+gk5D4hfCqKs+IH6L4Zvvx8IVE+Uhm46a1VSFGA+LRbz7W6JdpCmZNqqb
         0FVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8PYO3gKOvpQJUKoPD4Ucl8MVrwdN3gMad52iHtR/vZs=;
        b=UkTTBGNxM/Lni68Bn8AmEhCbIrQxmKYrzymSIyrwbK+S16dmgXJvO8D7Rz3ERjesKk
         ZJKUPYidauemw5cpszsQQQvr0LcUaT1tK3gHWvWEjgUr8XXhkEeGsROrvtYDDBBt2JhC
         0n0rPIPmtEHWZ41xhY7Xwvfi+u6tMJwohTpz1bIJROKVBz7vaRMTyq+37LDcBKhJuAWV
         k9AYmrLqHNfRdeUGLnCrg++Pj0Dbmf1Kvm0OE///dF+qIWNlxDQ8jxWlAYeXp1q9DIXl
         ANEuym4yNz4gMDdqCoMv74+yRCIJonLp3ddKI1ymvrDK1HTzOfXrp5Cp8d9/06qU7wsQ
         PURQ==
X-Gm-Message-State: APjAAAVNDqXyd/73bhstTaChjzrnwxLuZWsHrsiY4E/YAmnlMGCQUgVq
        gPA7Lp2g3eukLdmmQgZLxNAHGlhCfoHKoYn+V2DG
X-Google-Smtp-Source: APXvYqxm5P6p8PMa6Ve7YcMvKPOBDHSKqfXxUTTrADm7WlA8FeZonMrFtrUaZwY0Q7lPO92mGz404lWFoQ6nO9KpZis=
X-Received: by 2002:a2e:99cd:: with SMTP id l13mr4379179ljj.243.1575935614551;
 Mon, 09 Dec 2019 15:53:34 -0800 (PST)
MIME-Version: 1.0
References: <20191206214934.11319-1-jolsa@kernel.org> <20191209121537.GA14170@linux.fritz.box>
 <CAHC9VhQdOGTj1HT1cwvAdE1sRpzk5mC+oHQLHgJFa3vXEij+og@mail.gmail.com> <d387184e-9c5f-d5b2-0acb-57b794235cbd@iogearbox.net>
In-Reply-To: <d387184e-9c5f-d5b2-0acb-57b794235cbd@iogearbox.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 9 Dec 2019 18:53:23 -0500
Message-ID: <CAHC9VhRDsEDGripZRrVNcjEBEEULPk+0dRp-uJ3nmmBK7B=sYQ@mail.gmail.com>
Subject: Re: [PATCHv3] bpf: Emit audit messages upon successful prog load and unload
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-audit@redhat.com, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 9, 2019 at 6:19 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 12/9/19 3:56 PM, Paul Moore wrote:
> > On Mon, Dec 9, 2019 at 7:15 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >> On Fri, Dec 06, 2019 at 10:49:34PM +0100, Jiri Olsa wrote:
> >>> From: Daniel Borkmann <daniel@iogearbox.net>
> >>>
> >>> Allow for audit messages to be emitted upon BPF program load and
> >>> unload for having a timeline of events. The load itself is in
> >>> syscall context, so additional info about the process initiating
> >>> the BPF prog creation can be logged and later directly correlated
> >>> to the unload event.
> >>>
> >>> The only info really needed from BPF side is the globally unique
> >>> prog ID where then audit user space tooling can query / dump all
> >>> info needed about the specific BPF program right upon load event
> >>> and enrich the record, thus these changes needed here can be kept
> >>> small and non-intrusive to the core.
> >>>
> >>> Raw example output:
> >>>
> >>>    # auditctl -D
> >>>    # auditctl -a always,exit -F arch=x86_64 -S bpf
> >>>    # ausearch --start recent -m 1334
> >>>    ...
> >>>    ----
> >>>    time->Wed Nov 27 16:04:13 2019
> >>>    type=PROCTITLE msg=audit(1574867053.120:84664): proctitle="./bpf"
> >>>    type=SYSCALL msg=audit(1574867053.120:84664): arch=c000003e syscall=321   \
> >>>      success=yes exit=3 a0=5 a1=7ffea484fbe0 a2=70 a3=0 items=0 ppid=7477    \
> >>>      pid=12698 auid=1001 uid=1001 gid=1001 euid=1001 suid=1001 fsuid=1001    \
> >>>      egid=1001 sgid=1001 fsgid=1001 tty=pts2 ses=4 comm="bpf"                \
> >>>      exe="/home/jolsa/auditd/audit-testsuite/tests/bpf/bpf"                  \
> >>>      subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
> >>>    type=UNKNOWN[1334] msg=audit(1574867053.120:84664): prog-id=76 op=LOAD
> >>>    ----
> >>>    time->Wed Nov 27 16:04:13 2019
> >>>    type=UNKNOWN[1334] msg=audit(1574867053.120:84665): prog-id=76 op=UNLOAD
> >>>    ...
> >>>
> >>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> >>> Co-developed-by: Jiri Olsa <jolsa@kernel.org>
> >>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> >>
> >> Paul, Steve, given the merge window is closed by now, does this version look
> >> okay to you for proceeding to merge into bpf-next?
> >
> > Given the change to audit UAPI I was hoping to merge this via the
> > audit/next tree, is that okay with you?
>
> Hm, my main concern is that given all the main changes are in BPF core and
> usually the BPF subsystem has plenty of changes per release coming in that we'd
> end up generating unnecessary merge conflicts. Given the include/uapi/linux/audit.h
> UAPI diff is a one-line change, my preference would be to merge via bpf-next with
> your ACK or SOB added. Does that work for you as well as?

I regularly (a few times a week) run the audit and SELinux tests
against Linus+audit/next+selinux/next to make sure things are working
as expected and that some other subsystem has introduced a change
which has broken something.  If you are willing to ensure the tests
get run, including your new BPF audit tests I would be okay with that;
is that acceptable?

-- 
paul moore
www.paul-moore.com
