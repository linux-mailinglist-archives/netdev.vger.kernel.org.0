Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C0E19BB7C
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 08:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgDBGCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 02:02:19 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:37787 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgDBGCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 02:02:19 -0400
Received: by mail-yb1-f196.google.com with SMTP id n2so1480581ybg.4
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 23:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NEgNPHluRfItcxQUMYfomipK8ksOhnsPxteU6rGde1g=;
        b=uVi/XfjbJdqTht9u0Q59lLh/ksnTnIvLqBD0g7fMkjkiuYQTg3JwkQM4bCkO6qpKix
         aL+kcM0cV6wZeU4LsVhMm/Ozb+fn7zOtsP8e9beKH4j+92lYX48JFBF8lpxaTDjThYYx
         YHibnaFUF0FGBMfOGEXkKfa45DPCPcyeAn3YF4eJqfNP9ee279Pi2wDbD8opXGg35qdu
         RQ1kTzAbiKxoyKtg3Aty8edmzlVTE0+1yux1Nvz/hoICBo9pOCGejyLkXYSqI/GicZZ2
         D5skJj0UapJKH3K/NxLComkiRZUzUTwZs9ZTOSczddEb0YPaKgUJ57jY3aaB751W15FW
         iuEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NEgNPHluRfItcxQUMYfomipK8ksOhnsPxteU6rGde1g=;
        b=SGYZy6mOyddLy95cm67dCUq+nqbW3VH6htVBQG+Kp3/GjYO5OuvwPQaun7R/uoHvb2
         aukC+pDKu5ccVkFJKXyybhnf24MtKV/KTPJnbks+ol4JY2G1C5Rr5SjzGBb9S2/vTBz+
         JOW9zZm34xfTz7GHw1Rl20yuaxJBDCna6CMU6w80fjK2kl9oLO2ZJI1UpO5L7a/V3b+R
         06A3caggrELCW3JdUcasZlkxli7inl8Lsm/RIPpEpQtzwtP7tgJ0FK0hFDKu9Bg874lU
         PLkC1Bq3jvFl24SOJTyS7H2Kaz5YYtuR0lZaIbAjHTW9f9qfCRgQuYBNhq6CMIKfC3R8
         IwjA==
X-Gm-Message-State: AGi0PuYfDfHqfp47Fa/CJre5fgL7QIwdyC0YjatLYIzaDv4JQadTsR9g
        pmrUqqHudv8bYz7OJ3zwBpBVavvxTxl6MuQ1KEo=
X-Google-Smtp-Source: APiQypJWCNwxkOow9jDQlkQG/jEuOEX5aYwmVS0aztC0595puJzbJZbSezQKAHNI/eyC8+BjJB/E4c9fxsmxde4ZeKQ=
X-Received: by 2002:a25:9d12:: with SMTP id i18mr2838372ybp.306.1585807337921;
 Wed, 01 Apr 2020 23:02:17 -0700 (PDT)
MIME-Version: 1.0
References: <CADdPHGsD4b5GNoLy3aPQndkA84P_m33o-G1kP7F7Xkhterw0Vw@mail.gmail.com>
 <386b1135-6a3b-f006-021f-95ba07f42ec5@gmail.com>
In-Reply-To: <386b1135-6a3b-f006-021f-95ba07f42ec5@gmail.com>
From:   Stefan Majer <stefan.majer@gmail.com>
Date:   Thu, 2 Apr 2020 08:02:06 +0200
Message-ID: <CADdPHGssX0VXafhiHObcc3Jb+oFRc4SLzXM3K_Srhd+cBL2VDA@mail.gmail.com>
Subject: Re: PATCH: Error message if set memlock=infinite failed during bpf load
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

i thought is was my poor C knowledge that i was unable to get the
point where bpf_init_env is called from ip vrf, but thanks.

So should we also do:

diff --git a/ip/ipvrf.c b/ip/ipvrf.c
index b9a43675..16d19621 100644
--- a/ip/ipvrf.c
+++ b/ip/ipvrf.c
@@ -256,6 +256,8 @@ static int prog_load(int idx)
                BPF_EXIT_INSN(),
        };

+       bpf_init_env();
+
        return bpf_prog_load(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
                             "GPL", bpf_log_buf, sizeof(bpf_log_buf));
 }
diff --git a/lib/bpf.c b/lib/bpf.c
index 10cf9bf4..210830d9 100644
--- a/lib/bpf.c
+++ b/lib/bpf.c
@@ -1416,8 +1416,8 @@ static void bpf_init_env(void)
                .rlim_max = RLIM_INFINITY,
        };

-       /* Don't bother in case we fail! */
-       setrlimit(RLIMIT_MEMLOCK, &limit);
+       if (!setrlimit(RLIMIT_MEMLOCK, &limit))
+               fprintf(stderr, "Continue without setting ulimit
memlock=infinity. Error:%s\n", strerror(errno));

        if (!bpf_get_work_dir(BPF_PROG_TYPE_UNSPEC))
                fprintf(stderr, "Continuing without mounted eBPF fs.
Too old kernel?\n");

Greetings
Stefan

On Wed, Apr 1, 2020 at 9:57 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 4/1/20 12:57 AM, Stefan Majer wrote:
> > Executing ip vrf exec <vrfname> command sometimes fails with:
> >
> > bpf: Failed to load program: Operation not permitted
> >
> > This error message might be misleading because the underlying reason can be
> > that memlock limit is to small.
> >
> > It is already implemented to set memlock to infinite, but without
> > error handling.
> >
> > With this patch at least a warning is printed out to inform the user
> > what might be the root cause.
> >
> >
> > Signed-off-by: Stefan Majer <stefan.majer@gmail.com>
> >
> > diff --git a/lib/bpf.c b/lib/bpf.c
> > index 10cf9bf4..210830d9 100644
> > --- a/lib/bpf.c
> > +++ b/lib/bpf.c
> > @@ -1416,8 +1416,8 @@ static void bpf_init_env(void)
> >   .rlim_max = RLIM_INFINITY,
> >   };
> >
> > - /* Don't bother in case we fail! */
> > - setrlimit(RLIMIT_MEMLOCK, &limit);
> > + if (!setrlimit(RLIMIT_MEMLOCK, &limit))
> > + fprintf(stderr, "Continue without setting ulimit memlock=infinity.
> > Error:%s\n", strerror(errno));
> >
> >   if (!bpf_get_work_dir(BPF_PROG_TYPE_UNSPEC))
> >   fprintf(stderr, "Continuing without mounted eBPF fs. Too old kernel?\n");
> >
>
> bpf_init_env is not called for 'ip vrf exec'.
>
> Since other bpf code raises the limit it would be consistent for 'ip vrf
> exec' to do the same. I know this limit has been a pain for some users.



-- 
Stefan Majer
