Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E205B7C26
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 22:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiIMUVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 16:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiIMUVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 16:21:35 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BAA642E9
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 13:21:32 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id 138so9611706iou.9
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 13:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=hvA7f1e70eZNisribXBaUlpwC7EMEv0cHfgluSEMJ+0=;
        b=VPYxLNq/A8L3gEZHrUwDcoUnPkNmYHwG9R7k93b4XkSnlgyVRTTuF0O77jbNmGZoIO
         fdkM8HmeOpQpWtqZPyf/TvCIxnU02BuqCVAm/R7KpqMDY9pXP01TznUpG3VpHJ9t/OYj
         eUOiHs7lGwCuJU0/YT9WAeKvqZ79yq/a06L8Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=hvA7f1e70eZNisribXBaUlpwC7EMEv0cHfgluSEMJ+0=;
        b=Lk2c9LOkIKVwbLXBV+JibKDV4nV2rn7qxifzsjTVT+U3BPKD+K6631GMLIpGGJArxr
         +MfMrs2c8WPNqe4kL1kb+sNtpM7WZgYwm/vcY1v5Lf15a70PqyOPwjbyPFTqmxLZk7X2
         qjvXqp/3vb1lrqwBVAO0R+soinum4Nya6jZHEqkP+W4hgJkKFD3WH5/vjEaSVYnkA4vb
         FpTVr9mjlZ7Qx5/3b6EOJtNsehZufL07xaymtDgC8wY/bWjPSrjuOEB6NyoEVWVkggip
         GP4CR7gua7p/Htz28Rz182/U8eS3WYI6RHz+5LcpsJRXGMFSQCs+Anfzh4dwFeAh0ugP
         ltbw==
X-Gm-Message-State: ACgBeo3hU0qpZKkTzfuSFyxbBXLVupvc/mb6miIm7UTeINKEyovpVfuj
        Ige3p4JuWcDqtPGIW+x85q8pSg==
X-Google-Smtp-Source: AA6agR7bLInJc4dGlF3FU+bR5qg/fCB3+Slbgvu5j48T3Dz25FTGl4WwJnDiLCEX7WWA0v0QFQAfow==
X-Received: by 2002:a05:6602:2f13:b0:6a1:730a:dd9d with SMTP id q19-20020a0566022f1300b006a1730add9dmr3702301iow.114.1663100492023;
        Tue, 13 Sep 2022 13:21:32 -0700 (PDT)
Received: from [172.22.22.4] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id d4-20020a0566022be400b006a102cb4900sm5436906ioy.39.2022.09.13.13.21.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Sep 2022 13:21:31 -0700 (PDT)
Message-ID: <ac428312-745c-490e-dfb4-2208913c27c1@ieee.org>
Date:   Tue, 13 Sep 2022 15:21:30 -0500
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
 <f2fa19a1-4854-b270-0776-38993dece03f@ieee.org>
 <5b0543dc-4db8-aa33-d469-0e185c82b221@quicinc.com>
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <5b0543dc-4db8-aa33-d469-0e185c82b221@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/13/22 1:51 PM, Jeff Johnson wrote:
> On 9/13/2022 6:58 AM, Alex Elder wrote:
>> On 9/12/22 6:25 PM, Jeff Johnson wrote:
>>> Change ff6d365898d ("soc: qcom: qmi: use const for struct
>>> qmi_elem_info") allows QMI message encoding/decoding rules to be
>>> const. So now update the definitions in the various client to take
>>> advantage of this. Patches for ath10k and ath11k were perviously sent
>>> separately.
>>
>> I have had this on my "to-do list" for ages.
>> The commit you mention updates the code to be
>> explicit about not modifying this data, which
>> is great.
>>
>> I scanned over the changes, and I assume that
>> all you did was make every object having the
>> qmi_elem_info structure type be defined as
>> constant.
>>
>> Why aren't you changing the "ei_array" field in
>> the qmi_elem_info structure to be const?  Or the
>> "ei" field of the qmi_msg_handler structure?  And
>> the qmi_response_type_v01_ei array (and so on)?
>>
>> I like what you're doing, but can you comment
>> on what your plans are beyond this series?
>> Do you intend to make the rest of these fields
>> const?
> 
> Hi Alex,
> My primary focus is the ath* wireless drivers, and my primary goal was 
> to make the tables there const. So this series, along with the two 
> out-of-series patches for ath10k and ath11k complete that scope of work.
> 
> The lack of the other changes to the QMI data structures is simply due 
> to me not looking in depth at the QMI code beyond the registration 
> interface.
> 
> I'll be happy to revisit this as a separate cleanup.

Sounds good to me.  Like I said I've wanted to do this
myself, and as long as you've gotten this far I'd like
to see it taken to completion.  Compile-testing is most
likely sufficient to make sure you got it right.

I cherry-picked the one commit, and downloaded the series
and found no new build warnings.  Checkpatch would prefer
you used "ff6d365898d4" rather than "ff6d365898d" for the
commit ID, but that's OK.

Anyway, for the whole series:

Reviewed-by: Alex Elder <elder@linaro.org>


> /jeff
> 

