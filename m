Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203CA1ECA2B
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 09:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbgFCHFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 03:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgFCHFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 03:05:47 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457B9C05BD43
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 00:05:46 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id s18so1108440ioe.2
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 00:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yzQjFogPAYNv8AHviWr8AcjUPuA1WozjAYYWyYrp1Wc=;
        b=jLxh9QU8Vg6dgoDIL7o0fcgQ5K8N/ssijFij6Lw1Su0p/qJIAIO1BZkCMX65xqFcBm
         4LtHJ5Y3EiAoDv+5mmDsgvvjx38h1QgJxQvdwprllXS+vA46b5zzbkeyX4ry/VYiVh2I
         rXTDAN5dUvPabGQpLpQCyLh1FrwFWmscJC5mZkvBg+BSombwijjwtJ4ocVqs2YTWoLkp
         zo/rv64nz68E/NTV0S1F/P+FBRiZ1IWNGA701QNiS9qYVTJiBd6wd7mQKDTdyAiPEd6A
         zqX5lkV/V1/fC4QTUCrWUD5FYd2crb2shpnFWSWKQtGRV7N9X9vhWOW6phqG4jWwRbRO
         iGGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yzQjFogPAYNv8AHviWr8AcjUPuA1WozjAYYWyYrp1Wc=;
        b=mkb49n6TvA7wmxjx4gvGu96uDzK2jC/eD7wX7qLxdwu1llXp2ktBnNXnI8BgR6mFl0
         zF+orbJvjpe2g5GqaLXcmBToKe+kUC2gkRPNVs1TNOh3gTUFbLSkbJ8qJf5vCaA/5YD8
         0VKaWzgBvnKwqUpyTBZy0cZzOq3oblWyrDAWN80SOhMcRDEU9r5bj41tb/Ti4wnojFAM
         WBhvq1zSs1t3BeXYk+ERDKdZKijxB4Y+gSXfQ+kPh6hQAhI/HB+GQQig/RZY3o84drzw
         /jAJI4KWYCftMwyrzqVGL9/wZqfqofS/A+M3U8mE83dKiKfPK0tEeXXLLG4rFuXrlq3d
         JRrA==
X-Gm-Message-State: AOAM532kPrXAIJmKdznY28fju6SCRBWTLnW1XaKuSEtIryaCXi3smD/8
        DHv1Z6Gf8D/i+CDw3djJXuBFodyXpNBdwyZLZmY=
X-Google-Smtp-Source: ABdhPJwXKmwe+fGQtY3ok2V3CvY4ejr7ObLD07BzEGhEqPT12MpqjjKwf244CtcgLwYinidJfVeJM9itRLps0AWA+Uw=
X-Received: by 2002:a05:6602:2f0a:: with SMTP id q10mr2426742iow.134.1591167944751;
 Wed, 03 Jun 2020 00:05:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1590512901.git.petrm@mellanox.com> <CAM_iQpW8NcZy=ayJ49iY-pCix+HFusTfoOpoD_oMOR6+LeGy1g@mail.gmail.com>
 <20200601134023.GQ2282@nanopsycho> <CAM_iQpXTWK+-_42CsVsL==XOSZO1tGeSDCz=BkgAaRsJvZL6TQ@mail.gmail.com>
 <20200602060555.GR2282@nanopsycho>
In-Reply-To: <20200602060555.GR2282@nanopsycho>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 3 Jun 2020 00:05:33 -0700
Message-ID: <CAM_iQpWw81SqpWHFMLz=rxM8CwFW77796=Cf9x+tERd6gK6nrg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] TC: Introduce qevents
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Petr Machata <petrm@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 11:05 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Mon, Jun 01, 2020 at 09:50:23PM CEST, xiyou.wangcong@gmail.com wrote:
> >On Mon, Jun 1, 2020 at 6:40 AM Jiri Pirko <jiri@resnulli.us> wrote:
> >> The first command just says "early drop position should be processed by
> >> block 10"
> >>
> >> The second command just adds a filter to the block 10.
> >
> >This is exactly why it looks odd to me, because it _reads_ like
> >'tc qdisc' creates the block to hold tc filters... I think tc filters should
> >create whatever placeholder for themselves.
>
> That is how it is done already today. We have the block object. The
> instances are created separatelly (clsact for example), user may specify
> the block id to identify the block. Then the user may use this block id
> to add/remove filters directly to/from the block.
>
> What you propose with "position" on the other hand look unnatural for
> me. It would slice the exising blocks in some way. Currently, the block
> has 1 clearly defined entrypoint. With "positions", all of the sudden
> there would be many of them? I can't really imagine how that is supposed
> to work :/

I imagine we could introduce multiple blocks for a qdisc.

Currently we have:

struct some_qdisc_data {
  struct tcf_block *block;
};

Maybe we can extend it to:

struct some_qdisc_data {
  struct tcf_block *blocks[3];
};

#define ENQUEUE 0
#define DEQUEUE 1
#define DROP 2

static struct tcf_block *foo_tcf_block(struct Qdisc *sch, unsigned long cl,
                                            struct netlink_ext_ack
*extack, int position)
{
        struct some_qdisc_data *q = qdisc_priv(sch);

        if (cl)
                return NULL;
        return q->block[position];
}


Just some scratches on my mind.

Thanks.
