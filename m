Return-Path: <netdev+bounces-6853-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D5F97186D8
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:57:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCFF4281522
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05461772B;
	Wed, 31 May 2023 15:57:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE5B174CB
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:57:02 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2136.outbound.protection.outlook.com [40.107.220.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574A1125;
	Wed, 31 May 2023 08:57:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxGKsBtojCQog/FDCCLLSHNTxZiXyEz3dk0amqkl6prNE3AR/8XGvwmfox0XxmLVQRrLDtubnGwM2yVMFpxVEs6fSmLLvt3BTvcKqtdAS86uoheVQBB7sdS2euqnnBI49P71GUkAlzKv9MKnaLa2vuUEqzurqbpZ7qcU6ldka3WrwuxIWhIpGIg0dYsRLGudmLn4EhK+btV8DMkd1/EalhCKAhHiQYxXsYHfr8FMu57o1+g25avQ82r+YZxWdUNQ83f+1vHkXPR3cFzVQTFF/vOQNw+7Cjm8QpwkoTNHY1ccnmBDRyxxWYNPBj2BdReA/lzLOkzVUD6efCa7DVbV3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E/FD03qq7h+ACzK9S8OZnsjtSyuO5WfGZDIRnrcec7Q=;
 b=jBP3XYi1CvK+mzoZoUAaJc8gUHyjkKl0SePwRrz0mRvO/uypSQZv2gjCm8G4igqCTBRq/0NroSxS5Pj0Qhe8/SRWyYKUmcrhiHGmG78vWsY0yFK3MgZ+TOjFVOZ9MGAcrO2H7DrVGd+vd3LDgZ/FEXOJjjHgfYyCU5g25QqPBOcGnSzLTjDUed2M+z6PC7jZAyZTE9wIGkC80jNc4o0AnnOQ8Dj2vS7F3mWgVBny+bboznsLd9bsqc10eJsnuhswHtds1qkouQWXFX1RGHo4v72FZE7OgYUXaaBF2zYlSFokS1HjYDAyDiYkqjpDauS9s/BB7l8opXOyF/2LvnLisQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/FD03qq7h+ACzK9S8OZnsjtSyuO5WfGZDIRnrcec7Q=;
 b=chLyorS3FaWoKOnghkT9jMUupF60SN6dWtlGjR/xMvewhMGiDpEWmqieT7w1Q4X+XFZuWE1OzqoKVqJloqcauTKWR9+Bhf5aW1MAxGjOHVc3bhx7pti0b3gmzT2mUhfGXoXG/JRHXmOw+HFlLJB0q/UzTqRBDINVRkF4ZXRfJk8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB4469.namprd13.prod.outlook.com (2603:10b6:a03:1d5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Wed, 31 May
 2023 15:56:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 15:56:56 +0000
Date: Wed, 31 May 2023 17:56:48 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryantan@vmware.com>, Vishnu Dasa <vdasa@vmware.com>,
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org
Subject: Re: [PATCH RFC net-next v3 1/8] vsock/dgram: generalize recvmsg and
 drop transport->dgram_dequeue
Message-ID: <ZHduQMZG4an6A+DG@corigine.com>
References: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
 <20230413-b4-vsock-dgram-v3-1-c2414413ef6a@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413-b4-vsock-dgram-v3-1-c2414413ef6a@bytedance.com>
X-ClientProxiedBy: AM0PR01CA0106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::47) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB4469:EE_
X-MS-Office365-Filtering-Correlation-Id: 61bf06ef-37df-42bd-be7b-08db61efa917
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zrb8SRr/Bnk/qqsdSXJQnnxhLUlydgIOJI7EJq0Zfn5W/ThQMjUJNU9q5S60MonjJIi7pCnlRHvDWpJBiUVMJqFVmCA9mNAOtEi3t8KPY8dAiZy761Cx0guv8OecpKu9ZYk9pqAPSZczCTMO3ZqJzCu1w7rjUCtdrHEjG6a3cjKLEcmElXGj83VX7A9FHNNW58jpJQsVgy1mPHb9rnyuuLaaWYc5aqFjNuy1t1DMqgBEnH1mnHKqRMxQEoMAvRD2PKkQ7/87OQRn6ff8dfbhauxmpWo7P0AI3m+nKDbSJEP5OjPjEHDeha/GLClVFQcFqVT6AI6qjzq34Bh56tHTdi/M1XosGa4aN6FIKNdQduFaBjrBc5llDIhot30ox7yorQ6dTsBwNGsIzaQBAwr67eLdxxkUJzNpjST9A7G8+4mnd4gy1fYZqZ+Qk8fDAvgISI7ZaCU4309KTIuOB+aAxnfB0A4Gd/FA102HyhwFYLU1xNaJZJRiJ8caqhCNNPb1GvwkE051BCnXy64jGzHmZobtG+g0EMiwDrBuK8dwNg2AUntzGa8Txutfjf8LYH1uRPde6Sx+DmZk0j6gF1Que3egUnWLUqgAfXpX9LjPAxc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(39830400003)(136003)(376002)(451199021)(6512007)(6506007)(186003)(2906002)(2616005)(54906003)(478600001)(44832011)(83380400001)(8676002)(8936002)(38100700002)(6486002)(41300700001)(66556008)(6666004)(66946007)(5660300002)(66476007)(316002)(86362001)(36756003)(7416002)(4326008)(6916009)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wuo7ghWGi+4L4hNbSj6RX+0Bi6yJllK2VbhYVAXjoEz96xiALCQuNtk4bqdI?=
 =?us-ascii?Q?UaTI3Q6rVxzuI1t67FIXbd7t9SqBW+scdwmBhy0WadRoKt/FUsSUvVPW0Le6?=
 =?us-ascii?Q?7GLKbCBxzUvlX7dSNpu7+X+GKkxHBPah7UhR/TUgLMQV2Xdeff363lapLAzO?=
 =?us-ascii?Q?CUiaUJ0iwLlsE0syQry+EU8Mk96u0fmiRn9wcYR4DFuQxWxbV2rLrRIUz5Dl?=
 =?us-ascii?Q?qCPIIGAcKgiJWo35vfrzWny3Zqxxfhs1NAl5vUmYOWkCsV4jLXlIS+k7ZgOW?=
 =?us-ascii?Q?N4UBZDVceESXe58lerussfHUOIpkZ4XUDBxwrZEl2vEjwAgJtm1p/4nJFp1Q?=
 =?us-ascii?Q?Fsi7REMYvCn0YhzPZaupMqBal4jpW3wU/WtLHVBRRXHKJKQ//YCmRrCm/KOS?=
 =?us-ascii?Q?vqQXznXCOyP9NDULz9ItqeelurobN2m54Dc1lXJS5+EPrRTpu16Xxv0SYKV8?=
 =?us-ascii?Q?FXSxARfdSeKwXbReY+K/ro0me1EweSLTF4molOD/VtzHhP8GrVC+DBqdkYQT?=
 =?us-ascii?Q?FTYNDv7JZ29JuNPd8u9AHLICuD9eopwYDNTZY8mbibpOCo0UtzAIW+63fbMk?=
 =?us-ascii?Q?A5x38+7VlFQezRsfBb83PCHYzoISms0YKAlFD6fPN6Z5LAUAR8oI3KirPpyx?=
 =?us-ascii?Q?9PCKcTsXSoRehBOMwxvawQ1E0exwdP+00x7x6qonP6zgfLxCKq8XPy0Ba3H0?=
 =?us-ascii?Q?x0wNb/o7TZpQFnCntELxA+zXjwJ1fa0pKMlpbNgHQdSx/5lneZPlYNlxtKYA?=
 =?us-ascii?Q?KMEHO3eF+Zp6sfrwGDjk0zKeT/NofQtqj6yqP6Cx557ajLxjjALR89sKDNO9?=
 =?us-ascii?Q?8aOOTg46iZiFP1oYoeImj3zgwlxBTIMZ32wkke5YXx+Zru++rY9rLo6hR7yG?=
 =?us-ascii?Q?nVSCr02HwbR5r4SBZ7tVXQx2ySLRTOAt/CcppADpb3SJ8fiQ4lhgPZLQdZT2?=
 =?us-ascii?Q?SDobujmO528k23FsyfdpPhTJ6tFVJVKbVx36KwJku39LnzRxVjsXXoGrLcnR?=
 =?us-ascii?Q?r6cueAFZi2Z075vTnQi8WB2xAXrbIQ5if5y4dXAICqkeEHLCpkbEa/ngwEXD?=
 =?us-ascii?Q?tGVmXKTqkfySIcHJ0UFbNcAAk5OfsqrfavRZocJqrfu5fXSFcsSHUGa7KKw+?=
 =?us-ascii?Q?GbsNfc7Fi00X+OWXYqmcFBacCjTR29b0CVz4gL5MKGNTRmg0BwC2WqhSO9dN?=
 =?us-ascii?Q?iTi4+cJPbYP6im6pY+SxGJS5POi7Vn0yvnoKrBqUrIbFlnU/Af29FOinJIFz?=
 =?us-ascii?Q?gtglC3wOILuWqscUSm2mi/R6Gd1ucH0mkB1Aq/4AtDkb0XEUEiVK5mIWIHAF?=
 =?us-ascii?Q?ZxMU3XSI0PB01vMAcGTL/LdNpNVCCcj+c3Xpa+ItZB8QG0q7L3BpmzjMju/8?=
 =?us-ascii?Q?I+dG8qcRC5c/LGZgKONImmwNignMb+eA1DEUTWWME7B6aTda+8XbPx/6i9BA?=
 =?us-ascii?Q?9Xp51kNctf01ni7KsoqPRuey55RLmMgl1Nxp6HeEyHJ93q3TWx4+vitXW2pc?=
 =?us-ascii?Q?x3LgXr3xyWRqC23tSXnqrU1B0yNFvsmpyjRurPoJeLr0IMPSc7N4WuaPxEQk?=
 =?us-ascii?Q?NgQr0cfYtrZ/xmW5h8qKtiCOyCFXUEoqZgvpRqJ8S7UtDZyCK7PAVqDetEJ5?=
 =?us-ascii?Q?gkIlzKTqjeXjiXlwkHcC+oXsNqK8o6yhmCZA8aPwSetS7dQyokUccys2WVgg?=
 =?us-ascii?Q?PKlKxQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61bf06ef-37df-42bd-be7b-08db61efa917
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 15:56:56.7467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d6YgPNRBMXEqz9MklyI86fQ+PMXec81+NBqGEF44IRwHF7MrwdyDXRrE0ui/u+QTdI5Xa9fgs5hREnp1w0PEG2/EWY9G00KZ6ohROBkrlyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB4469
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 12:35:05AM +0000, Bobby Eshleman wrote:
> This commit drops the transport->dgram_dequeue callback and makes
> vsock_dgram_recvmsg() generic. It also adds additional transport
> callbacks for use by the generic vsock_dgram_recvmsg(), such as for
> parsing skbs for CID/port which vary in format per transport.
> 
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>

...

> diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> index b370070194fa..b6a51afb74b8 100644
> --- a/net/vmw_vsock/vmci_transport.c
> +++ b/net/vmw_vsock/vmci_transport.c
> @@ -1731,57 +1731,40 @@ static int vmci_transport_dgram_enqueue(
>  	return err - sizeof(*dg);
>  }
>  
> -static int vmci_transport_dgram_dequeue(struct vsock_sock *vsk,
> -					struct msghdr *msg, size_t len,
> -					int flags)
> +int vmci_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
>  {
> -	int err;
>  	struct vmci_datagram *dg;
> -	size_t payload_len;
> -	struct sk_buff *skb;
>  
> -	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> -		return -EOPNOTSUPP;
> +	dg = (struct vmci_datagram *)skb->data;
> +	if (!dg)
> +		return -EINVAL;
>  
> -	/* Retrieve the head sk_buff from the socket's receive queue. */
> -	err = 0;
> -	skb = skb_recv_datagram(&vsk->sk, flags, &err);
> -	if (!skb)
> -		return err;
> +	*cid = dg->src.context;
> +	return 0;
> +}

Hi Bobby,

clang-16 with W=1 seems a bit unhappy about this.

  net/vmw_vsock/vmci_transport.c:1734:5: warning: no previous prototype for function 'vmci_transport_dgram_get_cid' [-Wmissing-prototypes]
  int vmci_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
      ^
  net/vmw_vsock/vmci_transport.c:1734:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
  int vmci_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
  ^
  static 
  net/vmw_vsock/vmci_transport.c:1746:5: warning: no previous prototype for function 'vmci_transport_dgram_get_port' [-Wmissing-prototypes]
  int vmci_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port)
      ^
  net/vmw_vsock/vmci_transport.c:1746:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
  int vmci_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port)
  ^
  static 
  net/vmw_vsock/vmci_transport.c:1758:5: warning: no previous prototype for function 'vmci_transport_dgram_get_length' [-Wmissing-prototypes]
  int vmci_transport_dgram_get_length(struct sk_buff *skb, size_t *len)
      ^
  net/vmw_vsock/vmci_transport.c:1758:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
  int vmci_transport_dgram_get_length(struct sk_buff *skb, size_t *len)
  ^

I see similar warnings for net/vmw_vsock/af_vsock.c in patch 4/8.

> +
> +int vmci_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port)
> +{
> +	struct vmci_datagram *dg;
>  
>  	dg = (struct vmci_datagram *)skb->data;
>  	if (!dg)
> -		/* err is 0, meaning we read zero bytes. */
> -		goto out;
> -
> -	payload_len = dg->payload_size;
> -	/* Ensure the sk_buff matches the payload size claimed in the packet. */
> -	if (payload_len != skb->len - sizeof(*dg)) {
> -		err = -EINVAL;
> -		goto out;
> -	}
> +		return -EINVAL;
>  
> -	if (payload_len > len) {
> -		payload_len = len;
> -		msg->msg_flags |= MSG_TRUNC;
> -	}
> +	*port = dg->src.resource;
> +	return 0;
> +}
>  
> -	/* Place the datagram payload in the user's iovec. */
> -	err = skb_copy_datagram_msg(skb, sizeof(*dg), msg, payload_len);
> -	if (err)
> -		goto out;
> +int vmci_transport_dgram_get_length(struct sk_buff *skb, size_t *len)
> +{
> +	struct vmci_datagram *dg;
>  
> -	if (msg->msg_name) {
> -		/* Provide the address of the sender. */
> -		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
> -		vsock_addr_init(vm_addr, dg->src.context, dg->src.resource);
> -		msg->msg_namelen = sizeof(*vm_addr);
> -	}
> -	err = payload_len;
> +	dg = (struct vmci_datagram *)skb->data;
> +	if (!dg)
> +		return -EINVAL;
>  
> -out:
> -	skb_free_datagram(&vsk->sk, skb);
> -	return err;
> +	*len = dg->payload_size;
> +	return 0;
>  }
>  
>  static bool vmci_transport_dgram_allow(u32 cid, u32 port)

...

