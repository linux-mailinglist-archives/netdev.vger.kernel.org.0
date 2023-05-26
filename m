Return-Path: <netdev+bounces-5823-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A112713005
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 00:25:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF0A62819A0
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 22:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD92A2A9FC;
	Fri, 26 May 2023 22:24:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B295A2911B
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 22:24:59 +0000 (UTC)
X-Greylist: delayed 1813 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 26 May 2023 15:24:57 PDT
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD96119
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 15:24:57 -0700 (PDT)
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
	by mx0b-00190b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34QHHJ7f012838;
	Fri, 26 May 2023 22:54:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=ZDQHQgXXH0XYwiHgBwEStreNEkhoolEh0Pm1Bt77PvQ=;
 b=f9c2rN1w3LS0PZvWE+TRUksZX9g/cJKMozqv+bijXV3rmxS79TdkdrUzLG833Pz6VH5b
 iei1r/IvNMX2EWBTfilRsLaPbDbK6N2aOSU4hZ2NlChf2zpLV1RZ32cdV8ExmnagaM7C
 O1YvS9VtvENbhwZx4wWfjyeckB339EJ51EEZlAyl/6QV2W3EAEIR/G9K43r/Jeft+mfz
 7n7esdOsd9fNqtmOrxFZgTwV35DIF11JcYvAUYdGbDa3/oQMnHbQIZkAmhse/ep/JSv3
 wx6VTTmH+ch/PxYIGtwnk80VuuBUYfVhHw6xPmInjO8LStV65MyVAgJnvjKKjlPG93ct rw== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
	by mx0b-00190b01.pphosted.com (PPS) with ESMTPS id 3qu11g5umm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 May 2023 22:54:10 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
	by prod-mail-ppoint1.akamai.com (8.17.1.19/8.17.1.19) with ESMTP id 34QLba5v015764;
	Fri, 26 May 2023 17:54:09 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
	by prod-mail-ppoint1.akamai.com (PPS) with ESMTP id 3qpshwah11-1;
	Fri, 26 May 2023 17:54:09 -0400
Received: from [100.64.0.1] (prod-aoa-csiteclt14.bos01.corp.akamai.com [172.27.97.51])
	by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 3AA3761E11;
	Fri, 26 May 2023 21:54:08 +0000 (GMT)
Message-ID: <2d7ad6a9-2cd4-7936-7dc5-b6c79cd8c02e@akamai.com>
Date: Fri, 26 May 2023 14:54:07 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2] net/sched: act_pedit: Parse L3 Header for L4 offset
Content-Language: en-US
To: Pedro Tammela <pctammela@mojatatu.com>,
        Max Tottenham <mtottenh@akamai.com>, netdev@vger.kernel.org
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang
 <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Amir Vadai <amir@vadai.me>,
        kernel test robot <lkp@intel.com>
References: <20230526095810.280474-1-mtottenh@akamai.com>
 <5587e78a-acfe-edfa-6b6b-c35bea34f5a3@mojatatu.com>
 <b693fce4-7a05-ce88-ebe0-27b6fa03ed2f@mojatatu.com>
From: Josh Hunt <johunt@akamai.com>
In-Reply-To: <b693fce4-7a05-ce88-ebe0-27b6fa03ed2f@mojatatu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_11,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 mlxlogscore=936 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260187
X-Proofpoint-ORIG-GUID: vCHSdlJ_m9dn8xoFcG5zc_v9aw5OWsyl
X-Proofpoint-GUID: vCHSdlJ_m9dn8xoFcG5zc_v9aw5OWsyl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_10,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0
 mlxlogscore=859 spamscore=0 mlxscore=0 clxscore=1011 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260188
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_LOW,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/26/23 7:03 AM, Pedro Tammela wrote:
> On 26/05/2023 10:47, Pedro Tammela wrote:
>>
>>> +
>>> +    switch (skb->protocol) {
>>> +    case htons(ETH_P_IP):
>>> +        if (!pskb_may_pull(skb, sizeof(*iph) + noff))
>>> +            goto out;
>>
>> I might have missed something but is this really needed?
>> https://urldefense.com/v3/__https://elixir.bootlin.com/linux/latest/source/net/ipv4/ip_input.c*L456__;Iw!!GjvTz_vk!TyuEOA10ZxgU7TBKFX6HAZ359qEMEuo3H0jNMIF1EP75tQbrs8uiSNQSpaaW4N34AH1sCdf5vHcUrV0qsw$ 
> 
> Yes this obviously happens before the mentioned function.
> Now I'm wondering if it's not better to use skb_header_pointer() instead...

Can you elaborate on why you think it would be better?

Thanks
Josh

