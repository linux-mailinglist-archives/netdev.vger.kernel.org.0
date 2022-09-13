Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2745B6DA8
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 14:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbiIMMvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 08:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbiIMMvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 08:51:16 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3322EF24
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 05:51:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HQ3DzSSaxWxvd3Y2ukXse9stjIk2xHLVdTqCWOic/X6NWNPqZ/dtH+FLGHJpLjxM8wkbFG3+jFy5JHXHFE+8QMlQyC7IH9jj+GtThKswZm7j9V1z/GTf5x3HWO1caD5ptD7eHB2HnKPVUAuVwZ4BS7yMPzk/JPXqPplgccHqMtWbxVClGmyYO3+ZxrwHAWVNPbcTfwJJhA1ZfjiPcAZR7ungC2+yz9gwhGNIkoTb6/mjIzHrVqSPj6R+dYw2Qa8OV2wfOCaHP4U2JF2t0b00rbd2t+P5w67y4ovnT799DgxdoqUAU6XYB1eo6vdHJb9gx09H2YLichVfFXtqhL+1oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WLbAOk57kCtSw4lb5kDQmzRrg36OD4DTheqY4WKqu0M=;
 b=WoiGFjOJEhPM4phlOCbi/tDDEgIG08kXIAWVBrun741NlQd9br6VGdR187ukOh5OZKFiXxynKZuv6ptysyVxybllTF+xSoWK2biUA//sFpNG8/k8F2ltI1tRLkilFvbyQtQkYHc6NeDWCS8R8C+Jfap5arZtEDuaR4t5T/01rmGzbnfmLq/o/8wDi5LarVrrOCP5R4BLUS0SviMMdHvb3y1Cu6hUXnBbJWMaJTXOLqlEtpkj/SgYS0cekoXXtQdAH9jAXCPXOnVyjV+Q7CBe917o4NpSqsJ/pvsQafaoRqga7Q4+QtSYF0OzjJ2n0qff8JR8ACO1WQy717RyhAN+Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WLbAOk57kCtSw4lb5kDQmzRrg36OD4DTheqY4WKqu0M=;
 b=lCOxTaVvnhfEWU1081+FgJaWO2tOo5emZAlZv9ip3HrzvON63q7FHIC4ZsGchvA+uecSu+dqxdbrDcQBFWdlPg92S7IBoh+B/WrZ0eRre5fgvyxKFYq3kGaFeDmakmaAvVc1sWMei8w6sFv8b2wykphZqLjhBIxXkvVyQXnsTcgha1W78h7D+B7vlcwE9YO+T+NgfjwNMiT+Y6iuG/AH+UooWh7KEoNTHTNRmcJ7EzgGht4+JK7G+1O4tKwQvARgVQSQ3p3zJvlKFJv7VbzYzMtwsED23d0HPTzv4ogsLXiLgOMJWuwqgP6ZTDM6+ta0zn2NAQkhbFi/mgk9a1Wxqw==
Received: from CY5P221CA0116.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:1f::28)
 by DM4PR12MB6422.namprd12.prod.outlook.com (2603:10b6:8:b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Tue, 13 Sep
 2022 12:51:12 +0000
Received: from CY4PEPF0000B8EA.namprd05.prod.outlook.com
 (2603:10b6:930:1f:cafe::bc) by CY5P221CA0116.outlook.office365.com
 (2603:10b6:930:1f::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.15 via Frontend
 Transport; Tue, 13 Sep 2022 12:51:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CY4PEPF0000B8EA.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.12 via Frontend Transport; Tue, 13 Sep 2022 12:51:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Tue, 13 Sep
 2022 12:50:16 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 13 Sep
 2022 05:50:13 -0700
References: <20220908120442.3069771-1-daniel.machon@microchip.com>
 <20220908120442.3069771-3-daniel.machon@microchip.com>
 <87czc0efij.fsf@nvidia.com> <YyBI/tF5x+3OE2dB@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <Allan.Nielsen@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <kuba@kernel.org>, <vinicius.gomes@intel.com>,
        <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH net-next 2/2] net: dcb: add new apptrust attribute
Date:   Tue, 13 Sep 2022 13:25:07 +0200
In-Reply-To: <YyBI/tF5x+3OE2dB@DEN-LT-70577>
Message-ID: <87sfkvcubi.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EA:EE_|DM4PR12MB6422:EE_
X-MS-Office365-Filtering-Correlation-Id: b2fce1bd-684f-469c-f324-08da9586a339
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XK8Av08DZXW/uPV4p7U/q9URRO7l/GdPfYMac01VhhooiB31P7Xb/Ms1m3dk0PCFkyeKaLy5ypvohM0PzrBelPxkIDOlns7Hr4xXKxkfvhFTUJt99jCluzXrgBqsTDyMCK72h3cwzf92936LCy/VQC/7HMt4IAaB8ar1Tvpi648IJTimP8OrVHqvdLHTr4LfXCdNk8dp2JxNhrzBZzkGqlCjBm+FU55huBmr75D2LqqG/V1YelvwAiKdq1W9P2JcmnGvc6aCu9ORI1yxfDIwE5d6QhNKT2VtUdtD4KChNG1P+5rVScmdWGct4hu9xOeqY/HlxXdy43BPP0EtHSh7UQLO6zyWUV/FU5ImA29sRghCDG/ntiq4L3r3DcuQL9WNQ+yLtxN+VmW4vkR0YAQwRSpVIqHxhVojzLcDdZYLcoFjP1m2uz8zxxs5n2J0z2d1aVKA+gdoS/RcV7iC9o5OBucQEd4XIeJU4wXYTTNjgCFYkK2PVdyzLbxrCr4D3Pf5N1zXAA7H55VlHx+I+oMQjq/E4Hj7bkjKFsnWtcw/4rIEY60jKyrWvi+BteY1H5E9Hf11K+LnDKZKY35V0KF118wJajo7sPkAmjtagR6A5AWYvD6m15zxN6MiBv9T4AcCxXYZ9Q+oMCH17N4KsAcWB7BWqVBJYrnaYUvLrafvQu6U0D2NXygKXJ4OHP11HcSHfhRjof4NQftUQWejvOnGfVTyobPLt16iJPJA33LO5J+bQYnrpk30eIRhD3nI/61gf7m3qz3vtuSEbenEMt99RV2TrM4V5vZtM1LOTiHOeJY=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199015)(46966006)(36840700001)(40470700004)(4326008)(70586007)(6916009)(36860700001)(40480700001)(16526019)(26005)(41300700001)(47076005)(426003)(70206006)(40460700003)(86362001)(82310400005)(336012)(81166007)(54906003)(82740400003)(2906002)(6666004)(478600001)(8936002)(36756003)(316002)(8676002)(5660300002)(356005)(186003)(83380400001)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 12:51:12.1736
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2fce1bd-684f-469c-f324-08da9586a339
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6422
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:
>
> Petr Machata <petrm@nvidia.com> writes:
>>
>> But of course this will never get anywhere close to that. We will end up
>> passing maybe one, two entries. So the UAPI seems excessive in how it
>> hands around this large array.
>> 
>> I wonder if it would be better to make the DCB_ATTR_IEEE_APP_TABLE
>> payload be an array of bytes, each byte a selector? Or something similar
>> to DCB_ATTR_IEEE_APP_TABLE / DCB_ATTR_IEEE_APP, a nest and an array of
>> payload attributes?
>
> Hmm. It might seem excessive, but a quick few thoughts on your proposed solution:
>   - We need more code to define and parse the new DCB_ATTR_IEEE_APP_TRUST_TABLE /
>     DCB_ATTR_IEEE_APP_TRUST attributes.

Yes, a bit. But it's not too bad IMHO. Am I forgetting something here?

	u8 selectors[256];
	int nselectors;
	int rem;

	nla_for_each_nested(attr, ieee[DCB_ATTR_DCB_APP_TRUST_TABLE], rem) {
		if (nla_type(attr) != DCB_ATTR_DCB_APP_TRUST ||
		    nla_len(attr) != 1 ||
		    nselectors >= sizeof(selectors)) {
			err = -EINVAL;
			goto err;
		}

		selectors[nselectors++] = nla_get_u8(attr);
	}

... and you have reconstructed the array.

>   - If the selectors are passed individually to the driver, we need a 
>     dcbnl_delapptrust(), because now, the driver have to add and del from the
>     driver maintained array. You could of course accumulate selectors in an array
>     before passing them to the driver, but then why go away from the array in the
>     first place.

I have no problem with using an array for the in-kernel API. There it's
easy to change. UAPI can't ever change.

>> > +             struct ieee_apptrust *trust =
>> > +                     nla_data(ieee[DCB_ATTR_IEEE_APP_TRUST]);
>> 
>> Besides invoking the OP, this should validate the payload. E.g. no
>> driver is supposed to accept trust policies that contain invalid
>> selectors. Pretty sure there's no value in repeated entries either.
>
> Validation (bogus input and unique selectors) is done in userspace (dcb-apptrust).

Using iproute2 dcb is not mandatory, the UAPI is client-agnostic. The
kernel needs to bounce bogons as well. Otherwise they will become part
of the UAPI with the meaning "this doesn't do anything".

And yeah, drivers will validate supported configurations. But still the
requests that go to the driver should already be sanitized, so that the
driver code doesn't need to worry about this.
