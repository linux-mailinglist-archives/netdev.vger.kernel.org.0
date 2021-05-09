Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415493778EB
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 23:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhEIVzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 17:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhEIVzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 17:55:18 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D78FC061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 14:54:13 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id s20so16067496ejr.9
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 14:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BUKgrm0iW6aeFKwl3oW3H+VZ1RqWnbBKe4voE1NkxW0=;
        b=CdYbZjnbfLDUA3eTM1F3Mg8LBHzXaYn+d1cl9nFdBWaRmCcHBYtioercbwgS8Pxn/G
         w4Ruf8PcCrvR3rN7017nceyoAZKIJoRl6iYQfIwemW1Xpxe3uqr+st63w/2yEykcGbKO
         vs4D9FC7Dw2nLZm+NM8VHqdlNwvus4Sh7kZRUb5E+KUGqorR/2yblaiIRadAiX3EYFV1
         GloNdXXvCtfefM6zzhEtdrxwXYd2t7Bvd8zHSX/M5obZsD4XSpHbIoESNORicNe9Bx2P
         xR0pXuUrbns7TQ7HRuGIYQhaTVoyeCOzzBhJk4TN9aG6Slp3HZD5wVwT0myzHpr3sBwE
         jLRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BUKgrm0iW6aeFKwl3oW3H+VZ1RqWnbBKe4voE1NkxW0=;
        b=OzIiqfP2Wk9rfkwP6mtPrknLopehavhKGmVtatGJ7abHNuBORwXaj/17/xXHEFgeRY
         6fConBqN/pj2meQnd7BxngCBweieSmY2cjS1Am8jK74TuUwxbzCrsmxYu1cFiizFzU9Q
         OSdIlDbrfbJ26lr0J+KTJWr6oeyCITvZYCQZkmVmBdvw9eyf+mtK85IS8Ey5YAeoWroR
         N2Bf2mIBbRYcL76EKyFmaW7SYawopQZctSAjA8aU8J5M6NQwBophy4e0LgLaj20iwKhc
         zbrVx5A5hLh3dQ2qPEF+7dRHM1vAgBDIl/ZbiEenY/M08bY104Jw6wSVVI6YR8WGDbUg
         S2Ow==
X-Gm-Message-State: AOAM532Flh3PafDJH2IepUVexswa1B1g68q7F3IvGfF1imuff5m1vxU2
        EFrC9DqdTVqRT0hShbdQHOezpMfYNJvWKEnyQ2M=
X-Google-Smtp-Source: ABdhPJzv/j2xP8mvBWSli5bZjLCEYkoT8lBD9GlSxuJRMAZrcYHKMqBJJoyrqOU4TnI7rbrn8Skuu14H3VEr/EuyYrY=
X-Received: by 2002:a17:906:9a02:: with SMTP id ai2mr22752461ejc.279.1620597252167;
 Sun, 09 May 2021 14:54:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210509115513.4121549-1-olteanv@gmail.com> <53834b37-16c5-2d1d-ab72-78f699603dca@gmail.com>
In-Reply-To: <53834b37-16c5-2d1d-ab72-78f699603dca@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 10 May 2021 00:54:01 +0300
Message-ID: <CA+h21hoKocOhidF_wNaQhOgiq_KqMsi4LJisdPTkEiWo3x4ZDA@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: fix error code getting shifted with 4 in dsa_slave_get_sset_count
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 09, 2021 at 10:35:27AM -0700, Florian Fainelli wrote:
> On 5/9/2021 4:55 AM, Vladimir Oltean wrote:
> I would have a preference for keeping the count variable and treating it
> specifically in case it is negative.

Thanks. I hope I've understood you correctly that renaming "err" back to
"count" was all that you were asking for. Anyway, patch is superseded by
https://patchwork.kernel.org/project/netdevbpf/patch/20210509193338.451174-1-olteanv@gmail.com/
