Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3774534AEA1
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhCZSbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhCZSbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 14:31:06 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF9CC0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 11:31:05 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id l4so9806145ejc.10
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 11:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TOVnee5aO55od2eNOXdJeJeFnQPtbxaZgbiCUYuBH5w=;
        b=VfJjCynbRqUqphPo2Gal+V8t6/3CEa4NM15MH4FuH+YOfFJzDt39RPLzk7g/jMcUmG
         gwb6twjn9Mdb8uHK7uQeIMoz9vi7l9qxfLUGW1A588peldKh/XcwGPrJTA2qAP4nbRu2
         cWtPzYm/xHwlEzSQ9hRo5qJXK1p5SxdGW6ueaqCW6Whg3mvlkw1TfyORQlGnMmiLl6Oc
         s/yfeNm5/55AMwLdeiBMShLD76gIeoGt1Y2vK6Yv7DkobqcOYuPbCZzkjDGnQHFg3hKy
         FBQY2tjr8KA0B0kGNDvX6Ci55mocFlxXoh57pC4DP1d1yfJx//5btQhxnCG/RwVmKkK+
         +oaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TOVnee5aO55od2eNOXdJeJeFnQPtbxaZgbiCUYuBH5w=;
        b=NSUxtfKukP6Kz2VyxLyw3bPrqSqiABMX4bQ0r1+qh1CFSoxgdzQbdBowZqMeJKEjhS
         Sslq3nFkR5ZCXnxiLvEkW30k9GKoSHhvbPn1Pcg0jTMdtxJ4x4hxsYDrfClw6S18rvIm
         NRwyPP0DP4fkGfWZS5qOVG4bI473ZFtD6Qvsx0Mkn8ecnHSJloXQlh6fGM2GALSJ0/zg
         JxWQCz2YEQ58ni4XYZJBg649SPhDBRDBHX3Lqm/rJZJWK69dyKElEfy2RoRXQ7Qq1cbZ
         ZxBGwDj085dt+Z+/ptuXx4+kJl+j+Lkp083TAeIezZkyiRK0cmZkKdYH9T61nxea+RsT
         2Tpg==
X-Gm-Message-State: AOAM531QoF3mDor+aD3dozWe7HH172z3mYhdmMsK4zowbLxs/akzYYF3
        etytedPqoK5l4bQYXIS305szORMb3as=
X-Google-Smtp-Source: ABdhPJyV7Oks+50Rtxv2xS6GBY1rwR5cdUox4Td0p1a18dDTeG9XONyh/PnACdIeDB35A+N0mU9a1A==
X-Received: by 2002:a17:906:b752:: with SMTP id fx18mr17385740ejb.128.1616783464051;
        Fri, 26 Mar 2021 11:31:04 -0700 (PDT)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com. [209.85.128.46])
        by smtp.gmail.com with ESMTPSA id x1sm4191172eji.8.2021.03.26.11.31.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 11:31:03 -0700 (PDT)
Received: by mail-wm1-f46.google.com with SMTP id g20so3452015wmk.3
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 11:31:02 -0700 (PDT)
X-Received: by 2002:a05:600c:4150:: with SMTP id h16mr14231305wmm.120.1616783462323;
 Fri, 26 Mar 2021 11:31:02 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616692794.git.pabeni@redhat.com> <28d04433c648ea8143c199459bfe60650b1a0d28.1616692794.git.pabeni@redhat.com>
In-Reply-To: <28d04433c648ea8143c199459bfe60650b1a0d28.1616692794.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 26 Mar 2021 14:30:24 -0400
X-Gmail-Original-Message-ID: <CA+FuTSed_T6+QbdgEUCo2Qy39mH1AVRoPqFYvt_vkRiFxfW7ZA@mail.gmail.com>
Message-ID: <CA+FuTSed_T6+QbdgEUCo2Qy39mH1AVRoPqFYvt_vkRiFxfW7ZA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/8] udp: fixup csum for GSO receive slow path
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

On Thu, Mar 25, 2021 at 1:24 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> When UDP packets generated locally by a socket with UDP_SEGMENT
> traverse the following path:
>
> UDP tunnel(xmit) -> veth (segmentation) -> veth (gro) ->
>         UDP tunnel (rx) -> UDP socket (no UDP_GRO)
>
> they are segmented as part of the rx socket receive operation, and
> present a CHECKSUM_NONE after segmentation.

would be good to capture how this happens, as it was not immediately obvious.

>
> Additionally the segmented packets UDP CB still refers to the original
> GSO packet len. Overall that causes unexpected/wrong csum validation
> errors later in the UDP receive path.
>
> We could possibly address the issue with some additional checks and
> csum mangling in the UDP tunnel code. Since the issue affects only
> this UDP receive slow path, let's set a suitable csum status there.
>
> v1 -> v2:
>  - restrict the csum update to the packets strictly needing them
>  - hopefully clarify the commit message and code comments
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

> +       if (skb->ip_summed == CHECKSUM_NONE && !skb->csum_valid)
> +               skb->csum_valid = 1;

Not entirely obvious is that UDP packets arriving on a device with rx
checksum offload off, i.e., with CHECKSUM_NONE, are not matched by
this test.

I assume that such packets are not coalesced by the GRO layer in the
first place. But I can't immediately spot the reason for it..
