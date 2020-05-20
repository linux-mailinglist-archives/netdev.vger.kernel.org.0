Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8BE1DC0BB
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 22:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgETU7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 16:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbgETU7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 16:59:38 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C621BC061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 13:59:37 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id u15so5548954ljd.3
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 13:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e/Xdk+2Qjc16LzOVa9lnuQqAqYFbaHhJYfbPjyOMWM0=;
        b=jAMH1927IOAoBJgvE2Gbj2cFEfC8mJsV3BVmnk97PIGu2VwPko5fwcFleC8sU0XF/G
         ITqIoW9YRkeABtk+sSwOOTV+vC5TF+URq5GRPfWFvNrh9ZDc41Ack3poVNcJGSL2iOnv
         ExgXaWUZCNd7yo8NhRoyf0iALymd6I61WzQ9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e/Xdk+2Qjc16LzOVa9lnuQqAqYFbaHhJYfbPjyOMWM0=;
        b=E86wxRshT5yhdA+mMBPOvU7SJKfRupbkNQdkIyvMQXzYeWW3hi8s2HvEXDTm9ERk9y
         BO/NRR2mo1GAUAgJy0CsONFqiFLMygF7IZygqlwWqwQhwdMnpqQVOhyWl8gT+t3xOI9q
         vC+b/hve2ul1cKsDasNZ24a89mW2Yw54o4fb2joben+CE5xjFrDNM9D70ACnoi1nAj1a
         Xtqp0IxORNemCZbMROSwObofIiOxs+JRahr41utgQMwPEZenKGYXk4nP75OTTOC1Ahqy
         4v84dJkLXdUjNBtZyRxqtjyQuSb2dtoFJpQoTMTUBqe1aUKKFrNxp9wR1Te4Zznc5P4+
         Jadg==
X-Gm-Message-State: AOAM5338ZRz7TdydIRGVv50mS6OovgkjcjHdO19DqM+rfsdnGZ9kyogn
        veC+2Qn8b/oLNvC26PDvE+OEfOT2V44=
X-Google-Smtp-Source: ABdhPJwdfxwJPbhamhE+ZsaG1cgCwrO+LrwXvTpI+PsvgsUQOX/I61C8C2jou9Whzidh+CB1LvQ6Tw==
X-Received: by 2002:a05:651c:153:: with SMTP id c19mr1533294ljd.429.1590008375391;
        Wed, 20 May 2020 13:59:35 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id t15sm1318912lfg.57.2020.05.20.13.59.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 13:59:34 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id u15so5548751ljd.3
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 13:59:32 -0700 (PDT)
X-Received: by 2002:a05:651c:3c6:: with SMTP id f6mr3496652ljp.138.1590008372306;
 Wed, 20 May 2020 13:59:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190906185931.19288-1-navid.emamdoost@gmail.com>
 <CA+ASDXMnp-GTkrT7B5O+dtopJUmGBay=Tn=-nf1LW1MtaVOr+w@mail.gmail.com>
 <878shwtiw3.fsf@kamboji.qca.qualcomm.com> <CA+ASDXOgechejxzN4-xPcuTW-Ra7z9Z6EeiQ4wMrEowZc-p+uA@mail.gmail.com>
In-Reply-To: <CA+ASDXOgechejxzN4-xPcuTW-Ra7z9Z6EeiQ4wMrEowZc-p+uA@mail.gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 20 May 2020 13:59:20 -0700
X-Gmail-Original-Message-ID: <CA+ASDXM6w-t85hZWcbTqTBA8aye0oka3Nw5YYZH2LqixO-PJzg@mail.gmail.com>
Message-ID: <CA+ASDXM6w-t85hZWcbTqTBA8aye0oka3Nw5YYZH2LqixO-PJzg@mail.gmail.com>
Subject: Re: [PATCH] ath9k: release allocated buffer if timed out
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 12:02 PM Brian Norris <briannorris@chromium.org> wrote:
>
> On Wed, May 13, 2020 at 12:05 AM Kalle Valo <kvalo@codeaurora.org> wrote:
> > Actually it's already reverted in -next, nobody just realised that it's
> > a regression from commit 728c1e2a05e4:
> >
> > ced21a4c726b ath9k: Fix use-after-free Read in htc_connect_service
>
> Nice.
>
> > v5.8-rc1 should be the first release having the fix.
>
> So I guess we have to wait until 5.8-rc1 (when this lands in mainline)
> to send this manually to stable@vger.kernel.org?

For the record, there are more reports of this, if I'm reading them right:

https://bugzilla.kernel.org/show_bug.cgi?id=207797
