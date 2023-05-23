Return-Path: <netdev+bounces-4706-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E081D70DF8A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:41:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A499A281394
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4230C1F183;
	Tue, 23 May 2023 14:41:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8816FB1
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 14:41:43 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2136.outbound.protection.outlook.com [40.107.212.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495CD119
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:41:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjbJOGtsQNxLad/4ODIiRvObksEquCU3L/OqlZmdyx6NGU73qTqQX8/MvApxB4v6/zQZNOElbbuhY3YCOCYIlTLli21RVlnKUiT7k5jKx6/UV2Mx9emWmIcMETazNv721k2TbLusMori8laEjK/K3DTVUsxOu8qmwUdcPL9ZAVccfX6QcF1YXHonWWhZJUbby5wfFwjwGo/lhg2MK3iLsqGCSI+LN18OvyXbp/HokDI4+Ha8NQg6AZl57K2a3vQVNtNewFXJtQLxnrLg6eJtxWV0ZIq7tenwTQt5icvT7ALVLqLOf3u0t/uJ46EySRJGUf+AIJJtxdPTiP1kLm1PWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yk1gybF2yWXA4Ucm/7+aFHXm/EzKsn0jkClI0hAmb3o=;
 b=TOl7MZisi40NUC8aQGdN5WqscWPtjVVQhQwFpzboVVPEmr4FBznYaz94adTPIqNXjQXJWvAaAS3Xd527iFQZvxlNfkGH7KOvdS1Kl0xr2mfA+amlA/SI3XF2BygXu2IEMmP7/6foS8UqkvYSHlMpdVjXRIiVXhvz2Y5TtOsAQOiy1rUwThsAY2kFax1WQ1ELv/kEdw3J61ctovDslePFLrnpaJKRtTnSgdSZWpziLkBQknXCyuNx/38OaWdt1YNOUfp/gNTLiPKmwvU3WZcVdtJb8JkLLj/9OZ84D/M1abV6iV54nyoJbJIuQwzlHeJ3WBl3bHdhz27x9KpQX7s/jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yk1gybF2yWXA4Ucm/7+aFHXm/EzKsn0jkClI0hAmb3o=;
 b=loHV+KR38FonpMy9r5gZRQ9WCuaK5661lk69ShmvNyR6WHhYRLBFRNDeYO30Y76Pn1iWzk+tEM9BjO5YrnLIONG2NlF55v3jFZGFFojc/Igg5hIkhvrXaHKl5gDrlznVyDdPWMavwhw1ca/2UPv3VYTDzu2fRh7Mw9YqXHm6X6o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5100.namprd13.prod.outlook.com (2603:10b6:610:111::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 14:41:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 14:41:34 +0000
Date: Tue, 23 May 2023 16:41:27 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexander Aring <alex.aring@gmail.com>, netdev@vger.kernel.org,
	eric.dumazet@gmail.com
Subject: Re: [PATCH net 1/3] ipv6: exthdrs: fix potential use-after-free in
 ipv6_rpl_srh_rcv()
Message-ID: <ZGzQl/tuggsugbY+@corigine.com>
References: <20230517213118.3389898-1-edumazet@google.com>
 <20230517213118.3389898-2-edumazet@google.com>
 <ZGZavH7hxiq/pkF8@corigine.com>
 <CANn89iJofjC=aqSu6X9itW8VQXTSFUOiAmBB2Zzuw-6kqTnwzA@mail.gmail.com>
 <20230522130050.6fa160f6@kernel.org>
 <ZGx9k6m6r7blT2B+@corigine.com>
 <CANn89iJ0Sdy5o8WHdTygE3UwUgHpJkdxKfeYXMN0DZBKs_f6AA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iJ0Sdy5o8WHdTygE3UwUgHpJkdxKfeYXMN0DZBKs_f6AA@mail.gmail.com>
X-ClientProxiedBy: AM0PR04CA0142.eurprd04.prod.outlook.com
 (2603:10a6:208:55::47) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5100:EE_
X-MS-Office365-Filtering-Correlation-Id: 8880f19c-6abb-444d-facc-08db5b9bce8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tXpOi6gU8Op70wJSzkUuaO7e3ABA5ZcJ/a2ETebCYoVnV0YIIf12rtXRs4XlgaPRTDE3YW/BJnwXDy/HB+d2EQyXovVtEESO8uTvbaKIJod0JxtUiZujZwVy5Y88fiZZX+Mp+H6JBOpP9jWfegnFwEzwcbCTUcDgd8XhRncW5QycA2xWnGj2E30S/zbd1I43gAxqv0wrJXc6Jh7zXITYZjA+5Q37R9RQWOrG/YuIjzq/ZpVTgzIEXoMJZkKHAnNzPsglPVkEHRcRmUwmdqHpnQnrPMltBJQwuBQzdbQM/rWtHtt08KPRzLLWYdDDz8+dLJQf6hq0E/arH6eqM2jnVLd2nUdRcWhOEGKdknWQEtU3XbJCxd0I3M1ARSw2nZtIy6/aYsDxkKpGsgCR5t5OJkN1qdPNM7oQNgMCtLkuZ66hpv3otyzXVdZBI9nlRpSAiS17cB8/i1SXKYMtsc6NDJr5UZKvrw5Ox/kAD6wc4PD6dowMAYoedpNudpgtrrmunZ7BDsv/BuY9w39AcAV5NC1HgfvTOp2ETbuDRh7xXg6KtPMx8KC5lnIUdet6XBg7
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(366004)(346002)(396003)(136003)(451199021)(5660300002)(54906003)(8936002)(8676002)(44832011)(316002)(4326008)(6916009)(6512007)(6506007)(36756003)(186003)(66946007)(66556008)(66476007)(41300700001)(53546011)(6486002)(6666004)(86362001)(38100700002)(2616005)(478600001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q3JLbzVwRXk0d05XMkJYbFQrY3dOYnVYUlNnQ0lpNXNJMlozbUFFcExEWmVj?=
 =?utf-8?B?Sy8vODVURFJKamsxK0VUNWtpWEZCdXlhZFhiOGh1ZDFBOXdSRXk4Q25vM0cw?=
 =?utf-8?B?MGloMEcrUTRYSXNQUTVKc2tkalFzL1BKMVJ2ZG5RSFFvN0FDVEJRVVRsMlhy?=
 =?utf-8?B?TmZUY214ajgxWG1vaHo3WTBSTmIram1jbGpuUm5EdUJYTm15aTZ1eE9RQlVJ?=
 =?utf-8?B?RXZUN29zZFlJNkh2NWJzbXk2MFQwTXlsQnF5WS92a1NRbjV3RFpsdThZSFNv?=
 =?utf-8?B?WmRVRU5VUy9EbXR6SnVPcDRKK0l5VGVwdVQ4UkpPZlpGSWgwejJBSUVVV2dH?=
 =?utf-8?B?c3grREhqU1BNQ1YySHQzRnlpWVlycEROd2N2dXVrbk9jLzZ5cEZFTDdvSG9a?=
 =?utf-8?B?OUlTR2dDSjBWdGl3T3dLMmNiQjlTM1FLK0ZGa1VFRVpOTzJOVGVvT0J1TnhU?=
 =?utf-8?B?M1Bya084cnd4cVdCcmdrRUxFbDVlMyttVjNnODdlcThTNFhwV1dpWmNOWjM2?=
 =?utf-8?B?SlRsWU54OG5Ka05pSkZiUFNqQVI0aUtyek90RzBPOWEwT0JyRjFSVGNhdUs2?=
 =?utf-8?B?U0xLdSs1Wm1IUU9uQitiZVl1L0F3V0ovbXBvYlZXOVNqSy8reXFhK20waFBn?=
 =?utf-8?B?T05lQ09kemloWVZtOEV3QWRVOWxFNTg0cGlNSkk0Q2V6S091dWdicWtwY3RC?=
 =?utf-8?B?a2FHS2t3YkNxTy9wMERPaDZPSzhxbVdHR1VEVzFzMFdraFF3dGExY1FHa0l0?=
 =?utf-8?B?K3ZqRnFxOTRnaVZuaTZzcTR3ZDRHQ3k3RWoyNFNKT21BeEZhY1J1UzZBTVAr?=
 =?utf-8?B?MU5CdkJkYXlQRlc0bXJXOUx4TEtpYUNFR05UWit4V05aMlh0Z1dmVElCSnFP?=
 =?utf-8?B?MGVJU2FUVEZtc1F5M0UyM1hySDdZRTZVY1lOQXBBVlFFL1ZnWG8wUUVwVlVa?=
 =?utf-8?B?R1p1VWh2dW1RVmU4dERSRFFRRWtoNS9mUzVrWWRoY0RrYmJkMmc2TlV6WUU1?=
 =?utf-8?B?cVJ2YlNqQ2dZTUhIRFpaSmtGVmt6dGhXQ2xoQldsNlpIQnZQSlFZN3pUQkJ3?=
 =?utf-8?B?dDd1UlFVcXd5MXEwVXNUd1hZejhEc0tkM3AvWk00d0FOY2VpankvRTdKZ0Z3?=
 =?utf-8?B?M0tUaDMwdDdEbWRKYXA2Z1J0R0Z2d3Q1VTdaWC93NThqSmlIWHJxVmlra0NL?=
 =?utf-8?B?T1grZmZINHdTbWVtTnoyby9aMmVZdEdZREpOY2t2Um85SnpsandDN3Zubmkx?=
 =?utf-8?B?d2hVSWNIbjhHc0cxR0hvR2hnVVJBanl1SXpSYzNMNklvTWtWck9YVTkzOGhj?=
 =?utf-8?B?QzZiVGJkUWwrOVZ3Y1ZFNGdsRW83UmMwRDBQWStjeDYrR0FpSDF2d1RiWjhm?=
 =?utf-8?B?Nlo0Ukd3MmNtVXlhU3NJU05PSzRlYnRLZmdmSTlvMXp3dmEzN2xnSlo2Rmt3?=
 =?utf-8?B?eEFWWVo3eDhKSVRLRHJlSzFpRE1wVy9pcWh0bUZOeTBxOEhRK296anBCQ1ln?=
 =?utf-8?B?VFF5aUF4RTNaTEZuMDZYeUphV3JrUlB6MUJ6cHpRMlJVRUpRMGFuNFM5WEpV?=
 =?utf-8?B?UDhuWndRYnpPRXVacXRsbnZnUzFpY1REZnVqNG1BWm9QeGNCU2VxVFFmb24w?=
 =?utf-8?B?SjJud05EQ1RFRGVycEcraExJRzFNMG90ank5SnFISzNmYzdwc010Tm5lTTVL?=
 =?utf-8?B?VjI2MjIyNGNyUVQ0WlA1VWZiRTFBcVNPdGVDaDhhZ042c0xMQUFEUjB1dW5u?=
 =?utf-8?B?Z3dlVENta25nZHdVR2lNZGU4ZFowdHRlTHFDQjRTdERhbm9CeURSUXlGMk1W?=
 =?utf-8?B?emVUN3gvaHRkNFFYZlBiUU5MRVg3UmpNcjJ5VThqaEwrN0pmdTlLSk01MGtW?=
 =?utf-8?B?N3FvVWdwVmxvdnhraGlvZjRjTk1YTHpHQTMxTnVtWUlNaHVoRnQ1OGhUNkli?=
 =?utf-8?B?MnRrSlM1cVVuZ0VDbGJVcWpKZjNSZ3UrV2l6Z3pxOUl2ZmN4bFI0N1F2aEVB?=
 =?utf-8?B?WmpjNjdBNjBvSWZhcVFiZWJrc3piY3MrbCtoNlk5QU12aHYwSUhIQ0RHbTR3?=
 =?utf-8?B?QVo5RUpyZjNjdXhZSHROU2gzNEhrSHk1VmpYYSs1ZXRaM05sUXhZODZOT2p3?=
 =?utf-8?B?dXh3cXlNUko3WUZkNzlUL0hwMkZUdHJwTXlqQlZOaTZJUUQwaEY0elZGWVdM?=
 =?utf-8?B?ZmpWQ0NWbU9rMW01eTlycjg5R2h2am12TVV6bWUxZWE5VFFKRHg0TGs0cFBl?=
 =?utf-8?B?eFhKS3N6NjNCeXdaV2dvVXhLcEN3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8880f19c-6abb-444d-facc-08db5b9bce8a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 14:41:34.8281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fMiM4MPPoi7wYmwVs7Y1ae0tULRWddRoqNMcry8+MhjNBbBbByDAiHqR9DMnNErHKb7p93tQxxfT+RPSe5uRb6p/3iOpevfCeFVUkUJ2cLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5100
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 12:45:34PM +0200, Eric Dumazet wrote:
> On Tue, May 23, 2023 at 10:47 AM Simon Horman <simon.horman@corigine.com> wrote:
> >
> > On Mon, May 22, 2023 at 01:00:50PM -0700, Jakub Kicinski wrote:
> > > On Sun, 21 May 2023 20:22:16 +0200 Eric Dumazet wrote:
> > > > On Thu, May 18, 2023 at 7:05 PM Simon Horman <simon.horman@corigine.com> wrote:
> > > > > Not far below this line there is a call to pskb_pull():
> > > > >
> > > > >                 if (hdr->nexthdr == NEXTHDR_IPV6) {
> > > > >                         int offset = (hdr->hdrlen + 1) << 3;
> > > > >
> > > > >                         skb_postpull_rcsum(skb, skb_network_header(skb),
> > > > >                                            skb_network_header_len(skb));
> > > > >
> > > > >                         if (!pskb_pull(skb, offset)) {
> > > > >                                 kfree_skb(skb);
> > > > >                                 return -1;
> > > > >                         }
> > > > >                         skb_postpull_rcsum(skb, skb_transport_header(skb),
> > > > >                                            offset);
> > > > >
> > > > > Should hdr be reloaded after the call to pskb_pull() too?
> > > >
> > > > I do not think so, because @hdr is not used between this pskb_pull()
> > > > and the return -1:
> > > >
> > > >        if (hdr->nexthdr == NEXTHDR_IPV6) {
> > > >             int offset = (hdr->hdrlen + 1) << 3;
> > > >
> > > >             skb_postpull_rcsum(skb, skb_network_header(skb),
> > > >                        skb_network_header_len(skb));
> > > >
> > > >             if (!pskb_pull(skb, offset)) {
> > > >                 kfree_skb(skb);
> > > >                 return -1;
> > > >             }
> > > >             skb_postpull_rcsum(skb, skb_transport_header(skb),
> > > >                        offset);
> > > >
> > > >             skb_reset_network_header(skb);
> > > >             skb_reset_transport_header(skb);
> > > >             skb->encapsulation = 0;
> > > >
> > > >             __skb_tunnel_rx(skb, skb->dev, net);
> > > >
> > > >             netif_rx(skb);
> > > >             return -1;
> > > >         }
> > >
> > > Hum, there's very similar code in ipv6_srh_rcv() (a different function
> > > but with a very similar name) which calls pskb_pull() and then checks
> > > if hdr->nexthdr is v4. I'm guessing that's the one Simon was referring
> > > to.
> >
> > Yes, that does seem to be the case.
> 
> I think ipv6_srh_rcv() is fine.
> 
> The "goto looped_back" does not need to reload hdr.
> 
> The only point where skb->head can change is at the pskb_expand_head() call,
> which is properly followed by:
> 
> hdr = (struct ipv6_sr_hdr *)skb_transport_header(skb);
> 
> I will send a V2, because this first patch in the series can also make
> ipv6_rpl_srh_rcv() similar.
> (No need to move around the pskb_may_pull(skb, sizeof(*hdr)
> 

Hi Eric,

Thanks for the analysis.
And sorry for the noise on this one.



