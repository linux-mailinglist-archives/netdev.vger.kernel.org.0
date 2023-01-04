Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F3665CE54
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 09:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbjADIaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 03:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234187AbjADI3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 03:29:55 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040E81AA3C
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 00:29:42 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id i19so21786686ljg.8
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 00:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HT3sx9aBPUAzOAulLJHa070LLoPurw3U1M7Y3HUSPaM=;
        b=jx2y7oW0zLABPdwWz4CItcsnV6/XWDwtZ5yqlw2YG4lrt7vYfceaSYcKBhxXQ6gID6
         FkMea47vn8Vhgnjd6AgJtJzA8YqGy6AqckGVTGGrwaQ0/jT0anwcZYPRdJUtLlCiIOcd
         4DXkg28j8nwHCiL+qVBaGFjfRgvNKC9skbIoQiUIKdlwgt0HLAUEYilPYvVIrBJRb0Cn
         G6+LF33C8e3ywXD+gE2Mv+1CxwMxdFbctG9pPkSYOf3OLjZcsKMxPZk0qRVGZxP+pPVG
         /UgLdo9N6yK82hGyofdWGFuleaiSoIIOanqdThHb1wA3cr8ykQBpMV/bhDeqW2+YOfYR
         U4mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HT3sx9aBPUAzOAulLJHa070LLoPurw3U1M7Y3HUSPaM=;
        b=4m5SRdfEqeZVG+fANSNC1SHWycQJHj0Zze9eksdyOJYS5c19tVvCYRLU03dc8K6iJk
         l18+X/SfqcU9Xgs0kRrhyTEULPm1Jw4Oe+/Kau5WTkERGtm/e+HGWcUlGvqmSspgx640
         TUX0qkqGua5wG/M2xTLqMMAn0WRlJ2t84Jas6U2H+XYnb2ymBG7nyeq3CslgeZYvKDue
         6ZdY4dW4UECg9Y6RzlcOIzkAa9V7g7o8Slmy9MDxhs1gdaWpD3mnJAhgo+quT8x7M7JL
         G8iRRaQnwq6h58bplNlK54BvvyjAxAfVvXE934DlJbp3eYefn0h5iaE0DD8Xy2N2KgLL
         vJ2A==
X-Gm-Message-State: AFqh2kqqRsWdhzIffxFjdNfYQVF+7gPAMRI/F2qwGI0TftQRXHjCXt2g
        XyxQh7ANRV7+rlDgNdkNFfeWzlFuuyXHkwqs6I3pqrAQE1k=
X-Google-Smtp-Source: AMrXdXt1nhWogzIlRZs8ONRJSZ7+gM5Gd3bOhhGa01bBpc2r6vsXDwsG7pGaR5kABjfm7taK+sO1rFezftxQjseZEgM=
X-Received: by 2002:a05:651c:194b:b0:280:1f0:f08d with SMTP id
 bs11-20020a05651c194b00b0028001f0f08dmr145725ljb.287.1672820980552; Wed, 04
 Jan 2023 00:29:40 -0800 (PST)
MIME-Version: 1.0
References: <20230104081731.45928-1-mika.westerberg@linux.intel.com>
In-Reply-To: <20230104081731.45928-1-mika.westerberg@linux.intel.com>
From:   Yehezkel Bernat <yehezkelshb@gmail.com>
Date:   Wed, 4 Jan 2023 10:29:20 +0200
Message-ID: <CA+CmpXs+8HPvv=0x93PHS4Po+QyBi4pS1Q-8PhGEO9J3UNhPpA@mail.gmail.com>
Subject: Re: [PATCH 0/3] net: thunderbolt: Add tracepoints
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Jamet <michael.jamet@intel.com>, netdev@vger.kernel.org
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

On Wed, Jan 4, 2023 at 10:17 AM Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
>
> Hi all,
>
> This series adds tracepoints and additional logging to the
> Thunderbolt/USB4 networking driver. These are useful when debugging
> possible issues.
>
> Before that we move the driver into its own directory under drivers/net
> so that we can add additional files without trashing the network drivers
> main directory, and update the MAINTAINERS accordingly.
>
> Mika Westerberg (3):
>   net: thunderbolt: Move into own directory
>   net: thunderbolt: Add debugging when sending/receiving control packets
>   net: thunderbolt: Add tracepoints
>
>  MAINTAINERS                                   |   2 +-
>  drivers/net/Kconfig                           |  13 +-
>  drivers/net/Makefile                          |   4 +-
>  drivers/net/thunderbolt/Kconfig               |  12 ++
>  drivers/net/thunderbolt/Makefile              |   6 +
>  .../net/{thunderbolt.c => thunderbolt/main.c} |  48 +++++-
>  drivers/net/thunderbolt/trace.c               |  10 ++
>  drivers/net/thunderbolt/trace.h               | 141 ++++++++++++++++++
>  8 files changed, 219 insertions(+), 17 deletions(-)
>  create mode 100644 drivers/net/thunderbolt/Kconfig
>  create mode 100644 drivers/net/thunderbolt/Makefile
>  rename drivers/net/{thunderbolt.c => thunderbolt/main.c} (96%)
>  create mode 100644 drivers/net/thunderbolt/trace.c
>  create mode 100644 drivers/net/thunderbolt/trace.h
>
> --
> 2.35.1
>

Acked-by: Yehezkel Bernat <YehezkelShB@gmail.com>
