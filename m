Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB08940886B
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 11:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238758AbhIMJji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 05:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238748AbhIMJjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 05:39:37 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF691C061760
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 02:38:20 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id d207-20020a1c1dd8000000b00307e2d1ec1aso337349wmd.5
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 02:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GgdGwtNZAbTBYuLX1/1vRJaXhwTs+Iu+RSqf/65W9qI=;
        b=iUDhQQW0GwwEZyLSrD/MdTQAwu0lwZP8K9T2F4I4/CZdhgjMplIXUxAATPchIzVnRU
         WOIMc12KJK7jY0mVzP7F20hbpwPJRi+WFETkBv+Y02d64GXFDMCsh1pRLiDc+pW159rF
         I/8MKdcHuDAnKzcauVZULM+HrMFVqgLkEc/5pUDxBEhPXUGE4CoP6HFID9WGFxVIjIUF
         JcqBLhtmP9B/4jUaJ1V0f1ETYXnl2AkyhGnhoErpEFJDDPz7XNRbDLvO86DlV8PXKwED
         3Y+GhatOSf2bXqNlyF3lHI4aLGXxsYjyNf8PBS/EGJcLaN8LDadqjB69Ogp8uTE+7oiD
         92rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GgdGwtNZAbTBYuLX1/1vRJaXhwTs+Iu+RSqf/65W9qI=;
        b=MJr11Wq1s1OAkEN1Yx0m8zzzi9Ij9Ohne4Cx67uIaD3xL9MA7jvtTifyigIQNohZTD
         e1DV8+S2U2AzfFPNKwTJUj2pniMKVYT/gD1tweEPFqrKkKgCiOasQ3Pm9cW6FHu/CAPy
         8sHfzPlMvGVFdgMugSD35UA0i2emLr3DMYGN5y/lQt8McGFZBUi45mgY4QZeKSS4S9sb
         TqZBG8YxarntouQUVdDebtG0n1LGsSUzD7MvncNk9auCwFBUXGnB7YYzdKinqvVGglzb
         tZpUL2oHSFuPQSaX8J6BVAd1DruoJQcPZT8XqbnamBOyxbaNccEQ9ZtvVR0Eg2xnzc1n
         +IBg==
X-Gm-Message-State: AOAM533LylGq857dXkigsfULIpGG0a5dC9sWs7Toks298lyCBxoIsuFa
        amj/zYTeo6K2BmNfg+cX6jaRBIuE/ASx4d7RjWw6mg==
X-Google-Smtp-Source: ABdhPJyW9K4gP2TJxkjRNTy5yov3L17WhGLT+BYWYSz7chVK5eZMsnjTqAs6t07eU237vsAJ5I1XI6GeJmQoYyhUhwc=
X-Received: by 2002:a05:600c:2046:: with SMTP id p6mr10484211wmg.88.1631525899229;
 Mon, 13 Sep 2021 02:38:19 -0700 (PDT)
MIME-Version: 1.0
References: <46a9dbf2-9748-330a-963e-57e615a15440@gmail.com>
 <20210701085117.19018-1-rocco.yue@mediatek.com> <62c9f5b7-84bd-d809-4e33-39fed7a9d780@gmail.com>
 <CAKD1Yr2aijPe_aq+SRm-xv0ZPoz_gKjYrEX97R1NJyYpSnv4zg@mail.gmail.com>
 <6a8f0e91-225a-e2a8-3745-12ff1710a8df@gmail.com> <CAO42Z2w-N6A4DmubhQsg6WbaApG+7sy2SVRRxMXtaLrTKYyieQ@mail.gmail.com>
In-Reply-To: <CAO42Z2w-N6A4DmubhQsg6WbaApG+7sy2SVRRxMXtaLrTKYyieQ@mail.gmail.com>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Mon, 13 Sep 2021 18:38:06 +0900
Message-ID: <CAKD1Yr2jZbJE11JVJkkfE-D8-qpiE4AKi87sfdCh7zAMJ-tiEQ@mail.gmail.com>
Subject: Re: [PATCH] net: ipv6: don't generate link-local address in any addr_gen_mode
To:     Mark Smith <markzzzsmith@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        rocco.yue@gmail.com, chao.song@mediatek.com,
        =?UTF-8?B?S3VvaG9uZyBXYW5nICjnjovlnIvptLsp?= 
        <kuohong.wang@mediatek.com>,
        =?UTF-8?B?Wmh1b2xpYW5nIFpoYW5nICjlvKDljZPkuq4p?= 
        <zhuoliang.zhang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 12:47 AM Mark Smith <markzzzsmith@gmail.com> wrote:
> This is all going in the wrong direction. Link-local addresses are not
> optional on an interface, all IPv6 enabled interfaces are required to
> have one:

The original patch did indeed disable the generation of the link-local
address, but that patch was rejected. It sounds like the right
approach here is to provide two new addressing modes:

IN6_ADDR_GEN_MODE_RANDOM_LL_TOKEN
IN6_ADDR_GEN_MODE_STABLE_PRIVACY_LL_TOKEN

which would form the link-local address from the token passed in via
IFLA_INET6_TOKEN, but would form non-link-local addresses (e.g.,
global addresses) via the specified means (either random or stable
privacy). I haven't looked at how to do that yet though.
