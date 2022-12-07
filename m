Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F3C645B94
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiLGN4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiLGN42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:56:28 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AF35BD44
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 05:56:27 -0800 (PST)
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 332DE44348
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 13:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1670421386;
        bh=AN5JF4JjPpOJkZ/tkyQphRahAoTXPLdfhR7No5Nhr94=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=jei3mGbblDEH/5cUMoQs+XxsOWdroGAdN8MOzYk/4MmToDd/v3XpTjLw36WVwO55G
         0sSfVTsv7nubsXdxEBXlwjey81B5Z5ZoMLpbXQt5Lpkfyt4laVdSkNVCl22i8TgJ7F
         ClM8wjpm0U0h99oceRXr1OHwcyTIV8C7NSL1kpoR1rUth1O6SBBwQWTh3U//FQJ3IH
         PWWlAKikhhk2yi+8WXi7Fgg8AfnQi8k+ile9dCG1kmsSYnsdpcmO96c3TW296gJvO+
         oblcufOjGuqPnAPlczDq8vmV2aAQLx+LcJCt0E1W2cGQpQ9S0sYDcB3uUZjBuOIwYM
         9HXixBwxZlwyA==
Received: by mail-il1-f199.google.com with SMTP id w9-20020a056e021c8900b0030247910269so16460387ill.4
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 05:56:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AN5JF4JjPpOJkZ/tkyQphRahAoTXPLdfhR7No5Nhr94=;
        b=gaa8msc1AWbIywkG7BxO0X49hIl3sb2IJO9o8Z1T10ETSzUxf407jfdUAjWxMxY6u9
         kkzDNftzQcdieC6TqY324Q4R5zxhG9pQXfofZPGGc4LZ/XVIAzPNzvJF2rqF5GwvzcFG
         cNZTSUB5xGXsawBR8YO6knQ+9pUnpb+AGYag+0W0jYU97hPNd0sxCfGxae2xwm14q8ng
         FbZN3v4D1TAK9i/FFZlo9ameXvybsLlAyOn2kkkPPqZDesrDpX96/WCPsdIaLA67kjVE
         TgvzqBI+fn7g5GxTtuEi/yERSyYtaf60yeqbr3etyWtaXKCZQZesUTiA8jHceJ4/A65w
         aB8Q==
X-Gm-Message-State: ANoB5pld2qTGFLdgIyTpTUwd0I4BZTVwmkDDqH7zr+ie9JCt6CjtgbsD
        eP7rjVyC7UD3sZwXqhe8dIGqUyKikHNK022WfrJdVb/W1Tz0fS2B55hFE2IrVCwnM+f6cEcb+Nz
        h24jStBYCl09a0brMohu3wqGtaArht8tAsAqRI7QAM1WGB2Dx0A==
X-Received: by 2002:a92:cd43:0:b0:303:2fd2:f612 with SMTP id v3-20020a92cd43000000b003032fd2f612mr15125914ilq.144.1670421384613;
        Wed, 07 Dec 2022 05:56:24 -0800 (PST)
X-Google-Smtp-Source: AA0mqf68T1FZSxevGnNf72rEE0f+xwVzoSCPSjB0SLRGWkB37LRAqopLc6DAcKKSJpFo/ZWVkn24R+SZbWzdDyZVHaY=
X-Received: by 2002:a92:cd43:0:b0:303:2fd2:f612 with SMTP id
 v3-20020a92cd43000000b003032fd2f612mr15125908ilq.144.1670421384463; Wed, 07
 Dec 2022 05:56:24 -0800 (PST)
MIME-Version: 1.0
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-2-yanhong.wang@starfivetech.com> <277f9665-e691-b0ad-e6ef-e11acddc2006@linaro.org>
 <22123903-ee95-a82e-d792-01417ceb63b1@starfivetech.com> <3a9ef360-73c3-cf26-3eca-4903b9a04ea3@linaro.org>
In-Reply-To: <3a9ef360-73c3-cf26-3eca-4903b9a04ea3@linaro.org>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Wed, 7 Dec 2022 14:56:07 +0100
Message-ID: <CAJM55Z-iLy1fZmoyk3FU7oDQcKBk6APYf-cbamKr7Gjx+NaoTQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/7] dt-bindings: net: snps,dwmac: Add compatible
 string for dwmac-5.20 version.
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     yanhong wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Dec 2022 at 09:04, Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 02/12/2022 03:53, yanhong wang wrote:
> >
> >
> > On 2022/12/2 0:18, Krzysztof Kozlowski wrote:
> >> On 01/12/2022 10:02, Yanhong Wang wrote:
> >>> Add dwmac-5.20 version to snps.dwmac.yaml
> >>
> >> Drop full stop from subject and add it here instead.
> >>
> >
> > Will update in the next version.
> >
> >>>
> >>> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> >>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> >>
> >> Two people contributed this one single line?
> >>
> >
> > Emil made this patch and I submitted it.
>
> If Emil made this patch, then your From field is incorrect.

Yes, please don't change the author of the commits you cherry-picked
from my tree.

But now I'm curious. Did you check with your colleagues that the dwmac
IP on the SoC is in fact version 5.20?
This was just an educated guess from my side.

/Emil

> Best regards,
> Krzysztof
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
