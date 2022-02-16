Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4854B869C
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 12:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiBPLZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 06:25:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiBPLZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 06:25:36 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D9E74878
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 03:25:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrrjFA20WLRPV6cXJhwifCcphxZtsWyMwI/aGouM8sJilxqqEqjBHX85H7eQa9l5NwkQNBUGBMyvOTjXAPqVjaBTdEik5gjq/RC5VXMBtZR5BNohWrj8+9IT2jKrcaxNhHvreckUAfgtLl+OK6UGieFCpTsLc04UNLIxknM7e15IiHhyjnfgJT8J/JT9ePqMz9SD7yf/xPZ3/72u65t0khyYDfDjSzWXgjhtEIeUFS9caXa7rj8hNSxu3+dEjcHeP9F8dojeOhB2hucRdf4QexKFMLUdxqsZSzt1HN7L8VM3lo0WKh+KSIrpcRydlgBp+3zSl3IdOMU8WylDXMubiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmbTTqeWT59fdbB+IEtrOMj+iY7mDKuw/G+Uz6wRvWQ=;
 b=F4VzqnYw2oqYT9ymrxM/OvZtiILmsud1Xex2jmyGlUaAYL5MFvv3wGYaKn887yVC9APAoI0EPpqY5MNPzqp0DlyWk/nWNizZ12SUOqxNYrAs4/j92rZTyRGaatN8xCv2xqZuF0l1rxd5AwoMHkLLZ86Dm1MeRzPpOg1G1UuPFL5Dot+sVC0Ti++5b0addx4/yKgzWAmOh6gX8+ahYzeuRd5bqFzFDmR2m415IkBIm0CFOGxGiWP0idb/GZf/6TvC5fkTdKFSFmX/9JOQ1n08HJDJHmKF5dAeJQ8H5trMvtnKzUgO9GRUnmT3kVZ1bfksCmdSRSGRl60p0rGNhfMhWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KmbTTqeWT59fdbB+IEtrOMj+iY7mDKuw/G+Uz6wRvWQ=;
 b=F7Is4iJipIzyKNRyyWrduOC0b+a1MZYwsMIbUAmrPJl9oYtp0XWr0Ruq8a1E5ARecCltEKRHKuVRoM11Vp1gghulHgJrQV76xLLcCkeLB5mjqmMRB/DLiy1ZMheLXRrBphb77d/JiVDJKo1O/8IlLeimsN92+GzyF2w2IlyayJaESJHJhbxqTTI5E16rPHoryAANqSBjVnVJvw+3dxy4ds6s9yw3lWQJ39rG5XA3JNNthBKCoKiin0Um6cYpdd/B+cQBk+wm331ZNjog83xbGgEn+znJtBoC86WUB9NCLuKQJh9Oo5x2E40DAuM32fIMkiJQhRGiYgFP0g/Tj2JBWg==
Received: from BN6PR14CA0001.namprd14.prod.outlook.com (2603:10b6:404:79::11)
 by CH2PR12MB3766.namprd12.prod.outlook.com (2603:10b6:610:16::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 11:25:22 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::f1) by BN6PR14CA0001.outlook.office365.com
 (2603:10b6:404:79::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Wed, 16 Feb 2022 11:25:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 16 Feb 2022 11:25:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Feb
 2022 11:25:21 +0000
Received: from [172.27.13.137] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 16 Feb 2022
 03:25:14 -0800
Message-ID: <8ee86638-afae-eb13-4d8e-c5c27e7f87ed@nvidia.com>
Date:   Wed, 16 Feb 2022 13:25:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 net-next 04/11] net: bridge: vlan: notify switchdev
 only when something changed
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
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
 <20220215170218.2032432-5-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220215170218.2032432-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 192eb222-a7e2-426b-8561-08d9f13f0560
X-MS-TrafficTypeDiagnostic: CH2PR12MB3766:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3766DF650033CFFF8077FD62DF359@CH2PR12MB3766.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MZVma0+fwdSIC1hUrcDzCpYlhan5Ld0l3/aPJXSzTWdhObTfS0dqHqt0egD9dx77YHwE7p900eyylVaRYFfIKctr0EHT8dVy5STFwPkbhGs6hcnQ0uAquoSIGORbr5FiMgnU3+fe9CoiWEy730p29CxVI4hdrn5evgzFcUcf+T9/qw6+QAPXYEDCXFRo5o6oQ1okEoa/7d0mabRYLe1QezQZF7YICtM8KQH/mrTwGRJKl8ZCIV5GhSRle7c/81QKxmmF3ubg4hY31geTQf1n+isUQpQIQZD0ta50fFwW72cnTxAYt6GORUpABM5h8TfbILkIrlGWbPU7PmsTHpQaGjSd1ABuBXR5d6E1Ynt0TonRgr2pT8ftCqpwrsOTloIYf4RGP2vMyRNNoDZ7gyNntZ7NDv99gCciFS0YbUmjnZA1btXlZWbD8khXnq4fWlTUv2CjB5yxqTosK6K5xoxm/DMNFmRwTBveO88joFMT5add4/kC7JDWBqOWxEy1Rw6hCNCT2xlflav92jYxMQIK1XWuOgu7Gj5IuZiQAiWGrLoCNI7tkeXUW5Y9CBnrnOP/oIWkbh2qQFMw9KXg0iiG8zLe7xIOmiWyf+xrpGTVY43aGycPTO9oINBDXwxqbdAzVJ5tze832kDfBM8DZkEZwWsZHdnUdovjr67qeXkhYTZ5kySPU2xW2bnKg7xIforGB42cFdW/anWQvutBa8V0kYKmwhQ+Vcvkxq3K1k0RblBsz8qFRk3t9rIiWoKIZedW
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(47076005)(82310400004)(2906002)(6666004)(316002)(110136005)(83380400001)(16576012)(54906003)(40460700003)(70206006)(70586007)(508600001)(426003)(31696002)(5660300002)(31686004)(8676002)(336012)(4326008)(36860700001)(16526019)(26005)(81166007)(86362001)(356005)(2616005)(186003)(36756003)(7416002)(8936002)(53546011)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 11:25:22.3362
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 192eb222-a7e2-426b-8561-08d9f13f0560
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3766
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/02/2022 19:02, Vladimir Oltean wrote:
> Currently, when a VLAN entry is added multiple times in a row to a
> bridge port, nbp_vlan_add() calls br_switchdev_port_vlan_add() each
> time, even if the VLAN already exists and nothing about it has changed:
> 
> bridge vlan add dev lan12 vid 100 master static
> 
> Similarly, when a VLAN is added multiple times in a row to a bridge,
> br_vlan_add_existing() doesn't filter at all the calls to
> br_switchdev_port_vlan_add():
> 
> bridge vlan add dev br0 vid 100 self
> 
> This behavior makes driver-level accounting of VLANs impossible, since
> it is enough for a single deletion event to remove a VLAN, but the
> addition event can be emitted an unlimited number of times.
> 
> The cause for this can be identified as follows: we rely on
> __vlan_add_flags() to retroactively tell us whether it has changed
> anything about the VLAN flags or VLAN group pvid. So we'd first have to
> call __vlan_add_flags() before calling br_switchdev_port_vlan_add(), in
> order to have access to the "bool *changed" information. But we don't
> want to change the event ordering, because we'd have to revert the
> struct net_bridge_vlan changes we've made if switchdev returns an error.
> 
> So to solve this, we need another function that tells us whether any
> change is going to occur in the VLAN or VLAN group, _prior_ to calling
> __vlan_add_flags().
> 
> Split __vlan_add_flags() into a precommit and a commit stage, and rename
> it to __vlan_flags_update(). The precommit stage,
> __vlan_flags_would_change(), will determine whether there is any reason
> to notify switchdev due to a change of flags (note: the BRENTRY flag
> transition from false to true is treated separately: as a new switchdev
> entry, because we skipped notifying the master VLAN when it wasn't a
> brentry yet, and therefore not as a change of flags).
> 
> With this lookahead/precommit function in place, we can avoid notifying
> switchdev if nothing changed for the VLAN and VLAN group.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v2->v3:
> - create precommit and commit wrappers around __vlan_add_flags().
> - special-case the BRENTRY transition from false to true, instead of
>   treating it as a change of flags and letting drivers figure out that
>   it really isn't.
> - avoid setting *changed unless we know that functions will not error
>   out later.
> 
> v1->v2:
> - drop the br_vlan_restore_existing() approach, just figure out ahead of
>   time what will change.
> 

Thanks for seeing this through.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
