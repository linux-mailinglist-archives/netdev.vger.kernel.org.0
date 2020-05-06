Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAD91C7946
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 20:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgEFSVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 14:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729313AbgEFSVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 14:21:13 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DFBC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 11:21:12 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id e20so2149387otk.12
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 11:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D2taJJRTg2UNCEqvPUHeisc7wYhhWEOMV6TUWaPz7kg=;
        b=JaXZicmLPCbQ1s4wEPLd+sV+a4q0wnzPoifqdGpBSL8D7Z8GrydmvQGqC8UT22nL2I
         WZa/znMpgXW+q41TZVo9zK6nCks5GJUhUduUAyuXBbeNVH+4lSu2c8TsdwQTipW46XE8
         2YvlAWllyGrBAxfyw+wCC3p4SEMWY6eYou+Co=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D2taJJRTg2UNCEqvPUHeisc7wYhhWEOMV6TUWaPz7kg=;
        b=kqmgPdey2GC1iOau97nF6rqmEoi/7tbmZInVuDDxdyOgEh8yedgcGJUz5qzZszV8+X
         KxTol8BNK7P0MUOw1kjcyAMBIJNjLbmYzO7dkCrxJ5jzr3Y8RLqP5w0YkbrqMsd4yhbE
         +6+9ETjyndsh5ruL5Ff5KAmDlQ8pSxM0rYS4tGNh/CA+ninM+ML1EumJnzlJ/s3RpGtz
         YZsaJKqrTQTB7/1eCQUelDzMmhPZ+hlhq6py3Q5+gphULzjBPdbM9dFm3LT5lcVJt6dG
         9j7vjPhTeX9P08oTu3nAi40Rh5kkfKtEIiaBs+PlaNZCxUr3wPdNuRb/cbH0lxIuBUYd
         l7TQ==
X-Gm-Message-State: AGi0Pua2uRV0IMaAEhpkt0onpVjPkI8RXbDmpCBbEJKMHnYNBOrx123I
        K65ZFdBmwJ5AwlPOC+kp6Y/ZkXtfkOyrBH3mefMv3Q==
X-Google-Smtp-Source: APiQypInw39ygS3P/++U3PAE3LlMt925jYmNYdu8cvU7nnL+hmn3yH1R3d09MJ5VoLDPJl2XHnEM/8wYsJ8wMTKfCVI=
X-Received: by 2002:a9d:490d:: with SMTP id e13mr7509661otf.356.1588789271980;
 Wed, 06 May 2020 11:21:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200505140231.16600-1-brgl@bgdev.pl> <20200505140231.16600-6-brgl@bgdev.pl>
 <CAKOOJTzcNr7mc9xusQm3nCzkq5P=ha-si3fizeEL2_KJUOC3-Q@mail.gmail.com> <CAMRc=Md7gLMThfGF-7YLqW17MpMhU=UFbdTvfjbr9fFHTLir8g@mail.gmail.com>
In-Reply-To: <CAMRc=Md7gLMThfGF-7YLqW17MpMhU=UFbdTvfjbr9fFHTLir8g@mail.gmail.com>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Wed, 6 May 2020 11:20:35 -0700
Message-ID: <CAKOOJTxkcaq0bF34bcz3HZzqsNgfmJH=Hd+odNNMX5gDq4to=w@mail.gmail.com>
Subject: Re: [PATCH 05/11] net: core: provide devm_register_netdev()
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 11:46 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:

> Re the last bit in priv_flags: is this really a problem though? It's
> not like struct net_device must remain stable - e.g. we can make
> priv_flags a bitmap.

Fair enough.

Regards,
Edwin Peer
