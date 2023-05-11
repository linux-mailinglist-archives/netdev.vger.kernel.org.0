Return-Path: <netdev+bounces-1876-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7904A6FF627
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:40:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 118841C20FAD
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B71A6641;
	Thu, 11 May 2023 15:40:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C24629
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:40:30 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2107.outbound.protection.outlook.com [40.107.94.107])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AC14C38;
	Thu, 11 May 2023 08:40:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDcdmlq4T1C/T3jtckb6mApGQ5+kYpmR7PzwQXV8HfAFnlyJgvSgd4PBNO5sLm1xt+TVYn5+5DQD7ncDy9CTcAg7C+c4ZaaG/oC+z0wdNI3u7sk/twPLFtbLGwFy/xcND0CV9/KG3V0CoVcGqxNdomBdq2clWnqDYnhp2a783ta7L58Jt36zZF9gGmz7pVFyG1TsEYbqj8WNy41i1sqrCp6U66LOwhjcL2tUvmUzx1tHY38AkGrEwIZbZXhGzfEkNQXps4KJA7i+9U76cm3UN7puqFvsamrogRFoHgK7b1tWOcqU1EXJxAU7dPelo9h5XOfDJWHwOi6G/Zk8cPVvSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VSetS11EQZm/hfNdaOWfLHQ51veJ4TiUExi/8+wsPzQ=;
 b=NLUfBeeC/IQM6L7/xI6OVGPxWEIhKSmuucNNVVYT7ihmW3CYhhl2m/vHgFYxM9i94hZpLbViI1rvvvpkBq3IMsceG0jAl7b154GAZWnO9yx7WFM5jIJ3Hr/2EnE9wIt2Z5WSuMmP68u0GF9x6/wnpCnneYQ6APbvtlyVE2pgiaz/naYeINZaEvQ0ehvn3ClWOmpjrhUK5ev6NkjBM4I6zu31l5q59OP9s9U3iuAx2Ss3Ta7TbEGQ+ghwyOrg0WXnklYJ2EG8dtYKr+cT+zv7zXI+Rzo8wXNw27iTdTG2XGm18aro3y/+PNZ4D9YNs7OEdHBDv4OYej0K1E58iBqi3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSetS11EQZm/hfNdaOWfLHQ51veJ4TiUExi/8+wsPzQ=;
 b=XVCgW+VixqxZSvzlcS6Rq7QWKS37Owc/lQS2pOFqw8am/f7eX3WbjuxjpJoZmMRCY9Tq/IBCljiUNVPai7IQqR3vdn+RNqWEqHZLU8oItcSH3fWnTRkKXwAL0s3PfQL5vaDbmfOBJsSbkbZpXQ8AbMXN4mOXexazh4Q8N4yw5vg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS0PR13MB6207.namprd13.prod.outlook.com (2603:10b6:8:122::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Thu, 11 May
 2023 15:40:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 15:40:19 +0000
Date: Thu, 11 May 2023 17:40:12 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>
Cc: virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>,
	Harald Mommer <harald.mommer@opensynergy.com>
Subject: Re: [RFC PATCH v3] can: virtio: Initial virtio CAN driver.
Message-ID: <ZF0MXKkK1tEN6QyV@corigine.com>
References: <20230511151444.162882-1-Mikhail.Golubev-Ciuchea@opensynergy.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511151444.162882-1-Mikhail.Golubev-Ciuchea@opensynergy.com>
X-ClientProxiedBy: AS4P190CA0047.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS0PR13MB6207:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ce660de-bed6-4d71-dc61-08db52360692
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nYQK6Y7kJjvBAeZPj2iukoXkfVQVT2As2xWRINwsmA7hS+yIKT9/LC+TNru5ThJilcIXPWL/xGPmsHniKadGQgDhgNNDz7yRLDcJjKGQ5+J78lv4oAV4Fid8IFgoIuWqlLA/GpJqd4lry3vH5r8AhwmIGAePagisaDdwDEuCEgAEtFeXC+gbmifhLvqk9XzevFILYP0CK/qEglJJHH7hzAwrAmqc/8haewsR4aPWD6AOxo1FiEpN437B3Pu28uwW0YFLW41J0dBfQb0UojVdwHNrWUuQbo0wjwkdCmUdY6dTUc87qfkm5iQVeb/M/IYQPPrTbkrL3Bnu4QiZMW3FNcaKhVrY43FA6VPTNGCk/tKIEEh+oOY6AOshbofbAq3y9Ekf5SJXF6IaA6hVxbe1M8zJfcrC8pdOCI8GXtZgfxXKo1SgI5Zjv8ralFzO/tS6TSa0lXEsjH5x+c6NbPy5VyIu8GrscouA0GnIgQv9HZEGUd86/XQClNjnyd2zEUEqK1ArHnmIN8f9wsR8UZL1VvbzkGnqXj2SUJm1Z4XDC40=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(39850400004)(396003)(376002)(451199021)(54906003)(86362001)(478600001)(316002)(6916009)(4326008)(66476007)(66556008)(66946007)(38100700002)(6666004)(6486002)(966005)(5660300002)(41300700001)(44832011)(6512007)(6506007)(186003)(36756003)(7416002)(8676002)(8936002)(83380400001)(2906002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sTRsWK3D2A11DpUU7k6JUGKYqDZjQZU3GkglIU5U8ODs4YIlhTVPrGpxOnHI?=
 =?us-ascii?Q?tOqG687AZMM9LyFJvVY86xkPAWM4uSfbu/7r/X4ru1RXqLP/oYrHh85+Ykn2?=
 =?us-ascii?Q?HOfaYRhoKV4E+YUGzGf7WpyObV0km0yF5Dtl+Dv3CCgQO5GWDUcOfEpkMB8+?=
 =?us-ascii?Q?YHl+7/ObF5aBzZ1s9JdFX0DA+mFowsB+A94GsJAzM3n643M1lWtgCAGK0HIO?=
 =?us-ascii?Q?3Uiit9OMbm9Q3JkfK6l9UvmTNmjUy3eTzbzIySs0vigP9GkJdiM9/r/5QEXu?=
 =?us-ascii?Q?/K/IOlnnpvN0EIvmd0mHSn7JB1bqMP2H1d1N8H+HucR5oo95secc/AftGcKC?=
 =?us-ascii?Q?pubiytoxxanW2QqGb4jXGak3qnxduFVp4/45Fc4I4J5H2P1G8FD5esfQpRva?=
 =?us-ascii?Q?t0+P8AQF6nLTjDBSsfA5GP7/h8UGEzsZDorN/QceACL/adcVoWGQ/C+Cmi3z?=
 =?us-ascii?Q?/R7q+avfxx/OEc0SFa0Ub2nLAtQklVGfSTuE39ChvIwiMpQH+XCNtGmlDUuw?=
 =?us-ascii?Q?VJOpg9TFVMsA4K6SVA06LfthzmXmNaVJM0c6HbTxBMMu/K1FVYGSrKXzR9yO?=
 =?us-ascii?Q?N8/cNe0V2KdOo5BuXFnhKdw3o/JtfT6Yg/A04syruU3GrgbCcCCPvS2N/LjL?=
 =?us-ascii?Q?Jbg6gu5jZ5i1IOFOqT/YikeSLvX8IEJ0GwiR3Qyngjv121i8ohgUjGPfx+gp?=
 =?us-ascii?Q?i+AR9dCUjz6RNsJBaOnDWrOPUpZr9v/RE/Vvd8xYbABoErrDuA3InCJevWvN?=
 =?us-ascii?Q?J1iSykHXEQXDd8wB2ITy9JFTIoVfkBK5WCWkXAGEqfTd9N0uWQJFfei5Fqgs?=
 =?us-ascii?Q?5ZXDNdXcySGUWvQBg+fS1hkUk6PsxZiAM8LryIx680vl3rxXkXMOP1d5nGjK?=
 =?us-ascii?Q?mXyD1pdeOeZnfrJZwlmiVCg7XO+H0SYGlxtmT0QnOWZhQDp+kglwirzQJzrf?=
 =?us-ascii?Q?nyrI5H1JPHhWoEFXtnmr73nzK9wZ2VxxpA1+n6jtUrvh56enfUmUwZhEQZgA?=
 =?us-ascii?Q?0aVlOFjA6ZDrzp5QFrCVrFvraW4XguRTrbCiD8IxWihZCeXLnCp4FLjuHxee?=
 =?us-ascii?Q?+13jLfN0CUqOxASHUhpSQ4E8XK5XDOjz2Dcjt13WsiKjs+oHdNehao9o8kL5?=
 =?us-ascii?Q?h2+Tscl1b8GOBTs7DIJOCuSXkSAmKU+TwjqgjgYNcFeQJekx6GOce38ZWah7?=
 =?us-ascii?Q?V6k/HGZeHNEhX7Ha3UhpEIREVB/7bl2fXfIPBinWb8bL77eQpgTlrAv4MvVj?=
 =?us-ascii?Q?98WNwvA5d1Fq+6GjVEmxRPbAZHnHGtOEDYw1TM0xJKGeNmc2FYO4hE+YTBYa?=
 =?us-ascii?Q?9cg4S2NBn5O4wnQfdusXX/i93xRWIGt4ZG1FaB8rcCnsK3eBmddkSYNVcGFs?=
 =?us-ascii?Q?ySCORRGoaoEJLrCXKijmSGQ7Zigfu7QXjHSjZXjnZpdIuwTYsu5BF9IHZh8q?=
 =?us-ascii?Q?vTt8GkbYnyvAoB2tj/jBRWcTO/wwVJm8E6Rz8eaNGaaGIfZjgHpRCgr7nnxa?=
 =?us-ascii?Q?+hrNWRqB1nzCWxyKN3BCKHeyYfd/mYYhB7WGld8wBn2UbKYj9iQ0L9K0OQfL?=
 =?us-ascii?Q?+myTJw8nDGPT4zVldHBoyTJkkf8legmFvWaBl/3ULCf6fYAdmEdAG/g/8qg/?=
 =?us-ascii?Q?EcV+WG4ne46IBKVw5YP2E1B9iq8gsiCykbT2tF8in325rmTgI8pNRraaTakc?=
 =?us-ascii?Q?TjOG9A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ce660de-bed6-4d71-dc61-08db52360692
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 15:40:19.6673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRuOZwUX64rEDGNX2XJCbIU6YXiHZ3JRoF65243Y6IPS9OCWZ+vApHHpDPHznqDKzm0lfk/e0H1JKZYJ/wQxQGVdhu9188l/QLXvHDh4eHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR13MB6207
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 05:14:44PM +0200, Mikhail Golubev-Ciuchea wrote:
> From: Harald Mommer <harald.mommer@opensynergy.com>
> 
> - CAN Control
> 
>   - "ip link set up can0" starts the virtual CAN controller,
>   - "ip link set up can0" stops the virtual CAN controller
> 
> - CAN RX
> 
>   Receive CAN frames. CAN frames can be standard or extended, classic or
>   CAN FD. Classic CAN RTR frames are supported.
> 
> - CAN TX
> 
>   Send CAN frames. CAN frames can be standard or extended, classic or
>   CAN FD. Classic CAN RTR frames are supported.
> 
> - CAN BusOff indication
> 
>   CAN BusOff is handled by a bit in the configuration space.
> 
> Signed-off-by: Harald Mommer <Harald.Mommer@opensynergy.com>
> Signed-off-by: Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>
> Co-developed-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>

Hi Mikhail,

thanks for your patch.
Some minor feedback from my side.

...

> diff --git a/drivers/net/can/virtio_can.c b/drivers/net/can/virtio_can.c

...

> +/* Send a control message with message type either
> + *
> + * - VIRTIO_CAN_SET_CTRL_MODE_START or
> + * - VIRTIO_CAN_SET_CTRL_MODE_STOP.
> + *
> + * Unlike AUTOSAR CAN Driver Can_SetControllerMode() there is no requirement
> + * for this Linux driver to have an asynchronous implementation of the mode
> + * setting function so in order to keep things simple the function is
> + * implemented as synchronous function. Design pattern is
> + * virtio_console.c/__send_control_msg() & virtio_net.c/virtnet_send_command().
> + */
> +static u8 virtio_can_send_ctrl_msg(struct net_device *ndev, u16 msg_type)
> +{
> +	struct virtio_can_priv *priv = netdev_priv(ndev);
> +	struct device *dev = &priv->vdev->dev;
> +	struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];
> +	struct scatterlist sg_out[1];
> +	struct scatterlist sg_in[1];
> +	struct scatterlist *sgs[2];
> +	int err;
> +	unsigned int len;

nit: For networking code please arrange local variables in reverse xmas
     tree order - longest line to shortest.

     You can check this using: https://github.com/ecree-solarflare/xmastree

     In this case I think it would be:

	struct virtio_can_priv *priv = netdev_priv(ndev);
	struct device *dev = &priv->vdev->dev;
	struct scatterlist sg_out[1];
	struct scatterlist sg_in[1];
	struct scatterlist *sgs[2];
	struct virtqueue *vq;
	unsigned int len;
	int err;

	vq = priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];

...

> +static netdev_tx_t virtio_can_start_xmit(struct sk_buff *skb,
> +					 struct net_device *dev)
> +{
> +	struct virtio_can_priv *priv = netdev_priv(dev);
> +	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
> +	struct virtio_can_tx *can_tx_msg;
> +	struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
> +	struct scatterlist sg_out[1];
> +	struct scatterlist sg_in[1];
> +	struct scatterlist *sgs[2];
> +	unsigned long flags;
> +	u32 can_flags;
> +	int err;
> +	int putidx;
> +	netdev_tx_t xmit_ret = NETDEV_TX_OK;
> +	const unsigned int hdr_size = offsetof(struct virtio_can_tx_out, sdu);
> +
> +	if (can_dev_dropped_skb(dev, skb))
> +		goto kick; /* No way to return NET_XMIT_DROP here */
> +
> +	/* No local check for CAN_RTR_FLAG or FD frame against negotiated
> +	 * features. The device will reject those anyway if not supported.
> +	 */
> +
> +	can_tx_msg = kzalloc(sizeof(*can_tx_msg), GFP_ATOMIC);
> +	if (!can_tx_msg)
> +		goto kick; /* No way to return NET_XMIT_DROP here */
> +
> +	can_tx_msg->tx_out.msg_type = cpu_to_le16(VIRTIO_CAN_TX);
> +	can_flags = 0;
> +
> +	if (cf->can_id & CAN_EFF_FLAG) {
> +		can_flags |= VIRTIO_CAN_FLAGS_EXTENDED;
> +		can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_EFF_MASK);
> +	} else {
> +		can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_SFF_MASK);
> +	}
> +	if (cf->can_id & CAN_RTR_FLAG)
> +		can_flags |= VIRTIO_CAN_FLAGS_RTR;
> +	else
> +		memcpy(can_tx_msg->tx_out.sdu, cf->data, cf->len);
> +	if (can_is_canfd_skb(skb))
> +		can_flags |= VIRTIO_CAN_FLAGS_FD;
> +
> +	can_tx_msg->tx_out.flags = cpu_to_le32(can_flags);
> +	can_tx_msg->tx_out.length = cpu_to_le16(cf->len);
> +
> +	/* Prepare sending of virtio message */
> +	sg_init_one(&sg_out[0], &can_tx_msg->tx_out, hdr_size + cf->len);
> +	sg_init_one(&sg_in[0], &can_tx_msg->tx_in, sizeof(can_tx_msg->tx_in));
> +	sgs[0] = sg_out;
> +	sgs[1] = sg_in;
> +
> +	putidx = virtio_can_alloc_tx_idx(priv);
> +
> +	if (unlikely(putidx < 0)) {
> +		netif_stop_queue(dev);
> +		kfree(can_tx_msg);
> +		netdev_warn(dev, "TX: Stop queue, no putidx available\n");

If I understand things correctly, this code is on the datapath.
So perhaps these should be rate limited, or only logged once.
Likewise elsewhere in this function.

> +		xmit_ret = NETDEV_TX_BUSY;
> +		goto kick;
> +	}
> +
> +	can_tx_msg->putidx = (unsigned int)putidx;
> +
> +	/* Protect list operation */
> +	spin_lock_irqsave(&priv->tx_lock, flags);
> +	list_add_tail(&can_tx_msg->list, &priv->tx_list);
> +	spin_unlock_irqrestore(&priv->tx_lock, flags);
> +
> +	/* Push loopback echo. Will be looped back on TX interrupt/TX NAPI */
> +	can_put_echo_skb(skb, dev, can_tx_msg->putidx, 0);
> +
> +	/* Protect queue and list operations */
> +	spin_lock_irqsave(&priv->tx_lock, flags);
> +	err = virtqueue_add_sgs(vq, sgs, 1u, 1u, can_tx_msg, GFP_ATOMIC);
> +	if (err != 0) { /* unlikely when vq->num_free was considered */
> +		list_del(&can_tx_msg->list);
> +		can_free_echo_skb(dev, can_tx_msg->putidx, NULL);
> +		virtio_can_free_tx_idx(priv, can_tx_msg->putidx);
> +		spin_unlock_irqrestore(&priv->tx_lock, flags);
> +		netif_stop_queue(dev);
> +		kfree(can_tx_msg);
> +		if (err == -ENOSPC)
> +			netdev_dbg(dev, "TX: Stop queue, no space left\n");
> +		else
> +			netdev_warn(dev, "TX: Stop queue, reason = %d\n", err);
> +		xmit_ret = NETDEV_TX_BUSY;
> +		goto kick;
> +	}
> +
> +	/* Normal queue stop when no transmission slots are left */
> +	if (atomic_read(&priv->tx_inflight) >= priv->can.echo_skb_max ||
> +	    vq->num_free == 0 || (vq->num_free < 2 &&
> +	    !virtio_has_feature(vq->vdev, VIRTIO_RING_F_INDIRECT_DESC))) {
> +		netif_stop_queue(dev);
> +		netdev_dbg(dev, "TX: Normal stop queue\n");
> +	}
> +
> +	spin_unlock_irqrestore(&priv->tx_lock, flags);
> +
> +kick:
> +	if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
> +		if (!virtqueue_kick(vq))
> +			netdev_err(dev, "%s(): Kick failed\n", __func__);
> +	}
> +
> +	return xmit_ret;
> +}

...

