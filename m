Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720AE589508
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 01:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239290AbiHCXxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 19:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240595AbiHCXww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 19:52:52 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4C4FEE
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 16:52:51 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id tl27so16238001ejc.1
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 16:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=UhuLkTz4ewjebruBu000VR+SoEVViViRI+eLh3drHz4=;
        b=RLa0K/3J+fTz0JDtX8L4ZznORLoy8hmPB+h5IkdM4E4Y58FxDb54Mgxryd6itqZvMJ
         BsHeZ9FjMeKkargYLuBr1ZXJagY4sVlpG+czrZL0S/vAF5m/DhxIhxMPiUn816YDa0bp
         NJYZ2HjhcfeD0xI9YUGVS4uT0SZXLyEpsjo2s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=UhuLkTz4ewjebruBu000VR+SoEVViViRI+eLh3drHz4=;
        b=lkaFxzC75cQu3+xmTBP4kL+zd3Em8Cv3WsbrIjzAjD16fubtyqvGQrh0ZDLEZVhMWh
         SFtP43lsbZBh51kQlEpGX49RhnxoRq5FCCc6uP/qRBpYuia3tfK61eF58QLA+ZscvqNb
         czUb4C1gbbuRGMDel1Gbt7MnCuntuHTxLo6TfCFrSVwq3UdgRhDZ0c1psjDvKWfgI4e5
         1vocjbiKqLq3XSb+vd1+X50Tx2M3+uapoEvxeT5xXD4v+PNXe7wjQhCxJRtdis2QtQce
         eiIUtJsKDE2TEGLcdEneFIAaGSqCeUa5v7jJMQLKYeoT4gjV/TiUsU9z0nnRuv6+h8n/
         ir1Q==
X-Gm-Message-State: AJIora8LyXeVi5eprrORM/T3AnR11iwpM1y3SEmJ3NDAOD3WZdU77stV
        UDjbV5RgvdF0q60KTSce6w/IdlzMNIeeoxJG
X-Google-Smtp-Source: AGRyM1sS11oKPgP/1ThZil2WypoawzagDtD3ShRq0jPOEEY/7YuoS2L5DmLTkatxZHy4KrwrfEW9mg==
X-Received: by 2002:a17:907:d29:b0:72b:4b20:5650 with SMTP id gn41-20020a1709070d2900b0072b4b205650mr21997283ejc.350.1659570769732;
        Wed, 03 Aug 2022 16:52:49 -0700 (PDT)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com. [209.85.128.42])
        by smtp.gmail.com with ESMTPSA id p6-20020a17090653c600b007307c557e31sm4092407ejo.106.2022.08.03.16.52.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 16:52:48 -0700 (PDT)
Received: by mail-wm1-f42.google.com with SMTP id v5so9494360wmj.0
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 16:52:48 -0700 (PDT)
X-Received: by 2002:a05:600c:2d07:b0:3a3:585:5d96 with SMTP id
 x7-20020a05600c2d0700b003a305855d96mr4356909wmf.38.1659570768369; Wed, 03 Aug
 2022 16:52:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220803101438.24327-1-pabeni@redhat.com>
In-Reply-To: <20220803101438.24327-1-pabeni@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 3 Aug 2022 16:52:32 -0700
X-Gmail-Original-Message-ID: <CAHk-=widn7iZozvVZ37cDPK26BdOegGAX_JxR+v62sCv-5=eZg@mail.gmail.com>
Message-ID: <CAHk-=widn7iZozvVZ37cDPK26BdOegGAX_JxR+v62sCv-5=eZg@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 6.0
To:     Paolo Abeni <pabeni@redhat.com>, Vlad Buslov <vladbu@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 3, 2022 at 3:15 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.0

Hmm. Another thing I note about this.

It adds a new NF_FLOW_TABLE_PROCFS option, and that one has two problems:

 - it is 'default y'. Why?

 - it has 'depends on PROC_FS' etc, but guess what it does *not*
depend on? NF_FLOW_TABLE itself.

So not only does this new code try to enable itself by default, which
is a no-no. We do "default y" if it's an old feature that got split
out as a config option, or if it's something that everybody *really*
should have, but I don't see that being the case here.

But it also asks the user that question even when the user doesn't
even have NF_FLOW_TABLE at all. Which seems entirely crazy.

Am I missing something? Because it looks *completely* broken.

I've said this before, and I'll say this again: our kernel config is
hard on users as-is, and we really shouldn't make it worse by making
it ask invalid questions or have invalid defaults.

                Linus
