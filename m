Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7BE93C42D3
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 06:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhGLEVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 00:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhGLEVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 00:21:15 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35895C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 21:18:27 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id go30so4786073ejc.8
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 21:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wch4ogmoRir2iW4GNTb1XcG6qhjlMSCAArvFTJAulaw=;
        b=k23GUR4y5/Cg+LCw/O2siv/JiRi8tjKYlxQKmE6p3gsVf1/8zQsnuPrZvx+MX7yKfJ
         MEfRmyynSc6/FXTehBQEMlwCtxnpdy/4KAd/SZ9grnoRiH4ucir3B8X+7auxNx3kBcFn
         mlPqhtRonzeYpb33eLKq7XFgG+PFWgH27oDKvBPtJCCtvz6r88rtyoNrA05FCnWXojn6
         GdtD1WCG8WSLf6YAR6AJcnbNqHGCnmOuyUQ8UVPv/5Hhchm5X2diDfspdQaI0ALrNS4/
         HTQ37raJigBE37vIW0CExWEpCWh8VkWCCRLgQJ8qp48OQRMM6PXd5MsyKLXOJwORWw2M
         wo9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wch4ogmoRir2iW4GNTb1XcG6qhjlMSCAArvFTJAulaw=;
        b=CLnAI1HSvBn2H0R5EU2BeC225gUU7L8obgepUhR7FeDfMbOyBlsJ4lapLa/Y1mf3fD
         le99GermpcHzFiuVK4DoujtOQsxZGj+RM+ccvZ7HbFv2sUW/RUnwgEf22zW5vV8tIlzE
         Q2sH3Eqc9JYwgtuCx2SwcVcA3o14N5EqUxsCwjcm1JMD+qrZvch5BAVkpzM8w551oSUu
         YWwwWano+PTNKVgivdO2vVTTfOLYt24V2Ml8p7ri1G51Utdwv33ANpvi5lWsv5k/KPv9
         L7qcaRc7Cg0bs58HEMqRt9z+5oX+Hs++0KqRZAC407mo7Yi8le8WRxH6Qu2TjBLpGq06
         3Dkg==
X-Gm-Message-State: AOAM531/E5HRu+l21OMBZSib5+teNAk2hzlFzOxeKqouGdHTJ6akLmNc
        D4k/3/XVBmrEpKUIi1Yf/0flXWeQtwegX0+FtbE=
X-Google-Smtp-Source: ABdhPJy61wTNwY8RT56gezLQHBKypXDWloPWbxBxLb8+hzAd7zanj1Ci42YxghxnSKmLoOq/QxxPMTEDafZYggeIoVc=
X-Received: by 2002:a17:907:7293:: with SMTP id dt19mr10938718ejc.122.1626063505890;
 Sun, 11 Jul 2021 21:18:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210711050007.1200-1-xiangxia.m.yue@gmail.com>
 <20210711050007.1200-2-xiangxia.m.yue@gmail.com> <CAM_iQpUtQGDx6yJtY5sxYVd3wNqBSDYAZ4uHZonkFQDrnLo8cQ@mail.gmail.com>
In-Reply-To: <CAM_iQpUtQGDx6yJtY5sxYVd3wNqBSDYAZ4uHZonkFQDrnLo8cQ@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 12 Jul 2021 12:17:49 +0800
Message-ID: <CAMDZJNWfRQ_M=6E=jyOSKWMso73nNY1iKw4jyN8JU7NkSyDQcA@mail.gmail.com>
Subject: Re: [net-next 2/2] qdisc: add tracepoint qdisc:qdisc_requeue for
 requeued SKBs
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 11:51 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sat, Jul 10, 2021 at 10:00 PM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > The main purpose of this tracepoint is to monitor what,
> > how many and why packets were requeued. The txq_state can
> > be used for determining the reason for packets requeued.
>
> Hmm, how can I figure out the requeue is caused by
> validate_xmit_skb_list() when it returns again==true?
> I fail to see you trace it.
This patch looks not good.
> For the other case, we can figure it out by trace_net_dev_xmit().
> So, in short, your patch looks useless.
>
> Thanks.



--
Best regards, Tonghao
