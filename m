Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91864B3D03
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 19:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbiBMSzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 13:55:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbiBMSzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 13:55:13 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22DC58388
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 10:55:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASNg/LbaAeN9GMGeINr1Tf1r/0vL+q63HucdKbdrj7q9/b5fJ0CKRlvKzl/dxpSycSyiyxYdZ7L1KmOpUD40I8pA3IbnuoP630MlGEbprLXAhhN/rcfErP9z5QV9x87xcbzpQ82eoQWElZa/padJGg22ZeCZxHmpVHrDVDMsALpvWUUjOQoeZzNDMN22GiTOIgXr0LQM+FveuenKMFGtQTZEKIHtb7TjuZJJ+nguLPSNto5Nrd94YyUrgKWkiiv6ufsZrwkT0cVL1XlWl5e9mlubO7NbdK2WxF8J4wWK9D6C84S7wz/O5QTcwOonZrAYwQOToD0BOJLjj2buTzzk2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vykNYhPQhyYHToBRU24TlLoR+QgtJoTQxzCpNsmpYk=;
 b=Ioxjf1GrOCTOJhysRAago6/3JESleh5+yyeCOb5UycT4i8NbubSJVuZ0RF8rJtlv8G22JPKlV3wZ6P3+ZZ8tjJXQWfRhYM/wa4r5ChDCUk5bU4y1sZ+0gDE5HloCeC/dyqusi3f0SP/CGrPw0Zhc+eOezd1sOS6X6HqO42ieUczka1523gmNJ07RJkZgU3c7Typ8Fh0X1NfdTxxeHkaCBjrQQmmZJamrvaP4rVJm/ca3N4dsw5WPnyIwuzlMwlq5ETzifAzEGPgdtT/YZWToq7iH0aPsMmxrU6uW9Lk3BKZ9L7ZbtvXoI/XrwPXdSBo0It8TjwUjjE6+J0VeCydO9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vykNYhPQhyYHToBRU24TlLoR+QgtJoTQxzCpNsmpYk=;
 b=Ls+fcM/NWayvYnQ/rgLqB6u8vlmY4PgTo2s/tcZO8gXPVkwQ3NCoxPJVNpeTdQjRMfIyllKfKgCb8MRc7aaYc/J7pGjdornoKnOL32gPhiSi5T5wFxurUUHKkE2LaePJsAxEu08GvjWuQ/K3WF/FYRWPiyjkbiPf1QoZ4TaB7PU/rj+gGVB8FdxiZLLeEiadVDmEpUiq4O0K8S/Q1APh9dvWvoZKq3wHJTnrmlrkwpAg26h3nz8fQhY4+IVqaFncaxLYask5lhTV1VLaHAU9dgZsUm6GJAcSLGTQYtNMSx3B+oIq4KXURmdvV+Xi46MPzbtChvCeLaAIQyh32hp2jQ==
Received: from DS7PR03CA0354.namprd03.prod.outlook.com (2603:10b6:8:55::12) by
 DM6PR12MB5697.namprd12.prod.outlook.com (2603:10b6:5:31::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Sun, 13 Feb 2022 18:55:04 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:55:cafe::b8) by DS7PR03CA0354.outlook.office365.com
 (2603:10b6:8:55::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15 via Frontend
 Transport; Sun, 13 Feb 2022 18:55:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Sun, 13 Feb 2022 18:55:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 13 Feb
 2022 18:55:01 +0000
Received: from [172.27.1.51] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 13 Feb 2022
 10:54:54 -0800
Message-ID: <7b3c0c29-428b-061d-8a30-6817f0caa8da@nvidia.com>
Date:   Sun, 13 Feb 2022 20:54:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH net-next 0/5] Replay and offload host VLAN entries in
 DSA
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edfc5e6a-226d-4913-3edb-08d9ef2258b7
X-MS-TrafficTypeDiagnostic: DM6PR12MB5697:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB56975BF4A161F3BE485B83D4DF329@DM6PR12MB5697.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2QOtPO1TYyEfSdI+12yRp/hSkmkx3ya2GykWmscjburqgl4dfyUyG5/unpy2/8/oqxnO3U91HLHCldKiWqD5/qNl9cl8ORyuv6Rs/bOkhh86rA5U4/8mFbmz3a6PIFrcdECuzi898zCq/SsCoEw00hIgI1gKc21nWI2fYjdfx3ZDETcp6n/WEQb/qivoIjG9jws6M2dfY1g1/mt4bvdRfbbnLrdxf8MXhOc46JbX/iqiR2VF76oUTmRR8uKncKcbvb+s9VDXXpsAU15LJM9L00w306unIU8lWmqx5l1uh8+UxhFgID16W2fvf+/EaYGjmZNYmX6pBOhZofVYNrWogLghHwPhW/yOQm69wjD0Mfladm8O1ABnzc46g1Yy07v6ST9ASDr5RiDD5SrVr947Z7ENBB1CpxoB0GH/nc3mdKnvA5A2OMIzcmOweLSMu+EJUV1ovBHVrPfQNRzS71bX86BRTWPhgsVqF0oFqF6fqTXvsjCQG9+t6of8BR2m8PnZCKj55ujwK3XuhnVoyoHFUpBvNPVdeD/PjLBoLYtfbTTkRrDdbUg7N8K0MsQw5+MCcQpOxlbj2Mg0tT+zHkdTZiDutfqzxvOU1E+zw3MwNaFRxqB9O6zCKS+339AERpIaCsC37aq4krkFxlBmHklHnyaG7ufnk15It2BfKzp2Lnd+H+zlUeJAQJp/wZQiQoMkXUlVR6QPOupgm0rSzTqGzDGB2Yg8qSfuTntzIoZA2ld1TFYFvuWo8ZxSC3VRUd8dN8YpPEnkGDSog6cuV62QHuDcXKVDZlTmVvRiWZMB20hJG7eFdbu6L8q/WCju0534w/77Y9fSZ0h0wKGXZZDb1A==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(508600001)(8676002)(4326008)(5660300002)(16576012)(110136005)(70586007)(70206006)(82310400004)(6666004)(86362001)(8936002)(31696002)(966005)(7416002)(316002)(54906003)(16526019)(31686004)(40460700003)(36756003)(83380400001)(36860700001)(81166007)(426003)(356005)(2616005)(336012)(53546011)(2906002)(26005)(47076005)(186003)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2022 18:55:04.4716
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: edfc5e6a-226d-4913-3edb-08d9ef2258b7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5697
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/2022 23:30, Vladimir Oltean wrote:
> The motivation behind these patches is that Rafael reported the
> following error with mv88e6xxx when the first switch port joins a
> bridge:
> 
> mv88e6085 0x0000000008b96000:00: port 0 failed to add a6:ef:77:c8:5f:3d vid 1 to fdb: -95 (-EOPNOTSUPP)
> 
> The FDB entry that's added is the MAC address of the bridge, in VID 1
> (the default_pvid), being replayed as part of br_add_if() -> ... ->
> nbp_switchdev_sync_objs().
> 
> -EOPNOTSUPP is the mv88e6xxx driver's way of saying that VID 1 doesn't
> exist in the VTU, so it can't program the ATU with a FID, something
> which it needs.
> 
> It appears to be a race, but it isn't, since we only end up installing
> VID 1 in the VTU by coincidence. DSA's approximation of programming
> VLANs on the CPU port together with the user ports breaks down with
> host FDB entries on mv88e6xxx, since that strictly requires the VTU to
> contain the VID. But the user may freely add VLANs pointing just towards
> the bridge, and FDB entries in those VLANs, and DSA will not be aware of
> them, because it only listens for VLANs on user ports.
> 
> To create a solution that scales properly to cross-chip setups and
> doesn't leak entries behind, some changes in the bridge driver are
> required. I believe that these are for the better overall, but I may be
> wrong. Namely, the same refcounting procedure that DSA has in place for
> host FDB and MDB entries can be replicated for VLANs, except that it's
> garbage in, garbage out: the VLAN addition and removal notifications
> from switchdev aren't balanced. So the first 3 patches attempt to deal
> with that.
> 
> This patch set has been superficially tested on a board with 3 mv88e6xxx
> switches in a daisy chain and appears to produce the primary desired
> effect - the driver no longer returns -EOPNOTSUPP when the first port
> joins a bridge, and is successful in performing local termination under
> a VLAN-aware bridge.
> As an additional side effect, it silences the annoying "p%d: already a
> member of VLAN %d\n" warning messages that the mv88e6xxx driver produces
> when coupled with systemd-networkd, and a few VLANs are configured.
> Furthermore, it advances Florian's idea from a few years back, which
> never got merged:
> https://lore.kernel.org/lkml/20180624153339.13572-1-f.fainelli@gmail.com/
> 

Hi,
I don't like the VLAN delete on simple flags change to workaround some devices'
broken behaviour, in general I'd like to avoid adding driver workarounds in the bridge.
Either those drivers should be fixed (best approach IMO), or the workaround should only
affect them, and not everyone. The point is that a vlan has much more state than a simple
fdb, and deleting it could result in a lot more unnecessary churn which can be avoided
if these flags can be changed properly. The host replay sounds good, but please re-work
the flags change logic and push the changes down where they're needed.

Thanks,
 Nik



