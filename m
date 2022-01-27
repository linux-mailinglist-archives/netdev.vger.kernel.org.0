Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F26F49DB9E
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 08:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbiA0HbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 02:31:01 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:35436
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233852AbiA0HbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 02:31:00 -0500
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9E5FA3F1B4
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 07:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643268659;
        bh=K9pKlwHH8BUvXPsrFd23VascNmFC+AtE0oEE3TMapTw=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=BZW2BC3K3XnlunZaox4KNomDGAoDKzgU274awylWWG3k/EcBbXToqjhCsmVi8M7h1
         gyB6JG8V+eHhFH7uHGXTgo6NCaug/zOOzC7tNW75/o9y4j3RPw3a4jJkCHLOu5z82S
         BU0Z54/Ahjhy+SxZQCimKoX9V1/oH0A2QR0aLKZj86gXLoTAkEuzwfxdsYfhc4QBf/
         axNJulK9KPryIJLf7nBmLz6PCjj0Ar/DUO15F0XeUJddE+6l5PWKSGn8AbUd7AL9YG
         NPXJRSRkfwbPleYf0gxoiWBBU7kRcAzIv3WL5YZkwSbCrzSfMjaTeqvCRIxMBE54X8
         DQydNiXVv4MmQ==
Received: by mail-wm1-f72.google.com with SMTP id n7-20020a1c7207000000b0034ec3d8ce0aso1077655wmc.8
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 23:30:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K9pKlwHH8BUvXPsrFd23VascNmFC+AtE0oEE3TMapTw=;
        b=NZbU1YhCgk1LXy6gdiRLNyNWqDA4yLg6dISX8tgzHA4MorcT2fPwQpM57sIEq9D0xX
         4bDjYjid8dvcFDX4i8CkeXM7Z8MY64yPeqaEqJsqkR+iy8wXXoC8Jh409f/AMAD6dEbf
         0fe/VzyKbvZ6H03gKxbkNOyGtOzh3qPR/CZuR+5JPQSxB1+SQb4HP/T7dkX34Z7o73fU
         TvnuQPEazURGvWofKWw4eTSeSYw0fI3oCmgUKKq2BDCBLtzT/HPj5r3abBYohYE2bclt
         CPxSompeir320XXcfcT81JvGMZ89U5k7pgR0M2WAr/NeRcJ75i9h3BKSXhlD34B2fddT
         lwIQ==
X-Gm-Message-State: AOAM533JFfpZ6vRCK3mGLQ/L7xdxjL38qLmzP155YvAGu+8/aMo3+npq
        Qb6KTdYV+M7eMalK0HzWewJxGN9Ct4qYvyinEuyrzUigd10rlpG+PzwHrGKeQ8KBMTJnH+wWhcM
        ccxID9RdWN4beEXkEX1Jmba87Ccf/S8Uefg==
X-Received: by 2002:a05:600c:507:: with SMTP id i7mr2063239wmc.40.1643268658657;
        Wed, 26 Jan 2022 23:30:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJybPdicnDDdxpVWWLaPKezySdArk9jv1vKg2D4syhmvh36/k0jiyfRWNxQWRaLWX5jTO2cgxA==
X-Received: by 2002:a05:600c:507:: with SMTP id i7mr2063226wmc.40.1643268658438;
        Wed, 26 Jan 2022 23:30:58 -0800 (PST)
Received: from [192.168.0.62] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id bg23sm1616501wmb.5.2022.01.26.23.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 23:30:58 -0800 (PST)
Message-ID: <051a3220-e81b-fb91-a11b-7057f47a9beb@canonical.com>
Date:   Thu, 27 Jan 2022 08:30:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 02/15] nfc: use *_set_vendor_cmds() helpers
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, wengjianfeng@yulong.com
References: <20220126191109.2822706-1-kuba@kernel.org>
 <20220126191109.2822706-3-kuba@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220126191109.2822706-3-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2022 20:10, Jakub Kicinski wrote:
> NCI and HCI wrappers for nfc_set_vendor_cmds() exist,
> use them. We could also remove the helpers.
> It's a coin toss.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: krzysztof.kozlowski@canonical.com
> CC: wengjianfeng@yulong.com
> ---
>  drivers/nfc/st-nci/vendor_cmds.c   | 2 +-
>  drivers/nfc/st21nfca/vendor_cmds.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
