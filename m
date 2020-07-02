Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FD2212949
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgGBQY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgGBQY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 12:24:58 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2850C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 09:24:57 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id z17so24616869edr.9
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 09:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hiBGL1G5BNNYTkB7ArfahX8fXmCAgmnI8sGRkxHOFeQ=;
        b=LZ9V/OYXyNlkbgUK7PtCxPsjFbzpIw1DK8dajrQvofA9xuuwG3BBGPZP40po+ueczI
         e9o/vK5t3B5695uMeI3kX/4/3MzcU50ka7QsU1bdacMYQtvw0qNUOc2F655ucK7AUY1G
         jlulOe2nVs+3N0+EHcm6Ib0+Dcj6diZSWa5ThyvWrZQaoz0Vn5nwoDMHGoT5dZTdJ0BQ
         e7IjWKS1prmvAD8FCkzfP02jazBS9Vxi7N1nPVnKx/gGgkFF+TTCFEy0nymKrw3OqxpI
         dYs1KeOPJzwdwWwIFJNd9viZZ6zhqUhONjPzz05pj+IG98dVY9XuLU7yL4KiMbKPiTss
         2aGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hiBGL1G5BNNYTkB7ArfahX8fXmCAgmnI8sGRkxHOFeQ=;
        b=tStz2NhLiMr6dAkOwUue6bsAg9HqCSrmPrmth5o9NrHHy8kmtyPiWYhz/fIEWL2RQJ
         7WpA3fFAyBkBddhJVmz6ar6/2+APoM43U4c+xJ8eaFhcZuwjAu63CZ/GLriqe4P73Zw1
         Q50VI+H8a0Fi4nNhccwJnfCfx/TGbdFLV/q9AEt4+LYIOFpAXfBeo4wBI+s3YHElsdC2
         +WUVblPsKU9Qo9brmsHP2+i5vcU4dEvFUI6ZVYuO77CIGXuCPDS4KUxKMkePfA1E7qTq
         9X9J6ONcM4L0zez8UVu8m3fjknY05ik9MW3IYS5su5tY6eKokf1xJMaqQhDUdimhQQ+a
         tHww==
X-Gm-Message-State: AOAM532N75c5nX8eq/Tn0lEbWWM0Ba7RPnRme0jVnjZ5SDPz8/H5gjeC
        hIdJK65D+5NxKclsjTCduSn8h5nC0KTWh+f/kwI=
X-Google-Smtp-Source: ABdhPJz6SofV5o1LNGZk/DZsAQJVGUjtt9UVwQ+/26rgDZNng1YIu8xtQoVnVJ/zrRaxodM7+HTSTq4qnVpWErcUvGM=
X-Received: by 2002:a50:cdc6:: with SMTP id h6mr35049396edj.111.1593707096541;
 Thu, 02 Jul 2020 09:24:56 -0700 (PDT)
MIME-Version: 1.0
References: <459be87d-0272-9ea9-839a-823b01e354b6@huawei.com>
 <35480172-c77e-fb67-7559-04576f375ea6@huawei.com> <CAM_iQpXpZd6ZaQyQifWOHSnqgAgdu1qP+fF_Na7rQ_H1vQ6eig@mail.gmail.com>
 <20200623222137.GA358561@carbon.lan> <b3a5298d-3c4e-ba51-7045-9643c3986054@neo-zeon.de>
 <CAM_iQpU1ji2x9Pgb6Xs7Kqoh3mmFRN3R9GKf5QoVUv82mZb8hg@mail.gmail.com>
 <20200627234127.GA36944@carbon.DHCP.thefacebook.com> <CAM_iQpWk4x7U_ci1WTf6BG=E3yYETBUk0yxMNSz6GuWFXfhhJw@mail.gmail.com>
 <20200630224829.GC37586@carbon.dhcp.thefacebook.com> <CAM_iQpWRsuFE4NRhGncihK8UmPoMv1tEHMM0ufWxVCaP9pdTQg@mail.gmail.com>
 <20200702160242.GA91667@carbon.dhcp.thefacebook.com>
In-Reply-To: <20200702160242.GA91667@carbon.dhcp.thefacebook.com>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Thu, 2 Jul 2020 12:24:45 -0400
Message-ID: <CAMdYzYp_ooh4rsDsWWx1HS_LdgHm+FWxt=3GUA4_aRp88X42eQ@mail.gmail.com>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Roman Gushchin <guro@fb.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Zefan Li <lizefan@huawei.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 12:03 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Wed, Jul 01, 2020 at 09:48:48PM -0700, Cong Wang wrote:
> > On Tue, Jun 30, 2020 at 3:48 PM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > Btw if we want to backport the problem but can't blame a specific commit,
> > > we can always use something like "Cc: <stable@vger.kernel.org>    [3.1+]".
> >
> > Sure, but if we don't know which is the right commit to blame, then how
> > do we know which stable version should the patch target? :)
> >
> > I am open to all options here, including not backporting to stable at all.
>
> It seems to be that the issue was there from bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup"),
> so I'd go with it. Otherwise we can go with 5.4+, as I understand before that it was
> hard to reproduce it.
>
> Thanks!

Just wanted to let you know, this patch has been running for ~36 hours
or so without a crash.
So:
Tested-by: Peter Geis <pgwipeout@gmail.com>
