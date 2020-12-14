Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86C12DA370
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 23:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440906AbgLNWcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 17:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440871AbgLNWcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 17:32:17 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB12C0613D6;
        Mon, 14 Dec 2020 14:31:37 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id t8so18532772iov.8;
        Mon, 14 Dec 2020 14:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yNY2CKU3IC5LSdmK56qyD4k/4auH8OVfPuwOc1I+eTI=;
        b=lU1dv2manwUoKQY1gs88fX6rxw4PY2Z2ICsyUnu/n/DFuCi3YZerq3OSVNXPtboCOH
         uJLSQ+l0nwFpM+9Id/GlzslzBfdj7tdqtOMCQ6ouxuVeNJ7pmaOvU63i5IPtnqr12bG/
         VGGh70ll4NcFcBrpL0iFYkLLjPz1R0UUS5QG6wVOnNzwB0to4oTJJ/2k6ow+H58a05Jd
         SGOOZ311PIoolRNPI7o11TgyACv/eK7kdEHQHgYGtE23nT2Y/dK4odlIfmY9/lVkkFbm
         jgnbyXv+6j/0YcuXYQhX1KOc4BsnwyHRKUD8TCn+XhWwSTuoQwkx7XP9DI42xDhHKzts
         ZXjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yNY2CKU3IC5LSdmK56qyD4k/4auH8OVfPuwOc1I+eTI=;
        b=mjC0tEhGSpJJx5rNtyY4CTnOl+vDYNArHFSvBly9idZ3SI/X809moD9Y+Lf+XAxpM1
         9bsOk7HMj/IOiBY2wiQDJyp59TYOGr2PLRzJXHisu5EQ4mwwhRMenYa4wqvJYYpKW5v2
         4BatdXHF5a95MNQYJ9U4HYLUNfncavh7JOLFnLonRovZrq3oF1CcDv83eClRaMxbvja5
         0r2yrh3NgRWmqwzVuk4KT3mBqVg77vljJHFZoosOQf/mIq+XGXCKMDTz4gRJ8+hK7HDF
         bTlMBTzrSfJv1l47n/94nJZYPgWMGXMMSqHiCBnvFUJJqz2QD6avh5wHErT7PXl1YJ9i
         B3JQ==
X-Gm-Message-State: AOAM531yBiT/LSQ0xn6f8lTo24FU3642iUr1Lz6i7VMUW/wNXqQQVTGo
        Fowy6aec4PQQFOJCtECAhfLIit0zRe6HATkKBzS5zjXky04=
X-Google-Smtp-Source: ABdhPJwinCJdN/6T/5LHQlMig+D8BEwTFUZH/yV7bIPHejDkzU5heP47ORiNycmIq6HBICVio9WHlB0scpjergZ1UkA=
X-Received: by 2002:a6b:8e41:: with SMTP id q62mr34912815iod.5.1607985096481;
 Mon, 14 Dec 2020 14:31:36 -0800 (PST)
MIME-Version: 1.0
References: <20201214214352.198172-1-saeed@kernel.org> <20201214214352.198172-2-saeed@kernel.org>
In-Reply-To: <20201214214352.198172-2-saeed@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 14 Dec 2020 14:31:25 -0800
Message-ID: <CAKgT0UeAaydinMZdfJt_f40eK0xxgEUdTeM7-YJc=pUyqB9-5A@mail.gmail.com>
Subject: Re: [net-next v4 01/15] net/mlx5: Fix compilation warning for 32-bit platform
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Parav Pandit <parav@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 1:49 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> From: Parav Pandit <parav@nvidia.com>
>
> MLX5_GENERAL_OBJECT_TYPES types bitfield is 64-bit field.
>
> Defining an enum for such bit fields on 32-bit platform results in below
> warning.
>
> ./include/vdso/bits.h:7:26: warning: left shift count >=3D width of type =
[-Wshift-count-overflow]
>                          ^
> ./include/linux/mlx5/mlx5_ifc.h:10716:46: note: in expansion of macro =E2=
=80=98BIT=E2=80=99
>  MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER =3D BIT(0x20),
>                                              ^~~
> Use 32-bit friendly left shift.
>
> Fixes: 2a2970891647 ("net/mlx5: Add sample offload hardware bits and stru=
ctures")
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeed@kernel.org>
> ---
>  include/linux/mlx5/mlx5_ifc.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.=
h
> index 0d6e287d614f..b9f15935dfe5 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -10711,9 +10711,9 @@ struct mlx5_ifc_affiliated_event_header_bits {
>  };
>
>  enum {
> -       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY =3D BIT(0xc),
> -       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC =3D BIT(0x13),
> -       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER =3D BIT(0x20),
> +       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY =3D 1ULL << 0xc,
> +       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC =3D 1ULL << 0x13,
> +       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER =3D 1ULL << 0x20,
>  };

Why not just use BIT_ULL?
