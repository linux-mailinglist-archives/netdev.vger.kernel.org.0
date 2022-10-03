Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4BDD5F2C8D
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 10:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiJCI5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 04:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJCI4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 04:56:44 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20712.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::712])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145241FA
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 01:41:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFGogpyvhPW85kq7YjYcQdHEP44X1ZXb2EDFRi59F612PiIyRJITdwEYnPQZCB90w/f3k3fiaFZnlKuz/qyiW+RrPIR8SqKgJZhat2zKvGyaU2dN4xv452UuNxQkgryB1Z3fGnjBRo+XQS2tRnpUczLhAtY/DmhtcsbYJIBaHKYEDiudM0Bqt21uA0L04WMek/RdeZcuKF3cSlMJqGkuWXcmTNFGl9kC7NQP5kNlWQ5O4QQJvneEzBE/z3QtnUVX7URP/PWTPRwvHPHkuaZITpCXiNF3vv7qc/Oi2dXu/7zP+1165FBz0OkEmZmnJZiW6i5FkGvhHoiwlr7YOx/awQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/xwSGZgKE6QjMgondtuximbWhuQ5Ywv9WPfsaj2lss=;
 b=G5jFUYcpdr4gpfZI1dueGxVvsgD50EP5q+kynfc+43oyDvPAg02BuSY8oKiSvCFoonCywGzyiWg1RKV7fRKHFGG189puoFIsQaB8HGPTpl14Jz5cAlVcuKpbmOxwh3pPR40m6r44r0zkFziT6uxK3el93ObT73gdmmzZQBdcvhAwVBiewJZyWWiNwJmehGzO9KY3HKG8Ujf0QHlsatG8P8KpjqXnOLdAw7O7kUmmzW3P4RMZQfDBCfvWpg4HVwMhggsiwKtfYyP11dE37RKZKlxarKFjOIhB0VT260N1ye5H23AyUZ97KOCc0DitTs6fmFD2S9PP7fQBJgYZV6nflQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/xwSGZgKE6QjMgondtuximbWhuQ5Ywv9WPfsaj2lss=;
 b=nSdNnTaBKFYeIACxKnCT8wb58I+5Ve52MBjj6SO9Hg0KkbTL+c83V4XdZDHWmGvyhdNXhZuROgCAj+kskI8XqAOLf5TmdSc2CiI7Ue8JFwzXKOkFFRmbbtPUHMIbusk1WbtYrVZJp4cTn91OmpSvJfYeJStuMMF83u/AvihEyig=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by BY5PR13MB3810.namprd13.prod.outlook.com (2603:10b6:a03:225::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Mon, 3 Oct
 2022 08:41:18 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::f43e:63de:d7be:513c]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::f43e:63de:d7be:513c%5]) with mapi id 15.20.5709.008; Mon, 3 Oct 2022
 08:41:18 +0000
Date:   Mon, 3 Oct 2022 16:41:11 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Fei Qin <fei.qin@corigine.com>
Subject: Re: [PATCH net-next v2 0/5] nfp: support FEC mode reporting and
 auto-neg
Message-ID: <20221003084111.GA39850@nj-rack01-04.nji.corigine.com>
References: <20220929085832.622510-1-simon.horman@corigine.com>
 <20220930184735.62aa0781@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930184735.62aa0781@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SI1PR02CA0024.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::12) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB3705:EE_|BY5PR13MB3810:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ff65899-1730-4542-e820-08daa51b0a4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lfC48ZTvHI7wj/2azdM7o+p7XgDLgG5nib/r/Fx3i6g+IMNABNxCsnrVIb8KosdFe5SKDmruBgu11iTtxVMIzwEtwvlaM/pt1EfCPkiXkRZ+gXKGRaLWVo/rmFsN0EAI4HTWdDoiop/MjbOBXfNoGzyiJSvdaMCX4V5B3W+GBZ/4dm2fg5DJ9NWrouVBKE285vbvIZ5wsWuGOIXLVGOInQN+JOqAtiXwdzXq2x4EFqu7pd5Ig7dzx/YzP3PgJR+7HyZBM5z4hGLlF1qgx/D9fb5UI5lqkR3FpOVBz+k/v6T1gzQ4SygLtNPF3xj0fPrwt9UjpsOsoiQFJenv7jx8m/q8vQtpdwdO/hC7PhC8GFB129S5q7208lN7FFw/iKq/BB9py58Nz7KQ4+KqjSrgUSVuVKtQnYIQUhnOWisRnOb5Pv6n4mpOLiEh6q9aAT9jUIV5yqE0lM38aNyxpIGQ3BcYA4mddM4qp6OGip4KVcrFwcWBO9nVzvryT7RiMlweJFo2ROLF3Br2RUvhbjShArvmE2lopwGiYvA819bSQXfFuE35I4iUJTM6C3UtDaUrNFLh463CAvX5+xLAUroN1x2ISeTh0CoC0S/sDNiBIfvHyJTM2P560JSaC8yx/c2mR+vWuoQ0kgx9JMeDK4aYTl9/SznjTTzuraBoAVvy8YQ6gHjgGzX5l6uGmg4grK+bdTLRUF/h47EopFd4P2ZsnI1L4dtYzefNrR5okPqaK4vShx4+b3+x6eBwLxgWiaEVgieKanPG/hoG8+dAQ4b6PTZ9TZhmLx4SV/T6Y1eZreI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39830400003)(366004)(346002)(396003)(451199015)(6506007)(4744005)(86362001)(4326008)(478600001)(54906003)(6666004)(41300700001)(38100700002)(6916009)(33656002)(38350700002)(2906002)(316002)(5660300002)(44832011)(6486002)(52116002)(8936002)(107886003)(6512007)(26005)(1076003)(186003)(66476007)(8676002)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bmz3kRr8Xn1mOqG+lVdBz58QIEF0M5CT28pAp6C/oGcF6vZz0/llaqQXiA5J?=
 =?us-ascii?Q?+J5UrFNN/5ZTgF36nkMlfrEKHtqlDuuKH5gUvQBulMhwWh/RjRjh2pbXACcm?=
 =?us-ascii?Q?xf04lrAgMDCa3Ysd/U00HC395vrmHQyezdWdlqHPEs1eki3IkiNM/vLLDcEn?=
 =?us-ascii?Q?OQ7QAUvKmwt0vZ7zz6zVr2Ylb5KFSH7DhfnZpRsO1T3LKsGz89KaAoPYRiov?=
 =?us-ascii?Q?HxESxASRohXbE+3TSnrndmFJLZLgMgy/zEDtaYoElzd4aiONtvaViaBkT5i4?=
 =?us-ascii?Q?bEx7xzXrkDULzYEMUMDH1ZMKoKgyvp2DkQsdh968YBqS5jUL5kXcM8efd5yu?=
 =?us-ascii?Q?Zf6LEL1HBNPgQZ4LLuQjy2+c1ltVrC8qas0i58XJhwb1X9yCXTs4A/AigDgf?=
 =?us-ascii?Q?PQqv7hhmB0dTnyKjVDKVcP2YZTMwGCzrrbxCpn53p67QXYoHOU1EA0egyRX/?=
 =?us-ascii?Q?y5jL25Gz9zxQEcCEa6/CVrBWy5wNH6cWWpzOeTv/hJpWqYxtH5+UCqw0bYz+?=
 =?us-ascii?Q?lZ9GHBFJvYETNjx7WbcPL9Z4PeA/kgz9E5bIBJfjjVMVg5j6LOihxj7vIDbz?=
 =?us-ascii?Q?0Ur0tu4tOq+cBdGGXt5H25MM/BFyGKeObxjTZIHgDcLj+v2qDYhnQDKsIFDJ?=
 =?us-ascii?Q?pJsCbGnxWVryooYIoqd3iMWqRO1ghV632imMrqOLFO2qgA4QVCivylGWnHEw?=
 =?us-ascii?Q?rh033wvJKhhzy8FkupCdiAzHNHUAdzmf1YWMAS8YgO5VnJPGLU/rEwBMvKxj?=
 =?us-ascii?Q?oZQLwjDcIQy3GBUv55OZBVzFjIK4xdiCpMr6Sbe+UYZl5TnbTdL+hC10vJqV?=
 =?us-ascii?Q?LxC4Kq4uFRzeLXorPvmVmU2h30GcoAGPYvuUskXmNdI9jYyEySlPwgYl1zk4?=
 =?us-ascii?Q?kAxKfJh/FeoW/CpmmunwxMreVfXxd0oFWB213bX7AxmjxiiCdcG/jiGnqjok?=
 =?us-ascii?Q?3NKWRd+GoK+hnBZn54nBdRDvm/RcUDbUFqAgWUJaNX269hdi8TttlLaY57Q6?=
 =?us-ascii?Q?nBdb4h4w5CEIs9jL/Yluh6OLYttLCZVZB4uu/T+e4m3dPXlAD6PNN/gk4GHO?=
 =?us-ascii?Q?xendZzHYsYu8V7tkP8ti1t6NnO+damOdSuqQl6sc5CVU04GNx8tSzhePo73a?=
 =?us-ascii?Q?pTf9wpSKCPs1ZtXBSRnErQ2/cCdqE5qYV/H5T7dqFaeDDPaosXejPR9mz78S?=
 =?us-ascii?Q?uYy/+X0wHSJSLTa9I/0UPtIjvW4bAQvZgaDTDO9WvHpFouewVMNuN444bGjq?=
 =?us-ascii?Q?2h9R6eMtrAxBxk7e8KouErsmC05+Betm7Qlc66+Y+2q51QmyALxc/JiJ82Gb?=
 =?us-ascii?Q?DZHL8DGNzIMdUHM39r167rUgZvItn51oze6SakdP/emRaI8HCHFvJGLDWsyC?=
 =?us-ascii?Q?nUMMYD1nyhymvgCINNgB7PgSwSZEAUMlZxuqeJrSvUcZypaIQqqBctm4S/nI?=
 =?us-ascii?Q?M3MiuF/CLWChCEIUPET2YoAFvsi8l5SS6yVNxP3BJnMimPYiW1hlZnHvlfAy?=
 =?us-ascii?Q?D9CrS7kwBCovELEo9u3AGkcRzwK4gqFvRJ7J1hBSsm1qZK+4bbhNr8TCcJ9q?=
 =?us-ascii?Q?SfLiGB9255E3n0F6be5z/iW3kV0T0fJJZ6zrNzN4f5Wwp3j/m25iqS8d3NRu?=
 =?us-ascii?Q?HA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ff65899-1730-4542-e820-08daa51b0a4e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 08:41:18.2927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6EQBNpgRNtVlkgEA5mU+zOnH4PArKgS19MxJ8vLM2DZauHLJ3WFMLpk4hh3dXheesfXxfw1tD4gEspZobch7kjA7PTgVw+igAU5gG/hnDd0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3810
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 06:47:35PM -0700, Jakub Kicinski wrote:
> On Thu, 29 Sep 2022 10:58:27 +0200 Simon Horman wrote:
> > this series adds support for the following features to the nfp driver:
> > 
> > * Patch 1/5: Support active FEC mode
> > * Patch 2/5: Don't halt driver on non-fatal error when interacting with fw
> > * Patch 3/5: Treat port independence as a firmware rather than port property
> > * Patch 4/5: Support link auto negotiation
> > * Patch 5/5: Support restart of link auto negotiation
> 
> Looks better, thanks for the changes.
> 
> BTW shouldn't the sp_indiff symbol be prefixed by _pf%u ?
> That's not really introduced by this series tho.

Thanks for your advice. Although sp_indiff is exposed by per-PF rtsym
_pf%u_net_app_cap, which can be used for per-PF capabilities in future,
I think sp_indiff won't be inconsistent among PFs. We'll adjust it if
it happens.
