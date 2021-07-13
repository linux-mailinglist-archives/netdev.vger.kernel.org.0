Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD053C6866
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 04:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhGMCKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 22:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhGMCKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 22:10:19 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CEDC0613DD
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 19:07:30 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id dt7so8665661ejc.12
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 19:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a8tC+a4k2WUeHRHdrnaApl2aJ+B7VO4FmR54pyaKgnQ=;
        b=as09yhmLpXjRDj/yPDtbWQPJs6dxQCf8YXp4+nLeUzUnsPZhMKeUf0YdCi9FT4GhXP
         NmrouSWPxET9SxaEvv8KAW0syBt7IqLv4MRu4EO2wI3PWTSPjWmO82yqcnKXpMsb37l8
         PTvPx+vGYd4Q+PYbGyEB24wjGLIe4X22rMJy++fpAcqTRP7eyr5yQzX1fbsg9YvYE4Rf
         FxktgxWpQUq3eVq1crKRM8Y+Aa4rsVEBpyaOsFlzOmnJld+nRoHBgrff+HA2G4GMlzab
         3vK7dJVQPikj1wJOB2A5g9tuSkz+kX/XDO8hX+9chMQAkQuMhrJLrL1DCaOE+j+jE/xl
         R9fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a8tC+a4k2WUeHRHdrnaApl2aJ+B7VO4FmR54pyaKgnQ=;
        b=ue28k3k3Yq2BFxsSseJIu7zyKGJWOM6evw2+SxrTH/mT00DNTiGl2CXX0IQ+QSw+Hz
         /yMac2wyapUmshuugHz202xHxow7U9Xj3dx6bzQZxCMPJXLy0JbKWcmmk7V6fV0ZlV7e
         Z99de6OQt9ygNJTaeG+qzWY8OdIWt6L+KMyBuXxT32AorfKMhGd/3hk5Ng58C/DsQyd+
         fG4KD11698+D04lq3Y++8wpETa2KNFNgd6Ey/IzsB4bUr7DBdlQWbMt51GObJX+oRGQz
         +jgo0jbnC3PviRCaBOqTzHSpvwJ6yzwna5QMyYmECwnYFzTLKQwE/k4fD40lq3Z1Qr00
         6y2Q==
X-Gm-Message-State: AOAM531+kNRRDA7USbIx8Uwrm4nU1Rfw5x9ZXZoLU45otJCCKupR5/qJ
        Xg/BWAE5rO1MxKtMyH9RQUbWWe8oraUE34CLU9E=
X-Google-Smtp-Source: ABdhPJwKiIoGTR9Ry9loLgCBVaWReI/YxtGyWwLm99ftTDoGnLIhpsU5dro0drfI+cU432k2h/4teqdbvI9Xgsg3wAo=
X-Received: by 2002:a17:907:3f0c:: with SMTP id hq12mr2547354ejc.117.1626142048927;
 Mon, 12 Jul 2021 19:07:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210711050007.1200-1-xiangxia.m.yue@gmail.com>
 <20210711050007.1200-2-xiangxia.m.yue@gmail.com> <CAM_iQpUtQGDx6yJtY5sxYVd3wNqBSDYAZ4uHZonkFQDrnLo8cQ@mail.gmail.com>
 <CAMDZJNWfRQ_M=6E=jyOSKWMso73nNY1iKw4jyN8JU7NkSyDQcA@mail.gmail.com>
In-Reply-To: <CAMDZJNWfRQ_M=6E=jyOSKWMso73nNY1iKw4jyN8JU7NkSyDQcA@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 13 Jul 2021 10:06:52 +0800
Message-ID: <CAMDZJNVg0E3SevntjJVm99RdggSxD_oOX=3EXU1v-sQLgDGvNQ@mail.gmail.com>
Subject: Re: [net-next 2/2] qdisc: add tracepoint qdisc:qdisc_requeue for
 requeued SKBs
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 12:17 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Mon, Jul 12, 2021 at 11:51 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Sat, Jul 10, 2021 at 10:00 PM <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > The main purpose of this tracepoint is to monitor what,
> > > how many and why packets were requeued. The txq_state can
> > > be used for determining the reason for packets requeued.
> >
> > Hmm, how can I figure out the requeue is caused by
> > validate_xmit_skb_list() when it returns again==true?
Hi cong
Consider this patch again.
The main purpose of this tracepoint is to monitor what, how many and
why packets were requeued.
So should we figure out packets required by validate_xmit_skb_list or
dev_hard_start_xmit ?
because we may want to know what packets were requeued and how many.

if we should figure out, we can add more arg for trace, right ?
> > I fail to see you trace it.
> This patch looks not good.
> > For the other case, we can figure it out by trace_net_dev_xmit().
> > So, in short, your patch looks useless.
> >
> > Thanks.
>
>
>
> --
> Best regards, Tonghao



--
Best regards, Tonghao
