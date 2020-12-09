Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6322D4819
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 18:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731993AbgLIRjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 12:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732511AbgLIRiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 12:38:50 -0500
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDC7C061793
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 09:38:09 -0800 (PST)
Received: by mail-vs1-xe41.google.com with SMTP id z16so1342375vsp.5
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 09:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HWv8f7XKKh5rI4uQxnVcsRlGKdIvv/aIM1Tgv7DhfRg=;
        b=C8Umeht1MjyTH+wPNpThAIbH0yulBOYlm8cRA5JcSEhOPceWTGA8G8HQrzufAMlqKx
         dcs+SFD0mFq5wlCcUvAJg4TeTa2s1djDXZ6P+xhHS17xU7fwf0vItPHWGnh1GKGkWKVY
         M7JxVil3jnFw6t6DmN0OdvUCvBJ1RubeR4rbD2c/R7ffv/pp1P81JYsUh95f7xGQoK3m
         YUrpbUdRPSPzdKPv0HkVAalX8BrVK5S2sL/wK/SWxTISNkfqXTgeHlqiswTtQkxI6xt1
         MjZxHulskru/Pl25X8cuuk9vTvSme4f4edmn8pAYqXY34/Zkklo2YwEoriElKZ4wBlJJ
         vJEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HWv8f7XKKh5rI4uQxnVcsRlGKdIvv/aIM1Tgv7DhfRg=;
        b=n5n0aUBsMJ2HpV4YfvifkmPbmetlhinPpdOvrhzXQlwFHXM/7Y3Jw5IvWLBb9GHOtS
         pRXVmzP0wZ9oBI8iwYz0+/r1JXWqV7/iT37LH0v1Io566lRixc7zZtj2jF0eaz5SeNGA
         kR4er5yn5+hjJFVU3TNdWpw0UZ49zNwcSJusiLsob6bCKyxD6zZj/kmcvlrxfhkX/Y34
         a8KHbcnaLP3TZazmJ/6rSgmRBJhJ1iHmcYIuh5YYQvudZBnFps7IENzRuDsgN63SZ6hE
         +Rz0VQ+j9QBSd4ozJA0/xNnPIIxXqWn6rGCn4ZK4GfuLcsSy3y0G5XbHll4ZBLQUj2BD
         uMRA==
X-Gm-Message-State: AOAM532VkCgEddtegUnNjXpaAwcTLiYiSBVBOrze/Hf6j0IDHdu3Zt0R
        FPmQlkxU9Eg/SxFu62lBFv2dfeMyqoSVXw==
X-Google-Smtp-Source: ABdhPJzmc2ztBvcmlIKMsfVnb5J9bJDbY8vUjlqTeIrNTNJK4t+fIG5ckKjUbgBnoBbiioAMpewzvw==
X-Received: by 2002:a67:7c17:: with SMTP id x23mr3206319vsc.36.1607535488823;
        Wed, 09 Dec 2020 09:38:08 -0800 (PST)
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com. [209.85.217.44])
        by smtp.gmail.com with ESMTPSA id k189sm191015vkh.55.2020.12.09.09.38.05
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 09:38:06 -0800 (PST)
Received: by mail-vs1-f44.google.com with SMTP id z16so1342237vsp.5
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 09:38:05 -0800 (PST)
X-Received: by 2002:a05:6102:1173:: with SMTP id k19mr3114725vsg.51.1607535485270;
 Wed, 09 Dec 2020 09:38:05 -0800 (PST)
MIME-Version: 1.0
References: <20201209143707.13503-1-erez.geva.ext@siemens.com>
 <20201209143707.13503-2-erez.geva.ext@siemens.com> <CA+FuTScWkYn0Ur+aSuz1cREbQJO0fB6powOm8PFxze4v8JwBaw@mail.gmail.com>
 <VI1PR10MB244654C4B42E47DB5EBE0B05ABCC0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <VI1PR10MB244654C4B42E47DB5EBE0B05ABCC0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 9 Dec 2020 12:37:29 -0500
X-Gmail-Original-Message-ID: <CA+FuTSd7oB0qO707W6htvs=FOJn10cgSQ4_iGFz4Sk9URXtZiw@mail.gmail.com>
Message-ID: <CA+FuTSd7oB0qO707W6htvs=FOJn10cgSQ4_iGFz4Sk9URXtZiw@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add TX sending hardware timestamp.
To:     "Geva, Erez" <erez.geva.ext@siemens.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Arnd Bergmann <arnd@arndb.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Ogness <john.ogness@linutronix.de>,
        Jon Rosen <jrosen@cisco.com>,
        Kees Cook <keescook@chromium.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Martin KaFai Lau <kafai@fb.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Or Cohen <orcohen@paloaltonetworks.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Xie He <xie.he.0141@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        "Molzahn, Ines" <ines.molzahn@siemens.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Meisinger, Andreas" <andreas.meisinger@siemens.com>,
        "Bucher, Andreas" <andreas.bucher@siemens.com>,
        "henning.schild@siemens.com" <henning.schild@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "Zirkler, Andreas" <andreas.zirkler@siemens.com>,
        "Sakic, Ermin" <ermin.sakic@siemens.com>,
        "anninh.nguyen@siemens.com" <anninh.nguyen@siemens.com>,
        "Saenger, Michael" <michael.saenger@siemens.com>,
        "Maehringer, Bernd" <bernd.maehringer@siemens.com>,
        "gisela.greinert@siemens.com" <gisela.greinert@siemens.com>,
        Erez Geva <ErezGeva2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 10:25 AM Geva, Erez <erez.geva.ext@siemens.com> wrote:
>
>
> On 09/12/2020 15:48, Willem de Bruijn wrote:
> > On Wed, Dec 9, 2020 at 9:37 AM Erez Geva <erez.geva.ext@siemens.com> wrote:
> >>
> >> Configure and send TX sending hardware timestamp from
> >>   user space application to the socket layer,
> >>   to provide to the TC ETC Qdisc, and pass it to
> >>   the interface network driver.
> >>
> >>   - New flag for the SO_TXTIME socket option.
> >>   - New access auxiliary data header to pass the
> >>     TX sending hardware timestamp.
> >>   - Add the hardware timestamp to the socket cookie.
> >>   - Copy the TX sending hardware timestamp to the socket cookie.
> >>
> >> Signed-off-by: Erez Geva <erez.geva.ext@siemens.com>
> >
> > Hardware offload of pacing is definitely useful.
> >
> Thanks for your comment.
> I agree, it is not limited of use.
>
> > I don't think this needs a new separate h/w variant of SO_TXTIME.
> >
> I only extend SO_TXTIME.

The patchset passes a separate timestamp from skb->tstamp along
through the ip cookie, cork (transmit_hw_time) and with the skb in
shinfo.

I don't see the need for two timestamps, one tied to software and one
to hardware. When would we want to pace twice?

> > Indeed, we want pacing offload to work for existing applications.
> >
> As the conversion of the PHC and the system clock is dynamic over time.
> How do you propse to achive it?

Can you elaborate on this concern?

The simplest solution for offloading pacing would be to interpret
skb->tstamp either for software pacing, or skip software pacing if the
device advertises a NETIF_F hardware pacing feature.

Clockbase is an issue. The device driver may have to convert to
whatever format the device expects when copying skb->tstamp in the
device tx descriptor.

>
> > It only requires that pacing qdiscs, both sch_etf and sch_fq,
> > optionally skip queuing in their .enqueue callback and instead allow
> > the skb to pass to the device driver as is, with skb->tstamp set. Only
> > to devices that advertise support for h/w pacing offload.
> >
> I did not use "Fair Queue traffic policing".
> As for ETF, it is all about ordering packets from different applications.
> How can we achive it with skiping queuing?
> Could you elaborate on this point?

The qdisc can only defer pacing to hardware if hardware can ensure the
same invariants on ordering, of course.

Btw: this is quite a long list of CC:s
