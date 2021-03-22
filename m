Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5975344623
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 14:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhCVNqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 09:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbhCVNpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 09:45:34 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E312C061762
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 06:45:31 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id w18so19453205edc.0
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 06:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OeDdsJWGdPdVqovW1nny2NE3dcfK9Oq++a93Y6GoBbw=;
        b=ZZw/9uyczT9wX4KeEZkZ/XmAauVUtlP5CMZq3D8Okf5ObxLCuQ3ixEWsoprRtP0WiQ
         HaQ72zP/LQybfmYqXO8NlTB6/c+B50glxtSEqA1mInPRsQkrif0qZuxAcNMqjT0sox70
         7IxAAzbEt8gHD70rkLEjrVQ/uI3cchhs7LvMJymkSdx1ZE8pEL3kYjzyOgw4vnyiuuT5
         xLAnhW/X+o+sYD0Umth0fcl1nJ1srwYFCjAM2tWqT0LCj0CbqBylo8NYoONmjcCVAics
         Iklmnbf6weJzvqUgV7T1Z8z+8fz2Jps77XD6ToctF5dEzBpfbCW4YamUo+G68GnAVoWa
         BXWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OeDdsJWGdPdVqovW1nny2NE3dcfK9Oq++a93Y6GoBbw=;
        b=A+0v/vV3byc7x0Jtctb43hEIuk/U8OtBck51BD81LqsD3RARmIfnbWAEUEUz+fd3tq
         N3INZCvRM1Qpion3DGKVNelP7h7xKIch16Z5su6ySvwfNHdyoAanKRcqG0WDatDQiPvY
         74WIT1BW32yzDnOQa3IEI6Itz20w8BkjUQWzZrTPeYeP/GyH76x8+oubyD6/q99VZV5e
         Nbsmml6H7zpwTVie8iUkgb/YzNsy7Eu8BLWe5uAc8IVtc96wf9Nmhf5egKXpzTIdZVyK
         yPYPHMSKZ5r5e/n5PysBTxqYIhjSA4NNMZzK3PUcwMsNj2hdluvNi09154tKy7MEFz6N
         oa9A==
X-Gm-Message-State: AOAM532BH0xAZd7OO5I2cMuhoqkJpH8v/o8rAa82of8AB9djuA9zOnwk
        B2aS5p6IZ31zVbNbontJmDv5wEMuxFE=
X-Google-Smtp-Source: ABdhPJxwy7z12tLgIokj3OmIFhBs6BE6f+fhzrq9/6xrMSGu147fa/3kD7IlOKbiBzWmoqJceaqSxg==
X-Received: by 2002:a05:6402:3049:: with SMTP id bu9mr26287770edb.104.1616420729358;
        Mon, 22 Mar 2021 06:45:29 -0700 (PDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com. [209.85.221.53])
        by smtp.gmail.com with ESMTPSA id gn3sm9412661ejc.2.2021.03.22.06.45.28
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 06:45:28 -0700 (PDT)
Received: by mail-wr1-f53.google.com with SMTP id j18so16877818wra.2
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 06:45:28 -0700 (PDT)
X-Received: by 2002:a05:600c:2053:: with SMTP id p19mr15992696wmg.87.1616420728043;
 Mon, 22 Mar 2021 06:45:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616345643.git.pabeni@redhat.com> <a9791dcc26e3f70858eee5d14506f8b36e747960.1616345643.git.pabeni@redhat.com>
In-Reply-To: <a9791dcc26e3f70858eee5d14506f8b36e747960.1616345643.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 22 Mar 2021 09:44:51 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc6u_YfhTzoHPtzJSkLGMhSsDW5mWvR4-o=YB8e6ieYKQ@mail.gmail.com>
Message-ID: <CA+FuTSc6u_YfhTzoHPtzJSkLGMhSsDW5mWvR4-o=YB8e6ieYKQ@mail.gmail.com>
Subject: Re: [PATCH net-next 8/8] selftests: net: add UDP GRO forwarding self-tests
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 1:02 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> create a bunch of virtual topology and verify that
> GRO_FRAG_LIST and GRO_FWD aggregate the ingress

what are these constants? Aliases for SKB_GSO_FRAGLIST and ?

> packets as expected, and the aggregate packets
> are segmented correctly when landing on a socket
>
> Also test L4 aggregation on top of UDP tunnel (vxlan)
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Nice comprehensive test, thanks!

> ---
>  tools/testing/selftests/net/Makefile      |   1 +
>  tools/testing/selftests/net/udpgro_fwd.sh | 251 ++++++++++++++++++++++
>  2 files changed, 252 insertions(+)
>  create mode 100755 tools/testing/selftests/net/udpgro_fwd.sh
>
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> index 25f198bec0b25..2d71b283dde36 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -23,6 +23,7 @@ TEST_PROGS += drop_monitor_tests.sh
>  TEST_PROGS += vrf_route_leaking.sh
>  TEST_PROGS += bareudp.sh
>  TEST_PROGS += unicast_extensions.sh
> +TEST_PROGS += udpgro_fwd.sh
>  TEST_PROGS_EXTENDED := in_netns.sh
>  TEST_GEN_FILES =  socket nettest
>  TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
> diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
> new file mode 100755
> index 0000000000000..ac7ac56a27524
> --- /dev/null
> +++ b/tools/testing/selftests/net/udpgro_fwd.sh
> @@ -0,0 +1,251 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
> +
> +readonly BASE="ns-$(mktemp -u XXXXXX)"
> +readonly SRC=2
> +readonly DST=1
> +readonly DST_NAT=100
> +readonly NS_SRC=$BASE$SRC
> +readonly NS_DST=$BASE$DST
> +
> +# "baremetal" network used for raw UDP traffic
> +readonly BM_NET_V4=192.168.1.
> +readonly BM_NET_V6=2001:db8::
> +
> +# "overlay" network used for UDP over UDP tunnel traffic
> +readonly OL_NET_V4=172.16.1.
> +readonly OL_NET_V6=2002:db8::

is it okay to use a prod64 prefix for this? should this be another
subnet of 2001:db8:: instead? of fd..
