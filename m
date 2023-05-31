Return-Path: <netdev+bounces-6926-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1DDB718B23
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 22:26:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B51E1C20CF4
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:26:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C003D389;
	Wed, 31 May 2023 20:26:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CB534CE2
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 20:26:27 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2070b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::70b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F51C126;
	Wed, 31 May 2023 13:26:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ig+3rm2fuEBqsjBo+gRYXexTZh58SIZPY5D1jl0t9ucz4WN8TlTIL6BCA6LgUyYC2mRLqYeRLQ1+uuzEsWVw7QsAuQ8ao4YHGgjdxYFsu1uh/xsR0RdC18Vqk/0Q7iydkm7EamtRbdn8XkKtASJWgPfIFfsAjnK0chzQk8OP9G9VyXnFC5BnYyzk8SJ5LgurXmX25+qSVHfRvVlH4fY5Ax+qSqR4qaNBReyrHIs0Z8QzCEJPIcqhIvfQ4haAvQ4ts6XP/xM9C+EqslqKbgmnIRhKE5g15jrNTTv6deR6LhzzvbKCyEalqrPZuv7qGDXkcet0z1zAGgcEpMj/2rBnvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJ7grSjLw2BrNzY47WR2RCDhF3wzZlVpw6GKqJLH31E=;
 b=MMPmNGbC5zCUf8vLEIFaYknUml8fsSpYkB6zZ6vygP+oiKUQiFcm+twU4PHyfeYDadjbF1qP8ZaUGOxm3fIEi0HpEDG0ZOfjEZuCViwTw9pr7sXoPk1Qp42iozPeJvclm9QE6wjMQhN2QVcLGHHDOT6dRFd1pSoUOE3eIbkoP/BaFbCFN71vXctqk70ZNLDSo7wogsopvWdXYYqlcjOItYLXmvBv9XyslrmT7EYi9tiB56OLjFucV4IjJTBiTGh1mzEykxUr/2FbL6T244yT/bdfM9kMm4C2xkivVJr7LTfykX9l9vScJY0UVCd+8kWfIcEHOvpLdugUcHvN2sMWjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJ7grSjLw2BrNzY47WR2RCDhF3wzZlVpw6GKqJLH31E=;
 b=tjfbuu4NVQDYbL0BmdklN97J1EBa7Ee6p2XFptajSc0ks2wkUPLTTIamHky1m82JWWUhjxu2jL3CpyiGLqOpgwNvJDOaA1TH7pyoDUg1Ss+5LGVwik76CQeEY2xOdqJwAqrKwbDaZUqqj11VonlHSvRgncQ78cQJe7N/MrU7JtE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5639.namprd13.prod.outlook.com (2603:10b6:510:12a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Wed, 31 May
 2023 20:26:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 20:26:21 +0000
Date: Wed, 31 May 2023 22:26:13 +0200
From: Simon Horman <simon.horman@corigine.com>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/6] net: Block MSG_SENDPAGE_* from being
 passed to sendmsg() by userspace
Message-ID: <ZHetZexY7zeyPLFw@corigine.com>
References: <ZHd9vCcBNtjkqeqg@corigine.com>
 <20230531124528.699123-1-dhowells@redhat.com>
 <20230531124528.699123-3-dhowells@redhat.com>
 <724855.1685556072@warthog.procyon.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <724855.1685556072@warthog.procyon.org.uk>
X-ClientProxiedBy: AM0PR01CA0101.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5639:EE_
X-MS-Office365-Filtering-Correlation-Id: ff2de518-5915-4ea6-1752-08db62154bca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tURZW0mZ4AYUWsIcJIqRiZ82Va3vlVjwy3NBeLFBohHp168aTWWAG9Luou92o82TTl70tEuM47gZs4h3GlB19Bux2f4TRg7DKCZeR+pdtJefBUg+RIsy/Tlpc8kRcpdDhC4yrChvlMXiiaLQmbLdfc3M7p/NvnBK9va8s5CW+LLWCTHWM0v/0fz+6DhD9VMPj+A3AeGAXtRQnJXXNqXsfmeKv92jXkpD28H7HYD4NBPILLaICv/Z23+26wnXUlFNADXYMgbcfPHCjcUpbSC8nv5uPijgfaLl+cfn6qZODx4AhtSmh9nFhA15qkFhU6bDHvhoy91T3c97czpy3NNd+u3gF7usOJyaAx/oLAtnjmW10q9OOCBGbcbkcXxmvDKYPCfhaTSAkfp1RjYYbOgQX1h13O6fB5s7EPvsp3+HIrLPleSu3+BaobW9wBx/1fqeKqEhie9umbVnV9mPiL6UE8eWVUQbfKNV/q3+ztv7Sb2b6+9N4iWV7EReXKotk7M+jIYzcPHZCpZngCNdjeRryML8FiAOxS3DkEB/0fhXAR54SE4cHXmq5o8fG7p3NNyRQmPD816GDIyC+4FQobhJm1YbN8sSDpkhK8axeRHW2ps=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(376002)(366004)(396003)(136003)(451199021)(4744005)(38100700002)(478600001)(2906002)(186003)(6506007)(26005)(6512007)(5660300002)(8676002)(8936002)(2616005)(54906003)(966005)(86362001)(6486002)(41300700001)(316002)(66946007)(36756003)(44832011)(4326008)(6666004)(7416002)(66476007)(66556008)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+XHT2EYoy/n8wk/Q+DVlUgC1u3PDLzYH+kvQ/ujtaKoomKIGk0t83JUHrCFg?=
 =?us-ascii?Q?zWpWpn+cTji4ZnwnECnU1TaDUQLMbnIkyAmXpzYPwn8KfmgJPMz+RUau6svy?=
 =?us-ascii?Q?EVPrXtUfo6i6yzLtxUtHXPZ/mN9zeYdNmYaR6iyyUwKBu9LyzCjHG3i3MdX9?=
 =?us-ascii?Q?kg0hqGBxB7RI1HS++AunR63peC7o72tNEjYiGJCHu/QfEKiQWEhTLK+9Stzg?=
 =?us-ascii?Q?szy8zQaXw94gWSXuLGuewoEmDI79Gmh8ylIYCK3bIaf7NIacXKoyiI177aKG?=
 =?us-ascii?Q?XOGmyfTpGMPyM8D92hkETDwVP4JweqxycrckMKqBLKd148h739jv/vANCLuq?=
 =?us-ascii?Q?Qw1cyG/itDIoGbPKOpTxU4ty3SmuHTqFZDJfOTFdVLBQdP+/c9wrXIngAyiA?=
 =?us-ascii?Q?K2EfVtSmqu46lDpQPgJGqKb1QWBxajqd/EAlEsFtTvE4Hstppy9GpnQVgyfo?=
 =?us-ascii?Q?Wrf/vvSUpxxdwkX18Q971udvB1sKpLL7cFEhV87Jda+IecwLkcRz9BiA0fLe?=
 =?us-ascii?Q?u18WWINUL0jcJm2ZxJv5wsWOsMPVTcBgxiaaZmJwkhAIog2jk1T7DcuVe5BD?=
 =?us-ascii?Q?2jboRZ4mgNh6lhra/o76jXUjrZOgHdKRLlthFkxS7OcXAKqlfpzAySxoGGCF?=
 =?us-ascii?Q?ULMTblan0MV38ywH6NqEdtnS5XANxDsdP9DCIKbhZpyEd8YuxFg0zWXS1WLc?=
 =?us-ascii?Q?yy4IkSq4/t51Nk7CebdVtBFghkdAB/+ane9WJRldDSlzJloiFNyR15WuFsmc?=
 =?us-ascii?Q?rvZmhNKk5xEULaLWnjLvo4gEzlebWAXBSs9wql6zum4fVMq2kn9eOdJnkTCb?=
 =?us-ascii?Q?NDZdWCF3OLRhsE3WCw355zVxQxZvUeGDnAnIpEbOm1bPkH3eSH6MdPbzI10Q?=
 =?us-ascii?Q?+UAiZIhzMBaB547TSl7pTj9UL6VJZ40rs4/CGPMwuRzcHvGODLwW22Fa3MKP?=
 =?us-ascii?Q?zdL0VW6epmiNUpYS14YuXNRwEwTh6DDQb9SKVWvSyxCWbYiNoZzyJljlPs3q?=
 =?us-ascii?Q?uPYR2uqwDrbymCFXf0IDkaUnlytI98jGeT57OWGbzwORoORkkchaQdyG8v1x?=
 =?us-ascii?Q?vuhb0/V/ZsXLVvIJja2O7/bMY5I53Ybpzk7WQhf5K9jDXML5GoamNiTgEv28?=
 =?us-ascii?Q?7RdE5imMmblnyTPu8mG5h27XfwsMBXEQfPsliAeO9nbhvZzDXLSZr8Sh4qd7?=
 =?us-ascii?Q?hYm+N5Wc/ZUH2EQkElCRu+2F6zAx6HIBKRp8j83eThsYqq0U/wwKW3K0n9WF?=
 =?us-ascii?Q?T+gBb0bM7COeBFdvLg1vX7xKhBA3TbUdSuWLEs+BnJHs56py85uAphST3wql?=
 =?us-ascii?Q?Msgt6OVXnGJGnADcAzTTlZG/EvSBRnFlus29rIaNeMEi7qM4wcybwcyI3OCO?=
 =?us-ascii?Q?wqRBfpG/sgtq+rkjYQip4Us/wsBoI1AeXACSk2W8mj8RUPfU0wNtn/teakOd?=
 =?us-ascii?Q?VcF+WgTWOe4GB4Aei22BkyaDR1DVBdaJWywhzCk9xV0Ro5LJfdzJE/PsSawT?=
 =?us-ascii?Q?3egIyg0HKYz72WL9xZ20AF8txdxKb+fP/4ZHQXvTsh8c4CkxgPcwK8sHHKco?=
 =?us-ascii?Q?4CR5aQjK+dTikrkojQuLQVSCGWIvF1Ls2Y4PSf+Q7M7g7qBW0HpgIS5Lp0xK?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff2de518-5915-4ea6-1752-08db62154bca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 20:26:20.9951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i9ludpvMfrmNt++FEhJ0qZv+cZImQe/Ldve/3FJeLozEkQRn1fS3dfJDBZwtita2Z5w+Lr6nb4AgMYR5S1EIVHB2O6cOxv7DLsEo0RXgpwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5639
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 07:01:12PM +0100, David Howells wrote:
> Simon Horman <simon.horman@corigine.com> wrote:
> 
> > > sendpage is removed as a whole slew of pages will be passed in in one go by
> > 
> > on the off-chance that you need to respin for some other reason:
> > 
> > 	s/in in/in/
> 
> What I wrote is correct - there should be two ins.  I could write it as:

Thanks David, I see that now.

> 	... passed in [as an argument] in one go...
> 
> For your amusement, consider:
> 
> 	All the faith he had had had had no effect on the outcome of his life.
> 
> 	https://ell.stackexchange.com/questions/285066/explanation-for-had-had-had-had-being-grammatically-correct
> 
> David
> 

