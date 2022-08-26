Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A7E5A2BE6
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 18:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240660AbiHZQEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 12:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiHZQEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 12:04:12 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1499BD41AB;
        Fri, 26 Aug 2022 09:04:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjbYo3Ge303vOM3LKpn8r9Z33hwVkjBIl1WkG82zNRejreQPcfJI4e7pZ2vhzdGR8ZLPYHd9bKZ7baO4iHmyP7S3WgfcEwn5UmlXbqJ8/dMhze3gLTEWmjOZnIMIzpNy2Joe6XTWcOg2977seel35x/0bllG5fURd7O+Jp1yXk5P+IQoMD/44n1uiFwl1keKZczKl/+TonDnPzIzeH4/RyzUXcVOtuzkaT+PgVBlu4PEqMvZGw/DOpslcbDY2seIysCZdJl1Mfo+RWwYhlX0pwQissELH2JyxcZaio4GyOHk/gcgirxIv/kxPbfQg+qc0ekGup44qusPhUCLZKgiOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pa7N55Z4cMr2yGVckk89mK79Y4Vn0IbYGFnnTN4bPB8=;
 b=O4cdAJBZxIu3lEPEZcO2TR6HpcOOSftZpFa1J808kKT49RUElORZ3l8dnxZFF70+D5HnDgFt3fnkew8awgQf5wY68m3SJfX8t/JdkTmnmoEpR2lZhlu/3Kk0e5kxXTdRa6v/hOysNr2OxJRWWCnmmv/sM49hryMOV90LCdVVelyQXc1UxsdqRZq+WDoOayM8NBxgO/vNzF5mYSa/TqGt24By9g1mveE6M7X/t0+OhwSek7smRGshBuSp9h1iAy6Lnecjr0YmJDmIELfn2ZQwB/3s5W0n90zJdVNETUHRzo6vBuCUVBEzi96nuEMrQqcZ2PcZuW+9h9kVprfD9dMSYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pa7N55Z4cMr2yGVckk89mK79Y4Vn0IbYGFnnTN4bPB8=;
 b=iQRXt1Egv5icgNpL5Pi+z1bXkIca5Hd9WFu+opSRy6rnCIrKHM1u9Nvok24xM3oW5AbQQIdb6axHELKnkf8ydnxKMe4zz42T9SmHDaU8JTH2BxNWVZOsdSiH3pV6w6als46a8CJcdvAUXQklp0na77Mgx3JcGB6uA/I8Re16SvQZ9oVqJ3l42e+cqMDgSRYnoM7oKDLa4wrDD1bDX1t72R/E2lkCLiDzvqBkUyi/p9nj+dFxGJygEpkGJHSXQNwICava1KHZ85+cviaEL4bwKGiqb9zDWXjDBGIK6YIIX8P7DeKqBwNp8Pa4XvV4cnVSuaINRcWPH+cTx+6/mjNfbA==
Received: from BN9PR03CA0580.namprd03.prod.outlook.com (2603:10b6:408:10d::15)
 by SN1PR12MB2397.namprd12.prod.outlook.com (2603:10b6:802:27::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Fri, 26 Aug
 2022 16:04:10 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::a0) by BN9PR03CA0580.outlook.office365.com
 (2603:10b6:408:10d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Fri, 26 Aug 2022 16:04:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Fri, 26 Aug 2022 16:04:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 26 Aug
 2022 16:04:09 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 26 Aug
 2022 09:04:05 -0700
References: <YwjgwoJ3M7Kdq9VK@kili>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Ido Schimmel <idosch@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net-next] mlxsw: minimal: Return -ENOMEM on allocation
 failure
Date:   Fri, 26 Aug 2022 18:02:12 +0200
In-Reply-To: <YwjgwoJ3M7Kdq9VK@kili>
Message-ID: <87pmgnhtzh.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 825aa730-ffeb-4864-ead7-08da877c9d00
X-MS-TrafficTypeDiagnostic: SN1PR12MB2397:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oVe3UyIcVRl0/i5byToplgmrgEUtZ8InzlyoGZ7ZuZl5aCaPgYMq60Yg75+xP/1Mf/RCGSnQbV8jCM4g4vDg1S76O+9s/06/mf0iOLAG/vnRc/p7PAehkeJtjJmmDCXUwU9A47YbTW2DVchScrwP7/exDjML0FOIEEEGn1F3quiXbZRAUm9iviBRi3xKNiE7fsFizZYfN6onRKGTbSCuCnP3ZBYiuL1DrpsgWuJJ2a1ZsYQJqOefwVlFdB93IwNEhRgEL6/k1zcbSUZJ0isTPBmpLQfECXpZ6T2w2JxXpbhhFCDyTEJqJfQUtCTlO+xgt6GR+riVx7AudeamFux+YpmK1anlplStz5lwSatmCfGQZ38aJvmeApp6uWMHKTVV9J8CQLFy7zUiMJ10Vy60CGFED9WzsMyKGTBHE7JZ1u1feALJkZl+D7xkSKZP6vIuccQ8gXxz9Jpeo5Jkc3kpHfpLzy3lpQYvvkvoDGBIa9+uJDCYqwrSsMlwkB936xiJxTUIb0wO6hvaa464eRPZEhDwq/GIxBQjnXDYqxb99YnoH/9MlqmPjDnkItFEIX4+yTqqPP/Xgm2vV3W1313qbw+/ACOw/YyvsEzyis1i/rthNgqKDxFTnznW5/DItqvQeBfMWX05qHd1oozwzKOL8GYddd49g9XOk76sA4MhgN5usfbatsRSiX+jkk4lK1dhFa8RUR7x6aqpduc1/HaTtLwO4UGXW9Qs/DOxa2gLBC35DVlkCbW9e978k9NP4XddXgtPiiaA1spIWrpB9T34WKXoMVeB8W9JFI7rZgGkzLmkGmgFPJJq8KEkJMFyZ/Ty
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(136003)(396003)(46966006)(40470700004)(36840700001)(2906002)(336012)(16526019)(186003)(47076005)(426003)(40480700001)(36756003)(81166007)(6916009)(54906003)(5660300002)(8936002)(36860700001)(82310400005)(2616005)(4744005)(82740400003)(26005)(70206006)(6666004)(70586007)(8676002)(4326008)(86362001)(41300700001)(316002)(356005)(478600001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 16:04:10.4405
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 825aa730-ffeb-4864-ead7-08da877c9d00
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2397
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Dan Carpenter <dan.carpenter@oracle.com> writes:

> These error paths return success but they should return -ENOMEM.
>
> Fixes: 01328e23a476 ("mlxsw: minimal: Extend module to port mapping with slot index")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>

Thanks!
