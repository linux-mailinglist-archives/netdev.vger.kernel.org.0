Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE772E9C61
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 18:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbhADRvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 12:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbhADRvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 12:51:41 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98B8C061794
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 09:51:01 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id r9so25756090ioo.7
        for <netdev@vger.kernel.org>; Mon, 04 Jan 2021 09:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8yJ/rj6PqsYMOo0MoZO0uP7k3vo4VqrOAAA7Yfj2SrM=;
        b=PnYpgomnbf4mErWFaG51JHsFFY0QD3JKdmAzzZW/O7Zc+Gm4gJtjur4KVBv8BMo1Wy
         52CTOpUcxfSjuVyflvz9yPvBBTsse9PxYbBc2BTgh7KKjoqxVKWM8ugnQXiZrWcNMiPA
         X/CTuvFeqaJ1OmwpxJLTsW02HBnpO3jKD0HfYV5mwkDtuO1X1SkwatxLeOrw9gewT1F+
         mwBMA421ylfJ2pqMrV5ySMCTZTdQiHoU0Y53d/U4O1RNj7vRC6wxog9vYuuwCl3clKVN
         mIcK+YB3X8puQKnSiZSsq65qD16pGMILIi2/mAdiNp4vZ4chJeH8pU029IAmWlrTu9qQ
         MQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8yJ/rj6PqsYMOo0MoZO0uP7k3vo4VqrOAAA7Yfj2SrM=;
        b=dGFKfodmTCOGvxOnyMztUGX1otMl1ztj8WDRxRR1i8ZT6LtuzyGcj4kkbYGlUyLBZs
         XkoNkpZfy+IjnKxRV+y7G9adUlD0K9yS5g6rSKuh4v80e9elZY/3pEcFu2jyTmWJ/wQ4
         PgQM8gVTHiZSEa414PdY/LtppCr+QBOui71pjd0FpTwbjw1jmHAMoY1fiDsduN9GMhfS
         UAezcqhL2vylOINxJ0aiE0mY116LA0wejbmyPsCqn5kKwjtWDTBaGBgMY4AE60X5X+kC
         DtN8VdyP4EzV9aF6Hghw1P9+9q4MRd5MiKEK7wmn/1vYtYin4XO9k1AlQEMa/peUutcy
         0aDw==
X-Gm-Message-State: AOAM531qIBCXPfWkPcOtjp9tHcwRi9xqa0IOA0ZlTfM4pYv0Z6U340Yd
        2+JWKOzix2axqZ/S3N8Sd+/T6u6GT5g1l9RhgBA=
X-Google-Smtp-Source: ABdhPJxf9Pgn4ov3xk43GxXtJ8eZUiL+ObyrUYTa3QAQyVlxsSTk/qPq/rzc6ugWPfnG8568bBe8429PCjl3yfker5c=
X-Received: by 2002:a02:cf30:: with SMTP id s16mr62460852jar.144.1609782661106;
 Mon, 04 Jan 2021 09:51:01 -0800 (PST)
MIME-Version: 1.0
References: <20201223071538.3573783-1-eyal.birger@gmail.com> <20210104084436.GE3576117@gauss3.secunet.de>
In-Reply-To: <20210104084436.GE3576117@gauss3.secunet.de>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Mon, 4 Jan 2021 19:50:49 +0200
Message-ID: <CAHsH6Gu+jCWud1VTh_jJmg0Z-nb4e0ayzTpitrz6inuiEfcWtA@mail.gmail.com>
Subject: Re: [RFC ipsec-next] xfrm: interface: enable TSO on xfrm interfaces
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     herbert@gondor.apana.org.au, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steffen,

On Mon, Jan 4, 2021 at 10:44 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Wed, Dec 23, 2020 at 09:15:38AM +0200, Eyal Birger wrote:
> > Underlying xfrm output supports gso packets.
> > Declare support in hw_features and adapt the xmit MTU check to pass GSO
> > packets.
> >
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
>
> Looks ok to me.

Great, Thanks for the review.

 Should I submit a non-rfc patch once the merge window opens?

Eyal.
