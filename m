Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31913DF7BD
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 00:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhHCWVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 18:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhHCWVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 18:21:39 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D18C061757;
        Tue,  3 Aug 2021 15:21:26 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so813156pjh.3;
        Tue, 03 Aug 2021 15:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M+6JKKf52HVxLfHy469OKCbdB/YMhbbhQWcIdOqleVw=;
        b=GqAK/nN5486TcHJjWMdZkgyfnxp3LUyPktr4rN/+JjFlwDTMYBEsBxeDDAzcw+sGBL
         +jgkqhjB4PDxNMbn3w4qCSMrups0bFgD2OmG7P2OSdK3Hrqsjkl4g/3qf8cpP3R0PZG9
         jwA734tjghQtz/1kJwOCDwymO26kX9d/90hEYvA9laYoLoTkYGYgwdzQKyAmMMswuyTN
         MpnxXaxczvr4qeuvdwXIXoRVUtIZGHdH0GuKs2Dw4mjlf1gyxUcxHG60TJ4zHs47XIux
         WOKzxCHNYC8zx8y5mOn8QrlxRyDvRxYG4dXS5on9gR2RRj6wTjsB2KBB7/8yhb/t4/xB
         mCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M+6JKKf52HVxLfHy469OKCbdB/YMhbbhQWcIdOqleVw=;
        b=c8LzxlssrsZilCvvR05cnmcdnGr/HmTwjUvWrvdXhgkqmHKDtHZ0dYoUabXQ/SlcOS
         n0Opem8xBi4Z4kM+eEkSB8Cy65kV9dreg82I81faCB+xmpyQtaWOudBSP712d26McQBv
         z1DNyv3M2IvmB8KOlh+Hn5+R53q3vd6lFgVNqTM4UzFIPiVfk69M92mlz9qct5O2e+Qu
         9BLkXVsQxut87JpI25akmKgjXKyPUQE4m07BbxhpNnalgs5EK4lP6Fwiyr4893kWZkuP
         FE/zLrXgXnLqT8FGDeXRYYlbQFOfDVoC0nuffU0HsbCkwKzI7bnpJVRMDECGkySEw90K
         pHhg==
X-Gm-Message-State: AOAM530vFvUJwc+BR+mI91bO95CmsIJ/LKzACCU7rR4IBQeSXX1Rblef
        Fk/ELS29m1shV35kyrGlNYNe5MPh5zIGdHX9tds=
X-Google-Smtp-Source: ABdhPJxtN8MnoEd+1WkSekpJSRyCxssbz2Tsbrjk+zGX6hlCjM/L/F1Z6I127QgiIeh5iUnHDMLL+IQGOz78f1IznzQ=
X-Received: by 2002:a17:90a:b10f:: with SMTP id z15mr15450178pjq.56.1628029286315;
 Tue, 03 Aug 2021 15:21:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210803123921.2374485-1-kuba@kernel.org> <20210803221659.9847-1-yepeilin.cs@gmail.com>
In-Reply-To: <20210803221659.9847-1-yepeilin.cs@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 3 Aug 2021 15:21:15 -0700
Message-ID: <CAM_iQpVUMzP8_gPsth_DncVUdC09ihizTC7jo2t1=MS9uSdfTw@mail.gmail.com>
Subject: Re: [PATCH net-next] tc-testing: Add control-plane selftests for sch_mq
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lucas Bates <lucasb@mojatatu.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 3:17 PM Peilin Ye <yepeilin.cs@gmail.com> wrote:
> +           "setup": [
> +            "echo \"1 1 4\" > /sys/bus/netdevsim/new_device"
> +           ],
> +           "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: mq",
> +           "expExitCode": "0",
> +           "verifyCmd": "$TC qdisc show dev $ETH",
> +           "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-4] bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
> +           "matchCount": "4",
> +           "teardown": [
> +                   "echo \"1\" > /sys/bus/netdevsim/del_device"
> +           ]
> +       },

Like I mentioned to Peilin, I am _not_ sure whether it is better to create
netdevsim device in such a way. Maybe we need to create it before
these tests and pass it via cmdline?? Lucas?

Thanks.
