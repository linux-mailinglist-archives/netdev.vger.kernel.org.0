Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5999E308E9F
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbhA2Upr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:45:47 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41008 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbhA2Upj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 15:45:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TKe029090752;
        Fri, 29 Jan 2021 20:44:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LlpJfoXp96p1vx/9ykw4MmRx9AvJnMAZtZTxakqUFNg=;
 b=NtJ0N9vAKvitVE/iCHdS6C+DpSSbsGI9PncGLomurMknXP9iEBsIgfmtFmlX5H0KMX/c
 KwiJ+DB5PygGBVt96v4UjhAMcLDi4UvZ2XdruD0ISENV3fq4TGVtZvb5AsouZ/qbp9k9
 L0IAt1RwXoZsZP5/bcfHkpTZ0J50AvhCvUrgVGP0Es1+Zy7XyPIF6OHx2Kgu3N7KrB4y
 BPakv+17JQ391OEr9q5zyQCB6YlPhUuZHfWIF0oq7vx1qcnjrGk5RCO731EIwvb3mV8X
 6xe+khhQJCfO9tSVDvUdcAhnbXl6aAlWplw1sU8vlvWTb7iuwnj140Rq63gklgEwTGQx Og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 368b7rb7ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 20:44:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TKeJaj147472;
        Fri, 29 Jan 2021 20:44:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3030.oracle.com with ESMTP id 368wr2fd4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 20:44:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AryuB6l48ujojlCv7cWasbsMarX06y+zF7kuJ111wYuGBhYCV7c67VBUKor89ZhqryNB4uQTtIPmPsPDSr2j5RlzmtzDS7OVib5SatXmlzhutB6b779h3UrDfzLdTJ4lS2JPqCbSFlAxZc1yz39AkA9a2NYZedG+opBulOdQRoIvYJzMzSPeiCXb/daMfpFACWtNqgDFtT9TkpqT411kXN5Yrfi5mYkaMSO1a3p272eigb6HdGOCgOUq71p9LER1e250Dy7zT23KKEOCqJjmX0i6lTAltj6ecEMFNKf02SHDpdprqhDYFCE6mvDz0gVok38pRsTFCRMyTYlexQfVhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlpJfoXp96p1vx/9ykw4MmRx9AvJnMAZtZTxakqUFNg=;
 b=mcb1g4D6/q5goSbdXJE8E3FkX8R68lpmFmGGxMrrVi6NbWxHcmXqkGqW+WCZrAnptEyLl1zecnZ3lAoD+vwnGLadvsjR0fKR1G8LXDClzsd9PWeeqG3YN/ifZpLwq4DVcmht6JjN83VaR9i58bL7CrBGUs5Agfhsfi57rLu4KntKX4aCD1LofKjy0CvzkWYOqdcTBpvGPwSnv7oNoHMJHM/d9ceFuSgG3RdLxFZBibjo7wtUXFKBUcM5eIcxP/BYxRfg6yDfhJAVpWZ/5WIF5qWlvZ5/4CBJz4JFOQZPafivnWDtN4y/ZB1ucn8MPsKMq/9wr/WwrOxAxxqMvLcAGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlpJfoXp96p1vx/9ykw4MmRx9AvJnMAZtZTxakqUFNg=;
 b=gLg/JXUUBSix//T17j6fiUTwOi1vfntAbSUO+zeREKW+xgdEQMx9dtvzsH8hTV3JuqNY+wMxTcQiyNRoKemkDSYlLJb11/wOUyGyxHf3IW4vCtdEc/Cg1W5W06IvBJS/oiKc18vRveZu73XUS5X9nUMX4OF2DHoIzuW+FOiY0ps=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BY5PR10MB3827.namprd10.prod.outlook.com (2603:10b6:a03:1b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Fri, 29 Jan
 2021 20:44:48 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::7445:f44:72aa:da07]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::7445:f44:72aa:da07%4]) with mapi id 15.20.3805.017; Fri, 29 Jan 2021
 20:44:48 +0000
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
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <e1047be3-2d53-49d3-67b4-a2a99e0c0f0f@oracle.com>
Date:   Fri, 29 Jan 2021 12:44:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210129121837.467280fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: CH2PR14CA0007.namprd14.prod.outlook.com
 (2603:10b6:610:60::17) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:7446:8000::12a8] (2606:b400:8301:1010::16aa) by CH2PR14CA0007.namprd14.prod.outlook.com (2603:10b6:610:60::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Fri, 29 Jan 2021 20:44:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ce3a11a-ef3a-44fe-7b62-08d8c496b7e5
X-MS-TrafficTypeDiagnostic: BY5PR10MB3827:
X-Microsoft-Antispam-PRVS: <BY5PR10MB382782FB133683FF3DCC0D0DEFB99@BY5PR10MB3827.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3L/fN43RW9T2bPkwhFWjfHNcHQpuX4HmzIGX/Yl4awF/t3iNUt33sxkOvx5K282xgtryktLncCxzszgzY64KSAE0U6lpYusw56xtCFwwMvTffADZvudR7XGNYysQ7cv2pAVYKKlEjQWkYJRXeFhjY/jFWjdNgF7QtqEUMWN9yewLwY5VHXdOCRRUvHBIB0SoSZnOKw6Ty+TaHY9WvFXCGHdO+mdWgF9+dii/NY5/9WemEdH6u53RM+HGACXunXY2iPPfCSwmMOKoU6qo6+iAIT/9HBfSpOLnR5jBCfxpgFJ2mZAJSmcl2WoDdx9CzbkvoEnVDOz+oi198w+xFdpxioRfURfOjmouaSvBQTICMJG3iaLdsFvy7+UFY/dCjZC9ehvvis14XwVs4l103lzHsy5pIsgTxsoW31uZ/0521Asr+vsPVQkas8dF2sxUYeZG32tVdlMfXjGHqMI7fYPUpdjnVLs76q4kfXK6qNf1Dm2l2F6k3O96t0ajW3DCEcYzHEwR+DbBDAPh4T2S/YN3hMp5UKY2II+kFYFwsWlx6/bim+8egSHxD0hq5dAY6QBgxLr0iXQGhlT6DYPqArLY+STrzihLDqJhS71yhCNFP14=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(136003)(39860400002)(366004)(53546011)(16526019)(36756003)(83380400001)(66556008)(2616005)(186003)(66476007)(2906002)(8676002)(66946007)(31686004)(6486002)(316002)(4326008)(6916009)(86362001)(6666004)(478600001)(8936002)(54906003)(5660300002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZWd6cmx2bU9vZXFQdUxVbzVydktFV2tGS1pwUlptWmZTK0xzU3h6ODMzcVBU?=
 =?utf-8?B?UlJUQ2lyVFhtV2ZHQU1mUU1kWkJkMWVnUUd4MFM0NlZmOWRZT3g0Sm1iczRM?=
 =?utf-8?B?aTMxQXNneHA3NTJaR3VxOEVwMGN4ZndPTFdwZVdpcFRXVDdCc282OUJuTGJD?=
 =?utf-8?B?ODI2ZkpTTmhnQks1Z0tsSURyeUhqcHRjYUo1TlVZVzgvMlVFNU9FZUgrNEhK?=
 =?utf-8?B?TlhBWkh3dmVqWnZmdnpNRE9TNC9RQWt2UlZ3bGJBMDU1QURLczRSSWhJK1k3?=
 =?utf-8?B?ZHdtWEJPR2g5Qjg2NmdtTWFhaWtkNytBUmZhNUpUa0JjNzl2YmM0R0wxN3F1?=
 =?utf-8?B?Q2o0WldWcHlZVExaVTR3NzRVSDBXOXdVU1FoaHZxMHJTUXMvSGxUbmlFU0dY?=
 =?utf-8?B?cGRlOTFlZVpqQWtEbS9OZ0xyYzUrSEZGUnRhd0ZES3JmdlZjV0pSMWorOThX?=
 =?utf-8?B?NXkzcWRsajc0NXhSWndiVnUzTU9TUlNFM2lVVkd3RHZUcWpSRWdOc0tEK2lH?=
 =?utf-8?B?Z1pnRy9TUzc3d0V5NE1sUnM3YWM2b0ZFQ2dNVm1ic0NOQ1FRUG1wU2dkMFVD?=
 =?utf-8?B?T0FkelhJWkFQNnlGd1pxZXZKRkVIa3RXZkM1NkRiUTB1TVNUK2FZWGlqbDM5?=
 =?utf-8?B?RVc5cHFSeGhST0I4dU1zZTl0L294cS9CRWRDMlBHOXpGemk5SFloV3hsLzYz?=
 =?utf-8?B?UG02MkZIa0FDWTRoaVMwYmpWRGZMODcvcWp4aGx5SUhjRE8rNHo2WjlYVmg2?=
 =?utf-8?B?TjRiSEFTMTA4RDBaTHFUYU1UWmpMeGNRc1FoeUFRWXdVa1JYTE5zNkJERDlH?=
 =?utf-8?B?ckovYjFoRCtHUDdaS1ZKSHloMWw1SWxsdzJHczVrN3Y4WWxJMnhJeWFFOFZW?=
 =?utf-8?B?U3NIOTBra2h4K3RXMXJIYXQ4elBCckc2KzIvVFF5L25vQy9BMjMxd0xHQ0ZB?=
 =?utf-8?B?Rmk5WVllREIxY3czdkx6SXNJN3ZjTVV3MVFOYTZjcGpBMlpYVTVuWU5uYURt?=
 =?utf-8?B?QTVtSlpTanNhc2NIamc1bDBvaldZNzE2QUZFdmRUVldMdHpJM0pMMFZ2ZWZo?=
 =?utf-8?B?WXp4Sko1dHhGUlQ2Q3Y5eFNCWmlLOHF0SUJYcENYWmZXY2FadENYMis1eE5y?=
 =?utf-8?B?N3RJYkJQdnNEbGhOMURtZDZhNGZEdDhrd2lnNmZtWU9ScnA0SFJkYUJYTTJQ?=
 =?utf-8?B?Z08wSG5OeEVTdzgzQWFuZDJ0dnZiVlRDcU1xOFhtSGIxOE05ZGpoMXVUbUN0?=
 =?utf-8?B?ckZkK0cxcEFOVW9PWlE5ZWhKTCtSOTNITzg2dmZJWkQzVVhWcmxOdWs0dzhG?=
 =?utf-8?B?djFoRlB2ZmNHM3lxakZWcFd6YkFiWktVeFdSNmlkdEdWSW5VQU5tc3JIR0xE?=
 =?utf-8?B?RmsvdzVDWTZWZGJEaXhHMlpXS3hjZmRSK2hZUzV3NVpFempFaXZHdEliK1N4?=
 =?utf-8?B?dzFnZmlwZDh0bWlmeFRCOXROT1VCemdta0t2RHJaaXFnVVd0NlZOOVJSQzNa?=
 =?utf-8?Q?/VABzs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ce3a11a-ef3a-44fe-7b62-08d8c496b7e5
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 20:44:48.3866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FmrhoKX44TjDfdA0U7bGtHcJ7AQtZM8hWI0e/KnM406kCPhpwwUwPuj/SlcHnlW/DYrV4wMvl8yCqnH1fRJaIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3827
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=781 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290101
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/29/21 12:18 PM, Jakub Kicinski wrote:
> On Fri, 29 Jan 2021 12:10:21 -0800 Shoaib Rao wrote:
>> On 1/29/21 12:02 PM, Jakub Kicinski wrote:
>>> On Fri, 29 Jan 2021 11:48:15 -0800 Shoaib Rao wrote:
>>>> Data was discarded because the flag was not supported, this patch
>>>> changes that but does not support any urgent data.
>>> When you say it does not support any urgent data do you mean the
>>> message len must be == 0 because something is checking it, or that
>>> the code does not support its handling?
>>>
>>> I'm perfectly fine with the former, just point me at the check, please.
>> The code does not care about the size of data -- All it does is that if
>> MSG_OOB is set it will deliver the signal to the peer process
>> irrespective of the length of the data (which can be zero length). Let's
>> look at the code of unix_stream_sendmsg() It does the following (sent is
>> initialized to zero)
> Okay. Let me try again. AFAICS your code makes it so that data sent
> with MSG_OOB is treated like any other data. It just sends a signal.
Correct.
> So you're hijacking the MSG_OOB to send a signal, because OOB also
> sends a signal.
Correct.
>   But there is nothing OOB about the data itself.
Correct.
>   So
> I'm asking you to make sure that there is no data in the message.
Yes I can do that.
> That way when someone wants _actual_ OOB data on UNIX sockets they
> can implement it without breaking backwards compatibility of the
> kernel uAPI.

I see what you are trying to achieve. However it may not work.

Let's assume that __actual__ OOB data has been implemented. An 
application sends a zero length message with MSG_OOB, after that it 
sends some data (not suppose to be OOB data). How is the receiver going 
to differentiate if the data an OOB or not.

We could use a different flag (MSG_SIGURG) or implement the _actual_ OOB 
data semantics (If anyone is interested in it). MSG_SIGURG could be a 
generic flag that just sends SIGURG irrespective of the length of the data.

Shoaib

>
>> while (sent < len) {
>>                   size = len - sent;
>> <..>
>>
>> }
>>
>>           if (msg->msg_flags & MSG_OOB)
>>                   sk_send_sigurg(other);
>>
>> Before the patch there was a check above the while loop that checked the
>> flag and returned and error, that has been removed.
