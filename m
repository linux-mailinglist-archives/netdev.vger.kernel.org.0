Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74BBC68078C
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 09:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235912AbjA3IiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 03:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235394AbjA3IiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 03:38:06 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CAE1204A;
        Mon, 30 Jan 2023 00:38:05 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30U6vN4M007482;
        Mon, 30 Jan 2023 08:38:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Cdkxg+xW+8P0QPbYyaaXnEj5NpJbFcN8CrtjbSiNIBo=;
 b=tdWHv+dxb4FDFNIL99L/+WtKsbmQW/Hpp9i/nw+0Uy5duwJ3gZW8H07XMIqQSxAI41Zz
 dfOWRyXM87ouii25gkD/I0dclfX4B0lzZQEfywPU/fs1Lw9UbwzmBGw0ihopE2B6koEi
 txcolqoB2MnSqHzC7Y8iDvPQErUTvOtkBuy8Zrw8f40TpxZq3YKL0E1Fx3RzvFduwCrw
 jDJJ9zPZSPRG1Ywr1pHC4tJ6su3QiAlYeimziKaID6dyzJPFu5XwV0PaHIuA+CVIBYBR
 lngQ2H22KlFs0qHPvRRAoMI54CRSgBi8twD1VdbgKhUbyyCxGBmZgVG+qDUc4zpUfcIV xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ne934abak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Jan 2023 08:38:01 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30U7Ecrv027301;
        Mon, 30 Jan 2023 08:38:00 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ne934aba4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Jan 2023 08:38:00 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30U5xOq2006488;
        Mon, 30 Jan 2023 08:37:59 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([9.208.130.100])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3ncvtm45an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Jan 2023 08:37:59 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30U8bwD77406164
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Jan 2023 08:37:58 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A9F45806C;
        Mon, 30 Jan 2023 08:37:58 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D77E5806A;
        Mon, 30 Jan 2023 08:37:56 +0000 (GMT)
Received: from [9.163.16.35] (unknown [9.163.16.35])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 30 Jan 2023 08:37:56 +0000 (GMT)
Message-ID: <c45960d9-c358-e47b-0a33-1de8c3a8f94c@linux.ibm.com>
Date:   Mon, 30 Jan 2023 09:37:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v6 1/7] net/smc: remove locks
 smc_client_lgr_pending and smc_server_lgr_pending
To:     "D. Wythe" <alibuda@linux.alibaba.com>, jaka@linux.ibm.com,
        kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1669453422-38152-1-git-send-email-alibuda@linux.alibaba.com>
 <1669453422-38152-2-git-send-email-alibuda@linux.alibaba.com>
 <2ad147d3-b127-b192-c2a5-29fa704cf3a1@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <2ad147d3-b127-b192-c2a5-29fa704cf3a1@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sJBST1Bs0wF95BoQDITdhkGdIGoC763i
X-Proofpoint-ORIG-GUID: 6MZ82YTCMQfVAXZkuHMTsR-T-r0cMhve
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-30_07,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 suspectscore=0 adultscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301300081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29.01.23 16:11, D. Wythe wrote:
> 
> 
> On 11/26/22 5:03 PM, D.Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>
>> This patch attempts to remove locks named smc_client_lgr_pending and
>> smc_server_lgr_pending, which aim to serialize the creation of link
>> group. However, once link group existed already, those locks are
>> meaningless, worse still, they make incoming connections have to be
>> queued one after the other.
>>
>> Now, the creation of link group is no longer generated by competition,
>> but allocated through following strategy.
>>
> 
> 
> Hi, all
> 
> I have noticed that there may be some difficulties in the advancement of 
> this series of patches.
> I guess the main problem is to try remove the global lock in this patch, 
> the risks of removing locks
> do harm to SMC-D, at the same time, this patch of removing locks is also 
> a little too complex.
> 
> So, I am considering that we can temporarily delay the advancement of 
> this patch. We can works on
> other patches first. Other patches are either simple enough or have no 
> obvious impact on SMC-D.
> 
> What do you think?
> 
> Best wishes.
> D. Wythe
> 
> 
Hi D. Wythe,

that sounds good. Thank you for your consideration about SMC-D!
Removing locks is indeed a big issue, those patches make us difficult to 
accept without thoroughly testing in every corner.

Best
Wenjia

