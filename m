Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6CD48C1F1
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 11:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349716AbiALKHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 05:07:30 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:55832
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349661AbiALKHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 05:07:30 -0500
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 6BC433F1EC
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 10:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641982049;
        bh=AFoEvp5eWcTOKPSE4vqU4Dm4wZS4JP2i5S4paCY8zig=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=DhPTLHtslM1nJL0+yJHCfEFe167fbm6XtOOvmUCTXWng6ZtSIx96BC3FHJ3hlpKwb
         JfwQd/MW4UBe6OyZYCKR1jbDp4BpIq+u50s436RHDP5prJGprVjw7+TtG5xJP2pI5K
         irA3G+aIdx0ltLgQAWHfp+Dwmc3Ddp508Zv4RW6HL6nH+3Otq6Zi7w+PgZz8WqqfFj
         4nYJHy3S2ccEdmjc9EzLt8CvV20S43L/7DvA+1gDKOdyr2DTl1++ZCqr/yMC5wHnna
         2E68zIvXQSCe9GdBZ1NUKTf+g5utqQPEd5xlbT97e9tFlnqofF/5QgPWDvLfXKZ3X+
         ezD40Hk2+TPWw==
Received: by mail-ed1-f72.google.com with SMTP id c8-20020a05640227c800b003fdc1684cdeso1822688ede.12
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 02:07:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AFoEvp5eWcTOKPSE4vqU4Dm4wZS4JP2i5S4paCY8zig=;
        b=McwIU3+B6tTcpqCm15oNWfyk2WGfRB/L6VyqtgUe6gfe1x9WEI0zeN1LxlHN0Fkw3J
         jgzrO9zhsfZLMvJrgv8wr5DXq7qf9aUrBsjfKpH/LVibuM0cWamFk55/3R7wRaVJKvSb
         msqR0q5QEKmckrTue6q1V2LiD5+jhhr9rHi6BRT+EUVDt8bGPV0ZJgNIeHGuRgZwZFPd
         CTM5LvT21zcHAYvQPDiicZaX21PUGDOexOOO1XgFatf+nce1J+trt7shnFPc6/FwS8Ch
         D8N7YjJ84Y0jsKCpm0lOixw+yvDH2ZsgDxJKSZbDtVNqTkxFvSNxPhALoPf305QC+ns8
         jygQ==
X-Gm-Message-State: AOAM531sugoX/wHAGhld7UESKwyE680wQXLGgltOVxwuYfN/Q7Vzuaqg
        t7VRu/S3BJkMFS/UL6A1kG1IKknhGIeQbavjFJKz42OJY9DWqszDY70Ickydhafy7CKL5UdVT7M
        E9s/2GxLu9gDemuXJcT4HL2Hz3QcPfOVTZg==
X-Received: by 2002:a17:906:2bc3:: with SMTP id n3mr7252234ejg.332.1641982049156;
        Wed, 12 Jan 2022 02:07:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyb/NuTKevzN07lPwyurPSJI67fCctIz9rq4OSgNTLHT/x3rRMME7Elc/Be6y3vkmR9tseimQ==
X-Received: by 2002:a17:906:2bc3:: with SMTP id n3mr7252215ejg.332.1641982048986;
        Wed, 12 Jan 2022 02:07:28 -0800 (PST)
Received: from [192.168.0.29] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id qf18sm2471944ejc.124.2022.01.12.02.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 02:07:28 -0800 (PST)
Message-ID: <38217570-9f19-2b04-6ed0-89f365e29d5f@canonical.com>
Date:   Wed, 12 Jan 2022 11:07:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3] nfc: st-nci: Fix potential buffer overflows in
 EVT_TRANSACTION
Content-Language: en-US
To:     Jordy Zomer <jordy@pwning.systems>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, wengjianfeng@yulong.com
References: <20211117171554.2731340-1-jordy@pwning.systems>
 <20220111164543.3233040-1-jordy@pwning.systems>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220111164543.3233040-1-jordy@pwning.systems>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/01/2022 17:45, Jordy Zomer wrote:
> It appears that there are some buffer overflows in EVT_TRANSACTION.
> This happens because the length parameters that are passed to memcpy
> come directly from skb->data and are not guarded in any way.
> 
> Signed-off-by: Jordy Zomer <jordy@pwning.systems>
> ---
>  drivers/nfc/st-nci/se.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 

Looks ok.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
