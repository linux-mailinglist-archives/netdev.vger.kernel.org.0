Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752AC500CC0
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237885AbiDNMIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiDNMIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:08:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B601D339
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 05:06:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69F4AB82893
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 12:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CEDC385A5
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 12:06:18 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SEEwDSOV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1649937976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GZ1BA6TpHPMsY58vHmext4YwmrVTXLAF1tsLrMoMkc8=;
        b=SEEwDSOVQys2+eJdUdgF5jRXdx6gN1s6SXrcCkYauOsbnrlRwjK35iHkxulmVIHfd9TxNC
        qCdHDSX1sTb+DQl4XFm1kZRNOakgaFODvneiKLTa/iI88sj++RlrstWa4KG5YYMXoV47wG
        mhAWSOGoBL+WBKm+4Dvbz3/iLN0Tm4A=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 296b2f95 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Thu, 14 Apr 2022 12:06:16 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id f17so8964258ybj.10
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 05:06:15 -0700 (PDT)
X-Gm-Message-State: AOAM533cnF4cleQjHz/jx2lmJzC1bgJjPFZrbvB4309e1F1DKVkvP1Dk
        p11rHVg/ksfnaXs9ZxUPQ/QYqlPAQwRRb3olZgQ=
X-Google-Smtp-Source: ABdhPJyqUFFKSzuWQmKd31Q61BMpomS7L/FGgsv5ayCAaemFit1pLM1Ox0PpNxZ/9vj+KWrmK/e2k30jVk6QmAoFzkY=
X-Received: by 2002:a25:b905:0:b0:61e:23e4:949f with SMTP id
 x5-20020a25b905000000b0061e23e4949fmr1484880ybj.373.1649937975177; Thu, 14
 Apr 2022 05:06:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220414104458.3097244-1-razor@blackwall.org> <20220414104458.3097244-3-razor@blackwall.org>
In-Reply-To: <20220414104458.3097244-3-razor@blackwall.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 14 Apr 2022 14:06:04 +0200
X-Gmail-Original-Message-ID: <CAHmME9ouN0O-mfi4d_xVon_SxzE4hbzdD0Zm8hRLS4k5C3dPFw@mail.gmail.com>
Message-ID: <CAHmME9ouN0O-mfi4d_xVon_SxzE4hbzdD0Zm8hRLS4k5C3dPFw@mail.gmail.com>
Subject: Re: [PATCH net 2/2] wireguard: selftests: add metadata_dst xmit selftest
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martynas Pumputis <m@lambda.lt>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay,

These tests need to run in the minimal fast-to-compile test harness
inside of tools/testing/selftests/wireguard/qemu, which you can try
out with:

$ make -C tools/testing/selftests/wireguard/qemu -j$(nproc)

Currently iproute2 is built, but only ip(8) is used in the image, so
you'll need to add tc(8) to there. Clang, however, seems a bit
heavyweight. I suspect it'd make more sense to just base64 up that
object file and include it as a string in the file? Or, alternatively,
we could just not move ahead with this rather niche test, and revisit
the issue if we wind up wanting to test for lots of bpf things.
Thoughts on that?

Jason
