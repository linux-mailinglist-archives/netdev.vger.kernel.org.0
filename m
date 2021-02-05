Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18D53106FD
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 09:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhBEIrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 03:47:14 -0500
Received: from mail-co1nam11on2051.outbound.protection.outlook.com ([40.107.220.51]:6752
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229500AbhBEIrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 03:47:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czWrJET4FGyOE++y621eTdbkVeezUulCgcsOaBliFJztKEmW2IIqqXaDQSk1mPUN2pA+wdcUMqoVD9glB0x9qk4AbgCIV1TckjGEosoldaLDfhGARqN86wure0YZY9QXuIyWKJEF1D1y+K3aLgEvEG3mkbR/iJ8zd9UmKg2Efdk9r+Xr7FB4X0wGLUUfTT+x3wd/57bQt7eEAyHtDxQ/bxDMlBZpamOu1hEStTveqOavBfah22Zc0iVU7GuK3ZCIaVav9WzYvPz955WY0q7pQII3u23tq1R2Qu5h3TZ4xu6Drlysf3usTlzL3+SmrPZCF17m9vMYRaOlCV2HW6lZqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EP6pq4CItDZtzXTFWszUmDr0o3zIPFdiXlIyEMlHxlM=;
 b=JB5UeUYgfa2tdQO1nlTSdr2TKtOe4+2aDN3Y1AplWXuADBn6v529B2ohJumzU/VKcqtQv3xyC7EMEyPHET4PEcxWJ2jCQl2+pfTIkoogzpIfNZt0v9/fTsrQni+2RueIc55QlNRza/FkA7opob9lTicVVMU8dCn+oCh745pwANcNOsZQumdVjdmEf/Z7ALx5EmLBgBH8Q/WCYmvTfj4N6wTSPdwk+N2fK5dE1JrBDrulZsAS2MCr4NO9hziSGwIsFHQOYrVEIxmxyv+iIvlg9pffqDGisJGoPPmcBQDc/o3IZMNRhFShXEA/Xc8N3pxXOhtccaxyhAwwCUB+iNqUEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EP6pq4CItDZtzXTFWszUmDr0o3zIPFdiXlIyEMlHxlM=;
 b=OA99V7VnWPrc0e9GPqLV0s+aZxVZafO6WktoHggwHgZVAJ6D09Xb6cHdXq+d1dmp4DtStzW3xpvGElFOvvR+657PG9hiy4uLxkU+v7GGMIcr5xpU2KZDYv0ph6jLAmz/TJ8JRFDNX0gW/3lw1yRI/TBsh5qdyEfKLmAhHxiEY/0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=windriver.com;
Received: from DM5PR11MB1898.namprd11.prod.outlook.com (2603:10b6:3:114::10)
 by DM6PR11MB3689.namprd11.prod.outlook.com (2603:10b6:5:143::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 5 Feb
 2021 08:46:24 +0000
Received: from DM5PR11MB1898.namprd11.prod.outlook.com
 ([fe80::d4c5:af6f:ddff:a34d]) by DM5PR11MB1898.namprd11.prod.outlook.com
 ([fe80::d4c5:af6f:ddff:a34d%8]) with mapi id 15.20.3825.024; Fri, 5 Feb 2021
 08:46:24 +0000
Subject: Re: [PATCH 2/2] can: m_can: m_can_class_allocate_dev(): remove
 impossible error return judgment
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     wg@grandegger.com, dmurphy@ti.com, sriram.dash@samsung.com,
        kuba@kernel.org, davem@davemloft.net, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xulinsun@gmail.com
References: <20210205072559.13241-1-xulin.sun@windriver.com>
 <20210205072559.13241-2-xulin.sun@windriver.com>
 <20210205081911.4xvabbzdtkvkpplq@hardanger.blackshift.org>
From:   Xulin Sun <xulin.sun@windriver.com>
Message-ID: <9cae961a-881d-8678-6ec3-0fd00c74c8ad@windriver.com>
Date:   Fri, 5 Feb 2021 16:46:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
In-Reply-To: <20210205081911.4xvabbzdtkvkpplq@hardanger.blackshift.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR06CA0003.apcprd06.prod.outlook.com
 (2603:1096:202:2e::15) To DM5PR11MB1898.namprd11.prod.outlook.com
 (2603:10b6:3:114::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.221] (60.247.85.82) by HK2PR06CA0003.apcprd06.prod.outlook.com (2603:1096:202:2e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 08:46:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd1eb4a9-679f-4226-286f-08d8c9b284f5
X-MS-TrafficTypeDiagnostic: DM6PR11MB3689:
X-Microsoft-Antispam-PRVS: <DM6PR11MB36891CB4D8C2855777FB369DFBB29@DM6PR11MB3689.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zc7B/kzDKHMWzC4/lugK16v7Rl58iWNG72Sqls6NwnRokhDW4MuVC2+qKzlx2tcZzfoOyD8LVE8/9HRatLnGb/jrGFAmmO5chDzNRaaDDl+zvpxFhcJW9+cExx804ETibuBk85kQWJ+lznIhSGPv6zcYDap5wxBOjU8n+yqoDZoZMCqvuba93tHrLyUhPVz+hJr5CCaMO3Tv+o5yCgr0j1rFCiQH1vJeuf5rzsL2NifieNxtjBi3sHFxXHDvrfIVNSvMzhuvL7iGXBMkL258zzgYSzjJ2Sy1zGsUTOO+0HSxiiUXuH9jpQCcNKof6Mj9coDhFX4LQY/InGvzR4pOjVCERUKUShcr36dk/3/deixiLZwNFfCdzLqLhFv4YT+SN+OMBOXoA5ulO+IKK9g2RuJLI1PYwBh2B/03oO26DXbbA/NQmapW30WgeBTSXWAI8jDKQOEUCiwcWvK+zfGb2RgK3Ggk5mcmhAwEubG7KQ0JEPMb8/Q5+Acj/86zJNSk9bV14FPbhY1jxxAijwPPLoxUWuZiCV0cn4whem7kFT9Eeq7+5duxn+jXxexGiODs4DM62tNC4IRgwsmbKWHE2+ITw9Rkr0/KcM2CdSNeVQUiMHjMeMX0wRwW4cb+D1dP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1898.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(366004)(39850400004)(136003)(16576012)(66476007)(8676002)(66556008)(2906002)(6916009)(8936002)(6666004)(316002)(5660300002)(86362001)(26005)(186003)(52116002)(66946007)(6486002)(16526019)(956004)(2616005)(4326008)(44832011)(36756003)(478600001)(31696002)(7416002)(53546011)(6706004)(31686004)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cGJGQlIrUUFualZyY0wyZmpkNHpkeHhFa2dtMVpQNDFkNkczemcwSTltTkxn?=
 =?utf-8?B?ZUVVZlBpK0s3RVBQU1dUa3owaFkxcXlQVE05M3I5eDNwbXlCUnR2aTU3OWZ5?=
 =?utf-8?B?UHVIMTFNUzcwUHBzbVhyVHp5T0JmU2daS3Q0MHpSNXJ5ekJMNFRzWkJMWnUx?=
 =?utf-8?B?Qk03RWN3WUxmZDVRU1luQytleGhxU2paVVgrbzRvdDQxM2NCUWNsek1zV1Jw?=
 =?utf-8?B?V3lvYmYyekJFRXFpS3hpMWI1TDhacWVCRmR1d1VDMjByZU1ETnEwMzF0WEFW?=
 =?utf-8?B?QThjVVlNMWxNVU8ySFNLc1RxWUlRWUsvTEVCQU1pZWZaRFcwdkJ1OGZrMUk2?=
 =?utf-8?B?VG9qM0p2VDBEaHBsTy9BY0p1ZzA1bmc3ZWNydEo4TFRzNUdtek5BNWpDVXBa?=
 =?utf-8?B?Tk9CbHZheE1tWWpVNjAxSHFKZ0licDJwSUc1eEljV0VvQUVicndJMUNKWUIw?=
 =?utf-8?B?SWNsRkd3cEJYWFNiVXRnMEtPeCt3RFY3dVVWTmpuKzIxS3UzVWpCbXBST0Vk?=
 =?utf-8?B?cG5lZmR5ME9udkpaMFZ0cEt1SXorWlc1SmJRS05EMlYrTW9lQWNvclBlSGZ5?=
 =?utf-8?B?ZlYva3JHLzYycjFRQy84bEtlZjB4c1Y3ajEza2Rnbk45NmJieEpuZDhTczR0?=
 =?utf-8?B?T1liTVBpV0pRN3RBbldNWjdEdjNCQlJSMXFVZXQvSW9QOHpBVnZyWHhkVUxY?=
 =?utf-8?B?REwrdTJmUjlGU1dMYXlWd3ZYQmRYSElrM1B1MUs4WmM3OGptdFNOaURLNEE3?=
 =?utf-8?B?M0Y2WWNCOW0vT2V2ODRvQkV5K0Q3UmJuUWJqRkhhekdXNWdmMVhOeE0rU1ZL?=
 =?utf-8?B?clZBZDlBWTlSODJ3Vm1hbktnajZZb0VLQi9aelZhVVg2VkdBbjIwejNzbnRa?=
 =?utf-8?B?Q1Nodkk5ZDBEamd6OWNpMURvaFhLOUpTNFRsM2NUYlBOUWhOWFBZK2ZPU2RP?=
 =?utf-8?B?b2RKeVlpQlZnc2hHS015UFptdGc5T0VVQ3pYMGNaS1l2SXpqYVRhQS8wNlhk?=
 =?utf-8?B?d3N0NlFsODhsaWxNVnNYZXlrYlM3MHU5cCtKWWhDclppeU85VlBrQzdMeStB?=
 =?utf-8?B?eHU4ZzFMRGZOTUdjaHVWSWs4K216OGh6b2pLTnRmQnBGQmQ4Q3VpVTNjamh0?=
 =?utf-8?B?c3JPdG0weUFYdkJGZys4YksxdkJqRzc3Z21jZHp2Y0MzaHc1RDdyMjVnWDE4?=
 =?utf-8?B?UzkxQ05DR0dwc29jUFBFRjNVZkNiN3ZDRUcrbjJYa2pIc1l3OVIvU1hyVktk?=
 =?utf-8?B?TmE1MHhHclBWK3V3ZHVIekVHWkZRZDV2NXY5TXVoUDdwZFRpTEtzZ3o5bHJi?=
 =?utf-8?B?WkRpbTI2Rktxa0FEWlRtSVo4SktqdnlyWko1RnNZaFJyNUZNTjJucHFZNUJW?=
 =?utf-8?B?ZGVYY0RaOU5ydFpTVHc2Um5nWm1jTjgrWkpFRC84QzQ2TVJTQVFpdVgzODJ6?=
 =?utf-8?B?bGdwanYrd0loNHdoSithek9leE91emZ0MTYxa0FnV1d6SG9kSTJsT1ZlZUth?=
 =?utf-8?B?SmIwdEZwdTlVY3FUSytuUWVtTlFCYjV2RDhOdTRuR1hjQlZUZjB6aFM1STVU?=
 =?utf-8?B?K1RPakpDUDhiZlFnM09MeTBpK1pkQnl4ZmZ4R0hLc2Z5Sjd1c1k0Zno3UjRs?=
 =?utf-8?B?ejRZTXpaTzYvVzRkRTJFTHoyRWpKaW9RajRRL1VmYmlXQmtWZFdxRnhEWkYv?=
 =?utf-8?B?eldRZ3o3QjN3V1FJclRacGs0N1o3cW1lYVFrbXB4YlJpemdWOXRaTnBYamhw?=
 =?utf-8?Q?eDy6OD2DWwjF5Hp7rHRqH9SyWtVSHkciPsa16M7?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd1eb4a9-679f-4226-286f-08d8c9b284f5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1898.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 08:46:24.7185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hc+9YkPUKsP38+Cz6U6v/hfGbtY6BI0hgho2oR0T+cV4WYP2FUnyk+5rhFkZYYA7vGX4t6dR4+vBxrKJu6ptVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3689
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/2/5 下午4:19, Marc Kleine-Budde wrote:
> On 05.02.2021 15:25:59, Xulin Sun wrote:
>> If the previous can_net device has been successfully allocated, its
>> private data structure is impossible to be empty, remove this redundant
>> error return judgment. Otherwise, memory leaks for alloc_candev() will
>> be triggered.
> Your analysis is correct, the netdev_priv() will never fail. But how
> will this trigger a mem leak on alloc_candev()? I've removed that

Hi Marc,

The previous code judges the netdev_priv is empty, and then goto out. 
The correct approach should add free_candev(net_dev) before goto.

The code Like:

         class_dev = netdev_priv(net_dev);
         if (!class_dev) {
                 dev_err(dev, "Failed to init netdev cdevate");
+               free_candev(net_dev);
                 goto out;
         }

Otherwise, memory leaks for alloc_candev() will be triggered.

Now directly remove the impossible error return judgment to resolve the above possible issue.

Thanks

Xulin

> statement. I'll add it back, if I've missed something.
>
>> Signed-off-by: Xulin Sun <xulin.sun@windriver.com>
> Applied to linux-can-next/testing.
>
> Thanks,
> Marc
>
