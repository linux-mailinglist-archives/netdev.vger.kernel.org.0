Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8799E46D636
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbhLHO7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235572AbhLHO7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:59:05 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A7BC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 06:55:33 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id o20so9197009eds.10
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 06:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ILtJ0oC6OBGy1IrHoU5umhWL83mqlVgSa3s2SPWxACk=;
        b=pypJ2ES/An1iyTOBlSdx+oDSRor8WKrFIyl0QvnJq1fab4lFTGQaluzdKvZg8ZWiJR
         cQewYPalq7HOQ/5JKWINWt923yykKff1ZXdpk6mE6N+LCp7Jz2buXDrnN8VT9qL6uNHX
         UUcDAibdmxdUh7xOkng9guYPGsBHqnBtbeb3HWPkt+35KGPVyyFXH/gJ0IqbeYg1E4Y/
         AWyUIQNAv8ycKSLELwNUP0w9q1DupUU6G3ubwstimqoPXInI9MP4kI9gdoGbuKcDst6R
         DGYB7K/L2xlrs/gmjVNSkaEo62lOyVFF5joO3T4prlA5qRQo8BXbV+Jq47wJ/NOwk92y
         /wtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ILtJ0oC6OBGy1IrHoU5umhWL83mqlVgSa3s2SPWxACk=;
        b=WcQT4DMGNp69BxwMrziJ4tr8pTt9Vb0Bww3hr9vPVfioekdX+GHzJiiJlgZ0erJ26c
         1tPgYjUB/mQKrZ75b0pqHYBoJUuQjtApCVDN3fLvICZCZuLStE3rnNWJv7apHAMH51pq
         TGlHgkbTitzd/tZa+wzbhfpaBx6zhaU86if1WUkVjVgzE0vGQc6kamWgsOXWCrvhv74c
         XzgVi+zPLQ13buNGbOAoLH+LA1dYsbpu4VDAw/6SLIgof1DecR6uhXgo2M/gNZNzkTx1
         weD0HaDc5umVu5lx3alKzb2PDGMdg3Ga1EiurgDJ9sOLHz7/kkI0iJmlrxH/wznvTkWh
         HZhA==
X-Gm-Message-State: AOAM533XKyK7nS0r3rMWfg51s19q+DykJrUjzL+/nDoZoIO3gRTBI/i8
        z6NrdUqqVGbg55dXOA1BaYGoPgsmOgI7SCdfll4=
X-Google-Smtp-Source: ABdhPJyHTZ4OjZQopBqNd4SWMvS+TV3nHJJomKKXcvDpcOR7lxGjprpzjnjJuqLktv1JEFmtUVqiqSHDa7T1FFb0AWI=
X-Received: by 2002:a05:6402:4407:: with SMTP id y7mr20035828eda.140.1638975331705;
 Wed, 08 Dec 2021 06:55:31 -0800 (PST)
MIME-Version: 1.0
References: <20211206080512.36610-1-xiangxia.m.yue@gmail.com>
 <20211206080512.36610-2-xiangxia.m.yue@gmail.com> <20211206124001.5a264583@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMDZJNVnvAXfqFSah4wgXri1c3jnQhxCdBVo41uP37e0L3BUAg@mail.gmail.com>
 <20211206183301.50e44a41@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMDZJNUwWnq9+d_2a3UatfxKz3+gjDo3GLftgOE9-=3-smA8BQ@mail.gmail.com> <20211207074457.605dad52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207074457.605dad52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 8 Dec 2021 22:54:55 +0800
Message-ID: <CAMDZJNVXDJ48yn+MAAcKda-noV7T6xg_EvPJh5A905V-pvuyCA@mail.gmail.com>
Subject: Re: [net-next v1 1/2] net: sched: use queue_mapping to pick tx queue
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 7, 2021 at 11:45 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 7 Dec 2021 11:22:28 +0800 Tonghao Zhang wrote:
> > On Tue, Dec 7, 2021 at 10:33 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Tue, 7 Dec 2021 10:10:22 +0800 Tonghao Zhang wrote:
> > > > Yes, we can refactor netdev_core_pick_tx to
> > > > 1. select queue_index and invoke skb_set_queue_mapping, but don't
> > > > return the txq.
> > > > 2. after egress hook, use skb_get_queue_mapping/netdev_get_tx_queue to get txq.
> > >
> > > I'm not sure that's what I meant, I meant the information you need to
> > > store does not need to be stored in the skb, you can pass a pointer to
> > > a stack variable to both egress handling and pick_tx.
> > Thanks, I got it. I think we store the txq index in skb->queue_mapping
> > better. because in egress hook,
> > act_skbedit/act_bpf can change the skb queue_mapping. Then we can
> > pick_tx depending on queue_mapping.
>
> Actually Eric pointed out in another thread that xmit_more() is now
> done via a per-CPU variable, you can try that instead of plumbing a
> variable all the way into actions and back out to pick_tx().
Thanks Jakub, Eric
v2 is sent, please review
https://patchwork.kernel.org/project/netdevbpf/list/?series=592341

> Please make sure to include the analysis of the performance impact
> when the feature is _not_ used in the next version.
Ok, I updated the commit message. Thanks!

> > > > I have no idea about mq, I think clsact may make the things more flexible.
> > > > and act_bpf can also support to change sk queue_mapping. queue_mapping
> > > > was included in __sk_buff.
> > >
> > > Qdiscs can run a classifier to select a sub-queue. The advantage of
> > > the classifier run by the Qdisc is that it runs after pick_tx.
> > Yes, we should consider the qdisc lock too. Qdisc lock may affect
> > performance and latency when running a classifier in Qdisc
> > and clsact is outside of qdisc.



-- 
Best regards, Tonghao
