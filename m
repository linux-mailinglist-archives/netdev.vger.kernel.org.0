Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BB82B1263
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgKLXEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgKLXEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 18:04:24 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFA2C0613D1;
        Thu, 12 Nov 2020 15:04:24 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id e18so8443471edy.6;
        Thu, 12 Nov 2020 15:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7EjfNjokVA+Ip5xEY0Et+UbXcCvqe33hKSsf95YOQTE=;
        b=uidqdNlkSR0HjUQ5fRPq6ij1qNSQchBB6wXirlsliUxIQWXJQrACts2GDGWPe4ekZ2
         Xpaj+d/bnbwgXkWp6Leu7syPoRkYqfLGxL1QBRmCouy26DoWzTkCQIear++NFzSKl71i
         9lH+QifDzqnNFK3rQlAmuG6X6gBmcQzl+T1BM3FbPldvm9pWW+XJhG2RcCLkZijsuWaN
         l0zAoKl09f1LyXj4Z6XvsmP6+hOpiIkguIkMdt0a530mS4t4mZOdKfAYLdLXJkvnUX1M
         E1DaQDmDl3fh6Z/0AHqwMe5ZSyWSJdkj11LxVTXIH3nqFIJQONAHAVCn5P4ZRPM4VYc7
         mIbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7EjfNjokVA+Ip5xEY0Et+UbXcCvqe33hKSsf95YOQTE=;
        b=HTlCHtffwnLFxpf8wwnVpakD0KQRiF61jRXfMnyxnWuwn1kx4yUjRnmI9vU5hbEAs+
         igfqYGnuQjUM4E4urMw5BK4AoLJhe5t8rVo7eGsfh6I8Ql7Hjaky+C3COc6k1RQ9qfbn
         Ba21oyWcRBRM1yFCqoZAAWLU/FF/hUkDdh2qDc4GvkeRikzng/6vTVReCRo6liyPvWlK
         2YOySMS0xtvEWJJB/L7BMUnyxUgz0QG1uKkZ0S9rjr2nmAvktlVTQvV4j+lLwo26H/eK
         Nw3yWwkt7aEnUBYkJYTeTPnVyyS2rTKVZPUxoH6RtnJpqDydjaVyza5xVL8uYlDNbuxD
         f0cg==
X-Gm-Message-State: AOAM530RcFvKWbbDH+fdTEElMnIcpDcJ23lqvRhsiCcIC+ZUq741m1yK
        BIoLHYS7CMK9yagj+xenLpY=
X-Google-Smtp-Source: ABdhPJyAgiyZCjaGcR7KTcgbRPew9fnk5N207iye+y3ljI03AwXoXIPjgZLexxhY2ZNNxw8oySNFuA==
X-Received: by 2002:a50:bb25:: with SMTP id y34mr2298061ede.249.1605222263379;
        Thu, 12 Nov 2020 15:04:23 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q19sm2679944ejz.90.2020.11.12.15.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 15:04:22 -0800 (PST)
Date:   Fri, 13 Nov 2020 01:04:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 04/11] net: dsa: microchip: rename ksz9477.c
 to ksz9477_main.o
Message-ID: <20201112230421.6op5jkwubefo3te3@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de>
 <20201112153537.22383-5-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112153537.22383-5-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 04:35:30PM +0100, Christian Eggers wrote:
> PTP functionality will be built into a separate source file
> (ksz9477_ptp.c).
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
