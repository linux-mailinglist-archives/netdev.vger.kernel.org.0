Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590EE5A8113
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiHaPTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiHaPT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:19:29 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075DCD8B2D;
        Wed, 31 Aug 2022 08:19:21 -0700 (PDT)
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VEt0ai016618;
        Wed, 31 Aug 2022 15:19:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=b4mSvOEH+vP34dG48xtqm5QYnL6FD+Wz1XH17FHzmWA=;
 b=a6Q7gBbyj8YMBZZ0jAvlVD9Q2pCL/ETx22in1LXv/TNMYt3M+z3fxWWo+uaDwKmREUyU
 BmtKjAjeaX3IXl7ed7xsKJbLc3S8lC6L2KRGNFa4SAe7WTvXzGTuGz6QBHfxACngL4pS
 pgmn4ZUnHRZa7F5hAVnAib/tdMqce3Uo9AMy3LoBUAjcPjG+xikrct/m3iEQJB5R+bso
 wYjsEKqyx9YycDS4ix2DZT0Y0W14faWg5lcfRSzTPDVcJPE74zJ6HMcDhmw6eyfEwo4+
 uc69s+g6IW0DR/hp7KzwlFKjh97dqzLeg+0MmtRhFtQf5OVZ0kB/xaDJWn/asN2wqNy7 YA== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3j9mwjkqk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Aug 2022 15:19:02 +0000
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 27VFIcQi011417;
        Wed, 31 Aug 2022 15:19:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 3j7cbkqubm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Aug 2022 15:19:01 +0000
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27VFJ1Ev012265;
        Wed, 31 Aug 2022 15:19:01 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 27VFJ1G0012263
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Aug 2022 15:19:01 +0000
Received: from [10.110.0.200] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 31 Aug
 2022 08:19:00 -0700
Message-ID: <24ee0926-1f56-f3d4-5531-f615352cda0c@quicinc.com>
Date:   Wed, 31 Aug 2022 08:18:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] wifi: mac80211_hwsim: check length for virtio packets
Content-Language: en-US
To:     Soenke Huster <soenke.huster@eknoes.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220831132205.129922-1-soenke.huster@eknoes.de>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220831132205.129922-1-soenke.huster@eknoes.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: PACf5UHZvt2zBIsW2CmIEZnqjxQaP8ZT
X-Proofpoint-ORIG-GUID: PACf5UHZvt2zBIsW2CmIEZnqjxQaP8ZT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-31_09,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1011 mlxlogscore=505 phishscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310076
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/2022 6:22 AM, Soenke Huster wrote:
> An invalid packet with a length shorther than the specified length in the

nit: s/shorther/shorter/

