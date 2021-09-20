Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228604118B2
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 17:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbhITP7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 11:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbhITP7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 11:59:45 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060FBC061574
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 08:58:19 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so15524231pjc.3
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 08:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PC1082so6j4zeqaFx3vA+JRnwTyDJ5U8JYJNv0kxl7Q=;
        b=PZGqpl2kju21asy10bspSvFckQjb4GgNUMkrUtNQQxOc9ARJ0dOOJCGrHfreN4yykh
         NLFVCVLdWyOK+6V//lE8XbgqUfovxx78H6veRlhx5Ie+ODVTIMRSVz6nzErBCLksdE1t
         nJsKDXbe830cwfg50+uKRo4MBlWoI3DM1MTzyzWMWUOSlRLp7NE7eDMMBd4NNzgywRJd
         fhXhcdB7tNgTNMzLGiDGXX8zElHgxwpkdJ/w7n4WD8g1mbDxsPttK1KZ0CiCjIdcFoKt
         o8AuZZy3V45cnc7dpBv3heJ4ON3odYVqzzDclnY1I15UUwWy1Cba6IkGJ90Xt1QGaU5U
         MMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PC1082so6j4zeqaFx3vA+JRnwTyDJ5U8JYJNv0kxl7Q=;
        b=6q1Yx/JiVMcAsgksDUgLMfB7hOd+4+1j00gV9yUyS9PSKEV9s5KTC3lWdhwjZE5gwX
         ePlm85emer+fJIdfGvYAx7VyaQRv6Hsr0VMtv5mLAwTY1NxcFynbskGxwTHPewa5ThhF
         s8PO7YSUGgpc2ston1ahwZi+e8PvXdMcBl+Z6cst1VZNExVlyxl49KSF8U/hnC5hrRPY
         4D9DGlBBg8MQiYqoGMykt4kB0FnwdjXQk+euNiPKtUKDRov4O7m2BtlGTD3xhcD92A7w
         mm5ungCCN5f9sQdvdPcoZB3SLG6n/YQ2irWm7QmVFyNRU/Bo561uA4OJi5u7KTNhj9Ll
         fXsA==
X-Gm-Message-State: AOAM530MamOZAgq+arvL+CPndN50xT5CjLi/rdCifxnrc38n/iE20weg
        EubshXQ0fup/TJWMSqtPCmxgi8+KffU=
X-Google-Smtp-Source: ABdhPJytIiuok1Lt6DNSmvb/o4uYeJe3Vs+TfVs/QAxhROv2z2A1q9HgSvBmd2F0/XVkZ+dbW8mWUA==
X-Received: by 2002:a17:90b:1644:: with SMTP id il4mr13101768pjb.43.1632153497330;
        Mon, 20 Sep 2021 08:58:17 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s5sm16976560pgp.81.2021.09.20.08.58.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 08:58:16 -0700 (PDT)
Subject: Re: bgmac regression: hang while probing on BCM47189
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Network Development <netdev@vger.kernel.org>
References: <CACna6ryn-gmGm0uKEd_gfNgLkGTNdKi=J=Akz5tp4nZGcZB9gQ@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bfac8ad8-a90e-f075-5ec9-a91f678423be@gmail.com>
Date:   Mon, 20 Sep 2021 08:58:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CACna6ryn-gmGm0uKEd_gfNgLkGTNdKi=J=Akz5tp4nZGcZB9gQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/21 5:44 AM, Rafał Miłecki wrote:
> Hi,
> 
> commit 34322615cbaa ("net: bgmac: Mask interrupts during probe")
> caused a regression on my Tenda AC9 router (BCM47189 SoC that belongs
> to the BCM53573 family).
> 
> Calling bgmac_chip_intrs_off() that early in a probe function - for
> the *second* eth interface - simply hangs my device.
> 
> I didn't see any problems caused by not having that call in the first place.
> A solution seems to be also to call bgmac_clk_enable() *first*.
> 
> Should that call to the bgmac_chip_intrs_off() be conditional? Or
> should we reorder bgmac_chip_intrs_off() and bgmac_clk_enable()?
> 

Most definitively, clocks should always be turned on prior to any
register access. On most platforms people don't even notice because the
boot loader does not care to shut down the Ethernet controller's clock
at all.

Do you mind submitting a fix for that? Thanks!
-- 
Florian
