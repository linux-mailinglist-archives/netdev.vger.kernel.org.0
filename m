Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48165F2E4A
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiJCJmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiJCJmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:42:08 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6AF13DC6;
        Mon,  3 Oct 2022 02:36:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dV83IBgb3ibbHisvUK/wiWUKXRB/4AtTqGEz+t2wQjUXUWk5ei1M1os57D3ah6+oJEdb2ljv3jLCx+Dx4peM0z2ob2ZHHvKH3dDVN5JzxQ+kpFrTGdYxuYNVuP5rfqhmp8OZLtQfwuUf4bgxutMHTmWGz0eaGVIYDC+8lZ25u6w18ngW3tG4Xy3W/l05xXCtZUZqC8peRY/rrgoiev4ib69WACcgA1d1qyuh00X4LE9W0MdTdZMKRCII6NIEYJAS3nT8KmxxdAWgHjwC4nx99jQGAGoDWh8l1NIo9seLXDtMXOmz8xpPAzD0qnZSGxIfXfAXlfKMxQs7jHUQREt1HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ADJrnYNSEhFpH3EHidSDQ8uUD1paQwS5DodawdNZLMo=;
 b=ftD2dhKJDyoWe9KAL8U0G6zq2nP/eYtX8fVycCb98podYuDHu0gAFFM0aTqxEJmatLEvU3SMi3j9m6CmYkOOZivoD3yaxZuvgSyVlhSMUdWv3LLpNikEfKj8bZAf8ncbYOdiojrJdM8953w1XDw10QxBWGNweYJem7ACenP5MXvdVHrPVijyoMp0/QfqybR6vogwoOeOX8jkdudB/MomYNKOUs0Gtc2C4HJafqryGkOR8fhwf/BXS4PF+i1nustUNW0XlLUE3QsPqUd7HFRMVWpdhM/g7dA6Yha4my6XGSRq0VmMYd+v1hP1BUhtRQrusAPe8LzXqWSE4ha+dRHx3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ADJrnYNSEhFpH3EHidSDQ8uUD1paQwS5DodawdNZLMo=;
 b=REpkE+6O1eM7KqtX3VlpOjYcDC80aTnoTNgGJJlIvJULpA83F2Q2+bTZQtWPE0+u26SdEfh7owy39tQI2dGhw3aL1uiNksP4arnH4sv2dtA1mnCHvml82+TCPhFtT7gkBYCA4z2nosA0Z1LDPBWpJZXw2sKV36VVfAeIjVm1X40QrSesasTJ6HP+jwJZEtGieRe4sIqDy9kaeDIySzXceHBHsJHxEDyJyr6iZEWrVtYfz0+F9J6zyUG/wRmccJO3J9CvG+/oV1OeVNERT8Te/RD+ZYRVf5APhazBimwXbH3FGIgk10vOv584G2INSw6+mysZYFGBYj5k9VEIH/u28w==
Received: from BN0PR08CA0003.namprd08.prod.outlook.com (2603:10b6:408:142::19)
 by DM4PR12MB6615.namprd12.prod.outlook.com (2603:10b6:8:8d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.28; Mon, 3 Oct 2022 09:36:05 +0000
Received: from BN8NAM11FT092.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::f1) by BN0PR08CA0003.outlook.office365.com
 (2603:10b6:408:142::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24 via Frontend
 Transport; Mon, 3 Oct 2022 09:36:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT092.mail.protection.outlook.com (10.13.176.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Mon, 3 Oct 2022 09:36:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 3 Oct 2022
 02:35:49 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 3 Oct 2022
 02:35:44 -0700
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
 <20220929185207.2183473-5-daniel.machon@microchip.com>
 <87zgegu9kq.fsf@nvidia.com> <YzqJEESxhwkcayjs@DEN-LT-70577>
 <87lepxxrig.fsf@nvidia.com> <Yzqc85mqkuakokCE@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <maxime.chevallier@bootlin.com>,
        <thomas.petazzoni@bootlin.com>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <Horatiu.Vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v2 4/6] net: microchip: sparx5: add support for
 apptrust
Date:   Mon, 3 Oct 2022 11:34:59 +0200
In-Reply-To: <Yzqc85mqkuakokCE@DEN-LT-70577>
Message-ID: <878rlxxn9t.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT092:EE_|DM4PR12MB6615:EE_
X-MS-Office365-Filtering-Correlation-Id: 81637ef5-2810-42f5-a7b8-08daa522b196
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cN5n50xyoGq4gwR1MCSnfAnQVNpkRYqG3OYGFkv4DP0mSyaFfFC/Wqflc8ts+YD3SayxYrAd2bxdbdEA6AURs6kQwzUjeNAn0apOUH8PUhiZ+nn3ava79UKX6C+nBCcI5pNVla9Svdrgv15nLze7HfwRNvbJyxwuirbBbKJmw6bP59yzK4Id90wszMlzQcjXkaMJ9RF7nSSgh7Mk8vcukHSgFUDkQs2V7/KneTA3/qxESNYRXsqdqluurIuqa7JlAJTwM7XwShPN8CgGGhuGAku+oEzuBpfvQ7G0nAjNWYQOqjlbqhUKYpUxp3bcpVVtxLP4LcdcSV1UdoUbuqaeGyjemXFgnzM90wV98ynIAU83x0M0/ngXAbiopQugO/+WVS8H/cTChnEx+YDA1hWf0NkZZ/HyiS+glec6NWtUa8PuNJcfIyWhZguNHooLRFvGPXWJ1YNnQayCn8zDitghfQqnQp2eJyKPd0txPzy/63XAziGxJljm13HmaeFQ3aalYJcFu41F7wqrjYu1yz+oe17707WxvNa3sjjww+Y4N8KN/2GxD8ENPW93xfXEzuKOGiIaTGjrYLd3foTiaSHvjGKY0mBcySV59jwl9FCsqQK494RrD2mhPE9S+Sj+HxW7iiBU0GIX8ZRIhdZoUjNTvcUeEKCd9TnixtosyvLnylVWNk2/iDfmsFulRPq1Lobad3wLXXmbv/pJmri2VMI9EuRPKu80AQEds0tmty4mJuoJ4j549mMLOtPr6QZuChWQ5zNlNqCM67agtuqiKavRtA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199015)(46966006)(36840700001)(40470700004)(356005)(70206006)(70586007)(8676002)(54906003)(6916009)(40460700003)(40480700001)(82740400003)(7636003)(336012)(316002)(426003)(47076005)(16526019)(186003)(6666004)(2616005)(26005)(36860700001)(36756003)(83380400001)(478600001)(82310400005)(86362001)(4326008)(8936002)(7416002)(5660300002)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 09:36:05.1227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81637ef5-2810-42f5-a7b8-08daa522b196
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT092.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6615
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

>> >> > Make use of set/getapptrust() to implement per-selector trust and trust
>> >> > order.
>> >> >
>> >> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
>> >> > ---
>> >> >  .../ethernet/microchip/sparx5/sparx5_dcb.c    | 116 ++++++++++++++++++
>> >> >  .../ethernet/microchip/sparx5/sparx5_main.h   |   3 +
>> >> >  .../ethernet/microchip/sparx5/sparx5_port.c   |   4 +-
>> >> >  .../ethernet/microchip/sparx5/sparx5_port.h   |   2 +
>> >> >  .../ethernet/microchip/sparx5/sparx5_qos.c    |   4 +
>> >> >  5 files changed, 127 insertions(+), 2 deletions(-)
>> >> >
>> >> > diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
>> >> > index db17c124dac8..10aeb422b1ae 100644
>> >> > --- a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
>> >> > +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
>> >> > @@ -8,6 +8,22 @@
>> >> >
>> >> >  #include "sparx5_port.h"
>> >> >
>> >> > +static const struct sparx5_dcb_apptrust {
>> >> > +     u8 selectors[256];
>> >> > +     int nselectors;
>> >> > +     char *names;
>> >>
>> >> I think this should be just "name".
>> >
>> > I dont think so. This is a str representation of all the selector values.
>> > "names" makes more sense to me.
>> 
>> But it just points to one name, doesn't it? The name of this apptrust
>> policy...
>
> It points to a str of space-separated selector names. I inteded it to
> be a str repr. of the selector values, and not a str identifier of the
> apptrust policy.

Ah, that's what you mean. Sure, NP :)
