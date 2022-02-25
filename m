Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65AE14C3C75
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 04:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbiBYDhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 22:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236588AbiBYDhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 22:37:41 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692396E56A;
        Thu, 24 Feb 2022 19:37:10 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id g7-20020a17090a708700b001bb78857ccdso7380678pjk.1;
        Thu, 24 Feb 2022 19:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=w4kU/agLvNDRYxAK8iCLDEEHKNEQqquvLbP28aEt//k=;
        b=n7lMhhxnECNDvblSTuLZz5utRr3tD3Kn6n4rwqKDtDEv7GnIqeoNhBQznjL0iSUKaw
         PPEBE0N5vuD2SBqN9IZMDAj1n0FAG6ekhNfiTQa51ThvRsW+MTio6NkWAUF5zWv9+uv9
         wcuYNFGke+A4KHNVLbk1HPAI9jKFygdHCooIKLfoV1sD0q8vhvM15hYr4Cfy/vMSActj
         i9jkrAyNuC/TIzXhLINIB2yXms0f+elU0oDyZ1qFfc6bL4um0JtnF3Z23Uw3z4RkL1Zp
         o6vUHXsb54+MxyyxZCU/4pJ/5JAoXvxYm/jocSLIdt9B9RG7jMO0cdOPJzYNX7YiZQxu
         IJnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w4kU/agLvNDRYxAK8iCLDEEHKNEQqquvLbP28aEt//k=;
        b=C2reE1CKKfvlYfKgBByfkwzrXlZ9/CsBbFdj9ke9BW4tu/qKwZ0KoCfrw/BVBRa6fo
         /nvMSTGLI3C81na3QtPPMJlnxT8VaEjXYBZz1katCTUKX5WKjkpe/cG+GboIp4Gvfh6B
         s820NHeJWqm33LhjwUNQGuooaGx+1BoD8GgPJkVYcmOEZAybZuuqrtwlG67LiH6omwwa
         DCgfIJ9mBDk+1wG6V1oEvYgLArVXg0hDUpUvaAKL7AXW4rNuevZL2aX1vpOdw1+099Yb
         62CUpqKxdGVA8XuNva3sv5wuP97CgGy3LzZ0qpUtyZJxrzKL+HqTtYliGNWMFQ4XsmH0
         fdFg==
X-Gm-Message-State: AOAM531eA4uME/xYFlNHdYO7i3tH6DusNKeCFKStnAAplaESlHkImKTc
        /+oJ151CEdjPhFJM3uW5tfXCegixXAxg5sJDDJ6ut765sD4rvXVt
X-Google-Smtp-Source: ABdhPJx3qooGIfV6JknyNM0UmE7xPtytOFgK0aHfeT25iHLKMeFk3bF1Imo+tnMW9sBiKVl4R6lj/H4eTiyI+tZTHqM=
X-Received: by 2002:a17:903:18d:b0:150:b6d:64cd with SMTP id
 z13-20020a170903018d00b001500b6d64cdmr5526610plg.123.1645760229931; Thu, 24
 Feb 2022 19:37:09 -0800 (PST)
MIME-Version: 1.0
References: <20220224103852.311369-1-baymaxhuang@gmail.com> <1de9e991f6c109d5986c857bc176e03d5e167944.camel@redhat.com>
In-Reply-To: <1de9e991f6c109d5986c857bc176e03d5e167944.camel@redhat.com>
From:   Harold Huang <baymaxhuang@gmail.com>
Date:   Fri, 25 Feb 2022 11:36:58 +0800
Message-ID: <CAHJXk3aSeNYdDksFjWOZaMueFtix8jYpcAV9qCThQjrX_5xRHQ@mail.gmail.com>
Subject: Re: [PATCH] tun: support NAPI to accelerate packet processing
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> =E4=BA=8E2022=E5=B9=B42=E6=9C=8825=E6=97=A5=
=E5=91=A8=E4=BA=94 01:22=E5=86=99=E9=81=93=EF=BC=9A
>
> Hello,
>
> On Thu, 2022-02-24 at 18:38 +0800, Harold Huang wrote:
> > In tun, NAPI is supported and we can also use NAPI in the path of
> > batched XDP buffs to accelerate packet processing. What is more, after
> > we use NPAI, GRO is also supported. The iperf shows that the throughput
>
> Very minor nit: typo above NPAI -> NAPI

Fix it in the next version.

>
> > could be improved from 4.5Gbsp to 9.2Gbps per stream.
> >
> > Reported-at: https://lore.kernel.org/netdev/CAHJXk3Y9_Fh04sakMMbcAkef7k=
OTEc-kf84Ne3DtWD7EAp13cg@mail.gmail.com/T/#t
> > Signed-off-by: Harold Huang <baymaxhuang@gmail.com>
>
> Additionally, please specify explicitly the target tree into the patch
> subject.

Fix it in the next version.

>
> Cheers,
>
> Paolo
>

Thanks,

Harold
