Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F197430ACC
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 18:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344217AbhJQQjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 12:39:53 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:48496
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242474AbhJQQjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 12:39:52 -0400
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 392D94005D
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 16:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634488659;
        bh=1RPm1/LKTSEH8C0YJx6dXoFgI89yVIC6crD5lgWAirc=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=GB/2jkttGiT2O3gSLZIsbwSllMctQKrSsyztzWsDbljlV5zNTSfTo35vCHi1wxUKR
         1bBlMY56nADKVeMt68W2CPN92cDamRoYIcOYm/I68xlenoO8tbWFW3Fg5u0CepcA2Q
         o2VUxAE4Xcf7IjayPdS+B/VtTVSjkZWLy9bkto7n3KyGKxN1mwMetIDefbDPC8bIlq
         XGM7hWB0xNa2J8d49mgDr9HW+VyfnHiasUDr3H98isGgsgEWF0vhNoBMy3Tjsp+keI
         p0bQORe73fZ8TR59UROSgM8qgfXvhU9qhqgig4fwkgPVkLlYvFj3vKhAGHHI+OENOi
         vGX1VAFqRmPqQ==
Received: by mail-lj1-f199.google.com with SMTP id s5-20020a2e98c5000000b002112895b3f6so493492ljj.21
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 09:37:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1RPm1/LKTSEH8C0YJx6dXoFgI89yVIC6crD5lgWAirc=;
        b=ixllKuWV7NJ3dum/2EoYd/stvpngYMh5pmJNFLPaB/l0s1kBKaCXtAOMHsQyqbs8tW
         yYNgk2sJ7fErXH5UCVM6rs5Fhz5pdpHTDtTxOmgMmx0smCi4FWD5DDsnA+pnHhk+mJ2t
         XwEvol/zMyirC6+g7qrl8UA/XpLF7gjdLwwSFPFAI1BcyBSEpJch70sIwSN1/z4C9xyj
         J4PPbMNsMWn2SCUrZ2qcmkXGozl0ro+BhwZveDkNigQOczGWVG9bYH2yYhMvr6jPEpOa
         eK52PvvFJ2VaLj+Y/8sr5WkcGBd5fEaLlFI5OTtXh1KrG9eANJzZ/KrfSGv1ToPbPCKV
         PMVQ==
X-Gm-Message-State: AOAM530fGr5yGYw8uGjja3dwNc+JHXDX0ttSiOM0bvLaPHkpKWIMku55
        vdbEshTv2KKheqRTEkpTyHW/pMjoSgGKZfZwE/yXglAp3NGJd5EjDv5SU0SrYbplllhgO/3kbPf
        aVRd5Wmm2re/ppMWwZwPh01cs/QeUL8FuLg==
X-Received: by 2002:a05:651c:204d:: with SMTP id t13mr23783987ljo.267.1634488658195;
        Sun, 17 Oct 2021 09:37:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/lqcEKlBCBJKXljOPkvtPOkonlr9+CwlLqnStL9xaA21H+RrX4917KV+h8+HiIpOwiDIgFg==
X-Received: by 2002:a05:651c:204d:: with SMTP id t13mr23783965ljo.267.1634488658014;
        Sun, 17 Oct 2021 09:37:38 -0700 (PDT)
Received: from [192.168.3.161] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id k23sm46262ljm.29.2021.10.17.09.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Oct 2021 09:37:37 -0700 (PDT)
Subject: Re: [PATCH v4] dt-bindings: net: nfc: nxp,pn544: Convert txt bindings
 to yaml
To:     David Heidelberg <david@ixit.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ~okias/devicetree@lists.sr.ht
References: <20211017160210.85543-1-david@ixit.cz>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <0937ddb4-7a5b-b6e0-d6b8-42a912744bd6@canonical.com>
Date:   Sun, 17 Oct 2021 18:37:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211017160210.85543-1-david@ixit.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/10/2021 18:02, David Heidelberg wrote:
> Convert bindings for NXP PN544 NFC driver to YAML syntax.
> 
> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---
> v2
>  - Krzysztof is a maintainer
>  - pintctrl dropped
>  - 4 space indent for example
>  - nfc node name
> v3
>  - remove whole pinctrl
> v4
>  - drop clock-frequency, which is inherited by i2c bus
> 
>  .../bindings/net/nfc/nxp,pn544.yaml           | 56 +++++++++++++++++++
>  .../devicetree/bindings/net/nfc/pn544.txt     | 33 -----------
>  2 files changed, 56 insertions(+), 33 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/pn544.txt
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
