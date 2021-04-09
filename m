Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A1E359BB6
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 12:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbhDIKPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 06:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234717AbhDIKPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 06:15:12 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1C3C061765;
        Fri,  9 Apr 2021 03:14:11 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id d5-20020a17090a2a45b029014d934553c4so3736699pjg.1;
        Fri, 09 Apr 2021 03:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YOBY+nGJ0NSe8Za1C4NDeG65/7cWv3y7G0rLV+xs2sQ=;
        b=E9a+9aKUqNdSjhLgrcBU5Veiwk1IQh45MTtCR3aauVhtQUxiD8rU+RIuWYqtZjVBPX
         SHdcq05gt3BqMF7dOX0mTYKQnCAN048TIC+O96QoeROKd1feVe+ckBOIleXgtwhDllVV
         jg6BGNvrsptQmqQGNOujMLbOXoGO25G0BCRs7ySvONNS9IKhfy9DmfejT6JsT5w5h/Pt
         fzgWM9epserQsy/F65RbEoNFFcJONS0l0KHTwnQauUD1Vu7pdo6SpMGk1WYgjeeWRx4u
         IwUh4pYBv01Hxcg5WgVWnfAgZoocLuL2L7FuQUkFcXFlBRBtNGKSZhry0w/W0YS82ZYR
         /fdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YOBY+nGJ0NSe8Za1C4NDeG65/7cWv3y7G0rLV+xs2sQ=;
        b=VyZgYsk6vTtsAzwPqyeQBcZpgr8HJELjHTYY2QJ/2a4PlaO86GxA7GqjrK/Gndbim9
         T2XiD4NA29DTbNsCMj4Gj/eDT6bAfZo/rjNDid8rr4M+RRfmpgK37T46jPGrTky1jOuI
         gcSa1gAIiDPj1/0cbMsAeZd3clQ1exXzsXkyHluRDGDWapOABGRDQPMiZrqHKC0vRMro
         JcHKgyJZ61H76OqyGhnT7+pw1irFJqNxmJpfI2bB0uujxNVdgvVVhzZZ7GzBmIAOng4a
         NwPD/C/I3Q34xTFv7GVhfgBrW9Pm6omOdqgf07OkrxUor0ryS4NcK/McVFoNokJdoJbD
         29/A==
X-Gm-Message-State: AOAM533ursXxYfqrSYZt57l3LbFnqMg2mPriufQJ3E5nl8unfgsBBzGn
        7ufA8Mj3TUELyqP8EMw7R1tRB8n3RKPRp4palqU=
X-Google-Smtp-Source: ABdhPJzrCE9HvBQl4/X83laizRRPqiS3VhqmtRHN+JqA4mFaXaaQ3uyPmWbixzJjFsfydz01nFNQwbEMgYazvpCcJ6c=
X-Received: by 2002:a17:90b:400a:: with SMTP id ie10mr4205591pjb.210.1617963251043;
 Fri, 09 Apr 2021 03:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAJht_ENNvG=VrD_Z4w+G=4_TCD0Rv--CQAkFUrHWTh4Cz_NT2Q@mail.gmail.com>
 <20210409073046.GI3697@techsingularity.net> <CAJht_EPXS3wVoNyaD6edqLPKvDTG2vg4qxiGuWBgWpFsNhB-4g@mail.gmail.com>
 <20210409084436.GK3697@techsingularity.net> <CAJht_EPrdujG_0QHM1vc2yrgwwKMQiFzUAK2pgR4dS4z9-Xknw@mail.gmail.com>
 <87ab3d13-f95d-07c5-fc6a-fb33e32685e5@gmail.com>
In-Reply-To: <87ab3d13-f95d-07c5-fc6a-fb33e32685e5@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 9 Apr 2021 03:14:00 -0700
Message-ID: <CAJht_EOmcOdKGKnoUQDJD-=mnHOK0MKiV0+4Epty5H5DMED-qw@mail.gmail.com>
Subject: Re: Problem in pfmemalloc skb handling in net/core/dev.c
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Mel Gorman <mgorman@suse.de>, jslaby@suse.cz,
        Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 9, 2021 at 3:04 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> Note that pfmemalloc skbs are normally dropped in sk_filter_trim_cap()
>
> Simply make sure your protocol use it.

It seems "sk_filter_trim_cap" needs an "struct sock" argument. Some of
my protocols act like a middle layer to another protocol and don't
have any "struct sock".

Also, I think this is a problem in net/core/dev.c, there are a lot of
old protocols that are not aware of pfmemalloc skbs. I don't think
it's a good idea to fix them one by one.
