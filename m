Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEE544CAF2
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 22:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbhKJVIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 16:08:52 -0500
Received: from mail-co1nam11on2065.outbound.protection.outlook.com ([40.107.220.65]:8928
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233176AbhKJVIv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 16:08:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jsj0A8VvodnnMPckZSZy2c0rxfe5WT0Gv/2xBz/1swljKi4EqhoDWqx90B4fsSsk6efMqUB+ZYKcdOihxqHMpngbrI7kex7qzxMYz8D8WOpq/+QnfISi3ENmFz6qeLW9NWmAmrLul4an2mlbS4krb1vLfGkWqrUqCZv0KV7v7iZ7AQXaFaWvuonv6AbkgWr3/X7C47gDqW9sevKQIPEeD+FrvmKAVSH62nzBEh5hCPKBkFiqqhpFHSiPEKgnR4wfkE/EclnJXrYBSVVeB+UkxXfaIx8DqMei/KTnztT8/1Pt+inLT3TY2KkHGABqNKmdPXG3T4j2hqmaMHLHFFYuSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qRjGRqq4kbQW+apXd+ghheDDBImx7zD5nXMgw6e8IEY=;
 b=SXMD93+8rVNwIKBOwn8YvKsfnKq77CZ+hoXQjjo7wHTOFhcVq73oOx/diBNGRPjnB2ggKLXOGe24EnGBYBIN7LFBjMf8dlWH0nvrhJL4Frho4fvRT6xGFn3dmPNL1WP3L6TvIxdzvwKuu6zF8SxT/j3IX/re64GQL+fkYUCFPOAwrNkMz+ghnqbF8DDZRyvEJBYq/Gc1TU5qBMtzoS9ApDK5unCWgeIIZVtM1RNt8cyipPw5MYxbailtJ6QViw6oS+hWzyntJPrIlRZNv5dMhqQ+FN5M8BxZBtQJeDScO9+KkPHyEk7rn+fm1/eMtkz8Ar4HYFx7KqYmeoehvnk1jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRjGRqq4kbQW+apXd+ghheDDBImx7zD5nXMgw6e8IEY=;
 b=mq0E84oeG/LndZVoHJo/cozZlMiaiMY5PMRISk10ii106RyE3ajHU/vKX1ZbWT8VJU4frdTILTLW/8WVIEHBg2it0NCed99LTxQcanMidY9xcOkDkksKKZH+HckwyLNRaEPyo73z2yupBfIwfib4rjZ8mrxMCTnBbpNE1QXJAydOYl4FaLEiUxxmogZlLaFvakXgDhcuYaAixuxiq/wB1iVT/t07Tz5AlWEwrskIsgRyowIggrKWi2EiYFOSGt7zU8gpPczLd6AIbnLvjdbX3xWEr+2xWHJj1h5vXZSoDfuDhpm9oHH+L/vJByK95GCT1d4x77KPGmYwvF558Oz6wQ==
Received: from DS7PR03CA0295.namprd03.prod.outlook.com (2603:10b6:5:3ad::30)
 by CO6PR12MB5426.namprd12.prod.outlook.com (2603:10b6:5:35d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16; Wed, 10 Nov
 2021 21:06:02 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::33) by DS7PR03CA0295.outlook.office365.com
 (2603:10b6:5:3ad::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend
 Transport; Wed, 10 Nov 2021 21:06:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Wed, 10 Nov 2021 21:06:01 +0000
Received: from yaviefel (172.20.187.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 10 Nov 2021 21:05:56
 +0000
References: <20211105205331.2024623-1-maciej.machnikowski@intel.com>
 <20211105205331.2024623-7-maciej.machnikowski@intel.com>
 <87r1bqcyto.fsf@nvidia.com>
 <MW5PR11MB5812B0A4E6227C6896AC12B5EA929@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87mtmdcrf2.fsf@nvidia.com>
 <MW5PR11MB5812D4A8419C37FE9C890D3AEA929@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87bl2scnly.fsf@nvidia.com>
 <MW5PR11MB5812034EA5FC331FA5A2D37CEA939@MW5PR11MB5812.namprd11.prod.outlook.com>
 <874k8kca9t.fsf@nvidia.com>
 <MW5PR11MB5812757CFF0ACED1D9CFC5A2EA939@MW5PR11MB5812.namprd11.prod.outlook.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
CC:     Petr Machata <petrm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
 interfaces
In-Reply-To: <MW5PR11MB5812757CFF0ACED1D9CFC5A2EA939@MW5PR11MB5812.namprd11.prod.outlook.com>
Date:   Wed, 10 Nov 2021 22:05:54 +0100
Message-ID: <87y25vbu19.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36b897ce-cdd6-4108-f597-08d9a48de6a3
X-MS-TrafficTypeDiagnostic: CO6PR12MB5426:
X-Microsoft-Antispam-PRVS: <CO6PR12MB54262EC3D8A53F0F69D16E1CD6939@CO6PR12MB5426.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ujQLE/jpTvKxCuNYuy7Ae30RKUD5LehO5N/d+tDaR20yOzbvKM15wXapkdukyLQIxkFXXdz0OXAJ2K+WHfzDAs0nf/RvVQBokOg1OTjI1Tbbe4Cs0PJVqxR7EX2SsZv+5EgtkSGCHraVYBCaC9bsSxMzBWqvL+ERdDa4IjDAYhqn8EH5hJVAHwlc1co6ygfL2twEzrg7qfCQYJFSKI4AIneOHKBnZYnPswEaiSGNUUFuaeMMKWnES8P0cVuf6CypaeqaUD52aCVw7h45dyXmgxbkgZV3qctQQnmBW9J66UlYuZOqkUJd1qYAWZ7rBWu+7RaDuUor446FXOMyPm1PX6C3ft4zJC2H5yVMSVk1g8+Wk3iydhKsCcpGthzAX3Q/uMeposFgEsvmh90lUWlQqkBFrRxlRVSQ8j2rUbZ/wAcOsKtHTpQehNxQS/whoH9SE+pd3NTcaW15iehzWzE6yDSbnEU9aE/jnV0QgUj+dcQoxZ9++fgS3ahyA4PCsB/mag5unnB4FygaSy8/IFpopr80w07HJ4E1uy6HPlKjiEllssl9iFG2Vbp01we/M1xKYnKyUsPwR2M6VEjGU5tpt9acf0Rqa82qO9JKesaVc7/chY71/0zD8FaGRMvV/6gJiYtzhlYqZAKh7pccejAxxy/3LExu5y0PlksdGnR5CxHiRXl5GmdIO4kt1N9B7JCxRx8+Lx0PAmalhC6CmS1nQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(6916009)(83380400001)(7636003)(186003)(356005)(508600001)(4326008)(16526019)(2616005)(70206006)(47076005)(86362001)(70586007)(336012)(7416002)(426003)(2906002)(54906003)(316002)(26005)(5660300002)(8676002)(36756003)(36860700001)(82310400003)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 21:06:01.5395
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b897ce-cdd6-4108-f597-08d9a48de6a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5426
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:

>> >> Wait, so how do I do failover? Which of the set pins in primary and
>> >> which is backup? Should the backup be sticky, i.e. do primary and backup
>> >> switch roles after primary goes into holdover? It looks like there are a
>> >> number of policy decisions that would be best served by a userspace
>> >> tool.
>> >
>> > The clock priority is configured in the SEC/EEC/DPLL. Recovered clock API
>> > only configures the redirections (aka. Which clocks will be available to the
>> > DPLL as references). In some DPLLs the fallback is automatic as long as
>> > secondary clock is available when the primary goes away. Userspace tool
>> > can preconfigure that before the failure occurs.
>> 
>> OK, I see. It looks like this priority list implies which pins need to
>> be enabled. That makes the netdev interface redundant.
>
> Netdev owns the PHY, so it needs to enable/disable clock from a given
> port/lane - other than that it's EECs task. Technically - those subsystems
> are separate.

So why is the UAPI conflating the two?

>> As a user, say I know the signal coming from swp1 is freqency-locked.
>> How can I instruct the switch ASIC to propagate that signal to the other
>> ports? Well, I go through swp2..swpN, and issue RTM_SETRCLKSTATE or
>> whatever, with flags indicating I set up tracking, and pin number...
>> what exactly? How do I know which pin carries clock recovered from swp1?
>
> You send the RTM_SETRCLKSTATE to the port that has the best reference
> clock available.
> If you want to know which pin carries the clock you simply send the
> RTM_GETRCLKSTATE and it'll return the list of possible outputs with the flags
> saying which of them are enabled (see the newer revision)

As a user I would really prefer to have a pin reference reported
somewhere at the netdev / phy / somewhere. Similarly to how a netdev can
reference a PHC. But whatever, I won't split hairs over this, this is
acutally one aspect that is easy to add later.

>> >> > More advanced functionality will be grown organically, as I also have
>> >> > a limited view of SyncE and am not expert on switches.
>> >>
>> >> We are growing it organically _right now_. I am strongly advocating an
>> >> organic growth in the direction of a first-class DPLL object.
>> >
>> > If it helps - I can separate the PHY RCLK control patches and leave EEC state
>> > under review
>> 
>> Not sure what you mean by that.
>
> Commit RTM_GETRCLKSTATE and RTM_SETRCLKSTATE now, wait with 
> RTM_GETEECSTATE  till we clarify further direction of the DPLL subsystem

It's not just state though. There is another oddity that I am not sure
is intentional. The proposed UAPI allows me to set up fairly general
frequency bridging. In a device with a bunch of ports, it would allow me
to set up, say, swp1 to track RCLK from swp2, then swp3 from swp4, etc.
But what will be the EEC state in that case?
