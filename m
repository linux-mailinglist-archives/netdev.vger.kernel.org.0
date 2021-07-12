Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CDB3C62BE
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 20:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbhGLSls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 14:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhGLSlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 14:41:47 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13FCC0613E5
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 11:38:57 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id x70so14832984oif.11
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 11:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FZWI809EM0kWSYKdDeR8M3Ek3N/OKceTmzxiJRrMjv0=;
        b=U/qz5/PV6oqvmMd/Zt16iUeVPD3wWnzAUca3PgKD2HuN28lr4NPCgx6/NISCFp3Lvf
         6NnmIqLkvibjMtlj4qMqP4PURjO1zanRe/ubXj94xzlYNIrJ1A6uZsOF6LWwg/0dAY7M
         4ycBW0KE8kBx+CyIvNgS+m5OR9aU+vOSCtF2w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FZWI809EM0kWSYKdDeR8M3Ek3N/OKceTmzxiJRrMjv0=;
        b=oWPv2UV/lwFfrIrvMgGkMZFm5V4DiIhE8GbreYrg69pscLJ8bdv92v72u2xX50UU/k
         gkS49XEQyzr9KpbzWeb/Il9jtDYk4rDuDSBlt1919/W3AAQ0Wixjfp1D6mzo8AQxMTWa
         mhMxyC8A19ZgOGz/7Y0WNnuEi0G70TH0Dsvr4S1YxTdbVGCWRbQdn53WrCaDvbyvWugh
         cGzHbTEvlDZwn/f4y9IQ8UBVxFW6GoZ+nl8uh1cBlzPJUmeF9Bx7jD74vSQUC56DKTPm
         XdqMJaIyCb5hUcN4aCIHPOYkXUi6giBD3B+s0zk1NKBknd0O1gnROGCN4jirO85eXf2M
         nrpQ==
X-Gm-Message-State: AOAM533bqmxHL048nt/d7Jyp/AC6115bX0uoAuPpO1g+9plppmvyVEO+
        0sfg3hmTdg7q2npTdDviK6DZM1u1tFvRoQ==
X-Google-Smtp-Source: ABdhPJzO17mn9f01jRT2/ZZwr1pKG00hAZ7PTOuFdyW5jxMiXbY6dfzC6im99FscZjDGpnik0zpW9g==
X-Received: by 2002:a05:6808:6d1:: with SMTP id m17mr11361911oih.34.1626115136720;
        Mon, 12 Jul 2021 11:38:56 -0700 (PDT)
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com. [209.85.167.172])
        by smtp.gmail.com with ESMTPSA id r3sm2626995ooh.37.2021.07.12.11.38.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 11:38:55 -0700 (PDT)
Received: by mail-oi1-f172.google.com with SMTP id u15so6958695oiw.3
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 11:38:55 -0700 (PDT)
X-Received: by 2002:a05:6808:112:: with SMTP id b18mr3729139oie.77.1626115134537;
 Mon, 12 Jul 2021 11:38:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210711141634.6133-1-len.baker@gmx.com> <b0811e08c4a04d2093f3251c55c0edb8@realtek.com>
In-Reply-To: <b0811e08c4a04d2093f3251c55c0edb8@realtek.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 12 Jul 2021 11:38:43 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOC_dqhf84kP4LsbenJuqeDyKcNFj=EaemrvfJy1oZi_Q@mail.gmail.com>
Message-ID: <CA+ASDXOC_dqhf84kP4LsbenJuqeDyKcNFj=EaemrvfJy1oZi_Q@mail.gmail.com>
Subject: Re: [PATCH] rtw88: Fix out-of-bounds write
To:     Pkshih <pkshih@realtek.com>
Cc:     Len Baker <len.baker@gmx.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 11, 2021 at 6:43 PM Pkshih <pkshih@realtek.com> wrote:
> > -----Original Message-----
> > From: Len Baker [mailto:len.baker@gmx.com]
> >
> > In the rtw_pci_init_rx_ring function the "if (len > TRX_BD_IDX_MASK)"
> > statement guarantees that len is less than or equal to GENMASK(11, 0) or
> > in other words that len is less than or equal to 4095. However the
> > rx_ring->buf has a size of RTK_MAX_RX_DESC_NUM (defined as 512). This
> > way it is possible an out-of-bounds write in the for statement due to
> > the i variable can exceed the rx_ring->buff size.
> >
> > Fix it using the ARRAY_SIZE macro.
> >
> > Cc: stable@vger.kernel.org
> > Addresses-Coverity-ID: 1461515 ("Out-of-bounds write")

Coverity seems to be giving a false warning here. I presume it's
taking the |len| comparison as proof that |len| might be as large as
TRX_BD_IDX_MASK, but as noted below, that's not really true; the |len|
comparison is really just dead code.

> > Fixes: e3037485c68ec ("rtw88: new Realtek 802.11ac driver")
> > Signed-off-by: Len Baker <len.baker@gmx.com>

> To prevent the 'len' argument from exceeding the array size of rx_ring->buff, I
> suggest to add another checking statement, like
>
>         if (len > ARRAY_SIZE(rx_ring->buf)) {
>                 rtw_err(rtwdev, "len %d exceeds maximum RX ring buffer\n", len);
>                 return -EINVAL;
>         }

That seems like a better idea, if we really need to patch anything.

> But, I wonder if this a false alarm because 'len' is equal to ARRAY_SIZE(rx_ring->buf)
> for now.

Or to the point: rtw_pci_init_rx_ring() is only ever called with a
fixed constant -- RTK_MAX_RX_DESC_NUM (i.e., 512) -- so the alleged
overflow cannot happen.

Brian
