Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3506559F40
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 19:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbiFXRVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 13:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbiFXRU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 13:20:58 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8356E78E
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 10:20:47 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id h9-20020a17090a648900b001ecb8596e43so3418032pjj.5
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 10:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JpG3GaCBjSymlu0qJdioaskNHObhsCdZ1X2qqa+IBhY=;
        b=OheUwHZvk5imrAj2nR5bzhQEPKZxrpivAtao33E8yyqE39cYGuex+pHguM7ACsTsL6
         DbQJpGIsHK6arR95hENMO7yFYX93UpqwUBDi1jDvrGCCmhpe/svbLIvPTJXo7MhxZTIx
         jS3GmlcLBvyPRlygx5I8upvloTU8D80W+RFy4Nav9JnzJbGyn8G8BxlqI7zaZVlhkmGf
         6EbUt/VtCG7YgxA6Vc2u+BYFGBqTmHZVZI8LgAkIgvDO7EFrmHQDqp8jVAHcEU64whuT
         DfLaC+vICgEXpcQTpTEFktMSDiFPDg7j6/Si1lDk4VpKMMuEM9ZND2vkoQ1/0PtaEitF
         FIJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JpG3GaCBjSymlu0qJdioaskNHObhsCdZ1X2qqa+IBhY=;
        b=gCOf1M3qqWOZWdc60flV9By0aNBr/vtn2PFOVhp9SBVwciFtcfQpt5UURc2D4DC+8i
         70eqXZXZaF7kl0Dvn2FXDfx2jgGg8TjziwrnpNCq8bZuVZzlDgTcUrFKGC3YLOXZKqY5
         mis5ZNRDeSoWKL18jxHeSUedaCfSKgYIpydsnCZX6UPWqxWUJlkIzmKYLANpDTwRS9JP
         iS3GtEFC0GCuEi75oHv7ezJRIpxr9GFdR7t9fr/peiSWFfyW4m+og1hxXxzg+iRdvcqo
         4GWUTiIf4sx6jagWMRWw6t5aIq9o7GWVwzwVJ7JBowLnFC6mG+eHgCs+i1oF/lgRypwB
         3K1Q==
X-Gm-Message-State: AJIora9PD/LsvbDmwwcmwo4RWGuzm08UWxxnMeW5b325VDUv75BHWyw4
        VK4EA8FeyJ/VCrtURKhAU7M=
X-Google-Smtp-Source: AGRyM1skElTXi9Lgt7ORDn0YT5PeOy3zwrNUQ/y/8qhBs6QhuYMNwCAadK4afO2SfKKonlB+x3hC+w==
X-Received: by 2002:a17:902:e5d0:b0:16a:6f96:ec3 with SMTP id u16-20020a170902e5d000b0016a6f960ec3mr128982plf.110.1656091247220;
        Fri, 24 Jun 2022 10:20:47 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x6-20020a1709028ec600b001638a171558sm2058298plo.202.2022.06.24.10.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 10:20:46 -0700 (PDT)
Message-ID: <3d2970c7-f785-edf7-2936-807cf21ec65e@gmail.com>
Date:   Fri, 24 Jun 2022 10:20:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v1 0/3] Create common DPLL/clock configuration API
Content-Language: en-US
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20220623005717.31040-1-vfedorenko@novek.ru>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220623005717.31040-1-vfedorenko@novek.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/22 17:57, Vadim Fedorenko wrote:
> From: Vadim Fedorenko <vadfed@fb.com>
> 
> Implement common API for clock/DPLL configuration and status reporting.
> The API utilises netlink interface as transport for commands and event
> notifications. This API aim to extend current pin configuration and
> make it flexible and easy to cover special configurations.

Any reasons why you are not copying the Linux common clock framework 
maintainers and not seeking to get your code included under drivers/clk/ 
where it would seem like a more natural place for it?

Is netlink really a necessary configuration interface for those devices?
-- 
Florian
