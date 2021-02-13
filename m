Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E18431A98E
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhBMB7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhBMB7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 20:59:00 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10346C061574;
        Fri, 12 Feb 2021 17:58:15 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id fa16so604971pjb.1;
        Fri, 12 Feb 2021 17:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KErMRR3I5uhgWEjnDaX5OIYebSwYMq6MDxuhVUaC/h8=;
        b=N37IdC0jsSvkFeSOJtd1gKzt1fkilAV6WQvQiLG8X+9sw7isRwCQW+OyLyAa57jwN8
         foTEqAe7tmSmbT4V+OWCyWes4pgcQvBV6H+1bJ1jWcTVzje8o03zzgsYP3O8qE+yyPq6
         fvnI/q4ERC4Rz7uNCv67E5qqX/BbW+0k6wp7UGD1NE07avW3ZzpJPlh12QyfbpgDjm17
         FWJJBVJEwgS4N0qnlmdHEtbCa4y/mCq3XFexyUSnpuHhkxlYD2mIyVHvzDd0khyi34x1
         ncFsfkbxtBEsNFTHGhsmCW/fkzEuZi2UOv+U4VbX2extePGr+Mlm6hF3nZ3ccDFuvBGx
         R8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KErMRR3I5uhgWEjnDaX5OIYebSwYMq6MDxuhVUaC/h8=;
        b=WpJzV4s50vHa2/9eRNKZ8VWBb6ZfmH9y79Zugzr0NapSt9NJVRqGyTpP5B+tNqnNKM
         m+Y4Yqjkl7lyuJrNz5c1THV+rEVpYf8ZOO1JsN1SejI/H/zf+x8XCeacXmL5StFqP5/S
         7p5t1t7bt8pfOZqK/uEMn7FAYxyGAdlZ/LooDGiGj+RnmLZT/NDM4u60UlxeybrhZNhF
         GUcMWO7c4cmC7atUKbG0/BcWAY+XM5j+7E3QKsOKk00xHI/vBpLMBoNcMN3VOE3R0AH+
         TM9AYEtZ+iyCKjEN36O0L2/cWLfvePnoDeyX7U3Xh9+Cfomzte5ar++iLjHU/9sN9j6I
         GLhQ==
X-Gm-Message-State: AOAM533tdBQJHC6i+O+tXkhgXiSIA7XPBJI4xG2geoN37NHlj0R4B2rX
        PFNd7dHfJueEuaH7YAR3+LjAzsDIM33b2skU3Mk=
X-Google-Smtp-Source: ABdhPJwsDe9AQYOLJrUdtwlcgLJFy5E+h3Y85TIZ+w6sK1srJStzBTkyFjfLStk860zQ/vzBQbDgb+EvxMvakkd2ulE=
X-Received: by 2002:a17:903:114:b029:e2:f8fb:b6a1 with SMTP id
 y20-20020a1709030114b02900e2f8fbb6a1mr5073239plc.77.1613181494523; Fri, 12
 Feb 2021 17:58:14 -0800 (PST)
MIME-Version: 1.0
References: <20210210022136.146528-1-xiyou.wangcong@gmail.com>
 <20210210022136.146528-3-xiyou.wangcong@gmail.com> <CACAyw98HxkT99rA-PDSGqOyRgSxGoye_LQqR2FmK8M3KwgY+JQ@mail.gmail.com>
 <CAM_iQpUvaFry3Pj+tWoM9npMrARfQ=O=tmg7SkwC+m54G0T6Yg@mail.gmail.com>
In-Reply-To: <CAM_iQpUvaFry3Pj+tWoM9npMrARfQ=O=tmg7SkwC+m54G0T6Yg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 12 Feb 2021 17:58:03 -0800
Message-ID: <CAM_iQpUkNA0D8vokqvjLgH3bv6vkKvNoz4Jg149dDnDjFH+qCA@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/5] skmsg: get rid of struct sk_psock_parser
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 11:09 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Fri, Feb 12, 2021 at 2:56 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > On Wed, 10 Feb 2021 at 02:21, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > struct sk_psock_parser is embedded in sk_psock, it is
> > > unnecessary as skb verdict also uses ->saved_data_ready.
> > > We can simply fold these fields into sk_psock, and get rid
> > > of ->enabled.
> >
> > Looks nice, can you use sk_psock_strp_enabled() more? There are a
> > couple places in sock_map.c which test psock->saved_data_ready
> > directly.
>
> Its name tells it is for stream parser, so not suitable for others.
>
> Are you suggesting to rename it to sk_psock_enabled() and use
> it? Note it still has an additional !psock test, but I think that is fine
> for slow paths.

Well, I think it is a bug, sk_psock_strp_enabled() probably means
to check whether progs.stream_verdict is running, not whether
any of these progs is running. So, I'd leave this untouched in this
patchset and if needed a separate bug fix should be sent to -net.

Thanks.
