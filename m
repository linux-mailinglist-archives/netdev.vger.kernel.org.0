Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B94921915F
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgGHUYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgGHUYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 16:24:17 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE00CC061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 13:24:15 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id o3so85244ilo.12
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 13:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7T7Nj+4QXcAAhJUtEkG7hf269T9F8N3wdWgzQjY+ccE=;
        b=btA5Rt0wI1m3fiYcnt0Rhss8yZ5Eg/lqEzrzD+qkM82hdTP8OgSSlfXeHAJ/adu6UR
         7weDg9Vp/UZ4jlrLYShPPxoECcKN2SteBdbEeNM8dZGE3brVdsGK8VgLivoKhF1/D0Xo
         MD3txsjprJftihtEIFjPrmHHdr9wnzJ9RnJNxX9bD4INu66o4TuEDBCwfGqmXrkfECPN
         lNqxK6UUQcnNyDhuCn0U5O2gHMPjyc67oL0nDhXEHqrakYULR8V48dzaFnZAbr2TggX5
         NH2uTyRETj7x5j8O4qvp8gcQ+JSs6QnyE41m7AGI0SVc2UyJMIiOkiFAAmT1aq65x9Xw
         sfDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7T7Nj+4QXcAAhJUtEkG7hf269T9F8N3wdWgzQjY+ccE=;
        b=bgER4Cni3+atlYYdUBoPg4G0OqCyt4qJqb5GjzVI7FMjrw4kFDk1ROof89UIFQwHOv
         AKDloWGagX688zQ7Co5uPpbu7VVQqZdPuQTiJ6QBr6O6qSyz92r3oZGQSPZS70tVh7Rm
         fpI9dDjxANAbfo1oGyzdmSgeUs3C7Z5fTjN9qi5Y4I3tnYOoO6tizV6f3cD7owp9oYEi
         w9kMr12zae1ex/ByJVkkm4V4Bjz1argkHwtntpDlhR4f7udm2lpEucG01dMdXOYtPlZ6
         UH6THsyvaOVZu0iFfN+GeFrm3NyY3nrBk8UtQLoy0oopqJ+fu+fSxw1dsrT7yJPtPz3Z
         9V9g==
X-Gm-Message-State: AOAM530MMNwZkDjn8KxCvYbDB0JG4XBcwu9plwiHAVZZ7RVXwu7Jp8rD
        kz9rS93FSu1+YFyP2/x09CmsiMrPfDNCdYrHbVbjgAPh
X-Google-Smtp-Source: ABdhPJyQuINqALuNMhUmlpWXwrcHQvPOco/0K4/BcNH+F2+8Wju2Fus8Py6DcY7jcc2Z0VrQhkrSuO5ERWI4/RH14SQ=
X-Received: by 2002:a05:6e02:147:: with SMTP id j7mr43357564ilr.22.1594239855258;
 Wed, 08 Jul 2020 13:24:15 -0700 (PDT)
MIME-Version: 1.0
References: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
 <CAM_iQpVux85OXH-oYeH15sYTb=kEj0o7uu9ug9PeTesHzXk_gQ@mail.gmail.com>
 <5c963736-2a83-b658-2a9d-485d0876c03f@alibaba-inc.com> <CAM_iQpV5LRU-JxfLETsdNqh75wv3vWyCsxiTTgC392HvTxa9CQ@mail.gmail.com>
 <ad662f0b-c4ab-01c0-57e1-45ddd7325e66@alibaba-inc.com>
In-Reply-To: <ad662f0b-c4ab-01c0-57e1-45ddd7325e66@alibaba-inc.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 8 Jul 2020 13:24:04 -0700
Message-ID: <CAM_iQpUE658hhk8n9j+T5Qfm4Vj7Zfzw08EECh8CF8QW0GLW_g@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: sched: Lockless Token Bucket (LTB) Qdisc
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 2:24 PM YU, Xiangning
<xiangning.yu@alibaba-inc.com> wrote:
>
> The key is to avoid classifying packets from a same flow into different c=
lasses. So we use socket priority to classify packets. It's always going to=
 be correctly classified.
>
> Not sure what do you mean by default configuration. But we create a shado=
w class when the qdisc is created. Before any other classes are created, al=
l packets from any flow will be classified to this same shadow class, there=
 won't be any incorrect classified packets either.

By "default configuration" I mean no additional configuration on top
of qdisc creation. If you have to rely on additional TC filters to
do the classification, it could be problematic. Same for setting
skb priority, right?

Also, you use a default class, this means all unclassified packets
share the same class, and a flow falls into this class could be still
out-of-order, right?

Thanks.
