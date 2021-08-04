Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E78E3E0769
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 20:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238022AbhHDSRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 14:17:01 -0400
Received: from mail-dm6nam08on2075.outbound.protection.outlook.com ([40.107.102.75]:42091
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236761AbhHDSRA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 14:17:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZ92ehMUaM+DRlisr5dVYkPbwnMPsteQ3V67nr6WqE/+LrYwMWLm6IMAmzHolmcfYjfXnhRJTth8qvSbBNSxZLjbmTEuzk/L5Pajhk1VxrHKXSlhsXcE9BIitPNDbzj5Up8KBa9qZP0GM28U1nxFWH/5vF20GA9pR3DH9xFrUVW1rs6E0Df7ooJeDPWV+CWKq7c/EkJ3ZGuQ+ITdnacI1q4UhWTpzK+7cOGFbxwhsCM7WTNz9E6p63NthsYtdyRYUcfr++ze9gkYl1Xsc4Nr6cf+CHW8sPjjax5HnKZqUWx0+XSVFGU+JOZf4UJ7ItubZqB/LzxGhzxxur9rEhlazg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21k9UmOmECgnE1/EUpietXhisMdQ+uQcI5jWL9ilyiU=;
 b=LhNelUCkU7itgIKNMhhnZNbhgLt3ezGdHxv7CovJlofm/W6XVhkcy4bGh30afo6cv42DRmeudc+uDVTjNfWdzZFNmyDq/5DiW6FfPqnOnIEdUekhqWzcCfC3qU+vZSW1pf1pLwwyCjZyegLQNgfXRwvYH1B2CrqB+m4XS0KjZM1lzUY1ybWGzYkhYsNBsHsNVq3FvR8sWsuaKQ4cc0Vgd83b4eAlDZCR3CD4RR58LabLumnJBZNfqwc8xMZJbFE5pI/RnA1mNOBSfq+k3NNt8DqRdwV43f4o5XO9GQ2ruFJpR3INJpPJu2b8d/9m0ke5kqMN2SrcZpelSP6Vb++0FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21k9UmOmECgnE1/EUpietXhisMdQ+uQcI5jWL9ilyiU=;
 b=QXAIwMa2LTzkh5fOAcz96BgBYt+TZGg0G40Qmz+N2E6AdIodPXRDZ2Uf+yIO1bs9uETLLiLBiuUtf9v4tpsuyJe4pTnzmjF17xO7xyifHlEaEdh3OzIs0k9FXploDqq+G/MbxmvbN3AS7V1BXahcV8UpvoHW991R5CrlUZk/NDheJ3RMwxq03TxbGuyc7yuDVydUs7dBakfkOeXtT56i5zzlVWveSJ61gFilPPiFxM/e3aJd55Ytd19dWXWSrdtdNnGzLCGrRqi1nTsOkpzgnEYCUC0x7PbRpVH+xCYc/4u+bAR++fBWrBTW3zR2gOffKGrGRNiKTEOkZjU9o9vOlw==
Authentication-Results: arndb.de; dkim=none (message not signed)
 header.d=none;arndb.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5216.namprd12.prod.outlook.com (2603:10b6:5:398::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Wed, 4 Aug
 2021 18:16:46 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%5]) with mapi id 15.20.4373.026; Wed, 4 Aug 2021
 18:16:46 +0000
Subject: Re: [syzbot] BUG: unable to handle kernel paging request in
 cap_capable
To:     syzbot <syzbot+79f4a8692e267bdb7227@syzkaller.appspotmail.com>,
        jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        serge@hallyn.com, syzkaller-bugs@googlegroups.com,
        Arnd Bergmann <arnd@arndb.de>
References: <00000000000009422905c8bf2102@google.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <5ccf831c-025b-88d0-48f9-d5e0d9377c70@nvidia.com>
Date:   Wed, 4 Aug 2021 21:16:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <00000000000009422905c8bf2102@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0017.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::27) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.206] (213.179.129.39) by ZR0P278CA0017.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 18:16:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7cbae2f7-e571-4ee5-d50e-08d9577404cc
X-MS-TrafficTypeDiagnostic: DM4PR12MB5216:
X-Microsoft-Antispam-PRVS: <DM4PR12MB52160B08C2E8486A37B0CB90DFF19@DM4PR12MB5216.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ankHtgtzz8YoyBb732QX+jH/kdT+IZGHSXIBkIWpN74/7SW1wZZFFZFfYlw1SZRPBENRYbpCNBvHCDLFH/bzhhH275Bhgo3CqdU28fpTTu1cKW4NX7FKeXPEyOrbCHPNQkIy7GTKLNWZqP0tqATWg9vDEFKti9i+HGQNdhZvC1jI51UiUNk9wOE+1vTxkd57qeu64uTahjuY+VNPwLv2TbK/PbrjRoF3KfFiwUh+UaHdnVie6Q0miQGJ/ii02VVXbteXeXzH+Nev3/T2DadE52xt8TwTivyMrerOfTa5/E8I2q0/y3YSOzdzJhQXfXMea90f35P5EJJTW9qILim7S9D+9RZV46zdw6OYdLqiSdV0tdzToQtkTlWa3SDIH43XRvTX8nFnh+lDMbNJVyM924MpJqRMf9tAKaEDsj321me3mXbEQRYLR+5RsIcScDCVxocPxVUybFuc4LKgMeyETR69WUUpsd5jZu986mUuZMlKVggXQtHkHfu4fdS1p86i0zgyuwYLyAuzq0OslDCP8zwpjffCIE+0ZhbmalU6dqS+izYSynn9nZxHEaZw+APR/hRIxTRX9qsgss54KFkQj2U/xMzop8N44mANMOXYEQRfE6fEq8a6Wt4cgNXpjSatG5TYIbUcnrhMTlLgI/232iXYttZqWkqzpEWyFgHR9Hk1ecSqGO2kK8ABQoAmlBmzAeqL273ROff1ylf1oZyOa4y+0w5vYpMP/8eQUrMzbkRrg4lkMsQWJbbyp2yKBVBFLAbrFJqjy6OqHTtvxQOR063a0xcTf8G09o9gHVkEDR+DFfJ2RYL4OA9ciyTeJwB0heGSXaFnTlnY95fkRvTxUlKwUFTsBXtpd9lH/T0YT487+fNrYbT023uJ7bouVil
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(66556008)(53546011)(66946007)(316002)(26005)(5660300002)(2906002)(2616005)(6486002)(8676002)(83380400001)(31686004)(66476007)(8936002)(110136005)(186003)(956004)(31696002)(86362001)(36756003)(38100700002)(16576012)(6666004)(478600001)(966005)(99710200001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OE5QenJYTm16bzhRd2hQV01yN1dMdkROWHRzbElQQlFIOHY5YWdJeFlkaVI0?=
 =?utf-8?B?bXFFYnhObmMvWDZrZVBMRXlIYlNsdXVLS3V4b083MGM4YjljdHY0bXlMTVZm?=
 =?utf-8?B?WW1TZ3Q5Q0pGWk1iL1RXTGJTRVNVdk0zdEVOS1ZCSXczSGpLLzF6eEdCa0F6?=
 =?utf-8?B?K3NSSysySjJwZVdRWkpSSlB1QnNobnNkZmFoQm1ndkhpZW9wRWVrNmwwaWxS?=
 =?utf-8?B?TFN5VmhNdGdhaFZWOUNnQk9YdkwyU1Q4ZmI5VWhLM3ZPTHRXY3l6cXp0ek50?=
 =?utf-8?B?ditpVUkzS0JDaXlsaXRYUDNBR1RFUlJHYXRQSDlDdXVJMzNXYjBPZ3UrcVpX?=
 =?utf-8?B?V1E3RlBVdUNFMWJ6akJhZDJnMktqYVc2MzB5UURRaCt4aVQydEVwMndUZi9X?=
 =?utf-8?B?Q3lCWi81OE5RbTY0Q25xdzFVc1BGRFZ2THNadFZ1dTNrVHR2UjJqL1FlSC9V?=
 =?utf-8?B?eXdNR1lwNVhyU2doYUZQdFNKanpRUjFwV1l4SE1Jc2ZyRHZ0OEh3L0R5eEVU?=
 =?utf-8?B?OHpjVkpJZzdVV3dVeGJkRVFldStMM0RML2x2T0FoUUM5andHWVZtNE1GWDlJ?=
 =?utf-8?B?aC83Nyt0Uy94UWszcUwwSDRFQmlxcGlFS1U1S1poMVd6d0h6bnNZclFUVUNs?=
 =?utf-8?B?M3hhdTlxcjlLN1pSS3ljcnNuU09iOTdjb0RsVFVDeFhoZlJHU2hLUDNUdnAr?=
 =?utf-8?B?Q0xUU0J0d0R4QXBCWkVVbE95U3VaQ3BkZGxOSFZzUW1jak4xN3crUHljSkVU?=
 =?utf-8?B?VlIybVkzbE1GV1EyOWVDcTU5U3pNbXBMSXBBMnFJeVg5Vm9Qdzh1RENkT3VL?=
 =?utf-8?B?NGZxUXYxTDRlZUU0MVkwdzk5TmFEYjdXL2FKWHowMXpjZDZKVkFFbDlkSmtw?=
 =?utf-8?B?WmlUQXNZK2pRQmdmRDF0ZTA5NDJIUEhVaGY3cUVCRlNkWDY4Rk4vVi8vV2c1?=
 =?utf-8?B?K1I0Mnp0Z3JCT0NFay9JbU9zbERJTzY4cDNiUHVlVm81STdYMWlEL3BrdkJx?=
 =?utf-8?B?N1JWMFlTM04yaE84QmdaOUhlQngrSjViQkNMa3U0MnZiV1dDN2V3cHlFaXND?=
 =?utf-8?B?bHpaeDIrTkVqVHZ1dkdHdm80SXlBdXRPVDg1THV5NnRKMXRkTTAxK1dnaFNE?=
 =?utf-8?B?N25qWHp0eVkyNElraE8zYVVHQ0dpUTJZa1A2MlMrNlNyYjJYMW9WTS9zdUJL?=
 =?utf-8?B?SFBudEduM05vRGFsbll1N2NDQ0FPZ3g3eERYOXFqdUNUTjc4WnllT0hjRnRF?=
 =?utf-8?B?U0grbDZYem00VWpLNXJ1RmpLZnFJWjNKRnY5N0RDV0dNZG02NjRQSlAvcGhK?=
 =?utf-8?B?d0tUQ05nTktsUDlaQmlaVUJIMEE5bHd5UGRuVlR6WXJFSnUvZ1FLT2xXcGVQ?=
 =?utf-8?B?U1ZLQ0lpUjd6S2NUZis0b3d1M0pmc1ByN1F6dE9hV0kwb2xIc0Z4cHZwZ2VD?=
 =?utf-8?B?SGZUS2lMcEVwVE9LUlVpV3M0Z3Yyc2phUW1BeFFTbC9SclViM29PSzFwRkp3?=
 =?utf-8?B?VEZSVXd2dG00aTF5TXBrMWRDUmdnS0NvUWJqa3FBM2dWTEVweVdqdkxPYktk?=
 =?utf-8?B?UGw1Um9mLzl3eXAzNWV2UDJWNmkyRU9yZnlucnRpMEVIWHE2YUJDMDFIbEZR?=
 =?utf-8?B?QXRhYnpKWFVuMFFxTXRBaDhFaXZEWW1SbytTNitIaVl4R09jaGZZUlFibHFX?=
 =?utf-8?B?dkJOQXkyNnpNM2JBNktXVGdKdXdDQnFBVW9qWkJMK1pHbkxZMjB6ejdSVFRS?=
 =?utf-8?Q?BNw9x605mfgf4Bfr9pPYkbM8sAtAM3fTIGhDThD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cbae2f7-e571-4ee5-d50e-08d9577404cc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 18:16:45.9982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ogI9Qj+SJw9wFOL7U82+I5M3maCVxRPdef8kHXB9b7qeX2JutDQCO/ZxTbuNl4u01wWs5jgz2q3pEaZyXVIVLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/08/2021 20:28, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b820c114eba7 net: fec: fix MAC internal delay doesn't work
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=11fbdd7a300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5e6797705e664e3b
> dashboard link: https://syzkaller.appspot.com/bug?extid=79f4a8692e267bdb7227
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=127e4952300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16fef2aa300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+79f4a8692e267bdb7227@syzkaller.appspotmail.com
> 
> netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
> netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
> netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
> BUG: unable to handle page fault for address: fffff3008f71a93b
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0 
> Oops: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 8445 Comm: syz-executor610 Not tainted 5.14.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:cap_capable+0xa0/0x280 security/commoncap.c:83
[snip]
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

+CC Arnd

I think this bug is also from the recent ndo_do_ioctl conversion, it seems
nothing checks if the device is an actual bridge so one could call br_ioctl_call()
for any device. I'll add this to my list, it's a simple fix.

Sorry for the delay, I will send both bridge ioctl fixes tomorrow.

Thanks,
 Nik
