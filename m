Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60D56EA1D6
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbjDUCtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbjDUCtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:49:31 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAACE2723;
        Thu, 20 Apr 2023 19:49:29 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-5066ce4f725so1637929a12.1;
        Thu, 20 Apr 2023 19:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682045368; x=1684637368;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+HNMXzHWvBEHzj9QSaYOYNRm6D/JVAcKYsrrAYs6ues=;
        b=J2haeZG7RdoZWZpd3ZntCOuHIAqDAgYBepUCCiv5hw1RwHsDYi61lOGi2oCQh5ZH3O
         EAoovY3k6DJDwUTqMfjjtDvyEPqL3q5/M0oPub4dIXtbBhPCrgK3n8z5EeF0lmTimrHc
         sGbWZpYzyxPgWy1OGA8K8CxjkeGl8q2L17RJ9XQgumSRmhShwosDwYpqCA6h6Dbxwums
         8o2uj5I4Ng2Si0Ym9WoIZX677i0g5Zg7bMbsXZwSn4A4SvJcwoZa/YP/BojprhN/NOw8
         E0F+TeOKDYjsXTNWOZ7DtqUnoMB/A7XSgYGS0h5ODe3ggStLbHqzWxSn8YCKTW9dO/qe
         F6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682045368; x=1684637368;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+HNMXzHWvBEHzj9QSaYOYNRm6D/JVAcKYsrrAYs6ues=;
        b=RcY+W+fYzJep+PmQdC6E1+ZOh+7xpLxTAdJHOMoSKsIJCDpL2p+0YBzRejASxpcB0J
         emvomluNPy0zWxP3jF3JNRg1dKoZIQWhwq8KcrYep3PpcloETsxKZ0qZiOwj6lIWtxMG
         TCv6++jsuyigUsGIHA52mWoU1hAzeKH6YrHDnYOTBJZXHjC3LvqNzhYUjrMKCeAUBmLZ
         Z6BLmzb1qrr5Tq1iLFJKeLHJhZ7MRcwaTrEdZ3WwiPFhgw191lgCJcI3yQSHXnnIPndh
         JXDWSZh1cgem+CvzpXe/W/UuU1z9BFymRH5KvasNVlk36b6tofci+p51R486xIJiyH2a
         hI/Q==
X-Gm-Message-State: AAQBX9diuSbsmKXu1nHC0aH99yTcF2PXAkoOre5IOMcXCvA7J66AWxMR
        W2M4FM9foumcrlfhdLh6M+TqDJbpSP2PVxB3YW61sKgRGhQ=
X-Google-Smtp-Source: AKy350ai74xPKhE2xPqnYTzdA58xoThXFlI6Bop3dQ/PP+2cWuDlEPDOCoU8/80INtmcMUbdznWPq5j4dZYMEXQp4ac=
X-Received: by 2002:a17:907:3ad0:b0:94f:24d7:64d5 with SMTP id
 fi16-20020a1709073ad000b0094f24d764d5mr808055ejc.56.1682045368170; Thu, 20
 Apr 2023 19:49:28 -0700 (PDT)
MIME-Version: 1.0
References: <20221222221244.1290833-1-kuba@kernel.org> <305d7742212cbe98621b16be782b0562f1012cb6.camel@redhat.com>
In-Reply-To: <305d7742212cbe98621b16be782b0562f1012cb6.camel@redhat.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Fri, 21 Apr 2023 10:48:51 +0800
Message-ID: <CAL+tcoBU+UD_8aXkJy95zNzFeOBMQvQE6jj9syiKvOh_wcLrcw@mail.gmail.com>
Subject: Re: [PATCH 0/3] softirq: uncontroversial change
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, peterz@infradead.org,
        tglx@linutronix.de, jstultz@google.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 1:34=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> Hi all,
> On Thu, 2022-12-22 at 14:12 -0800, Jakub Kicinski wrote:
> > Catching up on LWN I run across the article about softirq
> > changes, and then I noticed fresh patches in Peter's tree.
> > So probably wise for me to throw these out there.
> >
> > My (can I say Meta's?) problem is the opposite to what the RT
> > sensitive people complain about. In the current scheme once
> > ksoftirqd is woken no network processing happens until it runs.
> >
> > When networking gets overloaded - that's probably fair, the problem
> > is that we confuse latency tweaks with overload protection. We have
> > a needs_resched() in the loop condition (which is a latency tweak)
> > Most often we defer to ksoftirqd because we're trying to be nice
> > and let user space respond quickly, not because there is an
> > overload. But the user space may not be nice, and sit on the CPU
> > for 10ms+. Also the sirq's "work allowance" is 2ms, which is
> > uncomfortably close to the timer tick, but that's another story.
> >
> > We have a sirq latency tracker in our prod kernel which catches
> > 8ms+ stalls of net Tx (packets queued to the NIC but there is
> > no NAPI cleanup within 8ms) and with these patches applied
> > on 5.19 fully loaded web machine sees a drop in stalls from
> > 1.8 stalls/sec to 0.16/sec. I also see a 50% drop in outgoing
> > TCP retransmissions and ~10% drop in non-TLP incoming ones.
> > This is not a network-heavy workload so most of the rtx are
> > due to scheduling artifacts.
> >
> > The network latency in a datacenter is somewhere around neat
> > 1000x lower than scheduling granularity (around 10us).
> >
> > These patches (patch 2 is "the meat") change what we recognize
> > as overload. Instead of just checking if "ksoftirqd is woken"
> > it also caps how long we consider ourselves to be in overload,
> > a time limit which is different based on whether we yield due
> > to real resource exhaustion vs just hitting that needs_resched().
> >
> > I hope the core concept is not entirely idiotic. It'd be great
> > if we could get this in or fold an equivalent concept into ongoing
> > work from others, because due to various "scheduler improvements"
> > every time we upgrade the production kernel this problem is getting
> > worse :(
>
[...]
> Please allow me to revive this old thread.

Hi Paolo,

So good to hear this :)

>
> My understanding is that we want to avoid adding more heuristics here,
> preferring a consistent refactor.
>
> I would like to propose a revert of:
>
> 4cd13c21b207 softirq: Let ksoftirqd do its job
>
> the its follow-ups:
>
> 3c53776e29f8 Mark HI and TASKLET softirq synchronous
> 0f50524789fc softirq: Don't skip softirq execution when softirq thread is=
 parking

More than this, I list some related patches mentioned in the above
commit 3c53776e29f8:
1ff688209e2e ("watchdog: core: make sure the watchdog_worker is not deferre=
d")
8d5755b3f77b ("watchdog: softdog: fire watchdog even if softirqs do
not get to run")
217f69743681 ("net: busy-poll: allow preemption in sk_busy_loop()")

>
> The problem originally addressed by 4cd13c21b207 can now be tackled
> with the threaded napi, available since:
>
> 29863d41bb6e net: implement threaded-able napi poll loop support
>
> Reverting the mentioned commit should address the latency issues
> mentioned by Jakub - I verified it solves a somewhat related problem in
> my setup - and reduces the layering of heuristics in this area.

Sure, it is. I also can verify its usefulness in the real workload.
Some days ago I also sent a heuristics patch [1] that can bypass the
ksoftirqd if the user chooses to mask some type of softirq. Let the
user decide it.

But I observed that if we mask some softirqs, or we can say,
completely revert the commit 4cd13c21b207, the load would go higher
and the kernel itself may occupy/consume more time than before. They
were tested under the similar workload launched by our applications.

[1]: https://lore.kernel.org/all/20230410023041.49857-1-kerneljasonxing@gma=
il.com/

>
> A refactor introducing uniform overload detection and proper resource
> control will be better, but I admit it's beyond me and anyway it could
> still land afterwards.

+1

Thanks,
Jason
>
> Any opinion more then welcome!
>
> Thanks,
>
> Paolo
>
