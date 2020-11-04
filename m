Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6631A2A7099
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732475AbgKDWfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgKDWfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 17:35:32 -0500
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AA9C0613CF;
        Wed,  4 Nov 2020 14:35:31 -0800 (PST)
Received: by mail-vs1-xe41.google.com with SMTP id y78so12404073vsy.6;
        Wed, 04 Nov 2020 14:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ILAJ49z6tQ1g3I7M50igRvFR+RDZOmpMIx5R1kAjjF4=;
        b=APaaW8d6bvKzzzHeY5G0dybIu/V/nduXVyg4f65X8mW3LRqAITHK+wbk/jpRST+0ZN
         1vmwM+a/pomQMv1E7txLNLQw3Ri/cX1Sivs2Uhh5u5rv3LqZC2s/0l5+93BZ434oInFz
         JT+5EGYA3oxX3ERF+2pmc2KxQeUqKhNp/vrP3bwRbBdIE1qUt1kMx60f7jBJC04fseOM
         2y5WV3SmbTYFRxK2B+WYZVlGCaKH6v1lYrXEElFOuuIe+/F2LJfxr5lrHSZlWkgYwUwL
         yAuF7BltylYaqHqhL7AdzYP8vnbvCdCbShucch7nXVWNl0Bx+9PYvG55N3qAKOoQPl17
         Z9yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ILAJ49z6tQ1g3I7M50igRvFR+RDZOmpMIx5R1kAjjF4=;
        b=QrKjibmNqBnmjh8Ywh9IPAvvx3z4TEwYT9ZmtWU2GOliM8ZYWRxQn0YNIii7b4kK/0
         sSI1+t55OQeMFe2zBYPzPu+3lfwV3hvLS34x7tzc2sihjhDCjD9mbg2NEO1N6kDMURT6
         Bvd61eKY/e80PrnitW8PNHzKPC5zi3IngBV2Iw9S/JJ4D3xPz7SBPv/NbbD1wFKPypcq
         H4l8Vj6herp8SSsH3nl1wHsc9xsXponwjeWWZDJtHNgjnqSufV82SdBhoDKG8CDmnLPq
         fxvXEUc9ioOaW7VVA/Kk/pXMud4vYaCQNncYks6Ub0kyhXy/zMuWD2MB11geUsFfnEWc
         kedQ==
X-Gm-Message-State: AOAM531otMd18WYHau17oERMB/xBpQH7NqN7leA8WMEHw+R0g6u77ASf
        a85cBXJE4ObpHrWrQ+6Nsr8GcZxPJafJTP2P8Do=
X-Google-Smtp-Source: ABdhPJxQ7/Oo3fg0x6W5H4/oqbIwIHF3XJaVD/OmtahiucyhhM3CMoHLxC0LtLuW5NkYTKrmqoAsrkIcAuYrsNkU7kY=
X-Received: by 2002:a67:ff10:: with SMTP id v16mr84062vsp.40.1604529331083;
 Wed, 04 Nov 2020 14:35:31 -0800 (PST)
MIME-Version: 1.0
References: <20201104160847.30049-1-TheSven73@gmail.com> <20201104135827.0140aca9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201104135827.0140aca9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 4 Nov 2020 17:35:19 -0500
Message-ID: <CAGngYiUPJQHMO5PvXKqV68MrzVCMCATQDxeQ3Vi+OGOQ2onj2Q@mail.gmail.com>
Subject: Re: [PATCH v1] lan743x: correctly handle chips with internal PHY
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Roelof Berg <rberg@berg-solutions.de>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Wed, Nov 4, 2020 at 4:58 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Not a big deal but if you have to change the patch could you make sure
> your email address is spelled the same in the From line and other tags?

Absolutely, thanks for letting me know about those case differences.
