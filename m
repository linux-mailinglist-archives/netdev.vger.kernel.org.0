Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C396B55D2E7
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237611AbiF0Tds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 15:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236184AbiF0Tdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 15:33:47 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5883862CE
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:33:47 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id v185so8913399ybe.8
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cQ1SVIK+swrmYYcAgO26RS1RT0QUpm8VCeVy6fMaSU8=;
        b=ZEsjE62AYoQ48ot9gXFJIHN8kUUiw+rhek6Ya0nTxlSqHvDo0wl8yF7wemW8wW7saO
         TXW8FxCpwvB3gWw9umPTTqmSz+8Dvzrc50Z7cbyenJI+yHIrJnB3qbjhohvSgIDcG690
         dOJsEQvBp9x27xIVCRIQVTRNRia7LqCjW3j3MiG4+v2xyF8coQ31mvSRtgxXMlZMqP4S
         +R7x1+3/Zbl6nLGlP/fFfioZjoFO5jQ9m8iuy+KIxWoQK6eBgqB6G6wuc0uqXlqvcnDi
         LRkjcbIcj5/IzKyavY3VUgX73byCKSyRnOuLK12PmPNTggYlKOtno6w2vAQvi70vmGAz
         KSIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cQ1SVIK+swrmYYcAgO26RS1RT0QUpm8VCeVy6fMaSU8=;
        b=ROpR+nnFEUvcAw5uzuR3H7nY6XIkBWcVzJrAHFejtH2+0UJsXtcVelKX3ggaTtYIDL
         CG6GyjwSIw4qFOvqjgFdcCt+Yrpb5RRlyfsEvy60StoicViwNAYfQJee6RQeLhQLCes5
         wYmJwCePIWdbG8sOVPtrUQ/YH8TN1t76LRt+43eRy/CYnPt+gklUirLGUXY/q44rXcp5
         fKXBG5LDKp2DCnGyLerSkvBBgn3z79aRxBuw/TAsDKpQnK/ecD0GpUeC2DWO+5v6pwk7
         iI9wa8o7sW240kqTnuoLCJnymq74wjuxXFrrMFHCkLg234CmJbfefwDDYAaVyxyHkkUP
         7AiA==
X-Gm-Message-State: AJIora8TO91zZxkVIzAZJSLRYm/80JNLXG+L5NdP+z10tU7KQHP060Dq
        EVhKIpjSndLtySnyezF91Sv6DoLIfhwsvFOS3NIn+Q==
X-Google-Smtp-Source: AGRyM1uMBUt+PMcFPyXaE2u/MA2qbP5uBPpQfwnGsgM7arhkYSS725RyXMSltabt7Edq6bg6o6LACQO94+N+zs6Jzb0=
X-Received: by 2002:a5b:f08:0:b0:668:f065:9097 with SMTP id
 x8-20020a5b0f08000000b00668f0659097mr15568070ybr.233.1656358426357; Mon, 27
 Jun 2022 12:33:46 -0700 (PDT)
MIME-Version: 1.0
References: <1656050956-9762-1-git-send-email-quic_subashab@quicinc.com>
 <CANn89iJ_HBEkiU3ToAjcv_KHz3f77DJpycKcU=74X3rNst-V6g@mail.gmail.com> <YroEC3NV3d1yTnqi@pop-os.localdomain>
In-Reply-To: <YroEC3NV3d1yTnqi@pop-os.localdomain>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jun 2022 21:33:34 +0200
Message-ID: <CANn89i+X4+w91MwZNW7qsb9dK3W0s72iehh5Kkb077ApTis_Vg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Print real skb addresses for all net events
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, quic_jzenner@quicinc.com,
        Cong Wang <cong.wang@bytedance.com>, qitao.xu@bytedance.com,
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

On Mon, Jun 27, 2022 at 9:25 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Fri, Jun 24, 2022 at 08:27:34AM +0200, Eric Dumazet wrote:
> > On Fri, Jun 24, 2022 at 8:09 AM Subash Abhinov Kasiviswanathan
> > <quic_subashab@quicinc.com> wrote:
> > >
> > > Commit 65875073eddd ("net: use %px to print skb address in trace_netif_receive_skb")
> > > added support for printing the real addresses for the events using
> > > net_dev_template.
> > >
> >
> > It is not clear why the 'real address' is needed in trace events.
>
> Because hashed address is _further_ from being unique, we could even
> observe same hashed addresses with a few manually injected packets.
>
> Real address is much better. Although definitely it can't guarantee
> uniqueness, it is already the cheapest way to identify the packets in
> tracing. (Surely you can add an ID generator or something similiar, but
> nothing is cheaper than just using the real address.)
>
> >
> > I would rather do the opposite.
> >
>
> Strongly disagree. I will sent a revert.
>

Make sure to include lkml for this discussion :

Vast majority (100%) of TP_printk() using %p use %p, not %px

$ git grep -n TP_printk|grep %p|wc -l
425
$ git grep -n TP_printk|grep %px|wc -l
0


> Thanks.
