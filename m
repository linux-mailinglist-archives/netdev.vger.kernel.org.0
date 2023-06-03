Return-Path: <netdev+bounces-7667-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D297172105B
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 16:07:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5885C1C20DEB
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 14:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA33D2ED;
	Sat,  3 Jun 2023 14:07:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2971FD9
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 14:07:50 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2123.outbound.protection.outlook.com [40.107.94.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1236198
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 07:07:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWuX1Z7mOniIh5camOPR+CrDeVN/0pPDKVyIRjgdqTl7KG3O6bjoSgNYghv3Nmm4YiP5PKmFr/atxSjZRDV3bVQGFDTPDKPKS9sI98KgBof0BhkIDoNrV+4d8WO88kfccKP4Dwotrg+9+zGQgA6ovYbyw8zIDVbpG4oddHylgYHSbSUCYWrub4aBKAtL7CxjmxdQ1OGVWDmc33SsyEPAShgiA5TTEyBgPaThUAbDlrqHnwQMfgrb3TbTtWmmUgcAOgd1mfKFoTO5XsJ9iHXfVrmfqXogrIKCPl95X4Vab6L061/7YnYOvZHwnLK8yGgc1tNqMXn7maThmTi6SZf2DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mzfkkf38dXkiVSkN0YY69Q3fzLiWdU6yg41u4/gfppw=;
 b=dAifTrqE94L5QLNj/GFh8kB6glSQsKYB1enzNyPkw+dWtbz84pmp77bYuBI1V2UKYb59I36Jh0JRApE7pn97hiqZRwkSHQEg6m1V+Ut8fT8F+Gru5COcRZ4mCM5lElJzp66AZg7VHaKw44SwvPQZVqzEnaY3/muVGmOI2FXjvvUTnuy6tQSKtqc8uYD/k2SnopmzoGTrJHIlaf2dbhwMbWxZKFtjgZLYOyJ+mm2d2owadHU5Fq/PbLsB5vsm8XKsvqEkx3jBdkekIat/7yozs9ldOo3hih+k8s7LRMFlp00UF/8OnnebwXem2t61iC+LHjip7Fe96OC8uZy83OnR9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mzfkkf38dXkiVSkN0YY69Q3fzLiWdU6yg41u4/gfppw=;
 b=jWeWE3hEorV2xFfuGrYJiPIG1wE1UVvnRACJNSO2CakHCC1fVkLMmRkXyTmVa/2b0WTjT2Wtzn1GLe/pTTGCh+4oXvVwsxFtgP/sDmQ7ck+IExw+kTzsl88U3THmRt8g6Wln/NowpizO2FIKmXUjciILoP4GTXlpLTYu614wl90=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5246.namprd13.prod.outlook.com (2603:10b6:408:159::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Sat, 3 Jun
 2023 14:07:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 14:07:44 +0000
Date: Sat, 3 Jun 2023 16:07:38 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net-next 3/3] iavf: remove mask from
 iavf_irq_enable_queues()
Message-ID: <ZHtJKlPZBjnNkAhm@corigine.com>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-4-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602171302.745492-4-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: AM4PR0902CA0012.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5246:EE_
X-MS-Office365-Filtering-Correlation-Id: 3105d70a-fdeb-49c4-e488-08db643be6a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Tq3SYGEP36Sw+VOpmJdWmrzcCGZ4a8tDBtTRw+Ab+kiqqO5E/h0C/03Ilo3IzWml/UCeOSrZT+uUIU+A2g/zUOZ9yneGRp4dcuJl5JTBnT1bWAjgYe4UQn85VuQL6d1m5qhJTbrJiyzZZ2vy/8cna7W3NW3SOQRrgvqFH4dheL3iBOZN8eu9zV8nRqFhhg+leGKIOaZQLnClZHU4jBnNpv37d9sYSpUhBX16tS2AQMj8XKs/Ct3vkbAv3kDhw8te5w4hjOV71c2G5QRvLZR/ntkWdlOPDqM1Jt+tbPanHsfEh4gkLKmhkiZlODWgVOWSdChJfcrG65VjZBzmtbETVYh9GWxK9VAOepq1LYCFBieRYiTBNlTeqKMudBCLizhSrCt+8nTAk0KJ7xkAIwhhHdpCH3C6zpvnZ4X8Iw2+dtSLgDsWnesR513f8N+xym8n9B0aKMPWsCdyA1gKUCt2RIEXdDUYtVz4kYlek+L1S7hnV7THZ0vZSfQiUCmNWPc6APhbNrLnsIPLptLVjJ1BTMxbwaLA5wwnkWOOOSreosU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(366004)(396003)(136003)(376002)(346002)(451199021)(4744005)(2906002)(2616005)(36756003)(86362001)(38100700002)(966005)(6486002)(316002)(5660300002)(41300700001)(6666004)(8676002)(8936002)(54906003)(478600001)(66556008)(66946007)(66476007)(6916009)(4326008)(6512007)(6506007)(186003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sB/BUHd1pJGuf9SbInkwVWwFiM8sGku1stymTu42AbxrI/kc6dDiqtkss/5v?=
 =?us-ascii?Q?PuY8u2gHUl3uQIDET4vRWXMUbhshB3amAqWx+0Qz0M/H7xOiHZwPZwiktf3g?=
 =?us-ascii?Q?WLOI1knFtEnNmu2Trt7qyDllUb8GF65F+6bLeiRodH4Ta4wO76mcQ/9ToOmX?=
 =?us-ascii?Q?u0dy2Gnn+bTnAZZTLLHPZ+7M4kaP2/EcRuXjj3Tvxf/nPSN3Oh5Ls2XZc08h?=
 =?us-ascii?Q?uBXQyQOSDzia7y+K/XFTkKOvW2j4tJhuDshaTD4EvCT+e78dpCoq4T9BmjBP?=
 =?us-ascii?Q?ACdZe8o4YeOqXowsRhEBntSY0Tt22dpFXKiiKxM8EjIBfbY7XAYu5Q3QxcRC?=
 =?us-ascii?Q?kGk9AuoWDkCk/BiGGHzdAXvcF+mrOPFMDoLrMphLihjrqRI3FNbXGnQgmL13?=
 =?us-ascii?Q?8kVsUQPHr9u2pXmHpr3OWc1dgwet9ycpQZ4Zu/Ny1kmhqbn2iQjiNAXOki6X?=
 =?us-ascii?Q?riOXlytY32H3inGQM0bexjUtBglSt8bCdgE6GrX8/NvuiH/P0cSytaKlTZ/s?=
 =?us-ascii?Q?oA+vHbHzdhnZ4ovmhCYil4PuOchrgiDTw1v45J3b1rSmx5Dvq4HOPILEObeF?=
 =?us-ascii?Q?ZzO3pjgSuvZUTxYT4N1uvUMxlD6BR/Sr4r9VlmRKlI3cktwi+Y78/XMcoeHb?=
 =?us-ascii?Q?THvndK40ks8WhdBmDCB4yME6enNhETa3r90WDxw5HM5KUdFktMHhs/JPdz9s?=
 =?us-ascii?Q?36KkM325hb1oxlwu9YTQF5ZhnXL/0+yf5xITKC9sbbufA1d/tZsHTY7ZWj3/?=
 =?us-ascii?Q?jIKd/TWhtFVPPj6RtJYn6lNlXqtlGskbdxf4KRk7vxr0NIdWMLJ1bIc9pD0Z?=
 =?us-ascii?Q?uBjF1IJEY+SiqNNNcibLlgNUx9zwDr1+XGEUu09Iw1xhlbyOwpxc9o8DBcGI?=
 =?us-ascii?Q?R+7GJRwAuP4aDh/JfnTSeaWH/XTLjtUIq3sG/QMJqY38nWGuIbMyAWND8OjU?=
 =?us-ascii?Q?66RDL72dA1UZDQ7G9HLdMyJZw5rOST6zPWZlYuAjP8JE6bJRMW4n/tfO6fyU?=
 =?us-ascii?Q?+o1eFUwSRjJrNokh6aPax2tUvTQwKI+uoUC0nHrGGZcsMMZB9iIq/USdBE00?=
 =?us-ascii?Q?5QTee8BLy6BND6S51i+797NJHn/DKHZkqneDTwvmJDNt5T6ZYsqZKOV/CFe2?=
 =?us-ascii?Q?pzaBVppDsBw9x+DrzaFrlszXZ6GnV8LmSI1oetJWxYcBfc4ZiLNqRFmZCwVY?=
 =?us-ascii?Q?tbVVMP5mnaI8KYXfC1CmRHeadSNXEqCFNS4DD1NU+KeGLJr1r5lujr2y7YDU?=
 =?us-ascii?Q?1e8QJickWV8W9Pq7nJrcfrT1kjTTc9WcPO0MrbC/h5+ACzG74X3lm0hZXNQr?=
 =?us-ascii?Q?lz2Srp5lricQ0FcMbxM7mtGx4VyE5uXL/HJjpGiGWf00MQaJBsbFLbs1XqBF?=
 =?us-ascii?Q?u/8zMadbRMZ9ndjxI5dENmxWrZ+7lMYPVvDYA4Qhi4D3xIky+v6YvMqMh0Do?=
 =?us-ascii?Q?DRMOEJKZhogF1uOAp72+IRaSSgqu80Pd+Q1b7Mtl/thb2j3cVJk1NiAidLB0?=
 =?us-ascii?Q?/AZaABaJpBGvOwYgZ99sfN+dNhny3EhHfLKRVluNFHNqsFIdWOBxfaYmqIzr?=
 =?us-ascii?Q?r3pGn8xIXdQiEVQsyiW6B14X4j4zB4OIP5GuFnjPT3NJA1VtpifYd5joVKjM?=
 =?us-ascii?Q?mjrdEOzWHRBXbXLv7BqlnROcOWXRmDIDeCM18HGmNa4UI8APP8htS0C/Tbzw?=
 =?us-ascii?Q?IMpPqg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3105d70a-fdeb-49c4-e488-08db643be6a1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2023 14:07:43.9688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d0AIn0+VPIuXSJu85nD2Jg3W/1GI3RSDPkwwDc29jHHntB4wdYNik0bJdg7m5Az5RJa46QaklBH1Ks8pv0lMo1mmU5Q8VuTC8UNyR/CsTKg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5246
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 10:13:02AM -0700, Tony Nguyen wrote:
> From: Ahmed Zaki <ahmed.zaki@intel.com>
> 
> Enable more than 32 IRQs by removing the u32 bit mask in
> iavf_irq_enable_queues(). There is no need for the mask as there are no
> callers that select individual IRQs through the bitmask. Also, if the PF
> allocates more than 32 IRQs, this mask will prevent us from using all of
> them.
> 
> The comment in iavf_register.h is modified to show that the maximum
> number allowed for the IRQ index is 63 as per the iAVF standard 1.0 [1].
> 
> link: [1] https://www.intel.com/content/dam/www/public/us/en/documents/product-specifications/ethernet-adaptive-virtual-function-hardware-spec.pdf
> Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


