Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A382D34B3
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 22:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbgLHU4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:56:38 -0500
Received: from mail-eopbgr50105.outbound.protection.outlook.com ([40.107.5.105]:41985
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727988AbgLHU4h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:56:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZeKMnT4OwA18mHIaQ7GahKrShiLP9v3dK7EHEIA3Yv8y8DAeEY/2nkArT5mPlf9h6dcf3TIcytXQh0DGFjgHzwoOULqb5gwUIEUfmEDIMn7HPKLO8AmCxovMBRB4+gB7uOcYyhqHNsPKcfK8tVHx8hpPwoj82O+FIzecqbQolmujv/rnH59X3xiShnsCbZWG+nEe0Z94B6rVZFSSdxP7sBoG25xkzCpzYFiawfMHfcNVNpPszbuAczgEbpNjGa7/l/iriDDNNn4BNLcy2QhDTKyxRr2uZWHf9kxSZxtf/6DbIcaHQ6gs8r6kKd+FTpDO8Y+WSVugJO7WWs8oIKx2/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ph84XXH/+3bCdg+dgdqnCxRuVolrwQrJj+Rh59HJ0DY=;
 b=Z5CEDkfJxEKUmsyK/GbDfTO88qPI7bxhNFzjgdQxgVT5zPkFa9QjJOvlVY1zez3wk7tICmV8qlawJTUyvGtH5SiKzy2KiIea7g3sfcWQCHxyRr0OmOufP9+agfRheeGaAm29p+jOp4MTVUsu5rBkuoh/AkaLRWDU+idhO9gXsyvvEu/j58TyEUq1LgDkJD1qeMIOIJ7iznoD5PC/fC5G7wMhk9uVxCMeoDUZ3dKLF6QtZoj95JZdP17LjLubDcygPE6yXYxfNYX3xeI5dPZXzbIGC3osemsLqiFjtX/Hi31FOCznRGxf7raviW5KXjENdn8KM7gcIHR9B7wEQ3ADUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ph84XXH/+3bCdg+dgdqnCxRuVolrwQrJj+Rh59HJ0DY=;
 b=b1P+KcXTXcDZ3kZtdyacdPm5TsiTPB/+iLUgO2ru2YzzQU1VpwPExBj/KUoavkfSc9iNRbsSEMvHPP1p+29Kk63TyNDhqgB+D56SBG9XOdn6c8i855B3ymksQz3+YYYFDeiFo8anbOaUt6gC1pODqyJYIEwG4+MrKiGo4b+zzN8=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3617.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:15f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Tue, 8 Dec
 2020 20:55:47 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 20:55:47 +0000
Subject: Re: [PATCH 18/20] ethernet: ucc_geth: add helper to replace repeated
 switch statements
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Zhao Qiang <qiang.zhao@nxp.com>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
 <20201205191744.7847-19-rasmus.villemoes@prevas.dk>
 <ed16ea1d-5017-96bd-c1a9-5201f51231fd@csgroup.eu>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <17e064c3-41a7-fbc2-d9ee-35dd33345e16@prevas.dk>
Date:   Tue, 8 Dec 2020 21:55:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <ed16ea1d-5017-96bd-c1a9-5201f51231fd@csgroup.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR02CA0012.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6PR02CA0012.eurprd02.prod.outlook.com (2603:10a6:20b:6e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 8 Dec 2020 20:55:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48e48dae-2951-4d45-d1d9-08d89bbba38d
X-MS-TrafficTypeDiagnostic: AM0PR10MB3617:
X-Microsoft-Antispam-PRVS: <AM0PR10MB36174B78602E593D0439D43493CD0@AM0PR10MB3617.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HifXd7O/2n50ncOSl76UbH9G0r2KaWVqKae86eC56Di8hsaRKaNcJrydhN24ZXU+cchceZ0ENfT0SamIX92ffR91HjHLstEmcXADU1YZxfl1krdeRp1+KaZd4Q5VMlmfECtU/FUeP85h9lkCssMn4s9XopwiX1pyWzcECnVbaGqyXYirT+4jZp3xT4PnKyIp1aW4HtI9HblvXcAv1nGduLLCPJLrZckychbefHwu9JKCuiW+VpEE3OgkNpdRuUslygbqQBkR5jdqw+75bL4Gz1kRDBnImbQEfQG21w7gNIIHV6eBV38N1R1qGIhGl+nfRdhvxacxdJMeMQZYThMOPdaQjIuyt11xnG1XgVepw0c7uxlcybf5eBNGlbTqdN7iXvWB5yX1m893BYhYx3paE5gx1i5k21+qbfQP6a4lBEA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(136003)(8676002)(508600001)(8976002)(52116002)(4744005)(66556008)(5660300002)(31696002)(2906002)(8936002)(6486002)(2616005)(956004)(36756003)(86362001)(54906003)(31686004)(66946007)(186003)(26005)(66476007)(44832011)(110136005)(16526019)(4326008)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NUtJYSthWFBtS1ZwQkt4R2xJbmhZQWN2ZnJ2cFMreFg0Ym1Ub1Mrb0VONHVn?=
 =?utf-8?B?YnZBbWVrd1FadmRFbThDQVZDTWJYSkJ2aDBuN0dhUDdNYTBZSXR3SEVBTzBi?=
 =?utf-8?B?SGRpUCs2djBRNHdCVkZaWnhaRU1USVFPdFJaRi9Sb2szZVNUbFk2Nk1DRnpn?=
 =?utf-8?B?dlVoUmlTS0ZlMUt2Y2NZNGYvd1VCdW5Bakd1ZmdhRUF4RlYvcHlFRmpYd1dt?=
 =?utf-8?B?bzFtRVJaMjMrSkNORWwvTTBzZ1lCQ2xEKzBZQjlaM0t0N0xTRUNmZ2FDRkpa?=
 =?utf-8?B?TUljYXA0SkRWMmcxem12QisrOWtwNkw0azZxeU5YeW44NDFqV0ltcCsyaTQz?=
 =?utf-8?B?dTdFbmRta2xQS25zd3AwMXJhaS9hY0l6ZHZReWhRQ012S1lPcCtTQ0JWRjFS?=
 =?utf-8?B?ZHJqNTJrTVk3bGl0OEFHUUZOZVphSWJtVWRDNlFSWlhhbXZCRGRod2tFWm5a?=
 =?utf-8?B?OXRDWUVpS2pOUVZyUkVKeTQwaGluYVgxcmhvRi9vWXpxd3hzcm9pcG9hVkJl?=
 =?utf-8?B?ZDVUeUZSVEFFMmVUQXZ4T2wzTCttY1FVYk1TVjlWWEFMYlJXeVFSN1ZDMjAz?=
 =?utf-8?B?ZW9QdVJCRTZFUEUrWFNGQWxFS2lGN1VTcW84WVhQdnZwUC9yUm1qTUJtM09W?=
 =?utf-8?B?ZWx3VDV2S3ZvRmpMbXVPQ1E3Q3I2cHJIVENTL2M4UmtLVzNJdFROM29TRk95?=
 =?utf-8?B?ODljQU5VYUt3YUloMlNFVmpNOE1FN0Z3bVo0QmpzMlR1a0RQRUowNUFLRGVx?=
 =?utf-8?B?TmlvM2l0aHB3REVTTTg4MzNmcmkzREFwbFN6azZRdHhZUjN4a0VBeDlQczNL?=
 =?utf-8?B?QUh0aHNSWGxYQUpRR0lLb0VZVnVBeHlrcU5ZQzROUUJ3elgyYnZwOEY1ZlNv?=
 =?utf-8?B?bTdBKzFCYm5YVkdmUXFEQzZ6Qk8zeEhHdFhocHN5eW9ydXJVSUtMVmpMOXZs?=
 =?utf-8?B?RFRCczMxbVB4UnVwcjJaWXA1a1o3enByditYRHZ2QXNVUnJ1cnRzSXVNTVZD?=
 =?utf-8?B?MG5FcEhVU0U1WURLMUYwQWJvMGU4VmVESXFZakpJbTJ5aERIM1JhYTRTZ3ZV?=
 =?utf-8?B?MUxuRHU0dEl3dzVGTEJmV29QZ0pKcEpFZzBTaXRSazR0UGpPVjJ3ZStXWjlv?=
 =?utf-8?B?Y3Q2WDFOanRHZHZvcFFoTSt2a3gwRWpJYU5QQ2VDdkhtNmZEcjJYRXd5MjhN?=
 =?utf-8?B?VGZDOWVCbW53bHoyY3ZuTSsyVHZLZGhoWElydVpVQWl0TDV1UndYMWVMVExv?=
 =?utf-8?B?ZXlEc3lKVDY3TlVsckx6UjlMeGhTQXZiQSt6cGpST0N2VjhrTXltZnkrNU0x?=
 =?utf-8?Q?xgNeKpKGN8g6E3w92t98G9lmF0slB/wnDb?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 20:55:47.7755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-Network-Message-Id: 48e48dae-2951-4d45-d1d9-08d89bbba38d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xJTweDJ3692MKPpLjjW2FpV2dQtznEC2yfVvSHeY4QlbNREbUjkg46wz5u9bq5VhVbrq++N8Dl2nQazNSlKWcSzBg2od+7lh03t8/BbMdcY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3617
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2020 16.21, Christophe Leroy wrote:
> 
> 
> Le 05/12/2020 à 20:17, Rasmus Villemoes a écrit :
>> The translation from the ucc_geth_num_of_threads enum value to the
>> actual count can be written somewhat more compactly with a small
>> lookup table, allowing us to replace the four switch statements.
>>
> I think you would allow GCC to provide a much better optimisation with
> something like:
> 

Your version compiles to 120 bytes of object code, mine around 49
(including the 5 byte lookup table). They're about the same in line count.

Rasmus
