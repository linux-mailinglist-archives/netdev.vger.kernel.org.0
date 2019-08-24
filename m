Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86DCF9B9F4
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 03:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfHXBFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 21:05:00 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38180 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfHXBFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 21:05:00 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so10128586wrr.5;
        Fri, 23 Aug 2019 18:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gO3LZsXjDlrVljuF9pShs5ZK+ZVOT1ian+diPFOlUwA=;
        b=NZHvEK/V3VkNVqCIhrt20Lp0WSO1CreVQJZ66aCZCkcyIB8z4QKnjAs/psGK4aK7Rr
         CQ1upJMbOYnl0VFSIZxTgQ4dT4ZN/JwOG1juhr/MY7HGgZi56OVPJ++4nNZfelAQDand
         6IJvdE/PDPxqHcOUv0xinNwmBuytwU+ZALDOaanc+5FFIfPOHCm0PRT9PMR4hJxCbN+w
         hkrH5QjyjawjNbpMdj/d+Uh7sZfoCRdhmx0TukKHL1A+jksI6dy+elWrJoKnaGNSichm
         PN5eT6btNihSlj3aJOlxMZHxRGIphTtMup50MaI0l6okUd1fieScQEi9gcG8ce53louc
         /26Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gO3LZsXjDlrVljuF9pShs5ZK+ZVOT1ian+diPFOlUwA=;
        b=jnaHXRQqGDMh5JQj6gQKLjOuhYsV4F0vkV1QXFD4O1Xg3jjPxyPMA4y8mwEw15QcMZ
         3wyTP1awRZagSq7lBOyYBFDTfhU9kBzUB8Mag9e9/9Z47B78VWKRx7++R5onuMf7qNDI
         aS1hG/9KxnMmE56Ijgbt/i5nZ+hRhnXvj0oWmXGz2jnP6ER6AO2l0MY3ceu1e2JjR+xg
         A3JJ0FE5DzriTSvuzr3eJR0igNlOVBncId/3lsURpNfZtLAEOHQPLXBsWdlyPEsJ8rMq
         qlYMusS3l+rQ5DrWqL3RyUPAh0zLmTJ/onpAKQPAqoVEAg/9CgvlcHUv5IZlCb7UwsXn
         HW9w==
X-Gm-Message-State: APjAAAU/WfwBp8UORN8mAkTsxOdp+SEs6Cmw0vpOEi664QjJUHWlcGQ9
        wM/5V088qPJFsdtOvQIaTkX0N0rTzrvjQDGciiI=
X-Google-Smtp-Source: APXvYqz5D7mMCrFwuM61+YXLObcN7TIlZLLBVn5w7crug7bbJPeOkjW+pxDkAfdiT8kM2i/oWuAUBaisZi/3YkTbHYQ=
X-Received: by 2002:adf:f2c1:: with SMTP id d1mr8183863wrp.157.1566608697250;
 Fri, 23 Aug 2019 18:04:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190822205533.4877-1-david.abdurachmanov@sifive.com> <alpine.DEB.2.21.9999.1908231717550.25649@viisi.sifive.com>
In-Reply-To: <alpine.DEB.2.21.9999.1908231717550.25649@viisi.sifive.com>
From:   David Abdurachmanov <david.abdurachmanov@gmail.com>
Date:   Fri, 23 Aug 2019 18:04:21 -0700
Message-ID: <CAEn-LTp=ss0Dfv6J00=rCAy+N78U2AmhqJNjfqjr2FDpPYjxEQ@mail.gmail.com>
Subject: Re: [PATCH v2] riscv: add support for SECCOMP and SECCOMP_FILTER
To:     Paul Walmsley <paul.walmsley@sifive.com>
Cc:     Tycho Andersen <tycho@tycho.ws>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 5:30 PM Paul Walmsley <paul.walmsley@sifive.com> wrote:
>
> On Thu, 22 Aug 2019, David Abdurachmanov wrote:
>
> > There is one failing kernel selftest: global.user_notification_signal
>
> Is this the only failing test?  Or are the rest of the selftests skipped
> when this test fails, and no further tests are run, as seems to be shown
> here:
>
>   https://lore.kernel.org/linux-riscv/CADnnUqcmDMRe1f+3jG8SPR6jRrnBsY8VVD70VbKEm0NqYeoicA@mail.gmail.com/

Yes, it's a single test failing. After removing global.user_notification_signal
test everything else pass and you get the results printed.

>
> For example, looking at the source, I'd naively expect to see the
> user_notification_closed_listener test result -- which follows right
> after the failing test in the selftest source.  But there aren't any
> results?

Yes, it hangs at this point. You have to manually terminate it.

>
> Also - could you follow up with the author of this failing test to see if
> we can get some more clarity about what might be going wrong here?  It
> appears that the failing test was added in commit 6a21cc50f0c7f ("seccomp:
> add a return code to trap to userspace") by Tycho Andersen
> <tycho@tycho.ws>.

Well the code states ".. and hope that it doesn't break when there
is actually a signal :)". Maybe we are just unlucky. I don't have results
from other architectures to compare.

I found that Linaro is running selftests, but SECCOMP is disabled
and thus it's failing. Is there another CI which tracks selftests?

https://qa-reports.linaro.org/lkft/linux-next-oe/tests/kselftest/seccomp_seccomp_bpf?top=next-20190823

>
>
> - Paul
