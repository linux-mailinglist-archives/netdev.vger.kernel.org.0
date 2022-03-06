Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5084CEDF2
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 22:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbiCFVeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 16:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbiCFVeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 16:34:19 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BDB3EB90
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 13:33:22 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id r22so2334738ljd.4
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 13:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I1VslL3ye1MbAoXD/93dVSkYx3rBEqLz04PvwnWO5Xc=;
        b=aP7NIVkTp8F0TQzsVHRkgravZwx4iPy0i/GXcER23Kdwa3h0g1I9y3M8zMLvIP91ma
         ObiiRLWF0p9p92E69K8HInTDYUDFmL7AEyunpOxfqnONlKhXGU6Fd6Bw+kpf40xyPLD7
         J4arYW2KdltXWYcpnA2rG4WjyBSh6aOQAuIOY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I1VslL3ye1MbAoXD/93dVSkYx3rBEqLz04PvwnWO5Xc=;
        b=G8zQVbAa0e2eUdVj2ydjRotamasJ9YECGSw6BMtRi6V6+1Vz19WsYBWiNU3vPAmqAI
         OVdUbVIKEWKOjuIsebW/HtIHjcdd8C9V4DlhL8nV0OyCtBiIhy23W+z+ZSoB6NU6VcMH
         gg0tQxETqs3nLg7aC2N24wsu7AABixjtH7ykDynZETAZLRhy+he0jIGwapTgT3q6T966
         EUsQPhTo7FCGg49RP57T1ub3G5Rf+spO44uUSSW7JeXEv/C+Jf+6KRi8sedjAHN5CPjt
         TK6guA/UNPCOItauZ97WoNjWiKczaE7o5+Z1bwjOEh9xqaB4wE3DwJzBJbLuTenW0h2M
         /jaw==
X-Gm-Message-State: AOAM530umnW/VRppQl1zdm0WfGzALFOQXL9JNw4zzvMklR0J5kGB0Nn7
        HtQkfR7Q6vs4WlC87NX9W7a9d2+vU5x4HsDkQU8=
X-Google-Smtp-Source: ABdhPJzb7X6CMO+dkOufKvPuK7cuwnXkatZts5t7XSocxrfeAEjnOQ5SrkfCDn0x/+MWyWIGhlCiYw==
X-Received: by 2002:a05:651c:241:b0:23e:42c1:2e4 with SMTP id x1-20020a05651c024100b0023e42c102e4mr5666008ljn.406.1646602400825;
        Sun, 06 Mar 2022 13:33:20 -0800 (PST)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id a10-20020a056512374a00b004438dd764d1sm2461748lfs.306.2022.03.06.13.33.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 13:33:18 -0800 (PST)
Received: by mail-lf1-f45.google.com with SMTP id u20so23154941lff.2
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 13:33:18 -0800 (PST)
X-Received: by 2002:ac2:41cf:0:b0:448:1eaa:296c with SMTP id
 d15-20020ac241cf000000b004481eaa296cmr5987125lfi.52.1646602398190; Sun, 06
 Mar 2022 13:33:18 -0800 (PST)
MIME-Version: 1.0
References: <164659571791.547857.13375280613389065406@leemhuis.info>
In-Reply-To: <164659571791.547857.13375280613389065406@leemhuis.info>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 6 Mar 2022 13:33:02 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgYjH_GMvdnNdVOn8m81eBXVykMAZvv_nfh8v_qdyQNvA@mail.gmail.com>
Message-ID: <CAHk-=wgYjH_GMvdnNdVOn8m81eBXVykMAZvv_nfh8v_qdyQNvA@mail.gmail.com>
Subject: Re: Linux regressions report for mainline [2022-03-06]
To:     "Regzbot (on behalf of Thorsten Leemhuis)" 
        <regressions@leemhuis.info>, Rob Herring <robh@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Netdev <netdev@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 6, 2022 at 11:58 AM Regzbot (on behalf of Thorsten
Leemhuis) <regressions@leemhuis.info> wrote:
>
> ========================================================
> current cycle (v5.16.. aka v5.17-rc), culprit identified
> ========================================================
>
> Follow-up error for the commit fixing "PCIe regression on APM Merlin (aarch64 dev platform) preventing NVME initialization"
> ---------------------------------------------------------------------------------------------------------------------------
> https://linux-regtracking.leemhuis.info/regzbot/regression/Yf2wTLjmcRj+AbDv@xps13.dannf/
> https://lore.kernel.org/stable/Yf2wTLjmcRj%2BAbDv@xps13.dannf/
>
> By dann frazier, 29 days ago; 7 activities, latest 23 days ago; poked 13 days ago.
> Introduced in c7a75d07827a (v5.17-rc1)

Hmm. The culprit may be identified, but it looks like we don't have a
fix for it, so this may be one of those "left for later" things. It
being Xgene, there's a limited number of people who care, I'm afraid.

Alternatively, maybe 6dce5aa59e0b ("PCI: xgene: Use inbound resources
for setup") should just be reverted as broken?

> ====================================================
> current cycle (v5.16.. aka v5.17-rc), unknown culprit
> ====================================================
>
>
> net: bluetooth: qualcom and intel adapters, unable to reliably connect to bluetooth devices
> -------------------------------------------------------------------------------------------
> https://linux-regtracking.leemhuis.info/regzbot/regression/CAJCQCtSeUtHCgsHXLGrSTWKmyjaQDbDNpP4rb0i+RE+L2FTXSA@mail.gmail.com/
> https://lore.kernel.org/linux-bluetooth/CAJCQCtSeUtHCgsHXLGrSTWKmyjaQDbDNpP4rb0i%2BRE%2BL2FTXSA@mail.gmail.com/
>
> By Chris Murphy, 23 days ago; 47 activities, latest 3 days ago.
> Introduced in v5.16..f1baf68e1383 (v5.16..v5.17-rc4)
>
> Fix incoming:
> * https://lore.kernel.org/regressions/1686eb5f-7484-8ec2-8564-84fe04bf6a70@leemhuis.info/

That's a recent fix, it seems to be only in the bluetooth tree right
now, and won't be in rc7. I'm hoping that I'll get it in next week's
networking dump.

Cc'ing the right people just to prod them, since we've had much too
many "Oh, I didn't even realize it was a regression" issues this time
around.

                       Linus
