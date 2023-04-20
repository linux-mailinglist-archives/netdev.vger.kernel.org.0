Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350766E9AFE
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjDTRmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjDTRmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:42:12 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F47133
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:42:09 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-760c58486d3so38672439f.0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682012528; x=1684604528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wWI/KrkBx1ruAw1fs2tCw7jtIGLbpWu/3dIfHT/7yPY=;
        b=dG/12FU273yJIqrgVgIy0hpaDniYZteZdc0q5qUnK/tUBY0lYC/cwnLUJb2RA7Tx4t
         pWHp9T6wiMZ8VED3rwPBOlXY4idM6rPkEjdzIoQTD0arlH8NDBko1kX08GzKfzVxvR1M
         GtusXvkMxv8spvgxIs1F0Yxn34fSLI0oNPEkxEFjsOScIAq+kWxob0rgcWyMSVR/NmCm
         u/9hjGzCP0XJUR2C2j+0i/seC8P+AzraizAsLWYHtHiFBhesBGtaC23O9XfGQAkBQBRv
         ms/IZoEYCVGB1sAoIe2S82A+Hzb0Y7oeBXyNp62fNDp8cbhft7elBgddKFhZNu1xpbF1
         cErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682012528; x=1684604528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wWI/KrkBx1ruAw1fs2tCw7jtIGLbpWu/3dIfHT/7yPY=;
        b=leraXUkcqDdR8bKXo0ApfTUo/LVgaY/DCi9R1Jii6ZgQHv0gVwLlh/HBiYYdoUyDip
         WwQMh/M0HMbNV9cpZFgQbL7df5Kci6HasrmeZ9QPENGPnMfqjYv63XYTe/f6YJHNHtjm
         BcrnBhANn7S6Hu7/SXRanfyAimFnHSM0JqCRuQE422QCAoXKGaBYTxSO3T/Mbassg27r
         viK5fOMKysYQ+iaRFZeWO9HIDVeBp4yJ3kfSDdnl6MeEQjh8SXQJ5tKNG1bAho9afSEq
         vap2u/WhPUsyZXghDMWmyNNv7EAaMiTbwKNeMdSn5E/q+V7ExM972/LJs8TZNhnX00+y
         8aOw==
X-Gm-Message-State: AAQBX9diLHH7LGAeYzOzQusVtfdLC/zImnIPmB/r4F4R7BaQbw+aJqzN
        KBXZTallohG5xn67zBtT5ochk8yH7pE3jr6a+yHiCQ==
X-Google-Smtp-Source: AKy350ab9Bpn/wPH20efhl8mO92kdynFUNaFK18r9azbn9xAWSjeRVd7V3GFinVkzOtsE+MoWCmddGfBkWvj0NN34co=
X-Received: by 2002:a92:c908:0:b0:329:42d1:6e2d with SMTP id
 t8-20020a92c908000000b0032942d16e2dmr1162376ilp.6.1682012528360; Thu, 20 Apr
 2023 10:42:08 -0700 (PDT)
MIME-Version: 1.0
References: <20221222221244.1290833-1-kuba@kernel.org> <305d7742212cbe98621b16be782b0562f1012cb6.camel@redhat.com>
In-Reply-To: <305d7742212cbe98621b16be782b0562f1012cb6.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Apr 2023 19:41:57 +0200
Message-ID: <CANn89iKQ2KR23Ln9FU5RCKH89KWCNcu9QWuVLB4CcEqgoH+iRQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] softirq: uncontroversial change
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, peterz@infradead.org,
        tglx@linutronix.de, jstultz@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 7:24=E2=80=AFPM Paolo Abeni <pabeni@redhat.com> wro=
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
> Please allow me to revive this old thread.
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
>
> The problem originally addressed by 4cd13c21b207 can now be tackled
> with the threaded napi, available since:
>
> 29863d41bb6e net: implement threaded-able napi poll loop support
>
> Reverting the mentioned commit should address the latency issues
> mentioned by Jakub - I verified it solves a somewhat related problem in
> my setup - and reduces the layering of heuristics in this area.
>
> A refactor introducing uniform overload detection and proper resource
> control will be better, but I admit it's beyond me and anyway it could
> still land afterwards.
>
> Any opinion more then welcome!

Seems fine, but I think few things need to be fixed first in
napi_threaded_poll()
to enable some important features that are currently  in net_rx_action() on=
ly.
