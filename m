Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABD83461AF
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 15:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhCWOnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 10:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbhCWOnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 10:43:33 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB7CC061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 07:43:33 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ce10so27513549ejb.6
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 07:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wpRm6VhCt5Tmem+5xXP3SgI+L5GUwRkeSiWqVuYcDM8=;
        b=soPEcL5PD3pGzy+UVBJ50290iledeWVyf8/AulhF5hpJEIrvPSuQh+pOgymb0qAXuC
         3CeY/6PRkRboaDh8Xu3USVPeoTxltWgZv7IwV59A+syjGjRC3YTsycBdJP0ORN036mKv
         RPkwnbT39lNHZlSFKpXR7/9lN6nyv93+Sf9kQ+h57699GKuIUNmtp9/Oj1bNvsqCVlpe
         ReY7O2rFN7owsnQHimdhvuo1PwOoCPDQS2yBJ8zffcMmCpOCbZYE1Z7yWGPKGfpEx0kZ
         dP5aQSCKqftskfUlb4NswkyFAOJ4bl+Yuc9lnkLMfim/2JgqtgYndTkwa+Bx/4jWS0Jt
         kriA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wpRm6VhCt5Tmem+5xXP3SgI+L5GUwRkeSiWqVuYcDM8=;
        b=qa+PhirK5fhnRwS0ZyW3B5I4ft33DVKtufbG4dd85v7JyJ/0I9JTvHLalwt5Z2fgiP
         aHJ4n5Ouu9u8vD9J/OCC9NluGW5N7uUcbA9O+e0FtfvoPfo6EsJWUGj0mmxaNO98YTgN
         AT3G4Y5tSZT6Qu+YPpjhOEjk6RC27lkJ/p1uFy3nG+Q3wzoG5idtwOaD+XsDzOXs/Qa8
         DygYdoRsAFP1K1OrFyOmwmFbO2Is90TBIt154rv81ysWr9C64BlJdCm8AzCE6ktEXPip
         cFk1TeFEgVUnJ+mz0Q46ZHrWOU3viSMl8wZXrYRCnmy/AfNLz9x1frDJbd2SZ832DfeY
         RvcQ==
X-Gm-Message-State: AOAM532JfneyPwEiuzlcK0NsO3s/coUBAZENgu5HFFSoaYM+iTmN5Y50
        4UAA86hys2h+T5sb+64mQRhpYmbBKCE=
X-Google-Smtp-Source: ABdhPJw/8L+6Q/9bPZzkv+DoY8ukbFPI1n+phNEE946mCKgyUE1vhOxT+twia7wfdKHLwrtAznsJ2g==
X-Received: by 2002:a17:906:8043:: with SMTP id x3mr5176399ejw.149.1616510611212;
        Tue, 23 Mar 2021 07:43:31 -0700 (PDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id z17sm11306783eju.27.2021.03.23.07.43.29
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 07:43:30 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id e9so21040260wrw.10
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 07:43:29 -0700 (PDT)
X-Received: by 2002:a05:6000:1803:: with SMTP id m3mr4445527wrh.50.1616510608882;
 Tue, 23 Mar 2021 07:43:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210323125233.1743957-1-arnd@kernel.org>
In-Reply-To: <20210323125233.1743957-1-arnd@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 23 Mar 2021 10:42:51 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdZSmBe0UfdmAiE3HxK2wFhEbEktP=xDT8qY9WL+++Cig@mail.gmail.com>
Message-ID: <CA+FuTSdZSmBe0UfdmAiE3HxK2wFhEbEktP=xDT8qY9WL+++Cig@mail.gmail.com>
Subject: Re: [RFC net] net: skbuff: fix stack variable out of bounds access
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 8:52 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> gcc-11 warns that the TS_SKB_CB(&state)) cast in skb_find_text()
> leads to an out-of-bounds access in skb_prepare_seq_read() after
> the addition of a new struct member made skb_seq_state longer
> than ts_state:
>
> net/core/skbuff.c: In function =E2=80=98skb_find_text=E2=80=99:
> net/core/skbuff.c:3498:26: error: array subscript =E2=80=98struct skb_seq=
_state[0]=E2=80=99 is partly outside array bounds of =E2=80=98struct ts_sta=
te[1]=E2=80=99 [-Werror=3Darray-bounds]
>  3498 |         st->lower_offset =3D from;
>       |         ~~~~~~~~~~~~~~~~~^~~~~~
> net/core/skbuff.c:3659:25: note: while referencing =E2=80=98state=E2=80=
=99
>  3659 |         struct ts_state state;
>       |                         ^~~~~
>
> The warning is currently disabled globally, but I found this
> instance during experimental build testing, and it seems
> legitimate.
>
> Make the textsearch buffer longer and add a compile-time check to
> ensure the two remain the same length.
>
> Fixes: 97550f6fa592 ("net: compound page support in skb_seq_read")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/linux/textsearch.h | 2 +-
>  net/core/skbuff.c          | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/textsearch.h b/include/linux/textsearch.h
> index 13770cfe33ad..6673e4d4ac2e 100644
> --- a/include/linux/textsearch.h
> +++ b/include/linux/textsearch.h
> @@ -23,7 +23,7 @@ struct ts_config;
>  struct ts_state
>  {
>         unsigned int            offset;
> -       char                    cb[40];
> +       char                    cb[48];
>  };
>
>  /**
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 545a472273a5..dd10d4c5f4bf 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3633,6 +3633,7 @@ static unsigned int skb_ts_get_next_block(unsigned =
int offset, const u8 **text,
>                                           struct ts_config *conf,
>                                           struct ts_state *state)
>  {
> +       BUILD_BUG_ON(sizeof(struct skb_seq_state) > sizeof(state->cb));
>         return skb_seq_read(offset, text, TS_SKB_CB(state));
>  }
>
> --
> 2.29.2
>

Thanks for addressing this.

A similar fix already landed in 5.12-rc3: commit b228c9b05876 ("net:
expand textsearch ts_state to fit skb_seq_state"). That fix landed in
5.12-rc3.
