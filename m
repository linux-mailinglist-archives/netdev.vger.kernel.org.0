Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B0A265074
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgIJUSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgIJUP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:15:27 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC69BC061573;
        Thu, 10 Sep 2020 13:15:26 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id p13so6964046ils.3;
        Thu, 10 Sep 2020 13:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D3rZXN/M5buU4UjqwEW2O7loIxNlYUmjQb6smWkzqBg=;
        b=VTdYTP6ksg2hPwjOXuVHwHnK/LWAy+MORKzIMxhWBuXxVfb5VJ+q7CHpHgt/xy0q5O
         9UTprebf4ZdFm8XzykbZPqwoGRiKuzrcv3wDr7Ol7ieHJ06M5NGPxS27PoSNbrSYFNXl
         N5kdxkS4CFcx5BLWZ1ypTKhFs4fmEjoGKOUmfFTP9MPTLMJYWQIvmDtRP0uHtiYDr3of
         npN4t1iAmjdZcPNCXiHWP9Qkbbp24dK0saU2yHStbwahZwH/ZqnrNF6MABg4ZVAAhXTN
         Q6qpzxHbERYO5sbYodFmQbZ5YC7tsFU2VG+YHHe4RqogiUXiEQXQbBQryPsk9jrZpNmZ
         6UJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D3rZXN/M5buU4UjqwEW2O7loIxNlYUmjQb6smWkzqBg=;
        b=ocOJBGFSMJuRdJdP+78vBkRDSq7cjJX5n4df6wkeZlgdVIdbEpSYxwpXGTZ6cHgEjN
         qQIaCRp6zRFZv09mpXcxes3KYmUa+BBNHhTkBoh10dDpYm6yNjth4duzvq7RT2rZ7Aw1
         wbncO87gI/uxbEwZp3xzx9VvIP2cjdbMdO+Z4zOuKgcRavlw6C3jyPvBLUFz5cYIlySj
         wD11FSOdAUe0n5gI81pAnicNdXxGOQCCvdI2819MsMqL5qZnsKm8vnmavaXENJ6tSycT
         MGbx7ja5YmfvdMJZEcrs99U2w6o7a0ZQjahg3/yo90m0ge3IlDEOZikf3tlebcK+EXjP
         pQNQ==
X-Gm-Message-State: AOAM531GbR5p87oQ2e15fQ6rpa6g6EYqXmSV/b+yqu8qRQJt5IRiu9cc
        4ujK6QGNclraizwP5RHfGNx5SC2iM3RF7iQRIyw=
X-Google-Smtp-Source: ABdhPJyG9S6/AXyb0iHiDrjcyJg8kg5GF9s1OA0arakOUvT09KYBD8FleKNZP3JpzdcF7SlM1ehsQYaCRMx4M47BbvM=
X-Received: by 2002:a92:9145:: with SMTP id t66mr9259698ild.305.1599768926155;
 Thu, 10 Sep 2020 13:15:26 -0700 (PDT)
MIME-Version: 1.0
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com> <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
 <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com> <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
 <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com> <CANE52Ki8rZGDPLZkxY--RPeEG+0=wFeyCD6KKkeG1WREUwramw@mail.gmail.com>
 <20200822032800.16296-1-hdanton@sina.com> <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
 <20200825032312.11776-1-hdanton@sina.com> <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
 <20200825162329.11292-1-hdanton@sina.com> <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
 <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com>
 <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
 <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AB7fd2vUOQ@mail.gmail.com>
 <20200827125747.5816-1-hdanton@sina.com> <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
 <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com> <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch>
In-Reply-To: <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 10 Sep 2020 13:15:14 -0700
Message-ID: <CAM_iQpVqdVc5_LkhO4Qie7Ff+XXRTcpiptZsEVNh=o9E0GkcRQ@mail.gmail.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Hillf Danton <hdanton@sina.com>,
        Jike Song <albcamus@gmail.com>, Josh Hunt <johunt@akamai.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 3, 2020 at 10:08 PM John Fastabend <john.fastabend@gmail.com> wrote:
> Maybe this would unlock us,
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 7df6c9617321..9b09429103f1 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3749,7 +3749,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>
>         if (q->flags & TCQ_F_NOLOCK) {
>                 rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> -               qdisc_run(q);
> +               __qdisc_run(q);
>
>                 if (unlikely(to_free))
>                         kfree_skb_list(to_free);
>
>
> Per other thread we also need the state deactivated check added
> back.

I guess no, because pfifo_dequeue() seems to require q->seqlock,
according to comments in qdisc_run(), so we can not just get rid of
qdisc_run_begin()/qdisc_run_end() here.

Thanks.
