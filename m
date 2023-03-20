Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E9A6C1409
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 14:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjCTNyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 09:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjCTNyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 09:54:15 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2070.outbound.protection.outlook.com [40.107.212.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB6B526E
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 06:54:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Swi10aGD1uUVfmc9eMIVGbRlev6Ywr+vlHkAaN8gEgFhNkA1od7dlSHbYkbvq1WUmaWBhX/HdUI/p9DKRZvwFWZU18glTShlYR4E5ShexBZkgVnjJ633Ae/U29kd63etA0ZNUN0c+09zGDehDTTV6O/lEz05GmgTviL1tXjQGeKjZR6klWQA6JXbQBBN1yZliD89cuwZthpG6MFd+g7rUYp5E93wjMMDPD6bzVEZyyOAX4cm4QBApY+81Ox+JLenD+wcmlcnOXh/14u1axg+ik+NwDSVmivNLTH1jZc9yRzbgo7Lv+oyHM6V0UQukft1CwToxmCrI6aVzdF4PUTqgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KTtdljvPbvMqwXiSNOLGgNVaZJanlZfb8T/EsmM/nHs=;
 b=Q5NMwjpnwnFl495fKKDCHA5H+DYQAh6g1by3DxV4GCGBYiX6HXLeA8CVEbH4yfpPwaaByjx0957jVFbLHbC+fzIl+NGZQeeOAI6Fd1Xkkud39HyYnoViOpSe8jxfMa3XXgNJtggu07q8dJT6zmxondUtgxxomoY9wuaXoA2RkQdnT67lJ649pRSYY6pFSTFYWhrVIDjaylBGjCcsJ0LnMIY49yfWiBN4oMD6CfFeT8RNWMLxZjMjTLld/4Gkn2fK28AXh9kPTYb8s73PSqvIEZkb6uk3aEII/C0rsRtRbToe8hJtk8YHuqPc82TZ4EWqjyCFlvBVqYtfr1FqDBTDYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTtdljvPbvMqwXiSNOLGgNVaZJanlZfb8T/EsmM/nHs=;
 b=D+e96Z7eEVqGgtbubHAKT2FVREsrshalX1jNE5ljl9baJwQ63YzZMOt4wqqUOw20cXunPINpaxKXV86x1+XjCOdHTxuW3uDwM+IsXfW+4NitaP7e6OvOg30t6Pnvw62ONYzDeVl9wuH4qUPf+2YKCT4KSDxZ5vxDzhKSHWQ0ljj1oR8mUhILcz6O+Tg4QWDleX/pQaaSaLDNx6R/42pgJ8OBr783ApemDq7vxIwOHBmzzfCac71q8jBTaKI0YZWJSJt8tJmdkk6QXNV7IlhvCRT7daQNXGPkHTfHxnDgFWEZmxDaGb66DqQaMJ+kBm2TgDAJBbGftUTapwNse4nHjw==
Received: from CY5PR15CA0195.namprd15.prod.outlook.com (2603:10b6:930:82::11)
 by IA0PR12MB8349.namprd12.prod.outlook.com (2603:10b6:208:407::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 13:54:10 +0000
Received: from CY4PEPF0000C965.namprd02.prod.outlook.com
 (2603:10b6:930:82:cafe::8) by CY5PR15CA0195.outlook.office365.com
 (2603:10b6:930:82::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Mon, 20 Mar 2023 13:54:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000C965.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Mon, 20 Mar 2023 13:54:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 20 Mar 2023
 06:53:56 -0700
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 20 Mar
 2023 06:53:54 -0700
References: <20230210221243.228932-1-vladimir.oltean@nxp.com>
 <873579ddv0.fsf@nvidia.com> <20230213113907.j5t5zldlwea3mh7d@skbuf>
 <87sff8bgkm.fsf@nvidia.com> <87y1nxq7dk.fsf@nvidia.com>
 <87ttykreky.fsf@nvidia.com> <871qlnqt7k.fsf@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        <netdev@vger.kernel.org>, Danielle Ratson <danieller@nvidia.com>
Subject: Re: [RFC PATCH net-next] selftests: forwarding: add a test for MAC
 Merge layer
Date:   Mon, 20 Mar 2023 14:49:37 +0100
In-Reply-To: <871qlnqt7k.fsf@nvidia.com>
Message-ID: <87jzzbplzk.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C965:EE_|IA0PR12MB8349:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c8da1f3-78db-47ae-b729-08db294a9482
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EdcFp3BkqNBy4sWZySVqzfe2dmeigqUrghJ74rZuqA4xKHeZtZwW8KBTJwBpzqIfPx6Nva1BfnGnCewCLEQ9sDg1OdH9OK56PW/RzjjMGB1mpFU8jM3yZvPCgYLw51AnkSePp7KYp5YhYnu99hxwBL1bXwnm1LFyZPr1hr7HE/+ssjCtiq32vmAurBWg9nMXcqzjoSZcxKNlHApVShnMoXDSePE3eOUpD5gmlimzlckd4R7E4R1nvKTPWXcBkeXFXGa8Z+hBeQJ8yNxOuOaU7au6P1Y+Q9SBHgdkE0zFMx1RytwyvIK0CtCqb5cB1wegiypIjNu+yk7760aqlCfg3qFiG96LCiaX4ktm0sAA3leCsC2bLlJrmt02I652q16eOe1CLkQa/TKjNA2SfiO40tNepySrGVi4TUlqK5nE3nnJ6eX0AcDYzrnSgknNs/4J6wIjB7hX7TmZ971DnHmHJoJvJuFQw08gTZeE+U1y+q8GrxyDk1NJSOX9Zxy5mCpWnfDg5TOAPpFarUqYfcNx/k6fyvHbmCS6CodKs7duK7ouSu3TD+xciqlc+7tIa54Boxh6cKKSlQbk9fOLMyB/4nPwRD7UtvIVh9e6YynrTyFl2MGYpcvl1UunudRm5fUv8orrlM6YCwG4IBtPK91KJO8O9puU/7oO7I/r1UmYsoXaRGFJWL1HAF4Fi5bbJ0GCon08AIdmDRWFO12kImt5/ufrEWcIsSYzqLSzt5nthJoY3QdesE0wf2Bc6+zbV9K7+izcRLFWRkmx6+nwkVN/rJvWJaqGQODTCBciUdtk7UY=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199018)(40470700004)(46966006)(36840700001)(2616005)(966005)(426003)(47076005)(478600001)(83380400001)(107886003)(6666004)(336012)(37006003)(316002)(8676002)(70206006)(70586007)(186003)(16526019)(26005)(54906003)(66899018)(4326008)(6862004)(36860700001)(4744005)(41300700001)(5660300002)(8936002)(6200100001)(82740400003)(2906002)(7636003)(40460700003)(82310400005)(356005)(40480700001)(36756003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 13:54:09.7407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c8da1f3-78db-47ae-b729-08db294a9482
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C965.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8349
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@nvidia.com> writes:

> Petr Machata <petrm@nvidia.com> writes:
>
>> I added a shim as shown below. Comments welcome. Your patch then needs a
>> bit of adaptation, plus I've dropped all the now-useless imports of
>> qos_lib.sh. I'll pass this through our regression, and if nothing
>> explodes, I'll point you at a branch tomorrow, and you can make the two
>> patches a part of your larger patchset?
>
> (I only pushed this to our regression today. The patches are the top two
> ones here:
>
>     https://github.com/pmachata/linux_mlxsw/commits/petrm_selftests_bail_on_lldpad_move
>
> I'll let you know on Monday whether anything exploded in regression.)

Nothing _relevant_ seems to have exploded :)

I've pushed a new version of the patches with Danielle's (CC'd) R-b tags
and a fix of a typo that she noticed. Feel free to take these and
integrate / adjust / etc.
