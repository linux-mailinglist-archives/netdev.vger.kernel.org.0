Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66E13C4341
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 06:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhGLEoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 00:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbhGLEoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 00:44:18 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB8AC0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 21:41:30 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id c17so31885238ejk.13
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 21:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=52e+/fI6t8mIVBJ5EZ438QT9rSLYz1ISptpqssjWCl4=;
        b=MztHSeFNCCcL3w9ykzfB4AC7FTaUhOLI6TKWUfVYOc1uPtleKwCkPu6J3NxiJ8WkOX
         IhuxPUwiLG7UGGCikRlt6anpvN0QL4yx76MW5+7Q+vt8D2egIYkk2ns9VwLm2xCms/r+
         XyCJRkUxuSreyd+818ThG6gTyF9xIJLoaLreyfyVO5/IsT6yAZasa81M9uvziYsWj6ZO
         W+aZe09e7Snjel+hdpzWx7AMD+zQa3lTHuNsQPJg97ht8Gv2En8S7U+KZSPajdn474pB
         vavF4rk4eCF2AE4OM6dEvp8ziVe0IttN8RztDfhTZ0Ef2tPhzLM5rvfzD2rnWN4KLsO8
         4W4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=52e+/fI6t8mIVBJ5EZ438QT9rSLYz1ISptpqssjWCl4=;
        b=iGgM63jnl63TYp4MOr8nsWfbk+3HMUKwmYu4H9K90d4HwgSrWskyZbFH5zKOV7IMsP
         CmdDtrMftFa13dHB2iO6MCplghOkv3N43X4jnRoMIjkc9tlYBr1l0gY8Jx+qMUrlH5Ic
         trPaSsH+DW2uR6PugUxXTVX0BHUXuUh6ItcnjbuZF0EYFbou8b1zvqFWNh86TxstuZPl
         zb1nm+FSnHFkoCG23lJKPSZwefr0HkEOb0pb1aOlGMAH6AgV3VPLjGafapO+iI7ff8lx
         gkAf2ciZulHVOIlLrIQgcRA/O0kMT8cVFowaADJdyVLJ0lixUC0jrE/PkJgPbK2VBg4L
         wpYA==
X-Gm-Message-State: AOAM532KKEdJUpqhyFlatltGcEDLEtHtVOsRpWCgrTDVtOBdkszmuj5m
        y7xMp067XZtWBKVUQ8g9Xo148Li0NYej++jKA0g=
X-Google-Smtp-Source: ABdhPJyHRCJww2ZhTKo30tuhaR1xS0fgR5JvVnqdR4UOBlKfJCiG2vWmCDY90ZQXaNql5uLCp56sAdIUIyt/3LmKJRU=
X-Received: by 2002:a17:907:1c1c:: with SMTP id nc28mr9149118ejc.115.1626064889604;
 Sun, 11 Jul 2021 21:41:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210711190308.8476-1-xiyou.wangcong@gmail.com>
 <CAMDZJNWWq2TGb6-nZRbBNfLevOyD2oSn941Nw_+7q0QzVep_GA@mail.gmail.com>
 <CAM_iQpUmO8S-7cgG=yy2TsNoc9nHpW__-WCfhcfV-_eAf46K7A@mail.gmail.com>
 <CAMDZJNXbwzXrHX1UT+DLsJvbKPh70-OPyrkTV=D05a5Mwcko3w@mail.gmail.com>
 <CAM_iQpUG28PBhXmqQeEzcWq8cNLFH1BzXaZ1FWGu1jqObGfdwg@mail.gmail.com>
 <CAMDZJNV9tbGE0Y1nZgMcp2Z5LU5Cb7YfJ+mS9rVogrin8SGxjQ@mail.gmail.com>
 <CAM_iQpVAuF0Pq1qmKRWoOvBPPMSaf1seKykEwYvVhm0tRkNo4A@mail.gmail.com>
 <CAMDZJNW5F3MDPYaRhx1o1ifPXQPnW_fdML=ap+Gis2PG9FB9Pg@mail.gmail.com>
 <CAM_iQpWHvY1h-xdUxWk+PhQcMRqSmnDpzxvBLXKh1mARYzQfmg@mail.gmail.com>
 <CAMDZJNUMXFYJ9_UdWnv8j74fJZ4T6psdxMvbmRBzTAJuZBeQAA@mail.gmail.com> <CAM_iQpXhC6Jj+KE-L8UTyasTgVDyLDPS4rbXau2MVzwH41N-7g@mail.gmail.com>
In-Reply-To: <CAM_iQpXhC6Jj+KE-L8UTyasTgVDyLDPS4rbXau2MVzwH41N-7g@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 12 Jul 2021 12:40:53 +0800
Message-ID: <CAMDZJNXzPum_1_GkW+w28QgVhcMvq3rz=OOEE5XbdDfTYvCTAw@mail.gmail.com>
Subject: Re: [Patch net-next v2] net_sched: introduce tracepoint trace_qdisc_enqueue()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 12:20 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sun, Jul 11, 2021 at 9:12 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Mon, Jul 12, 2021 at 12:02 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Sun, Jul 11, 2021 at 8:49 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > >
> > > > On Mon, Jul 12, 2021 at 11:39 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > On Sun, Jul 11, 2021 at 8:36 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, Jul 12, 2021 at 11:23 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > > > Sure, in that case a different packet is dropped, once again you
> > > > > > > can trace it with kfree_skb() if you want. What's the problem?
> > > > > > It's ok, but we can make it better. Yunsheng Lin may have explained why?
> > > > >
> > > > > Why it is better to trace dropped packets both in enqueue and in kfree_skb()?
> > > > I mean we can use one tracepoint to know what happened in the queue,
> > > > not necessary to trace enqueue and  kfree_skb()
> > >
> > > This is wrong, packets can be dropped for other reasons too, tracing
> > no matter where the packet is dropped, we should allow user to know
> > whether dropped in the enqueue.  and the
> > what the return value.
>
> Again you can know it by kfree_skb(). And you can not avoid
> kfree_skb() no matter how you change enqueue. So, I don't see your
No, If I know what value returned for specified qdisc , I can know
what happened, not necessarily kfree_skb()
> argument of saving kfree_skb() makes any sense here.
>
> Thanks.



-- 
Best regards, Tonghao
