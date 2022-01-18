Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DAE492517
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 12:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240809AbiARLnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 06:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237441AbiARLnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 06:43:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE39C061574;
        Tue, 18 Jan 2022 03:43:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECD70612D2;
        Tue, 18 Jan 2022 11:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53D6C340E5;
        Tue, 18 Jan 2022 11:43:14 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="UWhDxVOV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642506192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UY51soStDeX7hSwfxW/Nourib51ic30YjyXLLEp9HtA=;
        b=UWhDxVOVNcUjzvUjwHhHyZQFX3zZLK5d4RfOkN0lnf3m9KvPS3j6bQjJKu4LDZbLIqNc1D
        LOZX8oz9CBYHnFxK7r275wTMloTj8R9AJqU6I2NYT5FDs0zM946ELlHB3z3o4AyPMb5TjY
        fp/rXFKHgo4ERVJ7g8yCS6L+u4GdKbc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 19799da0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 18 Jan 2022 11:43:12 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id m1so36183613ybo.5;
        Tue, 18 Jan 2022 03:43:11 -0800 (PST)
X-Gm-Message-State: AOAM531PKg4EhsUCoe1zdjAY6lMc0/aCdRE+MVZqPFWmdYh/TRtsMcQZ
        Iabo7mxnR1VF9KpUzEJjd4VVcilBjxXk2drnIGI=
X-Google-Smtp-Source: ABdhPJyEGJF0pwT3RY1nsH6lCBYOcSCuzgxGWqoaEC3w3XUMUZqr+gElLrE5UBtj52h3avkewVEljTNUn5n2TrbaiKo=
X-Received: by 2002:a25:854f:: with SMTP id f15mr32699113ybn.121.1642506189835;
 Tue, 18 Jan 2022 03:43:09 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:209:b0:11c:1b85:d007 with HTTP; Tue, 18 Jan 2022
 03:43:09 -0800 (PST)
In-Reply-To: <YeZhVGczxcBl0sI9@gondor.apana.org.au>
References: <CAHmME9rxdksVZkN4DF_GabsEPrSDrKbo1cVQs77B_s-e2jZ64A@mail.gmail.com>
 <YeZhVGczxcBl0sI9@gondor.apana.org.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 18 Jan 2022 12:43:09 +0100
X-Gmail-Original-Message-ID: <CAHmME9ogAW0o2PReNtsD+fFgwp28q2kP7WADtbd8kA7GsnKBpg@mail.gmail.com>
Message-ID: <CAHmME9ogAW0o2PReNtsD+fFgwp28q2kP7WADtbd8kA7GsnKBpg@mail.gmail.com>
Subject: Re: [PATCH crypto v3 0/2] reduce code size from blake2s on m68k and
 other small platforms
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     geert@linux-m68k.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, wireguard@lists.zx2c4.com,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org, tytso@mit.edu,
        gregkh@linuxfoundation.org, jeanphilippe.aumasson@gmail.com,
        ardb@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/22, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> As the patches that triggered this weren't part of the crypto
> tree, this will have to go through the random tree if you want
> them for 5.17.

Sure, will do.
