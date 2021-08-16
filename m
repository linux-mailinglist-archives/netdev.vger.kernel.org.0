Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CC93ED90F
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 16:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhHPOn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 10:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhHPOjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 10:39:52 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B77C061764;
        Mon, 16 Aug 2021 07:39:20 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id d5so4991947qtd.3;
        Mon, 16 Aug 2021 07:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qmlXMatWSYYRVrk+FklMkfhLPVeb/cB811pl9zDJ0Hw=;
        b=viBpZPu/7MsqC1I8Iw17SqiDARudLf+rBYxHhn2vnJBnKGkRs8einnxcmbj5PjVyz3
         HD7L6S4cfRGNr/05vLUwz7bvPvdnbsI23AwFLlsTJW088/AdjOjplsJ6JcytAHaloe65
         9dfriMgy1r+Xzp4L8S88fnw6AdrClMAsBFsie00AhsLKfrEPXrdDhLrjsc9rZmme+flS
         OFyGr4vqdi0IX3IoGip3GGzijG2L5v9i+HWygt2V/68b4RapCF0jXnertppJqNtsqSqo
         a2CqPfrehhZZb2i5nhWDwVGHNod8Ch/OExlXyBt6iisqDkXABlH+GmDHXurXyRocd1B0
         +nlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qmlXMatWSYYRVrk+FklMkfhLPVeb/cB811pl9zDJ0Hw=;
        b=IfeP9llGWKtHBW8cOAOGP3/KxVQVMZOnjOqgwjdM4RlskfGc1eF0VLSBqfdZkxssoM
         p1i+5P+K0jdFS6O5aVGp2X6ncOaemc7gPxL/r89P2+oepDDaKq9zPb0Vk6/UyD8JhPkl
         ulM05ChmSSUFb2UqiUbGV5WOVyyRL+ki+Jj7tTqyHNyhqk3qeQXV0MlDxy9LwrKH/l6p
         Ofbg1vDWU6TCunAHkd0pBdw2AsbVF/d3fQljaIwxMtOUqzZwdRcDk4PxqSAF9OP9oAyB
         B4aafF2gGJVih/3V2CRRpdNzHeXghzY8Li85vFP0YJJsZyp/ETUWgXHeAxbuXXmlgNK3
         of4g==
X-Gm-Message-State: AOAM532zws2WmMR/n4FlQWiZFF5TCOZU2oA4BQgCvStuosvU9P3yT7SV
        K1MxE8c6nVEcy+2GNuCYfK4Y+rcnBkjKGe0+x2c=
X-Google-Smtp-Source: ABdhPJw6qslwCXrPWWfHr57jZxjB0JbMoVqC/nFCS0vK5z8ngIjZmScq7v+RK+HvLZxSfARd3qRTmCmrDsGtGsW7LNE=
X-Received: by 2002:ac8:5702:: with SMTP id 2mr13921322qtw.65.1629124759754;
 Mon, 16 Aug 2021 07:39:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210811154557.6935-1-minhquangbui99@gmail.com>
In-Reply-To: <20210811154557.6935-1-minhquangbui99@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 16 Aug 2021 07:38:40 -0700
Message-ID: <CAF=yD-LnDSzFFz6B8o84B1OSxTQE9p=LyFoAe_7+-k7q_r0yog@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] udp: UDP socket send queue repair
To:     Bui Quang Minh <minhquangbui99@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrei Vagin <avagin@gmail.com>, alexander@mihalicyn.com,
        Lese Doru Calin <lesedorucalin01@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 8:48 AM Bui Quang Minh <minhquangbui99@gmail.com> wrote:
>
> In this patch, I implement UDP_REPAIR sockoption and a new path in
> udp_recvmsg for dumping the corked packet in UDP socket's send queue.
>
> A userspace program can use recvmsg syscall to get the packet's data and
> the msg_name information of the packet. Currently, other related
> information in inet_cork that are set in cmsg are not dumped.

[ intended to include in my previous response ]

What other related information? Fields like transmit_time and gso_size?

This would be another reason to prefer dropping the packet over trying
to restore it incompletely.
