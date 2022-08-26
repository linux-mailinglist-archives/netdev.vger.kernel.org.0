Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024F25A1ED5
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 04:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244795AbiHZCdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 22:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243483AbiHZCdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 22:33:20 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84AF6CCD73
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 19:33:18 -0700 (PDT)
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 8C3E33FFAD
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 02:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1661481196;
        bh=nUe5FUkp5BM8mlUb6+rDyzPScCmSYf6H5ZIbxJFBzKI=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=K6UhQpsY49bimB/8FOmwfQPvCNmha7Q9UtNIsY8cHesIE1ZErfmCulInwbTRpxd4u
         XK7rL5lU1SOa4UeqZrGP4Vk2eIOdtq7xSjLseqEITK+WxwJDdVdtrwADySOCTZVJ6V
         EnaLExGYjAukVjK0ngnqXQ/pGvNh0F6+SaAZsOnGD5yzKAua1Tbx4XCuik/o7uQ4lK
         q4349RYHuuEp7iGBngyucvfpS2DqGQvN0IcwuHBQk1ZRJ+xL8dSzSo2YBiPaZRzp+a
         4kUsj6z6FoIz0PrZi2cSIe0/NU2OFIAnC9D3SudP+zNUJHLbSuUSASKWNbrwSU4oJe
         YqKaVSZgI/C9g==
Received: by mail-oo1-f69.google.com with SMTP id b19-20020a4a3413000000b00448add2bb38so246434ooa.11
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 19:33:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=nUe5FUkp5BM8mlUb6+rDyzPScCmSYf6H5ZIbxJFBzKI=;
        b=21dclXAxA9/Y0OM1HLyF3nHSStwwkv3qsG2iq8kZ6yqaduauhofEzfol0q0dPr9En1
         17DwLZo2gR2XaYf3hRuoLBDG/MIFGPFI62dO+ntAlCj3op7BWkHOun9nFxLlMLRQXeCi
         sBOBsfyrUjKpnHA+cnXZctUsPgT/NVkQgNM3oLPkgtUSOUeuM7xzyccSucUx2K6fr6RS
         bcS9gUodnUvM5Zla/hWEQtRiuxP9l24AXso/cUnlkII0qan69OrMwLYTx+wY0bLbuoZZ
         uMfVFgLrt2FT0Mhq7bZ6qyQl3Je+PgeOVkNVeaNcvuOk9WUJAjhU5jVpxYsPn5LqL+95
         Kw+g==
X-Gm-Message-State: ACgBeo2ijYVbYukIVEcvolgjUdkW/7pm/bwBDb3qTfaOb1xff2xHPsph
        Cmova5aorYJmRQ+JzxrJ3ipgA9/THOvFwZSm+KQTFf74MPeYxPrr+IvwzVfkhF2fYXIcJV78ECx
        3b7IiMyCdnWLEWqcV+hXLVVgl+A0ww6v+8H/oxX6jo0maSvJPbg==
X-Received: by 2002:a05:6830:56:b0:639:bbb:f0cf with SMTP id d22-20020a056830005600b006390bbbf0cfmr640888otp.161.1661481195523;
        Thu, 25 Aug 2022 19:33:15 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7TFBWGF0ixay4ZBvqbgrqxXt9V5BPVUWMtfHjty3Dd9xD2Siok+CMHe9Hpq+thX/xTUOqz6zLVJPjb2dI3opU=
X-Received: by 2002:a05:6830:56:b0:639:bbb:f0cf with SMTP id
 d22-20020a056830005600b006390bbbf0cfmr640883otp.161.1661481195289; Thu, 25
 Aug 2022 19:33:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220825063852.1120632-1-kai.heng.feng@canonical.com> <20220825104403.740cac15@kernel.org>
In-Reply-To: <20220825104403.740cac15@kernel.org>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 26 Aug 2022 10:33:03 +0800
Message-ID: <CAAd53p78YwD2bcrQeoH7gg4D=Jk5LYBEbj7boMOQFn2LAh8qUA@mail.gmail.com>
Subject: Re: [PATCH] tg3: Disable tg3 device on system reboot to avoid
 triggering AER
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, Josef Bacik <josef@toxicpanda.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 1:44 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 25 Aug 2022 14:38:52 +0800 Kai-Heng Feng wrote:
> >       rtnl_lock();
> > +
> > +     tg3_reset_task_cancel(tp);
>
> Doesn't this "task" take rtnl_lock()? Looks deadlocky.

Thanks for the review. I sent v2 to address it.

Kai-Heng
