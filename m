Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2A42ACA9D
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 02:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731536AbgKJBmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 20:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730348AbgKJBmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 20:42:38 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD37C0613CF;
        Mon,  9 Nov 2020 17:42:38 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id s25so15151710ejy.6;
        Mon, 09 Nov 2020 17:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2XBv+bau2T0tT0YMQijH/9j+qP/ondesiGiFE1FM62k=;
        b=WgSKLe5O46a5WSSuVg6p3+qRbAsRyVdFTkrCZMSDa7rKQKfscWPSe40n/5PCYI/Jwa
         Fh9fSDw5PJmMMqbNuZkfTPbYs6UVhBq1n24uSUfsm2028DEpjnDDhO9AUQEp7aROmKz0
         J1neQCD2dYSL6v6qql+r7TsOaDphXTK1A10o944gJLfgIZcrHWJooSjVvDJcEFdwnbc3
         crhGU5EOi/t44dWaySv9Kwz29/Ko49uunvDTGLrDSOS4rXtS+253H+jqF/htrQtDeQ02
         a3M/zwA7WYmOOvCpQhmQX3Nuyg2xCM4InfvzHOUskqD4Q4kLmPg8CmgQYL8s1lHjUL6w
         m5FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2XBv+bau2T0tT0YMQijH/9j+qP/ondesiGiFE1FM62k=;
        b=GSP1bFx/5RGGCsmS8AjQShTfwRraBkXGpygPIXrmx2JCQ7Xoi+wTw1cGDb+BoCgueL
         6bd6WwsV9mpZ4plzR9ArO9TWgWfDuEdRi90NOS2SK9Cgev1IlaJ41i1WnkoSshGWJUlS
         tAtSzD9gY4tGxEZBYHy1hsR0TChgDC8gH9kVi776WUAPYhFjQNuchn7X14m1Rj3SRbSQ
         lHWqLqXf7wjZ1VUvqnhe+Dx6g/gQO+h9d516Ru0M/6dnofiD+fp9ZCsLxluRAyKmEL0A
         6MEo9PylAQnA+6g3o2+/SY4k6SNE9jsyluUjJl+vgxe4A7xdKU+JuoVsijzaIsuhqz54
         KSKw==
X-Gm-Message-State: AOAM533I7wQnxF8jBxqLnC7oD52gWuErDm6pW88HDWuOj7eJQfqMf/Dp
        L7e/55+wcW3zNo+/K6GChnc=
X-Google-Smtp-Source: ABdhPJzPmjLD1wIfBHVxywlVZqFgx4NRHieYjWVu1vml6kMk1Z4UmISXQnhW7bBAznyXLf6hbJJ1TA==
X-Received: by 2002:a17:906:a14c:: with SMTP id bu12mr18306597ejb.444.1604972556902;
        Mon, 09 Nov 2020 17:42:36 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id o31sm9673734edd.94.2020.11.09.17.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 17:42:36 -0800 (PST)
Date:   Tue, 10 Nov 2020 03:42:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add
 hardware time stamping support
Message-ID: <20201110014234.b3qdmc2e74poawpz@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de>
 <2541271.Km786uMvHt@n95hx1g2>
 <20201022113243.4shddtywgvpcqq6c@skbuf>
 <5844018.3araiXeC39@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5844018.3araiXeC39@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for getting back late to you. It did not compute when I read your
email the first time around, then I let it sit for a while.

On Thu, Nov 05, 2020 at 09:18:04PM +0100, Christian Eggers wrote:
> unfortunately I made a mistake when testing. Actually the timestamp *must* be
> moved from the correction field (negative) to the egress tail tag.

That doesn't sound very good at all.

I have a simple question. Can your driver, when operating as a PTP
master clock, distribute a time in 2020 into your network? (you can
check with "phc_ctl /dev/ptp0 get")
