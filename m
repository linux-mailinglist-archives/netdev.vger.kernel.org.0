Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB235F2BDD
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 10:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiJCIci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 04:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiJCIcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 04:32:10 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B82630A;
        Mon,  3 Oct 2022 01:04:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJTuIPuofilEw8vVNvXXJetLgHdDeDaSm5orvgP5XVNT2Ashbwv/zJ1AJKfpMytbAbSqiXZOXwmbteNS6w9U69H6QNcgoesUVmPVsg96YP144GFADW3rqZ1cFid7GVSGv3Tp9tJZpiK8oz+N+IcCE9paEx/JkXn7Xc1zBVb7lweHaQD4j++/kxCwXxnCxj6wr5OoJvC2DMpO8IqfWoCf7FvM+L9isCx3kEMd+VyDMl41N3BMEfPtdjb4Kj7c+MBfDdQhjzhLuYD/okw33NVOpyf95vXuL1hnRCJba5dSy7ehU1WlME/QmI6HqLPMt1Yd09VLbduRoaP3wjiwUAsa+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jSRDdAgoVeK8MieqkOyHvPI/oMQbeCLc/1HWatEm6Aw=;
 b=CbMs2y1y894BsgVOx9qHX2pvF4BOunauvO7UhTgDQnUk8lWMnbZcPK8Re8G+/X2t5zLkjxtv6yS3odN98hEk32B7KJACBReVssnoujRzMqkd0Tsa0p0XE/XFDapB+bdD5k7J1IGHFuvAiOYxN+IbVObtyFDLXKfFg+vAbufFs1d/UgSNbrKnEBmiGOZit9fpgWvXP/ZWinLt3sPF8qvA39hprMVRzKyLPkJ/T2w2KH+D43E8yv7j2/ruYuTiHEOx/vAxgHjgqk5FC8r+9M7Jb8+x3fdiWQaMVFBK4PxEY8WK6Giv1hebAY3HdLJkVB7pFemL8CgFO/EmPVGthJBQ0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSRDdAgoVeK8MieqkOyHvPI/oMQbeCLc/1HWatEm6Aw=;
 b=SYeZoafc06y35mIP5ToqA8SWr/KylekKFedSywt+T68kGksykzI2coS5N3UamY2slGvCZxt7kwNrluWb98Jg9+5wq37tcJ3HPyfqGjh2vJ1j/BD6myQ9+Ci5elXhd/0HoLU5xayrXxO2pXSYXp65gikjRQhJ9XRhpBNABFW/axNIgpwsDr/pNH+h6NIVyt+LHwuuzI9XVjnWkB9WrEbujZ2R6sBM43AIQYCMyi4lZkSn5LpgPZdyQt//I7kdRFVYyse3SvhUhzTc1l0dqQQsDxyA+nF8hKSIhb/ttf8GdRhYpOR7RK/L2ZdIijeGE/QgT5GMx7itpP8ZhDB3e3L0fA==
Received: from MW4P222CA0005.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::10)
 by CY8PR12MB7123.namprd12.prod.outlook.com (2603:10b6:930:60::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Mon, 3 Oct
 2022 08:04:27 +0000
Received: from CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::97) by MW4P222CA0005.outlook.office365.com
 (2603:10b6:303:114::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.29 via Frontend
 Transport; Mon, 3 Oct 2022 08:04:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT084.mail.protection.outlook.com (10.13.174.194) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Mon, 3 Oct 2022 08:04:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 3 Oct 2022
 01:04:14 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 3 Oct 2022
 01:04:09 -0700
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
 <20220929185207.2183473-5-daniel.machon@microchip.com>
 <87zgegu9kq.fsf@nvidia.com> <YzqJEESxhwkcayjs@DEN-LT-70577>
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
Date:   Mon, 3 Oct 2022 10:01:24 +0200
In-Reply-To: <YzqJEESxhwkcayjs@DEN-LT-70577>
Message-ID: <87lepxxrig.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT084:EE_|CY8PR12MB7123:EE_
X-MS-Office365-Filtering-Correlation-Id: cbe28790-047f-4dc5-1f49-08daa515e481
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eki3UHsIkXf/ThpgSvmqVqLtEZCsSQ8XpztZ8SIQX/Xh2kPXAFBUpvzh+3BgZef88vtvnn9iU70agmDF0ho0+EradCZyg9W0H1B/lYUd0koTm0ZG4K48FJLFgU5ERY+HFAKm5+MU6/iQ48LP1SeT0/rP38S3P0He1TvrHhBHDPsBttGRUp8UrT1JIuyIcCJ9+0EOzRg30ekUAzg4Mvdddy0+u+9rnbftdi05ODfwBaaVgZYo/EEMFq/o77nOIYH6ePOFqCoPwYB2qJGh4LBhRtbQsdG54+cTCg4Bo86AuAiM8MvYqDJaRMKNuvbMNdKxzqpuxyZ4h1uXev7+uBuoV/tcaxHiCa7hHimwW62BOmnOQi5Yt1/IqMHr4uHOUv9sJhlJ6P5l57/J1YsXyWKAh0qMOAv42zkkSynQ4YXI1wvdBPPoUyvkbBB2A8UNu3wSApHwvDfRZ8dPAaw01nt3a3SKkYGehJv9zaGVx3Z2OvWVdKxxe811aP5XeZcZaqBBGJIn8OJZnqtUpOQvVyP+ssugjFqnscmTFwo8Nbh0qxNrbznO2P02cTIRUaIjQighwAieKtDuIJwzGkpG84aVo9S5pdML6zUAgdZ6A3luU8Tl1USRhG6ZLoeRPlQum+N6SgeqmnVGG7BMzPXii3iLEo+uvybMhyPggfJx/o2rrHoi8cXrKLaz7RmkkGKhx+ox6G7HsF6Axnluk6xjmWnEacZNuHTXhHV40onf9dDXowEMb8FLJFXGzhx1lVWqvyMfIxQ2n4SQYBb/fLSDLLbAUg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199015)(46966006)(36840700001)(40470700004)(41300700001)(2906002)(7416002)(5660300002)(8936002)(4326008)(70586007)(316002)(70206006)(8676002)(54906003)(7636003)(82740400003)(6666004)(40460700003)(26005)(186003)(86362001)(426003)(47076005)(82310400005)(478600001)(336012)(6916009)(2616005)(16526019)(36860700001)(36756003)(40480700001)(356005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 08:04:27.1347
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cbe28790-047f-4dc5-1f49-08daa515e481
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7123
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

>> > Make use of set/getapptrust() to implement per-selector trust and trust
>> > order.
>> >
>> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
>> > ---
>> >  .../ethernet/microchip/sparx5/sparx5_dcb.c    | 116 ++++++++++++++++++
>> >  .../ethernet/microchip/sparx5/sparx5_main.h   |   3 +
>> >  .../ethernet/microchip/sparx5/sparx5_port.c   |   4 +-
>> >  .../ethernet/microchip/sparx5/sparx5_port.h   |   2 +
>> >  .../ethernet/microchip/sparx5/sparx5_qos.c    |   4 +
>> >  5 files changed, 127 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
>> > index db17c124dac8..10aeb422b1ae 100644
>> > --- a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
>> > +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
>> > @@ -8,6 +8,22 @@
>> >
>> >  #include "sparx5_port.h"
>> >
>> > +static const struct sparx5_dcb_apptrust {
>> > +     u8 selectors[256];
>> > +     int nselectors;
>> > +     char *names;
>> 
>> I think this should be just "name".
>
> I dont think so. This is a str representation of all the selector values.
> "names" makes more sense to me.

But it just points to one name, doesn't it? The name of this apptrust
policy...

BTW, I think it should also be a const char *.

>> > +} *apptrust[SPX5_PORTS];
>> > +
>> > +/* Sparx5 supported apptrust configurations */
>> > +static const struct sparx5_dcb_apptrust apptrust_conf[4] = {
>> > +     /* Empty *must* be first */
>> > +     { { 0                         }, 0, "empty"    },
>> > +     { { IEEE_8021QAZ_APP_SEL_DSCP }, 1, "dscp"     },
>> > +     { { DCB_APP_SEL_PCP           }, 1, "pcp"      },
>> > +     { { IEEE_8021QAZ_APP_SEL_DSCP,
>> > +         DCB_APP_SEL_PCP           }, 2, "dscp pcp" },
>> > +};
>> > +
