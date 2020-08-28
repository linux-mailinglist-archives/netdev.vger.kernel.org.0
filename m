Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85235256054
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 20:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgH1SQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 14:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbgH1SQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 14:16:20 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB271C061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 11:16:19 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id c6so1427577ilo.13
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 11:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m22z0ISyFMvPcoTGvRsrW6R3PDdN3a+wG0MVCpkElCU=;
        b=N4V6vN8+5cXZYLmAPCe/iq+aQqjmuN3B4WDzQsePN45f6lbLmwvy4cZu+2B4aTgLF3
         Cno9iU0N//Gup/jn0+JRGc3EyrulB9svBR3PoJIPSDWX2+OpoleGvR6Nbqa6MIEHbYRE
         Bvzl6URXQTCn5M+ryyBYzFSOVvPwEyKsAKghdf/c6ot8WeWyxiDaJvO4dN3qmq2OnSay
         Fs7WNoeYYXeGkdYXLh/lUX32vUrm1cTZ09GEXdmqIFcwE/LGKOvN4MISg1vaORPyKHvD
         29onA6qi0lj0oOwyjz4iNK3QLdTznITkMBIDneEKyZzzwsE8mijZfKwhWLgRoXCabiYy
         bzpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m22z0ISyFMvPcoTGvRsrW6R3PDdN3a+wG0MVCpkElCU=;
        b=GwNsER/jZSdlx1OEfr+9TbBvtTXFmtde0v7JXmaiJz5/R2hsbOnz7dGUUgphk3pE2a
         kZwsGzE68Xyqr9noazsg2XhCqIljkXHdPNLV3Qq3ggd1bnj2H6uBJwItHRULO4/Bh+Qu
         egJd21LEbxHqMgb/GkVGlYSqgFJTv5Awe+zkAg0nStmafzV7vA2Sz/Hv/gJhdYJacEa1
         Jl6uZiGROx78zzZDElgksMKmPnk/2icY3TbutXemWJjJuRXf0YzELtMXefDT+5Chr096
         9Ah9YI4dGkQEswweU6J2LPW3rA9MK0O9uHLxvDu/TOksxcdrGE10nHAnGVQWETefiys/
         5SYQ==
X-Gm-Message-State: AOAM532yJ/Ep0AeOmwMILu60HnSy2NcEOlj8ExaB8A2M6NIZ3jqsP6zu
        CwtwPzFDXWwIZUduMwLc441zVO6/3P1wWICyrL0=
X-Google-Smtp-Source: ABdhPJzr+Ms7wTHMx+rsQDR5no+zqQHg0kE9et8BvNhkahxISc4m6SVaNRutMeSCsqNC2pxuCXG4fvIGnrc8JLvAxbs=
X-Received: by 2002:a92:9a07:: with SMTP id t7mr145168ili.144.1598638579109;
 Fri, 28 Aug 2020 11:16:19 -0700 (PDT)
MIME-Version: 1.0
References: <1598335663-26503-1-git-send-email-wenxu@ucloud.cn> <20200825153318.GA2444@localhost.localdomain>
In-Reply-To: <20200825153318.GA2444@localhost.localdomain>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 28 Aug 2020 11:16:06 -0700
Message-ID: <CAM_iQpX+hoajt8VZQsHYqp+JzwAn0-t7pPHiQaKLOxKE6_zQpg@mail.gmail.com>
Subject: Re: [PATCH net-next] net/sched: add act_ct_output support
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     wenxu <wenxu@ucloud.cn>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 8:33 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> I still don't understand Cong's argument for not having this on
> act_mirred because TC is L2. That's actually not right. TC hooks at L2

You miss a very important point that it is already too late to rename
act_mirred to reflect whatever new feature adding to it.


> but deals with L3 and L4 (after all, it does static NAT, mungles L4
> headers and classifies based on virtually anything) since beginning,
> and this is just another case.

So eventually you want TC to deal with all L3 stuff?? I think you are
exaggerating it, modifying L3/L4 headers does not mean it handles L3
protocol. But, doing IP layer fragmentation is clearly doing something
belongs to IP protocol. Look at the code, you never need to call into
IP layer code (except some trivial helpers) until you do CT or
fragmentation. This is why I do not like act_ct either, it fits oddly into
TC.

Why not just do segmentation instead of fragmentation? GSO is
already performed at L2 by software.

Thanks.
