Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD85C4B86D4
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 12:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiBPLi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 06:38:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbiBPLi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 06:38:26 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFD71019C3
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 03:38:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpPI44Rq/rNQuR3NTIlDP+scP+/LSDEyGEweH2jhvFwRBMhiJjw+o/+xd2H7AU+8LQkAGNLJvBlgXQipQ0K3z9KIjNScPCaADrNIkuIMq8o06/8SKG8DXZ4q0gFigAI5MYSwIjs3qDw6CELSEqlreVnUildmMSaGpvYB2O6Mfzh9IbgMW56TQUb6ixnvPdYUWIlJcd44HtscL/K5vlLYN45wVNedawd5+ARvAfFUrYyGTFDJdSHNh2MwRPBo6Vnnl8GbRnroEkf8hxgGiPcZlP8NGdPvPAzLhjp9LYnCx4cZpunQL4BUoxH06GPj4Q5sjnrxTJdZQhrhyoes8pGkdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hP00kRIXi1JIWTrDdQBXpnykmKjxIJvEBB1KFRjxi8A=;
 b=fH39Wg8gEwhuVhEW+t7r5WZNft3ryTLfj41JcC7DFBND0Fnw+Nz5Lfy2QkLbVXpD0jY6qIJUGc0vuF9oLtWHTdQXz1XruVh26dOMK9Zq3tDZarIlHF/+p/tKsoWMiNvAvSsTEJIbMwtRwfm7zSQyhOBnODSTtY3VcGvymn9NYfRlFKit0KDrz//vUrd8WXeBlOAnxYOrqTXgNMxZeiXLZU9D0cg8uLv5/LBDm3tGdVUTMb4z6zYC7ccO/PCH1Pt3ItO0mV87PDtucg6C0DtlBrbcHPhtzWb3CI7J2r3bHP12y1Lvk+r2gpZZ7A+UB+hNm0vLWT9qc8arCJPS17JHxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hP00kRIXi1JIWTrDdQBXpnykmKjxIJvEBB1KFRjxi8A=;
 b=OXrx58SeErl1cmYxnGSaNbtuymOjyIWlz1pyBUnqJabj8qmG3BUZ4phPzABvTu9crrYkbiLjNC+8CS4no9q28LkbqWjF0zCDnnaIXIM6cZIx9pg5xZe+7EWyxrSEErJBIseiN02Nris/zMRDCJ1sXFtd4V4G6v5Qk9XEcKeAqBvyITGLl5P+wXefJQm/KrT6izV1jybtNzdbLqjmEaBPPkim9qr0okTFb3uOOIBpkLfn/frIQsnbX6AjAXhjEJNDdzwxcmiqHTMcvFj7dqwSEqM+O3tkzZTBfuVJqoo/dhMcaRiPwsaVk5leIOz06gZVFG28ncrz3al+w47/6xgUOQ==
Received: from MWHPR1401CA0004.namprd14.prod.outlook.com
 (2603:10b6:301:4b::14) by BY5PR12MB4179.namprd12.prod.outlook.com
 (2603:10b6:a03:211::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Wed, 16 Feb
 2022 11:38:12 +0000
Received: from CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::5d) by MWHPR1401CA0004.outlook.office365.com
 (2603:10b6:301:4b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Wed, 16 Feb 2022 11:38:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT057.mail.protection.outlook.com (10.13.174.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 16 Feb 2022 11:38:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Feb
 2022 11:38:12 +0000
Received: from [172.27.13.137] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 16 Feb 2022
 03:38:04 -0800
Message-ID: <001d6dbe-62ca-3922-08d0-fbee61066d60@nvidia.com>
Date:   Wed, 16 Feb 2022 13:38:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 net-next 07/11] net: bridge: switchdev: replay all VLAN
 groups
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
 <20220215170218.2032432-8-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220215170218.2032432-8-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5082d2de-d42e-4d4f-45dd-08d9f140d06b
X-MS-TrafficTypeDiagnostic: BY5PR12MB4179:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4179D047778FA86F1D0D6A01DF359@BY5PR12MB4179.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SgkzC7X7nw1nE9FJDkZkxagSZJo7qnp4LFcdq0wyLrYlZ+vTpYaZj8sbHFcnyYYKKOQy1v4iQOUWAFIWAkCFQt5yvB/R98gHy+OJsUgSCrNa7jSFnvBJuBgQ7ecTSSmx1/MP7LgU+DzvRkrIicooPcAEkM8UCy/Rft5ihA7c2t2Ao+anXBXuQxF1MjxVrnMQ+B/nwfNUH+YH0TG7W5d4efdcV8U2ui3Glx6bX7O1qHLnrQzouCjzTpfSq+/Sf6u5K3VzBbBcvwYfz+RFdzzEdd03e0DCD5GSJZ2J+gqeLQIt3/2r8MqzKGnEYqmWzMr0K74nvA2cRFrkyIm44vzY3Mrr1QES01q998IarIkNh621uEop8TiUcPaA6l5igXJHe1mREKjNZOogEDoFACo5e7jbr6M50pZzYDqFJ1+sC2YhUXvJ5PJ/vW6kVYz5DWo3TD5P2ZT/TfViNdNzmIFbJrtMX3MXVlIU57u0zpJdk8vBvx/32LkzERgjYjVKf7xLZWVIOU6Uv/dTfgzcLMUVm7elb4Fzs+asa+H30yQEJNhd8dQOJboK4IW6VDCd9zxX+XikwtTdEXPX8yKG9xFjQh172uQXguV1Z6LuYDIcqrQCEo8wdsvNBsRu8Mc8LJcYbTtmsQIaV7c/x3Oz6OoBruut1jM3M5CeC6p5PyfJNc8kei3PDaIXfTtGSlwv8/q4tr4Cy1IU0qK+VKWYbnlHFl4JOg72XU8C107aKJBZag3TzD/Mzap1G+HOpGDDE+fjBbmD1JraWQ/3EHbm91IiEwRAOQb1Cxmi4y55dlqhVwEnHjgGd1tsdLgOt889/abtUmMItzYc0nsQADGkG0SKsg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(82310400004)(36860700001)(40460700003)(47076005)(86362001)(966005)(426003)(6666004)(31696002)(336012)(2906002)(508600001)(2616005)(7416002)(5660300002)(83380400001)(53546011)(356005)(4326008)(8676002)(16526019)(16576012)(81166007)(70206006)(70586007)(186003)(316002)(26005)(8936002)(36756003)(110136005)(31686004)(54906003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 11:38:12.5434
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5082d2de-d42e-4d4f-45dd-08d9f140d06b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4179
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
> The major user of replayed switchdev objects is DSA, and so far it
> hasn't needed information about anything other than bridge port VLANs,
> so this is all that br_switchdev_vlan_replay() knows to handle.
> 
> DSA has managed to get by through replicating every VLAN addition on a
> user port such that the same VLAN is also added on all DSA and CPU
> ports, but there is a corner case where this does not work.
> 
> The mv88e6xxx DSA driver currently prints this error message as soon as
> the first port of a switch joins a bridge:
> 
> mv88e6085 0x0000000008b96000:00: port 0 failed to add a6:ef:77:c8:5f:3d vid 1 to fdb: -95
> 
> where a6:ef:77:c8:5f:3d vid 1 is a local FDB entry corresponding to the
> bridge MAC address in the default_pvid.
> 
> The -EOPNOTSUPP is returned by mv88e6xxx_port_db_load_purge() because it
> tries to map VID 1 to a FID (the ATU is indexed by FID not VID), but
> fails to do so. This is because ->port_fdb_add() is called before
> ->port_vlan_add() for VID 1.
> 
> The abridged timeline of the calls is:
> 
> br_add_if
> -> netdev_master_upper_dev_link
>    -> dsa_port_bridge_join
>       -> switchdev_bridge_port_offload
>          -> br_switchdev_vlan_replay (*)
>          -> br_switchdev_fdb_replay
>             -> mv88e6xxx_port_fdb_add
> -> nbp_vlan_init
>    -> nbp_vlan_add
>       -> mv88e6xxx_port_vlan_add
> 
> and the issue is that at the time of (*), the bridge port isn't in VID 1
> (nbp_vlan_init hasn't been called), therefore br_switchdev_vlan_replay()
> won't have anything to replay, therefore VID 1 won't be in the VTU by
> the time mv88e6xxx_port_fdb_add() is called.
> 
> This happens only when the first port of a switch joins. For further
> ports, the initial mv88e6xxx_port_vlan_add() is sufficient for VID 1 to
> be loaded in the VTU (which is switch-wide, not per port).
> 
> The problem is somewhat unique to mv88e6xxx by chance, because most
> other drivers offload an FDB entry by VID, so FDBs and VLANs can be
> added asynchronously with respect to each other, but addressing the
> issue at the bridge layer makes sense, since what mv88e6xxx requires
> isn't absurd.
> 
> To fix this problem, we need to recognize that it isn't the VLAN group
> of the port that we're interested in, but the VLAN group of the bridge
> itself (so it isn't a timing issue, but rather insufficient information
> being passed from switchdev to drivers).
> 
> As mentioned, currently nbp_switchdev_sync_objs() only calls
> br_switchdev_vlan_replay() for VLANs corresponding to the port, but the
> VLANs corresponding to the bridge itself, for local termination, also
> need to be replayed. In this case, VID 1 is not (yet) present in the
> port's VLAN group but is present in the bridge's VLAN group.
> 
> So to fix this bug, DSA is now obligated to explicitly handle VLANs
> pointing towards the bridge in order to "close this race" (which isn't
> really a race). As Tobias Waldekranz notices, this also implies that it
> must explicitly handle port VLANs on foreign interfaces, something that
> worked implicitly before:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220209213044.2353153-6-vladimir.oltean@nxp.com/#24735260
> 
> So in the end, br_switchdev_vlan_replay() must replay all VLANs from all
> VLAN groups: all the ports, and the bridge itself.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v2->v3: none
> v1->v2: patch is new, logically replaces the need for "net: bridge:
>         switchdev: replay VLANs present on the bridge device itself"
> 

LGTM

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
