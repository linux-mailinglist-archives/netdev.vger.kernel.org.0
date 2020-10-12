Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B0428B200
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 12:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbgJLKKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 06:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgJLKKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 06:10:17 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48210C0613CE;
        Mon, 12 Oct 2020 03:10:17 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k6so17087714ior.2;
        Mon, 12 Oct 2020 03:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tp7HRNglYkSYlHTMwdQ8CqrWv4lkJ3UZ4jPPZbiT0w8=;
        b=RkV/yrq87KRN+ZdT+fVgaogDRvqI7qxlTKUFPFuz7EAuKxlAwzlXgoW3TGzCyn5wzZ
         acw8iPUT+GDlYLdTk6IQT9nlCM6+S0jSI5F6+58o1m9UGPxDQA3eX6xB2x9H9QAGZBZO
         FnvNsi1BTywqqGQ8PeJhoXwkcBtJZofBZWT+p35sZJd0pnxO2ESHjjAP3Nmt0DxiD2EV
         oY/v/BRjn8MzXOBQ4SRKGD5vj1jWWEZ1smL07IpWgqJm7DQchOJsLYKp+0YRK5zFWkmU
         3JCSpZYNlPucdEg+mqYoYAhtegjpkoTSGvJz4ks2GT/b8R7FHVc6d4Tn6gGFo3uQ9STw
         IV5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tp7HRNglYkSYlHTMwdQ8CqrWv4lkJ3UZ4jPPZbiT0w8=;
        b=Mv7s+ePMPNpMeLq0RltxbkXAN1TP8nSsqaF4fyPr/qFtStdihMT5N66gZlLrGa2FwX
         CU9EryyXLwtabNvtnK0r34fRi2DpQEwEAecZtkBKHhn0v+5c94XOMnXgYUnXB22aX+ZO
         CD/BL2KdQy60j67zNUgaN/qBh8DA8zYfWxHZ8/yeuurZ241HuppCOqkVMvAf+oS4XCBg
         jB2SZR8nhVN8XXzAY2eu5Qzquvas7iJN8qDUDLzdmgRWmPpRA+RWYaMHK08/K46D/5Ag
         P/E3GnBBwUD+OgTxc5B1j5wzQvxLpGGDZl11sSWbs9pPCkobWSEMNaz7LILZ8xxokKIv
         UpNA==
X-Gm-Message-State: AOAM530KutlvmrbGOaUmTjfG4LHmOLd0VFVLNHRk8g/ULR10MABJIEkM
        PQ4Y7JJIv1AAilJfX+jl83sVsDUFVRb8+w8T22cc3LjPYT8V7w==
X-Google-Smtp-Source: ABdhPJwyXdKy3QD2HduXOgESaOpjgh3eI35re+YqyX6qHYFviec1TXWOxd3MR/xX0wpvdU1JCunTg+kRRYREeIwYlGM=
X-Received: by 2002:a02:6cd0:: with SMTP id w199mr19024504jab.121.1602497416540;
 Mon, 12 Oct 2020 03:10:16 -0700 (PDT)
MIME-Version: 1.0
References: <20201007101726.3149375-1-a.nogikh@gmail.com> <20201007101726.3149375-2-a.nogikh@gmail.com>
 <c310818ecec06fe34d535bb61f3a50a1cf669f40.camel@sipsolutions.net>
In-Reply-To: <c310818ecec06fe34d535bb61f3a50a1cf669f40.camel@sipsolutions.net>
From:   Aleksandr Nogikh <a.nogikh@gmail.com>
Date:   Mon, 12 Oct 2020 13:10:05 +0300
Message-ID: <CADpXja_PYfwBcigR-D9m7bsJg-fnPN921YeOrJJzYZTM3PftjQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: store KCOV remote handle in sk_buff
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        nogikh@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 at 10:12, Johannes Berg <johannes@sipsolutions.net> wrote:
[...]
> > @@ -233,6 +233,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
> >       skb->end = skb->tail + size;
> >       skb->mac_header = (typeof(skb->mac_header))~0U;
> >       skb->transport_header = (typeof(skb->transport_header))~0U;
> > +     skb_set_kcov_handle(skb, kcov_common_handle());
>
> Btw, you're only setting this here. It seems to me it would make sense
> to copy it when the skb is copied, rather than then having it set to the
> kcov handle of the (interrupted) task that was copying the skb?
>
> johannes
>

The field is added to the part of sk_buff that is between
headers_start and headers_end, therefore skb_copy will copy the field
to the newly created buffer. So in the case of copying it will be
initialized, and then overwritten. Probably, it's not the most
efficient way, but it seems to be the same for some other
fields that are initialized in __alloc_skb.
