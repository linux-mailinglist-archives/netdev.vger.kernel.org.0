Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805FF46A186
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244230AbhLFQkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:40:53 -0500
Received: from mail-mw2nam10on2049.outbound.protection.outlook.com ([40.107.94.49]:14528
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1356724AbhLFQkA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 11:40:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKc91d6jJ+xuKW1Ye4XIuwwDNX4fFjjCMyOWP6aZPdsQSRNZ9Cf99DQt84D8Fkm36XCoLp6Umc7Xt3bLW5kviCsDBpkMBmPq/w+RVu/qMiVNnyJQlHYr6kPRhD0W94Qy6PoMHWZ+D6ffNpHy4CsxIH5PKfbwJu4tZdf2hkM0ku+i5bUou0pcWoZOJC0YithKVcoJ9nN7rqlefArqCFvsqqw70DdldoYHIijdqfRup9XtyrzfFPPlPcvs6zEsP/CndGr6QoIsSfo4JBC8nUV753V60Ps9Z/nCqPQ6kWeajLQKGa104EDr9/C7D9EsyLr5rKrL2KyFqwQj+9ZLv806gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7cSRtor83BkuSypovumT7pfLlKFxMMhx9Vb+jRSBfW8=;
 b=eNp/7vbThif0Pox8JC73VG3GeC1Swg2/ymK4eexF3oO9Tj6uvQyJbicCheNxjrZQBcVOIxgw/lP+SxUyW+H4Xypd6FBoFGFAfgJC5P0I/HB5UGTdv/WqXiWmDH56WpTcmP3I0PpABnF8CwO8ICjrSxp1r+D7l5HpXWc+A5YZ+NVQOeqvi+1nLA8cNQ71Yz+Wunbq9zU0kdfz59+3yO/V15KerVfY+8TMbb+srSXl+oWWWu3IWJG8XWLW4SOO2gsd1mR+3fHxiGte+yC3mcVlHb1X1HWmlPhVXHlW5NJjPYhhqrklXoZzKVi70t7BuiTZxB/uXgv9mZeaclATUsazZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cSRtor83BkuSypovumT7pfLlKFxMMhx9Vb+jRSBfW8=;
 b=tHeI41QRlofaFjgJNwpJDcKzC4GjnWWrvHsvhkpVqxUiTbOb0pZ63B0PUTFqH+qlK05GiWXwGYXGJ+olnGCegXWeGQ9i7uGTZXSH9U4lDHcVN0YW6EAgbx9KbBVccXsfZUHbO+7iMNAEtipRWkVkp1lURcLUqGmWhbVQJeRqOHk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5375.namprd12.prod.outlook.com (2603:10b6:5:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.15; Mon, 6 Dec
 2021 16:36:29 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Mon, 6 Dec 2021
 16:36:29 +0000
Subject: Re: [PATCH RFC net-next 05/12] net: dsa: bcm_sf2: convert to
 phylink_generic_validate()
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRs-00D8LK-N3@rmk-PC.armlinux.org.uk>
 <6ef4f764-cd91-91bd-e921-407e9d198179@gmail.com>
 <3b3fed98-0c82-99e9-dc72-09fe01c2bcf3@gmail.com>
 <Yast4PrQGGLxDrCy@shell.armlinux.org.uk>
 <YauArR7bd6Xh4ISt@shell.armlinux.org.uk>
 <24f210a9-54c9-eb0b-af88-a7ad75ce26aa@amd.com>
 <Ya42sBObkK60mhUo@shell.armlinux.org.uk>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <e2b510b2-5eff-c606-8842-45bc1db2de17@amd.com>
Date:   Mon, 6 Dec 2021 10:36:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <Ya42sBObkK60mhUo@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR07CA0004.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::14) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by MN2PR07CA0004.namprd07.prod.outlook.com (2603:10b6:208:1a0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend Transport; Mon, 6 Dec 2021 16:36:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f570f1a2-47e6-4ebf-f710-08d9b8d68d5b
X-MS-TrafficTypeDiagnostic: DM4PR12MB5375:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5375CE6242335ED5D8A2E423EC6D9@DM4PR12MB5375.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5jfoY1KTyUrl/M6nSpsmIDjFSAGwAL3FjdSnSUHJpeoPh3RiVwFh4OuF0hNzMXjysccms+As9TmjO1340VWsrXwm/ZYJkqf6rfy4rp0UcU0/7bBmxKl5mQZgrm6kf8LrRv5To6sVWB9y1aen+4GywfQeCEUCwa41e2UFu4n1bnzcdlJrc+WD8g36kG4a6C7/9/zD33Ut86HtYwmL4kni79r6LjwyXIqDrPXt8YzyoyM7ueZ0fb6jOBHy+ZF0pJcv3LjM4W/k6wzGPFMhaf52w12M+zJdFmOa/gLIyCUB0h9tfUjqxsdT6rSA1w0wpYc8Z6IstLXoFjxsZMK2e50KNdaYHIrm+muIADKZv/BiwaTWxs/TMq+vS3nXxktWs8v/xGjsj6QYKLDtFPxmUCOXESlz/OXwWustw99gUWN6gw4kFpdMQ0CIG1PQB9OD5CRkHrRQ4tMyBQhbumg0DxuIpNQ9zw4Y0CKhlwsMselMWsVJ4cKfbMq76e75w8LHj/xSAEnSiOSTTzpsqpF9xh/A9WVCPrtS6aDJeGxY+PVmLh3BCn2BXsVSOSoWGy+teyLyavu1xcjHUcsfHkHS4M3S01pHp+IdJq6FIWnyxdiYnbghYF6PJHCfnJSLXeQs2mGd6uUrrc7hnPiBhKM53MYKKHBsWhc0sq/H8rBZNZ/lOC6SxkVY4R8x3SJ/KZ9yq+xdnjGEQwjSxnP+CAIh3TwQY11NOkBqT5z7JhMcJxGK9u6oY1Yb5Zg96+sO73B+F+Vl3a3DT9nCxcaReTjBeq2whg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(508600001)(8676002)(956004)(186003)(2906002)(31686004)(38100700002)(26005)(4326008)(4744005)(6916009)(86362001)(31696002)(2616005)(16576012)(316002)(54906003)(66476007)(66556008)(5660300002)(7416002)(53546011)(36756003)(6486002)(66946007)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTZsRzg2SWtxY2NzSGlFTzIwQkIrTmV2Mkl5ZzA0dDRYc3VWWUZSM1JmWVln?=
 =?utf-8?B?NlRuMzlRejZwa0ZIRGNOZEJnM1NwcU5Od21ObWhOK3NhVURkNWwyYkg1V2t2?=
 =?utf-8?B?NkNZbjlVTkh1a2FNcmsvYzdNSjVLUkxZbGo1YnFqWVF3czdqNFV3MFR5VnN5?=
 =?utf-8?B?RmMvb3M5a1NMUmk3K3BMSlFnWEN6ajAyTCtXank0ZWRldkpHY1FvMVd1dkJ3?=
 =?utf-8?B?NVJHNlhYdTNBeDR0eGhRMVgwUEwveURSaUZPSUNKUW8xd0VUV3VRRjJWL2lp?=
 =?utf-8?B?bDhjMXdtcmRIV3NBZkxUWCtVZ3NncGJCOU1Qa0NuYjlzYW9ndHp5RjhlYVZF?=
 =?utf-8?B?QmQ0aXh6V0MxeE1OSjdBaWFhQXhyVWcrcFhKT2pUdHdnbW9zVnFneCthbFJi?=
 =?utf-8?B?SUxFWlM3dGpjLzFiaXNLWGkvc0R3cVdXMU1yTzNSWkIrMUZQZ3ZWTGE3Q3gx?=
 =?utf-8?B?NTJWcjFxeWxjSGFKNUkrMjNmYzVURFlnLzJZZzNKLzFrdXBrcTI4QjhCeWkw?=
 =?utf-8?B?WHVkZlNtREtrWlJENmVNNk42aTFMMjFwb3RtQnpGWHNNWmRJaFplV25ibWdG?=
 =?utf-8?B?TVFrU2l1RzJ1bnhSL3NxZXNIWTIzNWZFdGFKVzRuazExQ1dROWFTQVpDdWxi?=
 =?utf-8?B?ZWVkUmttZ0RwYitkcUN6bTRta01kM0FlWkpuV1lSd0NXcEU0NFZ5NUt3WXh6?=
 =?utf-8?B?elVFWlpqd0NaRmJBQmhwNmY4ZVZlWWFqamhLdVJZaFR0bCt2ZXlpRC9vUHZY?=
 =?utf-8?B?bG02SVR2TWFVc0J0bXd4Q0d3enVzcHI3MVRZZjJ1anpuYWJMbkdmNE1pQUZY?=
 =?utf-8?B?dTV5QWJsUThxR0tMNnB6MHJCVnFlTFRDN0tYVzhLcXUxUzVwSGEzNmZmVER1?=
 =?utf-8?B?bys4SlU3Mkwybm1vMTliYmQvZ3VWUHlzZWVRVU04RXIrNE5KdlNHZXhqSGNW?=
 =?utf-8?B?bkhZaWhHZDlocmRqWnZ3dlpGcEZyUk1ocWhHMHhKWTU2c2VlRWNzMEFTYk9P?=
 =?utf-8?B?aXRQZ2VTVGc5NWJHdDZtaDNNL0VVUWhlcDk1TGYydStkUEJLWG8wdDU3Mml0?=
 =?utf-8?B?VllkdEQzZWphSjF6UkFCZWY2M201OFdQa0c5eTdrdDJ1cWk0eHlESmhKSW0y?=
 =?utf-8?B?VmhqM2Y2NFNpM3ozMHpSVUd6eG1SQlozd1MrNnlUYnNCNWRjc1k1c0prWi84?=
 =?utf-8?B?WGxaeHd4MXE5ZHo5eTZiZ0M0NHFNc3FCYUZ5eVROMjRPUjNlZ0g3TGlkNXg4?=
 =?utf-8?B?NE5sa0lsb2VPMXphZTZkRmlaZG5kaldUMTJKbWJLSkNRZTEydXJnSDBpWTkr?=
 =?utf-8?B?U2d0b0dqcHZSbmdlQUJyVmRGYmxZNlhpbWZQZlJmZ0xha2g3TXN0dVF5VWk5?=
 =?utf-8?B?K08rRnF1RkFHeVRMVVRkai96d0ZnQjAxOUFxRFk3dXRxbWlpem9WdTIybnVI?=
 =?utf-8?B?bTJoY1B0SlVDeUZIR2hRTjFiT2ozY1F0MUFFbXZ0dmIzWjNzYmRPbEhWbkxj?=
 =?utf-8?B?YUYxRGs5ZWNKd0ZlK2wwMUdycmc5bm4rNlkwU0ZNVzhWL2k0SndnQVVaL2hs?=
 =?utf-8?B?akpmdlFkbFFjTTBRMSt1b1g2VUI3b3FON2Q1cjdpUU9OOEI4andXZHk2Njk2?=
 =?utf-8?B?bnlPekpNdFVwOFkvZ2g0TmRKRWd3SEdjSjdXenZnNzRDcEdHQ01DNTg4dlgr?=
 =?utf-8?B?aWVQNmIwQlZNVmlhUzhDWGVHb0NpMG43Sy9EVjZyVDhQNjlaU2dGa3FVL0Fj?=
 =?utf-8?B?WVpMWU84ZnhrZms2eEdySEVVMUNIT3NUSUVIYnBBRUU3QUJZWXRZVjY5dG00?=
 =?utf-8?B?ekJFblBjWjlMcWhJYzJwSlRDWHlyZ3dLOTVNaHRDWGNmMDJ1dVc3eFhTenZQ?=
 =?utf-8?B?YmxkNUxEMzJVeWJ2OFR3TExpd2ZSTFY2YTRsNmJJODFjeG5ITHRNZktNeXlE?=
 =?utf-8?B?RklFOFRpWGR3RzdaNjJLSmJCRk80QVROL0hHbStJc205R0MycUtpdERXT0NH?=
 =?utf-8?B?K2VneUNBMmFUV21WeEFUd3Rla0sxazRmREoyNEthUE5LLytiVFo2VVFGMVdS?=
 =?utf-8?B?WFZZZEVELzNWUDdQRitLOEpKTFhvMVV4RHUxWEFyb1hKNmdSNytQSnpaaElS?=
 =?utf-8?B?VkgzYUNJRmNDOTBzYVdkc254WW9ZL2tVOUFtNlhsRC9iZ2VrbWxUUFFjY0hV?=
 =?utf-8?Q?0My4rMf4lF7JjIbpGJgdUkE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f570f1a2-47e6-4ebf-f710-08d9b8d68d5b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:36:29.0741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CXTe8jKAjhlEcYejG0JmnGKeesVkFRhV+FLkGXKtmcoObdHmeRvsEuhWR0AWMa+O0upcwN+F2nXruHKr+QHTKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5375
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/21 10:13 AM, Russell King (Oracle) wrote:
> On Mon, Dec 06, 2021 at 09:59:46AM -0600, Tom Lendacky wrote:
>> On 12/4/21 8:52 AM, Russell King (Oracle) wrote:
>>> On Sat, Dec 04, 2021 at 08:59:12AM +0000, Russell King (Oracle) wrote:
>>>> On Fri, Dec 03, 2021 at 08:18:22PM -0800, Florian Fainelli wrote:
>>
>>>
>>> Here's a patch for one of my suggestions above. Tom, I'd appreciate
>>> if you could look at this please. Thanks.
>>
>> I think it's fine to move the setting down. The driver that I was working on
>> at the time only advertised 1000baseKX_Full for 1gpbs (which wasn't in the
>> array and why I added it), so I don't see an issue with moving it down.
>>
>> A quick build and test showed that I was able to successfully connect at 1
>> gbps. I didn't dive any deeper than that.
> 
> Thanks Tom! Can I use that to add your tested-by to this change please?

Certainly.

Tested-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
