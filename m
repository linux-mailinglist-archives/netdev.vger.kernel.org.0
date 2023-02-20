Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE23E69D0A0
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 16:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjBTP3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 10:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjBTP3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 10:29:52 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2083.outbound.protection.outlook.com [40.107.13.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4FC7EDA
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 07:29:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7uvReAj84L8iZfeE1Gw+boaJn2f9KxTmWqorNGyDHnDQaWoQuFn2Dk/fOgKHcRgmjpIk/a1BiDLyWlDjDxbeyoV/VbIzsvipunhImVtcJqCLaVxYGAg9dIzGKSXk73pjpae7kzROYEgTXhx5k5mCEfA5pZc6xM+p2uNJ6BsJcaCrVRi4xrc1Rx6obX/BmOXXoBA/enmNdKVj/FxzlVl80Ni3KRwLARYGNX8W4JmjgbYAQELs72+qqKNW+G2I1ThWQ9tm7O9ZILGnXmekq4hJGhM2IEIvyfCOqkUVczloavgJNVqp24+Aa7m0dMyrxNI7FANoHCeQik10jzTv3I5Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CckSfc8E96GWdmMQ2Tjf0CrdP1aU1qiNA9HAH19NmJk=;
 b=J7Qp+W4XA/20Yi16kNtEAwl1N4wgmJ99o9zugUevoabb4H3PY/n1/OLkmD2H/oB+EAHyiIoN0sgsDEDJ36r4ih5/zIqVrtOwsR5tp2Aw28sRr1ITi9n1n+0w5B1HKJNVNADi2z5ZzxjgBURok8scTVOdoujcDCuMkEremyhp5hkIvPQ4ixMveKfQoCn9YBySlYgMHJ9sSuWq3ZdFlgv/fbxcqgsAbyyGHJ0ZoCkKC3GhmHsjNsUQkcVrQ3yAzODDULuXIBB1I78E1wj17IpRRNT/0bJEY0WX9blAehOaDrd/K7fMJLejfmIfUe7ZojpFkiHR2D3YMuTtkeC0UeYsNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CckSfc8E96GWdmMQ2Tjf0CrdP1aU1qiNA9HAH19NmJk=;
 b=VQaRZgVvf8H0Ws3w8sU6zWL/emGlifNzS2P5ezvHGFpOKjCKMA0gzb4LpZWEWmuxR8J0TgnNwUCTg28zUUNbK18SWGyWNRxY1DeTYOEMViivKLR8fnzgY771GCbfV8TlPnw+kXTEWNhlPwuMbPh8jY0DB1kDK4FgD6BhscXK3yY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8802.eurprd04.prod.outlook.com (2603:10a6:20b:42d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 15:29:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 15:29:46 +0000
Date:   Mon, 20 Feb 2023 17:29:42 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?UMOpdGVy?= Antal <peti.antal99@gmail.com>
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ferenc Fejes <fejes@inf.elte.hu>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        =?utf-8?B?UMOpdGVy?= Antal <antal.peti99@gmail.com>
Subject: Re: [PATCH iproute2] man: tc-mqprio: extend prio-tc-queue mapping
 with examples
Message-ID: <20230220152942.kj7uojbgfcsowfap@skbuf>
References: <20230220150548.2021-1-peti.antal99@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230220150548.2021-1-peti.antal99@gmail.com>
X-ClientProxiedBy: BE1P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8802:EE_
X-MS-Office365-Filtering-Correlation-Id: 818f576d-cc01-4ba9-2a0c-08db13574bf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UW0Tg4XiFxkPeV2C6RjqiFx1rtWRIOKTupJ18XHaC+e1XLVoCQhRoGS7huzDjvF6dTZDYuqrcqVZ1uz9Kf1MqYut0Sik8fzHob/5opGk1LhvLgCQmqLS2CQadEvqZTAJruY/qJw5Uhx149KCw5D+V+beOezzAovIC3kn4coc9SgEDNr2PzxnipEqji5XAx4V10WypHg0oZK0N62cxxyyMoZR4u/wuGU9EPlLgA42FEJUpgJg8i0+XvnSBHk8h7YnaPk68reWUTEsP917pG/YLGj3gqxD14P0vs0+LYXBudxvgVHz4ezu4hJPwi4Q7ng4GXslVi4g//KHIENaqE1/N0bA/gYUl0/M0DHK6yxyBI5XfgJyrkaQ1cC8f7Ye5e5Tj6ro+mEzhLjC/uQWPeW5fFgfMd1GPa8axzi+yAXEQlO5fkqSx5cYuk++Pa3V00EimzaA/GZCA3QJLa1nMCV2yv0mWabLhw26j0hOFkhLa4AJO5XE89lb+mDsnmdMmafq8JabKv4ZQLzd/QToPeUw0gTEL4hwFA1Rn/4Us6Ujvftf1E6ZjVzCRI45xphaFB0UQckfR7NNByJXZojZaBhvl7EuTE38CykupAXy2gXQi2Iv8IhVEYmltKvY4jP4p6e3pzUi49GiPSZuxyLDuyXr8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199018)(5660300002)(44832011)(86362001)(33716001)(2906002)(38100700002)(6486002)(478600001)(6512007)(66574015)(186003)(9686003)(26005)(316002)(54906003)(83380400001)(66946007)(41300700001)(1076003)(6506007)(4326008)(8676002)(6916009)(6666004)(8936002)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGcxL3dRaUljNXlYT0swSnU0QURpMWN0VGRZOEsyNy9mUEErRlloNmtkMzNB?=
 =?utf-8?B?MVU1YmF6c1p3TXkzeGxTcFNlREJJeE1zTHVROTNJQzYyRjF5OUpvRFhENUpq?=
 =?utf-8?B?UUZqZ0w1MzlNaUlHdEY4VWM0eU51TDBrY05hbDFMNTJ2K1pvbVYyNDQzQ1pO?=
 =?utf-8?B?K2p1VlFoajFKUm9LL3ZvK1R6dFgySUszK3VFNjBFUkZZWStHYTlVNDFWcDNY?=
 =?utf-8?B?emtaSU05cWI2VWJhdDRBY2p3V3RuWUlmTEhLbTJzekdBZzNqeHFGbVVrNVM2?=
 =?utf-8?B?ZmgxTVNzQlUwYXYxdXdyR0s1bU5DTjFzRW1WNTJjTUQ5QzAvRDFCRkdNY0ti?=
 =?utf-8?B?Y2I2V3F1RzhJUXFnalBCOGpvVkNKNWxPdC9YakZOb2VrOExmL2pPOTEvOGtt?=
 =?utf-8?B?NTZXNk5LNWJsMXUycmhEYnEySlQrNmVONHVwNHlrK0tWeEtsLzNOUFJWd1Yx?=
 =?utf-8?B?RkpGYVQ4WnRPNXhxNlI4OEhpYUxCZ1gxNnFrSG1jQTRKQ2VIaHpPN281Q2hu?=
 =?utf-8?B?cDBJT3pMMFdHV2JZcnJhZjhkb29zNUtSUnBGRkNZTDQ3ZzkxaGVWY1dPYXNv?=
 =?utf-8?B?c1RSTHRYdW9TZW5vTzdSNTF3U1E2T2NJeXhWOFl5YzZzbTRmdEpzdUNvc09B?=
 =?utf-8?B?MGNJeU0xV3p0amUvSHpvWTFOTGJ0Q1hEWkFBOHI1QjMyemRYRGtHTGtMSzI5?=
 =?utf-8?B?a2ptd1pxUWVJeUtRY001QW52Ky9YcG1rSlJySmp5eit5REM5TFI5ZEFWYzZI?=
 =?utf-8?B?eUZFQ1ArSmRxMTVML0ZjNm1ObGRzeUw2UVRXdi9jVFVVTEIzbk8yc0V4aFZT?=
 =?utf-8?B?UWgrbEhoV2tPRGgvSE5GYytVQmQ4UnFLUnBRa1RQMFNzNnNldVI3RnRWaE9h?=
 =?utf-8?B?dmxvZnlQVTFFSVBKVWJnYTEwNlZYdWdmcHM3SVA2TGRQeDBYLzZ6bHFWUG9r?=
 =?utf-8?B?KytlalVYNTZZM1JBOFVxVzJHQ1MxcEJRaUtod0hIZzlRMklJa2ZzRDVISmVj?=
 =?utf-8?B?ZzlHb21pVlVjV3M2alJ5aGFtUmJtK09nOGRCU3EzeG1EUm1VYVZ6RXMxVHg3?=
 =?utf-8?B?akcxYmovUTFTSkI0RVdreDh0MHJlWVV4a2ZEZmp0YVN5VnBXc3l1ano1Vm91?=
 =?utf-8?B?bEFScXlZV2trNWhmZGJTREVXdWVjRy9FcHhPRUw5UXdSME9oSWI0a1ZhT04w?=
 =?utf-8?B?emx2NTdVRE1TWmtGa21zeVh5enFnRW44NC9qYi9jZFRuMzJuVmVZWHI5R01n?=
 =?utf-8?B?SktrdDN5RzN2L0VENmtWTXFtTytDVkJ6WE82enl2VlFpdlZEMHJnV2RYOVVJ?=
 =?utf-8?B?L01hc0dRaFhFOURkazU0c2ZqU0tld2twU21IQUtUVWNwRjN5T2x3VlFmeHMx?=
 =?utf-8?B?blNUYkRNN2ZXOFE4Q2pVZ2wwbkRldURhVzMzMm9mOXFTaEFxam1zQkc5NzU3?=
 =?utf-8?B?c1JHWDAzL21jU2FKUjdlNVJoOWVwVDVWNEIwZERhV3ZpTFB2SUQ5ZnNuY2pQ?=
 =?utf-8?B?L1ZOZFBzQVhOMFVYdWZBeUpTMi9KYVhyZjJsSFlQWHhXS0lUbXpyUjZYYXZJ?=
 =?utf-8?B?RWZiTEJualBCTCtXZW96SXQ5T3pEVTRIcDNteGJndHFBTFZ6V3dpdjBlUkNj?=
 =?utf-8?B?bUJrbXlSZ3A1TTFnVy9zazNEbkd0ZWFKRi9nTW1RakdZUURaUy9zODdCd29m?=
 =?utf-8?B?bkZrSHZ6REhMZjFKQjloRDNseEZlR3cxanpxUUs2TWlFQnUwOFdoN2hnbXBi?=
 =?utf-8?B?MjJ5b1FOa3l3NXBKNlpXUm81cFlwQ2ZvTmZhTTlSaXFWQlRldnJZTlVpVW9r?=
 =?utf-8?B?ZmRBL2ZPVjlwYmxkS1hXSEdKUFJkdHo5aWdoRmRWZmNzRlRLZlpJRDQyQlJL?=
 =?utf-8?B?OGEwQk15K2JEVWtsRGEvdllLemZjcWdGa3psS3Q3d2RWQkhyc0RXanB4c1BY?=
 =?utf-8?B?UHpUeDhBTlo4YXc1QWN0L2xyZE4wTGRzUXd2UGFaZlI2d09NbkdNcWlRZUZv?=
 =?utf-8?B?RHRmb3p3Zk9ENHh5VXh3RHAwRlRTZFJMWXpoZkd2OWxZMXozaUQrWnczdGU1?=
 =?utf-8?B?bklodjZvNk5ORUtKYUpVSk93dUtQZDFNTEJmYlVhTUlzL3hxOEVCOXlnWGps?=
 =?utf-8?B?bEN5UmRHQStJL0tMcGhja2IxN1FTNndZQWwyS0pRSldXZk5QOVdEU0hjWnp4?=
 =?utf-8?B?b1E9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 818f576d-cc01-4ba9-2a0c-08db13574bf7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 15:29:46.6253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5AhKYMyAecAviQ0+L9pXrMOItcEzOz1hxRGNqvDttLMTPTInstY0ea+AWdsN2JvcPJQVKFURvacvjZMvxhIVXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8802
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Péter,

On Mon, Feb 20, 2023 at 04:05:48PM +0100, Péter Antal wrote:
> The current mqprio manual is not detailed about queue mapping
> and priorities, this patch adds some examples to it.
> 
> Suggested-by: Ferenc Fejes <fejes@inf.elte.hu>
> Signed-off-by: Péter Antal <peti.antal99@gmail.com>
> ---

I think it's great that you are doing this. However, with all due respect,
this conflicts with the man page restructuring I am already doing for the
frame preemption work. Do you mind if I fix up some things and I pick your
patch up, and submit it as part of my series? I have some comments below.

>  man/man8/tc-mqprio.8 | 96 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 96 insertions(+)
> 
> diff --git a/man/man8/tc-mqprio.8 b/man/man8/tc-mqprio.8
> index 4b9e942e..16ecb9a1 100644
> --- a/man/man8/tc-mqprio.8
> +++ b/man/man8/tc-mqprio.8
> @@ -98,6 +98,7 @@ belong to an application. See kernel and cgroup documentation for details.
>  .TP
>  num_tc
>  Number of traffic classes to use. Up to 16 classes supported.
> +You cannot have more classes than queues

More impersonal: "There cannot be more traffic classes than TX queues".

>  
>  .TP
>  map
> @@ -119,6 +120,8 @@ Set to
>  to support hardware offload. Set to
>  .B 0
>  to configure user specified values in software only.
> +The default value of this parameter is
> +.B 1
>  
>  .TP
>  mode
> @@ -146,5 +149,98 @@ max_rate
>  Maximum value of bandwidth rate limit for a traffic class.
>  
>  
> +.SH EXAMPLE
> +
> +The following example shows how to attach priorities to 4 traffic classes ("num_tc 4"),
> +and then how to pair these traffic classes with 4 hardware queues with mqprio,

"with mqprio" is understated I think, this is the mqprio man page

> +with hardware coordination ("hw 1", or does not specified, because 1 is the default value).

Just leave it at that, "hw 1".

> +Traffic class 0 (tc0) is mapped to hardware queue 0 (q0), tc1 is mapped to q1,
> +tc2 is mapped to q2, and tc3 is mapped q3.

Would prefer saying TC0, TXQ0 etc if you don't mind.

> +
> +.EX
> +# tc qdisc add dev eth0 root mqprio \
> +              num_tc 4 \
> +              map 0 0 0 0 1 1 1 1 2 2 2 2 3 3 3 3 \
> +              queues 1@0 1@1 1@2 1@3 \
> +              hw 1
> +.EE
> +
> +The next example shows how to attach priorities to 3 traffic classes ("num_tc 3"),
> +and how to pair these traffic classes with 4 queues,
> +without hardware coordination ("hw 0").
> +Traffic class 0 (tc0) is mapped to hardware queue 0 (q0), tc1 is mapped to q1,
> +tc2 and is mapped to q2 and q3, where the queue selection between these
> +two queues is somewhat randomly decided.

Would rather say that packets are hashed arbitrarily between TXQ3 and
TXQ4, which have the same scheduling priority.

We should probably clarify what "hardware coordination" means, exactly.
Without hardware coordination, the device driver is not notified of the
number of traffic classes and their mapping to TXQs. The device is not
expected to prioritize between traffic classes without hardware
coordination.

We should also probably clarify that with hardware coordination, the
device driver can install a different TXQ configuration than requested,
and that the default TC to TXQ mapping is:

TC 0: 0 queues @ offset 0
TC 1: 0 queues @ offset 0
...
TC N: 0 queues @ offset 0

Should also probably clarify that there is a default prio:tc map of:

.prio_tc_map = { 0, 1, 2, 3, 4, 5, 6, 7, 0, 1, 1, 1, 3, 3, 3, 3 },

hmm... you gave me more work than I was intending to do :)

> +
> +.EX
> +# tc qdisc add dev eth0 root mqprio \
> +              num_tc 3 \
> +              map 0 0 0 0 1 1 1 1 2 2 2 2 2 2 2 2 \
> +              queues 1@0 1@1 2@2 \
> +              hw 0
> +.EE
> +
> +
> +In both cases from above the priority values from 0 to 3 (prio0-3) are
> +mapped to tc0, prio4-7 are mapped to tc1, and the
> +prio8-11 are mapped to tc2 ("map" attribute). The last four priority values
> +(prio12-15) are mapped in different ways in the two examples.
> +They are mapped to tc3 in the first example and mapped to tc2 in the second example.
> +The values of these two examples are the following:
> +
> + ┌────┬────┬───────┐  ┌────┬────┬────────┐
> + │Prio│ tc │ queue │  │Prio│ tc │  queue │
> + ├────┼────┼───────┤  ├────┼────┼────────┤
> + │  0 │  0 │     0 │  │  0 │  0 │      0 │
> + │  1 │  0 │     0 │  │  1 │  0 │      0 │
> + │  2 │  0 │     0 │  │  2 │  0 │      0 │
> + │  3 │  0 │     0 │  │  3 │  0 │      0 │
> + │  4 │  1 │     1 │  │  4 │  1 │      1 │
> + │  5 │  1 │     1 │  │  5 │  1 │      1 │
> + │  6 │  1 │     1 │  │  6 │  1 │      1 │
> + │  7 │  1 │     1 │  │  7 │  1 │      1 │
> + │  8 │  2 │     2 │  │  8 │  2 │ 2 or 3 │
> + │  9 │  2 │     2 │  │  9 │  2 │ 2 or 3 │
> + │ 10 │  2 │     2 │  │ 10 │  2 │ 2 or 3 │
> + │ 11 │  2 │     2 │  │ 11 │  2 │ 2 or 3 │
> + │ 12 │  3 │     3 │  │ 12 │  2 │ 2 or 3 │
> + │ 13 │  3 │     3 │  │ 13 │  2 │ 2 or 3 │
> + │ 14 │  3 │     3 │  │ 14 │  2 │ 2 or 3 │
> + │ 15 │  3 │     3 │  │ 15 │  2 │ 2 or 3 │
> + └────┴────┴───────┘  └────┴────┴────────┘
> +       example1             example2

What would you say if we didn't put the 2 examples side by side, but
kept them separately? Also, I get the feeling that the verbiage above
the tables is a bit too much. Having the tables is already good enough.

> +
> +Another example of queue mapping is the following.
> +There are 5 traffic classes, and there are 8 hardware queues.

I think for maintainability, the examples should be fairly independent,
because they might be moved around in the future. This story-like
"the following example" -> "the next example" -> "another example"
doesn't really work.

> +.EX
> +# tc qdisc add dev eth0 root mqprio \
> +              num_tc 5 \
> +              map 0 0 0 1 1 1 1 2 2 3 3 4 4 4 4 4 \
> +              queues 1@0 2@1 1@3 1@4 3@5

The formatting here and everywhere doesn't look very well when viewed
with "man -l man/man8/tc-mqprio.8". If you look at tc-taprio.8, it uses
"\\" to render properly. If you don't mind, I'll do that here too.

> +.EE
> +
> +The value mapping is the following for this example:
> +
> +        ┌───────┐
> + tc0────┤Queue 0│◄────1@0
> +        ├───────┤
> +      ┌─┤Queue 1│◄────2@1
> + tc1──┤ ├───────┤
> +      └─┤Queue 2│
> +        ├───────┤
> + tc2────┤Queue 3│◄────1@3
> +        ├───────┤
> + tc3────┤Queue 4│◄────1@4
> +        ├───────┤
> +      ┌─┤Queue 5│◄────3@5
> +      │ ├───────┤
> + tc4──┼─┤Queue 6│
> +      │ ├───────┤
> +      └─┤Queue 7│
> +        └───────┘
> +
> +
>  .SH AUTHORS
>  John Fastabend, <john.r.fastabend@intel.com>
> -- 
> 2.34.1
>
