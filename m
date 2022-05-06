Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4C251E258
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444793AbiEFWiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444785AbiEFWiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:38:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D13F5DBF4
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 15:34:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8311961738
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 22:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81138C385A9;
        Fri,  6 May 2022 22:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651876455;
        bh=B7O2IxVZU0GEewaxG/nsmhsT8vrzIQQqn5w01g6DYL4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i8pGuy6K1PCoz5xe/ypv2HKnYOHd9UXpffQqF8YsAn9frAwpoPmmofpmdeDib77lQ
         TK1r4HXdccaumVqeKih0qgKfVuXJzJHFum/MlQq9axD6ID1aMI9nSS5qE9A3jVf1mX
         YUTQWAAiZUmVpENUw4/xqanwuu71or2E5bIUi/xsMxPTb9kIou3DQA8s31HWHSH2m4
         0hloT45YXyku1yox3q4HoGRQeINhlCUgfSi/naxPOXEynfsKmXForAVVDhBb47blQQ
         rHSIij+cAgFMvvUF1cX8KJBX2OJgwFmob9EIllkinOTZMgnfziLYNHDzGfPvbhZ72C
         SXSgOd3XpHnAQ==
Date:   Fri, 6 May 2022 15:34:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v4 net-next 12/12] mlx5: support BIG TCP packets
Message-ID: <20220506153414.72f26ee3@kernel.org>
In-Reply-To: <20220506153048.3695721-13-eric.dumazet@gmail.com>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
        <20220506153048.3695721-13-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 May 2022 08:30:48 -0700 Eric Dumazet wrote:
> From: Coco Li <lixiaoyan@google.com>
>=20
> mlx5 supports LSOv2.
>=20
> IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
> with JUMBO TLV for big packets.
>=20
> We need to ignore/skip this HBH header when populating TX descriptor.
>=20
> Note that ipv6_has_hopopt_jumbo() only recognizes very specific packet
> layout, thus mlx5e_sq_xmit_wqe() is taking care of this layout only.
>=20
> v2: clear hopbyhop in mlx5e_tx_get_gso_ihs()
> v4: fix compile error for CONFIG_MLX5_CORE_IPOIB=3Dy

In file included from ../include/linux/string.h:253,
                 from ../arch/x86/include/asm/page_32.h:22,
                 from ../arch/x86/include/asm/page.h:14,
                 from ../arch/x86/include/asm/processor.h:19,
                 from ../arch/x86/include/asm/timex.h:5,
                 from ../include/linux/timex.h:65,
                 from ../include/linux/time32.h:13,
                 from ../include/linux/time.h:60,
                 from ../include/linux/skbuff.h:15,
                 from ../include/linux/tcp.h:17,
                 from ../drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:33:
In function =E2=80=98fortify_memcpy_chk=E2=80=99,
    inlined from =E2=80=98mlx5e_insert_vlan=E2=80=99 at ../drivers/net/ethe=
rnet/mellanox/mlx5/core/en_tx.c:104:2,
    inlined from =E2=80=98mlx5e_sq_xmit_wqe=E2=80=99 at ../drivers/net/ethe=
rnet/mellanox/mlx5/core/en_tx.c:404:5:
../include/linux/fortify-string.h:328:25: warning: call to =E2=80=98__write=
_overflow_field=E2=80=99 declared with attribute warning: detected write be=
yond size of field (1st parameter); maybe use struct_group()? [-Wattribute-=
warning]
  328 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function =E2=80=98fortify_memcpy_chk=E2=80=99,
    inlined from =E2=80=98mlx5e_sq_xmit_wqe=E2=80=99 at ../drivers/net/ethe=
rnet/mellanox/mlx5/core/en_tx.c:408:5:
../include/linux/fortify-string.h:328:25: warning: call to =E2=80=98__write=
_overflow_field=E2=80=99 declared with attribute warning: detected write be=
yond size of field (1st parameter); maybe use struct_group()? [-Wattribute-=
warning]
  328 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function =E2=80=98fortify_memcpy_chk=E2=80=99,
    inlined from =E2=80=98mlx5i_sq_xmit=E2=80=99 at ../drivers/net/ethernet=
/mellanox/mlx5/core/en_tx.c:962:4:
../include/linux/fortify-string.h:328:25: warning: call to =E2=80=98__write=
_overflow_field=E2=80=99 declared with attribute warning: detected write be=
yond size of field (1st parameter); maybe use struct_group()? [-Wattribute-=
warning]
  328 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
