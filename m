Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E589331956A
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhBKVwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 16:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhBKVwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:52:04 -0500
Received: from relay04.th.seeweb.it (relay04.th.seeweb.it [IPv6:2001:4b7a:2000:18::165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55738C061574;
        Thu, 11 Feb 2021 13:51:09 -0800 (PST)
Received: from IcarusMOD.eternityproject.eu (unknown [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by m-r1.th.seeweb.it (Postfix) with ESMTPSA id D0B9C1F506;
        Thu, 11 Feb 2021 22:51:07 +0100 (CET)
Subject: Re: [PATCH v1 0/7] Add support for IPA v3.1, GSI v1.0, MSM8998 IPA
To:     Alex Elder <elder@ieee.org>, elder@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, konrad.dybcio@somainline.org,
        marijn.suijten@somainline.org, phone-devel@vger.kernel.org
References: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
 <3a596fce-9aa3-e2eb-7920-4ada65f8d2ee@ieee.org>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>
Message-ID: <f30c9f66-8284-0ada-3586-edf75fce12f7@somainline.org>
Date:   Thu, 11 Feb 2021 22:51:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <3a596fce-9aa3-e2eb-7920-4ada65f8d2ee@ieee.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 11/02/21 21:27, Alex Elder ha scritto:
> On 2/11/21 11:50 AM, AngeloGioacchino Del Regno wrote:
>> Hey all!
>>
>> This time around I thought that it would be nice to get some modem
>> action going on. We have it, it's working (ish), so just.. why not.
> 
> Thank you for the patches!
> 
> I would like to review these carefully but I'm sorry
> I won't be able to get to it today, and possibly not
> for a few days.  But I *will* review them.
> 

Don't worry :))

> I just want you to know I'm paying attention, though
> I'm sort of buried in an important issue right now.
> 
> I'm very impressed at how small the patches are though.

Actually, the driver is in a great shape. That's why the patches are
that small: thanks to you!

-- Angelo

> 
>                      -Alex
> 
>> This series adds support for IPA v3.1 (featuring GSI v1.0) and also
>> takes account for some bits that are shared with other unimplemented
>> IPA v3 variants and it is specifically targeting MSM8998, for which
>> support is added.
>>
>> Since the userspace isn't entirely ready (as far as I can see) for
>> data connection (3g/lte/whatever) through the modem, it was possible
>> to only partially test this series.
>> Specifically, loading the IPA firmware and setting up the interface
>> went just fine, along with a basic setup of the network interface
>> that got exposed by this driver.
>>
>> With this series, the benefits that I see are:
>>   1. The modem doesn't crash anymore when trying to setup a data
>>      connection, as now the modem firmware seems to be happy with
>>      having IPA initialized and ready;
>>   2. Other random modem crashes while picking up LTE home network
>>      signal (even just for calling, nothing fancy) seem to be gone.
>>
>> These are the reasons why I think that this series is ready for
>> upstream action. It's *at least* stabilizing the platform when
>> the modem is up.
>>
>> This was tested on the F(x)Tec Pro 1 (MSM8998) smartphone.
>>
>> AngeloGioacchino Del Regno (7):
>>    net: ipa: Add support for IPA v3.1 with GSI v1.0
>>    net: ipa: endpoint: Don't read unexistant register on IPAv3.1
>>    net: ipa: gsi: Avoid some writes during irq setup for older IPA
>>    net: ipa: gsi: Use right masks for GSI v1.0 channels hw param
>>    net: ipa: Add support for IPA on MSM8998
>>    dt-bindings: net: qcom-ipa: Document qcom,sc7180-ipa compatible
>>    dt-bindings: net: qcom-ipa: Document qcom,msm8998-ipa compatible
>>
>>   .../devicetree/bindings/net/qcom,ipa.yaml     |   7 +-
>>   drivers/net/ipa/Makefile                      |   3 +-
>>   drivers/net/ipa/gsi.c                         |  33 +-
>>   drivers/net/ipa/gsi_reg.h                     |   5 +
>>   drivers/net/ipa/ipa_data-msm8998.c            | 407 ++++++++++++++++++
>>   drivers/net/ipa/ipa_data.h                    |   5 +
>>   drivers/net/ipa/ipa_endpoint.c                |  26 +-
>>   drivers/net/ipa/ipa_main.c                    |  12 +-
>>   drivers/net/ipa/ipa_reg.h                     |   3 +
>>   drivers/net/ipa/ipa_version.h                 |   1 +
>>   10 files changed, 480 insertions(+), 22 deletions(-)
>>   create mode 100644 drivers/net/ipa/ipa_data-msm8998.c
>>
> 

