Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C83749F474
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 08:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242746AbiA1Hfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 02:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbiA1Hfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 02:35:42 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEABC061714;
        Thu, 27 Jan 2022 23:35:41 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id w25so7207957edt.7;
        Thu, 27 Jan 2022 23:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BnufEEmkIUDP5e9fBWHGjnpSrvFgxcU5p60BJF+NL0U=;
        b=Tf1f5/gi66t5ELzhAgRq42rBE0aij8GGNVpROmjOaODvorPu9AdbDdwTkdZ6Og4FgF
         H0x2JeDGNcmQizN0INe4G7KoVQunNX6Mz4L5x4tiJqOvbXlmhIwy2mIbELUXP+rCUdDz
         LYbQPt8WGYul+V+ZUO8qkFByZtFMHZ29tSHpyaVeai1yhEe8x8SqYQXUB0BmXDMMSxTo
         5MS+Fg8BQh7Img0b5q2uCEqqbTPeVrpM/0zrUEuoyLt8SYUcc40NZGRwtKxH6Bscwt1a
         hiu9MZad8nijGwDpEbdDWI5HLBcGvLNpFys/w6bVSkM2ggpJGTwEsWAsImbq5+DVQC/h
         1q5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BnufEEmkIUDP5e9fBWHGjnpSrvFgxcU5p60BJF+NL0U=;
        b=f3P1NIPTACxckunwy6G2cqInUNpqKDtPHpDg3/Yqp+R+Y7wk2sjhLQBU0aGqb2oCow
         R+jDR/fC+eayQk9RyiW6zXZd6SJbe/sJbYohlD384Yw13lxUBgvSzzUzSsI2riSh7Wnz
         5v61GSBf0BlyugnVq6W+ZWYdJPEMowOWcI0odW4HC4JhkFDD1CrHilA8eI4dCLnTqS9E
         B8CrH5ttoc5VzseEHwoSauV8JbYRpDFqN57hCkc4Vp5h8lySlN3KefOAqhl4xTYSo64s
         yxhFZhrKEdCzLUFVX733Dl1QShoNpz+0fweaW3rP3QyGmglhZlTgIdU3v5UT8HsAjeQc
         dYFA==
X-Gm-Message-State: AOAM531m2L8iprj6QCpmxtUmtKX+JCQSrmIs7pzrER6U/VIXoCV23T+8
        UuTplBNET9Zk8AlATHaUvNbasnD9u92mokxkqjU=
X-Google-Smtp-Source: ABdhPJw9iG+h6ZE7nDhbsSSoboe3FSp4c1TzA4JQ4VCXVNXZRdv7+jeKYCuxHyU70zleTwTE+EcwHBh3hI4mm/klufY=
X-Received: by 2002:aa7:d1cd:: with SMTP id g13mr6977950edp.70.1643355340180;
 Thu, 27 Jan 2022 23:35:40 -0800 (PST)
MIME-Version: 1.0
References: <20220127091308.91401-1-imagedong@tencent.com> <20220127091308.91401-2-imagedong@tencent.com>
 <2512e358-f4d8-f85e-2a82-fbd5a97d1c2f@gmail.com> <20220127084220.05c86ef5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220127084220.05c86ef5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 28 Jan 2022 15:31:09 +0800
Message-ID: <CADxym3ZuHRifkmMbnyDrKhpDKPqD7tVUgJ2OrnU6DOB_aw88wA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 1/8] net: socket: intrudoce SKB_DROP_REASON_SOCKET_FILTER
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>, pablo@netfilter.org,
        kadlec@netfilter.org, Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>, alobakin@pm.me,
        Paolo Abeni <pabeni@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>, talalahmad@google.com,
        haokexin@gmail.com, Kees Cook <keescook@chromium.org>,
        memxor@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Mengen Sun <mengensun@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 12:42 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 27 Jan 2022 08:37:06 -0700 David Ahern wrote:
> > On 1/27/22 2:13 AM, menglong8.dong@gmail.com wrote:
> > > From: Menglong Dong <imagedong@tencent.com>
> > >
> > > Introduce SKB_DROP_REASON_SOCKET_FILTER, which is used as the reason
> > > of skb drop out of socket filter. Meanwhile, replace
> > > SKB_DROP_REASON_TCP_FILTER with it.
>
> > > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > > index bf11e1fbd69b..8a636e678902 100644
> > > --- a/include/linux/skbuff.h
> > > +++ b/include/linux/skbuff.h
> > > @@ -318,7 +318,7 @@ enum skb_drop_reason {
> > >     SKB_DROP_REASON_NO_SOCKET,
> > >     SKB_DROP_REASON_PKT_TOO_SMALL,
> > >     SKB_DROP_REASON_TCP_CSUM,
> > > -   SKB_DROP_REASON_TCP_FILTER,
> > > +   SKB_DROP_REASON_SOCKET_FILTER,
> > >     SKB_DROP_REASON_UDP_CSUM,
> > >     SKB_DROP_REASON_MAX,
> >
> > This should go to net, not net-next.
>
> Let me make an exception and apply this patch out of the series
> to avoid a conflict / week long wait for another merge.

Thank you! I'll send v3 of this series patches without this one.
