Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87AF673446
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 10:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjASJWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 04:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjASJWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 04:22:37 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70552114;
        Thu, 19 Jan 2023 01:22:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PRz+UmnVE6btGiSUXxWukF0pIo9R5espluE7O+sCyBOH/naKxoJTLAiRjYpJKSiS3DHeSdRE+SpI18V6jPNMAcaqWh9+XpKxHEAWyiS5Rs9cXsEhAofkF37SmN7h5dCoCinkB8DAKTZPYwI4sgPwxrgjf/K7vB2jOXDqL8si9PZmdhAwPi+3Mapnfuk0nkvJym1djFPqmpTdoEJnU0X2B7fPXUaazQ5ZvcBRxV9JS7VaYXkXWBqO2+yXvtIwKn4LHoSRy/8k+movLM+CmF/pgsaOAO11ahphhySey28AeScuw2TiVV17jaZpmn56Mz0T0UfQalmPBhUSx5fyB1rU1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EZ+M9NI3EiQOUqNpEIyY+5Ua9bIbRzz+tMNxtj9AaIE=;
 b=ni80F/YoYKRQKq1F9VHoxRxL683UT4tnLf/VOCrr6tEsdEl7k/D8azoU7Y5SnaJX6/lnH36PdhWizfuyqLZouw7zMsxDM3mKuljzJms9RO6u/xciI06bzHGCQNy/W51BgTA9y1AUnIM+PiamPAxqkGKlqadwhk3uaZug+OlPwdlDsS1qF5+mtvlaXwHa2mKORVQvbXyRBKSK9ecXYGKkuifVoTHuU/S097JQVFLyDJWyx5nAFLPwJ/B7hgtrS9BFvrWcc9H6zTCcecdh3LTa70agm/5kN+ImlP84zZ1JBhM/cPuLKoqAhyeSM4KQ1yHoqFKF2MjqFq2Gb8Efh4ZDyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZ+M9NI3EiQOUqNpEIyY+5Ua9bIbRzz+tMNxtj9AaIE=;
 b=L7YAdJmMLYgO0DpKBMpmcr9q7AlqjHP4WAIJ0LP7RO8dhbZR/wsqfCya//RrkYbTVbNXY/rmiLL33AvZSQiITJB4wAriJUjPtBy/QjRMIGKxMwk3YfHAtcTi54Cx6oR5h85G4Qa7FmQZDNOLwi05z0O7ME9QsytX9iYnVP8osERJ7SwT/5EqT69cPyXG2i2s9TnEaeigOd4UNXSEwB3usx9iPVLf2vA1Y57ZxDgPQPKvqS66fs9N7hZWN5qqYmmRBn5fBTmo8ZyvrBOIWsGh/3WU5uX/piYAnVnPFCJ/LxykJsPbqMpykbXu/YSkePZRSSyyLq7gy2DQRVrg3VIfJA==
Received: from BN0PR04CA0102.namprd04.prod.outlook.com (2603:10b6:408:ec::17)
 by BN9PR12MB5290.namprd12.prod.outlook.com (2603:10b6:408:103::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Thu, 19 Jan
 2023 09:22:32 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::cf) by BN0PR04CA0102.outlook.office365.com
 (2603:10b6:408:ec::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25 via Frontend
 Transport; Thu, 19 Jan 2023 09:22:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 09:22:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 01:22:16 -0800
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 01:22:11 -0800
References: <20230118210830.2287069-1-daniel.machon@microchip.com>
 <20230118210830.2287069-3-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <error27@gmail.com>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <petrm@nvidia.com>,
        <vladimir.oltean@nxp.com>, <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 2/6] net: dcb: add new common function for
 set/del of app/rewr entries
Date:   Thu, 19 Jan 2023 10:21:31 +0100
In-Reply-To: <20230118210830.2287069-3-daniel.machon@microchip.com>
Message-ID: <87edrq98w0.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT052:EE_|BN9PR12MB5290:EE_
X-MS-Office365-Filtering-Correlation-Id: fbf01173-305e-40a1-479e-08daf9feb18e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dt0oo8DA3dKjT6WE7CMqqucC5sAc5NwhYc2Xd+E1nQZGBGnFjghRX3acspEOMdClHJwCVsD9ViX629ORm03Vjn5KsJuFujbjUED3wCVLgrkE82C6XtNEMI4l/9UkoMoRtqIrs35XFwIPNhzNKSbQfijta4QWIEu8jqiIQLf1tPDpM7Xw+QMSCx4t5dHTFXdbuUpmhmfHmKHF3Ihlv/Ll3dPaWTW7Y69gg2bfS2ERnWUCxZ+F3yAkBoKzQVxK1FMPXNXzl2gkvVJ4nGFFimcMWHrwqWgvwvUAf336Bo1uEFtrG0wPXRU+VVGptQ02bBhLVZRw51ylnEpv8FyOJmxjp5aKzDXpYCIzJNVJNAWzQfEFnijqY4UHcRqoAn/PZFaXBB4P/2HBUex1TgNZ2qvxNupqSCIuN8GEmM2XJYwm4kXiz+yoZamIVK5E2aEYkLzvdnkZE//nXWGaDNG3IfOHC+5163CMyOxsbvUKRlh/8WCtA2HSm8eXKwkrvT7asqluBZRo78Sw6OqqZeEnE1zO2Uj+f6MFonqkdITb7q1HBWG8O2FsVZgUDgAA/kbVyLzdsQdCgmjOoOJM4oS5BB391N3hQDJqfNiAwR/NQZzYmJEDKmB8EoFMfIxagI5JwCHvJp4z+hBQ0diWaJ8mdhvnVswC+0bgXrOEsI1gadHM7pfQc483MCP7xFjXggItWMZ8mBXD7Ij7THlQ+JZzV5yGOA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199015)(46966006)(40470700004)(36840700001)(7636003)(86362001)(356005)(7416002)(41300700001)(5660300002)(4744005)(8936002)(40460700003)(82740400003)(36860700001)(36756003)(478600001)(54906003)(83380400001)(26005)(186003)(16526019)(6666004)(8676002)(6916009)(316002)(4326008)(82310400005)(70586007)(70206006)(426003)(336012)(2616005)(47076005)(40480700001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 09:22:32.0216
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf01173-305e-40a1-479e-08daf9feb18e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5290
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> In preparation for DCB rewrite. Add a new function for setting and
> deleting both app and rewrite entries. Moving this into a separate
> function reduces duplicate code, as both type of entries requires the
> same set of checks. The function will now iterate through a configurable
> nested attribute (app or rewrite attr), validate each attribute and call
> the appropriate set- or delete function.
>
> Note that this function always checks for nla_len(attr_itr) <
> sizeof(struct dcb_app), which was only done in dcbnl_ieee_set and not in
> dcbnl_ieee_del prior to this patch. This means, that any userspace tool
> that used to shove in data < sizeof(struct dcb_app) would now receive
> -ERANGE.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>
