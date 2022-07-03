Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601FE5644C4
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 06:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbiGCEgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 00:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiGCEgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 00:36:32 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A3B65F6
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 21:36:31 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id n12so6154076pfq.0
        for <netdev@vger.kernel.org>; Sat, 02 Jul 2022 21:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=62ArhUP2zvYk+YsKHQYjwxVWsBvV25s5/UZPMyRsAAc=;
        b=WlEpV01Y/J4m3R5hP0hra2jrY+hkcyzmFOg4h9nik7WtD1n/kU/teSPKgHG+i6KvW4
         t8BDxIQwlQSxVvenyuYGjWuOH2yzhSHMOTzQJOjL5u5A55do5kO+7ZqCKkLjkhLCIY2I
         fF7NJD/OFWMdTQANsc797Ms7GAAbPKppWTpwY7HT4Ieub+iPl8azNm79QTahEm/S0pbB
         kezBw7JNdNwZaBl/tjKUfcvbMaIoJ3G9RcOwVrX/jf2dLdMAj1HaunFIqEJpDQs4qiot
         Q/Iij+MQHWjiox0Y2V3vh5ykyKVflvUUWZOmPaTyDuG5tt7s2+2awEOatGNUtVHG46Xv
         ifVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=62ArhUP2zvYk+YsKHQYjwxVWsBvV25s5/UZPMyRsAAc=;
        b=sZLjQts3IyPWxUnVz8HjjVtTAN9B8So7kelGUxLJixVqke5IX/exBQymzNWqkc9XOl
         I1EMe2zhelQaFQAP1DK89B/MEPeOhCgYIoHF/3uecrjNt5yI3sP6QmCR+vaG/JYUWCnY
         8CossGPwVdbKBkfxtf6xlo8elbfKUjJhjGj78PG35HR2zFBV1xow1YTjSbpxdozBpDCe
         Xh4F1Z33oYRjckt4H9bvuZvnwvxFwp3oBJypzUoRcfigCwriNXxoez3Me9NJt1bbvKMA
         FgHz708Erw/HivZSNGDVaJdNK9w4zyybQWLXGkjGz/ubg4YVoITKE2n7TCJ77jdV81CF
         LV+Q==
X-Gm-Message-State: AJIora8P4Ku4GJAU71v/SQC4aAvaB9LaXhzw0WD0EauElTjtgBZdkeSK
        2caU7REbeD2xLqYtIuj07llbcBpVFstcpRfxslw=
X-Google-Smtp-Source: AGRyM1v046EQA+y6P/P4TZNE8YH7JNPwG2IODBj0EzVD7TSGFAiJGgEVzVaH3fjlmc94nwbnBgiGrLN/xQzX7uUN6F4=
X-Received: by 2002:a65:4587:0:b0:40d:2136:8690 with SMTP id
 o7-20020a654587000000b0040d21368690mr19335146pgq.402.1656822991317; Sat, 02
 Jul 2022 21:36:31 -0700 (PDT)
MIME-Version: 1.0
References: <1656106465-26544-1-git-send-email-quic_subashab@quicinc.com>
 <YroGx7Wd2BQ28PjA@pop-os.localdomain> <ad6f3fbc-9996-6fa7-2015-01832b013c98@quicinc.com>
In-Reply-To: <ad6f3fbc-9996-6fa7-2015-01832b013c98@quicinc.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 2 Jul 2022 21:36:19 -0700
Message-ID: <CAM_iQpVXs5npkommaZzTTvoPKyjhpPL3ws5DtFGvG+_yYVX4dA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: Print hashed skb addresses for all net
 and qdisc events
To:     "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        quic_jzenner@quicinc.com, "Cong Wang ." <cong.wang@bytedance.com>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 12:49 PM Subash Abhinov Kasiviswanathan (KS)
<quic_subashab@quicinc.com> wrote:
>
>
>
> On 6/27/2022 1:36 PM, Cong Wang wrote:
> > On Fri, Jun 24, 2022 at 03:34:25PM -0600, Subash Abhinov Kasiviswanathan wrote:
> >> The following commits added support for printing the real address-
> >> 65875073eddd ("net: use %px to print skb address in trace_netif_receive_skb")
> >> 70713dddf3d2 ("net_sched: introduce tracepoint trace_qdisc_enqueue()")
> >> 851f36e40962 ("net_sched: use %px to print skb address in trace_qdisc_dequeue()")
> >>
> >> However, tracing the packet traversal shows a mix of hashes and real
> >> addresses. Pasting a sample trace for reference-
> >>
> >> ping-14249   [002] .....  3424.046612: netif_rx_entry: dev=lo napi_id=0x3 queue_mapping=0
> >> skbaddr=00000000dcbed83e vlan_tagged=0 vlan_proto=0x0000 vlan_tci=0x0000 protocol=0x0800
> >> ip_summed=0 hash=0x00000000 l4_hash=0 len=84 data_len=0 truesize=768 mac_header_valid=1
> >> mac_header=-14 nr_frags=0 gso_size=0 gso_type=0x0
> >> ping-14249   [002] .....  3424.046615: netif_rx: dev=lo skbaddr=ffffff888e5d1000 len=84
> >>
> >> Switch the trace print formats to %p for all the events to have a
> >> consistent format of printing the hashed addresses in all cases.
> >>
> >
> > This is obscured...
> >
> > What exactly is the inconsistency here? Both are apparently hex, from
> > user's point of view. The only difference is one is an apparently
> > invalid kernel address, the other is not. This difference only matters
> > when you try to dereference it, but I don't think you should do it here,
> > this is not a raw tracepoint at all. You can always use raw tracepoints
> > to dereference it without even bothering whatever we print.
> >
> > Thanks.
>
> Matching skbs addresses (in a particular format) helps to track the
> packet traversal timings / delays in processing.

So... how didn't you notice the duplicated addresses with hashed ones?
It is 100% reproducible to see duplicates with hashed ones.

Thanks.
