Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEEB5356FB
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 02:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbiE0ANT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 20:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiE0ANS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 20:13:18 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268552AC5B
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 17:13:17 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y189so2993950pfy.10
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 17:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p9iTWLyJ025WM0SvqQwn+Xw6+/Qe+I4QkaVruL1mYtQ=;
        b=faecmEBzfgXLuBMBS8lzCrpKuO3wlZiSbclqP8jEqaFc2TGHzVEb/nKY1X8OgEdXd0
         GJiI0krThFksIkk0Ffba724p6Tbx3UDM9c5mJOGvWkotLCqmh7I+M6YN1+IOPtzpDMQz
         w36jUJEx5UXevkBpZEd/HV8En7ypjl+UxauU4DQFvRjRxgOdC7ylYdnY/lsp3FyqNPwP
         zxpqwmXZGmxoFMhSsnr8YimcXsMdeuy9eo0gkpx0d/n8X4NufJR2DvWiuCbbY7jyE4y+
         SEU5oms0q0Njkm5qvjgnPBTqbUsQaj0UO8UdWRCLOvDWUKrhCZxKQEDuIbciNQu/YuZI
         wRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p9iTWLyJ025WM0SvqQwn+Xw6+/Qe+I4QkaVruL1mYtQ=;
        b=3TGESLAXuOfpB5u/7KpkOOPLhlwmDghCZudXSb6cXHas4EFVrrsgkwnPiUeN2YQ8XE
         THREMkgXNDj6kzKUMoiQOS8byDmiiUrRMcTAYDcJQJcbVZNuJ2oS36g2kL5QEfU+O33u
         0n2YXtodPJmajIYpm3703CebJobyFV6zhzaHpiNVfhFNCA1sBiLqaRaPYtoNvYZQVlP9
         Qjf/DMLgoo+ANCK9aLnoAFsSsj0a6RI4QMvMqT0eUkdtYDkmVe7UlcR/FjFjZs58GjBy
         k9jnqNmebbOSleS5aF9bHvkLIokQ6fLGnbNy/Kk6UpCIDWglFF//NDmSTSJcBClvvA6D
         D54Q==
X-Gm-Message-State: AOAM530mcIj9TYS3tnVi3Nz0Z0caOtaq/9sr7cZ/Zd+rKr2+DR7E0K+o
        rwf6+d/PY6vjKLFPxfhyIEK98pkHyn/vgA==
X-Google-Smtp-Source: ABdhPJzQgD6wXKqAZTy0sHjjNU0b45Omky1LbH2YE52j7LE2z3jMuFUe7IytZAkGHS6dS8Tbnm/yGw==
X-Received: by 2002:a05:6a00:cc:b0:518:1348:8dc2 with SMTP id e12-20020a056a0000cc00b0051813488dc2mr41752681pfj.52.1653610396657;
        Thu, 26 May 2022 17:13:16 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id e13-20020a170902ef4d00b0016184e7b013sm2162327plx.36.2022.05.26.17.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 17:13:16 -0700 (PDT)
Date:   Thu, 26 May 2022 17:13:13 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH iproute2-next 09/10] ipstats: Expose bond stats in
 ipstats
Message-ID: <20220526171313.592cbdb1@hermes.local>
In-Reply-To: <5c0de4f4844bd23a3c7035826ec93d6bf71ae666.1652104101.git.petrm@nvidia.com>
References: <cover.1652104101.git.petrm@nvidia.com>
        <5c0de4f4844bd23a3c7035826ec93d6bf71ae666.1652104101.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 May 2022 16:00:02 +0200
Petr Machata <petrm@nvidia.com> wrote:

> Describe xstats and xstats_slave subgroups for bond netdevices.
> 
> For example:
> 
>  # ip stats show dev swp1 group xstats_slave subgroup bond
>  56: swp1: group xstats_slave subgroup bond suite 802.3ad
>                      LACPDU Rx 0
>                      LACPDU Tx 0
>                      LACPDU Unknown type Rx 0
>                      LACPDU Illegal Rx 0
>                      Marker Rx 0
>                      Marker Tx 0
>                      Marker response Rx 0
>                      Marker response Tx 0
>                      Marker unknown type Rx 0
> 
>  # ip -j stats show dev swp1 group xstats_slave subgroup bond | jq
>  [
>    {
>      "ifindex": 56,
>      "ifname": "swp1",
>      "group": "xstats_slave",
>      "subgroup": "bond",
>      "suite": "802.3ad",
>      "802.3ad": {
>        "lacpdu_rx": 0,
>        "lacpdu_tx": 0,
>        "lacpdu_unknown_rx": 0,
>        "lacpdu_illegal_rx": 0,
>        "marker_rx": 0,
>        "marker_tx": 0,
>        "marker_response_rx": 0,
>        "marker_response_tx": 0,
>        "marker_unknown_rx": 0
>      }
>    }
>  ]
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  ip/ip_common.h   |  3 +++
>  ip/iplink_bond.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++--
>  ip/ipstats.c     |  2 ++
>  3 files changed, 58 insertions(+), 2 deletions(-)

This change won't build if clang is used to build iproute2.
It has valid warning:

    CC       iplink_bond.o
iplink_bond.c:935:10: error: initializer element is not a compile-time constant
        .desc = ipstats_stat_desc_bond_tmpl_lacp,
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
iplink_bond.c:957:10: error: initializer element is not a compile-time constant
        .desc = ipstats_stat_desc_bond_tmpl_lacp,
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2 errors generated.

Since desc is a structure, you can't just assign an existing data structure
to the new initializer.  It needs to be a pointer or macro.
