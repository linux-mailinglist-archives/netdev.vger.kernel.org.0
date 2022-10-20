Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34536068B3
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 21:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiJTTMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 15:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiJTTMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 15:12:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015B920DB57
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 12:12:44 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KIinXc014743;
        Thu, 20 Oct 2022 19:12:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : from : subject : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mA03+KoI/V60ijj8witb6/xvQrmSfXnCMOaWYPlha9o=;
 b=BG2jfBgRp3VEu2P+Mjf8bfp3OMmXK8d9eS+bGJrSZWYjeRL2WYddj9S4Xm1wB8u6ESoW
 Og+XpVvwa97EaCSDg8vpZhEjZ06FWsjf4a3bjUY6Adtshrdw8oB8hFX/6MrBIPCRgwrr
 NeJcshbfj3iCVnYG1krXhHCV2aEVjFanTjJzhTbxgpAqc9c9fRR/3Rj5LgtVdydnKmnL
 I+jDqXGGl0s1Qdp15Nz4wcSEDlVp+1IjRVWuZW3bqmGydll9C2rkt5RuCX+sTyCGE8QN
 oTB3njzq7xdNpJ7H0nB8NUU1/3AYqC6NKWzCLmrmxsBeKzlNyFblrWvVpyBOImYCT6Lf rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbbvk8xxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 19:12:39 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29KJ37RV023399;
        Thu, 20 Oct 2022 19:12:38 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbbvk8xwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 19:12:38 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KJ6KeR032368;
        Thu, 20 Oct 2022 19:12:37 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02dal.us.ibm.com with ESMTP id 3k7mgaqnj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 19:12:37 +0000
Received: from smtpav05.dal12v.mail.ibm.com ([9.208.128.132])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KJCaXb14090930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 19:12:36 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65B085804C;
        Thu, 20 Oct 2022 19:12:36 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3302F58056;
        Thu, 20 Oct 2022 19:12:36 +0000 (GMT)
Received: from [9.41.99.180] (unknown [9.41.99.180])
        by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 19:12:36 +0000 (GMT)
Message-ID: <7cc2762a-eddb-83bf-5524-73d0fc6daf3b@linux.vnet.ibm.com>
Date:   Thu, 20 Oct 2022 14:12:37 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
From:   Thinh Tran <thinhtr@linux.vnet.ibm.com>
Subject: Re: [EXT] [PATCH v2] bnx2x: Fix error recovering in switch
 configuration
To:     Manish Chopra <manishc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Alok Prasad <palok@marvell.com>,
        "kuba@kernel.org" <kuba@kernel.org>
References: <20220826184440.37e7cb85@kernel.org>
 <20220916195114.2474829-1-thinhtr@linux.vnet.ibm.com>
 <BY3PR18MB461200F00B27327499F9FEC8AB4D9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <b9a87990-ae04-6cd2-7160-d9966770fc85@linux.vnet.ibm.com>
 <d2a9711b-21b1-6b0c-ae29-7cb6ee33da6c@linux.vnet.ibm.com>
 <b06c65b4-dda5-2a07-6f46-56c8355418b2@linux.vnet.ibm.com>
 <BY3PR18MB4612A8ECAB3E238E9D9E06EBAB299@BY3PR18MB4612.namprd18.prod.outlook.com>
Content-Language: en-US
In-Reply-To: <BY3PR18MB4612A8ECAB3E238E9D9E06EBAB299@BY3PR18MB4612.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fjHfOlbbVYKHShSCXbJ9Z_MLc2ipAQh-
X-Proofpoint-ORIG-GUID: G4YkYXbNrwZHOI7bVLYjmVaTGSAtUD_T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_09,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=820 spamscore=0 phishscore=0 adultscore=0 clxscore=1011
 impostorscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200115
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

On 10/17/2022 6:14 AM, Manish Chopra wrote:

> I am fine with this if using existing 'state' var is not a suitable option here. Thanks.
> 

Thanks for the review
Thinh Tran
