Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E89308FAD
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 22:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbhA2Vzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 16:55:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43844 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbhA2Vzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 16:55:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TLioHk024616;
        Fri, 29 Jan 2021 21:54:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Ms4fuzYTFV5hwpaintqo+JVSmWGUE6Sjgo7LCJJH1+k=;
 b=ydGhGc8jhHBW3HQAwO/gryo3LRD9VMquABsu5pgEkfBEcF5PPCDlKQKb/qqwRlKXOupv
 t1BDgJTh0G7hYtD5Vs9W0DtV6scLIZTmOXSqww0TrqhkKHOewWtn1mFkpTOZgNbGbkTq
 9pXKKFfnyLKkkrsy3U9CZEoaC5EgjSm1ltXt7O7TOet+iu0jVfpWc50Ww/AmtQ4YKxnl
 PCWh+Ehtw7bIu2WZgIuR023bVZTMLxBWKdsr+kSWogXfQsbvD52wAPnV2HJye5ZSfnpN
 3nEoYYkcr18gpLgT7/E7G/Mm+CktfwFXSZHts9FkF+tFbgD0JDTvqfjkJliHEsPeRw1Q qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36cmf89pp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 21:54:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TLduwb011038;
        Fri, 29 Jan 2021 21:54:50 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2054.outbound.protection.outlook.com [104.47.44.54])
        by userp3020.oracle.com with ESMTP id 36ceuh9rxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 21:54:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9MmvmoCVUKl43+nFYHsE9w8AYT9QN/C5wWTNpA8y3gnHxQ1mLQmN7gqyeJMI8lkNbFuXHEBX/nrE08vL92QB8BAYvxhf9hZPcTm/BhsIUJb0khTr63olHSOHjbswjxhe3cfEUG5vmawmAPSWRzbbDnF5nVpHGpGyn2gqihJC11HEpg4NQr/OyZAbLevZPZdPE+pxERlhKMvhVLD1W7WzO4uQod/r8zSgzaRiyTpMxUbQ1EfsC2AnsOV6AJ1luiQUpck4iicOmW/QivV/pKwAw3xL6/EAXSj747miHhELhTYw0chWjU3xKpp+Q7uPl9FFPSQVQADMr4aTayiGAbc7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ms4fuzYTFV5hwpaintqo+JVSmWGUE6Sjgo7LCJJH1+k=;
 b=Ljg6RHYj9RBb1kJ/bMM1Erypk8EuwjrWnrm0X/GWlYzDCMQrBAdEySbcW7zqqd9vXAVb7xfzvaRBWSv4xNfOdByobXCEALCjPLdjEORh2wO/uEWdwJ1O/P4evTxYke+S6HjTJckexKEZGwYFhLtQ5kDJCkOZ+5xgesWQAZo1Sm0hhk8BXOWDEw7DPUd+V4dqJvrXosiMW94X/HZ6r1MqEaljJPMIW4bSGqD7cJhLB9EzZ5o230dV+cRMlzjf7YB04mz5CKuPVnAC07V8NS+r2Dfz1zgGT0NtSH3/nIGkTrPebdE5V1DLpkWwoejS+anTBgIh3OwUzt0auolklEpYsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ms4fuzYTFV5hwpaintqo+JVSmWGUE6Sjgo7LCJJH1+k=;
 b=ZQnM4wl0CVWFBKEGcIxJgbSQTYMxYMNSdXRH8SjLTwwWF95uvFHNFVqEzQfFZQsAfCeT+f3A3dInONWXK9bWVgCvh0y7ci9qnmnH8dHW+vT11jLiRVuvmLL1I8OTAHs43XARt9b1ef9bjxhW/KO73PxVqLUtn+G2etpubvRJCLo=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB4496.namprd10.prod.outlook.com (2603:10b6:a03:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 21:54:48 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::7445:f44:72aa:da07]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::7445:f44:72aa:da07%4]) with mapi id 15.20.3805.017; Fri, 29 Jan 2021
 21:54:47 +0000
Subject: Re: [PATCH] af_unix: Allow Unix sockets to raise SIGURG
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        andy.rudoff@intel.com
References: <20210122150638.210444-1-willy@infradead.org>
 <20210125153650.18c84b1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <23fc3de2-7541-04c9-a56f-4006a7dc773f@oracle.com>
 <20210129110605.54df8409@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a21dc26a-87dc-18c8-b8bd-24f9797afbad@oracle.com>
 <20210129120250.269c366d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cef52fb0-43cb-9038-7e48-906b58b356b6@oracle.com>
 <20210129121837.467280fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <e1047be3-2d53-49d3-67b4-a2a99e0c0f0f@oracle.com>
 <20210129131820.4b97fdeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <ba1881e4-d7be-1ea3-3e7f-f27729130f30@oracle.com>
Date:   Fri, 29 Jan 2021 13:54:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210129131820.4b97fdeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: CH2PR05CA0034.namprd05.prod.outlook.com (2603:10b6:610::47)
 To SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:7446:8000::d55] (2606:b400:8301:1010::16aa) by CH2PR05CA0034.namprd05.prod.outlook.com (2603:10b6:610::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.10 via Frontend Transport; Fri, 29 Jan 2021 21:54:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3060a2c2-0de9-43b5-245b-08d8c4a07eeb
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4496:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB449625255B601C53AB1FBEECEFB99@SJ0PR10MB4496.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oR51HjaBNQKvuSdFXUHikQxfjGqYZtBVvO1HOlO7pu1nnHsBRPaxd/BLs5F2shxP4YwUmcyen22l9117GZopJXd29XBijsB852srgZBC2bgViVqH+OBocapTHxB/tBUBHYyTroL8YRKoeckYNDLiFhyaOWknhboBcRgTc+eowWlVOWu0eNyfBMR4tSnaMGdQUhtJ+jyt8RExhrNR1I34e8d7TJaAAaMFRCwqhNbiX05G1wTVVZ5bTGtdfRGE/6lY70VeJKMBPG5NRd2PlLfzs2jlPAg1aeS903rttmMCI0+1rBAmkR9CR0bdOVwI9OBTkjClZEWrRRo/zrzUf1noBzgJRRwun69Jdd3Ms1QLFm9yEn5ydoUBWytnX+DHOAIgLgzDZgJl9DTZ+yoQSGQBlFYE+vk4VAW6Npp7rZaDeYpbNWM2Dx/2fVUOtb7iuHArNR5lRHo/2+MBaM85jdO1pd6upyjzxjH+Vae96bI+xWN11wKR0m+V5Z7ib3K2xEYbyjo6uCW3OpTy9MaxOJpKbKsTwL3LccXgoNUrsjHJ71bjzEGQzs1xvueZfvhmRT1rqfu7dHXrfqtm3O4nM5+3oa7CFXeEVqS2caewO2jeKKw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(136003)(346002)(39860400002)(316002)(54906003)(8936002)(2616005)(8676002)(66476007)(66946007)(53546011)(66556008)(86362001)(6916009)(31696002)(2906002)(186003)(5660300002)(478600001)(31686004)(6486002)(4326008)(16526019)(36756003)(83380400001)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?czRUMVhvV09JK3RHOU41aVU5U0JYaWNqSmY5blpaNkxWOXVrcFF1cDhFMFN2?=
 =?utf-8?B?eURqajh5ZWkzWlJKTm95WG9TUmd1dU16UlNZTFdML2hib2JqNEE4aThvQjNk?=
 =?utf-8?B?QjN2TnNHbUJVbE1ZTkhjOHpDTFhEcGhVNDlDdU9LY2RTQk5ubFJabG1GSmNG?=
 =?utf-8?B?YkgvazE2WlhOWmV3bDB6MWFRN0V0TWV4VWFEYWcyOGIyclVnaDI5alBkWTJY?=
 =?utf-8?B?aGlYRmd2YXRhWElJS3U4TzlEcGhvT2wwTlhYZFVDRW5QT2hUcERwc2VXSmF3?=
 =?utf-8?B?NUw1VkJabUxLNzhhOU90djJ1SFVnSGx1SkIzZi9WTkxMdkZxaEMwQy8ySUtn?=
 =?utf-8?B?SlE0cFYxMWkySXg2QmI2a2psdGhLS3kwMTRYY01zdVlUbDJpT2cwdWdJTm10?=
 =?utf-8?B?MzRaUWFCZDBJQk4vYWRSaXlSMnF2aWltODNxOHQ0ajNzQ0RoY2Z4UnBTUFlj?=
 =?utf-8?B?Q0lrZjNpdk1FUjJaTllXeldhRG1RZUxBbzMyRVk0QnF3NVR4c0k3MkUzbGUw?=
 =?utf-8?B?azUrc3Y3QUxxNTRVbGRvUFc1L0N0V1RKZG5qOWUyUStsM0dGWmtUZmV3b082?=
 =?utf-8?B?SG9nbWlITE9uK0FuK1g0cGVXS2VqK2VMc3FpY2U1VEc1aFZhSWF1aUJ4dlZK?=
 =?utf-8?B?emFwd1FJNnFlZ0JYNVlsZnJwU3F6cWdsYTFmN2FobEwzYnRES3puMFJRTFlo?=
 =?utf-8?B?b3VxN1RSLzNJT2p5em9mOWN4UzloUm5oTXpFTlowbWVtbWhNbnc1eHRmWnhq?=
 =?utf-8?B?dDNlYTdreitmRDZsZktiK2w2NDNab3QyUHhLTld6clhuRXhMdTN6UlhpcWdq?=
 =?utf-8?B?TnhQY2VUUjlBeThjZGJoNk9PT0lrbHJOZmFyTXVnbG95dFRQQUU4YmtUMXRC?=
 =?utf-8?B?TElSMGFna3ZDRmNta0gza1lIVFRwdUY3eU5YU3pxN0R6SXhWc1RhakNGTXVC?=
 =?utf-8?B?UzAzU0JpaERrenFJc1BGWHc0U1M2YTVKSjRCZ1N1bzJ3LzE5ZEsyMHg0Z09y?=
 =?utf-8?B?ODJ2YVMzZDE3RGxxUTk4b2pHSkxGRkd4b1Q4cVJwb1hZaXBjdU5mY0V1b1Fm?=
 =?utf-8?B?VDFmNjMvdzNQMjhoMzZMNVk0cmkvNmw3ZGZGTmJ5bFJyMGNmZ0JpVXl0amwr?=
 =?utf-8?B?NlZxSE94ZVEvQ29EdTZ5M3FXWHdtYjdMN0kzS2R6dTd5RW5MVjJKZE9TTU5B?=
 =?utf-8?B?UU1VZ3p1Y1VnaTVzcUFzRi9CSXk0QTJkZWJnQjZvSFVXRmFjdW15UjFCUU9x?=
 =?utf-8?B?bXN4V1JqN3R0WXY4WHNnYUZQVHhoZll0UW0rMHNoKytrZXRtaFZKYlBVNXNw?=
 =?utf-8?B?WUNja1E3ZjlwYW1VN0JSakpJL0ZRdUdnRWNxazVJQThYV0xoRnRYNXhuRmpy?=
 =?utf-8?B?cW9KOEdTekJWT016djBYYTVpb0xtMytjWGgxYzFTYitNMExaeTc3SFVmblRL?=
 =?utf-8?B?NStaZWlMN1lyVkRGSzAwa3NVOTVueUxXMlFGQUNBbnhEVWc4MlBlSG83Umx3?=
 =?utf-8?Q?jKA4sQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3060a2c2-0de9-43b5-245b-08d8c4a07eeb
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 21:54:47.8366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wHEzhMTU9JxBqt+vCm/U50zDk6Vuyi+iSkdwMvgPLS7ncTGbgqEwsT8MSuaiskG4ukRxICIQneWg8ViPLIBC/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4496
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290106
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/29/21 1:18 PM, Jakub Kicinski wrote:
> On Fri, 29 Jan 2021 12:44:44 -0800 Shoaib Rao wrote:
>> On 1/29/21 12:18 PM, Jakub Kicinski wrote:
>>> On Fri, 29 Jan 2021 12:10:21 -0800 Shoaib Rao wrote:
>>>> The code does not care about the size of data -- All it does is that if
>>>> MSG_OOB is set it will deliver the signal to the peer process
>>>> irrespective of the length of the data (which can be zero length). Let's
>>>> look at the code of unix_stream_sendmsg() It does the following (sent is
>>>> initialized to zero)
>>> Okay. Let me try again. AFAICS your code makes it so that data sent
>>> with MSG_OOB is treated like any other data. It just sends a signal.
>> Correct.
>>> So you're hijacking the MSG_OOB to send a signal, because OOB also
>>> sends a signal.
>> Correct.
>>>    But there is nothing OOB about the data itself.
>> Correct.
>>>    So
>>> I'm asking you to make sure that there is no data in the message.
>> Yes I can do that.
>>> That way when someone wants _actual_ OOB data on UNIX sockets they
>>> can implement it without breaking backwards compatibility of the
>>> kernel uAPI.
>> I see what you are trying to achieve. However it may not work.
>>
>> Let's assume that __actual__ OOB data has been implemented. An
>> application sends a zero length message with MSG_OOB, after that it
>> sends some data (not suppose to be OOB data). How is the receiver going
>> to differentiate if the data an OOB or not.
> THB I've never written any application which would use OOB, so in
> practice IDK. But from kernel code and looking at man pages when
> OOBINLINE is not set for OOB data to be received MSG_OOB has to be
> set in the recv syscall.

Thinking a little more about your suggestion, I think it can work but 
the application will have to do some more work to differentiate. I would 
prefer it would not have to. Anyways, I will re-submit the patch with 
the zero length check.

Thanks a lot for your comments,

Shoaib

>
>> We could use a different flag (MSG_SIGURG) or implement the _actual_ OOB
>> data semantics (If anyone is interested in it). MSG_SIGURG could be a
>> generic flag that just sends SIGURG irrespective of the length of the data.
> No idea on the SIGURG parts :)
