Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D2634ECE2
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 17:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhC3PuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 11:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhC3Pt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 11:49:57 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C626CC061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:49:56 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id u5so25564024ejn.8
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=idUbi6GfA5sYoezB01U4nl6vmoYtLWNdAxiknTw0R0w=;
        b=MGuD0UOO6ns2pd8khMBoqFyDn0NC/DO7FB1WR6GP8Em+85tNc4hqfkWGaVFhwsdaN3
         IL0VhzsMQBd2BDLQ+M1WLOMp3RAU2LLCfkWhL/1r9RRYYFr10bqlG9/ef7TWw++rhRo2
         Lg7/FowyubwAu4dGKqdunnzr2sGG8jaUY4guCzOLTj9pRARZU7ZF2PpmLnRfgE8C7zUK
         56p69ge8hkhHwlbe9OQQyPQnUQiM2oINFOjbifuGQVb/kyk+LMCh9JLlDUqaD5dbBgOk
         SpSQCfykYqjHueBKr3z1dnrw36jm0hw+yLBGL7OpICRUvKGP84UVMzmKGG52F25J/6No
         fgng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=idUbi6GfA5sYoezB01U4nl6vmoYtLWNdAxiknTw0R0w=;
        b=EKo2zBzkKiL+5omqu5VQ3n44bGW8LWpu/Zl1zZWk1uiarn5vAbMbrEpv04dyqMCobr
         M7Qa9ATivGNAzLCud/dgaIGAmHW21ARRLq89+jmriL6ZDOwflg6tnTFQmc7wGgtgXLkI
         gAc5Gj/muCZOmTyVI3PX3sgmlCUvGOF0ZbxQqEP+vlIwFA3y5/iMymfJNeFlwzRxUiq5
         nQv63AekNWrVkuFI78hML3wbzPkW58Gchzbg+EDPUlEbbjqcMPFlhbVvWP8tueJiLpxE
         TJNoqnuR7jLTcgWbwwRN1hO65ECDnGsQNKwyHXeGnvIzZ0k9Slhvd+oDeIRUssgeGf3N
         DCFQ==
X-Gm-Message-State: AOAM531T1EH35aIZQQzrP+6PSzYrMI0cCckAhrkHnRc2mBg/nDuH2LnI
        Fc5VNDG2LEJYKpXk8JK+NKxMfyST2ig=
X-Google-Smtp-Source: ABdhPJxRy6cBsJklDy5WLBW8j+Vz050KFAEozF/fklZ3cvto+D1QJM6Y9x82HZEVAgEMjM0LBADR9w==
X-Received: by 2002:a17:906:5902:: with SMTP id h2mr33886752ejq.416.1617119395313;
        Tue, 30 Mar 2021 08:49:55 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id b22sm11247857edv.96.2021.03.30.08.49.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 08:49:54 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id j18so16725492wra.2
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:49:54 -0700 (PDT)
X-Received: by 2002:a5d:640b:: with SMTP id z11mr33856969wru.327.1617119394143;
 Tue, 30 Mar 2021 08:49:54 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1617099959.git.pabeni@redhat.com> <9de587fd719db1cc318ee76cd7465ba8ca00c7cd.1617099959.git.pabeni@redhat.com>
In-Reply-To: <9de587fd719db1cc318ee76cd7465ba8ca00c7cd.1617099959.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 30 Mar 2021 11:49:16 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdoKrKPtRtKu5hKTL5hics+9+-pH3K7-aG=kFFUH4GimQ@mail.gmail.com>
Message-ID: <CA+FuTSdoKrKPtRtKu5hKTL5hics+9+-pH3K7-aG=kFFUH4GimQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 8/8] selftests: net: add UDP GRO forwarding self-tests
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
> Create a bunch of virtual topologies and verify that
> NETIF_F_GRO_FRAGLIST or NETIF_F_GRO_UDP_FWD-enabled
> devices aggregate the ingress packets as expected.
> Additionally check that the aggregate packets are
> segmented correctly when landing on a socket
>
> Also test SKB_GSO_FRAGLIST and SKB_GSO_UDP_L4 aggregation
> on top of UDP tunnel (vxlan)
>
> v1 -> v2:
>  - hopefully clarify the commit message
>  - moved the overlay network ipv6 range into the 'documentation'
>    reserved range (Willem)
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Acked-by: Willem de Bruijn <willemb@google.com>
