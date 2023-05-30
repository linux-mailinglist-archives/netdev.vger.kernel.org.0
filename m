Return-Path: <netdev+bounces-6429-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 379FA7163E1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:24:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCF8D1C20C15
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:23:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C150D23C80;
	Tue, 30 May 2023 14:23:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE95621076
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:23:41 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2093.outbound.protection.outlook.com [40.107.101.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46673E72
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:23:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dLoiB330satBNkWx6mDC8Ee7F/G0ACTJKFpMqjoDo1umqVZZSTSNzkR5RX0Xl9wjfNmkmkE+6I6oukgh+VQLQiUrjXYEeOMHlOc0+b5n9Cm6+dmcingpJV2VlQqWYScDoO6+osjDOntVSHkPeLaQhacRdFv9cWzL+LtRP3u83/L92DtVjJrgzEToGBvkFaqHnGurbXqfMRvWVxgI1rP1dW+3szoy2PdZWsgbTD40WCOIFk62H+zZYVkNPkS47cVNG5ylWrNUW+75wUxH5ISnp3OZK/Wt+6y0rqyZqQsFADHNtPYBrbkToVsEuNlY2xNo1fp/rhF9arSfrASjWM8ZMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HABFyQ6o2sKCyQAiFn70T8tOt01YxiRj0G1H3lnO470=;
 b=QGZrI6kca9iDJ1rDPrqWh4bXyAmQhkjDIwUpA6kDowIj/ifkQnUwaW9HhXqFnftQek6loAJK1vabaav7/eqaWOJNMMLC7gGidDS8oupOEtjPs40VFA09H+6TTWf+S4Hf6dc3NoN59Wg+HrS+JvThoJjOOlWJjHH84QOu+UUJqYMfF6TmDpD9Ii54Pb0WHQ/YVopVG1Xr4qXZUP8D7yKUAHJ/knR3QeJh6ldlxCHcF91q33CLXN31L3bE3K9XdQBjyYXJxuxQXke5vEZHC48JNcGhZ7cgmHHsVXXRWY0+10ZvJibkIQ9KR/t8RLj0jG8ld4BZxEV9ZXjQheFPkR8ctw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HABFyQ6o2sKCyQAiFn70T8tOt01YxiRj0G1H3lnO470=;
 b=RbWIZDoHdvZo5Crh2KZMu5bh9M5MVBFmbe085Huuc+HmvTm2Z94BKJtgcfSjAaBXAyq0WN+1mXaouBXWfly+BW9ixt1lfgGtMXSS3+rnnJCYIRAtC8HaGygdHquM4/IC2lQHRTyVCqTQ/FdLdywwpQE4zrgFNlsJWFPP2mNyEQs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5871.namprd13.prod.outlook.com (2603:10b6:a03:439::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Tue, 30 May
 2023 14:22:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 14:22:43 +0000
Date: Tue, 30 May 2023 16:22:19 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 net-next 03/14] ipv6: Remove IPV6_ADDRFORM support for
 IPPROTO_UDPLITE.
Message-ID: <ZHYGm8j0rmf+boQ/@corigine.com>
References: <20230530010348.21425-1-kuniyu@amazon.com>
 <20230530010348.21425-4-kuniyu@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530010348.21425-4-kuniyu@amazon.com>
X-ClientProxiedBy: AM4PR05CA0020.eurprd05.prod.outlook.com (2603:10a6:205::33)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: b2db0802-5df5-47fc-b1b3-08db611954fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5K5YDPf6DFGC0hhTGs61sQqQY5nezqqj5vA6zCPCUX5PMTGI5q0EjqL2aynV/nDmw0HR7yWHOjDCt+syfck89c6ladlfFVFaSo1byA6/Nri/1baC9OkAAtz9QrhhCqgY8rzlpcbFAO3G/2GWwlyKwksKVtiZ5wmhMLzx/UKtgFTRhornh5segT5/BXvYgNksJuiVUx+1M9qKP0rqVhKKhVFSYi8ArdINbUVtzCQPNp7/Dtsy6LUHNWecOt9Vnf5hf6/t5UDjg4uV+cW3RRKmOGVoUUuORSrltSyI2J+Bf2mpn1tAWq0+G5IDcAvN2P4Ib0DR5jJ6rhQQdgpSashLdsAw1EwIKIBwmoNpJTmoA74/afQqHfHC1U7T4rB/7uqHc6oGgTFfx1PWRuKanTdWlRihujG4YB8/uM1C1HormBhE9xEeuR+x08dGonj21RJRZBxgGKnTUgCC4FiVQQwgqTBPYxk3IotkKPL7E5Vx5YQW8n2iCAKYlAMZWEKlMK9I6SCd9ASmEHPuJCjZA9C/rWTecXfEkaS/WYJjT4K9i6LJIMJ4aktnZ9Momw/jyPek
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(366004)(376002)(346002)(136003)(451199021)(6506007)(6512007)(186003)(2616005)(2906002)(54906003)(478600001)(44832011)(86362001)(8676002)(41300700001)(6486002)(38100700002)(8936002)(66946007)(558084003)(66556008)(66476007)(316002)(5660300002)(6666004)(36756003)(6916009)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DhJQR1b89AqMWjSos6RycGS7SiogyRLLDAiWgZiLI3A872gqRObo5ljYCCqK?=
 =?us-ascii?Q?MqmLMqFrNiEipksWK5Pi1GJCLPa4WuiOkBkH4QIOTdnJ5sft/sJY0C8IIiXO?=
 =?us-ascii?Q?4Ooz0v774yBmuHsskLGCb+MVqrGMKIWYfFMLlNpfDwUeQ3GhXKjWoLc5b6z+?=
 =?us-ascii?Q?WlPKdpem0HjlBE1nmh91W5K0Ckl9SR9NAOuur3J6hn1iH9lhKK2QsQgUoKoR?=
 =?us-ascii?Q?jGrei28ezw0E9xhJpgChJD9vLhXAROsUzaEjdgZqcmGM/NCGcB98F63q59mh?=
 =?us-ascii?Q?+jj3yC1oohbxxHMML3GkTDoK8bBJtE5yX1OyzPsaMxQWgnJN1yXkQmOpdoaK?=
 =?us-ascii?Q?lZ0jm+basiDmQhnm+STEU3SlZRJxMFrvW0nV5CuKPzR+iUsd4pVliP+rHNc5?=
 =?us-ascii?Q?K3t++DlS/aaAKNGN2DZ122cTKoCkiiXIHW3oH1C1IDCaoxSr36TVCrs58iAz?=
 =?us-ascii?Q?2uqsBVYWpgtQeyGrwyd+NofInEpgMtKgvz+4d2MV+uGMyAomiTcRUb3glk1e?=
 =?us-ascii?Q?6gznlGud8+C0t/M9LLcgY3Jn6wEQsK5xiJi+jyqRyqJFBwvUWQv9e6V/YXqr?=
 =?us-ascii?Q?WkIrYUx0PyLvjtE4iJmcBYk+UuB25qbvLVqJ5UVOw/m1g47QPxX+2z8x0T4f?=
 =?us-ascii?Q?I7FAUBkIi/7kFC5b2ELq2yKewfdwo9w6CkVbXVR/fMD6wtix2DO70awZnlCh?=
 =?us-ascii?Q?AvTlctxkky4cquQpNsBeByN4XvDa3O1LFhDaw1eC3Q4PK4Kulga6WcM8A/5k?=
 =?us-ascii?Q?MjihOTnCBMLblrM/owGO3gmIRnVfy4+5wUplj1VVuNDD26ioiH+2EZJpXFBV?=
 =?us-ascii?Q?Ans7lueWiQK5fQcG6MutfW9J6gFUEP6S1nbpw60wMm5DFTOK8ywbNXDvXz1w?=
 =?us-ascii?Q?h5B68qUUX6bFYJ0sG77J5lQ6dO/FpgQn43ccbGjlZBczRFyvAKH+ESCQOuWH?=
 =?us-ascii?Q?alypu5eVbWG7jkXOBFJWOBd/koHc/jJGZsY9mkkSNL9Gu0UxDP41wfjCIKZK?=
 =?us-ascii?Q?lJ428yhLNfdKRel2Hn22RrOvYCN1ReH/xk50yz3n041ADRy7F3aOYl9LSexQ?=
 =?us-ascii?Q?LmBzRUXJ0G3yoC/EBRUs8CxghdpdBYXi+9XonTziFLdaf2PQl/eBXH/pXz8K?=
 =?us-ascii?Q?oDIXaaMtfyc9oD4LI6qwYlVk15Nj3QSLIkfErbFJGM1cK7sJU+LlUjIz7fAn?=
 =?us-ascii?Q?znXtuiBMIE2tVbfrxfhf5BNOG6TTsE3BKAoeJnNY9JzmFVObLuO2DgtfMqpO?=
 =?us-ascii?Q?VVUPAgcs/ZXvCLN/PDW8XpxpA/21jYRTM6zT7nQD20dPGDP/pAYlulY7FaEH?=
 =?us-ascii?Q?weVUw1P2WF14LHC6UBnGJffGHD4uY/6i5E1+vbTvOrdlFGOFqvbWbWs73w9u?=
 =?us-ascii?Q?1MeejPVcYKZWHFQ+WrT0tjYKDyOxrrvhFdLNbbioAPKOkdmR9wxrmpPVTfD8?=
 =?us-ascii?Q?JcpEIeLwleFn0cEVhQbWpvMf//pow1MYn7wai2sbfaY0gvZ9hrjfOYgRiQHk?=
 =?us-ascii?Q?mZaqjHTaXeqrFPHQvuXZsHCERaWV2xvJQ8i7t9MReciOD+DfTJVpS83TA6vq?=
 =?us-ascii?Q?vQf8Qch5gA5e633JZOKHHX8GWYRzIST1P34kZ8hmnFKfgW/CpKDOVzLpayRM?=
 =?us-ascii?Q?3aYgFG1N7HTNxT/dHDqG5XiVd9uT/zDrzOQ32eRPYzT2NKIdoqK/NZN8QM33?=
 =?us-ascii?Q?ZTYdJA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2db0802-5df5-47fc-b1b3-08db611954fb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 14:22:43.3463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nnb4ivqbwOJxX26GSXvALtuOfALV2PcE2ZDSkidk4HOFIXkiTSWDUSzl+WSOEorNC9GNE5do1iBH41ZdvgzcEBhmZKA/fX9HW30q8yOkZ0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5871
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 06:03:37PM -0700, Kuniyuki Iwashima wrote:
> The previous commit removes UDP-Lite v6 support, so conversion
> from UDP-Lite v6 to v4 never occurs.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


