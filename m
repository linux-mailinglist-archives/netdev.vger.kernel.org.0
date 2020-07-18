Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50018224CC4
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 17:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgGRP6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 11:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgGRP6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 11:58:49 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72DBC0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 08:58:48 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id di5so5574707qvb.11
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 08:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Plzvh6H4Hj4vOwuOygDMUlL5YJQ5p6zhFN1IKlQxzyU=;
        b=ifh1Ra8dpMd3QeCqbe0IeHUsUr+GMcVoPiANc+Cl0oz2CHrfUsRokRmGmQ2kfW39Jb
         9jw3Q/Wv8BRh86YqbJyd5r99MRYJNQSGSe9XMrdmsfgydbSyicsEV74ipNbcfM99Gh1T
         xHIdhn7KcErvRd3a+H//yxuCrb3bDh+lDTvfb96m/TKpjSO4m/qrMV87pQbF0OdLkgIv
         calxHyi8+AlbGE4wiW3fMxNR8S2OQzr0W30u2ksvEh539k515LDNEGJGhO4yKb+GF9ua
         Ee0XKlu12o1XOLIYfWpMOqJF6Hghk7H6PsOWc4Ox4uhciYW1v5nG29dn6I1bLigoKBeB
         GyBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Plzvh6H4Hj4vOwuOygDMUlL5YJQ5p6zhFN1IKlQxzyU=;
        b=n1aRcEs6xJeeyYjTG9eoLnyed+/NZXt/4gp6XjY7ADBTNbRepYnWTexG+OyuTvLTQd
         96uiyoTX/BN3+xvDHiaKD+Dco35XeO0cd6ZE8az2f6ha0mmY78DvuaplCVXU31Qu0zV9
         CCqW2Zwvcf7JTYZHW5guJaauCAQSUUacjT3sQhq5UIpRO4sO2XgQda6I4f92l4gCCeGv
         LlzfXLKiH+Uy/asMaeWoTmCSz75WZHypChSBy7ga5drXyNYYfWYOIpTkXCm/eZY3oM1R
         Ebntm5zfeJJ+909+5NwG9Agd0Y02AP/B4nzInfhK32EIbYK5vPmQ3oiFTV+H2vWoP0go
         BUKA==
X-Gm-Message-State: AOAM532EFxh2+sW33Tb27XeZmIRWUQXfke2ZUS6OKHLpvnl953u+ZEa2
        h77QlFBn30VrSWo2KmxUJj6BLxN0
X-Google-Smtp-Source: ABdhPJyrZtEWsgu6Ao+VIuDkegtqgY5uSkMM9PkKinaW8dd7t/7DGPAvovBEKbKKazT1r20doKDufg==
X-Received: by 2002:ad4:5483:: with SMTP id q3mr13449551qvy.99.1595087927599;
        Sat, 18 Jul 2020 08:58:47 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id f18sm15271573qtc.28.2020.07.18.08.58.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 08:58:46 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id 2so6032535ybr.13
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 08:58:45 -0700 (PDT)
X-Received: by 2002:a25:cc4e:: with SMTP id l75mr22783187ybf.165.1595087925354;
 Sat, 18 Jul 2020 08:58:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200718091732.8761-1-srirakr2@cisco.com>
In-Reply-To: <20200718091732.8761-1-srirakr2@cisco.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 18 Jul 2020 11:58:09 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdfvctFD3AVMHzQV9efQERcKVE1TcYVD_T84eSgq9x4OA@mail.gmail.com>
Message-ID: <CA+FuTSdfvctFD3AVMHzQV9efQERcKVE1TcYVD_T84eSgq9x4OA@mail.gmail.com>
Subject: Re: [PATCH v2] AF_PACKET doesnt strip VLAN information
To:     Sriram Krishnan <srirakr2@cisco.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        xe-linux-external@cisco.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 5:25 AM Sriram Krishnan <srirakr2@cisco.com> wrote:
>
> When an application sends with AF_PACKET and places a vlan header on
> the raw packet; then the AF_PACKET needs to move the tag into the skb
> so that it gets processed normally through the rest of the transmit
> path.
>
> This is particularly a problem on Hyper-V where the host only allows
> vlan in the offload info.

Shouldn't this be resolved in that driver, then?

Packet sockets are not the only way to introduce packets in the
kernel. Tuntap would be another.
