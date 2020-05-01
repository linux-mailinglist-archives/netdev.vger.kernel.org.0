Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CF91C0B7C
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 03:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgEABJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 21:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727124AbgEABJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 21:09:37 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92874C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 18:09:37 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id m18so1398830otq.9
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 18:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DcFZIklJvf3UHohSgALWH2bDZDBbBKFddxDwgLgTTJ0=;
        b=qEjU1rPBnRFZAzrOQaKLy2qqpUzkcfh6dP6nYSBRnfxlIBLfD+oeSot6ghZ6m574ip
         VaaMHLpdstCBqSL51y+s4j5Ebl46WQ8bCyerZVz7IvUCA8DXKwZnWXwG2wNzakILTcUx
         6YeFvKk/ougqlKIQmnCUV+iZtg1b5wNTjBKTQcyzk/nPHhwaTacGiREGDlSbG89N6ept
         0fPxDM1qHrU9XNuYAPyiVgjxt8wZV395YV0tAFaEF7o5h+Gs6ZZZ31ZidM+1bFWPCanz
         1cLIuk2CyXff1fwGHZcepZkFBs+cxz4ZSbTJQXYNwg4cXg9aR6T+jQYUyt3yGmxUvjUY
         ymTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DcFZIklJvf3UHohSgALWH2bDZDBbBKFddxDwgLgTTJ0=;
        b=b7Tzd0X8eFOrhQQZ6eBPk7DiKivqMrCyjiyETQhphtYivZ0MXNaTxNieuqWZ5bZ5NF
         OzGTipwxhwsjlDiIQFp4GB9shPocBJ15fYPwMNsjFSe3RNngcv4LQuhsvI6gCxoR691J
         3ugz8fxWj6+99ZdQaZIqAf9ohO2L13G83JA5BUYamnXPq5wEuoG73aXXRJSo+fUrTYLo
         Yt0h6nWKbnOI6qVyB1dkrrMuxzcCzeBHoWxj+FPp6HVwc+OmlYSUE2wDjxN7/kDn6lp7
         h1hOUmTkuZ2V0pmKV2PlgMLDUL6uJSp6y1N8dckSkS+gQvBdFFw1dOYBAAkQBt3KRDUu
         pNuA==
X-Gm-Message-State: AGi0Pub840vaovrj6M2hXiXmgRQi5smq8BNtPlKBjl5IURYfa2dkiphz
        goXft4wpJWO52hId47mdDS8CAIm1CpJE5ELtaKZvSfQW
X-Google-Smtp-Source: APiQypJrpsTutaW9GHUJSsVqu1g8jqXmlXcNJSlHw/O7PrA/FlVsXoNr6kxbF1C9EAZTNU8kXZsSqb/08rKkt8sk3dg=
X-Received: by 2002:a9d:107:: with SMTP id 7mr1819995otu.48.1588295376762;
 Thu, 30 Apr 2020 18:09:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200501010248.21269-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20200501010248.21269-1-xiyou.wangcong@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 30 Apr 2020 18:09:25 -0700
Message-ID: <CAM_iQpUyh6BMTWAKNV3=TAQwRfj0M3TVatELvn32njSE6Y8DSg@mail.gmail.com>
Subject: Re: [Patch net] net_sched: fix tcm_parent in tc filter dump
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 6:02 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 55bd1429678f..80e93c96d2b2 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -2612,12 +2612,10 @@ static int tc_dump_tfilter(struct sk_buff *skb, struct netlink_callback *cb)
>                         return skb->len;
>
>                 parent = tcm->tcm_parent;
> -               if (!parent) {
> +               if (!parent)
>                         q = dev->qdisc;
> -                       parent = q->handle;
> -               } else {
> +               else
>                         q = qdisc_lookup(dev, TC_H_MAJ(tcm->tcm_parent));
> -               }
>                 if (!q)
>                         goto out;
>                 cops = q->ops->cl_ops;
> @@ -2633,6 +2631,7 @@ static int tc_dump_tfilter(struct sk_buff *skb, struct netlink_callback *cb)
>                 block = cops->tcf_block(q, cl, NULL);
>                 if (!block)
>                         goto out;
> +               parent = block->q->handle;

Hmm, block->q could be NULL, I think I should just use q->handle
here.
