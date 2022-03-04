Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA7F4CDEA6
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 21:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiCDUHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 15:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiCDUGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 15:06:37 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930C11BFDF7
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 12:01:21 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id f38so19020005ybi.3
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 12:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S0hgM+UUFcR3uDXF/xP2YGoAG6MiXhyiVMH8Jve4w2M=;
        b=JWHsUs5DIK+NouQSBaB/f6c3Uixo4+apR6o9cWahmW2tRDLgRJM3wJBYLg0oGD0j8b
         755VDHwxbbQavBbT13PXbFmTx1qb6G5s2PmPD3txvJHPwloJ/QMuWFKACMuLjfXTg9MM
         lc9+pVCRq0V7aWOodllPKpXQIERVSDVu0mpOeYmwbibRFuwMfQZ2vmCe/GdpmA1nLHDp
         Nz+MBDVceLzBmCexRXFOa4AGQRrZPhwRBKXRbnRVmRWBvl3GsNcRmAiMAoo/dxIq7ipL
         4qNSXqYraiWRNcWN6rgrmw6FA1ob1VTUlL5fxRUSHmUDgQj68iWngWkD6XQrp/E6A3qO
         zzfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S0hgM+UUFcR3uDXF/xP2YGoAG6MiXhyiVMH8Jve4w2M=;
        b=mXIW6h/2r/nuISESQknBADklLtEI1lA2phplm2quHIMUIbamqoyUStovlt/ZPDd6/6
         u02Ffaj+EUkbPM/qYgfakMZHRZkZ8Iuy2jQskvFEJ7zfhilgxRTWZu5bWydiYiMTUFvq
         J1blwK1OnMNRRStiMD4WmezzYV9nep9Aq7kxkrHjR2iDLa05BXlhNxAmfalEYTAtHH2g
         8TOa4sgcBPOeF287SnHdJGwFCEZ68tbuMxCHIPrBcPAmP42RVGqpkwP1udrRI/Z0MKne
         EovtU4EFlio/kueSw/VASOw2Irnhs73FfASE+BNh9hhU+Wj9TqSbjlr1d6TgC7kpztPy
         rCNA==
X-Gm-Message-State: AOAM531fbe8U+F3vMtJg1Vz1yJ2aaan/oNFDb4fPNqT/9hveavZCCITh
        CgEQ31RQjGq+dqJSyDJNFdLCGV/+056HesWbKh1z88i0J4s=
X-Google-Smtp-Source: ABdhPJxj86jlR/Nf5BMY/fLztK0Sqbj0s6hWowm4DI7YcujF4fxssFrX58GlPiCdeCI+5lylBc1OxewF+INcp9tWY9c=
X-Received: by 2002:a25:8c86:0:b0:628:a042:9529 with SMTP id
 m6-20020a258c86000000b00628a0429529mr13684307ybl.231.1646422146966; Fri, 04
 Mar 2022 11:29:06 -0800 (PST)
MIME-Version: 1.0
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-5-eric.dumazet@gmail.com> <3e50ceabe3f1ea4007249afb6a30bda8996884c7.camel@gmail.com>
In-Reply-To: <3e50ceabe3f1ea4007249afb6a30bda8996884c7.camel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Mar 2022 11:28:55 -0800
Message-ID: <CANn89i+pb5tt4JhEUGf6ip=urQXT=LoiHKk-7H_wkoA6ZRDNaA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 04/14] ipv6: add struct hop_jumbo_hdr definition
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        David Ahern <dsahern@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 4, 2022 at 11:26 AM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, 2022-03-03 at 10:15 -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Following patches will need to add and remove local IPv6 jumbogram
> > options to enable BIG TCP.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  include/net/ipv6.h | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> > index 213612f1680c7c39f4c07f0c05b4e6cf34a7878e..95f405cde9e539d7909b6b89af2b956655f38b94 100644
> > --- a/include/net/ipv6.h
> > +++ b/include/net/ipv6.h
> > @@ -151,6 +151,17 @@ struct frag_hdr {
> >       __be32  identification;
> >  };
> >
> > +/*
> > + * Jumbo payload option, as described in RFC 2676 2.
> > + */
>
> The RFC number is 2675 isn't it?
>

You are right, thanks.
