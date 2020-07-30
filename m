Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744BD2331A4
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 14:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgG3MFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 08:05:13 -0400
Received: from mail-eopbgr60069.outbound.protection.outlook.com ([40.107.6.69]:1415
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728092AbgG3MFM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 08:05:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DD/5S6BY1JNEp1h0D/NOdLdMsrPqzcxHL4FcNTBrr49D/0tjaIU9rc2w70TTCbvg07IFFtt2se0Yn7TC1W8c1V0frKuWVwxjQE99Vr1SDRl5/CqZ8vIPa9dCF8PT3W2HpUjsp0AxurLuTYUe3D+3n5tyZPcFxeUhzsSU5/IDDoM2+prJa9dTkrmk1DgXRXMeNE6K9m3npQrL6TrGcSSXqZcgi20u1BVOZNhXJ5CNKfU308en00g7y1GL4MJi17H3FHGOyk7ose4FM55ntmExu61wYJzzk/NgxVjSSgxUhwQJ8Yql7V0n3s9amrckAiZJjO3ko/4hN5eDWyccYQ0Clg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpRPsfvw0hXvL9kZ4gY6lNBM5NufHoEQqyBnXNBLOJ0=;
 b=T8NAsdncu7BvADeejPDrrKg2BZkwklZ56ySOuqyFCRrj9aWyrwG3kifrVbKaBZQGfologBiyU9FN14WO/PPms5zOAEgo3zMgmksc0CR+Moq4lQoLH+k0Bifj/A3x/sSTyM36bAS+kF1UeoGiREwYE2AEy8dQdJppQhcNQYmlW7fQYH2Ah3RgZbsZyAeijaQ9IXeD5BWHUd94xj9TqXBfbaO/MzSoSKNW1Qfvc19K7CD9WNq1HvH1RGOh5sc5NesgDw4khFkuP5BfWurmim2NdNqG8GF6rApL23aZW0D81d3DVUxkc8R7epN9crGJXX8KlhY4H5BlIerH8P1kz369tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpRPsfvw0hXvL9kZ4gY6lNBM5NufHoEQqyBnXNBLOJ0=;
 b=lSWr6M6ExNbrep71wFE++FFOA0C1e1tqpg3fq09HvedlZjyhEYQPJt8f0VHbgnyKSbW0h7WOcDgD+7vusDjqf0arrE/JMs2I52Hu5uJO0Wny2qAIKJzWR4pPpluyE0MfsreVAfvi/ON8vK9KIZ1SUQ5+0dVWeKvRqT5hH17fwPU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from DB7PR05MB4298.eurprd05.prod.outlook.com (2603:10a6:5:27::14) by
 DB6PR0501MB2647.eurprd05.prod.outlook.com (2603:10a6:4:81::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.24; Thu, 30 Jul 2020 12:05:09 +0000
Received: from DB7PR05MB4298.eurprd05.prod.outlook.com
 ([fe80::f0bd:dfca:10ef:b3be]) by DB7PR05MB4298.eurprd05.prod.outlook.com
 ([fe80::f0bd:dfca:10ef:b3be%4]) with mapi id 15.20.3216.033; Thu, 30 Jul 2020
 12:05:09 +0000
Subject: Re: [PATCH net-next RFC 02/13] devlink: Add reload levels data to dev
 get
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
 <1595847753-2234-3-git-send-email-moshe@mellanox.com>
 <20200727175842.42d35ee3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <448bab04-80d7-b3b1-5619-1b93ad7517d8@mellanox.com>
 <20200729141117.0425ad12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@mellanox.com>
Message-ID: <34db0d37-5d50-5721-7a78-740b94190930@mellanox.com>
Date:   Thu, 30 Jul 2020 15:05:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200729141117.0425ad12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM3PR05CA0129.eurprd05.prod.outlook.com
 (2603:10a6:207:2::31) To DB7PR05MB4298.eurprd05.prod.outlook.com
 (2603:10a6:5:27::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.105] (5.102.195.53) by AM3PR05CA0129.eurprd05.prod.outlook.com (2603:10a6:207:2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Thu, 30 Jul 2020 12:05:08 +0000
X-Originating-IP: [5.102.195.53]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 485525f4-a83d-44bc-451d-08d83480ce56
X-MS-TrafficTypeDiagnostic: DB6PR0501MB2647:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0501MB26476C089892E50A7715F19AD9710@DB6PR0501MB2647.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hmYSKAnu6LMcXObLP2T+ekO5ILD+/gsiJLH4SiZ6sIlqcOuoqanQ2eKOlNv5XFxjJQvgCFhhhX9hsE9g23CndSkQ84RjFIpEk2eIqk90cSpaLcvt4sCQIoytzoU7+Vk8bFFLkTDS9EOI7vPy0ilr4ClcCkxDbPaGsKr4DHd7vhJxj/jGhGCzB6Su+/PuEE/GeBMoaSXlhVWq5nu4GWuPU2l5xkle8IhLBbRtLkXTYRDm6cpOth0Ia7AhmIqEoiGwD7bsvJgaPCghz8RgN/JYGzJoHJonOBuoJaJUNoqTp2YWB6oVtxoSrOrtW6odFkAOZ1wDUqge0NocULzhLC6XGXyj37JzXxCSz4Yh/bKegexqrHKvdDrSObuigrme8nYq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4298.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(52116002)(6916009)(2616005)(4326008)(956004)(478600001)(186003)(26005)(5660300002)(6486002)(16526019)(36756003)(53546011)(31686004)(8676002)(66556008)(16576012)(2906002)(86362001)(66946007)(316002)(31696002)(54906003)(66476007)(83380400001)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +COQdn37qWEHn6khZMqb0Hv/4s+gGP1rdGg00/mb8kq9zW8vTFW4a+Nk4HDi8q4YayMh8+fwU5gaZgPWADFzMWHoYFnW6/E6OO7eK60rGdnrEsHOUveDYnoYUmfPvJ6KdpjwthWAu8OIpjqU7DR3PEY4miSl0IrpakPJ/Rn7/kAukCHA5uIBYgjZhdyZHUKWimJA5hlowUVg2cCt4yaip8bWIDvmV+B9XLpXsSfoVMhOOWRLbHeZaU2JqGYR2TNNz8iF65WWnT4EHCF/9P+WGxiGxTk7L/ImcqZaIS6u/xoODZXBaTU+hajUPq8UAiSPLpG1oqbOXafIR+nJo7wljHZTHZCEqRWZD/rJ0qDNc3sy9xouA7Mtk87mrlAK1/cSyE69ROYDrmJgg2WSePAd1qhRhsAAi/j/xqBGU9uCFbC6m+H5sUiZCgIDHdXoShsm4OobLuKK41XBxVZKXIbAiOlhMqeQxgCukZGQwYeEgxM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 485525f4-a83d-44bc-451d-08d83480ce56
X-MS-Exchange-CrossTenant-AuthSource: DB7PR05MB4298.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 12:05:09.7572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YPRWigyvUIs0prqJo7bNWx3qyHREJTECBLCnaYp1KiiqUl/83ms5SJP7h36Lhp0L49P9dqpY9IAGlM1Bb0CcIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2647
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/30/2020 12:11 AM, Jakub Kicinski wrote:
> On Wed, 29 Jul 2020 17:37:41 +0300 Moshe Shemesh wrote:
>>> The fact that the driver supports fw_live_patch, does not necessarily
>>> mean that the currently running FW can be live upgraded to the
>>> currently flashed one, right?
>> That's correct, though the feature is supported, the firmware gap may
>> not be suitable for live_patch.
>>
>> The user will be noted accordingly by extack message.
> That's kinda late, because use may have paid the cost of migrating the
> workload or otherwise taking precautions - and if live reset fails all
> this work is wasted.
>
> While the device most likely knows upfront whether it can be live reset
> or not, otherwise I don't see how it could reject the reset reliably.


The device knows if the new FW can be updated by live-patch or need 
reset once the new version is stored and it so it can check the gaps.

So once the new FW is stored I can query if it is a change that can do 
by live_patch or need full fw_reset.

>>> This interface does not appear to be optimal for the purpose.
>>>
>>> Again, documentation of what can be lost (in terms of configuration and
>>> features) upon upgrade is missing.
>> I will clarify in documentation. On live_patch nothing should be lost or
>> re-initialized, that's the "live" thing.
> Okay, so FW upgrade cannot be allowed when it'd mean the device gets
> de-featured? Also no link loss, correct? What's the expected length of
> traffic interruption (order of magnitude)?


That's different between fw_live_patch and fw_reset, that's why I see it 
as different level.

The live_patch is totally live, no link loss, no data interruption at all.

But when the firmware gap for upgrade is not suitable for live patch, 
the user can choose to do full fw reset, that can include link loss 
(depends on device) for few seconds and some configuration which is not 
saved by the driver or was not configured through the driver (some other 
tool) need to re-configure.


