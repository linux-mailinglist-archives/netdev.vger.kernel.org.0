Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA0B5B1250
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 04:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiIHCCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 22:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiIHCC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 22:02:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0B4AB1B6
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 19:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662602547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GjfEsUaHMfzHi5IAlxBstxq1c6LM3vW3A0uBM7qUHYs=;
        b=hhacnbv39Vkwv9+W4VRKj+iXFy+PuT0VzpRAnkDCo/oi7Yl+qeqt+337HqvOFSx2R2ydkb
        IqMk1LsMHIb4qJXI3lJs5XFtnViQIV7tVWdbiC/HhTpF85vtNLcR3UH3Q+Wtz/9uNXoE+e
        p3bJeDfJT6Qt9ZGd5wFuMWfwdSEPdHA=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-125-I4swC4VsMNKGT9OzsoZAMw-1; Wed, 07 Sep 2022 22:02:26 -0400
X-MC-Unique: I4swC4VsMNKGT9OzsoZAMw-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-34558a60c39so72028027b3.16
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 19:02:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=GjfEsUaHMfzHi5IAlxBstxq1c6LM3vW3A0uBM7qUHYs=;
        b=Q0u80KdBNBr9Cp9q7CrhHJSvbiO3PkcL8seay/1OYPXKG97WhLweZwFJj1DZt2i4fr
         Af8Z2pX6/aEVVOgB2VNzu7RjjuxAmmzaDMjxqRwOZB9d7sau+smZR22SzGOhQL8p/kZB
         mDS0k5BQeVMT9GDXG6t4o/IlTKtTlRHYIL7h9kBC0uGh466rnYzde/TBmuABBRp6S4fQ
         QwU3J/jR4AHt62IWO32TAJhEZkqNsxyIppkFEQ6lUy6pxEeXa6vNyUkMAZ3LfQw1BR/q
         O9FZD0bCUKB542WARWjJoe8PC5fpgwFL+UbajvkBoKYwq61MGuFc28a/DUlLiARofytU
         +YOQ==
X-Gm-Message-State: ACgBeo1GAZxzb8PrPqiu6b0k+UQyr6nGegoL4pAJd+r51sonWx55/lKr
        PVMWHoGFFClIlF9j8GAts8U6sl9xhtN6QCMX/3wo4iYUmAnD3qCZAv4sPExOYzp7zv3sNNKyBOJ
        +GPOXkGXGJAmm09z8whB+7P/kFb7WUaaF
X-Received: by 2002:a81:892:0:b0:345:3873:36e4 with SMTP id 140-20020a810892000000b00345387336e4mr5729593ywi.249.1662602545651;
        Wed, 07 Sep 2022 19:02:25 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4+T3GDchJFTil6rYC+k2C3e0KB6ejdT/dDcUQqKgjob00o6B04iojRGphbGviSqYgspdGJOnn2xYLI9NMsyrY=
X-Received: by 2002:a81:892:0:b0:345:3873:36e4 with SMTP id
 140-20020a810892000000b00345387336e4mr5729573ywi.249.1662602545440; Wed, 07
 Sep 2022 19:02:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220830070339.494695-1-tcs_kernel@tencent.com>
In-Reply-To: <20220830070339.494695-1-tcs_kernel@tencent.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 7 Sep 2022 22:02:14 -0400
Message-ID: <CAK-6q+iGfyKdcXRy5Qq+71D=BE2NbXPNSjx6YELr1HO0RYYk-g@mail.gmail.com>
Subject: Re: [PATCH V2] net/ieee802154: fix uninit value bug in dgram_sendmsg
To:     Haimin Zhang <tcs.kernel@gmail.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Haimin Zhang <tcs_kernel@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Aug 30, 2022 at 3:03 AM Haimin Zhang <tcs.kernel@gmail.com> wrote:
>
> There is uninit value bug in dgram_sendmsg function in
> net/ieee802154/socket.c when the length of valid data pointed by the
> msg->msg_name isn't verified.
>
> We should check the msg_namelen is not less than struct
> sockaddr_ieee802154 when addr_type is SHORT before calling
> ieee802154_addr_from_sa. So we define IEEE802154_MIN_NAMELEN.
> And in function ieee802154_addr_from_sa, when
> addr_type is LONG, we check msg_namelen is not less than
> sizeof(struct sockaddr_ieee802154). Meanwhile we check in the
> beginning of function dgram_sendmsg.
>

There exists also an IEEE802154_ADDR_NONE addr_type.

We need to first check that space is there to evaluate the addr_type.

If it's NONE, ignore hwaddr or short address. If it's SHORT or hwaddr
check if they have space for it, if it's something completely
different return -EINVAL.

There are still missing bits and I would recommend introducing a
helper function to do this "kind" of more complex check. This patch
spreads different checks around by checking on IEEE802154_MIN_NAMELEN
(which isn't correct, because NONE) and then requires another check by
calling ieee802154_addr_from_sa() and checking the return code.

- Alex

