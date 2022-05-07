Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71D551E2C9
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 02:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445023AbiEGAgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 20:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352201AbiEGAgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 20:36:42 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9EF5FF30
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 17:32:57 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2ebf4b91212so97312177b3.8
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 17:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EuVWIU7c/ujWMaJPD8qFDUE2nnFTFcz6MHBoh0Zl5EE=;
        b=reQvNDigeQQJSKRkTYq9GudU2/ZbYm0TpoDVQ+7+8qfytXEtIE8CC5A2ikIkw6o+P/
         atuREYqwhfENxZl0BAKzRPKTlSrb5P/8OXs6gg+PuWx0OWSRRhVjUSuX0CioQnuJiNrP
         aANLDy5DtrycLyQFOF+UdHftj538ZiPQzKxqr+RMJ1K/BbWEA835FdH3P2+x7VymzKZn
         boC9ChQeUVZsOoAzrNHBuJsj8/ttHrM4UwCWhxCJ4ZNanflSRubUVfPXNLZU4Fra17d8
         5TELnOqG4G3MjGstvUaVNaYcBYAj+93j2pr5pRJjbjJs81X3tuconkV6TwRX7J1DIqEK
         LTbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EuVWIU7c/ujWMaJPD8qFDUE2nnFTFcz6MHBoh0Zl5EE=;
        b=cdYkr8DRQSBltkkYjXwA+Mo1as7FIJNLUvnlhfwUfr71MafkRiXynGOQU9szN4u8Dy
         UQ9unTnpq+Qkbli9z1sYapttOAunDC01gOc2vraGqc8Mkn2ng6mCCTlNPx0BeNnIKx+G
         k1FebIOwGfyxOJKuMtE3VYyl1S4WmU0iqC5/8GAn6A73vM69Db279iS6EkaxNIPS1aQu
         vQQAteHb6sdLIPse3Nns1SqnxZHeytThETRhXF0UnOQq9Vy08oG0bb+7cQmplRRbj5nP
         zDQ0ILgewWgQYmtz+gpHGtslpuUm+c+AKozl2uth9QdNXNihe0ivyoq4sv3fdjtlhHUB
         0exw==
X-Gm-Message-State: AOAM533C4F7OVz2jqZcX+h0G0HDtO8z1Heq0vawmSUFgQkzV7tkPDNcR
        Ud3nyDkY/18ip/KfJvBR8NvfcLJyWSzjv6YG/iIIAQ==
X-Google-Smtp-Source: ABdhPJyxxYt+lLHf6Af5cqhY9rWcPL47QtjVcSdLi80ackQb7iK0oPUqvGFGEGlB/0zh9vWkLDVYCQNKIzatMeDTLv0=
X-Received: by 2002:a81:a016:0:b0:2f7:cfa3:4dc3 with SMTP id
 x22-20020a81a016000000b002f7cfa34dc3mr4692378ywg.467.1651883575135; Fri, 06
 May 2022 17:32:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-13-eric.dumazet@gmail.com> <20220506153414.72f26ee3@kernel.org>
In-Reply-To: <20220506153414.72f26ee3@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 6 May 2022 17:32:43 -0700
Message-ID: <CANn89iJDP1aSwsCyVVq_qjVY8OZjg-vWULR=GN-WQV6FpLz+Mg@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 12/12] mlx5: support BIG TCP packets
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 6, 2022 at 3:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  6 May 2022 08:30:48 -0700 Eric Dumazet wrote:
> > From: Coco Li <lixiaoyan@google.com>
> >
> > mlx5 supports LSOv2.
> >
> > IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
> > with JUMBO TLV for big packets.
> >
> > We need to ignore/skip this HBH header when populating TX descriptor.
> >
> > Note that ipv6_has_hopopt_jumbo() only recognizes very specific packet
> > layout, thus mlx5e_sq_xmit_wqe() is taking care of this layout only.
> >
> > v2: clear hopbyhop in mlx5e_tx_get_gso_ihs()
> > v4: fix compile error for CONFIG_MLX5_CORE_IPOIB=3Dy
>
> In file included from ../include/linux/string.h:253,
>                  from ../arch/x86/include/asm/page_32.h:22,
>                  from ../arch/x86/include/asm/page.h:14,
>                  from ../arch/x86/include/asm/processor.h:19,
>                  from ../arch/x86/include/asm/timex.h:5,
>                  from ../include/linux/timex.h:65,
>                  from ../include/linux/time32.h:13,
>                  from ../include/linux/time.h:60,
>                  from ../include/linux/skbuff.h:15,
>                  from ../include/linux/tcp.h:17,
>                  from ../drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:=
33:
> In function =E2=80=98fortify_memcpy_chk=E2=80=99,
>     inlined from =E2=80=98mlx5e_insert_vlan=E2=80=99 at ../drivers/net/et=
hernet/mellanox/mlx5/core/en_tx.c:104:2,
>     inlined from =E2=80=98mlx5e_sq_xmit_wqe=E2=80=99 at ../drivers/net/et=
hernet/mellanox/mlx5/core/en_tx.c:404:5:
> ../include/linux/fortify-string.h:328:25: warning: call to =E2=80=98__wri=
te_overflow_field=E2=80=99 declared with attribute warning: detected write =
beyond size of field (1st parameter); maybe use struct_group()? [-Wattribut=
e-warning]
>   328 |                         __write_overflow_field(p_size_field, size=
);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~
> In function =E2=80=98fortify_memcpy_chk=E2=80=99,
>     inlined from =E2=80=98mlx5e_sq_xmit_wqe=E2=80=99 at ../drivers/net/et=
hernet/mellanox/mlx5/core/en_tx.c:408:5:
> ../include/linux/fortify-string.h:328:25: warning: call to =E2=80=98__wri=
te_overflow_field=E2=80=99 declared with attribute warning: detected write =
beyond size of field (1st parameter); maybe use struct_group()? [-Wattribut=
e-warning]
>   328 |                         __write_overflow_field(p_size_field, size=
);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~
> In function =E2=80=98fortify_memcpy_chk=E2=80=99,
>     inlined from =E2=80=98mlx5i_sq_xmit=E2=80=99 at ../drivers/net/ethern=
et/mellanox/mlx5/core/en_tx.c:962:4:
> ../include/linux/fortify-string.h:328:25: warning: call to =E2=80=98__wri=
te_overflow_field=E2=80=99 declared with attribute warning: detected write =
beyond size of field (1st parameter); maybe use struct_group()? [-Wattribut=
e-warning]
>   328 |                         __write_overflow_field(p_size_field, size=
);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~

I guess these warnings show up before this BIG TCP patch ?

I do not see any struct_group() being used in mlx5

May I ask which compiler is used here, and what CONFIG_ option needs to be =
set ?

Thanks.
