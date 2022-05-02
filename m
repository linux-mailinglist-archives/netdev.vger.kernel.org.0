Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4E6517149
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 16:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383480AbiEBOPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 10:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376812AbiEBOPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 10:15:48 -0400
X-Greylist: delayed 305 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 02 May 2022 07:12:19 PDT
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768F31572A;
        Mon,  2 May 2022 07:12:19 -0700 (PDT)
Received: from mail-yb1-f182.google.com ([209.85.219.182]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1Mw9Lu-1o1oZQ3RQa-00s6bp; Mon, 02 May 2022 16:07:13 +0200
Received: by mail-yb1-f182.google.com with SMTP id i38so26139539ybj.13;
        Mon, 02 May 2022 07:07:12 -0700 (PDT)
X-Gm-Message-State: AOAM530TBEJ+uhwqm/yj0OXyoVNtp6eHj0U4jrZruDpqv0/kCPvwY6tF
        JQ9uR74kDPK3tkSYi2bMfaIwAKAzcicztfb2u8s=
X-Google-Smtp-Source: ABdhPJxu2kBG0AiERlxFFKfvkpQdfWe88hhTfjwg6Tb4DR2KA4NCnbrpoFdptlIq/zYDIRIluCEYsCm8Yu59T63CSbc=
X-Received: by 2002:a25:c604:0:b0:645:d969:97a7 with SMTP id
 k4-20020a25c604000000b00645d96997a7mr9885111ybf.134.1651500431227; Mon, 02
 May 2022 07:07:11 -0700 (PDT)
MIME-Version: 1.0
References: <1676021ae8b6d7aada0b1806fed99b1b8359bdc4.1651495112.git.hns@goldelico.com>
In-Reply-To: <1676021ae8b6d7aada0b1806fed99b1b8359bdc4.1651495112.git.hns@goldelico.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 2 May 2022 16:06:55 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3OiFJiR40FXmCZTc1fMZBteGjXqipDcvZqoO85QBxYow@mail.gmail.com>
Message-ID: <CAK8P3a3OiFJiR40FXmCZTc1fMZBteGjXqipDcvZqoO85QBxYow@mail.gmail.com>
Subject: Re: [PATCH] wl1251: dynamically allocate memory used for DMA
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>, kernel@pyra-handheld.com,
        linux-omap <linux-omap@vger.kernel.org>,
        Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:YXa7K6DM7g/inUAliZ1ocSrJWVblp21+WfVrXAVMiOlXhM1agaN
 IKrTeCQPTkK+N/NiniQumqvXDlPUkABARKw1/mrNoTiPpdPIN98l8ZJfMGk9e4bfeinaSqP
 B26BbrSKr+GK5va2iC7PRPgpSFuewD/KI2SpN3U+LVJivCIJkblAPRz/eIzpngD5pH3HSXE
 kG2MX7PUMxHje7oWVMwlA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:aOxmBoOvjOQ=:ZMQ0ZUK+CnJOZTlAh3ZlMY
 C9wf5GXb4Z88YVtWNyzWD2lKByIQo/QuhETIeOecerfCipElavQD9rzllBoELGvKYkKn37Rx9
 4OWixDw72gpo72hE/1xHDoBkV7c9OixAUwkkNBset97d+U72YfWb5sA4TkQpaUJ0z5qtYfdmZ
 c0agqKtg92cbHlnn53pukpumbzlPfDqlXircivUH9/hwZgLZEeXrMMp8f7jyCsTD9XC3x7bZ8
 BWFD6at+28q/COiHAh4mnJiWiYQs+3qiUGpD0KsxzHD4pEyk7WpaSLh1QvjU8VmsZFfK8L09o
 JyvSfvV5DQGacigs19F6AcIMaNz9ejiAt7FfaMBHzzXEmsoB+juqnMpIg7rPWFIO4+viNCdOr
 yEolxH+HhFrMuHGd7am1ZCUEJQf7ho2AR8Yx1Kxz6/HdGkdX7kQvbPy8y8DV32CZ+0x+48zjB
 TiYGmY3oaA5kRu9rFPPjJlJnZBsRAYxxClc/whB42EhD93B+5kAs5HO4norQ3ZiVVWLEFYDZw
 KR/SZzF0C70nwXPyzI9Pt0a3xLLWZAhYI1i/LqTWjdKBKwEGMrBFhb/+3UyxCZZZ4fDvO6T66
 PJ67kaxaMb3QHn3KYPpQlsWoAa4u3Ciwcil31w9ORSz5eVE/BPQ2qX4QSSvPrvgKzz9fDSkSs
 4UAD8tqvayt4XRuGfnLerRR6Ee9CzxC6fGqJ0O4bykV3sCj/9mB7VYAe/wnjsZRWf2ln2jCVb
 7fTI2zJg0R8BIhpLfOd8lTLjaQ9+Dib6TKCZfuFJbNQu0AcAVQpO9O4v8sdZ+TB0FawUAAOti
 cmm4VgysNRspToBzt5VoGuKCl6mRS9FQ/UZEfSnHgP5xuI93dA=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 2, 2022 at 2:38 PM H. Nikolaus Schaller <hns@goldelico.com> wrote:
> With introduction of vmap'ed stacks, stack parameters can no
> longer be used for DMA and now leads to kernel panic.
>
> It happens at several places for the wl1251 (e.g. when
> accessed through SDIO) making it unuseable on e.g. the
> OpenPandora.
>
> We solve this by allocating temporary buffers or use wl1251_read32().

This looks all correct to me. I had another look at the related wlcore
driver now,
and see that the same problem existed there but was fixed back in 2012
in a different way, see 690142e98826 ("wl12xx: fix DMA-API-related warnings").

The approach in the wlcore driver appears to be simpler because it
avoids dynamic memory allocation and the associated error handling.
However, it probably makes another problem worse that also exists
here:

 static inline u32 wl1251_read32(struct wl1251 *wl, int addr)
 {
       u32 response;
       wl->if_ops->read(wl, addr, &wl->buffer_32, sizeof(wl->buffer_32));
       return le32_to_cpu(wl->buffer_32);
 }

I think the 'buffer_32' member of 'struct wl1251' needs an explicit
'__cacheline_aligned' attribute to avoid potentially clobbering
some of the structure during a DMA write.

I don't know if anyone cares enough about the two drivers to
have an opinion. I've added Luca to Cc, but he hasn't maintained
the driver since 2013 and probably doesn't.

It's probably ok to just apply your patch for the moment to fix
the regression we saw on the machines that we know use this.

One more detail:

> diff --git a/drivers/net/wireless/ti/wl1251/event.c b/drivers/net/wireless/ti/wl1251/event.c
> index e6d426edab56b..e945aafd88ee5 100644
> --- a/drivers/net/wireless/ti/wl1251/event.c
> +++ b/drivers/net/wireless/ti/wl1251/event.c
> @@ -169,11 +169,9 @@ int wl1251_event_wait(struct wl1251 *wl, u32 mask, int timeout_ms)
>                 msleep(1);
>
>                 /* read from both event fields */
> -               wl1251_mem_read(wl, wl->mbox_ptr[0], &events_vector,
> -                               sizeof(events_vector));
> +               events_vector = wl1251_mem_read32(wl, wl->mbox_ptr[0]);
>                 event = events_vector & mask;
> -               wl1251_mem_read(wl, wl->mbox_ptr[1], &events_vector,
> -                               sizeof(events_vector));
> +               events_vector = wl1251_mem_read32(wl, wl->mbox_ptr[1]);
>                 event |= events_vector & mask;

This appears to change endianness of the data, on big-endian kernels.
Is that intentional?

My first guess would be that the driver never worked correctly on big-endian
machines, and that the change is indeed correct, but on the other hand
the conversion was added in commit ac9e2d9afa90 ("wl1251: convert
32-bit values to le32 before writing to the chip") in a way that suggests it
was meant to work on both.

       Arnd
