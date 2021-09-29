Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D661A41CE99
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 23:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346179AbhI2WAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 18:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbhI2WAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 18:00:36 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CF1C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:58:53 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id v18so13892104edc.11
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=AQCL0Iw8COXwWivG4mXKwhejXTKvLJdLMLuuVVyNJCg=;
        b=Fye0Qsy3RjCUiiDkqtvAOHq+ZnLEHL/KKgcjHfDZ5W18bf2KPf3ywXT3CxXh+mb/9Y
         S6SYwSZoz2u2CaS3uWjVOCUS2tclxNgwPpeMewCcSF7hX+rpC1BgSQkovMJRkpWjVN2K
         5ziTgt1lKHBmUkdjhSJP31ZLsMsbs3ZAVSBGQnPv1B83kg5ztTNjwBOn42KlzY2E7MYb
         rvzXOlszcUSr71ERiBWBL/HJQAi2fFr8Bxe6hJUD4NXLNZsFvD7V7o14D4wIskSxB729
         TdpG5yYyexIFdbBa7+oJzYnLN44uC0c4yXZIOHOleAn9XgfWHYtA5BHQUhMe2P+6o9dL
         H8NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=AQCL0Iw8COXwWivG4mXKwhejXTKvLJdLMLuuVVyNJCg=;
        b=rcH+vxdorsQlNVC1ToH8pgl18uoBHf2liHc7eBJONg5ESgdzrq70PdR8OV9sQFIJfQ
         EvV53wKYgzeNsMo4/f0794VjiR6D0yusmdhnQ8gKeRwbrJCEuoRajFg3BXYPVvbq+hAy
         dYetZvj+850TrSBiCVS7/eE0lL2UrvReqII1k/HlCDv2zE4uzNtiXc5qjG6Pb3UPYakv
         ICWeqHczArsYTEJc5I1Q4gnCytpIeVa+hCNuzA9IUKhHws7pG9QDuL62R0oRPhlrVyq/
         3W+VaIzMLOH9kUEsh+mt0DTRyVdk3DnAsRZmjZioMvRIc9peBJlzhOtunhwGtq1Zhw1O
         QvMw==
X-Gm-Message-State: AOAM532StD1zo3ZGPnKkSDmxkdMTiZC1pVvlkfPRYKIw0ATT9bBKvA+Y
        g9XutQZcB+Z+oOexrW20daM=
X-Google-Smtp-Source: ABdhPJwFliiSe9C6RDabeTdFNWvfy1NW9rC+fxO1cNX83/pw+qvJH9I9W67qtDnpjcmfQ9rU9plEoA==
X-Received: by 2002:a17:906:6948:: with SMTP id c8mr2590145ejs.187.1632952732274;
        Wed, 29 Sep 2021 14:58:52 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id cf16sm550623edb.51.2021.09.29.14.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 14:58:51 -0700 (PDT)
Date:   Thu, 30 Sep 2021 00:58:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 1/4 v4] net: dsa: rtl8366rb: Support disabling
 learning
Message-ID: <20210929215850.znaj3sw422w2c2xk@skbuf>
References: <20210929210349.130099-1-linus.walleij@linaro.org>
 <20210929210349.130099-2-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210929210349.130099-2-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 11:03:46PM +0200, Linus Walleij wrote:
> The RTL8366RB hardware supports disabling learning per-port
> so let's make use of this feature. Rename some unfortunately
> named registers in the process.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
