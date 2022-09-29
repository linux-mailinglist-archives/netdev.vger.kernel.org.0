Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C559A5EFC14
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 19:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbiI2Rfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 13:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235442AbiI2Rfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 13:35:40 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAC210F729;
        Thu, 29 Sep 2022 10:35:39 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id i17so1289470qkk.12;
        Thu, 29 Sep 2022 10:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=zA6Y5hkQML6R8vIpJqVNEmC/+vTq2vUA6WDac9IkZHQ=;
        b=oDEM1tP1F7UAQVNZ91VmNnenaUm4qws7hEHmiEJRTthVohQUH5kO4G1hktHhuWt4CM
         EXQeLMeZeFlF32hqNkCbnw4vAAccKlVWEdhS89TBTSAWS4VrzAAwYropIGyq+4fzcIO5
         eDhJkFzHIo9VN1Dc2ixvSF25dp8FYQaXt+ADjX3g7d9JFEJEKQoi5HInCc8iua/m7T9X
         /0LdiHd4Ua5124nOwY/J4/lsmG9wSL2LOzz4GJGQ4eSC41jVmv1amWgIwgY0SoTz1KV5
         gLSqULVmTuciVMrXMzGbthl1K7bl/z5QNTi7Uzp1DXtwPIrBwOoRdLlgk9Tzp/smlRHe
         lBUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=zA6Y5hkQML6R8vIpJqVNEmC/+vTq2vUA6WDac9IkZHQ=;
        b=stlfClGuOeRKo9IdjBO6QsPE5ItAzVKAq408AgvN/UoWm2gpXniOujvhlmlhqXw8ua
         7lA8JrGZoD9Scrdo5qhhoZqP9k0HnKl6hAxgWCtVgLw/qz72hlm9rVOvqVJ5mAuADnsF
         MYN7+8meZDGPPtZNCQICAftGSJfrCMjGVrFNqFqSqPNKtIFWRD5tCdyOay0NKMjnyHC6
         qrVQ/ML1V3kNHkIkLrO6JDfT0Dpx0ikRw/h1OojmFx1FFdhqXLZ55CFLX8cme5urb8wU
         PecmgWsExTbvc/ztOW1m2oHtZA5KMOYO3iSQDX1JAXAlVQbC9BpJNzyXrG6FYQFpSFfA
         dvEg==
X-Gm-Message-State: ACrzQf3JaelOPEMIF4soYIABCAC7Bm8JMoU7zfl65Ac3e8xzhuMCB4oe
        OF9CZENOXkOttkiXUemnvV8=
X-Google-Smtp-Source: AMsMyM4Yah3QrJm+TCHsStE8k6mas/dBTRodARjXJOj7YfvBpRznPsuKIDoMU9NryiwLqSH3VhMzdQ==
X-Received: by 2002:a05:620a:2683:b0:6cf:3768:8e4b with SMTP id c3-20020a05620a268300b006cf37688e4bmr3058946qkp.768.1664472938687;
        Thu, 29 Sep 2022 10:35:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l19-20020ac84593000000b003437a694049sm5992207qtn.96.2022.09.29.10.35.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 10:35:37 -0700 (PDT)
Message-ID: <bc0fd01d-4d05-ef97-dbb9-d92b4549b9a3@gmail.com>
Date:   Thu, 29 Sep 2022 10:34:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v7 23/29] thermal/drivers/broadcom: Use generic
 thermal_zone_get_trip() function
Content-Language: en-US
To:     Daniel Lezcano <daniel.lezcano@linaro.org>, rafael@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        rui.zhang@intel.com, Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Kaestle <peter@piie.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Amit Kucheria <amitk@kernel.org>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Dmitry Osipenko <digetx@gmail.com>, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org
References: <20220928210059.891387-1-daniel.lezcano@linaro.org>
 <20220928210059.891387-24-daniel.lezcano@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220928210059.891387-24-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/22 14:00, Daniel Lezcano wrote:
> The thermal framework gives the possibility to register the trip
> points with the thermal zone. When that is done, no get_trip_* ops are
> needed and they can be removed.
> 
> Convert ops content logic into generic trip points and register them with the
> thermal zone.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
