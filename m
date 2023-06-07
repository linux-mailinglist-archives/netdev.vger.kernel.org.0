Return-Path: <netdev+bounces-8787-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B913725C9A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:01:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 278641C20B16
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D99B48C01;
	Wed,  7 Jun 2023 11:01:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C909B3D64
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:01:49 +0000 (UTC)
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E6B1BDC
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:01:27 -0700 (PDT)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
	by m0050096.ppops.net-00190b01. (8.17.1.19/8.17.1.19) with ESMTP id 3579FAnk012451;
	Wed, 7 Jun 2023 11:59:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=jan2016.eng;
 bh=piaKUG/V4VSes/POTcsQCs2NT0nOvlUu/zR8FsH3nLM=;
 b=VZJf9HBmoPAV6vbDwLpCB8FgdVTyqPixZsWytUkP1vtClNrwRyTL+CK/xYbnsyyn92HP
 qOdJt8LsUIcbgaFqLJTaR626PuWJkmR3vZZWZL0915W0jMusJHcrspbDBuoAohm3Czgl
 7ID9ZIzR68vPkfnemKsPi4DUTbriBBUU+xNatI9oP9jIANgm2YVzGON4i566FSBmINvp
 tw8b2xQ9f0gbP6aolt1kOfyNgvzejpTZ4GANB+yxYKa4gn0wBgtd0bc3TCuTUxMEpxOh
 SfXDyrlfPmlnqirEonWOS3Hw76apK65LsH39hvtTTYe/4zE+eagZwZFaryGWVqrgOE1o 8A== 
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19] (may be forged))
	by m0050096.ppops.net-00190b01. (PPS) with ESMTPS id 3r2a8gv04f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Jun 2023 11:59:27 +0100
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
	by prod-mail-ppoint2.akamai.com (8.17.1.19/8.17.1.19) with ESMTP id 357AjsAn030461;
	Wed, 7 Jun 2023 06:59:26 -0400
Received: from email.msg.corp.akamai.com ([172.27.91.24])
	by prod-mail-ppoint2.akamai.com (PPS) with ESMTPS id 3r2ahtjn90-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Jun 2023 06:59:26 -0400
Received: from localhost (172.27.164.43) by
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Wed, 7 Jun 2023 06:59:25 -0400
Date: Wed, 7 Jun 2023 11:59:23 +0100
From: Max Tottenham <mtottenh@akamai.com>
To: Pedro Tammela <pctammela@mojatatu.com>
CC: Josh Hunt <johunt@akamai.com>, <netdev@vger.kernel.org>,
        Jamal Hadi Salim
	<jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko
	<jiri@resnulli.us>,
        Amir Vadai <amir@vadai.me>, kernel test robot
	<lkp@intel.com>
Subject: Re: [PATCH v2] net/sched: act_pedit: Parse L3 Header for L4 offset
Message-ID: <jjrg5bbt5ivalb3pd64z26rs5zcdjupaoct4f4vyybcn6bjrce@m677v5ggt6t3>
References: <20230526095810.280474-1-mtottenh@akamai.com>
 <5587e78a-acfe-edfa-6b6b-c35bea34f5a3@mojatatu.com>
 <b693fce4-7a05-ce88-ebe0-27b6fa03ed2f@mojatatu.com>
 <2d7ad6a9-2cd4-7936-7dc5-b6c79cd8c02e@akamai.com>
 <886e2fe3-1c24-c0d3-8434-964767fd03ad@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <886e2fe3-1c24-c0d3-8434-964767fd03ad@mojatatu.com>
X-Originating-IP: [172.27.164.43]
X-ClientProxiedBy: usma1ex-dag4mb1.msg.corp.akamai.com (172.27.91.20) To
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_06,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 mlxlogscore=798 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306070088
X-Proofpoint-GUID: _gTprCFubLGnjFFPjEVtT5VU2k5zUEa-
X-Proofpoint-ORIG-GUID: _gTprCFubLGnjFFPjEVtT5VU2k5zUEa-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_06,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=833
 phishscore=0 clxscore=1011 mlxscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306070090
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05/27, Pedro Tammela wrote:
> On 26/05/2023 18:54, Josh Hunt wrote:
> > On 5/26/23 7:03 AM, Pedro Tammela wrote:
> >> On 26/05/2023 10:47, Pedro Tammela wrote:
> >>>
> >>>> +
> >>>> +    switch (skb->protocol) {
> >>>> +    case htons(ETH_P_IP):
> >>>> +        if (!pskb_may_pull(skb, sizeof(*iph) + noff))
> >>>> +            goto out;
> >>>
> >>> I might have missed something but is this really needed?
> >>> https://elixir.bootlin.com/linux/latest/source/net/ipv4/ip_input.c#L456 
> >>
> >> Yes this obviously happens before the mentioned function.
> >> Now I'm wondering if it's not better to use skb_header_pointer() 
> >> instead...
> > 
> > Can you elaborate on why you think it would be better?
> > 
> 
> I don't have a strong argument for one over the other and I believe it's 
> fine as is.
> It just looks like 'skb_header_pointer()' is a more conservative 
> approach as ithas a smaller margin for errorwhen compared to 
> 'pskb_may_pull()'.
> But I shall admit that the errors conditions for 'pskb_may_pull()' are 
> extreme.
> 
Okay, I'm happy to re-spin a v3 addressing the above, and the other nits
you identified.

-- 
Max Tottenham | Senior Software Engineer
/(* Akamai Technologies

