Return-Path: <netdev+bounces-10068-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 854E472BD0A
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:50:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B0B71C20A86
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA73C18B08;
	Mon, 12 Jun 2023 09:50:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB9418AFF;
	Mon, 12 Jun 2023 09:50:15 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2125.outbound.protection.outlook.com [40.107.220.125])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED5759C5;
	Mon, 12 Jun 2023 02:50:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXDoG7HgKZjECxQV+XD5foQD3O0b03gm0ijT+1jibS/VnqoC4mJrSZzhMKTtM4u8XjaXGTCCWioPdFH9MG5qkG8mQXjaOj6duoEa1HzWVAS9ylgdiRNTcQmgd8Did/lZzhXDiue486lks9O4Z3aHWGlYTVyYm1jhrC5ajV61H9PGhaNOdC57RSihBUXeKmraozuAl6QdJUjY01eVaqpOzTtiwT9x58k6zQJoaj3Ohc5b8ve2RqcLeyDH5n2s4q28aH+iD2hC4gBPgqcWzPMxhYLZoI1BFt4iIUa1LOGuaCmVy92w4Ld5faDULe8+iK9JT/vEWZNczk+nj5WnYOvZKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y+qsI0/KbDSkBlqrT41X2UQPZ+jE42Injv9dBFiMUG8=;
 b=StBMPN4S9qn8G2/ezdk0/n0ma2Pj2onPOyZtAxi9ZRsysUHUdvPH6E26Y66+Vkgv5n6/U/SgBp7dMdcn0I39z3eg4ANYmnLLqWN2WB66vE3bndLYyzI9S519YGWKS87ssyKD3rGgBgSiDPVS+xSQH0mZxImjvrPBb1HdK3gQchgGxpdHboiQ/c9Os5DmwsOmrSJ5h6BWFSf9r7hdrcNu5v++bT0srMuUHEbmfMzLJIfSV0JGWXsbGWayVR009GKuVAz9CkC8QVgG3uiGbJHdHV1q8Q2XGoYqd6xmZWtYZvwASimgCfVaOr4MUR9m+9cfCJGZlOYmbw+3f7AbScatWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+qsI0/KbDSkBlqrT41X2UQPZ+jE42Injv9dBFiMUG8=;
 b=tAEw5UUk6YX7vvhnwCzXrX4UjQ+5s8gUkjh13yW4zCiFhEdS6UZezpP30mSSZ3+09GMTOgQ7Wdjre/j+kA8cMbU4RGWUmh0ZsBt/R9RDgTcboNeMvAI6TrZmqZdM4t4Ao82hJfA+GVDEtMmRsm9SKy1oeHIGjrCSQzbsaOLSwl4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5845.namprd13.prod.outlook.com (2603:10b6:a03:431::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 09:50:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Mon, 12 Jun 2023
 09:50:06 +0000
Date: Mon, 12 Jun 2023 11:49:57 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryantan@vmware.com>, Vishnu Dasa <vdasa@vmware.com>,
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH RFC net-next v4 4/8] vsock: make vsock bind reusable
Message-ID: <ZIbqRXYMbYsdq874@corigine.com>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-4-0cebbb2ae899@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413-b4-vsock-dgram-v4-4-0cebbb2ae899@bytedance.com>
X-ClientProxiedBy: AS4P192CA0037.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5845:EE_
X-MS-Office365-Filtering-Correlation-Id: 67ec92b3-8f45-44c1-052a-08db6b2a66c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nllal47Yx1/rCcD3jHKJEby+jGgsgJwAUOB2kAMH4XhRx41a9KlvxeBKJbfCBXYr7SI+C6r8qCh/FVmJ328LvS3G6TjFLdSP/wmVF2S1f2jXcq6Ch9XAZ+FAZuRjmi5pBIzG258kak+UsvPA6ziUs1XZYtN9SutGIW5tkXL+94sgqx0EyNo4U7kCAJxC7lYM/eM+iue/IZVCh24zsu2HEMsplqbzU82FhSunaWj/n6lFkF68c5ax6EzS1ufRvIk9TtUWtyMJmNOORus1RL1Ro/gdJyCD33ENQzOwFUm58lmAg71vmS8jLkVrJQTce61L0lEPNFh6y2aKdRQpxBnYM3Hs3+EZD0auOxeae04egsf+1ZT8bqnAWESqIw73zTUo3eFvHSRB+mQfw1wYXwksHhm8Qa+4xlPfbD8XBvkbRH7kGH44pt77Bq4vT8MomqckqftOJ1b22MiFlK1U6MVkOctE36G95W4Yq7cJqmj8RQBSFx2FSKTRYKui9CNeOikkoS0YGUvU2c1JWugl+6hb8ZJS1EE/YmiNc0GgdyBkfEzBPupX8R2QDmhsXHRzueaePr94Co4FClbTRHraqT8gutui0xdcOk5b2rGrFVtd9WE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39830400003)(366004)(346002)(376002)(451199021)(86362001)(186003)(83380400001)(6512007)(6506007)(2616005)(6486002)(7416002)(6666004)(8676002)(8936002)(5660300002)(478600001)(36756003)(54906003)(2906002)(38100700002)(44832011)(4744005)(316002)(41300700001)(66556008)(66476007)(6916009)(66946007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2lwW5HCcQLNa/S+M3zGbCXFxvCAKc2WDtM4e7Oc3qbySL/DEMqxFeg5EsTfM?=
 =?us-ascii?Q?dZaXTX57PRvNW7ftYHqZICb7hWUA5kC2VaCY/EPqrjL491QxUtaL1e/x82n3?=
 =?us-ascii?Q?9QB00BPIPW44D8BvFhFGoFAbctUkm+JOPCoGrLR6ZnZZeGeHR79mEs7wTg1J?=
 =?us-ascii?Q?ysxCriSpxUe5sbF/aRE+ZzmKxWJzMfJqOHEszo0Vhl/9nZvJ6RbP/TirQyMo?=
 =?us-ascii?Q?T7svj7gg0GcQcsasZKBkC37GzBTp3hPkLx/B66ohktROCmojwCHA2HYUBcpK?=
 =?us-ascii?Q?dAKCgAAvc/dqlfAEHQ1FIw8ERMDpFRMf+ycduwRhQWKrpEqPb2lKIWgjsZlM?=
 =?us-ascii?Q?qbEjs03XpTWyiT78w4RolGkNfPGEDdTCEpZQVxjMQ55bzzKOIB8v3glfi9BL?=
 =?us-ascii?Q?cG8FEAcQVxYwi66/TmVdoBd79mi1HzGIpfUJzA1mF6dTdwQQRacD+9zc+0Nh?=
 =?us-ascii?Q?GoZc93FXyiJ+BItyYSSgONLnoqw9WZqByRjf0LZTVUdM+MdSm0Hr3uDHdHoL?=
 =?us-ascii?Q?c6hCG6KzrrJ6WcqKH3/hpI4X8qxETTwFTUDIMpo+0mU8p55ZD/iJT4irhBsl?=
 =?us-ascii?Q?DwxDcrrfQ22QQUeh7dTzDE/QoVcmPmrGt364F0xvlyD1dj9GUE9Ndcw22n0l?=
 =?us-ascii?Q?M0ardOrKKR868pir3UyKvYVbZyKaMgFUiv7f3DRWqbAJpqf1IKie8LkbRZRG?=
 =?us-ascii?Q?sSmI8ZIsrSvN5mjPUAyXMrOmcBLVxkwBDpPyYypJ7ZmmwGAfmsN4YgnhGSOs?=
 =?us-ascii?Q?z9wKfiQDrT5GZsvEtX4WIbtSyf3j9AcmKik0MzWNFQY2/2aUkuyLqJL5F/Ds?=
 =?us-ascii?Q?NXH6FwN1EK1CpKt25GW/WRA05MssvvFBC1Ms3OU6RU5ilfeRsmMkWQjynnSq?=
 =?us-ascii?Q?DWLaUSo0OANiQ2xKeiLEhQFSMF9axie5FABGELQ4yIGgD9mhqFvPvyzC00mI?=
 =?us-ascii?Q?L6S8PxlHIi94tLJJwehQ8JWzTwnxiZwrGlmTlmT597HolXnQbFxMvrh6tNUq?=
 =?us-ascii?Q?Z6lS2REAHvo8HVaelASaSLY52ogtcYlfdYxySgrVJHyQWXm0+CyaRpPh5ixS?=
 =?us-ascii?Q?KkV+MtDge3uKK23N3gN5J4TBwGf4268/D56ngfPAqh2gOgdUmhGsbQX5jfEb?=
 =?us-ascii?Q?84Od8dkeWAGqLBSqomhYaVvjvTYiGA0K6ewbyGpiSXM+YYpYx4A0cH03VYPD?=
 =?us-ascii?Q?FCeQJVN3QDNey3TOtW6F02C0sraQ6686Lwy0tviF1Nm88KY7rcxZJ1V6QuxQ?=
 =?us-ascii?Q?Fkd9cBgaN2/Ndu1a+QAeDShdlRNsqwHpQzZmn0kRflXr4nSQc1gwjVhrApVX?=
 =?us-ascii?Q?zvnpZOsPkyo6MB/tklapgzmOXoLYb8o4oKVNo6d2ZXZr38PGNkD0jvR3donr?=
 =?us-ascii?Q?WHA15kvbxcRaR0S00Gqsj/nVBcfDhSZiLCMnSpK118NBy06leLoPJ3eH+HRs?=
 =?us-ascii?Q?STwo/EfrmX4S1N/CrJcyXbUVhVXdC33Dzi8PknfY8LhzsaYXZwSrSS6bU2S5?=
 =?us-ascii?Q?J4TC2112IjdD/cvQF2H4i+D68VUD5hnNh1UN5cNXZDQOEXzp58R4o85u/a2C?=
 =?us-ascii?Q?zEYiSwRWVSGLPmKTA5e6PeYsQun2s1WXg7yK9UgKuI7Yxdj4fkyKGPe2BXTz?=
 =?us-ascii?Q?vrmxC2Q3WGXd8i7qeRDas5vsjfTC1HF7hbBguPIGh8I+cUhbUXPe8O11iXRi?=
 =?us-ascii?Q?xVthdQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67ec92b3-8f45-44c1-052a-08db6b2a66c6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 09:50:06.3106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kCrVqd4eD7bpj6h6/LLn9SaROZmV06Cl5tDV8z3MZZCeAxg2evJ9uSB86bpYlfnHmF74o1GIP5CkBTZ6dp8kN0S7RHY3FoO/Y0uKtECJSTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5845
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 10, 2023 at 12:58:31AM +0000, Bobby Eshleman wrote:
> This commit makes the bind table management functions in vsock usable
> for different bind tables. For use by datagrams in a future patch.
> 
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> ---
>  net/vmw_vsock/af_vsock.c | 33 ++++++++++++++++++++++++++-------
>  1 file changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index ef86765f3765..7a3ca4270446 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -230,11 +230,12 @@ static void __vsock_remove_connected(struct vsock_sock *vsk)
>  	sock_put(&vsk->sk);
>  }
>  
> -static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
> +struct sock *vsock_find_bound_socket_common(struct sockaddr_vm *addr,
> +					    struct list_head *bind_table)

Hi Bobby,

This function seems to only be used in this file.
Should it be static?

