Return-Path: <netdev+bounces-4764-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 018A070E280
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:57:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EF521C20DE3
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD2B2206A2;
	Tue, 23 May 2023 16:57:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5681F935
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 16:57:27 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6094EE5
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:57:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V10gTjHviLNuSmhi5rUREaF7lsk8s+ep/03ctDcs/Du3rAr7myZbgbgs/AqVXTxoEXbJWU7fzyqwaqTx9p5yUd9kSYZi8flCMeVUhPdnUS9l5nV4Yx6gOLpJjuEyoyBMH1r8hga3ERLemC1PI0CsZTISJmR9W+jBi2se2WxqyMIP9ZeZYsXRdWlSVzG5SJSe2IdHsmpz2iaVvN2YWaEuewxK2nYG9Km1EJm0CcrtMWj3thAw8OrlaDjUy78U0nKEjLkgI3WJE3Xv1z2v+SayAIaoqj1h+8iajvU6O8WzJ/XBZpWVo1XrILdjPgJ48WXQiRShcG0anXkyxwYc79R0OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WSQe91nPAuDpDoqXvgAlDqgvYFHBS+hefrbCS5wp+yY=;
 b=koWLXnnzKAE3ikroYhqwI+Kp64n/c4tDx77MEcpdP4AEoQ4ndV9yyhJAkilQoRbgEAwjQAr8L9AjZe5rpzBrPpzSdVZKbL7LCo4umaZAqeaywfkoXfQZArEpW/FSOPCJkoKTBAJ31AFfNlg3pwYiCpT1SoQdG3A2TFNpPeghWNmMlp1ylnRH/p/kr/ubBvWyN3dI6yBXUP3uNA0ZuQxIJohiVBq/LARa3juz+THpNXO+ku/c89+Z0TTQvviu8u4T83YUpOEO71NeUg8pLQ8PfwDNnl45BipZPy7hId5wVCxtSTxa4HMDlAqNV7YwCV15w0EePFseA2M5z4kmoMnFdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSQe91nPAuDpDoqXvgAlDqgvYFHBS+hefrbCS5wp+yY=;
 b=eulsoGBBb0YVmflPlUR8+oNFkuU9RRUi6/mmMpJ8dS5sjvq+GlMZcdZD/ndGqVmfxM8s/a9SgTBlmyUdD3Yrk17NwPOa2IHaQ4kYFV1QS56/qZemue2RVVVgwFLRcEA6cr+Pn+VkwuvwLI4vhvJvic18g/XC6BayW6So9ULkzlK4AJnQ9idQr9LPgA/RtsRR/RbpvY3x2FKxdwUEtwf0/k14FpdJ6cYWZ7XmW5L9CatCxGBO++c5cq7ZYBp3K/VbhEJwdwbxxbDNf2oWrYCcXtDKf/iQx8o51FMTRdYMD0VHukgqOPVI2iQdTmDHv5rV8W2n89g8GsIQbOkWpgAMRg==
Received: from BN9P221CA0027.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::21)
 by DM4PR12MB6351.namprd12.prod.outlook.com (2603:10b6:8:a2::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28; Tue, 23 May 2023 16:57:13 +0000
Received: from BN8NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::b9) by BN9P221CA0027.outlook.office365.com
 (2603:10b6:408:10a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28 via Frontend
 Transport; Tue, 23 May 2023 16:57:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT098.mail.protection.outlook.com (10.13.177.196) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.29 via Frontend Transport; Tue, 23 May 2023 16:57:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 23 May 2023
 09:57:00 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 23 May
 2023 09:56:58 -0700
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
 <20230510-dcb-rewr-v1-7-83adc1f93356@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: Daniel Machon <daniel.machon@microchip.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 7/9] man: dcb-rewr: add new manpage for
 dcb-rewr
Date: Tue, 23 May 2023 18:56:00 +0200
In-Reply-To: <20230510-dcb-rewr-v1-7-83adc1f93356@microchip.com>
Message-ID: <87v8gj3s13.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT098:EE_|DM4PR12MB6351:EE_
X-MS-Office365-Filtering-Correlation-Id: 529322ea-76d1-4195-aba1-08db5baec140
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NicziReOFoCxRIDiHkhNMTO2a41JvoV5Hc6Z8JFI33dwB2LRBNiM8U9dPjNoE6ZKxjwmjYqlj9iuye7W4Z3G+3GQUY71Cbs8hnyHpNVRTZTZbRmX92UytzfRmc9f0X/6CNJLVLBTJDN3N146PqjY9kJKQwMAgBCCdCwSbxaLzxJJhzNSJ0qyllGrbog7SM6Dezg31zJH9ehq/kOKEFLk5oXk8GZYOi/J3AzgoKwSNpYY0+KVPNJMXZET0nsYeM75h3Hx3PrtycHRnQyhk2Fkyvxz+koRQ5hMmdfKvDJKMygHiWElNwkykhgDh0p0PFup3Vhh+O/58CJdbiZxGyidgPbYjt0dXC1p50CkaqQFNh6UxFD/DOkES4UyVRCyZ32lNlzcDnNo6rINHDb60n2+Q+7ocR+ckEeu7ZfWUWcRkH3jeDvwH4Rn8+csx8wSd6xEebShhz2pXko6lDx9bq3OuttUQbxo9leh4c2DmYS3JdAgbfOb2N/A/bxHVUieGWPtLFj2+BSlxPgpwW4+/Uyc1we+332YcBXZyXH5tDKlllLFHw/6mfkt+vxPBSnoemzP+oryxxqJgwvC5RbYky5UDjE+OB5f9WnRTftM5azKRhfZ6qDvUm/tpBbP0Es0qXeU9fQZAFRo5QVziNw1UqLfe/WJ3IIQZsVsah3KevPwfRAOOAlTT7QL8LPulUqDAIMWJPC7WmlOrSu7FcQxRcN/7xXgJJbcRIiMEXsiLU6LdNwWOGyVjYh3HBbesh9u1GWv
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199021)(36840700001)(46966006)(40470700004)(8676002)(8936002)(5660300002)(47076005)(36860700001)(82310400005)(186003)(16526019)(2616005)(26005)(86362001)(356005)(336012)(82740400003)(426003)(7636003)(40460700003)(41300700001)(40480700001)(70206006)(6666004)(70586007)(478600001)(316002)(4326008)(36756003)(6916009)(4744005)(54906003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 16:57:12.5860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 529322ea-76d1-4195-aba1-08db5baec140
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6351
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> +.TP
> +.B prio-dscp \fIDSCP-MAP
> +\fIDSCP-MAP\fR uses the array parameter syntax, see
> +.BR dcb (8)
> +for details. Keys are priorities, values are DSCP points for traffic
> +with matching priority. DSCP points can be written either directly as numeric
> +values, or using symbolic names specified in
> +.B /etc/iproute2/rt_dsfield
> +(however note that file specifies full 8-bit dsfield values, whereas

... and please whatever form the "that that" ends up having in 9/9, use
it here as well.

