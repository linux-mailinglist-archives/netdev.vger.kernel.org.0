Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C7D613B2A
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 17:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbiJaQZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 12:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiJaQZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 12:25:11 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2080.outbound.protection.outlook.com [40.107.96.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25CE12603;
        Mon, 31 Oct 2022 09:25:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8hCVbTGaobX5VLIhl8GLE3ODHuOiXipFIoC+pcxiSMPpq0kHDFDWve2UNwhTbqVsJdeIOEtW7VhVfE1Mh30WwX5CTWcYbTB/49r+/fNzbydGnc5TVVDX3mzUm7mJKHBxKCBva/NtSiHn/d7bQf7BPqELxLNw+IhVWseCvd70JtmeJfgBvWlm6DxeRuXwIWeaX0wnsj+wsIjjMCpUR/kjICFpebcQqH0a+sxO7iykRFmXQIIcQXuL9mM8IK1BZNIF34fGIH9w5F/KBCPCgVOQrl2JzBmjfVXcrzOdp+K9AkehK1rIvwngvcUOspDR5CGBKG+dwlg9EKm02mUGhpc4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rf/QEFqR+Divu4rlOfKaFm+gi3FHOQbxtFPkiBEof+0=;
 b=mpIpMxdO5TULtyuPo7gAcBgERGo4MFRZca2wuZjjE1nnSDRzKvnSRs5abtukipmQOPArl0Ove/Ip13ldrjT5ZSwOxqchgjM3UnMRj5hMme72OK07M+1ZPw56CezaqWl2IgM2B7Hu4w7oggZVx3fMn4OTmukvpHvYB9xHbUUNAoCdYh9cfshKKIGlLc4MOzErtu2TCPIkA1fBy4Gn0Q35xEAXeE5FeWWYUDgYEiALD3V2c61LHQY2frRZlo1qGjyoLAEBCaqXY230ItFftz1Ynedvl3yjCB/q56ZrEuN1dnTor5O6uwB1SlromWs7LPIKDjqZ9Oiu8Nr/BAGN8yvvRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rf/QEFqR+Divu4rlOfKaFm+gi3FHOQbxtFPkiBEof+0=;
 b=Bbski3bUFfJo/y6PZ46pYnVbTXyQwuF+Zj4H1gcX87vozoUE5v45HvV4rY1DoKXiCFsd6mWNmyJE1m43UJCz+5dD89T2QxdMOZR8Sah5pKBXt+pAsYUaKnCIVPWFc9umoWm8T/oEbaoYRHmx3oodYj3OfU+GgyXspCTaHO1cyofdGro8AZq4WaUokMPu4ZdBn5RP2obeX8CUwWlEMfS1oKlW+Rah4fm50YZlDEDqEF/ePAtsEqCpKvMSCmJwGToAX30Zzk5gYxjzEnNB5bF2GS9IwxxxZMwVJ5Ir8usQ3q2Ofd58h0EACkGby9fbk6dKfvRxNja5Yu2YZNOGqYZadA==
Received: from MW4PR03CA0264.namprd03.prod.outlook.com (2603:10b6:303:b4::29)
 by DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Mon, 31 Oct
 2022 16:25:09 +0000
Received: from CO1NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::d7) by MW4PR03CA0264.outlook.office365.com
 (2603:10b6:303:b4::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19 via Frontend
 Transport; Mon, 31 Oct 2022 16:25:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT078.mail.protection.outlook.com (10.13.175.177) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.14 via Frontend Transport; Mon, 31 Oct 2022 16:25:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 31 Oct
 2022 09:24:58 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 31 Oct
 2022 09:24:53 -0700
References: <20221028100320.786984-1-daniel.machon@microchip.com>
 <20221028100320.786984-3-daniel.machon@microchip.com>
 <87k04gw54m.fsf@nvidia.com> <Y1/F5n+geZHAitoW@DEN-LT-70577>
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
Subject: Re: [PATCH net-next v4 2/6] net: dcb: add new apptrust attribute
Date:   Mon, 31 Oct 2022 17:24:32 +0100
In-Reply-To: <Y1/F5n+geZHAitoW@DEN-LT-70577>
Message-ID: <87pme8ufjg.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT078:EE_|DM6PR12MB4516:EE_
X-MS-Office365-Filtering-Correlation-Id: 05852c51-de98-4cbe-85eb-08dabb5c7a48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c2f1Vh7dBitnMjuqm4tF8X8LvkLkRGevjzB4CDptYpXDPMrHO6RXMz8qUZILLw7KkW0oRRABnRc279Ta0bOQDvoowDzAIIZUWW2EWH0/8fclHMBhvyQ02gfDPm4XWyt6yP2XAOnYpglgqNnqo8V4KEYIOssvKLnCIZZDxKtBa3hvbzy/+vc2HpuLbXRkD5vpcIyjfRTHPBvphfTY46pHZEo2sTy124fuHvsOwZGXB2lryu2zTbXbdbYHr5pPUZRoJocXpsmlwn2kpVxgv0sFFgaDyfn6ViL+AvbnetsDhL+Z6Kj1Fjem8Y1Ko0DJ+YcgHJoszanZA1KhFwKd8esMrMjqqnshJd4CI24JRzAFgJI3tgG54uxX2Hgx/6sarXOPW8cVF4fhlUMmkg417xMiSpK/cV2tdzzFOTpUiy1IbX7nzjNd/PzHcweW7+Pfri907fHR5qTXdUS+XL/8ExoEYXwbNWzWbwT34v/fq9NixHSoi53OQZwsXtB0a3v/ncEXKlCNbnqtVNUSgk0ZCpdbGUuE/bkQGY2Hr4T1s0/d61a3UTu2IKjP0i/pABHTd/REaDxLTquKZhs0sE83t1m4HP6b4udVFGXM6kmFNaEPam9hyioPBjRQ2LbvWjHdWzVpSQmWkR68SUon43VswxLutqv842zMofjIQ06w7w6EdRWJ26fQGtP3l3fPt9MtMvdQb16hoAqZvqiFGm3DwMA+Mf5y5ldQh2JrZZGfdN2vvTnXQdejjMtc4mxD9uzwfdYJ8g7Ew2XOkJZt5leP/LePdQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(39860400002)(376002)(451199015)(40470700004)(46966006)(36840700001)(336012)(47076005)(426003)(82740400003)(6666004)(2906002)(36756003)(356005)(86362001)(7636003)(40480700001)(82310400005)(2616005)(26005)(16526019)(36860700001)(186003)(5660300002)(70586007)(70206006)(40460700003)(8676002)(316002)(4326008)(41300700001)(6916009)(7416002)(8936002)(54906003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 16:25:08.8367
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05852c51-de98-4cbe-85eb-08dabb5c7a48
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4516
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

>> > +     if (ieee[DCB_ATTR_DCB_APP_TRUST_TABLE]) {
>> > +             u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1] = {0};
>> > +             struct nlattr *attr;
>> > +             int nselectors = 0;
>> > +             u8 selector;
>> > +             int rem, i;
>> > +
>> > +             if (!ops->dcbnl_setapptrust) {
>> > +                     err = -EOPNOTSUPP;
>> > +                     goto err;
>> > +             }
>> > +
>> > +             nla_for_each_nested(attr, ieee[DCB_ATTR_DCB_APP_TRUST_TABLE],
>> > +                                 rem) {
>> > +                     if (nla_type(attr) != DCB_ATTR_DCB_APP_TRUST ||
>> > +                         nla_len(attr) != 1 ||
>> > +                         nselectors >= sizeof(selectors)) {
>> > +                             err = -EINVAL;
>> > +                             goto err;
>> > +                     }
>> > +
>> > +                     selector = nla_get_u8(attr);
>> > +                     switch (selector) {
>> > +                     case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
>> > +                     case IEEE_8021QAZ_APP_SEL_STREAM:
>> > +                     case IEEE_8021QAZ_APP_SEL_DGRAM:
>> > +                     case IEEE_8021QAZ_APP_SEL_ANY:
>> > +                     case IEEE_8021QAZ_APP_SEL_DSCP:
>> > +                     case DCB_APP_SEL_PCP:
>> 
>> This assumes that the range of DCB attributes will never overlap with
>> the range of IEEE attributes. Wasn't the original reason for introducing
>> the DCB nest to not have to make this assumption?
>> 
>> I.e. now that we split DCB and IEEE attributes in the APP_TABLE
>> attribute, shouldn't it be done here as well?
>
> Hmm, doesn't hurt to do strict checking here as well. We can even get rid
> of the DCB_ATTR_DCB_APP_TRUST attr and just pass DCB_ATTR_DCB_APP and
> DCB_ATTR_IEEE_APP? Then use the same functions to do the checking.

That would make sense to me.
