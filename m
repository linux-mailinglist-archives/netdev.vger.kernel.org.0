Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF677260E4C
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgIHJHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbgIHJHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:07:05 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B75C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 02:07:04 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id l1so4848171uai.3
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 02:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zPeLijxzM+XZMTaCNQE7DglKZfJdAtpmR2GIWZ5vDsY=;
        b=MjlUgsao0ShQ8g7WsFsge/quUBaa7u/250SmBOkoJrze0h1sM1x1qGCpR9Ah5MpayV
         69jHj6NJiURG/tYdVMqhvl5ePLXxj4YXHlFAUpzl8UJDJMZsoAQSH/38Ah9O7CF1Xi/r
         USnn3NYA/u4MIImIrrsuUFq6Bdm4mouVOchALGsj2ieT02O+gMZdhvqSW2VwsbNn3666
         B8NQORYn0zswY8fxF1hdbui6dojApZzoSLMalOqVjIOYYnHrsEnhwXKNB+tgKOTt26+W
         iNZ5tfFuaxncZTjimNCEfFY9lykiQKZmU0gCcb8tq5nsbmPNYYGhyvlQCKMDvfFcyArV
         Q3pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zPeLijxzM+XZMTaCNQE7DglKZfJdAtpmR2GIWZ5vDsY=;
        b=ConGTbAnQKUP3GOKaVIKtKNFVrW0gijkNwW/7hSQl+t7RLV3pACFEQCXn0mFknkGXW
         9bcsnmBXZ3f898J/7jLjJ2MY+QBD9TEENYOM/2aKZF023ZzGO2Wc80om0JkBrgEDtkRN
         27rDRl1krrlEGyIULqyxenASQde2TLuT3YLZyRRr942PLylrLmev2TboMllTtFVOH6Ka
         GEc8G9Qp2ui564pohTJx7bhvfzc3aeZfwuAzrxjwiyM4IAND7s6Lqc6fiV845wuMFPQE
         AqnPM42UfIg3VZbdxHwU2RoLo+noUtJB7+uf85Ec/6pILUWlUarR1H5V3H5NF5BcEyjV
         rLPg==
X-Gm-Message-State: AOAM533uYc+f4+ElfuucGABFEzAtPVZUYqhzB/yQW/FAf/nHF0N1mUJ4
        4Svy8/XxkeEQkM1yFyOsw2w7ibrCPh7t8Q==
X-Google-Smtp-Source: ABdhPJwXN9ZhqKjP7uz7D6ryiypRAk1IMEXcYPHqtUnTEmaGdsizgpzr8BMRjLMfmagsGHxxd4BUcQ==
X-Received: by 2002:ab0:2c1a:: with SMTP id l26mr4926987uar.6.1599556023620;
        Tue, 08 Sep 2020 02:07:03 -0700 (PDT)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com. [209.85.217.46])
        by smtp.gmail.com with ESMTPSA id j20sm2652804vsg.18.2020.09.08.02.07.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 02:07:02 -0700 (PDT)
Received: by mail-vs1-f46.google.com with SMTP id s62so8571568vsc.7
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 02:07:02 -0700 (PDT)
X-Received: by 2002:a67:d209:: with SMTP id y9mr13790179vsi.44.1599556022160;
 Tue, 08 Sep 2020 02:07:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200903210022.22774-1-saeedm@nvidia.com> <20200903210022.22774-5-saeedm@nvidia.com>
 <CA+FuTSczxJXJuRDKRrMHpQdqjCJLhbujhrzAQZkS=0GO6oJ7ww@mail.gmail.com> <250f08af-b02b-f88b-85c7-12ab6d66c874@nvidia.com>
In-Reply-To: <250f08af-b02b-f88b-85c7-12ab6d66c874@nvidia.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 8 Sep 2020 11:06:25 +0200
X-Gmail-Original-Message-ID: <CA+FuTSe3TA5XxrrE80RAGX1rP0hsv4evMShDivVkeZ6C_SU7Cg@mail.gmail.com>
Message-ID: <CA+FuTSe3TA5XxrrE80RAGX1rP0hsv4evMShDivVkeZ6C_SU7Cg@mail.gmail.com>
Subject: Re: [net-next 04/10] net/mlx5e: Unify constants for WQE_EMPTY_DS_COUNT
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 10:59 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> On 2020-09-04 18:05, Willem de Bruijn wrote:
> > On Thu, Sep 3, 2020 at 11:01 PM Saeed Mahameed <saeedm@nvidia.com> wrote:
> >>
> >> From: Maxim Mikityanskiy <maximmi@mellanox.com>
> >>
> >> A constant for the number of DS in an empty WQE (i.e. a WQE without data
> >> segments) is needed in multiple places (normal TX data path, MPWQE in
> >> XDP), but currently we have a constant for XDP and an inline formula in
> >> normal TX. This patch introduces a common constant.
> >>
> >> Additionally, mlx5e_xdp_mpwqe_session_start is converted to use struct
> >> assignment, because the code nearby is touched.
> >>
> >> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> >> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> >> ---
> >>   .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  2 ++
> >>   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 13 +++++++-----
> >>   .../net/ethernet/mellanox/mlx5/core/en/xdp.h  | 21 +++++++------------
> >>   .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  2 +-
> >>   4 files changed, 19 insertions(+), 19 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> >> index d4ee22789ab0..155b89998891 100644
> >> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> >> @@ -7,6 +7,8 @@
> >>   #include "en.h"
> >>   #include <linux/indirect_call_wrapper.h>
> >>
> >> +#define MLX5E_TX_WQE_EMPTY_DS_COUNT (sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS)
> >> +
> >
> > Out of curiosity, what is the logic for dividing this struct by 16?
>
> The hardware needs the size of a WQE in DS units (16 bytes). An empty
> WQE takes 2 DS (for the ctrl and eth segments), and this macro is this
> initial size of an empty WQE (2 DS). As data segments are added to the
> WQE, it grows, and its size in DS also grows.
>
> > struct mlx5e_tx_wqe {
> >          struct mlx5_wqe_ctrl_seg ctrl;
> >          struct mlx5_wqe_eth_seg  eth;
> >          struct mlx5_wqe_data_seg data[0];
> > };

Thanks. It was not obvious to me that the first two are the size as
data_segs. But that actually is pretty logical. Ack.
