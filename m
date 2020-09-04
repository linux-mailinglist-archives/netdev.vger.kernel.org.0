Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB9D25D999
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbgIDN14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730304AbgIDN1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 09:27:13 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03412C061246
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 06:27:06 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id e41so1988134uad.6
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 06:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EcvtgMkqtV+QMekKVdpR7+VGa/x86DjVYJCvIcGjyK8=;
        b=n6QTs08VggzC4TRruzKbItvKGOXVLpbSHGflONYffbYUuhXodFEZk5rF2ce4lJVCXf
         G/jZYiUQij/ybyYI7bQq22YLon4jSFDP5yI0O/J6OCCXtXh8xugcnhAJL5AXEPEY7i9d
         wa6m2CbLmR2x1kqwCOezY7lUGIPtejJ2i6AzkpMb5wGrYJuwWbSqnOFbiT2iOIKdVPab
         IdXRhxQBEzVvvJfGJNRGlw5fTGQmiw4rel47Vz7ph4VKhOfM0m8KzYBmJ5gEOHiiW+5g
         q1s6x3oOQduGCeCPapiRP+y3UfC1IuNOsIM2t0SzVzcD/MlpLtKoSFyFsLC5HaX52JuJ
         creg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EcvtgMkqtV+QMekKVdpR7+VGa/x86DjVYJCvIcGjyK8=;
        b=fyox3BAU5LhoCMs8EJzlNI3uXyx8KYfFg5cGepGyywgMCLiPiZfyl86AnZCXIvbVqq
         4VR21UkcVqbV+73O4VE5gISl63mO7yvOvt2tWC2r/uoJIXEYLAobEhve20BhrsgoT6fA
         EN4UATDc0fLevZWgiGXKabLgxteb7fAKyszuTXSzeGEtr/vDiCa18e8lmmpKvWDDkp3H
         LQcgN7xN+8smCNnx5wKJQtnjiQHQn6/FMZ8Vn3WUmrWhhOQfB0bRXUeW3fcQLsx4aS+u
         MC7SAAjpQqB16hy4qNW464BNPWe1wv8uyImDWMZ7prMBYe0D6tD09JkTj4wIfzllI6RY
         BA4Q==
X-Gm-Message-State: AOAM531xMC0madP5qhJMAcf82nMbofYaUjRXsIOpGOgdXWWrN7yvyByz
        UfU1WDatn7CD99hgGi7kq+BYPT4dumB1Bg==
X-Google-Smtp-Source: ABdhPJxcVr7oxXDPQYbLv9u0llG1G/Is1iCYdquZR4CgORcEHy82wRfZBeY+zwAxAQEmLfae6fXuCQ==
X-Received: by 2002:ab0:108:: with SMTP id 8mr4579801uak.25.1599226016217;
        Fri, 04 Sep 2020 06:26:56 -0700 (PDT)
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com. [209.85.222.44])
        by smtp.gmail.com with ESMTPSA id w69sm1004994vkd.23.2020.09.04.06.26.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 06:26:55 -0700 (PDT)
Received: by mail-ua1-f44.google.com with SMTP id i22so1422224uat.8
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 06:26:54 -0700 (PDT)
X-Received: by 2002:ab0:2404:: with SMTP id f4mr4707114uan.108.1599226014262;
 Fri, 04 Sep 2020 06:26:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200904130608.19869-1-wanghai38@huawei.com>
In-Reply-To: <20200904130608.19869-1-wanghai38@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 4 Sep 2020 15:26:18 +0200
X-Gmail-Original-Message-ID: <CA+FuTSfMO4YPGp88HYRPWwRUCg79SVyYicOowCH9oJkKPtmdLA@mail.gmail.com>
Message-ID: <CA+FuTSfMO4YPGp88HYRPWwRUCg79SVyYicOowCH9oJkKPtmdLA@mail.gmail.com>
Subject: Re: [PATCH net-next] net/packet: Remove unused macro BLOCK_PRIV
To:     Wang Hai <wanghai38@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Ogness <john.ogness@linutronix.de>,
        Mao Wenan <maowenan@huawei.com>, jrosen@cisco.com,
        Arnd Bergmann <arnd@arndb.de>,
        Colin King <colin.king@canonical.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 3:09 PM Wang Hai <wanghai38@huawei.com> wrote:
>
> BPDU_TYPE_TCN is never used after it was introduced.
> So better to remove it.

This comment does not cover the patch contents. Otherwise the patch
looks good to me.

> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  net/packet/af_packet.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index da8254e680f9..c430672c6a67 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -177,7 +177,6 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
>  #define BLOCK_LEN(x)           ((x)->hdr.bh1.blk_len)
>  #define BLOCK_SNUM(x)          ((x)->hdr.bh1.seq_num)
>  #define BLOCK_O2PRIV(x)        ((x)->offset_to_priv)
> -#define BLOCK_PRIV(x)          ((void *)((char *)(x) + BLOCK_O2PRIV(x)))
>
>  struct packet_sock;
>  static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
> --
> 2.17.1
>
