Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9A640990A
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 18:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237273AbhIMQ2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 12:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhIMQ2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 12:28:24 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF15C061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 09:27:08 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id c6so21685486ybm.10
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 09:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dCljwccdQFwVFy93OqtVIKp3PZCDT/ADvJ86wXMBB1c=;
        b=qVzntkI8ty7TzZwssmW70rJfJG5dO830VxZRRdhP0PMesxf0cxhOS6BKeHeoSQZcXY
         ucXtZh2XKH52rRh+oML3toVHEWo3pPfNgy54xdw3DNgQsRtzyrXJFaGCIK/0GG2ONGBH
         AgTAem/Pe8z1CioKikN7gLqb91CSDjE7gEhhVAB/AryYavXNAUftiFIR6Wz4vYMj86zW
         3X8mb7xdnL3CBpMdDM/kEu5XAIJRGewznJ3d9A91R/DBQATtDhb6AjtphuR2BaZUOPF4
         a9ZxuldSe62SqjCsa2uqdTLNyViN3odKWmq31eDHbYvNt2P+JPMqi2i5G0d48LqtRed3
         BBlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dCljwccdQFwVFy93OqtVIKp3PZCDT/ADvJ86wXMBB1c=;
        b=cANyw4kKa2PheL1OlRzE3kCCYN5GoB1NubkiYXTkLzP6tDstRhm6tTP2Izw2e6YKq4
         XwE0DRxpAAKq+bhPpaPLiGguPpetzezfu6UMVKgEnk9GRqAq1H3bqZcZTfBSDN1Vah72
         0encUEmIwbnp4nTnB3j9r2bZaCg+sPsjPWG2jcsu+R5T0ofCibNLLHljXzZxoUziKSl7
         wdp5ch4HB+r3n6Svr7yo6JMtncbf7wscZiksQa4cS7d6PdfpLeZKQvkn5bglJU06GG7K
         nr8V6S4xc99NUqfA9Gxt0DWFXKx9RIRgCpLBIB5XWwMCKOqwNSjRtqJ1TnftTNLGnNJ+
         qsqA==
X-Gm-Message-State: AOAM531AlBt5G0/ahq7R9MUCwXYepffoDg4AKp617t5CX49EkJg3oHIg
        qYecsb/v8/KZtucH3W8lV9I0mExas5q4zxUb6TOS0Q==
X-Google-Smtp-Source: ABdhPJz27MKbWIWOFZuyc0cuHlwNoQfGdaFHQcK7JtxZ3RlsQ5t4Byfn2DRfdHGxQOyKT9AagntMY5b47icO48wTVz0=
X-Received: by 2002:a25:c011:: with SMTP id c17mr15408711ybf.291.1631550427500;
 Mon, 13 Sep 2021 09:27:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210913130034.103362-1-yan2228598786@gmail.com>
In-Reply-To: <20210913130034.103362-1-yan2228598786@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 13 Sep 2021 09:26:56 -0700
Message-ID: <CANn89i+EvheAER7uHvacU0=DRsQoXkCi3P9_v0VXoTkZU7K2TA@mail.gmail.com>
Subject: Re: [PATCH] net: tcp_drop adds `reason` v5
To:     Zhongya Yan <yan2228598786@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Yonghong Song <yhs@fb.com>,
        2228598786@qq.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 6:01 AM Zhongya Yan <yan2228598786@gmail.com> wrote:
>
> Description information in the reason field of tcp_drop, "Tcp" is changed to "TCP"
> Feel free to suggest changes
>

This is a cryptic changelog.
Have you forgotten to copy/paste important information ?

We would like something that explains what the patch is about, and
eventually how to use the new functionality.

Do not assume future readers of linux TCP stack will have instant
access to all your prior versions

Also patch is about tcp,  net: prefix in patch title should be tcp:

Thanks.
