Return-Path: <netdev+bounces-8044-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F3A77228D7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:32:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A6D92812EE
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F95A5238;
	Mon,  5 Jun 2023 14:32:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CF31F178
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:32:12 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2133.outbound.protection.outlook.com [40.107.93.133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F1E83
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:32:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AJtXTFq26QS+tF+Um7HzQ30Tu2lYKvbhzX5S+ygl1qklqIIpNDO2nB0v0Jon8LKXMTIt2/Pyx1/EhV/YCwvGaGJ5pHgE+BrGencg6k2a7bA4eUvAgm8v5qiHiNr35dVCbdD6rWinXi1DXyiUCBOASkzz3T/w6q/ltKB+bfhe2op9BDvplJGgzkVlO3mVyW/fLXoJ8Lg8PDuV78nOC0LNv+pkgEL939f5in0Qhu+RKvusj1GSZ4h5lnSJzcuJrOvFhmapA7lNUm963N6tHHLfJvJyljtSSJRtpk4By9wHTwyVwzF1nvp9wUl1fDrPz/xsBUixHszRnQ9GperhnFq72Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I3WMH8ov/CKWub8UaUFlun2mxPEZg0b0wUC0ineHRfQ=;
 b=NptxB7m56bd45idX+DqP5KhB+XAA3Ys923DVXDqSlfI0qb0Wm0NlPkT/boGpwwxhpx2PNze0nfsOCdEjqxPJo0w3hB1DeWxubwK/9S103MhkdmhXxKoQBNRFpzB9Dwy7r5F5lD6kySX/WDVv6cjGJbhewDS8zFoQDiaZuedvqnImE5HDnnVy0051TgpAqSiMmUAc6z9fPo+sUZToSXKddDdnlf8j3pvUDMw0cuuoHOj3AW90YHV36EICuwwOM16K0LEmxh0x3j1HP5WgaMbxNht1wqhILMeFe4MgwhsFW8KhTBLdcqQ/HisyxzcWXqB1gDsfsGCYdYUheQrEDoyOLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I3WMH8ov/CKWub8UaUFlun2mxPEZg0b0wUC0ineHRfQ=;
 b=ksoKQ+45uroLv3wjKyoeVkUB6wMmZ0kLc5OO4e6ZGQHHymZa7DpgeHwFIkLB1BShZ5yi0/2qtb7GyB9tjcJpK3OtasHM76VWhSV3C9mts+Tg+d5oI+WekCegZvI2K4TyKp0gkPcPoIdW1VWB94TVtPofSMe+SQ5KLLUjoJrycxY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3905.namprd13.prod.outlook.com (2603:10b6:5:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 14:32:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 14:32:06 +0000
Date: Mon, 5 Jun 2023 16:31:58 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jamal Hadi Salim <hadi@mojatatu.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
	deb.chatterjee@intel.com, tom@sipanda.io,
	p4tc-discussions@netdevconf.info, Mahesh.Shirshyad@amd.com,
	Vipin.Jain@amd.com, tomasz.osinski@intel.com,
	xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, khalidm@nvidia.com,
	toke@redhat.com
Subject: Re: [p4tc-discussions] Re: [PATCH RFC v2 net-next 05/28] net/sched:
 act_api: introduce tc_lookup_action_byid()
Message-ID: <ZH3x3mT+80K1BR1O@corigine.com>
References: <20230517110232.29349-1-jhs@mojatatu.com>
 <20230517110232.29349-5-jhs@mojatatu.com>
 <ZH2xKs65IZe1LMTC@corigine.com>
 <CAAFAkD8dUoPjff+VaRY95VsvQDpSzBdtUg=JzjJnrqsKc7AHJA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAFAkD8dUoPjff+VaRY95VsvQDpSzBdtUg=JzjJnrqsKc7AHJA@mail.gmail.com>
X-ClientProxiedBy: AS4P195CA0048.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3905:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cea7ab8-5751-4ffd-f0cf-08db65d1a2c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Ja5hgpi69aZQhLipcmfkiLSpGq7/Y7PujbS+d3tVSmf2BemI+ogGClTzlr5SJbMK8SDMQA96FWX+Y64QlgzRjhGCL7dQ4jnIfXeRNGDf4yV3hnvnR7Sr0guAg7JltQMbuZfIqmoTcrPDHbkhVZOwUcpyfuseENUMtWnt/wM6esAD1eygnbuRDegto1SLujQSZxSLUT/JlKPUT/oBfDu0PnD9D0vGddVK3rYpnwkBaGjim67X4HttPtF6fCuczCqy1WZtqTnGuepYmWnNyjoHlzNc/UQUji3Bn9jlv7jna4TCBtUW/bscvpiIHZG7WNhb8qkbO4N5ROlST8n4XgnbNy1/EQCsuAQt+JBKJQgmeAZaPPrJNbTPngxCyAi/agiasdZgsQgY4PoRQqM6epBdWM1EjoR+NkO0cffDdw92/UfD1AKBcRACrn4i9ZVB3Inty7jhg3Z4mtMGfy9iSI0tf2LE13EIua4qq+1I9Hvi8UVEuKsPbg+3sWE/JYJaUuhKLbNgfE/DXIyECASDetaMVTd2wR8dgN7Ed0RP1HV5Krw9XW8JuqGPJ9xJNpInuOovXkRHUF5jXukc1+SHeEwHXCiuYDOU++7p4ssrItIvrhk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(39840400004)(346002)(376002)(451199021)(478600001)(2906002)(36756003)(966005)(6486002)(6666004)(2616005)(83380400001)(186003)(6512007)(6506007)(53546011)(86362001)(38100700002)(316002)(7416002)(8676002)(8936002)(66946007)(6916009)(4326008)(66556008)(66476007)(5660300002)(44832011)(41300700001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDV5aXhvS3B0dkRmVVprbTQrSkdZRlNOU1JrclZHL0QvWFpTK0daRHYwOTdH?=
 =?utf-8?B?THVabXpZU0MwWG9PSjl1eUR3ZW1lTFRZR0x6UjI4RmJXMGtjSVM4TklRbWJ3?=
 =?utf-8?B?SmVFbUo4NmxPYmJLQUl3SWs3V1kyWng3Z3FNT1hkK3RWZGk0aFdJWTJJaklF?=
 =?utf-8?B?ZDZRVkVSUTBLTE5GMkFITjJXajBpdk9BTjZ5YUtRZU9MdmRwVzU2cFNDOFlW?=
 =?utf-8?B?cVBLMm00TjVsa1R5QTZmNVVGRDFlMGthZHZxaTRQeS9PbVlMK0RUUkpNQmhH?=
 =?utf-8?B?NXZaWCtOd2p6cnRheXB1c3dHUnl3MWRPWmNSc25ydlFXZHJ3WU1GWThTdGMy?=
 =?utf-8?B?VWI1bE50Y05wc09TN1NZSHRITTg5Q0h4eStWanNtZ0dzTlV0RnRwMWs0b29t?=
 =?utf-8?B?VmxvVjNXMEFHdlhWYTNBMGFieVU2RWgwWEZTdlN5OWlxL2pNUmpmc2t6dGow?=
 =?utf-8?B?bEdIUGlSN3ZvK2tNQlMxRW1SZWFvN0ZKRUxCUDE5RVZ5TE5URWYyZ0NzakFE?=
 =?utf-8?B?WGVQR2FUdytVemhRK2gxQ05iRWIrSjg2b2FaQytGR0JuK2E0bVZqOHJKL1NK?=
 =?utf-8?B?UFcxR3dqbXNlamRRaXRsZ0RQTUdVMWhmT2g4bnR5bGFhaCtLVmFKcVA1ZlBt?=
 =?utf-8?B?VDAzVWFySTE1am1RQnYxckZWYlJpVEZoaG1tQmpucUYxQjZsb3ZLbjlteVcv?=
 =?utf-8?B?Wk1YRXp5RTBhd0JWSGFMblBYOVY4dWhzWEVCd3l3TUIwMzlnODNSYzd2UVZS?=
 =?utf-8?B?NXZJcUtoWDFvZVN1OUh5V081dldKZ0JaeGJSb2RjeEVuaFlia2V3VUkrWWVN?=
 =?utf-8?B?bHpCSllIWjJjbm42d0IzbEpHc21Hd2xiaFJRNERSVEp3aHgzbkNkY3hWZitP?=
 =?utf-8?B?WlBLdE96bWt1YkQ4Y2Q5SVVOUEFVYjE4Yi9mRUUwekx6eG1yaGREb2EwRUlH?=
 =?utf-8?B?MXBhLzZLU3BWbktyUTBrNjl3RzFXWlV0T1Q3TDlVZjlDNkwvRENHVE9IT0lV?=
 =?utf-8?B?YWZwclk4YU43cW9CYXU4eTN2Q3RNV3k2UjNYRDRFeWFGOFZHOEsrT2hYYy9S?=
 =?utf-8?B?SXNZbmNSZ21Ra0Z4Um9Ba2NPUVp0bi9tR0orb0gzNklZNTdSZGtkeDR0VzFQ?=
 =?utf-8?B?MkRzV29VcmpHMnl4NUxZMS9XTG1PL1FGSk5YNmNqdnNGdTQ0bkVIOG9ENmNJ?=
 =?utf-8?B?bzc1WVRYejNjK01WeWlLUlBSeC96c2UzWlhGQTRWQmtSdGltUFErbVAyUjB1?=
 =?utf-8?B?akVoM0N3SVJub0htTWFISE1QbWVlSWdiNS9vQjVDc2k4U1lMN2JCUU42MWhJ?=
 =?utf-8?B?aG1SRjBWMWxSeHVENXdHZjhnd1hvd3J2RkFUOFFGZXgwczNTOFduK1o1TW5u?=
 =?utf-8?B?aFozQWxDRHNMdXprUVQ4dXR3L2xHVUZDZVp5UHVCY0pCMzFlQ1dhelJ6ekVF?=
 =?utf-8?B?QWxaUis0MklLTGkwaFVpY29nY05MNnlDb2hFcTRES0xaUVdTcUZ0YVFIYnlp?=
 =?utf-8?B?WGFENEF0ZDFSRG5vWUQ1Mm5ub2FDRkhWZlZEb0Y4NklrZXExR25JNFBKd09w?=
 =?utf-8?B?Q0kzYmtnRzZORmptQ2FxMmVhMUxSVTZObWh2TVJ1anczK3kxNFVlSWh0WGxO?=
 =?utf-8?B?cjU4MjE5dmhwRFFYMUp1ZjA1UmdzMmtVYnNIRXNGbXB3allMb1hCL3BXYXJq?=
 =?utf-8?B?VGtVeUZoankvWWJoSUFobExWUzZyajNZa05qRUgxVW9Hek5LY1BHYmk3dG1T?=
 =?utf-8?B?bmNVQTRTMkl3L0daL003ai96V2hDRnNmYWdXNWJxOVhXRVZ5MmxvNXhvWWJB?=
 =?utf-8?B?Ry90NWxUQnoxdFpxUklMclBkL09WenpWVnZITnlOMTB4S1dWL0R3SCsvamdy?=
 =?utf-8?B?cTc5YkJCeWV4VFc5VXdMb1hWMmJYcXl2L3hpcDRLbGt0cnNyQlFZUkM3RjBs?=
 =?utf-8?B?MmQrSE1JVW9EK2s3Z28xb2RKK0lya0pkT0IrWnRoaFZGejJGWUorUVJ4bE1x?=
 =?utf-8?B?UHRqRDlEUnBpQ25jUW5nYjdldWV6MlBPRklQRXhEL0lXeWd4YmZIRnF0R052?=
 =?utf-8?B?WC9vNVpiOUplUmRsclVYd1YvNm1PVkJMbmY5OHJ2N1FRSmtqSVpvUzRIaU1W?=
 =?utf-8?B?MWwxZXdTV1hUVDYyR09DQmc3UElKNGRTTmdpZ3ZRN3RKYXdDbUZydzNNUmVB?=
 =?utf-8?B?ZFVsd01WWTZQYU5YS2xkUzRrVlRRNFphdE9iNFBtQ3d0cFdoaDV5QWxrMHcz?=
 =?utf-8?B?WE9nSjBaNlk4RTI3S0tRTHhDVUNRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cea7ab8-5751-4ffd-f0cf-08db65d1a2c5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 14:32:05.8696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qse+8OwjwChACzYdYOpJ2YGkw5aCY4LSLHnhVvHTxoczN/jTZjJEuTVD9NqJjYYjFmXK/nZlH3g7weYN6gcNPFEMTpsfRC8ji/ulWHh6jmQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3905
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 10:17:57AM -0400, Jamal Hadi Salim wrote:
> Hi Simon,
> Thanks for the reviews.
> 
> On Mon, Jun 5, 2023 at 5:56 AM Simon Horman via p4tc-discussions
> <p4tc-discussions@netdevconf.info> wrote:
> >
> > On Wed, May 17, 2023 at 07:02:09AM -0400, Jamal Hadi Salim wrote:
> > > Introduce a lookup helper to retrieve the tc_action_ops
> > > instance given its action id.
> > >
> > > Co-developed-by: Victor Nogueira <victor@mojatatu.com>
> > > Signed-off-by: Victor Nogueira <victor@mojatatu.com>
> > > Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
> > > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > > Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> > > ---
> > >  include/net/act_api.h |  1 +
> > >  net/sched/act_api.c   | 35 +++++++++++++++++++++++++++++++++++
> > >  2 files changed, 36 insertions(+)
> > >
> > > diff --git a/include/net/act_api.h b/include/net/act_api.h
> > > index 363f7f8b5586..34b9a9ff05ee 100644
> > > --- a/include/net/act_api.h
> > > +++ b/include/net/act_api.h
> > > @@ -205,6 +205,7 @@ int tcf_idr_release(struct tc_action *a, bool bind);
> > >
> > >  int tcf_register_action(struct tc_action_ops *a, struct pernet_operations *ops);
> > >  int tcf_register_dyn_action(struct net *net, struct tc_action_ops *act);
> > > +struct tc_action_ops *tc_lookup_action_byid(struct net *net, u32 act_id);
> > >  int tcf_unregister_action(struct tc_action_ops *a,
> > >                         struct pernet_operations *ops);
> > >  int tcf_unregister_dyn_action(struct net *net, struct tc_action_ops *act);
> > > diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> > > index 0ba5a4b5db6f..101c6debf356 100644
> >
> > > --- a/net/sched/act_api.c
> > > +++ b/net/sched/act_api.c
> > > @@ -1084,6 +1084,41 @@ int tcf_unregister_dyn_action(struct net *net, struct tc_action_ops *act)
> > >  }
> > >  EXPORT_SYMBOL(tcf_unregister_dyn_action);
> > >
> > > +/* lookup by ID */
> > > +struct tc_action_ops *tc_lookup_action_byid(struct net *net, u32 act_id)
> > > +{
> > > +     struct tcf_dyn_act_net *base_net;
> > > +     struct tc_action_ops *a, *res = NULL;
> >
> > Hi Jamal, Victor and Pedro,
> >
> > A minor nit from my side: as this is networking code, please use reverse
> > xmas tree - longest line to shortest - for local variable declarations.
> >
> 
> Will do in the next update.
> 
> > > +
> > > +     if (!act_id)
> > > +             return NULL;
> > > +
> > > +     read_lock(&act_mod_lock);
> > > +
> > > +     list_for_each_entry(a, &act_base, head) {
> > > +             if (a->id == act_id) {
> > > +                     if (try_module_get(a->owner)) {
> > > +                             read_unlock(&act_mod_lock);
> > > +                             return a;
> > > +                     }
> > > +                     break;
> > > +             }
> > > +     }
> > > +     read_unlock(&act_mod_lock);
> > > +
> > > +     read_lock(&base_net->act_mod_lock);
> >
> > base_net does not appear to be initialised here.
> 
> Yayawiya. Excellent catch. Not sure how even coverity didnt catch this
> or our own internal review. I am guessing you either caught this by
> eyeballing or some tool. If it is a tool we should add it to our CICD.
> We have the clang static analyser but that thing produces so many
> false positives that it is intense labor to review some of the
> nonsense it spews - so it may have caught it and we missed it.

Hi Jamal,

My eyes are not so good these days, so I use tooling.

In this case it is caught by a W=1 build using both gcc-12 and clang-16,
and by Smatch. I would also recommend running Sparse, Coccinelle,
and the xmastree check from Edward Cree [1].

[1] https://github.com/ecree-solarflare/xmastree

FWIIW, I only reviewed the first 12 patches of this series.
If you could run the above mentioned tools over the remaining patches you
may find some more things of interest.

