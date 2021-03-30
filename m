Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCA034EBE7
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 17:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbhC3PPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 11:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbhC3POm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 11:14:42 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3832FC061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:14:42 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ce10so25405862ejb.6
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zOF9DO8jsIER4xgcyjgP1P9rMPFoqYp5LnO/IB4A7ZQ=;
        b=RpXJ32LxkmIKJN2qIXxnYxCxcKlqj3GAr4HYWak4qI9S96ZkLWMT8v+OFasHVCjx+R
         5tvYl4y6OVFA9M4sAQtgFEzG1DgDmBVhk7UQQ4DrIs5QcmEyDarws2hKnT1aHN+gfAsB
         +rPF2Xla6/3YclHEvo4+rTSwPBZ8v0zjYUl9lHuKL65KpysEgoIpUXkt0BRU7eP+YncL
         QY3wBAO502Ve3+3/cU/85xQv8uhpdpnxiDbUrktj9yakTF884G0VP0J6BdXCi35AGAPE
         oennR3s7JbZl+mjwSKvLC7Nz1RQGgOR2pBbcTLjZ5Bjt6Trcf/ftTJhHaJpkmaeStwaQ
         cREw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zOF9DO8jsIER4xgcyjgP1P9rMPFoqYp5LnO/IB4A7ZQ=;
        b=SbFN32l9JE+ZE1utXoTgPeRz8V5W2yIu56fLHgchpdq5yXQ0aZZo7J5iSM27mHYX2D
         kTYS2rSLO41P/wqIu1N4fMpWpASRIqKTfGUYoP/ckyouhCx9tIQsFI9x4YMpIQ5QYzfE
         6O/U8km8TdOLrzlbPJwuCq9hEcoyaoPHCZ+vM7aNNFnmKWWI9LE5oVWrQS8iLHB4K5A2
         nccBc6horiQ95wKFMWf8eoGAQwpkEnUIPgHLAkDmB9cGkophWv/waAqcYS7J974TjQjM
         GIaW+xrnkb/piH5utD3TJm7dSWu/ec02fs9w20WreNTOG35VvrzKVlnfSe78ijBPJmnk
         ye3g==
X-Gm-Message-State: AOAM531MyMD3k259d9K+GmqOn0pMK4ilbwVl7JhuGBb3SjLJ0SXJLuXK
        WQxYMuJR6pwZvMAAEpax1BBUza9mK5Q=
X-Google-Smtp-Source: ABdhPJyzGMakpZjDn4xpyv5XfWf05Q4MSSJHyX8axi3isQm2i6RNCp9MSMwXqolp5QPlNnY7cpYTIw==
X-Received: by 2002:a17:906:1a4b:: with SMTP id j11mr34066261ejf.55.1617117280419;
        Tue, 30 Mar 2021 08:14:40 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id s18sm11743572edc.21.2021.03.30.08.14.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 08:14:39 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id b9so16573000wrt.8
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:14:39 -0700 (PDT)
X-Received: by 2002:a5d:640b:: with SMTP id z11mr33709379wru.327.1617117279234;
 Tue, 30 Mar 2021 08:14:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1617099959.git.pabeni@redhat.com> <4dc90e5bc0f6d7152e6b6dcde4bb409fd4c6d2ea.1617099959.git.pabeni@redhat.com>
In-Reply-To: <4dc90e5bc0f6d7152e6b6dcde4bb409fd4c6d2ea.1617099959.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 30 Mar 2021 11:14:01 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe9q2+PiGvUnyNSs48CjzABotNn1CE8V0VXKFwuhBhMOQ@mail.gmail.com>
Message-ID: <CA+FuTSe9q2+PiGvUnyNSs48CjzABotNn1CE8V0VXKFwuhBhMOQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 4/8] udp: never accept GSO_FRAGLIST packets
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
> Currently the UDP protocol delivers GSO_FRAGLIST packets to
> the sockets without the expected segmentation.
>
> This change addresses the issue introducing and maintaining
> a couple of new fields to explicitly accept SKB_GSO_UDP_L4
> or GSO_FRAGLIST packets. Additionally updates  udp_unexpected_gso()
> accordingly.
>
> UDP sockets enabling UDP_GRO stil keep accept_udp_fraglist
> zeroed.
>
> v1 -> v2:
>  - use 2 bits instead of a whole GSO bitmask (Willem)
>
> Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>
