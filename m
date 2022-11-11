Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013E2626279
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 21:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbiKKUAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 15:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiKKUAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 15:00:04 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1F92B1A9;
        Fri, 11 Nov 2022 12:00:01 -0800 (PST)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ABJvAsT012293;
        Fri, 11 Nov 2022 19:59:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=yGZJVOEkn/5ZhGcIVIIDwWtiBepp7mgPkuoc1OTiiTI=;
 b=pWJbY73Ezp9fk9U6++vgKcB5bpO+gW/yfJsnt95YArh8y5dXIhPsoLRVqR65Vo6d8QXf
 PBrprVDk6Nvguk0YsOZt0ul4ueuumgtPLCvytlf5MoFqQshmAnU2HXrCMCTRM0C+8lpE
 GM9pcVW673CHDrBw21V+/Fo/jFeON9qusSywZ3XiDGpn8SvQ2UGX11tlQTHhQ6bLOqK5
 mjWLj8abq8Gd6y1mpqfkHPDXWG0qJQgMOPkG0jX+JEzQ2ETk8KaxftoZzFeUkCaVHgi3
 t+2jhAD/X2613Z2L/lQ2WOTP2o5xT62a8ex7AUlixRPklvQoLL0QMiWzD2ibmBV4Upd0 Mw== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3kstu507mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 19:59:44 +0000
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABJxhYX012161;
        Fri, 11 Nov 2022 19:59:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 3kngwmaca9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 19:59:43 +0000
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ABJxhqq012152;
        Fri, 11 Nov 2022 19:59:43 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 2ABJxhKQ012147
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 19:59:43 +0000
Received: from [10.110.46.68] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 11 Nov
 2022 11:59:42 -0800
Message-ID: <a484effb-9da3-9888-c11d-2d36ece7a342@quicinc.com>
Date:   Fri, 11 Nov 2022 11:59:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RESEND v2] wifi: ath10k: Fix return value in
 ath10k_pci_init()
To:     Xiu Jianfeng <xiujianfeng@huawei.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <rmani@qti.qualcomm.com>
CC:     <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20221110061926.18163-1-xiujianfeng@huawei.com>
Content-Language: en-US
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20221110061926.18163-1-xiujianfeng@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 8ZwVySvqS3447jZKp55SqcvevK2DhXPE
X-Proofpoint-ORIG-GUID: 8ZwVySvqS3447jZKp55SqcvevK2DhXPE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_10,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 mlxlogscore=667 impostorscore=0
 phishscore=0 spamscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211110136
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/2022 10:19 PM, Xiu Jianfeng wrote:
> This driver is attempting to register to support two different buses.
> if either of these is successful then ath10k_pci_init() should return 0
> so that hardware attached to the successful bus can be probed and
> supported. only if both of these are unsuccessful should ath10k_pci_init()
> return an errno.
> 
> Fixes: 0b523ced9a3c ("ath10k: add basic skeleton to support ahb")
> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>

Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>

