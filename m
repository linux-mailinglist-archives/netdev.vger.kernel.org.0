Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE6068F6CD
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 19:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbjBHSTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 13:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbjBHSTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 13:19:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD0F521C6;
        Wed,  8 Feb 2023 10:19:42 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 318IACvt017629;
        Wed, 8 Feb 2023 18:19:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date : from
 : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Cat40qxwJuXwH7djamxVS8eFCLmklYkpm2R0WNxYhUU=;
 b=cHoUhpHr5z6sCRHPxYKOgBOkg47WEsrVIO2psXyxiDZoCOVp3nZbCtOFXEvkSHNpCjDC
 DvCj0w9yV0T235Ow2JWapFZ6YJ/ub30Ha/9nMfeKlUkJ4ydnFzck3XIK2g0y5iidbGNT
 +Me6acKOANRFI74L1kT5/e6gg7Qgo2rtncAKWIhNHW9lAOrm/kZneoUiv1+XjGjtDxw4
 FnjkkxUWIxDgCBSFDbvoJwykaxvIvzh4RRCGGOpokcXhyXV24mGZoWXbyVBkE6Hm1LXw
 zQePWEVJoFENIDZIHxCyXqRJsilTh3+g6zoWzfUQuWv1pfrN/KR4R5GcJMv0DziCNhuC Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmgc20pr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 18:19:37 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 318IDTYq030351;
        Wed, 8 Feb 2023 18:19:36 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmgc20pqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 18:19:36 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 318IJUOE024491;
        Wed, 8 Feb 2023 18:19:34 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3nhemfkqvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 18:19:33 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 318IJUq922086090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Feb 2023 18:19:30 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 265E22004B;
        Wed,  8 Feb 2023 18:19:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A09702004F;
        Wed,  8 Feb 2023 18:19:29 +0000 (GMT)
Received: from [9.171.33.244] (unknown [9.171.33.244])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  8 Feb 2023 18:19:29 +0000 (GMT)
Message-ID: <045d16d2-fca2-4dbe-e999-05d5365da1ad@linux.ibm.com>
Date:   Wed, 8 Feb 2023 19:19:29 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
From:   Alexandra Winter <wintera@linux.ibm.com>
Subject: Re: [PATCH net-next 4/4] s390/qeth: Convert sprintf/snprintf to
 scnprintf
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Jules Irenge <jbi.octave@gmail.com>
References: <20230206172754.980062-1-wintera@linux.ibm.com>
 <20230206172754.980062-5-wintera@linux.ibm.com>
 <Y+JxcPOJiRl0qMo1@corigine.com>
Content-Language: en-US
In-Reply-To: <Y+JxcPOJiRl0qMo1@corigine.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s90Dxlqn8dR7jSqNS4ICbZclar9qCm36
X-Proofpoint-GUID: Cl8H23vKJaRDzsCnF6wYjn9BrHw0HPkh
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_08,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxscore=0 bulkscore=0 clxscore=1015 phishscore=0 adultscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302080158
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07.02.23 16:42, Simon Horman wrote:
> On Mon, Feb 06, 2023 at 06:27:54PM +0100, Alexandra Winter wrote:
>> From: Thorsten Winkler <twinkler@linux.ibm.com>
>>
>> This LWN article explains the rationale for this change
>> https: //lwn.net/Articles/69419/
> 
> https://lwn.net/Articles/69419/
> 
>> Ie. snprintf() returns what *would* be the resulting length,
>> while scnprintf() returns the actual length.
> 
> Ok, but in most cases in this patch the return value is not checked.
> Is there any value in this change in those cases?
> 

Jules Irenge reported a coccinnelle warning to use scnprintf in 
show() functions [1]. (Thorsten Winkler changed these instances to
sysfs_emit in patch 3 of this series.)
We read the article as a call to implement the plan to upgrade the kernel
to the newer *scnprintf functions. Is that not intended?

I totally agree, that in these cases no real problem was fixed, it is
more of a style improvement.

[1] https://lore.kernel.org/netdev/YzHyniCyf+G%2F2xI8@fedora/T/

>> Reported-by: Jules Irenge <jbi.octave@gmail.com>
>> Reviewed-by: Alexandra Winkler <wintera@linux.ibm.com>
> 
> s/Winkler/Winter/ ?

Of course. Wow, you have good eyes!

> 
>> Signed-off-by: Thorsten Winkler <twinkler@linux.ibm.com>
>> Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
> 
> ...
> 
>> diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
>> index 1cf4e354693f..af4e60d2917e 100644
>> --- a/drivers/s390/net/qeth_l3_main.c
>> +++ b/drivers/s390/net/qeth_l3_main.c
>> @@ -47,9 +47,9 @@ int qeth_l3_ipaddr_to_string(enum qeth_prot_versions proto, const u8 *addr,
>>  			     char *buf)
>>  {
>>  	if (proto == QETH_PROT_IPV4)
>> -		return sprintf(buf, "%pI4", addr);
>> +		return scnprintf(buf, INET_ADDRSTRLEN, "%pI4", addr);
>>  	else
>> -		return sprintf(buf, "%pI6", addr);
>> +		return scnprintf(buf, INET6_ADDRSTRLEN, "%pI6", addr);
>>  }
> 
> 
> This seems to be the once case where the return value is not ignored.
> 
> Of the 4 callers of qeth_l3_ipaddr_to_string, two don't ignore the return
> value. And I agree in those cases this change seems correct.
> 
> However, amongst other usages of the return value,
> those callers also check for a return < 0 from this function.
> Can that occur, in the sprintf or scnprintf case?

I was under the impression this was a safeguard against a bad address format,
but I tried it out and it never resulted in a negative return.
Thanks a lot for pointing this out, we can further simplify patch 3 with that.
