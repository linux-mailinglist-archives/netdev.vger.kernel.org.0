Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D86261290E
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 09:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiJ3IVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 04:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiJ3IVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 04:21:02 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E99A33E
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 01:20:58 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id a14so11947691wru.5
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 01:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mjaD747cFGT9c4tChWYm/vwyEAFwe1mtHJ7oR4wNSYA=;
        b=Q7UwaYpb8ksKAzvtewNjpTlBaQIuIXHJkeMe7lD9/iMZUArs01seT0MpLhBXV/diFw
         +Xn/8muaKGVL42Sfj3aVwbbwMtvmVfOrNz4eApMPhMEE69iKH0+8pQbmLn9xzUVjG94J
         4j1N4ojh4NlkanZ/glQrq4mTPNuRbsRdYXNtReLnWX5rjv5rJqi+/u1Oh7X1Eq89IvPf
         S+8deLS4hpNf9g8jTS6QRg4rcreTiwotN6h6D6UbFTm612KT1vsxy8t03WfYWmLCack3
         6kaDIMIONSGtMswJCHB84OVYo+4u47FRh1EbM6sVtKS8K7njG4Ik6bbLtlIpzbNU0fxs
         updg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mjaD747cFGT9c4tChWYm/vwyEAFwe1mtHJ7oR4wNSYA=;
        b=Y6AAD5oFbKXeblfAFbBWqSzNwhYmJkisKm12vae5vo61UJORqvLpSp4tKIIJJwe/yx
         zN/f99MlpukN3rh/aac1WJ2iFjDZXbTab59k7ctWkjPAZzjKU7iS3kaOm/Dw33PHTqPh
         f9Nf0JknNg8TTPZyXcWDd8BqI442o8eVmskDJ0h+S6+24aJFsurx93MS10J7MD8vH+cw
         cbBnSLSKRr61TufZoLPFnqtpZ6zrBd8s+Z7Rv4HLGeCNz1zHsG/QukfOs2q9Wrunw5Fk
         gCPsd2FQqzJwArhWYYyLMdOujgQ+iLqn/06wa+AduRNJY6KASUderGzkMr5OdhDdFmQy
         NUmQ==
X-Gm-Message-State: ACrzQf19yIKOQqLtVpY5DqTwASyFv33BWf3lV/49M0S8CVz5N22+IFRa
        4v0qECaXuBtTV+9GVuxVT8SagNG6NdWZZ4oMB1SMdw==
X-Google-Smtp-Source: AMsMyM6UL9q70iQbc+Dd7dtfH/V7OnMsk3nSiqNT45ilzCNHo1hWlWL+xOTc7NHHwEKOnpNHiKlca8fVSjAygSGHVXc=
X-Received: by 2002:adf:e84a:0:b0:236:5f2d:9027 with SMTP id
 d10-20020adfe84a000000b002365f2d9027mr4275871wrn.89.1667118056929; Sun, 30
 Oct 2022 01:20:56 -0700 (PDT)
MIME-Version: 1.0
References: <20221029090355.565200-1-shaneparslow808@gmail.com>
In-Reply-To: <20221029090355.565200-1-shaneparslow808@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Sun, 30 Oct 2022 09:20:21 +0100
Message-ID: <CAMZdPi_E6KuGb_EdMQviLHMsuPehtxW1a3Yc0j1jMAoz8p498Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: wwan: iosm: add rpc interface for xmm modems
To:     Shane Parslow <shaneparslow808@gmail.com>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Oct 2022 at 11:04, Shane Parslow <shaneparslow808@gmail.com> wrote:
>
> Add a new iosm wwan port that connects to the modem rpc interface. This
> interface provides a configuration channel, and in the case of the 7360, is
> the only way to configure the modem (as it does not support mbim).
>
> The new interface is compatible with existing software, such as
> open_xdatachannel.py from the xmm7360-pci project [1].
>
> [1] https://github.com/xmm7360/xmm7360-pci
>
> Signed-off-by: Shane Parslow <shaneparslow808@gmail.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
