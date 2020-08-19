Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F41924A5C7
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 20:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgHSSRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 14:17:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54780 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726435AbgHSSRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 14:17:22 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JI4B1u128938;
        Wed, 19 Aug 2020 14:17:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=RjslbRhYQcVscmXUK33LJ6GMRcF2scrPR4NsyNA80rg=;
 b=ABxibEDEgwgmMpMEJGD54Q4e9Mdds2PJsu2w/yPe9kww57IDcA72bxj30EJMUTlhKctA
 g/3Uw1eLlykFCE59x+Chrd61sZnPW88ExW7MkfRd8pd15nEpqvjob9lrycJJApPjDIul
 qowatHco72uW4/TvygIlpC8x7UdBjhGsOCJVH95J4s2y3Q21q3T8jM+V2KH3RDOeLjE1
 L1Fa1OmnU01X02pJQwCWujJA0H59v52p+Z5ngzejpmFyv82RH8/jj1eOh2mWZt1xxFtt
 X+26dL4a2m4HZvy6+rHD8H/Uyc1Pb9cqtDg9ZNdeBhE36LLGafcn/2imMJzwbkmaP8wH FQ== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3317aabh8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 14:17:19 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07JIAXwP012239;
        Wed, 19 Aug 2020 18:17:18 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 3304tgwwrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 18:17:18 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07JIHIfT49086830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 18:17:18 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAA16AE05F;
        Wed, 19 Aug 2020 18:17:17 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69709AE05C;
        Wed, 19 Aug 2020 18:17:17 +0000 (GMT)
Received: from Criss-MacBook-Pro.local (unknown [9.211.59.12])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Wed, 19 Aug 2020 18:17:17 +0000 (GMT)
From:   Cris Forno <cforno12@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, drt@linux.vnet.ibm.com
Subject: Re: [PATCH, net-next, v2] ibmvnic: store RX and TX subCRQ handle array in ibmvnic_adapter struct
In-Reply-To: <20200818.154401.826640119439302130.davem@davemloft.net>
References: <20200818215333.53183-1-cforno12@linux.ibm.com> <20200818.154401.826640119439302130.davem@davemloft.net>
Date:   Wed, 19 Aug 2020 13:17:07 -0500
Message-ID: <m2y2mabivw.fsf@Criss-MacBook-Pro.local.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_11:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 malwarescore=0 suspectscore=1 spamscore=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 clxscore=1011 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Cristobal Forno <cforno12@linux.ibm.com>
> Date: Tue, 18 Aug 2020 16:53:33 -0500
>
>> @@ -1524,7 +1519,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
>>  	unsigned int offset;
>>  	int num_entries = 1;
>>  	unsigned char *dst;
>> -	u64 *handle_array;
>> +	u64 handle;
>>  	int index = 0;
>>  	u8 proto = 0;
>>  	netdev_tx_t ret = NETDEV_TX_OK;
>
> Please preserve the reverse christmas tree ordering of local variables
> here.
Sorry, missed that. Sent v3. Thanks David!

--Cris Forno
>
> Otherwise the patch looks fine to me.
