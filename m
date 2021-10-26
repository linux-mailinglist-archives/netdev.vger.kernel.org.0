Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D831C43B875
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbhJZRoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:44:38 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:44419
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232024AbhJZRoi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 13:44:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WgLiUayu0uA5hyaQFdQZV5JkjUf+OnLNGAr6UfNldNtoid5T8z7KQ+0c78CaDVEWNWkfFmpIQ2R/srsaJpbxiQ2d47I1uSfVsdXk4mOMVAIPjfNX9+2Bz3SallSE52CshNGm9ep9CCf4HFcn3DNLQlIy26rEyadouBTEFDjiouDua1/wakFLrPv0+rAeWd6AtIxVGmNHDHOaBnfHEhoSFgVO20kG/A2Zsxrl+1SEaaZPnyh1/MsXS2cyHE9+LHgfKF2kU5lbjuwBgCl0EMtRVRd9JZJ2+2bjyf7twXX/Eo/kIAjROp28+uckZTmsNFAeZqjuEPlavqP2jMvcC8fROQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DK/I0MqQWAlG3SKHurqpIClUEG+G6dP6/qiM2DgN1gM=;
 b=mfAonkiHrXFVQ1M+SmRaPya0bzgBftOoaappxZXzNZ03cp8dyQCwUtLb+SMlhaw00WrquaWV4uRnaBRQ8RrZmZlGvoVIQShbe6ue1tRavo4FRc2yXjqPMhe9xbH0VJ0mkdwYuQz2pj30/xyfBapVr6ESiiR+OAK+KCOC4GOD1T60YNkJFMTp/HhythP+a5h1jcdT9HDIMguzuePFDxzdMe52vszNLCwQ61xzGyWVVOKJY2mfuoJGyWNjJD4qTd1P4jQIFDAkaIRnAYV68CfSjCn2qC93PVfPPKmnVOGB2lVW05XQ1K1FiVKtolAUK8bzx/wgmc2nGVdaD6W1yi3EcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DK/I0MqQWAlG3SKHurqpIClUEG+G6dP6/qiM2DgN1gM=;
 b=UNxEFCGME+EyuGsLJ2+A+1koiJZOFk7vMGGCMNPHIIfqGKIYOSxU6LYtNup/8KSpnbD5bS5Jy3/icUMkF6igFPYeWPbNX/J3DbGrMBR2Q51EHCp2BdD8Z6TyyF6g0FvaeirPuzorxDLymcZOk0tyHgfh2kqYn58pwrObkf46udY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB4859.eurprd03.prod.outlook.com (2603:10a6:10:33::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 17:42:12 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 17:42:12 +0000
Subject: Re: [PATCH] net: macb: Fix mdio child node detection
To:     Guenter Roeck <linux@roeck-us.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
References: <20211026173950.353636-1-linux@roeck-us.net>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <84fd2f86-7f94-dab9-184d-49e87cede579@seco.com>
Date:   Tue, 26 Oct 2021 13:42:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20211026173950.353636-1-linux@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:208:2d::40) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL0PR03CA0027.namprd03.prod.outlook.com (2603:10b6:208:2d::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13 via Frontend Transport; Tue, 26 Oct 2021 17:42:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d288f148-4f7b-4377-3968-08d998a7f147
X-MS-TrafficTypeDiagnostic: DB7PR03MB4859:
X-Microsoft-Antispam-PRVS: <DB7PR03MB485992A804EAB74A013C01E396849@DB7PR03MB4859.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g9lto7RrVca0vsbhXxBtEkl4YbmQ9HZsZ3lakK6jqM8wjs76Ua2fg+DOUD7UMTr3yKiBqrz+vEumWkBXLYiTSMaWi502ql4GUrQVDHP1KaLJ2nEBNlYNYz21aXGrPziCU9Ypz2mKxRbmpuChHL7A5t+OsbwHblVK+v8ncZhRYLtme/+1ldCD/u+BwNUfstP7e3gf64179D/zE1tN9JhG4w98CYniJcFtj8ek3FVwL29yz/q5153pDWycrvuioqaSFTOv3yNilYO6nyZDIdAoqFrSpgPWhVlMOycHMTHJuMEYs9zUlh+C1T7GbEWn2zkg1l7yk6DSnue0ZZXzLbFHFHM4Yx25OLfd1dWDsXCjUgMtSdrEBuJstlVkI72DiTEjj0RNm5/3G89ITxgtQHDL4A3AGDM3L50sTWg1V/gAoJZJawCL6prsxjMJUXMHoy9bQ5DUFyD3Qeu1eq8p/V7A8a2/NSh+LuGhd33CRC10nEZ97lVcNCN6/evqyFaB6/3nkn9WwNX180Bvyi4yHorBbL6M1ub1QGvDSmJyBu6XVcQ4F8ntrX0f8DZqXPXPFCAWyQmKG0QeCKWe40Fsqv6T+9grPrJ5zn9ISIkkcrzmGcYVv0QGmP8AAHgBkz56QXvi6/01qC/6Zm2QPzJSqA/v4Wlw4pqq5HR4XU/vOc1xljqEw57uj537cSVHGBPRWaAaZnHAiNRRSqeRbQIxtlpDiLmY/XHc58yiqJ2o9ddgUwaiNe1zvfbrXoizqXFcHA1VL50YbWBsOZwdihiIGYtXjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(8676002)(36756003)(26005)(83380400001)(54906003)(5660300002)(6666004)(86362001)(38350700002)(38100700002)(44832011)(4326008)(316002)(16576012)(66946007)(110136005)(2616005)(956004)(6486002)(31696002)(186003)(8936002)(53546011)(66556008)(508600001)(31686004)(2906002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ym56QTd6djIzRWJVdlY4Smt1eG05M2RFRGs5WFdZZUtrQUI2RHgzNnZhbnFD?=
 =?utf-8?B?emZibGw4ZzZybHdFK1VpSWVXaHJlaDhpa2t0RUNES1lYUWdMb1ZVYmJhemRT?=
 =?utf-8?B?UXhmbGZuRDBqOEVPeWVJNW5mTENpVGYxYzVpekEydVJiMmJZSFVSSnFVcms1?=
 =?utf-8?B?RUUwRGJ1eXFpWGdMaTgvU0I3ajViTWVEdXZjTmhlOFhMUHZhZXBuWXplaTlG?=
 =?utf-8?B?VSt5cE1DSnNaK1c5U2dXSnVRZXEyWmU4aUJLQW9oUmhkZFJoK3RrbFZGTGE0?=
 =?utf-8?B?Y09VeE9mQUV5T005RW91c0JJQ2JNRHVFZlBXblZGSWNoSjVidUF4RlV0dDkv?=
 =?utf-8?B?TGxvVlFLQk5WWjhGZHVTVllRN3hlcjBudzRxL2tRUklrOS82KzV2cVJHWnFt?=
 =?utf-8?B?cWMwWXhYeTVlVmZUSWEwZHg5dXluOVBtUUFHSkNHWlpmV01BUDdlZnY5cHhK?=
 =?utf-8?B?bmgrNjgxaG5ueUVVOUlVamo3dmdMYzZXTWJWMk4xUk1mNWcyRGlIZGJMb1dr?=
 =?utf-8?B?UEcxaU45d1cwSEp1TmRuR2o2cTdsVG8xdWJKUmNicVlXZVNpb2MwZE5WNmFn?=
 =?utf-8?B?NGpTMUtSRVJZNk5BM1ZoZWlpMFdUalpTMGMwamM1VmV5RnU1U2JUVTIrY3ZS?=
 =?utf-8?B?Ym1GNzNXdVA1QTJZYituY3UrUEFEVmRRbVlxSyswS01qZGp4R3BoZXVzcVg0?=
 =?utf-8?B?Wjg0TnJTV04raUNDWENNUWVPRWlXRGw0WmFrcGdpakVRblJSL3NTdnYvREM2?=
 =?utf-8?B?RVJ6cjZUUTM2RTZPRnBJMS9yU1VtMHZ1Z1lhS0pmOE9yejc5Y2xuWU5vWUly?=
 =?utf-8?B?MHFUM01EYzR4ZXdzaU85MEthZm9Tc1h0bVRGek1BeTJNY25lSjQ5RXlYWjd0?=
 =?utf-8?B?NHIzbmM0U25yUGVEbFRpU2hVTUY1eklhWFREaCsyTS9BbC9Ba21KRnMxK0VN?=
 =?utf-8?B?NDdKVzlrYnhmWGFKNitmVnIyQlVWS3VucThJdlVqT3ZzdFdnTmJVOTRzdDZi?=
 =?utf-8?B?bGpleFcvNHB4bWJhdk9mczd1QlpYb0xjVG5NMEFnNnBmcGV4K0Q1NHRKUkQ4?=
 =?utf-8?B?UHJaVWdja2plSTliTlcyRzRJNzFadHZCV1RYL1ZjUHNJdGpLcExmemUvbkVM?=
 =?utf-8?B?ZVZOc3hpZkx4YnVBWVk4MkFTZ1BLU1VVcDdpNGMrbEpEaG5wRGtSYkNHKzkr?=
 =?utf-8?B?VURwaUlPaTZZaFRjKy9sQUNxaUlWblVIUzd1ZDJ6YllTVWNhM0lqSUxMWEM1?=
 =?utf-8?B?T0d4WFR0NVgvSUQ4cEhGVXoza0J5NXJRZ1Z5WWtEYW9Pa0JVMzhEUk16RDgw?=
 =?utf-8?B?R1g2QklOeXZleWt1UzFwY2tZdlArNnFLbmtSNXNHMFhmKzdxMWZkWHVjUVZ2?=
 =?utf-8?B?Y0VFQWd2aXdTSWoxL1NGQ0ViL01YN0g5RURVejY2Y0ZPaEVzU0tWcHhORFgw?=
 =?utf-8?B?VlEvdjA3ZHNlWmpuLzk4WTdsdnBVcjdobEhDcVIveUd3YlRSTXNYVjdpRFBZ?=
 =?utf-8?B?NnlCR0x3MStLc3BrOG5KK2xPdkZkbXFHTXJTcUZ0TUdMYUNGbzhQU0JTNU1V?=
 =?utf-8?B?ZEtPU05oSVJUUFc2cU9JbmI4RHhRZUl6Q0x6NkFubnJuNGd6K3VlaWwxKzI4?=
 =?utf-8?B?Rkd2TDFid2JiU2hqUWNHMUhhcGdaWGFFUVdQdTZZSTNkNjBVZ0RPd0l0RDB3?=
 =?utf-8?B?RzM3ZnB3Y2djZURaTXI1TmlTbmFYUUV1TkkwakZhSkxndDdrRzdvR1kwM0V4?=
 =?utf-8?B?RTVVUFZaVVlJN2JWdHlIbGpuTGJhYWhrbGllUnd6TUs0NzdScEJ1aHRtVFk5?=
 =?utf-8?B?cGtiNmRiZTJjRnZyTnYzZHpHeFFDRldrcHR2elZYZUVCVG1MNXIyY2k3emVH?=
 =?utf-8?B?a2VCcm4wT1VPVzl5c2h3bDdWWkdzNkFVSUx0WEo0eVFRS0ZOOXhOU0xDMXRF?=
 =?utf-8?B?WTBIRHdPd1M2Yk8wTy9Ia0dRbkhYUXUyaHozNDIxZjBHS0xUVmQ0NWc3WnZh?=
 =?utf-8?B?S2EzSWRBYUhJK2tBc2ZDNVJja0w4cE9uYWl2b0U3RklOeXV5UitwU09CZnpk?=
 =?utf-8?B?bFczN1JTZldxTW1NNm9Kbi9saVltY3N1WU5VTC9LWjczWGdOVXVHVUhBV0N5?=
 =?utf-8?B?TmhoVHlEcXl1dDRmUDBrTzJaNG9sOVRUZWhEWWJoL1NiaDYxYno3eFhaMHF3?=
 =?utf-8?Q?DSnr0A5XZQ/bB/bJ8NxsvVk=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d288f148-4f7b-4377-3968-08d998a7f147
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 17:42:12.5412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1aBY93CDYVGtRwb4vfMEoc6XcSu9XLsN9VRyl/S8PfzMgpOq9O5E58Q/KFvcimyX3xeUtR3ph7quRc+u+1Hf2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4859
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/26/21 1:39 PM, Guenter Roeck wrote:
> Commit 4d98bb0d7ec2 ("net: macb: Use mdio child node for MDIO bus if it
> exists") added code to detect if a 'mdio' child node exists to the macb
> driver. Ths added code does, however, not actually check if the child node
> exists, but if the parent node exists. This results in errors such as
> 
> macb 10090000.ethernet eth0: Could not attach PHY (-19)
> 
> if there is no 'mdio' child node. Fix the code to actually check for
> the child node.
> 
> Fixes: 4d98bb0d7ec2 ("net: macb: Use mdio child node for MDIO bus if it exists")
> Cc: Sean Anderson <sean.anderson@seco.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>   drivers/net/ethernet/cadence/macb_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 309371abfe23..ffce528aa00e 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -901,7 +901,7 @@ static int macb_mdiobus_register(struct macb *bp)
>   	 * directly under the MAC node
>   	 */
>   	child = of_get_child_by_name(np, "mdio");
> -	if (np) {
> +	if (child) {
>   		int ret = of_mdiobus_register(bp->mii_bus, child);
>   
>   		of_node_put(child);
> 

Thanks for catching this.

Reviewed-by: Sean Anderson <sean.anderson@seco.com>
