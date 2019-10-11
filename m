Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC5AD4964
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 22:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfJKUmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 16:42:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46194 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfJKUmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 16:42:46 -0400
Received: by mail-pg1-f194.google.com with SMTP id b8so6414913pgm.13;
        Fri, 11 Oct 2019 13:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4XoXOX0uA8zEeRRweFDHTezpZIHOl+c1NBlkyciPQFQ=;
        b=kjOkPa+qJNIj54kgt1Tu4c2y/jQTQWnHNv6uAQvSn/P8dU/oM5lZgHuq9LM8Qvt1mD
         B836hKn2o1emu0wom0YN4mJ7blqqLeq94TU16FWdODUGpY8gL40Q3OeMdCc70AlteXKE
         X6nj5THN8VqJvA8AQAmdhzQ/j0voXn4FRe1UzTtxQA53a5NnJfDYtwple7KInrVd0JjH
         vqTIALzwwhMMMcC2OWTFdTCz37TVC0iykWK8iPMn/nhj3tb6LLjjhV9a6TdU8U6Xmfwh
         ZWCV9GVr6z+tvC8+8tLuX13eYOAZLoB6xxPqb/6Z20U7apbEd5OXwwe0JlnE/lMWigzZ
         dEqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4XoXOX0uA8zEeRRweFDHTezpZIHOl+c1NBlkyciPQFQ=;
        b=Mf2vIsmgyMfmjSmQruyPY8/Ih6iLtqX6GE4w7OM1VKc73i6fGzzdasD22Ayneb9I1l
         HTydWw6AAsZYWwYRZHgkXV0MQhtpceW4pq17i1WytbhEgdd8ODz6TOOMQR4HhMblfOtX
         ky55+38C/1Q3D9N3UuvCXsn2ondks+Ayo/RDsic1GIel+Z9XazVZZkRdRZqqQZe7YDtL
         mhj1tUUJ+BHIlVYAYKAVEeClnBJcrHbALueqIumwW9LTwVMsQVoxCHYz3nMr7fYj60lA
         ALjDCZMRW5iXHnmoUg+2KIoPexourXLSpailtFlWz8G7hwqq+QQOuODfQv9Tv39CDU21
         D6Sg==
X-Gm-Message-State: APjAAAVqE1IZdrIrTaHRkVaPqmcuGX6esOcovMRN4BORabV4D3/6kXhJ
        WiBhRjDoyMfdi8lYs9CgvHU=
X-Google-Smtp-Source: APXvYqxgMYTRiReIny38MzeJBeHWIF7zFVtugRBRVOxiaqSCzPV++EW3iFHGUcMAK+iv3c7huzSHuQ==
X-Received: by 2002:a65:66c4:: with SMTP id c4mr3754487pgw.42.1570826565852;
        Fri, 11 Oct 2019 13:42:45 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id v1sm10714891pfg.26.2019.10.11.13.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 13:42:44 -0700 (PDT)
Date:   Fri, 11 Oct 2019 13:42:42 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH 0/3] net: phy: switch to using fwnode_gpiod_get_index
Message-ID: <20191011204242.GH229325@dtor-ws>
References: <20191004231356.135996-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004231356.135996-1-dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Fri, Oct 04, 2019 at 04:13:53PM -0700, Dmitry Torokhov wrote:
> This series switches phy drivers form using fwnode_get_named_gpiod() and
> gpiod_get_from_of_node() that are scheduled to be removed in favor
> of fwnode_gpiod_get_index() that behaves more like standard
> gpiod_get_index() and will potentially handle secondary software
> nodes in cases we need to augment platform firmware.
> 
> This depends on the new code that can be bound in
> ib-fwnode-gpiod-get-index immutable branch of Linus' Walleij tree:
> 
>         git pull git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git ib-fwnode-gpiod-get-index
> 
> I hope that it would be possible to pull in this immutable branch and
> not wait until after 5.5 merge window.

I see that the patches are marked as "Not applicable" in the netdev
patchwork. Does this mean that you decided against pulling this
immutable branch, or you dropped them because of kbuild complaints (that
happened because it could not figure out how to apply the patches)?

Thanks.

-- 
Dmitry
