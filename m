Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A255409A95
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 19:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240913AbhIMRXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 13:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239321AbhIMRXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 13:23:36 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54DAC061767
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 10:22:19 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id kt8so22638465ejb.13
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 10:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=vabVJLvPmcjnxX58SbBYjQSZ52U2HSgPreDRXzqMmVI=;
        b=FQpctGsVuWP+pJZXE8gVbLQ7gUs1Fcpyb2vfQqI3OVuW64eevFQ//o0IsLA+a1bqgV
         WOri9CkQavueZjR+nUq8jqLpKgr7y/gm6Q+rOTFfdBArnIS7E0kAH6SJQgN6V/9GF5cf
         sozAvpNtq0KzG2IbxGfkUkEp+Ib/Gn50HyPv2MYOOGLKxQZjJ3ym9Zy+jiuhgVkGIxpW
         1ykm65LqZ7tmU0+qNZJZBTkrHeZh4Z5A1Xngdh+6PSgWu8sGhkduCTSQG653ea91pQbu
         VqBRsEEnjjb91AZMkYQ1ZP3YI+wjgbQCn1nS6z0ciWrq4yRkKm1kIk5aPFeyy2kPxe/f
         3PBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=vabVJLvPmcjnxX58SbBYjQSZ52U2HSgPreDRXzqMmVI=;
        b=o3haja/CT99c7apt+DYfxN1xEK7lf5NPz6C4V52ZfjV/etQNyjeGi2g4V5X52X5//l
         V/2QAFyejxSXjgbj0eEzKw143adKshpky8tYTkOv1D4pOVQ5FYJmV7pAR3L3eZ3TIfYT
         N8Htx3vaoIerWFu0oVMJ2enh4iYPw69hf+QWkNhMenfNzvuzmJrTV3AeVlioiSrP32eN
         +5BM2X0SiZ6HEMowOzEeO/+QvtYxq6ijQXeibUUmc+MCLLhuRN5wNdsDuntbF0wLvdzb
         Ka1Qq7pm71ASXEVWt1W7Bo6DxU2SWsE3Vss0sgWoOBsYv+bzbzLABtX0+HVcsynoMlk0
         fsSA==
X-Gm-Message-State: AOAM533zQzSAROs9f+INWTFYJ32aB7uneC7PXFUmKpstW0nIZ62nmuis
        aDoVeCs0kAkGUOj60ASii1I=
X-Google-Smtp-Source: ABdhPJzovNR3I1l7ZvkIPXslCAdnD23i+rCtPlddGSSVtt6ZOxXebWh77KX8UYZfdWM/j2K3DGpp6g==
X-Received: by 2002:a17:906:3c56:: with SMTP id i22mr14045374ejg.287.1631553738451;
        Mon, 13 Sep 2021 10:22:18 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id f22sm3812721ejz.122.2021.09.13.10.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 10:22:18 -0700 (PDT)
Date:   Mon, 13 Sep 2021 20:22:16 +0300
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
Subject: Re: [PATCH net-next 6/8] net: dsa: rtl8366rb: Fix off-by-one bug
Message-ID: <20210913172216.e2khiccsfxbaxdu7@skbuf>
References: <20210913144300.1265143-1-linus.walleij@linaro.org>
 <20210913144300.1265143-7-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210913144300.1265143-7-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 04:42:58PM +0200, Linus Walleij wrote:
> The max VLAN number with non-4K VLAN activated is 15, and the
> range is 0..15. Not 16.
> 
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

What is the impact of the bug? Should it be backported?
