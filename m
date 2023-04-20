Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A846E9A9D
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjDTRWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjDTRWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:22:52 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A584D449A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:22:38 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id m14so2774294ybk.4
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1682011357; x=1684603357;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eRwp+gaoH/x8vy7YcRHrYzAXSAxeOGBrIDHI0r958iw=;
        b=HS7jJHdbrmQxD3JA56TJQ9f2wBot1P738RX30RJEZ09/WJoc5SCM4p8plI0DgiUiTl
         hBgXKyhqSxA4VRrlCGZxZL0KlUJcRorMWYI+WvL/PPy9SIUXk6pgdZMr2BsxtvakkGpi
         rKOkHBKYEGZZ/5xqbM73BX5MTNeV94OgmbBEtMbktw5aftwDF8kDznypvkUR+0wSEehu
         wqs+9RXibS5XHhbOkjWmfrWywQPNuoP/xKpdkFDgDJ3QUl933OuZjMPxHliKYkBJ4z2O
         N1UZy7E1f0Zd3s0WJUMR5FXCh/mqe/1N3GDyeSPNojTIBrDywKxVPvkLBKvSM++a8zO+
         Oyew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682011358; x=1684603358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eRwp+gaoH/x8vy7YcRHrYzAXSAxeOGBrIDHI0r958iw=;
        b=CwGWYXbu7KEKQKFN8ObkeAE2MI3Em1OgK91TIbLINZ1pCGpsE+2XvRzwsupch+nrJk
         gN438XFy7IUiQdGbKErrPoDyVOji0MIr6OMgfN9uUqOoNVD3HheYvj9nIBVO/x4A+iUD
         Djau1FtGR76pzDOwhjJpqaaWYJaCwqqU5KJNuFC6GfFR/5roSGQrNvLEr9vRWCIAsC5P
         iPkihA5HUFenVYMxa6GoI2OZAT9/9To/wFeqkcFHvGOUnP3LDqED5ouXClmrXtrAPEm4
         GNsZYW75lKCojP7ugsHKFkJZX9+3vKR19xvz0JzRiiMOjiX6pDcEYYFToeLKsJ2JY4A2
         Y/Sg==
X-Gm-Message-State: AAQBX9ejZtOovdtHWVd6acW7Le4jolU3fUODn6hnFOcqefJGKdZeTxIB
        sLMsd/CHUBw0c+ZlIwbb+mF0m1NtS+d87Bf/5BiY
X-Google-Smtp-Source: AKy350a6EwlzcjzK7fIm9GJdXJqVPmzNXf1LT/osl3zj6+BxMwW29Cvdcmkb6xIucrCyet4wYWLCqA3f42zN0F22FIs=
X-Received: by 2002:a25:e005:0:b0:b8b:ff4a:3328 with SMTP id
 x5-20020a25e005000000b00b8bff4a3328mr2004939ybg.61.1682011357677; Thu, 20 Apr
 2023 10:22:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230420035652.295680-1-saeed@kernel.org>
In-Reply-To: <20230420035652.295680-1-saeed@kernel.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 20 Apr 2023 13:22:31 -0400
Message-ID: <CAHC9VhQza6Wj+mEf-VDZX3f2em94R=CQm=ghNL55JkOSjR6H8Q@mail.gmail.com>
Subject: Re: [PATCH net] net/mlx5: Fix management PF condition
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, shayd@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 11:57=E2=80=AFPM Saeed Mahameed <saeed@kernel.org> =
wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
>
> Paul reports that it causes a regression with IB on CX4 and FW 12.18.1000
>
> Management PF capabilities can be set on old FW due to the use of old
> reserved bits, to avoid such issues, explicitly check for new Bluefield
> devices as well as for management PF capabilities, since management PF
> is a minimal eth device that is meant to communicate between the ARM core=
s
> of the Bluefield chip and the BMC node.
>
> This should Fix the issue since Bluefield devices have relatively new
> firmwares that don't have this bug.
>
> Fixes: fe998a3c77b9 ("net/mlx5: Enable management PF initialization")
> Reported-by: Paul Moore <paul@paul-moore.com>
> Link: https://lore.kernel.org/all/CAHC9VhQ7A4+msL38WpbOMYjAqLp0EtOjeLh4Dc=
6SQtD6OUvCQg@mail.gmail.com/
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>
> Notes:
>     This patch has a couple of TOODs, since this is a fix, this is the
>     shortest path to a solution, will do the refactoring later on net-nex=
t.
>
>     I hope Paul can test it before tomorrow's net PR, and I will ask Shay=
 to
>     test internally if he could today.
>
>  drivers/net/ethernet/mellanox/mlx5/core/main.c | 14 +++++++++++---
>  include/linux/mlx5/driver.h                    |  7 ++++++-
>  2 files changed, 17 insertions(+), 4 deletions(-)

I'm not sure where this patch stands given the current timing, but I
ran this through my automated testing this morning and everything
looked good on my end.

Tested-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com
