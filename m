Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA0C3C36BA
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 22:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhGJUJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 16:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhGJUJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 16:09:17 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7F9C0613DD;
        Sat, 10 Jul 2021 13:06:31 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id m17so19746288edc.9;
        Sat, 10 Jul 2021 13:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=279SNIJJKJdalSwwK/+vCT2n7h+cZDK+CFjInEn12Wg=;
        b=uVu5+H9B5kYnaNupC8Xwy5ddbiGdIwZ6h4819ZgV0eZsbn/O/x6KpU2l5/rGxRoI91
         zziyFROarERB92ZIJ1Jk3Gp+Vn34gt0aQlq7MtbHaQw3bOvNEFy4fyTcyMrcoZKmwo5G
         s4DLajdut5BdwH/k2/qsyu6P1NrhFkAYYim6p7kAitk3L4ecu/p5lnwtRnvlj3ZSGa4r
         cjehgnCuzdV1Wq7Kl6trZa5QCf7i5IZMNPDyWUfvgFbMbBSI9i8UbAKTJcyo+dRbQnF5
         womE5ahtNfEjiWTYhhlxWoqGVAM9gUSaGKzQ48Rb446Rzrauxio3Ut+5KHFtK9NHWBGM
         +tfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=279SNIJJKJdalSwwK/+vCT2n7h+cZDK+CFjInEn12Wg=;
        b=P8d6iCjFt8vSz+JkIz+UgnMpmWSLQUmQbM4QRZWbAzFIb3Pefs+9AClxPN3ihsqpEz
         FJ4MYUhJU/qWRL7fMAKXz88j4dl1xBucrdEbDbDHkJDOSHDTQSQrlU8XU6SJzoem5mS8
         ZS40u4pDu81g8lLCTRYwUY+WzD6iUYCiNHgb3zjY32GkWTb4ubdgylavsyLIkqHDNba9
         yE2MTQf2LMq9FGnQ6VFDrqsMjxUA096EaAgNw5dzjAcZ8QdtsUhK9zrjAKC2UUrhxRpx
         U7ruEWggv5a3E0DqQqMxeDo1ci6UniIK/uVlEVtRLD5YRe7YDGzf738/AahVX0hij8b+
         ENDA==
X-Gm-Message-State: AOAM531iTc2ZquGFyi0poeomdmR0foxNQEi0Qe57Jeebu2om9kW05nJb
        03/4b78LkHH7E156m8+4ao8=
X-Google-Smtp-Source: ABdhPJxOsZyaSugxbfGUGG4qRb0BqZb/E+AczvOYeRPetBKyCK6j+YF88vss+S269MvMZpaTP4zntw==
X-Received: by 2002:a05:6402:2044:: with SMTP id bc4mr27541932edb.307.1625947590114;
        Sat, 10 Jul 2021 13:06:30 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id n13sm4138951ejk.97.2021.07.10.13.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 13:06:29 -0700 (PDT)
Date:   Sat, 10 Jul 2021 23:06:28 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 3/8] net: dsa: ocelot: felix: NULL check
 on variable
Message-ID: <20210710200628.uwwyzuuou242anzq@skbuf>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
 <20210710192602.2186370-4-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710192602.2186370-4-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 12:25:57PM -0700, Colin Foster wrote:
> Add NULL check before dereferencing array
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

The patch is correct but is insufficiently documented. In particular,
people might interpret it as a bug fix and backport it to stable
kernels.
