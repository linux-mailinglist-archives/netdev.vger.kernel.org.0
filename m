Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F795EF405
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 13:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbiI2LL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 07:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiI2LL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 07:11:58 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387B450508
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 04:11:56 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id g1so1693080lfu.12
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 04:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=453frXB/kNUKS4+LajW/7Zv5Zzd9xLs8ChwxzSQov+Q=;
        b=focHzlVM1uUyGowU4eLvot1rTTt1waRxiIFcI/spBQ8RgZl2lQm+pt20XHM+6HCfUe
         0ci4+gl2jSvo9iqq6Hf15GrRo16lkto2ONH6tFCvdxV126iZV/b9xSwrkTT2+nHSzNfX
         yopNKpcu4ii3fIIaJIdShQCS19n8zSc7iU6Ik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=453frXB/kNUKS4+LajW/7Zv5Zzd9xLs8ChwxzSQov+Q=;
        b=YU1qG5ltXjBTLgUADRH2ukhBMAUQQjGYRmWysxMVUrSTyvAviSQn+kbv4f0o5JRy37
         OsmHGIqEGjC2x3OdOpOvydJESOXdcTvzgAnfMCs85R3CaYfjvmuAkTzg7VNdewOOGmru
         AkgWisFlkRZ6d/u02xz/L6FIsVdDtEwlBeehSYZpPGqoptmICZr6MZDvqXT+A1+AcIpM
         2pzaE4VejXndz8xQrHms2w7BgQWU9t6I7IEwfu0AXaiDvA42Gzn/STkEgu+hqHX3TW1K
         Ew/HREE+2a6ccW0cN3RhKbwWyMri9C6qHVO8TwO06Zc32N3aPUc6WgZc8Qgiczp89YNX
         c1lw==
X-Gm-Message-State: ACrzQf0IBSvPvDDX42RNJjReCeOu50IrTxt+zWpjWIoFNXFzXy5B4GeU
        gcoiKKelMSwxRnqJTPRV5D2EKKmL0otFE1P/
X-Google-Smtp-Source: AMsMyM6/nJX4uw+gwEM+y4XqO/PKPbKfvMeDJnPsTWU4V22j1G85p0p+9MgdilQM3DOqX6/zmwqyNg==
X-Received: by 2002:a05:6512:33c1:b0:48b:2ef6:f510 with SMTP id d1-20020a05651233c100b0048b2ef6f510mr1229163lfg.237.1664449914699;
        Thu, 29 Sep 2022 04:11:54 -0700 (PDT)
Received: from [172.16.11.74] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id v20-20020a05651203b400b0049936272173sm754288lfp.204.2022.09.29.04.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 04:11:54 -0700 (PDT)
Message-ID: <2f720705-cee2-75b7-c32c-793dcaeb8ea7@rasmusvillemoes.dk>
Date:   Thu, 29 Sep 2022 13:11:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Network Development <netdev@vger.kernel.org>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: purpose of ping_hash() in net/ipv4/ping.c
Cc:     Lorenzo Colitti <lorenzo@google.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

I'm wondering about the purpose of the function ping_hash() in
net/ipv4/ping.c. It only contains an unconditional BUG(), with a comment
that doesn't help much.

It was there with the original commit c319b4d76b9e (net: ipv4: add
IPPROTO_ICMP socket kind), but then renamed and made non-static for
"use" by IPv6 in 6d0bfe226116 (net: ipv6: Add IPv6 support to the ping
socket.)

The latter commit also added the 'EXPORT_SYMBOL_GPL(ping_hash);' in a
somewhat non-standard location (namely, after the the similarly named
ping_hashfn()), which is why I stumbled on this oddity.

Can we just remove ping_hash() and stop setting .hash of in ping_prot
and pingv6_prot? I don't think there's much difference between a NULL
deref and an explicit BUG a few instructions later.

And if we can't, can someone perhaps improve the comment and move the
export to the right place?

Rasmus
