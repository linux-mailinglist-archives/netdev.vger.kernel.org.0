Return-Path: <netdev+bounces-7987-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8C047225EA
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:33:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B81928120E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A946A6ABA;
	Mon,  5 Jun 2023 12:32:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AFC20FA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:32:58 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2122.outbound.protection.outlook.com [40.107.93.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38137E54;
	Mon,  5 Jun 2023 05:32:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Au9wAX5I+m7OsgPEQ0e+H2q4cZhXb7jI0/c7Q6a0CvFL5wT3DnvcGp5Dd3r+fEPBa8XxWN+/mXHARpsYyzvU298uq/leqi4o70KYwLH8nA9P0tIqCT6QczMpVkV0PDt1qSNCE9iZJ50OykUjOUyoKxZkBfyBxMaADYD1+pD5UidR3sgLkdENJ1L1vEdDDouQCwrrnsutUXZXg2Ew+JaQUtpixHJrlEEmYUV6OrTZPwBkYySmoGXK0OVJ/QievQXaJeJ5Gx0rS7aRl2x14TplKqs0Wb2r78OT+oSmfvhWWiApZCaDXmCJBNBSgAthKAR/yLO/Es62//mFDnwzF8Qvlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3rJmQT2uF6sKRJDtWw461Yw1/3fF+neaCR9O/RzZ8s=;
 b=dzGCMO7mEO0bo2ipeTh0+fPbR8mYc2zASKDWUBpkTEbWHKy60FeJZ6LedRY6g8TY3uB0EUnhEkCKDL6yF6hrUN3Cz1RsG3G759Hj1OE3x4pu7b19CHE0lEHlzTngIC9EkqLIaRJdQOWgDay+b4tMVZIrEKbc4/8jG2kxT4DSW6GlBNABi1Hd/5EvI5OqJ2r5XV8gc58xb9WKEs4v21vEiar7AK9JrdJFWZ6P8with7/ZfCD8SnAyJVN/9iPe58FiZmM4eFRPKT8oXB46Oiyd4DDx2QB/d+IJwufRrhzPGsCkY4xnV+e5sK+WW08KUMKPCXPmP1eHXr1LQhCq5SuaAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3rJmQT2uF6sKRJDtWw461Yw1/3fF+neaCR9O/RzZ8s=;
 b=cGRcRMKaSmtMlSTBYKEU1vyI+YwudtYctt7VQa6cOVPFO/jnVXY7/AjVAGy+OqUupJPL3eT3nVqADR7UjZn3I1Yv6qac7xzP9gcqZyZ3F4f1sLkvCV3KmhwDq+zGWl3kZhGlK+fNGuyzlw8fZ15drR35B0wsKEYYpVKwvUig9QY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4994.namprd13.prod.outlook.com (2603:10b6:a03:357::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 12:31:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 12:31:17 +0000
Date: Mon, 5 Jun 2023 14:31:10 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Hangyu Hua <hbh25y@gmail.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: sched: fix possible refcount leak in
 tc_chain_tmplt_add()
Message-ID: <ZH3Vju3D3KCKAkCO@corigine.com>
References: <20230605070158.48403-1-hbh25y@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605070158.48403-1-hbh25y@gmail.com>
X-ClientProxiedBy: AM3PR03CA0058.eurprd03.prod.outlook.com
 (2603:10a6:207:5::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4994:EE_
X-MS-Office365-Filtering-Correlation-Id: 6935f668-0e19-4874-84e3-08db65c0c230
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	C4lGDlYppWH2pN19/RtwlVfLpgYce3bnHVOX4Uoi4322rdaSqjldzw9KydgfREU9zsVKkjL6n4oufsGW0r+ZPDKAJUXvJiF6kaILqEK34VtRODvOhj97kVJfvliUbqpwWoIfTX70tlqDoI9c9O2HlkQslyxRk2DY1viSc1qkOoVPRca1xqKtXdNLGExKwgXbPb7YzenNo+O00cKBxU2k9o8QkoEmqKkHd+NtrMDa9E74rvkSdB7c8pH63gWxbhKsmZxoidtozw5q+FFbbnb+QtmX80RSH+xKRK/Mha/mpLWg8HVPNJkmYF854Oosa4SDk9aZ5HEfy0rJ7EBKWfAFInbImK8r5MW7Ip2VXADXrsrVy88YcRCxb8yK8u3goDnC7lEEnOZhsYyTIaKbF++dPfW5bz2xCnO2POH5pTggWDuH/wR0jXw8v2u2wghIhZQxWfHCgVoTtQejyquc31zV6oxcOi9WU4mgYEdairTBNTHIPM8oyfXIefq4nzag/2NFXbpZnGUrd5OUuYSgaRVYA9Jky/YB8jT3t8r8O7AJZciyB1GQilUcNwwbMW+Wo+fj
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39840400004)(396003)(376002)(346002)(451199021)(6512007)(6506007)(36756003)(86362001)(38100700002)(186003)(2616005)(41300700001)(44832011)(2906002)(478600001)(66946007)(66476007)(6916009)(4326008)(8936002)(8676002)(316002)(66556008)(5660300002)(7416002)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ftx7E8j6wPNRXQubYYf2d0ZrYRGfE0vwQnsuXV7bI5sLxOh9k8xUdKt8p+Jc?=
 =?us-ascii?Q?sNzHb5mJFPRGG/wKF0qmvq3duGf/0/s4T05lw+ihsMp0cnSoMeXXzyy52z7F?=
 =?us-ascii?Q?k2JpwkZx6m7QVyT0EIJWnxnEdWfJ5U4HgbEXY7/8h+FrP+WaUL364holPCFS?=
 =?us-ascii?Q?Ob4/1NnlvwE8EsF8YIfSnajakpP3QUk28LHzE1QGMo8ewgx/XPStSFkIetk6?=
 =?us-ascii?Q?V2IHgLWsPSlwFCdlpDUNgbVauaGy+9iK/AWMCfTDfJPaW2kJta4ZY6cM3aek?=
 =?us-ascii?Q?7QncwGlKP2jnw31MYUBesDlFPwmRR7tI/uS0jY3QrxwhaVnIGD3ahgCyLcH3?=
 =?us-ascii?Q?mDhUcmSYhRsRd81LwrcrE09dTVuxb1zUVZo1dH324vq9FUf4NNzfYpn9oVz0?=
 =?us-ascii?Q?0TP4jaQvFmPfEdqDhsqu4+an5xSfnqShSU1RPBJX52NZPeQz7g/q7A3WzGlO?=
 =?us-ascii?Q?6tj6xgF4YothDPAGiiS+JuHnptUqibcAOmHdnOgiIKGgF3AatQ1FeJrNg2NO?=
 =?us-ascii?Q?W2DPj3+CkRnId4S9e+mm8ZnGV7lJ8EtOvhofuv7rYXppB7Fs/Ad44NZIvqj6?=
 =?us-ascii?Q?O6xh52hNcw+FqYvawLFV5oBZbP/d2fKo3nxyZv0wkc+XVPvTOp0A+7cQ9f8y?=
 =?us-ascii?Q?qi4TXnmEm+6gmGZ8uHk5D3z1TcuuB2KvZLgQnGXV+vMim82e5nBEgklccLJA?=
 =?us-ascii?Q?wZDA+Dk9TImOFuTCVqIDNv6Z6hf5LlA69YjeVj2x579LyeBdXx/0nU6spwoQ?=
 =?us-ascii?Q?nKwMbvpN5G8T2RdHO6Ggn+k86xLvv7Xb4HKlksBJ7eBTtalfiyOUreGShN74?=
 =?us-ascii?Q?8G/RakAze4965Lm5EQ7XtjSuwZGqIlYW5nH8zwRx/m7nsZW4P9huzkehCvXN?=
 =?us-ascii?Q?5ngh8wY1ZaKAZnAf+0Br0zBr6i3GYje/SHh3Xb35IXFeKOYWPl+H6e4BrjlG?=
 =?us-ascii?Q?S1uvj39PsN0lHGgPnABtdc1Y1JNHuVgsbYfpcMuxhl7RQ2WYfG+efU1gyIMz?=
 =?us-ascii?Q?342ge+beusTJsiLEQkutptbyKi5EiM1Kj25qmnXWE+kIxJS4+pMQXRYwmz98?=
 =?us-ascii?Q?Z6FDaXrZX25yBcm2Vn1gG9BsN0d5LJ/94F6A1WXgtEjJevnwgApK4gbDHB55?=
 =?us-ascii?Q?k6BauE2meZBwrqf/R3jtLkhTPOPxCFmLh8IoJIiTkYEgplT0loenjMC88Fne?=
 =?us-ascii?Q?Vp39ETHOk/Tde1wUTy18Zo3ne/DvPXlymfVEbnUo8saXw9vmZNQIbBafGsjx?=
 =?us-ascii?Q?OmOGHeKIpIDIg9shb/DROO7YVfz5BM/FM89yv764RHe2Uhfz+u5jdeSKRVWf?=
 =?us-ascii?Q?TphZd4XELNjqMiMCRhMgLoA6qq1b3dKDkvHDX7fp4L0GWS7WMOUKm9r8GIBu?=
 =?us-ascii?Q?0PWq+XUqia1UmUwm0j7kGeUB1rUReLhDK6nlym3zmIXyb3z/KVpw8uDwZBRs?=
 =?us-ascii?Q?5nscUS1hXQ36REniv3AmmJ3mPjI2juMpODeaNdNpZR3ONLQcbBxT3ii7+cYa?=
 =?us-ascii?Q?5GnTPSTb1uGo8vDqByDP90sAWfCn9ZipriZ0ls91YeRTbG4hwtB6hUrGdQr2?=
 =?us-ascii?Q?tsyHF14li5fL+F766CHqsTVVd8npeJB66VxZW/2lV+5B9SuT1pIZxzq3y/7N?=
 =?us-ascii?Q?8dVmy1Jy+sSsaRkShFgqs4l/jWdYpk9a9irbagRZTT9v/zLXgAxsy6+30Lje?=
 =?us-ascii?Q?N0WfdA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6935f668-0e19-4874-84e3-08db65c0c230
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 12:31:17.1282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A7Ukbg8pV9xGlP0Rpo3rVvzBMj1y/Op2HLYMKyxpmGU0Ntsw9e9H8mEHNTMiJDDFL8KFp/gdKnjBWO7qjf9W9UZmIU5LF29dElzQqc04RkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4994
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 03:01:58PM +0800, Hangyu Hua wrote:
> try_module_get can be called in tcf_proto_lookup_ops. So if ops don't
> implement the corresponding function we should call module_put to drop
> the refcount.

Hi Hangyu Hua,

Is this correct even if try_module_get() is
not called via tcf_proto_lookup_ops() ?

> Fixes: 9f407f1768d3 ("net: sched: introduce chain templates")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  net/sched/cls_api.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 2621550bfddc..92bfb892e638 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -2952,6 +2952,7 @@ static int tc_chain_tmplt_add(struct tcf_chain *chain, struct net *net,
>  		return PTR_ERR(ops);
>  	if (!ops->tmplt_create || !ops->tmplt_destroy || !ops->tmplt_dump) {
>  		NL_SET_ERR_MSG(extack, "Chain templates are not supported with specified classifier");
> +		module_put(ops->owner);
>  		return -EOPNOTSUPP;
>  	}
>  
> -- 
> 2.34.1
> 
> 

