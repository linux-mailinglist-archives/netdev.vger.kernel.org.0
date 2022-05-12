Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB420525353
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 19:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245709AbiELRL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 13:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356928AbiELRLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 13:11:01 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EE027CF1
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 10:10:55 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id t5so6984732edw.11
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 10:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=loonHWmCtVeGx4aWVVUzPzapZ1t+QIqGsKXmCgmw6z8=;
        b=WD5qjD3n7PQ6Q1+OHYaSBYIXZyE3MSnd14hOsae1gMnqzXVow2TJFjREwN777Ig52q
         V4qfULfCcQ86ni9aAhSi7LjMQHCPkFJi+glv65R1S+sQR6oFUNEhVyq5JADGgBm6h1kT
         2hznSR7F9VZ12haH7nWz1Ev8hTm8abuX+I6D4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=loonHWmCtVeGx4aWVVUzPzapZ1t+QIqGsKXmCgmw6z8=;
        b=UrTyIZEHx6RRGTCgfW7NXnIv1S/vWZ5TDvUhnbrzGpT29B5zfSxE9nSlT9YMaxnQHY
         epI9OaE4qrf2hcKZgHMdHWza11cM1SEiGVpnMI4yUQHkYF4zi3enDiLpUaKDYgpKvDvh
         LgVC0jN155Ryit4WyQas3UZKVJAvwpqui5N7Gsm+ki+01SorPqoAeU1goF3iURqqsfRJ
         Axk2rNnnMM5QOM/7jdqf1TjdpQjCjEOP7WXo2LYB0dOTvEa/Jh4Q0QmTtxSC6Ts/rpny
         SOwO9GNzCuQ5yInoaDA6Rk99W0aQKUjotTFXKyFAm3Q4y8p72SGtJmX0GGWSsp8lpsU6
         BKcw==
X-Gm-Message-State: AOAM531xmoaRX8Z7ZEEETUbzyuoeV4O26VkwyZJe0r972sf1POfu6vvX
        dUDK4A9gvCBkXYInwE0EEBabcCRdiQhGm7PGHNs=
X-Google-Smtp-Source: ABdhPJwS4VShBRXWn2sC6fZDamGx+ZVY5z/uHiW4swjMto4A+rKgdX5/4QiB4nQG8fzJlBqC3y1F+Q==
X-Received: by 2002:a05:6402:5253:b0:427:ed62:bb8b with SMTP id t19-20020a056402525300b00427ed62bb8bmr35822429edd.65.1652375454161;
        Thu, 12 May 2022 10:10:54 -0700 (PDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id t8-20020a170906268800b006f3ef214e18sm2214066ejc.126.2022.05.12.10.10.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 10:10:52 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id m1so8153369wrb.8
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 10:10:51 -0700 (PDT)
X-Received: by 2002:a05:6000:2c2:b0:20c:7329:7c10 with SMTP id
 o2-20020a05600002c200b0020c73297c10mr557896wry.193.1652375451235; Thu, 12 May
 2022 10:10:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
 <87czgk8jjo.fsf@mpe.ellerman.id.au> <CAHk-=wj9zKJGA_6SJOMPiQEoYke6cKX-FV3X_5zNXOcFJX1kOQ@mail.gmail.com>
 <87mtfm7uag.fsf@mpe.ellerman.id.au>
In-Reply-To: <87mtfm7uag.fsf@mpe.ellerman.id.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 12 May 2022 10:10:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgnYGY=10sRDzXCC2bmappjBTRNNbr8owvGLEW-xuV7Vw@mail.gmail.com>
Message-ID: <CAHk-=wgnYGY=10sRDzXCC2bmappjBTRNNbr8owvGLEW-xuV7Vw@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: last minute fixup
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
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

On Thu, May 12, 2022 at 6:30 AM Michael Ellerman <mpe@ellerman.id.au> wrote:
>
> Links to other random places don't serve that function.

What "function"?

This is my argument. Those Link: things need to have a *reason*.

Saying "they are a change ID" is not a reason. That's just a random
word-salad. You need to have an active reason that you can explain,
not just say "look, I want to add a message ID to every commit".

Here's the thing. There's a difference between "data" and "information".

We should add information to the commits, not random data.

And most definitely not just random data that can be trivially
auto-generated after-the-fact.

                Linus
