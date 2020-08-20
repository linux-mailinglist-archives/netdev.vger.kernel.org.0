Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0236324B048
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 09:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgHTHnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 03:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgHTHnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 03:43:31 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CF7C061757;
        Thu, 20 Aug 2020 00:43:30 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id i6so822265edy.5;
        Thu, 20 Aug 2020 00:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dqghZRBtsmgBcL9zovjVe2f2vLQATQWo8uSmvuxBzHQ=;
        b=iE8RIxO/pFTAv5ttCWHqtyybVWLleG5KbeeliQ4MWAcj3Et6B9Mt+XJaaOYzns3aBF
         WbQx68Vkf31i98LizPvX+hHeT6uZs4Q4Qtu8egP9MT8smRjreJG33EFLD210FvYqRIv6
         VyG/P+c2nTYjIWmCJBuyydQa2XFJObOKoP2r6KiT7Oem/H0j5w0VrvTLItdQdK7o/izy
         Z6rseArdFHX/+devGGumGlVE1hxFC5w3C5CdfUAec54mwpU8Ec5tG0bmEW5Pmpx2QrZO
         djC25HjaY4wNtDeVF6KQ9D9bXKivhfrUQKcCqFWMPDm5uY5s8okiQzuepgC/6IUb49yU
         /FmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dqghZRBtsmgBcL9zovjVe2f2vLQATQWo8uSmvuxBzHQ=;
        b=KH87rDbICNp76BtUEpgaNJaxvxQqUNUPpe4q3AxgOXg46Tk1x2AzhIZMRDhk8Iolxd
         WCcHFlwq8uIF6paVJ5j5diz+J9OwSzHzSVKn2JG+DLbCMqYx0pmukatwjDo+ygAL9jXG
         pbaLJhDSLLbXZOOFa9sVeUE6e4n+vGrPzt2yFyGxMmjLCgy2BsnL32ud5sF5AUEsXd9i
         BbDj0jHkxFNEUy/6Ws5LIKk9/NtXDvIDZe/tb4IN5YKJMo9zlOP4e0aPZ9YDzhUahIck
         HtU9O8n4GaE5/sL1fFdDxbE5QeQoCcajCKJX494PbZMjKiJDgXjXJrpw3YqQs60QyHSJ
         MzEQ==
X-Gm-Message-State: AOAM531t/c6Ld8Nc352w02FyOfs0zyRaUJnC601mXnG5lPU0f1pO0p2c
        3C2YPJ+vhAk9256/r/XsKMtP9GFlEZqvWGXW8No=
X-Google-Smtp-Source: ABdhPJwMbmcJ4NWOGrV3q85l7RlB6WidpEdoOwK1UBexXU20R7Z2Ht1elpiWU7rI7joz4LZw490sfSv6MHCKZI7tMFA=
X-Received: by 2002:aa7:c513:: with SMTP id o19mr1640779edq.327.1597909409462;
 Thu, 20 Aug 2020 00:43:29 -0700 (PDT)
MIME-Version: 1.0
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com> <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
 <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com> <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
 <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com>
In-Reply-To: <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com>
From:   Jike Song <albcamus@gmail.com>
Date:   Thu, 20 Aug 2020 15:43:17 +0800
Message-ID: <CANE52Ki8rZGDPLZkxY--RPeEG+0=wFeyCD6KKkeG1WREUwramw@mail.gmail.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Josh Hunt <johunt@akamai.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kehuan.feng@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Josh,

On Fri, Jul 3, 2020 at 2:14 AM Josh Hunt <johunt@akamai.com> wrote:
{snip}
> Initial results with Cong's patch look promising, so far no stalls. We
> will let it run over the long weekend and report back on Tuesday.
>
> Paolo - I have concerns about possible performance regression with the
> change as well. If you can gather some data that would be great. If
> things look good with our low throughput test over the weekend we can
> also try assessing performance next week.
>

We met possibly the same problem when testing nvidia/mellanox's
GPUDirect RDMA product, we found that changing NET_SCH_DEFAULT to
DEFAULT_FQ_CODEL mitigated the problem, having no idea why. Maybe you
can also have a try?

Besides, our testing is pretty complex, do you have a quick test to
reproduce it?

-- 
Thanks,
Jike
