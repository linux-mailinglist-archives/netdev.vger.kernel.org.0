Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389B25F4142
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 13:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiJDLCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 07:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJDLCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 07:02:31 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2070.outbound.protection.outlook.com [40.107.100.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6E62529B;
        Tue,  4 Oct 2022 04:02:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NeFZjgxDT8kkvsGs7jJfUBY0oSwaGK+k/IZi99i86ixvO1dGxEd5rllAFl8KvsvFgpyya0XzeuydTuqapLcpPcP+OYTk2OrsMi/gbitWtXwvwFQvrtBA7t82YJtpwb2jC4TITg5i1+PIzTVYVOjFi7HH/LIT5hHfZavqKIJJgPpvUyIdqHBt9WqHm83IxepY5l9jP23XqzwJil892ZUmmjx8N+XJPtdSqp0AbWidRyNPHKdLxqKz1NSMfb+bYChBfu5Yixm6NAbFLs1mDGaxoTQ3d/UnNmH8gkXvdTxy92pTQabq5J/eLCHcR7eZEnTw42R6s4p9jOsgpCehV7h2wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cW+hhd0j3YCHRD3d/+ZzLofVEKIBEg+PKCpW3nJagAY=;
 b=Bk8mhCOYraAVoQU0qxXUUTfu1FT9F74e1D7VU6lAdKRKqA/DpbXhrf3q+XmFqD4XyL5Np7YS9e3kD1CN5Kst7o1pqF9Xmmve/CReGL0bPaxF2kSdSQKl2LN5P7/eYxm4NZQH4oe5sHxL8LkjO4VGgpUoKGJQl/a4eVq40QX8A31zcsiyyCocEYgUITaC/wHaNMDmU9xr1E1ZOj43PI1iVjRbnCc7nlAbir8ExDkBoNlk+lB4JzPwauQ3k/JHd7R9Tznyeei+Qq8OS0uAU9q0Z4vHmSSkr/XzTX8LdqEXCgODEJsAjKgNG+PZQuBG67kKXKoer2+jaO1Dgui+3LwLeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cW+hhd0j3YCHRD3d/+ZzLofVEKIBEg+PKCpW3nJagAY=;
 b=b9p1YjfgXrZB5eBQr4czICciF237rQ0DAMA0qmS8fMCHmFA1WrGBOZWrcBwiUD0AneMetYESBUFpAt6Q/6kRLp4YeEY91mU2athVgBDsPf1/lmoOM2YdeIVfzODXXdVtJ+QTjVpQztgQrjhoGEQ5GzaSR76ADV4DHVdonFt2VWAWS7wB7AoqplBwtlltogiLoFc47ejIcz2S9a0VbFDT+SYlBscIn6Gg3I+f0DyNOCGxtl7NVXVlNXRlx6UKyPDIwAlrNV9tmMDMmEBBA/VVfQmTUqSBoGZosDc4qvWfnMDLYrgYOWFIiUqgszdor6ssn/mford9KyWtQB7Q3CqjRw==
Received: from MW4P221CA0022.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::27)
 by DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Tue, 4 Oct
 2022 11:02:28 +0000
Received: from CO1NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::ec) by MW4P221CA0022.outlook.office365.com
 (2603:10b6:303:8b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.32 via Frontend
 Transport; Tue, 4 Oct 2022 11:02:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT072.mail.protection.outlook.com (10.13.174.106) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Tue, 4 Oct 2022 11:02:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 4 Oct 2022
 04:02:19 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 4 Oct 2022
 04:02:14 -0700
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
 <20220929185207.2183473-2-daniel.machon@microchip.com>
 <87leq1uiyc.fsf@nvidia.com> <20220930175452.1937dadd@kernel.org>
 <87pmf9xrrd.fsf@nvidia.com> <20221003092522.6aaa6d55@kernel.org>
 <YztdsF6b6SM9E5rw@DEN-LT-70577> <20221003163450.7e6cbf3a@kernel.org>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <Daniel.Machon@microchip.com>, <petrm@nvidia.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <Horatiu.Vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v2 1/6] net: dcb: add new pcp selector to app
 object
Date:   Tue, 4 Oct 2022 12:56:35 +0200
In-Reply-To: <20221003163450.7e6cbf3a@kernel.org>
Message-ID: <87r0znx363.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT072:EE_|DS0PR12MB6608:EE_
X-MS-Office365-Filtering-Correlation-Id: 503fd27e-fca6-4e7c-9be8-08daa5f7ed66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LmSWybQcrt64TFJHt8tUehc+oGhkFzGAIkGQMLxNjQIhj14rtGCYfCTHRgs22wBbTjN0WkcWtZVCp7BR/X9JHNg5K/oEBdBHlUZ3NYGFbbw1LrIPYW60Gx0du1CXsJCfiVd6FM5t1hXhaLlbo+3WPVwKBm7tmyzZgtH/39ouS3D+UEkSYRkxSsAQUsVCHwzvJDDmqilQ+VFkZiajrsLINUo92eBd0rnOdD72qaHgeF2ZJFpaPfGRMAwEG5dOrB6LeSi2m2Zo9FbTCY1eqki8iejymN1A2MsYcSqUJf2KxVehYZPhCw1DY2I0F1zKPDkks5yaUfOWFDU2l/lz+eCf4gqgTVtjuKk3Nkf8sMs8ijnQazWXNDeOJMLh89Jyzwr7xefLwxAbnQZDYD7CgBPqVkFOOpREjMLrQaGt/tlRZOqYIjd9alVOU/giYZudcABSrKcMCejt1c5Q+XEusXhvOovzSG7zEyW+JdhhcAAXPKLYH0+WW5E7D7bFjMhGH8oR663RleLumXV0qZtIn6VYXt1k+lu/25feNz63SGjYv5g6dkXLyesnkzlwZCdWCjfLzANf1ZgWuTOSNs1oEGLEFiaphQvi087feF5i1Um8FGcocuidnWNmAzCFMgwMvX9+4KsHpRwwbSAGERiJ0r5TUV0impsvmTsqlcmIW4SoiVe2hUPi8r94Ww3p1IL3wBr2cKqqULR7CF42pZ6f75GbzQE1TVagxwgZDtXABE3qLofkNYOuXOyjl3ZlMhqK85QXJiyysiUuRcRpMf8X3SFs5A==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199015)(40470700004)(46966006)(36840700001)(41300700001)(2906002)(5660300002)(7416002)(8936002)(82310400005)(36756003)(40480700001)(478600001)(82740400003)(86362001)(4326008)(26005)(2616005)(6666004)(54906003)(70206006)(70586007)(8676002)(316002)(6916009)(7636003)(47076005)(36860700001)(426003)(40460700003)(356005)(186003)(16526019)(336012)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 11:02:28.3682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 503fd27e-fca6-4e7c-9be8-08daa5f7ed66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6608
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

> On Mon, 3 Oct 2022 21:59:49 +0000 Daniel.Machon@microchip.com wrote:
>> If lldpad was idd able to emit the new pcp app entries, they would be
>
> idd?
>
>> emitted as invalid TLV's (assuming 255 or 24 selector value), because the
>> selector would be either zero or seven, which is currently not used for
>> any selector by the std. We then have time to patch lldpad to do whatever
>> with the new attr. Wouldn't this be acceptable?
>
> I'm not sure I can provide sensible advice given I don't really know
> how the information flow looks in case of DCB.
>
> First off - we're talking about netlink TLVs not LLDP / DCB wire message
> TLVs?

DCB wire message in this case.

> What I was saying is that if lldpad dumps the information from the
> kernel and gets confused by certain TLVs - we can add an opt-in
> attribute to whatever Netlink request lldpad uses, and only add the new
> attrs if that opt-in attribute is present. Normal GET or DUMP requests
> can both take input attributes.
>
> Old lldpad will not send this attribute to the kernel - the kernel will
> not respond with confusing attrs. The new lldpad can be patched to send
> the attribute and will get all the attrs (if it actually cares).

Another aspect is that lldpad will never create these entries on its
own, until it gets support for it, at which point these issues would
presumably get fixed as well. The only scenario in which it breaks is
when an admin messes with the APP entries through iproute2, but then
uses lldpad. Which doesn't make sense to me as a use case.
