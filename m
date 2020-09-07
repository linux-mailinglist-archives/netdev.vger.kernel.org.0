Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CAF25F6BE
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 11:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgIGJlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 05:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbgIGJlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 05:41:04 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B50C061574
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 02:41:04 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id h23so3165423vkn.4
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 02:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kIca8443CSDJzX13RTZ2oe86ZVBDa2TpFg9gh5GtOMQ=;
        b=jXYL2Lf+6eb68KLQm+cL4NheEBa+kW2UpNKYu+eQvw+3tni/khjNr1BTmBumm+tYym
         C7ACwYKo+EcWURxBCrQI12QXdwfLnGbTuZdVhw5FvGfhxHKVQOhrGAb49Kolav/3k/8e
         gS0IYolGS08Gu8ZRD3MV+T8yyAhjzJWN3XNTiI+v1t8PDMiB65WyCSWCN+nU88v9AAx5
         nRjlMJfJ3d2EeeIA4mDcf3/Cg4axtshp/nu0iTeTALxRk29wEBVV+5u8VTP2uGc1ev+C
         85lz8p1UbU3o8o/Rgr4fFyb39x/j4mp9JSo/3Z43NqcOxuCo5Ti8b5Zd2aLERJbwZwTi
         lBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kIca8443CSDJzX13RTZ2oe86ZVBDa2TpFg9gh5GtOMQ=;
        b=m4oGjyjRjCNexOknfVKEnkhr2DtHLzRLtKqjUUHMuFcYnIfzMcKr2PvCEg0HeYjfT8
         77E059/UT6u50R7Re/jZMilyo2nYk4U3P8sBd7UfaLRVBlTIOR2h7VLJuSkAzGb/9f03
         4to6yqFvvcd3umflCtiU4iVLbZPUQOuPAS4Nn2ME+wPs8hHVK6fDdzDRzwa7LhgL8jzl
         MRvyD+b8aS5gsGsRa2b4Hz8jx1lEvZqf3mrRVweECS2H4sPZovIu2EccS3rlUocghMoH
         JNPP0lWZ7QXWelOPNUvrCehB6iCc8bBR/XcT8xYPAn9g/hGrvSA67o3QxrnWhV5XGwV3
         W5Qg==
X-Gm-Message-State: AOAM533rHJEsXWZKWlyo96QePE4uG2c9fzAL0PYyWRqbCSkSEyzn4DoU
        5GCkSxGlCQKWpRE979/PeC+N4DVxGUshoQ==
X-Google-Smtp-Source: ABdhPJwMXukxihEu0daDqdLaypBsrS7uZao7YzMYM4dCLD9YZyUqjHfjmmrmENndi9/9pL5N8YJJ1w==
X-Received: by 2002:a1f:c805:: with SMTP id y5mr11631882vkf.0.1599471661877;
        Mon, 07 Sep 2020 02:41:01 -0700 (PDT)
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com. [209.85.222.54])
        by smtp.gmail.com with ESMTPSA id b205sm2355484vkf.54.2020.09.07.02.41.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 02:41:01 -0700 (PDT)
Received: by mail-ua1-f54.google.com with SMTP id v24so3991915uaj.7
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 02:41:00 -0700 (PDT)
X-Received: by 2002:ab0:2404:: with SMTP id f4mr10667066uan.108.1599471660425;
 Mon, 07 Sep 2020 02:41:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200906031827.16819-1-xie.he.0141@gmail.com>
In-Reply-To: <20200906031827.16819-1-xie.he.0141@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 7 Sep 2020 11:40:21 +0200
X-Gmail-Original-Message-ID: <CA+FuTSfOeMB7Wv1t12VCTOqPYcTLq2WKdG4AJUO=gxotVRZiQw@mail.gmail.com>
Message-ID: <CA+FuTSfOeMB7Wv1t12VCTOqPYcTLq2WKdG4AJUO=gxotVRZiQw@mail.gmail.com>
Subject: Re: [PATCH net] net/packet: Fix a comment about hard_header_len and
 headroom allocation
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Ogness <john.ogness@linutronix.de>,
        Mao Wenan <maowenan@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Or Cohen <orcohen@paloaltonetworks.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 6, 2020 at 5:18 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> This comment is outdated and no longer reflects the actual implementation
> of af_packet.c.

If it was previously true, can you point to a commit that changes the behavior?

>
> Reasons for the new comment:
>
> 1.
>
> In this file, the function packet_snd first reserves a headroom of
> length (dev->hard_header_len + dev->needed_headroom).
> Then if the socket is a SOCK_DGRAM socket, it calls dev_hard_header,
> which calls dev->header_ops->create, to create the link layer header.
> If the socket is a SOCK_RAW socket, it "un-reserves" a headroom of
> length (dev->hard_header_len), and checks if the user has provided a
> header of length (dev->hard_header_len) (in dev_validate_header).

Not entirely, a header greater than dev->min_header_len that passes
dev_validate_header.

> This shows the developers of af_packet.c expect hard_header_len to
> be consistent with header_ops.
>
> 2.
>
> In this file, the function packet_sendmsg_spkt has a FIXME comment.
> That comment states that prepending an LL header internally in a driver
> is considered a bug. I believe this bug can be fixed by setting
> hard_header_len to 0, making the internal header completely invisible
> to af_packet.c (and requesting the headroom in needed_headroom instead).

Ack.

> 3.
>
> There is a commit for a WiFi driver:
> commit 9454f7a895b8 ("mwifiex: set needed_headroom, not hard_header_len")
> According to the discussion about it at:
>   https://patchwork.kernel.org/patch/11407493/
> The author tried to set the WiFi driver's hard_header_len to the Ethernet
> header length, and request additional header space internally needed by
> setting needed_headroom. This means this usage is already adopted by
> driver developers.
>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Brian Norris <briannorris@chromium.org>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  net/packet/af_packet.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 2b33e977a905..c808c76efa71 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -93,12 +93,15 @@
>
>  /*
>     Assumptions:
> -   - if device has no dev->hard_header routine, it adds and removes ll header
> -     inside itself. In this case ll header is invisible outside of device,
> -     but higher levels still should reserve dev->hard_header_len.
> -     Some devices are enough clever to reallocate skb, when header
> -     will not fit to reserved space (tunnel), another ones are silly
> -     (PPP).
> +   - If the device has no dev->header_ops, there is no LL header visible
> +     outside of the device. In this case, its hard_header_len should be 0.

Such a constraint is more robustly captured with a compile time
BUILD_BUG_ON check. Please do add a comment that summarizes why the
invariant holds.

More about the older comment, but if reusing: it's not entirely clear
to me what "outside of the device" means. The upper layers that
receive data from the device and send data to it, including
packet_snd, I suppose? Not the lower layers, clearly. Maybe that can
be more specific.

> +     The device may prepend its own header internally. In this case, its
> +     needed_headroom should be set to the space needed for it to add its
> +     internal header.
> +     For example, a WiFi driver pretending to be an Ethernet driver should
> +     set its hard_header_len to be the Ethernet header length, and set its
> +     needed_headroom to be (the real WiFi header length - the fake Ethernet
> +     header length).
>     - packet socket receives packets with pulled ll header,
>       so that SOCK_RAW should push it back.
>
> --
> 2.25.1
>
