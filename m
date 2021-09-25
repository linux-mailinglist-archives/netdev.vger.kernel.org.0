Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6A74183FC
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 20:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhIYSc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 14:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhIYScZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 14:32:25 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82E3C061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 11:30:50 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id l8so2217102edw.2
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 11:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=O5JwyRn1rbgSB0JM7MKHjqllh1/czrVl1yV1oflPmog=;
        b=a7TeUSV5R1s+z12ce+d7orRQK2AZUdFgDSRGrLMHXU4Aaou3dJkPEF6aGB2dOCLE2F
         3q+iNDusUWp9K3lg+03OPOyq4smgl/W51fqc2vq1S+mpSgWktmJSfBZUlZtXBojHFQ93
         lpH9iCBlt9QKPQ8zadzBZcPnVLefqkbu2Xej2LwrjL0Cf40FAQKQimZZo5zrhEq1kkny
         ptqJId9tCcnOuK9hwaXUS9nGWsWmqZsixyQIDTeu7Q7U0nrvSS1lAbkHVP/soNcJUYpF
         5N4rcm2QGmhAIUuhBFnZ4CH3lWnSIMzTeW92a4QyH5ifB+bQMeUzMe9ydihlnKKcFqif
         ZnKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=O5JwyRn1rbgSB0JM7MKHjqllh1/czrVl1yV1oflPmog=;
        b=Uw+WaN2zi+HUe549QMTZfMbVuZSfSQC9aV99d1QLNc1BARtjFQopMMTvKKqLJyRCN1
         TBP2kkVAdaeuI1MzcuE/zUZzViv8pNAEUQyc9w4UDf/3Ln3rmZ3duJ5o71q2apKBRF7R
         et2BP4lVSR20AaTsQKPtWCXcT57acdIUItqG8Gg6ejlOsh13OEp+nmEmErfsFqSs3372
         L1X96Cq71+ThYxwrDOa0xAkHZsuDPk3zWkXrjoAcAUUZbNKQT8Pm3oWo9voaWoPf+/E4
         9g7Hhko18QvX0YK69Yz+ebqYPQeKn3pTNe23bMGljPXa48TxfzUOueNbelaBSFAhl7dz
         ok8A==
X-Gm-Message-State: AOAM530nVu2Ptf3R+GEmWS1dRnHZSOSsd0bScfEUUuL49FTdvre9Aaby
        hLJLfAUrrGO7FzrJ0bmzrGc=
X-Google-Smtp-Source: ABdhPJx1dAj5/O99zyD+BPEchcze4OHx6FX9S5PXAm5YPTnT/ZRogj2YNqFOsenrQDjNaYH1cm7a3g==
X-Received: by 2002:a17:906:564e:: with SMTP id v14mr5414012ejr.424.1632594649312;
        Sat, 25 Sep 2021 11:30:49 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id d16sm6423770ejk.39.2021.09.25.11.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 11:30:48 -0700 (PDT)
Date:   Sat, 25 Sep 2021 21:30:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH net-next 1/6 v6] net: dsa: rtl8366rb: Support bridge
 offloading
Message-ID: <20210925183047.pzeotver2nfjpevw@skbuf>
References: <20210925132311.2040272-1-linus.walleij@linaro.org>
 <20210925132311.2040272-2-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210925132311.2040272-2-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 25, 2021 at 03:23:06PM +0200, Linus Walleij wrote:
> From: DENG Qingfang <dqfext@gmail.com>
> 
> Use port isolation registers to configure bridge offloading.
> 
> Tested on the D-Link DIR-685, switching between ports and
> sniffing ports to make sure no packets leak.
> 
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
