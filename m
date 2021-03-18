Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E13340FE6
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 22:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhCRVdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 17:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbhCRVdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 17:33:12 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46142C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 14:33:12 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id o11so2288843pgs.4
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 14:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ro8Sjh5Wsy2O8WdpXIggi8sTffLOCBxeS6BGtMQyLbA=;
        b=SMhxJGmbcvYnMRBdnO5ENiO9PkTSDiewUFWJnuRiXHsyHT+HMAKzbuHI97sg6FH6o8
         5NHbhxDm2t1H4NPlp7b4umoVoiy2F8GG6gZcIjsHpsjZeH48uyVcgyGIjxqOBVsl7SPR
         k7yVUslyOJg/mm9hYvFxCsBt0Qjhp2oew/D/94C+TieK3rpY1Xu6b66pzlIMzuZC0HtQ
         /Qmk+9ZmL+FPP7HuI0Y9TXBpkztwbe2vt/Fi1JLXBkXxH7+4kU+rFNamPHCU8rC9U+Yi
         +Tub/s8nbR9oQoZLX3mtVbKNXpJ5Nkc2Ld+KqY84Dmr5OMPimXfn3oCHvvoleFqTtJTe
         943w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ro8Sjh5Wsy2O8WdpXIggi8sTffLOCBxeS6BGtMQyLbA=;
        b=YXs0iZoz/gyhvgNjxwGew2CGKnsNogkgQpFaikhuPJfHyIjZZ50tJhsufns32Ufdx2
         viBbb3ec4pDSnUYBdHwngl/b3GxVvGQhfhkN29Hhpseg3m4qeWdOVQxxy5L7NumP/1mW
         PFhhabIjwPCy0OoDLp+pIfVj1YgGIE8c7QPVPYk4hgnTJVEPapjaJtM9iEcrI/fau9/a
         AskFDzzbb1OvehICjBoUX+lTxQ1kfHGLUsPATb3/mtmPVx2YPyiK/paLkK+iInWI8aE8
         I1sMSvfV6xqsC4HftHYxiE1o68Zlqlh8B5VXecrCUAzL8n33sgxkHSUbI32BFiix0fQI
         HgGw==
X-Gm-Message-State: AOAM530njMgX57JkSGf2aQzqg/m9OJybWyB1ivNcX87azZa3O0L+6fzm
        pCtYzgG3jpyvnBBexOLdG1M=
X-Google-Smtp-Source: ABdhPJxf9kLfBdTVasx16Ox3tJN2jhoeSKT3G+BMH3yAVCDOOV3T4CoB0DBJ34hHyuYz2+sSixdnyQ==
X-Received: by 2002:a62:b50a:0:b029:1ef:1ee8:1164 with SMTP id y10-20020a62b50a0000b02901ef1ee81164mr6048121pfe.72.1616103191814;
        Thu, 18 Mar 2021 14:33:11 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l22sm3640634pjl.14.2021.03.18.14.33.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 14:33:11 -0700 (PDT)
Subject: Re: [PATCH net-next V2 1/2] net: dsa: bcm_sf2: add function finding
 RGMII register
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210318080143.32449-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5d0d3fba-a914-778c-79dc-8b0cbe29b3c6@gmail.com>
Date:   Thu, 18 Mar 2021 14:33:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318080143.32449-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 1:01 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Simple macro like REG_RGMII_CNTRL_P() is insufficient as:
> 1. It doesn't validate port argument
> 2. It doesn't support chipsets with non-lineral RGMII regs layout
> 
> Missing port validation could result in getting register offset from out
> of array. Random memory -> random offset -> random reads/writes. It
> affected e.g. BCM4908 for REG_RGMII_CNTRL_P(7).
> 
> Fixes: a78e86ed586d ("net: dsa: bcm_sf2: Prepare for different register layouts")
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
