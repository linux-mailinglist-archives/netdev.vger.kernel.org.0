Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1932C1FA8
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 09:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730387AbgKXIM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 03:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728177AbgKXIM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 03:12:57 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C040C0613CF;
        Tue, 24 Nov 2020 00:12:57 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id j19so16761825pgg.5;
        Tue, 24 Nov 2020 00:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S6YlKWAgNMQGNjAA/VjKNCADAW62RGdxJPGcO5zwTnQ=;
        b=pWAicoTtEBPq4G6parGTFE9sr0a7BHS9fSt/zIZlqvicBHMpdpAWCtcXY0oHj2cMou
         g6sxuUF7fwfufyi+CplKMJo5ZBJ78vs8HF++TVGw744iMbXCMzW7duL0xj6gFdpbWzZn
         WZl/HaGVpYGwQKOGml70h3i1Khb2WctNlVse12WDcLHeBui86+AbY1oOXZ6eFtLHV67i
         LGfJS+TcvsK9BI76oGWe/zr5+tA/IKikckTlloZfiiKXPf7RG/PwD5iwuibq1qOkiZfF
         IiG1tIXYDnqezXqjvAcA/Hxrq2eB4GlX09aoRFrCS1WVkWwKiHqfwZDJHId8iHGqhcJK
         5qQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S6YlKWAgNMQGNjAA/VjKNCADAW62RGdxJPGcO5zwTnQ=;
        b=LI4oYFVDV6PQ/HtYS1twJdu9K5fCf3MNAKc5vMHX/kvcMjp/kz29NG0CIlg5ayg1MD
         RjX2LguwzSi5gW4H/LGSP5Sj5GzMT18Y9AFhFIndsBGAfD2t3wubHLJ0PyPFz4uJAJad
         cmLPdcMu/WQY8Rr606Rw3zHl5202xRWp1biEfEpqOQFgwUq+O+1OjgajnecsydWijKn6
         gSIU6dorPm7EEDWmTJplMUrE8lJ1T0cox0qXQGwTCP4FW4vuyhImTWbXBj8hIbuk2W5G
         vlisM6/Bu6/I6I85iebubHBWSeXPbCdbOec8GytWlpX06V/z2qcCRKfW/Rn12LoZARxS
         vaQg==
X-Gm-Message-State: AOAM530wtXPAmxyStkDYcJC0KrkavezMhKiwm+G5yS5BR6CF5Rubzj14
        YqdRyAQ8lfPBvdz1MFWSJRZS3OXGWi9O1pObohBRw3dCjfAgDCXtjDI=
X-Google-Smtp-Source: ABdhPJy3Dt6JV2iEPDRLzcs4CkirZ2Hig5hYVL55zqBA1wNXhN1z3naERdKQvVwF5rFHYxLyD9uYFi78H22vS4a+TTk=
X-Received: by 2002:a62:2bd0:0:b029:18a:df0f:dd61 with SMTP id
 r199-20020a622bd00000b029018adf0fdd61mr3095974pfr.19.1606205576999; Tue, 24
 Nov 2020 00:12:56 -0800 (PST)
MIME-Version: 1.0
References: <1606202474-8119-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1606202474-8119-1-git-send-email-lirongqing@baidu.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 24 Nov 2020 09:12:46 +0100
Message-ID: <CAJ8uoz0WNm6no8NRehgUH5RiGgvjJkKeD-Yyoah8xJerpLhgdg@mail.gmail.com>
Subject: Re: [PATCH][V2] libbpf: add support for canceling cached_cons advance
To:     Li RongQing <lirongqing@baidu.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 8:33 AM Li RongQing <lirongqing@baidu.com> wrote:
>
> Add a new function for returning descriptors the user received
> after an xsk_ring_cons__peek call. After the application has
> gotten a number of descriptors from a ring, it might not be able
> to or want to process them all for various reasons. Therefore,
> it would be useful to have an interface for returning or
> cancelling a number of them so that they are returned to the ring.
>
> This patch adds a new function called xsk_ring_cons__cancel that
> performs this operation on nb descriptors counted from the end of
> the batch of descriptors that was received through the peek call.
>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> [ Magnus Karlsson: rewrote changelog ]
> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
> diff with v1: fix the building, and rewrote changelog
>
>  tools/lib/bpf/xsk.h | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index 1069c46364ff..1719a327e5f9 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -153,6 +153,12 @@ static inline size_t xsk_ring_cons__peek(struct xsk_ring_cons *cons,
>         return entries;
>  }
>
> +static inline void xsk_ring_cons__cancel(struct xsk_ring_cons *cons,
> +                                        size_t nb)
> +{
> +       cons->cached_cons -= nb;
> +}
> +
>  static inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, size_t nb)
>  {
>         /* Make sure data has been read before indicating we are done
> --
> 2.17.3

Thank you RongQing.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
