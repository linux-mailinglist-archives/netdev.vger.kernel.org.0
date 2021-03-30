Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0286234EBF1
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 17:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbhC3PQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 11:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbhC3PQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 11:16:19 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F39C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:16:19 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id dm8so18660227edb.2
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JBeWOzpgkgAmreLHtMmdVr3HcLHRKehe5YCWkZ52w64=;
        b=Bf74gY6pnKNp8ygNox3PZ64Ir+ww/1cuOel8mb2kSDJqYeMtzVIZAckkc4XWFWn+Hq
         PKRSqeODad+m1oxf0TN04cuMKDZKMpb6qZkQ8aM57PGnD3LExaan0JH996TsICVRnLuj
         yGMpxnyrpIg+zGtDohWOWoFA4jup0/U10wSGKuRhAIDQfaLrDru790Vo0YoaxaRbRXBg
         x7RLWRPVUMcnBpIpDC/pkf49EFu/7N17pG49HdJeCP/Wa6IvZLgmFcJcfJp6JQbe4ibX
         Ap2TUM5GbKkTzDC17a3/T76F/ADcGQu3GuQHM/mhKyqUCth20XC5KG37wvPASDiObAux
         5VlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JBeWOzpgkgAmreLHtMmdVr3HcLHRKehe5YCWkZ52w64=;
        b=kilJe/rBrOJpAu6+W52OTwrRlQrXD+yfd4QrYD5IR3NcWsKnW7wUM/9ZV+zz073HP6
         gCf1uccPAuXGdNwcvZeYQDcHVYnuBsuqORMvsasrFkxU49IxkSCeclx7RcYEV/9jhjCh
         v0A0/aDA/GfXdzsQYWyk/aqMzCNG7BMaVldNbgsp8wiA+EWOAJNhHDFkmdYMUoaIegTE
         h1D74sRX6mT/xsYZ0pa7ELBpIVcLdGM5bpIMPmc0KlA7wHAIFt2XmwqkC8yqYg1KiqSh
         SAZ0LHjowMnwSCzYo7mOFwKgR590IfW03PuN/zKuPx65Yq0IqpTG867kMdXXpw8YImpd
         IGyw==
X-Gm-Message-State: AOAM530ZQxTPJsFIuT6+jIlaLYtnDKlPdu1LHfKHvislwFwLX3LqJ6Ee
        mPAJ0uU39EdfzHKTymfEWf+fTavtLRA=
X-Google-Smtp-Source: ABdhPJwOqnb2DrAu6KFDC4qLMx+BEXDJj5sm0pyZpZx5vwHBHdcpVt0PsxTCGqxfxr0Zkkdw1hhiow==
X-Received: by 2002:aa7:c684:: with SMTP id n4mr20268160edq.141.1617117377666;
        Tue, 30 Mar 2021 08:16:17 -0700 (PDT)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com. [209.85.128.43])
        by smtp.gmail.com with ESMTPSA id gb4sm10164663ejc.122.2021.03.30.08.16.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 08:16:17 -0700 (PDT)
Received: by mail-wm1-f43.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so1185457wma.0
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:16:16 -0700 (PDT)
X-Received: by 2002:a05:600c:4150:: with SMTP id h16mr4624428wmm.120.1617117376437;
 Tue, 30 Mar 2021 08:16:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1617099959.git.pabeni@redhat.com> <6430002178b54a389ea50413c7074ba9b48d6212.1617099959.git.pabeni@redhat.com>
In-Reply-To: <6430002178b54a389ea50413c7074ba9b48d6212.1617099959.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 30 Mar 2021 11:15:39 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdgNT8LfySseSB2Yaw8xm5woB8cM_BFrr=LH01L-98T0g@mail.gmail.com>
Message-ID: <CA+FuTSdgNT8LfySseSB2Yaw8xm5woB8cM_BFrr=LH01L-98T0g@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/8] udp: fixup csum for GSO receive slow path
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

On Tue, Mar 30, 2021 at 6:29 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> When UDP packets generated locally by a socket with UDP_SEGMENT
> traverse the following path:
>
> UDP tunnel(xmit) -> veth (segmentation) -> veth (gro) ->
>         UDP tunnel (rx) -> UDP socket (no UDP_GRO)
>
> ip_summed will be set to CHECKSUM_PARTIAL at creation time and
> such checksum mode will be preserved in the above path up to the
> UDP tunnel receive code where we have:
>
>  __iptunnel_pull_header() -> skb_pull_rcsum() ->
> skb_postpull_rcsum() -> __skb_postpull_rcsum()
>
> The latter will convert the skb to CHECKSUM_NONE.
>
> The UDP GSO packet will be later segmented as part of the rx socket
> receive operation, and will present a CHECKSUM_NONE after segmentation.
>
> Additionally the segmented packets UDP CB still refers to the original
> GSO packet len. Overall that causes unexpected/wrong csum validation
> errors later in the UDP receive path.
>
> We could possibly address the issue with some additional checks and
> csum mangling in the UDP tunnel code. Since the issue affects only
> this UDP receive slow path, let's set a suitable csum status there.
>
> Note that SKB_GSO_UDP_L4 or SKB_GSO_FRAGLIST packets lacking an UDP
> encapsulation present a valid checksum when landing to udp_queue_rcv_skb(),
> as the UDP checksum has been validated by the GRO engine.
>
> v2 -> v3:
>  - even more verbose commit message and comments
>
> v1 -> v2:
>  - restrict the csum update to the packets strictly needing them
>  - hopefully clarify the commit message and code comments
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>
