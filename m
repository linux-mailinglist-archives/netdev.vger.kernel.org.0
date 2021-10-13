Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9689B42CE0C
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhJMWcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbhJMWcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:32:05 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B738C061753
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:30:01 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id h196so1525731iof.2
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9VxMpERwcZ4xYpWC2uQ0LTIQ1eQf4C6GAkgZ6JNwhAU=;
        b=ZUnbkll+NeOlj4vECmVUOxQmkzvLTiP9awdIYrvS7dQVXagLA6gjiIx/6sDUo0U55C
         586bE5OdV9vW8AdNdy2/I1QPjSjvyVklmxA3GUPLk7KXyJyEkC96S3b8WT4se2uoC3oX
         3vtJ5mGzQfyqp+o/A5oL0R4yJEZ8cLpfCYEAU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9VxMpERwcZ4xYpWC2uQ0LTIQ1eQf4C6GAkgZ6JNwhAU=;
        b=TOeSM65bI6y359uj+klxrTW5W1D5gKZXw3+Yy0qIdhhpqdxNSwj0x/X0vRLpXuFEQJ
         tVyJlIwG7hJBkzmmwhWlMH7CzZGVWDPXkzA9H5ODmDKfmY1Nt1riT5k9Q4URJhRzH1wQ
         rjeMxwiezmxQBvGFidBAQqWz3TKs4tTGd7DSCSQ5Gqq3/kFcNlNaTeW4XxQopmr7HcFG
         sxD9VACC/0mLW62HSHIHo3WICUgihfSfASQHyWTyxQBsrOZ5wTUyvwvIN98zVzL+hbl+
         j5MkfDo2cEqWqHQ6nBbxpRLynT6C74aAjcfU/G0VjSUvj+aTtPviDZD47RPOq3RFnpOh
         JTUQ==
X-Gm-Message-State: AOAM5330bW/4SXtZte+JtWliwSwTdBFj1GiFgiHh4qeB+LU+wv0zMGve
        clhwB93EF476wfsvsYxfA+3sFQ==
X-Google-Smtp-Source: ABdhPJwWZ0hVrUwMUCZk2xLiuhA+jc3JfSizQWF8/3galc/P07X9S7bFStovtL3JCmxnfwo8xLETZw==
X-Received: by 2002:a05:6638:258e:: with SMTP id s14mr1517643jat.54.1634164200602;
        Wed, 13 Oct 2021 15:30:00 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id w15sm377481ill.23.2021.10.13.15.29.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 15:29:59 -0700 (PDT)
Subject: Re: [RFC PATCH 08/17] net: ipa: Add support for IPA v2.x interrupts
To:     Sireesh Kodali <sireeshkodali1@gmail.com>,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Vladimir Lypak <vladimir.lypak@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
 <20210920030811.57273-9-sireeshkodali1@gmail.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <356e77b6-7a90-a75b-7ee8-33d8c92ead33@ieee.org>
Date:   Wed, 13 Oct 2021 17:29:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210920030811.57273-9-sireeshkodali1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/21 10:08 PM, Sireesh Kodali wrote:
> From: Vladimir Lypak <vladimir.lypak@gmail.com>
> 
> Interrupts on IPA v2.x have different numbers from the v3.x and above
> interrupts. IPA v2.x also doesn't support the TX_SUSPEND irq, like v3.0

I'm not sure I like this way of fixing the interrupt ids (by
adding an offset), but it's a simple change.  (And now I have
a better understanding for why the "fixup" function exists).

					-Alex

> 
> Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
> Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
> ---
>   drivers/net/ipa/ipa_interrupt.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
> index 94708a23a597..37b5932253aa 100644
> --- a/drivers/net/ipa/ipa_interrupt.c
> +++ b/drivers/net/ipa/ipa_interrupt.c
> @@ -63,6 +63,11 @@ static bool ipa_interrupt_check_fixup(enum ipa_irq_id *irq_id, enum ipa_version
>   
>   	if (*irq_id >= IPA_IRQ_DRBIP_PKT_EXCEED_MAX_SIZE_EN)
>   		return version >= IPA_VERSION_4_9;
> +	else if (*irq_id > IPA_IRQ_BAM_GSI_IDLE)
> +		return version >= IPA_VERSION_3_0;
> +	else if (version <= IPA_VERSION_2_6L &&
> +			*irq_id >= IPA_IRQ_PROC_UC_ACK_Q_NOT_EMPTY)
> +		*irq_id += 2;
>   
>   	return true;
>   }
> @@ -152,8 +157,8 @@ static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
>   
>   	WARN_ON(!(mask & ipa->available));
>   
> -	/* IPA version 3.0 does not support TX_SUSPEND interrupt control */
> -	if (ipa->version == IPA_VERSION_3_0)
> +	/* IPA version <=3.0 does not support TX_SUSPEND interrupt control */
> +	if (ipa->version <= IPA_VERSION_3_0)
>   		return;
>   
>   	offset = ipa_reg_irq_suspend_en_offset(ipa->version);
> @@ -190,7 +195,7 @@ void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt)
>   	val = ioread32(ipa->reg_virt + offset);
>   
>   	/* SUSPEND interrupt status isn't cleared on IPA version 3.0 */
> -	if (ipa->version == IPA_VERSION_3_0)
> +	if (ipa->version <= IPA_VERSION_3_0)
>   		return;
>   
>   	offset = ipa_reg_irq_suspend_clr_offset(ipa->version);
> 

