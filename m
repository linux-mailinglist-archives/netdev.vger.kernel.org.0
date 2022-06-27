Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30E6A55CAEC
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240621AbiF0TmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 15:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240485AbiF0Tlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 15:41:49 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D891705A
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:41:48 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d5so9048944plo.12
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JlHL5tJ/f7FTmiUmvcxN9wHROBLnGjfBtLf1fu0bbkI=;
        b=F+CYf343/6DF8EHLKEacmGYb02yIwMwgIRhTXoXL4AVrRtAbh+RuHYjDqqCGR65CRJ
         r8T0jlM7m14OFusjQbW2iP7KxqwRinfC7yNqEVx+ZzaSN6HV9exXGgGLpimniBgDSp/i
         6BO2LMvfxVUTV4pTqGdT1J2kfjZ45+3ikp2r2Bl3LrkCooUEAaS/pCeIKsmgUJfwV3df
         z78wC23xQyQP5cpgKEyqXwtOkbP7NN9EnMWydUOVm69JlSeewoEjEXWt5CXQUJnQl9ps
         steEIjJ1I3zxTpL2abjP6j/aHnd8x3D/gPZ0DwnYuv6YEdDxmWMFvEuOnPIy4EupKqJX
         9NVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JlHL5tJ/f7FTmiUmvcxN9wHROBLnGjfBtLf1fu0bbkI=;
        b=s2Gcq1ZaqQxm3VtqS6nm5xYxXsaVZ6JIiZXY6J5ZZLtWZc8pMv29lSh3SnVFsoqCMb
         B7PjTBf0pV6gwAEso+EuGu3Ca1QO7PTZ6WhgRBLt1jdm1T9BcQh6QWJx3KC84yvZN/3O
         5sQ6piwl1GCkhNVKb/8Jt0sKXC9P9rfAPVJSnAoTNjyVDwgKDS6yE+PXo0y+SkPwJWg4
         z0h6kvEUW3m4QB70qgy78q9BwfDiQcilmKgzQBsuVZ5anrEGP/rAzzcvj2lRDa9xCdj5
         7C0PSnwpHOXSqB/wrobwKJY4n7AW51ieqaiSrzqvnMZfkRqatdxq0cBG8R0y3oxMX3zu
         Dg5g==
X-Gm-Message-State: AJIora8werI+BLkVNOYrWYdiN/DshDS/qXfTrjjFCSfrYm9oNNKy5lno
        xMp8Ihg8JnS9q9QuJg4tIGp9TFaSiLxKQ2jK4FY=
X-Google-Smtp-Source: AGRyM1t511aDH8tPbGia5+vLJlleUXiGZ8NElgrQRQF2SE8Bl5rgnH1IhQo3j1VqWq06aB4uFwpr/+87L6W0ac3VfTE=
X-Received: by 2002:a17:90a:f8c2:b0:1ec:d690:a269 with SMTP id
 l2-20020a17090af8c200b001ecd690a269mr17574452pjd.190.1656358907841; Mon, 27
 Jun 2022 12:41:47 -0700 (PDT)
MIME-Version: 1.0
References: <1656050956-9762-1-git-send-email-quic_subashab@quicinc.com>
 <CANn89iJ_HBEkiU3ToAjcv_KHz3f77DJpycKcU=74X3rNst-V6g@mail.gmail.com>
 <YroEC3NV3d1yTnqi@pop-os.localdomain> <CANn89i+X4+w91MwZNW7qsb9dK3W0s72iehh5Kkb077ApTis_Vg@mail.gmail.com>
In-Reply-To: <CANn89i+X4+w91MwZNW7qsb9dK3W0s72iehh5Kkb077ApTis_Vg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 27 Jun 2022 12:41:36 -0700
Message-ID: <CAM_iQpXF4cvuMe3yM_G2Xzab_3Q_D1oUcfchaAZE6cYNcMoe9Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Print real skb addresses for all net events
To:     Eric Dumazet <edumazet@google.com>
Cc:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, quic_jzenner@quicinc.com,
        Cong Wang <cong.wang@bytedance.com>,
        Qitao Xu <qitao.xu@bytedance.com>,
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

On Mon, Jun 27, 2022 at 12:33 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Jun 27, 2022 at 9:25 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Fri, Jun 24, 2022 at 08:27:34AM +0200, Eric Dumazet wrote:
> > > On Fri, Jun 24, 2022 at 8:09 AM Subash Abhinov Kasiviswanathan
> > > <quic_subashab@quicinc.com> wrote:
> > > >
> > > > Commit 65875073eddd ("net: use %px to print skb address in trace_netif_receive_skb")
> > > > added support for printing the real addresses for the events using
> > > > net_dev_template.
> > > >
> > >
> > > It is not clear why the 'real address' is needed in trace events.
> >
> > Because hashed address is _further_ from being unique, we could even
> > observe same hashed addresses with a few manually injected packets.
> >
> > Real address is much better. Although definitely it can't guarantee
> > uniqueness, it is already the cheapest way to identify the packets in
> > tracing. (Surely you can add an ID generator or something similiar, but
> > nothing is cheaper than just using the real address.)
> >
> > >
> > > I would rather do the opposite.
> > >
> >
> > Strongly disagree. I will sent a revert.
> >
>
> Make sure to include lkml for this discussion :

Already did:
https://lore.kernel.org/all/CAM_iQpV3Qm_GTfCX1E_OC0PXu+diT9QHtPt4OYcJdyGRcA37Sw@mail.gmail.com/

>
> Vast majority (100%) of TP_printk() using %p use %p, not %px
>
> $ git grep -n TP_printk|grep %p|wc -l
> 425
> $ git grep -n TP_printk|grep %px|wc -l
> 0

You are changing this topic, no one here in this thread cares about non-skb
addresses.

Thanks.
