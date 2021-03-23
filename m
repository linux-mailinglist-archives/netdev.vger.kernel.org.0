Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C77E3459DF
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 09:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCWIgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 04:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhCWIgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 04:36:36 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715FAC061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 01:36:35 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x21so22451304eds.4
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 01:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=f/MW/BemQ7oviNUfk5rw4aPJnsP1RW/2LEki39GacAs=;
        b=fZcQmN4fiRh9DYTGxVh5vDvBACbVQQ5MSRBYb9xRO++y050pr6MI8DjQzDhrRT+Nlo
         4x34B5H0SlRuD7RgdHqxAHFbnw1hbDX5ORMpbH7q7HXsFrt6Cd7mnjSzQY60lBscgNaE
         TJhLnc4Cf92bKNKIqJIfHvVxfapYGP+Q84hT/U6UMiHWju+UEoQ+FwCQbmRZnh2KQtd6
         AERLKok/Ajs6uTvJJUk8/ptVm+4H2/vhpgkjuhqA7ceDqHSOVZAx3AsexbXKB9mF8/z+
         hDX+4BSjpaCRzk42KeFVaOtCLU/kPFQOPz+i/ggEvAPxz+NOZaXx9fmL7GPIbQQ8Vabr
         fUOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=f/MW/BemQ7oviNUfk5rw4aPJnsP1RW/2LEki39GacAs=;
        b=sHC7rLlpJ73XsIgnmizGbb/W/QOrDumJeyTzJxyb6/MC3Mp2wIOABIuB4/RYtUMdAN
         IetmyM9qerN2mtfSsSiwjntn9bEKxmn2mKIA4xbrFclpAX7RugI5nsCsqNjR1fhdo2bX
         SzbsFj+jzNPrTpVV8XG8V7FVMgObajKh02fFYnuh0GRKneu/fBP9GJalLtV4ouZYhVEq
         Flijp/dPxTvODRcOGtZi9LVaauD/qaif7ymNtNjJS4ldYdtXrl/SAL5Yk/+cF0FIAcKj
         AH3Z25DxWe/4o6pPcxdWjbF5JvUIr+78MBxt7/iiyUo/zIiAwk30x05Vinoh+AenPtMm
         mdeQ==
X-Gm-Message-State: AOAM531c9SM+xvs8bQhHIce6mdaUHkSLQiKmibemn2TGYpJuASJK8Vdj
        P+Bd7Lo36T0IKq+UZPWpXE5SVw==
X-Google-Smtp-Source: ABdhPJy0VDsYYV6quQqQy47nXqKIcFzgIaUTMhBb+JTD5y8MEuu0ls0eRqKZFg2j5m7GAeMn3o4Vyg==
X-Received: by 2002:a05:6402:d4:: with SMTP id i20mr3509321edu.147.1616488594058;
        Tue, 23 Mar 2021 01:36:34 -0700 (PDT)
Received: from dell ([91.110.221.180])
        by smtp.gmail.com with ESMTPSA id u16sm12990701edq.4.2021.03.23.01.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 01:36:33 -0700 (PDT)
Date:   Tue, 23 Mar 2021 08:36:31 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Anton Vorontsov <anton@enomsg.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colin Cross <ccross@android.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Kees Cook <keescook@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        netdev <netdev@vger.kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Russell King <linux@armlinux.org.uk>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v2 00/10] Rid W=1 warnings from OF
Message-ID: <20210323083631.GE2916463@dell>
References: <20210318104036.3175910-1-lee.jones@linaro.org>
 <CAL_JsqKueTWKbXNuN+74COR1LT6XLyw61GqCLpOgv-knNtEdKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqKueTWKbXNuN+74COR1LT6XLyw61GqCLpOgv-knNtEdKg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Mar 2021, Rob Herring wrote:

> On Thu, Mar 18, 2021 at 4:40 AM Lee Jones <lee.jones@linaro.org> wrote:
> >
> > This set is part of a larger effort attempting to clean-up W=1
> > kernel builds, which are currently overwhelmingly riddled with
> > niggly little warnings.
> >
> > v2:
> >  - Provided some descriptions to exported functions
> >
> > Lee Jones (10):
> >   of: device: Fix function name in header and provide missing
> >     descriptions
> >   of: dynamic: Fix incorrect parameter name and provide missing
> >     descriptions
> >   of: platform: Demote kernel-doc abuse
> >   of: base: Fix some formatting issues and provide missing descriptions
> >   of: property: Provide missing member description and remove excess
> >     param
> >   of: address: Provide descriptions for 'of_address_to_resource's params
> >   of: fdt: Demote kernel-doc abuses and fix function naming
> >   of: of_net: Provide function name and param description
> >   of: overlay: Fix function name disparity
> >   of: of_reserved_mem: Demote kernel-doc abuses
> >
> >  drivers/of/address.c         |  3 +++
> >  drivers/of/base.c            | 16 +++++++++++-----
> >  drivers/of/device.c          |  7 ++++++-
> >  drivers/of/dynamic.c         |  4 +++-
> >  drivers/of/fdt.c             | 23 ++++++++++++-----------
> >  drivers/of/of_net.c          |  3 +++
> >  drivers/of/of_reserved_mem.c |  6 +++---
> >  drivers/of/overlay.c         |  2 +-
> >  drivers/of/platform.c        |  2 +-
> >  drivers/of/property.c        |  2 +-
> >  10 files changed, 44 insertions(+), 24 deletions(-)
> 
> I still see some warnings (note this is with DT files added to doc
> build). Can you send follow-up patches:
> 
> ../include/linux/of.h:1193: warning: Function parameter or member
> 'output' not described in 'of_property_read_string_index'
> ../include/linux/of.h:1193: warning: Excess function parameter
> 'out_string' description in 'of_property_read_string_index'
> ../include/linux/of.h:1461: warning: cannot understand function
> prototype: 'enum of_overlay_notify_action '
> ../drivers/of/base.c:1781: warning: Excess function parameter 'prob'
> description in '__of_add_property'
> ../drivers/of/base.c:1804: warning: Excess function parameter 'prob'
> description in 'of_add_property'
> ../drivers/of/base.c:1855: warning: Function parameter or member
> 'prop' not described in 'of_remove_property'
> ../drivers/of/base.c:1855: warning: Excess function parameter 'prob'
> description in 'of_remove_property'

You don't want much do you! ;)

Sure, I plan to clean up all of the kernel with subsequent patches.

> BTW, there some more which I guess W=1 doesn't find:
> 
> /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> ../drivers/of/base.c:906: WARNING: Block quote ends without a blank
> line; unexpected unindent.
> /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> ../drivers/of/base.c:1465: WARNING: Definition list ends without a
> blank line; unexpected unindent.
> /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> ../drivers/of/base.c:1469: WARNING: Definition list ends without a
> blank line; unexpected unindent.
> /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> ../drivers/of/base.c:1473: WARNING: Definition list ends without a
> blank line; unexpected unindent.
> /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> ../drivers/of/base.c:1517: WARNING: Definition list ends without a
> blank line; unexpected unindent.
> /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> ../drivers/of/base.c:1521: WARNING: Definition list ends without a
> blank line; unexpected unindent.
> /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> ../drivers/of/base.c:1526: WARNING: Unexpected indentation.
> /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> ../drivers/of/base.c:1528: WARNING: Block quote ends without a blank
> line; unexpected unindent.
> /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> ../drivers/of/base.c:1529: WARNING: Definition list ends without a
> blank line; unexpected unindent.
> /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> ../drivers/of/base.c:1533: WARNING: Definition list ends without a
> blank line; unexpected unindent.
> /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> ../drivers/of/base.c:1705: WARNING: Definition list ends without a
> blank line; unexpected unindent.
> /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:49:
> ../drivers/of/overlay.c:1183: WARNING: Inline emphasis start-string
> without end-string.

What command did you use to find these?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
