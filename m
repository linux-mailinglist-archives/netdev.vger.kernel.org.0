Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A07038FE74
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 12:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhEYKMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 06:12:44 -0400
Received: from mx0a-001ae601.pphosted.com ([67.231.149.25]:6836 "EHLO
        mx0b-001ae601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229736AbhEYKMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 06:12:42 -0400
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
        by mx0a-001ae601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14PA91ts027231;
        Tue, 25 May 2021 05:10:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=PODMain02222019;
 bh=WFgu6DFwy2WHh/imDJFsOlDQBzrymeuswN2nsrye4wg=;
 b=JAEl/6RS+oPDAYoggZYtu3qe7O4J7IJaqP/zx+82jk9AnpuzSw6UNwveuvSVr8kGZ179
 ksWF9qRuLWSw/TBjCRa0OPj4I4Tx+kvPXcTQHXUqBRIzLYiTp4mSZssRVFtD8tUp6rSb
 MOwftpvIM5Lm8NnpG9I47maLsmHGchqeAs3UAW9/TRtF6PkgNSRjLN0atQqslJ7jr+dE
 WcfQkXJdrACeUT+ZMi2FeGFkz22lC/CJ1ZMFEuJrKUrZEVuC8M9GNk8J64lTNTmyA3Zb
 QfDJdXk/Iznw3ZjmDZcjhL2VwhKVztnRI0NWdpYGUPwq+XMEjfaXyzFzJUofjOuat6aG nQ== 
Received: from ediex01.ad.cirrus.com ([87.246.76.36])
        by mx0a-001ae601.pphosted.com with ESMTP id 38r7ck9fse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 25 May 2021 05:10:13 -0500
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 25 May
 2021 11:10:11 +0100
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.2242.4 via Frontend
 Transport; Tue, 25 May 2021 11:10:11 +0100
Received: from [10.0.2.15] (AUSNPC0LSNW1.ad.cirrus.com [198.61.64.127])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id 5331F11CD;
        Tue, 25 May 2021 10:10:10 +0000 (UTC)
Subject: Re: [PATCH 1/2] lib: test_scanf: Fix incorrect use of type_min() with
 unsigned types
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>, <pmladek@suse.com>,
        <rostedt@goodmis.org>, <sergey.senozhatsky@gmail.com>,
        <andriy.shevchenko@linux.intel.com>, <w@1wt.eu>, <lkml@sdf.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <patches@opensource.cirrus.com>
References: <20210524155941.16376-1-rf@opensource.cirrus.com>
 <20210524155941.16376-2-rf@opensource.cirrus.com>
 <a3396d45-4720-ee30-6493-b19f90c74e54@rasmusvillemoes.dk>
From:   Richard Fitzgerald <rf@opensource.cirrus.com>
Message-ID: <0650840d-1b7d-3bc0-c04f-3a22ddc1ced1@opensource.cirrus.com>
Date:   Tue, 25 May 2021 11:10:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <a3396d45-4720-ee30-6493-b19f90c74e54@rasmusvillemoes.dk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: VJKQP3m6ElqTCe9jMRLQEGpPEhXd0dpr
X-Proofpoint-ORIG-GUID: VJKQP3m6ElqTCe9jMRLQEGpPEhXd0dpr
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250067
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/05/2021 10:55, Rasmus Villemoes wrote:
> On 24/05/2021 17.59, Richard Fitzgerald wrote:
>> sparse was producing warnings of the form:
>>
>>   sparse: cast truncates bits from constant value (ffff0001 becomes 1)
>>
>> The problem was that value_representable_in_type() compared unsigned types
>> against type_min(). But type_min() is only valid for signed types because
>> it is calculating the value -type_max() - 1.

Ok, I see I was wrong about that. It does in fact work safely. Do you
want me to update the commit message to remove this?

> 
> ... and casts that to (T), so it does produce 0 as it should. E.g. for
> T==unsigned char, we get
> 
> #define type_min(T) ((T)((T)-type_max(T)-(T)1))
> (T)((T)-255 - (T)1)
> (T)(-256)
> 

sparse warns about those truncating casts.

> which is 0 of type unsigned char.
> 
> The minimum value of an
>> unsigned is obviously 0, so only type_max() need be tested.
> 
> That part is true.
> 
> But type_min and type_max have been carefully created to produce values
> of the appropriate type that actually represent the minimum/maximum
> representable in that type, without invoking UB. If this program doesn't
> produce the expected results for you, I'd be very interested in knowing
> your compiler version:
> 

 From the kernel test robot report:

compiler: m68k-linux-gcc (GCC) 9.3.0
reproduce:
         wget 
https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross 
-O ~/bin/make.cross
         chmod +x ~/bin/make.cross
         # apt-get install sparse
         # sparse version: v0.6.3-341-g8af24329-dirty
         # 
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=50f530e176eac808e64416732e54c0686ce2c39b
         git remote add linux-next 
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
         git fetch --no-tags linux-next master
         git checkout 50f530e176eac808e64416732e54c0686ce2c39b
         # save the attached .config to linux build tree
         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cro

I get the same warnings with Linaro GCC 7.5-2019.12) and sparse
v0.6.3-184-g1b896707.

> #include <stdio.h>
> 
> #define is_signed_type(type)       (((type)(-1)) < (type)1)
> #define __type_half_max(type) ((type)1 << (8*sizeof(type) - 1 -
> is_signed_type(type)))
> #define type_max(T) ((T)((__type_half_max(T) - 1) + __type_half_max(T)))
> #define type_min(T) ((T)((T)-type_max(T)-(T)1))
> 
> int main(int argc, char *argv[])
> {
> #define p(T, PT, fmt) do {					\
> 		PT vmin = type_min(T);				\
> 		PT vmax = type_max(T);				\
> 		printf("min(%s) = "fmt", max(%s) = "fmt"\n",#T, vmin, #T, vmax); \
> 	} while (0)
> 
> 	p(_Bool, int, "%d");
> 	p(unsigned char, int, "%d");
> 	p(signed char, int, "%d");
> 	p(unsigned int, unsigned int, "%u");
> 	p(unsigned long long, unsigned long long, "%llu");
> 	p(signed long long, signed long long, "%lld");
> 	
> 	return 0;
> }
> 
> 
> 
>>   lib/test_scanf.c | 13 ++++++-------
>>   1 file changed, 6 insertions(+), 7 deletions(-)
>>
>> diff --git a/lib/test_scanf.c b/lib/test_scanf.c
>> index 8d577aec6c28..48ff5747a4da 100644
>> --- a/lib/test_scanf.c
>> +++ b/lib/test_scanf.c
>> @@ -187,8 +187,8 @@ static const unsigned long long numbers[] __initconst = {
>>   #define value_representable_in_type(T, val)					 \
>>   (is_signed_type(T)								 \
>>   	? ((long long)(val) >= type_min(T)) && ((long long)(val) <= type_max(T)) \
>> -	: ((unsigned long long)(val) >= type_min(T)) &&				 \
>> -	  ((unsigned long long)(val) <= type_max(T)))
>> +	: ((unsigned long long)(val) <= type_max(T)))
> 
> 
> With or without this, these tests are tautological when T is "long long"
> or "unsigned long long". I don't know if that is intended. But it won't,
> say, exclude ~0ULL if that is in the numbers[] array from being treated
> as fitting in a "long long".

I don't entirely understand your comment. But the point of the test is
to exclude values that can't be represented by a type shorter than
long long or unsigned long long.
> 
> Rasmus
> 
