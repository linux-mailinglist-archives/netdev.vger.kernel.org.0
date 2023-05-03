Return-Path: <netdev+bounces-145-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 115F06F5702
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 13:15:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC64C28151D
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 11:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79506D505;
	Wed,  3 May 2023 11:14:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6719446AC
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 11:14:58 +0000 (UTC)
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A062B40CF;
	Wed,  3 May 2023 04:14:56 -0700 (PDT)
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3438w1fQ009598;
	Wed, 3 May 2023 11:14:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=nVj6NgtyNyEjf9h7GXCgl1wixn646Jm5+4yYduszGcs=;
 b=aNl8AMRU5Bo8PfAK9mYfdDnrJ4Ugz+Dsrx1JRdflIOju611YusbeCdo+mL340IUvt2va
 +m6uhhzjMSKDEN9ttSeyNkfiA4p4VjBol136Gr7SgP0LEuitVQH9tdClI3VRDMX4JaS9
 ji5a2mQOEcitLgxNYgowU4hY1hhtTgC3lAwX8fm/bCs1utn9c69UhGao7FOOj0p5ffMP
 pFSp8J0qc8ljVFq6VFTSdpNrgIopJq8bS3C/ZnSSQx3+QTH6TiATH3jEv8VPwtSyySzM
 VitlzhvqrPcHOiEcOAYgLYYA0kBVOj15uuh+57098S/pR00v1jriOH6zJdu7f4ZWfnHP Ug== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qb4e9ae3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 May 2023 11:14:52 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 343BEorn009364
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 3 May 2023 11:14:50 GMT
Received: from [10.214.66.58] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Wed, 3 May 2023
 04:14:46 -0700
Message-ID: <20a45e1e-6e62-9940-33d8-af7bad02b68d@quicinc.com>
Date: Wed, 3 May 2023 16:44:43 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v5 2/3] pinctrl: qcom: Refactor target specific pinctrl
 driver
Content-Language: en-US
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: <agross@kernel.org>, <andersson@kernel.org>, <konrad.dybcio@linaro.org>,
        <linus.walleij@linaro.org>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <richardcochran@gmail.com>,
        <manivannan.sadhasivam@linaro.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-gpio@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <1683092380-29551-1-git-send-email-quic_rohiagar@quicinc.com>
 <1683092380-29551-3-git-send-email-quic_rohiagar@quicinc.com>
 <CAHp75VegxMgAamS3ORiJ2=D4MH7asD9PiWrM+3JAm-QOuEgcrg@mail.gmail.com>
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
In-Reply-To: <CAHp75VegxMgAamS3ORiJ2=D4MH7asD9PiWrM+3JAm-QOuEgcrg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: anB2e0d6eAfCV96cjebqf-ClkhOCLVAI
X-Proofpoint-ORIG-GUID: anB2e0d6eAfCV96cjebqf-ClkhOCLVAI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_06,2023-05-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 malwarescore=0 suspectscore=0 spamscore=0 impostorscore=0
 mlxlogscore=848 adultscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030094
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 5/3/2023 3:11 PM, Andy Shevchenko wrote:
> On Wed, May 3, 2023 at 8:39 AM Rohit Agarwal <quic_rohiagar@quicinc.com> wrote:
>> Update the msm_function and msm_pingroup structure to reuse the generic
> structures
>
>> pinfunction and pingroup structures. Also refactor pinctrl drivers to adjust
>> the new macro and updated structure defined in pinctrl.h and pinctrl_msm.h
>> respectively.
> Thanks for this, my comments below.
>
> ...
>
>>   #define FUNCTION(fname)                                        \
>>          [APQ_MUX_##fname] = {                           \
>> -               .name = #fname,                         \
>> -               .groups = fname##_groups,               \
>> -               .ngroups = ARRAY_SIZE(fname##_groups),  \
>> -       }
>> +               .func = PINCTRL_PINFUNCTION(#fname,                     \
>> +                                       fname##_groups,                 \
>> +                                       ARRAY_SIZE(fname##_groups))             \
>> +                       }
> Does it really make sense to keep an additional wrapper data type that
> does not add any value? Can't we simply have
This was done as part of embeding the pinfunction structure in msm_function.
Will drop this in the next.
>    #define FUNCTION(fname)      [...fname] = PINCTRL_PINFUNCTION(...)
>
> ?
>
> ...
>
>> +               .grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,     \
>> +                       (unsigned int)ARRAY_SIZE(gpio##id##_pins)),     \
> Why do you need this casting? Same Q to all the rest of the similar cases.
Will drop it.
> ...
>
>> +#include <linux/pinctrl/pinctrl.h>
> Keep it separate, and below the generic ones...
Sure
>
>>   #include <linux/pm.h>
>>   #include <linux/types.h>
>>
> ...like here (note also a blank line).
>
> ...
>
>>   /**
>>    * struct msm_function - a pinmux function
>> - * @name:    Name of the pinmux function.
>> - * @groups:  List of pingroups for this function.
>> - * @ngroups: Number of entries in @groups.
>> + * @func: Generic data of the pin function (name and groups of pins)
>>    */
>>   struct msm_function {
>> -       const char *name;
>> -       const char * const *groups;
>> -       unsigned ngroups;
>> +       struct pinfunction func;
>>   };
> But why? Just kill the entire structure.
Got it. Can we have a typedef for pinfunction to msm_function in the msm 
header file?
> ...
>
>>   #define FUNCTION(fname)                                        \
> This definition appears in many files, instead you can make a generic
> to this drivers one and use it here
>
> #define QCOM_FUNCTION(_prefix_, _fname_)
>    [_prefix_##_fname_] = PINCTRL_PINFUNCTION(...)
>
> #define FUNCTION(fname) QCOM_FUNCTION(msm_mux, fname)
>
> (this just a pseudocode, might not even be compilable)
>
>>          [msm_mux_##fname] = {                           \
>> -               .name = #fname,                         \
>> -               .groups = fname##_groups,               \
>> -               .ngroups = ARRAY_SIZE(fname##_groups),  \
>> +               .func = PINCTRL_PINFUNCTION(#fname,                     \
>> +                                       fname##_groups,                 \
>> +                                       ARRAY_SIZE(fname##_groups))             \
>>          }
Got your point. Maybe your option 2 of using MSM_PIN_FUNCTION seems more 
generic,
as there wont be any redefinition of any macro FUNCTION altogether in 
the target specific files.

Thanks,
Rohit.

