Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FBF475A64
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 15:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237565AbhLOOQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 09:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhLOOQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 09:16:13 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851E8C061574;
        Wed, 15 Dec 2021 06:16:13 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id i6so41174586uae.6;
        Wed, 15 Dec 2021 06:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CzbcpPsGeUu7cJzf3YmL97esTyegl1WilzwunHBlsJ0=;
        b=jQ3z1cfZEizwMVs6X9FHIKAYSCLQEZfG9jBGu6U5eoX9t3cxn2eK22elO0OTZJN69h
         Hn+F8vkLmwBfB578y8gVSXOPSRPG+UHZf9bm2KmLLJDjbOh5AIV7parjNUiHpJxrM0iW
         p5T5FK4MMFw+ERF7e0E4+igdewZbUJ9F3hzyLUfPPEOFYLFzA3ug1JiDR9PL7ZcNIvK6
         p4PtXl1+yP3AgMaBp+WhABR5xmamvD7qNuBwUz3mqPxrY17i33Jk7SkKYqf1pe004f1X
         rnTY65EfiluoKF3GNdURKFgUXlXNaiv9lK09YfKDKw1pS1Pls+r2sR2A+jVbdTByOurc
         971g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CzbcpPsGeUu7cJzf3YmL97esTyegl1WilzwunHBlsJ0=;
        b=egm9gEHBNDrvRs0/x3QVfv8J4zq9z9nP6AG1hkVUMInasgjBb8iJ54eez2/NBr9HTQ
         J5DPZGOMx6nBguIF/w+Wt7iMqRN8z7F8bM0m2utegOYOxgaivJg/iRX52xAcUg844xqi
         Va7+fOJpXzbm+osFGkaDXLRvX+78bbbn6ajZK1OZmXY2rBManrJunrdvsIQseE9j+vxl
         2lU2siEFp/DAaFpX3kscOTn8CPdTtUPraxhSaYiLmSzSuiy/K6PBUcuBs3OeH3tAmYGQ
         2SzTb56U2cEpdPvMiLmSha3HjIw0wE/dsr1nG8NX6kRb3zIhpMTwJBw5hqtoDTEIA9pX
         +Y6A==
X-Gm-Message-State: AOAM531t0nmigMmVdT4ehlx6HzlhxtcJkfDwB7FwewfIYa06oUzDK8GT
        d4xbqpEkIIVU/Qu/5GB8Ao3FYpejhIkZGeCB3NI=
X-Google-Smtp-Source: ABdhPJxdL2tTTGHJqdrnbuJO9P7hgjMkVQp/qQTD2TuSHHUNy6I1A/PqvwNkyLn7WxuKlm+/IoK/o+YjeolRNyYzGJM=
X-Received: by 2002:a67:d893:: with SMTP id f19mr2833967vsj.39.1639577772711;
 Wed, 15 Dec 2021 06:16:12 -0800 (PST)
MIME-Version: 1.0
References: <20211208040414.151960-1-xiayu.zhang@mediatek.com>
 <CAHNKnsRZpYsiWORgAejYwQqP5P=PSt-V7_i73G1yfh-UR2zFjw@mail.gmail.com>
 <6f4ae1d8b1b53cf998eaa14260d93fd3f4c8d5ad.camel@mediatek.com>
 <CAHNKnsQ6qLcUTiTiPEAp+rmoVtrGOjoY98nQFsrwSWUu-v7wYQ@mail.gmail.com> <76bc0c0174edc3a0c89bb880a237c844d44ac46b.camel@mediatek.com>
In-Reply-To: <76bc0c0174edc3a0c89bb880a237c844d44ac46b.camel@mediatek.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 15 Dec 2021 17:16:01 +0300
Message-ID: <CAHNKnsTWkiaKPmOghn_ztLDOcTbci8w4wkWhQ_EZPMNu0dRy3Q@mail.gmail.com>
Subject: Re: [PATCH] Add Multiple TX/RX Queues Support for WWAN Network Device
To:     Xiayu Zhang <xiayu.zhang@mediatek.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        =?UTF-8?B?Wmhhb3BpbmcgU2h1ICjoiJLlj6zlubMp?= 
        <Zhaoping.Shu@mediatek.com>,
        =?UTF-8?B?SFcgSGUgKOS9leS8nyk=?= <HW.He@mediatek.com>,
        srv_heupstream <srv_heupstream@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 11:44 AM Xiayu Zhang <xiayu.zhang@mediatek.com> wrote:
> I want to know whether it is acceptable to add new callback functions
> into WWAN subsystem only as well. Hope anyone could help confirm.

Yes. Feel free to add any callbacks to the WWAN subsystem for proper
hardware support.

There are two things that trigger the discussion:
1) absence of users of the new API;
2) an attempt to silently correct a user choice instead of explicit
rejection of a wrong value.

-- 
Sergey
