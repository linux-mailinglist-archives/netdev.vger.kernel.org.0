Return-Path: <netdev+bounces-6550-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76F68716E2E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:55:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6EDF1C20D30
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7071231EE2;
	Tue, 30 May 2023 19:55:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0CE17FE5
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:55:18 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2107.outbound.protection.outlook.com [40.107.237.107])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B8AE8;
	Tue, 30 May 2023 12:55:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3ZwKE8RtH/lFGE4ZBu+44ko+o/KnPI/MlPxidaz+ip8c2fBZOi/Jq8dYY50kTGDq2RJbzRL3CyFqYSnueyFJv+n8Fs974SFs7T//TI9KpOkmTn0qU9CyLAx21ds/sSypRjHEaf59soSckXOmU9uhcelykKDquUIaIcL0RZDH6yBK1tgurE3khmBbP2QPwSLqyIzLd4BVnA39BqsZ1O4VQaZQ19hKxQr0/cqAT1ZK9n86bgIuBVmMaUCDXFuGinhmGGEnWmBmdHkcYpDYuMGqZwVsrygz3QmUcCi2qxX8yZqQkZgUmjpuntmJkyH3Z5sytJAJTnhLWrk2HvZlv4WVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M2QibxGVOA+FGDY6sCosHoqKQJ+rnFs+kdwLi+r13AU=;
 b=YN524pWy4729+RCn941UoxthBu3QiyZrThIKp1L4/Vcjyx9jUV1Wo4Wv49PsV23hOlK8sLTX9h3kc35EcxIRes8gdkP1210dd/oC3AuJ1UrKORwJ5TozPOePMpJm6anK9Zh7IqEKZNSiryFBMeW2UIrN0CssL04TH4ga1WVvcL5d18E5V/kLlAaf/LY6aZGzOctAQxihaNdUg2pD9vUZ8G7PfMy8F+1ZPrGVQGI9WxONdvpwI9a4JmDNW29Zb5Ua1W5k3o+2hBKl1zpDgoj6x11zyTu+DldkRLuJyaTXZ3J5gLROgNQA45qj9RRO9xRcIvB7jbpWMFjHy7FId48Eow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2QibxGVOA+FGDY6sCosHoqKQJ+rnFs+kdwLi+r13AU=;
 b=ncnNb7xI5jmXtdslzj6qL62hs1fo9NtGNuPgrbHuI3sMCMBoEIOyDQE1Mx/028pJaUz7XpNHrjBg2a0QmNVWdsFbLriclp1PnhOjWkuVTdBqVi8fsyp7EY5WwtlQmG6QD1cQPSeKLUQ9EStcnbBRqXj3o0l9ZtyvkxVrvdSbdLg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH8PR13MB6182.namprd13.prod.outlook.com (2603:10b6:510:259::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Tue, 30 May
 2023 19:55:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 19:55:14 +0000
Date: Tue, 30 May 2023 21:55:06 +0200
From: Simon Horman <simon.horman@corigine.com>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-crypto@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
	Steve French <sfrench@samba.org>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>,
	linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH net-next v2 02/10] Fix a couple of spelling mistakes
Message-ID: <ZHZUmj71oJYKYYLY@corigine.com>
References: <20230530141635.136968-1-dhowells@redhat.com>
 <20230530141635.136968-3-dhowells@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530141635.136968-3-dhowells@redhat.com>
X-ClientProxiedBy: AM0PR10CA0102.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH8PR13MB6182:EE_
X-MS-Office365-Filtering-Correlation-Id: d2389c8b-f74f-4692-1dfe-08db6147c8d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ounxAFoAEjYbTDoKI1qQVvxasgO5Yx9mGvTRH/JUgf2m9wLv1KGWGm71L6ZBjf5gEQWR/tigLort9JANn2mIXMAiKpDU+xZ27Ix6eDWbMRj1tXXxUBv6HTlH3J+RNJbzhhaNtbvjfUrmJtQfRPTUlWooZCsh/1CNg984qUZWlQ2P7XxB5nEaGj5rKltLDLtNOzKFq30DlHrUXchm2zHDxeEPNX8SEB9pDXblgpb4OR0QOkBi0yUMDghauNyHhGWAnKCsaD5o/ST2j7R3iJpZoY1GugRb2uL29yvYkVaoHz2rzVZNg46wb6e3LRwFJbsgvW9ZXexEo349VAoPDuIAwqrfdO+Yct3ehPBhhFfvvuNEz4EXs2ayc8UqDO1BSQfV00TKIWSMj/bMHujmJCMrjycbODa2OypsyLNPNVpRNfNTW6Y8ZH4FrphLSrgmfL3BOKJnCI4Olkh9avCiPRUs7YFcWsBJ5Few3SiQecoTYul4VwmRQHYoj65hs4/om+fcvVtHWZfGGFZmOPq91x4gYt51xDxSFs7ORZuO+f58LkY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(396003)(366004)(346002)(136003)(451199021)(4744005)(478600001)(2906002)(186003)(6506007)(6512007)(5660300002)(8676002)(54906003)(8936002)(38100700002)(2616005)(966005)(6486002)(86362001)(41300700001)(316002)(36756003)(6666004)(4326008)(7416002)(44832011)(66556008)(66476007)(66946007)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ePV5Mg2v+nXuak1La6s9TxA66j4ne3Sd2idZAkFsNZEOJbvrQr36LZpHaVMj?=
 =?us-ascii?Q?IR0JI2PDppAUUoOYrz2+jYws7caQcYWdTRWTu24Tdo28kvzjvtshCGP5bmt5?=
 =?us-ascii?Q?Bp/W2wZul6rUMJMLRXXntGx3XH6UXTD2Ll58nbQPZm3sAIvuGst9/R6C7ylD?=
 =?us-ascii?Q?9xcQa2tJUAb6N4Ro4orik5bBUWAmiotjKwCrsZl3AgR5QhaqzKHqYMSulPh8?=
 =?us-ascii?Q?nfWDKKRPqARmFleLcys7bTPKTTeyKDocDYaV/MoVl2glwQw6YEG9j1W7r2Jz?=
 =?us-ascii?Q?TNPNVpt+Dmq6G4KlfU+ZUUsos/jTnVBeCb5ae4ZhqLT+6dnNkTBLF6esPnS1?=
 =?us-ascii?Q?4mnASXLsUIrxqjGT9woqUYVMe+AD5Hp5TJFc5yA7KGcD7wma8u23oraX8KHG?=
 =?us-ascii?Q?xtynStSRqG71A73GiIQ62/BNOv38+eHHbVbtEam7+MnodaxqyJZUMBKqlb4e?=
 =?us-ascii?Q?cdNIUlrRENgz7nkFQ0cT5Hi/O1zDzKUgytsL/F09bnuIWp/t0a1vcnZr+uif?=
 =?us-ascii?Q?zSlLHlle3i8G8ufVhP0moX1QmyGt78c7VUHVnsVYOGnFUHVwLMTnJdH+lgP9?=
 =?us-ascii?Q?037xhHmYo0xILIj4daCLM19ITZX9a0Hvn4YKgjjjx/6vXYnosLg/NhP4X+59?=
 =?us-ascii?Q?F4ZOpxFyhcztTOeSCCVSXgiFrGK10QjI/7elhqaq7PQNvO/IwIliBlLJLlQn?=
 =?us-ascii?Q?cgZo/sAJuV/spHa93v/cc9MtPb+MRwKb3rndhILMBFWXav1vbDpKDmMPukc1?=
 =?us-ascii?Q?U+FXFItKefcawi8AUFwyKk57oLiNLs6FD8i25JXQnkmYEnNePR0PaNQA4YWN?=
 =?us-ascii?Q?TEG/iF8bmdVjzDVg1x2qIZidaHmJ0nmdQqnOe3MNFcBnhrS3639Bs1uOf6qi?=
 =?us-ascii?Q?xzWkRjGBAr+G1XuyvOKgV8n/1zDqMlP8nJz/jNQkoNbmyl3uaprK6BhUnK32?=
 =?us-ascii?Q?qBWfzlansOwyteeSf6muX1LjWbf5yWmYxlBNR3J2/LtgCktNLKayQwJXWfjx?=
 =?us-ascii?Q?+pANBgTxUN/JAcqZ2Ro0n6uljdqx/aSRYmJTRe+coh2gqRmC/ZH5Gso2AhQI?=
 =?us-ascii?Q?43kNCaxSQBaTHBBHGWR8b+lIx2gJ451ra2zGFNgEod0gQww1G32rbwrhqnre?=
 =?us-ascii?Q?v3BwhJO9ttSpouqicwGxPsFNLxF14jibF3TYUCbOQULrz+/QyLKkjZc14SQQ?=
 =?us-ascii?Q?+7cq6pEhYwDWixp+J4WtUd0rkyrsrw5tCcHvUCKj5M47LtM2liXmbbXZciFc?=
 =?us-ascii?Q?syVmO5X6vWVUqcjPC5sBwUcWUH0BVUEoToYe6VMBBtvjeDM8H6WV4rvIuikc?=
 =?us-ascii?Q?MRn7KU9ygTXLq4Sued1X5Pciz5JwtyxlxXc4kU84DtYfrcG9pySwE5uRCdw1?=
 =?us-ascii?Q?S58qLzRGCC+6Em+4Dp/HGlyTKwIYm8zxlcdW4iyFy3/aIecAxHy79y3Kmsoi?=
 =?us-ascii?Q?aGH1IpKzkNsspVg6ets6si83AoSpFqAmT0+71MRb1a+gexK3Ngr+mJlWw9Ov?=
 =?us-ascii?Q?379Bg1KoYrIxVbOfVWEgahUqTqOyMmutA+mVIGRaMBf9OnwXv7fuqLYk4rZl?=
 =?us-ascii?Q?55CYYTpiaFAE2vhVGqa3LqqoXcE91qh4X+atsqgEWLOegirAADoj9BNsEls8?=
 =?us-ascii?Q?LCtut+W61PgGdX0+9PEzFpBXjP/y+fRda4eidKlIXXJNH185xlb7cOhbAK+O?=
 =?us-ascii?Q?bN4UFg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2389c8b-f74f-4692-1dfe-08db6147c8d7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 19:55:14.8689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rOD6j60HscxKHVJT0OMF+iZuqUTQhPWnBmxP+Wiczi6pOLFOtSy9A1ol1BSsV+5/npNal7PDE2jMUb6GH8RhJPABVskEwlYpwvCtGdyDy1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR13MB6182
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 03:16:26PM +0100, David Howells wrote:
> Fix a couple of spelling mistakes in a comment.
> 
> Suggested-by: Simon Horman <simon.horman@corigine.com>
> Link: https://lore.kernel.org/r/ZHH2mSRqeL4Gs1ft@corigine.com/
> Link: https://lore.kernel.org/r/ZHH1nqZWOGzxlidT@corigine.com/
> Signed-off-by: David Howells <dhowells@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


