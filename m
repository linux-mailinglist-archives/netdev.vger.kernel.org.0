Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA8E26D72A
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 10:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgIQIvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 04:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgIQIvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 04:51:11 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F91C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 01:51:11 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id 7so837290vsp.6
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 01:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sj5UyJ8Py1XxMDm1b+Dp3kuayDC9hTLomojipNJ49uc=;
        b=jFzLRPPIW49GK3JuychHrqNiDw05L+uuzWGpzbxeyx8Du8MaP9ZsQ71e9xkmAz08Ps
         Zgn9QZ23r8KwHYIoTDS9kw6d1UxhgY21LUwAJDESWqBd5PmdYb5e6sKPcw0/LiePv1uL
         Ci8zwmuJv4I/hNyh4QkIV/TrGlUXIIRKEThamueOtLskzhc3tKRlZNhgwcb9PpYXVPYs
         9VjSAlghdUTyhLsTBXLUomEroYjo5QR+fdtWJtqMWAyB060b7SvEe1Glvv+l/Df0ZTnw
         ikcwKmWLMV21PrQ/mZNeDg4vj0gaT5tZW7ISSY6AuL1NLwY3MJ6ut939ADxj+CjF1XbV
         n0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sj5UyJ8Py1XxMDm1b+Dp3kuayDC9hTLomojipNJ49uc=;
        b=CBd01cTTTRBIW7Pzky6VqCr5eyK0C5Y2C6w4yJqq0Yj46RNZYOmgkixOTq+5qenurN
         naOK8SoL0YH2+/jFgSwHSJ6gOAyeql17xj6gJcby5CKpfBKqkglvKQDlcOJUBY38yXuA
         eUBkIeY8rgiaXJzl3gDYNmIpEzGbLFXynVZ14mCjchbaY+1qKSYdaL/51m0X8tlPbc+R
         tqZsg6DFwLkAcZ8927ywXOy8aDLyP66g4kbCamz0nsFRDn0jXNr/bljWhvFHO5AANlZu
         wAM7KPv/AgCJVAVDWDKCvALJF2OG4Nhr4TkVNAK7rgDU6wvKVT4tMs2E1raeZpxIr6Z/
         4LvA==
X-Gm-Message-State: AOAM530AL9di3YEKGNhrQdMKcjTD5mNc1qKilULLafVlc1K2LrzHcE7Q
        n4L51vE6YqVCUZIXkck0jYV1pn9B+msB8A==
X-Google-Smtp-Source: ABdhPJz2bIZBxaAjClSEdj/zL7hjmdSD1qvwT09749xROCN3XHYwHqvP2DcVDCAOTR9TgiNWvxEVeg==
X-Received: by 2002:a67:2645:: with SMTP id m66mr16987712vsm.16.1600332670212;
        Thu, 17 Sep 2020 01:51:10 -0700 (PDT)
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com. [209.85.221.181])
        by smtp.gmail.com with ESMTPSA id z81sm2966569vkd.22.2020.09.17.01.51.09
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 01:51:09 -0700 (PDT)
Received: by mail-vk1-f181.google.com with SMTP id e5so287987vkm.2
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 01:51:09 -0700 (PDT)
X-Received: by 2002:a1f:1f15:: with SMTP id f21mr16008951vkf.12.1600332668648;
 Thu, 17 Sep 2020 01:51:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200916122308.11678-1-xie.he.0141@gmail.com>
In-Reply-To: <20200916122308.11678-1-xie.he.0141@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 17 Sep 2020 10:50:30 +0200
X-Gmail-Original-Message-ID: <CA+FuTSf4di9Zsw+7XD1+3rwRMT4f0pUPprWKtmg83mVkHum9Zw@mail.gmail.com>
Message-ID: <CA+FuTSf4di9Zsw+7XD1+3rwRMT4f0pUPprWKtmg83mVkHum9Zw@mail.gmail.com>
Subject: Re: [PATCH net-next] net/packet: Fix a comment about mac_header
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        John Ogness <john.ogness@linutronix.de>,
        Wang Hai <wanghai38@huawei.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 8:54 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> 1. Change all "dev->hard_header" to "dev->header_ops"
>
> 2. On receiving incoming frames when header_ops == NULL:
>
> The comment only says what is wrong, but doesn't say what is right.
> This patch changes the comment to make it clear what is right.
>
> 3. On transmitting and receiving outgoing frames when header_ops == NULL:
>
> The comment explains that the LL header will be later added by the driver.
>
> However, I think it's better to simply say that the LL header is invisible
> to us. This phrasing is better from a software engineering perspective,
> because this makes it clear that what happens in the driver should be
> hidden from us and we should not care about what happens internally in the
> driver.
>
> 4. On resuming the LL header (for RAW frames) when header_ops == NULL:
>
> The comment says we are "unlikely" to restore the LL header.
>
> However, we should say that we are "unable" to restore it.
> It's not possible (rather than not likely) to restore it, because:
>
> 1) There is no way for us to restore because the LL header internally
> processed by the driver should be invisible to us.
>
> 2) In function packet_rcv and tpacket_rcv, the code only tries to restore
> the LL header when header_ops != NULL.
>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>
