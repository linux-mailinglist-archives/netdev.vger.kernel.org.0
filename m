Return-Path: <netdev+bounces-1102-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0638F6FC304
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:45:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C3681C20B07
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F5A3AD45;
	Tue,  9 May 2023 09:45:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AC18BE8
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:45:34 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F25A1
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:45:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vd6VssgUEPWlCyyuirRyzwknhbY/Nhyrl+sLucI01eaMBa4s9uLJ4tTQqxoHFyPFPKV1aH7ovGCBkJwlmicpKqomule7DwMD3xyKRMWixT/r16B26246RbvED08q5Ltncxn9jbySAZpJ00s8wsFr8fSIDk6FQN3JGblopdpPboEgEZbgr213bpvVidPwsm9zUHfZ+zrdHDtapmJ8tGl5VZSjo0+GjhgTR7OQ2VNmZdtXLzB91ZHC8dMMiIoN6Kvy0BZQQSBrBs9maWzz9fGXTr+Bv6BJnWV6VM+5B+EuwH9vcnthnEhLPZ6XpV0Zc+mEK3pMR82N/4drN4Tie70ipg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dLIoMGJsBMPsqozsBXbb1xXpdYgVg9W6if7tTXdbz+k=;
 b=T1ntbPb9ql5wymwkNyZH9cNg7Jbg/KlbdbJcXIoYHfKuZerJS5ALbYJvuYZdlaWqkhd/3axrWP3kPLCC4a5s1vBD8djBzZRybbh5uJPRrF5YrNcBlOLzzkqTGubgOht/YemBVHqkOFKb1nCe5SD4K78kaYUDvCvhdk/+5nOUGuFgFP5lI2/3mLlNqWlfJ49mMu7+eS6wMX3XZFG/8VSjPrfIQXsZ/72+DFo2ESKdaxhHBtVMIOt4ZeJ+/H/9f2R8XWiazy6efpCEf9maFjFbXPl7vi/mj/JMkgLxmCkPjH2YWeD2/0NWBH9TD8bnHUPrBaRySFTJ/fbvfrH1+RayYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dLIoMGJsBMPsqozsBXbb1xXpdYgVg9W6if7tTXdbz+k=;
 b=Go2NopOOPvikBNugsGuoy+fJgrjbz8nB06Bw/xYQHLt+SoL7quYY5wEKw4q6H1HeCa8IJTtceDPABkhTbc2w6gNxy2m2/xbBxIUyV+BoH7kS8MltspOUUmeohPlChw/5FVR86iTwrXxPWpZ4G/1URYlKJM0G4QTkPCGlvwCfGFQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6177.namprd13.prod.outlook.com (2603:10b6:806:2e3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 09:45:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 09:45:30 +0000
Date: Tue, 9 May 2023 11:45:23 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Zhang, Cathy" <cathy.zhang@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	"edumazet@google.com" <edumazet@google.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"Srinivas, Suresh" <suresh.srinivas@intel.com>,
	"Chen, Tim C" <tim.c.chen@intel.com>,
	"You, Lizhen" <lizhen.you@intel.com>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Message-ID: <ZFoWM5YteJL2ZRxL@corigine.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <20230508190605.11346b2f@kernel.org>
 <CH3PR11MB7345C6C523BDA425215538D8FC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <ZFoHpoFDkoT77afk@corigine.com>
 <CH3PR11MB73458835C7F7E0316A6325FFFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH3PR11MB73458835C7F7E0316A6325FFFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
X-ClientProxiedBy: AM0P190CA0023.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6177:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b3206e8-fa6f-4d9f-3cdb-08db5072200c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	j5hORNC2G7mSZfUkXNEvUxVeSD+hfgn7NhZlRx32ynP5eB6AQH+OPp90w+3Mm6OWsq6vkIYewg69F6iJTLzVZ5D09E54t61/q1f0suGyGQvZV5GOqtLpqWkD5cInofcS8hno7OOeud8FLWrMWOearqvHMDrOV/FihumC6hZkgHNw42kS6NJLPAP8jjh6tdcNyAx69UcqRw6o/AWwyr+f9sCfWOludq7vQpiEu5Bo+Klvd2nBCdW61lqbngqd7rdbPmUBUdnVn8Xx51aMv3APKQrycyQNTEplKluT9b1HwiEbKSzLoBW4BaICJ2oqoE+j7NVytPerOFfA0P4VqAzjZrogiVVJtcWLItWWeUgqZJz+5v0QC0dMD2/2U7sXQACjIinf9mAlJoE6wH7kmqcZZA247Xsk0QtDhvMM3UOzFhcjdNILiB9wiJszClsEQoeVa0K7fDgf6E/6+BoKlFs0J/DarxDs4T1ndqODT4msybLiVQWshlbuhOqe35XSZCMK2+s5feOqJGPliPLnj9GyzhJ+Upb2s8ZMtkH4xHB1u0LN3LAG94liGdEcWVNOg2bq
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(396003)(136003)(39840400004)(346002)(451199021)(66556008)(6916009)(4326008)(316002)(478600001)(66946007)(6486002)(54906003)(86362001)(66476007)(36756003)(83380400001)(2616005)(53546011)(6506007)(6512007)(6666004)(2906002)(5660300002)(41300700001)(8936002)(7416002)(8676002)(38100700002)(186003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eXPFxnDko+O88DXMpxkpEJIrIb2NpdAajSg2kXLny+rBQb+Kk1v58KbLfTF0?=
 =?us-ascii?Q?0FJ7SMb/Xx6aohXSDxqFPppmxvjEDM+7uK1jx0wgu+VfMY9DFckRY6fFVVzw?=
 =?us-ascii?Q?fKpcdcQ7U+59kmeSt9hjZjyucdUIpo5io9ceszn1p3gwnc+SI3nwNWSktmJd?=
 =?us-ascii?Q?/SLLo3yvGRt8DGmCoPZ8/CiY1A1L8DJmy5fuJvmN59pQOryHJedU2+hPUdaQ?=
 =?us-ascii?Q?jHeYOQkr2H+Sm4+PW2KjqUkrW+MGpFQW+azf0ggr4q2io3bP+jmfNly6ySGi?=
 =?us-ascii?Q?uOx7Bfa5ZMt2TLgWl/czTsmhVVxnfnNAEdh2SAFYRthMIC+9j5UlHnYCByZA?=
 =?us-ascii?Q?azKiv5H8/wGsKknQwVMcvLdU/itmjDBzWJ9OFJ6JalNQ1qjmknrN9lDW2gdU?=
 =?us-ascii?Q?bkXopG7q7j1H2DpBxf9maIIw3ggDzHesoQDesbmPwkFg5BFHCD07wxUsc8Ev?=
 =?us-ascii?Q?vmzQR/hi7jnjq1w3I3I/GLUwJDnROH55bI1IzHggYrwW/frgTsiA3ql7Ub2f?=
 =?us-ascii?Q?xg42Ej+qOpgrP28go1ZisqF5enJFHMhtzUzaxhmyOCmWIFo4v6yV5i+Uvo+V?=
 =?us-ascii?Q?R4+I+/iIopPMy+IXKBuzaeP8bxh+6wrc25YjoAjgKh+rQ3kT24FmFGbFISAO?=
 =?us-ascii?Q?VE5dXyfpJB0JblrExrGVfeSchXcJq6nGSutSv2fUWcEpR/q2ubYyVdlcACuD?=
 =?us-ascii?Q?fiQbLWG3sav1TBUmiMe3IeLjixUPN6NBCVPObWacNfQ2IjdCNC+5R4fDjVEW?=
 =?us-ascii?Q?WrXSvG6P5dabCnJSKa2zoCDV/+TGeiDxZnCuY5DKz3UPOWnVxg9/p/yOpJcq?=
 =?us-ascii?Q?kT5OCjjVImZGzShhHtELhLuDOyJKAfucVuRn2sfeRHLVUkUroclwF9rlYdp7?=
 =?us-ascii?Q?xifY+eVqtRPFKM6tto4jOj9OixxKj/hju2s9h+5UlOBI0v7S9NpQmuIiiBS/?=
 =?us-ascii?Q?NO+hVq2eK73DWH70ipyH57HKIejEaDyT+fOoM2EvyzhQ063nsSmI3UybF3W0?=
 =?us-ascii?Q?jKT0T+HccSMe959Sgvcz2wOouj0fwlYYeuB6MegbGBIpQJsxt4FeaRl0X2Qm?=
 =?us-ascii?Q?EdiiD4lrBc3iO2awqpde6TfcBdAKB6HqchtZyTNRrYN6mCZ8Rs9VL1gbamah?=
 =?us-ascii?Q?eV5E6OL8LUPf/SgVw9EULEdm82/yyNIAaHHJ4gqWRce1w/Nhp1G9aCzVSOZw?=
 =?us-ascii?Q?wwwpZW914qVPztI3/o+k3iL57ILPd+c3377fUmseMkWFHhhAfG6NjY0BqPVd?=
 =?us-ascii?Q?MTj/Jn6l+nRGWfZGYZHmHcommJqajNy79vav1TssB4ALOIReIh+deuNTinod?=
 =?us-ascii?Q?DQKxHdUHPxgVs5CZrwrNO/Ii1NTP05ZO4qhdIjx2QsgtNMKr8NlDYhSRLImq?=
 =?us-ascii?Q?KhaUWQL4ihdI8BOzn4Z0AE0w+GhchUCUTW7vqy4kb/wkxbjCFVWUPXG1rmig?=
 =?us-ascii?Q?Z5acV5AQN/tNhtVZBvXIEAd2yWfR7P1aMM6v1h74jBpfBNTiZt+S4qROP7ux?=
 =?us-ascii?Q?LTHBNRLswJRdEZVWJVOU0JY/w58D9x9KxRH9V9hD7xXkdKW5pNA+oQAzBeQO?=
 =?us-ascii?Q?S0mKHYJnXr9/rbfvV5pPIqfFNpHvnnkYvPBSS/5+1Zq23jeMjKet1d8fwrXa?=
 =?us-ascii?Q?dXWzSFJigUqi0akTckFJ0rUlv5GDw85JYnCl6n5s3E96J7Q6Wyb30jsRX+RY?=
 =?us-ascii?Q?kkls0Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b3206e8-fa6f-4d9f-3cdb-08db5072200c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 09:45:29.9623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CHuhVfXO905PKj0FeR6KXLFkmoClFqtBMCHSumYnJCCeZQ+pCHzCVexyOw9eHPJhvmE/uaNbX74nrti2/9LLmnTc285HYokaknRDirWWhUc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6177
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 09:36:59AM +0000, Zhang, Cathy wrote:
> 
> 
> > -----Original Message-----
> > From: Simon Horman <simon.horman@corigine.com>
> > Sent: Tuesday, May 9, 2023 4:43 PM
> > To: Zhang, Cathy <cathy.zhang@intel.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>; edumazet@google.com;
> > davem@davemloft.net; pabeni@redhat.com; Brandeburg, Jesse
> > <jesse.brandeburg@intel.com>; Srinivas, Suresh
> > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> > Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> > netdev@vger.kernel.org
> > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
> > size
> > 
> > On Tue, May 09, 2023 at 06:57:44AM +0000, Zhang, Cathy wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Jakub Kicinski <kuba@kernel.org>
> > > > Sent: Tuesday, May 9, 2023 10:06 AM
> > > > To: Zhang, Cathy <cathy.zhang@intel.com>
> > > > Cc: edumazet@google.com; davem@davemloft.net; pabeni@redhat.com;
> > > > Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh
> > > > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>;
> > > > You, Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> > > > netdev@vger.kernel.org
> > > > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as
> > > > a proper size
> > > >
> > > > On Sun,  7 May 2023 19:08:00 -0700 Cathy Zhang wrote:
> > > > > Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as
> > > > > possible")
> > > > >
> > > >
> > > > Ah, and for your future patches - no empty lines between trailers /
> > > > tags, please.
> > >
> > > Sorry, I do not quite get your point here. Do you mean there should be no
> > blanks between 'Fixes' line and 'Signed-off-by' line?
> > 
> > I'm not Jakub.
> 
> My apologies :-)

Sorry, what I meant here is: I think I know the answer. I could be
wrong, because I am a different person. But I'll try and answer anyway.

> > But, yes, I'm pretty sure that is what he means here.
> 
> Sure, I will pay attention to. For checkpatch.pl does not report error, I submit
> as it.

Yes, perhaps checkpatch.pl could be enhanced in this regard.

