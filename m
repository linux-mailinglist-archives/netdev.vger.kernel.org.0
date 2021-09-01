Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488D33FE112
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 19:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344968AbhIARU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 13:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234840AbhIARU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 13:20:57 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDEEC061575;
        Wed,  1 Sep 2021 10:20:00 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id 6so211048oiy.8;
        Wed, 01 Sep 2021 10:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MQNYeLOlbF4CU5PfvC1DgnprS8pBMmOc+dOnuh+XI1k=;
        b=esBUZIktOXnkxH7MHZWuyRuBrt/0OaHxjQAi1ayt+Dl36umGXGmzSQ+Sx/LAPlT3aT
         LkA+BTaWsdGQJNoWzkP60NEmKvTEj93uAjnGU/HzGPK+Lq92+GaG71MqDk3auyBgEbXE
         V0mTLqLfn9AXf2+ozir/0KZUzw6vm2Z5+jzgrktMtWhqonWBYO3tAyXT+GzGXKTp52pp
         gc8r1OZ9z6YQ+uMu+t3hK433OJCkyJgjFxE+xhcYN/UhtHnBOHnk/DRSW/xg3jRAc1ue
         gd4n/vR26V4WxDaf+KTC2SQU1zEaEBRlEXQmEcV9rj8x6qN+2XeFFhBf7UMagdghgviw
         821g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=MQNYeLOlbF4CU5PfvC1DgnprS8pBMmOc+dOnuh+XI1k=;
        b=BoxJ/QPNNm48oyfqB1xZ0Hk7nDFCImLbD0a7E9WTlud7dE9CkHFDJ754nlpq3Agjcy
         ysQvrMdr0HOlQ9oVAfBHCNXA6vPse+Ji4Shm+X3DaKdMK4UT2WujI0LonjM/79RKkIwr
         fNCUA+RVNhWdrcRyNd89ZgDmaRwx8pNC0VmvEeg1KOahPZaxFXOxwYSjSJa/OMXaGE3X
         xIjM8Vs2O9RWhQOhM/C5iWN/0/OPe63cN8QkWXKDrTI676pGrbhrZPJSSpR2Kn9owp88
         NIl7qT8jwBXmXOFNVTkRFyZwSmyEqjSc7sz6KctoWI/yUwUAFQdcuveKJMbOln0RAbnv
         WUUQ==
X-Gm-Message-State: AOAM531oQvo0P7U4hNL9QrwC7/U5EgqI0/GhSLbna6J1a23YDSpRv35P
        N3MXZ1MPBGi7ve89b1xK0rk=
X-Google-Smtp-Source: ABdhPJzrU8WAkpumxHlHzavN6WMqpEaXk7p+smulDC+w95FmkVcCbDcJYy1r45EYCpTBirX1Gq8XHA==
X-Received: by 2002:aca:b6d5:: with SMTP id g204mr562584oif.29.1630516799738;
        Wed, 01 Sep 2021 10:19:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d10sm71231ooj.24.2021.09.01.10.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 10:19:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 1 Sep 2021 10:19:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Doug Berger <opendmb@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sam Creasey <sammy@sammy.net>, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH v2 05/14] [net-next] cs89x0: rework driver configuration
Message-ID: <20210901171957.GA2882691@roeck-us.net>
References: <20210803114051.2112986-1-arnd@kernel.org>
 <20210803114051.2112986-6-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803114051.2112986-6-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 01:40:42PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> There are two drivers in the cs89x0 file, with the CONFIG_CS89x0_PLATFORM
> symbol deciding which one is getting built. This is somewhat confusing
> and makes it more likely ton configure a driver that works nowhere.
> 
> Split up the Kconfig option into separate ISA and PLATFORM drivers,
> with the ISA symbol explicitly connecting to the static probing in
> drivers/net/Space.c
> 
> The two drivers are still mutually incompatible at compile time,
> which could be lifted by splitting them into multiple files,
> but in practice this will make no difference.
> 
> The platform driver can now be enabled for compile-testing on
> non-ARM machines.
> 

powerpc:allmodconfig in mainline (I tested v5.14-3756-gd8b4266666c4 and
v5.14-4526-gebf435d3b51b):

drivers/net/ethernet/cirrus/cs89x0.c: In function 'net_open':
drivers/net/ethernet/cirrus/cs89x0.c:897:41: error: implicit declaration of function 'isa_virt_to_bus'

Guenter
