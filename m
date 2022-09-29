Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7EB65EF812
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 16:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbiI2O5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 10:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiI2O5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 10:57:24 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F06B13EEAF
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:57:21 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x15so2123117wrv.1
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=nMnoSaH++1jbxSRlI1i6ADibQaQmTqMy1EUBbqCTBb4=;
        b=Vv38lf5pdCpNoqOoAP120tgQ2KJMA7ZXY3zRv5IFf/18Ka+QYWp8iVvfDHwGWrUURq
         XMcDVzCN67NfLLBvXneNU5Hkez1866vy2rJVUYu1vKryg0jxvA42QIHMFr7FwGNaV9n6
         +IocjwdpayeRbeM2/sZgvPjKG7ythoaKpeUuXczusJJEcfS9wVBWcjyCRFl0D/sVgICw
         2J5a8U1veuMcYYFjAV1q0dwyuM/YnZan597rCZ3Ds+v2h0MHW6JxifLG9t4Ao/8M6lM7
         dZ4dzrfOEAf3pCEuuCr6J1A5XSYwp2pNtFtcBkJ2x/vFTyXVLC2qrq4yFh7WpEiVWHAy
         sp4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=nMnoSaH++1jbxSRlI1i6ADibQaQmTqMy1EUBbqCTBb4=;
        b=UQctk/DzzET4ed5sWsnWfDAuBTq3AzQ+ywnPuScgfp1pOYT3DhCh94eHcwSBPm8p9h
         dQULS5m1okAwwzu9+Ul2nuft7407qdQ0g+Xfix0VdfY0nYjHCFY1jWa95yJnVatlDBfj
         TzXorR4KUt5BB+kQD6Y5WOWGkn6Imw+R1wUbj3uDMi+2P8/NvohnSBXYeiSQeC+Mge0w
         fMUi7CDwo/UP38vJ3ITxhCCIrCRQTcT8ZC6JXrgjtcFyXo1uIN2OftsCuZOHdRP8OaQB
         iTu21hBv/udVymLjhg3gbylrv2N4zrsAua5HLFhX/s9muY9O1Ffr5b2N8vBnUvT5hSVn
         H5QA==
X-Gm-Message-State: ACrzQf2bRIza8uFRVGROlQNl7jmDjeENmW4CoUPp7D7MJtK7exoO7vz5
        6l3TyPl5VKCTgCw+8E+lHPlY2Q==
X-Google-Smtp-Source: AMsMyM4axP40VuENGb1cdsZ/JJas2+un/fCosaf9j+YjtgOlism/1wYOdarXHCbv/7WEnKLKyS9PoQ==
X-Received: by 2002:a05:6000:2a3:b0:226:dff3:b031 with SMTP id l3-20020a05600002a300b00226dff3b031mr2687409wry.495.1664463439654;
        Thu, 29 Sep 2022 07:57:19 -0700 (PDT)
Received: from ?IPV6:2a05:6e02:1041:c10:48a2:39eb:9d1b:8b8d? ([2a05:6e02:1041:c10:48a2:39eb:9d1b:8b8d])
        by smtp.googlemail.com with ESMTPSA id t187-20020a1c46c4000000b003b4a699ce8esm4646084wma.6.2022.09.29.07.57.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 07:57:19 -0700 (PDT)
Message-ID: <ae86fc5a-0521-3dde-c2ea-8679c0ec4831@linaro.org>
Date:   Thu, 29 Sep 2022 16:57:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v7 00/29] Rework the trip points creation
Content-Language: en-US
To:     "Rafael J. Wysocki" <rafael@kernel.org>
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
 <d0be3159-8094-aed1-d9b1-c4b16d88d67c@linaro.org>
 <CAJZ5v0hOFoe0KqEimFv9pgmiAOzuRoLjdqoScr53ErNFU4AAPA@mail.gmail.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <CAJZ5v0hOFoe0KqEimFv9pgmiAOzuRoLjdqoScr53ErNFU4AAPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/09/2022 15:58, Rafael J. Wysocki wrote:
> On Thu, Sep 29, 2022 at 2:26 PM Daniel Lezcano
> <daniel.lezcano@linaro.org> wrote:
>>
>>
>> Hi Rafael,
>>
>> are you happy with the changes?
> 
> I'll have a look and let you know.

Great, thanks
> 
>> I would like to integrate those changes with the thermal pull request
> 
> Sure, but it looks like you've got only a few ACKs for these patches
> from the driver people.
> 
> Wouldn't it be prudent to give them some more time to review the changes?

Well I would say I received the ACKs from the drivers which are actively 
maintained. Others are either not with a dedicated maintainer or not a 
reactive one. The first iteration of the series is from August 5th. So 
it has been 2 months.

I pinged for imx, armada and tegra two weeks ago.

The st, hisilicon drivers fall under the thermal maintainers umbrella

There are three series coming after this series to be posted. I would 
like to go forward in the process of cleaning up the framework. IMO two 
months is enough to let the maintainers pay attention to the changes, 
especially if we do a gentle ping and there are seven versions.

And after that comes the thermal_zone_device_register() parameters 
simplification :)

[ ... ]

-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
