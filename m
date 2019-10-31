Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA16EBA49
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfJaXSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:18:00 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33296 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfJaXSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 19:18:00 -0400
Received: by mail-lf1-f68.google.com with SMTP id y127so5970473lfc.0
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 16:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NibWiHSAeXAM/Iwxngz50i61VNw/YqR3wLT5Y7DYmYg=;
        b=phSv4YvHNt9TamGa3qCiffTMt3zSeOmece1Bbt9+j6yUNxkmaaSQZcjVUzjiDxOuZi
         yZaRbFiGpfL+0LSP3kKHT49SI1gGJQ2pboux+N32KJsuoJJr6vE3vbyoxyYLUDK7DQKv
         JJopHw6VX2AJIlZHciamu53J+X7BfsVtdgHPFSKdU1AIF7KhFB+8GsmzqrE2UAyb+kGW
         NvRFpVc05ZAov7YBa0cbjARtvHNX/yAUrP9GNNXOEDU8jl2NN2Ay5sPQd+VqtVyvW0yF
         KkbYjfCrz4/+FU3j0cvvCL5rC+fEtq92rOhdZAzKY60PUpAhIzJ0/gTaycKoN2pmjUn/
         3SGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NibWiHSAeXAM/Iwxngz50i61VNw/YqR3wLT5Y7DYmYg=;
        b=HnlG25JIYEy0KrmvfZIsnQ/KXB0Yis/evu2L+j30ZERMkLZkYj4mhfk4V6/lo2X9og
         TqJhvudUaDem57lRm5xfiSoLeNCHpXu3/e76TVsbXWTcziRn7ZRt9jMRJ5u95MmElG/A
         vK6TxTw98VdpDHQOaDC2C2+w3ZFHQ6joQ0+qPZPnW/Ye6+AqiCEzLTrpuq/+F9mS9z5j
         VUE7F0TqKfErkzTUhgSYt0YfkkB9qqvzMu1vpQtWBcKF8jxXnY68+8UzpABunEze8E5u
         1Jr2tgn3yClbxq0ZxALcNDkbZ1w7gf7aEigOQClI8NVUYkGwYD0TeAH2fdqM9DRdbMUx
         C+/w==
X-Gm-Message-State: APjAAAUc15jtvldmZQgZD7b3uSXpor+M5u5BuFiCiok4NccCsHJqpRMt
        v4QNIGR5D0u42QYuE4VLcpKimIo/mJ6z4/4PVOIuAw==
X-Google-Smtp-Source: APXvYqyz1aXvDdXWGyKsynhgjuqUPKoM/QcpCEEobAYYLmtrEVyrfmcy3LRQOdv7WCb1jNZd4ekRJ4MHzJWJHqbTAL8=
X-Received: by 2002:a19:651b:: with SMTP id z27mr5130005lfb.117.1572563878197;
 Thu, 31 Oct 2019 16:17:58 -0700 (PDT)
MIME-Version: 1.0
References: <20191021000824.531-1-linus.walleij@linaro.org>
 <20191021000824.531-10-linus.walleij@linaro.org> <CAK8P3a1qbJC+nFZD0ZKDqWE6ORbEEZbO_Y+MZBS--ym_VQ6fXQ@mail.gmail.com>
In-Reply-To: <CAK8P3a1qbJC+nFZD0ZKDqWE6ORbEEZbO_Y+MZBS--ym_VQ6fXQ@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 1 Nov 2019 00:17:46 +0100
Message-ID: <CACRpkdYTL44zkP-2kSLvWkGunL8sRT_XXVRj2LgLd6GKc=Z0zg@mail.gmail.com>
Subject: Re: [PATCH 09/10] net: ethernet: ixp4xx: Get port ID from base address
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 12:30 PM Arnd Bergmann <arnd@arndb.de> wrote:
> On Mon, Oct 21, 2019 at 2:10 AM Linus Walleij <linus.walleij@linaro.org> wrote:
> >
> > The port->id was picked from the platform device .id field,
> > but this is not supposed to be used for passing around
> > random numbers in hardware. Identify the port ID number
> > from the base address instead.
> >
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> I'm not sure this is better, as now the driver hardcodes the physical
> address, and the port->id value is still the same as the pdev->id
> value that all boards still pass.
>
> Is this just meant to avoid setting the port id explicitly in DT?

Yes, because the DT bindings people would not like us to encode
that in DT, as it is a Linuxism.

To DT these are just three networking engines (NPEs) that the
OS can choose to use however it likes.

That they behave differently and that the driver has to cope
with that is due to different firmware being loaded into the
different NPE:s. DT doesn't care about that.

I will mention it in the commit message.

Yours,
Linus Walleij
