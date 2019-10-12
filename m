Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3A7BD4F43
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 13:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbfJLLTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 07:19:08 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:33364 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfJLLTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 07:19:08 -0400
Received: by mail-yw1-f67.google.com with SMTP id w140so4449564ywd.0
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 04:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hABoQwLdO0uMm4YXkBCFk8W+eev136YlKUX9aXvX8MQ=;
        b=D7mHgPzHHTjdRL5OoclG/V+NKJIlPgeUibKjAWXcA7kIdPCd1XFPkfIyBuFuGwE2P+
         MrEzs8F+PLYTxDH7ouh8EEEy/e6BEoGBjYbDgQTWpvl1t6uv5b1purG/AhX+7F5S/XHr
         MNSbgSGnJaoqe4a9mxi+0NmcCJmKRSvg6o6KyHN4EoY2PckPjdpYR87r82qzkJm4Z96/
         ZAipfmQiNMA0Cnt9YBnNvNO7quDOmC2t+0DHM2qaYIasyDERsY8dzwGmDvE10fGVmuxs
         bkjJbp4M1R1rManGnfz7uhb+pds7C8qEl7FJqoQ8kyOTrRWsTxMjvoM0WbNsQuMp18D1
         IAEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hABoQwLdO0uMm4YXkBCFk8W+eev136YlKUX9aXvX8MQ=;
        b=YWXA67a1fOjXITTJOvKWciRcao1V5e/5tMz1eOIc78RI4dlNo6y8CmkdXD8sN116qq
         5rKVc3xiMkBoTkcc2PKP1YJIF9vNImNSv3NF89TXR46Ug0XZDREYK45PhrN8unZ0AVI6
         5ElWgejhOyCEPP8JkGOEAsJLho07ha4Y3r5IaNNV6mtaWdazkG/TAA1SsnW/YXjIm2GP
         THeNQMOahuAtdo77w3uxl4r4RJatKj6FL2CNAHxjXmYL7oBo0IYp12mhF6OSqP970c5k
         UrVfwlKZZb6KMEWiVT1MLS5iF5BR0v/P2yQXw/Ycc/Am0ECWGQ4E7nfKI3qd5Mae8TpJ
         jqAw==
X-Gm-Message-State: APjAAAXiTcP50IBf0iny91QgFkZ7N/eNxbqvGuVDPg6AOX9nItM04FY+
        kFb8jdWvrngw4tKPZawg/W8s6FIG5dx0o3Gi+Tb+qA==
X-Google-Smtp-Source: APXvYqwZOaCkSDRcIvwoJHVK/AzkGRNEIC28N93f863MsT7N1isrICFjEYjK81ioPs6sBTYpIDJGcldt+P9QBxA23xg=
X-Received: by 2002:a0d:fd03:: with SMTP id n3mr5796321ywf.170.1570879146864;
 Sat, 12 Oct 2019 04:19:06 -0700 (PDT)
MIME-Version: 1.0
References: <20191010144226.4115-1-alobakin@dlink.ru> <20191010144226.4115-3-alobakin@dlink.ru>
 <c2450dc3-8ee0-f7cd-4f8a-61a061989eb7@solarflare.com> <1eaac2e1f1d65194a4a39232d7e45870@dlink.ru>
 <3c459c84df86f79b593632d3f08d5f4c@dlink.ru>
In-Reply-To: <3c459c84df86f79b593632d3f08d5f4c@dlink.ru>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 12 Oct 2019 04:18:55 -0700
Message-ID: <CANn89iLrVU2OVTj1yk4Sjd=SVxHYN-WpXeGhMEWx0DsVLz7giQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: core: increase the default size of
 GRO_NORMAL skb lists to flush
To:     Alexander Lobakin <alobakin@dlink.ru>
Cc:     Edward Cree <ecree@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 12, 2019 at 2:22 AM Alexander Lobakin <alobakin@dlink.ru> wrote:

>
> I've generated an another solution. Considering that gro_normal_batch
> is very individual for every single case, maybe it would be better to
> make it per-NAPI (or per-netdevice) variable rather than a global
> across the kernel?
> I think most of all network-capable configurations and systems has more
> than one network device nowadays, and they might need different values
> for achieving their bests.
>
> One possible variant is:
>
> #define THIS_DRIVER_GRO_NORMAL_BATCH    16
>
> /* ... */
>
> netif_napi_add(dev, napi, this_driver_rx_poll, NAPI_POLL_WEIGHT); /*
> napi->gro_normal_batch will be set to the systcl value during NAPI
> context initialization */
> napi_set_gro_normal_batch(napi, THIS_DRIVER_GRO_NORMAL_BATCH); /* new
> static inline helper, napi->gro_normal_batch will be set to the
> driver-speficic value of 16 */
>
> The second possible variant is to make gro_normal_batch sysctl
> per-netdevice to tune it from userspace.
> Or we can combine them into one to make it available for tweaking from
> both driver and userspace, just like it's now with XPS CPUs setting.
>
> If you'll find any of this reasonable and worth implementing, I'll come
> with it in v2 after a proper testing.

Most likely the optimal tuning is also a function of the host cpu caches.

Building a too big list can also lead to premature cache evictions.

Tuning the value on your test machines does not mean the value will be good
for other systems.

Adding yet another per device value should only be done if you demonstrate
a significant performance increase compared to the conservative value
Edward chose.

Also the behavior can be quite different depending on the protocols,
make sure you test handling of TCP pure ACK packets.

Accumulating 64 (in case the device uses standard NAPI_POLL_WEIGHT)
of them before entering upper stacks seems not a good choice, since 64 skbs
will need to be kept in the GRO system, compared to only 8 with Edward value.
