Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF4E3BE8B6
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 15:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhGGNZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 09:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhGGNZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 09:25:29 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93D2C061574;
        Wed,  7 Jul 2021 06:22:48 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id bu12so3318516ejb.0;
        Wed, 07 Jul 2021 06:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NX1ZKDJsQuuJjvtcyvAtIrLYE2dDnJwtrH+INwBVKA0=;
        b=Pky5EfyGnHFuWzU1VkHcjQ5Cd8ZLb9e7Uz+KHY6CdD1szPAz44F8DrmZTNfTlSV+JY
         yuCGcmuIBaW7Gafdc6xRhySf2F/+kyK8hzz5r7FmXwrp72ZPm/8sdiP1bkIznNH8rW44
         XZY5w4bF4H3e6nirQrVAf+0FXlhFjKzX5IUgcGvXJqdZsufT4t7gkX6qasBgRlUTiSsf
         tWcPdSdY3TVq1yZq7NGY5lhYMhxCGqqVPycCBJQZfdOU8qEocmyUBJ4L3ijx/HDHnH55
         zHMX6hxWXFy9MDSacDZ0w1y82iE6pd5n2mXs26DuBeibWtFi/bPLMq4rLab19NVI8rql
         x9cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NX1ZKDJsQuuJjvtcyvAtIrLYE2dDnJwtrH+INwBVKA0=;
        b=KWCZAtzlKbH5+CnLyvCRWmE9sGAPKwe6Crn0pMIrItpKlfW6FuqywertwDFX6uuCcO
         LEjC2rWON8RoIW4/TnKK/yAnBkkhE3wdYqfI8FB57bfZG6YBW/j4VNnh4kYAlrTsuB3/
         qNjQdLAXluL3++qOB6Cq7gAg+ttbGZEfcM24W1sUMgU7xAbQzvKXe85uJ8ocFD6djzfj
         3OJw2FsUKfQzhzLKdlayCpj4zkjSq/rxn9Cw29bP2QK5MqoVhFQp2g3Hg861y7mUIpwo
         PS0zJl7Bg0OXsHnA5Si0+g5djDXpvVd2zVEdkHZVmX5G6Yyo34zpapeuTgqJiS9AQW0z
         OShw==
X-Gm-Message-State: AOAM531LsAbXSk5Jsij1f7OIf1X9O74vo24ga1hvtTtZn97Dg2LtN3HZ
        wu58zA1OzDzyZujQO9TsW4pu+QpBYAS22Myv/HqiNTmc58IR4Xxg
X-Google-Smtp-Source: ABdhPJyxIR7UkT66xJvNSNwNAdxLITultz32qew0PD2PJgaP6iPMpohAS1uS911QvIXI301VO5e/scNfzte2g3xukxQ=
X-Received: by 2002:a17:906:3699:: with SMTP id a25mr17995642ejc.452.1625664167340;
 Wed, 07 Jul 2021 06:22:47 -0700 (PDT)
MIME-Version: 1.0
References: <CABv53a97_5iaAdOcoVdQDxNyyTxgXHx=mHm0Sfo4UJVLHoxosg@mail.gmail.com>
 <20210707091807.GA16039@salvia>
In-Reply-To: <20210707091807.GA16039@salvia>
From:   iLifetruth <yixiaonn@gmail.com>
Date:   Wed, 7 Jul 2021 21:22:12 +0800
Message-ID: <CABv53a_3sQmRzCfybo1s0EkNnFyaehx-E0WvBALe34XsXggpJg@mail.gmail.com>
Subject: Re: netfilter: Use netlink_ns_capable to verify the permisions of
 netlink messages
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiang Liu <cyruscyliu@gmail.com>, yajin@vm-kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I see.
There is no need to check the capability again in the
nfnetlink_cthelper and nfnetlink_osf now.

Regards and thanks for your analyze,
- iLifetruth




On Wed, Jul 7, 2021 at 5:18 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Jul 07, 2021 at 04:05:33PM +0800, iLifetruth wrote:
> > Hi, we have found that the same fix pattern of CVE-2014-0181 may not
> > forward ported to some netlink-related places in the latest linux
> > kernel(v5.13)
> >
> > =============
> > Here is the description of CVE-2014-0181:
> >
> > The Netlink implementation in the Linux kernel through 3.14.1 does not
> > provide a mechanism for authorizing socket operations based on the opener
> > of a socket, which allows local users to bypass intended access
> > restrictions and modify network configurations by using a Netlink socket
> > for the (1) stdout or (2) stderr of a setuid program.
> >
> > ==========
> > And here is the solution to CVE-2014-0181:
> >
> > To keep this from happening, replace bare capable and ns_capable calls with
> > netlink_capable, netlink_net_calls and netlink_ns_capable calls. Which act
> > the same as the previous calls *except they verify that the opener of the
> > socket had the desired permissions as well.*
> >
> > ==========
> > The upstream patch commit of this vulnerability described in CVE-2014-0181
> > is:
> >     90f62cf30a78721641e08737bda787552428061e (committed about 7 years ago)
> >
> > =========
> > Capable() checks were added to these netlink-related places listed below
> > in netfilter by another upstream commit:
> > 4b380c42f7d00a395feede754f0bc2292eebe6e5(committed about 4 years ago)
> >
> > In kernel v5.13:
> >     File_1: linux/net/netfilter/nfnetlink_cthelper.c
> >                        in line 424, line 623 and line 691
> >     File_2: linux/net/netfilter/nfnetlink_osf.c
> >                        in line 305 and line 351
>
> These subsystems depend on nfnetlink.
>
> nfnetlink_rcv() is called before passing the message to the
> corresponding backend, e.g. nfnetlink_osf.
>
> static void nfnetlink_rcv(struct sk_buff *skb)
> {
>         struct nlmsghdr *nlh = nlmsg_hdr(skb);
>
>         if (skb->len < NLMSG_HDRLEN ||
>             nlh->nlmsg_len < NLMSG_HDRLEN ||
>             skb->len < nlh->nlmsg_len)
>                 return;
>
>         if (!netlink_net_capable(skb, CAP_NET_ADMIN)) {
>                 netlink_ack(skb, nlh, -EPERM, NULL);
>                 return;
>         }
>         [...]
>
> which is calling netlink_net_capable().
>
> > But these checkers are still using bare capable instead of netlink_capable
> > calls. So this is likely to trigger the vulnerability described in the
> > CVE-2014-0181 without checking the desired permissions of the socket
> > opener. Now, shall we forward port the fix pattern from the patch of
> > CVE-2014-0181?
> >
> > We would like to contact you to confirm this problem.
>
> I think these capable() calls in nfnetlink_cthelper and nfnetlink_osf
> are dead code that can be removed. As I explained these subsystems
> stay behind nfnetlink.
