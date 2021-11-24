Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112A045B837
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 11:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241143AbhKXKV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 05:21:58 -0500
Received: from mail-mw2nam12on2071.outbound.protection.outlook.com ([40.107.244.71]:29824
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240105AbhKXKV6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 05:21:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=da+fHjAr0qRwarlpaS9sNGntfahjfDiBvOIxSpQGpJ/rUzuIYMTL8nVspQ5e6m41ZrrbqPS7p11A1k2MNrUywwfG53lJSp08mfjjtF6QKEtoz4dODH+WUOe4fh1QwNKwS1Edsr2tVj7fgyt9uKr32PMolfvRN802t4ThoO3S0wEkwW8CfjVIavG8oszYpmrzoVdZ4B9vwWYWZ/ePAWkDBWmdZ+5oQgFwGx4IdLmV11+RBao+gPYyo7pIfbHfPfcKwsKDrXcVvFd+yAYL7bGJ/dvPAmLRmVzzo7/alZ49aqs5ZAds5yNGzlOOUPQRKIt5/yKUgeGs3ZixnbXYUyjaNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hMkGBr0bXbLoc0r4al3bxzXWiBdclmaz3s2+8RyY/3M=;
 b=MUaCtT0VtnZZRGTfJ1OBJJZP2CoI748l4JrCUpB+474m3egAx/ZDvn57OxKcFV1mh2hFCFimfedylQY9gyGEA3xWCvXJZUxU+SYbzFCv04XUI8xtQr3Mm5UDSsI1ab727yvPywhzxwxpT9AiTamiGG4sB2XR9wwEUUzywH0S6/pHSfTgtChdaK4NxNrmql+ZxxPLokEbbf191o8Rcx0vRr45j36hPPI4m8n6MhfDVeXUYxXj4G7OmWqgX/2NY3OgsjAZhJbtrb7Z2GrVN+kHYtkHJY0i7IqIQ5fOc+i0mR1nAw1Kv0f6htR2+NLCVKx6LXEqGy3cT6xgZxB5mtWuwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMkGBr0bXbLoc0r4al3bxzXWiBdclmaz3s2+8RyY/3M=;
 b=JbZsE4d9qhPR12OAkq4xoB+MCP4YAPy2Yq6rzoftX5OaMfDGwvHeDJAnUL1u/T+SlDQqhhxnxScYnhaSLmHZfQp4YQXxgyfwKI3gGpalmL2ktflE+zOOakS/W+fRNOUW61Q162H4WTl0bM7FdZHGDEfo6J483APyhVSbVhWV8GNN/eTRi92dHqNayxxaceXRe7CKoIlP3f1AcXU7gkdcDQ5qDWgzO4xt6LVQlMyo2JZqr1FjH6c5kmjLXCUkpEZYKgw3cddXcavVfhwxf6YI5xRGhgCU2fnvdVzZcM2Su8oy1qetLEXzsXZZUOt3WQibYXZ+Jm6Q5w6Tyjf8UlnCSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5311.namprd12.prod.outlook.com (2603:10b6:5:39f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Wed, 24 Nov
 2021 10:18:46 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%9]) with mapi id 15.20.4713.025; Wed, 24 Nov 2021
 10:18:46 +0000
Message-ID: <1db3aae2-2b68-a18e-2ea7-3b193612125f@nvidia.com>
Date:   Wed, 24 Nov 2021 12:18:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] net/bridge: replace simple_strtoul to kstrtol
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Bernard Zhao <bernard@vivo.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211119020642.108397-1-bernard@vivo.com>
 <YZtrM3Ukz7rKfNLN@shredder> <f98615d9-a129-d0b0-e444-cb649c14d7ce@nvidia.com>
 <20211123201327.3689203b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211123201327.3689203b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0066.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::17) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.23] (213.179.129.39) by ZR0P278CA0066.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21 via Frontend Transport; Wed, 24 Nov 2021 10:18:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34b4eaef-2522-4b36-b131-08d9af33cc92
X-MS-TrafficTypeDiagnostic: DM4PR12MB5311:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5311E1C5D857029E6AFCAA15DF619@DM4PR12MB5311.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GGhCqx26/eKtx7CJWc3iLfhKAvQJUm0TE2TXkEEg4ZUL1jD0eLVvteEQeUDSKk4y4xBcYn4hghihQoZA+tfun/z9Mz+Gg/J2k6om/G4Y1Six5wvI7rnqIS3Zn9HvF9QKAaoa04khBm1qCRVwJixVWew4qp+bGCqksrzB/lQmOG6t57o+bONBESLcbq1dkePcVrSNuyLaJDKEKb0EhUDczSF8qkiCfMo3qP7x+G9LR94jodePBy925+8NJGtbWtPmFX7rx+Rr/FeOjYIpU1oXXVt/aPTeUNP2vvRp+QwJoGFtXmHZf34M+Pv0FVaPRkHmA4jbC/oG6yVAjbuelssKfx1rRfnucKoQH9NcqxgTUNWXlvdtDoPdiFfsmaSqK9V6rmmpURDadWtpbbRr6Rtd/eveOZJHmqAM7IfDT0HPga3GWM0kQaVN/y+2GEjLoJCruY4DmMgGWwfzZUNBFZ0QhrHFVz79MaTEeH/CcBP8Hc6OzJ8T1RBS+pMHyNc/WmbiAghGwsvyU/yeuY1mb0962CdkfUmErBxHK+xPisQ5L056lgV7ASGoVJcHacHBdC3bd8egfcaW11N1JJr3E+aBmYVQYh6B7IoNQ7RMYUOLSKX9ERUgK+aRL4mWoGfGDZdyIfjuy3s7L4tyCrIGtVpbOtwg/0qa7uGnyNtVLcZVpbwR0hDI6kVvft1v9sc8mmQvwrf9mcX7vbrgpsDLirnBfVeoewBK9dCoxvHZ9ZHsT2YQ2sfQOec24yAoOuywKzmIBtSqDgT7HE/q3H1mr2BWW0ApTc4dXPJyrfqCdI5lVpDEIepaZ1RgJFQxjSGkPoO6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(6916009)(8676002)(2906002)(4744005)(508600001)(54906003)(86362001)(16576012)(316002)(66946007)(956004)(2616005)(26005)(36756003)(31696002)(6666004)(5660300002)(38100700002)(31686004)(66476007)(66556008)(6486002)(53546011)(186003)(8936002)(966005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWpUTWRiUUI2N1JDbDlCMjIwbHdaUDIrK2hJNWJPWjlUODZBaXhuUXpwMGky?=
 =?utf-8?B?emhXVlF5Zzk0SUJ5RHNiWGlaU1Y1V1JKWGlrOFAxbG54c3N4T1VsTGJsVEwr?=
 =?utf-8?B?NmdqR05zdXVWblJTSmtWYm5yRDJuZ21KL3dxS2UvRVpxVTJnYld5TFJmcFZ4?=
 =?utf-8?B?Qm9EL2F3aEFUbWZwU3lpZUpSMGpmdy9Hd3ZuY2E5S1VMN0hUQ0hJZC9zK0tl?=
 =?utf-8?B?bzhKb1ZnREJNb3NTMW5LT1cyREgyQjhDR3VUZm5FY3JlMFdyRVFNeHJlbFlr?=
 =?utf-8?B?RHExY3VkaUdPVzUwU0s5NzBuMUtVWndMbTZZaFFSSzF5a09OblJud2tCTGRF?=
 =?utf-8?B?QXhFc1puRG9xQnlFZnJzdVRNQ25UVU1rMGtOWGR3SXc4WE5ZQVk4MjdBalRN?=
 =?utf-8?B?Z1UvdjRtUmN0WldBMFRvM1luMXR5WEVLQVNWblJYYzZDbDJEUi9zUjU4UnQ4?=
 =?utf-8?B?MjhkRU52M0Yxd1dCL1NwY2EzQmNsbUR1aWYvMEl1SWpGdlpCK2o2SFdiMlhM?=
 =?utf-8?B?dzlIdzRxRS9kS1JCK1NXSTJ6V2NGTVpXY3hJSUQxdnNrWW9vdmZvR2JLdSsx?=
 =?utf-8?B?VW1tVXR4RDhSMnhDcWExSURYbllzaFM1TTVyTWhBRTlZbUNLTy9iWWovSjBt?=
 =?utf-8?B?ZFNDK0pBeXU2MWpNUGF4QzltczlJaW5JU3Q5SW9pN2VyQ0FxeDgvc2RGM1Bw?=
 =?utf-8?B?Qm9QMlo2bEFjWGtyZ05kd242UmwrWTQrS0R5MmkwOTdqS3NNNG1tNG1zNlJk?=
 =?utf-8?B?TGpaT0xVK2ZCZDdMc05FR1VTdml0M3VMZGRYbTFaeFdtUVpDMHRQdmcwajRy?=
 =?utf-8?B?SzNpOFBuaU02d0Y4WGpFQUZXYTJ6OGw1QWdHb2I4UXJ2aXBveThlSmhyM1NQ?=
 =?utf-8?B?WENCZ3pwNU53Wm44aE5Iek1yZUFERFViVWl5YkZiVWRBTHZrL1RwVldmMXdl?=
 =?utf-8?B?a2N4Qk1SeVJ2aFdDbm92cTN0dGRqL1ozY3c5U1paQ1BjajFEb0xrWjlGdHF1?=
 =?utf-8?B?L2FFd05ydjRoVnFRUWFUTE1yNTU3Z2ZTdnVEYkZoazd5N0RTbEJHSjRZMTJK?=
 =?utf-8?B?eUsxRmozZWpwV0g2UW9lS1VXNkFtbjhUTXdlZStJM1p6UGJxU25Hb0VjQ1Z2?=
 =?utf-8?B?MXI5c1lwaGkvSGh3RVdSNFpoK3VtUXl3bVM3bG5KMmxPT0hlMmtkRUo0TTFR?=
 =?utf-8?B?VHRzK2VvQTMybXNyYkEwVFNvQzhSdHdWSi9GdFJabjVOdE5DcjB6bER2Nkhn?=
 =?utf-8?B?bTZuSkVLSEQrN25xY1FnUkF0bUhCbDRNMGZWS2VMd1VXK1hqQ0Z2NVVJdkFv?=
 =?utf-8?B?YXN4QllpKzRQMlNjeCt4NUdKWlhqMlQwbjNMQnFHczgraExzaTgvcW9HN29M?=
 =?utf-8?B?VzBQTExrYmRPZXpaVDYyRkhWLzg2L1hONDhpQnJjUm5mNm96SUlnbE1KRExq?=
 =?utf-8?B?ekdrNEtnWitLbnVHYTFldzU4RklLM0VpWnZ0WHdscmtYZy9KRTl6UUlpeVNi?=
 =?utf-8?B?dU53dGxvaC9COWh1MDhjVGloYkEvcVovc2VicnRXNFFxenVRMWJzSTFkbFI2?=
 =?utf-8?B?UjB4S3FtSlA3a1ZnNW9hRFhZQmt5Q2RQUEowVTNLQ2Fwc01JK2g2QU1hSGJk?=
 =?utf-8?B?K3NOMEZVUlFIemRwWlNJMzFkMmlaTmpYQXdsUFlWVDBLRFhhSkg4dThrS29j?=
 =?utf-8?B?Tm83OC9EMVlNeEllV01pRktIbVVMaVBGNVZmRzFBajRRSlduYmZ2UnRGSnZo?=
 =?utf-8?B?NzFYSGNRM3Zub3IvdERIVG10T2hmUmZPQkV5a1AxODN0NGJYSjFQK3hKNWtH?=
 =?utf-8?B?a2JXWFZXK3hFRDVtdE9jZ3ZZbEhIZU9ZRGRtS1ZPdTdWZFF0dmhyeUFzYmFY?=
 =?utf-8?B?SUkwNVNKSlJhZ0JhMWxzVUpZUVhaeWduWklkMWxqd3I4ZlMrdGY3WUNvcnlv?=
 =?utf-8?B?L1BxRzR5dlk0czJnMmRpaUVKWTUwcVAyL2FHWVBrd29kUFI1NHZ6Q0thdHpn?=
 =?utf-8?B?OTgyMkl2TGFRZk9ydTY4a0NzK0o3ODNkYXRhYlRIZis2OW5mWlREZi9MZG5F?=
 =?utf-8?B?eGs4YzdTbWtWTzl6L3ZSblFicFJKN3N2dG04WldyQ2hMaG9ndGdHcHVFdnl2?=
 =?utf-8?B?NjFHMXVDeGNZMk1Tb1VBR1BMQkNrZ0lMQndNcVVLaGVIbk1pLzNxSmZBb0xm?=
 =?utf-8?Q?KBQoRlnFa4b1keecKFQAlLw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34b4eaef-2522-4b36-b131-08d9af33cc92
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 10:18:46.3976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CHzAFpAqVzYnWgekpVmr4HVlyobdvgFN9ICry14QkthX1g7kEE3+VRaptTob4fvhim0itb8bWgkw87ZdhO0Wyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5311
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/11/2021 06:13, Jakub Kicinski wrote:
> On Mon, 22 Nov 2021 12:17:39 +0200 Nikolay Aleksandrov wrote:
>>> # ip link add name br0 type bridge vlan_filtering 1
>>> # echo "0x88a8" > /sys/class/net/br0/bridge/vlan_protocol 
>>> bash: echo: write error: Invalid argument
>>
>> Good catch, Bernard please send a revert. Thanks.
> 
> Doesn't look like he did, would you mind taking over?
> 

Ido sent a patch to take care of it:
https://patchwork.kernel.org/project/netdevbpf/patch/20211124101122.3321496-1-idosch@idosch.org/

Cheers,
 Nik


