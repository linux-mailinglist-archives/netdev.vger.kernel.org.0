Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C907E5F35CC
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 20:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiJCSrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 14:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiJCSrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 14:47:23 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6501B7A6
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 11:47:20 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id m11-20020a4aab8b000000b00476743c0743so7329348oon.10
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 11:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=9+BGiHRC+t4jfVgAYmMsB8O50n5F9YYbfrvUcCDXzKM=;
        b=TR7E5rehtmTOnbqVeLL4DfkeJa4As7/WRyMlYBPCRv0ct3chPfDoXUgrM7k6nkesm9
         ScCUxWZUn/N2b92lKe/7ZQ5iI8ryYI8YRAxyKk2DMW/0bB+qoxIAFe7t3h/bUwkZ/m2E
         cYxYUGiuqRc7uZ/LXG1NpkzgAxP1bsu4Ha+FJwQ6ksZ9QVYsVNG2AwSJLLHk4ezhDDwX
         1h9jlxsceufNWepSq+KHyyuSnBj75hS4BPamgPV/sqIHh8BaXrikXFlywrS9lRYbRIfV
         XXl7bGL0XxJpUeBdhqW/NzWpG0LJ3OoTuFqx6TLyeKTWFMKxnO2xk2jnX4ha5kLCPBgF
         frAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=9+BGiHRC+t4jfVgAYmMsB8O50n5F9YYbfrvUcCDXzKM=;
        b=ikoRuu3Tl7Ql1woAITd9SsgxnmjekPACJrKidfufWfv38GaB4f5J+KqAOzOp/DCHZE
         HVTREl7A36ASdgpEwDDn0Tmz+YoBDjcyRRFY/IeCJxBl6qmuo2bFe6Qcmt0SNinIKbBp
         Qk8tT9C9s6xmrawsUHM/W4OrwDY7mB5lznCzwVPk6H9NOeg6vYYKxGGwFypjZn8TD+xf
         JxAmV5xbILI68ilVIe1pcRTHCy/1fRqlpAEXOeGkaf1cfDgWYc4oCZ4WzDxKbHJ/q0Bt
         /37tM6KtcFvbi7MvvADVRjkOrkMpUrymxtFp+B+DFKoIQ9HtHx7FtwLh7ECKU5188Klt
         QVaQ==
X-Gm-Message-State: ACrzQf3MVUjk13K1DCngMrNKho27pixdZcUbB+4v4Y/AMAq92D8gbAlT
        XnRL5buw7yo1xOc0eV3F5zywv7c0GlyNWMnOv5NoMw==
X-Google-Smtp-Source: AMsMyM50gyQ1bl/cMoZtMyAzR6aJFUiGKwwoyfHJ3t60U+2etUsYMfD/fDvYNO0hqOLwe+6n4GWRfs1cZFa69wIi3g4=
X-Received: by 2002:a4a:8932:0:b0:44b:3454:a9d3 with SMTP id
 f47-20020a4a8932000000b0044b3454a9d3mr8038384ooi.56.1664822822288; Mon, 03
 Oct 2022 11:47:02 -0700 (PDT)
MIME-Version: 1.0
References: <E1ofOAB-00CzkG-UO@rmk-PC.armlinux.org.uk> <YzsMQyPJ+I0FqVOA@kroah.com>
In-Reply-To: <YzsMQyPJ+I0FqVOA@kroah.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Mon, 3 Oct 2022 20:46:51 +0200
Message-ID: <CAPv3WKeCecHxmQS47eqZzSxaeLcu7P9CZ4GPeyEXQucggJ2Xig@mail.gmail.com>
Subject: Re: [PATCH net] net: mvpp2: fix mvpp2 debugfs leak
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pon., 3 pa=C5=BA 2022 o 18:22 Greg Kroah-Hartman
<gregkh@linuxfoundation.org> napisa=C5=82(a):
>
> On Mon, Oct 03, 2022 at 05:19:27PM +0100, Russell King (Oracle) wrote:
> > When mvpp2 is unloaded, the driver specific debugfs directory is not
> > removed, which technically leads to a memory leak. However, this
> > directory is only created when the first device is probed, so the
> > hardware is present. Removing the module is only something a developer
> > would to when e.g. testing out changes, so the module would be
> > reloaded. So this memory leak is minor.
> >
> > The original attempt in commit fe2c9c61f668 ("net: mvpp2: debugfs: fix
> > memory leak when using debugfs_lookup()") that was labelled as a memory
> > leak fix was not, it fixed a refcount leak, but in doing so created a
> > problem when the module is reloaded - the directory already exists, but
> > mvpp2_root is NULL, so we lose all debugfs entries. This fix has been
> > reverted.
> >
> > This is the alternative fix, where we remove the offending directory
> > whenever the driver is unloaded.
> >
> > Fixes: 21da57a23125 ("net: mvpp2: add a debugfs interface for the Heade=
r Parser")
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> Thanks for fixing this up properly.
>

I tested the patch and everything works as expected, thanks!

Reviewed-by: Marcin Wojtas <mw@semihalf.com>

Best regards,
Marcin
