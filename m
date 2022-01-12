Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF04548C799
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 16:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354796AbiALPuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 10:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354833AbiALPtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 10:49:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D65C06173F;
        Wed, 12 Jan 2022 07:49:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3CBAB81F71;
        Wed, 12 Jan 2022 15:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24404C36AEC;
        Wed, 12 Jan 2022 15:49:49 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="QpBtYbI9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642002586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pshnUO5xYpkkdXPtgf9tc4a2VXTQic0G5jxH023mrV0=;
        b=QpBtYbI90gDkx694sKwf4xo7OSjyDeiyrChbl+ipUVkvWshdRDyxB1SB1U0KDpBIiIH0Y0
        SFap77Q61vWVUHkea8rOWo5hqErKENXaqfcKhUROpCxPJAStailtvU1ypErepvgrmIyhnu
        +8ZlOGzt1uOmdMFt1+fpoYGnUl4VrJs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 223ff93e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 12 Jan 2022 15:49:46 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id p5so7474998ybd.13;
        Wed, 12 Jan 2022 07:49:45 -0800 (PST)
X-Gm-Message-State: AOAM533/Ei4BTlJlJw5Rj25MgUYFAya+pR0ooHQ5YJEHtkS1tltQZERP
        wDDYz+n/ti37qwhYd2cXMlD959HPCNwZwV+IUtI=
X-Google-Smtp-Source: ABdhPJwVyAaXipSkjfhiFQhM7/wC2UupGS2Wv7UVpd1PBvAYip0LDwtp6/NNMx557OIKy+4x0swc/ZlfSyvEsLyEQ1E=
X-Received: by 2002:a25:f90d:: with SMTP id q13mr397640ybe.32.1642002584806;
 Wed, 12 Jan 2022 07:49:44 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-3-Jason@zx2c4.com>
In-Reply-To: <20220112131204.800307-3-Jason@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 12 Jan 2022 16:49:34 +0100
X-Gmail-Original-Message-ID: <CAHmME9p1NXemJnpZ07fAzkMMa-nQ4cBoQYP_Y+FpNFao0S5t_A@mail.gmail.com>
Message-ID: <CAHmME9p1NXemJnpZ07fAzkMMa-nQ4cBoQYP_Y+FpNFao0S5t_A@mail.gmail.com>
Subject: Re: [PATCH RFC v1 2/3] ipv6: move from sha1 to blake2s in address calculation
To:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the record, I've been able to simplify this even more in my
remove-sha1 branch: https://git.zx2c4.com/linux-dev/log/?h=remove-sha1
. We no longer need the packed struct and we handle that secret a bit
better too. If this patchset moves onto a non-RFC v2, that'll be part
of it.
