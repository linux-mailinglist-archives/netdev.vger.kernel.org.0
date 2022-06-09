Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607B0544529
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 09:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbiFIH6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 03:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbiFIH6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 03:58:51 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65134EAC
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 00:58:48 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id x6-20020a1c7c06000000b003972dfca96cso863154wmc.4
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 00:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst.fr; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-language:content-transfer-encoding;
        bh=r6BJ2fqC01OZgkvp46nCFzQQ2UQ5wFj5JCbh0Sv7Bg4=;
        b=zNeXV/3vdM5FVg3nD1+30vKQfLPXLiHzlD45qbe4wYafxph4WPbapPUlAz9zLZsAHB
         C67pEQyM4rSWv1OT/t0gmjqnQ0hUwwCRCUjHFmb2x+U2lwz/CJ4M89qXIQ9IznHhTXI8
         l+xN4E10PCdWrLweMIKuzNo2AngM5Gfaa2GDuwosJxJuK3stTk8ihjYHgfY8tBLPidIq
         lWZv0XL6yrG0KxdQ+EEr917AHuA9azseGFQgAYwpIxF/JedCfr9+/hhHfzb0Aach5IpU
         fgEd3/S6wu9JrHCsCGkkgXY7wn8kPL9FF9xl7jrXBWNyGhqyTppO1HtDqqafy0MY7OPX
         T5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r6BJ2fqC01OZgkvp46nCFzQQ2UQ5wFj5JCbh0Sv7Bg4=;
        b=cr8n4slQ06Z2nrt7+PbLqc2qUSUohQ9t/UyNlwHP5kGCt69W9Ue+L548wRTuNDaXip
         2mQ5bmIDWTNZTDLsAW1jB51zZwWg1aAaR3AIBLNCnVwDfgb5SEp+YqJ8fUdGMd+O+jUi
         Q7EbOhi7H2orJg4D9C7EjQgnbMEjIBV3IGVnb7m553k/eR93Huj1ed70zXYiqUOZ+0Sm
         ygx2AlXXOmlwg0BnNLisQ34mUM+T0zhvYuu+s6xt4v7C34GFevWVWwtkR7NeNLK9uCZm
         ERM9Q68NnchgcPdYrSXvYIB1dYaJyIegZaB43yxBp2GErqWHJMEoQKGIvSsWXC7EEOa8
         Lwkg==
X-Gm-Message-State: AOAM533QGMm+RRsh7nDXBe9+hWPi8yEHFqf+N+Va2OHzvAX9B/bS7oY5
        4BVU3D8EIlLCkvcwBW68Z+Xnx+d4yGbtm8xCFeTiXf2wKCAb5POxGr94NFwfv43c90ju2vys35w
        jH9aRUsfnhg==
X-Google-Smtp-Source: ABdhPJysrdv3o+2a9+gC7iTtVKchXN9HA07au4X6pHH0pcfLUI2/Dv3foB5nkfeJm5VlHJiD1OBzbQ==
X-Received: by 2002:a05:600c:2847:b0:39c:4f07:e31f with SMTP id r7-20020a05600c284700b0039c4f07e31fmr2044624wmb.53.1654761527008;
        Thu, 09 Jun 2022 00:58:47 -0700 (PDT)
Received: from [10.4.59.130] (wifirst-46-193-244.20.cust.wifirst.net. [46.193.244.20])
        by smtp.gmail.com with ESMTPSA id x5-20020a05600c21c500b003942a244ee7sm20689085wmj.44.2022.06.09.00.58.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 00:58:46 -0700 (PDT)
Message-ID: <d0f91700-0a0c-b464-4a25-2f0cc24987e6@wifirst.fr>
Date:   Thu, 9 Jun 2022 09:58:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 net-next] net: neigh: add netlink filtering based on
 LLADDR for dump
To:     David Ahern <dsahern@kernel.org>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20220509205646.20814-1-florent.fourcot@wifirst.fr>
 <b84e51fa-f410-956e-7304-7a49d297f254@kernel.org>
 <8653ac99-4c5a-b596-7109-7622c125088a@wifirst.fr>
 <af7b9565-ca70-0c36-4695-a0705825468d@wifirst.fr>
 <d8a28a59-79ca-e1fc-7768-a91f8033ce0e@kernel.org>
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
In-Reply-To: <d8a28a59-79ca-e1fc-7768-a91f8033ce0e@kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

>=20
> Kernel side filtering has always been kept to simple, coarse grained
> checks - like a device index or upper device index. It's a fine line
> managing kernel cycles holding the rtnl vs cycles shipping the data to
> userspace. e.g., a memcmp has a higher cost than a dev->index
> comparison. I see the point about GET only - potential for many matches
> and a lookup of the ll address is basically a filtered dump. Mixed
> thoughts on whether this should be merged.

Thanks for your feedback. As you know, this option will not slow down=20
standard dump.

I understand your concern, but the choice is between:
  * putting all entries on socket to send data to userspace. It means=20
several memcpy (at least one for L3 address, one for L2 address) for=20
each entries
  * Use proposed filter, with a single memcmp. memcpy is not called for=20
filtered out entries.

My solution looks faster, but I can send a v3 with some numbers if you=20
think that it's important to get this patch merged.


Best regards,

--=20
Florent Fourcot

--=20
*Ce message et toutes les pi=C3=A8ces jointes (ci-apr=C3=A8s le "message") =
sont=20
=C3=A9tablis =C3=A0 l=E2=80=99intention exclusive des destinataires d=C3=A9=
sign=C3=A9s. Il contient des=20
informations confidentielles et pouvant =C3=AAtre prot=C3=A9g=C3=A9 par le =
secret=20
professionnel. Si vous recevez ce message par erreur, merci d'en avertir=20
imm=C3=A9diatement l'exp=C3=A9diteur et de d=C3=A9truire le message. Toute =
utilisation de=20
ce message non conforme =C3=A0 sa destination, toute diffusion ou toute=20
publication, totale ou partielle, est interdite, sauf autorisation expresse=
=20
de l'=C3=A9metteur*
