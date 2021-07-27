Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D08A3D7F4C
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbhG0Udk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhG0Udj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:33:39 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B30C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:33:39 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id j21so265674ioo.6
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RjE/W6T/G1G3DE60Zpq30R6kBO27bGvIJy9HHGSW6YY=;
        b=Wn8R3QzT6y0RM/QZtPvHbNhXNkPWqUFHl/IcpfJ2YFFlAzx5o6P1m7BdgNpUQ68MwJ
         VH6S7FgNv9LvBi+vKkHRvIkJbKUZ6zvwPM62lJ/uaD+KqG7m37vSUtU/cXdX38HYKran
         h5CgK1edbXdqALvlIv8JAhNIXbVevomqme83Pdb4/Cyrhhlqyw8pEpHgKqCMbHsZKeQf
         94ExX3UPal6uTkBq8j2/HcDVunQY1vqkLliaP98EJYs7sY9S+AJZC0m3EBPwpVXTmbrw
         4O1TczLDDgcwOaTw568IXvUMy7GNgrnc5jcP+Gp9c3LlCcG+DmwQ/6rgA/ZpH5FFt0NU
         vRYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RjE/W6T/G1G3DE60Zpq30R6kBO27bGvIJy9HHGSW6YY=;
        b=ATbsjOWo8DUr5fVvgWCEiz7qoycsWxpYTeg/RlCTCXrldvNe8zc/U5qvzQRrgUTQX9
         UVUure0S9AzL+DnoRTj8bhKczDWCqkzaXr89QPkuqQDES770IWdGmCU5vJPaRsRMdgaY
         TPRWJSiX/4oMPVmVjMwsO/I88n8IMJ/pKzcgKWXjE3orC9ly0mcOU6FkyXE9Mzq+vrnZ
         Rq6m1uddP7fuplM469LgYZ2odD6X8zIM6crvAFSc5vIdaJ9ezzy6cVatOHjppAINYFpU
         tBIUREtYCPOJpS/I2m1IVMNuIZjC/00ZX3wCtC7EiafWfpCQ+E0zf3N1FU2CXLzYIZWE
         RdJQ==
X-Gm-Message-State: AOAM532JL0XY9lElhAk7ywDOKGPVfVUGTWUtQKxlkgeN1GQ8B/nFBB3s
        SqTfMyXGlN2x2/z94Iavr3cGJ2n0xFBRRRj978hq2A==
X-Google-Smtp-Source: ABdhPJzN6PDCaZS5qI2RCQNlVxbVKe1re3RQgcqiPkQpZkKOk/JWjPWZ/BwrwDv4ai3+mRCpLrBn7M7hLX3BXzFaOu4=
X-Received: by 2002:a5d:9ccb:: with SMTP id w11mr20491126iow.174.1627418018729;
 Tue, 27 Jul 2021 13:33:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-3-gerhard@engleder-embedded.com> <CAL_JsqLe0XScBgCJ+or=QdnnUGp36cyxr17BhKrirbkZ_nrxkA@mail.gmail.com>
 <CANr-f5wscRwY1zk4tu2qY_zguLf+8qNcEqp46GzpMka8d-qxjQ@mail.gmail.com> <CAL_JsqKq6H471iFoLWRGvNSLpaJmuF+feDFut2p+J725n3U4HA@mail.gmail.com>
In-Reply-To: <CAL_JsqKq6H471iFoLWRGvNSLpaJmuF+feDFut2p+J725n3U4HA@mail.gmail.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Tue, 27 Jul 2021 22:33:27 +0200
Message-ID: <CANr-f5ykgOHc1G2JQrTnMCFyQ35LbnWPH2pTKV07v-ucy_Zi1Q@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] dt-bindings: net: Add tsnep Ethernet controller
To:     Rob Herring <robh+dt@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 10:25 PM Rob Herring <robh+dt@kernel.org> wrote:
> > > tsnep is pretty generic. Only 1 version ever? Or differences are/will
> > > be discoverable by other means.
> >
> > Differences shall be detected by flags in the registers; e.g., a flag for
> > gate control support. Anyway a version may make sense. Can you
> > point to a good reference binding with versions? I did not find a
> > network controller binding with versions.
>
> Some of the SiFive IP blocks have versions. Version numbers are the
> exception though. Ideally they would correspond to some version of
> your FPGA image. I just don't want to see 'v1' because that sounds
> made up. The above string can mean 'v1' or whatever version you want.
> I'm fine if you just add some description here about feature flag
> registers.

I will do that.

Gerhard
