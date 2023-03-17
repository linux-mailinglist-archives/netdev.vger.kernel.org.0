Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821BD6BEE52
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjCQQbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjCQQbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:31:05 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5219B26B3;
        Fri, 17 Mar 2023 09:30:50 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-5418c2b8ef2so104137947b3.5;
        Fri, 17 Mar 2023 09:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679070649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CRgK9HXnvQYGCYlTJ91NuAOKkUDg3MnLpGvNTEpeww4=;
        b=bgPmsxjfSPA4IdWJVcAvzhCH91tzUHGQGFqOVs0xQ7jIWPnAEwRVTPuD60L1dX3G6y
         oP2bcXHLQOJvT01gbMc7Lg8NN6OtesBP7w38zFILGQUtAyi+8PiqrAVPfeffayrqsM5j
         5wwkLmeRKFmn5ne7owhcVi+0ipgIM7FnUqCkzAip8PyfGNhCNuVFnFnZcQs0Jfs1bKQB
         Hi4oHOKjO+HqXjoPVMK4V8bwVZSGuxQidud9Bw9PjmnMa3loXg6nXJcXDhuGPE1c7kY9
         eFj8K+MkDqlzSFe3gQhSfy5NwxloxZ5W2KZmv11jvv8F6uAaAjkHk7NXS+ZXzJQZ+ADG
         xGdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679070649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CRgK9HXnvQYGCYlTJ91NuAOKkUDg3MnLpGvNTEpeww4=;
        b=jtbgG+T7AybwOC8mAen6R5SeZ7dLatAfroAJQ4QcTGBED0iawebnjx718nMUKoReOs
         b+03rOLKuqoOk1/gRBIncfZ6guFoTT78Tuy+zbwdIZFtqH/tvws8Qaptv/BD/UMVGaDf
         SESfPIvGV7641UgEsdhOMYEpPr204cwyDv1whrOF6rNG5mUiWnq3vx2l4xmvKI6L9uFA
         xxSWJKRHvG2DLjICKAqrbmc9YuLyDlbLLlAeFLqHMictIc4ZBJmStiKWmwDrAmS/DejX
         84ehZtEcYzwVwMqomTj+h2T4E3Aq/IY1T4iuKdnECz3k01Q1OBAZJD7SqwRaMcOe0r8b
         aosQ==
X-Gm-Message-State: AO0yUKVfcJVvhR76IIfo3Ruo2gHFaL3gUtyxlhgWz9N0yxd4wZfssEwJ
        VymcSJ4oEK5ZNIUXrqQdpyL+7DBrY88NzKIVo/A=
X-Google-Smtp-Source: AK7set9FI9Sdh2CkgmBb0Hs4iCQvJYE/QrsPtuHkAgmvvHGfh9IQTw/riL8AUdBpkT9mpSNrwYIjog/oMd6qPICAn7I=
X-Received: by 2002:a81:e8f:0:b0:544:b9dd:e27a with SMTP id
 137-20020a810e8f000000b00544b9dde27amr2427864ywo.1.1679070649422; Fri, 17 Mar
 2023 09:30:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230317113427.302162-1-noltari@gmail.com> <20230317113427.302162-3-noltari@gmail.com>
 <20230317115115.s32r52rz3svuj4ed@skbuf> <CAKR-sGe3xHkN-1+aLn0ixnskctPK4GTzfXu8O_dkFhHyY1nTeg@mail.gmail.com>
 <20230317130434.7cbzk5gxx5guarcz@skbuf> <CAKR-sGeFZLnuqH=4Gok1URJEvrQKxbk203Q8zdMd9830G_XD7A@mail.gmail.com>
 <1ed6d7d9-4d3e-4bcb-8023-75bb52c2f272@lunn.ch>
In-Reply-To: <1ed6d7d9-4d3e-4bcb-8023-75bb52c2f272@lunn.ch>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Fri, 17 Mar 2023 17:30:38 +0100
Message-ID: <CAKR-sGfMF+UtL4kY2hJ9gw4=jQu1JAqqF3N0obeUE=vGj8R-yA@mail.gmail.com>
Subject: Re: [PATCH 2/3] net: dsa: b53: mmap: register MDIO Mux bus controller
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        f.fainelli@gmail.com, jonas.gorski@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
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

El vie, 17 mar 2023 a las 17:27, Andrew Lunn (<andrew@lunn.ch>) escribi=C3=
=B3:
>
> > > The proposed solution is too radical for a problem that was not prope=
rly
> > > characterized yet, so this patch set has my temporary NACK.
> >
> > Forgive me, but why do you consider this solution too radical?
>
> I have to agree with Vladimir here. The problem is not the driver, but
> when the driver is instantiated. It seems radical to remove a driver
> just because it loads at the wrong time. Ideally you want the driver
> to figure out now is not a good time and return -EPROBE_DEFER, because
> a resource it requires it not available.

Ok, I'm open to suggestions.
Any ideas on how exactly to figure out when it's a good time to probe
or return -EPROBE_DEFER instead?

>
>   Andrew

--
=C3=81lvaro.
