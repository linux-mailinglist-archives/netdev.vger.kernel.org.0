Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781DC1B8B76
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 04:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgDZCxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 22:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725952AbgDZCxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 22:53:06 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75326C061A0C;
        Sat, 25 Apr 2020 19:53:06 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a31so3895543pje.1;
        Sat, 25 Apr 2020 19:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1LztWkTQksezm49t04IiCw9RhUvH955q26bjVcYL2+w=;
        b=bWN6zg77Lmi27H32TLeWao3GKLDwrMUDIOKQUuFD68yxeyXDXzM/NhPgMIvl7Uj9y3
         9le3mMk/2ELc0Fp1WOBMNWfHowpx4PKeHLxH+2Y2EIE7gNn1CiUxoHnBT8zUAW6Taxv6
         NwkPgt8m6R4P7mNQo1146Dn16BFUrvjXMXFe/B3tbhpeLKlHXHBkxDfuiGRQYTpSzLYj
         0dn473lYNJPuzo7O39LCxzD7NdCzT8gV2nOsLJWCMvvZehOdaz6ezsZpxV+ccp6xeIt/
         qyxm4oNIvYtp4q6p4HS/sATt8mI3TDOAfstLGN4KCpJOVUx1pd/v7ZvcNgYSGqJoUUda
         ZhMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1LztWkTQksezm49t04IiCw9RhUvH955q26bjVcYL2+w=;
        b=dUhZt+exeQbK635sf3QGliyaz3SX+NzcnmgFKHCP8Fg4x9WFVc+Yn3QKMTjGbt+Ke+
         QH6vi5zHyW/wWtuQJC8f3zbJuah1ogbOSDogH/Qpdy92chvKtdH5Luj5BrCbUUMyBCVN
         ANGTEX1CVBoZlMOjmn4l6i0QXccX4igEAg1PejJLsRHeyP3XvlHBw+LdyqcKkSU6ShQg
         MShLj4jd9N02jZRgPiCkCcVhmGk0LaT3OrZ9/ngMZD0Ye6F6bNNpr6zNB0ZWXcWbjYrL
         Szq6Lol3qfD4HYzx/0mPrnNl27Zynk0b6Fn8vWGAV67wyMg69n3FKkBq3iqyY40MkoKU
         J6/w==
X-Gm-Message-State: AGi0PuYLgkqoR6nsd39G1Gp0EQ58z5mWjCuh4HoGpXShMpZ6Vp+2n+ol
        V2nfkMz1tPAfg8xT3jPS+ns=
X-Google-Smtp-Source: APiQypInH+VVbys+8G7ngkwBV7EOSU3pXKlNLrDx/agluMsFAtugxxZrRjsYO7M6KVcArI/cpcPkHw==
X-Received: by 2002:a17:902:dc84:: with SMTP id n4mr314861pld.281.1587869586024;
        Sat, 25 Apr 2020 19:53:06 -0700 (PDT)
Received: from localhost ([176.122.158.64])
        by smtp.gmail.com with ESMTPSA id p1sm1609850pjf.15.2020.04.25.19.53.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 25 Apr 2020 19:53:05 -0700 (PDT)
Date:   Sun, 26 Apr 2020 10:53:00 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Yash Shah <yash.shah@sifive.com>
Subject: Re: [PATCH] net: macb: fix an issue about leak related to system
 resources
Message-ID: <20200426025300.GA18964@nuc8i5>
References: <a0891e70-d39f-7822-f81a-04eb824c6fd0@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0891e70-d39f-7822-f81a-04eb824c6fd0@web.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 25, 2020 at 07:00:35PM +0200, Markus Elfring wrote:
> > A call of the function macb_init() can fail in the function
> > fu540_c000_init. The related system resources were not released
> > then. use devm_ioremap() to replace ioremap() for fix it.
> 
> How do you think about a wording variant like the following?
>
Markus, I think my commit comments is a sufficiently clear description
for this patch. Someone has told me not to send commit comments again
and again when it is enough clear. Because it only wastes the precious
time of the maintainer and very very little help for patch improvement.

BTW, In the past week, you asked me to change the commit comments in my
6 patches like this one. Let me return to the essence of patch, point out
that the code problems and better solutions will be more popular.

>    Subject:
>    [PATCH v2] net: macb: Use devm_ioremap() in fu540_c000_init()
> 
>    Change description:
>    A call of the macb_init() function can fail here.
>    The corresponding system resources were not released then.
>    Thus replace a call of the ioremap() function by devm_ioremap().
> 
> 
> Regards,
> Markus
