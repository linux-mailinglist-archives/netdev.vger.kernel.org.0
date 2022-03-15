Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0984DA1AD
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 18:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350827AbiCOR4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 13:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350777AbiCOR4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 13:56:05 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5126F59397
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 10:54:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2p0mJSOzcogPFzlVmoAKx4TtWoz35OqdmQdnClkQCfslO/A0Bo+pU2ZdJBz6SLEPaOjJySvAPJjQOaraedSA31AMQ9kTmvZD8+o4X7EBExmfuB4Now6H5tRc3OjsePlUAsnP7GY/eBvjJHWCW07QRYVJYpOYlXE2K0/SYHoaP+tUTNdmlyFFrfnPSLf/BE3qExzmbf/kW7vWi52N4dzoIzjvLpYsJI/7sxFeazhtMAMOsNWb0MXjXibTZjgE0iTGdrZGeBEyVgjvePRseMaux8obAj3ZRAg/CN0gmKJ2LEreXmZbCDnxYqnW/V0WAtJNK/d0e/n3XMtfgOAdvxD0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BzHY54qOxEv7X16jkNEDWCjuErQ9i57sSdbw5Iaynsg=;
 b=OuI/xhZa01hKHJ/LBwWHA4MDFHhIxcaaRTfQ+37xF/62B9RPOIscM80cwBWnSUAetjtuYbwH1Pb+rUu+r9FsZxdi1DWY6LEVHKZnA0xl9zptMkUJPT4ykHJalOWU3u591zpRndRCKVaTan8Abmfk/0sHnCxU5PG3tikKhF8wGCn2khuUQfHDYJASmesNNhrjahLLQjTw2HTGlGy/GdPtlyPgTe+PKgWVwM8Q69bpzdBVEKF57P6YhItpY9fcwvJGpH0CH1F8vabW4aCzWCtLMiYLE+WpH8G2XOtlYO0R+PyopCuQbuiztBa5hg3ro24b2srVRr+wjWGZyb9hbPFPKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BzHY54qOxEv7X16jkNEDWCjuErQ9i57sSdbw5Iaynsg=;
 b=k9DxI1ThUVv+usOqreVWktB0dSgxQ1SxzB6fFiUVaa3XCtIN+HP/tUzu9Pj6Y5E87b7imOFdwIxViLWFJ0Y8kWAPGJbNgwlTiFKHN7pHByKKRQsZwVu7bc6bZtR3tqj2j03bhnNGt4IBwo7Yn/mMF4VnOFyOn4B43cYEKEJkyHl4cN/yMtEHtBh8MYEVFxkUOI7bluZgaBmOwLCutNFad0wwXIrr8ReDwGKViW/CI8P+OjMOnnwbRI/lX7wBuTUZMk/FqM5Flb1HFh1TJLuVYKj/YfoNAGnHFTsN9J88jay+pFbHA2+UTrIQQFTrS1G7UWjp6feuHiwwPySCe+XJLA==
Received: from BN1PR13CA0030.namprd13.prod.outlook.com (2603:10b6:408:e2::35)
 by BN8PR12MB3603.namprd12.prod.outlook.com (2603:10b6:408:4a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 17:54:50 +0000
Received: from BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::5a) by BN1PR13CA0030.outlook.office365.com
 (2603:10b6:408:e2::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.13 via Frontend
 Transport; Tue, 15 Mar 2022 17:54:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT006.mail.protection.outlook.com (10.13.177.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Tue, 15 Mar 2022 17:54:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar
 2022 17:54:48 +0000
Received: from localhost (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 15 Mar
 2022 10:54:47 -0700
Date:   Tue, 15 Mar 2022 19:54:44 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Ido Schimmel <idosch@idosch.org>, <idosch@nvidia.com>,
        <petrm@nvidia.com>, <simon.horman@corigine.com>,
        <netdev@vger.kernel.org>, <jiri@resnulli.us>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [RFT net-next 0/6] devlink: expose instance locking and simplify
 port splitting
Message-ID: <YjDS5P/qCR0krMYI@unreal>
References: <20220310001632.470337-1-kuba@kernel.org>
 <Yim9aIeF8oHG59tG@shredder>
 <Yipp3sQewk9y0RVP@shredder>
 <20220314114645.5708bf90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YjBCs/uc+djgQRgH@unreal>
 <20220315085829.51d2fd5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220315085829.51d2fd5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f87adf6e-9a45-4dc4-5413-08da06ace721
X-MS-TrafficTypeDiagnostic: BN8PR12MB3603:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB360338ECBE7511C74675AD69BD109@BN8PR12MB3603.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +IWU9rcLSXw05f+jY7JneSYRFxBJECXCuxz9ETX238sg4oDXrN0E7VgvPq8hlT5WRBjihBSlMevZgDJKt7RVo5bXpeTinFNayHXqfX1xhL9cufwfhES6juN6oPmtX7tmtYK0jWFyKFkNIdeL3U2u6Y9WD2UUHCqNwk6nDnsXdr5Z93PJi2r5ZpNDA8e4Q+O/BK8Kj7Guq+WunYYFshILk4KVBcjBVngs458F3KBgnEQWbA/zQVjYXlIMChCm5EpBOV8qH57tp2TDHah+kbQ0++yP1cJ5USvYNRVXB41CNFnfalHHUcRxgTGBLC4PMXiA6jY9+O7fFYAn0MJKrtLpO5oRlVNo8tMT2O6y+uG43klcQzlPG73WLJ8ipAFyUu59rLqyc78xXIgjg6jfUkXj+fHaGMQz635Sw/P8H+H5GoOTy5RS41gmpjV6VH/1Zz56bp8Ltk9Z6Pkh40f8x8FOL2mEEwTVBmt7iDs7+KfRWWimMUPBUnby1USCcHiysqJvPApftbZm6V4GfAF8I/aV4DYnfyfeMNaSrm9VdyHCFu6xIvQJAGEZupAIr5kT680pBAN7Q58kTTiPkt131X0jIPrXWgJJV4aKvq7ak9AZwG/ciOjmpl08SeIxAqy1TzutG2nlGGapfSG21APqTuDSIZtSilW8/FDpwYQTHSIULmBOuj4Ywy4viJJeLo/xw67V7LDUVCBQdWSJv8C944teKw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(7916004)(46966006)(36840700001)(40470700004)(8936002)(5660300002)(6666004)(186003)(16526019)(426003)(82310400004)(336012)(26005)(9686003)(83380400001)(36860700001)(4326008)(8676002)(2906002)(47076005)(70206006)(70586007)(33716001)(86362001)(81166007)(356005)(40460700003)(316002)(508600001)(6916009)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 17:54:50.6334
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f87adf6e-9a45-4dc4-5413-08da06ace721
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3603
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 08:58:29AM -0700, Jakub Kicinski wrote:
> On Tue, 15 Mar 2022 09:39:31 +0200 Leon Romanovsky wrote:
> > > I have the eswitch mode conversion patches almost ready with the
> > > "almost" being mlx5.   
> > 
> > I wonder why do you need to change eswitch locking in mlx5?
> 
> I want DEVLINK_CMD_ESWITCH_SET to drop the DEVLINK_NL_FLAG_NO_LOCK
> marking.

+1

> 
> Other drivers are rather simple in terms of locking (bnxt, nfp,
> netdevsim) and I can replace driver locking completely with a few 
> minor changes. Other drivers have no locking (insert cry/laugh emoji).

I saw it too :)

> 
> mlx5 has layers and multiple locks, 

I would say that mlx5 has too many locks.

> if you're okay with devl_unlock() / devl_lock() inside the callback that's perfect for me.

The need of DEVLINK_NL_FLAG_NO_LOCK for eswitch is because of
questionable locking in devlink_rate_*() calls. 

If you success to remove mutex_lock from devlink_rate_nodes_check()
and devlink_rate_nodes_destroy(), you won't need devl_unlock/devl_lock
for eswitch.

Right now, the eswitch set flow doesn't suffer from races and/or other
bugs, just because of global devlink_mutex that protects unlocked parts
of devlink_nl_cmd_eswitch_set_doit().

Thanks
