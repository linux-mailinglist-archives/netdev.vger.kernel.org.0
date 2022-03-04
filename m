Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CFD4CD9EC
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240947AbiCDRRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236449AbiCDRRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:17:32 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7F21CD9F0
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:16:44 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2dc242a79beso88490637b3.8
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 09:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nQaMKntsJ/SPnc7wWdYnYjTXxWL4K4LBjyDT5CBhBpk=;
        b=Uh6kHNEpl8ECj5EBa6Ph4vKE2wvtuEQk34zn8LUM2NH768PQS/N61EyPSuirsOnfcR
         wyUPOKq79J44YWdHTiSFFeF9rLsbn6I2mSu3aur6yFf2D0G1rhJeLMbX9lTwMRP0Midm
         CaMFRuyBGsSyVmVSFGcWXgj6EJ38jZSIMx5pJ57tSTnxP+Kb8FX7jXor5S0HvN5oYPRe
         rosO69Q78bBbQeccdKIzywEIcpw1wfKjqH7JDXzxJPsBZgPQLxgNF9mlRfbNyM/DpFBN
         X+wNi0XVNJhvnZ1CEJyPOhLccQ0BAg3Yxu4RXoe0pVaCZsUbGFEzuj4GMsRkBgBI+O4F
         pBXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nQaMKntsJ/SPnc7wWdYnYjTXxWL4K4LBjyDT5CBhBpk=;
        b=iMEI58NPyUcjevwjrtUvoJGKism7D8ssywctVBd7f+YlNKdYUHTbmkV0GSHBym04fQ
         eKL+LQz2+c9JRWxoEukMVQBhYoCG66D0fU4mWk7dQmyxKzScP9Wew/4osEGHlQT/nBWk
         DSmZ0Fcmt6QYmegm4KyTqX6KXkKaGHpT0+Tk1UKPqMaObbaZyc3HtFZ019epHLXNcdha
         0FoUsvpGKK/uwIZDCXv63M4QDh/pfvqj/9jgk5eCO5TojMZrpnEjF1RMLTeUmTNcsxol
         aLHkmoKoFN8BETizI1ziSohv4KYjH31aGahURuq/7o1R69FpnE8teSukil5OHmyBJeYF
         B+9A==
X-Gm-Message-State: AOAM532VL3nWVouVALl0M+SgnsvsG4Qgb/o53MnCSLrCilPuwkrcBSC8
        VT6nIczMz29Ge5ba3StpLeGTXaLIzxQEFJ8XNO18txuDm6U=
X-Google-Smtp-Source: ABdhPJzK6nRNY8Rxxm+ElNle5R3Js3Gr4i3kQp2yJiFPLxIaXQlb2eU6EkP64ILXEi323TQjmSp5uW2BFKP2Wx+emrU=
X-Received: by 2002:a81:1043:0:b0:2dc:289f:9533 with SMTP id
 64-20020a811043000000b002dc289f9533mr11504963ywq.467.1646414203183; Fri, 04
 Mar 2022 09:16:43 -0800 (PST)
MIME-Version: 1.0
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-8-eric.dumazet@gmail.com> <f7c14a37-3404-2ad0-bb71-2446b52c572d@kernel.org>
In-Reply-To: <f7c14a37-3404-2ad0-bb71-2446b52c572d@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Mar 2022 09:16:32 -0800
Message-ID: <CANn89i+DTORA9B4TPoqfZifCns4dChJAGFXtunU5yg8efBM5aA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 07/14] ipv6: add GRO_IPV6_MAX_SIZE
To:     David Ahern <dsahern@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
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

On Thu, Mar 3, 2022 at 8:37 PM David Ahern <dsahern@kernel.org> wrote:
>
> On 3/3/22 11:16 AM, Eric Dumazet wrote:
> > From: Coco Li <lixiaoyan@google.com>
> >
> > Enable GRO to have IPv6 specific limit for max packet size.
> >
> > This patch introduces new dev->gro_ipv6_max_size
> > that is modifiable through ip link.
> >
> > ip link set dev eth0 gro_ipv6_max_size 185000
> >
> > Note that this value is only considered if bigger than
> > gro_max_size, and for non encapsulated TCP/ipv6 packets.
> >
>
> What is the point of a max size for the Rx path that is per ingress
> device? If the stack understands the larger packets then the ingress
> device limits should not matter. (yes, I realize the existing code has
> it this way, so I guess this is a historical question)

The point is to opt-in for this feature really.

Some software stack might not be ready yet.

For example, maybe you do not want to let GRO build skbs with
frag_list, because you know these skbs might cause problems later.
