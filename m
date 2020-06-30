Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A78E20FFF3
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 00:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgF3WQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 18:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgF3WQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 18:16:33 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77752C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 15:16:33 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id c16so22781538ioi.9
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 15:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w7dlV35/ynf/6OeN2ExucxhcfbWKMj6YGJTlTTPGRrE=;
        b=oNnjp3G9vwckD7UjnHPVYbyPhpunY5EN4LCv6VAVE9QeQc3WJ68zfbmNmo+C2s3eIX
         qnvm0Xf5flLXY7/T2mU9Q+nkNXnDt7SD1gam8i+a9IFPriLV0JzaqndD6A9o0TOKuZ+B
         Kca+cI0Zz+AH33nRDNjwa5eVoPx3DiUxYcq0yH4DcOkSfsCDn/FGh6/CetSnjtE0sX9I
         ycDIHnpqn44MMQuykW0w7LKgA+m720fuwICvNj7GzNaVevAHDgzSqyB8e5Efp2nDKoiC
         Ru/iUWcDi1mxzFjkO1YvyovSvBUnnIt8zq0S1dQNyHpRmX1/ThPTtQln3tjT4VUz5g7O
         9eDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w7dlV35/ynf/6OeN2ExucxhcfbWKMj6YGJTlTTPGRrE=;
        b=n8qqetw2n1JYZjZu19Koep4fQ0JzKXSwL9kVnFMYKpk5U4v4CicxvCJQZri9BOWgfX
         S8TWRhPN/mA/hOac7gLRxecVZA8dY3JDXn/0CThdkQLWV0VjqSZ+mSfD0z6Hm13+VeBZ
         Pwddaf2tqtmqn4Ef5SvyjQ8PslycNRxqa8gf03BF3IwJjTQ0xqZhPznGldTluwYUSBxt
         Fe8fIKXsz4632irKvK+fzvZnTzaUmxBi/Ty4JK50ishK0xfJWTQgD/9//t9FSEgjLTnH
         FOQr8qKXnGxx1mlDNYVEn30+Us/dVN2aSGPrZnsEcm/Pba9QbpVtMkvBTmOqJWFRxJlw
         WK3A==
X-Gm-Message-State: AOAM530M+a2GMvfd5T4imbcXjaYCkwQgNo4hD0Y+BljjQZYWVDlyCvrU
        fEK0SFNWUF1Q+Gh5bivXWK1dyymtMBCaOgRea4w=
X-Google-Smtp-Source: ABdhPJwF69jwGqdNv5OUh2Z6eFNuJtKiLnKKZMF099hrrqVLq/O2bGW4bAe9AwuQh/nGXoclUuGHkCmm0PUYz+CQkx8=
X-Received: by 2002:a6b:bec7:: with SMTP id o190mr24169570iof.44.1593555392670;
 Tue, 30 Jun 2020 15:16:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
 <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com> <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com> <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com> <CAM_iQpVKqFi00ohqPARxaDw2UN1m6CtjqsmBAP-pcK0GT2p_fQ@mail.gmail.com>
 <459be87d-0272-9ea9-839a-823b01e354b6@huawei.com> <35480172-c77e-fb67-7559-04576f375ea6@huawei.com>
 <CAM_iQpXpZd6ZaQyQifWOHSnqgAgdu1qP+fF_Na7rQ_H1vQ6eig@mail.gmail.com>
 <20200623222137.GA358561@carbon.lan> <b3a5298d-3c4e-ba51-7045-9643c3986054@neo-zeon.de>
 <CAM_iQpU1ji2x9Pgb6Xs7Kqoh3mmFRN3R9GKf5QoVUv82mZb8hg@mail.gmail.com>
 <ec45c883-b811-1580-c678-73a490fe8a0c@neo-zeon.de> <6b5827a3-2832-b31d-83b6-5614a2080754@neo-zeon.de>
In-Reply-To: <6b5827a3-2832-b31d-83b6-5614a2080754@neo-zeon.de>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 30 Jun 2020 15:16:20 -0700
Message-ID: <CAM_iQpUev+6+5CYYgrsDxn99Uwy6xN6m59C2Rn8mx0-nNcDuQA@mail.gmail.com>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Cameron Berkenpas <cam@neo-zeon.de>
Cc:     Roman Gushchin <guro@fb.com>, Zefan Li <lizefan@huawei.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 3:59 PM Cameron Berkenpas <cam@neo-zeon.de> wrote:
>
> The box has been up without issue for over 25 hours now. The patch seems
> solid.

That's great! Thanks for testing!
