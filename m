Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4F35BFEC9
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiIUNQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiIUNQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:16:27 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921EB89CE4;
        Wed, 21 Sep 2022 06:16:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0WV4QtoQgzMQ48GTuPNaqJZSY+ITqySOzoE/DwaLfiOE+st/CXvGmUlPJ16xn/5xWC2whw+ih4k/znbj3Lt/ZOJ6Lvv9RkMu0vFggA8ebMhM883hx4oqXvJyFlKjJldrSnLJVvtpLWWWUyzkBBMXk3mo+oTwcDnCgX+Ld+PScBtqw3X8fCy1NyfHW1SI+Qsu0fcOeRX6tlDkGGIJt3dXCtnNEQ/SvWLP7P0+uNWvJF2m+hu+1egnTO1JuFBjtXu7vZ0/S49R1vS0uA5UnkcZ0c93LUs3hlL7IHtC0KKflD85y1wrGHrbVbCaDRw+duTmNhME+C2ODrpjDGejawUBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l8S/xByeINJJUtPVqs0wChkgHaGk8OwQabKE2abeLHo=;
 b=btJHN00qwF6eP7ba1h7fZm6WDpkr2vt6F84ywtBjjE24PCW0FzcCKq4T2wH6wpqLnEKKAhifPwMuCM6+pP9euRq/qhou6OcMI0wghMVmjkPahDJZtkskAqV6kh8J7KpwCrBBHV6INl6u4juKRmh6ga/1x51UXPai9UlxqsLIQ06DoZXhjws+pS8ExNyZd+sT22ZOB4kOWdaXVAH8oGILBXB4T3MhFd6xGOnI0dtJVFczc+Ghr1eHP4vfUD7vV/0E5Bj/RlN1Rb5dkcvE3cqzb0DZf3OCuq+6rX2ngHoRQC3WvuygThOV70Inlv/VjxmElu5wDls2lopumHnqDogKzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8S/xByeINJJUtPVqs0wChkgHaGk8OwQabKE2abeLHo=;
 b=DUPRtohCUCVUtG6hOilZQRCF7kYFDjNrZSGmJhetxC3iQFMIjYlfTygCmB6XQEvsCdGMktUw40yndzhPVAUaJvPSB+b4rhhqs+I14vAONOhaHgXIKNzs5H0Xodd6eI2ZUFeH8B97h5mSEq4gRqa7cMXl6AaEcg/0ytYgpVhfkN8hBHTtcAOTctBy4wwE8FjzQ7mkijvpQuCjP23JbkiWhCpONVBUC9U5aEPloiiRIGhbqE+JTRbjLoy+uhA4Zk72dQCqgPc2ECi2O8aHw3/iGmIaXHvVFzeKW6LWQLlGwkm6SzjvSbhYtRAlF3A4tPisNVeOCNCNhZphSV3ue2nEkw==
Received: from DS7PR03CA0100.namprd03.prod.outlook.com (2603:10b6:5:3b7::15)
 by DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Wed, 21 Sep
 2022 13:16:22 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::1d) by DS7PR03CA0100.outlook.office365.com
 (2603:10b6:5:3b7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16 via Frontend
 Transport; Wed, 21 Sep 2022 13:16:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.14 via Frontend Transport; Wed, 21 Sep 2022 13:16:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 21 Sep
 2022 06:16:12 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 21 Sep
 2022 06:16:07 -0700
References: <20220921090455.752011-1-cuigaosheng1@huawei.com>
 <20220921090455.752011-2-cuigaosheng1@huawei.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
CC:     <idosch@nvidia.com>, <petrm@nvidia.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <nbd@nbd.name>, <lorenzo@kernel.org>, <ryder.lee@mediatek.com>,
        <shayne.chen@mediatek.com>, <sean.wang@mediatek.com>,
        <kvalo@kernel.org>, <matthias.bgg@gmail.com>, <amcohen@nvidia.com>,
        <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH 1/5] mlxsw: reg: Remove unused inline function
 mlxsw_reg_sftr2_pack()
Date:   Wed, 21 Sep 2022 15:15:43 +0200
In-Reply-To: <20220921090455.752011-2-cuigaosheng1@huawei.com>
Message-ID: <875yhgyijv.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT027:EE_|DS7PR12MB6263:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ef6d7fd-4c35-4d72-764f-08da9bd37aaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4QqDn2M83GMRBdt/gNhxPEFbm8bOfu+l5ep6vveHx+bNPtevDRt5RNT0VhdRwE/s1hZg8h4dV/MUmvsn2DiaOPPB9q7NzS7NjHo3yqAmL71H93sIaFqK7qbwFVEfAN4nZRjSvODJOjU9MKjwbpC3GxMOe8wYawsRKeTT1WkJ83pPeL9G6HacHP8dBV1MXMf0fHAk3Wh2GVZ2B1BlR87w3tF3RV7prbNzHmmuhyj/2WXiKkujxPhooDoCcwekUNIONRVOJrLAm9NZBTwBnVzXSV6Jxm0mMN0wKBO/ZeOhE5ZYaNK7l1e8vCcodippmUpPRtoEbt0CEe+Xv//vAOsN999vc49D4B2L6YAm6BJ2+XwBm2yxlnFfUy6qSxrxf3JjvA2tAAj4JDlZWrE1ljIH/Gv8e5YcFWBdY/Vdqt0iITlfOBqU3ha2jwJHxREN1MucJz7+EfJ/Ii2Ll/WzaG2ZDZCy+BzTd+GGTfuw2nS2LnrDO8/QRa+EvhnPFkMk9D+3TATeL/APK6sTreORIfgjqE9IBQnVVUf6Ua3ljaollFrVQLyF3vy81Zh2I5mxLbDymbocPkhxca1iTkQNVP/wIRafPXkytEEay2rzFYPxYQMFKS5TiK4Z55jSnopvGxtDjVU9qhqurwONfKkHDmMaKEa9vK71kh054AP+WLOYPY6iHcDDkM8H9HGFRRL1NNQ5kA13PTXSLythOC+rtoGrT4/FucDeg8DJuA1Ig1tUwnWc5ymeEPIGfp2Zn1EpgECukhZtPRlzxk0vY7sZAp3Dmg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(136003)(346002)(451199015)(40470700004)(36840700001)(46966006)(426003)(336012)(82310400005)(186003)(7416002)(8676002)(70586007)(5660300002)(26005)(70206006)(2906002)(316002)(82740400003)(36860700001)(2616005)(41300700001)(6916009)(478600001)(36756003)(558084003)(40480700001)(7636003)(356005)(6666004)(86362001)(40460700003)(47076005)(16526019)(54906003)(8936002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 13:16:22.3336
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef6d7fd-4c35-4d72-764f-08da9bd37aaa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6263
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Gaosheng Cui <cuigaosheng1@huawei.com> writes:

> All uses of mlxsw_reg_sftr2_pack() have
> been removed since commit 77b7f83d5c25 ("mlxsw: Enable unified
> bridge model"), so remove it.
>
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>
