Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6296719CF81
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 06:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbgDCEnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 00:43:41 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:36203 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgDCEnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 00:43:41 -0400
Received: by mail-oi1-f194.google.com with SMTP id k18so5068841oib.3
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 21:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pxk3qk5Bn3RYUkFktZThaPnODyF46Yu2JEsa4YXKZiw=;
        b=kFYRYrg76NUoc/b/Akw88QOh5ieISq+4SNZnrbBD6Nx2XScbFcZbBR9Ic0Y9Yre5Va
         SBukoww18pRUawsVt/qWxf+GMQBPKenl1blOUmE+CxFnj6zDpsRfIsajxrp2qZWiaNDV
         N+388V5XxrbAaQDd1Izi8V4rc88SXwmAZSUB9SbgF7BViZv025zuHqdGpvSd5kVK38OA
         9CEso6zH8AsMl7p/PMjpeHj+KZh7kPyYYQ6jS4yqUT7ZkhG4LLpJy/OMV8uD4w2HUXR6
         7mwhkPZak6Z9ac9+b+jsfXjxKnZAnl2ApVoaU97jg+i6g4vzVKGYaU1ZbRspaRn9wr0K
         IPIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pxk3qk5Bn3RYUkFktZThaPnODyF46Yu2JEsa4YXKZiw=;
        b=hh2a2xPgbK/W1UXngeM/6KNXarW49TyJ9OBu4x7SFXxG6+hELcE3/lwtofDxqsKo0R
         o1KxUcyS+6+6nKXvvJyA43JkEch7+JjDGO8MeUhXi71HfHZ2xYOWpLlU9dhkZpfOdpZ6
         IHjTeGZJeIVgaoFIp+ctgpn5TZwiHq29SYjr2huOs2lW1dItZzgPBNbzAyBN5+j6Z+DT
         lCt8MoLGS6BIsvpyCfvDcCvVxIuy78zhyx2ymYEDFBwXDfT7BBVAE5DFVAyV/xtq+lXv
         m6x0KS27M7EOSQapSFIvNnhflHE/CCYBXyWcMYLxuFSY/cEKFo31duwhqvzW3vEY7+vk
         7P+w==
X-Gm-Message-State: AGi0PuaNoM0ziAk6khuu6Z1PhfjHWlnjZBUSytFVe7pNw3sMY5j6d3UF
        nH9FfaIqJCz9+Mm9s6tAksgYjPcvSNskDW16DgM2HVCDQCU=
X-Google-Smtp-Source: APiQypI4MZW5519Jc++Gxj0tg4LUpf0zGuO8blCD9CpY7/3GANc+aJZ9SOkshmrL2BMv3DBaBR8A+jdIl8+v6F+3fjY=
X-Received: by 2002:a05:6808:648:: with SMTP id z8mr1823987oih.72.1585889020816;
 Thu, 02 Apr 2020 21:43:40 -0700 (PDT)
MIME-Version: 1.0
References: <a59f92670c72db738d91b639ecc72ef8daf69300.1585866258.git.marcelo.leitner@gmail.com>
 <20200402.180417.804204103829966415.davem@davemloft.net> <20200403011412.GA3629@localhost.localdomain>
In-Reply-To: <20200403011412.GA3629@localhost.localdomain>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 2 Apr 2020 21:43:29 -0700
Message-ID: <CAM_iQpUvn+ijyZtLmca3n+nZmHY9cMmPYwZMp5BTv10bLUhg3Q@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: reduce amount of log messages in act_mirred
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 2, 2020 at 6:14 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Thu, Apr 02, 2020 at 06:04:17PM -0700, David Miller wrote:
> > From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > Date: Thu,  2 Apr 2020 19:26:12 -0300
> >
> > > @@ -245,8 +245,8 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
> > >     }
> > >
> > >     if (unlikely(!(dev->flags & IFF_UP))) {
> > > -           net_notice_ratelimited("tc mirred to Houston: device %s is down\n",
> > > -                                  dev->name);
> > > +           pr_notice_once("tc mirred: device %s is down\n",
> > > +                          dev->name);
> >
> > This reduction is too extreme.
> >
> > If someone causes this problem, reconfigures everything thinking that the
> > problem will be fixed, they won't see this message the second time and
> > mistakenly think it's working.
>
> Fair point. Then what about removing it entirely? printk's are not the
> best way to debug packet drops anyway and the action already registers
> the drops in its stats.
>
> Or perhaps a marker in the message, stating that it is logged only
> once per boot. I'm leaning to the one above, to just remove it.

I think the reason why we print that is we do not handle
NETDEV_DOWN event in mirred_device_event() or check IFF_UP
in tcf_mirred_init(). I think if we can do both, we can remove
this message entirely. I am not sure whether the latter would break
existing expectations, as users may want to add a down device
as a target and bring it up afterward.

Thanks.
