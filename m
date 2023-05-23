Return-Path: <netdev+bounces-4598-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC5C70D7D2
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:47:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03FBC1C20CB2
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57C571D2A7;
	Tue, 23 May 2023 08:47:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E384C89
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:47:25 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2103.outbound.protection.outlook.com [40.107.223.103])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269DFC5
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 01:47:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLW+9a66UxPRR4/cfxfIjCVh9jfCqPWXBOrhK9e1fopQ58MXMw9pTYXBVDg9HMAKfA+OQq4+79Nz1mlgCwJ1iES1zpLVWt/KvHTY5GlUB5R8c2GShOJvUB3gRYQ85Ozedr4TYWLjBvYc6qotMNGCG51yxwnLRtoUsXH1/Lp9KZzcPpm++7hbXiFczjlOqjVz+cOQ8jEqUs86ZxRDNKorkjIMVObPHgP2y9vh0/bZcjA3o7AZzhB5F94KG6BMTYHUhvLO/LDiISAzX0tW9dvJKPFuP2dDsTqkp+vPN4VV0VmDs7jec3cAHopNqRbbAbOt8Ok5zrvpNcUMTZqoly/4kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sLF6brXQzxV9h8fjKSM7vdMQ99Cd6in2BOW7jT28aJs=;
 b=XZLr45oUYaa0iLLSThkwG5Jdrk6b3NS9YmIcguQnAlQwzDfas4RiiCZHmFOVp2bh9XYpO2z+O9M9wOGYFCMWrgxvDQPy6sHkax6BOW77/K3M0Rcgk6XNJwzDoVKHDSwPI+gH69i7NlMMl1q4Tl/iHKoLevk9bjyevov4SfAULav3eO4gUpBWmg7MHFVRijbg7voX7tpPCQ8zRpo2KOdikHz9ps1QajTAVGncTlToUUjjXJ74O7ipIfRTgPR/fB1QMh8+pUYrHguBWt7zSUoqXK1M+kKyY0YP7M1Y4J3PCHFT2o9+vrjpWFUQ00EkveCwK2cbeLj/KUZKxwyJri9Pvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sLF6brXQzxV9h8fjKSM7vdMQ99Cd6in2BOW7jT28aJs=;
 b=l1VlKIaFipwGSWnP0vEpiM5uKnBY2e+PZRV6VSW+RySXF4KjrYXAbiTML1BOmQ9lXsy9+JsBD/+g/aNpQ+bPSvMoig5IfKmjwToF5pDR2o2HXPg/KFLp/iNtUZAIRynzJbA7pi5uFMTYJchNaF3Wkvm9JyNg1UO37RHp88tBcWY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by PH0PR13MB5616.namprd13.prod.outlook.com (2603:10b6:510:12b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 08:47:22 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7%7]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 08:47:22 +0000
Date: Tue, 23 May 2023 10:47:15 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexander Aring <alex.aring@gmail.com>,
	David Lebrun <david.lebrun@uclouvain.be>, netdev@vger.kernel.org,
	eric.dumazet@gmail.com
Subject: Re: [PATCH net 1/3] ipv6: exthdrs: fix potential use-after-free in
 ipv6_rpl_srh_rcv()
Message-ID: <ZGx9k6m6r7blT2B+@corigine.com>
References: <20230517213118.3389898-1-edumazet@google.com>
 <20230517213118.3389898-2-edumazet@google.com>
 <ZGZavH7hxiq/pkF8@corigine.com>
 <CANn89iJofjC=aqSu6X9itW8VQXTSFUOiAmBB2Zzuw-6kqTnwzA@mail.gmail.com>
 <20230522130050.6fa160f6@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522130050.6fa160f6@kernel.org>
X-ClientProxiedBy: AM0PR02CA0101.eurprd02.prod.outlook.com
 (2603:10a6:208:154::42) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|PH0PR13MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: a976fada-3822-4b57-6181-08db5b6a52b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lVue7woTErF8xXh95CC5/51GhORZYkKKEm/VRFMDp/mrwF8rO6OJ4/7UN8/RcipSO/8FTcDMQZu4L79BpoHjHbyFS7sd4DUDoqu+ZUc4JT9/n4cA54KKpxZVQe7jcg7cjHUg4Y9M18+2cTI58TmW05PEeetGvwglTZDt0OTBeJh3HpGTlhX1EJwuiKiTlmJ9uYC6Qrzu7jVyZKGbGxhGNDXLRTl+a3oeaBIXNHVdvh461FARpMSJspk2c7vAa6T7zXCnFKn5qb7Ar27K7i/KaaRCBTCixXtGGTyvDi5mIqOtLC0TlzaWdNTUcG+bHq25FAfEitwisDgH2/0un30np6YflZPIaYpEbBB9PrhzMu4BAQNLEX0Sz5tw+YndVZcqtJrZXxkQl6skM4IRmELo3xBnAI4124SlAoTfLxwDrCtlJrItmXQHszlSg6B29O3b4C7FvHENSCDmc19FyKJdh5Np/GcklVx0czO5qmP2khaUtDH2HtnfSp6+m/VofHbOeoQzTohohvTij+FBKaexAJOgH6zoW7C2hSeS9zjRESTV7OQiHT+OqOpzPPqZ8f12
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(376002)(366004)(396003)(346002)(451199021)(2906002)(6666004)(38100700002)(6486002)(53546011)(6506007)(6512007)(2616005)(36756003)(5660300002)(8936002)(8676002)(44832011)(478600001)(54906003)(41300700001)(316002)(186003)(6916009)(86362001)(66946007)(4326008)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K0NzRW8zQ2hjZldXdDFGTlVrcVJHbVJ1bEh2a2dWa1N2ajFneFk1dHJBNHJR?=
 =?utf-8?B?bnI3V1hKcmxLemFncFhKeUdpK1lQVzBONWlETU1zcVVBSy9BOVJWakVVT1VF?=
 =?utf-8?B?Z3hQVlJicWZscWNUdXIrSG9XRVM3dzR4ckNFWkFXMGQ0S01tdmJBY3dsVDcy?=
 =?utf-8?B?Z3QyOGZ6SnkxWG1GUXFVUnluNU1yWkZnZW1mSUhnb2pEbWh4eE0vVU5zNzN4?=
 =?utf-8?B?aWwzUldTZmlSa3NtbnRlTlFLMUZvUWlWY2pXQkFDaFNjbkxZVzNtVGRGRElm?=
 =?utf-8?B?a0Evc0tWMDdtOGRVV3ozKzY2YW5icS9taWNDbE9QTmI2RkczRkFDeE9nb1py?=
 =?utf-8?B?MCt4TzNoZDV2RUl2NzlIU29yQkNtL1RqdktPRnJONjRXMWJTd0pBNnkvRFFw?=
 =?utf-8?B?N1UyMTRJRld3Wi8ybmNEYjM5ckhHU2tSSytYTXNEaXdCeld2TXQ4cGdJalVx?=
 =?utf-8?B?a0RZVDY5YzZtOVYwQVZwWGhEU2h4VXlPOTRDOXJuS2xRbmx5VmU4REU2bnJE?=
 =?utf-8?B?NHFaNzFhRHk1TWwvYmRzTjRHcVFmb3dNMDNpY0FZRXJ0QXUxY3I5L0YwbzlY?=
 =?utf-8?B?djFRbDUwQU9GSmhkZ05IU3hVSlptanBkamV6VkE2UHkzVURWc3YrWVRJaW5B?=
 =?utf-8?B?UnNvbUhyVzhOY0VWdVY3T3Q5ZjhtWEgyalFhUFFjbEFqMzlyQzB6a2lKYkJs?=
 =?utf-8?B?RnVrL2hQS3R5Umw4dkxyVjBNazVPUHRxKzc4d3dzVGRPbzNqRXVWMXJZZEdL?=
 =?utf-8?B?UHFmeUNZellOenlCVCtHS050TlAzdGtQd3VaM2ErQ3oyYk5na3V0cHU4SGY3?=
 =?utf-8?B?c2g5VCtoYm5DZDJTZzRLN1dzeWJJNlllTFQ3cUx6M00xcTdZdDdFS2JKWG5I?=
 =?utf-8?B?UXdlT0VCejhsMmRIZGJpWEV2RW9DZ0xUOGZCNnEycHkxODhGYjFSWE5ZbVBZ?=
 =?utf-8?B?VWJzbE1ZN1kzcnpaYnlMQUxxTEhNek1mMHd2OW5tZ21LU1NVdXlVV1FaWk5x?=
 =?utf-8?B?TEIwYTZKS3p5dWw1Y01QeXdVaUc2RkFYc1haV0lTdDNVTGMzVTdIdEdZMUhR?=
 =?utf-8?B?WEVCWkxJc0dpZ0hKWTNUeUwzcnVJTkNpZ0hJcFh5M2xIT2RQZWpyT1B3Y2NK?=
 =?utf-8?B?L3AxSEVBU1FMUFg1SERaUzJPZTgxdStLb0FhRi8rNGV2RklVenNISDZVQVpv?=
 =?utf-8?B?MXJTamYzNy9nc0NKV0FSRGdBbWIvaUNGRXk4dy9XR1dkTGFhWTd4K1JjSW15?=
 =?utf-8?B?OS9mY1VBMkZJOFdFZFduSVlzRkRGUGxBa2Yyd2ZCcElWNGR1VDh3K3g0emkr?=
 =?utf-8?B?SjgwaDEyek9BdEdlejhYT0NobXpPVWcxaEJhZXNNaFF6cWhUZTJKQ0w3cWlp?=
 =?utf-8?B?SlRTSW1YWGdXUlpLZXRqUERpZmFUYTdpcUhIUDFXRW5LQXdDUVFqck5jUjl4?=
 =?utf-8?B?SDdhazRXWm40QUhiRnErczBFci93bkZ0d0pBWXg5V05wZFZpZkNIcnVFVEkz?=
 =?utf-8?B?RTVqZ3RaZFZUZmRkWVlIZEQwTVFlT0tXTEZYUVBpeDFMalRSSklXUUNuWDJL?=
 =?utf-8?B?eVU5SGZ2NzVVcTh5bGZHdzRReTNyNVZiYTZFenZpQ0dLM3h0cE4yS1l6TEl0?=
 =?utf-8?B?STNPemxUSk4xL0F0NTJjWWN1THYyWWkwUlBWRFJMRFN1WFNtTXZyM2dOU2Vk?=
 =?utf-8?B?RTlabzhBZy9kaDE1UFlIK0hsR1JRcG5kcTk1aDlDM0pZVnJkbEJpdVhleTcw?=
 =?utf-8?B?blZ4Y09MZHEyV3ZrV3VvLzhTdkp5Vmk3K3FTT2JYdXJ3bVVxOVFzbFA5NGRW?=
 =?utf-8?B?eVMwdk50T3N4UndFT3lHbU0vWWFnQzBZR0haMDhpRFQxRkZWNWRSNFhWUW8y?=
 =?utf-8?B?MHExRHdvaXBvT0gvRy9MdnFSTlcvdU1ydjZ1SDlseENLeEJGTXd3QXdtdW9l?=
 =?utf-8?B?clNNV0JzOHkxK3ZRam1rMnI1UVk1MkovdUlZVjVydzBJcldCaEozYmVJWFMv?=
 =?utf-8?B?M0ZTbE0yb2NZZEpvdFB2REt1VUIrT1MyVFJuM3krVURDNTY1UFZPaWpWTlox?=
 =?utf-8?B?WElpcmgzbXU0bzBVZmFhbHZBK2lyQU9RVWVZcldRMktEdjJRdVFrQWRiVjd3?=
 =?utf-8?B?UE9mdEdQRnJxUS9kSWNRblZ3Y0R2UWtuOWtlNVdBYXJBbTlJSkxiNzhkdnM1?=
 =?utf-8?B?OWNrT1F6M1VPbDA1bVY3S3Q0NWI2aGZpRDlhUUVXekhZMm0ySE5YbHd4dFhW?=
 =?utf-8?B?aGhRQndzYzlCS3RENWFxa1BrcnVnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a976fada-3822-4b57-6181-08db5b6a52b8
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 08:47:22.1014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LaCd5rY4qLJTQSkvkjmGFO4mhkN9cHM2yh46LpP9zUYufn/eASGq/6sRn8+eYkj0Wzj7Pb5AeJwEa5iEXZTkR+q9H52L6D7nx49zj2ibzmc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5616
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 01:00:50PM -0700, Jakub Kicinski wrote:
> On Sun, 21 May 2023 20:22:16 +0200 Eric Dumazet wrote:
> > On Thu, May 18, 2023 at 7:05 PM Simon Horman <simon.horman@corigine.com> wrote:
> > > Not far below this line there is a call to pskb_pull():
> > >
> > >                 if (hdr->nexthdr == NEXTHDR_IPV6) {
> > >                         int offset = (hdr->hdrlen + 1) << 3;
> > >
> > >                         skb_postpull_rcsum(skb, skb_network_header(skb),
> > >                                            skb_network_header_len(skb));
> > >
> > >                         if (!pskb_pull(skb, offset)) {
> > >                                 kfree_skb(skb);
> > >                                 return -1;
> > >                         }
> > >                         skb_postpull_rcsum(skb, skb_transport_header(skb),
> > >                                            offset);
> > >
> > > Should hdr be reloaded after the call to pskb_pull() too?  
> > 
> > I do not think so, because @hdr is not used between this pskb_pull()
> > and the return -1:
> > 
> >        if (hdr->nexthdr == NEXTHDR_IPV6) {
> >             int offset = (hdr->hdrlen + 1) << 3;
> > 
> >             skb_postpull_rcsum(skb, skb_network_header(skb),
> >                        skb_network_header_len(skb));
> > 
> >             if (!pskb_pull(skb, offset)) {
> >                 kfree_skb(skb);
> >                 return -1;
> >             }
> >             skb_postpull_rcsum(skb, skb_transport_header(skb),
> >                        offset);
> > 
> >             skb_reset_network_header(skb);
> >             skb_reset_transport_header(skb);
> >             skb->encapsulation = 0;
> > 
> >             __skb_tunnel_rx(skb, skb->dev, net);
> > 
> >             netif_rx(skb);
> >             return -1;
> >         }
> 
> Hum, there's very similar code in ipv6_srh_rcv() (a different function
> but with a very similar name) which calls pskb_pull() and then checks
> if hdr->nexthdr is v4. I'm guessing that's the one Simon was referring
> to.

Yes, that does seem to be the case.

