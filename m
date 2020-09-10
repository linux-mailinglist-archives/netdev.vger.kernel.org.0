Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E504F265077
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgIJUTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgIJUTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:19:13 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0FDC061573;
        Thu, 10 Sep 2020 13:19:13 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id d190so8635023iof.3;
        Thu, 10 Sep 2020 13:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s+AIzW9bZYd69ocgPt6/tPEsvQJmPkUuejY1VbCW5RI=;
        b=PSjUzGamK/yB5XyXSYNk6wk31Mk6jEgr5dlIwKKgp2yr8Iv5d4YrCEh6gMJADlZw1I
         HIM50Z1hOSNAyOrMjiQOj2EfvVQhKEeW/A14DV2yQN9X2drQ75sNjxCSkUuw2/5HxHC9
         PL8zegiOF3qEJAMzKhvGuesj+HYq907JSiW2dBpOS1EjVwiz0Hvj9D9Wnamb6sOjPVmm
         sGk4+v9Oz32W3/7XFZGAvvW4bOerhzXUp+jgdhDnfH62epV9awNozdSfBCZ2laHfZBVF
         z9y62CmyQswHuAe2gNC8gOPsO0Ax98d5cg7rK7WVjrezok8Jj5PUrDmiadC+uenK1jTS
         OoLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s+AIzW9bZYd69ocgPt6/tPEsvQJmPkUuejY1VbCW5RI=;
        b=s06PllhQq89ukpiqL7nF6z/hkkFYADNGZnbsBSsHQB6u6vlAVkrTi1xEiMZSUQqJVf
         Yldvgz8LKngjTzf8Zvw8TVmIxdVkNhLXw8MSz8W8bnQ0cpS4HjZsOH/w1gOVQ7bnaNJz
         Vza8yhAtQO6fZH6YfDWyeGVjq6SwEMOr0pezFsWjb1y5PwRHdhtMw2QjjZd3btmzowmJ
         qElLKhZ8bzHk/bK9O5f9dh4BhKItPHJtblmMXtHANfY9ppSjp9j90Pj0Q3CMz3QOCxVS
         aJGYkP4mHSGB1YBBDH7i/Lw4ux6e/iZMcmW2wWsPkXDDfPNdkz+SZxCXuSoC20fNWEq7
         KqTA==
X-Gm-Message-State: AOAM5336s+yagZFURWhEpW7V+bKQF+l+/6jtPTj/2ROhwxeYhwIZyMTs
        bDgM4TdJAFcLm1g2IYkGlIyYvqknX7mvf1UDn9Y=
X-Google-Smtp-Source: ABdhPJyK/kYoVACa8JXaGcMrn6ejBtf/33fdvZ0QxKmG40KQdhlSLaFv+zNVXZrYfTz1R6C2HS674CbsBqiHtDwdyus=
X-Received: by 2002:a6b:da19:: with SMTP id x25mr8978079iob.12.1599769152687;
 Thu, 10 Sep 2020 13:19:12 -0700 (PDT)
MIME-Version: 1.0
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com> <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
 <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com> <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
 <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com> <CANE52Ki8rZGDPLZkxY--RPeEG+0=wFeyCD6KKkeG1WREUwramw@mail.gmail.com>
 <20200822032800.16296-1-hdanton@sina.com> <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
 <20200825032312.11776-1-hdanton@sina.com> <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
 <20200825162329.11292-1-hdanton@sina.com> <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
 <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com>
 <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
 <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AM7fd2vUOQ@mail.gmail.com>
 <20200827125747.5816-1-hdanton@sina.com> <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
 <20200903101957.428-1-hdanton@sina.com> <CACS=qqLKSpnRrgROm8jzzFid3MH97phPXWsk28b371dfu0mnVA@mail.gmail.com>
In-Reply-To: <CACS=qqLKSpnRrgROm8jzzFid3MH97phPXWsk28b371dfu0mnVA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 10 Sep 2020 13:19:01 -0700
Message-ID: <CAM_iQpUq9-wja3JHz9+TMeXGyAOmJfZDxWUZJ9v25i7vd0Z-Wg@mail.gmail.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Kehuan Feng <kehuan.feng@gmail.com>
Cc:     Hillf Danton <hdanton@sina.com>, Paolo Abeni <pabeni@redhat.com>,
        Jike Song <albcamus@gmail.com>, Josh Hunt <johunt@akamai.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 3, 2020 at 8:21 PM Kehuan Feng <kehuan.feng@gmail.com> wrote:
> I also tried Cong's patch (shown below on my tree) and it could avoid
> the issue (stressing for 30 minutus for three times and not jitter
> observed).

Thanks for verifying it!

>
> --- ./include/net/sch_generic.h.orig 2020-08-21 15:13:51.787952710 +0800
> +++ ./include/net/sch_generic.h 2020-09-03 21:36:11.468383738 +0800
> @@ -127,8 +127,7 @@
>  static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>  {
>   if (qdisc->flags & TCQ_F_NOLOCK) {
> - if (!spin_trylock(&qdisc->seqlock))
> - return false;
> + spin_lock(&qdisc->seqlock);
>   } else if (qdisc_is_running(qdisc)) {
>   return false;
>   }
>
> I am not actually know what you are discussing above. It seems to me
> that Cong's patch is similar as disabling lockless feature.

From performance's perspective, yeah. Did you see any performance
downgrade with my patch applied? It would be great if you can compare
it with removing NOLOCK. And if the performance is as bad as no
NOLOCK, then we can remove the NOLOCK bit for pfifo_fast, at least
for now.

Thanks.
