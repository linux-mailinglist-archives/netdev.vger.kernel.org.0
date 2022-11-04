Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739D56198C0
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiKDOGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKDOGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:06:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6332024BE8
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 07:06:17 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4CI3C3029540;
        Fri, 4 Nov 2022 14:06:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zA4tPs7Lir5SHDesz0+4cEgKh7Kc6ERih+f0Qzr7fvs=;
 b=DqXy2eIx9xDabqac+1HeCAoMBrKo/MRoCaPF3FnFWzrr+APU2pKQbyOHZHLqGyU6e3ZU
 hx82IUD3j/Ltnq7ZKjqIpG/mUTaDYqo4MHoRbxJJ7U8gF7xCJJwzf631XhxK/sbWKVCW
 w2Npit1bU0MHZtbJY7QUyx6RCMv8BdUHXn/QuQU1yfTkMhHJTbzKkfrT6zrAzOBIk+Jz
 OW3YdYRZ3NRLWN6br26XXbvK+g+f3fbcsCxlNrw4QRQRqPiNqEhjBFkiube31qk4Zkmd
 P23h056ZzwQnsnVikhfgAhBQ6aB/TQycFpvha5BN66E1JP4AgUffaDspyI+A5WPwc7hM iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmyqw0s2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 14:06:09 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A4Buspw021147;
        Fri, 4 Nov 2022 14:06:08 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmyqw0s19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 14:06:08 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A4E5pho012225;
        Fri, 4 Nov 2022 14:06:06 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 3kgutbam93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 14:06:06 +0000
Received: from smtpav02.wdc07v.mail.ibm.com ([9.208.128.114])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A4E65tw58261764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Nov 2022 14:06:05 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0C8A5805E;
        Fri,  4 Nov 2022 14:06:04 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EEA85806B;
        Fri,  4 Nov 2022 14:06:03 +0000 (GMT)
Received: from [9.160.12.76] (unknown [9.160.12.76])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  4 Nov 2022 14:06:03 +0000 (GMT)
Message-ID: <4f84f10b-9a79-17f6-7e2e-f65f0d2934cb@linux.ibm.com>
Date:   Fri, 4 Nov 2022 09:06:02 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2 net] ibmveth: Reduce maximum tx queues to 8
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com, bjking1@linux.ibm.com,
        ricklind@us.ibm.com, dave.taht@gmail.com
References: <20221102183837.157966-1-nnac123@linux.ibm.com>
 <20221103205945.40aacd90@kernel.org>
From:   Nick Child <nnac123@linux.ibm.com>
In-Reply-To: <20221103205945.40aacd90@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 47eWspCDIqag6yCpCjR8RT4vuKbLkn_t
X-Proofpoint-GUID: AZO4tCKSRaiYux336WIYvgT7RLt1qAiN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_09,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0
 clxscore=1015 spamscore=0 mlxscore=0 mlxlogscore=555 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211040093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/3/22 22:59, Jakub Kicinski wrote:
> On Wed,  2 Nov 2022 13:38:37 -0500 Nick Child wrote:
>> Previously, the maximum number of transmit queues allowed was 16. Due to
>> resource concerns, limit to 8 queues instead.
>>
>> Since the driver is virtualized away from the physical NIC, the purpose
>> of multiple queues is purely to allow for parallel calls to the
>> hypervisor. Therefore, there is no noticeable effect on performance by
>> reducing queue count to 8.
> 
> I'm not sure if that's the point Dave was making but we should be
> influencing the default, not the MAX. Why limit the MAX?

The MAX is always allocated in the drivers probe function. In the 
drivers open and ethtool-set-channels functions we set 
real_num_tx_queues. So the number of allocated queues is always MAX
but the number of queues actually in use may differ and can be set by 
the user.
I hope this explains. Otherwise, please let me know.

Thanks again for taking the time to review,
Nick Child
