Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D56A52C1F3
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 20:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241269AbiERR7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 13:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241140AbiERR7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 13:59:13 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E238CB21;
        Wed, 18 May 2022 10:59:11 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id n13so3418595ejv.1;
        Wed, 18 May 2022 10:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2EXLfpaR9WvqL8huPkuehcAb08K9DJWvKulz74lLwjw=;
        b=Urdlnv8IqAORyjTFmHZLBgcOzSzrZSHWlU9e7dz7blnq9rEiu55Ve3Q0Po4tYZIx+G
         9TIXsHkVnSuplxMVXKRM6GJVjhLGm0PUkQECW0bwkLuJPOrG/eyTyf5F25rYNCIw4aAP
         7yV1u/4cqsRvUNUH6ndn25TFkTxg4ewWEdvAcgYZ5UwHcNSg/6xHRSkZ1kcFp1UeaNzr
         OuVZJ6m5qgpnaZpx4mqnbi07koAg3rkKFxtmTqyusGOshud83kMwt0veApxORp+jPDxU
         i8gAuaf4FaU6R0A4T4hxeBWrQim+obyQzf1R8wI2/XexlaI9wnaQbfEOfJ8ji0czQdq5
         qByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2EXLfpaR9WvqL8huPkuehcAb08K9DJWvKulz74lLwjw=;
        b=eIr9SsgktXUpCiZaCJjIpSh+8MJiaros+5Ml8laf+Q5ixB0PPSxezJ3noeFnLpQ/+p
         DTNN18LyF21IlpmbQe1AMqDB8t7zYqbIKRXcG0tvPmM6QRDi74E+o7h/B3+axxewO8UK
         8+GACnILz9bQonvgFrmMPczTgjbIapXVQaTvxYf4+38zSewPOanjheGBXrICpDYdXsln
         KS7I7WIIk3jjxKXCY/gNwCGiC7+CrQWtSDDUjtezjTJrEvQqUtgGRRdlTtPahMscfws6
         P9XJSQ2lEcK462CTiOrK+SfinI+cTSHq3h4gqKrAU5TSHcWCvhUeMiEKCBM5QRKmNdz6
         OLGw==
X-Gm-Message-State: AOAM5327EG7ytIdnEp8Eig/vdGGsfaTh8s1seML8uwS+jQY5zquNw8Hl
        Vx5D9WjPt28zaAKzDQNZsUpdT8rukhScbHnLnwQskt/p
X-Google-Smtp-Source: ABdhPJxC/Wsua39QofOOC9FOg1Mm9DKIGDvecUCE9Bbgi51eryTiNG0+r6d/o3bmozvtPAmdT88tf4sToyBK1+jUGfw=
X-Received: by 2002:a17:906:7e19:b0:6f4:5004:d442 with SMTP id
 e25-20020a1709067e1900b006f45004d442mr685470ejr.147.1652896749683; Wed, 18
 May 2022 10:59:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220517194015.1081632-1-martin.blumenstingl@googlemail.com>
 <20220517194015.1081632-2-martin.blumenstingl@googlemail.com> <20220518114555.piutpdmdzvst2cvu@skbuf>
In-Reply-To: <20220518114555.piutpdmdzvst2cvu@skbuf>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 18 May 2022 19:58:58 +0200
Message-ID: <CAFBinCBZ6dDAgC+ZUAPOwTx5=yVfYBYvODs=v+DQzGzeEOeiDw@mail.gmail.com>
Subject: Re: [PATCH net v1 1/2] net: dsa: lantiq_gswip: Fix start index in gswip_port_fdb()
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Hauke Mehrtens <hauke@hauke-m.de>
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

Hi Vladimir,

On Wed, May 18, 2022 at 1:45 PM Vladimir Oltean <olteanv@gmail.com> wrote:
[...]
> The patch, as well as other improvements you might want to bring to the gswip driver
> (we have more streamlined support in DSA now for FDB isolation, see ds->fdb_isolation)
> is appreciated.
Thank you very much for this hint! I was not aware of the
ds->fdb_isolation flag and additionally I have some other questions
regarding FDB - I'll send these in a separate email though.
Also thank you for being quick to review my patches and on top of that
providing extra hints!

> But I don't think that a code cleanup patch that makes no functional
> difference, and isn't otherwise needed by other backported patches,
> should be sent to the "net" tree, and be backported to "stable" later?
Sure, I will actually re-send the whole series based on net-next.
When I initially wrote this patch I thought that it would fix a more
severe issue. Only later on I found that the bug is harmless (as
mentioned in the patch description). When I then finally sent the
patch I just stuck with my original plan to send it for the net.git
tree - instead of re-thinking whether that's still needed after my
latest findings.


Best regards,
Martin
