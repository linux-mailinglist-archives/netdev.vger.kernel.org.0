Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9081A6AB56
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 17:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387977AbfGPPE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 11:04:59 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41359 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728513AbfGPPE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 11:04:59 -0400
Received: by mail-ed1-f68.google.com with SMTP id p15so20521097eds.8;
        Tue, 16 Jul 2019 08:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rLKY158y7o9w0mksAJ+3djh07wVS+19os39rfVhg5lg=;
        b=J/O/qFcuyIvs6g/T4tYkcPanE4wXRHutSu7Cz2V3e0tuGetbFqGJgzdVQciBkvoCjD
         W9si1HT8ydCMwlpeql2StLdH1Bbsl6B4u6aguIf27YBBOCuhWP79vGaxUS/BimHgardh
         TJjXzRt8tdlynwNo5tmpRpstDTlg7f5UyA77zOxIzNWFE7eIp31gwHu8wNh2lK2RfHzF
         RXh1kShvcwBpOGKjXoma6xoGUDqiXN92GfLcAjcTCa/1rQaRUWCdmrBYR9F5qbXG1i+/
         4nP84yFQEBCzOyp4OV8l1bRRHB39HoGXNxEaYriBBYnyjZQJmVUGHUyz4n9wREGOdlMy
         J9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rLKY158y7o9w0mksAJ+3djh07wVS+19os39rfVhg5lg=;
        b=YlOuDDf3b+wZfu4CFgfWMTTxRbEgGPwjY/7yBBTwjlpKsutmM+PgH/ytmApM2YPlb2
         KsGK52ccOIpRWGn3PiPAiHSj/7ZbwnvWkcN3VY3HQcWn+ULBbyIIH42vpu3o+SOZpq6e
         riEpDJW3gAAUwiZ/6me9Jt4TzqXsCH1g9VdKDHIpsChSTuw/3dR7ccMWN9wXiKpGLuVE
         69yTfIJxCGIWETaQM5dtAtbVwfX4ko201ta6GUWQ+z2tYs3aQ/P1M+FyP+gAODmqxcCk
         ACc11l8pvDTS6lO0fPkdkn+sAwq/smxEUSpRzg6eT2/Zn4lbeylEK/JOj6WTLUUGDOh9
         Gx0Q==
X-Gm-Message-State: APjAAAXpIxZkUMHlX8BzyU8MYJljwpAXFvHuIY0D0ygsmaeHB8QvI66W
        Ws4gRLwXCpRxpMqiXa807o01gFoJI/UGBRTTHsc=
X-Google-Smtp-Source: APXvYqz/bxWcm/h7JRe26DoT0RVddByJPiMQ5+4n35GneGsifipYzAOgkR7VE2fbyqNRGuZASkHFaUgQ+vauKMSvNwA=
X-Received: by 2002:aa7:d30b:: with SMTP id p11mr30420633edq.23.1563289497311;
 Tue, 16 Jul 2019 08:04:57 -0700 (PDT)
MIME-Version: 1.0
References: <1563288840-1913-1-git-send-email-cai@lca.pw>
In-Reply-To: <1563288840-1913-1-git-send-email-cai@lca.pw>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 16 Jul 2019 17:04:19 +0200
Message-ID: <CAF=yD-KW-XnDvD0i8VbzrkLGNWEY6cPoaEcHy40hbghGXTo+kA@mail.gmail.com>
Subject: Re: [PATCH] skbuff: fix compilation warnings in skb_dump()
To:     Qian Cai <cai@lca.pw>
Cc:     David Miller <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        clang-built-linux@googlegroups.com,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 4:56 PM Qian Cai <cai@lca.pw> wrote:
>
> The commit 6413139dfc64 ("skbuff: increase verbosity when dumping skb
> data") introduced a few compilation warnings.
>
> net/core/skbuff.c:766:32: warning: format specifies type 'unsigned
> short' but the argument has type 'unsigned int' [-Wformat]
>                        level, sk->sk_family, sk->sk_type,
> sk->sk_protocol);
>                                              ^~~~~~~~~~~
> net/core/skbuff.c:766:45: warning: format specifies type 'unsigned
> short' but the argument has type 'unsigned int' [-Wformat]
>                        level, sk->sk_family, sk->sk_type,
> sk->sk_protocol);
> ^~~~~~~~~~~~~~~

Ah, I looked at sk_family (skc_family), which is type unsigned short.

But sk_type and sk_protocol are defined as

 unsigned int            sk_padding : 1,
                                sk_kern_sock : 1,
                                sk_no_check_tx : 1,
                                sk_no_check_rx : 1,
                                sk_userlocks : 4,
                                sk_protocol  : 8,
                                sk_type      : 16;

So %u is indeed needed instead of %hu.

> Fix them by using the proper types, and also fix some checkpatch
> warnings by using pr_info().
>
> WARNING: printk() should include KERN_<LEVEL> facility level
> +               printk("%ssk family=%hu type=%u proto=%u\n",

Converting printk to pr_info lowers all levels to KERN_INFO.

skb_dump takes an explicit parameter level to be able to log at
KERN_ERR or KERN_WARNING

I would like to avoid those checkpatch warnings, but this is not the
right approach.

> Fixes: 6413139dfc64 ("skbuff: increase verbosity when dumping skb data")

Thanks. For a v2, please mark the target branch, as [PATCH net v2].
