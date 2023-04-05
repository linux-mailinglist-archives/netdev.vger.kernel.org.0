Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7046D849B
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 19:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbjDERLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 13:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbjDERLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 13:11:48 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A3E5FD4
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 10:11:33 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id l27so36937791wrb.2
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 10:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680714692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1y/vJsTY2A1FmW6gUN68//G6OPTX98iG+jP/G/a/zJM=;
        b=dZbMPFY68y9iEW2Nh9Um+VS3HWqMX0n3QwotDEDFpuhfdzxDKtvslt9cv69LbQy1vx
         C731Y+zGEP+IhKBbHt6lCOh8+RyWrMstzlbYbN4ItrwoIlOrRNkh2IlvP+hh2CfhvIpO
         OYVUO5I0aRjTNlhDcijvJI+fL7wd/A+J3hLuOP2quIMGXcybGgEeSJiqJp1swVqK2O/w
         tZwBR4gf7inmERAeJ1hv2v8BVX5ThU/bfPdZ7AIYiZEDNim/lsdxmJlExRhCzseLE69k
         YsuyKeYuswrDH5nuOyyQRx396YHJApeFWmSmE5/q4Yc7PcpsiJ72JT1bJLFoOb6XXwPk
         wOZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680714692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1y/vJsTY2A1FmW6gUN68//G6OPTX98iG+jP/G/a/zJM=;
        b=IBFxyw22+1e5vWHxz3sxktTg+htz47n4pJi04M3uEovZPI09M2KpfkBU5iEw100Cro
         ckLsa3zG9d7k/CcKkiukoacAxQWmo+w0AgGlbIS2fG+wUbxwjk2UFdAV2qXIpp/6TMmB
         irI3xf4e/1IsNHZR3V2lwZw2HM/+QD3cdeVRTlnF3fuW4jOKgfOJhVbViuhA9+TwU5AZ
         Ei5L57hRUSkA8T1DJqSOHL6K6pgpxZSxWfqEw2cOKnt6iQfJz2A/+f3IUM3Yxsg4dmmF
         2D6cBEVntzRHTI/l9ki8IbBoAI+9akkuap29LCzvOLlsIB3FUro9aGbM2LjN+zbFF3yf
         iFmw==
X-Gm-Message-State: AAQBX9dawaYs3dpapdgj6aqYwv2LW+NyytmCvb+RgiEiw9XGg+v/oXY8
        JmCi3u3caLUu1OT/W3D8f12Op7zY++7f8hz5YHO+Hw==
X-Google-Smtp-Source: AKy350aVs7YHwY2DXOMfkJRcPYYAXCpnl3wMEKlBVXUMSBZUYJTBMyjkIOwxhBRY5o6ey03/NjX6jfhWbaz3kkDOB9o=
X-Received: by 2002:a5d:4601:0:b0:2cf:e70f:970c with SMTP id
 t1-20020a5d4601000000b002cfe70f970cmr1309284wrq.12.1680714692069; Wed, 05 Apr
 2023 10:11:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230331043906.3015706-1-kuba@kernel.org> <1f9cf03e-94cf-9787-44ce-23f6a8dd0a7a@huawei.com>
 <CANn89iKsNYizAvoFisrFBSb-vXnn6BjkR7fuR1S5vQLggcLCdA@mail.gmail.com> <263c9940-ecd6-eba1-c971-2fd743671905@huawei.com>
In-Reply-To: <263c9940-ecd6-eba1-c971-2fd743671905@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 5 Apr 2023 19:11:20 +0200
Message-ID: <CANn89iLopSNwoEyZayuXnu7=Oc3=8nNdg1YDnjM_m5dzWHn9zA@mail.gmail.com>
Subject: Re: [RFC net-next 1/2] page_pool: allow caching from safely localized NAPI
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 4, 2023 at 12:50=E2=80=AFPM Yunsheng Lin <linyunsheng@huawei.co=
m> wrote:

> Is there any reason not to introduce back the per socket defer_list to
> not acquire the defer_lock for one skb at a time instead of adding
> per-cpu caches?

This is a disaster on hosts with millions of sockets.
Just think how many pages _one_ skb can hold, and multiply this number
by 10,000,000

per-cpu is the more natural way to make sure this kind of cache will
not use an unbound amount of memory.

We had the same issues with sk->sk_forward_alloc per-socket reserves.
