Return-Path: <netdev+bounces-9162-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBBB0727A71
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:51:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A338D28163F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 08:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 071A48F77;
	Thu,  8 Jun 2023 08:51:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A801FBB
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 08:51:07 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2108.outbound.protection.outlook.com [40.107.243.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9B230CD
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 01:51:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BnwuP+CMbgaz9YHlnHYG05EFpkqSZC/4zBEV7jCLSgjwndX7E5Ofc9kgXArBGT7bO3unicHqPb9TJVKEOGhYwCNt2L6FdkpSB/dD9B7rOK+1RiEFfEleOcChooB9pRJgpFuUAvHs456d0f+KeA1u4id0jI1Kxo+OfOvrchPIlgG3qGgrea54Qg1jaL4DUd0NTOx61z1oafLzqAI6aWwgIZ0AqW/j3p8+eSEsWGqs2I6ZQLmQ4BV0bSaBuyaaap4ouwjnvmcP1riSC/LD2IaDvfEbj62DZ9iAj/cESs4Qh1qBglA5kkQONiKOEw8nT3PmvK/PAk7FKfSKhqmNcUQQHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=coplc7E4lYZo4jEP49YPX5+cIy77ApY4B1+UsoXmGIE=;
 b=O2zPd5uD9WkLz14azh1Kczx7/L6bsoFR7tUZ265aErMT7z4nqIsWnPPCKPaCaaXDydKTvQcX5ME2wFMenGSCrGbSMrP8N58Ym9WLBKvgJGDKU97oOBSE3kDgpe9mnym5UfzmGBh5I2clVNc4y/g64Nq7HyciLdYO+S5gMjkd4TVdrSWzndG7+542R8WowHbenzWw6S2VbEEdWg2dDbSmlW8VlWITx1Yp3QkXU1rUwJbV3CsQQ+haga6MA3buctOq5e0xnnljMPNI3NuNrGv5Sm/4iW8lpPzkgnTPFngOgSrRMYRkuxYNDd/Fdw8Owsv60cEqwMgobHXnCYVmdTsIzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=coplc7E4lYZo4jEP49YPX5+cIy77ApY4B1+UsoXmGIE=;
 b=NCcLtGag+/9fvjO9rQFa/yzoMYd9BiobtocP+gF/LW3j7gemTsjnrZY098pCXJr4JXRs9BjfSvikvcdhKMockL9sxPa15P14rfGy4w87BzLFHC2rHmWvQJAGP/6f93KnS4iAL6TwwaPsMrw+BxmfQwcGah+6j9y5HP7CmEMDEkU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3750.namprd13.prod.outlook.com (2603:10b6:610:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 08:51:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 08:51:02 +0000
Date: Thu, 8 Jun 2023 10:50:56 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eelco Chaudron <echaudro@redhat.com>
Cc: wangchuanlei <wangchuanlei@inspur.com>, aconole@redhat.com,
	dev@openvswitch.org, netdev@vger.kernel.org, wangpeihui@inspur.com,
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Subject: Re: [ovs-dev] [PATCH net v2] net: openvswitch: fix upcall counter
 access before allocation
Message-ID: <ZIGWcLy8ivB6IeGK@corigine.com>
References: <20230607010529.1085986-1-wangchuanlei@inspur.com>
 <0E3E5A3D-E1C5-4C27-BEEB-432891F996F4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0E3E5A3D-E1C5-4C27-BEEB-432891F996F4@redhat.com>
X-ClientProxiedBy: AS4P195CA0038.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3750:EE_
X-MS-Office365-Filtering-Correlation-Id: 62b558e9-22e9-486f-246e-08db67fd7d0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MljbJjZBplTCdbBgNP/uu7GXr1JaxGRiCLe5iL+isKlVBxBCkWcfsLnZRKZgSNqi8ULYnujJsdWvh7jRwpkR5mr0dIk2MrFv18zozd0pOMLsEEQ082zhkhxSiWyrAcpKC8wotnU/pWAk0N5yDDVjBvlHPukxJWGBQUmmzmIiewLDBusVLQvkXCfaWfpiipCOJVA0Ubrb+88fcIib2x2oAplt4+SZG+PaQWs9fDoyuy1XJoj91POWWaneJDsDuwvYgYrqxozkpho35DEzDke2W+S0U9VRGDpn4snv0yMUXQP372oyLSPr7cZ3fDZkVb5vh0eDnfTdmLt+AcTffO0b/ro5Or70vxTod5iRCX79A/Ioyd7YCK3UYDK2fQLcjaPPMcIRwsBKVQ8YRClM79RNBwcVA+K/r3omr83IZ3df7veSLqeZhl8paOhB0jtDuuHf+XNi24bDmmLNB8IZZX32qHdEKiM4vdabPNSHJRge2GgqrbDOLZUOtHu+g0PWl0ANOmeWBUoJQLzWbHOesmxwXfDxyNxkK7iRZ1Wep7EwwiQnetw934liZtKK4sgLkiTn
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(376002)(346002)(136003)(396003)(451199021)(6512007)(2616005)(6506007)(38100700002)(41300700001)(6486002)(6666004)(186003)(83380400001)(478600001)(66476007)(4326008)(316002)(66946007)(8676002)(66556008)(6916009)(8936002)(44832011)(2906002)(5660300002)(86362001)(4744005)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UGRZMnFnYTl5L0NudjNmaDNFQ3NIWHUxNzBVYVNMYzR6ZTJOWHYxd3VoM0tE?=
 =?utf-8?B?M3lUZkdta2RHc2ZZNlFkRmp2VUMzS2NORm16Z3JIcGJ2cDJXaStYYlNONXgy?=
 =?utf-8?B?aEkrNVpGeHREbnhadUhEZkRDZG9QaThUbmFlc0JNb2dwVzV0dUl2T00xb2l6?=
 =?utf-8?B?SDk4SmtqTitxNzdNbGVkOVRZQXhZWjRpWjQzMlpwTmkzZFRrdHhEaXZZVGMy?=
 =?utf-8?B?eHVpcnplaVJoRTJPNTF4MGFObThBY3J5c1FCR1RLVUxNTisxeWdDb1RGNEtl?=
 =?utf-8?B?TDU1SDEzV0xUa3Y2dGpWYWZDbTRkWlR0U2ZYaGtmck1wUStLendKUEt4MGRi?=
 =?utf-8?B?L1A0RDZKSERDeWNDRWhmb3Jqa08rWTNxbVFiaFJPeFEzLzUrK29DSnY0M2tm?=
 =?utf-8?B?SWNTRDdrVFUzTGw4bTNJQWR3MkliY0IyV0hqRStNM3VvRHQzcFJ5SHZPQlRQ?=
 =?utf-8?B?NlVQT2VPN2ZidS94K1M3SSthdTNiMS90c3d5aHgyWmhRSUhwS1ZxeG1zMHBr?=
 =?utf-8?B?dTZQVXBLRm9DU3dEeWlsMnhJTi8yTlFFT3djaFE0aGlGckF1aDA3MXhGZFVE?=
 =?utf-8?B?bzNQS3ZIREdDOU84clFhNlhMY1UyRFlrc2lkc1NnNEQzandFNktJN2ViM2hF?=
 =?utf-8?B?aTFtM2ZqRHF6aklzTERYSlBKTit3bmdySHppc3h4dkJTS0ZBZEkzRGNZejlF?=
 =?utf-8?B?UXY3L2dkS3BPL1Vyd3J5WjBRK2VQTVBRdVVSZzZJaHFxaGNMaXVJSVNic01R?=
 =?utf-8?B?ZDVSaTZTZ28zZzVQMU13K25DMFkva0F3Ritvekl4WWpzc2JGS1lTVnFEUktz?=
 =?utf-8?B?SzZHR3dmckNCeWlWU0NRZ0J6aGNINUQ3ejhQVEZ0clJiWnBmTmUrOFlwZjlB?=
 =?utf-8?B?U1M4OWV0L1ppM2FaUFpSeHhDMHF4SGhOdVlnNFVUUDJqSmRISjhVd0xLU09J?=
 =?utf-8?B?SXJTeForVnl6UWVOeHFTRkZjSXZIOUh3R1FzVHgrK2xJSXlRUFY4Y0N0UGZT?=
 =?utf-8?B?WWFkODF1WXlZNlB5Ri9scERVcnJ5RlpuVjlkalVwSVprdmNjL0hZazhJRmEz?=
 =?utf-8?B?WHAyUGFEeHNCbUpPQlRETzJVcHExN3J3bHJ3VlI0Y0FKcEpqM2xTL1lzUTZp?=
 =?utf-8?B?SjFSOEloRXRlN3ZFK3hYZWNtcG83QVVRaHdGT09OZzFjbGVRaG5XMjNMUnd1?=
 =?utf-8?B?K0ZDc0RkMDVCNHFSSXp4a3k2Ymd5cFpVSXk1ZEFrd1BUS2tkbjErK2c0OElU?=
 =?utf-8?B?YTgzSHd1R0ZXRnZlc3kvaWhmbzhaQkxaVUhkN2xReGVVeGZCMW03Vmh4Zi94?=
 =?utf-8?B?RGh0eWhDZHRGOGVZdmVwNE9tQ00zMm9WMHRYWHlMUkpraURPY2tFQm1vdDJY?=
 =?utf-8?B?c0Fhb0xhMVdTQXlsL05CRkFYV2g3NlIyU0llQzBwTXNOM3dHSFNEWEdleWRs?=
 =?utf-8?B?ckNwTm03c2xjSW5QKzA4UXZFbHV2Z3RDVlYxNFRFTTZNbEY3SEhDYXovU3p6?=
 =?utf-8?B?WGR0bjZKRk5RLzhsWjh2aTVvQjBURFZYQlZTU0ZEMFd1dlZEN0FoMHJLRmw4?=
 =?utf-8?B?VkRPNUhOanhocy81Vkp0MDhXM2VTVitJNGlhRXFSWlJBMFhFeDdBVklFMXV0?=
 =?utf-8?B?OWFvUUNoc2EwdUpQWkw3WDBUb0o5cWFZSmJVSXdwNXdtQ2t5dWZMMXBwczN2?=
 =?utf-8?B?LzFoQVBpRW4yNTJvUkkwU3BNeVJKb2UrektWSVBodC81WStlK3FiVmRIMEJM?=
 =?utf-8?B?cC9iVWoyWXFwUmp3SmxMREFxR1R1aEVCd2FkM2haZWNyWlI5R3E3L0dMRGt4?=
 =?utf-8?B?VjFPcUpmYnVvN0xwblVncmVmeVhsMy93L2ZDMFc2bmo3enE1aHF2ZWh5QW9w?=
 =?utf-8?B?aVE3aFl3Z1NFSk85NlMxZm5laC9sK29aTnNMc0swbzhyYzczM2l6QnlZMFVs?=
 =?utf-8?B?bzg5aTB2WGorcW8wblRzaHFGK1lTZ0hIcTUyWEQwU0tuRlNuRXhjV3N0amxs?=
 =?utf-8?B?TXRxWXVEQzRZL2E0WEdrTXRLaEZkck9yQ2dqdnV6WnRNUnpWeFp4bHZyRzNY?=
 =?utf-8?B?UC9FTWErTVZZVnBVd0lGYS9DbHNxdjJDenArN3YyK3B0a2FXUVI1UGtDby9H?=
 =?utf-8?B?Qy9jYlhQZU9qZnU5RnRNVGxackNLNnZ3UEtOT0tBR252ZDVMYTJNVURtQW9t?=
 =?utf-8?B?a1FoemlVZ2JmK3BQSjFIbVh1U0hUVWozZkN3a1VweUxrUTNjc015Q1VSWW5D?=
 =?utf-8?B?Wnhsb2FNWHJiVzE2YStrNllZQUlnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b558e9-22e9-486f-246e-08db67fd7d0a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 08:51:02.6984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: svy9ecH/h5p2Zi95iYtpCZDn8oRC/mSWTnR2etRtfqZWPGqU1RoRLyv4svPVkqiTD9KYoJ7hF1ntUvT7nh+HxecsQosDTfKPeoKpGhbJztI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3750
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 11:09:58AM +0200, Eelco Chaudron wrote:

...

> >> We moved the per cpu upcall counter allocation to the existing vport
> >> alloc and free functions to solve this.
> >>
> >> Fixes: 95637d91fefd ("net: openvswitch: release vport resources on
> >> failure")
> >> Fixes: 1933ea365aa7 ("net: openvswitch: Add support to count upcall
> >> packets")
> >> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> >> ---
> >
> > Acked-by: Aaron Conole <aconole@redhat.com>
> 
> Were you intentionally ACKing this on Aaron’s behalf? Or just a cut/paste error ;)

I was wondering that too.
But then I concluded it was an artifact of top-posting or some
other behaviour of the mail client.

