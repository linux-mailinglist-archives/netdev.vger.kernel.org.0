Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97152414ED
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 04:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgHKCYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 22:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgHKCYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 22:24:51 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CDBC06174A;
        Mon, 10 Aug 2020 19:24:51 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id k4so2778534ilr.12;
        Mon, 10 Aug 2020 19:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hCz8EvxNcwP1MLnxl5uqHWrnePg4yqrkMKmuLHur9S8=;
        b=lDqu6Q3VJDQPoRfu4Yy67aD92wWClr1dz94yr7y0wb7mjfoSWdPiz7Nx0fuQO/mTlI
         b72OSmmvaAQgOmjIQ4zPJyGsg3G+gisdKI4pVgQwVb6Ns6BkTiakNpu1XAs6UwcjnysS
         Lpokm10u/fzLdaFzaprp47EEHlMysDCwd1sF7l0mdGHHQ9GxfLEgWS+2LgYW3ezjfHie
         lzdVx7NNCmhhMTwa1z+ECvU3SrrI2vDMGqwbF4QLCaqCF7tKC8+pmVm2hCpDOemDavah
         1Xa/sU06YgYMHALxXTUtLSuNUSI5A6I7cv9KxvGerAPjZiTtDj9j1FZdBWhjVYOw+koF
         0Tkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hCz8EvxNcwP1MLnxl5uqHWrnePg4yqrkMKmuLHur9S8=;
        b=oieXRvT1TINOcl5KUSjMHbTCH8t7y0QgqnFAETCePjTuqBiGVDDLdDc7KqnWlMuAsB
         Aemc0QtLoOGSWpuAVPBrLoVtpWD+xcca159qpd8OyYS7svyTOqFvnN/0lwfnj58hciGI
         FZ/6fpNvChJ1UGtOJ4znyUyTBkUKiOCixhoryT/Rq4a2GPhCBUwjwOkhVSH0WZ84FkyJ
         Yo2/GFjDSP6QITptnvkM8qEHWfUxFLQq0E7hz/JGDLPY60ZkBLk1ETByLKAeBnyAqNIf
         fd43cFLCbtp7kpylQZyZqUAsSltidXhQYv83BmSuI+M1pX+XheJRB4jcxXlVWvZlwo0N
         UbXQ==
X-Gm-Message-State: AOAM531SUiWBzxgNdH/8Qem9IYJl+R/tO/wQQmWfJ885O2gfRN2tUhmK
        5F8LDlztqWnvva8tiihOqPLSHEsZMAEhzim8p/mcweH5
X-Google-Smtp-Source: ABdhPJzrQn4d38H7qBVbzIk4ZF0R4YJC4C34XU5aTrggi0DeUAtt5mYtlPEbzkNHBnUI3dy066YJxTfNPom+l0SVBGA=
X-Received: by 2002:a92:9116:: with SMTP id t22mr20163057ild.305.1597112689356;
 Mon, 10 Aug 2020 19:24:49 -0700 (PDT)
MIME-Version: 1.0
References: <CA+Sh73MJhqs7PBk6OV2AhzVjYvE1foUQUnwP5DwWR44LHZRZ9w@mail.gmail.com>
 <58be64c5-9ae4-95ff-629e-f55e47ff020b@gmail.com> <CA+Sh73NeNr+UNZYDfD1nHUXCY-P8mT1vJdm0cEY4MPwo_0PtzQ@mail.gmail.com>
 <CAEXW_YSSL5+_DjtrYpFp35kGrem782nBF6HuVbgWJ_H3=jeX4A@mail.gmail.com>
 <20200807222015.GZ4295@paulmck-ThinkPad-P72> <20200810200859.GF2865655@google.com>
 <20200810202813.GP4295@paulmck-ThinkPad-P72> <CAMDZJNWrPf8AkZE8496g6v5GXvLUbQboXeAhHy=1U1Qhemo8bA@mail.gmail.com>
In-Reply-To: <CAMDZJNWrPf8AkZE8496g6v5GXvLUbQboXeAhHy=1U1Qhemo8bA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 10 Aug 2020 19:24:37 -0700
Message-ID: <CAM_iQpXBHSYdqb8Q3ifG8uwa1YfJmGBexHC2BusRoshU0M5X5g@mail.gmail.com>
Subject: Re: [ovs-discuss] Double free in recent kernels after memleak fix
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        =?UTF-8?B?Sm9oYW4gS27DtsO2cw==?= <jknoos@google.com>,
        Gregory Rose <gvrose8192@gmail.com>,
        bugs <bugs@openvswitch.org>, Netdev <netdev@vger.kernel.org>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        rcu <rcu@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 6:16 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> Hi all, I send a patch to fix this. The rcu warnings disappear. I
> don't reproduce the double free issue.
> But I guess this patch may address this issue.
>
> http://patchwork.ozlabs.org/project/netdev/patch/20200811011001.75690-1-xiangxia.m.yue@gmail.com/

I don't see how your patch address the double-free, as we still
free mask array twice after your patch: once in tbl_mask_array_realloc()
and once in ovs_flow_tbl_destroy().

Have you tried my patch which is supposed to address this double-free?
It simply skips the reallocation as it makes no sense to trigger reallocation
when destroying it.

Thanks.
