Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02F74555CF
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 08:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243674AbhKRHnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 02:43:40 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:49386
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243729AbhKRHnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 02:43:18 -0500
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 0E3AE3F197
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 07:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637221218;
        bh=6O/A/IhU2XeX9QN2oJl3uiU3cJm6GUQ4n07BCEIs3FI=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=Mjdk6P8uVHfBXLKON+R0N/2qsRDAy823Y/xqrt/58DvEivVDZdFNvFOOfwezNu3E1
         9HIRQ79FJP2/FGY7APXb07toxEIw448N1oC/hpeCi2USjhq5mx8GKTMk/IwvzKRezy
         +O/rRPwMpiym41IoYKOZJvlXbCmWKEm0ZJ8tR2jtMN5KfD6Mjxkki3kkkTaqsAY9rd
         FM/bdqKdR8vs1v6AduNOQSr3joHi8Q4bKpdxtg+kmFDFmk0N/Aas3z2QL5Yg+hIggZ
         A7oFvC0hO4spBZA5MxZIB7KOVrj2SrzFT3jTyk/6NJQPV/y/WU6kJiT3Hxyx1EI12u
         cBdlxFPhcCuGg==
Received: by mail-lf1-f70.google.com with SMTP id k5-20020a05651210c500b0040934a07fbdso3376733lfg.22
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 23:40:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6O/A/IhU2XeX9QN2oJl3uiU3cJm6GUQ4n07BCEIs3FI=;
        b=l+TCEQqqpTok1+gIYveLEFHN8zo5ZYn3S8EHhpcF8q1LWEgkel4+UVJ+bVgPuM/gxu
         z4WWh0WEn4QL02XS6tFkjnTsjuZT/D8uDOEz7FT2QG6dskb6fS0DLEHH50C5nJg5w6No
         EKmKhXghoYFqppOi/hjyNwHFRvsitxd7JuvvPkgXt4ubRDsNCFjw8veX/9hAT9fvObte
         Cqc8O+oyZKWTSPiASNpc3/rDY9s78y0MXHL72nm+6d7KlXYSWvIEP23gVIZ7q0rVufif
         GHPvkYfpF2qBpUaDCx0pRTJYisiEZySQSLVHLYsSAxDWy008Cvz8K+461AQFldUv0d1F
         ZL9Q==
X-Gm-Message-State: AOAM5338rvjXibCHYHvFDHNEc0g3RF85LPJ30L2XipdeF2E09QZ654Yb
        8C0TalY3RHNQ52vpqu/UqGVXhsCxIlzd+I/roHlv0tnkbRzRnqzVIDJB92Xyuhx3/CVMTnIchPk
        i/NH7ImjzHqq9m9h+SJgO5k/KWlmWgLePmQ==
X-Received: by 2002:a05:651c:2123:: with SMTP id a35mr15191913ljq.174.1637221217551;
        Wed, 17 Nov 2021 23:40:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzYyujL48SlrjMMONApWRnv27oqukk19+pBLjhDOBjnbg/qDDNCUWm7BY38HQ6cjBUqNBMsLg==
X-Received: by 2002:a05:651c:2123:: with SMTP id a35mr15191883ljq.174.1637221217276;
        Wed, 17 Nov 2021 23:40:17 -0800 (PST)
Received: from [192.168.3.67] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id r19sm213195lff.207.2021.11.17.23.40.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 23:40:16 -0800 (PST)
Message-ID: <879d53ad-1819-d556-3403-daf26b08ba41@canonical.com>
Date:   Thu, 18 Nov 2021 08:40:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v2] nfc: st21nfca: Fix potential buffer overflows in
 EVT_TRANSACTION
Content-Language: en-US
To:     Jordy Zomer <jordy@pwning.systems>, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20211117171706.2731410-1-jordy@pwning.systems>
 <20211118070426.2739243-1-jordy@pwning.systems>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20211118070426.2739243-1-jordy@pwning.systems>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/11/2021 08:04, Jordy Zomer wrote:
> It appears that there are some buffer overflows in EVT_TRANSACTION.
> This happens because the length parameters that are passed to memcpy
> come directly from skb->data and are not guarded in any way.
> 
> It would be nice if someone can review and test this patch because
> I don't own the hardware :)
> 
> EDIT: Changed the comment styles and removed double newlines
> 

Same comments apply. :)


Best regards,
Krzysztof
