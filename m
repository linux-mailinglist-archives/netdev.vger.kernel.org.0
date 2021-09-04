Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5049D400CC6
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 21:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237487AbhIDTFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 15:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237371AbhIDTFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 15:05:18 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30944C061575;
        Sat,  4 Sep 2021 12:04:16 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so1751601pjc.3;
        Sat, 04 Sep 2021 12:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AXbeTtMqMo/aTKvuZLDXQ5FW3yxo+iy3ryaN538FkdU=;
        b=Y33EIXrxjIWeT4h/+5Rjxa9BzxRmMJCuUJldNJIwe5HPlLs7Dn8ci/hHdqRqpA4Jrp
         WlVs5T9CSr3ls0p+BtC+8XNkHHAGRg45XWaQfNVSdQHwcdQe0yRE8Dv3bdH3EYx1NxFf
         nkFFskT9xPc/vT3S7wAI5OC+Pa4kgGxWrsYrCBSth4PxQLYCFCIfneFvz0wTyyuyKZKa
         yuj4uUy4gGVE+gNAJ50kOJ4lBMLtO+0fm2c9iesuRy/OBEatz67Q+f4TX8a7xdIFXHHQ
         r2B2LbWUDmnOIYh7mQCDcskln+NyHdBr0fLcSnrzoq37I03Ph7zTmY8PVW6zZAhzMMD2
         nnKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AXbeTtMqMo/aTKvuZLDXQ5FW3yxo+iy3ryaN538FkdU=;
        b=Z/bgSRuqkwt8MWw4dOSeoelQbQOZUwwbHFSHL4zTKpX8dDJGmWo87e8eDfI/Doe9dH
         zTEvD/nNpkt64/mdJzIk44mOVxhVP+NqNB26Bxw2KPBremDIebJ59HmmxCBcj9lseqrD
         Rsp4sQuBfFGf2In/BH+4vPu+O+YmDtkLBtw8LP596sNY0A3XZ6gvWfCv7gdvujvLd7YI
         Jl4gQ4RGAjzicKqgGf23elICCbF94ho9VBmUzXm6tYUNcZs1wvt5hwz0IG5gjz+VUbx2
         dVYF+Q7UrNVukgvBRiUetX3YBXO409cralEnqYJgrAbAXotuMJW5Kr2PbxTo3+czb3nW
         Gd/g==
X-Gm-Message-State: AOAM530eN4O6E+yLiEFzrGnwHIFeZRh8efCqyeVsc/jI/fUpkiAfkROl
        fsf1Qlu2f3l8dSP6SNBKR1xOOiKQAYPpEEp0sXo=
X-Google-Smtp-Source: ABdhPJxnjn28S3Q1uGdHTNfr5X0GiGPtYWSUrP/vZ+QmUEvy0AdlnWo52kSiRaDk+w6KSetaS50kkwKlEOhQxpLsdbw=
X-Received: by 2002:a17:902:c408:b0:138:e3df:e999 with SMTP id
 k8-20020a170902c40800b00138e3dfe999mr4030391plk.30.1630782255546; Sat, 04 Sep
 2021 12:04:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210904064044.125549-1-yan2228598786@gmail.com>
In-Reply-To: <20210904064044.125549-1-yan2228598786@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 4 Sep 2021 12:04:04 -0700
Message-ID: <CAM_iQpWCRYXc1PAOTehgMztfbmSVF=RqudOjhZhGeP_huaKjZw@mail.gmail.com>
Subject: Re: [PATCH] net: tcp_drop adds `reason` and SNMP parameters for
 tracing v4
To:     Zhongya Yan <yan2228598786@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, hengqi.chen@gmail.com,
        Yonghong Song <yhs@fb.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>, 2228598786@qq.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 3, 2021 at 11:43 PM Zhongya Yan <yan2228598786@gmail.com> wrote:
>
> I used the suggestion from `Brendan Gregg`. In addition to the
> `reason` parameter there is also the `field` parameter pointing
> to `SNMP` to distinguish the `tcp_drop` cause. I know what I
> submitted is not accurate, so I am submitting the current
> patch to get comments and criticism from everyone so that I
> can submit better code and solutions.And of course to make me
> more familiar and understand the `linux` kernel network code.

Any reason why only limit this to TCP? I am pretty sure we are
interested in packet drops across the entire stack.

You can take a look at net/core/drop_monitor.c, it actually has
a big advantage over your solution, which is sending entire
dropped packets to user-space for inspection.

If you can have a solution for all packet drops, not just TCP,
it would make your patch much more useful. Therefore, I'd
suggest you to consider extending the drop monitor.

Thanks.
