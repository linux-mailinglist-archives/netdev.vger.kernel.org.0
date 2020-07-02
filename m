Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3331A211B3C
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 06:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgGBEtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 00:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgGBEtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 00:49:01 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F684C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 21:49:01 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id t4so9905286iln.1
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 21:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ja7sx2wushUMYxUE5tyh1jopAgwFg/ym6zqxOiu4gss=;
        b=guFqxti3+bEiQHnxPHp10NZcukD4lJl5kUtUkaAORQMpY/RasNfKwoQP+poiVB+0MQ
         MyTSQ+i4YyNapXt0RHcVWy8EzOieleiSNB7g0H7KtSg5AHxGegzBxwQ5b3OB+lxVyJlh
         1//6tiJPY8lIXlspZ5HRjB8ae1BQEjnIulfsivRUUlcGT20tXjK1l/RokxM1jcbexd//
         Pu2WDU2RxLAa7twflSk7ySsV5n2w/4cMBXq4I1MOASkfLC9WdX4smCopXshsru9kAnEQ
         Rx+ltSWLS8S6zfpEqhglkHw1m3r0F3b0PaPVIOIfIKY+dWkrvmc+ps3mhWlymT77mEpN
         Kt9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ja7sx2wushUMYxUE5tyh1jopAgwFg/ym6zqxOiu4gss=;
        b=TBikbdbVYJ5+SnWgf0ZFwfUG1cU5wdvM8PrHYwPqZay1CRyIOWw7afiXfuMXI+y666
         2AJaefHiSS+RmpVFL0nnP/Gvn662AdyVADJ/TC7VffYvUelzMgldpwVN15oB5vkKBrPY
         Z52ua/dId3nNKCsQreBe6vhdtQLgDdmX93KDDoivF/GEnRJowMPh8wnXZoMAbiv+0SnX
         6M+MWvxurMH5BOU4l4qmCkQbujQkSQpDe76zdGR0orp5vpdGz6wHqNBWbV5RHfSQG4rx
         KLsi7ZvmrAAeiggU6M7wIsGZt0IK8R46itraYApYuXuJVrGTT51wuuODVdAYOaL99z/u
         YMfA==
X-Gm-Message-State: AOAM533Cn1DY5AsfPJoODt9fk+ERnlbl7caDIBIuLBnLZ+0Yku65QGtU
        rTijUbMavwobxiAeARAyseLzxTG+Wz9RnlIJ0SM=
X-Google-Smtp-Source: ABdhPJy10kLhzERddYayXcdiimd17/OCe0SBoaX7ZQwCJ/ANsoKbEr+BiJwuPhnC1ddVtaQHMpaGyoVTRmSkFfbt2A4=
X-Received: by 2002:a92:bb0b:: with SMTP id w11mr11318742ili.238.1593665340589;
 Wed, 01 Jul 2020 21:49:00 -0700 (PDT)
MIME-Version: 1.0
References: <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com>
 <CAM_iQpVKqFi00ohqPARxaDw2UN1m6CtjqsmBAP-pcK0GT2p_fQ@mail.gmail.com>
 <459be87d-0272-9ea9-839a-823b01e354b6@huawei.com> <35480172-c77e-fb67-7559-04576f375ea6@huawei.com>
 <CAM_iQpXpZd6ZaQyQifWOHSnqgAgdu1qP+fF_Na7rQ_H1vQ6eig@mail.gmail.com>
 <20200623222137.GA358561@carbon.lan> <b3a5298d-3c4e-ba51-7045-9643c3986054@neo-zeon.de>
 <CAM_iQpU1ji2x9Pgb6Xs7Kqoh3mmFRN3R9GKf5QoVUv82mZb8hg@mail.gmail.com>
 <20200627234127.GA36944@carbon.DHCP.thefacebook.com> <CAM_iQpWk4x7U_ci1WTf6BG=E3yYETBUk0yxMNSz6GuWFXfhhJw@mail.gmail.com>
 <20200630224829.GC37586@carbon.dhcp.thefacebook.com>
In-Reply-To: <20200630224829.GC37586@carbon.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 1 Jul 2020 21:48:48 -0700
Message-ID: <CAM_iQpWRsuFE4NRhGncihK8UmPoMv1tEHMM0ufWxVCaP9pdTQg@mail.gmail.com>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Roman Gushchin <guro@fb.com>
Cc:     Cameron Berkenpas <cam@neo-zeon.de>, Zefan Li <lizefan@huawei.com>,
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

On Tue, Jun 30, 2020 at 3:48 PM Roman Gushchin <guro@fb.com> wrote:
>
> Btw if we want to backport the problem but can't blame a specific commit,
> we can always use something like "Cc: <stable@vger.kernel.org>    [3.1+]".

Sure, but if we don't know which is the right commit to blame, then how
do we know which stable version should the patch target? :)

I am open to all options here, including not backporting to stable at all.

Thanks.
