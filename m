Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A472A0B0F
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgJ3Q1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgJ3Q1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 12:27:22 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B89C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:27:22 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id t8so893717vsr.2
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bep9AfD1MRCjrXXe8vaQR1eGt2W/4JPt3j0HqUAR8Kc=;
        b=fPPw5/rMgTq6GYM9/CnVQANTQVZj4fqNJLTkqAoJ2XCviiPxhrtlx/USdS0coEyxUq
         XFk7P5Pr/MiCh0IcK3sUkDUaC8BSucn4H9vxPGcoz7SuomFhAQENjotpHLs8qsUfBYIS
         ZnFHur0NNGCn5WLxbSTWYp8EVfb1oMhiq+wz/34wN7ekOB0xIwaDpJ4e/E/OLrgryGcm
         P8nLCh5MvaNhX8uLILR2h3IE4khldnGF/T31OGGDFUbn/lryu+SX9YZEcWHnmueztgig
         wPVp0DXQHRzJ+jABMCkKGo5fwV43GrLb/yZXsmqb501Je6n6mkAKBHOsupQrI8FGdLzy
         jLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bep9AfD1MRCjrXXe8vaQR1eGt2W/4JPt3j0HqUAR8Kc=;
        b=hD/Y5tCm6P+2cu3lNnyGbUAJUhnEGax9w/Jx5JsXvbG7hmnhRL4ea+xUms8P47Qios
         sahZCMlK4mTM+kNLV1Cz6M+MPlehLB9lsUIBDIRu8lj5wCurmwiqB9jTOwiMFfLDo7Km
         27/AOSEVE2Xr9wXx1zZ4AweqvFqasJLzESWTFyRxiKwpoIEUHaE31LJsjktO/IlixQ+a
         4VFJES6TWzJ0+5b5HDGrdQTNLQgRbyaQ1cEvT0RKQEHqOyEQNT7br6K79dwqDRX4cSMs
         V+WpUav+XWReef0X8z2+tW8g20Ipl13YGWF1qDf6gIeOA4kqI5wjcanIqr6E/2QF/3nk
         0inw==
X-Gm-Message-State: AOAM5312h3ugaB0qZFP898OPejMlvaicBJKOJ0aHyYfazF+U7mkzrDDE
        zyIPM4s1cso8523z/g3mW9WNBfxU4hE=
X-Google-Smtp-Source: ABdhPJwAwWCJAYLCf/nzhRVR6puy4F2RIYDVQF47V7kzRjyxHa1IIvLO02SvoDviCwbtFiquJMFt3Q==
X-Received: by 2002:a67:f8d3:: with SMTP id c19mr1770939vsp.36.1604075241491;
        Fri, 30 Oct 2020 09:27:21 -0700 (PDT)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com. [209.85.217.53])
        by smtp.gmail.com with ESMTPSA id 123sm799208vsr.6.2020.10.30.09.27.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 09:27:20 -0700 (PDT)
Received: by mail-vs1-f53.google.com with SMTP id b3so3712906vsc.5
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:27:20 -0700 (PDT)
X-Received: by 2002:a05:6102:2f8:: with SMTP id j24mr8038385vsj.13.1604075240051;
 Fri, 30 Oct 2020 09:27:20 -0700 (PDT)
MIME-Version: 1.0
References: <6e1ea05f-faeb-18df-91ef-572445691d89@solarflare.com>
 <94ca05ca-2871-3da6-e14f-0a9cb48ed2a5@solarflare.com> <CA+FuTSdaPV_ZsU=YfT6vAx-ScGWu1O1Ji1ubNmgxe4PZYYNfZw@mail.gmail.com>
 <ca372399-fecb-2e5a-ae92-dca7275be7ab@solarflare.com>
In-Reply-To: <ca372399-fecb-2e5a-ae92-dca7275be7ab@solarflare.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Oct 2020 12:26:43 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdk-UZ92VdpWTAx87xnzhsDKcWfVOOwG_B16HdAuP7PQA@mail.gmail.com>
Message-ID: <CA+FuTSdk-UZ92VdpWTAx87xnzhsDKcWfVOOwG_B16HdAuP7PQA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] sfc: implement encap TSO on EF100
To:     Edward Cree <ecree@solarflare.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-net-drivers@solarflare.com, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 12:16 PM Edward Cree <ecree@solarflare.com> wrote:
>
> On 30/10/2020 15:49, Willem de Bruijn wrote:
> > On Wed, Oct 28, 2020 at 9:39 PM Edward Cree <ecree@solarflare.com> wrote:
> >> +                             ESF_GZ_TX_TSO_ED_OUTER_UDP_LEN, encap && !gso_partial,
> >
> > This is a boolean field to signal whether the NIC needs to fix up the
> > udp length field ?
> Yes.

Thanks

> > Which in the case of GSO_PARTIAL has already been resolved by the gso
> > layer (in __skb_udp_tunnel_segment).
> Indeed.
>
> > Just curious, is this ever expected to be true? Not based on current
> > advertised features, right?
> As I mentioned in the patch description and cover letter, I'm not
>  entirely certain.  I don't _think_ the stack will ever give us an
>  encap skb without GSO_PARTIAL with the features we've advertised,

That's my understanding too.

>  but since the hardware supports it I thought it better to handle
>  that case anyway, just in case I'm mistaken.

Then you could (as follow-up) advertise without GSO_PARTIAL and avoid
the whole transition through the gso layer?
