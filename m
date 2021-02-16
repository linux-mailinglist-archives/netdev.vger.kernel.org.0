Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4922E31C498
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 01:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBPA27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 19:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhBPA2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 19:28:55 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C77C061574;
        Mon, 15 Feb 2021 16:28:14 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id r2so4568487plr.10;
        Mon, 15 Feb 2021 16:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EfJMDhxC2JDO2cfLgWN0mUNWvycHxcL6WVpnHJwl1yM=;
        b=eEtMDGXoiB6IBT5yd2mVS/f0RmZvlVn3p7wEUhdQeP8s8CPg2kqOro/lE+lZz1ytGf
         BuTO7YIkrDOMK9svJrOKL92Cp9GuAFyo7tS5T8fg//4qk8bKtqRvFZ31RBW/DWKui3yy
         RHrjMdufbSl7wSJ9sUyaRQ2s6J86bDilHORIeVfN+aWgFW1uuKjXxNf07ZKM3lNFnmhS
         PH4LiugqmFsOn1oQUwLi0A7bLoL9h93fr5ZlSLcySsYFuzd+0o5LX4hcvHCHcLR6fFYP
         aUJQBB9Iy944WUNpSJs4u1drFF6MEwYBmwH3y69KNtiI7jHUrEtXkhEmQOrFpPTM0wZS
         v65g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EfJMDhxC2JDO2cfLgWN0mUNWvycHxcL6WVpnHJwl1yM=;
        b=dH8iBwjZufs1fGv67eyQqHDsaMtXFu8B0q3JqII5PMUMU5duReTIoxb/0pJT0HMui+
         /onYxdSUz0SXtr3oDIZzFIla9bZ0+labSBkSTbAHYqUliJWMmE2EWF2ede3pVil5VHL0
         PXfCSnf6Eh3lfIU0tSvN38phQmL00sQKeqZezbRs3ZAQ8kmexuykCtkg22R1I+xaZt+P
         LiFKmeCWZBc52A7qgJO/VWRPa2KfrmLOlhfzG0fFgSEH1r2Y6aWGqAfMuYJc3MQsUJP0
         iKs7SVfOqWz9gFphSmqM7G274INIYDxY1V+jl4kT7B2uMc5bMjXgsWwk+EONEq25W6zO
         tYPQ==
X-Gm-Message-State: AOAM533e8yAqndGLHtbdEEe05T9sqKd5SS6sShHQxy+1eWZ3DvvAi07R
        MZWTBVViwLm4pdbKMNRvFqcGH/y9KfMfTdijr2c=
X-Google-Smtp-Source: ABdhPJzH83YUFhNv2LTc/HxVEx7I5oOdu/rqC2gmouTGRGlGfmtS0eAfMCir6jAMpKHWVyQcvMr3cQ5dRZe+qOMnNQo=
X-Received: by 2002:a17:90a:af92:: with SMTP id w18mr1318558pjq.191.1613435294380;
 Mon, 15 Feb 2021 16:28:14 -0800 (PST)
MIME-Version: 1.0
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
 <20210213214421.226357-5-xiyou.wangcong@gmail.com> <602ac96f9e30f_3ed41208b6@john-XPS-13-9370.notmuch>
 <CAM_iQpWufy-YnQnBf_kk_otLaTikK8YxkhgjHh_eiu8MA=0Raw@mail.gmail.com> <602b0a7046969_3ed41208dc@john-XPS-13-9370.notmuch>
In-Reply-To: <602b0a7046969_3ed41208dc@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 15 Feb 2021 16:28:03 -0800
Message-ID: <CAM_iQpUomzGXdyjdCU8Ox-JZgQc=iZPZqs1UjRo3wxomf67_+A@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 4/5] skmsg: use skb ext instead of TCP_SKB_CB
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 3:57 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> For TCP case we can continue to use CB and not pay the price. For UDP
> and AF_UNIX we can do the extra alloc.

I see your point, but specializing TCP case does not give much benefit
here, the skmsg code would have to check skb->protocol etc. to decide
whether to use TCP_SKB_CB() or skb_ext:

if (skb->protocol == ...)
  TCP_SKB_CB(skb) = ...;
else
  ext = skb_ext_find(skb);

which looks ugly to me. And I doubt skb->protocol alone is sufficient to
distinguish TCP, so we may end up having more checks above.

So do you really want to trade code readability with an extra alloc?

>
> The use in tcf_classify_ingress is a miss case so not the common path. If
> it is/was in the common path I would suggest we rip it out.
>

Excellent point, what about nf_bridge_unshare()? It is a common path
for bridge netfilter, which is also probably why skb ext was introduced
(IIRC). secpath_set() seems on a common path for XFRM too.

Are you suggesting to remove them all? ;)

Thanks.
