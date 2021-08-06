Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623593E2EF6
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 19:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241665AbhHFRpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 13:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241661AbhHFRpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 13:45:06 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E10C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 10:44:50 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id b1-20020a17090a8001b029017700de3903so12904563pjn.1
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 10:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z2dc0BZe51MH320JqbfFcX30KUAz7IVRZkgKOB1D8F4=;
        b=tVR3+ZEfMNNaznbtgqpBxwi/BdyBhs+OdLAuiP3sNprTIk9tBQiplrh0BKNO7oeIdt
         gDn6K31sFp3/kBghlAOJNS6Sdo8pGIiCX1bjE2xTDBJr48/X4pFZxm7PrB7pcf0xG/+o
         CGzo8OUed6yVDcK62fI0AQyyjbqEQM53xulpQO7v8V6uIf5FwstNe8DAOhsFdcLm38MS
         aFVbcqKnYIMRQjLh1GwTR8LLUfCdIGvDgxUJt4nETag19JF2ptU0FKzEQc/p23NTdZN/
         2Sex/vlQiazZmhgz2SVHp07d0pmpXVgDt7jPnCEu+i9MM5SE/O9kl805fS7hK8sJcU8D
         4jqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z2dc0BZe51MH320JqbfFcX30KUAz7IVRZkgKOB1D8F4=;
        b=J88yxxCrxo4cZG801tYKISKTfW/60iuEmqZGeLcQru7n4vuDxriiXYea0JRHEJ4EtI
         AkSBOwmI/Amu9AkK91xd3Hoi0wnRWjbntdkNyJk0fl9XfFOUMbwSzFfHkvftna21Ivxv
         1D/CuVEavCZorK/vpRq/KiCesj+u6YMKcbXC4Ks/0ne9TS5m1kmlq3lbV/4hfuTt8bwC
         eeKnHCPsj100aEiAmCByQp6CtfLEYNoaE/W63DfiOO5Jt4SfYoqWE4TcDqBn/vaX4fDg
         IXgGYhNPBvfaKjXDZ+sWA3CpvycM9/UjLwzD/NJQYzLi02F6Cr5i0phrdKfBMAVS6PXO
         5gXQ==
X-Gm-Message-State: AOAM531m9WwE2Bd4PUUiCAA4ZuO2rRRxG6AiRx5RxCCKkvaraFTKAbZz
        4EKGrs4EPrPzjM1H70Ztc5wDBGuQK2rmJG6bV9jPew==
X-Google-Smtp-Source: ABdhPJwE1U+Yl6EuKIF7iX675qoLDk0AiOBcIdm05Kkb5mTwW8CgznRoUMpoqu4ihfLvnd4Fu//n5Vpx3/tAasy6q/8=
X-Received: by 2002:a63:a0b:: with SMTP id 11mr596725pgk.229.1628271889814;
 Fri, 06 Aug 2021 10:44:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210805073641.3533280-1-lixiaoyan@google.com>
 <20210805073641.3533280-2-lixiaoyan@google.com> <6595b716cb0b37e9daf4202163b4567116d4b4e2.camel@redhat.com>
 <CADjXwjhvb9BVNPjY2f-4yfE51RGL88U3VbiN_gwaMSGbagzQEg@mail.gmail.com> <dea381f16949a076860a550ae1db91dcca935f8f.camel@redhat.com>
In-Reply-To: <dea381f16949a076860a550ae1db91dcca935f8f.camel@redhat.com>
From:   Coco Li <lixiaoyan@google.com>
Date:   Fri, 6 Aug 2021 10:44:38 -0700
Message-ID: <CADjXwjjCTCLY0MraywXP+98NXy_tvTtnJ=eogiq2aLQMqF_r4g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] selftests/net: GRO coalesce test
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Tanner Love <tannerlove@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sounds good! I'll work on a follow up patch.

Best,
Coco
