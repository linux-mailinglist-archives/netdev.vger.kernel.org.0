Return-Path: <netdev+bounces-9054-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 911AB726D20
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:39:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD13C1C20F50
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C035C19E58;
	Wed,  7 Jun 2023 20:39:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1B11EA8C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:39:32 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2090.outbound.protection.outlook.com [40.107.244.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F582688
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 13:39:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fuIKK+DBMXjGLV0U65y7mO6RAKGUCDz/iZ+EhwTj02w4GVgl4Ywd++pgEhYnCmHIJ9gW0a24f3ZxMREgU/fr7GJaILbjTorhLZlQmt5Z7nFdKxgqMSNWuDeABDUQU7BhsBgbxCl4OB2bzDVY8FfhdrxgP/t5q094evNK/W++LLtLVzKmDHVe8d/1+YSNBUfA2TaSHTdmS0h/GOe2Lot7XAc1I5WelO/rf7rnsW20TsKVTh6DHr6GTBpPhUqYDMFtt7r/4bxExR7W8Io/KUlLIebEqGysW+9BtKhzo8wEoYFlFk3D9qccI5zFFpK8+zdIZcLblNzzZ+QsBPonuipAQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Z3LlN4tlj+N2cNFmlsU8ZoGeD7cUHqJkM/4qJaGeSQ=;
 b=BXUV1Wzt8hiBXR5IX7Ci8dyJBlfMeBPnyHaBP1nZjDq2sJ2o0t/y0Y/kgjdTgIezl2D7ts2XeoMbzB/zSc1TkgcKxDjGPh1G45kZpsQ+QDbmkAoz6uQHK495H0dPzNsg/RD89fKINQzEj1nZQnM3DzoZYyv46fkB+eLzHrtazSEY+2vx+sq128N1Q1IewRDJtPrWTwyo6Fd+yGXg4dsIjPhBdmC6Y5aiptZGZxHwzyGQpOKVGmcl/gbP2o+CqhfhpDvlJK+SdJ/N3F9qZc3PNbwARIZvdDCxKkV2lEkCKsM+JeL1gXdHFh40GcDh6wpJ/s9EVHtEA2jd/RaYGSwd9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Z3LlN4tlj+N2cNFmlsU8ZoGeD7cUHqJkM/4qJaGeSQ=;
 b=JYHVNNIhhuh3QVts70lzLgJfsPalyopAaNdgxSBvxyfgEkx9/7Ql6dSNh+qxf0jkzKEtb6wo39ZTjW/VHwL4BQZPMVI4GHqv9lPiRuj1cIiqHCs/Kw31lxcM7BrFsehR4L7x6gMWzY7aDP/10NPXiJfaci1NJZy7Gm+qfKuCMmA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by DM6PR13MB3940.namprd13.prod.outlook.com (2603:10b6:5:2a7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 20:38:53 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e%7]) with mapi id 15.20.6455.037; Wed, 7 Jun 2023
 20:38:53 +0000
Date: Wed, 7 Jun 2023 22:38:43 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	intel-wired-lan@lists.osuosl.org,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
	Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH iwl-next] ice: clean up __ice_aq_get_set_rss_lut()
Message-ID: <ZIDq0zaDuh8qAeIW@corigine.com>
References: <20230606111149.33890-1-przemyslaw.kitszel@intel.com>
 <ZH9S6wPIg9os8HYa@corigine.com>
 <1e11a484-af99-4595-dc1f-80beb23aae9f@intel.com>
 <ZH9hS9BBDhy9lIG1@corigine.com>
 <9b5c6653-3319-3516-0b50-67668dcc88f3@intel.com>
 <ZIAzEh1Y++os19fl@corigine.com>
 <20230607094228.10f5b84a@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607094228.10f5b84a@kernel.org>
X-ClientProxiedBy: AM4PR0202CA0001.eurprd02.prod.outlook.com
 (2603:10a6:200:89::11) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|DM6PR13MB3940:EE_
X-MS-Office365-Filtering-Correlation-Id: 98c392d9-ea08-4d92-7934-08db679734cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	T9sjkOXwiWK6AMl6OG3hsol7nosLwb5tBiOwiTLWrJXbc3NT07EI2s0zN5wdB7Wq/ge0CMxptWtcQ08nt0m+uR6B3T8EHCEmOSp9eQ0bDdg+l+7xZgjSN5kg1Id+xHksqb32A32R9JUfgRIUqEA0erJjwUBrpvtrDFY3BgoXDJYa6RU/sexTauPv0pMvFlHSasloXkpcFXsIoxe2SyQHPzzZgyrbaCQDlUBJf1D+7WbOqEpqRDg2dae0sE4Q6cXihAmu8bXFNOrWAO2fhhyZZJC1lqN+dbANHJN4ymRSGrITfbunTbbbEPF+HEkO6iUZX+58iOef8EEtGzB+hYyldQ5Cbk5UOMHH0ERW1NilVtfzwWdyegdO8sJ7Rk1FoMJuuLFtUAIej52gpzhuQmVKTqvd1+HIPr5LibDmbTyuf5SYX6mx+hgEobbY+ERAN790ybgOehLUCxIrXNBkztA/rGNtZyVF2X1TLCRlleZ7qrE4uvaQam71h6JTS8Y3Ik5d923k0kk3Hug9cb+XqBfLVKgsBQOFCOl5cdjOw5mlrIWyEXVb47mPpHeb2Nduzanmss2oK4ZUwdjrczc/rwnj5qV3feDPqOnflra5BKlo3B0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(366004)(346002)(376002)(396003)(451199021)(8676002)(478600001)(8936002)(54906003)(6666004)(5660300002)(6486002)(316002)(41300700001)(6916009)(44832011)(186003)(4326008)(6512007)(66556008)(66476007)(66946007)(6506007)(2616005)(2906002)(4744005)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?d9FqMh67naMmSmD+tKz5t+ubNdyr/Af7oqEmxlb/1Nzqlriv4jBsd9Gmhpxi?=
 =?us-ascii?Q?7iwmSG0TwxbxylUUe0Se+OSo1GI1C1d0NIsUl2QR7BBITKFFDR3F1cwLv4ph?=
 =?us-ascii?Q?fiyUE23IO32hR0tvMbSYkGNbrIyGd63PcsM3ZmBR5hUt9OeV05xtunVBkcnv?=
 =?us-ascii?Q?/8HC39Q7G1NayHkBPgevJgra95rgxFPlJP8fd8JGfaOKfUpFHO8SdG6WlKLM?=
 =?us-ascii?Q?3wM5AN01cb6ytkgCVd76E6n7JYDFuZjVRsgpsRBRbU8/7urjuCBkfDH+mQVb?=
 =?us-ascii?Q?ar7LxAvucZ9+djsLDOqNEO09WcZzpunBA+BSSBDnxh7szH8FkmenVsGquFDR?=
 =?us-ascii?Q?eY9ZrR39lkveWOd8yByFqsQbpUUwHgPvKs5ApW5v8V1RDH7wmWpfi6H5Pr5F?=
 =?us-ascii?Q?gh5MzvHbyvybVRHGiK1JU6XHHF6zwbvYW62Idlk8SUrbh9tTa+EsirzgMZzi?=
 =?us-ascii?Q?2hIkmxRw0bCAEyPwakKCwgC+sH3F/s5TjHl8uJ1ilDozvN1jSa+QZgZqGtdN?=
 =?us-ascii?Q?+wZk6v2PqnTGDWuz+9PiZGCstBTl9tASIU1vwrYNUpKCvpgxVYf9jUGRybUN?=
 =?us-ascii?Q?Bq5qJsTf9LR0dJpinCMoYwg59slgTr2CEeBjKFtYTvdCoOqLdzduwHMSkPX7?=
 =?us-ascii?Q?QUPMfHIrc3r6w113TXpk8k1dheHmorBvka6NbsPBNylPdiMr/YSdPN2xnXNy?=
 =?us-ascii?Q?bR4tzAcc9ECQ99R7PQKrBlHecOowvjL4xIwFPdjamnlUkAGngawXa0eig83a?=
 =?us-ascii?Q?wTxEmJAhDK8Yih3UZGAzy67uqfTFu5JUKIVPON51My3U2OQTM+Q+O+u0jBZw?=
 =?us-ascii?Q?5S+ba18JJ8wTTZtYd1l2biCpFYaGW2ciTDLGPqN/lHKAmHtiKiAcqiVhIFfP?=
 =?us-ascii?Q?mZEoFlpaYKqU+ek0b+pCj95XO97oyKkQsUH4Rni/hPYyEY3YbVGfve4vmil0?=
 =?us-ascii?Q?ExBVqrCATOJHOvnJfQjZp0taKNm6paHoSQ87CSsxJt6UZYS14XlW2OJH9DaL?=
 =?us-ascii?Q?CXjrhDWy8yE0q15yCjDEooWF+7uYIZcsiloAJl5cVnLkYL9SLfgqEz8lgMHX?=
 =?us-ascii?Q?jI4soljkS54AmnJ5VEYUXT/IZIiFvXifQoFswYM+N36+MjCUAG2Ha6S4+QuD?=
 =?us-ascii?Q?9Hal7sSHcEA/cbpYzPZS/DiDYjRc1UNjH9Vlrs4v3WtbqqAA0bhh60Eo06UH?=
 =?us-ascii?Q?wkDjqwLhiakc6kU20mk/Xn5VG3NoihkUOH4vX5r4eKzPQ7uMcrkEvB4Z0Yna?=
 =?us-ascii?Q?7n1aNTIMisNV+KobHfj1Xho0ghNDMdHCMPkIlCY6F8X+aUiAsIUmaKwVUDcv?=
 =?us-ascii?Q?VXUoUsgzIAEL7eChAAxcAytAYOj+x6rrmnsJK8BQdqtBUAOOmFhNao4YAiLl?=
 =?us-ascii?Q?w5XvR+mP4cnnlb8jakGGcsGCMSY2XSH/hl1EtK+cC5jIKV6VeQ6hAkV9BQbc?=
 =?us-ascii?Q?ljWp1KPfh3FJO8irUtvVqm3PdR4j1xB+yJ8ROTGYgwY5vFkgtwMFm8ulSeAT?=
 =?us-ascii?Q?pW2RhdbGVdwQzYvsbqK8QYgPMTKInxtyXqj3jThPyFw8q81cdnkyVIoDkET2?=
 =?us-ascii?Q?KBYtSn6r87IZmqhGqIMlpG871Rqj0G0aseT7Ah64/dumGgEDD9XpVma09Ehg?=
 =?us-ascii?Q?RLARRavmciLlF49KexKI4UL0c0QdBg1eK7gv5WT4pe6MbLByjHcwZLCDtQ84?=
 =?us-ascii?Q?yxnVbQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98c392d9-ea08-4d92-7934-08db679734cf
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 20:38:52.9021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IQCSwQAjCzbI7X/2w8BZ1WVperBy2VxLhM0sNt7aEyKC4ooPQ/7e0xLt0uKo6POG22btn+YCYlJy71b2MjZDRxhYlqJjYRfH17q3BvMOZrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3940
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 09:42:28AM -0700, Jakub Kicinski wrote:
> On Wed, 7 Jun 2023 09:34:42 +0200 Simon Horman wrote:
> > > it's the same on gcc-13 on default (make M=...) settings, I think, I will
> > > post next version that is passing that build, even if to make integration
> > > with new gcc easier  
> > 
> > Thanks. TBH it does seem a bit silly to me.
> > But GCC builds failing does seem to be a problem that warrants being addressed.
> 
> Isn't GCC right? There's no guarantee that the value of @type in real,
> numerical sense falls within the set of values sanctioned by the enum.
> It is C after all, so enums are just decorated ints, aren't they?

Yes, of course you are right.

