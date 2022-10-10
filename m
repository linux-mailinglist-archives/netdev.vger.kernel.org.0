Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8B75F9CCA
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 12:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiJJK3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 06:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbiJJK3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 06:29:40 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9B91EEF2
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 03:29:28 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id de14so6870910qvb.5
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 03:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HAk+jIWcsGx20V+xJoRii9xzHTi+9gyCqOSiSPmuZl4=;
        b=Qv3W9cWpnTuMQCymoZ1Sx3kPx3L/B10M0CPDcQrzCZ5GFl6ha9O7I2Rrb3fK8RWAJ5
         KG2TUoAxbt2JQZMGjvYGPeYHRHIhpNwcvMZ1vOcgYW8FGXOWvZzPTqXE6hvmbSjmYe/+
         CEMdzBKqvY9G7Uc83W6lpSB9vMiX1pwzUejlaB5wKhunLZGhGKseFHn8ZzKSICb7zPx2
         u/oZ3LYw1lvey/FP5V8h3Ra2VHQ1Vso9+fOaqCBqkC+zpW88DQptkBohvyWjtqQQVs+D
         JLp+KIl8ngHjpasK1uAMW4WKLPTh0PI6vn7lnmgeOrui+Dl3waozOmEJ0yVnkHrwtxU4
         tsww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HAk+jIWcsGx20V+xJoRii9xzHTi+9gyCqOSiSPmuZl4=;
        b=U4D1/Bz/gV4EzlSBCkJsTWS0h/7975ZWaQ1gkAN7/0XFl79t8Jv3IMcpf1pEGtde53
         IE//5prHB3IImvMFPGMQwz81sSL2r7gLSj04uCOPnqUSyG51I8vERNIrLgAQxc+UVmvk
         rSj6IDuOXezKoHhg51wI6j8vn4w+blb01LipCjJz9Qg7vsVxvP9eqX6ieCbhVO3b7MtQ
         99JJP2Txn+P/lsnyy0c+a4coWkIpQjO/eL0gA3UIqvFX5loWx8TEim4jXaVUWbMYWtBz
         IkdZGSz9XROE3x29oU2S5c8sYbvNiHWaXyqfE17vjl2JgM6Hh4KNBzgfSB5BoOHf1Fq8
         YUcw==
X-Gm-Message-State: ACrzQf2r2rvAhC/G81DtC2CbwdPmtlFNZZpEsuwkYIpi9HV3B0JrnPE4
        ZkBlljYn0VXCwVIQdO6ALiSJdE1Vylp+NuRB/Ks=
X-Google-Smtp-Source: AMsMyM5jNpPWw/eIlQ3PNfxphVCS+Oyy8VZNuDo5Pj6w8bc/SL4CrHkqVe4HDOB2+FJloN+hP77+yW8icY9pw8p6xhI=
X-Received: by 2002:a05:6214:f65:b0:4b3:f4f2:fcaa with SMTP id
 iy5-20020a0562140f6500b004b3f4f2fcaamr4428501qvb.48.1665397766649; Mon, 10
 Oct 2022 03:29:26 -0700 (PDT)
MIME-Version: 1.0
References: <20221009191643.297623-1-eyal.birger@gmail.com> <1fc3c7b2-027b-374d-b77a-e5a01b70e73a@6wind.com>
In-Reply-To: <1fc3c7b2-027b-374d-b77a-e5a01b70e73a@6wind.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Mon, 10 Oct 2022 13:29:15 +0300
Message-ID: <CAHsH6GthqV7nUmeujhX_=3425HTsV0sc6O7YxWg22qbwbP=KJg@mail.gmail.com>
Subject: Re: [PATCH ipsec,v2] xfrm: fix "disable_policy" on ipv4 early demux
To:     nicolas.dichtel@6wind.com
Cc:     steffen.klassert@secunet.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        monil191989@gmail.com, stephen@networkplumber.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicolas,

On Mon, Oct 10, 2022 at 11:28 AM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> Le 09/10/2022 =C3=A0 21:16, Eyal Birger a =C3=A9crit :
> > The commit in the "Fixes" tag tried to avoid a case where policy check
> > is ignored due to dst caching in next hops.
> >
> > However, when the traffic is locally consumed, the dst may be cached
> > in a local TCP or UDP socket as part of early demux. In this case the
> > "disable_policy" flag is not checked as ip_route_input_noref() was only
> > called before caching, and thus, packets after the initial packet in a
> > flow will be dropped if not matching policies.
> >
> > Fix by checking the "disable_policy" flag also when a valid dst is
> > already available.
> >
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D216557
> > Reported-by: Monil Patel <monil191989@gmail.com>
> > Fixes: e6175a2ed1f1 ("xfrm: fix "disable_policy" flag use when arriving=
 from different devices")
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> >
>
> Is there the same problem with ipv6?

The issue is specific to IPv4 as the original fix was only relevant
to IPv4.

I also tested a similar scenario using IPv6 addresses and did not see
a problem.

Thanks!
Eyal.
