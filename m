Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF2B215F40
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgGFTVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgGFTVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 15:21:45 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34ABCC061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 12:21:45 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id f6so25021404ioj.5
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 12:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oZA63vFpCn3oFOpSFuQ0TFjLkURfFPWwShJPxeaHrO4=;
        b=KnQ/Qg4fLebp63ArTGo2tokGyryfLLF2FAnm+PI30BQAXxlPfpKVtAto6AwyorCv4j
         PBQ/FHGGFGG7moWSik3M7pizwk34uae0nT5hUw9mG49e0h+l4j/D9G4ed1+4PbiUAIZo
         S0tahXPLukmNrgMaVkAaO3+u8OECX47OAj5uupNrFpgBmmT0z03yOUgkz0w/2zO+YrSy
         rPrgiUTPlCTmiBMgwlGWisQV02Zg74BjxvshD064TUKxyNVPS3KYQW4MKHeJSdGxTDbp
         Xi8qQGFsoTygI/9yrWkwa2H5QDhZ//wzfPGa1fKVoO2AJPcyKl4rr4HQcyJVQlhPnEna
         0zUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oZA63vFpCn3oFOpSFuQ0TFjLkURfFPWwShJPxeaHrO4=;
        b=jicNJeta5ZiMyBx2oV0cVdsLlT1lQIFczERlLfGIgKcuLf1pccOJnMyyLtDHGRzPBX
         F8iwL79tqBTaG/IN0XAsOaPiyHp3RKI4E8I8ctMl+aDZiEievTAVcLGy3nPt0KAJh/p1
         lGq+kKJ9HFEXm9EIUqG6LAhQtPuW/F7Nf8MzkWu7jKKJStDjSjdDX16ReVcwuB+sk61G
         8WOga61E1kJXx7nSXhFKLI79LPRia87bvyf47UGcRmkNFmV+QDoRRI34MixwL1SjjmM2
         08IXGvDyOcSZiRCuwcp+cEZluoAoOeeKacRtU/5z1xea/rMiPID6lziTt3Qkzin6uyNa
         gg+w==
X-Gm-Message-State: AOAM533FdlDIuASw4uJ8y8lERsoWM/7AywDvpVkNqxqHrHq7OIkqleBu
        isJ2lHVDGoQPLyK+WiB5dX6ieyvYFJQ3yAG0BcI=
X-Google-Smtp-Source: ABdhPJwUBbXlzKvXQCGIhAHttrFWp5PCN+0gha8b9XOP/l5OMuxXc3m5rn/1Wz2ecr4MuBXCYTZ2OwdM+JLBcn0enXY=
X-Received: by 2002:a02:c785:: with SMTP id n5mr55979560jao.75.1594063304502;
 Mon, 06 Jul 2020 12:21:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593209494.git.petrm@mellanox.com> <643ef0859371d3bf6280f5014d668fb18b3b6d85.1593209494.git.petrm@mellanox.com>
In-Reply-To: <643ef0859371d3bf6280f5014d668fb18b3b6d85.1593209494.git.petrm@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 6 Jul 2020 12:21:33 -0700
Message-ID: <CAM_iQpUEAt_0Kr1vVfRrpMPz+2arpLA5g4yfWCLe2fhbMTrH7w@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/5] net: sched: Pass root lock to Qdisc_ops.enqueue
To:     Petr Machata <petrm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 3:46 PM Petr Machata <petrm@mellanox.com> wrote:
>
> A following patch introduces qevents, points in qdisc algorithm where
> packet can be processed by user-defined filters. Should this processing
> lead to a situation where a new packet is to be enqueued on the same port,
> holding the root lock would lead to deadlocks. To solve the issue, qevent
> handler needs to unlock and relock the root lock when necessary.
>
> To that end, add the root lock argument to the qdisc op enqueue, and
> propagate throughout.

Hmm, but why do you pass root lock down to each ->enqueue()?

You can find root lock with sch_tree_lock() (or qdisc_lock() if you don't
care about hierarchy), and you already have qdisc as a parameter of
tcf_qevent_handle().

Thanks.
