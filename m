Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79704F6C2A
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235414AbiDFVKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiDFVKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:10:03 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BF41BB806
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 12:49:32 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id t2so6071313qtw.9
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 12:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YALPcXFlHyjJhM5IWic8x8fsXsmFYfOaEejI/INaLqA=;
        b=Y/LXP7pUpQ/mB4D2Bm5PRBF+M9OQHdXqn1VwvqNhpwGTAGnOYEvjaT7gj06TOoXUlA
         Q7JoZlyaXNJXIzIyqVy0C1436BtgV1uvf5vNDam8qufk0kDTp5kRX7+VoTPKNwHHYibO
         mE49Cgi9zQ1+YVg9j0PpdETJD0CebPzxvpx0O7YMQ3qHHW6z5WO4n47LK6Ecoy4zMyq5
         LdvfSN/wS8f9agQoDVjQoXDMc6hwWLpPkNg9NL/h9kVYrIWdxQJcmuPK+7vaHqjZJ2LP
         ob1vZmvXVrvh6KC6diiiDq4HGv29tj0Bh7cZqbu2cJgCsFkyq2aYQYXvvF7VGAAAm1oP
         //7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YALPcXFlHyjJhM5IWic8x8fsXsmFYfOaEejI/INaLqA=;
        b=TgsoTj1s6exqDW1bUjbc4Bqo+T0Nu7iuBymUOtY1ZEdAQWnVzzgd/bfH9hHtyvQX9y
         AONY1rvfafM3RDkwcM6vHfBDoDRVc95STn26B0kBTMZWW4YmiUHlvCz7EtvlJDaS05tB
         1a4oUCGKG6UnmSbD73ZbBgHAn0/pQsOACToWPGAXxbv/+0vP8hp+QgpS+L1x9RcEiJtj
         a7zPRcvcpWGvZPBU2PdE6lZVTJs459YjjmJ+4JlprC5y/cM8JB12TW8R3UNBPqJ+CEaf
         oU645VgEtJ4lEYfwa59CRTN5e87AnLNrsE57mneGtKLutN0HJq0lDXJISwBDhlcZ4PNU
         NuOQ==
X-Gm-Message-State: AOAM531ojg9ZaQeaGW7nIS1L7LgfS0D7b4lTmb7s2HBKa58lamOGJcXH
        5dhtDEaF+FlZDpCifkXCPeRGp1Gczbg=
X-Google-Smtp-Source: ABdhPJwQf+4XpCcpRo2xr5+CPmNkKsMizAiPymJhjIgULgc4/gqUDuV5Htfm9gNxx93pjdFjugk2dw==
X-Received: by 2002:a05:622a:391:b0:2e2:3282:7e66 with SMTP id j17-20020a05622a039100b002e232827e66mr8819566qtx.566.1649274571358;
        Wed, 06 Apr 2022 12:49:31 -0700 (PDT)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id k8-20020a05620a138800b00679fc7566fcsm10105188qki.18.2022.04.06.12.49.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 12:49:31 -0700 (PDT)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-2e5e31c34bfso38479967b3.10
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 12:49:30 -0700 (PDT)
X-Received: by 2002:a81:b04a:0:b0:2eb:6919:f27 with SMTP id
 x10-20020a81b04a000000b002eb69190f27mr8641057ywk.54.1649274570313; Wed, 06
 Apr 2022 12:49:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220406192956.3291614-1-vladimir.oltean@nxp.com> <20220406192956.3291614-3-vladimir.oltean@nxp.com>
In-Reply-To: <20220406192956.3291614-3-vladimir.oltean@nxp.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 6 Apr 2022 15:48:54 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe0YNxNqR5kWSB3+8DLEBz4FDQBXG0w8yTDTKCRtrrR_w@mail.gmail.com>
Message-ID: <CA+FuTSe0YNxNqR5kWSB3+8DLEBz4FDQBXG0w8yTDTKCRtrrR_w@mail.gmail.com>
Subject: Re: [PATCH 4.14 2/2] net: add missing SOF_TIMESTAMPING_OPT_ID support
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 6, 2022 at 3:30 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> [ Upstream commit 8f932f762e7928d250e21006b00ff9b7718b0a64 ]
>
> SOF_TIMESTAMPING_OPT_ID is supported on TCP, UDP and RAW sockets.
> But it was missing on RAW with IPPROTO_IP, PF_PACKET and CAN.
>
> Add skb_setup_tx_timestamp that configures both tx_flags and tskey
> for these paths that do not need corking or use bytestream keys.
>
> Fixes: 09c2d251b707 ("net-timestamp: add key to disambiguate concurrent datagrams")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks for handling the cherry-pick to stable of this fix, Vladimir.
