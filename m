Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8995E3C42DA
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 06:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbhGLEW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 00:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbhGLEW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 00:22:56 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BF3C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 21:20:07 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id d9-20020a17090ae289b0290172f971883bso11392321pjz.1
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 21:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l2okPCwgzbHE2HeawmqTithwVPMkeqeSAMOMA4qOjIY=;
        b=tP0uj1h6pdr60DEbcBVD+BNJlLGZKNBJSqzXGat6z/m9MSxMt25J0wUxQy59H8CjKn
         90kgSjTZUR5LvSAkocd9koyu5adcsX4diJC/k5wJOtcZMZQPlIBMjZA+aXtuIl323+sQ
         aIEi5csT8xhETneQ85yPj9owMPYyWznxRtZmSWZa0iXYTQMRQdOjd1FwMLNzRCzHTkNN
         fdnaYN6u/iTJs1ivcxCnDcd53J1ZkJek49wkJAB4L5pRT4BKCnNu/WwDFNun+PtB8Cau
         b0lteFrUixeQGRn3x5Yvk/Z3oj9v2/S7zcsTOuQVbqYxJGmfsLQ6xzPibT4BttGTXW8h
         iy/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l2okPCwgzbHE2HeawmqTithwVPMkeqeSAMOMA4qOjIY=;
        b=RPDtWmZ9werjV/ty+n8qn/BtpecTUbUxwFmVLWXaa47Y+kg5G0Ypk6d4x4lP4tmoU5
         mMOQQ/UfxgzrPjOAtOUVYGfNUWmxcRpU4dn92gLm53zBzRrOEh2iVi1151HZyeHSjSKP
         L5kaoEZUgeZJ69lvZrxzVbcB376ueLrubEbeVbG/SZVcIp/gT9jjTPAW8ZfD5/rSiWNd
         6sdW7GmNs/dxJ8nyyZ8KSbT3BGT3AXFKeGLJal+A2kwC1f9VEBAhGLV/Dn8gO7O8rI9L
         RYOfry7BoLVUcC6Xvr33jms7Jq5cteJpjC/nA8CnMfVEBtDqk3Yud2fb/1fabTv5ybyh
         RkYg==
X-Gm-Message-State: AOAM532HWhokh6NskPWgjjulclkWIYhmHNw+OlvZDBJvgBJ51hTI29TK
        YoVYdpGcrf3s7Ox9rIz7DuefmfgRI2YSsHU6vAM=
X-Google-Smtp-Source: ABdhPJwgKNhIgdc7WbOl0gcUQxV5YAMWFQ/4Ld/Ng/jrOIJgj88nyIc7OJSJwlJ5Sm3vOWqtSD3C8u261UyLTIJFoxI=
X-Received: by 2002:a17:903:3015:b029:12a:f5ab:e040 with SMTP id
 o21-20020a1709033015b029012af5abe040mr8088815pla.64.1626063607447; Sun, 11
 Jul 2021 21:20:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210711190308.8476-1-xiyou.wangcong@gmail.com>
 <CAMDZJNWWq2TGb6-nZRbBNfLevOyD2oSn941Nw_+7q0QzVep_GA@mail.gmail.com>
 <CAM_iQpUmO8S-7cgG=yy2TsNoc9nHpW__-WCfhcfV-_eAf46K7A@mail.gmail.com>
 <CAMDZJNXbwzXrHX1UT+DLsJvbKPh70-OPyrkTV=D05a5Mwcko3w@mail.gmail.com>
 <CAM_iQpUG28PBhXmqQeEzcWq8cNLFH1BzXaZ1FWGu1jqObGfdwg@mail.gmail.com>
 <CAMDZJNV9tbGE0Y1nZgMcp2Z5LU5Cb7YfJ+mS9rVogrin8SGxjQ@mail.gmail.com>
 <CAM_iQpVAuF0Pq1qmKRWoOvBPPMSaf1seKykEwYvVhm0tRkNo4A@mail.gmail.com>
 <CAMDZJNW5F3MDPYaRhx1o1ifPXQPnW_fdML=ap+Gis2PG9FB9Pg@mail.gmail.com>
 <CAM_iQpWHvY1h-xdUxWk+PhQcMRqSmnDpzxvBLXKh1mARYzQfmg@mail.gmail.com> <CAMDZJNUMXFYJ9_UdWnv8j74fJZ4T6psdxMvbmRBzTAJuZBeQAA@mail.gmail.com>
In-Reply-To: <CAMDZJNUMXFYJ9_UdWnv8j74fJZ4T6psdxMvbmRBzTAJuZBeQAA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 11 Jul 2021 21:19:56 -0700
Message-ID: <CAM_iQpXhC6Jj+KE-L8UTyasTgVDyLDPS4rbXau2MVzwH41N-7g@mail.gmail.com>
Subject: Re: [Patch net-next v2] net_sched: introduce tracepoint trace_qdisc_enqueue()
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 11, 2021 at 9:12 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Mon, Jul 12, 2021 at 12:02 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Sun, Jul 11, 2021 at 8:49 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > On Mon, Jul 12, 2021 at 11:39 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > On Sun, Jul 11, 2021 at 8:36 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > > >
> > > > > On Mon, Jul 12, 2021 at 11:23 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > > Sure, in that case a different packet is dropped, once again you
> > > > > > can trace it with kfree_skb() if you want. What's the problem?
> > > > > It's ok, but we can make it better. Yunsheng Lin may have explained why?
> > > >
> > > > Why it is better to trace dropped packets both in enqueue and in kfree_skb()?
> > > I mean we can use one tracepoint to know what happened in the queue,
> > > not necessary to trace enqueue and  kfree_skb()
> >
> > This is wrong, packets can be dropped for other reasons too, tracing
> no matter where the packet is dropped, we should allow user to know
> whether dropped in the enqueue.  and the
> what the return value.

Again you can know it by kfree_skb(). And you can not avoid
kfree_skb() no matter how you change enqueue. So, I don't see your
argument of saving kfree_skb() makes any sense here.

Thanks.
