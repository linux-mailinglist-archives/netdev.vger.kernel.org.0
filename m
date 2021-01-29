Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E887308E10
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbhA2UF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:05:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34194 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbhA2UEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 15:04:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TK00An018921;
        Fri, 29 Jan 2021 20:04:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7efHXqqLsnERjzn4ldFqk8olvQNxe6cmKCIAq6YL18g=;
 b=p5zN3SsW8/oFUAEmYylcbbiDqwnyPJsWI2S2mWBFLJCHAyjObW9oj2QBJs+e9rYFPvdO
 Q/3gzpiH3BBYWNyc40wYYLVGJTJlMjoWgCq9hDkqslPi9c2ye9uoM2f2b6A7OGsqAHNI
 Wd3l+S4RoqNWM2mDF8y5PoK+ueVZVmn4zUMQVoQj3Ga4eiLvFZwcOTNOpKqIl91m11vU
 whkuwP5X98LJ9M/Gx2DgjmuInbpeFbHVTjUrjfP+dY7DP/C48mngb9y5dkN9ONp5ijAH
 SVqzoxltW7JOe1VvU+gseDcmM7KGbm0XkfJXn6RuErFTzPJ5rz4A5c2m+BYstqm1sgZ3 Kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 368b7rb322-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 20:04:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TK0l4O059983;
        Fri, 29 Jan 2021 20:01:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by aserp3020.oracle.com with ESMTP id 36ceugc183-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 20:01:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrSJ/9CoHs4fhzdYtOdN+PCsQItEKFLtCRWgn9vVXQbekXSmJskvkynur+SM3m7f67aubH/5zpf4EjULnB9HiMCIVCd7YpbPXNjM6K8zoTjKKpN8wG4xLy+wM8kYlYmOzWNyJX/zxZTgDT19dHh8qrTn/2Y+iNuu4kVVRKKoZUmAQRWrXGwAUW/JWDbhAzZ/XxLrAp1EsJzMu0HhLw4aBmiRJ1vCDlu/2rXHQAFESrjWOrLMPJ/I0jicLBxISOOy5mYXRbFvYKOqsdkhcvZGaSFoiPl6n4PFi5EBLfCR2cXDhupwUPBCnIvCt/u/sHsEJpENXwubF9ZYhqoWSkchTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7efHXqqLsnERjzn4ldFqk8olvQNxe6cmKCIAq6YL18g=;
 b=J3vxp9ooSOK07QwSwGHEXwp/uoqbJw4gGhfvGlIit+bk7WVD2y0Am1aOIhBtpyXm03XjBpfncfz3hKo50Dymss/GLgcucbRX3p16oL5HzDiF+x83vEJVbfMEhUTRm8aqJIInPWKzJqHfGAkkqYvOxK+3tzWFslqLA5DySdHFJYt/PK41Z3/Ltl+BEcjYfPtuogZIwe+3TlG3HPyxCtF9CSdxpy0dQBaE1DrChH/9BhSgJIGh+HwuZD9S/uiUMqk4Hk/BjXCq3kEzN8svzKvlmQPPiJfCj0tqMRtm3J8j3wNWHbB9dLWg8U8L2nO3v2xX8qVwF/w4sO2Hk3C1k2WHfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7efHXqqLsnERjzn4ldFqk8olvQNxe6cmKCIAq6YL18g=;
 b=X+yNcAjEULxyZUMLtvjvsvUjuPb5IIA/XO3toACNcBV/+jhO4srmoJYrl5cXwdCpejMl3HsA59oQUCWRV7kJ/rrHKw5CmT/NnvUapB++Z80PdqHFWZEZnymCXJN3vjFc4YSGGPJtoEjN8rZZ262CIrlmvXRstnp3mAscnz+HEWI=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB4464.namprd10.prod.outlook.com (2603:10b6:a03:2d0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 20:01:57 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::7445:f44:72aa:da07]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::7445:f44:72aa:da07%4]) with mapi id 15.20.3805.017; Fri, 29 Jan 2021
 20:01:57 +0000
Subject: Re: [PATCH] af_unix: Allow Unix sockets to raise SIGURG
From:   Shoaib Rao <rao.shoaib@oracle.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, andy.rudoff@intel.com
References: <20210122150638.210444-1-willy@infradead.org>
 <20210125153650.18c84b1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <23fc3de2-7541-04c9-a56f-4006a7dc773f@oracle.com>
 <20210129191939.GB308988@casper.infradead.org>
 <6cef3799-088c-b017-94cb-18971ac74727@oracle.com>
Message-ID: <00a01000-92ea-f5d9-3275-c4cc730f9f24@oracle.com>
Date:   Fri, 29 Jan 2021 12:01:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <6cef3799-088c-b017-94cb-18971ac74727@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: MWHPR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:300:16::12) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:7446:8000::12a8] (2606:b400:8301:1010::16aa) by MWHPR13CA0002.namprd13.prod.outlook.com (2603:10b6:300:16::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.8 via Frontend Transport; Fri, 29 Jan 2021 20:01:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a898c7a0-bee4-4c1d-155d-08d8c490bb5c
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4464:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB446484827503FCB487A042FBEFB99@SJ0PR10MB4464.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J6OWGxMX4uRjB6/N0BTI5wUot/2HLDzeT8xtn2Cq9IDAbD4JUOByta3HDQ0nFTe182UTRm3d8SqvlK/r//TOKFaaskOMlo8rNzVIkMtpDiEXvStJsS3vgffVyHIB/j0ZV388xAWaNK+MbXL/jnopWFkAL8b19z0wjP2C6BdWeKfJAKWVDP1UsA7751y9FMo+6zkJj0JwYnvkbqeRwnw8cuCClcle6Ef31UK6x8XPUvtpYIkVPMgsXmTUDGTuQzpiHeF8P50qYP7ZI1pry7bFrg9X/Wx794Adm87piP3yuJluimEVZpZE4TxJp+ER+dGXmbTTqRUzNdPfhOYWoF0tEjfxzViKacKZjBDX4FiqtMFPFteEhlEWZvT6zICcQGv9YxIs/gfYyHZ68gWW9Be4hxK9Stm3Iw4EfMLCYQaWV0AWVJohtw2rUma249OxWUVOBJ62HWHfNfBMaqBKB3syf9tFXD5/FqmZRQPBQ25Q4GhJf4DGncYLYXGJ9O75expYqPxirwNK5gZqP+KdbqxvB4Ut5Lf3J1t/uLICHa03wpkgz77JsS7GB2AfLUa7PzpTIc0itsnpEgUSjv70TV/X4EVlgnwpTYGAyCXTugTWUHs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(396003)(136003)(376002)(186003)(53546011)(4326008)(6486002)(478600001)(31686004)(66946007)(2906002)(66556008)(66476007)(5660300002)(86362001)(8676002)(8936002)(2616005)(54906003)(316002)(31696002)(16526019)(36756003)(6916009)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bnlwNFhIenN6MEpXcUE4T1NZMVZyN0VJZ2FTUjIveUo4ZHY5SHlXbXFrQXh4?=
 =?utf-8?B?Q3lOWGZjMnR2bW5WYnFWWjhLcUVxbTBybUJtcUYrV3lRRnYxNmhlYUFRK3lp?=
 =?utf-8?B?VEVlUnBUdmxHTStjelFuZWtwZW1nSDRSQzZJTFlCV2lGYmFJN0hPSDVwaFA3?=
 =?utf-8?B?b21JTy8vVlVrWjFwOEs0L0ozUGlqZXdxWmhjdXNtdHFUZytHZXpqMEg3Vnhw?=
 =?utf-8?B?L0lDUFpZNmliK2xvNEtXV1ErY01TQTNSTDIrdnBRRktNOXBEbUV0OFRlU0k2?=
 =?utf-8?B?L3Z6YUQrOXQvdy9kSlJ0WU5oOGcyQmVRTnlWcE5TUk5kQ3NSdSttbWlaN1BP?=
 =?utf-8?B?S05IZlhXWTJ2SUZKUk8yVHg2TVg1akY2QXpnRU9aZjRBWnZVb3JkQ250ZlIz?=
 =?utf-8?B?SVNjcjN0bmk3amJMemIvVWJvM0NtdWxDTm5PYjlnNVY5dVRhd3pvNnVpM3pS?=
 =?utf-8?B?djlnODd1WCtFVXFUSnduNXdreDc2Yk1md2FSZGMzYithVWxPSStwSG81K0ll?=
 =?utf-8?B?elExQjJaOUdBVi9nWHpDSzBPcXN6NDd4T2lwU0lHNFVVTUo5N0hDcjhvM0pE?=
 =?utf-8?B?VHZ6QnIybE5kR0tibnJnSVhid3JtQy9NU3RjTW53VmN2WEhZVURzaWVqaElm?=
 =?utf-8?B?RDZMUS9ZWklXZ1NybUJJdXVxNzFWWE9TMmNQdDZhL0JhYjVJWDdFb3NtSGJy?=
 =?utf-8?B?Uisyb2NOZzRQZDhUZXVGNDlpcWQ1Zy85dUZOLzZkem1wMnJHNlgzQmVUYVRG?=
 =?utf-8?B?K0NhWXJORHcxbkJIdnFPazlXenpaTzBhcDJORDR3eFQ4Z1JWTWtsZ1BLdHhM?=
 =?utf-8?B?dDIwSnkyc0FOL0FCaVp2U1RWMGpNS29TdkIzSmF0Zk52RXlzMnJocld0Zi9T?=
 =?utf-8?B?eFFCME9BL3E4YVFRRUVkNWE4Q2FZeG12VFhzMllDS2R0ME9iancrQ09KdWox?=
 =?utf-8?B?UEVzMWt4MmV6UU1neGxSbVJLRHhWY3g3SXU3MW5KTk1EL1JkcUJoZHpsSEZY?=
 =?utf-8?B?T1M2bk1Bb2FGdW5TTzh5SXl1WVlrRFdKSXZEc3hEZkY5bzgxalM2Tjd2blZZ?=
 =?utf-8?B?a2dVeUd1RVRpOWplaURiZkE5cjFlQnpzWmRkQWMxcEJmQzgyeDVzb2JBR2NO?=
 =?utf-8?B?eWhiaHZhS1k3K0wyYTJNMWZRVkluZmUzRlh3aS9tUXlVRkZ4L2tvbjZXdDVk?=
 =?utf-8?B?Ym96aElNRUx5d3BuVmlhQ1BFamt6M01BNkN5KzlJMURzUEl1YXF0b3JTbjVH?=
 =?utf-8?B?RFNPem9PUEo5K1M0UlJxbk1jQ0RyQnhVd0t6MitKb2kvWmpiYzdCeG5XVnJ5?=
 =?utf-8?B?bWxRU3E0cjFUdDg3K3E0SlNkTzAwcHJPRk9zUi9VcGdGOWRtK0lsT2dXdkpX?=
 =?utf-8?B?UFhzaGJDKzRZZWcybnpLdzBNT3VGbDA0UUFSUlZuSFE4VXNmYU5uaG42bzVX?=
 =?utf-8?B?VldpeXlGelB4SGhFdkdmK2Jna0pnL3ZDUFZIM0M3NW9ySXpGSkNHYmlaSzg3?=
 =?utf-8?Q?+e/NmM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a898c7a0-bee4-4c1d-155d-08d8c490bb5c
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 20:01:57.1769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QodEHmRIUs49IwLaIU84SrFwgM58KqUen0OX0gS59hN432GrK65vsFAjHwA18qNuHdGgE9xqVPHzNtcpGOpSIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4464
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290097
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290097
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/29/21 11:54 AM, Shoaib Rao wrote:
>
> On 1/29/21 11:19 AM, Matthew Wilcox wrote:
>> On Fri, Jan 29, 2021 at 09:56:48AM -0800, Shoaib Rao wrote:
>>> On 1/25/21 3:36 PM, Jakub Kicinski wrote:
>>>> On Fri, 22 Jan 2021 15:06:37 +0000 Matthew Wilcox (Oracle) wrote:
>>>>> From: Rao Shoaib <rao.shoaib@oracle.com>
>>>>>
>>>>> TCP sockets allow SIGURG to be sent to the process holding the other
>>>>> end of the socket.  Extend Unix sockets to have the same ability.
>>>>>
>>>>> The API is the same in that the sender uses sendmsg() with MSG_OOB to
>>>>> raise SIGURG.  Unix sockets behave in the same way as TCP sockets 
>>>>> with
>>>>> SO_OOBINLINE set.
>>>> Noob question, if we only want to support the inline mode, why 
>>>> don't we
>>>> require SO_OOBINLINE to have been called on @other? Wouldn't that
>>>> provide more consistent behavior across address families?
>>>>
>>>> With the current implementation the receiver will also not see MSG_OOB
>>>> set in msg->msg_flags, right?
>>> SO_OOBINLINE does not control the delivery of signal, It controls how
>>> OOB Byte is delivered. It may not be obvious but this change does not
>>> deliver any Byte, just a signal. So, as long as sendmsg flag contains
>>> MSG_OOB, signal will be delivered just like it happens for TCP.
>> I don't think that's the question Jakub is asking.  As I understand it,
>> if you send a MSG_OOB on a TCP socket and the receiver calls recvmsg(),
>> it will see MSG_OOB set, even if SO_OOBINLINE is set.
> No it wont. Application just gets a signal.
>>    That wouldn't
>> happen with Unix sockets.  I'm OK with that difference in behaviour,
>> because MSG_OOB on Unix sockets _is not_ for sending out of band data.
>> It's just for sending an urgent signal.
> That is what I just explained in my email
>>
>> As you say, MSG_OOB does not require data to be sent for unix sockets
>> (unlike TCP which always requires at least one byte), but one can
>> choose to send data as part of a message which has MSG_OOB set. It
>> won't be tagged in any special way.
>>
>> To Jakub's other question, we could require SO_OOBINLINE to be set.
>> That'd provide another layer of insurance against applications being
>> surprised by a SIGURG they weren't expecting.  I don't know that it's
>> really worth it though.
>
> SO_OOBINLINE has a meaning, that the urgent byte is part of the stream 
> and using SO_OOBLINE to allow signalling would be wrong/confusing. We 
> could add a socket option on the receiver to indicate if it supports 
> or wants the signal.
>
>>
>> One thing I wasn't clear about, and maybe you know, if we send a 
>> MSG_OOB,
>> does this patch cause this part of the tcp(7) manpage to be true for
>> unix sockets too?
>>
>>         When out-of-band data is present, select(2) indicates the 
>> file descrip‐
>>         tor as having an exceptional condition and poll (2) indicates 
>> a POLLPRI
>>         event.
>
> No because there is no data involved. Poll is associated with data not 
> signals.
>
> Shoaib

SO_OOBINLINE implies there is urgent data inline -- This patch will send 
a signal even if there is no data.

Shoaib

>
>>
