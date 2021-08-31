Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7053FC255
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 08:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239539AbhHaF52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 01:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239066AbhHaF50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 01:57:26 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2208BC061575;
        Mon, 30 Aug 2021 22:56:32 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n18so544014plp.7;
        Mon, 30 Aug 2021 22:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aIXBIIIoz+rnxmyGhqnZFJeXHpwd+gU8Q68x3m93PVQ=;
        b=qDY2Ej/r5UzI10iwQI83HXn/Jw4eofnIFvyMHcKbw4KLOWi+nlrsApoxiSRR62WBEG
         vUGxAU9OyB6dEZxlSKYgsBFAvERCGVtXiYAhzMLxO2Iu0po61VCf/ncpwBsYN9VPA26v
         OUCGloe7CnhgYOrQmC9jXkhHI551M72FdEEN6fj9xPYlDjPLi7KDBCOGcyTXb4jhxAmH
         wCEZL+jqLXTtXPCmDeHvD/axS3jdJmQLuL/WTUMhMLxKOJxTVqofa/7YZaEPJqpY0TJd
         7sVFeiNe9o8WtM1DRizH52tFi73w9+4fIzCxNHfgvgMd7OzuoLAjDOu3sk/2QVRyG2gz
         hTSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aIXBIIIoz+rnxmyGhqnZFJeXHpwd+gU8Q68x3m93PVQ=;
        b=izwY/Q74bLNtkajK0BnFRSM3OgR22simr4O5lmAvs/l0R9Hwf1lfmA7jLt1RoYjvGq
         +NT4vgkwWQM3Ms2iwQFDuPoVNEWnQixu/HU/xdNTzZegU8qIqGC/t6iUNRaKukleSYcX
         GH0i5xPk4uq3G3qgEQ4ybJhVOEK+dF/tNSHCKMO01+f8EFYQCwyA2EXhQy5/Sb0U5QO9
         /iO89xzvFDHAZOqukk4m4sYpBcjam5Li2bqqxE4bw89NpDjp2QI+itzXI1SSqxIRDnyE
         TmlSl06hPPOZwuR7qYam5BieaaYlShS+G0SxhaMPYVaUl2ZHCeEw8wV+9BY6iHzjd1J2
         dDUQ==
X-Gm-Message-State: AOAM532Q9kY+/dAC9nKNN12FyDdNaD4vKr2TVScKEyGwwhyzS5ATP/Ht
        Bsrf6mo68m7N8hTaIgNF3tiio5c7PWfKHONzGlo=
X-Google-Smtp-Source: ABdhPJwhByb5Jufu27BCB2wa52/aJ3dGafnYRXjfMoZnLI+Y4Dr9MSWTIzNPzbGq2t6j52uasgFquGwoSRpuO0XsXek=
X-Received: by 2002:a17:90a:a0a:: with SMTP id o10mr3367812pjo.231.1630389391641;
 Mon, 30 Aug 2021 22:56:31 -0700 (PDT)
MIME-Version: 1.0
References: <1630295221-9859-1-git-send-email-tcs_kernel@tencent.com>
 <163032300695.3135.11373235819151215482.git-patchwork-notify@kernel.org> <20210830101456.21944dfe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210830101456.21944dfe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 30 Aug 2021 22:56:20 -0700
Message-ID: <CAM_iQpWi083uZ5wMYA+coWtME=xQMy3pb-__9jaFqe9piFRSaQ@mail.gmail.com>
Subject: Re: [PATCH V2] fix array-index-out-of-bounds in taprio_change
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Haimin Zhang <tcs.kernel@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, tcs_kernel@tencent.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 10:14 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 30 Aug 2021 11:30:06 +0000 patchwork-bot+netdevbpf@kernel.org
> wrote:
> > Hello:
> >
> > This patch was applied to netdev/net-next.git (refs/heads/master):
> >
> > On Mon, 30 Aug 2021 11:47:01 +0800 you wrote:
> > > From: Haimin Zhang <tcs_kernel@tencent.com>
> > >
> > > syzbot report an array-index-out-of-bounds in taprio_change
> > > index 16 is out of range for type '__u16 [16]'
> > > that's because mqprio->num_tc is lager than TC_MAX_QUEUE,so we check
> > > the return value of netdev_set_num_tc.
> > >
> > > [...]
> >
> > Here is the summary with links:
> >   - [V2] fix array-index-out-of-bounds in taprio_change
> >     https://git.kernel.org/netdev/net-next/c/efe487fce306
> >
> > You are awesome, thank you!
>
> https://lore.kernel.org/netdev/20210830091046.610ceb1b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
>
> Oh, well...

I agree it is slightly better to make the check work in
taprio_parse_mqprio_opt(), but this patch is not bad either, we
need to check the return value of netdev_set_num_tc() for
completeness at least.

BTW, this patch should be landed in -net, not -net-next, as it
fixes a real bug reported by syzbot.

Thanks.
