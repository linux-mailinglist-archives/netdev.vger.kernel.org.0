Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC231A3E21
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 04:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgDJCTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 22:19:53 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38610 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgDJCTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 22:19:53 -0400
Received: by mail-io1-f65.google.com with SMTP id f19so469775iog.5
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 19:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wG5LSwPYeErDHEL7gyvpikJDXawVdrLpPlB6bwcLQys=;
        b=FtZ3l44uhworJnVnS61mliTb8l7FBSkyyqaNd974mwJPYzjte0m3Sy0fYcv7/FjzkP
         73rAYLmy7JSeR5XRn5Xis1brunpnMUchgEFB6OA5IDlfPZRTp0O2XZMtDd3tVv+9rJN+
         WjEdcsYfdwQmKh/s+HnAlXzjFMn3ge2j05tL42vhJpOCB39jYWSB+sWNdmIKxkVbv7vw
         UNG9ft1WixS6GlUHR96wB5TVArnA9iT0Vkr44H0Qmnm5O7BKDEUCFlJORVS/4aipBot6
         tIySWQ06EvfpIKszJ9f5dI0GuMt4BebnUNY/GOipHUSX0ps9E7XxF7OLD/dSNYGUtE5H
         kLVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wG5LSwPYeErDHEL7gyvpikJDXawVdrLpPlB6bwcLQys=;
        b=VMR90DXmEZYp3WlWb9LGBRiXL9ehJRD3rlpiUu49zeijoemAQ4civvlTVbB3zz+lf/
         HqYvkmjDC1XXSusVZJTl5WJwN/rpWRAYdE0g454zYPJe5VFceGU1/eVOwizn92VH+otZ
         UZyuJwYMksopRg8LYWWL9m14WD7zBNuhbK6XLRykNu73GKx5fhVciGZpEnTnruh4DCGJ
         gYYJVleeTAk+kjwJjpWywovqnarhCVndpDEOPNUWKNxpDmnj0LXP+fwlFzOt98/KOoXj
         WZzIvjSYGY/Xl1QWR5F+chdzhI1ZaqUEuei5mb9RqW+K/ySLn98N0Nk21n4qxqenhsSr
         XbkA==
X-Gm-Message-State: AGi0Pubmip/MyflrDEwDHSZEhY92S/vCWIRroilLbax/PS1pehi90xon
        TJFCwa6Ub6K6VszwZP8iMtrD59ktBoKvZlEEqYMWTUsj5KuiDQ==
X-Google-Smtp-Source: APiQypKGnoeBngyMgm/Kcfo1B5o6gk77Hyt/Zgeuoxib0h9TUKbP/KJ32PHU5llYbSN2W0VTlCwQjQeoqbvOj1u0oiA=
X-Received: by 2002:a5e:dd47:: with SMTP id u7mr2303594iop.6.1586485192812;
 Thu, 09 Apr 2020 19:19:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200409155409.12043-1-dqfext@gmail.com> <20200409.102035.13094168508101122.davem@davemloft.net>
In-Reply-To: <20200409.102035.13094168508101122.davem@davemloft.net>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Fri, 10 Apr 2020 10:19:42 +0800
Message-ID: <CALW65jbrg1doaRBPdGQkQ-PG6dnh_L4va7RxcMxyKKMqasN7bQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mt7530: enable jumbo frame
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sean Wang <sean.wang@mediatek.com>,
        Weijie Gao <weijie.gao@mediatek.com>,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So, since nothing else uses the mt7530_set_jumbo function, should I
remove the function and just add a single rmw to mt7530_setup?

On Fri, Apr 10, 2020 at 1:20 AM David Miller <davem@davemloft.net> wrote:
>
> From: DENG Qingfang <dqfext@gmail.com>
> Date: Thu,  9 Apr 2020 23:54:09 +0800
>
> > +static void
> > +mt7530_set_jumbo(struct mt7530_priv *priv, u8 kilobytes)
> > +{
> > +     if (kilobytes > 15)
> > +             kilobytes = 15;
>  ...
> > +     /* Enable jumbo frame up to 15 KB */
> > +     mt7530_set_jumbo(priv, 15);
>
> You've made the test quite pointless, honestly.
