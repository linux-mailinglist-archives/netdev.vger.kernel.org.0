Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823E8308E35
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbhA2UMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:12:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48866 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbhA2ULW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 15:11:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TK8iRu012758;
        Fri, 29 Jan 2021 20:10:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=V6+5DHzwNSy3lflM3AxktO+qCwLhZljcwxoHtntZwqA=;
 b=JBNF7JuZnXOWCynJY67E6+sffFqIcqH09eFKxSQA6JcLu9umxa66A1oaWl3olOvuQFrY
 JhLk0sVtPeA7Ziqg9sfstd8NNxuxqsfWIdDlWOuLBfIczODlfYTwPoy0ZWLo0ZeBYRCY
 gka1u0R+pOHvUju3k/nh2JW6uiqQeML6qcRG+tjLP1xXL0xrA20SWvVlvy0jwjEMPCCa
 9W6AwlrzeoNCRczDxh9WtRtMuHt10l5YLZseaTJP9AFS9FfbT+bWoAqPcP5BLlNuQoCR
 eS2IZ8dhcTmzGtzLBT27KtFHMuSXSyjP3aM/fsmS3tf15JL0CgdKrH5QkdqvomLfHZ05 ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36cmf89cgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 20:10:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TK9utQ105992;
        Fri, 29 Jan 2021 20:10:28 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3020.oracle.com with ESMTP id 36ceuh5s9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 20:10:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SoXZ5VWuPJNwZgxisOf/Lk5Gm4Dx1M3z948ZvHquFp1cd/hPbut0/mGcthTV8Mmlh6EJucCNehnhPf2KiGfvjHm3/69UibIA9SD94x+GnmcxVbwiszR656z1xzSce/sLc2KWhFuMPf8XKObzc6XKQO1gwjGHvwC4YDSdwxyUYUgwZwGSBt5DM7b25vV7QZa10jhJLnZAbrFWuwmnMmmze4xgxHaFaW+i+9OLfunU7OFQxnHRd4WrV+GbUMp0qFqKKmNc9vjtNcMJRvusK2YUrcDGIlVYG5BLbxPqxrjlseQk26crD89cdF3Y8TxwkKNw00UxIqJnmqsavyiuR3mCBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6+5DHzwNSy3lflM3AxktO+qCwLhZljcwxoHtntZwqA=;
 b=cUEM0ys9Qi21VXgM3/3/ZrPl3KHvh+P5SJPDP3qMz0Lz1dYf0ggTwsk0cYklZauj+5eHVcA6no5NffQb5ARIn3pr5lyt0GWpFzyECYkd8xgj2rATj9ZYt4I3fVnCbp2Okd3Dc4/6YDY6RGyz6VfBzxIj4HWFUamuvaYgrMd5mkFwz/e4+1Qo1U5b0mxXr1Qs5vXEnXkFlutISXSe1IFFzOe1rX3UOfU+7eGBMT6vSWY75RGXEJQi4VoE2XNmhk4w5K9ti3jK4JwthZ617n0PZOr0dpeoWvtBuqI+bbdKRFHwsU2wTcfi3lxNc4G1Lf4Ue4JA+H0145UOThaDHL8jCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6+5DHzwNSy3lflM3AxktO+qCwLhZljcwxoHtntZwqA=;
 b=ocLiH7Z94kDhR1krGd551yv0j9UG1RXOswBBO4rF5Tjg/h4OpaLJbg8xUsyj48hz0NaExg6zcbbzlrw8ZyiQlA97NccYTpJwxb6a6zTsVYB1SIjFYG9yJ+yfo9RWx06ihtX4gORs0grVsc6VOlJNQcQthgD72/xscI8wUb2OTGQ=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB4656.namprd10.prod.outlook.com (2603:10b6:a03:2d1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Fri, 29 Jan
 2021 20:10:25 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::7445:f44:72aa:da07]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::7445:f44:72aa:da07%4]) with mapi id 15.20.3805.017; Fri, 29 Jan 2021
 20:10:25 +0000
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
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <cef52fb0-43cb-9038-7e48-906b58b356b6@oracle.com>
Date:   Fri, 29 Jan 2021 12:10:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210129120250.269c366d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: CH2PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:610:54::28) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:7446:8000::12a8] (2606:b400:8301:1010::16aa) by CH2PR11CA0018.namprd11.prod.outlook.com (2603:10b6:610:54::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Fri, 29 Jan 2021 20:10:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 055cea37-d7bb-4290-5e75-08d8c491ea66
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4656:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4656F06829B75CE9B7D7C677EFB99@SJ0PR10MB4656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 82oE3su9Jh3HAgcKllp3kCBWy6b9trqBiX/SQ3Qb3V5D9uj4tIdVKFx9oxbdWg+K/5gSuhDs96BIPVUM5zSx6OHTaAs+Fpb9BkgmZ7llvPkBaBQhMbXI8mUOG11GTt4rrbZAUxRsXwjdFc95KyLLTDz7O0QqRQ3yEp3JHOr/JdXYPhKl+18Z3YCojV7oQnKy31qttmBFNxqoIdKlQe6xlTn1vMNJbWhLZo+UVpgZ7yxCbIWZetJuIgZAtQnrUPmpR4H01l9p0vMlsReIRElmM3QUD5smWmz1/llWaj0veTkW2CncmVtZTB44wAFpqn5CBBokK5x+2LaAy8OFqPpnsisMemeTvsTpMBBvjbFAzrkeCrQLrQboOBmJJylda4Y9NtMmmOmKyuITkZ0BVtWf3GAAd1FegxV8wvZs4d+dPPd2Aai73MjzIbHTacNxZBYN3xYKfeLkWwHsacCzof4YamPnGrhjIVitn7Z4qTyhqAHkGYinBibTGmqwEjUpWrQvJuEC5zgi1jh/fwDvK4iTvy8PX33swB+OeVPD02Cf5QuhCntFyvJGuc7HIZ94pJIc3+5gA55C74s7o9jzgp6cto7hL9YUOKyQ6VUMdgdIyck=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(39860400002)(396003)(366004)(6666004)(83380400001)(6486002)(8936002)(36756003)(54906003)(31686004)(66476007)(66556008)(316002)(66946007)(4326008)(2906002)(16526019)(5660300002)(8676002)(86362001)(53546011)(478600001)(186003)(2616005)(6916009)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NlhXUHkxU3g1bEtZc0F6SFBtQ1FnRDl6dzR4QVVVS3ZZKzBtTEhrM0RBUXFU?=
 =?utf-8?B?RXI2SnVrdFJxck5tSE9ZbVoxZklzU25BRE82dVNJeU9DVktML1ZpaWNjYUpM?=
 =?utf-8?B?UDd0a1kvQ0dXZUxHRndsck41N1dtZ3RnSytQR2ZwZ28vVzJmZE5jRWlTSWxi?=
 =?utf-8?B?MU1VRDl6L1VLMHM3OFBoYjgvaTJkamNQSzRqVkw5VlArTUkzUWFybkhaaDZW?=
 =?utf-8?B?RzMzVUo5V0NhR3J1YngxYXN0Ynh1cmZXOXNxZDR0anl5eFRuMi9CWUEvYi90?=
 =?utf-8?B?eGIrWW55QTlhaWdsQnI0RmUzNGs0VW5ac2k3aE15MWRJVGg0NHVyVERDdmVU?=
 =?utf-8?B?cXIxeGRMVkcyb2pWeGgrSG51bkMydno3b1ZqZnk2aUw0eVpVbTNQdTFCbStN?=
 =?utf-8?B?YktncjdKdW00bEtSS2JzdXBXR0daSFpmY0wzRC9hUUZ3RTdnTnFYb215L3pS?=
 =?utf-8?B?ZGh5eU03ZEI5U1BvVUdma1dKSE1ta2ZWWElHaWllSWQ4QlJOUEQvZjMxZW1j?=
 =?utf-8?B?MTFqN2RYc0c3aFlSMlZITHVudzQ3a2VVQnNHSi9uRnE3bnZQUE4xQlAyWk5k?=
 =?utf-8?B?VjF1Um5oMEZhN2p1RmpGZ2dUbmZtVWJFdG0ySHMxV2h3d3lDQWc0c1o2WGsv?=
 =?utf-8?B?cXdheXFGT25MTlowSW9ES3h5dHFBRzFwaFFYZnI5WGU2RWhIRTZ1Yms1SUJq?=
 =?utf-8?B?UFhPRjZKaVFNaVZORUpyZTM0REJqa2dsdlZWVFV6SktNMVhPOVd2YTMrYy8x?=
 =?utf-8?B?ZTBnalc3d3VDMkpjMHZzYThLN1pSRGZYRjZhajQvSDdKKzJXTEdDUDFkOCt6?=
 =?utf-8?B?V0VDRGlzOGNkL3U3bHM3ZWswQkljelpmbWpmL2FtUkVWcWFZeG8xV0xKaktE?=
 =?utf-8?B?cXhIMWU2UTNSOWJ6SG1ZUlNRVmRQVk5VYU1zYXM4K2hrcVNRUWllUFQ1Q2dI?=
 =?utf-8?B?YTY4SFlDRHdkOUJnUnErQkVzN2tNdHZVUnlaZ05zMjh5U2Jrb2UzRHpZRkNQ?=
 =?utf-8?B?eGROVlFBb1F4d200K0Y4azhPNXNVRWR6bWMrZFFtalRaQ3Z1YXI2azExSG84?=
 =?utf-8?B?N3FvUWVZR0YwMXNBbENmMmdMZTE4ZXl2OWk3YVRTRFRGV3hmanBBSW04LzlQ?=
 =?utf-8?B?WG1FZG5Yak1iNFQyL1cvcUJwTUdIb20zSUFrRnVvZXlmREc2ZFVRemNrNnVo?=
 =?utf-8?B?Q1lxV3NHbGRybVJYQVUyZk52ZituWGwyY1d4M2tNbHdoRC82aEdHajRSbmdu?=
 =?utf-8?B?bGtaOWRLTElLblU3R2w5Qi9IQ2pTbnNWNVFZT09HME5YR3VLdEFqQSt4dU96?=
 =?utf-8?B?Y1NwMlhtSmZ2L0IwZFVrK21KaGwxOTdidHBxdDNSMGk3S0hnWTNvVi9rOTVT?=
 =?utf-8?B?QzJWVzhXMjR0cklpWkcwaGhpd3F5ZGhaa2d5TjdvL21xSjZVaHJNellqWXBU?=
 =?utf-8?B?SGZrVk1yZ1dZMnVvOWk3d2hhLzIzb2xYSzkwdkNPL2hhSkNJN2gzdkV6UFMw?=
 =?utf-8?Q?q3tLWc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 055cea37-d7bb-4290-5e75-08d8c491ea66
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 20:10:25.6108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YVcKXjMgYsPj2vMcTCn4XtrOaMPTJ4LzUmt9E6eAEByh3Ooc+kJDiLIeSq2KkCfCn2M7JazUCujsvhHfwZqaAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4656
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=998 malwarescore=0
 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290098
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290098
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/29/21 12:02 PM, Jakub Kicinski wrote:
> On Fri, 29 Jan 2021 11:48:15 -0800 Shoaib Rao wrote:
>>>> SO_OOBINLINE does not control the delivery of signal, It controls how
>>>> OOB Byte is delivered. It may not be obvious but this change does not
>>>> deliver any Byte, just a signal. So, as long as sendmsg flag contains
>>>> MSG_OOB, signal will be delivered just like it happens for TCP.
>>> Not as far as I can read this code. If MSG_OOB is set the data from the
>>> message used to be discarded, and EOPNOTSUPP returned. Now the data gets
>>> queued to the socket, and will be read inline.
>> Data was discarded because the flag was not supported, this patch
>> changes that but does not support any urgent data.
> When you say it does not support any urgent data do you mean the
> message len must be == 0 because something is checking it, or that
> the code does not support its handling?
>
> I'm perfectly fine with the former, just point me at the check, please.

The code does not care about the size of data -- All it does is that if 
MSG_OOB is set it will deliver the signal to the peer process 
irrespective of the length of the data (which can be zero length). Let's 
look at the code of unix_stream_sendmsg() It does the following (sent is 
initialized to zero)

while (sent < len) {
                 size = len - sent;
<..>

}

         if (msg->msg_flags & MSG_OOB)
                 sk_send_sigurg(other);

Before the patch there was a check above the while loop that checked the 
flag and returned and error, that has been removed.

Shoaib

>
>> OOB data has some semantics that would have to be followed and if we
>> support SO_OOBINLINE we would have to support NOT SO_OOBINLINE.
>>
>> One can argue that we add a socket option to allow this OR just do what
>> TCP does.
