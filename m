Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B9C3F3ACE
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 15:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbhHUNmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 09:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhHUNmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 09:42:35 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FBBC061756
        for <netdev@vger.kernel.org>; Sat, 21 Aug 2021 06:41:56 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id cq23so18271218edb.12
        for <netdev@vger.kernel.org>; Sat, 21 Aug 2021 06:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TeKh2a6tL1O7r/BPYMAdDrJPmjZaEASKoGVN1mT54FY=;
        b=KwIHmklndMgpFkH3N6bSWNDQ3P+OQ6J9a1Xfdop6d40wko87+aJh90VyHV9RNp9WXn
         KXZS/8L/XctzYmME5gXp2ke4ih7y7rX6+nJvfhV8bEbLhvEb3VCzpOPCzpylZa0xRk+g
         N5Ia0utM4rqXA9yxatCfGhB1d17+UDiZKsrUWYn6geXOIgXT/YvyJqsUlgGrCQ7N7q2Z
         47ghG0hBbN1VmeNlR/jYu2XASysMzchajEyU+Hl74mIgUQJBfU0DCVp2434pX2UgJtZG
         GvPmCECmCn2/UE5iV+uFySy4tX5l90y/uJncFQVmpr9iUqyJRg4lIj7RwdU/LKVv9fpO
         aJSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TeKh2a6tL1O7r/BPYMAdDrJPmjZaEASKoGVN1mT54FY=;
        b=EZSefmXX/miX1c6kYMUhDSmRhoMDHj8laIgIlVNsxTPFIF609YPcnNX5C4cxFDenRg
         ISwNhik5pXUhtDby3okM1fYpJ8pPBWrJToQLdu85rtIV7OvozIq+H+gl69b1tPC1sJLs
         Yz3p5/Nq6WS8gyHGIQjVVPt5HMfVV6/vVp5YaBXj9+71bcMhjqgp7FcVTjo1QZKBlRvt
         iejVWyG/v3+YZ211wpRtlZ9nUYN8z7LlpgkYNQamXsxCg4s64dJCWV0j2TvH5DpAdbSt
         r9V/tDCqbKZCJ5egr7q/vjoRxHJ8XFip8v5jogK0DduQ+IJa1P+n+PUaxDO8kDpW/Ioe
         YhFg==
X-Gm-Message-State: AOAM532t5zZB20NATB9UnWqvUI9QxvJqbphGf+YbtFB8zlspJnr5IKOq
        QVoHgFiww3ztKjLYU78Q/r5I2cTUlo50LQ==
X-Google-Smtp-Source: ABdhPJzC8zLGiKAza0+Pil9J6F/8oeHzb0Vg28l9SdrHVd24F4wepPBaqmIdIbL63EfeBhkwAzmQZg==
X-Received: by 2002:aa7:d951:: with SMTP id l17mr27398121eds.92.1629553314997;
        Sat, 21 Aug 2021 06:41:54 -0700 (PDT)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com. [209.85.128.43])
        by smtp.gmail.com with ESMTPSA id g23sm4330016ejm.26.2021.08.21.06.41.53
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Aug 2021 06:41:53 -0700 (PDT)
Received: by mail-wm1-f43.google.com with SMTP id f13-20020a1c6a0d000000b002e6fd0b0b3fso9234566wmc.3
        for <netdev@vger.kernel.org>; Sat, 21 Aug 2021 06:41:53 -0700 (PDT)
X-Received: by 2002:a7b:c351:: with SMTP id l17mr8559189wmj.120.1629553313119;
 Sat, 21 Aug 2021 06:41:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210819100447.00201b26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210821071425.512834-1-chouhan.shreyansh630@gmail.com>
In-Reply-To: <20210821071425.512834-1-chouhan.shreyansh630@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 21 Aug 2021 09:41:14 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeWY-0+VtERqAxNwmHAwmarYh_HQUoF3b0wHiwAaL+h+A@mail.gmail.com>
Message-ID: <CA+FuTSeWY-0+VtERqAxNwmHAwmarYh_HQUoF3b0wHiwAaL+h+A@mail.gmail.com>
Subject: Re: [PATCH 1/2 net] ip_gre: add validation for csum_start
To:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pshelar@nicira.com,
        willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 21, 2021 at 3:14 AM Shreyansh Chouhan
<chouhan.shreyansh630@gmail.com> wrote:
>
> Validate csum_start in gre_handle_offloads before we call _gre_xmit so
> that we do not crash later when the csum_start value is used in the
> lco_csum function call.
>
> This patch deals with ipv4 code.
>
> Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> Reported-by: syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
> Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>
