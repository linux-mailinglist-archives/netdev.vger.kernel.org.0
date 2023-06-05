Return-Path: <netdev+bounces-8092-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D96FE722ABD
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:19:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B0D728120A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B1F61F94F;
	Mon,  5 Jun 2023 15:19:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473A81F94E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:19:09 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2135.outbound.protection.outlook.com [40.107.92.135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB42194;
	Mon,  5 Jun 2023 08:19:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEsWz2JM/lAvClvvKVyGVRVIxEXHLqdUxTA4F7HY0CT9o0B0WNYFKBoQYc64BF2ixi09EDm3G1wbxqvii+Px4Crx+sELLOGyi2lz9C8owTqN+VqfHiQQHpPS6wz8nQ0RGdqgyAxKAd3n3pYWqbONz9JJIiWS8CokdgSFQj3cIWvRdceTgj3oWJdM7A7E/WV3QUNC66E5hhzjzko+xn9TJ8uuskBx1uBQF3WX95qhy+CyVwZhT/fJxJQM5lLQ82dZuvDiTHYvFtn286OrUmQAIYNQv4x04iM4lX0XRTP1Z5Y3KQJGjgrGi/P8NDjtG8TgokJsrYF0xSN7DPKU7ohj0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RTDcANxWM9NtJh9GqqkOSr1c39WhiteQUb6U0sjPkbw=;
 b=egdcT3frvgXs04mCaZ6l2iCj28nMKw6leE4ORsG152BQDi+5FVXgLx93rRxG8DQ/CwowAUte00pdZjLA3kdLR+xHJoaIMvHJUjRHp+A69Fu/WcBR3+tDFrKZOHLICI5a4j2ILvf9pRkR3WSSu25AaOY6DffTqrnWu1Rv92lAcoiIK/vWxUGUNGBy3YVQUiqGL5wxYNgSBSt9avZJ2K92n+rYq8l9RMSiFb1XC8OGjuYPGDljObxH3wcaOG2Srzk3N7Zd5qC5UyP7jWbvL+We+lALOHcB8DlnDMzqOrVrXF/8GK0VLlgWrlQEGhL8V9KFMBMNyyEA0QRuS93BWZAxAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTDcANxWM9NtJh9GqqkOSr1c39WhiteQUb6U0sjPkbw=;
 b=C7A8ZS69Vr+L9qI9X2G/tdtUGYLZOaf/AF5JEfjREcUlBeiVsUbAeM9h/4q6yEDUvhYu70gRQrUOe19MrzdUIcordxOPGw04F6YgMbKlcVySitBzbunVpSOsoLn/WeIRFX0JvNNt3xKax4EAkoEhkX6+/cjkeqqDNH+Zs9dAyF8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6478.namprd13.prod.outlook.com (2603:10b6:408:197::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.18; Mon, 5 Jun
 2023 15:19:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 15:19:05 +0000
Date: Mon, 5 Jun 2023 17:18:59 +0200
From: Simon Horman <simon.horman@corigine.com>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 03/11] splice, net: Use
 sendmsg(MSG_SPLICE_PAGES) rather than ->sendpage()
Message-ID: <ZH3841Qotr/QWgXk@corigine.com>
References: <ZH32Jp1Iop8FaDtC@corigine.com>
 <20230605124600.1722160-1-dhowells@redhat.com>
 <20230605124600.1722160-4-dhowells@redhat.com>
 <1729074.1685977857@warthog.procyon.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1729074.1685977857@warthog.procyon.org.uk>
X-ClientProxiedBy: AM3PR07CA0072.eurprd07.prod.outlook.com
 (2603:10a6:207:4::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6478:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b43b6b5-7ff7-401c-1d42-08db65d8336a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6P9ErAhwgywzK3rW87+9bEVeYU34AHtpVvJ3PkMjq7OU+1f2m4P3Xh8IMhgsLG/1u1uqDjiolsT9NAEKJcKDkaMVq1LWAH758Wb0qSf1Bl9Mb/ldgKCB7+m1zztkm/stHLPdoBZqRVH/fltweSkbdlc7T7IfBn10FYD8kLBORdbVQWyPVlCjcgDUr2P/3hh3PPaoDE+tPLdD7vvsAFOBCci2kPoI5xo+CsrraarNHvKkOx92x9st5IayKl6B5EbQ+KF49tl8Rg5ce7egmP53KYcIWnrOexF4FczDEGZVGU+b4Px5CTNJpxx7OTIGowhrszvrxron7k2pnKJ7KinArDB5YV2UcTQhtbLyM1vzTOEus/y44PPdKXgOYJvbFkYujaRe8981+i1XGJ1oDlzbMlUkWtk58qL7dIDoAD9Gi4tUvCmlayftC5Hdtuvwj/YrxrQ+ZnnKnGoTy/PrM89XlcItcP1SqqVpNNGv3oZCpVw2nz2yHiJTrzMjxF+oDuPjXGZBlEE2pqRjAzrxzjzGYYH/e6bvl1vSrvgssjeJ86rnreOQ/mNHa0zNzRopWQQhoT1FkZJDuE2eI8xNGETatIZBGEfH173fTFVyIZM1ZTA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39840400004)(136003)(366004)(346002)(451199021)(44832011)(7416002)(8676002)(8936002)(5660300002)(4744005)(2906002)(316002)(66476007)(66556008)(66946007)(6916009)(4326008)(41300700001)(6486002)(54906003)(6666004)(6506007)(6512007)(186003)(36756003)(2616005)(83380400001)(478600001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QzdOA6rrNDsgry81dhE6XZmalw39UX55k6YfpWHheS2fLOzAzmzgC58hWEuk?=
 =?us-ascii?Q?IlxTyd2MVN7HFLjniUFIQWp8ZKuQ9XcHHdGkj2II4JX2icKsslQT+4GdoeTs?=
 =?us-ascii?Q?lv5JCLdpbs+U0s7YCzBanzqdjiTkZEA1HY3ollAxGRJWzFJagTOu4AI4b9Xl?=
 =?us-ascii?Q?fUv9NNk+hkjFNA2y8jvwzpSLdmcfJjqILwW0zqZMT0pDYNEvSU0o6G34Z1HS?=
 =?us-ascii?Q?xAqnQSELOhKbmlX7evRkScwE7Z6ep3CwIaST1XjZ6DK5k2J4vTb6lyeDt7sW?=
 =?us-ascii?Q?9qMYYggljF4FP838Q/W/oLQPoLwe/iLt5689KkK6Yae88oDJefqav/6jywCs?=
 =?us-ascii?Q?k+RNP9UEfl49p9fXSnc+XekyQybz6yFgbX8sNqCj06WlBLqDhKoGY7SVenam?=
 =?us-ascii?Q?RcNNahwy/Ih1xGdP9zxuc1WcvNYq2DtMvIM/oIv+XyIhxZPXv5sh2pPUnDz+?=
 =?us-ascii?Q?1GGSCDIG9LzHNKU3CJOSjzBuIX+aHBi9DaLxXUB1hJPiRvEOGu0IWJVjSoZR?=
 =?us-ascii?Q?gRkGBL/TvP223YobKHfjHFNhA12siD/M6mkSoJ2wkp0zzewXfzFBCNn8Fg4t?=
 =?us-ascii?Q?/R6p6xUiTStkNwVsSn8LVADjWIXVLdPuB67VLYjYVpA2oZtmCIHHMOR5OdoV?=
 =?us-ascii?Q?4RRpawXL+3wHoI3Itb7/l0xxC0cWMcx/bwBLGttv1PNc28bmd0hlv0jzFWVb?=
 =?us-ascii?Q?3NhOTRd+EcL/SPV7S2HLDo4sOoCpoq7kJ9l1VLdk1ODsFZZDXtfFqi9vYxgC?=
 =?us-ascii?Q?NM0TLAYj7FDakJXMclgy4H6E/MH+X0LIkLw+Nh095kBB0QzYZdA9/NCnCv2P?=
 =?us-ascii?Q?bsuivFpbzCioQGfwj5yh/5MRhAFFW/fl1ZPgh7wfjt+7NfWxzJCImNlo95u/?=
 =?us-ascii?Q?j2YjNplXdN8cjc8jwC3Zq+s9sJ4hlJoeTFN5rA/feM5le5Hvqi17GRTyzNJH?=
 =?us-ascii?Q?6l513nCksdyX0If+2yWGx1Ka1UovKMDTzSgL2B6uPlMICoEIGXAbquEppQ1q?=
 =?us-ascii?Q?/d7ThagJgmK1jmtkRn5YSsV/fQKqGfxODdOxR9jR332XdujGBMrgr2omSo5f?=
 =?us-ascii?Q?X4RTOX9oGerB0+289XToM7ABJFvCwgJNWfy6gtdmH4aNwPC2QbFNLPPH1d2z?=
 =?us-ascii?Q?f/wxEnEIPGOoxIMa9gPUm9HVNVDVgKankYMColDHISUn1VzgpcaBgD3pgR8/?=
 =?us-ascii?Q?GddwlPs7KH6grY6dglQUb8KfFgjjmC5rG7CAjYlVTyiDJLqNkmz3lg7JSl2R?=
 =?us-ascii?Q?ZRcs5W0mA6/x0ZKhq3oWx/n3WagdXQc/vt+Lb/E/8C21tIFwS5Fo4CJzYmpB?=
 =?us-ascii?Q?Y5i6Qmwj835Ns3gluc9xI0Jkzk5qFXjBDUvC5wDM0Q+vV7PTDkxykjibQnfc?=
 =?us-ascii?Q?klupJzFi08hmbQ9qKclNwY1p2gP2AiV8i2fRaiab1HKI07o7qX2uIclmDJ9K?=
 =?us-ascii?Q?FNru8i59okL5rBih8MktYjg8aoDykraRMut9Je7OX7XAx6YEgvgr3zyjRUya?=
 =?us-ascii?Q?SUHolx8SfUICT1QjX5lCD9uqy9N7G0N1u0D28mNGfEDYm2ke2yNqzaDM2C/Y?=
 =?us-ascii?Q?1CxNo8EhuV4FmIUQpPcMqE23/R8Y3CazwfSVHcuaKvc7r5OE4LnA9lDGQdm6?=
 =?us-ascii?Q?22uzEm3MznICxzyVtRm3cgkKT/Q9IdxoF28HxsMa+JBwm/JpnmiCvGnaNVVb?=
 =?us-ascii?Q?09a7tA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b43b6b5-7ff7-401c-1d42-08db65d8336a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 15:19:05.4070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LXRiEdmSSxdDDDTHjfq+PRWuejWGvP9+dIj8D7JeLUAZG8Z5T0NbJlGKUVfLOSI+fH/jiQKpTLedsyETuI2pXgX+LUuFQOL4Mm1ET/NF8oc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6478
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 04:10:57PM +0100, David Howells wrote:
> Simon Horman <simon.horman@corigine.com> wrote:
> 
> > I'm assuming the answer is that this cannot occur,
> > but I thought I should mention this anyway.
> > 
> > If the initial value of len is 0 (or less).
> > ...
> > > +	return spliced ?: ret;
> > 
> > Then ret will be used uninitialised here.
> 
> len shouldn't be <0 as it's size_t.

Yes, sorry for not noticing that.

> I don't think it should be possible to get there with len==0 - at least from
> userspace.  sys_splice() returns immediately and sys_sendfile() either splices
> to a pipe or goes via splice_direct_to_actor() will just drop straight out.
> But there are kernel users - nfsd for example - but I don't know if they would
> splice directly to a socket.
> 
> That said, it's probably worth preclearing ret just to be sure.

Thanks, I agree it's better to be safe than sorry.

