Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8AA23D54E
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 04:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgHFCRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 22:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgHFCRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 22:17:46 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EAEC061574;
        Wed,  5 Aug 2020 19:17:46 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id p1so26725066pls.4;
        Wed, 05 Aug 2020 19:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bmUoQ8Yqb0yCc2UJLmctj9moyzTmkngEF1wnWxeUUjA=;
        b=Cpvi4D/HtWhUNAkkFFsAKMwGC/2Q+wMWFRYrgaI6B061eOtykDHlpDG6G7di55PNst
         Fqhj/Lw8iC4XU5E3oEoGNH9X4hXLyRuyodr/GJUZaUpwnTsaVcfH/Wzr2Dmoo/C9uido
         IjNpl20aFv6EysjFvzWA9rndSNsJahH0rH//8mGP8o4yYEfnREYwM4Jc60BOPhBupMu+
         MMICF3QBzMWThYWEw7KASsJPs8B1s/1/2aJi8GZ2DJThVLHwdiry7WYAJX2hMTMxCAVo
         ABbGjVD2MqkV5eLkK5bvQbvBtsgJmA1RyF2TAIqQg1P/n1U58YV8DdPUlOBV1hK5UkKe
         n6cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bmUoQ8Yqb0yCc2UJLmctj9moyzTmkngEF1wnWxeUUjA=;
        b=VOUIXeoIfD9yJVq3VwHh5jscwB/R8y3S4BxKvVrQiese74jJWGJgAQW7KsD/T10nXq
         aZCSsYUYED/hTMriMBalRK3Qo5od+1CooWjgLqezzguATdtZqXzd4ZBNy2nErc2wn0gq
         4ZmadcPOYepekefgYLY0iFLWdhRuve8kTR1TZP3qfS892/pkjxqI3IFOlvrwJ9a2QEFN
         JBsfT0ta2cBmftxCaNntvLZwpV1/0HCcCiI4Hq+U3kmzjN3aG1UJv3BK0hzwbZhUl2gh
         70c1FkP3r1AQv6RDXjws9IGBGqSUyV5bFb8KUwuFITnfxvb1C4efaTsDioqVMFxGxVwR
         Riaw==
X-Gm-Message-State: AOAM531HnTtg4TYfDdTC3ebmjXrzJHjhDZESs7HgHnuC3MDWrsFo/NGg
        TbEy+GkIp0U+r3jn7Tn5aKU0Q319P79YL9BmRKU=
X-Google-Smtp-Source: ABdhPJzibthz3FojelP1SXthc6kN281mI/ZPAKJFAEO1TG0OwusOyZDWU4TyJnO2ndjCz3KgYCpPufmBlUFvmzJWhhQ=
X-Received: by 2002:a17:902:9b8f:: with SMTP id y15mr5984598plp.322.1596680265011;
 Wed, 05 Aug 2020 19:17:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200806015040.98379-1-xie.he.0141@gmail.com>
In-Reply-To: <20200806015040.98379-1-xie.he.0141@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 5 Aug 2020 19:17:34 -0700
Message-ID: <CAJht_ENdnD5u2Qbi+fMVTw+GUrYS77=dHRES1s3F+mjvttYnVA@mail.gmail.com>
Subject: Re: [PATCH] drivers/net/wan/lapbether: Added needed_headroom and a
 skb->len check
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Brian Norris <briannorris@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm sorry I forgot to include the "net" prefix again. I remembered
"PATCH" but not "net" this time. I'll try to remember both next time.
If requested I can resend the patch with the correct prefix. Sorry.
