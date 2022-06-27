Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D3555CA9D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240676AbiF0Tq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 15:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240719AbiF0Tqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 15:46:54 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F5D1ADA2
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:46:53 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id q132so18456002ybg.10
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vSvY/rRS7LVgGifrIdx+Y1pH+hiapbvLwF3dQ1bNHus=;
        b=WeUYF/bhX6aCdW5J/z4c/eur7ZzL6SzlnE7Bo1qEP8r0TJZDH1hgy7oPGP/GVn5qfJ
         cg6qTapCXhXuG6a9bb8yxDwrWsoSY3yqbBDrEfqPuXF4xq38auWWwyrbx7Zfjc24aFT3
         qyyiBAqCFKISUd3N4xnagkNHNYixCaZn1XPN844B3QRsFDIupIxVzkMAh75aO8y31FkF
         ofJillikL+PaIcBnWxxXGEhbJHbpob5+hlbswKhe/QNHKvP1vMOurScaPUQIqoX50CY3
         3nDxdxvMNwbXll7MxFiTUJdKYYeySihpuQUbkLQmfsA78Ot7TtFX7YxAIUnZAILTuCMn
         oTDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vSvY/rRS7LVgGifrIdx+Y1pH+hiapbvLwF3dQ1bNHus=;
        b=cUUKYzo/YHJiglAh/uRICasADp5IElFO3BeSgw+W7DSOihKIJ1gFUyBeERwFO5jgdD
         l7ue62/NrKJvlolZk0aIliyA6rKelDnemAZulOWD9EJRvUIU94hac7Gb36Q5OkbM1kqz
         zhgnyCuoR6royNDvPqR1S9tRdoFa/LSmp9GTaopsicZAbQNq/TrgXow3TbzMThtSzowK
         NptE42cQuD/N3nl9/+eAhF1VU96NGLu2CSPFl9tWRpYQK4PHr5sv/vDrEQ0sk9kmMT8E
         WWIz0DGnMBmtsLTbsqJFZoepwlwPa92hfj/3h1SXgHmKm40EXya50dd0jV2e25aWg87Y
         p8wg==
X-Gm-Message-State: AJIora9v38dSMo7z/1+Tg+qDFo/JRJXWn6rRWabLkbNsWQn6MmlD0hdW
        wqVmzRwcuxWQudZWX7pGjLXuBK0mAvrHFL3ZPpkrBQ==
X-Google-Smtp-Source: AGRyM1sndprHsDKoCbTOPbrNFsOGhT0oRIZ+SMahNCmqCS1PMl8bMBlhOvg8YHwR0X0dQfVhJLC2yAhe0mUS3kAYZnM=
X-Received: by 2002:a25:e211:0:b0:669:9cf9:bac7 with SMTP id
 h17-20020a25e211000000b006699cf9bac7mr14588363ybe.407.1656359212572; Mon, 27
 Jun 2022 12:46:52 -0700 (PDT)
MIME-Version: 1.0
References: <1656050956-9762-1-git-send-email-quic_subashab@quicinc.com>
 <CANn89iJ_HBEkiU3ToAjcv_KHz3f77DJpycKcU=74X3rNst-V6g@mail.gmail.com>
 <YroEC3NV3d1yTnqi@pop-os.localdomain> <CANn89i+X4+w91MwZNW7qsb9dK3W0s72iehh5Kkb077ApTis_Vg@mail.gmail.com>
 <CAM_iQpXF4cvuMe3yM_G2Xzab_3Q_D1oUcfchaAZE6cYNcMoe9Q@mail.gmail.com>
In-Reply-To: <CAM_iQpXF4cvuMe3yM_G2Xzab_3Q_D1oUcfchaAZE6cYNcMoe9Q@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jun 2022 21:46:41 +0200
Message-ID: <CANn89iKRU6QDfmRa=YikyGHjC=v-8RepTWHtHPMQivAqP=gt2Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Print real skb addresses for all net events
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, quic_jzenner@quicinc.com,
        Cong Wang <cong.wang@bytedance.com>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 9:41 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Jun 27, 2022 at 12:33 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Mon, Jun 27, 2022 at 9:25 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Fri, Jun 24, 2022 at 08:27:34AM +0200, Eric Dumazet wrote:
> > > > On Fri, Jun 24, 2022 at 8:09 AM Subash Abhinov Kasiviswanathan
> > > > <quic_subashab@quicinc.com> wrote:
> > > > >
> > > > > Commit 65875073eddd ("net: use %px to print skb address in trace_netif_receive_skb")
> > > > > added support for printing the real addresses for the events using
> > > > > net_dev_template.
> > > > >
> > > >
> > > > It is not clear why the 'real address' is needed in trace events.
> > >
> > > Because hashed address is _further_ from being unique, we could even
> > > observe same hashed addresses with a few manually injected packets.
> > >
> > > Real address is much better. Although definitely it can't guarantee
> > > uniqueness, it is already the cheapest way to identify the packets in
> > > tracing. (Surely you can add an ID generator or something similiar, but
> > > nothing is cheaper than just using the real address.)
> > >
> > > >
> > > > I would rather do the opposite.
> > > >
> > >
> > > Strongly disagree. I will sent a revert.
> > >
> >
> > Make sure to include lkml for this discussion :
>
> Already did:
> https://lore.kernel.org/all/CAM_iQpV3Qm_GTfCX1E_OC0PXu+diT9QHtPt4OYcJdyGRcA37Sw@mail.gmail.com/
>
> >
> > Vast majority (100%) of TP_printk() using %p use %p, not %px
> >
> > $ git grep -n TP_printk|grep %p|wc -l
> > 425
> > $ git grep -n TP_printk|grep %px|wc -l
> > 0
>
> You are changing this topic, no one here in this thread cares about non-skb
> addresses.
>

I will not ack a revert.

Unless you get ACK from Linus Torvalds maybe.

We have ways for developers : no_hash_pointers
