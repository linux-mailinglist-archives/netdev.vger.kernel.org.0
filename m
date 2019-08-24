Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2213D9BA0A
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 03:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfHXBST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 21:18:19 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34428 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfHXBSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 21:18:18 -0400
Received: by mail-pf1-f196.google.com with SMTP id b24so7672861pfp.1
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 18:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=hFC89CjETE6kSjgcVSwHDSYQXSiMoiEBQa3e+HIYt4Q=;
        b=E0CEXHhixhPPnduz4oCvzrE4SYv5LhBG86wlPOFAaizB/7Pzj9s3MqGo3cOQiKxH2H
         WMYn5lQwwEBQZbEaeBAENQsk/YFrhXIrg0RzuZMLncZ02XfQwLbYWYR9rt3b/takcJhE
         aSXhDyTFtKSGnsa2qZk6RJyQxRh2sPqWCqyGT3lBAIH99Hqpr3Pp4LuQHYrpj1T7RfKD
         NxtKlXH80DwCrwLgtye00jD3r875YOCXbKImkxbcOtaKojLdfF0B3pPECxdxWzjFWKZR
         a9AcMclmd+i08OU7h4fTOBV/Ey/MmTbLs2v1E5yu8DxLZcGN2G9BtmB5htE9RbR0cpgD
         S6nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=hFC89CjETE6kSjgcVSwHDSYQXSiMoiEBQa3e+HIYt4Q=;
        b=MMkzfLkFotIYkXyi+Tnx1BrE7Fy9E7H1G5x34FsXPSGkJCeLjI5Wtfa/7hEHZb6Mac
         alTxZBP7HQqQKBGBuQiuZt/ad3OsQXmOxDb1RHImhCEDfccjxWHE0arvaUYhhfCVkK6O
         6PX4+O8S/gpj03tBHerfAP1VG6ICPmAsbDdvakr2ys+wxeBhC2HHQphLyU4Pc1rkW0vn
         1QsNgz+S5u1yIeUxJnLChTCe1vPg4SVRCV2+eGSIRFT5fiI3ijCH/QzAyntgBbDgGLh9
         WAKfnfojvr7VwlgtBU44DeDJgVb0q44vYsAFVw7JvIWVo6KRW+HA9Pd9SO/TKduGV6+B
         +xlA==
X-Gm-Message-State: APjAAAVJwreUGFSWF0ZkXrTUovVtS41PbE9kxpmU7Zz1VD/tfD2+eOZq
        TjvFYgdeNKADVZKa4H1QEJyOLA==
X-Google-Smtp-Source: APXvYqwuX2JonhdUQesJbI454z6VwBTbUlXdP9d0uxq5+0I9DCD2aD552ligSdNeFL7iVFwXuBSZOw==
X-Received: by 2002:a17:90a:b890:: with SMTP id o16mr5418766pjr.41.1566609497976;
        Fri, 23 Aug 2019 18:18:17 -0700 (PDT)
Received: from localhost ([12.206.222.5])
        by smtp.gmail.com with ESMTPSA id g2sm8023188pfq.88.2019.08.23.18.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 18:18:17 -0700 (PDT)
Date:   Fri, 23 Aug 2019 18:18:16 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     David Abdurachmanov <david.abdurachmanov@gmail.com>
cc:     Tycho Andersen <tycho@tycho.ws>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Abdurachmanov <david.abdurachmanov@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Vincent Chen <vincentc@andestech.com>,
        Alan Kao <alankao@andestech.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, me@carlosedp.com
Subject: Re: [PATCH v2] riscv: add support for SECCOMP and SECCOMP_FILTER
In-Reply-To: <CAEn-LTp=ss0Dfv6J00=rCAy+N78U2AmhqJNjfqjr2FDpPYjxEQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.9999.1908231816500.18210@viisi.sifive.com>
References: <20190822205533.4877-1-david.abdurachmanov@sifive.com> <alpine.DEB.2.21.9999.1908231717550.25649@viisi.sifive.com> <CAEn-LTp=ss0Dfv6J00=rCAy+N78U2AmhqJNjfqjr2FDpPYjxEQ@mail.gmail.com>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Aug 2019, David Abdurachmanov wrote:

> On Fri, Aug 23, 2019 at 5:30 PM Paul Walmsley <paul.walmsley@sifive.com> wrote:
> >
> > On Thu, 22 Aug 2019, David Abdurachmanov wrote:
> >
> > > There is one failing kernel selftest: global.user_notification_signal
> >
> > Is this the only failing test?  Or are the rest of the selftests skipped
> > when this test fails, and no further tests are run, as seems to be shown
> > here:
> >
> >   https://lore.kernel.org/linux-riscv/CADnnUqcmDMRe1f+3jG8SPR6jRrnBsY8VVD70VbKEm0NqYeoicA@mail.gmail.com/
> 
> Yes, it's a single test failing. After removing global.user_notification_signal
> test everything else pass and you get the results printed.

OK.

> Well the code states ".. and hope that it doesn't break when there
> is actually a signal :)". Maybe we are just unlucky. I don't have results
> from other architectures to compare.
> 
> I found that Linaro is running selftests, but SECCOMP is disabled
> and thus it's failing. Is there another CI which tracks selftests?

0day runs the kselftests, and at least on some architectures/Kconfigs, 
it's succeeding:

https://lore.kernel.org/lkml/20190726083740.GG22106@shao2-debian/

https://lore.kernel.org/lkml/20190712064850.GC20848@shao2-debian/

https://lore.kernel.org/lkml/20190311074115.GC10839@shao2-debian/

etc.


- Paul
