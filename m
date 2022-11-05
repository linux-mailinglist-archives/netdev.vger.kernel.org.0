Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A9B61DF35
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 23:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiKEW4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 18:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKEW4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 18:56:12 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B121BCBF;
        Sat,  5 Nov 2022 15:56:10 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id v17so12415275edc.8;
        Sat, 05 Nov 2022 15:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zP0zVoNY9bRmSC2JqzCNWw7/QwV/09WG5UmPPgvch3U=;
        b=ITEnNwVtzwYUXM9GiBOje7UESNtMaKpXoKTRvxf9P/AI6w0n1UztX9zzK7K7sjBfMl
         cx8tCJSd64ZPIjwBsDwnGdcicIERP2qeIIPbUPQBuocsbFUQuKYvBbMjBpyVu2f25xtJ
         dFdHZ/gW4KeeLzrmGCERzCRRMSksSaRNElzMiVi5LBGmR+f2SQ/+3gYUdizT/oO1gpNw
         s1ntGXJ+DVDMyw7PnmdFu9XqHcWtA9qlvdMvA1nIkzDVkXwN4R5q+vuRo8+TbBBpun6w
         1z8Ga3WWhamod0INV2QTHj+EfMT3ONa0gejegma55sdo4/DD3R03P8JyXlu/UsFrOF0p
         KpEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zP0zVoNY9bRmSC2JqzCNWw7/QwV/09WG5UmPPgvch3U=;
        b=DgWVEuEw3Z1tzGd/U8xmwC/X7LIltrvzP8sGX0WgJ5b9Qxhv4GIs3Ebw8/mHhI79xe
         OHW3GhlZ6y8IR96aBr+6Gf8+zMZUOvQZyKmYz5m/BrVjfJiDnja/iTpBehhT+th+lT4U
         SStCYuSPEDZj+b4u/J/I38OBPfbLw7MBaAqRfSlM6WH7Pw/j1PB/Sir4g4rDacYwcbnx
         2zI85JCXNgm6j2V5F7y0CRUeZ3r1Cq+qeAPlCMBCrY6LCZ2aVdOGbQzZpVFuMOfpXk2p
         +o3J+QxbVHcFo36UoutmoCUeLrWRPB1i74W33pXrC1/mjrQBpf6U6QXk6JeaYLXCturK
         YYiA==
X-Gm-Message-State: ACrzQf03UjlHJ4ABv7pk82a2SgxyWKRc9e9ELPcieMRfyf+TwbwgOfxU
        lOq61svKg4nhIzfQpaxIzPlvM7dKfKjqCFBsoWw7fjFSAVE=
X-Google-Smtp-Source: AMsMyM4szC53zUWs/viztgubknkdNxRoJepHUcXEVFQ7TSnVHReU8QFBSlIdlj2Od+GHx8/ceJxZvd4BbluaiSU+qnw=
X-Received: by 2002:a05:6402:31f4:b0:461:604d:2607 with SMTP id
 dy20-20020a05640231f400b00461604d2607mr43491798edb.330.1667688968775; Sat, 05
 Nov 2022 15:56:08 -0700 (PDT)
MIME-Version: 1.0
References: <20221104083004.2212520-1-linux@rasmusvillemoes.dk> <CAFBinCBiTgV5uC2Dq3Lowj5WXFk7U0XuY07717oAMGc+jH15hg@mail.gmail.com>
In-Reply-To: <CAFBinCBiTgV5uC2Dq3Lowj5WXFk7U0XuY07717oAMGc+jH15hg@mail.gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 5 Nov 2022 23:55:57 +0100
Message-ID: <CAFBinCBJVqM86VxPzSxafav9iOepS4sHuYWTD_1wY0ZYdjmzUw@mail.gmail.com>
Subject: Re: [PATCH] net: stmmac: dwmac-meson8b: fix meson8b_devm_clk_prepare_enable()
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Rasmus replied to me off-list yesterday. His reply is important so I
am sharing it here.

On Fri, Nov 4, 2022 at 10:02 PM Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
[...]
> If we want to propagate the error code returned by
> devm_add_action_or_reset() then we also need to do the clean up within
> meson8b_devm_clk_prepare_enable(), meaning we need to call
> clk_disable_unprepare() in case devm_add_action_or_reset() failed.
> Your change just propagates the error code without disabling and
> unpreparing the clock.
Rasmus replied to me:
"devm_add_action_or_reset precisely calls the reset callback for you
if the add action falls..."

I was not aware of this but it's actually true, which makes the patch
perfectly valid. Thanks for the heads up Rasmus!

So this patch gets my:
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

I suggest applying it to net-next (even though it carries a Fixes tag)
so the various kernel auto testing labs can try it out on as many
Amlogic SoCs as possible.


Best regards,
Martin
