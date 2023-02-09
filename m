Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E516B69097B
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 14:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjBINDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 08:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjBINDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 08:03:47 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4321F55E5C;
        Thu,  9 Feb 2023 05:03:46 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319Aos02012256;
        Thu, 9 Feb 2023 13:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BLjD8KvZ57Itgt7rWzh3m2fdoFB6Z/3jt3U5rrkKw14=;
 b=JJ4hQzsX/6Aw8EgKkpUVmV8wbQxhvbNemHMe3geVUYb+C8osJ6r8N9imVLtujwImUd70
 x+uxrZra3OSe7SaUc9wBV0OjuYdKkea8lJwaUjlspI5tyh5qHfP3rxAGE3Gtj0BRGROT
 G+1fO/sEstKoaEu3pgtImpOmumrZp/Y+5f9iiCth81qVOXtOUH+e7cTYW4MRPMNTz4i8
 xNX4f7hw62dlgPI2TGlX/dxBtos4O8A2fHyG2+VCTWpQpHh4I8yweaz6X6M9mhGFtIwS
 QcqGXbaXVksPkyfrjYynrJKfSoR/EuM8mtIQSWlvFMpdh2xHedx6iBc6j/uyXDwh321B oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmyeju3er-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 13:03:30 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 319D1HLb022104;
        Thu, 9 Feb 2023 13:03:29 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmyeju3ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 13:03:29 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 319CPvOT020984;
        Thu, 9 Feb 2023 12:57:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3nhemfp7vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 12:57:09 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319Cv58324052090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 12:57:05 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E8512004E;
        Thu,  9 Feb 2023 12:57:05 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2604620043;
        Thu,  9 Feb 2023 12:57:05 +0000 (GMT)
Received: from [9.179.13.205] (unknown [9.179.13.205])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Feb 2023 12:57:05 +0000 (GMT)
Message-ID: <36189f0d-82ec-36f8-c093-1947ebbe3160@linux.ibm.com>
Date:   Thu, 9 Feb 2023 13:57:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v2 3/4] s390/qeth: Convert sysfs sprintf to
 sysfs_emit
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Jules Irenge <jbi.octave@gmail.com>,
        Joe Perches <joe@perches.com>
References: <20230209110424.1707501-1-wintera@linux.ibm.com>
 <20230209110424.1707501-4-wintera@linux.ibm.com>
 <Y+TYo2UXuVQuXGrY@corigine.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <Y+TYo2UXuVQuXGrY@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _erlYM-avXarxrSJyw8y1vakVMre_GuU
X-Proofpoint-ORIG-GUID: DOEImqCSbduulk7Aww1WhdY1a6xCz_6V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_08,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 phishscore=0 priorityscore=1501 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=611 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090120
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09.02.23 12:27, Simon Horman wrote:
> On Thu, Feb 09, 2023 at 12:04:23PM +0100, Alexandra Winter wrote:
>> From: Thorsten Winkler <twinkler@linux.ibm.com>
...
>>  
>> -		entry_len = qeth_l3_ipaddr_to_string(proto, ipatoe->addr,
>> -						     addr_str);
>> -		if (entry_len < 0)
>> -			continue;
> 
> Here the return code of qeth_l3_ipaddr_to_string() is checked for an error.
> 
>> -
>> -		/* Append /%mask to the entry: */
>> -		entry_len += 1 + ((proto == QETH_PROT_IPV4) ? 2 : 3);
>> -		/* Enough room to format %entry\n into null terminated page? */
>> -		if (entry_len + 1 > PAGE_SIZE - str_len - 1)
>> -			break;
>> -
>> -		entry_len = scnprintf(buf, PAGE_SIZE - str_len,
>> -				      "%s/%i\n", addr_str, ipatoe->mask_bits);
>> -		str_len += entry_len;
>> -		buf += entry_len;
>> +		qeth_l3_ipaddr_to_string(proto, ipatoe->addr, addr_str);
> 
> But here it is not. Is that ok?
> 
> Likewise in qeth_l3_dev_ip_add_show().

As you pointed out in your comments to patch 4/4 v1, qeth_l3_ipaddr_to_string()
will never return a negative value, as it only returns the result of s*printf()
which at least in this usecase here will never return < 0.

