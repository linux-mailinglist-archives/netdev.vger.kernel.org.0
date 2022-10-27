Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF1060F74D
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 14:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbiJ0Mbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 08:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234951AbiJ0Mbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 08:31:44 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37670D8F70;
        Thu, 27 Oct 2022 05:31:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNy3qzslrX4x1UskrK1uH4fqTnCZb/nf6u95tRe53VoV2nFi+TburA40th/NmGYWxA+4x+OFJ9etpSlXroyNlSDgbM7Zg8LXWRKTHqYPzhIq/cIPyeoZqabmCpO5bCwgHo1DnwqAq5czy/o1ibhLZnsO5Nw2alA6paYpCTF2Dow+bdiqbttGAJz6CZ6etbfh7z8BFi2K+lWFVZaUK2KW/3+1YucFgbYA84IxgNNTNgW9JkCJ0ybahUBLeq3VV+CAKt2hil3F6idsFNypy9RovqF6VruI2OE5pNSq7wVTlg11gNQ2ibRUQMJLdzcNbh4pHZJq+rX+kbeV46A73+ZAZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hkskW57cuQHsxOoSREKT7vjlv3Tt7P+NdykLzP9YwUM=;
 b=hXDENEQs4kdl/xFvJ8xMyCpFAbzwIIgQ6SRDaJXeVbb33/wZClIdarwxVuKWVsB1aQcAhY2I8LUYvuJn4osqdxiP3g/NGHSRzAfhED8JzCwlg2AARnSgfbpAUCvPXl+CyGuf3kU1esTE1FdfCyeJ4Ip3nfU3H9nSI+/51p1DXmIS1TgSYT+G2D4TbkVXB/FNHdXFI26QHPHoAewn275vM5LmFRr9XbneRgFeBTNjeKAybWCnQXSQlyAAW87oYVsrUcZL+lLyGnWxjZ0IXhMZ7jZecPaAel0M1ADTsg01/fNVjj1Dklvhnys5lk72x8libffaeuzxS1AUX5gDc6wq2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkskW57cuQHsxOoSREKT7vjlv3Tt7P+NdykLzP9YwUM=;
 b=l2k2imaXW82B3TSygRoh/KZmOhNuopxVoJmtJx05bahRIpI29wLtSFVa2xy52Xvr7XuYBIALDueG3ZynU9OsAJG7viWqLs8MjmQuZIuyCSdYTCx41T01Ai2e8p6f6mn3oRFJ27Btc2TYfRLvNvjBk5Yo79bRyE+KiR0OzxQBIpIleUELUfaaorQJXokDgSj47LuoOpniHQUfK6m+okMkYP/5Fh7zmpBpagpnzjI+12tvAlsTd017JFDnZB5KcJs5qktsAyJfciiOGMu6wFNvwhEI5wTTU9sQxyDAUJaT7pjlXA0UMCsG6MJf/NoGtg0IHuTbu1am2kmZVvl7TenjQQ==
Received: from MW4PR04CA0381.namprd04.prod.outlook.com (2603:10b6:303:81::26)
 by BL1PR12MB5852.namprd12.prod.outlook.com (2603:10b6:208:397::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 12:31:42 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::21) by MW4PR04CA0381.outlook.office365.com
 (2603:10b6:303:81::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28 via Frontend
 Transport; Thu, 27 Oct 2022 12:31:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.16 via Frontend Transport; Thu, 27 Oct 2022 12:31:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 27 Oct
 2022 05:31:26 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 27 Oct
 2022 05:31:21 -0700
References: <20221024091333.1048061-1-daniel.machon@microchip.com>
 <20221024091333.1048061-2-daniel.machon@microchip.com>
 <874jvq28l3.fsf@nvidia.com> <Y1kaErnPh5h4otWe@DEN-LT-70577>
 <87k04mzlc3.fsf@nvidia.com> <Y1pLHL/d96VKT3kO@DEN-LT-70577>
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
Subject: Re: [net-next v3 1/6] net: dcb: add new pcp selector to app object
Date:   Thu, 27 Oct 2022 11:59:26 +0200
In-Reply-To: <Y1pLHL/d96VKT3kO@DEN-LT-70577>
Message-ID: <8735b9zbvu.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT054:EE_|BL1PR12MB5852:EE_
X-MS-Office365-Filtering-Correlation-Id: 082ca371-6c69-47a8-cdf0-08dab81733f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xg9fYfGJ1q0jI7xZFU12PyefHZmTSRUpAr6v3+ehi+92pfx1NeaJlppucqcTMiPDsoUVduOEsdkX7e3DDyFmibPvOUlPBPwTk44tSujEMa+OlPYPyCWsYVnbeXJdrWpJnr1CG2OWV5vI9KxinJsT1lWMjtwED51dA3+i9oJOOsvBBwXubc4Hxdc3eVmJhxpGIjjC4jgU1cm2UAgnoNot8nKz36Y8J/qKKsd52uK5j1mc2UicxykFwnUH4pK3dbdInGY+eDaEiU9pLT3/AnvVL4lQFCNC7CXC9iSKp/pp41E6dZqMmoR1eZ0YXfnF1S/ZdyHfKb1uOMdx3+0TmSnMyVtY3XRAUSj/wfO+TCELP5Y0YLpwgY4iub5wv0UVNb53/7JWfOUiBhBV+KZazuePHawWLoe/bV776ZXQ6JmCNfnNuqWNouAgdGlDW2uIyJWqN2AMz9e+IpxJea+hOZnL1Jjr/qVYK7rLdMGQfIm5ZvV7gWpc1GJTouyL6QUBw89m48Naead7BamgUVdbyjjTyHOZwB7WSRscnWAOPS4cTe0/9OTsaDjO3GnohwrSCchz5dThXr2gZBE36emRObIs1cKso9BY94D60GTIJiCvfHbogHDtEcpomRYcKEj5Zn6uiimwfDrpSslIp20SBJLv5hqksk0PccKb7dcvMsOLMjeWFuM/px0X0p2I3bcnIfCf/Eh6y9CBSSewLk4ZPiNXQfoQAo2j6KxxFBR8oMGolDLFqlgnLfN0C5EX87G2W3BpWlxpu63REEGsgqoFs1fBeA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(82310400005)(86362001)(54906003)(40480700001)(7636003)(36756003)(356005)(8936002)(7416002)(70586007)(478600001)(70206006)(82740400003)(5660300002)(4326008)(8676002)(316002)(41300700001)(2906002)(2616005)(40460700003)(336012)(16526019)(426003)(47076005)(186003)(6916009)(36860700001)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 12:31:41.7149
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 082ca371-6c69-47a8-cdf0-08dab81733f0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5852
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

>> >> And vice versa: I'm not sure we want to permit sending the standard
>> >> attributes in the DCB encap.
>> >
>> > dcbnl_app_attr_type_get() in dcbnl_ieee_fill() takes care of this. IEEE are
>> > always sent in DCB_ATTR_IEEE and non-std are sent in DCB_ATTR_DCB.
>> 
>> By "sending" I meant userspace sending this to the kernel. So bounce
>> extended opcodes that are wrapped in IEEE and bounce IEEE opcodes
>> wrapped in DCB as well.
>
> Right. Then we only need to decide what to do with any opcode in-between
> (not defined in uapi, neither ieee or extension opcode, 7-254). If they are 
> sent in DCB_ATTR_DCB they should be bounced, because we agreed that we can 
> interpret data in the new attr), _but_ if they are sent in DCB_ATTR_IEEE I 
> guess we should accept them, to not break userspace that is already sending
> them.

I see, it's not currently validating at all. It just relies on the
driver to do the validation, but e.g. bnxt_dcbnl_ieee_setapp(), just
lets nonsense right through.

OK, but this interface is built on standards. The selector has a
well-defined, IEEE-backed meaning with enumerators published in the UAPI
headers. As before, even though this constitutes API breakage, IMHO if
anyone relies on shoving random garbage through this interface, it's on
them...

I think it's kosher to start bouncing undefined selectors.
