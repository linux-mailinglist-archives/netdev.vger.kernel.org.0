Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505054252C5
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 14:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241175AbhJGMOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 08:14:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231821AbhJGMOU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 08:14:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42F8461261;
        Thu,  7 Oct 2021 12:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633608747;
        bh=UFmzM6MOPDrC2YnCHNQY4jnog6UiUR6r3/FJrYKEiGY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jEF9Ip0cdeXVMo+RrjAtjg8Q1qJZZlPsKYbJhtIZqPTvZZpMw0Pq7PbhlBufVUhmi
         eQm3nGqo2WwPwsTTDf5ILHQBpZRDMi2OVhEa4bq7BZA74sXxfkPcn8oZqq4O67iKE0
         kJT1C5V217JDgjZ2cHVG8cC3hRLCg8ptbiS1XT7gQkrGCjqUwVoAfHlQ6+ggn+fgkj
         kejLwJ0wZnZTxE+UyQ0IEgcJ0hEu9oD8H76vjvokio/pRFeFcYvqNWfS+lQirK/aPD
         iMbawfr+XgvZ7FQd+xTTBHkW9aaiiWv8hH9JiB0bjK88Yr5ohph+ilxOazAzjR773G
         HFwn6fYYZiVKQ==
Received: by mail-ed1-f52.google.com with SMTP id r18so22289486edv.12;
        Thu, 07 Oct 2021 05:12:27 -0700 (PDT)
X-Gm-Message-State: AOAM533+COMJfB4JZFPKQG7GW1DiA2Sl4jy3IXeB5XeNGtOEiDNutcFI
        qRiZATuXT5e2hTshgYT+GFZuR+YgKB3peGCndw==
X-Google-Smtp-Source: ABdhPJyKnoG5BuOUgOydTNWekh8Q/qcWH6F6+u4CPjoVWWP4ynDVrh0Q4+pWywPOknwRDSQkpnDKqKfFdhnlIQsdaYE=
X-Received: by 2002:a17:906:7217:: with SMTP id m23mr5160203ejk.466.1633608745772;
 Thu, 07 Oct 2021 05:12:25 -0700 (PDT)
MIME-Version: 1.0
References: <20211007010702.3438216-1-kuba@kernel.org> <20211007010702.3438216-2-kuba@kernel.org>
In-Reply-To: <20211007010702.3438216-2-kuba@kernel.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 7 Oct 2021 07:12:13 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJ85TEDXwLLFo3y5w=G0X4+9H-_9UdtL4Nykk1YRxpaLQ@mail.gmail.com>
Message-ID: <CAL_JsqJ85TEDXwLLFo3y5w=G0X4+9H-_9UdtL4Nykk1YRxpaLQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/9] of: net: move of_net under net/
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Marcin Wojtas <mw@semihalf.com>, Andrew Lunn <andrew@lunn.ch>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        devicetree@vger.kernel.org, Shannon Nelson <snelson@pensando.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 6, 2021 at 8:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Rob suggests to move of_net.c from under drivers/of/ somewhere
> to the networking code.
>
> Suggested-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v2: new patch
> v3: also clean up Kconfig
> ---
>  drivers/net/ethernet/amd/Kconfig    | 2 +-
>  drivers/net/ethernet/arc/Kconfig    | 4 ++--
>  drivers/net/ethernet/ezchip/Kconfig | 2 +-
>  drivers/net/ethernet/litex/Kconfig  | 2 +-
>  drivers/net/ethernet/mscc/Kconfig   | 2 +-
>  drivers/of/Kconfig                  | 4 ----
>  drivers/of/Makefile                 | 1 -
>  include/linux/of_net.h              | 2 +-
>  net/core/Makefile                   | 1 +
>  net/core/net-sysfs.c                | 2 +-
>  {drivers/of => net/core}/of_net.c   | 0
>  11 files changed, 9 insertions(+), 13 deletions(-)
>  rename {drivers/of => net/core}/of_net.c (100%)

Thanks for doing this.

Reviewed-by: Rob Herring <robh@kernel.org>
