Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E55422E31
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236549AbhJEQox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:44:53 -0400
Received: from mail-eopbgr10067.outbound.protection.outlook.com ([40.107.1.67]:12558
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230445AbhJEQow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 12:44:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVo6SAKJFvp8+zfnQY+RagefbWevFu292uJpgGkzXGAnU2NnPBki9ewgQenZ4E3KpP/JLRJWuh+vZQVr2geBf9nTjVCakAPnXlEkwNQYaWPzHgpe9zf+a0FYiSqfhbm0QcqFMKdW+C04K8jw666c5XLA0rZW0+gExP8PDTHVZ44F8CBiKhDI8E0IJ1XL2RcTyq15hISubAguH7yx47SmWwMpD2yRKFzxCqD+VUYh/pm+oTOGidvse9sYn7I5eKvqM+NaL18DF7/DrqZYcWRVBPgAvxb8HP2D0XiSt8AFVHw0HH7svpRRuvNQWmOt6aVBF8b44lliWMRCTNHulyitfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nmNvox9fNTyAx4sRX7BYLkOha1P7aQNcBuaDTgt2gBI=;
 b=F2sG7x2CcArCncuIJ2Zaa863Y6WjHmUUcfIpzslmQio86UjOJIGzjtm5ePHr28pd8VkyIxnlR2+ZuFRfQ0skMRu89EQnfHWrte8lwAncg7yzjgXcGP6QGN62D1OJwjYNS3Lf8KK26UJcxKGV09fAp4iGny+/dFdLKJMBx/zKh8UDFYIr/2Gt2toz3/DIAqcvgd6n1cf63sU6p3UDSdreVJUVKDGYI+e7ycJ3lTGR0NAwxjJO+rwZzrehxE4iwZrr1ASwXzaKm1gDNP+zg/OFuv3JWGYjC8iV1f3V9Jj9qRFM67FG6rW++ICGFygzMYlUqeC2lyXC25i0JR9F9oYzIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmNvox9fNTyAx4sRX7BYLkOha1P7aQNcBuaDTgt2gBI=;
 b=L1ZQOC8keFh62vYdPeN1lwYX8UW8EMHeOp1vYbW2lZ3ZeETuuMqTzDWb+fstEurOd45H9bYP1i6P/+Pj38lR2R4OAJgo/zKrCqPW/OUBNv2FgnlPpId7ec+kqV+OKD057h6GmDxWkbVYieUTBVCmHsZA20g/nB7H/bEglvD+U8M=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR03MB3047.eurprd03.prod.outlook.com (2603:10a6:6:36::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Tue, 5 Oct
 2021 16:42:58 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 16:42:58 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [RFC net-next PATCH 05/16] net: phylink: Automatically attach PCS
 devices
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Saravana Kannan <saravanak@google.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-6-sean.anderson@seco.com>
 <YVwfWiMOQH0U5bay@shell.armlinux.org.uk>
Message-ID: <61147f21-6de4-d91e-c16f-fdb539e52b42@seco.com>
Date:   Tue, 5 Oct 2021 12:42:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YVwfWiMOQH0U5bay@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR14CA0022.namprd14.prod.outlook.com
 (2603:10b6:208:23e::27) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR14CA0022.namprd14.prod.outlook.com (2603:10b6:208:23e::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 16:42:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2778ccfa-33d1-4c3c-7b48-08d9881f304b
X-MS-TrafficTypeDiagnostic: DB6PR03MB3047:
X-Microsoft-Antispam-PRVS: <DB6PR03MB3047C4D055F9A473F9C880F696AF9@DB6PR03MB3047.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FhwjkEwy2+ArcrsjigdoqkMUlFrGHbYB8KUN4t3EHCVC1mHyy6AUAa83kSYKQFr82aPAUxvqYBTsOsRX490gJNKSYJ6l6SO4bB6WA2NvdWD3IXDJ9RwFtyHfzzH4zWXgrWFp2VaX36O+8kDqt4e2TUWcVKRFj42nEznBYE1OnwJI0hgWV7kGmLmJEQXmbHSRRJqmrtOxXfOcp8mKGRVn/YrOJidReG4wIvR4nepEpLzF/bHygYRE9HNN6M/s1dCE/s2nbhS8NPpfAYr3jM5w7Z2kmpCDEmWE/YMm66y5ZuIInH1rPKtqlW45JCtX9QG5fwspLjgFEz/nrbpbSzzAvBGZqvfgsyW5zwhnMzBXtezy7Knr/kLgRJPDEqvVASrZQfyVa0buzvfQoKTW2vBpMC83+DCRaXUc/UWkUOYbgtu45L731AkJIXi1y6Rf2Jqkjeelfgt+wU1di8AmZIlOpwIalevEZzAq2pUpZM+tqRM/r6vnikM5SLubWl4ksGZR/1zNe1FU/0XjI6xhw0qdjweG7Q/n89dBPwa4EIlYN8w1OwASaexTZQ6OrJXo4zUhNhYs1ifmiM6MNaakRbF3qwd1S/b1B9mGLoRlqBnhCQE9N+jz6a/nXg5aDyUNfUt1wGtTcGus2NVflZnn/MXaXg80mJtuQRKJsx9bbRk8CpNbV+nlGHE6SsFYC1RjotT66OOv2f55tPRWFq8L93be2Z91ebjx3XWQ2JVj72J9C9nY+FRWWfiYC7nOZsb5uwa4vsiS/0Tqhg4GrexVoNPr2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(6486002)(4326008)(5660300002)(66946007)(31696002)(66476007)(8676002)(38100700002)(316002)(16576012)(86362001)(2906002)(38350700002)(6916009)(54906003)(66556008)(2616005)(186003)(956004)(508600001)(36756003)(6666004)(8936002)(26005)(44832011)(53546011)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHczYk1DQ0xybkpkWXE5bi9oamN6Y0k3Yjd5T2ZQNGNEUnJGNFAzdVd0ajZx?=
 =?utf-8?B?VE1VS2NYNmNEMUxtcURzQlZ2am9EZkNIN3JOL3dpQzJmdjZYUlRjK0IrakNC?=
 =?utf-8?B?dW84MDR2bjZZQXNwbDEvbzZBSEFjT3hJaFVjeWFGWVFPWnIyTDVtU0VGVDNI?=
 =?utf-8?B?bTBKUVhLazNpcEtEeWVPTG5MMTlpOHp2UHFCRFVZUlZITjd2ZGJNZVMzSVl1?=
 =?utf-8?B?Tjg4WWI2ajdLNkx0ZFp4VGpDZFk1aUxHZEYrNHFOUGNycnlITm9obHJjMkty?=
 =?utf-8?B?OTFTWk5CeDZGMVlqc0pYQmpWbE0reTV0bjFtL0ZSTmpwUzlkWllTRjRuQXRH?=
 =?utf-8?B?NTM1SnR4MHptTExmZVd4Vk1pd2U4Mk5rMllLVGlNa1B1NGtjeWxOV1czaWs2?=
 =?utf-8?B?QlBsZUVNMFZOcU9FbU1WTWh4c1NCNkhBZVh1ZlRvdE9XV2FxRDFrSUJ3elRw?=
 =?utf-8?B?cjBST0NSaTZLaXJnUGYvSHFXWWdhVWdLbFV2REh5dndIdXdjZ0dMYWtBZ3NY?=
 =?utf-8?B?c3UyQm5pWVJUMU9aY3ZSMll5Qkhhc1JaQWNNb2M3N0NtUVZsU3IzNmxpNSt5?=
 =?utf-8?B?cnppV2ZDK1ZoMDl5WmtlNkJ0SmFQMWRvMjdHTzNiL0ROWExvN3NzNGFXNHZj?=
 =?utf-8?B?M09HT3BBWGd5NEhDVGRGbXZ5U0tTcEs1OEJ1QnI0NXp3MkFIT3V4YUpVWXI2?=
 =?utf-8?B?cUlKTzFBcGh3dWZXb1JMcXVySDh0WERFd1hyWkRoM2pMZGpEVldjNUJPSVNN?=
 =?utf-8?B?SXRLVkw4cXFmZGpxcVluaEgzUncrY0w4aDRzZXZNdVg2UzU3cUcwdXdTcnp0?=
 =?utf-8?B?R01PZjRManQ3YTR4TmRlWUt0MjBOQm1HNWlqNk4zYmlQUHB3eXltWUE1VVBn?=
 =?utf-8?B?Nk1uY2N4dmdxUTN2NDhzVFJEVVF0K2lUTVNKWS9jeUJhZmtvV0tIMEg3b0lL?=
 =?utf-8?B?bVQwdFc5Q0xhU0Rmb0h5Z09RYmlUenpjTndLTGlHZS9ydlNFUjZZc0NNbUFq?=
 =?utf-8?B?UmZacWkwMmkvMGlVUTk5ZW9yam5IL3BhbW5jK0hQRTdkTG43UWNjMER5L3dF?=
 =?utf-8?B?RUtENGxZaUlxc1E0MmMwd1MydS9VaGhZSVgzc1V0Ujc4cGU5WXdIR3VVWlIv?=
 =?utf-8?B?WHFnRkZFRjZNbU4vV20xdGhOd3B2WkdBWmlnVzNiYXF4Ylk0ZUx5T1RBRUcz?=
 =?utf-8?B?d2dERXhDYTM4TWorU09oSmFQVWt4bW5GOEtYclA5WHlzMUFWcVhwYnljK2d0?=
 =?utf-8?B?T091dER2NGhRR0ZNYk9YWE93UktuVEJHRllneGw4aUY3NC9aemFORmM0WXJQ?=
 =?utf-8?B?cjFkWVBrZTlGU2o1eWc0cytMQ1ZTSWh4M2lrcEVrYm04YXBHNS9vQXhnNDkx?=
 =?utf-8?B?VGpJUFVXYm5XL0tubm9EYmZrcGRPUDMvaFVRcDgvNmpjMFA0azV6djhrVGta?=
 =?utf-8?B?eHVUTUZmSGFKT1I4SVEvVlNzSVpFcC91cU00TExhZ1hoK2N6LzdIK205UWVW?=
 =?utf-8?B?TndVdkdZQW9PekFHMlUzdVROaGY5Ylp6SlVYZ3VCSXZsY1Z6enR5dTN0dlNJ?=
 =?utf-8?B?QUtDWlV0N1hGcS83b003QkV0NHFxV0pnTGR5Mk0vM1o1bjN1M2dYODUwODg1?=
 =?utf-8?B?S0ZTZ0NDNEsydXhvVjdRczNWdGJuaHJiNDBpZ2xWR2NMYU5ONWY2d1hhRmpw?=
 =?utf-8?B?cG0rQjB2ck1NOVJTRWl0MVp3VjVtNzgrTk1RVWVFWE5VcU0wNXE3YW5MS3ZM?=
 =?utf-8?Q?LVDKvjaCrOZtOGe/jtJTXj5juBKytyi5xKdRu8K?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2778ccfa-33d1-4c3c-7b48-08d9881f304b
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 16:42:58.5936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h9+e+QSnNHzKSiDO7bp65uPojRukeC8T3zwxQGb34Z9B68j2QfWXOb8/vfLtpUFRsmeS5H+rdtKMLCrn7TARAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB3047
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/5/21 5:48 AM, Russell King (Oracle) wrote:
> On Mon, Oct 04, 2021 at 03:15:16PM -0400, Sean Anderson wrote:
>> This adds support for automatically attaching PCS devices when creating
>> a phylink. To do this, drivers must first register with
>> phylink_register_pcs. After that, new phylinks will attach the PCS
>> device specified by the "pcs" property.
>>
>> At the moment there is no support for specifying the interface used to
>> talk to the PCS. The MAC driver is expected to know how to talk to the
>> PCS. This is not a change, but it is perhaps an area for improvement.
>>
>> I believe this is mostly correct with regard to registering/
>> unregistering. However I am not too familiar with the guts of Linux's
>> device subsystem. It is possible (likely, even) that the current system
>> is insufficient to prevent removing PCS devices which are still in-use.
>> I would really appreciate any feedback, or suggestions of subsystems to
>> use as reference. In particular: do I need to manually create device
>> links? Should I instead add an entry to of_supplier_bindings? Do I need
>> a call to try_module_get?
>
> I think this is an area that needs to be thought about carefully.
> Things are not trivial here.
>
> The first mistake I see below is the use of device links. pl->dev is
> the "struct device" embedded within "struct net_device". This doesn't
> have a driver associated with it, and so using device links is likely
> ineffectual.

So what can the device in net_device be used for?

> Even with the right device, I think careful thought is needed - we have
> network drivers where one "struct device" contains multiple network
> interfaces. Should the removal of a PCS from one network interface take
> out all of them?

Well, it's more of the other way around. We need to prevent removing the
PCS while it is still in-use.

> Alternatively, could we instead use phylink to "unplug" the PCS and
> mark the link down - would that be a better approach than trying to
> use device links?

So here, I think the logic should be: allow phylink to "unplug" the PCS
only when the link is down.

--Sean
