Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD5234EBED
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 17:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbhC3PPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 11:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbhC3PPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 11:15:20 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFD6C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:15:20 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id jy13so25428989ejc.2
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/aWR9FqcuVLorBtT2JUaP/s1v9+TOaTgWe9ot4i57hc=;
        b=VXP0WD8G2U4sYoT3AYJBXvug44AIchRSXWe86MEc7mjjrRiji408iL/s2USHRlm+JE
         LtjUGWJEIpxtbfIcJ2T1ElzwVGvvGGoS9Vl5gm7tWh0qd/G01EdrkFwE1n2iCVAK/Awe
         6sG2SqTvEqQTezRQZdG4wjca8LY0poMnOO+U6OpMy7av2fZT/6yyhB8pkoZ7zmrfDTgP
         tLODrHkyrG99z0q9kvXboUF1kAWKS4KxAnki9pzyLfLJPmvIyz97HSlDM5g8morNWDho
         hEPwwzNWTnTcRpIz4tbUa0Kzu9JAYkqEr3tjqZRD4qMeMGIHUk/5lR+t7sXMdA0Qba7B
         sbOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/aWR9FqcuVLorBtT2JUaP/s1v9+TOaTgWe9ot4i57hc=;
        b=LZu8t+ay52WRxJ8Ao3u/q+AWhADcG0w6MvxLLxeIyywC8hBas/2eHbu2mphDID8qpj
         JSx2OkdhYd5T1t2lpUbb2hVbO/gGfEFcv29XRNbhCo6XKOTZmQi8cktCtkQDNJidHoWo
         1MU+C+YXqlk8aum3XJPaoQ8r/lrYt0+KjdetrgVzqhwP9qykEU91pLUmG6S5kx+8la9D
         yOcPhHRyWxUXj/CUjnTYugHyF03empdrYG+hRdHlS5NXJu9RB5icukRV0pUGfXX4p4Rn
         YmoNsPZQAY+OFZhGvQHlduAdgh+PLJC/eqOrh9wLW3omnDJuAuzkiNAl67Rw5+Mf7UJL
         ictA==
X-Gm-Message-State: AOAM531i+dYWRMtl/3B9l3YUsh85zUX5tiQhhsJLkP9+hwDjYHBe4F15
        FoR1aY+vcl9KPihhIgWGGGvJSbsEDXc=
X-Google-Smtp-Source: ABdhPJzJ079Q7ua8ZUVcdSd6XBozP/9sQvqfOIGn5UOFl1CjBYfXSinfMw4+foD/1eTrTXXqCzNf9w==
X-Received: by 2002:a17:906:4747:: with SMTP id j7mr33323263ejs.221.1617117318513;
        Tue, 30 Mar 2021 08:15:18 -0700 (PDT)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com. [209.85.128.53])
        by smtp.gmail.com with ESMTPSA id w24sm11169644edt.44.2021.03.30.08.15.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 08:15:17 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id b2-20020a7bc2420000b029010be1081172so8620971wmj.1
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:15:17 -0700 (PDT)
X-Received: by 2002:a1c:e482:: with SMTP id b124mr4486542wmh.70.1617117317135;
 Tue, 30 Mar 2021 08:15:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1617099959.git.pabeni@redhat.com> <e3d9aacc43a90b294d181fcda7f598b81d8eba53.1617099959.git.pabeni@redhat.com>
In-Reply-To: <e3d9aacc43a90b294d181fcda7f598b81d8eba53.1617099959.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 30 Mar 2021 11:14:40 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfhxmzhHwP5fX5Ck49tmk14TyO6R8tg=7VSU_AgVW8upQ@mail.gmail.com>
Message-ID: <CA+FuTSfhxmzhHwP5fX5Ck49tmk14TyO6R8tg=7VSU_AgVW8upQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 5/8] vxlan: allow L4 GRO passthrough
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

On Tue, Mar 30, 2021 at 6:30 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> When passing up an UDP GSO packet with L4 aggregation, there is
> no need to segment it at the vxlan level. We can propagate the
> packet untouched and let it be segmented later, if needed.
>
> Introduce an helper to allow let the UDP socket to accept any
> L4 aggregation and use it in the vxlan driver.
>
> v1 -> v2:
>  - updated to use the newly introduced UDP socket 'accept*' fields
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>
