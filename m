Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EE021A7E3
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgGITh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgGIThZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:37:25 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CF5C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 12:37:25 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t4so3074301iln.1
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 12:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a1/16hM8/7lOdrIAsYt4AtbeDRQT0tdtg5Q7CbKDEhM=;
        b=TsbdrgTY2P+v1EPyTAu3FMpmNEQ57W3QoMNUsxDe7gnIlh+dUVE7w6jZZ69omwT+VQ
         CQMjOX1JwmmS0YLjAmgrj3cCVU9IawNAzhV3X4AJ/yRO0xD3XLT5fdQbtLHjO8Po7skf
         CaI+2t5jfVtt62gncLnPyRiS+m43ROwGOSN235d3STOHvcD6f8A1hY0l2t+MCil0AL8V
         Y4YQO2vrpaCaWbCkXDB8cEpLzJ6OKJ87pl4dLX9+glMMC66jiFFwKtI4WLvvynLOV/wU
         uYiVILII5NpLxTGxKtWgFbZA8Z8114oVpT/S3nLJfRO9UpyeA4adqhrZ8082Cb03Ljge
         3hMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a1/16hM8/7lOdrIAsYt4AtbeDRQT0tdtg5Q7CbKDEhM=;
        b=njSVs6pHLvgQxYJb2hBG0gJaEGxUqSAFYmQakgDIwYUeArG0w8dy1iGUpoAHytnv9h
         ZvPK1ELhRqAmkZ9tvrvIip+QbNXgE+cgRsaaq3Q2ZyKgZfR8VKoo/BOK2rleVcmoHx/e
         CBezFjV5FYSUH3BApfcfYVHn4u6Qy8IlvGN8JtOO4HJewuckSy+ugP4FvTRqvIgQXdYs
         K578erbPqLTgcewq4xADZkVaQ4HrYtom2hAQwccUjVODfbTBL4Uj20l5VMUkw7TPUTrn
         6/jULDzYhMrVT/inRR34Xqzu8UiBDFU8EqM5BlNdom+0FW6uHHyx86VXIiNb/KYLnibq
         P0Ow==
X-Gm-Message-State: AOAM533liTo2UVv4vD2kI5F9N+AUyzoOHcFbAEesvwbWWALFJ4XumYvo
        RESA/U/OgxJHJ74W8QlmuBhwH1AxQVO9xmZw6ps=
X-Google-Smtp-Source: ABdhPJz0p0xmClOjRSiUTQsD0dJLldNso4O1mrMi3nP694bLp5yde/WWozivsDFhHCJVhcuMIL1i7aSZU1+p8ZGBA7w=
X-Received: by 2002:a92:5857:: with SMTP id m84mr47871925ilb.144.1594323445119;
 Thu, 09 Jul 2020 12:37:25 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593209494.git.petrm@mellanox.com> <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com>
 <CAM_iQpXvwPGz=kKBFKQAkoJ0hwijC9M03SV9arC++gYBAU5VKw@mail.gmail.com>
 <87a70bic3n.fsf@mellanox.com> <CAM_iQpWjod0oLew-jSN+KUXkoPYkJYWyePHsvLyW4f2JbYQFRw@mail.gmail.com>
 <873662i3rc.fsf@mellanox.com> <CAM_iQpVs_OEBw54qMhn7Tx6_YAGh5PMSApj=RrO0j6ThSXpkcg@mail.gmail.com>
 <87wo3dhg63.fsf@mellanox.com> <87v9ixh7es.fsf@mellanox.com>
In-Reply-To: <87v9ixh7es.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 9 Jul 2020 12:37:13 -0700
Message-ID: <CAM_iQpU-fh9Saaxo+6juONn+Xd891sUhgaaoht0Bkn2ssAEm8A@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/5] net: sched: Introduce helpers for qevent blocks
To:     Petr Machata <petrm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 5:13 PM Petr Machata <petrm@mellanox.com> wrote:
>
>
> Petr Machata <petrm@mellanox.com> writes:
>
> > Cong Wang <xiyou.wangcong@gmail.com> writes:
> >
> > I'll think about it some more. For now I will at least fix the lack of
> > locking.
>
> I guess I could store smp_processor_id() that acquired the lock in
> struct qdisc_skb_head. Do a trylock instead of lock, and on fail check
> the stored value. I'll need to be careful about the race between
> unsuccessful trylock and the test, and about making sure CPU ID doesn't
> change after it is read. I'll probe this tomorrow.

Like __netif_tx_lock(), right? Seems doable.

Thanks.
