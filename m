Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6AD920C30E
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 18:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgF0Q0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 12:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgF0Q0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 12:26:35 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4067C061794
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 09:26:34 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id n2so219800edr.5
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 09:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jMFR2HbEYsyIRmp4I4lI0gXHiq1A0lFEb04l7REmO8o=;
        b=jGKXQu7tLII7Xl8W/rutTbqW2+b37Bot9j0NLNHCgWrd14iQwkUfGscWJUZCn6h2qv
         R66VPVZrobRQJUwnse72sm0o1jWhW16rvgwcfyKSfviuGoC5i3NLtKMzuny/b/m5klrf
         4TUyu0jlEMnjnJSZMUJRzmOxtQgSGGfv85Z59GXUYLTJ1ejICmKUeEgyRq+sMUGufJGz
         ibJRbR0dAEOHPRf3GP97G25H66hj1SY0bHsUsunSeO3svwaHuSvQfhmd3Iwz0f7R0kNU
         WgXurhtMPzYtc0+JAfdGeViR6MYioSeBzUChbyyOe1ubGPi7B1EAyVImScAtvD8Tj8R1
         xumw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jMFR2HbEYsyIRmp4I4lI0gXHiq1A0lFEb04l7REmO8o=;
        b=B/KdWraTmlufC8VGZHyv/7hGCRuY0qIuyUaA9dQCvzIEb/h4vZHmCqct78+8kKxcW3
         S8hOVFvchmCwaWqwuU7uZGHPrjelvhw55lb2dx7IVz8mVFZWMkzV90BGbXbh48RcYjBz
         DoyPqD6McOyoNFqSvf3VOQT6EGiN1+MmASK2Nt5dx1PafNc9sQcRbxpWdiYLRaFYalih
         XrrYnDlDNjo6HufRMpTmP90mjgry9P6B5yPmK5gBYXUlzFkG7l68855Rzb8A3V0vpxxS
         DU9A9makiZX5A4PDWozbX+Dc9Z5d3wlKyOCyqU6sSGL6x4yQsGJFWJxlKgMy2VRRpr+W
         YNCg==
X-Gm-Message-State: AOAM532r9ineFyxbFVlpEA44LyuSx2Y/klC+53wI+1P7aecGMjlPsb3r
        +CHVanzYLHpJMLVEkC1f7CoCuVPLndtK1HuSFjvByw==
X-Google-Smtp-Source: ABdhPJz/3ukDQltSmEbXbltWTX/wkxtlg8EppZDtDF2+xEQ8YinNaYGniKHrzEgxiMFOKXZBL67UO/ETdLzDStiW6gY=
X-Received: by 2002:a50:ee87:: with SMTP id f7mr9400400edr.355.1593275191059;
 Sat, 27 Jun 2020 09:26:31 -0700 (PDT)
MIME-Version: 1.0
References: <e13faf29-5db3-91a2-4a95-c2cd8c2d15fe@mellanox.com> <807a300e-47aa-dba3-7d6d-e14422a0d869@intel.com>
In-Reply-To: <807a300e-47aa-dba3-7d6d-e14422a0d869@intel.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Sat, 27 Jun 2020 09:26:20 -0700
Message-ID: <CALx6S35NaCEBPXAsM-8-wrYYQhDB2EVxAN1RaGiJM9yNncaHaQ@mail.gmail.com>
Subject: Re: ADQ - comparison to aRFS, clarifications on NAPI ID, binding with busy-polling
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 1:21 PM Samudrala, Sridhar
<sridhar.samudrala@intel.com> wrote:
>
>
>
> On 6/17/2020 6:15 AM, Maxim Mikityanskiy wrote:
> > Hi,
> >
> > I discovered Intel ADQ feature [1] that allows to boost performance by
> > picking dedicated queues for application traffic. We did some research,
> > and I got some level of understanding how it works, but I have some
> > questions, and I hope you could answer them.
> >
> > 1. SO_INCOMING_NAPI_ID usage. In my understanding, every connection has
> > a key (sk_napi_id) that is unique to the NAPI where this connection is
> > handled, and the application uses that key to choose a handler thread
> > from the thread pool. If we have a one-to-one relationship between
> > application threads and NAPI IDs of connections, each application thread
> > will handle only traffic from a single NAPI. Is my understanding correct?
>
> Yes. It is correct and recommended with the current implementation.
>
> >
> > 1.1. I wonder how the application thread gets scheduled on the same core
> > that NAPI runs at. It currently only works with busy_poll, so when the
> > application initiates busy polling (calls epoll), does the Linux
> > scheduler move the thread to the right CPU? Do we have to have a strict
> > one-to-one relationship between threads and NAPIs, or can one thread
> > handle multiple NAPIs? When the data arrives, does the scheduler run the
> > application thread on the same CPU that NAPI ran on?
>
> The app thread can do busypoll from any core and there is no requirement
> that the scheduler needs to move the thread to a specific CPU.
>
> If the NAPI processing happens via interrupts, the scheduler could move
> the app thread to the same CPU that NAPI ran on.
>
> >
> > 1.2. I see that SO_INCOMING_NAPI_ID is tightly coupled with busy_poll.
> > It is enabled only if CONFIG_NET_RX_BUSY_POLL is set. Is there a real
> > reason why it can't be used without busy_poll? In other words, if we
> > modify the kernel to drop this requirement, will the kernel still
> > schedule the application thread on the same CPU as NAPI when busy_poll
> > is not used?
>
> It should be OK to remove this restriction, but requires enabling this
> in skb_mark_napi_id() and sk_mark_napi_id() too.
>
> >
> > 2. Can you compare ADQ to aRFS+XPS? aRFS provides a way to steer traffic
> > to the application's CPU in an automatic fashion, and xps_rxqs can be
> > used to transmit from the corresponding queues. This setup doesn't need
> > manual configuration of TCs and is not limited to 4 applications. The
> > difference of ADQ is that (in my understanding) it moves the application
> > to the RX CPU, while aRFS steers the traffic to the RX queue handled my
> > the application's CPU. Is there any advantage of ADQ over aRFS, that I
> > failed to find?
>
> aRFS+XPS ties app thread to a cpu, whereas ADQ ties app thread to a napi
> id which in turn ties to a queue(s)
>
> ADQ also provides 2 levels of filtering compared to aRFS+XPS. The first
> level of filtering selects a queue-set associated with the application
> and the second level filter or RSS will select a queue within that queue
> set associated with an app thread.
>
The association between queues and thread is implicit in ADQ and
depends on some assumption particularly on symmetric queueing which
doesn't always work (TX/RX devices are different, uni-directional
traffic, peer using some encapsulation that the tc filter misses).
Please look at Per Thread Queues (https://lwn.net/Articles/824414/)
which aims to make this association of queues to threads explicit.

> The current interface to configure ADQ limits us to support upto 16
> application specific queue sets(TC_MAX_QUEUE)
>
>
> >
> > 3. At [1], you mention that ADQ can be used to create separate RSS sets.
> >   Could you elaborate about the API used? Does the tc mqprio
> > configuration also affect RSS? Can it be turned on/off?
>
> Yes. tc mqprio allows to create queue-sets per application and the
> driver configures RSS per queue-set.
>
> >
> > 4. How is tc flower used in context of ADQ? Does the user need to
> > reflect the configuration in both mqprio qdisc (for TX) and tc flower
> > (for RX)? It looks like tc flower maps incoming traffic to TCs, but what
> > is the mechanism of mapping TCs to RX queues?
>
> tc mqprio is used to map TCs to RX queues
>
> tc flower is used to configure the first level of filter to redirect
> packets to a queue set associated with an application.
>
> >
> > I really hope you will be able to shed more light on this feature to
> > increase my awareness on how to use it and to compare it with aRFS.
>
> Hope this helps and we will go over in more detail in our netdev session.
>
Also, please add a document in Documentation/networking that describes
the feature, configuration, and any limitations and relationship to
other packet steering features.

> >
> > Thanks,
> > Max
> >
> > [1]:
> > https://netdevconf.info/0x14/session.html?talk-ADQ-for-system-level-network-io-performance-improvements
> >
