Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9EC549D41
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 21:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbiFMTRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 15:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245219AbiFMTQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 15:16:52 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E8C344ED
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 10:29:04 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id h5so8059162wrb.0
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 10:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GkHUyUBvMlbOB2PrckkIt65Ri8yWb3dEP1hU9en5mDk=;
        b=fThTqDQ1jdNpd//oYDcVHtlsDsh6tAQoM60mBgY8d98H0x2DckAJ0orA3Ygg7e6xKg
         6Nl1qhQ8FugeIAjztSR8jOvNNdhOKi57KEnl1b36CK/4u9i2jPTx0EYz75b8CjqIuC/1
         6WWO8AggbEKg41Cy3DQkNA8/CeSt0hfI2JX9m8ab9f/dxLnhESCWmL/Dgsmfo/27R6V0
         q22EXn0u6vJcB5moodugF1fU2wKdPFaneTMZoL1Sirasrft0nYZZuJUPFfJmT9c+KYKx
         TbF1r+JrciX58xQ8ZlW1Pu81y+BNCd2AR/e7V1a7MV4Ba2CIO5vAMogbn7seLGlozuOK
         fbeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GkHUyUBvMlbOB2PrckkIt65Ri8yWb3dEP1hU9en5mDk=;
        b=jPy7jEAP8eb2Vyki2avJWLAo4Fs+c4xnK5HG+Zds3089QR4o+78e7tjORY5U0JWj7f
         2oaJ3Sp1emlsXIdUA6NAo34OxEVGMRSMvEWYy9N8hsmxniSNOxpCo4+u7CAyAzywUdmP
         9xlMjuyQxeIriu0KsXJcrK8OOwzZPJ5XWimjFFoQCX2EvbHGnYxKI8OHd4nrkdS/USBV
         i1/YPMwJW1nUyuiNVofY9MVypmHNq2gi03409IVWhkek6T8TuDDm2IvU2SXwUcqVpv10
         I+CKqiE5uSWAN59xyyoKT5SKzpiAcgYU8biNOWBjiKWwFE9XonLjJ3hI+08Nvns4z84J
         YIlQ==
X-Gm-Message-State: AJIora9bhp66KZU63RDUrfhKpOchdzuV4abXJyuvnjui28lUVpWswuNn
        IE5NkGsQ3jKKLYHddNhV0S+YqA==
X-Google-Smtp-Source: AGRyM1uwPIM3kghJQ8bShSDKcBNehxKUpuhTfauW2N2w+o61VA5Ku1DLOBL+jcOdXxsQ2nG4JE8BEg==
X-Received: by 2002:adf:ed45:0:b0:210:2f9c:f269 with SMTP id u5-20020adfed45000000b002102f9cf269mr898537wro.470.1655141343000;
        Mon, 13 Jun 2022 10:29:03 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id bd17-20020a05600c1f1100b0039c975aa553sm3012122wmb.25.2022.06.13.10.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 10:29:02 -0700 (PDT)
Date:   Mon, 13 Jun 2022 18:28:38 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh@kernel.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com, maz@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] amd-xgbe: Use platform_irq_count()
Message-ID: <Yqdzxlquw2gmiFp8@myrica>
References: <20220609161457.69614-1-jean-philippe@linaro.org>
 <3067cab3-21b3-456a-37a5-f21a349f3b8e@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3067cab3-21b3-456a-37a5-f21a349f3b8e@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 13, 2022 at 11:39:48AM -0500, Tom Lendacky wrote:
> On 6/9/22 11:14, Jean-Philippe Brucker wrote:
> > The AMD XGbE driver currently counts the number of interrupts assigned
> > to the device by inspecting the pdev->resource array. Since commit
> > a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from DT
> > core") removed IRQs from this array, the driver now attempts to get all
> > interrupts from 1 to -1U and gives up probing once it reaches an invalid
> > interrupt index.
> > 
> > Obtain the number of IRQs with platform_irq_count() instead.
> > 
> > Fixes: a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from DT core")
> > Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> It looks like the CCP driver does a similar loop looking for IRQ resources
> (sp_get_irqs() in drivers/crypto/ccp/sp-platform.c), have you looked at
> fixing that driver, too? I can submit a patch if you hadn't planned on it.

Ah no, I did very briefly look for similar issues but missed it, feel free
to send the patch

Thanks,
Jean
