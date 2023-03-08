Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD206B0315
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 10:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjCHJkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 04:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjCHJkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 04:40:03 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B834CAF761;
        Wed,  8 Mar 2023 01:40:02 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id s20so20508657lfb.11;
        Wed, 08 Mar 2023 01:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678268400;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NoHhRDqxhWq5dkj9fVOfw1WvkPwkneaT/si7dtFMPME=;
        b=cZoxPmC83DhtmjAP5Aveqw/y9OSrO/czmNAdUC3If883SJoDiKUY9h3IkB9EeVeRMA
         uq+fmMxEyULqkmocgUWKlHrCFYlikpeZc3zh9Jq5NTnS9fcHCYMUntYcA4yLdWTxLk+X
         Xu6OFBSQzsZ2XyWHva5EbMQkPeNK+nFN7jZh4JhSKEAxzb7Vm+yw1IZj5sgVO1kevmSU
         pavm3icbhonniV2oybkpE+30s7sbadObmEEM0fpDE3hGpLvJqpfxU6ckg6GWJ/nVgmKl
         /xsN8/9a84fzSXeFvjpzHyfO1t0tiW5akm+HhZm9IdLUR6ITb5eiAfBUXhC0YfcnZaQH
         yxAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678268400;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NoHhRDqxhWq5dkj9fVOfw1WvkPwkneaT/si7dtFMPME=;
        b=kZA4v1XPUr+PBl4uZ9sEkoa/CuLCNraqybD8sBLjIeGv+o4yh2fLpd4HL/FUhhzzFx
         IMQSE9cwE2a+UjQOx5zHIrbAtmRiqiMUgifygkkqZITEEAK7NIrK7aMzfoN23vA7IpWY
         vT15l3VadPIRnRiBdSFvbCD6fwNrkvN7Rsc+2j2yzUCYlyVDqLHeaapsvBXQJ/3X1jUr
         5gbwYGd0PtJ+iRJfG/r8FS4nfa4JMNJFkxA4wRlOLhfsW0QWwqnkdJIlL7K4QVWPP254
         jr4XdgI15TYV3qLJjgntPiJCVP8OmRAbuIx0akYG9e0ijKpor2q4LUrNf4r6uQ+W9xHa
         lggw==
X-Gm-Message-State: AO0yUKUEtxIHkhFjH2rGNfsDE6n6zofZNynmJptdtgHIk2o6A6ph7ztH
        d4noLYRbIVnbKDXmc0+SV7f0OnZPyUY=
X-Google-Smtp-Source: AK7set9JF4WMLeQFvQUWIDYLr0H22AsmKbkTA4wDUDuLBz4g/8jnNaQOa3u48YW2L58+TH9d6gZPZw==
X-Received: by 2002:ac2:489a:0:b0:4dc:807b:9040 with SMTP id x26-20020ac2489a000000b004dc807b9040mr5085438lfc.5.1678268400573;
        Wed, 08 Mar 2023 01:40:00 -0800 (PST)
Received: from [192.168.1.103] ([31.173.83.210])
        by smtp.gmail.com with ESMTPSA id l3-20020a2e9083000000b00295a7f35206sm2505458ljg.48.2023.03.08.01.39.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 01:40:00 -0800 (PST)
Subject: Re: [PATCH 07/11] ravb: remove R-Car H3 ES1.* handling
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-renesas-soc@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230307163041.3815-1-wsa+renesas@sang-engineering.com>
 <20230307163041.3815-8-wsa+renesas@sang-engineering.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <20567076-5347-4385-db93-850b4200dfa7@gmail.com>
Date:   Wed, 8 Mar 2023 12:39:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20230307163041.3815-8-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

  (Sending via Gmail account, as the OMP SMTP server rejects...) 

On 3/7/23 7:30 PM, Wolfram Sang wrote:

> R-Car H3 ES1.* was only available to an internal development group and
> needed a lot of quirks and workarounds. These become a maintenance
> burden now, so our development group decided to remove upstream support
> and disable booting for this SoC. Public users only have ES2 onwards.
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

[...]

MBR, Sergey
