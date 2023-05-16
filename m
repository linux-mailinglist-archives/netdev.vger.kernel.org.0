Return-Path: <netdev+bounces-2943-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B380B704A77
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:25:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FE38281035
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 838691D2CD;
	Tue, 16 May 2023 10:25:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CE01B903
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:25:54 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2114.outbound.protection.outlook.com [40.107.102.114])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D97F359D;
	Tue, 16 May 2023 03:25:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHvuu6lqkvT9UJi9vmiN56+nqFZ4AAjWbs+9mCdfIWRyx6Gy8EGHfHx37nlghjHw2kpdBhYfuQ80FI35SbAFgKYx2CnVQ19nNw0pVztEMCdegkOIL5FhBQrvhNDmvd1TXX+pwn+Eb+/+lx16NuzpfEfxh7bJ4BbuLZLVWxiaoEqLY8ArLfcDI7XNbaWAOiYaiaoNKHmptnpIKbjC9kMVJK/1pUQ4PQiIMamDIvkLa/uRVncC5rZw/cNLcOaoGJv/c2MUVAzYW/IPWrDzwpDuvzabXJcsFTtwyhtgog1uUblAEkaZJojdbzWTIOoOBN8kCqs4Yli90rAQkPH6FCzryw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WuBn4G+NgZa0+wd7P6CL5pqi9NLgle/eZm7JtNbhA0A=;
 b=jEn6vGnj2NcpZpkUX7jFSeVpMzq45cCH3JoWMg92rxKMgWe3fvEe1vwL5Y+zMCJroNq8plK8URnSwm+CJjD4ZoVGkxEtWExIIqxw3uihYQTMBwvZD9n7iy20JDfli8jJh3L1MaUI1LuAQ9QLmBLE4/Z0hAHokpsn5SqUqqH9nPMIhme96cOXyVggADY1YDcx0dHkZa3WsPSNz2V4KRsaMELwyaoePwVnXqeRvtU3fNqyN32bVi9YL0fXASxmP2ISIlgwwCj5BtsH0JfbVc0hBXXo6gcIZxiPDNThfNAQV3Gcy/AzYK/A3OS+PassTJ/4PbTGRMT8/7hG3xthgLX1aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WuBn4G+NgZa0+wd7P6CL5pqi9NLgle/eZm7JtNbhA0A=;
 b=jppnzApeMpnxupG/2RcXtrWLlSF3eiyg2/SV/gZ9AwwTr4jrla4lO0v460Io6lEHiAEV2onV0MUnIsWZLBYxcxpqN09XfZJI+pETWv4WXZexTzUs5QOWD2lKTxdKFDUS5bSI4u/PMrWN9Ymp7VKx36LHyWqacbWBtkA8NbthCxY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB6073.namprd13.prod.outlook.com (2603:10b6:a03:4ee::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 10:25:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 10:25:49 +0000
Date: Tue, 16 May 2023 12:25:43 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] wifi: mt7601u: update firmware path
Message-ID: <ZGNaJ63mM58DCas7@corigine.com>
References: <fefcbf36f13873ae0d97438a0156b87e7e1ae64e.1684191377.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fefcbf36f13873ae0d97438a0156b87e7e1ae64e.1684191377.git.daniel@makrotopia.org>
X-ClientProxiedBy: AM0PR03CA0096.eurprd03.prod.outlook.com
 (2603:10a6:208:69::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: 89c1eb90-8915-4ef3-4b7b-08db55f7eb45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ma2hKwPQXENHt7VpYgKpbh99/4wzz17HPGrqJiRLFaQaMGOEC/RI6mK0UUgmyyi2Mg2/v497Go5gniO8nFX+Ec8CSRd+OPm+6n9NWLLzR9FE+c7IbQui9K+rMG/XNpX61zkQdd/ExMcZW27pp+8c21MQy0A/6RIXQYhdDrJww7F5K1gH9N8F5tCu0Lw8q3PyiMhBFknllmYDuZNbdQJmNfQPn1Ofp4Fkse6UTd7Ye+euoMr4TeeIHjcdmMGASeloA0kqpWdElRixuRDgoC9Rg3A+aKxyEfSs7yjbmWjvqmA7oDmhhTMWeQcaPGTrXI17lPZKhDuZszJERAqE7zn4uDRDrp996hl2hrfYuPSC+IneZ4rYpOeg+77WyHRJXaQs4CGRtsUg4SwpeCl5MBVfhswxqP2BU4GS3LUBON7KiC9A2m67wAEIMkEH+T2J9LjSo6vu+U49nRF6xzKPXJFmJZnO6/T8b62PK//27PMMomz71paorWOmPX1Hi/+Yex2ZbFubqIJkWg6mxio/VJxmWGfijvoN6ZCQz2mclh7Y+Nwhb/GSbJCiqbrEIa4sT1bNLJRo5Roo3OcvZMDHPHOy7o5lGYu7VDdqUl16UA311Bk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(376002)(366004)(346002)(136003)(451199021)(6512007)(478600001)(6666004)(6486002)(54906003)(186003)(4744005)(2906002)(15650500001)(6916009)(316002)(4326008)(66946007)(66556008)(66476007)(41300700001)(8936002)(8676002)(7416002)(5660300002)(44832011)(38100700002)(83380400001)(36756003)(86362001)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Km2PuGbAqfP51KY8VMAlKttVfojkcSLMcnEnFOdAxqQZ7YN2n20sjiDiDoeI?=
 =?us-ascii?Q?nyGlbnWrU7e0Tmm7Kqo68Si0HOaiYVmIeDAWcGYUSQpPQMxvlCPjhPy83O3/?=
 =?us-ascii?Q?14qpav5MmPzFcooyEWHNISdgJ96o+76d4zJNPfz363w/FTG5Evc9goIMOF3W?=
 =?us-ascii?Q?6OaWo5U8RVUbEeMDWZE8O3AfIInbBIDnWFiQvGgGh35ghof9mRAkDSfZe+aB?=
 =?us-ascii?Q?aidUaNunJ/hQWURV3iY02eeG23o08r7LcrOPI3/AvSE2YRGD68kW78tqSEQJ?=
 =?us-ascii?Q?xnJwapUdU0AyLflnNd8Vv3SsFwJ5D1jZ0QiGlv4EGV4YgQaAyVvGbS+HqdbX?=
 =?us-ascii?Q?Tzg8aX6BY/rcqKolb2znGiT/bheFrSfTMRa4Yf1xtXaOpqPfHN7mGvdwwHch?=
 =?us-ascii?Q?7QWClTv9t0qo4ld3mznvhEPjZAY6xBhTdMCP1f8IPaU7nF8BWIjmj+FQhKQo?=
 =?us-ascii?Q?5fbVAbyl7w5J2ncAA759BUHkvR4inbiGI9zGpRn5zcHaNVwGGuWyRXfCMVAY?=
 =?us-ascii?Q?GXDTIfuyHMsjcTcjn/LNub652dgN7+E5ZpT+a5tyNF7jwPqLYrO0GTM0Dn/S?=
 =?us-ascii?Q?FzcKKIauLJlzw2+0r2zYBK1TVm5kmB2DFr4WtVk6PxQuhof+apaC2YRB2qyI?=
 =?us-ascii?Q?Pbuf8YB7xLjJzNJBsVPHtyj+woAfeDhiaLzCexYdvzzgJ73XTVtzFEpisoSs?=
 =?us-ascii?Q?WoENUkOfYM71iLORDDCNrOR42HUdJctt8+NbCvJIEwozmkwOHxlCT9Yz52Z7?=
 =?us-ascii?Q?p0YnJ7Xq9856vJiNBEiADcR0BPTaErMXx91ISq+l17zPPtIiCPLP5jdZPcQL?=
 =?us-ascii?Q?GJXLPpVV4Dn78AebxLtnQBu/AfS+AVKqx87ZeRePz8OBPlp19bBlIT/XxF14?=
 =?us-ascii?Q?P/x9w3DJgo61InUS+IX9/mcJwq+n1Y72KDxLcRjv41AVl4OEUECyM3MD8UJx?=
 =?us-ascii?Q?rj9/43/Oe3hXIbYdKdIySyZy0NWTsaSJU2jMdpU+JJxaH0tYXZYpWGAr9nSA?=
 =?us-ascii?Q?sYilIDBZ2SYy906WfyGtYqXlUeQdSvJjuegxdvqX6OBIyiwnN8MbXrCwVgB+?=
 =?us-ascii?Q?CCqHPPEtBzwYKKG4lXoqsWUGAvOY1lXangirbUpKizkAZtL7FJMsKbiiu3wo?=
 =?us-ascii?Q?RN1+s/J3J0Oyz6Crj40O8wyEXmwUcr8mRk2lFGqvkelNjV0P9UxcEvCQ0Teo?=
 =?us-ascii?Q?RP8pqmHtPgSSLEB3ENEzbSdECHN6G8phfntsEmqLsCVs8h1UEo/km/V4oEul?=
 =?us-ascii?Q?JgNzdZ9xkF7UZbXx/Kd4wVCyfufLaAiqS12yzj82biMVdzR4tX5HzhicQcRl?=
 =?us-ascii?Q?adjRhoQI/kdSHZUU+uSVMtqBqhGGWIJslvvGWxmB3jfcNiVN5YYfhtRRqMeb?=
 =?us-ascii?Q?UFYv8olqYN60qY1HUwrlZVZQgZwHj5CCgtN/+7qa2HINibZfb7QUQaAqqfQ5?=
 =?us-ascii?Q?jvwNjexU/zoX7vMeHz09Z1U1PDO/WpTXpJjT5Yl+DCoNv7qEyv7JQKrQihk4?=
 =?us-ascii?Q?Y3WvJ76QqKWbaZgEWQUoG/Ub8LWB7hYtAVZ8xlp6Uz9xuIasm+ak3Ewn70T1?=
 =?us-ascii?Q?q5yXMIPyRDrtU9OhzgZwnuJdpOGfnky6NYYylDk0aLcOtSlBj4WjdoNafnEy?=
 =?us-ascii?Q?/TfkBrtSiQKaH8Phtxz06UaNr9FxfGl+/q8cqeeQF6JXR022lMNe/Al6fKzS?=
 =?us-ascii?Q?zINcXw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89c1eb90-8915-4ef3-4b7b-08db55f7eb45
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 10:25:49.7050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TAMUFVMCWqqPkD0P4jNRlZjfO5/XTCRlgNoMs59u7Liv+cXtkq8QH/pIbBvDtcDBLiNPGHY0qMNJOguv47WpyirBMyPEC0F8VLNYREO/9Pc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB6073
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 12:56:53AM +0200, Daniel Golle wrote:
> mt7601u.bin was moved to mediatek/ folder in linux-wireless via commit
> 8451c2b1 ("mt76xx: Move the old Mediatek WiFi firmware to mediatek")
> and linux-firmware release 20230515.
> 
> Update the firmware path requested by the mt7601u driver to follow up
> with the move of the file.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


