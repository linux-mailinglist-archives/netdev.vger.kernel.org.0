Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3EF201FFD
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 05:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732251AbgFTDAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 23:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732074AbgFTDAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 23:00:55 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBDEC06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 20:00:53 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id i4so10497894iov.11
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 20:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mSXKjlPFEPPbuZ3ktrTAgLZs6zP8T98sUcJLvU/GK6I=;
        b=u04eFMz7cbp80d/rfBlHcroOXzPC7iYfrJRAtupT6TBETFh1vcKvBQ3p/8vtgI99Lm
         gZBPYr2O1dVdBDQcL8W4Pv3Kv5Bl9L9IchLpVbpD/yCrG7sMs3l7Ud0O29+jMgr0okIC
         1XS4tc2msPKIfyvdxTvNoB/4/AbZh0zgyz1CEepNQJ1xk/N30AGrYrFiWFs4Ifx3P5ls
         PMCC4EPhvCpxepIKOuDMUkelDZ0A389aQG79g0n4N2rRfaP5EDOwE1HUTotK3OSlxxOX
         Gs/1WXOw+7QYwaJy9+u0qFFa/z07rqtMBpgo3Qt2TBzpA5fWYDGXcSuB+Zyp+fTTM/CT
         JL+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mSXKjlPFEPPbuZ3ktrTAgLZs6zP8T98sUcJLvU/GK6I=;
        b=ZLkJh52zbMgggzYh7dTAv8R0OYepfvOTQr32opxnZUr0hz3E/9BAK7YUmlvcij88ja
         ATly4ONAgmvqNoUGQqbSrd/CNWLGfq+Tdiz1iX/MtCbWESjlNNQAaEpjXBYOzb6c/gUI
         M3cdKha1E36LlNhZ7TdQecPLpI6Y8Xyu9F6EpbvnRh7+IaOxajMTtI53z0TkoaWaKkJ7
         nAL43jEsXJuoK8MPcONh+drO5+MxwxX0dvm61VNdJzgEso/EcC58WaAgGFR7z9MaYi4G
         gYIMwd6WLBi1+aHsTV4aJKHHH+tRfBZRfISaC84ZOTMnYp8/QUErT1sbg2DZohhJIwi4
         mDNg==
X-Gm-Message-State: AOAM533cOFWtofkzWmiX26sIgu0jIRNDoCGv5qIIjToJ0Yi36YdyXVT/
        tGRHXhfAq8sd48WqBfwMf6ms5vgNowofzivppUw=
X-Google-Smtp-Source: ABdhPJxVDtmROngjgLGPUeZ/S/uoAHbu2UfF0ZoubSIudKdGXW2wrNSpOUcB8SzO4UIB2jrEjO1bW0VBAcyvucum4Ss=
X-Received: by 2002:a5d:9819:: with SMTP id a25mr7221081iol.85.1592622052879;
 Fri, 19 Jun 2020 20:00:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
 <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com> <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com> <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com> <20200620005115.GE237539@carbon.dhcp.thefacebook.com>
 <f80878fe-bf2d-605a-50e4-bda97a1390c2@huawei.com> <20200620011409.GG237539@carbon.dhcp.thefacebook.com>
In-Reply-To: <20200620011409.GG237539@carbon.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 19 Jun 2020 20:00:41 -0700
Message-ID: <CAM_iQpUmajKqeYW9uwtEiFeZGz=q7DFYQT5sq_27yaqoudewuQ@mail.gmail.com>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Roman Gushchin <guro@fb.com>
Cc:     Zefan Li <lizefan@huawei.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cameron Berkenpas <cam@neo-zeon.de>,
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

On Fri, Jun 19, 2020 at 6:14 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Sat, Jun 20, 2020 at 09:00:40AM +0800, Zefan Li wrote:
> > I think so, though I'm not familiar with the bfp cgroup code.
> >
> > > If so, we might wanna fix it in a different way,
> > > just checking if (!(css->flags & CSS_NO_REF)) in cgroup_bpf_put()
> > > like in cgroup_put(). It feels more reliable to me.
> > >
> >
> > Yeah I also have this idea in my mind.
>
> I wonder if the following patch will fix the issue?

Interesting, AFAIU, this refcnt is for bpf programs attached
to the cgroup. By this suggestion, do you mean the root
cgroup does not need to refcnt the bpf programs attached
to it? This seems odd, as I don't see how root is different
from others in terms of bpf programs which can be attached
and detached in the same way.

I certainly understand the root cgroup is never gone, but this
does not mean the bpf programs attached to it too.

What am I missing?

Thanks.
