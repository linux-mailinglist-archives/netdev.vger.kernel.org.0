Return-Path: <netdev+bounces-4301-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67FCB70BF68
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:14:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBA411C20A5F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A5B13AD4;
	Mon, 22 May 2023 13:14:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E25C13AC4
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:14:00 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2101.outbound.protection.outlook.com [40.107.220.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5D7C4;
	Mon, 22 May 2023 06:13:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHsHaoQYIUDYds8PWfSKIAD5LRiaHNKzs5+f/reIzjxU/rDp4oQGJGId5zGvC0e0zK1A9XbaRvd3CBCCPZVBjV/lsvcrTTRTdHzRGrbGU5awHmLlrF1mvXK+io0mqWdpehIdtbeiBIP0kvQeiYul3SSOE+vJWaesAhVVYia8ZKrV2UjUKwSBvipkl99KUumlOsOIbLQI1LpC23WrpPtpGIPMgOiOmP4Kx+RrF8QyqHu2ds7T/Lh3+Th1+MAjRvVkF4IOhcSYrQeSVQ9ADCO9T0hjVuhHlhrfLYGVxeZFSrlB1IzokG2ztMxQO1nHImFH3vo1NGBKNhq0+K9tMvE+fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YhJ+DqBuh7hxJ9ire3Jilz3Y/81HN1SSsdL3DdWowz0=;
 b=hl+5Ga+CzrTz75uECOmN6eb/u6VoIHyik+lexFn66Zg/FBETpEgsDTrezQuo792GKWtrYuWkfBufBPMhlpNDT7TzKYOTn8TMmwwo3XnELn/9AIFRGGyAriedXdoIHykRDeQZNuKau2UgjCfYtqXAikNoKDmAZmB9KNlg29FREAfDiKHgHI9dZrXp8MCY01aMREEn1q6z/Ipqma2wzQI7SZ5Kd3xjFMolmCuKP9DqoTjrcZsywWwpxHwgtkAZFlUAXacdggJD/7s6wvfcAnpvwEUOUfDr+teUSc9ThHKTILH2niXTFyXG4juU6fdttUAt1lSqnzGQOS2XQUeeeoQ0Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YhJ+DqBuh7hxJ9ire3Jilz3Y/81HN1SSsdL3DdWowz0=;
 b=LnorRJmhmt7LOpiWEIn+SxBhCtOmlBH9KtnSo2fYC0GlPNoCHlRs6yVB9dniRBIYfiOl7RhpBTtb/W1CpJKPQy1GzpsbGhXcCV/8dLod2MAHPNRzOGOknoZ5nPPuDd78G6IfFWaPmqQk1yX3dl9UPu17VoWb/vVByUOExekO29k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5995.namprd13.prod.outlook.com (2603:10b6:303:1cc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 13:13:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 13:13:54 +0000
Date: Mon, 22 May 2023 15:13:46 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
	oxffffaa@gmail.com
Subject: Re: [RFC PATCH v3 04/17] vsock/virtio: non-linear skb handling for
 tap
Message-ID: <ZGtqijZSCbAsS5D3@corigine.com>
References: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
 <20230522073950.3574171-5-AVKrasnov@sberdevices.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522073950.3574171-5-AVKrasnov@sberdevices.ru>
X-ClientProxiedBy: AS4P251CA0009.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: 72c59bf2-cff9-49c7-f042-08db5ac6649c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DLmv9yU1hzZd6gfgILgGvDIXoBs6AnmFei6BZSKheUr3dpBakLgXG8sU84LYwcLQHJvfwpybNzDqvexRNRljQqhLfeA0vHEWLjXMfOZ0Ob9vFKTfp+5ElL+Rg8NnZho/8faRDSkx4yUI2Ojj9ARdPqLeVwhzZ4BXUii+1Fg/8x4QPcLoVOvN335xBxcUTbbFd/y/72XjsNy1/pIlorTd1a83hgwWj1BhEqPrqsmUN7dhLuBrkSPsnG730h9go36JaeyLKWtFpMPwkEZHugE42DcTGZRWkulsqEemk61HZ/65TAMvk8VILXXO3jHDkkhZY16bz6KrMVwP7EaMTOMMz9b4NMZ0jUzBewAs8lG7QutFrjz88/dnHGHotkeYu0MGNON0kZXv9juv2+E4KQ2dJmilMh0FrHmMgtxn/ZysMibNBhR8XaqBfs3BmPdUpc92fAQrkzmWl0JIjum3jqTzVoBMR+qq2Xa3iMpDbEiY8qiIV/Bk6z8bM468itNiQeFVx4uTYSq4PQnyB5aYB5IfSZp8eoF2vt176tvA3hpsmNjj70vxEsJ/hEjkM9RjWBuM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39840400004)(136003)(376002)(346002)(451199021)(83380400001)(36756003)(6666004)(6486002)(86362001)(2906002)(54906003)(478600001)(6512007)(2616005)(186003)(6506007)(8676002)(7416002)(8936002)(66946007)(66556008)(44832011)(66476007)(38100700002)(316002)(5660300002)(41300700001)(6916009)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/H0/DWcYzYzcVTRfL0URDg5bHtHTwpuWZtOB6Blh0/G4AEjlr0dd0KRWvQgM?=
 =?us-ascii?Q?dIibMNScG5PG+FL6Cf3q1rUL1dt3ieDwuoEfpu9XLRFY6wuP/zUKsIbuuBqa?=
 =?us-ascii?Q?A1EG5GfigwPvD6OwfRlfyVUkRzbiyvOs7rvGm/ghCQgx/Q67nLUD4WEgeRxd?=
 =?us-ascii?Q?Y7DSje/Nti7q96lqyIOs0U4cRtDFmXHVebFPgS9TRlcV3crFWEm+kOxk4+rS?=
 =?us-ascii?Q?hHRft32Q0CUG8NRpEOJPYPe86pvLv+/NDPE5d9jYuvm3sNAKO0lBnGTT+jnc?=
 =?us-ascii?Q?+A+x9SLp+Ftfd5F+GFJIk5aZFGvbRxi5iWwSrbEQlTs6zl5K5NWSwxGpnPKv?=
 =?us-ascii?Q?M3yhqJktUC6ZAfH+OfnEwCpLYNW9exhIDepGggE9Qmx/4/uYI8RleoZRCi8Y?=
 =?us-ascii?Q?RUkxx/2o6WXsBuZiHKS25LjQ3gyqxptQF/ZnPCNam0vrHN4P3+RJimGa8iqK?=
 =?us-ascii?Q?1Sl2V25/vBCR/tktIF41mGFjfV5ebFSuDihLcVpCSBNtYCz3T/bz6/IlSKxR?=
 =?us-ascii?Q?QuCZqhL7qqe1H1Wezgum1gI1YbHPuPkbFw3te/THmwnMT80knuIY78ClsPuv?=
 =?us-ascii?Q?Kx7BrFMz8QsSWPdhE39YWEA9xkv27Zkx4iBM6DBMAHNuivsizMuv6cOf2961?=
 =?us-ascii?Q?O6EUJYAEa2R90xCOs99+Kq2kh1RfAbKqk2IJiw3nzbdutl6n5ZaHrmjDtTGd?=
 =?us-ascii?Q?ugmeDD0PJqNQ+d0eSKTwLrb6Ay2IMWFtjEVn/EcmmZbJKCHx5sD1WJvLaady?=
 =?us-ascii?Q?FL3R92RA4ycPFtZ6ypd7XXyyr8IZ8+sQU11EancjwQgM4Ipw1yLlpJ/oVBok?=
 =?us-ascii?Q?R2KJBhH003VKa5wV5Tsc8iuhnbNaVg8KwIHazwusiKRmnmNYri7WZCvHvKbg?=
 =?us-ascii?Q?dwWlBxwAd1IOpXdgOqnK809J/ung7pvIeoZrXbOrsODoVAWv6hRp4eLRncd8?=
 =?us-ascii?Q?nOHfGL+o9hPibH96vsB/6jqYzAbc1qldB7XK2tpeXEs3OTaReFW0+Gj2RfUG?=
 =?us-ascii?Q?wcXxUNyRaraXQnTejCGJvwPGjT/Y5/bFN1MJk7egf9WD57Owz8HFkUOcyI/2?=
 =?us-ascii?Q?6zVyyz5IWtP4xlcmCxp3nVF9x79CBV8ia/0T9ZNFiWcJAXAn/pIzWc1tPu59?=
 =?us-ascii?Q?LjwgspalFffkyHtZogPvBwfV6mO5HtYrXOkO4jNGYH/wr5dEnpWGCGF3yczc?=
 =?us-ascii?Q?Sdr+ayirBiRIe49YypMwZQeG04LVjEB2I0pNMaBeKEKImp7+dScsheXoc+/B?=
 =?us-ascii?Q?Q2oxPdQbivmPBnAyzseR6qYXAoYAWU6h5mXJJwhmzALeyL+oPAlRx9akGCcx?=
 =?us-ascii?Q?G2N1JbA/U4yNhADHNyJ1N25cce6atNzknws0OnbQH8Y84HQIn9ZlLlRkqugh?=
 =?us-ascii?Q?IrdeygqazDoUw2Edv5G2qsDpoy9f/hDqIOsyFZFQlUGi8dl+373WCgbP7ssM?=
 =?us-ascii?Q?sXscqPMmygdjZsGWLParwWdV4AyQqDaF7+a/Udv4HZKR83JiiN7t/H0ni63J?=
 =?us-ascii?Q?IpJjqdY6/5mWUdnisPdFQRwEP1bZ4jvkDXYIVYtY+BSqMyJWgsaOBhr/izCy?=
 =?us-ascii?Q?QVlzEOyU0slyxTOYUACWfl/b6SskXnA+78ktzWzPOB787rW7UAk/MW5AUA9G?=
 =?us-ascii?Q?mGKJehC9tuQKel0iYVSUzsIIuIpE7WQ3AcVm384qDEdMzab4eINJzHEUCDqc?=
 =?us-ascii?Q?C75Rew=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72c59bf2-cff9-49c7-f042-08db5ac6649c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 13:13:54.2279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RiT93JKZzJJRRij3Oi4D+tBG9L89grc4vkagTJGf+R0pf7urFWT8dqVlWgcWkFEeZrFs59MHEdImEIv7xj5O28L6rEJ6A1LGWRWYj5DGwDg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5995
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 10:39:37AM +0300, Arseniy Krasnov wrote:
> For tap device new skb is created and data from the current skb is
> copied to it. This adds copying data from non-linear skb to new
> the skb.
> 
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 31 ++++++++++++++++++++++---
>  1 file changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 16effa8d55d2..9854f48a0544 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -106,6 +106,27 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
>  	return NULL;
>  }
>  
> +static void virtio_transport_copy_nonlinear_skb(struct sk_buff *skb,
> +						void *dst,
> +						size_t len)
> +{
> +	struct iov_iter iov_iter = { 0 };
> +	struct iovec iovec;
> +	size_t to_copy;
> +
> +	iovec.iov_base = dst;

Hi Arseniy,

Sparse seems unhappy about this.
Though, TBH, I'm unsure what should be done about it.

.../virtio_transport_common.c:117:24: warning: incorrect type in assignment (different address spaces)
.../virtio_transport_common.c:117:24:    expected void [noderef] __user *iov_base
.../virtio_transport_common.c:117:24:    got void *dst


...

