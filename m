Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9D925AD3A
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 16:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgIBOeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 10:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbgIBOdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 10:33:54 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D18CC061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 07:33:54 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id b123so2648771vsd.10
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 07:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GTgJ8jRvYHfsaCYMvrvH0r8WVjN4146hJg98Kfc6e3E=;
        b=GqX9sYheDnvfIvKTFK/YljPYXr+3kQcZ5oeuEyfjrmPv9ynxsoVZe1l347TGAbC+Rp
         rEvI0xz61c68O22SRUFr+GZTyhQ+UdS7P+IDlWIamL7aM5WBSJmp8LD3ICvXd6fYhJOj
         21cSc2kz+u10AgNpfA9qcMnUMYrAYW86iQI6sUoPi7zjVTcTR2jigazQAZ25eq21E/WF
         mjDqeDGhHfwiALlh1OkrVcNqZMcpZOqRDelWt04/+Em4OXmFpgWfbFaT1nKFsS6o8CXX
         F7DQO15/wvL/9NZF7GjQ4HKldIVHxa7y2XhS3m6tk3zyNHM3vlL5gkmrgOhY1ubPQYu4
         nKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GTgJ8jRvYHfsaCYMvrvH0r8WVjN4146hJg98Kfc6e3E=;
        b=SK0Aab71TPE3HBybevRUjGQ/vdVBRDB70NHS2ZVxak4JYaOe9WUZ8njiMi4G34bQmk
         eRDLZAAV0QdcB2+kxCWwbS21mQy2tLiJleJiyxH24GcDgv47nBI43j3WNreqI6ZmVdpN
         ovLIEby4/Zot1xmSM5YK5b6zH0541qXiBOVHmTvZv6xcuH9rJvLIkJbj0LygTTZP1QKj
         Bp6K0zrOtU1D/EhdjiGjGHYxSfvXgV98/nVZksiCSUbIKy4+QXIqa2Z7a07HbFr/T3x/
         MvmCAVmP5dBVtqVbLICq/budRfE96Egc1YZXJvuDUlLIj/Dhayv0hsgnAsfn2K7sqIGF
         ztSQ==
X-Gm-Message-State: AOAM530/NPs3OYfSXxBozfnUwpu4+B5w0ZyZyF+Vll7x3Vdw7HKiFA4O
        JSExej4vTh18jvspWsjOc4iNL+4CPpbIEw==
X-Google-Smtp-Source: ABdhPJwYZqWYk1vEF/Yf2X7Rhz3Hf4vwy6NuTxBpLon1ns4XjGj5tERETajPBafn0sfEFAVIfnJf/w==
X-Received: by 2002:a67:1a47:: with SMTP id a68mr5791787vsa.84.1599057233273;
        Wed, 02 Sep 2020 07:33:53 -0700 (PDT)
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com. [209.85.222.53])
        by smtp.gmail.com with ESMTPSA id j21sm793457vkn.26.2020.09.02.07.33.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 07:33:52 -0700 (PDT)
Received: by mail-ua1-f53.google.com with SMTP id v24so1630651uaj.7
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 07:33:51 -0700 (PDT)
X-Received: by 2002:a9f:2237:: with SMTP id 52mr1270900uad.141.1599057231345;
 Wed, 02 Sep 2020 07:33:51 -0700 (PDT)
MIME-Version: 1.0
References: <1599048911-7923-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1599048911-7923-1-git-send-email-tanhuazhong@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 2 Sep 2020 16:33:13 +0200
X-Gmail-Original-Message-ID: <CA+FuTSc_KOZRTdh34Vw3gTCzGMmi5XvDZKjpWMOXw7aby53wqw@mail.gmail.com>
Message-ID: <CA+FuTSc_KOZRTdh34Vw3gTCzGMmi5XvDZKjpWMOXw7aby53wqw@mail.gmail.com>
Subject: Re: [RFC net-next] udp: add a GSO type for UDPv6
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 2, 2020 at 2:18 PM Huazhong Tan <tanhuazhong@huawei.com> wrote:
>
> In some cases, for UDP GSO, UDPv4 and UDPv6 need to be handled
> separately, for example, checksum offload, so add new GSO type
> SKB_GSO_UDPV6_L4 for UDPv6, and the old SKB_GSO_UDP_L4 stands
> for UDPv4.

This is in preparation for hardware you have that actually cares about
this distinction, I guess?


> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> index 2cc3cf8..b7c1a76 100644
> --- a/include/linux/netdev_features.h
> +++ b/include/linux/netdev_features.h
> @@ -54,6 +54,7 @@ enum {
>         NETIF_F_GSO_UDP_BIT,            /* ... UFO, deprecated except tuntap */
>         NETIF_F_GSO_UDP_L4_BIT,         /* ... UDP payload GSO (not UFO) */
>         NETIF_F_GSO_FRAGLIST_BIT,               /* ... Fraglist GSO */
> +       NETIF_F_GSO_UDPV6_L4_BIT,       /* ... UDPv6 payload GSO (not UFO) */
>         /**/NETIF_F_GSO_LAST =          /* last bit, see GSO_MASK */
>                 NETIF_F_GSO_FRAGLIST_BIT,

Need to update NETIF_F_GSO_LAST then, too.
