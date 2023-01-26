Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA7267C840
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 11:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbjAZKRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 05:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236355AbjAZKRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 05:17:16 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E953430A;
        Thu, 26 Jan 2023 02:16:47 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 7so762253pga.1;
        Thu, 26 Jan 2023 02:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N25kb8917DsEocMyJFvAiiipeCXaDAmvWVoSKk7Ucb0=;
        b=J7dO80kzV3/qF3wGrZBEcsJCeJEp5R/pt3hGmXvqpAEmso/l5D0u0sgHZ9RX0xvomZ
         2dXKQeZ7zV7XD2xGzCpF9px9ss3aPwnTXgST9A0Uwgza423jYi/HHbKXn30hs8pHiu2p
         A2YvV4WXVMrfd404HQKm2lhJdiefVdJ4hka/Wv7qWnUBsu58j6fWmc6KHywb2EbEnaO/
         xa6eVNhGPFffCvLG0vLIpx5VjW6WGgpcFIYtC3JAbXzwpovK5GFHnDCw15gLnss4zqiB
         OZ89/CLLoE1HbK/sNFKMwqmug8CSOfk1w27usyit/ZFFB+ffZtyYuWW5HfDSWLOpaEip
         1ODA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N25kb8917DsEocMyJFvAiiipeCXaDAmvWVoSKk7Ucb0=;
        b=d7tT/ZEg+U4KJdUUCbRB/IGawtYqjojxXjpD97tfQUjAMK48sfwlKYqMgsbeuM42ZS
         UZXMGn0+qzNAdsodTZatfuJcN2PB6yofF1o/Hb3qqSY8GxbUkAH51jnFYeHXvTWhWfsE
         aU+A+VRC0jgzxfhJfORsDSzmqotu1kA8PaGtclft7A0hLQARNoZarJWBc/9Tc19wJA+B
         K7KBJryqsnYvYNnNwoLVPtycZ4R30qhToPsF2hgqWkdTsBX+4/M1zb6Wff/Ksb95diyp
         4gkbjPlw3zEhAX+lM6aawPPnnUViPnJuh44ZNJ8pHjno6ZUNNGNTwy738iNuF988X3nA
         TnqA==
X-Gm-Message-State: AFqh2kreLO9SqagSEpc20Rwnl4FoioVCN8YKcSvJHqXcmN1ICYhXLCLq
        aslU4u8FU4fwJv87StA1c+HBEUb0C4hbYZNQNg0=
X-Google-Smtp-Source: AMrXdXuMrEBm+4oiJayh39LZrd1yppbt7a1PGYiFSqbjJHTWfkPRXLJ75/k1Yg/4x1L+XesT/pbGxb/r2VgM0gsID0k=
X-Received: by 2002:aa7:9010:0:b0:578:6897:597c with SMTP id
 m16-20020aa79010000000b005786897597cmr4172567pfo.35.1674728206647; Thu, 26
 Jan 2023 02:16:46 -0800 (PST)
MIME-Version: 1.0
References: <20230124110057.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid>
In-Reply-To: <20230124110057.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid>
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Thu, 26 Jan 2023 11:16:35 +0100
Message-ID: <CAOiHx=niyEho+tJJ-dvOr3wOYiEOsvCvvJbxQvXGGoHbdxFhBQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] wifi: ath11k: Use platform_get_irq() to get the interrupt
To:     Douglas Anderson <dianders@chromium.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Youghandhar Chintala <quic_youghand@quicinc.com>,
        junyuu@chromium.org, Kalle Valo <kvalo@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Jan 2023 at 20:05, Douglas Anderson <dianders@chromium.org> wrote:
>
> For the same reasons talked about in commit 9503a1fc123d ("ath9k: Use
> platform_get_irq() to get the interrupt"), we should be using
> platform_get_irq() in ath11k. Let's make the switch.
>
> Without this change, WiFi wasn't coming up on my Qualcomm sc7280-based
> hardware. Specifically, "platform_get_resource(pdev, IORESOURCE_IRQ,
> i)" was failing even for i=0. Digging into the platform device there
> truly were no IRQs present in the list of resources when the call was
> made.
>
> I didn't dig into what changed between 5.15 (where
> platform_get_resource() seems to work) and mainline Linux (where it
> doesn't). Given the zeal robot report for ath9k I assume it's a known
> issue. I'll mark this as "fixing" the patch that introduced the
> platform_get_resource() call since it should have always been fine to
> just call platform_get_irq() and that'll make sure it goes back as far
> as it needs to go.

Since I recently stumbled upon this in a different (external) driver,
it's likely a1a2b7125e10 ("of/platform: Drop static setup of IRQ
resource from DT core").

Regards
Jonas
