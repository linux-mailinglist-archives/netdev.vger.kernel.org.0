Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3E16E737E
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 08:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbjDSGsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 02:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbjDSGsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 02:48:07 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4097910CE
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 23:48:06 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id 006d021491bc7-546dad86345so819490eaf.0
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 23:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681886885; x=1684478885;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/tTgR0WKqClO58pB5JSB2fRAbYPiO3xwxIKhsg/5/ks=;
        b=GVzSDbruyvXn1hvwNatihFePe6OoQbtHIHolGmMVe6C8YxOoO1DMlvCkMeGLoZjjuC
         /ugQf9lqYqGIlmbb4TpPGIIDiQsslQlmosZl8PRCU94Ev7EzOcS1PWkB0eK9DJnbgEAi
         WHGEXibmPnUWRxtFU4Y3NGMeAXLdrYt3ti6WASp4tbBsCkxlgYVRSXxw3rXfjWBTD80c
         nYvXBwUuq0qbMQPasHK7TvMS/wdmfsJWXRdM9YSj23CQwlnQK01a3atw7ubBLxEZcVbC
         zp5r/Q9B9X3NSAsByKuPTFB/P7UgLpMKTNE9zB9Wb4hNQ4yWZVfevZ3atFityF2oFOUI
         lcyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681886885; x=1684478885;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/tTgR0WKqClO58pB5JSB2fRAbYPiO3xwxIKhsg/5/ks=;
        b=NmiwzuOCoPxUL7xjA+7Hze20M37UbUmy95ZzKBwm3u8gHMQaHqtwiDDiM2cS/M5CGJ
         x5drDKHe2oVJyqJ8TZfFi709v0q0B7s4GzDaaIv2RUbW+zCCZ8WObkyZJg+dw2K78kd7
         sPnYXi6VCT0Zh9uHkGK8etOs+nrJpPCMyH5DTjORvpoQsvf/rVs41SbT0ebZn0r8fvfB
         49PW1iJR5294qTMWbxbWRh3t8FteXLElrq1NC0zlntcaNCMtq3QF7Hyxr7rjNePIjAaN
         6utgH2ZQ4EfoHw043z+ZaeIVByjz/bAK4V9H//CzeukcRbdNqPv3knQlfd2Wg20MgcMJ
         w+nQ==
X-Gm-Message-State: AAQBX9dRuWVTthAV1AE4dB6o/kDAjM8uu7sjSvOLLrze309I84bb1tgP
        OZ54813CbW85jnlbn/TKgioQ49QVG7dxt1756ZZelpvSTBrBLQ==
X-Google-Smtp-Source: AKy350bH2feNnWlPl4lMLXiXq4ga90h/s1piz2L06kkgA/SigHmwwenbmFwMK2zaERID4Rr1DdzjzqTD07DU1EEqf30=
X-Received: by 2002:a05:6870:4251:b0:187:9718:4070 with SMTP id
 v17-20020a056870425100b0018797184070mr3024044oac.39.1681886885454; Tue, 18
 Apr 2023 23:48:05 -0700 (PDT)
MIME-Version: 1.0
From:   Robert Landers <landers.robert@gmail.com>
Date:   Wed, 19 Apr 2023 08:47:54 +0200
Message-ID: <CAPzBOBNKPYFwm5Fq9hvEPPVk7RHjzPOO5gpnVXeT-2dgk_f69Q@mail.gmail.com>
Subject: Maybe a bug with adding default routes?
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello netdev,

I believe I either found a bug, or I'm doing something wrong (probably
the latter, or both!). I was experimenting with getting a "floating
IP" for my home lab, and eventually, I got it to work, but it requires
some voodoo, which intrigued me and I think I found some strange
behavior that smells like a bug. I'm on Ubuntu 22.04 (and Pop OS! on
my desktop), so it is also possible that this is fixed upstream (in
which case, I'll email that list next).

To reproduce is quite simple:

echo "1234 test" >> /etc/iproute2/rt_tables
ip route add default via 167.235.212.73 dev enp9s0 table test

This will fail with the error:

Error: Nexthop has invalid gateway.

Now, I think this makes sense, however, the routing table shouldn't
need to know about hops, Right? Maybe I'm wrong, but this voodoo
results in a correct routing table:

ip addr add 167.235.212.72/29 dev enp9s0
ip route add default via 167.235.212.73 dev enp9s0 table test
ip addr del 167.235.212.72/29 dev enp9s0

I'm not sure if this is a bug or working as designed. It smells like a
bug, but I could just as easily be doing something wrong. I grew up in
"simpler" times and am not nearly as familiar with iproute2 as I was
with the old stuff.

PS. I've removed other commands (like rules, etc) to reduce the
example down to it's most basic reproduction.

Robert Landers
Software Engineer
Utrecht NL
