Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461FE1F97E0
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 15:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730081AbgFONGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 09:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729977AbgFONGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 09:06:08 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29524C061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 06:06:07 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id dr13so17331821ejc.3
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 06:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=69uJpwsef1LEGMh8o7umonFUWwgg6vbIbWs74NJqgYk=;
        b=forNqvr25ZCy4KtzpSSkw79X2sWfB+A8jm1W/kNNickkicfmCIeWG+UGzV4zfLyD6m
         fDbsOnZsh/2ds4UoRmpsoJCRXXOjbfTf6fsz4my/WfszeaWGcCo8AIjZptTL61UNrJZe
         +xK3i1pbtifsq7YSgBDxrt2Xdx0Jn9C1TkHuoQICmuiHL23KaSjqFVdHsG1BO3Nfa88h
         0wzFGGq5IYKtnlaoqiZFTn+PiVb41bk9V5BqUy/rrT4COFsoOINvfdTrGplmY23ZaRIf
         NgCX3sbe56pSLYlo1lIA+3DwgpXSjnWlb3eGl4enb51QF3o/faqckHFRDo7YNvB9f0RX
         /xLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=69uJpwsef1LEGMh8o7umonFUWwgg6vbIbWs74NJqgYk=;
        b=SQrNsxrjfgk6OmrHUuCTlXRmO8HZJyXWh03bK8QyKwqzTS0iEhuUGkUX2L9x0Aaexc
         leAV58pAwPmbDd268KanBENRZTo3a6bfdESEE0fhWIsbW7fu0gLDr9Z5+NrfUmalRqKw
         Kk2GAZh6/aA8TzBhp73GgvzlZcCksK/BbshD7TeIVsJQahHd0h38E1WobWNbBsD9qQ1d
         jJ1lfnJJg68w7ke8/ZkCMyF3Dx2b/oapLFvoztFJq1YE8IuqfF3OlmJFBQkfu6lYVX5B
         K8cAbjjljKvnV5OxshYPnIvZg3HZDIx/HrbCZ2uxyPlPvd+61bd+MiJUqeL+Xgjqq3G/
         EbwA==
X-Gm-Message-State: AOAM530i85UAECFLBPGH5xKtKC8at3TRe0SqLEi+/d4GjJS2lj1bY6na
        +cqE0gtP0B1x1NtQTv+yuDJuztBMc3vh1Bszs4w=
X-Google-Smtp-Source: ABdhPJw1pwi/HNh921Mx6rCS+xxInamyVP4Z7OCwEfJYNmQpzJW/MKlTHknVaFYl2EsTdbKWjHlC63YRWDP3E8Di088=
X-Received: by 2002:a17:906:6453:: with SMTP id l19mr24513455ejn.262.1592226365372;
 Mon, 15 Jun 2020 06:06:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAMtihapJKityT=urbrx2yq-csRQ4u7Vcosrf0NzUZtrHfmN0cQ@mail.gmail.com>
 <CAM_iQpUKQJrj8wE+Qa8NGR3P0L+5Uz=qo-O5+k_P60HzTde6aw@mail.gmail.com> <CAMtihaoxAPUgQTkhjmwjKHTdvz7r+SwDEXwhzyjVDXoNR0GKQQ@mail.gmail.com>
In-Reply-To: <CAMtihaoxAPUgQTkhjmwjKHTdvz7r+SwDEXwhzyjVDXoNR0GKQQ@mail.gmail.com>
From:   =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>
Date:   Mon, 15 Jun 2020 15:05:54 +0200
Message-ID: <CAMtihapcPYn-tZyypwN8ZLMWGeqErC37gFtyLp9zv-mcmcn7eg@mail.gmail.com>
Subject: Re: BUG: kernel NULL pointer dereference in __cgroup_bpf_run_filter_skb
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Op zo 14 jun. 2020 om 22:43 schreef Dani=C3=ABl Sonck <dsonck92@gmail.com>:
>
> Hello,
>
> Op zo 14 jun. 2020 om 20:29 schreef Cong Wang <xiyou.wangcong@gmail.com>:
> >
> > Hello,
> >
> > On Sun, Jun 14, 2020 at 5:39 AM Dani=C3=ABl Sonck <dsonck92@gmail.com> =
wrote:
> > >
> > > Hello,
> > >
> > > I found on the archive that this bug I encountered also happened to
> > > others. I too have a very similar stacktrace. The issue I'm
> > > experiencing is:
> > >
> > > Whenever I fully boot my cluster, in some time, the host crashes with
> > > the __cgroup_bpf_run_filter_skb NULL pointer dereference. This has
> > > been sporadic enough before not to cause real issues. However, as of
> > > lately, the bug is triggered much more frequently. I've changed my
> > > server hardware so I could capture serial output in order to get the
> > > trace. This trace looked very similar as reported by Lu Fengqi. As it
> > > currently stands, I cannot run the cluster as it's almost instantly
> > > crashing the host.
> >
> > This has been reported for multiple times. Are you able to test the
> > attached patch? And let me know if everything goes fine with it.
>
> I will try out the patch. Since the host reliably crashed each time as
> I booted up
> the cluster VMs I will be able to tell whether it has any positive effect=
.
> >
> > I suspect we may still leak some cgroup refcnt even with the patch,
> > but it might be much harder to trigger with this patch applied.
>
> Currently applying the patch to the kernel and compiling so I should
> know in a few hours

The compilation with the patch has finished and I've since rebooted to the
new kernel about 12 hours ago, so far this bug did not trigger whereas with=
out
the patch, by this time it would have triggered. Regardless, I will keep my
serial connection in case something pops up.
> >
> > Thanks.
