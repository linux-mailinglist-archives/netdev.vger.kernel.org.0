Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64508418408
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 20:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhIYSwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 14:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhIYSwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 14:52:15 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E349EC061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 11:50:39 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id l8so2347299edw.2
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 11:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=oZkuWJd2ePSsI26RBKO8Z9+iPRrnkX97AJwIZNzoKF8=;
        b=qzMmBRZ/NKafMNecpzdJu7jg39aiG/5lXeJVrTp6xgZhfqjVUe8BFvVudJOnu3+bhD
         +7VbW3alxln7yaXGg1ft50QxGmMdtni56yO0UV+2fDv4CNxQuxIk6NQF0Zvdba9VGjEp
         VuQ4C2i6Z4WNrwC1AdYRnO31MviVJWpB3xtFogvjb/c1OCgWQHhb5sdMD1pOtmoIjZfv
         3zc5OvtYWZ9ziCFRz9CIiZ381kRRA7Wlj8bOnftM4PwAj/f37T69RI1XOVwOOH6XKPrd
         jIswZVRjcEZysDKqx7qe5g8UCjZBbpFu4jJuZ59QKNwlpT2prVUKVeXVu3h4mnDFnuAO
         +4sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oZkuWJd2ePSsI26RBKO8Z9+iPRrnkX97AJwIZNzoKF8=;
        b=zK7uIWHguMGo9J2fjsl8KdmIwcDy+j3/FFX/4XaIpfYpf9kSoAgL/qPHowbEt/UZSc
         5fGBwm6BQGUny3rcu3+xLVd/fCwAcOmj0kDaSqQeytQH4qjB+vUh8o4WuPxXSMx7LrJh
         kQW9w3mCa2nIaZHQHIDgpD1sial1lYTFl+1/mVyvFa7JqR8MZBPf+9juQoTjTipjkxqo
         YAIFrF9dbZWm6Hbd9sF5vxYjpahVqmpPcCzhxYvk7YgSrja1pPoiM6QL9Jh/8RDbvTTt
         mN9+LtGCIF6/GoGfP7UPtOK3wBYGbpdPFNLEvj93qxQKoI5qa8PCeAgcXsIYm1WBIP69
         Gapw==
X-Gm-Message-State: AOAM532BazUbJgjec9C4js6syw7R85irKqQQST6bB9T5JtWEY7GA6T0/
        mVutiCOLW2LnYnOALwMN9faqw6tGVGQ=
X-Google-Smtp-Source: ABdhPJwB27s/rWx/AaOABtsRiuAnmLwYcJ0JDPmoe316SZvO0hBXQBt1ReB0y8+cjzwycLq0auloyQ==
X-Received: by 2002:a05:6402:b12:: with SMTP id bm18mr240820edb.199.1632595838573;
        Sat, 25 Sep 2021 11:50:38 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id p5sm6384406eju.30.2021.09.25.11.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 11:50:38 -0700 (PDT)
Date:   Sat, 25 Sep 2021 21:50:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Mauri Sandberg <sandberg@mailfence.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 5/6 v6] net: dsa: rtl8366: Fix a bug in deleting
 VLANs
Message-ID: <20210925185037.q7nyhbyq3asrvhul@skbuf>
References: <20210925132311.2040272-1-linus.walleij@linaro.org>
 <20210925132311.2040272-6-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210925132311.2040272-6-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 25, 2021 at 03:23:10PM +0200, Linus Walleij wrote:
> We were checking that the MC (member config) was != 0
> for some reason, all we need to check is that the config
> has no ports, i.e. no members. Then it can be recycled.
> This must be some misunderstanding.
> 
> Fixes: 4ddcaf1ebb5e ("net: dsa: rtl8366: Properly clear member config")
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

but bug fixes should go to the "net" tree and from there towards "stable".
At the very least they should be the first patches in a series.
