Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E1A64BBDD
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 19:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbiLMSXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 13:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236460AbiLMSX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 13:23:29 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68417F01B;
        Tue, 13 Dec 2022 10:23:28 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id gh17so38641521ejb.6;
        Tue, 13 Dec 2022 10:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TwSscO4PEOQF6eSJjMD8VMf0/HEneWx4N+6zCukP0wU=;
        b=aISaR1NtmUs7HLwylIB8pt6NezUoA9MqVwdl1HaqJxF+w6X3F0mTpCZgmb7+ljxrwt
         k4mwmFp6zMZQoYd4d0MLWDhpRsmzhWmA7uNk49EqQ/4f95adDVJba25WIv06vO/8B37F
         3rQEgux0qYjlZlOY8C/LpUBSTkO2e4XEo4Qors0OnlJ4ZXcCCEZ09tDy4wki9a8n3oqZ
         KAFAm4JLpVSyfKKOLgkjkz+hJkpdUb7X4gZVASHRv/fMuCBj1pGXjEbibY7iRj2v+cH1
         XEQWyPWpUU3PMQ2kw+m/mUXlkfTDD5AdjFHNzMt8Q8D2uGIT29xXaWjzHWZkrlREu5Vm
         5tBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TwSscO4PEOQF6eSJjMD8VMf0/HEneWx4N+6zCukP0wU=;
        b=KnxeC6JvPHPdHLdKGo8CeWB33VBlFNMPwcVJLrVAnH+3Bon/UysNeYtD6yzF9yZ6Im
         hxWd874XEDQY8ZRrjVeNbzl+oZkeQtMkfLmSO2SxRrWx8MJdj3RffCFzAU7zhjoIDkjQ
         o5uE1adqB/0C45ZnpJskH5ZhxfO0TEwM4bX9OGdWEZ8RZkV+x5t5Q+L+gGBpP29e92u/
         XNyDCpcsU8D7uN+LddesqD8mCqOiP8H8j4Wd1kbYrBEaOPuf/C0FyQGOS1SN/s1vPSN8
         JYHAsWExZ77fh++Mz1KZhuUJSOuUXw97SZXDVm3BjOW/oJ1MRgPGB38DoWOpZZGC7Zof
         qs6Q==
X-Gm-Message-State: ANoB5pnH4YznKazvLaHDKGfdMKAv44AgcfwwoPdsbfvu9YQaX4CZsrFK
        2z32z7/7CheruAeyVEGF8zOdWG/ebA+8nlY/gI0=
X-Google-Smtp-Source: AA0mqf6GxPasT+P+nG824mqg/9ow4VA7kyhlgtwQwUoxZsf7IYyHCjz2Wn/JsjLxWfg3FzF5J+K6Q0rdfOkZ7s7yol0=
X-Received: by 2002:a17:906:694a:b0:7c0:9d50:5144 with SMTP id
 c10-20020a170906694a00b007c09d505144mr31755625ejs.590.1670955806889; Tue, 13
 Dec 2022 10:23:26 -0800 (PST)
MIME-Version: 1.0
References: <CAA42iKxeinZ4gKfttg_K8PdRt+p-p=KjqgcbGjtxzOqn_C0F9g@mail.gmail.com>
In-Reply-To: <CAA42iKxeinZ4gKfttg_K8PdRt+p-p=KjqgcbGjtxzOqn_C0F9g@mail.gmail.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Tue, 13 Dec 2022 19:23:13 +0100
Message-ID: <CAGRyCJGCrR_FVjCmsnbYhs76bDc0rD83n-=2ros2p9W_GeVq-w@mail.gmail.com>
Subject: Re: [PATCH] net: Fix for packets being rejected in the xHCI
 controller's ring buffer
To:     "Seija K." <doremylover123@gmail.com>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Seija,

Il giorno mar 13 dic 2022 alle ore 18:44 Seija K.
<doremylover123@gmail.com> ha scritto:
>
> When a packet larger than MTU arrives in Linux from the modem, it is
> discarded with -EOVERFLOW error (Babble error).
>
> This is seen on USB3.0 and USB2.0 buses.
>
> This is because the MRU (Max Receive Size) is not a separate entity
> from the MTU (Max Transmit Size), and the received packets can be
> larger than those transmitted.
>
> Following the babble error, there was an endless supply of zero-length
> URBs that were rejected with -EPROTO (increasing the rx input error
> counter each time).
>
> This is only seen on USB3.0. These continue to come ad infinitum until
> the modem is shut down.
>
> There appears to be a bug in the core USB handling code in Linux that
> doesn't deal with network MTUs smaller than 1500 bytes well.
>
> By default, the dev->hard_mtu (the real MTU) is in lockstep with
> dev->rx_urb_size (essentially an MRU), and the latter is causing
> trouble.
>
> This has nothing to do with the modems; the issue can be reproduced by
> getting a USB-Ethernet dongle, setting the MTU to 1430, and pinging
> with size greater than 1406.
>
> Signed-off-by: Seija Kijin <doremylover123@gmail.com>
>
> Co-Authored-By: TarAldarion <gildeap@tcd.ie>
> ---
> drivers/net/usb/qmi_wwan.c | 7 +++++++
> 1 file changed, 7 insertions(+)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 554d4e2a84a4..39db53a74b5a 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -842,6 +842,13 @@ static int qmi_wwan_bind(struct usbnet *dev,
> struct usb_interface *intf)
> }
> dev->net->netdev_ops = &qmi_wwan_netdev_ops;
> dev->net->sysfs_groups[0] = &qmi_wwan_sysfs_attr_group;
> + /* LTE Networks don't always respect their own MTU on the receiving side;
> + * e.g. AT&T pushes 1430 MTU but still allows 1500 byte packets from
> + * far-end networks. Make the receive buffer large enough to accommodate
> + * them, and add four bytes so MTU does not equal MRU on network
> + * with 1500 MTU. Otherwise, usbnet_change_mtu() will change both.
> + */
> + dev->rx_urb_size = ETH_DATA_LEN + 4;

Did you test this change with QMAP?

To support qmap dl aggregated blocks qmi_wwan relies on the
usbnet_change_mtu behavior of changing the rx_urb_size.

Thanks,
Daniele

> err:
> return status;
> }
> --
> 2.38.2
