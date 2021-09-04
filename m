Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75124008EB
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 03:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350398AbhIDBK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 21:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbhIDBK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 21:10:58 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B2EC061575;
        Fri,  3 Sep 2021 18:09:57 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gp20-20020a17090adf1400b00196b761920aso686415pjb.3;
        Fri, 03 Sep 2021 18:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FWQtL5QOoLHU7YQrXkzddtQ+8ZmN5WN9ZTNZWe/Yr7w=;
        b=CoUVo7xPRbd/1OqzsHewb7kBWGZAajvlL0/xxJWJZI3GMfzUAKZIKgMIP1/5mANPrm
         hfUcAl8DRMb1/t90Ch9iw9dHeFG3mqlSq7a+/P38skZeP2lTb6DcrXRX6Mjji9ids45x
         zFal1n4jfVwP/myW+KSOKXKgH9+AiSL/66GX14ihC98NkH13SIZvIkVrFZCmmfBcpMdf
         Z/Pa86ZH6bqLOwFkh278TiddNuU3lanlTOoccCs6UZl5bIYTRremKv0bUQ6LYmMYcChZ
         Tm8aTnKZmhmuww/Y6JqB210q+Icbu9ebHGxA21v7X5VO4icIUfWXBbynfAXcNj7vol5z
         j97w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FWQtL5QOoLHU7YQrXkzddtQ+8ZmN5WN9ZTNZWe/Yr7w=;
        b=ZKr3K5IZjB+I8tWi/an4CUmnCVplHPJIzs1H+KzaBto8VPLKYk7tZqlfYwNG4j6lwc
         M18KDWJNttKMikc4PxarfriaaczR5q/FEziTcUwXitUHcUFe7Z5zvDrSu7ReSjeXa+mZ
         2dpJ+rKvh0/r2RG3lxSFUnupOutvrQpmWRsm+nqg/Am+KsVT+elfZjh1NmPakXEnLhyC
         5kbWNnp0tPt8Tjn2wHhuyDBtVuVlES/A+IJB+UoXvLZqsg+D7O/ZmnAmy1YAdM02W7tz
         7glcSAn+1xdCI8ENXEERx3vBbKY1s2VvtYcVQXetYHcV2Krvw0B+siNkL2zD78YXNqN0
         MMCQ==
X-Gm-Message-State: AOAM530KzXNB1mPquPaZ+sdQkBFLhoJMsNwakAtGAbJUIUDixlNyQWup
        Qg0zA7M7BBaqwahbF9HFuNjP2bTo2eKkEy5ai8w=
X-Google-Smtp-Source: ABdhPJy+3quJK2MbXXTc+bDB6tAaBi//zBB65njhTFjLJ9G/lZklQQLopTKtmcZ5bkikh2tEdTvNV82LnBS14gGeyrQ=
X-Received: by 2002:a17:902:c408:b0:138:e3df:e999 with SMTP id
 k8-20020a170902c40800b00138e3dfe999mr1217318plk.30.1630717797105; Fri, 03 Sep
 2021 18:09:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210821010240.10373-1-xiyou.wangcong@gmail.com>
 <20210824234700.qlteie6al3cldcu5@kafai-mbp> <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
 <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch> <871r68vapw.fsf@toke.dk> <20210901174543.xukawl7ylkqzbuax@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210901174543.xukawl7ylkqzbuax@kafai-mbp.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 3 Sep 2021 18:09:46 -0700
Message-ID: <CAM_iQpUjJ+goqoFX+vPUXbcvt3oDga2UgA-MKMXJh9iYY8j_6g@mail.gmail.com>
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 10:45 AM Martin KaFai Lau <kafai@fb.com> wrote:
> _if_ it is using as a qdisc object/interface,
> the patch "looks" easier because it obscures some of the ops/interface
> from the bpf user.  The user will eventually ask for more flexibility
> and then an on-par interface as the kernel's qdisc.  If there are some
> common 'ops', the common bpf code can be shared as a library in userspace
> or there is also kfunc call to call into the kernel implementation.
> For existing kernel qdisc author,  it will be easier to use the same
> interface also.

Thanks for showing the advantages of a kernel module. And no, we
are not writing kernel modules in eBPF.

And kfunc call really sucks, it does not even guarantee a stable ABI, it
is a serious mistake you made for eBPF.

Thanks.
