Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696A6322DAC
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 16:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhBWPiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 10:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbhBWPiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 10:38:07 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED9EC061574
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 07:37:25 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id a7so17498552iok.12
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 07:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nuaXO0cb1HyXVhqw+e5O+5Pe6WRMBqNbjk08Wiu4LIA=;
        b=W3oHiGyyepZVCryKU5/sfwMEeXv2SSHjhKOIkFWfW3Z3SHTYUNuD+KmiyCvlefNGqM
         fd9LC9DeTYhjY6cl8T+aqq+WKgzVfw9aP96DVd4UB5Lzxwi0FnA15Uor+UMET/SfINJ+
         jamjt1cqkIb8C1Iskt5qwdZGhu/5V/QMwABqKKPdRaAQfSGqDqGSa7rz0eRPFWgtTC7s
         f8I87wH1KXOnHQutzxa3KlDTXaRHEwGhxBFPHiLlMor15yN1YKe9U4D88dnlm7GwDckF
         dZLvqrhZtl9+hxv/c89clwYXkvkwwIWwjV6EE7Me9Ptek9QAxuenbBstMQq0ZNv1EJcq
         YjNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nuaXO0cb1HyXVhqw+e5O+5Pe6WRMBqNbjk08Wiu4LIA=;
        b=rJC73WTX1fhicTNxk0xQIktp+ceRFG17FB7mYIEMW/zSSmJNLl2wfihjegoYuFvxeG
         3BJ0btyl4OYd+R1c2uavqUHBFXGx8/decF7rlsGxSYgwKh9OQB6Np9HOQJyMCH8PAkl/
         NtuXeHJSJtySq+hnuQTJ3v+qpaKhc7d4IPbPn4DRgU5AWLR3NFev05WAvVjy89rOue5K
         6w2IlXBKDvDDomNgZrCgTGMjSjTT5drKAFxyfJk6ZEjiAtfavqIJFOWSXxppkmOALU9p
         yuqslk9urkrA6x9e1nLCzi5OTTy24w0YIpyiVHONbdUo6Zuo/NN+tVSmiibBM+zzZBL8
         XLAw==
X-Gm-Message-State: AOAM5338X+q27QYFMyphU+/RrlzkLnvzx+qxyaN8u16M2pUMYfnGVJoU
        mJhp9t/aY4ifTnMeU9tsUwVi5p5XJLXtDhshtp9cyYA7SHQfug==
X-Google-Smtp-Source: ABdhPJyVeLPe8YbxDJju3lQmIx2Szi+XJiyrTbNe8pGAbCjgCh0fXB0fV6GoElU7FXV2XY31rudG3JaQ60EUYqfXRkM=
X-Received: by 2002:a02:1382:: with SMTP id 124mr2037623jaz.144.1614094644941;
 Tue, 23 Feb 2021 07:37:24 -0800 (PST)
MIME-Version: 1.0
References: <20210219172127.2223831-1-eyal.birger@gmail.com>
 <20210220130115.2914135-1-eyal.birger@gmail.com> <YDUbYvCnRN/aBQrM@hog>
In-Reply-To: <YDUbYvCnRN/aBQrM@hog>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Tue, 23 Feb 2021 17:37:14 +0200
Message-ID: <CAHsH6Gs2=siz4a4CZAe3NDnKuhZKQDRk-kbB2ZdGjM1w9c2njQ@mail.gmail.com>
Subject: Re: [PATCH ipsec,v2] xfrm: interface: fix ipv4 pmtu check to honor ip
 header df
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        herbert@gondor.apana.org.au, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Feb 23, 2021 at 5:18 PM Sabrina Dubroca <sd@queasysnail.net> wrote:
>
> 2021-02-20, 15:01:15 +0200, Eyal Birger wrote:
> > Frag needed should only be sent if the header enables DF.
> >
> > This fix allows packets larger than MTU to pass the xfrm interface
> > and be fragmented after encapsulation, aligning behavior with
> > non-interface xfrm.
> >
> > Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> >
> > -----
> >
> > v2: better align coding with ip_vti
>
> LGTM. We also need to do the same thing in ip_vti and ip6_vti. Do you
> want to take care of it, or should I?

I can submit the same fix for vti{,6}.

>
> Either way, for this patch:
> Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

Thanks!
Eyal.
