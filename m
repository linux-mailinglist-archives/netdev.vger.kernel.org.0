Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8928559E5E
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 18:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiFXQGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 12:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiFXQGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 12:06:40 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7DC54FB7
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 09:06:39 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id m125-20020a1ca383000000b0039c63fe5f64so1828267wme.0
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 09:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SoVtIIZHjWRSMo13op8m8fPdrTugWCzliMXoc5Fduz0=;
        b=E2P5RbBMaz9Pxf8+72L3Z/PDzQ/7fYcFm6sZRDskl+UpVMnh1QKOsFgfpIm0auYzd0
         Td0lMl1g/gDG0ZbLJzzqQ8RxhRxB6kRmYad0vEDZWGkyiC4SdDyJto0LBd7Um4lqoMBg
         NYuACZFlGUP7DJ2eQNAM5t+PRcUdumGvIMN463iRP+VlEfKFReo/iw7NjEyx+g5OPUfD
         GHGV0fYphI+703QDc495RxlegvHLHoakCytO4+TW0vAVAfbCiKLVbY42EbBtAztwZLRF
         pJR9UIR2UAaZ98ES4WIfAnUt/3AX9XZNCINnfC0lo4bN0FNN/OO5kjFAcijUyX6zkn2V
         ePhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SoVtIIZHjWRSMo13op8m8fPdrTugWCzliMXoc5Fduz0=;
        b=57D6pv6TLLKU3ZytRDLlzWwo+0smTS0XfE+fP2w5pGA5+FShQBxlkdUb9AXtEjLbcV
         ALZjAJrQ2k2AayKdva+oS1eVMjMw5W7gGVjmkKIfzIZsrV491Jbi6noieZ+aiovVi2BB
         3Sxi96fa0meJwHBI8hXLmjt9I86tnKs5+BsN7cT3lKHcbAWP7xvsmzfYKlxEFriS6bqa
         dBjkNWE7v+EqZWyr0Fh2gZCrkLgvw8N7PWhZechqYadp2Ro9uIJrPO5y/sE0Olnyy0W2
         WMrRyo7gfjir8ELpfJzqamI05dA+tSaYSx4Zc8mZ9vk7muQQRVVeclxSsqF/VC+wZJzi
         9OAA==
X-Gm-Message-State: AJIora8jBp7O1FhKAka3Z6sfrVH6ZZg/l6GBrL2zfofmfeDSFqemcE6w
        OgA6yqQJuSG1VGDdRZhEo72DtA==
X-Google-Smtp-Source: AGRyM1tfyiO4rvMCSPBArZEx2r/rZCaadR6ZXZk+61ln039bq0sY4qF27rYjHXorq9wzfyha+qBZcg==
X-Received: by 2002:a05:600c:4e88:b0:39c:7c53:d7ff with SMTP id f8-20020a05600c4e8800b0039c7c53d7ffmr4716238wmq.176.1656086797893;
        Fri, 24 Jun 2022 09:06:37 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id k1-20020a5d6281000000b0021b9e360523sm2754953wru.8.2022.06.24.09.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 09:06:37 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     linux-tegra@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, vbhadram@nvidia.com
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        thierry.reding@gmail.com, treding@nvidia.com, robh+dt@kernel.org,
        catalin.marinas@arm.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, jonathanh@nvidia.com, will@kernel.org
Subject: Re: (subset) [PATCH net-next v1 3/9] dt-bindings: memory: Add Tegra234 MGBE memory clients
Date:   Fri, 24 Jun 2022 18:06:34 +0200
Message-Id: <165608679241.23612.13616476913302198468.b4-ty@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220623074615.56418-3-vbhadram@nvidia.com>
References: <20220623074615.56418-1-vbhadram@nvidia.com> <20220623074615.56418-3-vbhadram@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jun 2022 13:16:09 +0530, Bhadram Varka wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Add the memory client and stream ID definitions for the MGBE hardware
> found on Tegra234 SoCs.
> 
> 

Applied, thanks!

[3/9] dt-bindings: memory: Add Tegra234 MGBE memory clients
      https://git.kernel.org/krzk/linux-mem-ctrl/c/f35756b5fc488912b8bc5f5686e4f236d00923d7

Best regards,
-- 
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
