Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC721116FC1
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 15:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfLIO4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 09:56:36 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36211 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbfLIO4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 09:56:35 -0500
Received: by mail-lj1-f196.google.com with SMTP id r19so16010109ljg.3
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 06:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RsQfOlFUGzZqyf3ezmn5EcB8XlzWrV/TpuS1nL9HyUA=;
        b=HmqNilUPBpuSeEhFN0/1Tf+9RVxhRdXssPGLXz5+jl0rG9uPXIL03HEDnMkqqIkX1n
         /HJOT0PKJqCC7oO0rlWDDP0qISiTzfhTl0cY3N6ut+GFplobes3omhkTjUS2fbRFDIig
         rfsQtl0/YNPyEi8/Uscib3qIhnEfkp+CjJD2Kz6hFTNAgHwFee9Ky+0kCNP3SLxUqgiA
         uCnQ0yC3YQwzy3GIKxTYmLjivd4Yv7jsPZV9Pr/TM5qKFKIC7R3et0cXWne6s/vntQKQ
         RoTwHoK9Hfhgw2ZwCxzU2wY6xjj5O4PFrsjwtAtmSriS+Tu1DW/Cdeh3IcHlmlDwXg6H
         Xa/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RsQfOlFUGzZqyf3ezmn5EcB8XlzWrV/TpuS1nL9HyUA=;
        b=Q0+KB1rgoOfELsiqVHMBTE0joUZNiHAMLaw//9+aqnT3gF3I/CVk8PtorcR2RlI0ze
         fU4OrZAe/2bxbsdhgmt/sYPZwxbbsj5SucetaBCsAtQQoTN6/7N0c9fw3apaa6vc3ABN
         5IUEOsOlJd9yDHJbXZEtRF6OL+JxKVVzWebVWcji2nWLFZMAO66v214uRrjhZDMDAKj5
         4LdsLdHwZbWNH/PvA2+pp21A1WZ5L66AOtOqtuaDiRdLqm3cfpMiRzlSZcm5bBfcfg1l
         GVXqox6UgE5vJ/Zx+wZcc3+2mW1gkPRJsLBid0wZ0+4QE2hBYShWJzhXvA7qRnM09eGd
         TF3g==
X-Gm-Message-State: APjAAAUnxwypMPJlTdSGVmEo0XPgjGKbKzKn2b+k4FXbp4URbOgWtbFS
        7uBudHsc431pkRXbd8VCviL1rdidiQEf4It0qn3Y
X-Google-Smtp-Source: APXvYqzEIjSqtPTCB2cfVEMG6x0at7HT07j/bt6UvxOXj8LpjTFeTQmPmWYxjSCxxluC4FcTeVwB0BNgblygXkcpdFM=
X-Received: by 2002:a2e:99cd:: with SMTP id l13mr3012994ljj.243.1575903393503;
 Mon, 09 Dec 2019 06:56:33 -0800 (PST)
MIME-Version: 1.0
References: <20191206214934.11319-1-jolsa@kernel.org> <20191209121537.GA14170@linux.fritz.box>
In-Reply-To: <20191209121537.GA14170@linux.fritz.box>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 9 Dec 2019 09:56:22 -0500
Message-ID: <CAHC9VhQdOGTj1HT1cwvAdE1sRpzk5mC+oHQLHgJFa3vXEij+og@mail.gmail.com>
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

On Mon, Dec 9, 2019 at 7:15 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> On Fri, Dec 06, 2019 at 10:49:34PM +0100, Jiri Olsa wrote:
> > From: Daniel Borkmann <daniel@iogearbox.net>
> >
> > Allow for audit messages to be emitted upon BPF program load and
> > unload for having a timeline of events. The load itself is in
> > syscall context, so additional info about the process initiating
> > the BPF prog creation can be logged and later directly correlated
> > to the unload event.
> >
> > The only info really needed from BPF side is the globally unique
> > prog ID where then audit user space tooling can query / dump all
> > info needed about the specific BPF program right upon load event
> > and enrich the record, thus these changes needed here can be kept
> > small and non-intrusive to the core.
> >
> > Raw example output:
> >
> >   # auditctl -D
> >   # auditctl -a always,exit -F arch=x86_64 -S bpf
> >   # ausearch --start recent -m 1334
> >   ...
> >   ----
> >   time->Wed Nov 27 16:04:13 2019
> >   type=PROCTITLE msg=audit(1574867053.120:84664): proctitle="./bpf"
> >   type=SYSCALL msg=audit(1574867053.120:84664): arch=c000003e syscall=321   \
> >     success=yes exit=3 a0=5 a1=7ffea484fbe0 a2=70 a3=0 items=0 ppid=7477    \
> >     pid=12698 auid=1001 uid=1001 gid=1001 euid=1001 suid=1001 fsuid=1001    \
> >     egid=1001 sgid=1001 fsgid=1001 tty=pts2 ses=4 comm="bpf"                \
> >     exe="/home/jolsa/auditd/audit-testsuite/tests/bpf/bpf"                  \
> >     subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
> >   type=UNKNOWN[1334] msg=audit(1574867053.120:84664): prog-id=76 op=LOAD
> >   ----
> >   time->Wed Nov 27 16:04:13 2019
> >   type=UNKNOWN[1334] msg=audit(1574867053.120:84665): prog-id=76 op=UNLOAD
> >   ...
> >
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > Co-developed-by: Jiri Olsa <jolsa@kernel.org>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>
> Paul, Steve, given the merge window is closed by now, does this version look
> okay to you for proceeding to merge into bpf-next?

Given the change to audit UAPI I was hoping to merge this via the
audit/next tree, is that okay with you?

-- 
paul moore
www.paul-moore.com
