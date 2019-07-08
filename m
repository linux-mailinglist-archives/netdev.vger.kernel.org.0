Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2DE62A66
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 22:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405043AbfGHUel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 16:34:41 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45756 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732013AbfGHUel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 16:34:41 -0400
Received: by mail-lj1-f194.google.com with SMTP id m23so17266298lje.12
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 13:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dBFZRyCyJk4RFRv9CPsI2krQKYXMzg0NzprO2zX7A1I=;
        b=G3xgqReYoo3GSkZMfROj+G1V+LsFfZ+sxdSupWo479mM+nBsMYlhwh+Tu04N5jaNWt
         nSlvIFgmIAVDBnUi4N+s4Uy6bZFZl6VTNh1UzuKHMWRPTrDbrjkZlx85TsEJQarYbBFz
         9AW5ty334qmUJCphkzlsWNJG3h+Tk1sDgUuCo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dBFZRyCyJk4RFRv9CPsI2krQKYXMzg0NzprO2zX7A1I=;
        b=WIih5CeO+uA1z4ltZydTL3+8nRcP/TYYMoU7rY9gpxwOrOTYSYWKGsgOpliBq3xcHJ
         jK6FHbYm6ELL4lEbYlQ6rR7WmmrMlb4d08C8j94sNhqQ++xQ5gcnsNITo4qmxCZUoQh3
         2GH0L9E1h9F9b8V28jZBZY/2bZYXtjSQGO2csspWAbzMFxYNgvdcIuzKptf6SMQ8IuY8
         9GdB4phUgqNPDC8ezv3yBf2YYpeUZJfNckwbZDxEPjbufbxblXrztfToaD+adTBVu4hm
         2xPtFIOYa0FZOtbE3nUWzce2P/YGZklE6VYNcD6wdcaZ7PpXGJKS2JMj6P5D2W5PHhIx
         dJEw==
X-Gm-Message-State: APjAAAULb6IOM0KcjOhHVSaBJAz6EHzPchDMzT/LjcV9lUi7O1QeoN6T
        bRE/s8h1hL4bl9fUDBsdxT+KLN/3rew=
X-Google-Smtp-Source: APXvYqz0m8Uj8wfyziFtBWBjBjTUL/Z9Of09uDtePndTP5P5mPLSXYMTb8NHxRRoLTYPBndDjfGRgQ==
X-Received: by 2002:a2e:1290:: with SMTP id 16mr11013733ljs.88.1562618078823;
        Mon, 08 Jul 2019 13:34:38 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id j11sm2945979lfm.29.2019.07.08.13.34.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 13:34:35 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id k18so17283026ljc.11
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 13:34:34 -0700 (PDT)
X-Received: by 2002:a2e:b0e6:: with SMTP id h6mr5676774ljl.18.1562618073778;
 Mon, 08 Jul 2019 13:34:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190708125050.3689133-1-arnd@arndb.de>
In-Reply-To: <20190708125050.3689133-1-arnd@arndb.de>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 8 Jul 2019 13:34:22 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOjPbZ0k8dvWr3b6ns_Y3c_ydanYA9+HVUA00btJB5rxQ@mail.gmail.com>
Message-ID: <CA+ASDXOjPbZ0k8dvWr3b6ns_Y3c_ydanYA9+HVUA00btJB5rxQ@mail.gmail.com>
Subject: Re: [PATCH] ath10k: work around uninitialized vht_pfr variable
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Miaoqing Pan <miaoqing@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>,
        Pradeep kumar Chitrapu <pradeepc@codeaurora.org>,
        Sriram R <srirrama@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On Mon, Jul 8, 2019 at 5:50 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> As clang points out, the vht_pfr is assigned to a struct member
> without being initialized in one case:
>
> drivers/net/wireless/ath/ath10k/mac.c:7528:7: error: variable 'vht_pfr' is used uninitialized whenever 'if' condition
>       is false [-Werror,-Wsometimes-uninitialized]
>                 if (!ath10k_mac_can_set_bitrate_mask(ar, band, mask,
>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/ath10k/mac.c:7551:20: note: uninitialized use occurs here
>                 arvif->vht_pfr = vht_pfr;
>                                  ^~~~~~~
> drivers/net/wireless/ath/ath10k/mac.c:7528:3: note: remove the 'if' if its condition is always true
>                 if (!ath10k_mac_can_set_bitrate_mask(ar, band, mask,
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/ath10k/mac.c:7483:12: note: initialize the variable 'vht_pfr' to silence this warning
>         u8 vht_pfr;
>
> Add an explicit but probably incorrect initialization here.
> I suspect we want a better fix here, but chose this approach to
> illustrate the issue.
>
> Fixes: 8b97b055dc9d ("ath10k: fix failure to set multiple fixed rate")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index e43a566eef77..0606416dc971 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -7541,6 +7541,8 @@ static int ath10k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
>                                                                 &vht_nss,
>                                                                 true);

^^ Technically, this call to ath10k_mac_bitrate_mask_get_single_rate()
can fail to assign 'vht_pfr' as well. I can't immediately tell whether
it provably will never hit the -EINVAL case, but if we do, then you'd
have another uninitialized case.

I *believe* it shouldn't fail, since we already pre-checked the VHT
MCS lists for "exactly 1" rate. But it still seems like better code to
pre-initialize and/or add error-handling, so we don't rely on that
implicit proof.

I'm not quite sure yet what the "better" answer should be for
resolving this, but at a minimum, I think the above could be improved.

Brian

>                         update_bitrate_mask = false;
> +               } else {
> +                       vht_pfr = 0;
>                 }
>
>                 mutex_lock(&ar->conf_mutex);
> --
> 2.20.0
>
