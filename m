Return-Path: <netdev+bounces-6922-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CEDB718AF8
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 22:19:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34FF82815B9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577093C0A9;
	Wed, 31 May 2023 20:19:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4974D34CE2
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 20:19:26 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F67126;
	Wed, 31 May 2023 13:19:23 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VKCVx9001351;
	Wed, 31 May 2023 20:19:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sTJCWWUwzwvNr/MkB+nxK/PvXW1ND48ywSdnL9r2G/I=;
 b=sxQoG0kvVkhnyhB9eb+OI9pqNiToozu3AIl6pgp559MfzyrrQgnrLMZ2Qha+NApe/kHM
 ITHVeeqpErVZ4oK7jbAQrWQnwDJr2ODcg1xW0gj5tTTw6+6i7w61JXOFAMrJYqysL3Rp
 JQtsmxKTAZr/NBgQ8RbYP+pnfEqpHyrvmeRXs7czCxz7cRAdBptaSOd5RKTzOCPRY3rW
 M2H4NCPv0sVDDn1lFqYkGYqSi/BqIjmiN5H4DQtW4RD1ZFaf3z3SJmWICDAA6DTDnXfU
 uBJS/kQHLEmoIVBbl/QzsL6Gv4jVDu49lZZL+ox5yp4xbHar51S52ooa4hrZOE7oG/3v 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxd2c05je-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 May 2023 20:19:05 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34VKFpvl013315;
	Wed, 31 May 2023 20:19:04 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxd2c05ha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 May 2023 20:19:04 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
	by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34VJAC4Y008154;
	Wed, 31 May 2023 20:19:03 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([9.208.129.120])
	by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3qu9g8ddxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 May 2023 20:19:03 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34VKJ1GC48431430
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 May 2023 20:19:02 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA9A358050;
	Wed, 31 May 2023 20:19:01 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 20C6558054;
	Wed, 31 May 2023 20:19:00 +0000 (GMT)
Received: from [9.61.47.250] (unknown [9.61.47.250])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 31 May 2023 20:19:00 +0000 (GMT)
Message-ID: <002e833e-33b0-54d4-8584-9366850a7956@linux.vnet.ibm.com>
Date: Wed, 31 May 2023 13:18:59 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH net-next 08/11] iavf: switch to Page Pool
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Christoph Hellwig <hch@lst.de>, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
 <20230516161841.37138-9-aleksander.lobakin@intel.com>
 <4c6723df-5d40-2504-fcdc-dfdc2047f92c@linux.vnet.ibm.com>
 <8302be1b-416a-de32-c43b-73bd378f8122@intel.com>
Content-Language: en-US
From: David Christensen <drc@linux.vnet.ibm.com>
In-Reply-To: <8302be1b-416a-de32-c43b-73bd378f8122@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: g88aeaZRpnfP0PdxA02G1n1w3BlzCyqp
X-Proofpoint-GUID: st-v3kKNhM2pBCFgda0-Zy5gNWLuGVPD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_14,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305310170
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/25/23 4:08 AM, Alexander Lobakin wrote:
>> Any plans to add page pool fragmentation support (i.e.
>> PP_FLAG_PAGE_FRAG) in the future to better support architectures with
>> larger page sizes such as 64KB on ppc64le?
> 
> Currently no, we resigned from page fragmentation due to the complexity
> and restrictions it provides for no benefits on x86_64. But I remember
> that pages > 4 Kb exist (I have a couple MIPS boards where I have fun
> sometimes and page size is set to 16 Kb there. But still always use 1
> page per frame).
> By "better support" you mean reducing memory usage or something else?

Yes, reducing memory waste.  Current generation P10 systems default to 
quad-port, 10Gb copper i40e NICs.  When you combine a large number of 
CPUs, and therefore a large number of RX queues, with a 64KB page 
allocation per packet, memory usage can balloon very quickly as you add 
additional ports.

Would you be open to patches to address this further down the road as 
your refactoring effort gets closer to completion?

Dave

