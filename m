Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAE73BDC65
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 19:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhGFRii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 13:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhGFRih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 13:38:37 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15AF6C061574;
        Tue,  6 Jul 2021 10:35:59 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id e14so10033178qkl.9;
        Tue, 06 Jul 2021 10:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Uwfk4YkfYnLUY61LIrInzNWSqJf1Bvs7c1Av+mBNu2I=;
        b=E7/6U1xptRsZ3HKEB8jG1fXaffia6e6UTsGXHJ+63i9xCHv2a7ahnH55Rb5RXQSadV
         vVx1flieXFwDSwSdOut8jLqsG+4YbWkTzWOBeefu1cXWzEBE4eipDoHq9igGc+KK/QPB
         fe12IDUolDkw6/r2cjgNiMUo0bY2pMPpR3/ss3uwaOC7XCaEjsN0pz1EJz26smEZHCTw
         blq1gVnZIe0HEZu0J1RN8BAkaTI6aQ9GouT4UOQey+UFVUnf3Xe20xcZtM1hGXlVTE42
         q4KRW/LItVH89sktEgJeGNP9q54kYGt1yU+7pY7kcdZaqPn0SkavBQe870z6Xii65d1s
         rNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uwfk4YkfYnLUY61LIrInzNWSqJf1Bvs7c1Av+mBNu2I=;
        b=f2Vezkd5Mcr5tZxczdqfOM16pbWYPoxjCksRET8n+D3m7TddMhznvdYN1e+iIX9Zun
         IwoNYfjIEV2vKrmfEf3xwWkfsOeKF4bsLjcJivA43W/IGNzdDaON9WNv3zXc1J+Bp+Z9
         rLE0WcxfCAptKdFoURJpWih35cQKKsfYguKeoE79Z1Mj1eeFntZShPnRWH0ikNFFAMsI
         3JxfqhPoGkf1Zp1jJZhkiRjWVgCfq7lLNavS/kQpP2smAAPlA3t60h9y0Xg9RGv+vSGM
         3I16VFQ/00blh9q9rSA9zYxQYfyD+6x5sCbeI83I7v5G+a3tY3by1M28HY+zKgOlqmYT
         O2PQ==
X-Gm-Message-State: AOAM5323Sv6Z4PLJtoiZyxwCj8GhwWYViMDzQch4MVCD4biZVQD95mm9
        yVdYaYEZzjYMGdZU5/DRp5CSOw5vSGVGZw==
X-Google-Smtp-Source: ABdhPJyLuETifOOqasZegMMPnjZoasbg8/SIJEvlmxlvbPDrKji8v3B4r8DcvFcM0+fLAaHWmo+EKQ==
X-Received: by 2002:a37:e314:: with SMTP id y20mr20525746qki.289.1625592958134;
        Tue, 06 Jul 2021 10:35:58 -0700 (PDT)
Received: from [192.168.99.8] (pool-72-69-75-15.nycmny.fios.verizon.net. [72.69.75.15])
        by smtp.gmail.com with ESMTPSA id g76sm1919659qke.127.2021.07.06.10.35.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 10:35:57 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH] rtl8xxxu: disable interrupt_in transfer for 8188cu and
 8192cu
To:     chris.chiu@canonical.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, code@reto-schneider.ch
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210701163354.118403-1-chris.chiu@canonical.com>
Message-ID: <d32690a6-f679-c676-1461-10b47ae3428b@gmail.com>
Date:   Tue, 6 Jul 2021 13:35:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210701163354.118403-1-chris.chiu@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/21 12:33 PM, chris.chiu@canonical.com wrote:
> From: Chris Chiu <chris.chiu@canonical.com>
> 
> There will be crazy numbers of interrupts triggered by 8188cu and
> 8192cu module, around 8000~10000 interrupts per second, on the usb
> host controller. Compare with the vendor driver source code, it's
> mapping to the configuration CONFIG_USB_INTERRUPT_IN_PIPE and it is
> disabled by default.
> 
> Since the interrupt transfer is neither used for TX/RX nor H2C
> commands. Disable it to avoid the confusing interrupts for the
> 8188cu and 8192cu module which I only have for verification.
> 
> Signed-off-by: Chris Chiu <chris.chiu@canonical.com>

I remember noticing this earlier but never had a chance to dig into it.

Thanks for fixing this!

Acked-by: Jes Sorensen <Jes.Sorensen@gmail.com>

Jes

