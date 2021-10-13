Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA5C42CE04
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhJMWbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbhJMWbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:31:46 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF484C061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:29:41 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id s17so1455483ioa.13
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X4CJTc4Njf69DLLQxOgBO1lHglpI/hl2yPlJRwuWzH4=;
        b=GKNXrKfuutVxuw9BjFqKaV934w9FytkIThSKVWyp/OMlCbcFvbUphnoAl+jCqxvwq4
         NZFVtsYW+mWlrMxCf7Egoy12fy8Cywke0DDRdMgUxzi3QLRrZgL0plDrg3aFxjtZHbOw
         y5Km8Ms3y3EHGaLEtvlWG9+//KWMdm+cVEQQA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X4CJTc4Njf69DLLQxOgBO1lHglpI/hl2yPlJRwuWzH4=;
        b=CVqVkzEGo0t1CEn1y5fhd+yq6XBSdaAUvrwR34/wE7QaFJTW2BJdvEPsnPb/+9wexI
         BAO/KHNwpELOFW/lkmWSD5PeKRqQiW8fWOFz++RmVf9FaMV7fD8qCvLTNxVQIjRjkrup
         aiGxDbZfBB6jk3Xcj/oo3TUtvKTrgGDAdpeFvpCZLgtglPw890Mk7Cq0cTSTDPuk71Yx
         n9Ye6bIeI8U1DGiT7PD2/qAd5tzMNRACI00Gy++vXfCpF9H0SFnY76sHuSglALTpMSuG
         oBGYpixeJ2G778daevd0cPW6mZ5LcEUyyb2ZanG8RAbnxNvBI2tCqoaWVG/PtFnv4/V3
         FnJA==
X-Gm-Message-State: AOAM532mRp9SVzRcGXmcLvqdw6zmKFuJJ0YTMzn/xY87Ow0INMK0cE62
        TbripqchBvNbG7OKIbcfcnoCOw==
X-Google-Smtp-Source: ABdhPJwR8LxJQnXST8wIB5lHPFSxJpXHOmPZmhnDfDyd/IfQ0vxv32KmQh2G6XQR9POr0AIWfQ+PeA==
X-Received: by 2002:a05:6638:37a7:: with SMTP id w39mr1510508jal.19.1634164181311;
        Wed, 13 Oct 2021 15:29:41 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id v63sm369660ioe.17.2021.10.13.15.29.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 15:29:40 -0700 (PDT)
Subject: Re: [RFC PATCH 05/17] net: ipa: Check interrupts for availability
To:     Sireesh Kodali <sireeshkodali1@gmail.com>,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Vladimir Lypak <vladimir.lypak@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
 <20210920030811.57273-6-sireeshkodali1@gmail.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <445bb258-c07c-349c-e482-78b7b560e0eb@ieee.org>
Date:   Wed, 13 Oct 2021 17:29:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210920030811.57273-6-sireeshkodali1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/21 10:07 PM, Sireesh Kodali wrote:
> From: Vladimir Lypak <vladimir.lypak@gmail.com>
> 
> Make ipa_interrupt_add/ipa_interrupt_remove no-operation if requested
> interrupt is not supported by IPA hardware.
> 
> Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
> Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>

I'm not sure why this is important.  Callers shouldn't add an
interrupt type that isn't supported by the hardware.  The check
here would be for sanity.

And there's no point in checking in the interrupt remove
function, the only interrupts removed will have already
been added.

Anyway, maybe I'll see you're adding support for these
IPA interrupt types later on?

					-Alex

> ---
>   drivers/net/ipa/ipa_interrupt.c | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
> index b35170a93b0f..94708a23a597 100644
> --- a/drivers/net/ipa/ipa_interrupt.c
> +++ b/drivers/net/ipa/ipa_interrupt.c
> @@ -48,6 +48,25 @@ static bool ipa_interrupt_uc(struct ipa_interrupt *interrupt, u32 irq_id)
>   	return irq_id == IPA_IRQ_UC_0 || irq_id == IPA_IRQ_UC_1;
>   }
>   
> +static bool ipa_interrupt_check_fixup(enum ipa_irq_id *irq_id, enum ipa_version version)
> +{
> +	switch (*irq_id) {
> +	case IPA_IRQ_EOT_COAL:
> +		return version < IPA_VERSION_3_5;
> +	case IPA_IRQ_DCMP:
> +		return version < IPA_VERSION_4_5;
> +	case IPA_IRQ_TLV_LEN_MIN_DSM:
> +		return version >= IPA_VERSION_4_5;
> +	default:
> +		break;
> +	}
> +
> +	if (*irq_id >= IPA_IRQ_DRBIP_PKT_EXCEED_MAX_SIZE_EN)
> +		return version >= IPA_VERSION_4_9;
> +
> +	return true;
> +}
> +
>   /* Process a particular interrupt type that has been received */
>   static void ipa_interrupt_process(struct ipa_interrupt *interrupt, u32 irq_id)
>   {
> @@ -191,6 +210,9 @@ void ipa_interrupt_add(struct ipa_interrupt *interrupt,
>   	struct ipa *ipa = interrupt->ipa;
>   	u32 offset;
>   
> +	if (!ipa_interrupt_check_fixup(&ipa_irq, ipa->version))
> +		return;
> +
>   	WARN_ON(ipa_irq >= IPA_IRQ_COUNT);
>   
>   	interrupt->handler[ipa_irq] = handler;
> @@ -208,6 +230,9 @@ ipa_interrupt_remove(struct ipa_interrupt *interrupt, enum ipa_irq_id ipa_irq)
>   	struct ipa *ipa = interrupt->ipa;
>   	u32 offset;
>   
> +	if (!ipa_interrupt_check_fixup(&ipa_irq, ipa->version))
> +		return;
> +
>   	WARN_ON(ipa_irq >= IPA_IRQ_COUNT);
>   
>   	/* Update the IPA interrupt mask to disable it */
> 

