Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC0547CAAF
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 02:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240642AbhLVBUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 20:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240545AbhLVBUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 20:20:06 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5D3C061574
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 17:20:06 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id o20so2006928eds.10
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 17:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q3E4fwi4gNj4jiWCJVADgxc2jcY60s27qHsWWjHk/Ms=;
        b=iv0KEQurMq23U8WzhUVIbPnEqKsRRz/YeCYpV8vDPXYnHMr6Fy+eQFFfxMrByj41+L
         akJdphdl976a7xhuG/Ey69UorBHduqA66mtBTwIQd6tu++0z+1eYrD8uIU/e5dtjqtv6
         cFJlLt4VLoEq8NQ+jVQIuiZkPP5Ev7aGhsRS+af7EY3OtbZuhIJCC7YTdmj3o5/D+tVu
         T4+i+C38AEZXZXhuCrBrdpiwR6MBok+hJE4Gpb/9dXHguVhORiYwdviHvfQhNmXUrNi/
         lcgXS4DJQ1rcuofsmKYbdQuVGx4dTDvKHD+IYLzr9bqw/pI6Aol9fDb7FhvWimiHLV0K
         hU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q3E4fwi4gNj4jiWCJVADgxc2jcY60s27qHsWWjHk/Ms=;
        b=7pss3NXXpA4rlxmTvhGcJIa+9VcqR0bZ6cqwTi6EgrB86ZG7EoZVAiNYaQhL+V0DRh
         en3rOGTeoLpYhRE3Dz3kn3YIhAkBHV0kKgsfisvZv71WtttVwJxZAUSxxxkf0vyMCBBo
         vOXx1GOIHJm7G6++yoCNu5Tv25IwqbZwuy+W2wEtbcTmPlTcqfyIGUnXtmjLKcK2Rejf
         DJ+6h0Avjj9Hx6v40qERN7jgZdWrd4AmTcgwTQSDlT5nqP1pguxqupZTtmTAb9i0egIr
         34ON5YaHGKpbwovGHhRk1m3T8eVeLwHMGqKwk9G1Lse9I50pZFKykNHrDesOj4E8f6h5
         H/7g==
X-Gm-Message-State: AOAM531lLU0vNNlzM4d6TouSzLP4XWca3fm+Le/DjuWgPPEDZuGtn5iN
        /43+2xApXZpQu2ug3nXq0dXyXNF16n1IWGukogvkw85TDMV1MQ==
X-Google-Smtp-Source: ABdhPJyNgk/u5E2fVsFpbY2jUbDnvy73KW94DS+ULSyMFKywKdGWfpjULECu7ZH6+toultFtaycmRDD/p1cPNIFQNus=
X-Received: by 2002:a17:907:2da6:: with SMTP id gt38mr685821ejc.61.1640136005029;
 Tue, 21 Dec 2021 17:20:05 -0800 (PST)
MIME-Version: 1.0
References: <20211220123839.54664-1-xiangxia.m.yue@gmail.com>
 <20211220123839.54664-2-xiangxia.m.yue@gmail.com> <CAM_iQpW+xKMj8B_njBEy0dO=rvY=hVGRSjwWj1T-Xk6e-FB1rA@mail.gmail.com>
In-Reply-To: <CAM_iQpW+xKMj8B_njBEy0dO=rvY=hVGRSjwWj1T-Xk6e-FB1rA@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 22 Dec 2021 09:19:28 +0800
Message-ID: <CAMDZJNXK263KkXp2=gVkuW1nqD2nqJbNxGC2YwRkZT5__hJkCQ@mail.gmail.com>
Subject: Re: [net-next v5 1/2] net: sched: use queue_mapping to pick tx queue
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 1:51 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Dec 20, 2021 at 4:38 AM <xiangxia.m.yue@gmail.com> wrote:
> >   In general recording the decision in the skb seems a little heavy handed.
> >   This patch introduces a per-CPU variable, suggested by Eric.
> >
> >   The xmit.skip_txqueue flag is firstly cleared in __dev_queue_xmit().
> >   - Tx Qdisc may install that skbedit actions, then xmit.skip_txqueue flag
> >     is set in qdisc->enqueue() though tx queue has been selected in
> >     netdev_tx_queue_mapping() or netdev_core_pick_tx(). That flag is cleared
> >     firstly in __dev_queue_xmit(), is useful:
> >   - Avoid picking Tx queue with netdev_tx_queue_mapping() in next netdev
> >     in such case: eth0 macvlan - eth0.3 vlan - eth0 ixgbe-phy:
> >     For example, eth0, macvlan in pod, which root Qdisc install skbedit
> >     queue_mapping, send packets to eth0.3, vlan in host. In __dev_queue_xmit() of
> >     eth0.3, clear the flag, does not select tx queue according to skb->queue_mapping
> >     because there is no filters in clsact or tx Qdisc of this netdev.
> >     Same action taked in eth0, ixgbe in Host.
> >   - Avoid picking Tx queue for next packet. If we set xmit.skip_txqueue
> >     in tx Qdisc (qdisc->enqueue()), the proper way to clear it is clearing it
> >     in __dev_queue_xmit when processing next packets.
>
> Any reason why we can't just move sch_handle_egress() down after
> netdev_core_pick_tx() and recalculate txq with skb->queue_mapping?
If we sch_handle_egress() down after netdev_core_pick_tx(), and we
overwrite the txqueue, the overhead of
netdev_core_pick_tx() is unnecessary, so I don't do that . If
eth0(macvlan) -> eth0.3(vlan) -> eth0(ixgbe), skb-> queue_mapping is
not cleared,
skb-> queue_mapping affect every netdevice to pick the tx queue.
> Thanks.



-- 
Best regards, Tonghao
