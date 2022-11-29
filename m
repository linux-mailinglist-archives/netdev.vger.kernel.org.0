Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D66A63BD1D
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiK2Jka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiK2Jk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:40:28 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31EA63B0
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:40:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PcvYGCqCOUjUwZ3jvLOi+XGUD1UcPImh+uutdDE6HvYCXqtnRD36jnmjSoH87+kMH+bnHeKxhp2c+iEo+ujz9yy57Fl9yl26vaQuLTWmoUQZgSJSFtpTYUPQmI0fWHKz2BOW+NC8gRz31/T/PSfrmRd80SwJwjBLdD3vT7WxpNfwCxCtAngBkZTqFCmWBbny/aKI2PkwnokOHy9bbT3LfRsGRIuM8ZnJJj/Skqf64hLHvwGOrNmLOExOK/fqwDqz6F3LjqE6xmIcYLMRn/ByFeV5iktEaHuakf+r6YRshr5YVjikkba0M70UBAAEAu/sistaXGU9/5ZA7CEibS561Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yCL2U6aSGcrTzmsupbjZjYvZk2pePIvWBheOjEXIDgY=;
 b=iBqSx+FNZ2RjO4CXoEVFgL8sVdrfvTfUgb7gltBsY9cgwBvTgynupPAaVk1XQIzIkHaNSTHop+W2dAgbzkS4VCLc8HisvT6BPRoJcyRx0yA3HEpQi5E07pZm9+Qyor1oeDrFclcR3tF/m5+E8TJWjyrXiHJrdffsEbYlak9MkfuJ3mkS+jI6ymoUP330VuHN0nAEUBJ1FsP84oBcUFabKENaxQmgeyGyBe51ZqAJdO+rba7LJPTa9rf4OBFmcv4nNH+EHShzCOhHGIXLzfkJiXFgV7B9HYaAaRmQNwdEpj5T23ULun+XGRUr1rL52oWH4xhdmYKy8s+vmCbzjUpp2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCL2U6aSGcrTzmsupbjZjYvZk2pePIvWBheOjEXIDgY=;
 b=lqcALla77eO7y9uP2qDUVXwgBPo0CEXnGxy/+ceqUEop7RrrGtPBMLfWh62PRBzskbXVlePJ4XHQS9Sv+WCsy8CbilW6YXZAYpAlwMFX9njRhJCtX9Y4CVCwM/Hke8UwDVrM2wAJlHNCEob8lekHD8Qc/MHxwXSBn/A6sFv94g238ZJ9enNTrwNadKl1Pqoot1OMp0gB5DXqv0WUwnxZgXF/Fh+FWYbMdFl/9aD4micFJk9dlj7Z9phSLs9yLu6lsNGBak8562q9egDJW+piJwJkbrHjgL4OzcqfWo/IGcDzjkm/ZluhwlKXDHtbYT3cJXn5KjoBjHem9FdfNuPw+Q==
Received: from DM5PR07CA0053.namprd07.prod.outlook.com (2603:10b6:4:ad::18) by
 SA3PR12MB7950.namprd12.prod.outlook.com (2603:10b6:806:31c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 09:40:24 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::bc) by DM5PR07CA0053.outlook.office365.com
 (2603:10b6:4:ad::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Tue, 29 Nov 2022 09:40:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Tue, 29 Nov 2022 09:40:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 29 Nov
 2022 01:40:06 -0800
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 29 Nov
 2022 01:40:04 -0800
References: <20221128123817.2031745-1-daniel.machon@microchip.com>
 <20221128123817.2031745-3-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <dsahern@kernel.org>,
        <stephen@networkplumber.org>, <petrm@nvidia.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v2 2/2] dcb: add new subcommand for apptrust
Date:   Tue, 29 Nov 2022 10:24:35 +0100
In-Reply-To: <20221128123817.2031745-3-daniel.machon@microchip.com>
Message-ID: <87sfi2f6a6.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT041:EE_|SA3PR12MB7950:EE_
X-MS-Office365-Filtering-Correlation-Id: 9371bd7c-fd55-421c-2b5c-08dad1edbd54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 39mY2VN5PnFgviCg/ErRmxLQyAvUKs/7I3nyhPASYd+Byny8Zuwv/98/JHW4Iloy+2yj5e3RcDuvYaYb01Uh4rBC3a/OMubHvSlbEBQE8gwvyqsuZgfvlGNuyWIuMLboOObNR/nISYQZPwLxNYzKAISbFxlPZ02K/vx8bxYEnAxfr4bzB4m1nfjdBRv/N2g+ru7SsRxTvGP/BXDwR26h3ALuIn/lw4wncgOyVXEUBSdZFsbwauHkt69XsViw9BoAPMlEGNPtxTH/El9DPgNnxavlmDkzr+6b/DEdAPyl/E34klCfzx9KHT0PCHGdSvXRE7lLslJ+tB/4JnXAdHRjXmg3YPGrGaBcId+LguNGUDqyD3Wwx5v89ZkywonsXVMhsY4VCvTq0rR78ZHw3z5O8wnJcellMVBJXLqVWMPft6aK35haL3zbMQmQno6yZEmpXXAyUx/lfj7idJIHLx08MfD9Pot/kR1buI2EB/VqAA5iH9d+SE8iOkvRSmO0RLYur/G8LYy8zBah+QBHWl9/ojmModznnP2XghZu+nnGrAa0RBWQJyHRlAawqqb0IzYsh9jiEnuXvPPvDPtBWokQ363rqJiNrfApxGDoQEcYKP68jX+DqF9LFO+7Psu2gtDWADgul6jZYG7GX9LY7tNbgGYApPzsl7spy/HTJGFUPbnG51JcqhxT4TB+ULoF17h//jhRew1K5lyhHPlz6LdXeg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(16526019)(40480700001)(47076005)(186003)(426003)(336012)(41300700001)(2616005)(8936002)(4744005)(8676002)(2906002)(36756003)(86362001)(82740400003)(40460700003)(70586007)(36860700001)(83380400001)(7636003)(70206006)(316002)(6916009)(54906003)(5660300002)(356005)(4326008)(478600001)(6666004)(26005)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 09:40:23.8804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9371bd7c-fd55-421c-2b5c-08dad1edbd54
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7950
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> Add new apptrust subcommand for the dcbnl apptrust extension object.
>
> The apptrust command lets you specify a consecutive ordered list of
> trusted selectors, which can be used by drivers to determine which
> selectors are eligible (trusted) for packet prioritization, and in which
> order.
>
> Selectors are sent in a new nested attribute:
> DCB_ATTR_IEEE_APP_TRUST_TABLE.  The nest contains trusted selectors
> encapsulated in either DCB_ATTR_IEEE_APP or DCB_ATTR_DCB_APP attributes,
> for standard and non-standard selectors, respectively.
>
> Example:
>
> Trust selectors dscp and pcp, in that order
> $ dcb apptrust set dev eth0 order dscp pcp
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>
