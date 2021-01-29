Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC05D308DE9
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 20:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbhA2T5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 14:57:22 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56908 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbhA2Tz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 14:55:27 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TJjdLN035845;
        Fri, 29 Jan 2021 19:54:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4y+JmLF61W5aXrbQWEs66xkP64gAVHeK/ndIzwwqnLY=;
 b=pjIyD9qZUf8bRgTtpVSS7wt+u88D5PNHHgYS0Jc8Q0nM9uqNTmMmrNJz2eEYlJ+72c9/
 Lcc4eFYaLZenAlyxg3bVO+tCSrAZ6caZT454e/y/Ptfya113F+XQ2VcM/n54QJRezoY7
 ygICfviXzYLuKfMNKFcO7omQxIQW/fdHZryupnDBjE1MrMIsNcuAo2+4ZmBNuth74GGt
 979zIU1mx0sPm2UwIkXGowy5NPI+RGyvojA+Yzg4Q9n9Kw+bF+NjfDs/ps0tie8yS/Vm
 41OxFUg12Wn1BIl/424X+CNM0+mUaUua2sOpP0OMEjT9gVXyTp3pzEDQxg5alFwafBYX Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 3689ab365f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:54:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TJnw8h035692;
        Fri, 29 Jan 2021 19:54:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3020.oracle.com with ESMTP id 36ceuh540r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:54:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGzvkT6LMdUuz9oamqJf682pbV5/fM/ERufE3h8qgoXE8Go68KARTB2f07XKsSyCkcnrLN+ZV0Iuq/lEO8mAGkwyl7BT8/qb2xH/loPgCPzvMK7CKnGsnDolyRj23pVwdkJ/kKk8/9yjwRbKYjq3k5zxu64NSjtnALzIiYpjTbRCrSrnncDKvDev2Aib6v4WkMMEi49V5+nU8f+jim1wInD6JAcldWPLnLdk7L6DcrJThJHHVEgufpQ8hBkZ3d8FblTlYs0DVL60rN91PJ/IcTaz/MPCQB1wOc93XDKxItCdo9vfh0r5zrBfvgQ7BVWEaYLfwENe1Z9DK6G+9kSwlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4y+JmLF61W5aXrbQWEs66xkP64gAVHeK/ndIzwwqnLY=;
 b=J0byEtQVjLJ4Pi+9HBAZQH7yKHI7Sd5Mv3nOnfjXhJr9m6+gfVExeycL5+vwBw+cPzKUxDCwqJ6tZzn6XWSYhfSzkc1z61WHTZ1JdCApYmdiMo6yMfLFBslLFdzlURudAP3bGD6RblPiQDlXNnXPRRuVMj6Dzk4J957xogJb/ixziVmt37PJQYElm8FbUJfcSCNOLyKwcKs2DI6qKcDaeUtm4z5rdwyobkmUi6mL8BaWkGAyUXTrrBlHT2FvulGXo8ye0zCmSV2/XGCXQWOVbRtB2x1c7OJWdpotzqGnHCZsp794o1V0o19NQIABim15ltHHeA+c7snzbpN1DvwhMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4y+JmLF61W5aXrbQWEs66xkP64gAVHeK/ndIzwwqnLY=;
 b=yT+SBbpQ9sEc0msjiTzm6broIVnqfEbvNEgnFw8yNogPCJZW5+tMCmckyq2LZt66EcrkbbnZyFWe1ZnQpkwcafJo/BRXPF2CMhmRKuh5Q8dhx2r15NIA3IJt67NUusBIYdeAd5DSA72O4W3okiIm3T5RFre1JwMkT786Xd3s0Zg=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BYAPR10MB3413.namprd10.prod.outlook.com (2603:10b6:a03:150::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14; Fri, 29 Jan
 2021 19:54:34 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::7445:f44:72aa:da07]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::7445:f44:72aa:da07%4]) with mapi id 15.20.3805.017; Fri, 29 Jan 2021
 19:54:34 +0000
Subject: Re: [PATCH] af_unix: Allow Unix sockets to raise SIGURG
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, andy.rudoff@intel.com
References: <20210122150638.210444-1-willy@infradead.org>
 <20210125153650.18c84b1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <23fc3de2-7541-04c9-a56f-4006a7dc773f@oracle.com>
 <20210129191939.GB308988@casper.infradead.org>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <6cef3799-088c-b017-94cb-18971ac74727@oracle.com>
Date:   Fri, 29 Jan 2021 11:54:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210129191939.GB308988@casper.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: CH2PR19CA0008.namprd19.prod.outlook.com
 (2603:10b6:610:4d::18) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:7446:8000::12a8] (2606:b400:8301:1010::16aa) by CH2PR19CA0008.namprd19.prod.outlook.com (2603:10b6:610:4d::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 19:54:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: daea6ae4-a833-404b-acdb-08d8c48fb396
X-MS-TrafficTypeDiagnostic: BYAPR10MB3413:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3413BD72D04C3EEF6B702986EFB99@BYAPR10MB3413.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lu9ZJ567tfW+1cCDsrP7Bzu3YBsBfhjOZBdgXcuFY9IMsbXhn7CzW+CgSBeNmLXbWBpOU8JR3C3PVYEnPE+EmCXeDEXYVYhD07YQwnaPEdxYhJTvzo6YNPNurQ508n4eBZiw9jVEbBim/NEidROAt+rJ72UpzzgNqNkApZIKZPV7gOUblfilR0+rUt6VoS0vTDF8czwc2H6DXi48ZdWqNKbqPiPDHWLU8DGOSGlYcq/JChwP4vRxb0b1tXOflmoG/xDmT9tvI4U31neBFxUaW6fOsD7DMLS0nr/e31iNv/pIX7PJzn/mpU0k7OsoqRtH25CB6xXq5Pw8lcoF7vTto+ip1jO4a6pOrY3fOxad9Jcw7Qy4zD0rCWmjly46RBgb7uQn/WqZ37mhKzpQATPZoffH6e0zOzNA64I7maSe1o+HfB15vsMZFYDNnVqM5XUOw639G659nYbxUS0pN8HCeE+XT2WU2WRpE+SRaKvigg6eyJZWtHDOUvjgm1Uk5Bl+g2OK2Sa+KxuobNohweVaK2aK0ZZlOAbX9+8xjAyB4i/Iq/0j/FOP6LBeTY29LuG/iE5XctpfN0CbZiVYT7RSxuZZdF4zaxLkDwuUTFL38e0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(376002)(136003)(346002)(53546011)(31696002)(4326008)(8676002)(31686004)(36756003)(6486002)(478600001)(186003)(8936002)(2906002)(16526019)(6916009)(2616005)(86362001)(83380400001)(316002)(66476007)(54906003)(66556008)(66946007)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UXAzczB6b25GY3lMWjkrT295K1JGOHR3N1ZnU2tmL1JrYmVheGs5RXU1ZnZx?=
 =?utf-8?B?eTU1eFBRd2lzR2FwcUFHRXBaSWcxbERNVWR6Z3RURG1uZjVIc2NPRUp5MHN0?=
 =?utf-8?B?dEV6Y2hXT2JYdE9tS05FYkFwalVHTWtMeTAzVnM1RTlGVGFaWHNSTk4rRWdm?=
 =?utf-8?B?R1hxNldxQ01EZWpqd3RkZVRSTjlLZ2JLZW1leEZ2RzdkdDdmeGwrY0FVSjJD?=
 =?utf-8?B?dzRxMWtlUkN6cDRyNGJ5UHBQV3RQa1BRNGZiZEdOVDZDS0grSXlhbTBJb3pY?=
 =?utf-8?B?S2NocFVRa1F4dHJpSG9NUTVKalpjOXRKWjcyQTg0cWVVSE5VQjZud2xPYzVk?=
 =?utf-8?B?VXJQOEhVVEZvLzF4N3lzeFM4b2JxaUZsd1hkTXlVdE13S2VYOUNIY205NWg2?=
 =?utf-8?B?eTNENDNlbXl4dFJTNm45U0czVzNuUWlnRG5ydjNtTEtkc1lrK1EyQ1Y4Y2Mr?=
 =?utf-8?B?b2l2V3l5RW42Y1hlVTI4dFcvb2g0dlJYSEJEZUNSZGlFbzFrcUxCUE5ma1JH?=
 =?utf-8?B?SDNHaUhvVVErbnBFK21LV1A1YWRCSmdNeGR4YVhSNjd6ZDIwL2ZBdWlOc09S?=
 =?utf-8?B?aTVXN3VJOGVKMTZLbzYyV2VCUnFWZ21DSHBCSFR6Sm9WZmRpWHl1YjM4SDE2?=
 =?utf-8?B?T1hoYUpMNDB0VzdqM2hVcDRNSTZTTW1HbVJ0QlN5NG5iNmlLdXFTUDVKQjdh?=
 =?utf-8?B?ZDVKT3BmbExDVVA4bGlqOTFmWTRiWjFneElvTTlmSmNJV2U0T2MxdkprTmZS?=
 =?utf-8?B?UVFJSWpXTkVMVGVGQ3Q3TFA1d1Z1UC9YVXNSalJXRmJKU2pidUtNZDIvMVpt?=
 =?utf-8?B?MDd0L3ltdERvdmZWTjIrR3gvT3Q3cUZraklFV3pDSG91b2dPSEJkTkZON1JT?=
 =?utf-8?B?elpmMk5yN2k2dlFsV2wvREtWTUNlL3BsMVQ3Tks1dmJxUHVNWFhQSlN0RE9m?=
 =?utf-8?B?ZUJtYWV2TWdaNzV6QWF4a0FiVnVpcFNrNU9RSXRZNldVcnFJRHFOUFVKaGxp?=
 =?utf-8?B?QUJCMVQzMlJTTHQ3YjUwUGVrT1U2dlFBRUlZMlo3SHRrRWd0U09nanViQjlV?=
 =?utf-8?B?WXlkNmgya2dTekZkOWlwV2FYQ0E4MXdNN2N5RlhRSkEwemtMUWkxRkt5ZGZF?=
 =?utf-8?B?UVFGN2pRM3VOZ2l3dTFBUnZxZlVSVmY5T25KL2xncjZWOUhLTEg1dXNhTzU5?=
 =?utf-8?B?Ykt0RmZGaHNhVGFYeUF0b0hKeE1VdFZDVi9zdysrWlhGUjBrLzR6dllvMGxz?=
 =?utf-8?B?QmdJaW9Ibll0SU1HbGNJS2JzeXYwV0IvcHBaR1VuQ0Q0NzRXUlc0T1NWNWFG?=
 =?utf-8?B?Sm9lSExlNXUydlZIZ0lXbzFHVFFwRzZRTk9xOFhXNVVtRVFnemM2VkpmYzVG?=
 =?utf-8?B?RzloMkdKNnowT2xRSWV2STFvWHVZWDUvbXljS3FtODByT1diZXNsN2J3MnVW?=
 =?utf-8?B?RUVPUk1VeVA1UGRsdElIbWllbUcyTlJxVWpYSVdnak5XNHh2QVlFNkNQeHlj?=
 =?utf-8?Q?w0hNj8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daea6ae4-a833-404b-acdb-08d8c48fb396
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 19:54:34.6911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vjemfkqg/omq7zIFlSGW+6BYpqeOZvxnrbjBbZ2HRv+d2cvF/+sZSFpLYEERm0bDkoSpMe0H2dcylWYRc3kA5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3413
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290096
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290095
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/29/21 11:19 AM, Matthew Wilcox wrote:
> On Fri, Jan 29, 2021 at 09:56:48AM -0800, Shoaib Rao wrote:
>> On 1/25/21 3:36 PM, Jakub Kicinski wrote:
>>> On Fri, 22 Jan 2021 15:06:37 +0000 Matthew Wilcox (Oracle) wrote:
>>>> From: Rao Shoaib <rao.shoaib@oracle.com>
>>>>
>>>> TCP sockets allow SIGURG to be sent to the process holding the other
>>>> end of the socket.  Extend Unix sockets to have the same ability.
>>>>
>>>> The API is the same in that the sender uses sendmsg() with MSG_OOB to
>>>> raise SIGURG.  Unix sockets behave in the same way as TCP sockets with
>>>> SO_OOBINLINE set.
>>> Noob question, if we only want to support the inline mode, why don't we
>>> require SO_OOBINLINE to have been called on @other? Wouldn't that
>>> provide more consistent behavior across address families?
>>>
>>> With the current implementation the receiver will also not see MSG_OOB
>>> set in msg->msg_flags, right?
>> SO_OOBINLINE does not control the delivery of signal, It controls how
>> OOB Byte is delivered. It may not be obvious but this change does not
>> deliver any Byte, just a signal. So, as long as sendmsg flag contains
>> MSG_OOB, signal will be delivered just like it happens for TCP.
> I don't think that's the question Jakub is asking.  As I understand it,
> if you send a MSG_OOB on a TCP socket and the receiver calls recvmsg(),
> it will see MSG_OOB set, even if SO_OOBINLINE is set.
No it wont. Application just gets a signal.
>    That wouldn't
> happen with Unix sockets.  I'm OK with that difference in behaviour,
> because MSG_OOB on Unix sockets _is not_ for sending out of band data.
> It's just for sending an urgent signal.
That is what I just explained in my email
>
> As you say, MSG_OOB does not require data to be sent for unix sockets
> (unlike TCP which always requires at least one byte), but one can
> choose to send data as part of a message which has MSG_OOB set.  It
> won't be tagged in any special way.
>
> To Jakub's other question, we could require SO_OOBINLINE to be set.
> That'd provide another layer of insurance against applications being
> surprised by a SIGURG they weren't expecting.  I don't know that it's
> really worth it though.

SO_OOBINLINE has a meaning, that the urgent byte is part of the stream and using SO_OOBLINE to allow signalling would be wrong/confusing. We could add a socket option on the receiver to indicate if it supports or wants the signal.

>
> One thing I wasn't clear about, and maybe you know, if we send a MSG_OOB,
> does this patch cause this part of the tcp(7) manpage to be true for
> unix sockets too?
>
>         When out-of-band data is present, select(2) indicates the file descrip‐
>         tor as having an exceptional condition and poll (2) indicates a POLLPRI
>         event.

No because there is no data involved. Poll is associated with data not 
signals.

Shoaib

>
