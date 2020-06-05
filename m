Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646941EFE02
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 18:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgFEQaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 12:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727887AbgFEQaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 12:30:14 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7863C08C5C2;
        Fri,  5 Jun 2020 09:30:14 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b16so5119946pfi.13;
        Fri, 05 Jun 2020 09:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yOY+RGQ0y8NLKWiTC9Vwmd3IeabzmeWUib2nuwEKtQY=;
        b=ikKSZJTJ0fRqF55OzXDBeGk+ozI4yYISs2QJE+MyHK9OZerySw2NkPIl3WouPPqCFn
         zHBM6tGtcPHj4p10MZ6qntjbfdi1wI/V8l809nuxg3uQ7ev+KDsCEUH+zZYSMSznaG4g
         cF4BNUXjOks7vDt/oSgNwSSf14Z4oNaE7sHb2qyI5b+pUUPWnX474diGEn0hhevtJqaC
         GMR7mYMVZoVnGPq5T1wicOLkxr9jcOyhX1bt4YdDFtTSCiXkVxqcisH0b1fn9mV61krI
         Iprvljjj/vMCgkiBO7L/69PjE3H5it3dQ2UxL9gWBUJiqM5gz26rUwN5kZma8bB2UB4+
         U4Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yOY+RGQ0y8NLKWiTC9Vwmd3IeabzmeWUib2nuwEKtQY=;
        b=NBWn0uLtiYXMQJOMFVqm94IW9NG6kjkKKN7Ldc24IxS6u6Qp33LNqL4+tpNasDp/iC
         xwrSZDnvubdkGYxNKC04/m4M8G+1LvAX2t1QGMmel9XSxE9vjVA6o+ShS0GploCdU8pk
         2QcR1Qql29xAnYSftPliNYSQBSbTtXkN8OMbP2otfkjk8FzFIQ1/hTgcaCCkEiYqz9PX
         t02I9JQBIMlkMDwtoHTcMHM+jlTi87GrU4jxvndQPkHRijz91ocoIG8vXiWzNOhwdPrU
         yzfQ9GRQRCLtWUS9czrpYRuZZw4mReHVs5l2uyUtxfnK684sjHWVtA8jGkrTdnH2IqF9
         64Kg==
X-Gm-Message-State: AOAM533Ijdmr4ybVQPB3HY76ydRNTgn0/jSa3/A4B8pNZwvt2rkONXbu
        /fERoNhjf2roJio7najfrNE=
X-Google-Smtp-Source: ABdhPJw+O3YvGEeP1Pg8F+acLN4e1QkI016yU12VHsBPYunFa517MHjfu4mNtwoahu4GX47rCjHuwQ==
X-Received: by 2002:aa7:9edc:: with SMTP id r28mr10058759pfq.139.1591374614357;
        Fri, 05 Jun 2020 09:30:14 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f29sm85786pgf.63.2020.06.05.09.30.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 09:30:13 -0700 (PDT)
Subject: Re: [PATCH net 2/4] net: dp83867: Fix OF_MDIO config check
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael@walle.cc
References: <20200605140107.31275-1-dmurphy@ti.com>
 <20200605140107.31275-3-dmurphy@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b64b10df-80d5-c862-ab30-2991fe76335f@gmail.com>
Date:   Fri, 5 Jun 2020 09:30:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200605140107.31275-3-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/2020 7:01 AM, Dan Murphy wrote:
> When CONFIG_OF_MDIO is set to be a module the code block is not
> compiled. Use the IS_ENABLED macro that checks for both built in as
> well as module.
> 
> Fixes: 2a10154abcb75 ("net: phy: dp83867: Add TI dp83867 phy")
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
