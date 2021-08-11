Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B624F3E9A9D
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 23:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhHKV5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 17:57:42 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:53126 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232013AbhHKV5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 17:57:41 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17BLjUUm015016;
        Wed, 11 Aug 2021 21:57:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=9Ovr5WifW4K5OxXRMn8YSGBDtzNBospKio5rgY7jTKk=;
 b=pO6jOhMERuD17E2G9ulXQl1ZdHOtO/S1SAsXj1cZ7103ixqacJPTLBbtsh5cXCBnSInN
 vDiLQ7sb+ODihACt/z667/z0MBAo0KxDMbiPCRB6pJdwSSABtPPmBS7+sQYiffz9eW+O
 fVl365FOREjkhq9VNyU3yXqQF+Oxgw3z98/f7ByjC/j/nj0eV+B8aDb307yTNI/u6oGd
 Aktc2gOT9ZIxUw0hJZWvyrVfvkiX3wvOj+GHMIoVrrxGdRfzKiYM9UBxhvQ90HK1o+yh
 2UA5shxDJRPlSG8f+/ysbNQ4pkUKHaebN3WiadYC8lZBnwAr/OfFKn4ZpOTCiIu9hkx0 Fg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9Ovr5WifW4K5OxXRMn8YSGBDtzNBospKio5rgY7jTKk=;
 b=QOtxXfSRXkpnKRgBjnA1uUw4QoAffCetNPxcq7HAdv/ZPU+f17ZEFREF1j3r0JKbMl19
 2qY4uwBwp8QGSs6eZKeUQkpKTQZiETLj3HpcUhP/nE9/OHhtGU9bY2LpR5d3WBIcZUmR
 2rw0ENCjrx+TMDuuGzmOpEH+tNsJbA4vEc2Z1O43kINavRR+2XFmWvkmp4Lr0fEysZEG
 ZtSj98eiBTuUO4izWqC6orwdlM6cZ2H47tt6sVsya9peMnbZAk9I3nbnUTLaQNp3u2zO
 8e/Xj0Q0kqRo2U4My5L4VAwMuxEumZ98aJJR7yDgoEiw7WbFVtvUEJWQzFK9VMfOWOLw VQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3acb7a1thy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Aug 2021 21:57:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17BLuIXq006925;
        Wed, 11 Aug 2021 21:57:10 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3020.oracle.com with ESMTP id 3aa3xvvy9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Aug 2021 21:57:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6dUP/K0WjPOm0+A4UfkT5dAnAh8ubap1SlsB3T1e8ZTGDg/yHBDe1iMHYJurmhy5glh7BXvuKRNvK5ZJuS4b9riEdEs1OmJJsJwkUwabyCauxM59XJqYQZRXF2Z++YqkGALKcTSkz3bmpDqCOi3pWKAQ02CP9eTbfaVbRbsjeyeokGhUIqXedkAkMzkG1G9q1NkyJyf/URUKNGcpvS5SD3AYSZ9fMHqjdrxVvKV0v4+ceU91NxOwnwWgQ4t0g/OH4FKp1dfn388WVkgHTLM4qW6H9ugKBbt5VW3h1pdPyQAie6AiDSZrlCZN/g1oYNIdY6zImwwDeS4bLJvAX6RuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Ovr5WifW4K5OxXRMn8YSGBDtzNBospKio5rgY7jTKk=;
 b=LDu63YdErEmVdTtHhKatgg5ikJuNMH9mA/ZzxyByy/PBZMLT90fcrCgY0JnoZpzhM2bqdoVdf4eGpzZwBGKbOGWhl99T/WSKJIp+vmD+VXjmX8IlUP2dR/ikCYQVVpvhjYswxI5cmXNEIYRBUbAISb6/ytPdQyMji3Dea7tNfCRQY+GXEGj2/oaXgQNgZUymBiOVlnE6BsjcOSiRPrRZ5DhgVAWKP4em54mC+CTJu7inlJAo+Y25FJNtUFtKm2QxxB9s5Pgc8wDEytIYaLyRxP/XZQZTM55xwIKzfRMwyve5ufK+jyJcj+23VTkior6x24vuuI0BJbT1CXKCPJzIvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Ovr5WifW4K5OxXRMn8YSGBDtzNBospKio5rgY7jTKk=;
 b=lbH4+i/3130pPZ7qy18ak5XsyzjVtCx16NM5c/y6EFD8zniCqtgAm3m+HDUZoiFCBVL/NG6/292cMldZYH7X3d07E5M4Fv/jnrVeCpd+/oQCgNKEd4eIfZQxrJR3bADFDW1dGTYuzyPvexyACCNZl7cyLpufytRuGjEg1pQt+fI=
Authentication-Results: zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=none action=none
 header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB5645.namprd10.prod.outlook.com (2603:10b6:a03:3e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Wed, 11 Aug
 2021 21:57:08 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%4]) with mapi id 15.20.4415.016; Wed, 11 Aug 2021
 21:57:08 +0000
Subject: Re: [PATCH] af_unix: Add OOB support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dvyukov@google.com, davem@davemloft.net, netdev@vger.kernel.org,
        edumazet@google.com, viro@zeniv.linux.org.uk
References: <20210810183122.518941-1-Rao.Shoaib@oracle.com>
 <20210811145543.364a7552@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <e3c19759-578b-4aad-7651-95792dce4d87@oracle.com>
Date:   Wed, 11 Aug 2021 14:57:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210811145543.364a7552@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN7PR04CA0092.namprd04.prod.outlook.com
 (2603:10b6:806:122::7) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:744d:8000::7a3] (2606:b400:8301:1010::16aa) by SN7PR04CA0092.namprd04.prod.outlook.com (2603:10b6:806:122::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Wed, 11 Aug 2021 21:57:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef9d39fa-f376-40f0-fc0e-08d95d12f6ca
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5645:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB564523A0A61FE2A801411E6FEFF89@SJ0PR10MB5645.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nCd4d3z9tbH1Lhr4BD8PMxFw5AhO8+Kc0L23itMbsrU5W1VVt9lOq8S5wCvLaP/ud8+07a5Fy0zvAvYrXCf0nBNG7i9irvfZngF8nV4ic92M3fpdrFbV0WHgq5MUm28rCvVmD3YbwBr/twhsTEyG0dvrX/1RsJBWL7821Ye8+o/qZH8fqj4+ndrkU/lI8LyK7pA3EZYyhvEg1ZjnAE1d/n4jtN1KwOxiLDlLLTfM4+ubzzvA96t2vSQo88R4Jzk8q2EbFPOGuEzAzhcrfTpONR7KicntygdNEOwixtMwSMpcwkdzxXVP+Fg0kH9fCVkU62sDGI+iSROUHDOZFiG2j5MsmS7wat+glt3TnilMdXYdy/JlmTbUlkrTOlw3ERUjVCP3FTbHXCJbOJsJB/4zMiPFM13rCqohnU/55bIIwkHuqllnfkk6m0KmjX9loIDJ6vN3EqnLtYpnZuncnSux15h2mS5wFgiPfmowaM+QpypPwpp0MZmdARu3v54Q0QVzVXkZsRISav2/b0occsRRgfJj3ANCWjVLw1qF/fDw2GWehQ+Nxo744180EPOCtJQohsV5Hc4LL1mas9lRv6RkDY8xQMzkRPr27cJg0f2KYutJtbUSb+JuwWIO1grtA3b/LP+/hm2rlVyF6Xl0QcoenLICM3QPQLKzgFgVUSsWNfveoXKrY/1RH0oJnAPmQwPsz+eKOqFwoJol4r0U5qpc0d77NMT7jhdfIXd+J09IqhJNppYdQux18jr22jJo14CI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(396003)(39860400002)(346002)(6666004)(5660300002)(6916009)(83380400001)(8936002)(38100700002)(4744005)(4326008)(86362001)(53546011)(66556008)(478600001)(186003)(66476007)(31696002)(31686004)(2616005)(6486002)(66946007)(316002)(8676002)(2906002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDVIZjV3YjV4emVDeDEwT2cwMzNEem1EV2E3Wk1TalQyS2VIMnBLd29MVU94?=
 =?utf-8?B?ZW0zMXA0UkF6UFl5Y2dQNWFFUjV6cDlhelM1UzFwcHRJeHlBOExVR1BKQ29W?=
 =?utf-8?B?V0RvelZ2bmJCVlhXZGRTbk9sQmx6UmpSN2lwVG1lb2cxajlrbkpzMm8rRysx?=
 =?utf-8?B?WnBXVHp1ZzFERUNJc3F4ME5waFJlYURSMTRRbGljdHcwQktpcnRvbURxRGFI?=
 =?utf-8?B?ajhGejJuNFVBbHZkeklIWTlRcmpZZ2l1SjdRVUYwY3BJbEVhQ2lzSGlGUWFj?=
 =?utf-8?B?ZCthOTFYY2FWaFBFUG9yY2V6elBHZzdkZHo0Y1RmbStQa1hxVllCam5pM2sv?=
 =?utf-8?B?a1VSaUJpdTd2N014K1VPZ3RqOFExRDNRNUlhVlRJd0tnYitzWHVwK0ZFVnEr?=
 =?utf-8?B?Q0pxTEVBVUtjMmhlTGNweEhkMzZxdzNPYXRlL2c2bzFxNDFCdXZoNnJneVNn?=
 =?utf-8?B?S2RrYm1WNUxQMWMvN2RwRGZYejV1am9NbjFBcFV2d1h4aGtSdEkzN2p4ZmJN?=
 =?utf-8?B?TCtHUWlpVlBFeXpOWGM3VXFuSmRqY1k4N082aGs1dCtjckQvUVJDTGxiQTZX?=
 =?utf-8?B?dmROL244TGUzcFRqY1FnVHkwM1ZGSUdsR1VPN0tYS0FMQXI3MFZ4c084eGVU?=
 =?utf-8?B?WjB1cGJqWFlxMEFBRXd0YkhxWC9sY0dBMno5WXl1NHFzbHBiRXltc2tzMEsv?=
 =?utf-8?B?cTV6b3BDSXB3S1h1SzMwZkorYndzeFB5UUhkbU4zK3hmNVV6bGxGY1JrS3lt?=
 =?utf-8?B?THdaWjhiaDI2eTJOV1NhZVc4Y0FUNVdCV1lpQmp3K2srTGRoY1ozNGpUNnpV?=
 =?utf-8?B?ektUYVMrdlYwUU0zYjVrR2FhbDJ0Nm1aMUhVdmVUcGJobnJwei9qUTZ5empz?=
 =?utf-8?B?Qm5XVmFPbTMwSE52ODdWL0ZFSDZicmFuRG5zM0s1Q1AwMU1MSGxTTDB6bEE4?=
 =?utf-8?B?cm9ueGk1TGtUWkRpY2tZWk5GS0o1K2tkNWZKN0ZwSWFzSXd5Snd1VHlBTDhj?=
 =?utf-8?B?UTBOUzE1bVdNRm5wL20zYkVXL1RwTVgrc2RkeXY0c242dGxSN1VRWitURjJh?=
 =?utf-8?B?dXhKenNmR1NCNGdadUlrWnQvaW0wamNwNG9nSEhDTGxLaC9mWDVPOU1kKzhz?=
 =?utf-8?B?NzZBSlErekY3WFBBSmo1VE9XQ2dTTG5iMm5MdzdaY2Y1SHoyRXVjTUNORkJZ?=
 =?utf-8?B?Zm1tcGdlVVg1WEw1bkExVGNJWXdhT1hDbDZZMXJBZ3Q0bDNkZ0RKWW9VUEQ0?=
 =?utf-8?B?MCsvUnZ0SzBxQWtObzRGd0NpL0JBWWRadk9iYnN6RDhnN0JsY0V0dlVWem5B?=
 =?utf-8?B?dzVzYWR1cFpEd3JqNkMxdjg4ak8zNEQ3Vk1zUW5MaEw5eW5qTlRSZ3I2bHJw?=
 =?utf-8?B?R1dlMHhpNHlYbTVDSEdXc1lLWjZYcXJGYUsyTEdjakp6MENiWGZWbkMzNHoz?=
 =?utf-8?B?cDBjazJOaU5BZStwUnJvdldXdEcwLzkxZ3JlUC9JWHpmczFnZlNPYTZ6ZUxv?=
 =?utf-8?B?aUd3WTlKTlR0VG9WR1VuY2xTK0JIWWU5bndvN3J3NWowS3I0UWpLSk1OWjRX?=
 =?utf-8?B?cUJjVDdKTmtCWjFRbjFtYXBmVzFrM3pQRG9lNS9pT3BhMGN2N2lLazI0VW80?=
 =?utf-8?B?TjdpTDAvWUFDelhXSkJpWDhuWFEyMCtyS082UEtmQk52SERsakRyZnJFVHVi?=
 =?utf-8?B?UHpMTzhlOTVqMjBmTWZsOTJrMyt5MGM1d3NwN3RIQkpOcDZ2WDg5T0QrZFEy?=
 =?utf-8?B?dlBpUUtFMGo3dDNpenFMci9Vdkg3Q1Q2VWdKbU90WVo4YkRHVUJXb2FNNFR0?=
 =?utf-8?Q?J4RPknAQMYRxPUrDasi5bOUeX4ph0ujFH5u/k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef9d39fa-f376-40f0-fc0e-08d95d12f6ca
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2021 21:57:08.2581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CnZZpEowsJQMuQzJJ/gg6A+tFtXa2bOSXm+9O1BQWw6bcLk0bjPO4obKX8lajD14X4zLDAEq4IA2x2NDcJTRKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5645
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10073 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108110149
X-Proofpoint-GUID: KLRkzBNVY4bakPpvdMXkaPwF-t91G3FM
X-Proofpoint-ORIG-GUID: KLRkzBNVY4bakPpvdMXkaPwF-t91G3FM
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sure will do.

Shoaib

On 8/11/21 2:55 PM, Jakub Kicinski wrote:
> On Tue, 10 Aug 2021 11:31:22 -0700 Rao Shoaib wrote:
>> From: Rao Shoaib <rao.shoaib@oracle.com>
>>
>> syzkaller found that OOB code was holding spinlock
>> while calling a function in which it could sleep.
>>
>> Reported-by: syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com
>> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
>>
> No new lines between tags please.
>
>> Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
> Would you mind resending with a better subject? Something like
> "af_unix: fix possible sleep under spinlock in oob handling"?
