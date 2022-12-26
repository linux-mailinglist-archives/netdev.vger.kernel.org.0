Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2548565640D
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 17:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiLZQbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 11:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiLZQbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 11:31:37 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5EE249
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 08:31:36 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id 186so12060023ybe.8
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 08:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tNyU3hi4+YHcw3wvohcr4k63kxaU1hZhqQ2UlHaU9PY=;
        b=VK6yNPHlmxyJcqrIpTlk4pEpd3PmzhVQJCmNa3kGSXURprRwl10Qm+M/op7c6+43K8
         uyz4p05IXcwLOOj4i1CMRW2xHc6ziRg1mVolv39xXkI15fPksxj/BtjRgt5NJWyg8NQ0
         xj5eJSlgATQmr/3OH+hoYX2hjv9UT7x2mxuqv4xoqDqyC91lqnxEZf0cloa31R+qYpua
         QOzttMbaqnUYa95rlbea2wm7leWzia7YKx+gXq5m3kWIJgPtkz15wVE9+R8pHLuWSOeV
         nikFYb+Ncn448PyI/vgpFYfLYfyL8xS9o+YGckCvY38wuE93dzo5WcNdYCZX/lBQuMl7
         eE5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tNyU3hi4+YHcw3wvohcr4k63kxaU1hZhqQ2UlHaU9PY=;
        b=r/47Ta54MOK7h/J9GZUu8ZXg4ffmy1oPQ9GcPpO1T2QGbKpFGQ0tM3ei27NuiPZOW2
         jkCnwAECXgUfVyKZC2F1w5PzWU5B9XT2KL/kd0+4wnAIjG4VLuPj74ahp86RKyRIUT7d
         bqLpea2ENy70CdJYsBNg7HxHbTj1+ZCsoDm4e2rpRURxylbPLgYBWA+fuJgN5ecaiuj8
         ckJI2rkKJqFOV5O1OpBc5/c433WRX7T3THth60G8j3LDw1NPSDFUevKQr8QBBFTFpi4k
         IcUaEQivGI/pEWkhIFbb9+7RWfVSrYgywwBDyq2bW0HSMzeR7DUOH1r5fNptTGiLiAsG
         rgPg==
X-Gm-Message-State: AFqh2kpatIV8yuSUsPfxRdGn0qKnw8fCwJCQ6Zh7Lm0QVw8RO8qpx8Rx
        NQIc4elq04D9o+Q1XcnRLqT/mPy6i0RDe8q3VZRmgd7wZ6nQzEY3
X-Google-Smtp-Source: AMrXdXsu9vmlBSP3ufY3gvzD7gdQE99mOPY/yZQ2uwGwk88t1sT8NTKeGn362L3IaXsY3mwEGD2VBKkhUNFUSDLIryk=
X-Received: by 2002:a25:6e87:0:b0:6dd:702f:c995 with SMTP id
 j129-20020a256e87000000b006dd702fc995mr1584583ybc.204.1672072295268; Mon, 26
 Dec 2022 08:31:35 -0800 (PST)
MIME-Version: 1.0
References: <20221221093940.2086025-1-liuhangbin@gmail.com>
 <20221221172817.0da16ffa@kernel.org> <Y6QLz7pCnle0048z@Laptop-X1>
 <de4920b8-366b-0336-ddc2-46cb40e00dbb@kernel.org> <Y6UUBJQI6tIwn9tH@Laptop-X1>
In-Reply-To: <Y6UUBJQI6tIwn9tH@Laptop-X1>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 26 Dec 2022 11:31:24 -0500
Message-ID: <CAM0EoMndCfTkTBhG4VJKCmZG3c58eLRai71KzHG-FfzyzSwbew@mail.gmail.com>
Subject: Re: [PATCHv2 net-next] sched: multicast sched extack messages
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My only concern is this is not generic enough i.e can other objects
outside of filters do this?
You are still doing it only for the filter (in tfilter_set_nl_ext() -
sitting in cls_api)
As i mentioned earlier, actions can also be offloaded independently;
would this work with actions extack?
If it wont work then perhaps we should go the avenue of using
per-object(in this case filter) specific attributes
to carry the extack as suggested by Jakub earlier.

David, extacks are passed to user space today via NLMSG_ERROR  and in
this case the error is being returned by
the driver - so it makes sense to stick to that attribute so user
space can interpret it as such.

Jakub, I would argue this is an event given the original intent: Some
human (or daemon) tried to add an entry to
hardware and s/w (neither skip_sw nor skip_hw set in user space
request) and it failed because the hardware does
not support the request, and therefore the entry got added as to the
kernel only.
The event in this case is to tell whoever is listening that this
happened i.e half the request worked.

The secondary argument from Marcelo and Hangbin is: there is a
practical use for this, you reducing the amount
of operational tooling needed. Alternative is to get the extack
equivalent in syslog and the other from from events and
then do the heuristics.

cheers,
jamal

On Thu, Dec 22, 2022 at 9:35 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Thu, Dec 22, 2022 at 09:26:14AM -0700, David Ahern wrote:
> > On 12/22/22 12:48 AM, Hangbin Liu wrote:
> > > On Wed, Dec 21, 2022 at 05:28:17PM -0800, Jakub Kicinski wrote:
> > >> On Wed, 21 Dec 2022 17:39:40 +0800 Hangbin Liu wrote:
> > >>> + nlh = nlmsg_put(skb, portid, n->nlmsg_seq, NLMSG_ERROR, sizeof(*errmsg),
> > >>> +                 NLM_F_ACK_TLVS | NLM_F_CAPPED);
> > >>> + if (!nlh)
> > >>> +         return -1;
> > >>> +
> > >>> + errmsg = (struct nlmsgerr *)nlmsg_data(nlh);
> > >>> + errmsg->error = 0;
> > >>> + errmsg->msg = *n;
> > >>> +
> > >>> + if (nla_put_string(skb, NLMSGERR_ATTR_MSG, extack->_msg))
> > >>> +         return -1;
> > >>> +
> > >>> + nlmsg_end(skb, nlh);
> > >>
> > >> I vote "no", notifications should not generate NLMSG_ERRORs.
> > >> (BTW setting pid and seq on notifications is odd, no?)
> > >
> > > I'm not sure if this error message should be counted to notifications generation.
> > > The error message is generated as there is extack message, which is from
> > > qdisc/filter adding/deleting.
> > >
> > > Can't we multicast error message?
> > >
> > > If we can't multicast the extack message via NLMSG_ERROR or NLMSG_DONE. I
> > > think there is no other way to do it via netlink.
> > >
> >
> > it is confusing as an API to send back information or debugging strings
> > marked as an "error message."
> >
>
> I think it's OK to send back information with error message. Based on rfc3549,
>
>    An error code of zero indicates that the message is an ACK response.
>    An ACK response message contains the original Netlink message header,
>    which can be used to compare against (sent sequence numbers, etc).
>
> I tried to do it on netlink_ack[1]. But Jakub pointed that the message ids
> are not same families. So I moved it to net/sched.
>
> I think the argue point is, can we multicast the error message?
>
> [1] https://lore.kernel.org/all/Y4W9qEHzg5h9n%2Fod@Laptop-X1/
>
> Thanks
> Hangbin
