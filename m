Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33FB1BD97F
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 12:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgD2KY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 06:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgD2KY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 06:24:59 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C6AC03C1AD
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 03:24:58 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id t14so1812226wrw.12
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 03:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iXQizAN15vmkFr5UmCuVlZeWN/hx4vVTXbmcBldyYF0=;
        b=hjpd6ZDirs1V9DZRh+sELbAc0Dg3SIqRPFeEj56PCS3rfdwiCf3fT8aA24VoLdkyA9
         QoizmmyU5EX+yvJO3E3kwGPXJqv70qqAG4fdJdxCkje95WGpAMfzmDnsVp5zjvzYdWHi
         n7SaK1YR8c3cn2nEL6DdY+XBqrDBFcBJIhV70=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iXQizAN15vmkFr5UmCuVlZeWN/hx4vVTXbmcBldyYF0=;
        b=Jh9ZwVrRSCQl08jHplzXq7JDUyI7mylOBEr4aoOtTz6RKl2593SaRVaF3OGPOYSgnr
         4NjW8cFpmRWqeQwmThWaazDs68X+2uovb0VJIpN2LCKII8UF27WrdXh+QDF3GNBezfnz
         njxtf6H/ab06vzn23jK+pJ9D7pKWuuOIVRcV5KGsQQdtf6GmxxPQhx2oedB5qZje1UHn
         Kqx1rITDfGcRai1SNR0sP5bYL+jW32jAhVTpMja1ikhPMXn2iL7T0d4n6xlpV9vbp/Uz
         QetGmuB8ov9Ot6byByvl8xTRAmJ9lboX7aWlokHuB+hyxLzuU65N5izLDSbgYs2cCN4j
         qWWQ==
X-Gm-Message-State: AGi0PuYQb9bXQaObLi2zVn/63uRaPRfrx6+naxsyjlBxv0lyl/UZynS2
        VnOREUxadfVT1JJMFZXW2LoZdA==
X-Google-Smtp-Source: APiQypJ2tyaiTUpDANlX9X3wZViAkc82v+L2T+OCcWUQA++Fc2QRS/hgVPrNi3lySBHuXzZQ9AT/sg==
X-Received: by 2002:adf:e8c4:: with SMTP id k4mr37119329wrn.209.1588155897352;
        Wed, 29 Apr 2020 03:24:57 -0700 (PDT)
Received: from [10.230.42.249] ([192.19.215.251])
        by smtp.gmail.com with ESMTPSA id a10sm18955868wrg.32.2020.04.29.03.24.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 03:24:56 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: no need to check return value of debugfs_create
 functions
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200429101526.GA2094124@kroah.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1a9ed45d-ca55-00af-6598-4c5499e4dc24@broadcom.com>
Date:   Wed, 29 Apr 2020 12:24:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200429101526.GA2094124@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/2020 12:15 PM, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> In doing this, make brcmf_debugfs_add_entry() return void as no one was
> even paying attention to the return value.
> 
> Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
> Cc: Franky Lin <franky.lin@broadcom.com>
> Cc: Hante Meuleman <hante.meuleman@broadcom.com>
> Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> Cc: Wright Feng <wright.feng@cypress.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafał Miłecki" <rafal@milecki.pl>
> Cc: linux-wireless@vger.kernel.org
> Cc: brcm80211-dev-list.pdl@broadcom.com
> Cc: brcm80211-dev-list@cypress.com
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   .../net/wireless/broadcom/brcm80211/brcmfmac/debug.c |  9 +++------
>   .../net/wireless/broadcom/brcm80211/brcmfmac/debug.h | 12 +++++-------
>   2 files changed, 8 insertions(+), 13 deletions(-)
