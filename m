Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678FC47B25C
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 18:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240289AbhLTRvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 12:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240283AbhLTRvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 12:51:43 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5A3C061574
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 09:51:43 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id v138so31120754ybb.8
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 09:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LBxVmnKz7z8v0Mgow/i9V228EvuxtNuGCRNfMGoGN/I=;
        b=I9dxBZKIjre/4ANn3E47E5LGjG3g81bgjk1hnjwkHAlH5V7Uh9X6V5hXvWXnU8jp7j
         eu6oRpCC73Gr9ovRdto5F8JZLPRZ1avsRxQfWfxbRqGgyj9kO4yUCtQ6sSdkUV0+RsZr
         Iv76xZ4aadApE7JVSidLVo3pGsGJbnOe770+x2LnTqFwjZMBPs1rWQ37oDDL2Ht4cwGM
         XezuReldafxDQgQQtVKqoZefN+RfJ8SbjNg09DH0lrA0X8Z0xDFoQ8mT8JXTIGgs3igY
         UJSpkTSlJbL1X04KCnZLBkMMoA1S8cEHaNx2eL8JNOZExkWZ1d8Mcq+2A8GaMq/3Mqtg
         B1CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LBxVmnKz7z8v0Mgow/i9V228EvuxtNuGCRNfMGoGN/I=;
        b=V0bhHNOmYvsXGDbFLvbjE4KbAzSlh18gwZcBedC1yZ/eNBO3w03d5gvPyjaPd1aDCL
         bSab6tWfMGjPmwIIouYnSzQ7ufDnIClbPEPo7GuQ3NCt+jG7i0CJp6mhmF8rvEI3qyOR
         wDL1Btkay8vCMedkPTzQIbrMp2wrELaRIE7aYTNq5V5i3P1fiJ67zeKCRGGjZBDzr94c
         I9olBTNByHHXGv2mMvXBhz0xn6/vDVD0czzGwr4Uv5P8iIVrM1B5YMysdL574/bI4IwJ
         smz0pq78fayRuDT2ffav/gQ0J1kqXUxfJhE9zxwTZb3ln7NYU2blJ0B6EiFFXLr1TFkM
         XzBw==
X-Gm-Message-State: AOAM530xmvfaRs6Ib6wBzyBkubkN3w9sXi2c7EB63V0QUneZKXHqGFhS
        zRsbz8frIXgu7LQRntUSD9NCntXvlQZfxMPqQMg=
X-Google-Smtp-Source: ABdhPJw5c6JJE+WzoB8mFVxaJsnwIWiTn5uA9PM0Koz/yJD5NpG9KabRtm1RoDSa5qlENrfq6KigGRNc7da7b5QFYss=
X-Received: by 2002:a25:a448:: with SMTP id f66mr23966288ybi.225.1640022702283;
 Mon, 20 Dec 2021 09:51:42 -0800 (PST)
MIME-Version: 1.0
References: <20211220123839.54664-1-xiangxia.m.yue@gmail.com> <20211220123839.54664-2-xiangxia.m.yue@gmail.com>
In-Reply-To: <20211220123839.54664-2-xiangxia.m.yue@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 20 Dec 2021 09:51:31 -0800
Message-ID: <CAM_iQpW+xKMj8B_njBEy0dO=rvY=hVGRSjwWj1T-Xk6e-FB1rA@mail.gmail.com>
Subject: Re: [net-next v5 1/2] net: sched: use queue_mapping to pick tx queue
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
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

On Mon, Dec 20, 2021 at 4:38 AM <xiangxia.m.yue@gmail.com> wrote:
>   In general recording the decision in the skb seems a little heavy handed.
>   This patch introduces a per-CPU variable, suggested by Eric.
>
>   The xmit.skip_txqueue flag is firstly cleared in __dev_queue_xmit().
>   - Tx Qdisc may install that skbedit actions, then xmit.skip_txqueue flag
>     is set in qdisc->enqueue() though tx queue has been selected in
>     netdev_tx_queue_mapping() or netdev_core_pick_tx(). That flag is cleared
>     firstly in __dev_queue_xmit(), is useful:
>   - Avoid picking Tx queue with netdev_tx_queue_mapping() in next netdev
>     in such case: eth0 macvlan - eth0.3 vlan - eth0 ixgbe-phy:
>     For example, eth0, macvlan in pod, which root Qdisc install skbedit
>     queue_mapping, send packets to eth0.3, vlan in host. In __dev_queue_xmit() of
>     eth0.3, clear the flag, does not select tx queue according to skb->queue_mapping
>     because there is no filters in clsact or tx Qdisc of this netdev.
>     Same action taked in eth0, ixgbe in Host.
>   - Avoid picking Tx queue for next packet. If we set xmit.skip_txqueue
>     in tx Qdisc (qdisc->enqueue()), the proper way to clear it is clearing it
>     in __dev_queue_xmit when processing next packets.

Any reason why we can't just move sch_handle_egress() down after
netdev_core_pick_tx() and recalculate txq with skb->queue_mapping?

Thanks.
