Return-Path: <netdev+bounces-7800-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23ED37218D3
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 19:31:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F09B1C209DF
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 17:31:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39DDA101FD;
	Sun,  4 Jun 2023 17:31:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB468460
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 17:31:10 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2098.outbound.protection.outlook.com [40.107.237.98])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A4DD3
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 10:31:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKxGdqEbztfh/Rk1oDkFq1Eqp/8AyKPU3E8zMCwAYdVhlNzttVHaUqiHk9sr2wbZt30cWVSOXg2eEn1rw9T63kjdoE3Y4aypA4er27zaAGP7FbuWPqmTh6TcsbUAuECGKRc1075lM8aV5tamZVbNHGUDtNE2VQFxQeZqTpAxsv3ldDc/D29bA7Td8FG97Xkoi2c9R3OKO/xmIb+BXCbR0W0JgJlK+cayupOkyGHafHQaqPl6RdnJiVKrvDcdqTfrhvWuy7G6SqXFr4t+OqBu7Zfr2Bn7epc39mCfqMyGZiWeXXl9m+IqMpi/lVq7nVSv/Udtc3QMgD5sXcP6BYItLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eqbJQ/dVLe/rpbAFhtDTIfoWaIpii2QaeRxdOeX5z2g=;
 b=B1YJcHw+YFD2/sugyK0fpm11U74k2EfWLNkA3RQWnzBba56F5bAPbKBEcGxyC+QPAqJLdp26ulD+N+xZFJTJHxy7o89ZPQ1DJZUs6ogpJKsRe2mO8NeT41L1zUbLVdGEIlZmhLxNanyKzudiUWAyPAzW85K8arMS4DB2IFrcHAlLsQDbLm5iCniNEycuUgZVhSxaSj0mjghw7C/+TYICBJFLvmB4pywctNLuCKqLftpnbyM4wrfmPmut3NffMCtxyMBaSAU/f82nkbaLwXSEu2iuN7sRyQ07ltt63dq25Fcy7OUearGfdTn2wru3iumx2+iq6O7VagNSNWGQFYXrfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqbJQ/dVLe/rpbAFhtDTIfoWaIpii2QaeRxdOeX5z2g=;
 b=EXJlavjUsTAd5xG8DZaWeA5cMokIlST3yIw2BENTJtHMCIu5WkXmYKImI8rHC/88/lnLSNLhs7YKNN5GvavYj0BK4q+IWdwx9rWZNaXDLuy78qYI/jcxxS/piU4vVcbJVj6yAVAZoEeu+SN9PkPREvt7mi2o4106MvygVdlzYXY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3895.namprd13.prod.outlook.com (2603:10b6:610:94::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Sun, 4 Jun
 2023 17:31:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Sun, 4 Jun 2023
 17:31:06 +0000
Date: Sun, 4 Jun 2023 19:31:00 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Wojciech Drewek <wojciech.drewek@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	alexandr.lobakin@intel.com, david.m.ertman@intel.com,
	michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com,
	pawel.chmielewski@intel.com, sridhar.samudrala@intel.com,
	pmenzel@molgen.mpg.de, dan.carpenter@linaro.org
Subject: Re: [PATCH iwl-next v4 12/13] ice: implement static version of ageing
Message-ID: <ZHzKVJZ4TFb1F7pZ@corigine.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-13-wojciech.drewek@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524122121.15012-13-wojciech.drewek@intel.com>
X-ClientProxiedBy: AM0PR02CA0189.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3895:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a2a08bc-581c-4399-0582-08db65217a78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QoIQD6D30huveVCOFWTD/pJoP2odT5DxpYVLm3c09tkIuzSlbJ3MvZlMnZ6WlWltNPB7FbgZ9N72bx9fjwaOuKdJtRsvOKL0nyY8nCbUlkitz4RRVRUiJFiL3z8y0yi0egdgF0LFOIGABDXtH+kfNMvaezNVRg6Bww5YTITEzEtM3N/Pyos4GBL7Skpa4fa6k7mnWdlgnEgxdEOzQMraOtqDwN7syz+XbFotsIQdgTz6Wgenjl6QuldzFu1F5XwrFZ++adP8NXx8/VyeU8fH5pXE7grYyRmQQyyt5Sovn2wTQ3NFPK5NcXhXo2Tw9i9LKoEcTAnAUCpCUPX01Xt26k/wkaM4vkMPszSVbOUN2iJa/LltdfVHRlLTiwT5jq3UU1SE6AEHwr4de7hD0i5uMC41Z08EfLDqzqoF6blRfTeOvifZssILOa0DreNZIloKQH+6JlhG0bzssjKb21r1STZdTBF7gpqimUd7ueftGMxGwv0D7qvc10FUjkYvIxKxYLyznWiH8Fpn585YxBNFxmx/RtEQajbWglAwUtclKRqfnsLpW5u37u1Xf58gfKQhYjJxjueG7cBNhi2x9CkEEg1S5h/Ld6VeYWJAAjiJcH4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(39830400003)(136003)(346002)(451199021)(7416002)(44832011)(6506007)(6512007)(83380400001)(36756003)(186003)(2906002)(316002)(5660300002)(86362001)(41300700001)(8936002)(8676002)(4744005)(2616005)(6916009)(6666004)(38100700002)(66556008)(66946007)(66476007)(4326008)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5XTnbT3//Z5CP+ykEaQFIdPNxmchZYpb9h1vooqoFpTe7kRWbJNAN64fLXGI?=
 =?us-ascii?Q?kHICo5s1DkNU5I0x3unUALCLW4EickvDxvntamTyh/mK9hhNQUVA1YuQcUPB?=
 =?us-ascii?Q?wZuwtbhZk6AaZ4Bn0+pahcs63VdAGG44GX0Cw+43TnH3rGPuifaLpj3E5W64?=
 =?us-ascii?Q?Y2j7kseEg1XiWF+IsHbL9zLKkARoWXKvJEgrYU+Cl2AwSMs4nAEgN1wYDgMT?=
 =?us-ascii?Q?HcOysAvAszzDMe5SahMX3Zwa25xzbGoXmlGw/5OnFEPmj0ZpTXhOb1SneWnP?=
 =?us-ascii?Q?BEIJOMNSt7JCn5u7n7d+a41w0Twdl0qt6nfZpfFoPO/I9lJ6JkxqKrSMsaVS?=
 =?us-ascii?Q?h1jAFCqviY4Focguf5u2EEyhLHda5JVByAWG/MD/dKzF2FgAhQFkWTnXp1sy?=
 =?us-ascii?Q?nn9MJk2Sd57sbROAZLHwqmmnHvr1Xg+e7c8uMIEBSqwVGPLCeQxXEnIJrMdN?=
 =?us-ascii?Q?QVFNYtV4okYbRa6L5gcpi2LPZ7R6CQZkoaH1/1CMx0qEoYLMEl/0GiP5ovDP?=
 =?us-ascii?Q?fRg1QfEvPQ+PA9/7Yro8UM40i/eKIDL3CyZv8OD0Ug6E3Ua8Tf0Psfj002Zq?=
 =?us-ascii?Q?y9jM6F6QdZXhmgfr6Vj46Ly97B59VPWMhFov7UVmnB2hzVURzsMfQvqtWJeb?=
 =?us-ascii?Q?L+O6+ht6tpaOqVZjro1S+rhRFyGeU2z8oE//xlq+/MMaKg87TvXBJmZ3EmGC?=
 =?us-ascii?Q?S5+/EtwwU4e1LNpWgYKOaWZsEYKOyO4g4TYYleq1lbKYvDvfQUPe9lt6pGlH?=
 =?us-ascii?Q?kxCBgFM2GNKBwVSK7xJy2w83UmzM3+4Dy62BGpUdfNZqmgoIw+AGY+ukBDIx?=
 =?us-ascii?Q?f0J1zFutN379MEaPZaZ8qsh557ib32v2ipIKoegVv+zbxShEoHOaP+Gp7qhr?=
 =?us-ascii?Q?JK4QweWuVnX8qZXZlk1w9lR/48bcl59VGdyLW7Z4rVQBdsrOV2Q9hGU0f4ei?=
 =?us-ascii?Q?OCTC4jkMmv/ZpENVGPgWqa+EwIb0T5au5275HKL1nf5LKGHns99zvaaUP2Ci?=
 =?us-ascii?Q?LBwht9ow930ATTkoI65IapSIyd/iLGR63OdZYz0ruLigIUEIxS/JKFU98q2S?=
 =?us-ascii?Q?1BSSkl9eUFvfG5cXTAOhN2vHxoOFRGejSrLO5fbh/gL1e/cD58LFWwIS2476?=
 =?us-ascii?Q?eUK9wRpKXDhNyWUZ277hfHez+DgPJZyyr8PNkmAUE+JuOto9C5hg6Ihd4dh2?=
 =?us-ascii?Q?P1OOP7EZVvB00/9TjFOuZkb9nxKnQ6EbPViODeXwMgUwEjCNtyhtdGwIVEPJ?=
 =?us-ascii?Q?Qs9aF89jKLQwoAPcmj/98dY7CXa5SDaJyRTdOaJDTeZPGgM5NMCNRlF9Xboe?=
 =?us-ascii?Q?+MDEdmv6gsvAmjfzYjcmiRUyPtkOD1TaZYiovcGNr6SD7u4AORuc7M3pSHgx?=
 =?us-ascii?Q?pSHYdWsj8Jvu9lfPHKQe0RvhWK1hi/B7Ebd5gub5Ee4q0ArZl0r7r3iHxzDn?=
 =?us-ascii?Q?3UmnaQAkP/9/oefEIhAuvvZaqxbqoMOgFmiKYMB52E9dkVrLMH4jW0fCux9q?=
 =?us-ascii?Q?v+GshD1od7RQPDViKa3sSCuv9g/4s8TIAVrM5MJzw5hp+jVxgNgwZ0BIn1nt?=
 =?us-ascii?Q?I3DS3VaqYhjyGsmgE4ELmoxCaLEDuW8ia++h/cCd6M3048ZO8VThsWm7+8Qo?=
 =?us-ascii?Q?NjNsrBr1GIpDaCQeWZ5YfO99K79UjJmchJthhjiYNOKFFtwuZEkOzlGDdIrk?=
 =?us-ascii?Q?MBxmZw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a2a08bc-581c-4399-0582-08db65217a78
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2023 17:31:06.7138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CtbgNVWtl/NmJrSeyd4q7SY77FQSqJMFlxhRE5XmfEtmAqzn0S5iUnwhJvb8nuVj02FqcthllxWtiscLpZ4cTx2gk/aXkRSnsJKC6NQs1jo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3895
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:21:20PM +0200, Wojciech Drewek wrote:
> From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> 
> Remove fdb entries always when ageing time expired.
> 
> Allow user to set ageing time using port object attribute.
> 
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


