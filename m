Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFB8119E84
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfLJWqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:46:14 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36327 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfLJWqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 17:46:14 -0500
Received: by mail-lj1-f196.google.com with SMTP id r19so21784204ljg.3
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 14:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iqidpsRetevR7KQf2spiLZEXt1H+oFvx8yu6gvT2PyY=;
        b=z/kxokg0605hqzDYiyrxq2x9Kyh+BMYxxmWS8jrbxqlOFo8Xo/aAb1sJtqw1Pn9PdN
         deUpk3LibVV0+9VeRj+wDPcCDd+tz+NI5Eyje4m9db2BI6uGgmE9NQO2eLJ6LMN9yBX2
         IMsIeTCd+Jr9bXHYMTsKzudH7CU89kX/SYRyldUeAXeKL+Ys01awCUBj4zig71+d+oOu
         nNHQYWTlo4WI9gB37T8tf0qBDt8WpbBZ822KurKsTHDl1JUSZeHBT+PiQmeIe1vjz3S6
         lCaKSEDNwF/q04epKMXNXXfAwyV0XyPWwVEc9EF/kIyisDMLm0+fa9gmRH2AxqNTT0iX
         9aAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iqidpsRetevR7KQf2spiLZEXt1H+oFvx8yu6gvT2PyY=;
        b=YcN+DvmxxgDrBlMHGTy3jVYYtsRw5mfeW6TPisDYH0+u8LazULzwwIjqyvT4vLuNMN
         DKsGzj/e/nUsyru5CeJ/kO4VbInpNFVazmZPG43kEsgTOBJ1PRn+JcvIQCq0nTCgPGDf
         gjZIqmWR3pJKO1ALNXFDJMaR5od/Lz+dEIUpVOIonIX7R+JYg7bkku3hnr5BGa8+y/t8
         N2iu2Ex9AALd2y7HhIeEj0+lJambzj9jqiKDHn+q+8v/r+hwA1/WZqVZgiqOuP8pLKpG
         yy3KFBbYyiwx3xrefCMiovuFX/rlAHtQPC0gK9M9LV/z7AxEtnW6KWa9dMeYrGXnehI+
         Ealw==
X-Gm-Message-State: APjAAAWdAUKL5RzjGIeLm8X5yUjondPoDmTXVGDwRLGFNKLC06roLV0r
        KJDwL+C2UBawg2k+Y00pI+jZNuiEy6IDkMx4PhKj
X-Google-Smtp-Source: APXvYqwwFpweBwuruZL/D9PCPIdAr4GxZUnVllKgDndZSSzILeWdfLDomxs8nWamvvW8Y3aYKfYQw+55pd3HU/tS5yg=
X-Received: by 2002:a2e:800b:: with SMTP id j11mr20040516ljg.126.1576017970966;
 Tue, 10 Dec 2019 14:46:10 -0800 (PST)
MIME-Version: 1.0
References: <20191206214934.11319-1-jolsa@kernel.org> <20191209121537.GA14170@linux.fritz.box>
 <CAHC9VhQdOGTj1HT1cwvAdE1sRpzk5mC+oHQLHgJFa3vXEij+og@mail.gmail.com>
 <d387184e-9c5f-d5b2-0acb-57b794235cbd@iogearbox.net> <CAHC9VhRDsEDGripZRrVNcjEBEEULPk+0dRp-uJ3nmmBK7B=sYQ@mail.gmail.com>
 <20191210153652.GA14123@krava>
In-Reply-To: <20191210153652.GA14123@krava>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 10 Dec 2019 17:45:59 -0500
Message-ID: <CAHC9VhSa_B-VJOa_r8OcNrm0Yd_t1j3otWhKHgganSDx5Ni=Tg@mail.gmail.com>
Subject: Re: [PATCHv3] bpf: Emit audit messages upon successful prog load and unload
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>,
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

On Tue, Dec 10, 2019 at 10:37 AM Jiri Olsa <jolsa@redhat.com> wrote:
> On Mon, Dec 09, 2019 at 06:53:23PM -0500, Paul Moore wrote:
> > On Mon, Dec 9, 2019 at 6:19 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > On 12/9/19 3:56 PM, Paul Moore wrote:
> > > > On Mon, Dec 9, 2019 at 7:15 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > >> On Fri, Dec 06, 2019 at 10:49:34PM +0100, Jiri Olsa wrote:
> > > >>> From: Daniel Borkmann <daniel@iogearbox.net>
> > > >>>
> > > >>> Allow for audit messages to be emitted upon BPF program load and
> > > >>> unload for having a timeline of events. The load itself is in
> > > >>> syscall context, so additional info about the process initiating
> > > >>> the BPF prog creation can be logged and later directly correlated
> > > >>> to the unload event.
> > > >>>
> > > >>> The only info really needed from BPF side is the globally unique
> > > >>> prog ID where then audit user space tooling can query / dump all
> > > >>> info needed about the specific BPF program right upon load event
> > > >>> and enrich the record, thus these changes needed here can be kept
> > > >>> small and non-intrusive to the core.
> > > >>>
> > > >>> Raw example output:
> > > >>>
> > > >>>    # auditctl -D
> > > >>>    # auditctl -a always,exit -F arch=x86_64 -S bpf
> > > >>>    # ausearch --start recent -m 1334
> > > >>>    ...
> > > >>>    ----
> > > >>>    time->Wed Nov 27 16:04:13 2019
> > > >>>    type=PROCTITLE msg=audit(1574867053.120:84664): proctitle="./bpf"
> > > >>>    type=SYSCALL msg=audit(1574867053.120:84664): arch=c000003e syscall=321   \
> > > >>>      success=yes exit=3 a0=5 a1=7ffea484fbe0 a2=70 a3=0 items=0 ppid=7477    \
> > > >>>      pid=12698 auid=1001 uid=1001 gid=1001 euid=1001 suid=1001 fsuid=1001    \
> > > >>>      egid=1001 sgid=1001 fsgid=1001 tty=pts2 ses=4 comm="bpf"                \
> > > >>>      exe="/home/jolsa/auditd/audit-testsuite/tests/bpf/bpf"                  \
> > > >>>      subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
> > > >>>    type=UNKNOWN[1334] msg=audit(1574867053.120:84664): prog-id=76 op=LOAD
> > > >>>    ----
> > > >>>    time->Wed Nov 27 16:04:13 2019
> > > >>>    type=UNKNOWN[1334] msg=audit(1574867053.120:84665): prog-id=76 op=UNLOAD
> > > >>>    ...
> > > >>>
> > > >>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > > >>> Co-developed-by: Jiri Olsa <jolsa@kernel.org>
> > > >>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > >>
> > > >> Paul, Steve, given the merge window is closed by now, does this version look
> > > >> okay to you for proceeding to merge into bpf-next?
> > > >
> > > > Given the change to audit UAPI I was hoping to merge this via the
> > > > audit/next tree, is that okay with you?
> > >
> > > Hm, my main concern is that given all the main changes are in BPF core and
> > > usually the BPF subsystem has plenty of changes per release coming in that we'd
> > > end up generating unnecessary merge conflicts. Given the include/uapi/linux/audit.h
> > > UAPI diff is a one-line change, my preference would be to merge via bpf-next with
> > > your ACK or SOB added. Does that work for you as well as?
> >
> > I regularly (a few times a week) run the audit and SELinux tests
> > against Linus+audit/next+selinux/next to make sure things are working
> > as expected and that some other subsystem has introduced a change
> > which has broken something.  If you are willing to ensure the tests
> > get run, including your new BPF audit tests I would be okay with that;
> > is that acceptable?
>
> hi,
> would you please let me know which tree this landed at the end?

I think that's what we are trying to figure out - Daniel?

-- 
paul moore
www.paul-moore.com
