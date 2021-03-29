Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E65A34C2B8
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 07:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhC2Ee2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 00:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhC2EeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 00:34:12 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E43C061574
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 21:34:11 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id ap14so4194447ejc.0
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 21:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=XLwPGzf1BbJJSqDZ96QH3+lNi3BVxFdSY+mBTRn7sJ4=;
        b=R0AjivEBnYm2GXpIXk2Tuj+izh7i7kB1UVrPaXSIEw1aFCKiXVlPKap9uMyUaAQykU
         FlCDXz1g3xhGPBQsYA6VOkEFxg3t0wBrob4atmzIRFru9WNAS+QIjLUX+dhhqpH6/47G
         ohZEn9g/EgzbIHsg6YRDZoYZ0Gf/O7RIYtS0hTjlys3bOcj4Tfd2R7+PD1YoREEEG2ZV
         2Yv1L9G/kZk3NKrR0yUjBY6rfkoQ5Uth69YZ3wj+jKqSviIWXfYcfm6AyAreGu4rc9p5
         N3+4KXUVHM8KIzRHQjp4clKpB5tEfQ5IBopKKfAKH2WvjVjK/5dDL0G0s2kx2uhnj/9g
         Vgiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=XLwPGzf1BbJJSqDZ96QH3+lNi3BVxFdSY+mBTRn7sJ4=;
        b=ORjqtC79Khcikz6GD+DtoND4VpNJe3dVfZL1207pQxQ3VBpH7NUoJWLjAokzCJKZXF
         0JPaisRrPGucr4VifreublgufsSwr1pJVhlv4LWsaWkr/tWsUzSbCpTd8BpWdwza7aG/
         FxhwU3AlQuoYlyMt5XP3ttG+yA65ExhHtJD8FK1YIC/9gOrICGvU+ihXAObLcx5b28/H
         /3NxTC1QCoZuyIdvnfJG2Hkg398oh/TigLa+s2yjE7f8JhZJweqARjaQ27K2ZljB1SYt
         kvQNKvaKbFIk3Ov1oPUf16YhpCw2FFDTNOOqmvdxGNj7T+vCY+vLM3FVilyV0kSZitnj
         y0GA==
X-Gm-Message-State: AOAM531wuq2seJaf9O6K3Hu80J86LJ6txStT6kfrJjduW9wCsVBcyNWc
        wVy9zB6Bw4jxNUdTYKfr9bBPRqeT06oaGGMf+Zo=
X-Google-Smtp-Source: ABdhPJwMT5KlQEqXIg93Aavjz9fEWp1AOCzDztQvpms1hTk6AzgaL2r/Kl7g5swtdIobZ85K6owJxKCM0J3JGyt8voI=
X-Received: by 2002:a17:906:8a6e:: with SMTP id hy14mr26976272ejc.356.1616992450029;
 Sun, 28 Mar 2021 21:34:10 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?6auY6ZKn5rWp?= <gaojunhao0504@gmail.com>
Date:   Mon, 29 Mar 2021 12:33:58 +0800
Message-ID: <CAOJPZgnLjr6VHvtv9NnemxFagvL-k1wrRsB1f1Pq+9qbtPWw0g@mail.gmail.com>
Subject: ESP RSS support for NVIDIA Mellanox ConnectX-6 Ethernet Adapter Cards
To:     borisp@nvidia.com, saeedm@nvidia.com
Cc:     netdev@vger.kernel.org, seven.wen@ucloud.cn, junhao.gao@ucloud.cn
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi borisp, saeedm

     I have seen mlx5 driver in 5.12.0-rc4 kernel, then find that
mlx5e_set_rss_hash_opt only support tcp4/udp4/tcp6/udp6. So mlx5
kernel driver doesn't support esp4 rss? Then do you have any plan to
support esp4 or other latest mlx5 driver have supported esp4? Then
does NVIDIA Mellanox ConnectX-6 Ethernet Adapter Cards support esp4
rss in hardware?

static int mlx5e_set_rss_hash_opt(struct mlx5e_priv *priv,
                 struct ethtool_rxnfc *nfc)
{
    int inlen = MLX5_ST_SZ_BYTES(modify_tir_in);
    enum mlx5e_traffic_types tt;
    u8 rx_hash_field = 0;
    void *in;
    tt = flow_type_to_traffic_type(nfc->flow_type);
    if (tt == MLX5E_NUM_INDIR_TIRS)
        return -EINVAL;
    /* RSS does not support anything other than hashing to queues
     * on src IP, dest IP, TCP/UDP src port and TCP/UDP dest
     * port.
     */
    if (nfc->flow_type != TCP_V4_FLOW &&
      nfc->flow_type != TCP_V6_FLOW &&
      nfc->flow_type != UDP_V4_FLOW &&
      nfc->flow_type != UDP_V6_FLOW)
        return -EOPNOTSUPP;

Best Regards,
Junhao
