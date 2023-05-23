Return-Path: <netdev+bounces-4823-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EFF770E933
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 00:43:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF46F2810E8
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E031642C;
	Tue, 23 May 2023 22:43:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD40BA55
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 22:43:11 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A72CA;
	Tue, 23 May 2023 15:43:10 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34NMRkUk007808;
	Tue, 23 May 2023 22:42:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=DPxFy0kgkp15W/17/zrdeqdPMfusaYNP5aDhFAM4+Ck=;
 b=FPjsUBN9nNGZxtrvceZMhyx11qP5uJy8pzzwpeC9oLlBM9/LvQ7FlK7WFu0ZeqAom7lE
 5aUT5UdzxmhOuyWxqoHZR9Jd5MhGBe8W9T34DzHhY4ZoUKRdLh6KFE44KOA7Fb7A/Ixi
 22++KFIvzqWQwuxuTAoH6ROj3gZjOax4rWUsHOgYW7nWOkHfv/NHGVL07i28VUqEdVxF
 +uXknIPwUF69YDCYJvtc9vsbStzNljIZ8ZAun3vfhH4jlzECyzMBiGElBlHodp2P+QyG
 TwQDacojcvBNrKDC4WsmxiOOHIuOFlBO2/dMIfNXKWdZj3peLZ21t8Zr0Ay/nQGjqX0X uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qs6a0r8k5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 May 2023 22:42:33 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34NMZtCl027793;
	Tue, 23 May 2023 22:42:32 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qs6a0r8jq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 May 2023 22:42:32 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
	by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34NLABhg016521;
	Tue, 23 May 2023 22:42:30 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
	by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3qppdswdnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 May 2023 22:42:30 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34NMgTr549611192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 May 2023 22:42:29 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B92735805A;
	Tue, 23 May 2023 22:42:29 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CBD5458056;
	Tue, 23 May 2023 22:42:28 +0000 (GMT)
Received: from [9.211.103.243] (unknown [9.211.103.243])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 23 May 2023 22:42:28 +0000 (GMT)
Message-ID: <4c6723df-5d40-2504-fcdc-dfdc2047f92c@linux.vnet.ibm.com>
Date: Tue, 23 May 2023 15:42:28 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH net-next 08/11] iavf: switch to Page Pool
To: Alexander Lobakin <aleksander.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Christoph Hellwig <hch@lst.de>, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
 <20230516161841.37138-9-aleksander.lobakin@intel.com>
Content-Language: en-US
From: David Christensen <drc@linux.vnet.ibm.com>
In-Reply-To: <20230516161841.37138-9-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SevONVa19cfGb6wVMoCGcEghTdYgfyUF
X-Proofpoint-ORIG-GUID: JrrJtm8H54URjr6Drg0Je3S2Jk_G02FA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_14,2023-05-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1011
 mlxscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=883 suspectscore=0
 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305230181
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/16/23 9:18 AM, Alexander Lobakin wrote:
> Now that the IAVF driver simply uses dev_alloc_page() + free_page() with
> no custom recycling logics and one whole page per frame, it can easily
> be switched to using Page Pool API instead.

Any plans to add page pool fragmentation support (i.e. 
PP_FLAG_PAGE_FRAG) in the future to better support architectures with 
larger page sizes such as 64KB on ppc64le?

Dave

