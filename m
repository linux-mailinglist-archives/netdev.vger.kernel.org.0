Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA3C314B97
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhBIJ2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbhBIJ00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 04:26:26 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A4DC06178B
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 01:25:45 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id i71so17489690ybg.7
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 01:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=q0ANm4poPaEOKbvTtwyKCJDfFrFp8G7TooLAWUNU80Q=;
        b=rf1mRsy4UPPTCRA+Kpjb4xXVPfvaZFOTEqf4ZEe3FlXLtaqsTwrcp6KtkULIzJTV5o
         6NjZWpvwvQHt8LW02s0DMCbMvrB5ae1A/SOyfDRiZf4fKHIRwJ108xXttuprpMDz41s5
         JoFo4pZ1T5PonxrE9lkX8AHAr7JtUHBcFUMgxjutwLfzxpvQd7L7AQS6HSk/SRWSrhho
         Fh9XlPmRvCbpa/LchtAMbR8agv3M/CUOa03oHkqWxBUCOEpk8p0gJOTSdo+RyWEllHfL
         Dkd90Gi7gPwNN5tLeb8cOx6HkwhT2bRZWtDAhdIW1aar1B86qBj84pzwXCrnoc6I22rq
         G0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q0ANm4poPaEOKbvTtwyKCJDfFrFp8G7TooLAWUNU80Q=;
        b=h/B5Vb2VNHRgGp29D7HnLUmzweMDtJLJ0lcRUvS87NXdbjjHWU2OsrDCLfZi9xnkFj
         Orb9tr2Pg/ZEYC8PxyMCWAay5wozks2y9xGmW4s5q6Yd+HMoGJADo4pNNAm6Ib1v8XsB
         Ep/5mTAkFGP3gU4KGtHGXH5Noz1p9Dd6K6cvjWORPAvw0yFSXWeVo7Ah76X8yGV4Lbsk
         0dmQIMiAgycSiAApiGpSWp8SFyJtDcEPS/xRfH4p4F45YmksTqsUHBGs/th0g6aYi9qA
         ECru0jZGnJqE3ZiLK1yIIp1XkSxCcEHDaW/pcJYVv3vHslFIxbgiZevxLmaPxL9VVOLp
         rXZQ==
X-Gm-Message-State: AOAM531nhe8XBsZ79I9UiCY5aWUaWmHRCiwoibpIsTC4aF+VzWX2jPF+
        S6h7iI6dnzU1+uuCFhHpm7LZISzv8tlKf4j+y1w=
X-Google-Smtp-Source: ABdhPJwNYCiXO+wAJtGEeaZg8o/ni0bdfTzaW2V+nlnahbZgwQrrBhvNvCXRJQ7jjWABy+8kNdNT6NCEpNdzMLe3aa4=
X-Received: by 2002:a25:858e:: with SMTP id x14mr33249191ybk.257.1612862744905;
 Tue, 09 Feb 2021 01:25:44 -0800 (PST)
MIME-Version: 1.0
References: <CAM_iQpWQe1W+x_bua+OfjTR-tCgFYgj_8=eKz7VJdKHPRKuMYw@mail.gmail.com>
 <6c586e9a-b672-6e60-613b-4fb6e6db8c9a@nvidia.com> <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210130144231.GA3329243@shredder.lan> <8924ef5a-a3ac-1664-ca11-5f2a1f35399a@nvidia.com>
 <20210201180837.GB3456040@shredder.lan> <20210208070350.GB4656@unreal>
 <20210208085746.GA179437@shredder.lan> <20210208090702.GB20265@unreal>
 <20210208170735.GA207830@shredder.lan> <20210209064702.GB139298@unreal>
In-Reply-To: <20210209064702.GB139298@unreal>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 9 Feb 2021 11:25:33 +0200
Message-ID: <CAJ3xEMh72mb9ZYd8umr-FTEO+MV6TNyqST2kLAz_wdLgPcFnww@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 8:49 AM Leon Romanovsky <leon@kernel.org> wrote:

[..]

> This is another problem with mlx5 - complete madness with config options
> that are not possible to test.
> =E2=9E=9C  kernel git:(rdma-next) grep -h "config MLX" drivers/net/ethern=
et/mellanox/mlx5/core/Kconfig | awk '{ print $2}' | sort |uniq |wc -l
> 19

wait, why do you call it madness? we were suggested by some users (do
git blame for the patches) to refine things with multiple configs and it se=
em
to work quite well  -- what you don't like? and what's wrong with simple gr=
ep..

$ grep "config MLX5_" drivers/net/ethernet/mellanox/mlx5/core/Kconfig
config MLX5_CORE
config MLX5_ACCEL
config MLX5_FPGA
config MLX5_CORE_EN
config MLX5_EN_ARFS
config MLX5_EN_RXNFC
config MLX5_MPFS
config MLX5_ESWITCH
config MLX5_CLS_ACT
config MLX5_TC_CT
config MLX5_CORE_EN_DCB
config MLX5_CORE_IPOIB
config MLX5_FPGA_IPSEC
config MLX5_IPSEC
config MLX5_EN_IPSEC
config MLX5_FPGA_TLS
config MLX5_TLS
config MLX5_EN_TLS
config MLX5_SW_STEERING
config MLX5_SF
config MLX5_SF_MANAGER
config MLX5_EN_NVMEOTCP
