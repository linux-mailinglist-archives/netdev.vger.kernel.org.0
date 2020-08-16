Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65B62459D2
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 00:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbgHPWRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 18:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgHPWRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 18:17:14 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D64FC061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 15:17:13 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l23so10790425edv.11
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 15:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8W4PdPQrHlvyxdTdQMJpdFjr9+g0eOP32lTkPT5mHtI=;
        b=EzuuYx9ovW6ihu7JoXTmL21zc8+ORQK58skpHwI87mgbqA6SWuOEa521/M1iBgYAv/
         vMdmFX062CQ1aNJIjYPVF7fY26TdKRaxgVwAdlDvVj6r98MiHOzr9NhAfvO9TvnmbyG9
         OEGt8n2sQVBjEKDuJsu/R/3KJOh4Ntby5pD3ytXWst5FqIRvpMb7qbC+3VoeOUWI04Nd
         57Y2MVc8L/cgKz4SYvyXRv0XYLplp0nBFmwAM/8uNHk0aGdWuuBEkCoJwm/XfATgmAl0
         7I9kL9MIVwhtTMkf2Wijls2MznNYLQY4td89spADd1E2M+PnNO+F+XfNwItL8+zwcltO
         SIPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8W4PdPQrHlvyxdTdQMJpdFjr9+g0eOP32lTkPT5mHtI=;
        b=ec7L3X06DaRRBLU8Rk/+OX67shMvb4qmJpldezfZxIGR4ynu4sDcTiPsY62GbXm1Ta
         Nx6PqaqQYEUThslFbg8bIrR05HeMu+66bvAs6MNG0cvWiX7kKX8drj3ZWN+S0QsQS9JI
         L5wVtna0lIKl83y464krRXEZto9ZYpK1xQQzirUuV6u1WXCMZB4uqM7C7pEcIhjIb13/
         9/j7BKn3aBbFcEz3jxIIdG7qNHsPb5e33LI6RWVFdqVl7sRUYmnoOBpYSOe9lTZnINL+
         K0htnJwEDw+9k/0K6Zz59hx/w3HaadiDI+m7ovXMlG/Sr9Gb41+XRFPOo93hp55FhqJX
         uAig==
X-Gm-Message-State: AOAM533i2zsEAgGA93QTzyWAEW57cozR+mVYQwVMTmWZRL0w6uHyYA+/
        3dqR2tjAg49YMDpmUtrj4BM=
X-Google-Smtp-Source: ABdhPJzUvDniaQ4bYUnD2o2EuBsTYhq/Am3IqayN2aVABLq8cyaSC9Q32YVSXhtmJLnCYLRdjWBaLg==
X-Received: by 2002:a50:fd16:: with SMTP id i22mr12236119eds.281.1597616232278;
        Sun, 16 Aug 2020 15:17:12 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id dm5sm12503622edb.32.2020.08.16.15.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2020 15:17:11 -0700 (PDT)
Date:   Mon, 17 Aug 2020 01:17:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 2/7] net: dsa: Add devlink regions support to DSA
Message-ID: <20200816221709.ugb6qf7k4koc3y43@skbuf>
References: <20200816194316.2291489-1-andrew@lunn.ch>
 <20200816194316.2291489-3-andrew@lunn.ch>
 <20200816215009.m7ovmuwjme3lrl4g@skbuf>
 <20200816220632.GA2294711@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200816220632.GA2294711@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 12:06:32AM +0200, Andrew Lunn wrote:
> > Could we perhaps open-code these from the drivers themselves? There's
> > hardly any added value in DSA providing a "helper" for creation of
> > devlink resources (regions, shared buffers, etc).
>
> If we do change to open coding, would we remove the existing wrappers
> as well?
> 

Maybe?
I reckon one of the main reasons why DSA hides struct net_device is to
present a unified API for the ports that don't have one.
But with devlink we don't have that problem.

> > Take the ocelot/felix driver for example.
> 
> ocelot/felix is just plain odd. We have to do a balancing act for
> it. We don't want to take stuff out of the core just for this one odd
> switch, at the detriment for other normal DSA drivers.
> 

Yes, the ocelot/felix driver _is_ odd, but in my defence it's only as
odd as the hardware was integrated.
On the other hand, the model you're proposing would be forcing me to
register devlink regions in one way for felix DSA, and in another way
for ocelot switchdev. Or could I just ignore the helper, and call
devlink directly, even if there's a helper in place?

Thanks,
-Vladimir
