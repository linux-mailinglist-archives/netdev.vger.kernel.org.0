Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D9847A2A5
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 23:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbhLSW2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 17:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbhLSW2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 17:28:11 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9102C061574
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 14:28:11 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id x19-20020a9d7053000000b0055c8b39420bso10423724otj.1
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 14:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mkxg9YJ1VUNW9qmT9GYUdbencxbQaI8+vpGFuN857BE=;
        b=bsNXll/bHGaJggVfU58Ha1TTohE2PIjEpdMrII86qh4TlsbdLkj/vQ7lTGk72wXb0W
         QJquPXFBXtbqZ5KZP+26rtFXenlYEI8UNimMOH4B232aQ66ZXw9jApcKQHEbg/xexERD
         qCcAwNGKbXX8y4ZW3lNzR4FQPDCh2UcSDePK3gSPpTeOc/mv4l9T78Bc/Crdaf6P9Pnh
         aLo/tXH8cSEV+BxV3He5NeRBmBk0Mukyk3qJxKcmpFoBUXvaRuRU/D/DQtE425mwoGGP
         THNi94HdYdfCDQzTSuo+kRYmIKkmQpVI/zNW/FDSGA5MsczPqP9Ktrkl4Av0fczn4hRV
         Xf7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mkxg9YJ1VUNW9qmT9GYUdbencxbQaI8+vpGFuN857BE=;
        b=u+IewFOurpeQ5pD88GiJJKL4aA0NL1BDPDUqlL+/zgew6l8fUzvSsSWAQvfbr2mi1w
         dp/VbLpDaMTQhaEZiXBwuQZhGnw+AyWH6WkDGBjsi2+QtWhyVFY8Qt8/N48RQxoNTSOe
         HyU69MTNETQnVEoYLOmeCZUO84oMsB0TzuOOxmqgpDL6YngsSJH7Rh5sfOGradVMVeJy
         cYXqex8NrAApSiEwFlsANix/uNi0sdNEF/Mhmac5F8Ffhp8ZTzHEUYI+TDE+ZoAgSwOd
         AgYO8iDa/sAuzCzVHT4G4aiQLsSEcpiqNd9k+c76U/guMt7VWuvVDNDbBrjQgB7iuiqb
         Fgng==
X-Gm-Message-State: AOAM533LUdHLdBpO9msl5sIAb7Za0I8J9+GejO5CYK48X3l5CIUBJCNc
        Dxcs9bVpwvLkxVhFyQ0jTdgLXBX7ZGQSjEUNOxMOEQ==
X-Google-Smtp-Source: ABdhPJypl0HuzptDxHHG0QPFV2dC/Q6Gvt2OImya+q5KQOGs1CjR14HO7XX62QLys+g7bLa0Fj7vJGBSFfBYZ1ZkmSQ=
X-Received: by 2002:a9d:74d0:: with SMTP id a16mr9115873otl.237.1639952890935;
 Sun, 19 Dec 2021 14:28:10 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-2-luizluca@gmail.com>
 <CACRpkdaWY=YMHgbpuvghCMaYk1Fa9_PLdUknmTHyHh7vb1kSjQ@mail.gmail.com> <CAJq09z4e=9-A8bz-pE45izAXb9kXttN9RGg1HBxFb9p7wyF4Kg@mail.gmail.com>
In-Reply-To: <CAJq09z4e=9-A8bz-pE45izAXb9kXttN9RGg1HBxFb9p7wyF4Kg@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 19 Dec 2021 23:27:59 +0100
Message-ID: <CACRpkdYxrKnbPAbA9dY4e7pe4dEPNBNCKw2TO6w0UgCOi4UZjA@mail.gmail.com>
Subject: Re: [PATCH net-next 01/13] dt-bindings: net: dsa: realtek-smi: remove
 unsupported switches
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        vivien.didelot@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        olteanv@gmail.com,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 18, 2021 at 7:12 AM Luiz Angelo Daros de Luca
<luizluca@gmail.com> wrote:

> However, it also gives the users a false expectative that it is
> supported (it has happened to me a couple of times). I would not like
> to simply drop this. How about adding a "(not supported)" comment.
> Would it be acceptable?

I don't see why users would get that idea. If they do not know
the difference between device tree bindings and operating system
implementations, I don't know how to fix that. Probably they simply
have to ask and get the answer like with any other technical
detail.

Yours,
Linus Walleij
