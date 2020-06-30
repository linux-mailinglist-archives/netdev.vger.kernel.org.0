Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E936210003
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 00:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgF3WWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 18:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgF3WWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 18:22:46 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BBFC03E979
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 15:22:46 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id i25so22891690iog.0
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 15:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xB0Br0JyKgL2Z3Eg66kuCiZe8XAzg3Ju64hrrs0TqDo=;
        b=iRhHIBpQMDu2Z1UnGsiLNTtgvog7P6HpOOo97rRipmrU2j6wW3e9l93eRcvgORCAmw
         2h2++TGR8lHFv/FJeyA69mteeuF9Sf1EB6LADRy4FaX8gMX+oHdMonO6QbNbh/VD19LK
         NarowRTRxwo/JQ9AOQLd8ZARBFLt3VSM9HKOx82Z0hT2q4jBBrtJPWoNxus6E1yWSw22
         NpD3nvKtNvnMd81vscjP+allw0WTsnwkKNgwehphZ1EmLMTvQtQpigpTmAbjecmi9XrB
         6aHCyk+byhWuoSgI2kZCl1kEXhD74RKF2r+vrjEBw2/q/4IUAVPbjcNM9cPsDs5jIlWE
         3e3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xB0Br0JyKgL2Z3Eg66kuCiZe8XAzg3Ju64hrrs0TqDo=;
        b=fSkVW7+d2zEJ+5nbV1O21a58DhPIf9Np0QM5MQ4vRFWfkuGX45TmWfnyfSvbehx+uH
         7BT4P/qn+NxyffHzzIq+HHAiC6/wXTLtY6HzSnY4Obj4jgFMkaGIqErc722UtGO0r/n5
         Dl4xN+Uibo/uynCjUUGje1pSHGBe+38xkbzfMPuWko8Qi+pG5Ccx+2n47YYEOHMPK/pY
         MpFQ13iLkKqZNJF8zK5CVx5D3ZgksnrOTFpGaMxxrllFVdYXEqI45emC/zXsMASOvgO/
         qN0UA6ioulWn6XIEwrA7Q3OVY+moXELXURCjG7Z8p9I3jsCnOlEuWK7vJXOt4gWCWUfe
         j8Kg==
X-Gm-Message-State: AOAM5315+CDOlFq9QXLXttxvfEyorEGkKAnjUiWFg8gsgu/eGItO1CgE
        5KBD/NAsywU7oUu+ziMGa9FFlMBEjvTujAErjno=
X-Google-Smtp-Source: ABdhPJxQqOIQEqy0t6zgdBDzJNL8eA1MrydwXSFKYn2Nt13w7Lcf8VElQ8SZIamqnGoUEp9uQIJij+Jq8g0DCEoac/I=
X-Received: by 2002:a05:6602:1225:: with SMTP id z5mr24052710iot.64.1593555765488;
 Tue, 30 Jun 2020 15:22:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200618193611.GE24694@carbon.DHCP.thefacebook.com>
 <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com> <CAM_iQpVKqFi00ohqPARxaDw2UN1m6CtjqsmBAP-pcK0GT2p_fQ@mail.gmail.com>
 <459be87d-0272-9ea9-839a-823b01e354b6@huawei.com> <35480172-c77e-fb67-7559-04576f375ea6@huawei.com>
 <CAM_iQpXpZd6ZaQyQifWOHSnqgAgdu1qP+fF_Na7rQ_H1vQ6eig@mail.gmail.com>
 <20200623222137.GA358561@carbon.lan> <b3a5298d-3c4e-ba51-7045-9643c3986054@neo-zeon.de>
 <CAM_iQpU1ji2x9Pgb6Xs7Kqoh3mmFRN3R9GKf5QoVUv82mZb8hg@mail.gmail.com> <20200627234127.GA36944@carbon.DHCP.thefacebook.com>
In-Reply-To: <20200627234127.GA36944@carbon.DHCP.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 30 Jun 2020 15:22:34 -0700
Message-ID: <CAM_iQpWk4x7U_ci1WTf6BG=E3yYETBUk0yxMNSz6GuWFXfhhJw@mail.gmail.com>
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

On Sat, Jun 27, 2020 at 4:41 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Fri, Jun 26, 2020 at 10:58:14AM -0700, Cong Wang wrote:
> > On Thu, Jun 25, 2020 at 10:23 PM Cameron Berkenpas <cam@neo-zeon.de> wrote:
> > >
> > > Hello,
> > >
> > > Somewhere along the way I got the impression that it generally takes
> > > those affected hours before their systems lock up. I'm (generally) able
> > > to reproduce this issue much faster than that. Regardless, I can help test.
> > >
> > > Are there any patches that need testing or is this all still pending
> > > discussion around the  best way to resolve the issue?
> >
> > Yes. I come up with a (hopefully) much better patch in the attachment.
> > Can you help to test it? You need to unapply the previous patch before
> > applying this one.
> >
> > (Just in case of any confusion: I still believe we should check NULL on
> > top of this refcnt fix. But it should be a separate patch.)
> >
> > Thank you!
>
> Not opposing the patch, but the Fixes tag is still confusing me.
> Do we have an explanation for what's wrong with 4bfc0bb2c60e?
>
> It looks like we have cgroup_bpf_get()/put() exactly where we have
> cgroup_get()/put(), so it would be nice to understand what's different
> if the problem is bpf-related.

Hmm, I think it is Zefan who believes cgroup refcnt is fine, the bug
is just in cgroup bpf refcnt, in our previous discussion.

Although I agree cgroup refcnt is buggy too, it may not necessarily
cause any real problem, otherwise we would receive bug report
much earlier than just recently, right?

If the Fixes tag is confusing, I can certainly remove it, but this also
means the patch will not be backported to stable. I am fine either
way, this crash is only reported after Zefan's recent change anyway.

Thanks.
