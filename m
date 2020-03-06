Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC87317B713
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 07:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgCFGyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 01:54:24 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33829 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgCFGyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 01:54:24 -0500
Received: by mail-qk1-f194.google.com with SMTP id f3so1406129qkh.1
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 22:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cLPWvNSOP+MV0re84hb9zPh4ZB9yhzDFVpwkdYDOR0g=;
        b=KtpK3NRr31C3Zs9+iMc3xBFMAmP08JX/SerSGM6MIlhwnXB6VMywnHD+3l4MOrmIwZ
         0U/bVgypm84jvwmeNGsp4xOj9+5FRC/wm972l41SrPyEZ8Ym2gHix/GQSNGVarFuVbe+
         LwikB0B1aeh4YNxGCNTVWj5yWcgT8EgSZNARnWkuCjyP/8eAAi+G/gWK+9ExnXN/UfUt
         0u7ihMju8OwDXTxP0NfxDSJtURS7FI17USifMsAe3/rjAvmJOK8ZXt0c8WlSC3/AIRfI
         iOwrBDxKe2S0Z5Ey96LU+NKAwgu0dsfr92sHQdGDlKeyXO1Vxwjeyl19u5+cng6PAbPS
         GQEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cLPWvNSOP+MV0re84hb9zPh4ZB9yhzDFVpwkdYDOR0g=;
        b=uIcdIW5SbCesnnz2+38mZCPS4ZkkqIdAcPwWmK7LNS+UAZV6c1wUiYCQ/eMojwFGWl
         bQugD3JTWx4H17cUIqWrExyQ08Rbmjsrk4o+gY743dtjBrC4759CdgA6BUwc+9139ap4
         5IG2XFm8pFlJ4cisqh6t+zch2DbqPsTS51Ro9za1SpRuXca30r8Uz9cFXss+axmlZy7G
         RraCPbh7LGG1WPrP0LytgZx9784gGQVV63vev9HKi+YRVfzRR6YwvfgKFXou5QcPVt9X
         YhXsnfivsHb9bDs50mHyfk8fQAoWbRo2R6it7j/dNBe+me/CqFEqLxPka/DaX/i9c050
         afkA==
X-Gm-Message-State: ANhLgQ3ew4QO1+KaqsvydYuIjefgEq913rgOgEhkrAxTMchgSwQ2hey/
        ECAYMBJk4j8anNeQdDzGyHsjGE9+ZXsRinzqA6yRew==
X-Google-Smtp-Source: ADFU+vtjq1CHk59NKlxZ+Q0+ZtkJWXxUc4bWCPtGHAQuv7SM1AexEu4KMsDKH+gUyTmanpep3anqs6BLB9SoFjsuTv0=
X-Received: by 2002:ae9:e003:: with SMTP id m3mr1688430qkk.250.1583477663066;
 Thu, 05 Mar 2020 22:54:23 -0800 (PST)
MIME-Version: 1.0
References: <0000000000001b2259059c654421@google.com> <20200121180255.1c98b54c@gandalf.local.home>
 <20200122055314.GD1847@kadam> <CACT4Y+ZP-7np20GVRu3p+eZys9GPtbu+JpfV+HtsufAzvTgJrg@mail.gmail.com>
 <20200124102830.52911ff4@gandalf.local.home>
In-Reply-To: <20200124102830.52911ff4@gandalf.local.home>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 6 Mar 2020 07:54:11 +0100
Message-ID: <CACT4Y+YA4AygABGNaQv5GUm-LJyOjCWot7eBGNCbqugS9K2RrA@mail.gmail.com>
Subject: Re: WARNING in tracing_func_proto
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        syzbot <syzbot+0c147ca7bd4352547635@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 4:28 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 24 Jan 2020 11:44:13 +0100
> Dmitry Vyukov <dvyukov@google.com> wrote:
>
> > FWIW this is invalid use of WARN macros:
> > https://elixir.bootlin.com/linux/v5.5-rc7/source/include/asm-generic/bug.h#L72
> > This should be replaced with pr_err (if really necessary, kernel does
> > not generally spew stacks on every ENOMEM/EINVAL).
>
> That message was added in 2018. The WARN macro in question here, was
> added in 2011. Thus, this would be more of a clean up fix.
>
> >
> > There are no _lots_ such wrong uses of WARN in the kernel. There were
> > some, all get fixed over time, we are still discovering long tail, but
> > it's like one per months at most. Note: syzbot reports each and every
> > WARNING. If there were lots, you would notice :)
>
> Hmm, I haven't looked, but are all these correct usage?
>
>  $ git grep WARN_ON HEAD | wc -l
> 15384

Hard to say, nobody knows. But there is no need to check/fix all of
them proactively, at least not due to syzbot. It stomps on wrong uses
with very low rate now (<1/month), and then for these there is a
reason to fix (but then we also know precisely which one is that).


> I also checked the number of WARN_ON when that WARN_ON was added:
>
>  $ git grep WARN_ON 07d777fe8c3985bc83428c2866713c2d1b3d4129 | wc -l
> 4730
>
> A lot more were added since then!

Adding WARNs is not necessarily wrong/bad. There are totally
legitimate uses for them. Especially in the context of general desire
to have fewer BUGs and replace more of them with WARNs.



> > Sorting this out is critical for just any kernel testing. Otherwise no
> > testing system will be able to say if a test triggers something bad in
> > kernel or not.
> >
> > FWIW there are no local trees for syzbot. It only tests public trees
> > as is. Doing otherwise would not work/scale as a process.
>
> Anyway, I'll happily take a patch converting that WARN_ON macro to a
> pr_err() print.
>
> -- Steve
