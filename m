Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7667F60836B
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 03:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiJVBxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 21:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiJVBxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 21:53:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1A52CDEB;
        Fri, 21 Oct 2022 18:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74564B80CB0;
        Sat, 22 Oct 2022 01:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1A6C43470;
        Sat, 22 Oct 2022 01:53:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="hrD1fy18"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666403588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rZmgGNrZrKnSHJUXdPvr1CVgxx3pz8zkqE2JHpWrLoo=;
        b=hrD1fy181ftNPMbLIWvdq1TNmPl2/0CdM7/Lk64vw7BAl7M3MktAAgao0pqv3r7qgniXsO
        4BD4bX4lfMYnva80UWxouoW5ERbvot+JnSptzx/6Yzykm7WremVTgfjhY9iKkxDyjOWqpC
        /2+jF0qKe+aEBbQ/Vq7qoHvdyFxkTMQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6e0cb5ea (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 22 Oct 2022 01:53:08 +0000 (UTC)
Received: by mail-ua1-f41.google.com with SMTP id f12so2931157uae.3;
        Fri, 21 Oct 2022 18:53:07 -0700 (PDT)
X-Gm-Message-State: ACrzQf3t87fLmziRZtK/py17szxZwPNJ4oh/SxdzHoTUq6tEI3CagJUp
        Focj4BQduO9MEXXvNQxE+lVnteReIM4It3Afn10=
X-Google-Smtp-Source: AMsMyM7ESXRvCZptaWCL4tIaUktlfbhaS7HlVAdnbJrL1GncaUouT2QrgQVBs6Gulq+WjUOj02W9TYHyY5dXtNj1mQI=
X-Received: by 2002:ab0:6413:0:b0:3e1:b113:2dfa with SMTP id
 x19-20020ab06413000000b003e1b1132dfamr15868037uao.102.1666403587008; Fri, 21
 Oct 2022 18:53:07 -0700 (PDT)
MIME-Version: 1.0
References: <5894765.lOV4Wx5bFT@eto.sf-tec.de>
In-Reply-To: <5894765.lOV4Wx5bFT@eto.sf-tec.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 21 Oct 2022 21:52:56 -0400
X-Gmail-Original-Message-ID: <CAHmME9oHzopzm9PjpaYsLFujY5O+mdt0_NujUcpEp764CvGU8Q@mail.gmail.com>
Message-ID: <CAHmME9oHzopzm9PjpaYsLFujY5O+mdt0_NujUcpEp764CvGU8Q@mail.gmail.com>
Subject: Re: [PATCH][Resend] rhashtable: make test actually random
To:     eike-kernel@sf-tec.de
Cc:     Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Oct 21, 2022 at 9:47 AM Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
>
> The "random rhlist add/delete operations" actually wasn't very random, as all
> cases tested the same bit. Since the later parts of this loop depend on the
> first case execute this unconditionally, and then test on different bits for the
> remaining tests. While at it only request as much random bits as are actually
> used.

Seems reasonable to me. If it's okay with Thomas, who you CC'd, I'd
like to take this through my random tree, as that'll prevent it from
conflicting with a series I have out currently:
https://lore.kernel.org/lkml/20221022014403.3881893-1-Jason@zx2c4.com/

Jason
