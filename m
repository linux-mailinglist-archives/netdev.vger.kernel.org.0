Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8483EC256
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 13:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238255AbhHNLRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 07:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbhHNLRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 07:17:33 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B859BC061764;
        Sat, 14 Aug 2021 04:17:04 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g21so5391218edw.4;
        Sat, 14 Aug 2021 04:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sFuQOxf4Uj/Ksao4Xe3gegBoFzrHq37Z5/m2daygjUk=;
        b=S3HqDRg5AfGsMERZ8ykkUOYaddzM9smQX5sspty4hPgHxRe4L1gAJw9l+kKV6WuzMi
         xaS8PqNzXaFzdN0UxIxboSqhnUIjtfZoPoHQEGiMPa+BefjNa3KdPfOuBR8SpQhiHSm/
         PV4JSEKOVR+t7/JT0yaPpe0LjH9iM9SjVm0WqdO7OxZj+kIgzJoCYAE8OD9JlYgnDC4t
         smUXUZ0NDsrjdcdgZbjRhxVBBHPclKhF75BqeLRUtz1FhR7kkbq2T4p2bKV4+RqaobkX
         +b2N8KjUUZxJo8CvBtRjYx4AY277z1g2rp1WMx3/dUPwTgjws6cinCj/IwrfjtUtVSnF
         vzfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sFuQOxf4Uj/Ksao4Xe3gegBoFzrHq37Z5/m2daygjUk=;
        b=E4z+mSWF9egwiDTlge4G4G8/1K8LtVFvgo0cvWuggyhBvaKdGY0FsVaRwC/9VXsEdW
         g0OsJ4IXG6hs+tR4aVMroADRBJhZ5J3cx/b675qyvHL5PB1SmKg9FFSSPdXbBV96wb3T
         orXy4+n6Cwzx07ztSCDuRFYOmpwo+rz1CifdFp356AOyelhlm4wpOECkfsisVvX+O2R0
         JmPsFCip+U/YLmxWaWcGJrXXBoW/7dv1lUBi79PjIrPe9m95QFSw9EyfD2NUTr1/0qB5
         GUGMUk0cCKle+Xlytnu4HnXsJrxTbTN04f+xz13MyQSz1YhPL/kpltf5x/boAeBk1Pb/
         lg0Q==
X-Gm-Message-State: AOAM532oogBfCszf9304lwXPJcuwgiLacdtD7lgR/eQlcqfvSzM0crrC
        9gpO3+9dFXPPH2xPPVZR6OU=
X-Google-Smtp-Source: ABdhPJyPx2ttMXQOMjpDk+X8jtcSr+ApaNkeKl/+WiAXT7g3ibzVDUtUy+a5EurSpJnbJTdWGGyaOQ==
X-Received: by 2002:aa7:c894:: with SMTP id p20mr8512274eds.42.1628939823377;
        Sat, 14 Aug 2021 04:17:03 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id ks20sm1667500ejb.101.2021.08.14.04.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 04:17:02 -0700 (PDT)
Date:   Sat, 14 Aug 2021 14:17:01 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 07/10] net: mscc: ocelot: expose ocelot
 wm functions
Message-ID: <20210814111701.dkn3ckhzxoyvcw5s@skbuf>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-8-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814025003.2449143-8-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 07:50:00PM -0700, Colin Foster wrote:
> Expose ocelot_wm functions so they can be shared with other drivers.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Can these be moved to ocelot_devlink.c? There's a lot of watermark code
already in there.
