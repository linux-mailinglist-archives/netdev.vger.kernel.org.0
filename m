Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15562DE35E
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 06:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfJUEfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 00:35:33 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42294 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfJUEfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 00:35:32 -0400
Received: by mail-lj1-f194.google.com with SMTP id y23so11699419lje.9
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 21:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QQNBrejSIfQot1yvJ+CXYvqpFeva493kmEcK/FmvoDg=;
        b=Lxe3V4zwPgql6DdVfOuGdemoN+iTyWUFJnNUZSjTdmoNQjUtvBndjhx5Rdj4/DP/Dn
         4z1dCVwOAa6V8CYqKP/3oWo7ve+o5f+Qtc1jdxgfpXkIeuRIPOFHPql1RbabNN2N0bOA
         KrA9Gd8YoyxUxwQ4bbDHN4daiPvi8CYU5SYtg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QQNBrejSIfQot1yvJ+CXYvqpFeva493kmEcK/FmvoDg=;
        b=UiL+7X+IDd8jcW/4jneBY6Crdwo/7LktBBxdAitg5JA4DeJ6zMbG3UOyyLgI6GHbh5
         bt/t643YW1PqnIMqfCICQ117IgD1uDdq76ek+5aw6PdMIq4KfWf16uWITC3lnhi9+Lze
         m6k0BXUEDxir4Cz15Wj4azgTejfwovvnLWQLooA7V7N2bnbvbmSvtJMZX9kbfsoGgGUh
         65bQZi5aGXPlkDhQEKp9GWSJ+MYonPj4rN1PnxEulr6HvU+M0CfS2erYp67nSElzx8qV
         V47s/poQpZ1Wpo4Q+CePyjOPgPdSD1JmT4TrJPQplNRNREopYnQIprMq4itmZLtJhRpb
         P8bA==
X-Gm-Message-State: APjAAAXrXIBizTPRJFomdfG/4fy96eGaSwuXzYXodhfHB3aq1unPq9aT
        qkTHy81kVttfjs0IAACotsWuIsvRSFPkHKWl4GUmlg==
X-Google-Smtp-Source: APXvYqyPwzrXyWagP0WdecOXwfobY6lx3tOdIlc+iCpmqPIfDijQd2X10s5moFVm+KFeq7Sc0yztxE8DVsyHeSnsbyY=
X-Received: by 2002:a2e:990c:: with SMTP id v12mr11977368lji.58.1571632530840;
 Sun, 20 Oct 2019 21:35:30 -0700 (PDT)
MIME-Version: 1.0
References: <1571313682-28900-1-git-send-email-sheetal.tigadoli@broadcom.com>
 <1571313682-28900-4-git-send-email-sheetal.tigadoli@broadcom.com>
 <20191017122156.4d5262ac@cakuba.netronome.com> <CAACQVJrO_PN8LBY0ovwkdxGsyvW_gGN7C3MxnuW+jjdS_75Hhw@mail.gmail.com>
 <20191018100122.4cf12967@cakuba.netronome.com>
In-Reply-To: <20191018100122.4cf12967@cakuba.netronome.com>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Mon, 21 Oct 2019 10:05:18 +0530
Message-ID: <CAACQVJp1R-9frrgjn6=5s_f3AGBq-fyy5CsYdAio1e=c9iLB9g@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] bnxt_en: Add support to collect crash dump via ethtool
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rajan Vaja <rajan.vaja@xilinx.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tee-dev@lists.linaro.org, bcm-kernel-feedback-list@broadcom.com,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 10:31 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Fri, 18 Oct 2019 12:04:35 +0530, Vasundhara Volam wrote:
> > On Fri, Oct 18, 2019 at 12:52 AM Jakub Kicinski wrote:
> > > On Thu, 17 Oct 2019 17:31:22 +0530, Sheetal Tigadoli wrote:
> > > > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > > index 51c1404..1596221 100644
> > > > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > > @@ -3311,6 +3311,23 @@ static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
> > > >       return rc;
> > > >  }
> > > >
> > > > +static int bnxt_set_dump(struct net_device *dev, struct ethtool_dump *dump)
> > > > +{
> > > > +     struct bnxt *bp = netdev_priv(dev);
> > > > +
> > > > +#ifndef CONFIG_TEE_BNXT_FW
> > > > +     return -EOPNOTSUPP;
> > > > +#endif
> > >
> > >         if (!IS_ENABLED(...))
> > >                 return x;
> > >
> > > reads better IMHO
> > Okay.
> >
> > >
> > > But also you seem to be breaking live dump for systems with
> > > CONFIG_TEE_BNXT_FW=n
> > Yes, we are supporting set_dump only if crash dump is supported.
>
> It's wrong.
Sorry not very clear. You are saying that support set_dump all the
time and return
error, if the config option is not enabled? If yes, I will modify the
same way as it
makes sense.

>
> > > > +     if (dump->flag > BNXT_DUMP_CRASH) {
> > > > +             netdev_err(dev, "Supports only Live(0) and Crash(1) dumps.\n");
> > >
> > > more of an _info than _err, if at all
> > I made this err, as we are returning error on invalid flag value. I
> > can modify the log to
> > something like "Invalid dump flag. Supports only Live(0) and Crash(1)
> > dumps.\n" to make
> > it more like error log.
>
> Not an error.
Okay.
