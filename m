Return-Path: <netdev+bounces-4329-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0967D70C183
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:53:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7D2028100B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF85914278;
	Mon, 22 May 2023 14:53:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6D21079A
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 14:53:16 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2047.outbound.protection.outlook.com [40.107.22.47])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833FEB9
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:53:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=imdO+tm7Rv6gN2z0R53ommnRv0noXhlcPZD9W15pt40i2v9dJw4yDw7XqYff93s3/recBcJrG3Eiboj9FIsYe810ffXVNBiKcyrzsE+tCvf7ISf58RIhYmTzgkZ35m+eR327VrAURAKV0irkGSVEzTi8UrXgXWhyiEtKeVW+QH2vugYF61G5x03ndSfCaQMt/Vj/UJrLoNgtTS9FnOHjKYi8hADViqIQILYLst6p3XhrmQMgrhyyxaZH4OTeIPJeiT4AyUgEQLxqpXWjmZeqznG73AP5nGkDvnw1fonKDVyKPOPw9GnsyTM1MqC3DE2BLDtGkQ0e6NaXyHLiuP4pEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8lOfXB6MipdMgQ4iwAKyVmmj/PCszGSxBHKa0t0iRQo=;
 b=nsFt4a+1hcZCmMi4c/+X2t6FwtH3QCtTkWiAAQCU0Lnw5YlEgEMfxL7rJkNdqYqCBzp4PSUyOV1QecXkuQ+FpanS8mv+mm1Tm89tr1yJ19h4NhbzYlDBnH44nnn2BbySFs8NPbla44G0eu6VdodnHlh7gWG5oaLjuRehhOi3PhpawvjprJVI5iIrNij9Rnf6TH5ULhggYXSnECrBgiqdPAU3BK7rcsNSW69NXmugQ+u4vB6udursBWk/+waIYV8vBdmGadTU1Zh06vjeupTHt4jB4IJYItKeuNJ6F5tyWu/kk6SbkufJYOWW6eRVAGdRBm6D3DdjPhbdf/XELaVhfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lOfXB6MipdMgQ4iwAKyVmmj/PCszGSxBHKa0t0iRQo=;
 b=OLVUusrcP8Et+JB1QDAhvmaDWeqvmw6qL3Dly37CDcRA7qlmCQNxbE+keR6ApIj/zvVhzYTrHOniQar/wTAceA8ItZsxKWez7xQrEtymd7XTUd8qfNy9EI8WD8JCxhrzVWx/6AVrjwQDD8FWieQTkPp477HB3PQd3/tSMTH7vGs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
Received: from AS8PR04MB8963.eurprd04.prod.outlook.com (2603:10a6:20b:42e::18)
 by PA4PR04MB7856.eurprd04.prod.outlook.com (2603:10a6:102:cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 14:53:12 +0000
Received: from AS8PR04MB8963.eurprd04.prod.outlook.com
 ([fe80::9e27:8c41:a8d:938e]) by AS8PR04MB8963.eurprd04.prod.outlook.com
 ([fe80::9e27:8c41:a8d:938e%6]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 14:53:12 +0000
From: Josua Mayer <josua@solid-run.com>
To: netdev@vger.kernel.org
Cc: Josua Mayer <josua@solid-run.com>
Subject: [PATCH 0/1] net: sfp: add support for HXSX-ATRI-1 copper SFP+ module
Date: Mon, 22 May 2023 17:52:41 +0300
Message-Id: <20230522145242.30192-1-josua@solid-run.com>
X-Mailer: git-send-email 2.35.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0199.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:57::10) To AS8PR04MB8963.eurprd04.prod.outlook.com
 (2603:10a6:20b:42e::18)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB8963:EE_|PA4PR04MB7856:EE_
X-MS-Office365-Filtering-Correlation-Id: eb3ec3cb-61c6-4f0d-6d68-08db5ad443b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kCxEZVn97TVicY1ooowV9XRoPDklqR8AgjBXlZA9juR/+dCCyr/frdFqtv+W5rHmslPUuCh18em4/22haciNDKP/sQm+qYJ1dv8bnJKa3oBbpTpdLG8ZX9AcKX2S3sFPJ9eTJh7aKtjHdryzYGYxrJICiZI74G4bb+DwqV8c61bJLp0BWivn4mHjSFGtd18q9A+yacnZmrIdIaHwA5ohgPDeQ5QWugymzZhhYxHdEMk/iqMJcKyihYGBYRVKdhqTr7GIYzLplr3JH7Xk/vMiTmwANi7SxpgcB7MKBzdj08745DYxZ/DuYLr629zCDAK+wfmDcIJWcnrBMaXSF1YbfuLEHg2llJi4FPQxnHWycLX3Y2hOKbwXB2BSOhbaQNqal+No1pW97d64zszjBR1+GoNmi3W3iLAD9nIYnksFOfxY8f6I7KEp6onaheB01uKY1gewOTjmPqJULxevT/SosChX6xDSR5FT4ho3x14DcyV7ZJmInJB+XjceyS1izTAXeCvd04cpHidkru1j2kMQnRJi0EqcDqhRYlOehyv6KFn2IsxcCsappnVKCp8wVJ3hAOGQO6MkN/iBgfbVkh5gos1acq2rjvwNzG/tcNCwPrS9Z9oEBHM1WP5NhgY5w+H3
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8963.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(39840400004)(376002)(136003)(451199021)(8936002)(8676002)(5660300002)(83380400001)(186003)(6506007)(6512007)(1076003)(86362001)(107886003)(2616005)(26005)(38100700002)(38350700002)(41300700001)(6666004)(6486002)(52116002)(66476007)(66556008)(66946007)(316002)(6916009)(4326008)(36756003)(478600001)(4744005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1Hm6vgGXFvYvxqJrRdCSQ5Q/L6dcnmArE88h9kch5l1YLBgD/HpoCvvCsOOv?=
 =?us-ascii?Q?HTX00jfAqCMhp0dhwdAqehBAPNi9ydkko8N+ajhzOn3kmFVLuFtnwLsj7sCn?=
 =?us-ascii?Q?TGpV0c4ErQzgewX8SG/MnxdZivS5XLNPbsfTIEp23rvo+3iCJx7DtQD/kJC6?=
 =?us-ascii?Q?4Ymh2V8VVCIjDuessJA0s34qmeuw2alYBJvFuBHjWF/Urb60IbgS3DdSG1iA?=
 =?us-ascii?Q?CKt40V7SG5sZTNr5OmZmAAbdC3SvB9Ob4ZID4iBNlipAiqpGmtjUSVd6sjTT?=
 =?us-ascii?Q?7Y+ZepIHQuCH1WiMA4o2rVDZqv+tSkAc7gceP+01FRDEWLp1R4tPBT+Q9Ooi?=
 =?us-ascii?Q?jlklmrLC3wtg4yj/UJ/Y5WJB+Ofi78MUg76ak135IQz+itDa6LbhAXb2SCmu?=
 =?us-ascii?Q?G0FUo0D3s5Vq7jEv8oaBueT/Q+VoSTyrz8T6CAQmf5wtJfnUu3Mo6bOVHX5p?=
 =?us-ascii?Q?SZrxplz75alKIYGAAViNBEwTMNYL4FS1aKoaa/YLrKAQBKwpnlggPeQgtlUK?=
 =?us-ascii?Q?oGtoa2DNLgz/4RzHsDllKYdm609a+gqg/oO3t+0bxxTmpYZ1LJouPZIRZlKr?=
 =?us-ascii?Q?xfWKh/2CUiRUbRj+e1wQjxv63+KlqLTvJGRkJmh4SMEUi0bfuedo4kF4v7Fi?=
 =?us-ascii?Q?5YZRLH9Z9DENY8t/honXZejv9MqoLMZuTs2kCNx8CeMbQISBFRN3OOk2BsA2?=
 =?us-ascii?Q?XW4oCoYdWkCidCEIHWFGQY2IR2iXelilMN54Twc76oj5tUTezU2790jFAhns?=
 =?us-ascii?Q?1wALZ3InpafXMgCLTJfVQAhAtRFvihoiYjedLeWJwImvIdtbEr+MOyzYQCWY?=
 =?us-ascii?Q?CU0id+q8eg5mlpx/L4hS2d4c4n3LXNHYOmdz4zUBYgETKA0AhF0EwgEzduvS?=
 =?us-ascii?Q?uBfOb4iwLXUlgN5G/YuOZkpugkQQLrNJYXpSSHbxEOox1ZXAAWxz5Zpwafpd?=
 =?us-ascii?Q?Kkojugx3DrhJ5Op59vc8bl2GjXKQxGDF13A/3M0Yqp5Fk+BlzbKWJgIooF4y?=
 =?us-ascii?Q?YV/grJj/N7XD7IhmYA6DGRK8sDb7SyF+3vIr53brwrPpoxv8QNSwTFd3jI1s?=
 =?us-ascii?Q?MNYv/GDrnIJe3w4WfRBP7a1/z60qkgFG6hI3LiOmFoIN46fQjZGm75LWxB7j?=
 =?us-ascii?Q?MEsMgsx75tg7ORwz1Lw01BcboGJctox/WAI8hgjBaxZHEYTFlLl6X2HUCU7M?=
 =?us-ascii?Q?39Uo/TwdTkUjIONyNWbOKtfQE121KI/gbOBlEivF1/JVAZa1OlJXP694MeY0?=
 =?us-ascii?Q?3AM+pUjtdPjxcd5ly0H3cfEX6AEquAdn/p+ePea6ZmY72CxSdysC9MVLEV/7?=
 =?us-ascii?Q?Dzxz5Ah/bCBVDsvtxom1udzItFOz+ehMEFsL7IUiRmkaZ74TLxDIZlnwLRdy?=
 =?us-ascii?Q?RT4FxMLZqOsgwTJCguaTWNfXoCXaT2KTpVSz6ArItJlFiVpsYICIaJdezu5u?=
 =?us-ascii?Q?+r3BE+qr5pW3jhFsK03UlRmN1lVs5iyHD10X4Vh7JFllGdUAvTebohXkLh8Z?=
 =?us-ascii?Q?5TVIqO77FUUjAXIiNYxICSEx8EWfzSNEVIL60yFGpHwDIn8bUc90tHqjcSZb?=
 =?us-ascii?Q?rgl8f7rRelhaajnV5BWCu9UYEn6zpImYphOBpG9a?=
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb3ec3cb-61c6-4f0d-6d68-08db5ad443b0
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8963.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 14:53:12.0644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aqadfV1xUz1dy1tHqKhte9ItOs7epB9xaBdArBM0Dsc22VvmNNvvx45+2l2aXL9imPGwN4c00nBdzI1zUgsxDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7856
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add quirk for this SFP module, which is the industrial version of
Walsun HXSX-ATRC-1, for which Russell King already submitted support.

Please apply only after Russell King patch:
"net: sfp: add support for a couple of copper multi-rate modules"

Josua Mayer (1):
  net: sfp: add support for HXSX-ATRI-1 copper SFP+ module

 drivers/net/phy/sfp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.35.3


