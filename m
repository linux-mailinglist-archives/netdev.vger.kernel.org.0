Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074DA346864
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhCWTC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:02:28 -0400
Received: from mail-dm6nam10on2049.outbound.protection.outlook.com ([40.107.93.49]:38017
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232903AbhCWTCW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 15:02:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DsfdEGemb0zA2HfaK1qsssAdGuzzqCigSBMkeNUzbsAKnXkehV11tRSI5WJvD8TYybbmizSn6Ldzgw5yl8n/5A/igcoE/Tmf9ViibMe7qXDM4VLLokYDGb7biFiX8uVaI1tiVEjS5NwBS6xsIgfQkb5cTqvtTGuQ0JspsTv11Hv6Es8u1nOHvPjOFOv+MctQesp9UmKZ7KHAXyZxDaAr6DvT7O7uBIXG2nWlRCVx8n4C0SPwoCi9p9YLqOzyXzIzDqGyyEYB0VzAg+Yd+vSBHPU3r+/oW6RdTtS/8WiHWGA0sBkuo9u1JBKjQjA2KosMrIaEq67ybt8RzDlOsrWLBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vcAmQoaR+CG52gxVrCwkpalwxHUIN++iP00jVkqxmQ0=;
 b=hqFhDOVZF+xnuOwRNsfjNOT6wkQu46T40UCB9BrnGqbgcwyPA7ZlRTluDJyNhE5qthEE9L7Lbbmi2yWBiVGayRrWft7sFs0x39j9xE0GHwPF2UXheDXWZLWznF4R3E7+PEK7Jcp1awFCkPRvBx+THbJDtH39ZULnNbG4wHRTXyhvZ8C5CBpKkjMLX/sc2YXGLC515y6JdS07Ft5/TrLpvDVj+PVP6iU+AHdmWbCgAaoPsZFI3BmLws1r+U8YhCqNHcL9+jlTAIep1ZHXJB76FIXAZrfRJ4DePRnqAAU8PpduLXIVTYxIv91BsZ3EdHnbkJEXQ5owgCubshLjMIfs1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vcAmQoaR+CG52gxVrCwkpalwxHUIN++iP00jVkqxmQ0=;
 b=SqKyyRv+MoFmcipnj5B6cmuuA+n0Skoz8W+/D7XiiSzymOQeeaTMtF50KDsmgBEl2Z6BCD+b2buKw1e59wGV1hYzMLrUs1vRzh40nvj8LLkk7lq9oPvx7CfLTJerfvzcJaAeZS0RTQTWAxFT7LdMj7XEVjddu5AAEYfOtvN7GUxOI++ZllEsOqlsZLDFPOF/WB9Zmt4jrSQUn4MTi8xI3Cjk3iUZbJV8al05DJWfd1OY/5Vxnrk8GxY3a3dPcG29uqPklfw8Qw96UELI0C2CsLUrCZDUg8PR/AyMaq+tFHqRtYkZ24+nkKomg3lcxzaBPrJFgsCitNzuyneD6WX/DQ==
Received: from MWHPR22CA0023.namprd22.prod.outlook.com (2603:10b6:300:ef::33)
 by DM6PR12MB4329.namprd12.prod.outlook.com (2603:10b6:5:211::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 19:02:21 +0000
Received: from CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ef:cafe::10) by MWHPR22CA0023.outlook.office365.com
 (2603:10b6:300:ef::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Tue, 23 Mar 2021 19:02:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT052.mail.protection.outlook.com (10.13.174.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 19:02:21 +0000
Received: from [172.27.0.234] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Mar
 2021 19:02:17 +0000
Subject: Re: [RFC PATCH net] bonding: Work around lockdep_is_held false
 positives
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Mahesh Bandewar <maheshb@google.com>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>
References: <20210322123846.3024549-1-maximmi@nvidia.com>
 <YFilJZOraCqD0mVj@unreal> <0f3add4c-45a4-d3cd-96a3-70c1f0e96ee2@nvidia.com>
 <27509.1616522187@famine>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <210a8bf2-5c1f-0c14-ab81-5c0775d7d23d@nvidia.com>
Date:   Tue, 23 Mar 2021 21:02:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <27509.1616522187@famine>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a487c9e4-9487-4702-3a5c-08d8ee2e2ff0
X-MS-TrafficTypeDiagnostic: DM6PR12MB4329:
X-Microsoft-Antispam-PRVS: <DM6PR12MB43298FD5BEB9A6D220E9BB60DC649@DM6PR12MB4329.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3wLsqCXeCGM9gc/p3D+OY/sWX9NN/SyCgmZCiPouJlUfFQsuFNs/ZRsFFHtHGYdKC1FW4L/VIX3vMlmD5LSKF6uui7ABgbWJLsCHTEB4SM90Lg3K1YEUmNkq3sIMPCifFbvjAFwHHsUUJwIReNo0VuJpC7LwwxGZOaV9urHV/IJ/+iRlR7wr7iNHTI0AkX/xgHEN45lPVDailVXmpkJMBH2JhDCYHqYGEKyZ1Gu9qda0ur8iCEsZLSiWpdpP1uL+y5e0xZFzRlv0N33kjFwtC6OFWU5xGA0Ap3SIgGLqg66v+4ygXdwUCo+VGGF5Wbq/F8CU1SfbMEkO7YdziM/XNuuBZgIUoY1x5/lyjVCBgdngTU9cCYHNmiQclFTH6REzAKK445cuFN4mpXWheZdaqjdcKPRxLSz5a6KXoYOvLajpcgc6/P68xj3MZquuF8gY8jaqDt1B6THhAQBm9G9GZiUkKYI0iwGM1sJTB3D1NbAZgDWneAYXIRGyCBcI6n0g46hFggAOLmULivo0m0nKnPrDEK4Fz3JgJ5LodwHy94jvjwmnuB3CL17/R34W+ny/nxpfTaYBOgoXwQxhfl8n/iCcExNMhU6W7IgjYK8oxhorRjQEGTfjLgMc778jmyePaBidrNMCDyKkDn4bplfRTm0vqTx3g8+9gPkHQwpdm0W19zyxTMJd5BHDylrmchMmrXu/cMOarRPJqm4AmWp/7ulGMWFidNKZUzauIOqlk8zSL40TwrTEqHPEa3u5tYhPd4C9UI9FY3ACrI4QihjURw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(396003)(36840700001)(46966006)(7636003)(82310400003)(6666004)(2616005)(36860700001)(82740400003)(336012)(86362001)(4326008)(8676002)(36906005)(426003)(47076005)(356005)(2906002)(36756003)(16526019)(8936002)(70206006)(316002)(54906003)(16576012)(83380400001)(31686004)(31696002)(966005)(26005)(478600001)(70586007)(186003)(6916009)(5660300002)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 19:02:21.2404
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a487c9e4-9487-4702-3a5c-08d8ee2e2ff0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4329
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-23 19:56, Jay Vosburgh wrote:
> Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
> 
>> On 2021-03-22 16:09, Leon Romanovsky wrote:
>>> On Mon, Mar 22, 2021 at 02:38:46PM +0200, Maxim Mikityanskiy wrote:
>>>> After lockdep gets triggered for the first time, it gets disabled, and
>>>> lockdep_enabled() will return false. It will affect lockdep_is_held(),
>>>> which will start returning true all the time. Normally, it just disables
>>>> checks that expect a lock to be held. However, the bonding code checks
>>>> that a lock is NOT held, which triggers a false positive in WARN_ON.
>>>>
>>>> This commit addresses the issue by replacing lockdep_is_held with
>>>> spin_is_locked, which should have the same effect, but without suffering
>>>> from disabling lockdep.
>>>>
>>>> Fixes: ee6377147409 ("bonding: Simplify the xmit function for modes that use xmit_hash")
>>>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>>>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>>>> ---
>>>> While this patch works around the issue, I would like to discuss better
>>>> options. Another straightforward approach is to extend lockdep API with
>>>> lockdep_is_not_held(), which will be basically !lockdep_is_held() when
>>>> lockdep is enabled, but will return true when !lockdep_enabled().
>>>
>>> lockdep_assert_not_held() was added in this cycle to tip: locking/core
>>> https://yhbt.net/lore/all/161475935945.20312.2870945278690244669.tip-bot2@tip-bot2/
>>> https://yhbt.net/lore/all/878s779s9f.fsf@codeaurora.org/
>>
>> Thanks for this suggestion - I wasn't aware that this macro was recently
>> added and I could use it instead of spin_is_locked.
>>
>> Still, I would like to figure out why the bonding code does this test at
>> all. This lock is not taken by bond_update_slave_arr() itself, so why is
>> that a problem in this code?
> 
> 	The goal, I believe, is to insure that the mode_lock is not held
> by the caller when entering bond_update_slave_arr.  I suspect this is
> because bond_update_slave_arr may sleep.

If that's the case, this check should be replaced with might_sleep(). 
There is at least kzalloc that may sleep, so you may be right, and if 
it's the only reason for this check, it's indeed invalid, as you explain 
below. However, let's see what the authors of the code say - maybe they 
meant that during this function call no context must hold this lock - in 
that case I would like to hear the motivation.

>  One calling context notes this
> in a comment:
> 
> void bond_3ad_handle_link_change(struct slave *slave, char link)
> {
> [...]
> 	/* RTNL is held and mode_lock is released so it's safe
> 	 * to update slave_array here.
> 	 */
> 	bond_update_slave_arr(slave->bond, NULL);
> 
> 	However, as far as I can tell, lockdep_is_held() does not test
> for "lock held by this particular context" but instead is "lock held by
> any context at all."  As such, I think the test is not valid, and should
> be removed.
> 
> 	The code in question was added by:
> 
> commit ee6377147409a00c071b2da853059a7d59979fbc
> Author: Mahesh Bandewar <maheshb@google.com>
> Date:   Sat Oct 4 17:45:01 2014 -0700
> 
>      bonding: Simplify the xmit function for modes that use xmit_hash
> 
> 	Mahesh, Nikolay, any thoughts?
> 
> 	-J
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
> 

