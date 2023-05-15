Return-Path: <netdev+bounces-2765-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B3B41703E14
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 22:04:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98B321C20BCC
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 20:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7506D19534;
	Mon, 15 May 2023 20:04:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65935D2E4
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:04:33 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2126.outbound.protection.outlook.com [40.107.220.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E2FE707
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:04:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WtHBiQ7ijK8xnW9xMsJ1wHtBZQi1C2b7q2D6/QCmmCShbOZRogpiWtjFvrXgYDSltuolfPyAVg4jgvPbYgHV36CbgxqSJZb0DyrPhTTlmRoOwXSwImw25y0IOXAFkt5d1TP+NmGdpVVOjJ6uyzBn3FxYv9jycEFqbz2qzL/MP88fhJn6lrtYVz4p4zu4kisdDi6OdcsMHtHOndOM1bjP1KlH89RYRKiE78rgNDy5iSjvSo5VFBbv/6R+D/tZTv6OlBA8Xwz0Jdvk8jvhnnT7qIQ7u1BP+X6Dr3YSMT2j8d8XFYjd7FsmRKF7T80c3W1ffA3SkJ/vFEW1m2Ar6B755g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dPWLMoNBC2pjIOfZ2qqPZcje4Wx+wEYvvS5yD+gtPg4=;
 b=ob2vaTELNutfe7zuyxrQlAE7YsngrKdrlvA3Ss5SKD9cl2RFyBd0H+yQ/eEvVBP2jwmpmaPv8p18u7k1yYSBWYv6ZSj2Uft8aWeoMz9ckh4E3ibouVlN8/tLAY/Bd0ypwYMMUE2UoSNY33VFtc9108i0dqQMTfKHyrD+3QKJw4RtyIPoziqnunzhANUi1IN3VTr9J+LCsY8V38eAGlHfX9MzT9dImdXBHRCX5YeoVJleplokdXondgXTyvRSti2d712YpGaNVZvP/zDG5+mK06fK39lj7LAt4JnYaVOIgN5tj4xPLm9gpuNr2AsfczztZqr7gNUuW1gb5SfkV2yRJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPWLMoNBC2pjIOfZ2qqPZcje4Wx+wEYvvS5yD+gtPg4=;
 b=ni9zloh7NS/cOCChxp/Co91piz7bTghm4de2G8oycwkJcY4LjT8fCtWh58aszUPSGLfN+E8HLTyweiUFvYzzbGw6KHwV3GCHVRth1E2nNO5OoK2xu7ft7bH1ezipijPbKIntU+3RdQqqCVT8PEDKeBzE7vlpKGpeoFH0pmwgpmc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6479.namprd13.prod.outlook.com (2603:10b6:408:194::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.13; Mon, 15 May
 2023 20:04:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 20:04:29 +0000
Date: Mon, 15 May 2023 22:04:19 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Hao Lan <lanhao@huawei.com>
Cc: netdev@vger.kernel.org, yisen.zhuang@huawei.com, salil.mehta@huawei.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, richardcochran@gmail.com,
	wangpeiyang1@huawei.com, shenjian15@huawei.com,
	chenhao418@huawei.com, wangjie125@huawei.com, yuanjilin@cdjrlc.com,
	cai.huoqing@linux.dev, xiujianfeng@huawei.com
Subject: Re: [PATCH net-next 1/4] net: hns3: refine the tcam key convert
 handle
Message-ID: <ZGKQQ9j9XbVzMMnI@corigine.com>
References: <20230515134643.48314-1-lanhao@huawei.com>
 <20230515134643.48314-2-lanhao@huawei.com>
 <ZGJU55jrzqZYlWPH@corigine.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZGJU55jrzqZYlWPH@corigine.com>
X-ClientProxiedBy: AM0P190CA0020.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: b4068a22-1b92-4988-0755-08db557f972c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jXfFf+aoXOiaerDkhF6yWok2R580A/HTFB0zqsLjv/Z+nc5YkSwahzO49BNIhoOBUZ4cEMYDnPekkAO0uMWVuleNAPqUaOqZ58kzwK3j8jcVY2rDWgi2e4FNXqVk33EvhvSihlxRGE+TcKu4U5/1RePieRRSjXaIAjTBWYXh1J4oWv41hnJJ9f6YugSm/Yr3LBKL0cmymFhyTs0LyfpqgmE/S+s93rG468vUDO/6T47QNWLUGC/E1NdJq0lpU4J3dh/rb4vUgGU/U4sREAyt/6OFLKfv+hm4MD0v+QdpZLi8t0ApYlU/6K8jKx6R8R0PhLC0Hub2hOWaQ4XrZplneyzO2hr/HN2XV5Y14gQoVY0HbQhG6iTCEAZgP3GViQmzRQHiEjnCCFuehQMPMet3wOK0e2YHx6Vx+qrKV4cWdQq2Viv/Z7GMr2YjW23Gjl1Gxcz4SGJE3tUls5xViheTcZZPxk0A59cDg1Imz2/TxeTZQVSu/cXcmkoK9Pt66WFPIysZf8HuU47KkG1K7yGLGyjVYsm6+YZ+fLvAAhLXNH0M/6CrU9Sygmflvhb3Ox7s
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39840400004)(136003)(396003)(366004)(451199021)(316002)(6916009)(2906002)(66946007)(8676002)(5660300002)(44832011)(7416002)(8936002)(66556008)(66476007)(4326008)(41300700001)(6666004)(86362001)(2616005)(478600001)(6486002)(36756003)(6512007)(186003)(6506007)(83380400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dm9yd3FzZVFWOEx2RHh4RWluM0ZPdDBldlhka0FVUkhFUnYwOGRza1gwZU13?=
 =?utf-8?B?aWE2bUl5bHptVVhHeDJWWk8xdlNUZ09LTUZjalBMYUNoelNwT1J6Zm9pckVp?=
 =?utf-8?B?OVl0cW9IdVRwb3lvS1hVNnNnMzYrTDhWUGM5Mk9iZzZCUDNRYWhQb0JjUlB6?=
 =?utf-8?B?aE9HMnQzY2x0aGUyT3d2alhRTnh5RWNHZytxeWlYUDk1L0FLRGpGMmJLemZX?=
 =?utf-8?B?SDh5RUxISjVkU0hKdHNWR1YrTUVzckNBVXhSam9LRXZuNDNaSlNOYlpMNWRi?=
 =?utf-8?B?M0RSOXRHUEMzWVR1QXY1NFM4N2paOXp4Q3k0NlcxUnd0d01UREdzMDhiKzBp?=
 =?utf-8?B?R3ZUT3lnamVKb09PTmRZdTZBdXFkRzRCczI5MGRTQnRoeVNyeUIxUk1TSTBI?=
 =?utf-8?B?MHdOVEpSMzhKR212SEtzS2lwQmpUYmVhTEV5QURBQ2x0bllhNncrQUVFdXdn?=
 =?utf-8?B?VzVQTGwrYXQ0eEFLUVR1dnVGVWkzL0pBZDZXNlBoTVpyK3BBajZuMEs1UWFB?=
 =?utf-8?B?dGFXNjJCaWljeTFUWC9VSkxaelE0Zms4NEpaZXd6ZXovSkVOZWsvemFDQWdL?=
 =?utf-8?B?YitUcno1c09lUEZ1c3MrQVdjeHkvOVZIRjJYdjI4Zkl4V3NnNWE1TnF1UzJk?=
 =?utf-8?B?L3NkRno5Y1FoV0o4WkI4ZWVPR0p0VkFEenIrQ2dTaXRTTVRUK3JZYmlpczY5?=
 =?utf-8?B?MmMyVHBnZUtFNElLOW9CRzZEYU1iL05vN0tabFY1ZWwwOGJVNHBuT2xzaVNo?=
 =?utf-8?B?cXcwd3lqUkhkQjBpQVVtKy84SkxMdHJFY05VOHNaUll5R0FWNHlIZHJEeUZI?=
 =?utf-8?B?WmlKSnhwL2JwZjJXa3hONFA1MTU3YmV5eVhYejdnU01YSHArOUh3ekVEbnRi?=
 =?utf-8?B?TnAzQkdWVHFTMThmVkpaOHRqak1jeHRkVnZTVTZkWE9wb3pqa1l3ZXZjZnIv?=
 =?utf-8?B?SEM4V1BQdVVXanMyMFQ2RUdqQnk4Y040Y2hFcFdqVHpGZHJBbVN1aURoTm1H?=
 =?utf-8?B?dEFWbnVYV1h1WmZ3M2l4cFBtUU01LzViRmZNWUZDM0Nqem5OOEVrVkV1enR1?=
 =?utf-8?B?RWt1TE1FTDY4VjFmRjh6MFltMCsrbm5FeWNFVjBncExZalMvMmp2QzIzN1VU?=
 =?utf-8?B?WUFMa2liNmwxRThmVjVqZXlBYVlDamhCVFBnUllUN0M5OEVaME5VSnNWdHZB?=
 =?utf-8?B?VVFTWHRJV0E3YktscVRqWlhERlM2ZjFocE1WZ0c3YmpMZXNsUW4ycWY0MU5G?=
 =?utf-8?B?dmZzaVR6UFBuNTZkRksxdzA0Y1dySFprNzZTV3lFbGNmTXRTck8yazNHcnNp?=
 =?utf-8?B?ZGdFKzNEdjl5cEo0M3pjNHdSRDFMRU1ROGxoTFBCUi9ncnRWQ1hMNmFWemdR?=
 =?utf-8?B?WXRqMU1mTklaNkV1ZUNrbWRHQldrNDhIZFJnb3BLMVRVZkVyU2lXSXFRdEZ4?=
 =?utf-8?B?V1dNODZja3hITlhMN3FmTG1PbjVXQlJrWlNITXkvT2FwWXFDWTNacURwNlZP?=
 =?utf-8?B?OGFLNGc3Q1p5Q2MwT2w5bFJqZFMwYVF3cThKeWRrOEkwZm8ycmZhSDVCSXI4?=
 =?utf-8?B?S1RMUW1xRXFDMXFhaEtvNFl4MVdTZGpaQnIySTJady9LMzh4UkVHUVdLMG9C?=
 =?utf-8?B?empTS3dhVFVTaGlZTCtKRU9vdVAyVmlONXBpUENJSE05VllrVGxneHNNVzRq?=
 =?utf-8?B?aHRHZU4yWUo0djZDRGVQWkF0N1NjSnMzcTNvakpEakpVSjRiRGVFaW9UWUNi?=
 =?utf-8?B?Z2hocWtaR0ZlWnpqcGVzOUhKb0dRWmFFVUxZTDJFK0lteExQMGZuVGhmNy9L?=
 =?utf-8?B?WEVlZ0R3UkFKM3RocytDVXFWQktZeWFoeHJDRGlpdmlDdnlVRitUbFI5Qmoy?=
 =?utf-8?B?aXpHMHdEM0JDUEs1dE9XbkFSaE5pNWlWbjZkU2daSisyaXNKMU13dUYvQXp5?=
 =?utf-8?B?dUY1S1RHRXJNc2M5TEswSlN0cEJaVnpmSTZrMzdqUWZ0QmpYaU1lbkpDK25Z?=
 =?utf-8?B?dFZqSnpuNm13ZTduMUIwMGoyQ2loTlY1ZUpmSE1VZjN5TEhmb056eG5wRFZE?=
 =?utf-8?B?SDNxVVZwaHA2WjVoVHhZc1Z4YnVVam44eWlucURpT1VpRTUyRnVwTGUrNkZK?=
 =?utf-8?B?Mm5qcU4zdnFrMTVhSXY2V2xzRmRuSHdPblF3Q2pqcHBicVNzdDBwaU5Ic0ZX?=
 =?utf-8?B?SXlJTXVuT0dqZlNFYU9WelN0TzZxUVRnMnZmUEFuMm53ZnR2MHNxSmtSSlkv?=
 =?utf-8?B?VUZhLzcxSVJYeHRKbHRwa3hxNkJRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4068a22-1b92-4988-0755-08db557f972c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 20:04:29.1568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ce29KHVmcQOO6vNCEpqlLDjTcyBuuAq24DjlatFbhzhyK4SrRxkiDHcax41Lbkv+W112rmanXW0cYTW8NsGk+FHuSmtfMSWmoicK4IWCAlA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6479
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 05:51:03PM +0200, Simon Horman wrote:
> On Mon, May 15, 2023 at 09:46:40PM +0800, Hao Lan wrote:
> > From: Jian Shen <shenjian15@huawei.com>
> > 
> > The expression '(k ^ ~v)' is exaclty '(k & v)', and

Sorry, one more thing: s/exaclty/exactly/
Also one more time below.

> 
> This part doesn't seem correct to me.
> 
> Suppose both k and v are 0.
> For simplicity, consider only one bit.
> 
> Then: (k ^ ~v) == (0 ^ ~0) == (0 ^ 1) = 1
> But   (k & v)  == (0 & 0)  == 0
> 
> > '(k & v) & k' is exaclty 'k & v'. So simplify the
> > expression for tcam key convert.
> 
> This I follow.
> 
> > (k ^ ~v) & k ==  (k & v) & k ==  k & k & v == k & v
> 
> Looking at the truth table (in non table form), this seems correct.
> 
> k == 0, v == 0:
> 
>   (k ^ ~v) & k == (0 ^ ~0) & 0 == (0 ^ 1) & 0 == 1 & 0 == 0
>   k & v == 0 & 0 == 0
>   Good!
> 
> k == 0, v == 1:
> 
>   (k ^ ~v) & k == (0 ^ ~1) & 0 == (0 ^ 0) & 0 == 1 & 0 == 0
>   k & v == 0 & 1 == 0
>   Good!
> 
> k == 1, v == 0:
> 
>   (k ^ ~v) & k == (1 ^ ~0) & 1 == (1 ^ 1) & 1 == 0 & 1 == 0
>   k & v == 1 & 0 == 0
>   Good!
> 
> k == 1, v == 1:
> 
>   (k ^ ~v) & k == (1 ^ ~1) & 1 == (1 ^ 0) & 1 == 1 & 1 == 1
>   k & v == 1 & 1 == 1
>   Good!
> 
> > 
> > It also add necessary brackets for them.
> > 
> > Signed-off-by: Jian Shen <shenjian15@huawei.com>
> > Signed-off-by: Hao Lan <lanhao@huawei.com>
> > ---
> >  .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h   | 11 +++--------
> >  1 file changed, 3 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> > index 81aa6b0facf5..6a43d1515585 100644
> > --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> > +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> > @@ -835,15 +835,10 @@ struct hclge_vf_vlan_cfg {
> >   * Then for input key(k) and mask(v), we can calculate the value by
> >   * the formulae:
> >   *	x = (~k) & v
> > - *	y = (k ^ ~v) & k
> > + *	y = k & v
> >   */
> > -#define calc_x(x, k, v) (x = ~(k) & (v))
> > -#define calc_y(y, k, v) \
> > -	do { \
> > -		const typeof(k) _k_ = (k); \
> > -		const typeof(v) _v_ = (v); \
> > -		(y) = (_k_ ^ ~_v_) & (_k_); \
> > -	} while (0)
> > +#define calc_x(x, k, v) ((x) = ~(k) & (v))
> > +#define calc_y(y, k, v) ((y) = (k) & (v))
> 
> This also looks good to me.
> 
> >  
> >  #define HCLGE_MAC_STATS_FIELD_OFF(f) (offsetof(struct hclge_mac_stats, f))
> >  #define HCLGE_STATS_READ(p, offset) (*(u64 *)((u8 *)(p) + (offset)))
> 

