Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0186E5F2BBB
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 10:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiJCI0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 04:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiJCI0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 04:26:21 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on20619.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::619])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEABB23392;
        Mon,  3 Oct 2022 01:00:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MrbMilKgCmmyy9vxPwY1lMFaLZ/vL22ySH6W7wYgLK7+vkl/gBBoQ2FwDamEsldcJqnxXeobvDeIVIAMh1EuIinDxJgp2WOiTpYunZZVGeF135DFYd/u9bBfAEKGfoRb0JGqjnpzgXegpnfuBo2DG8/Fwmb2BAldh4Xo//acQLKLY92Jy2yrh8ff9oEuvrQOGkmmtXPiFapbG1QohAOltmUvwzyvGG5stW+SHkv851zDNCPT/uf9JXwemcfjAlZ1iSPpmeEbvT/COsq3QB3Dlj2f+rZdP1B2aiuhwIC+4I/8pRXBqGBvAmJUGD9qhxkyiJOo3CiR3xOFk2PeEOG0jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BwJRc/I2+eCjgkQidCQEwBwTjXycCDCY3M+z/4eY52U=;
 b=OxXPvfg1AD7oBDjy17clGZeu3q9m1iaqOYzpgQMN/O2A08NscOKfICRggl+bWAfNS46DbAvZLhl/iY0eTVeH1AT78hx7+QViOZVTOQUoX6+skpd+oVkc8L0evKk+LKQRjMOjZYmNzXMjQdn/u0qN9jXFQBPNhWFCOZRfpb/foQ7nDQzbBLLAYo5lK8BU4dniZs4/dcZns33/IMwOELwzYXQav1dPRDVSj/uEr+xDrNnFCMbnlEj6a+B/91zZQe5V2kR4hBlNwkchLiH9+WTCXcCOQATlB2fUNJo5ZSOFn4NpXW1AuQQyOSa5opi5iOksaxr2881Utne2j1UAUWUwRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BwJRc/I2+eCjgkQidCQEwBwTjXycCDCY3M+z/4eY52U=;
 b=KEQCh7975sd1HQ1Bc2SAK5bS1HHZcD/mRpQCGpFte0gkd+KR2rlF5h9nAp+UDvMw05M8GRP6zsewVscavIVZ7yYaKfs5kmur53aTm4smDEEDDKX9g6vKvd9vZfJPgKdWCVaKjLxuJAlbiybyPLQ/pYlpPiSXrDQ4YBZV5qi+Gj3JOMYulxLEXMpNbvQiMa/hrmFrr0A/GM016xqR3ZcLwv7sKjUWQ/MF+97LXT3N2Qb7xVUhw56Dcgkn9AIPrXVZm5UQhm2qRGzlyBLoXrO6ucYvKaRTWt/CsoSVX25hPzok+/7ZdgOGrGmzJYy4NPtn9fiac27ew5s+e+QazYd4IQ==
Received: from DM6PR02CA0161.namprd02.prod.outlook.com (2603:10b6:5:332::28)
 by DM4PR12MB6302.namprd12.prod.outlook.com (2603:10b6:8:a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Mon, 3 Oct
 2022 07:58:57 +0000
Received: from DM6NAM11FT079.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::90) by DM6PR02CA0161.outlook.office365.com
 (2603:10b6:5:332::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24 via Frontend
 Transport; Mon, 3 Oct 2022 07:58:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT079.mail.protection.outlook.com (10.13.173.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Mon, 3 Oct 2022 07:58:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 3 Oct 2022
 00:58:53 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 3 Oct 2022
 00:58:49 -0700
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
 <20220929185207.2183473-2-daniel.machon@microchip.com>
 <87leq1uiyc.fsf@nvidia.com> <20220930175452.1937dadd@kernel.org>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Petr Machata <petrm@nvidia.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v2 1/6] net: dcb: add new pcp selector to app
 object
Date:   Mon, 3 Oct 2022 09:52:59 +0200
In-Reply-To: <20220930175452.1937dadd@kernel.org>
Message-ID: <87pmf9xrrd.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT079:EE_|DM4PR12MB6302:EE_
X-MS-Office365-Filtering-Correlation-Id: a03366ee-4b9f-49e8-4c94-08daa5152021
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ifD2mQKH9rJNXQbhUjpCYojIq28W8coKY1aYliVycpBRaUYTs/cKy1S75RoUxe9WIy6MTWib6z0mXHWEmnmo/j4j+dyAI0gW5eCZpFNLRz/Z27ofzAUh0OXnPBpRWjK4G5JABpYEJvPEZlIAoVYkhjAtSCt3p7EB9ZB4DJhraYV5xDXEaFmWwr3SXe+FNbkrQy1mTk/+ozye82OW3X0iLpO3SvRV78hVzwgk2bl6N3cEK2VNqIkdVsC9fzM30XA5uzRedFqIaTa1cxPRk8qDUm+zR/+awN3l6pmVGJc/zuJV2r0TAbrfw63T7Z/c1vaOppljFjnQ8m1RsKU7oX42FG3HnUvABxxWpg/DmNhI+6b2Nhl+fppKgO9apdWmSl7Ja2Iez6UmoKbs/ejiMYwcZ/OgB80/rig4O1M3WTbx21FfdqiLsfKCXjIwCadXAzA1chowmHPCuaGVoKTJ4X0URQHxKM2YDJiFdnWspj3ndgsm/LBQaSxVG5PDIL1gMQK/LwX6UGX0umei4ak2rhHY++8gjbBQKP1tgwy4O8KPHqUTGxlGVQxrBB1zd6jJpSC4+HTkqhjIH2WDvh/7Y5hCjxQ0y9iP6W6d8yVKvZ5WzuUBe4uX9Y8nF9gVz3NsrVRDFYKva0iaHpeI29lEroQsV9TvUMuRonQ11tIhYYeyD9cLy8b5rYQCiVZlSdkvK5WGDm7y/oj32OIjh+olUymf8SrNuwkGWaU3D70vkBdB1WpyWvnS5q/uaa/mWmL0h3prUkdWs0URyyoVUV7+722K1Q==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199015)(36840700001)(40470700004)(46966006)(2906002)(6916009)(54906003)(40480700001)(26005)(36756003)(40460700003)(86362001)(82740400003)(7636003)(356005)(36860700001)(70206006)(70586007)(41300700001)(4326008)(8936002)(7416002)(336012)(8676002)(5660300002)(47076005)(2616005)(16526019)(83380400001)(478600001)(316002)(82310400005)(426003)(186003)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 07:58:57.6733
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a03366ee-4b9f-49e8-4c94-08daa5152021
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT079.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6302
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 30 Sep 2022 14:20:50 +0200 Petr Machata wrote:
>> > @@ -1495,7 +1536,7 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
>> >  		nla_for_each_nested(attr, ieee[DCB_ATTR_IEEE_APP_TABLE], rem) {
>> >  			struct dcb_app *app_data;
>> >
>> > -			if (nla_type(attr) != DCB_ATTR_IEEE_APP)
>> > +			if (!dcbnl_app_attr_type_validate(nla_type(attr)))  
>> 
>> Oh no! It wasn't validating the DCB_ATTR_IEEE_APP_TABLE nest against a
>> policy! Instead it was just skipping whatever is not DCB_ATTR_IEEE_APP.
>> 
>> So userspace was permitted to shove random crap down here, and it would
>> just quietly be ignored. We can't start reinterpreting some of that crap
>> as information. We also can't start bouncing it.
>
> Are you saying that we can't start interpreting new attr types?
>
> "Traditionally" netlink ignored new attr types so from that perspective
> starting to interpret new types is pretty "run of the mill" for netlink.
> IOW *_deprecated() parsing routines do not use NL_VALIDATE_MAXTYPE.
>
> That does put netlink in a bit of a special category when it comes to
> input validation, but really putting in a random but valid attr is much
> harder than not initializing a struct member. Is there user space which
> does that?
>
> Sorry if I'm misinterpreting the situation.

I assumed the policy is much more strict with changes like this. If you
think it's OK, I'm fine with it as well.

The userspace (lldpad in particular) is doing the opposite thing BTW:
assuming everything in the nest is a DCB_ATTR_IEEE_APP. When we start
emitting the new attribute, it will get confused.
