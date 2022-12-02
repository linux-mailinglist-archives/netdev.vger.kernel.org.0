Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEBFD640F1D
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbiLBUT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbiLBUT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:19:57 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA6CF2312
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:19:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htzgihmqRjfGwa7z6w+DXp38yaOijYw9oFmKpV3Elptx+6n03pR2eW+8BBIvNMvNNxCkIpucDk+DvtbtI7a3nx3SccHNedsVZ3YFEwB5+yfUuer8S+yKMyCZt3MDtyX204DmqLpiUp5/8g0eAfdtJpNN6pXwGhyo/UDz8isgOf4N/tZvyXm7dInG18QCoCGLwqfzseqsY2FiXqXj1YVFLgwl56xsStrPgPQTmuQV89sE9pj+Eu6CHZkpFZLcIvcmop/FAy/8J7Joe3moNK2lSHljKdliyOV8nf7YO8/cOHYCxGz4kZROFx8+aC4iMhmKBMzalT7Nh/y371NMC39tjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8RrMSRCiXONWfXOgvdGUhXB2JddDGtXV34SIni3KSoM=;
 b=XT/nSdnraqX0jwxYv3l2c5EdyI1v7Wkryxyoa/2a2II5dqy0QpZASSNtZ/SVrXwD9Jqm4evZssyUvE1+8NaDW+cnYodoLzZpisxef+Vna0QPgUcIpleGy7kIstRNpMX/w+5G2IkGQK9KFrZ0X9jFPIDCY8Eqo+j6oSh1r3HBSstKhSJ7H9GC52vQgYdeTHeiow3BLKPSbjqP0rCFbYaNAF3odtVDZfcb/e6qVyrh09DNbjh32UUJGnFdtbZeZr+vj5NN8lwZ42LI4YKkwW2f7KY23btbNnJ9LpJBY5aKvMEir5VXxQ/9BVaJ8IH4HzbUwvsWQN9Zsi8TAwg8LvpYnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=secunet.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RrMSRCiXONWfXOgvdGUhXB2JddDGtXV34SIni3KSoM=;
 b=UkDnl8u4Tz1glHqwAsnNnfgmA4u6OmNdElEDo4bvc5oxO/+Ql0nlrauua3lksFOFbqSBbvACkoxic+wMiJ2ZuI52nv/zqBedhJLsR3G9QTWuwld9ua0QkxsJgqTCmD15RIA6vpAljNjsETb0dZMndh1aGXzTSb6TuhGiSAHpx7keJ+Hf2sVum8E1gcUDhaJ6buOeitqCtw5h46jWeednePNa+TloeMEOkrQvBqFVrO3EzbEiUyzXQE3ddVwu5NCnKsbg/B/bqlA7GBRlxUJQ6+JMKJleLZpUfvHMVv1ByZLpjmliV6gXKwsz9HiOsGkm3VjXhTuTCfMlZua227cbtw==
Received: from MW4PR04CA0056.namprd04.prod.outlook.com (2603:10b6:303:6a::31)
 by PH7PR12MB6719.namprd12.prod.outlook.com (2603:10b6:510:1b2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 20:19:52 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::31) by MW4PR04CA0056.outlook.office365.com
 (2603:10b6:303:6a::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Fri, 2 Dec 2022 20:19:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23 via Frontend Transport; Fri, 2 Dec 2022 20:19:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 2 Dec 2022
 12:19:37 -0800
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 2 Dec 2022
 12:19:36 -0800
Date:   Fri, 2 Dec 2022 22:19:33 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH xfrm-next 00/13] mlx5 IPsec packet offload support (Part
 I)
Message-ID: <Y4pd1ZrFXizV5TqF@unreal>
References: <cover.1670011885.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1670011885.git.leonro@nvidia.com>
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT058:EE_|PH7PR12MB6719:EE_
X-MS-Office365-Filtering-Correlation-Id: e0d3a1ea-4757-4c20-d3aa-08dad4a291d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E6lqbnAkgNIq44bUSDJzctg2j3nmhFCRLXGUXDrE1BGpRnBod5LpZSNdLnidZSFrd7F5izH8SUXVk+iQTKIlwnCjWU7XKIJOM1pWOn4DSB9IdQUAw+65UsGQ2iArd2eAQAnMYypFHtTEMxcTjMENF8GtmITxwH1hrG5CvyBcbTaBlk8/YCp4FzjbQ1aUX/a8Y/yThv9zhj/MVBuycnK2zYQ+Bkf4tRHgTtIxzCtKfC4gH2PWWpery4d2n0AhF/sznTy2mYIWl6Yt8icLahhB+1vf0HtnTr/vJJLsR+oRfOY0f/p2qUbSvDiP745r2wUfUe5PIWGtGYMM313Ppkb/MS8pZ4U/FtpcmBRDGbO1MGehJqB5f1bLyhdy0Q6TQo/1hhfQzk9ej+D79Tsmf2JuIcs5CyXryFMCmdn1CdkmiU+aNneZaiPPwF1lPOPKgak7NLPo3UXXlhCd9hORz7T3FWfjG4VGqlXMRxoTasRGW9D7EiJik9R6ap/5Rpi39+yMLvoAVLI2sw3cDRwBDPl08sQfsNqk4sCke04423RbCB0UjPigBzQC6U1TsYEYscR+xVrtELCUC/NeAqUIwjqrgfBRLsR4s1PrdhNLEHldm8XWv4IwDXtLMptwtz74A6lwRx1KDHcoj71ojG7xvXfVdez6X6mFiaurOdcID/dJQnNw2DlcCOismvHhNG4IOydj8x/HaHICn8UCUK3pnYN4vg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(136003)(39860400002)(376002)(346002)(451199015)(36840700001)(40470700004)(46966006)(86362001)(9686003)(478600001)(33716001)(26005)(82310400005)(336012)(16526019)(186003)(47076005)(5660300002)(36860700001)(426003)(54906003)(6916009)(316002)(40480700001)(82740400003)(6666004)(8936002)(558084003)(2906002)(7636003)(40460700003)(8676002)(356005)(4326008)(70586007)(70206006)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 20:19:52.1022
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0d3a1ea-4757-4c20-d3aa-08dad4a291d1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6719
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 10:14:44PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi,
> 
> This is second part with implementation of packet offload.


The title is misleading, it should be written "Part II".
Sorry for that.

Thanks
