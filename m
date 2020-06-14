Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477C81F8ABE
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 22:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgFNUng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 16:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgFNUng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 16:43:36 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6501C08C5C2
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 13:43:35 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id w7so10047792edt.1
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 13:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G5pz+aLz5Pqc4F5deU2OyOxBZZ1zvq4SWZqGzE+ff58=;
        b=ogwtVPH5/lB+JKjkz6Ww87I8K9fV5P/ScuBoqlxT8yFMRjbfGWhv+oYIuJx8ElFQzo
         D0Np85rAmVTyWy7nmlSyorssvX9SWB/hXl4gxkP5XoFcguPssYa9v8X+erAmvEBQNcjf
         d4tmaOPZnYxI39bxliK39iG3mMPh2a6VKvrpWhgo+tiE9htOz1lFfauroFYvvJvq7CIp
         8s55VzqXuXzrAynhcmuF9eJwBbGNxiIVL04xSsXvOQPuZYr4ztLYJJ+624jb8g7cUeeU
         HWnCXxYJR3ySs1lbr+ZmPdBnJNtlocI/mrk5fjpUrecq/F4EXr6KPJoPZ/shKa7+ZqFv
         G2iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G5pz+aLz5Pqc4F5deU2OyOxBZZ1zvq4SWZqGzE+ff58=;
        b=bx11ZbKB/TJhP0ymoToHMBroJaYSWpJWuWOsxYuAHjSQE3TLdJ4mSL1wAlE7qRrVA6
         HnF+4ql+4LwkJ1dtFQbiv6ytGDm2vrGM2uy9c56N9UTO/eKV1xRdtIQizoHFdiw9oUcA
         iy+p8/LBEgHYzNapRvkZVsaRfDB3GZR74qZWAqjaaYvCZLAZn+CjoUWGqjgAEGcF0474
         W/+aEoU2UZHAxw4RNEtuzQu9r8kIwa3OpIhpxQG2swCx/FO7NOLXU7ZCSXGucJYFYj2x
         j97+kTIlTSzuUkoD2+JQWS+L4Kq03LXYYS6zhjru3dS9HzZU3QQFjzqGseijm5+Gk3Dh
         q3Dw==
X-Gm-Message-State: AOAM532C4PsZfgXycYOWHuexw7E6GYiMseV52RkhKKtZCxdfwjitH/mB
        6+6C6dIx6gUdby3hDtXBU/2RF+bC9AZIzN6SWMM=
X-Google-Smtp-Source: ABdhPJzgOyZzO7VjOHUgNsR3piQQWMnYPyIRuNP/qJdOLCyF4x3e0vLLXI9M7Fk/3ZTMBW+/OnzbPa3JmxBTJft20Qs=
X-Received: by 2002:a05:6402:17af:: with SMTP id j15mr20532984edy.67.1592167414300;
 Sun, 14 Jun 2020 13:43:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAMtihapJKityT=urbrx2yq-csRQ4u7Vcosrf0NzUZtrHfmN0cQ@mail.gmail.com>
 <CAM_iQpUKQJrj8wE+Qa8NGR3P0L+5Uz=qo-O5+k_P60HzTde6aw@mail.gmail.com>
In-Reply-To: <CAM_iQpUKQJrj8wE+Qa8NGR3P0L+5Uz=qo-O5+k_P60HzTde6aw@mail.gmail.com>
From:   =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>
Date:   Sun, 14 Jun 2020 22:43:23 +0200
Message-ID: <CAMtihaoxAPUgQTkhjmwjKHTdvz7r+SwDEXwhzyjVDXoNR0GKQQ@mail.gmail.com>
Subject: Re: BUG: kernel NULL pointer dereference in __cgroup_bpf_run_filter_skb
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Op zo 14 jun. 2020 om 20:29 schreef Cong Wang <xiyou.wangcong@gmail.com>:
>
> Hello,
>
> On Sun, Jun 14, 2020 at 5:39 AM Dani=C3=ABl Sonck <dsonck92@gmail.com> wr=
ote:
> >
> > Hello,
> >
> > I found on the archive that this bug I encountered also happened to
> > others. I too have a very similar stacktrace. The issue I'm
> > experiencing is:
> >
> > Whenever I fully boot my cluster, in some time, the host crashes with
> > the __cgroup_bpf_run_filter_skb NULL pointer dereference. This has
> > been sporadic enough before not to cause real issues. However, as of
> > lately, the bug is triggered much more frequently. I've changed my
> > server hardware so I could capture serial output in order to get the
> > trace. This trace looked very similar as reported by Lu Fengqi. As it
> > currently stands, I cannot run the cluster as it's almost instantly
> > crashing the host.
>
> This has been reported for multiple times. Are you able to test the
> attached patch? And let me know if everything goes fine with it.

I will try out the patch. Since the host reliably crashed each time as
I booted up
the cluster VMs I will be able to tell whether it has any positive effect.
>
> I suspect we may still leak some cgroup refcnt even with the patch,
> but it might be much harder to trigger with this patch applied.

Currently applying the patch to the kernel and compiling so I should
know in a few hours
>
> Thanks.
