Return-Path: <netdev+bounces-11064-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D7FB73168F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:31:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CC1A1C20E5E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3748D11CB7;
	Thu, 15 Jun 2023 11:31:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BC120E0
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 11:31:32 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2105.outbound.protection.outlook.com [40.107.100.105])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87213268C
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:31:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWbj9IxuZixvCXoc9imhmngEHpBr79tI0cs8kUoWm8WXIBDUamQzcnPbxXHL8GeenY37g/dtwSk14ME4fkDKTV1shlMKPOMdV+QJPryyBAY4JQMDoTTrMG8CBHoUSOAxHVO2p9ZO+JJuREmTqqt6oNJp6rtAWBsoOyxI5Su/9gWz3zklUFcrO5uHH/WzcvyaBOotG4zfwMCr+tfW12sDfcpBetPRvrgNKTW33s0xMEOHsNsqzHE1WnLOWj7beqsoje485efhKEYM2ui7QUwiYqsRLU+4q27X0PyiFXZjFRCzmjXszjvT0v8VIq/3xn5KShb4PKK0gd/FOEEhraAs5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NO1LgNAabdqTNuC+pxtrSZF0tva2oZT9l0ME25PJfgU=;
 b=W1q2Nc2DA3z8s2bqLzcMPGh7oLznX8CAfdHvpImrm2RpoCJGuLuKzWUNml3UzMcBHDvD5YfM1ZifGcw5xA4JZ35vEiFQK4a+te9sp3sFJe7w4CpimzDBoE5L3ju8ZwxfVefwRl5AsIBCPa2X1wvRh+2EP15hp5a1wp8XKQYYrgQAp292+PY94uQNQOaaHgbSe9vcZU7lzh+g+TAlntgFBjfarWzLN1Glo2p1d5Bb3uEH0/l8FVBAg71D37mfgZM2xls7srOGb4wWzjL/wyQ2+Tdf0Ox7h+7HHYao88sd8WJkEemAq/VxXNxvYXWkWeduzUYn+kOTsa9fsOhKohiVGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NO1LgNAabdqTNuC+pxtrSZF0tva2oZT9l0ME25PJfgU=;
 b=uYCJ0ISa0QUw5/cxXutYww4eiWbnihMU9lMwqwf4lRrSG++93Xjz82toJCJV1rskbMruxKeJkIYmn5Lc/DFbpFOGXTMN7y2UUOFM+qCiURwJXCAds0gSER0mYfmDnF10nUFupS1S0ImU//RZmDdtB0mF/OBgGDp/+aNJQytQcs4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5287.namprd13.prod.outlook.com (2603:10b6:a03:3e1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.27; Thu, 15 Jun
 2023 11:31:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 11:31:26 +0000
Date: Thu, 15 Jun 2023 13:31:20 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Piotr Gardocki <piotrx.gardocki@intel.com>
Cc: netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
	przemyslaw.kitszel@intel.com, michal.swiatkowski@linux.intel.com,
	pmenzel@molgen.mpg.de, kuba@kernel.org,
	maciej.fijalkowski@intel.com, anthony.l.nguyen@intel.com,
	aleksander.lobakin@intel.com
Subject: Re: [PATCH net-next v3 0/3] optimize procedure of changing MAC
 address on interface
Message-ID: <ZIr2iNTFcWV4Tdjc@corigine.com>
References: <20230614145302.902301-1-piotrx.gardocki@intel.com>
 <ZIq+SMD6fdMU84Dg@corigine.com>
 <e15cba8a-8e3d-e804-ba8e-6feea374f1f9@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e15cba8a-8e3d-e804-ba8e-6feea374f1f9@intel.com>
X-ClientProxiedBy: AM3PR03CA0073.eurprd03.prod.outlook.com
 (2603:10a6:207:5::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5287:EE_
X-MS-Office365-Filtering-Correlation-Id: a52a251e-80a4-442d-b74b-08db6d940e46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ovBrP9fPCaP0RVkcjXybigA3LhmrqLFwA25/hXba8IouOPDiKSsvu+vXSiQAlG2UWwrrgKPfX+uuD4eq++LxJxTqnOZIhJR50wSwVjWrTHK9/E4Jngm/TEC+4I+KmAePlt3MJ7PcMMd3lHUHZ/wk0ob1LUUDiE4ItHcMaKyLqxNspFog9BfWB19fr7XFk86EedBpd2x3gwI6ym/nTs51WgrSvGsprhfVTl58ClntAlTQ7Ue7LjFcLyodd/6gohrNIZIvTvtHXGGsg/yTwRRUxKJPecBYczccMV+cKYStpAXK8BgvQkJAXUD0wdJCcMVzEFHfLyagHHdJ+WMVX6K+vAG8Z+PBYTNgQqJqEKUMBsErMDGm66BQxkV7b5ErKkc2l3jzUSueBl3lgMpEd8JkiaDVgppVe4b2qSUnhMzWcq2T8IG2JpxTxt9XgmSHAFXLD5CS8EfiLduX7kI9UzEkpd/4uxzVnAt10XyOfjPL40F9jsZ3CsT+S7vhU6b469TVJds3ylYOW6K0sYEeyTw/zZrqSuvRIBY98tLOTdwi7oXu+JP3tO9ivbMr+2uvzy0g
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(396003)(346002)(136003)(39840400004)(451199021)(2906002)(36756003)(4744005)(86362001)(7416002)(44832011)(5660300002)(6666004)(6486002)(83380400001)(186003)(6506007)(53546011)(6512007)(4326008)(66556008)(66946007)(66476007)(478600001)(2616005)(38100700002)(316002)(8676002)(41300700001)(6916009)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aZgMhvRN9WX2QBVdYuu1DAAoau62zNPQSxGupeKlOGYTnR3qFTLvmzcxoSf4?=
 =?us-ascii?Q?k1kURnBn2r7AAmV2iX6zmIrmsQLzcIWXG1Vl9GBQvS1v9SgWcmou+CDYYqPS?=
 =?us-ascii?Q?BG0WPTTccNJSUwfbmaHrDwJhyuhPhPXC8CEXBgleUaO8Dl0Tmhj1QBcTYmsM?=
 =?us-ascii?Q?2CKDlC3pQ6HsIJY3As3y3uBKZLmwGtF+e6OjKOBVINd1YQfz755Hh3XtBhaw?=
 =?us-ascii?Q?gjozCUFi73B62cyZo6hC94y5Jvpb8weM+ntcCUrb1S7CvBxQJrWkL6M0afRQ?=
 =?us-ascii?Q?ruNQv+8ETkxCv4i5BbFihjBhtDKl5r1fRI7MbHQbSXP/PfLJ5fipvV8rRnUy?=
 =?us-ascii?Q?rBzVLyXP5ayjBHjc20GkahONMcRyQeodvRPGdMqx2Z58vX5dJCtKcIkgndfK?=
 =?us-ascii?Q?u56difLmgN+XVljm3WUUWP/3ccsmQqOEVkj0yWWQ6bv81othOfWAP7UobDUx?=
 =?us-ascii?Q?eeYLL314uLjwVjQFgQ9s3RH3xZOLrJwsEtDgSV428cEsTy2ZH8ufXoWibbuj?=
 =?us-ascii?Q?DY8Gkoo6rqovIjNSJd1LOugGKuRZEsIqYoYjIdhdGtlcO/MMYDg7sDHgK7hn?=
 =?us-ascii?Q?axtrT36SYmCZLZ7hnvV2Gr60HgNFOpBeT3hBFDRZ2ROfUlfNLoCOrg6Q9ioP?=
 =?us-ascii?Q?IzBk4v+kCKEHJq84DdeHPIsg379JM9JzJEoZ7sULUBiZHneBHy1urH7NVTtT?=
 =?us-ascii?Q?ZmpXX8vqazyjZvVKZsnlBaVLCt3w/y6/yLyDB9uIkMUozGxFmaAucgWjt9wm?=
 =?us-ascii?Q?CXerE3o4t5y68Xukt3B1axf88sg/+f7e0rJDbsJBMMO2SzAMG7Y8ARHY6W/Z?=
 =?us-ascii?Q?pdRUwtiYtjWIdJPOETozNmYvcTCHDfFQ85t/uQrXgGP5att2g82dt6uAGAEu?=
 =?us-ascii?Q?1LNZONhj/e9j3i6l2mJOsQ/mgqCjt5Lbi7Ee3lzqpFctGshN2dkky1DWMh2i?=
 =?us-ascii?Q?09aRQ6Y4led/+s3N3B9rHYvon7uMJXxPrDyyWR0s2ZHHNW4C2rSlUt0cjmSJ?=
 =?us-ascii?Q?oyu0ejrcbjzpg+QDbf2fkte2bF94N0LTM9nEYwkJ3acxlNuAvs0NqIEMRTPf?=
 =?us-ascii?Q?DYRGPKelEASQzb1LxN0O/ulQojx+5CyfqkCp5YJ8oep4rrtG+xgBiIWcbld3?=
 =?us-ascii?Q?owqPvKiW+0l8BaaILUvMVymg7y6MzUhoC2AZs4gXwXogD6719+7XoXE1nFjQ?=
 =?us-ascii?Q?KOMUGPQ5i0DiZsF4AJ5h7ZB4TaIMJd0RcHVYxj/8tZ5sfTt1Jrk2RC+lD8dC?=
 =?us-ascii?Q?iIudvYmBudXX3Ps8ZtT5KTkVxuGlaEHCDdkEN9ppPzQn8mxSR5nmTp9+oOzH?=
 =?us-ascii?Q?gNNGeGzz6DN14TnB2qhP2kWki+h9TjgUqfNW0hwQKO5fqMiPFdMcrH7PE1PS?=
 =?us-ascii?Q?x7gAOwfuguHIZ7DF+wJYD2b3ebNVKk0P9kb7eNlGoIm6dHS7KMwN5fJA89sA?=
 =?us-ascii?Q?zGY06DEPPmCY0OKVs8PiSOowGfhDiIrefBk4x778zi/Bqdmq56OoVKx68PQu?=
 =?us-ascii?Q?igz62D6jFNuZmZWkapTXUoZMJjjIQusmh0RHZlw4upuLsCgqbITLPVmTUldL?=
 =?us-ascii?Q?SiPLaDsYv3xVXOfHOiSfFkKhBPGY0YahAobcp0BJblzvIlLUEJURHhb0EM2l?=
 =?us-ascii?Q?z3gS0W2S6aPbyWTA/vBf1XRRLowMYjS96SzcD8rv86ML97mbMCyRNNg4G4Xz?=
 =?us-ascii?Q?S8iFQg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a52a251e-80a4-442d-b74b-08db6d940e46
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 11:31:26.6201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LUd/QTWbp9X+D7Ba4sdJocQ+1z47BPpaBzLKpZzgzFM+Xk7U5V50t17d5stYruhdg3fwCwdsZyLdo2Zzi2Z7WD5K8MSopEIYhSrssk94G5Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5287
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 10:51:28AM +0200, Piotr Gardocki wrote:
> On 15.06.2023 09:31, Simon Horman wrote:
> > On Wed, Jun 14, 2023 at 04:52:59PM +0200, Piotr Gardocki wrote:
> >> The first patch adds an if statement in core to skip early when
> >> the MAC address is not being changes.
> >> The remaining patches remove such checks from Intel drivers
> >> as they're redundant at this point.
> > 
> > Hi Pitor,
> > 
> > I am wondering if you audited other drivers to see if they
> > could also be updated in a similar way to the Intel changes
> > in this patch-set.
> 
> Hi Simon,
> 
> We already discussed this in "[PATCH net-next v2 3/3]". Other drivers
> should be audited at one point, but there are hundreds of ndo_set_mac_address
> callbacks in kernel and I don't have resources to review all of them. I just
> fixed Intel drivers for now.
> When this patch set is applied someone else can work on that.

Sorry, I forgot about that discussion.
Of course this is fine.

