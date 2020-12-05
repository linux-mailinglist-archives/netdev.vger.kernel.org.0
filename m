Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06402CF8E1
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 03:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgLECBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 21:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727550AbgLECBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 21:01:03 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A234C0613D1;
        Fri,  4 Dec 2020 18:00:23 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id 142so8656242ljj.10;
        Fri, 04 Dec 2020 18:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hdY2b4ukClLmN3a4XJxuVpAzllyssIAUZTOi0yRf5wA=;
        b=S/MpeJe2Rj3WXxLXEikOoU1oEgV5KZicvL/V/appGLTNZNmN7MJJy9HrajLwt4kYrr
         IWaijxifAdLUwte95UgF2fjyXfRkPpq5ItQEr9ufpXdJWdz1BmORrGrldJ9ZdI20AXT5
         9Y0ZXTcHL8xocb2ZyNBeggnKcLmaZYt8nEjWR88M8lM8at7uoGoR3f7PiDXf7hBkI5Xo
         yumneBuzsOvlqa7uQLBobyMVQUBtLtQJxmd4vzA37OtwenWcMnk/qq4136GK4JcF4uy4
         EjvoCx12WvXTBVR8ev/ICV0VZRm6OAnxIqBFMzYKu9erH4XmPxuQ5wWA3Fyk77baU3Fs
         e3Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hdY2b4ukClLmN3a4XJxuVpAzllyssIAUZTOi0yRf5wA=;
        b=EY4fvy6MbsI/63OEOl1Tn6FOIv2nLL549IQZpCZ0rlQmGh220LakEY1Ti7ol0zhOeZ
         lN9aTDnuVyFrdQM194cgHlHTm00P+eELELFFe56LYmqBiu9IMg02aBQGDt0i5F+d5DWW
         hRoDRsXRPMY2go8rJwlwd65BtMiGSBiz0uiL97co4Sb30q5x6pnRe+nt4gCGPU2eckZb
         OP8UAEdsBgV1XtF9D/Q6QnCEoCHBx80JAxejlOh8iX0PuWkXhZeQuk64cDwvgieZ16Xn
         8TUoLQMUhMsB47sjcaGCXXn4a8Lm6pxOHDFXNWBOZvuTXFxfsObeDRCpD1WYIqmuzYTG
         W8qg==
X-Gm-Message-State: AOAM5319lKbcSfRjjfciodMcqWk8aWJQZuLza6L+bMMHjl8HuB//PF9k
        0FgVbcGZw9BTYtvi+RsTq+PLP2LhcI4RHsacYYY=
X-Google-Smtp-Source: ABdhPJxMIpLj4X6ijCTUYw/AYNzDb/TfDpkJi1jNAtgwACCfOJy4bSFqA8piycXWSzzMd851IcKb2eFglg16Jl4Ul5o=
X-Received: by 2002:a2e:b1c9:: with SMTP id e9mr4540535lja.283.1607133621869;
 Fri, 04 Dec 2020 18:00:21 -0800 (PST)
MIME-Version: 1.0
References: <20201201194438.37402-1-xiyou.wangcong@gmail.com>
 <20201202171032.029b1cd8@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAM_iQpWfv59MoEJES1O=FhA4YsrB2nNGGaKzDmqcmXQXzc8gow@mail.gmail.com>
 <CAADnVQK74XFuK6ybYeqdw1qNt2ZDi-HbrgMxeem46Uh-76sX7Q@mail.gmail.com>
 <CAADnVQ+tRAKn4KR_k9eU-fG3iQhivzwn6d2BDGnX_44MTBrkJg@mail.gmail.com>
 <CAM_iQpUUnsRuFs=uRA2uc8RZVakBXCA7efbs702Pj54p8Q==ig@mail.gmail.com>
 <CAADnVQJY=tBF028zLLq7HzQjSVwU+=1bvrKb75-zFts+36vdww@mail.gmail.com> <CAM_iQpU7juzuqy2T8gYQ+U_7HWc_rth304fNfKM5qW91CmE4fw@mail.gmail.com>
In-Reply-To: <CAM_iQpU7juzuqy2T8gYQ+U_7HWc_rth304fNfKM5qW91CmE4fw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 4 Dec 2020 18:00:10 -0800
Message-ID: <CAADnVQLTvifKr0JGqDm-DTndmjziRMiS8i7czCPoW-tEhfaWDQ@mail.gmail.com>
Subject: Re: [Patch net] lwt: disable BH too in run_lwt_bpf()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Thomas Graf <tgraf@suug.ch>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 3, 2020 at 9:55 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Dec 3, 2020 at 10:30 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Dec 3, 2020 at 10:28 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Thu, Dec 3, 2020 at 10:22 AM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > I guess my previous comment could be misinterpreted.
> > > > Cong,
> > > > please respin with changing preempt_disable to migrate_disable
> > > > and adding local_bh_disable.
> > >
> > > I have no objection, just want to point out migrate_disable() may
> > > not exist if we backport this further to -stable, this helper was
> > > introduced in Feb 2020.
> >
> > I see. Then please split it into two patches for ease of backporting.
>
> You mean the first patch does the same as this patch and the second
> patch replaces preempt_disable() with migrate_disable(). Right?

Right. Just be mindful of changing the comment.
