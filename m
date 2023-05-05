Return-Path: <netdev+bounces-501-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC07E6F7D4F
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 08:57:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12AE31C21659
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 06:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CBDA1FC4;
	Fri,  5 May 2023 06:57:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA60156EF
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 06:57:12 +0000 (UTC)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE531AE;
	Thu,  4 May 2023 23:57:10 -0700 (PDT)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3454mq1V026461;
	Fri, 5 May 2023 06:57:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=2Cr4yp6+m/xXSoIvTb526YLiKj5MoW2rHpxTH4RqKvA=;
 b=WX6SpXsGZk8osnNSAMuT6OS+mvXbp2AxSEstCeO29uIE3TRwAamK8sGN9N6SQCkBPiiV
 i4zZlWVXGEEkBJFS3aGGe09zshwgSp6jihKyIT0XsTTHtxlFudROCM22b8Hea45st3XW
 QPHX7R2KUbRUHtloWfle6PUsxuCy5+kk31gKWM0qKlm57HAntyXou6SxFgVqsEgBVf5h
 wfkU9X+LtHdsWCP4JBgvDoT2Y1cp2QDkWER2cJm/Ta87YHpU6C5OV2BkVioW7cGlv7WU
 Zv3wm9mUMLOC7QUPjfEud4wQHIsjExZEfy4g+O18+OuxhIOiS6Dx3DiEGs0dQsxoXgcU ew== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qce6mhubx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 May 2023 06:57:06 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3456v6me018854
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 5 May 2023 06:57:06 GMT
Received: from [10.214.66.58] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Thu, 4 May 2023
 23:57:01 -0700
Message-ID: <28761e5b-4746-14f9-c079-ee8e0d76882a@quicinc.com>
Date: Fri, 5 May 2023 12:26:58 +0530
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
 <20a45e1e-6e62-9940-33d8-af7bad02b68d@quicinc.com>
 <CAHp75VekkTVzVCJs10GEi=1Andb2rWTwK8RELw6SqMzKYCPq2w@mail.gmail.com>
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
In-Reply-To: <CAHp75VekkTVzVCJs10GEi=1Andb2rWTwK8RELw6SqMzKYCPq2w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 3LkMwWOhpMVtPFLv-e6i7p7XZbSmyJCU
X-Proofpoint-ORIG-GUID: 3LkMwWOhpMVtPFLv-e6i7p7XZbSmyJCU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-04_15,2023-05-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 phishscore=0
 mlxlogscore=841 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305050059
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 5/3/2023 7:23 PM, Andy Shevchenko wrote:
> On Wed, May 3, 2023 at 2:14 PM Rohit Agarwal <quic_rohiagar@quicinc.com> wrote:
>> On 5/3/2023 3:11 PM, Andy Shevchenko wrote:
>>> On Wed, May 3, 2023 at 8:39 AM Rohit Agarwal <quic_rohiagar@quicinc.com> wrote:
> ...
>
>>>>    /**
>>>>     * struct msm_function - a pinmux function
>>>> - * @name:    Name of the pinmux function.
>>>> - * @groups:  List of pingroups for this function.
>>>> - * @ngroups: Number of entries in @groups.
>>>> + * @func: Generic data of the pin function (name and groups of pins)
>>>>     */
>>>>    struct msm_function {
>>>> -       const char *name;
>>>> -       const char * const *groups;
>>>> -       unsigned ngroups;
>>>> +       struct pinfunction func;
>>>>    };
>>> But why? Just kill the entire structure.
>> Got it. Can we have a typedef for pinfunction to msm_function in the msm
>> header file?
> But why? You can replace the type everywhere it needs to be replaced.
> I can't expect many lines to change.
>
> Also consider splitting struct pingroup change out of this. We will
> focus only on the struct pinfunction change and less code to review.
Ok Will update all of this.

Thanks,
Rohit.

