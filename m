Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278A82DA667
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 03:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgLOCrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 21:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgLOCrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 21:47:05 -0500
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E35C061793
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 18:46:25 -0800 (PST)
Received: by mail-vs1-xe42.google.com with SMTP id j140so10182974vsd.4
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 18:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JKDYfoD2YveWyRLE9FVGDqnZc519d7up4wSVOM0VYXg=;
        b=CQaYpmBp1+FbfgAFIpMsWhFEG6LO7xp6fdAXIlzWr0hQQz5Lw3US2gEfT7IHIj1ot4
         UJnQC7vHNHhfcR6z1bLLKlRjbnLuAKCOqWk0jYVdiXlagIX4hXjVhQMCcTRoGKX8r6eC
         NNtn6kVtCGPHWTQT+sb7ZyFXjNfvNoXyJorIZmxiak5w1Xg6bwLQbsIeJ991DIjHtWLV
         2mPs8VS9l3A6Z+vQeQyJdnF8kP43vWQB4R0/sFArpRDY/so4yX6iAjX2SnXLkhoNkT2l
         Xrkoasnv6EsYEFnHN59d9gq0cdw9WHQA/Q/SM+SqinXK5UGjbOGb1njBde02B37ZzPZ9
         g6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JKDYfoD2YveWyRLE9FVGDqnZc519d7up4wSVOM0VYXg=;
        b=cHXswUDyZab71CS0DIg+zVEggVn/JGQ+oZHkgVLreZuQ4n/0uTxWqsZFvFAI+0FwkC
         5nbwPt9PExxbf6ASAmBgiSviShu+NGGxWC0eCilUhZ7DzlMC1wx5NKxBoMDSekBMMuDD
         6ECaMAmLYhnTX32AdrKJFA2dHHYkqNAS9H1P3E2ugW2ON1dQJIxlVr3/YpVNmhJFYdO3
         TfnhZfEUKcSaVr2GLIKf9tP/warhKlag5M7Vlx71eXlZfuxffO3CMHRGa127h2orR1tN
         Id9UAoflsMnEc3MQrxFSaMbHDRcWqhsEcKgjmM/aRUF6lEbEVIDtBqP9cjIyzxyL6bbn
         24RA==
X-Gm-Message-State: AOAM533BGXOSM4dhguZgT9w+9R+6nYbPQAnb/O3h9trWrkoHTAPKHyry
        fWDxTSeS/h7YAstXZDiY3iJOIDAAKhY=
X-Google-Smtp-Source: ABdhPJxs7u4Ine3LhgYA1ZxqIoN0byvO6LymQJvONOsO1alqfoAMopVooUnHvjCkKNhoy16HHGydcg==
X-Received: by 2002:a67:de97:: with SMTP id r23mr26860202vsk.44.1608000384088;
        Mon, 14 Dec 2020 18:46:24 -0800 (PST)
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com. [209.85.221.170])
        by smtp.gmail.com with ESMTPSA id s204sm39063vkb.27.2020.12.14.18.46.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 18:46:23 -0800 (PST)
Received: by mail-vk1-f170.google.com with SMTP id w66so4436756vka.3
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 18:46:22 -0800 (PST)
X-Received: by 2002:a1f:1446:: with SMTP id 67mr11022573vku.24.1608000382303;
 Mon, 14 Dec 2020 18:46:22 -0800 (PST)
MIME-Version: 1.0
References: <cover.1608024547.git.wangyunjian@huawei.com> <5e2ecf3d0f07b864d307b9f0425b7b7fe8bf4d2c.1608024547.git.wangyunjian@huawei.com>
In-Reply-To: <5e2ecf3d0f07b864d307b9f0425b7b7fe8bf4d2c.1608024547.git.wangyunjian@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 14 Dec 2020 21:45:45 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeH-+p_7i9UdEy0UL2y2EoprO4sE-BYNe2Vt8ThxaCLcA@mail.gmail.com>
Message-ID: <CA+FuTSeH-+p_7i9UdEy0UL2y2EoprO4sE-BYNe2Vt8ThxaCLcA@mail.gmail.com>
Subject: Re: [PATCH net 1/2] vhost_net: fix ubuf refcount incorrectly when
 sendmsg fails
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        virtualization@lists.linux-foundation.org,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 8:59 PM wangyunjian <wangyunjian@huawei.com> wrote:
>
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> Currently the vhost_zerocopy_callback() maybe be called to decrease
> the refcount when sendmsg fails in tun. The error handling in vhost
> handle_tx_zerocopy() will try to decrease the same refcount again.
> This is wrong. To fix this issue, we only call vhost_net_ubuf_put()
> when vq->heads[nvq->desc].len == VHOST_DMA_IN_PROGRESS.
>
> Fixes: 4477138fa0ae ("tun: properly test for IFF_UP")
> Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
>
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Patch looks good to me. Thanks.

But I think the right Fixes tag would be

Fixes: 0690899b4d45 ("tun: experimental zero copy tx support")
