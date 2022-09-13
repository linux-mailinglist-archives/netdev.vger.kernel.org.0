Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E02E5B6EB5
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 15:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbiIMN6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 09:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbiIMN6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 09:58:36 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A14501A4
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 06:58:32 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id u19-20020a4a9e93000000b004757198549cso982300ook.0
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 06:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=j4b3AwKXnbNOc68U591Ba49SYpbjEmsPStwHugruFXY=;
        b=IY8xOwXpGjE0SdIJPzybMxmP4m2T8KAbKGM7JrPns4diuJRzQQdTrR9uBMLZMZ1lZO
         K/HcgHm2G7ER+vdjQDjBa7FWLUTbtkNCQz2jT5oIF9qIbknckvE+l63mEgLKqMIJlf5J
         fC+8+JnPKboKqHH/11hZPFYExWokI2U45amkI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=j4b3AwKXnbNOc68U591Ba49SYpbjEmsPStwHugruFXY=;
        b=vqpM0zF8ugka6MHndacM4qsb5H7KyTF5+oEcc2XROCT19wB7EG8Vf4RaFuW7X3B+fZ
         m59SeM7CLE2RXMb9AilyN4GKzqnrnUJiYXBSfUgb27q3xgHblWiIOxDmNwPYKbqHJhuH
         LMqukSARXfaDGo7NutTmzAov6TlwgWRBsk6fKn6POhq6jCghjSw7ndQvV7LgdqGJscK/
         Q8FZev08lF2KAxCEf5Z+P1FByJjZDc7iQgR/xKrEzgB1n1bcg4BPSGZsHYZ68bpreMRe
         IOvUerdMhF4fSR/z0eVtydeZA4LEb8noU+ko6aWg7/SNcDa9AeKhV0u3RC0RwplL+yRc
         +aGw==
X-Gm-Message-State: ACgBeo1Gv9Iz/BV+zDm2aM8Bqxpg7eqXTAtXTW8XdT4eClrL29oxDddb
        lAQt8hVNwiRIyqRvLeAZU1zZAQ==
X-Google-Smtp-Source: AA6agR6Tr6upEAKirqfcck1pCLrIPjxxEXBfXhURgmYde0fXkAmfIiiM2LtbTbWlyIGlUU6Bd09Etg==
X-Received: by 2002:a4a:8e81:0:b0:475:811f:3f9e with SMTP id p1-20020a4a8e81000000b00475811f3f9emr2603836ook.35.1663077511837;
        Tue, 13 Sep 2022 06:58:31 -0700 (PDT)
Received: from [172.22.22.4] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id k26-20020a056808069a00b0033a11fcb23bsm5212658oig.27.2022.09.13.06.58.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Sep 2022 06:58:31 -0700 (PDT)
Message-ID: <f2fa19a1-4854-b270-0776-38993dece03f@ieee.org>
Date:   Tue, 13 Sep 2022 08:58:29 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 0/4] Make QMI message rules const
Content-Language: en-US
To:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kalle Valo <kvalo@kernel.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Cc:     linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
References: <20220912232526.27427-1-quic_jjohnson@quicinc.com>
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <20220912232526.27427-1-quic_jjohnson@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/22 6:25 PM, Jeff Johnson wrote:
> Change ff6d365898d ("soc: qcom: qmi: use const for struct
> qmi_elem_info") allows QMI message encoding/decoding rules to be
> const. So now update the definitions in the various client to take
> advantage of this. Patches for ath10k and ath11k were perviously sent
> separately.

I have had this on my "to-do list" for ages.
The commit you mention updates the code to be
explicit about not modifying this data, which
is great.

I scanned over the changes, and I assume that
all you did was make every object having the
qmi_elem_info structure type be defined as
constant.

Why aren't you changing the "ei_array" field in
the qmi_elem_info structure to be const?  Or the
"ei" field of the qmi_msg_handler structure?  And
the qmi_response_type_v01_ei array (and so on)?

I like what you're doing, but can you comment
on what your plans are beyond this series?
Do you intend to make the rest of these fields
const?

Thanks.

					-Alex

> This series depends upon:
> https://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git/commit/?h=for-next&id=ff6d365898d4d31bd557954c7fc53f38977b491c
> 
> This is in the for-next banch of:
> git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git
> 
> Hence this series is also based upon that tree/branch.
> 
> Jeff Johnson (4):
>    net: ipa: Make QMI message rules const
>    remoteproc: sysmon: Make QMI message rules const
>    slimbus: qcom-ngd-ctrl: Make QMI message rules const
>    soc: qcom: pdr: Make QMI message rules const
> 
>   drivers/net/ipa/ipa_qmi_msg.c    | 20 ++++++++++----------
>   drivers/net/ipa/ipa_qmi_msg.h    | 20 ++++++++++----------
>   drivers/remoteproc/qcom_sysmon.c |  8 ++++----
>   drivers/slimbus/qcom-ngd-ctrl.c  |  8 ++++----
>   drivers/soc/qcom/pdr_internal.h  | 20 ++++++++++----------
>   5 files changed, 38 insertions(+), 38 deletions(-)
> 

