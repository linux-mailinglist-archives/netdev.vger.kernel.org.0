Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2765D146E12
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 17:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgAWQOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 11:14:33 -0500
Received: from mail-ed1-f47.google.com ([209.85.208.47]:37137 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbgAWQOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 11:14:33 -0500
Received: by mail-ed1-f47.google.com with SMTP id cy15so3858318edb.4
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 08:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bs4rkdS4VkwACvqUAa4FNNeYiNAjq8Y/NohWUo6BvsU=;
        b=rUkxjKHhBPsEPl8ri6k2oVgSnbC7yW0deGu2TFKEn5bLxu2G+iEAgd0RsFV8wUhHWO
         MGcMwxERp8p/ciNie/urr5CrRqWcRKqKtjPE2d9KVeXICq80lZd1KSOC+Z1JszOgTAkn
         IWZuTVx5V2lAwwYsyRTW89Wzl3A9vxkNWdQhRLZ8Uy9HbJqE/oiIOrhOh4liGR1D42bI
         fDf+Brytc6WduvEqM0n65DAStemtDyP+N1QLBmFH3SQivGNgEIOV4vGquhuT+cKoJ3E0
         vJZ8hyi1HcMulUdMIQvh1uE6Y0NHGce5qUQXcK3t+ubPIV2IPIhywIWoduTlj0gR3PyR
         a/Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bs4rkdS4VkwACvqUAa4FNNeYiNAjq8Y/NohWUo6BvsU=;
        b=AboV3y6P1XSJ0nyNJ7YjBwpgXLeZVrBCRbrRfk57wWZKg0X7EdAP2XzKgsfuv3Vvjx
         /Tl0SquKantS6qZ2DHLr0tfiTX7c01MTh7++KBASmXV0NSuxaWGsbaf4TXoPjGXsj4NW
         29EScx179zB0q/6yhNVALywNU6OEpiGNsUGpVgbrUx6yEb/YdEt2Lx/kWyVBi3G4L78X
         XA35PUSoYCAQhaCfI0a72GxzPJQZRttP1VQEoYe5gB7lmxMoWC72WUX4wTcF+g0ocm+P
         kqaUJwLyKWk/8lUEXACrVv5tMl4qySXaRV4jfdPjamejXRp4y38XYI+gGbVkYFqsiu3m
         cF9Q==
X-Gm-Message-State: APjAAAXGq/JSPvT38NbjUmQD2DC/djPnum3Y5xO+bYxvz9UM4f2S+Hip
        XsLOnDStnJT4ln+vv3RijGTpNHz+5Bna78/N/6g=
X-Google-Smtp-Source: APXvYqx/PKnyFXhM4uVbdJP4R3QLlJM+tfpLok+bxGPXyr8ZzMfzV0QOHX1FAvsFxSQTD8iU89HtYPt+0bK4dT094II=
X-Received: by 2002:a17:906:31cb:: with SMTP id f11mr7651926ejf.337.1579796071139;
 Thu, 23 Jan 2020 08:14:31 -0800 (PST)
MIME-Version: 1.0
References: <20200122182233.3940-1-gautamramk@gmail.com> <20200123.113903.125339377712611659.davem@davemloft.net>
In-Reply-To: <20200123.113903.125339377712611659.davem@davemloft.net>
From:   Gautam Ramakrishnan <gautamramk@gmail.com>
Date:   Thu, 23 Jan 2020 21:44:19 +0530
Message-ID: <CADAms0wMcBN_Uv1LkNc2F0_QXJQLGLbms7MrTPvSyAKziN_nuA@mail.gmail.com>
Subject: Re: [PATCH net-next v7 00/10] net: sched: add Flow Queue PIE packet scheduler
To:     David Miller <davem@davemloft.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 4:09 PM David Miller <davem@davemloft.net> wrote:
>
> From: gautamramk@gmail.com
> Date: Wed, 22 Jan 2020 23:52:23 +0530
>
> > From: Gautam Ramakrishnan <gautamramk@gmail.com>
> >
> > Flow Queue PIE packet scheduler
> >
> > This patch series implements the Flow Queue Proportional
> > Integral controller Enhanced (FQ-PIE) active queue
> > Management algorithm. It is an enhancement over the PIE
> > algorithm. It integrates the PIE aqm with a deficit round robin
> > scheme.
> >
> > FQ-PIE is implemented over the latest version of PIE which
> > uses timestamps to calculate queue delay with an additional
> > option of using average dequeue rate to calculate the queue
> > delay. This patch also adds a memory limit of all the packets
> > across all queues to a default value of 32Mb.
> >
> >  - Patch #1
> >    - Creates pie.h and moves all small functions and structures
> >      common to PIE and FQ-PIE here. The functions are all made
> >      inline.
> >  - Patch #2 - #8
> >    - Addresses code formatting, indentation, comment changes
> >      and rearrangement of structure members.
> >  - Patch #9
> >    - Refactors sch_pie.c by changing arguments to
> >      calculate_probability(), [pie_]drop_early() and
> >      pie_process_dequeue() to make it generic enough to
> >      be used by sch_fq_pie.c. These functions are exported
> >      to be used by sch_fq_pie.c.
> >  - Patch #10
> >    - Adds the FQ-PIE Qdisc.
> >
> > For more information:
> > https://tools.ietf.org/html/rfc8033
>
> Series applied, thank you.
Thanks for the reviews and for applying the patch series.



-- 
-------------
Gautam |
