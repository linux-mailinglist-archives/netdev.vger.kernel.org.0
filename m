Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B9B5F2C3D
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 10:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiJCInX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 04:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJCImw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 04:42:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8BA8205CE;
        Mon,  3 Oct 2022 01:19:13 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CB4E139F;
        Mon,  3 Oct 2022 00:33:12 -0700 (PDT)
Received: from [10.57.4.29] (unknown [10.57.4.29])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B323B3F73B;
        Mon,  3 Oct 2022 00:32:57 -0700 (PDT)
Message-ID: <e4276afa-b6c5-8f5f-e604-92bc480714c9@arm.com>
Date:   Mon, 3 Oct 2022 08:32:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v7 00/29] Rework the trip points creation
Content-Language: en-US
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Raju Rangoju <rajur@chelsio.com>,
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
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
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
        Dmitry Osipenko <digetx@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-rpi-kernel@lists.infradead.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Samsung SoC <linux-samsung-soc@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
References: <20220928210059.891387-1-daniel.lezcano@linaro.org>
 <d0be3159-8094-aed1-d9b1-c4b16d88d67c@linaro.org>
 <CAJZ5v0hOFoe0KqEimFv9pgmiAOzuRoLjdqoScr53ErNFU4AAPA@mail.gmail.com>
 <ae86fc5a-0521-3dde-c2ea-8679c0ec4831@linaro.org>
 <CAJZ5v0jrWamTTXcHabSk=6cmm4pEx0_ebiECKZRfrX_vS85YYg@mail.gmail.com>
 <CAJZ5v0gnfK2MBuzZi-C03VVO+b4dthckJcdj3zLo3q-qAUyy_g@mail.gmail.com>
From:   Lukasz Luba <lukasz.luba@arm.com>
In-Reply-To: <CAJZ5v0gnfK2MBuzZi-C03VVO+b4dthckJcdj3zLo3q-qAUyy_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rafael and Daniel

On 9/30/22 18:39, Rafael J. Wysocki wrote:
> On Thu, Sep 29, 2022 at 9:35 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
>>
>> On Thu, Sep 29, 2022 at 4:57 PM Daniel Lezcano
>> <daniel.lezcano@linaro.org> wrote:
>>>
>>> On 29/09/2022 15:58, Rafael J. Wysocki wrote:
>>>> On Thu, Sep 29, 2022 at 2:26 PM Daniel Lezcano
>>>> <daniel.lezcano@linaro.org> wrote:
>>>>>
>>>>>
>>>>> Hi Rafael,
>>>>>
>>>>> are you happy with the changes?
>>>>
>>>> I'll have a look and let you know.
>>>
>>> Great, thanks
>>
>> Well, because you have not added the history of changes to the
>> patches, that will take more time than it would otherwise.
> 
> Done.  I've sent ACKs and still had a comment on one patch (minor but
> still).  When that is addressed, the four initial core patches should
> be good to go in.
> 
> I'm trusting you regarding the thermal/of changes (even though I think
> that it would be good if someone involved in that code could review
> them) and if you are confident about all of the driver changes, they
> are fine with me too.

Sorry for being late. I have been busy with some internal bug hunting.
I'll check the code today and test it on my dev boards.

Regards,
Lukasz
