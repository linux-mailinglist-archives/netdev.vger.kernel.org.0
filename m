Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DAC5F40F7
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 12:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiJDKo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 06:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJDKo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 06:44:56 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98A512601;
        Tue,  4 Oct 2022 03:44:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UA+i9byxm459dPQb3RvNzCAUWLUNQ9lWVav9gVIlJ+5+LP70YXmCm9OR6KFN77bpy7fCv+j7Gz4eSINXRSWSY3CDrWAeztpBpghxGNQRGL6OpuLS21aJG86RQVSmI4KpQsBs4T7H7m/vi4FNPPSN43WULDf6w1arjEnVa64c35XBsab/yRJyle8AORfAohgtBsYrgAmlnvFgyh44NVMAqHYNp5t7D6TE4eIYSNICJEuwC9TO+Ty/oq0nH09VXqagJgh8m17NfGHfEK3EeNk6u3GvcRXLHNw8wiW5+L8vOR0nuNazg3795sNVzb+HlI5PhSnVRbBZOUGfTpbHxv6few==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BewjoptCVNNNylIM027ZWvyajObLnBKEI78+BWD2Y+k=;
 b=SGlthqEVRGF2Ea0uNM9PWm27An9zWo9NkXkw4xoHa96CM/VFFd7Gd4bfwdn+/CpJhBYw+w9gxlwGzqA/fqe4icymwUoZiLkrT9qGHAgUJ+vm01mq+52XRsK8XC2hlfyBnzGoLUdh8yuwNcjQEXziVNR+EDpWEpaKSZTKBATsA0ClK6mWLyDs4rojrLUbWdkPROg5QRkCmDY25EubTCLi7bdBXePenKU0hZHiea4FZD7HM6L7f8dlMb23NIch70LHmXRe4c++DrQXPUw8WGtYdcBL6MejmtOsblHwgHA7yfH8CUgmCcO6/6d7khikhahHu5qvDZT/991xa/mEcqGjKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BewjoptCVNNNylIM027ZWvyajObLnBKEI78+BWD2Y+k=;
 b=RGQAwaQLdYMKjTbAwOewdE16qd4yCpnw/jKk5Lph5XEQMacQ9QaACJOIxTbfVsMmuVDcv0OgSCVOGURLr/tksRyQIgVUKa6oWs7hhjuhetpPSj/VVwQOtEw6MNd5R3aZez7Io5OISE2CMgEXcMHqIy3fRXh+FuglvnvLm2YqbEmPf8N3lg4yJRXstMQyIg6CktVx+KPM8BItdiFM4Z6jVLR8RddHU0YMCs5UtXi0UIONrn9XWJrLFYba4JHa0lL2OvGB8mRIepEZNfSgs2d6yzxmQ0i763me/b1s81Zah2fV7o9EAmeaMt3NRh5ypEuHsBu9HPbwclfxEhlqqgAuWA==
Received: from BN9PR03CA0629.namprd03.prod.outlook.com (2603:10b6:408:106::34)
 by PH7PR12MB7020.namprd12.prod.outlook.com (2603:10b6:510:1ba::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Tue, 4 Oct
 2022 10:44:52 +0000
Received: from BN8NAM11FT100.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::c9) by BN9PR03CA0629.outlook.office365.com
 (2603:10b6:408:106::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.26 via Frontend
 Transport; Tue, 4 Oct 2022 10:44:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT100.mail.protection.outlook.com (10.13.177.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Tue, 4 Oct 2022 10:44:51 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 4 Oct 2022
 03:44:47 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 4 Oct 2022
 03:44:42 -0700
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
 <20220929185207.2183473-2-daniel.machon@microchip.com>
 <87leq1uiyc.fsf@nvidia.com> <20220930175452.1937dadd@kernel.org>
 <87pmf9xrrd.fsf@nvidia.com> <20221003092522.6aaa6d55@kernel.org>
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
Date:   Tue, 4 Oct 2022 12:20:04 +0200
In-Reply-To: <20221003092522.6aaa6d55@kernel.org>
Message-ID: <87zgebx3zb.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT100:EE_|PH7PR12MB7020:EE_
X-MS-Office365-Filtering-Correlation-Id: c4fe5a54-0dc2-44d5-00cc-08daa5f577aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DXlD1Xb2V3GYvEV4rz5ftnWH1ZC/ak0VLKJNenr1pAlPxjjTr8L4sp+jMV92Zrnx/Z1tfJefY2i1iE6kx1GYvA63GAddspO2jeg6Mq3wE0mxm8ECq0bMRcgk/P5caP1q/BXUIydekNihB986r42/gqey4tWvufOVXnLoiYVTEE6rJ04mKYdj9P1KjUPt/QTKbXJV4mMY+YVQNHcxlLiTyMCew28zbnrOy0bkq2Gvfe4ibqtrgmIcmOjBOWAKTvHdB8+2Jh+SGspnZk8F3ZLMk2IGk73omLbUyRk7Ue/eEbIg4f6zBMlFflIIba3jNko+PPIhrmF+HhcrKXKTHUeTe0Q8MKzp9+2qX8iLlHwOFoYBqI055U68jZEGzEG6NDmp+eYOtZnhbTd8uZi6ySY1q7b58X+gshgBKjHavdXbRM2NLgpeedwRHfx4r7v+FRbdJ8+UXh3eygnte8CqB8Yts9nvpdy+f2FYgt9fjsXYF3l6gLkwUhguRNInCW6Nj2141VcLxfXojfX46GM3RmVWOKlSDCTnvS6nVuXxQ/mcelwcAcMnB3H+uBtNidtrXIiRtNGSM+JJBx4/zNOUTPN+tHuEcOQ6cgn9YKeYk6cfHcmd6GyB++vAjJVtr8xN2AYLNfBF7CeX8gTao7PVkoS/bvVFmPY4ezZD7D50HGQpr6obM2NtekGIhyEJh7cpyNzPHsXRmADvSr9gk7SSKjqaZ164ONfp1BBJKChx13fLhxtc1wxlYJOeMY97jHbIcRUVu/XaUJ34Twk7Mff49kIT/Q==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(54906003)(478600001)(82310400005)(8936002)(41300700001)(36756003)(7416002)(4326008)(316002)(8676002)(4744005)(70206006)(5660300002)(70586007)(36860700001)(2616005)(40460700003)(82740400003)(7636003)(40480700001)(356005)(6666004)(86362001)(26005)(6916009)(336012)(16526019)(47076005)(426003)(186003)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 10:44:51.7672
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4fe5a54-0dc2-44d5-00cc-08daa5f577aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT100.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7020
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 3 Oct 2022 09:52:59 +0200 Petr Machata wrote:
>> I assumed the policy is much more strict with changes like this. If you
>> think it's OK, I'm fine with it as well.
>> 
>> The userspace (lldpad in particular) is doing the opposite thing BTW:
>> assuming everything in the nest is a DCB_ATTR_IEEE_APP. When we start
>> emitting the new attribute, it will get confused.
>
> Can you add an attribute or a flag to the request which would turn
> emitting the new attrs on?

The question is whether it's better to do it anyway. My opinion is that
if a userspace decides to make assumptions about the contents of a TLV,
and neglects to validate the actual TLV type, it's on them, and I'm not
obligated to keep them working. We know about this case, but really any
attribute addition at all could potentially trip some userspace if they
expected something else at this offset.
