Return-Path: <netdev+bounces-1714-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8450A6FEFA0
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:07:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 401D61C20F22
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B3C91C760;
	Thu, 11 May 2023 10:07:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DF51C741
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:07:17 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2116.outbound.protection.outlook.com [40.107.92.116])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAAB211C;
	Thu, 11 May 2023 03:07:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nABhR065F3BlO63vQz/yStwRbLQ9FQuKSiCFGoX6E/2df50N+O9WL1hsGiyeHImJvBocHvlB8XLfvUbCX3u5pKMTgliESY6jqj8xwIrsfXqdKQCDym8Lz854jF27jQMy/nJ1DKmC30TOCs1/x07310WLVPzicFONpdXrZqXGLq85boBiJ4gJu7jtE7hg2UWqP0SstDzdHCE5VHfT/9FULcNHe4jtHABOZ16MVD0v/t0/EEwZKMRjwHu38wZkrOsmJxpxOH0f1Id7qrjcZa9Xag5ltrri2HDG642JoVqoDZEPro5vbj8Da7gZEd4KmoXRJI8RuYr3b0dkS9Lqf5MDIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wi2rOQPPIiLgAcRx1taE2FmVZeYcjeMRh/YHoVgqB9o=;
 b=RmdehjQfwzw35aK7dViPxhI5YhURmAVf6uCyMlVRuhyXXLyZfN1nVfSQR1wswOosO48jB8aCyLRe/sz7AhVuQvfRTbuLCobnSBFm6YNMtqBlbwIJLHWj9Dtq4hZAdjv7iH5kB3VkSX05qpHkyOPiQtZq09QCXJuSlfVItiK05I3g6aSiBEbWR+jg7aVO3VWfTD7vaU/aBYK/tFe00KAqmWNPrVH3N2wscsUTNMiIck5tLfIq7zil7r4zLC5HdZj2ZaSN3qdnXaxtWPbEqiEVMHWAWQEzucS+VypQBD/OVrToyYOqucgtXtp0XTb23FV9tZGrchxTXn8T61JWvvSfwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wi2rOQPPIiLgAcRx1taE2FmVZeYcjeMRh/YHoVgqB9o=;
 b=u+bBYieYS3nNX4qzEtlGpGZ+EAuttjc0g9p1sCQ96iaN92TAbFiwhPRybS7utuKhb6+fDsI9uj4xXLrgJz0Ufp2XJ2/On/si0+MkX5mrqHjp/kG4nDLTIfce/EL2nhHUYTJj37h5PHUjHmwWxuN2Q89D1jNnm5IUSPU0pFUVrJA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5223.namprd13.prod.outlook.com (2603:10b6:5:314::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 10:07:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 10:07:13 +0000
Date: Thu, 11 May 2023 12:07:06 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Siddharth Vadapalli <s-vadapalli@ti.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	srk@ti.com
Subject: Re: [PATCH net v3] net: phy: dp83867: add w/a for packet errors seen
 with short cables
Message-ID: <ZFy+SnPWIn8aBRxg@corigine.com>
References: <20230510125139.646222-1-s-vadapalli@ti.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510125139.646222-1-s-vadapalli@ti.com>
X-ClientProxiedBy: AM4PR07CA0029.eurprd07.prod.outlook.com
 (2603:10a6:205:1::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5223:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f72f40d-3613-45ac-13c3-08db52077d7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zQ97akHl2ut1tMYn5ZKQ8m6XLysbjUrG+/TRaac4WXvFV5536PctRDRNQq2M2yMUrifgXQNhSmaOnJ8tfCRkWJLLj824NJjV8EG9DtM2myJ7MR8f13o4hnPzNfo/DzDgMXf6iVkXiOW5WhKypZ+j1X9UXdY8k6AO5cKCf3yuqY8rfJW1+fdjiB1iketx9JrDRUIwLZzHje7bbkOAKI4uw7Q79s88p9aOHVXiOYCVRkJmQs8KW5AeNBuZeYKhYRN8F49Oi3cAkpMQx15d60kJdDb+opSKxHuhjvhgyqkvRJLKiGXl40xVoe1sYV8yc7mRQHAEwORINBndAkXML8F+jZO9eGHlRuoZ/uAfDQJeeK+gVsBPHWNQW9yTEcO9N+xVoKyzz823J1tqE4mB/Cr8K/8CRB6ZNqnuyvEOu8iNXjq8d/BYomq5FwuopiepGTgPxhbL4b7A5qsI2JTh9jj5LvKOpFJfL2+Bta3G41WcVcakvD+z8eEc0MmAFK7HDn4drFzt1lXUfG45stZZWll38yaCyt1zJ2umAedCN5jd3oeXZ3mhrnizNkToR64s2gVCPgN40cUg1A4RtTK9rwaXJ7hL/+Wy3wTN+HXTmfnOCIdSr4eqEgC01hGNV5Mg3KR0euQZ3d14SRaUh7RmdnFZWA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39830400003)(366004)(136003)(451199021)(2906002)(4744005)(86362001)(36756003)(6512007)(44832011)(6506007)(7416002)(478600001)(186003)(5660300002)(6666004)(6486002)(6916009)(38100700002)(66556008)(4326008)(66476007)(66946007)(2616005)(41300700001)(316002)(8936002)(8676002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oETSPRZ3t6t6CYiB/y1oDtzVHiju68XGFW9bzp4BkdjR78UYg6jPWHbwlKGC?=
 =?us-ascii?Q?pW+QglngsQCg1GVe7JBDHP9W8n4EkpMDAHKS2WO0A0axrhwhnQVKYn3dljIk?=
 =?us-ascii?Q?caojns6zIS3Bv2PUiBnBnWudqWx6ZVrQkmXl2KH0yQQjjj2OzuwYvzIe6Jtn?=
 =?us-ascii?Q?iCT6flhXuX+KWXQEdJo/oztd5qjplk14LIso/bMsnmXP+WJ0PTAS4k0a05rH?=
 =?us-ascii?Q?oZ/VKZJtSeK6XH1MxvoU9R19u2oKUR4bJGnz1fAJ2sdYHCvS4Jh1tx8mrpot?=
 =?us-ascii?Q?azNB+AGnP/5vH/qXs2mXTPqNMAjcxQrUti+2vEDACCWzpbWbE6UXjFe0sxSI?=
 =?us-ascii?Q?vB6O2RtzvoGFoFEIv3MOEr7YH10VIwmaiIjWUyDe7ZUczAzHiIa0qZiH042A?=
 =?us-ascii?Q?i5+Df4rF7HuG0Tc96NufgnEX4RFbI3WFVWK4XyzhM5uNoMGSulkU/4wJprL4?=
 =?us-ascii?Q?K4WLYIYbQcgVvXlmF4W78SNtSaGSpDda31bW27VPL7yO87jG+Me+NGz6mNo/?=
 =?us-ascii?Q?P8irKIbK/2CL0YBmYqhIaraUFdNznng4axS9w1grmfroNblt7+tvWus/E8pt?=
 =?us-ascii?Q?77Mw65eq5fdHT44/c76BrXsReBmiCVUY81ciLVewgKZq1/lXQFtfXOXqC/h6?=
 =?us-ascii?Q?CpvFcPhT4OsjwxzNHTwjvbnoxzrYnhLdhNtJP/l44LE1q7L7KXCAGBs8/M6B?=
 =?us-ascii?Q?K+yzVKB4NQe1r5UKF8WnJhXDz9riP9102u5PQSRkdabYmoGiwc0YFN7x7TBS?=
 =?us-ascii?Q?fjGpY9qno9ElWejTuGfrpXVr/8XABb2ZcccTqBc798FJpunjvsnZbdIJdHlv?=
 =?us-ascii?Q?l5+igmpmgclkgeHakM7saCzmkknbv2eJc+w1TA9WdOBZVKvtw/QwLg/vk6NU?=
 =?us-ascii?Q?pjzhMBZjmEEAL3IJ/bLk0s2Qo4kTVfLcmyL62uPng7zIkTANgtnyVI4hIxsf?=
 =?us-ascii?Q?rkiTP20HupmP1yhzxPvZjrx0fhNMgUdJS2qifxy+cFxOiMz50S5UiDc9iRp5?=
 =?us-ascii?Q?Rq83II7P2vOUrMUBzh4YkUs5b1WSwph8XoQR9VW3kFOtZKtXLJrmYAO6coNg?=
 =?us-ascii?Q?oICofsZ3q/IyWNKuzIO9ZfiLSxXRePaYgZSxY/Vbd99hznIvw2FS4yxkIfFX?=
 =?us-ascii?Q?sLkOLFzFnWA3a8CPFCeUjMwqoFK+D4xmXym7nIkpTTU/vnoChxtE7ZXKQAu2?=
 =?us-ascii?Q?QvBvyWHJjQJAISMWcPQyka+mvnCCkj6hRGsraewbH7CNa3R+FMG1dufONwgH?=
 =?us-ascii?Q?SG525gYQ6kQ3I0dPnBwuObD9cv1SktBXdpb87CBzjynimDPAgEp/T1FERPwr?=
 =?us-ascii?Q?hyNTUvbS/bNdePVCduButLTHK0WaETQZ+kq4oyP9m9rb44eYFpRGMZfOeL3s?=
 =?us-ascii?Q?h6aLFZWCX7HbQNc78/KECexHNJ4Fd3W+W1Y0O91OfJ7sLDdAbdMvKvQ88eLs?=
 =?us-ascii?Q?SEELkVAyJFgcOxwZdOyFaW7v8nk4tXo+ZajHMu0E37YhY+uaCG5Z41bgycQA?=
 =?us-ascii?Q?iaEIWAUwbsqeoGSQpeFysDyrBTQY+5j3F16aHlOvEvockxzidlbYok62NpyK?=
 =?us-ascii?Q?T46QMlBjURnutYQkK178rlHY1eMVZPZCUH5LdUXUo8/YbJdlW+XQZqSlWBzl?=
 =?us-ascii?Q?MFjqTIJVecur/8j6Kso4e7PQaeMxsjX7lbL+MqLfRw5roGkHsRevW3YP1dm9?=
 =?us-ascii?Q?KFP1Zg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f72f40d-3613-45ac-13c3-08db52077d7c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 10:07:12.8735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6WBP19FFIJeih0FAlh5WOsR5ZzghoMC+Je614n2lj1eX+x7etrAC7zcGwIysCRlkSxzpfyk7mehDn4r4l47FMyH1GGUM8+CK/hVbkFTxats=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5223
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 06:21:39PM +0530, Siddharth Vadapalli wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Introduce the W/A for packet errors seen with short cables (<1m) between
> two DP83867 PHYs.
> 
> The W/A recommended by DM requires FFE Equalizer Configuration tuning by
> writing value 0x0E81 to DSP_FFE_CFG register (0x012C), surrounded by hard
> and soft resets as follows:
> 
> write_reg(0x001F, 0x8000); //hard reset
> write_reg(DSP_FFE_CFG, 0x0E81);
> write_reg(0x001F, 0x4000); //soft reset
> 
> Since  DP83867 PHY DM says "Changing this register to 0x0E81, will not
> affect Long Cable performance.", enable the W/A by default.
> 
> Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


