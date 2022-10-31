Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B5361364D
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiJaM1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbiJaM1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:27:47 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2076.outbound.protection.outlook.com [40.107.101.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741D02AED;
        Mon, 31 Oct 2022 05:27:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khwlB00mANFJqDudT65byOp8whHdpgYLa3K2SSzjM9V2hiIQmxk8FxhHvJmDJw7PoaieHJx/WkEYsgWoZJO6Sj5Od5mnS0je3X/pRE7iWh9eGg5SwuMC+kEdHjsoTRKzGeQMe3WCdlzBUVhdEnK8/7YfxH+faW2VByqISF/exw1Nz/jQ1kMao82UNsCcwew3IPiYydrW+GchDHbV4GWPTJ+zahlRKTfmQIMiftYJ4g5vQmyjUqgcZMLBQITYNHvtfJSnYFDHYcWjwDbsKMnTn16vp7QyTdPkWZJsUmqVEZbVysW3q7315InNaRh1Umz/dy95TCm08/YjhSENJmILxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sEcweQWDCyWz3vkclOKJi24MgrM1JUIbG8v3G4VzlNE=;
 b=QiWn4bY1dnonE7FqJnpIkp7SM8Svpla58Nb31L5LeiEYA8gDY6EFzJnS0xKtSGWZDaFrCU80txzNEmVWg9pUxdo4kxdbGcVDwwL4s75QysGNm0UY7zsGF+HaF/4myJWWqyCa+g20AnWkjj2K5ZfBI1vghHydHFNF16i6bddKDCnKRTv9iWZXqf5kjKCqnLBBvNWBpM16gAGiO7sFw0egDzE8ejD2fazLUS8GfltqPCZQl6NXY5yXQWpkVnMX/TbNJVdSOKGnqtys83tQgxUnfyHnGyGQFuexrMafIPIylQ97D6H1vBiIDb0RanXCtBhY0E5/bbxv100kHUrF4//bPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEcweQWDCyWz3vkclOKJi24MgrM1JUIbG8v3G4VzlNE=;
 b=DYl8thb2XEcRh2UciQ8P4tl/T1UBQ22lohFd2L0AAL0uGEvsLNqw2i0lLHVDKD19qcvGzaGml/eDdVQ9ZjJ3sKnb4gx8eIuO0NsP/pfqNEN9Tr4Ni2yw+ezJ6sZp+9xkXriYCGW9+kbCiVwoN9pd79w7GxOyQ86FJGKKLehGdvzq8eHEMFPFi6hDQYdxG3uBTr5KGE8HUamOaOwsyM3Tvyn2R2Oy4i5upRguxIeKAmJ5EBu26FlxUsd+xRx/oifxYKbiHyj4waYHuilZgbHLFLd8Q5hDShHU6dh6Ga+vzDG8IzfNWy7myCJMEGR0FxisSUXm5+PMsyWRNn/86B7zZg==
Received: from MW4PR03CA0126.namprd03.prod.outlook.com (2603:10b6:303:8c::11)
 by MW4PR12MB7166.namprd12.prod.outlook.com (2603:10b6:303:224::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Mon, 31 Oct
 2022 12:27:04 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::1) by MW4PR03CA0126.outlook.office365.com
 (2603:10b6:303:8c::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19 via Frontend
 Transport; Mon, 31 Oct 2022 12:27:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.14 via Frontend Transport; Mon, 31 Oct 2022 12:27:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 31 Oct
 2022 05:26:56 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 31 Oct
 2022 05:26:51 -0700
References: <20221028100320.786984-1-daniel.machon@microchip.com>
 <20221028100320.786984-3-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <petrm@nvidia.com>, <maxime.chevallier@bootlin.com>,
        <thomas.petazzoni@bootlin.com>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v4 2/6] net: dcb: add new apptrust attribute
Date:   Mon, 31 Oct 2022 13:24:23 +0100
In-Reply-To: <20221028100320.786984-3-daniel.machon@microchip.com>
Message-ID: <87k04gw54m.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT051:EE_|MW4PR12MB7166:EE_
X-MS-Office365-Filtering-Correlation-Id: 406a2bb9-81a2-4ee1-8928-08dabb3b3845
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4PebtwDUYuuELhMtSnHOOvlHq5XlKZIKYZqKb0MWFET34Zc4WoP/BPbhns7711r2meAkJhI2NVGuKTjxYZILtGjSR2t5xPj8y2+kMdMuAup8uDWP9hLlHHRjvAua8dAUri1HTO9wpsi8qqNb2h4j/0RPN9IkJTPH0SkjVbzwKymhxOSeSh6X3itiZJJQ8we9xCqCnKOM/SzDmpSWoLBYBcXTUlW+Q6k+W5KpA4CVKjfZLMDtd46e9hcR8LcyFugSkQ/Asu516HS1cxxcpggS5I3S+MdeF3LisN6BAVx9YfULzT8Fb99pnIxLuHGsB5im9HA1kDT/QgRQMFc+d31DQ5imc+i1lR6iJxdxfLGME1tUzroOtmguF07CriJAvdxWwDnpoX8q77wO5TDSzTtAFaGAPDsbizdK8gn5mK1BtDcam/SB09nB/Lbc3MCEjWXoznptI4pUmngjfOFbH2LNtUzo129SI2C9NUmUm3PYJ/H1VdGXxOh5U2xYhTVlN8Q8oG0YrPC11jGRpLRUgK0En6lxo9rc1kYfyQD6YZdfQ+2j3CjUNt7OmxTXPy5bJkhW0z5QDlfXLaIAseeo0EOsFy6NpMYy7P1Cod+P5fVuUH1fdbxZQ1yCMR/SqHgxq38qj52fPzNJddiDkLJ9OkcXmbwojOiWdJJYD4AkmDfT8t87uQJfii0maZ7PYEtixF9dHoEWtFnRG+qd8aAXgfL/E2WBFq5rh0RoKSN1m+sJHcHuSnUJjUGtSJRvfSw1SH4LEZ5wTAcdbe3/XO0u4YjsxQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199015)(36840700001)(40470700004)(46966006)(4326008)(41300700001)(70586007)(70206006)(82310400005)(8936002)(36860700001)(8676002)(40480700001)(36756003)(7416002)(2906002)(26005)(6666004)(47076005)(426003)(54906003)(316002)(186003)(6916009)(86362001)(478600001)(336012)(16526019)(2616005)(5660300002)(356005)(7636003)(82740400003)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 12:27:04.6954
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 406a2bb9-81a2-4ee1-8928-08dabb3b3845
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7166
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> +	if (ieee[DCB_ATTR_DCB_APP_TRUST_TABLE]) {
> +		u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1] = {0};
> +		struct nlattr *attr;
> +		int nselectors = 0;
> +		u8 selector;
> +		int rem, i;
> +
> +		if (!ops->dcbnl_setapptrust) {
> +			err = -EOPNOTSUPP;
> +			goto err;
> +		}
> +
> +		nla_for_each_nested(attr, ieee[DCB_ATTR_DCB_APP_TRUST_TABLE],
> +				    rem) {
> +			if (nla_type(attr) != DCB_ATTR_DCB_APP_TRUST ||
> +			    nla_len(attr) != 1 ||
> +			    nselectors >= sizeof(selectors)) {
> +				err = -EINVAL;
> +				goto err;
> +			}
> +
> +			selector = nla_get_u8(attr);
> +			switch (selector) {
> +			case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
> +			case IEEE_8021QAZ_APP_SEL_STREAM:
> +			case IEEE_8021QAZ_APP_SEL_DGRAM:
> +			case IEEE_8021QAZ_APP_SEL_ANY:
> +			case IEEE_8021QAZ_APP_SEL_DSCP:
> +			case DCB_APP_SEL_PCP:

This assumes that the range of DCB attributes will never overlap with
the range of IEEE attributes. Wasn't the original reason for introducing
the DCB nest to not have to make this assumption?

I.e. now that we split DCB and IEEE attributes in the APP_TABLE
attribute, shouldn't it be done here as well?
