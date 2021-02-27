Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25306326B1F
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 03:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhB0CNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 21:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhB0CNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 21:13:08 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56474C06174A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 18:12:28 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id lr13so17819191ejb.8
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 18:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XOh4jWGZzUzzkdrgEJp7auQd7xh6McchmmYXJ3xSdfw=;
        b=YqHg6NDXywR35GiV6w60PgfAvLBPl201VfsWGuPANyg47+utFMAWvo9IFo/+R9bDdi
         G8PFG9HEMongFdH+48seOSRxe8PciOpdYin2q0EKd6BsY7xheAy96T9nmpYyHkVMCpEH
         XmDoNSXmAvnnjW4PXExDKTAoCKK6qawRXshLrO77YM6pJ5KoR9nyUIlgC+HOtNLuzrGT
         gpQcBpeQpt7D0C6oyHjD7UHzBzAlxacprdeqQlGXgdLGwGnBnCfwbimlPzOXPauv0iT2
         AHFWpEcZBUkseMzFXJWxwx58+ixRviowqnWrlmwSUAOLwic88MSj5EoaF/w4+GkW6ldB
         EJPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XOh4jWGZzUzzkdrgEJp7auQd7xh6McchmmYXJ3xSdfw=;
        b=WE+n0HQIONpmQqmBzSYpf5qhuYdzksEqJM+HUoBEn/G5l40UD7TTn6vM++CxDhiQJ5
         he+xd8Ui2Z/S+wr9sPiJQwKdW2Qut48StD12f7pTbmjS42fiqlvvrSzLEfaT5Pe/c8sP
         yscIWsVsNNHrcoEtkT3RdoQbAXAFSVIbagRK8Cq8dnc5WBvHv6ipK80Lq4NI5SZJ2qF5
         5W5NMHHaFL9zSydH7yLL2yEew88C64c3xY9vxtfPK01bLTOnTmvq9yA0tjKkTyuPkapK
         oHGNjXiGenyC27Yyma+8py8xHyfFjYj2w+1nEbPGzXTKQB0zVgG1Cv7+lJk+XPr4eD73
         0rgg==
X-Gm-Message-State: AOAM531Eo0EP3XTJu5F9VFkGQ8I97KIo0gBWah3v7kI65SqNBSdNfhQ7
        86B+F5Gf9smA+eNwD71cjhZsdrsk1+c=
X-Google-Smtp-Source: ABdhPJwrW9ejQbskb25edbGFWxMHCVcnt8EpPu7i7558y4tZDrr7vjMgTaD0pfm3UFmuDSh3yh+saQ==
X-Received: by 2002:a17:906:4002:: with SMTP id v2mr6225980ejj.135.1614391946787;
        Fri, 26 Feb 2021 18:12:26 -0800 (PST)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com. [209.85.221.50])
        by smtp.gmail.com with ESMTPSA id i17sm7307282ejo.25.2021.02.26.18.12.26
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 18:12:26 -0800 (PST)
Received: by mail-wr1-f50.google.com with SMTP id n4so10369487wrx.1
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 18:12:26 -0800 (PST)
X-Received: by 2002:a5d:4b84:: with SMTP id b4mr6061773wrt.50.1614391945914;
 Fri, 26 Feb 2021 18:12:25 -0800 (PST)
MIME-Version: 1.0
References: <20210227004019.2671818-1-Jason@zx2c4.com>
In-Reply-To: <20210227004019.2671818-1-Jason@zx2c4.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 26 Feb 2021 21:11:48 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfV1ehfMNOM=N0uBMG=hNsdrx3+-eAcpvUc=yapbk5jbw@mail.gmail.com>
Message-ID: <CA+FuTSfV1ehfMNOM=N0uBMG=hNsdrx3+-eAcpvUc=yapbk5jbw@mail.gmail.com>
Subject: Re: [PATCH v2] net: always use icmp{,v6}_ndo_send from ndo_start_xmit
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 7:40 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> There were a few remaining tunnel drivers that didn't receive the prior
> conversion to icmp{,v6}_ndo_send. Knowing now that this could lead to
> memory corrution (see ee576c47db60 ("net: icmp: pass zeroed opts from
> icmp{,v6}_ndo_send before sending") for details), there's even more
> imperative to have these all converted. So this commit goes through the
> remaining cases that I could find and does a boring translation to the
> ndo variety.
>
> The Fixes: line below is the merge that originally added icmp{,v6}_
> ndo_send and converted the first batch of icmp{,v6}_send users. The
> rationale then for the change applies equally to this patch. It's just
> that these drivers were left out of the initial conversion because these
> network devices are hiding in net/ rather than in drivers/net/.
>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Fixes: 803381f9f117 ("Merge branch 'icmp-account-for-NAT-when-sending-icmps-from-ndo-layer'")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Acked-by: Willem de Bruijn <willemb@google.com>
