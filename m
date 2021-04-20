Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A884B3653C0
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 10:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhDTILk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 04:11:40 -0400
Received: from mail-co1nam11on2048.outbound.protection.outlook.com ([40.107.220.48]:9281
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229543AbhDTILi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 04:11:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBi+XbAjc1H29utMHbcPi6rdhGLUqFGY9j62k/TvKza0Vj/wVVpd6+D+PvNqpJdtqS8CeTRYfx0S6YLTG7O8fXvfwv01Bfl+LRLTfBXvB5ggl389Y2AjPK6h98TrSbGwIGmSNPyhnDiYx/H7bLn2JCsT+JL+AgcmQ3DOVSxfW2I0vpsIqMQotF1g4CSquBxOMk0Fn7CPL+CkSsHq5aJqQi+HNU7rNSZavphOa5P/KPcbtgVYetueF5Txj0A3whVpmkMEB1dwkkRINrUdPoge/TyDmWDNXiGkF3aaqljWAuUNCMYfK0xf4Tv9RwtF53NqZmAYunu29DdkbMy7NI5yXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DST2vVqRTWVoGV1FBGKfizYwYX+t832y+BBqHCD+GVU=;
 b=fJL6Cg9gLT9nThc3hiUkPKmoVDV1ldyHHOVV5wp6huqYyGs/MjdvG5iT6FHlExzH9zUdnftP1/2keNIp+N7gRqmgP1ItPoYedQms/mQ6uoaajFxTmLIaGfHfJZTeBVy1iRZ5X81l+QJSecB0HcFfQdl+6IvBPLmxWh6ZTjFS8xl3gHwih490S3vcl1Q37tDzeW8QFsYXhPn6EJaTd2EtteSenYiJuJ8ORvoYzpYPuqSowrAl8xBt0mCwbc9GPpaa+qZ4AJZLeUV4qw3oFoWJrtuitzR8W3yvrBRYK5WwVY4wmHoZUdqhbFJZMywV6gYlmCv9+H8HSoX8rsOy552rLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DST2vVqRTWVoGV1FBGKfizYwYX+t832y+BBqHCD+GVU=;
 b=eOOGIN9oEPktbONpCRtAM9RcI57HEnQ9TqkviAd0OPDLAKMF1wJD6oYgKpWGYZ26Ts/z9m1Cim0roZaNYS1Xsh8O/CYEa2abb+6uApu2+2UzuhPu1UG9S0KloXcJ7AA0qcczxqIHpxEtwtgkOYnb3zhurCOTEOkjuJI66jmYPTq7Ugo+iVslFAh4YxA52HxvFUSZ61vHMkF8OMi4FjF7gSiwLiQ0jLiM7VB1dMxsGrSSO4uUz0H5tldZvAcuXy70fuETJAJGsQlTVyiUG9anLe0njA1kGxzd2Grwg0C+i7EiPUpJOFiVEhkoddLg/odLIzYAWxFrJbt3SHrSABCu+A==
Received: from DM6PR03CA0069.namprd03.prod.outlook.com (2603:10b6:5:100::46)
 by CH2PR12MB4246.namprd12.prod.outlook.com (2603:10b6:610:a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Tue, 20 Apr
 2021 08:11:05 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::85) by DM6PR03CA0069.outlook.office365.com
 (2603:10b6:5:100::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend
 Transport; Tue, 20 Apr 2021 08:11:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 08:11:05 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 08:11:04 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Apr 2021 08:11:03 +0000
Date:   Tue, 20 Apr 2021 08:11:00 +0000
From:   Jianbo Liu <jianbol@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <pablo@netfilter.org>,
        Roi Dayan <roid@nvidia.com>
Subject: Re: [PATCH net] net: flow_offload: Fix UBSAN invalid-load warning in
 tcf_block_unbind
Message-ID: <20210420081059.GA18290@vdi.nvidia.com>
References: <20210408074718.14331-1-jianbol@nvidia.com>
 <20210408141619.7dd765b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210409062555.GA1191@vdi.nvidia.com>
 <20210409090104.3e2a95e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210409090104.3e2a95e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 465286ad-1f42-45f6-2baa-08d903d3d847
X-MS-TrafficTypeDiagnostic: CH2PR12MB4246:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4246BC0A5E0B2D368F02D615C5489@CH2PR12MB4246.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NRKaeu/D5vq+ccWSAs8Se9Cm9W8uMuVlw1tb/SgUmWxY2uH3sr801rMbd99J4FwJBCQQaV3VVT+Tu9ioZrba1kj/RyZV3LP+Rx7MnDJOsFVV4bOIMIHmQ3Js94E6YpM0niArJ+R+qJiEsvZtwFQPumoiYtOFjLRf4kIi4zWkY3m5mha+iBGEntxdrGvNSlebPAEjHcoJ/V/EXQLU0110dnnc34mmXSC70WkykKBx7KF3VmmJPlygFHVQU6HCsBcbJiqGjXUr3aMeEiAIdNFDczCafOpp6s0a1SF1KGm9d85N4beevtYyPpqAcgHDpo78HoomcjEeMAj+4zf1Qqz4LK5baJ31MYkjAFkboKtSgJ1Gb7HKrkso6P6C17+DTJKdl4rPrk5Q6iswkZBgIq4wu6Zh0eX7sGmlLprKGuK0UucHyqp4C6YiEIK9RIqIelDJRp7ZY9emXdGdqtZcZzl34DUOVInls6epcPOmAOvaI+1JwdWV41Cwo4vQdREsoVuw0PT/G8EvAo4zzl+njgsmsmvrWARrJgzA8LGBZMsmBAM5q6cc0JhfEIWYVDCk4u+u1TZ1knKmT6tOFEQ1lIHLxMQXimtqkuhJxFqsOAB0p6CrmhNh5ElBDkeFiwflVb/nvlCfRkbMGQPCt3Fc0vLY9mgDbCUmDkM8kZ3a8oEMu3s=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(36840700001)(46966006)(86362001)(6916009)(54906003)(2906002)(7696005)(186003)(47076005)(478600001)(82740400003)(107886003)(316002)(55016002)(36906005)(26005)(5660300002)(33656002)(8936002)(4326008)(8676002)(70586007)(70206006)(36860700001)(83380400001)(336012)(7636003)(1076003)(82310400003)(426003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 08:11:05.0062
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 465286ad-1f42-45f6-2baa-08d903d3d847
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4246
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/09/2021 09:01, Jakub Kicinski wrote:
> On Fri, 9 Apr 2021 06:25:56 +0000 Jianbo Liu wrote:
> > The 04/08/2021 14:16, Jakub Kicinski wrote:
> > > On Thu, 8 Apr 2021 07:47:18 +0000 Jianbo Liu wrote:  
> > > > When device is removed, indirect block is unregisterd. As
> > > > bo->unlocked_driver_cb is not initialized, the following UBSAN is
> > > > triggered.
> > > > 
> > > > UBSAN: invalid-load in net/sched/cls_api.c:1496:10
> > > > load of value 6 is not a valid value for type '_Bool'
> > > > 
> > > > This patch fixes the warning by calling device's indr block bind
> > > > callback, and unlocked_driver_cb is assigned with correct value.
> > > > 
> > > > Fixes: 0fdcf78d5973 ("net: use flow_indr_dev_setup_offload()")
> > > > Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
> > > > Reviewed-by: Roi Dayan <roid@nvidia.com>  
> > > 
> > > It's been a while since I looked at this code but I don't understand
> > > what you're doing here.  
> > 
> > To fix the UBSAN warning in tcf_block_unbind. It's easily triggered when
> > netdev is removed before tunnel netdev.
> > 
> > > The init in tc_block_indr_cleanup() makes sense. What's the change to
> > > setup_cb achieving? Thanks.  
> > 
> > But unlocked_driver_cb of flow_block_offload is not initialized in init.
> > Calling setup_cb is to get the correct value from driver.
> 
> I'm trying to understand what became of this code :/ Was there no call
> with FLOW_BLOCK_UNBIND to the driver when driver was unregistering
> before your change?
> 

Gentle ping.
Should I need any change for this patch?

Thanks!


-- 
