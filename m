Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB18661348F
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 12:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiJaLfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 07:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiJaLfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 07:35:01 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70527E0A1;
        Mon, 31 Oct 2022 04:35:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OEk7YeaXFG0Y3AC5a3Vl7UIKOjUeY8TmtbAHesUoODycLzAn/HaznVrqcsc+EkkeV+lZfdvtfx1J2vj3ajwhtgoz511eO9IfVfxoPmh2H9EHv3B5lKXRWhKhk+260QktkRkNk+ckotzPjaNX/rhPWvB3JuhFHGiozQ5IKLaQcd9Kg6Vz4Vm+hTT/B363KaGPaQkP8mFzik5yGdhxgd8bW2/BOZ7KjtRGWEHP+XgorLpHa+Lk0HOmR4O8QKQUS6K4DJAZmofANyPJ7E2GbUMBxGqlkjILzlDKBBP1E8c89A+LI4Ta40OZrUzBje9YntVtvcm6FRNVHHfIwSjMq0KJ3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJqt1o1d2SVdLzS5fdfK+6eVfcGRZhKtWzOMVw0GSXk=;
 b=iOxLuBnObe0cIGescrveyseUjewctcCxImEa022pATNuD5EVlGu6JiH0lbnHduikjPKZwRUCKfEmJKQc8TAeEQ/hjmR2cQOi1T8TgsIKSURD2c8ciO0/1J/985slpyQA30LvjqRl1LMKR1jSYX1WJ4K0AiHmD5xtZd9TkTIujk8ClfDx6h8yHIf25KYwxABklbBFALbX+RpKFYaJ07uVAc4wcqucwBKFg7XfSbU+AWl2bxYJPoAi0ncNTdRfviyOcY35bNfeubZtKrxr+mELuGu3KfhjZn0SH8xTqTfENxEKWA5F208sD4p71qDvPsue1c4YuiDGIgFy9QwcWHaNJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJqt1o1d2SVdLzS5fdfK+6eVfcGRZhKtWzOMVw0GSXk=;
 b=uFnDN/rH9iMcwZkgGYI/diQnDMv/6KRZflETHygtfR82RKKv8T+Z0pXYj5x7OnWYXqb8JB3KYilr606ZWO/CUm9tS8K7ZPzxYDnhRUtIGiDNSRQT2kTU0yUHLiFLcgt6SULQhw+mS73M+MPXZwEIWdcg64DT4J4jm/xUYT1ZwD5/T8L/MDz1Yz93fzQWpFXZtIV6fjMC6rn2UzKvNGdv72NslmNobSNxdE2T03K6t+C7uxYiPgRnGG5eK3Grude7LTe/cCeDOAJLhVyIXBpyYqRlXcacbM9NZZayRhfHuMwLJD3tFPslUy/EWDWcGPvgYX7jadXCkRoU7y3pfepm8g==
Received: from DM6PR02CA0095.namprd02.prod.outlook.com (2603:10b6:5:1f4::36)
 by SJ0PR12MB5472.namprd12.prod.outlook.com (2603:10b6:a03:3bb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Mon, 31 Oct
 2022 11:34:59 +0000
Received: from DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::65) by DM6PR02CA0095.outlook.office365.com
 (2603:10b6:5:1f4::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19 via Frontend
 Transport; Mon, 31 Oct 2022 11:34:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT072.mail.protection.outlook.com (10.13.173.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.14 via Frontend Transport; Mon, 31 Oct 2022 11:34:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 31 Oct
 2022 04:34:49 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 31 Oct
 2022 04:34:44 -0700
References: <20221028100320.786984-1-daniel.machon@microchip.com>
 <20221028100320.786984-2-daniel.machon@microchip.com>
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
Subject: Re: [PATCH net-next v4 1/6] net: dcb: add new pcp selector to app
 object
Date:   Mon, 31 Oct 2022 12:13:43 +0100
In-Reply-To: <20221028100320.786984-2-daniel.machon@microchip.com>
Message-ID: <87o7tsw7ji.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT072:EE_|SJ0PR12MB5472:EE_
X-MS-Office365-Filtering-Correlation-Id: df39593b-3083-4057-ad32-08dabb33f107
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iuoDQb71oiuje8OWNpNz/HX3qsEGqbrjnWAx2UEHUTrZoBU/FovwCg+ws/c4Prq2cSfvQa2eQ9yBdwVJyFb6b46VwMkrLS8QNrb1GYMSv0/MIDSa0c9FV1VoGmatb2ra/ngc7S2NssY4SFxe11s8iFynh/Tcf9uEizX+xNvIQup6Yw7XnMqGC6thOWk8s3reB6pDOq5jSHXqyu1pF167tSGtTPl4w2ciI1CrF9CzwiHQETb9Vp8dLG2zjFxwPoPUKzdEdRJt/wmgCLTkwYyLs3E/JF9QG1RKnkI/SAloDZ8reHDmkXaq7FG9CjUFC4VpQ7mPxewGcpDNYWk6vieJy3x37brQjTnNPvUBx7PTQ2ip7z+89NDJauhFBdBpimKd9LUMQ2fBvtzwqPr/SLXG8auV9FvLXKCKv43/6wiZ6j3HKs0Vh4PZADKol4Ron4mdiOQSbHfeburjNmdVXbrkDy89I6frvF/0O1pn9gEsaXTAWyn7FTsNIkFzcYzG9zi64OSgs37xp0SQ8NPMLJfYLNMYTvc/E/c6Dp7RfHsgecyzeOD6KXokYNb9ForRGdahqyNWA7sNHOPb6mLX6k4HFuirdBTY5+hbgMJpSen92iGPxCi6cGmcBNmOnzg8pw9ooBc5ZWipjNV2+VP4SkfTFOEMqHeu+sBgJg+P9QWvMq3aCBE7ea5xEepMIWryclQMoMXmi1WLGJo8AHum5Q5NvCtNmhkVtQ5rvk+7KY2lncIdyPTWYMfETd20oTXj+2xPZc9fIIqUDgNYuZTGwy/Trg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(39860400002)(346002)(451199015)(46966006)(36840700001)(40470700004)(478600001)(82310400005)(82740400003)(356005)(6916009)(54906003)(7636003)(2616005)(316002)(40460700003)(83380400001)(36756003)(8936002)(86362001)(16526019)(336012)(2906002)(186003)(7416002)(5660300002)(36860700001)(4326008)(70206006)(70586007)(426003)(26005)(47076005)(40480700001)(8676002)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 11:34:58.5697
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df39593b-3083-4057-ad32-08dabb33f107
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5472
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

> diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
> index dc4fb699b56c..68e033a459af 100644
> --- a/net/dcb/dcbnl.c
> +++ b/net/dcb/dcbnl.c
> @@ -179,6 +179,57 @@ static const struct nla_policy dcbnl_featcfg_nest[DCB_FEATCFG_ATTR_MAX + 1] = {
>  static LIST_HEAD(dcb_app_list);
>  static DEFINE_SPINLOCK(dcb_lock);
>  
> +static enum ieee_attrs_app dcbnl_app_attr_type_get(u8 selector)
> +{
> +	switch (selector) {
> +	case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
> +	case IEEE_8021QAZ_APP_SEL_STREAM:
> +	case IEEE_8021QAZ_APP_SEL_DGRAM:
> +	case IEEE_8021QAZ_APP_SEL_ANY:
> +	case IEEE_8021QAZ_APP_SEL_DSCP:
> +		return DCB_ATTR_IEEE_APP;
> +	case DCB_APP_SEL_PCP:
> +		return DCB_ATTR_DCB_APP;
> +	default:
> +		return DCB_ATTR_IEEE_APP_UNSPEC;
> +	}
> +}
> +
> +static bool dcbnl_app_attr_type_validate(enum ieee_attrs_app type)
> +{
> +	switch (type) {
> +	case DCB_ATTR_IEEE_APP:
> +	case DCB_ATTR_DCB_APP:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +static bool dcbnl_app_selector_validate(enum ieee_attrs_app type, u32 selector)
> +{
> +	switch (selector) {
> +	case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
> +	case IEEE_8021QAZ_APP_SEL_STREAM:
> +	case IEEE_8021QAZ_APP_SEL_DGRAM:
> +	case IEEE_8021QAZ_APP_SEL_ANY:
> +	case IEEE_8021QAZ_APP_SEL_DSCP:
> +		/* IEEE std selectors in IEEE std attribute */
> +		if (type == DCB_ATTR_IEEE_APP)
> +			return true;
> +		else
> +			return false;

AKA return type == DCB_ATTR_IEEE_APP;

> +	case DCB_APP_SEL_PCP:
> +		/* Non-std selectors in non-std attribute */
> +		if (type == DCB_ATTR_DCB_APP)
> +			return true;
> +		else
> +			return false;

Likewise here.

> +	default:
> +		return false;
> +	}

Also, it really looks like the following would be equivalent?

static bool dcbnl_app_selector_validate(enum ieee_attrs_app type, u32 selector)
{
	return dcbnl_app_attr_type_get(selector) == type;
}

Also, shouldn't it be u8 selector?

> +}
> +
>  static struct sk_buff *dcbnl_newmsg(int type, u8 cmd, u32 port, u32 seq,
>  				    u32 flags, struct nlmsghdr **nlhp)
>  {
