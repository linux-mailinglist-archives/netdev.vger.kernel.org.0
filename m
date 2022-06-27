Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8BB55B637
	for <lists+netdev@lfdr.de>; Mon, 27 Jun 2022 06:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbiF0Efd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 00:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiF0Efc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 00:35:32 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D68C2705;
        Sun, 26 Jun 2022 21:35:31 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-3176d94c236so74013957b3.3;
        Sun, 26 Jun 2022 21:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VGnevX9G/FAyne4kSDIYkylm7uDGxuW8ROK7dj8djTU=;
        b=jnKuFHRe8aDzO2iz4XQOY1V9LFpDgHE5SEAevG6hW9hXWObyXQCRHLuR744OOeFSpK
         1844PoEFgKZHwXM1kVTPW3WF02pfiR5PEbYWad5V8c+dGS/5k8FQgVni8FWf2KTJ3By7
         pil7JfCEilKzbFW5ou9bm/nkw041yXO+0I4m/DV3nPqDWBFD6FmTplReYL58WC3iV8IA
         STl6OaVoFPJCWbWLC2+auMaKFYDG+K0tkcQyZ9W0DZVGkUX/Dxrk+7CbzqODt+aP4nKR
         kMNSXX059dF0Iry5PyG/tny+84AHkRocaBbimKFVenAx1UMXlEoPOBCwZ8fbDS1BStt7
         SdqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VGnevX9G/FAyne4kSDIYkylm7uDGxuW8ROK7dj8djTU=;
        b=sGn+HhfbKtAElcfZaM5NpbY2naKqoEw+uMxph28lKbn+i0xnRFa4UIJhXDgzM3+zVK
         v1y45NcSRMocmLjTV/wp8A+eq4Mv+QGs1I4JDE/MCxh9GfZFKxMJkyLacUHGkzNf2/WD
         jaBSISg/ZvG4VU/rZyOqnbeO0zAVdrRSRZl83AQ7B4YL/R1FkXJJeUx+JtN482z1kOv9
         q6hc8ljOWWrQySDb5Krsdg/FveheDYwJyge/KY2VCWmMi9yVvcvD70/AmaZ9tP8Qa5Ry
         PdKGKecD1dRv4xtIc1KPUwWqj5Bs9324kZ8wiBVgTR63BcOp82PlCrscLM+lLPSEjNzO
         4H3Q==
X-Gm-Message-State: AJIora/5mIi4S/1ABlDiQGkIkp6T7KX+/Rj52Tq+jXvpxS40hcajWScN
        Lq+0bu766tiqMxPV+0VY+XElkr/A9mCXY6AW9QU=
X-Google-Smtp-Source: AGRyM1t7KykIAaCX7WD+tEM1BhnRcAySF8DERATDtuPkh5nwN+ghkCh2OCLDJF8Y20efpQjPQW9/Q9Z7KAJWpV9yX6Q=
X-Received: by 2002:a81:1942:0:b0:317:7e9f:75b with SMTP id
 63-20020a811942000000b003177e9f075bmr13117916ywz.398.1656304530162; Sun, 26
 Jun 2022 21:35:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220623074005.259309-1-ztong0001@gmail.com> <YrQw1CVJfIS18CNo@electric-eye.fr.zoreil.com>
 <20220624114121.2c95c3aa@kernel.org> <CAA5qM4Aq_2HSxCgaHUgZX9C3E0OCPT4tN-61-MZP1iLXCbF-=Q@mail.gmail.com>
 <Yrh2Om1c7ins9VrK@electric-eye.fr.zoreil.com>
In-Reply-To: <Yrh2Om1c7ins9VrK@electric-eye.fr.zoreil.com>
From:   Tong Zhang <ztong0001@gmail.com>
Date:   Sun, 26 Jun 2022 21:35:19 -0700
Message-ID: <CAA5qM4DGB_YR=uaZcK7CHnLzonuoS7vf=9B3tWF5_BWK9gFvpw@mail.gmail.com>
Subject: Re: [PATCH] epic100: fix use after free on rmmod
To:     Francois Romieu <romieu@fr.zoreil.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Yilun Wu <yiluwu@cs.stonybrook.edu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 26, 2022 at 8:07 AM Francois Romieu <romieu@fr.zoreil.com> wrote:
>
> Tong Zhang <ztong0001@gmail.com> :
> [...]
> > Looks like drivers/net/ethernet/smsc/epic100.c is renamed from
> > drivers/net/epic100.c and this bug has been around since the very
> > initial commit.
> > What would you suggest ? Remove the fix tag or use
> > Fix: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>
> 'Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")' has already been signed-by or
> directly used by maintainers, including netdev ones. See:
>
> $ git log --grep='^Fixes: 1da177e4c3f4'
>
> The patch will require some change for pre-5.9 stable kernels due to
> 63692803899b563f94bf1b4f821b574eb74316ae "epic100: switch from 'pci_' to 'dma_' API".
>
> --
> Ueimor
Thanks! I amended the fix tag and sent it as v2.
- Tong
