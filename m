Return-Path: <netdev+bounces-4922-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B2770F308
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:37:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF04A28122D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D689BC8CA;
	Wed, 24 May 2023 09:37:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD57AC121
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:37:22 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20603.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::603])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11B012E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 02:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Unn/uhOcZCH8M1+DlSl5bkq6lc70kc6VVSgK6wKNDrw=;
 b=hSV2NfsxnSi327ZKipfgWWQRptmd4C+AiJFBGh8UW9WSsuDBWtS1buOsqFTcwRQknTf33U2Y02kvl47/8Hl6P4f3D+2x9UWHKTLRkCNcNU9iWKnwqokD0sz28gOREDCktPyFXoFNX+lZePlVmydClLOddxDdih/fhqUeleaIeUgFRrprUQSGKQDrOtKWP9OUm2twOdIDvYIL0uwWLSozdAJkcbtMlqtH/VM0O0vqY/0FucvkvYPCalcvcmePYa6WyfErO1wNWGMDgtbbfPF2s5AbUzMFb22qfD66S1MKvZgVPp0gqDqXVu268xlWUElACdO9qhEWFCjOYSDOaOzEdg==
Received: from MW4PR04CA0226.namprd04.prod.outlook.com (2603:10b6:303:87::21)
 by SJ0PR12MB5675.namprd12.prod.outlook.com (2603:10b6:a03:42d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 09:37:13 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::d1) by MW4PR04CA0226.outlook.office365.com
 (2603:10b6:303:87::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29 via Frontend
 Transport; Wed, 24 May 2023 09:37:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.30 via Frontend Transport; Wed, 24 May 2023 09:37:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 24 May 2023
 02:36:57 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 24 May
 2023 02:36:56 -0700
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
 <20230510-dcb-rewr-v1-1-83adc1f93356@microchip.com>
 <87lehf5gu1.fsf@nvidia.com> <ZG2xBsorejY7v5l1@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: <Daniel.Machon@microchip.com>
CC: <petrm@nvidia.com>, <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 1/9] dcb: app: expose dcb-app functions in
 new header
Date: Wed, 24 May 2023 11:28:34 +0200
In-Reply-To: <ZG2xBsorejY7v5l1@DEN-LT-70577>
Message-ID: <87r0r63way.fsf@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT055:EE_|SJ0PR12MB5675:EE_
X-MS-Office365-Filtering-Correlation-Id: d9d8af72-0712-4e89-46b2-08db5c3a746a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9s+qbZKZ7xiAF8fbVKvrU4iO9UP9ENtqc2oPqxUluS12/0yI3lPERCvzioT2suIKw6Km0ySSQo1fYxpHDwX+oVqYUqGn5/iqlikQy1CvE8V49eIkkj4ZnqailPLno9CnuBFkhnt1qDaOkbJXqprOFxqH0CmygmQMFRSyoLqus4Tkztrke3t2R+SpYgVclH4FwdtaqC4FUM0477AeC7tJFe62emt+M3DTfeL1zoIODC64xkaZ3XFv98OTSSdihPHiALC/fJdSFoYBH76BBAPoG1THcd5dzGG4QB5wYbLe6G5jCsXJNeCbUigUV2aNO34P3NdG8RcuCYEDZbqYAmx/D0kSg9llrUSDVj2gp1JFXVsY0L28OOIohV6D9o9pN8pn8fHEplzrN/ACEjLbfxQu0XjFblR6+Lr5qlgJiJx9r1vNB5KRyF6ZSM4xjm77UVYD1ye5xbhfWkHzLePih5IJtHXq+cxguchiPDBeGG/J0X6WC2e1qDRE9ZoBdETkT7rUYLuRJaww3D/XLuTYpuSwk022Js5CFXp3vc/89mZlnmlJy7/UJnjuq+FMVSwyJLCMA6lusSU2Ht8JPtVfiLa6kM7K1CQ6cjGDnWvZB9K91ovdsy2hyNe9240jlhPd7neFAEHYlodSAEA+a0Bat7gkt4VIeRkFskB1NAeSdH89W5kS07KpPT8DbLJJsBE68WHrUFgs4soG0tZi1t6w9ws68Mh1VWncNBtiQfBDPgikOD2xn9z5OdCaCB4tWh8Ls0hX
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199021)(36840700001)(46966006)(40470700004)(186003)(40460700003)(356005)(26005)(82740400003)(2906002)(16526019)(36756003)(2616005)(36860700001)(47076005)(7636003)(83380400001)(336012)(426003)(40480700001)(316002)(6916009)(6666004)(86362001)(70586007)(70206006)(4326008)(41300700001)(54906003)(82310400005)(478600001)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 09:37:13.3100
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9d8af72-0712-4e89-46b2-08db5c3a746a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5675
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


<Daniel.Machon@microchip.com> writes:

>> > -/* dcb_app.c */
>> > -
>> > -int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
>> > -enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
>> > -bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
>> > -bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
>> > -
>> 
>> Why the move to a dedicated header? dcb.h ends up being the only client
>> and everybody consumes the prototypes through that file anyway. I don't
>> fine it necessary.
>
> I did try to rationalize that a bit in the commit description. I thought
> the amount of exposed app functions ended up polutting the dcb header.

I think it's not too bad. The dcb.c section of the header is similarly
large as the app section will be. Even with all the stuff that you
publish, the header is still, what, 150 lines maybe? I find that the
fragmentation isn't necessary and the current setup is just super
simple.

> Maybe it is not that bad - can move them back in the next v.

