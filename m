Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971284AA9BC
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 16:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355322AbiBEPvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 10:51:12 -0500
Received: from mail-dm6nam11on2057.outbound.protection.outlook.com ([40.107.223.57]:58650
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232649AbiBEPvM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Feb 2022 10:51:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/J6iW77ku2SIok2upkMlRpJcJS56lLtJWdhyMKLhOh+pZqwV2tqD+M1QxeG/hx6B7vltiFFGaUjLt5lGrlVBQlDb5uZc+nlg2ZBI1/NADM26PQ8+ZRY75zWISy9b3bv5Fi4AKrQajfp2FzW0faTHLIdNqkg/M09A25bulavBm6KtpOzKScQPb+c8zGWiEq/IEoy97gDIm8yCMv39kW3eGQTcgBefDmcH/9ZC14IwhT19gIV4UcgSYoQkZMMxeWMBuJ4/QKmUoooMPOCRxZUZpH+aRtFax9f/1h8xvZ10wQjYSZmziLb25p8QYNxe4qaRAdAGgW6TqoFkECwolCdTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j6XIFx181Ifl2aoC077aNI5vN08rAQoSEYspbu+SQkc=;
 b=Tmn3IBvJgbECSzJE0x87Ex4IbjmiugPlZ5j/vy0TkWkR4jsmLepihX/rYXgSFBJTJPKqwrABkY9UzV5rYnax74S69YQSlnfNeougV7mIDxN3clAqybah1cYYhv+J8lFQ1TuhU+ZGhmRUwfgQCMFKqD0Jo6rAdzCG4weOkuZ36tjGF4VS0UNv8in5SoIC67Ld1rKit/Oa/JvcEX61VI14wAYmdmeAnVolLukwIBh+Xm38Ox3dTuCfOHDWIwHkl3Mrz5X6B8pWK0HWLZQ6WDUrkaijYMlk6Qbop1bUmRq+WyZjXOridjxTQzpuaJsYqw5DPVENqBrbWduaZr3edD9+Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6XIFx181Ifl2aoC077aNI5vN08rAQoSEYspbu+SQkc=;
 b=zf6awzAKb6MQ4/XtMjme2qzaHIr/CFlfCnoSatkmGuvOopxeXsnVkqPutbeNmJSrkMe7ZUYIUfkCt01HU8DXXDP6yXUZL9I+CK3m8qaLzDCgSOOsxvzF4QmFypEF/7JIUCczzP66ILbm2zwNfu3Su+J8ajoHQHQq6qzkfR7+FA4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BY5PR12MB4132.namprd12.prod.outlook.com (2603:10b6:a03:209::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Sat, 5 Feb
 2022 15:51:04 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccd7:e520:c726:d0b]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccd7:e520:c726:d0b%7]) with mapi id 15.20.4951.017; Sat, 5 Feb 2022
 15:51:03 +0000
Message-ID: <c3e8cbdc-d3f9-d258-fcb6-761a5c6c89ed@amd.com>
Date:   Sat, 5 Feb 2022 09:51:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: AMD XGBE "phy irq request failed" kernel v5.17-rc2 on V1500B
 based board
Content-Language: en-US
To:     Thomas Kupper <thomas@kupper.org>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     netdev@vger.kernel.org
References: <45b7130e-0f39-cb54-f6a8-3ea2f602d65e@kupper.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <45b7130e-0f39-cb54-f6a8-3ea2f602d65e@kupper.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR08CA0009.namprd08.prod.outlook.com
 (2603:10b6:805:66::22) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11cef8ac-0db6-49e1-14c3-08d9e8bf500f
X-MS-TrafficTypeDiagnostic: BY5PR12MB4132:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB413280322FAC2C6364542BBEEC2A9@BY5PR12MB4132.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F/nqj0eM8uap7dUbLtvBHl7jPx3pexTMZZajuMAf5qGllj3jsJbNEWEzUCX9A5Z+aUoBvgrenvPMEj1dSILKK52lEABxL6NvQSathiStRpCYBQzuYUpVen481XaEv4gUuIydD/0wA9FPKs4kFx0/Imf7JledCTaB7RhEf4WyEq0GZVHoTGxhw/e8K1sKFGelOB7C9id0zEliBqy4cLvulyXvpfRy3TwTiKZLAYxmaflIO7nBeuAZiCW+pGT7JvBw5d0be/IxLbas3mTvt+hxiOJiH7/Z1YZlO3T62he6DtdZW6ZhSy2bCds1nFOK9cNcndL5B0wWPfJ0i5D/QnWqzumAsypsHq9U3T8HRrzqNxgLef7PwrYJvl2N23vk9fnazkhRMD6yKrL3zwF4vMNi5ctq6F5Io3t8Uybn5aePQGvOlvyupYTrU8HqmfoUEKh827qpYAOFGSo20absmqAiD/KAXwI5vbyE6QXd/r65ftWce/+mIeXTcTEDF1mnwVIJX5uTUxSvqsxkS5+TnH2MHuT26kPpUE3zdaOKnHHF0LKzHO7y1E/d5IjEra/exHWfI+YkS9DTqLa9vqYhV9o4NgJuBfTO90HoKhzFFpTJv5S/COOF2794XIdhShuxORPndbyfDH8HB9syTPyUh7Im5Sznqy2SdQHbxuov5jPfEeu9250/dN9IRBa/01Z0fZH7iPFt4w28ihgQsj0coDJXIDWG2i+nSyAlXUJ73xwG56k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6486002)(31696002)(31686004)(53546011)(38100700002)(5660300002)(26005)(6512007)(2616005)(186003)(8936002)(8676002)(36756003)(110136005)(4326008)(66476007)(66556008)(66946007)(6506007)(316002)(6636002)(83380400001)(2906002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnQrdCs0Qzd1a2VPd2tSQU5HNVQva0dQdXk1UUM1MUlQWjdwWGFndHlyMStU?=
 =?utf-8?B?UGh0R09pRC9TanFOWUxXOUZIbUVOaFBDamRQSHJVaTJrRmpQSjlHTHpTcDlk?=
 =?utf-8?B?SFFxRVBYRkg4Q0dQSFRkTkZUb3hJWWRhVDNBUDZML0dTZVdIRm1ydlh5WXF6?=
 =?utf-8?B?RG4vS2I0K2lqbXBOVzlHUWszdjQ2Rk1VN2pLSWpmZk0wdC9USndEVk0veUQv?=
 =?utf-8?B?VjFsbG9TQ2xDUzRzbnlZeWd4dWJEbVcyaXNWdjV2cERmSTNNZ2E1eWh6WXR6?=
 =?utf-8?B?aTVUSG4rQ0J2MEMyRWs0WG4vVTNKQXpKdkxVaExYZ21BeC9IQUJ4MmRKVXY5?=
 =?utf-8?B?SGM1QUJDZHpZVkdyOW5IL3RLd3ZnUU8rZkVuRUQ3VnRYWHpDSFNwZFBIU2Zo?=
 =?utf-8?B?S05Bd2dReVljeUw4c3R4RDBoQWlQcCthVEQzcFQ5WGM2Sk1jZCtRNXBEdnpa?=
 =?utf-8?B?elo3MjFwbTdHUTBLLytaaUkwTzhqMkd5aWZkWm8yWDQvbVpkMkxkMm9tY0Vo?=
 =?utf-8?B?VE5wKzlwNHFTL3o2S1k5dkFyWWlHVmFJZndOTW9aTnd3aGlnR3JuN2k3Lzcw?=
 =?utf-8?B?Mmp4YVlZQ0Y0OFVpek5aRkEyc2NFTFRuU0t0c0ZJZ2Z3eTk2QVNBUnY0dlBr?=
 =?utf-8?B?a0pUVXd3UC9JVGhhNjJYd3huY3pCL1ZTcGs2UVNJTlBLT1FFZEF0WXpvR0I2?=
 =?utf-8?B?a2tIMWNBS0ptTG5Qcmc0Ni9iRGFlSXRscXFSUUVxWWJHQlQrTjluYS9OYjls?=
 =?utf-8?B?TzNMb1daejdqU3VlRjBWVHFnMWE5eVBLLzFnWEVtMG95cW5FWXZaVjEvYVYw?=
 =?utf-8?B?bUs5L0MrTWoxQVJQclhUVnVYajRJODc4TFFMN3JuRU5PQk5OV1lOSUFoM1Jj?=
 =?utf-8?B?OWpOOGRna2V0ZmFjMVZ6WjJIcUZqVyttMGFHZUFHQldmSGVwRmMvTE9NWExS?=
 =?utf-8?B?V1dLZ0VlNVJxUGtVRm5PRW56SEIzT05kTVgrMktqQnBrOXRGbHhvdUtiMVla?=
 =?utf-8?B?Slg5QlBtTmdBUDhLVExtUFptYi9ia3RTc2RaVVdkaUYzTHkxQUVvOTYxNGZG?=
 =?utf-8?B?dGR6Q2FCQnBpc0gyZFUxUE1uQlk3MGp4bE5UeTJnRjFra1orOXRzQ1J6ZlhY?=
 =?utf-8?B?bXY1eXQzV0wzTDNJaUVodS9uL3J4VDZveldFUGJjbVc4eWY3R1lHZkpLWUpO?=
 =?utf-8?B?R2tXT2JObTlaV0hFdzJ6TWFLSGdVcUI2NUxadU9tK3I1SEs4TVhNdzl3N2Js?=
 =?utf-8?B?TnhTRm0ya2d0MElLOEthdVlMT0NKSksrSUNTbzlFWTd2UWwyMWlSV3RLQkYx?=
 =?utf-8?B?YWNDTExwcDZoYi9tVlZCQjJWREkvbDVBZ2lPMC9WTXdjSEZLYnV5TUdqWXps?=
 =?utf-8?B?Sm8rYmp6Q0ZGY2M4QWRJSXU5WkZqd1V0anp2R3M5Z1NVbGdtS2RaRFM4ZXN1?=
 =?utf-8?B?U3FCekp1Y2xQYU5WVzk2d2Z2OGtGcFhBRnpSYXA1ZDZkS1FSWGZId255NExG?=
 =?utf-8?B?aFpySWFxekNzY0oxRU5vVmY0WWlpYlg4bDJXaEJVM2ZuNldVZGpsclVKNlZG?=
 =?utf-8?B?dG9LRWpSWnpZRTYvMUlyK281bVB6YUUvNlkwYUVPRFppVDcwNVh2WXVKK2V3?=
 =?utf-8?B?a3FXcGpjdDNxcDlRaWQ5b1U2RW5LMk5tZC9QSTljZ3kxMVNYcXYwdTBuRGJr?=
 =?utf-8?B?K05VeFJ2dW1kZTV5ckswRjN1VnIyQ0JCUHBlWHhXa01xSFg4YkgvSFp3bnVF?=
 =?utf-8?B?bXB6Mlc5dzFJV1dUUWxqQmNJWnh6enFRNHJScnVHRlYzMFZkYmRyOWRTK1lS?=
 =?utf-8?B?Q3doL1lPbyt0cnN4ZG9NeFd3S0YyaVp2TEh6LzFyNkRKcWNRQUMzaDk3NU03?=
 =?utf-8?B?S1lNVStOL1NpU3IwbzF0VXlISE1mNVZ6MnRwSXhTTFJhR0hDcDNJc3FTNlpK?=
 =?utf-8?B?Q05vbks0M0xnbmJ5R25XWlhuYXBmTHNhRWtBekZtaVd1a0Nwenp5R0dhenp3?=
 =?utf-8?B?VEpTcGhpMmgyYWtPQ293aktFekZDZUt2K3c5SjZFTDY2eWJUS2p3NUVEOXcx?=
 =?utf-8?B?YXRDSVVTVEJjOWpGcno4cWxWZE5UT2VUNkdJWE1YOUpLWmpvRnhVNHZwSkta?=
 =?utf-8?B?M1lXYU5mWUNCN3VIR1ViTHVGdjhXMmlsaTZ1b2huaTVZTmpsT1JxMXNQTFB2?=
 =?utf-8?Q?iCANtElnOEGEkgDFv4ZTA7g=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11cef8ac-0db6-49e1-14c3-08d9e8bf500f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2022 15:51:03.2479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bGv5UrDguLva3cHJqfUNTG106YgoFEW8/anMgtuJFcd0NiqALaOv0mot4+bAFxvmc1VVzN2a3tGjSsFYVnDZUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4132
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/5/22 04:06, Thomas Kupper wrote:
> Hi,
> 
> I got an OPNsense DEC740 firewall which is based on the AMD V1500B CPU.
> 
> OPNsense runs fine on it but on Linux I'm not able to get the 10GbE 
> interfaces to work.
> 
> My test setup is based on Ubuntu 21.10 Impish Indri with a v5.17-rc2 
> kernel compiled from Mr Torvalds sources, tag v5.17-rc2. The second 10GbE 
> interface (enp6s0f2) is set to receive the IP by DHCPv4.
> 
> The relevant dmesg entries after boot are:
> 
> [    4.763712] libphy: amd-xgbe-mii: probed
> [    4.782850] amd-xgbe 0000:06:00.1 eth0: net device enabled
> [    4.800625] libphy: amd-xgbe-mii: probed
> [    4.803192] amd-xgbe 0000:06:00.2 eth1: net device enabled
> [    4.841151] amd-xgbe 0000:06:00.1 enp6s0f1: renamed from eth0
> [    5.116617] amd-xgbe 0000:06:00.2 enp6s0f2: renamed from eth1
> 
> After that I see a link up on the switch for enp6s0f2 and the switch 
> reports 10G link speed.
> 
> ethtool reports:
> 
> $ sudo ethtool enp6s0f2
> Settings for enp6s0f2:
>          Supported ports: [ FIBRE ]
>          Supported link modes:   Not reported
>          Supported pause frame use: No
>          Supports auto-negotiation: No
>          Supported FEC modes: Not reported
>          Advertised link modes:  Not reported
>          Advertised pause frame use: No
>          Advertised auto-negotiation: No
>          Advertised FEC modes: Not reported
>          Speed: Unknown!
>          Duplex: Unknown! (255)
>          Auto-negotiation: off
>          Port: None
>          PHYAD: 0
>          Transceiver: internal
>          Current message level: 0x00000034 (52)
>                                 link ifdown ifup
>          Link detected: no
> 
> 
> Manually assigning an IP and pull the interface up and I end up with:
> 
> $ sudo ifconfig enp6s0f2 up
> 
> SIOCSIFFLAGS: Device or resource busy
> 
> ... and dmesg reports:
> 
> [  648.038655] genirq: Flags mismatch irq 59. 00000000 (enp6s0f2-pcs) vs. 
> 00000000 (enp6s0f2-pcs)
> [  648.048303] amd-xgbe 0000:06:00.2 enp6s0f2: phy irq request failed
> 
> After that the lights are out on the switch for that port and it reports 
> 'no link'
> 
> Would that be an known issue or is that configuration simply not yet 
> supported?
> 

Reloading the module and specify the dyndbg option to get some additional 
debug output.

I'm adding Shyam to the thread, too, as I'm not familiar with the 
configuration for this chip.

Thanks,
Tom

> 
> Kind Regards
> 
> Thomas Kupper
> 
