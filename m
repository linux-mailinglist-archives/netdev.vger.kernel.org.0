Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F724182C1
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 16:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343740AbhIYOdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 10:33:35 -0400
Received: from mail-dm6nam11on2084.outbound.protection.outlook.com ([40.107.223.84]:56865
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343667AbhIYOde (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 10:33:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EH71zUUT2pBIyodAy/UDL/hjB71wXyrvtLXfNhXT7zn6h9rWXL1URfQB6v02OwtTcGR2GMYwwDx1HKeb41JAsTrQ4rjf0751GDkp5XZ0saGlbqgTjsu3zqEkcrhpYtgf7XewemTbJjyze7ahh0cRLo+WGQox82oMBEWpWcGU/Fz0R9JeXww8k4FNXm+5okSsgFkyOrBsernQT9oUt53DXiWXzmvykHjiMODT3bbDoX0m98BaWPg6bEy++R94P6N2N8TWbYjuigTnVis+80apKxNrdC1gS1VgmlXcBLTcJiLo55VTryBM5xCfqW0UMCdLXHOnh91ZzpdM99t26f00kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9HNPZYnM56aZwTzm8x4uT3WxOb/aGgpJ9K2JrTHkORA=;
 b=mxCCQVpLTL4U58BcEA71dRX7TsZz+92wuVg6zUN1lhFjmXc7Z/5+j9vYvHp1WEicND+G286wHbFucMrRGk7aWvXO/VitCOpNXDOeYBWjQasMva0F8iRJz9Nx8Go4dv3fAeP1vtdpINDNhkJl/c/Q8GpL5LatLwCSlRuZGnAcfMfh13neWfWdEmHeYHQ/rvLrcVRVReq/jdfd5t0IrCV6T3XphfdeKrOdr8bQ5pC/+/SZHlQ3LrL1GnC4j1hpFtwBtclv8NYG2YsnRqHQatDI/eGMsCQhTPtPoRN0eIbyjpYg+Rd5TaGLi2TaDdGX2jlC+wNBK4ijEiXRQvsix2LsKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HNPZYnM56aZwTzm8x4uT3WxOb/aGgpJ9K2JrTHkORA=;
 b=Enbaos2a6qxY/rLqmfqWPbhfh3LFGlh0hyl+aWCNSYHFX9pTih7p/f7U2MKnIurxCw3GH3TmTBv0UlJadHql/r5PzxkLAK7mf0mwoFsZlZTG1Z5CnEULDFM/oQf3v4EAptC0gm36pNHtWbGXnoUwXu5P55Pt3VAcJcaDFyp2CJ0jlvOZNkpd9SNCk7EkQ4U96/VmgmqtTKHVOjDeRikdymd+18WZtxGx+MG4rCLhX/kfR8e/O4XjnUmKcJ6GpTbLJphdKQ0Ije+urnLihx1ZU9bLq7GpDjfkR0+nMRkEv6kZJ9Zu2Z5qcqE+EYRu4LHHbzWGOcz401Xh9PyeMBCbag==
Received: from CO1PR15CA0076.namprd15.prod.outlook.com (2603:10b6:101:20::20)
 by BL0PR12MB4740.namprd12.prod.outlook.com (2603:10b6:208:84::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Sat, 25 Sep
 2021 14:31:57 +0000
Received: from CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:20:cafe::84) by CO1PR15CA0076.outlook.office365.com
 (2603:10b6:101:20::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Sat, 25 Sep 2021 14:31:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT024.mail.protection.outlook.com (10.13.174.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Sat, 25 Sep 2021 14:31:56 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sat, 25 Sep
 2021 07:31:56 -0700
Received: from [10.2.54.9] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sat, 25 Sep
 2021 14:31:56 +0000
Subject: Re: [RFC PATCH 0/4] Faster ndo_fdb_dump for drivers with shared FDB
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210821210018.1314952-1-vladimir.oltean@nxp.com>
 <20210923152510.uuelo5buk3yxqpjv@skbuf>
 <187e4376-e7bb-3e12-f746-8cb3d11f0dc4@gmail.com>
 <20210923224903.mrln22qqfdthzrvm@skbuf>
 <01371d1f-8fdf-4159-331e-32f2dac22445@nvidia.com>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <d9a3720d-6f19-5214-463c-99debcccf9d6@nvidia.com>
Date:   Sat, 25 Sep 2021 07:31:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <01371d1f-8fdf-4159-331e-32f2dac22445@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 656ae4ab-36ce-455f-f28a-08d980313a5f
X-MS-TrafficTypeDiagnostic: BL0PR12MB4740:
X-Microsoft-Antispam-PRVS: <BL0PR12MB474057149A0AC6BC416FD824CBA59@BL0PR12MB4740.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b3v9VGCtP8owJbguyM28fs2hgrywrUb6B26Nm3B9rwXtf4d2CChv0FaWCtHe42ofWJY5AsooVa9AgIWCNky172ClikYswSxHYMXDXzhTFnsaCWNI1bYqySe1zGTC2Q7t+esxccg3X5oz7NKhKs41SwLfavYwkz+6FteeoQtb+qCzDOVbJH9k4zIrRAQXejrzES0Vc3HrLIMKf2fsIAKZ1Wsw2d5cQeaT11ceZw807mS/3IbDiPNFF8gbtrvWSykbpi05ptbbryhVK4fV0hkpM7F8S1NXrqzhntHgInLSxWYgWAEwnvJkGRGiP95fYmRYW1pyuy0nkwzg8mnb7prcOPQPtowN1b389EJq9gYFBNE3WTbO6KDZ4LQnDbYrA+FgMekwd2gpzW+s+5C3G+jzTNRLIbFhlubz0lNtK0ZoqaD9MDMMixRX7AoGP4R7rlNsF1QtudxXTxbHVYmUKK72tQki0i9z2ZKi9j5+go888HgppcBqS7D79oEulH7jLeDE+jDCjHE+eMUtFS56jq17ftPkjJ3/m8tExcPM/AjTVjWtj8VZ4PHMUajdbGqygFaef/JNnMLPWAid0dCT4l8kGqYT0Kabs6cfAl7kS+7xhW0JCPO4HWJ5+/YZyCc//e+YNzxAUaC0YnFPFdvE82pUe2644rvBeEoPapYJgYiQkfo3DnLCxjcI0biIpZ0MkyuBPSgK2btj1DGJTtpSs7mxBUl1fSBLh61k1Nb7EKiz9r8=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(8676002)(86362001)(31696002)(8936002)(110136005)(47076005)(508600001)(54906003)(53546011)(2616005)(16526019)(426003)(6666004)(336012)(70586007)(4326008)(36756003)(70206006)(316002)(26005)(5660300002)(186003)(7636003)(31686004)(82310400003)(2906002)(356005)(16576012)(83380400001)(36860700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2021 14:31:56.9625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 656ae4ab-36ce-455f-f28a-08d980313a5f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4740
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/24/21 3:03 AM, Nikolay Aleksandrov wrote:
> On 24/09/2021 01:49, Vladimir Oltean wrote:
>>
[snip]
>> We don't, that's the premise, you didn't miss anything there. I mean in
>> the switchdev world, I see that an interrupt is the primary mechanism,
>> and we do have DSA switches which are theoretically capable of notifying
>> of new addresses, but not through interrupts but over Ethernet, of
>> course. Ocelot for example supports sending "learn frames" to the CPU -
>> these are just like flooded frames, except that a "flooded" frame is one
>> with unknown MAC DA, and a "learn" frame is one with unknown MAC SA.
>> I've been thinking whether it's worth adding support for learn frames
>> coming from Ocelot/Felix in DSA, and it doesn't really look like it.
>> Anyway, when the DSA tagging protocol receives a "learn" frame, it needs
>> to consume_skb() it, then trigger some sort of switchdev atomic notifier
>> for that MAC SA (SWITCHDEV_FDB_ADD_TO_BRIDGE), but sadly that is only
>> the beginning of a long series of complications, because we also need to
>> know when the hardware has fogotten it, and it doesn't look like
>> "forget" frames are a thing. So because the risk of having an address
>> expire in hardware while it is still present in software is kind of
>> high, the only option left is to make the hardware entry static, and
>> (a) delete it manually when the software entry expires
>> (b) set up a second alert which triggers a MAC SA has been received on a
>>      port other than the destination port which is pointed towards by an
>>      existing FDB entry. In short, "station migration alert". Because the
>>      FDB entry is static, we need to migrate it by hand, in software.
>> So it all looks kind of clunky. Whereas what we do now is basically
>> assume that the amount of frames with unknown MAC DA reaching the CPU
>> via flooding is more or less equal and equally distributed with the
>> frames with unknown MAC SA reaching the CPU. I have not yet encountered
>> a use case where the two are tragically different, in a way that could
>> be solved only with SWITCHDEV_FDB_ADD_TO_BRIDGE events and in no other way.
>>
>>
>> Anyway, huge digression, the idea was that DSA doesn't synchronize FDBs
>> and that is the reason in the first place why we have an .ndo_fdb_dump
>> implementation. Theoretically if all hardware drivers were perfect,
>> you'd only have the .ndo_fdb_dump implementation done for the bridge,
>> vxlan, things like that. So that is why I asked Roopa whether hacking up
>> rtnl_fdb_dump in this way, transforming it into a state machine even
>> more complicated than it already was, is acceptable. We aren't the
>> primary use case of it, I think.
>>
> Hi Vladimir,
> I glanced over the patches and the obvious question that comes first is have you
> tried pushing all of this complexity closer to the driver which needs it?
> I mean rtnl_fdb_dump() can already "resume" and passes all the necessary resume indices
> to ndo_fdb_dump(), so it seems to me that all of this can be hidden away. I doubt
> there will be a many users overall, so it would be nice to avoid adding the complexity
> as you put it and supporting it in the core. I'd imagine a hacked driver would simply cache
> the dump for some time while needed (that's important to define well, more below) and just
> return it for the next couple of devices which share it upon request, basically you'd have the
> same type of solution you've done here, just have the details hidden in the layer which needs it.
>
> Now the hard part seems to be figuring out when to finish in this case. Prepare should be a simple
> check if a shared fdb list is populated, finish would need to be inferred. One way to do that is
> based on a transaction/dump id which is tracked for each shared device and the last dump. Another
> is if you just pass a new argument to ndo_fdb_dump() if it's dumping a single device or doing a
> full dump, since that's the case that's difficult to differentiate. If you're doing a single
> dump - obviously you do a normal fdb dump without caching, if you're doing a full dump (all devices)
> then you need to check if the list is populated, if it is and this is the last device you need to free
> the cached shared list (finish phase). That would make the core change very small and would push the
> complexity to be maintained where it's needed. Actually you have the netlink_callback struct passed
> down to ndo_fdb_dump() so probably that can be used to infer if you're doing a single or multi- device
> dump already and there can be 0 core changes.
>
> Also one current downside with this set is the multiple walks over the net device list for a single dump,
> especially for setups with thousands of net devices. Actually, I might be missing something, but what
> happens if a dump is terminated before it's finished? Looks like the finish phase will never be reached.
> That would be a problem for both solutions, you might have to add a netlink ->done() callback anyway.

+1, the series conceptually looks good, but core fdb dump is already 
unnecessarily complex. moving this to the driver with indicators passed 
as flags

is preferred (you can possibly also mark a port as designated for shared 
fdb operations. again in the driver)


