Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4108C426824
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 12:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239853AbhJHKsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 06:48:46 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:45566
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230041AbhJHKs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 06:48:28 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id CD35B3FFF7
        for <netdev@vger.kernel.org>; Fri,  8 Oct 2021 10:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633689992;
        bh=3cr8zX2dAw0svXJgbkiM05M80BJoKzttTWvDR09S5uE=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=gm0rs+jc3biAtr3QvDCH2JyBuKWp5oBSsXuxLulfjZWtVPYuz4xklNEGJzsMYRqKc
         i5OxJk/5ww9GLueEEZp8KpfCWGg0FBmuyQ46Gtc7xFqSHYE0AA8zM3SRCBattWlgJK
         jhB9ZEMNI9nTRYrIfXAXASeVE65VoXHi2E4jbfZCmqNHWlFKl6R/HgVAjbENK/3nug
         JTLusBJXM8BZeq2fA/r+iTRG2mvx0aaZD7xNaBiwgM19ZAvK/oZ7QkgIIUe+gdsByF
         w4ccjHPcNBrRwCnfy/wT52ofZurbiUd+3hcB0hEJ/RpMdm6A4RljZoYYg/132hH/NZ
         o+fzM5tKCzP8w==
Received: by mail-ed1-f69.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so8764884ede.16
        for <netdev@vger.kernel.org>; Fri, 08 Oct 2021 03:46:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3cr8zX2dAw0svXJgbkiM05M80BJoKzttTWvDR09S5uE=;
        b=XbkOR6+3yaaij2zh7cYaTvBSqSJyte8xwEu5uhkxRYtJEbycaFoES0K3XCsqMOQPCK
         HtssDGJtbR9MzO0+0u5u0mE2GKeI4sV/Q6QUWfSVbLMcyU/TOkIq6ZZpTD+ZgsFEMvhh
         tQmbLWcX8sBWH/8FqeKrn7Q/RRtjo8GtReTfq48w11HbeRcgKGF725muKBx/PlWt/KDs
         uVG7G0XqmeTXvs1030bbKEohwoS5TVyMHFDDFLsExYocSRTE4lQblCNt5qDYcSodqO2y
         /WeuMQOKn84txUgv4Zh35CXb0Y+5/Ejlt2MC9JvZALeaa/IEd+TymlsnGjohoKeHJjeG
         QmiA==
X-Gm-Message-State: AOAM530sLN5u8aPiZniYXR/obab9GPTg1ZpAhRK8OBe2PQRBK86e5cHQ
        YD/w4SvPwvCtZd2OPVSHkUEpKGrtmCXbzr9+4hc/ko9S/kQVhfSS9Qya2ey/AdKp30M8uS7nokN
        dmtX0nPrfJnKehObyjuKYcx/bvnUzYnyxkQ==
X-Received: by 2002:aa7:cd90:: with SMTP id x16mr14673686edv.148.1633689992417;
        Fri, 08 Oct 2021 03:46:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCnuwvEp45zrynOfgAiJNTLTmF14F6ci1bs8PUwWz6ORr06pt51TTTkRL3uoEToyDmY4LVUw==
X-Received: by 2002:aa7:cd90:: with SMTP id x16mr14673660edv.148.1633689992271;
        Fri, 08 Oct 2021 03:46:32 -0700 (PDT)
Received: from [192.168.1.24] (xdsl-188-155-186-13.adslplus.ch. [188.155.186.13])
        by smtp.gmail.com with ESMTPSA id y4sm324097ejw.3.2021.10.08.03.46.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 03:46:31 -0700 (PDT)
Subject: Re: [RESEND PATCH v2 2/7] nfc: nci: replace GPLv2 boilerplate with
 SPDX
To:     Joe Perches <joe@perches.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
References: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com>
 <20211007133021.32704-3-krzysztof.kozlowski@canonical.com>
 <34cc3eda06fa2e793c46b48ee734fd879e6f8ab1.camel@perches.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <9669a6cd-77de-ca0c-153c-75b531bd2490@canonical.com>
Date:   Fri, 8 Oct 2021 12:46:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <34cc3eda06fa2e793c46b48ee734fd879e6f8ab1.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/10/2021 12:33, Joe Perches wrote:
> On Thu, 2021-10-07 at 15:30 +0200, Krzysztof Kozlowski wrote:
>> Replace standard GPLv2 only license text with SPDX tag.
> 
> Nak
> 
> This is actually licenced with GPL-2.0-or-later
> 
>> diff --git a/net/nfc/nci/uart.c b/net/nfc/nci/uart.c
> []
>> @@ -1,20 +1,8 @@
>> +// SPDX-License-Identifier: GPL-2.0
> []
> You may use, redistribute and/or modify this File in
>> - * accordance with the terms and conditions of the License, a copy of which
>> - * is available on the worldwide web at
>> - * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
> 
> See the actual text at the old link which includes:
> 
>     This program is free software; you can redistribute it and/or modify
>     it under the terms of the GNU General Public License as published by
>     the Free Software Foundation; either version 2 of the License, or
>     (at your option) any later version.


Thanks Joe for checking this. Isn't this conflicting with first
paragraph in the source file:

  This software file (the "File") is distributed by Marvell
InternationalLtd. under the terms of the GNU General Public License
Version 2, June 1991(the "License").

This part does not specify "or later".

Best regards,
Krzysztof
