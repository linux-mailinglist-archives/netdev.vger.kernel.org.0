Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6BD52EA78
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 13:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347553AbiETLGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 07:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345351AbiETLGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 07:06:54 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2043.outbound.protection.outlook.com [40.107.22.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0595E150
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 04:06:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pg9YhP4Km9i+2eZqCQ+1oBA/QodZUkaapV4pgjKl58PNPvDVquw1WZBt6WkQB81Mgv4/14ndEg0hcXFPXsd25iiO2cNjmz3GBMGdwHs5tJOjJdmpxNqytZN14AxUkSWKMhU6Gw9UvMGpQPbJmUSfc/IXe2YZWvXMf/bpphehN+/FGs0r/7eRGz9wHsC5+1SvdHuLg/LgyiC/qZ0W5ypAVuvDer0NIyFksLIuc0453TSRNa62o39gj1oPx/FLUmgwOHFCs9t67A0pRe+e62UxO6Q9fO1ijBtFrooAXButSkPPDYosRTaU992wo4XhPdWloT/JHQMNZ2tpkzAjZFsx5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdDORfQAk2Hl5fYAdwvnZan57pX8VFY1+33pZho+GC4=;
 b=V/oCTpz+vNVDPy5xegMiYNqQiKvmjqvtOy0fQech+NxuKqHW76s0ppr789ZDX/yILD0J4iH5vJQyl/E6N3DMOhfpTm4Da+w2u9xSHp+EMHhvy/ovmGfyztp13dtiLoOa1dhMOnqC2crVHNPrBa6iOukeNuPxegHkC8FPqm3I0oEAXRBJiW89FtkpZVNYTZLLc+g7waybXJBPK+HuC9nZVOcpiPj4l2yEJkIYVyDoG9XuhFDEneQH4k091DMsu6nNhER87uhnab5f5kyJW27NP6gYp3J9ZyVPZiy/IK/JUb0UggIvWv2BkyG7fo+23lP02NJocqlkjpz0PkPorA6iog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdDORfQAk2Hl5fYAdwvnZan57pX8VFY1+33pZho+GC4=;
 b=UKh+XqpmQQ52t+RxyoKfrg1MwDJ76XlAAoURYsrPyZsUD2nC4csY05qpB7jhR5LFCpRWD9amiYyJYZNQL90PXyE/Ftt+2/V+QEn/eUDFhv05Osw3h8VsAC7rZjf3zRJhgZe5yEAKv8m9Nc2RiNIQ+pE5E1NdpFtnsAk2CfJDPwE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB3PR0402MB3754.eurprd04.prod.outlook.com (2603:10a6:8:6::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 11:06:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Fri, 20 May 2022
 11:06:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Po Liu <po.liu@nxp.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net-next v5 10/11] igc: Check incompatible configs for
 Frame Preemption
Thread-Topic: [PATCH net-next v5 10/11] igc: Check incompatible configs for
 Frame Preemption
Thread-Index: AQHYa+cwuNvk2+V4W0WI+WtiFZXYD60nm12A
Date:   Fri, 20 May 2022 11:06:00 +0000
Message-ID: <20220520110559.p65s3wf2dr4qhjxi@skbuf>
References: <20220520011538.1098888-1-vinicius.gomes@intel.com>
 <20220520011538.1098888-11-vinicius.gomes@intel.com>
In-Reply-To: <20220520011538.1098888-11-vinicius.gomes@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0407c55d-453a-4a6f-a9c7-08da3a50b928
x-ms-traffictypediagnostic: DB3PR0402MB3754:EE_
x-microsoft-antispam-prvs: <DB3PR0402MB37546DA3AD50F779F2D47B82E0D39@DB3PR0402MB3754.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mYQtlssFb6ZbtBbJCxPA71kegYXXZO4YDMzQ5R5ibJq+k4gLykAjHl8ennLiFIULIbqJ3Tc5LmCgvhKe7Gdc32EVZ47WbQY4/IsFZ82ALPe1IvfOp+QPR6q5oZS19Q1cDTn8Iv5ep0NVDVvTRI9ib2JmCLg+kqhfS32Q4/Rc8CPecopJWbL08U7ydqrI8rWt1r3bMp5EfIABS/F/V5tzWj2STMU7DUDmi6NA7UJYx/IRmsetx1mh/p/zIULVNg857CgIeWGSiZ2pmR2N22yaQ2Hna5W0wRrTm5MOmmPaYrNex+iQjtOdM8DoH2+4bIHbccPatnNlmcD9RebrvnlsEHwXseVfT9f0LEKFrptY0CjIGkhYK5wS6s/fPQgktzNNIv7r9FNq4nvh6FsoDXu9FT1994YANKBDRYrx577twN/P7UUw7iLP1eRKgH9w7ZUQmO3l70ocdbM/f2ijzyP+Lz3YfRYkCMcsRzhc+TZJ2j+2YqaRTF5ZWzM/OtFT5fRrmd28u8JpnyRhtky+JjIxSnCTYo8ZONAoWyvTkzrAl06NMUX9o6WL12hiEJX6D5hkTcctEe3380wF+Zv8xhCjJ3zST2oqppzRx7aUtb+bgUD1rStUPUq62IO/6TwGSEVJVcbtMtrr7js+hwBzj9ahDvk8Pp631sMZGtBoCc71XyFyqPyrR1CvB0uuyC4h50qzVfdm/bfpu0iif5wap4oSbeODCxVDF0NZs+oUSAO7A4HS+Af1Yn8JuvlWwJy3NhFD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(1076003)(186003)(83380400001)(6506007)(5660300002)(91956017)(316002)(508600001)(26005)(8936002)(64756008)(66446008)(8676002)(54906003)(2906002)(6916009)(9686003)(6512007)(38100700002)(33716001)(44832011)(38070700005)(71200400001)(86362001)(6486002)(76116006)(66476007)(66556008)(66946007)(4326008)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PXNRMnIloJnZQyAe03XHri1xikGBKpvYStwEATmlwBCjSn8tDc3drUZvwNZa?=
 =?us-ascii?Q?2V1NwrsLoi40AHfiZBGEnJyCY9W5HOucQqhTswWJafDcyPIvF0ftH4NdPgx2?=
 =?us-ascii?Q?p1+ODcFbl9CfJlXhimqQV+bcYu/gxm4vdE7Tn4i1uq2HGwO/ioU5lsr8ebI/?=
 =?us-ascii?Q?3N88r3SiQFwMrJNQxAc0jidMJb80UKj5O9S9WXJT/8oZkmN6Yqfyl/05aS9U?=
 =?us-ascii?Q?j27slc0qdhh6pvxaJR1QtqypdEPrf4kfTvcJ+ljPhsEJTSVDau3w30iST69O?=
 =?us-ascii?Q?HtASWZ3qkfzAyTTf3rDc/AB+QL8/Zg00q/ncVOzNQF0CDi6MQugQRIWjFK5Y?=
 =?us-ascii?Q?tLQDTcKG1Z+KRGfebCtkhft7jysYeJb/PNp2qV07BygrtRsK8eLxs8/Il/Or?=
 =?us-ascii?Q?mYAefuQ1d0LpkQRh0tfJ/kq/O/lp3UTNtYkXihfvJwfFxAi7MG3wJcljIh1d?=
 =?us-ascii?Q?rFk88JzL1iuHdoINwB/Cyjx4tIZZd9BCY/gzcWkYlAgd3Tv5ngGKIMWDfTjo?=
 =?us-ascii?Q?I/x0JoQRdsaVMX1OfHaOXwufRPNpNqrpPzoPQgqtm+ESVyZ+RfTRAVC+BgHW?=
 =?us-ascii?Q?9UiRa4NTpRL5S/XPoeMdBF8qjcW98mFKib/BWDkzfBkH4ThPtEb/ePZ4n9Gi?=
 =?us-ascii?Q?lM/pkvYhyNiDAhDPfCe/6gVfK6QNgBGXvErWdZJf2ES/GHAbKwFbreU96BL8?=
 =?us-ascii?Q?yTt2f18P+64qVhXVuvjLYOgdxGm4cYovmu2ekR/MIcBkWHdef1lrLnVUpMlb?=
 =?us-ascii?Q?46dcm/7ZbtfT0igWlkPIEu9OnYTYCxemlKJziNuNCwucT/4YPvd+hxx/56Z0?=
 =?us-ascii?Q?Tcxi+/mDar1utl1Avq5uIEhJ98JxC0DZdPZSR+TWAT8DXclAUKamQH2EJZ0w?=
 =?us-ascii?Q?nocXOTBLB5/VT89a+BvWm7ckrAgnV19yKQYv7sQUTIdRKQeuE+XHde9q9yLk?=
 =?us-ascii?Q?26GVQ2L7v8rC7MuLPqdXv1J3dXgJyX9+7aiC/ZkEsGo3Ea5AJeW++tupoLfn?=
 =?us-ascii?Q?9pXyQGYG52m4XPxk1jiHDV62Z6sLpSuRFYdtLNSZmx7KI6Xu+uHQ0Fr9NV9s?=
 =?us-ascii?Q?z0UY4opTdTB9GhHfKMXPNFtWpwaNLelpytNFdYea3rKLWfcvqk/7RJpnb1Uy?=
 =?us-ascii?Q?HrAjbyOLMMELxkaFOEiQjdFL93dgqXsEmq95qUbWA694HoP/rSrwWR9FSnni?=
 =?us-ascii?Q?1xWrnt3FnSO+ZqCBe9N0D2AcU+UxuJIZUvFpP3hc/C8dBj81Ukm50IaFE24c?=
 =?us-ascii?Q?ZAEay6xKGQxMgV2D660yP4VSk4hoVAdQVAM5yA+oAI+ney7mG1F63KqcQuTs?=
 =?us-ascii?Q?Mz49mqDD2WnegfQzjcvG2XhHT8DTXL1+Q4NUI7CE+MB5G7GnYKlRSY7wojv+?=
 =?us-ascii?Q?/dTQhH0JSUcNDokj6ov/k8A3JiZJrDQpvdm+DXUr6z6u/mXgs2e6YykCP1mc?=
 =?us-ascii?Q?ltp25uOMS8pI/FCUsmphstSSVoe4SmYbaPEMmpgN61MsvO5dVbV4NYKVH66f?=
 =?us-ascii?Q?osqJynmj8AhP71jcea0lWAhiJSAVAGZC3AbXnLSn8p4O/BZcfE2ZIoqgjmxf?=
 =?us-ascii?Q?vx6lKgRCDrvTb0GNFhm0e2bhiUdsX9xtb1puSLH7xHvE/Ee2xtDay+tj1d89?=
 =?us-ascii?Q?VkKDzm47eY02UT08fnrhKeR1sf3UofyzNrjqj1OEFRhjbk+lVElfhSIjWlBO?=
 =?us-ascii?Q?7buSpMlAT+SPnq7bADDlW2r7UdJL4fDR51bMejLY1zdYpEutpdX8EJs1/pbn?=
 =?us-ascii?Q?M8XDsaBZBMpMwzR8gE8Fn8NbtL1rt/E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <412C8EB8FAE5274F8F26A9B30B9E4F20@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0407c55d-453a-4a6f-a9c7-08da3a50b928
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 11:06:00.4122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +cSkL3LVApTLkEzG6JFzGOotakIsGPpNGZ3epfzNoc2QgDnD6uUosgn4q12BHLclUJjqPHtKmi5QyH2sNPZRIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3754
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 06:15:37PM -0700, Vinicius Costa Gomes wrote:
> Frame Preemption and LaunchTime cannot be enabled on the same queue.
> If that situation happens, emit an error to the user, and log the
> error.
>=20
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_main.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethe=
rnet/intel/igc/igc_main.c
> index 69e96e9a3ec8..96ad00e33f4b 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -5916,6 +5916,11 @@ static int igc_save_launchtime_params(struct igc_a=
dapter *adapter, int queue,
>  	if (queue < 0 || queue >=3D adapter->num_tx_queues)
>  		return -EINVAL;
> =20
> +	if (ring->preemptible) {
> +		netdev_err(adapter->netdev, "Cannot enable LaunchTime on a preemptible=
 queue\n");
> +		return -EINVAL;
> +	}
> +
>  	ring =3D adapter->tx_ring[queue];
>  	ring->launchtime_enable =3D enable;
> =20
> --=20
> 2.35.3
>

I'm kind of concerned about this. I was thinking of adapting some
scripts I had into some functional kselftests for frame preemption.
I am sending 2 streams, one preemptable and one express. With SO_TXTIME
I am controlling their scheduled TX times, and I am forcing collisions
in the MAC merge layer by making the express packet have a scheduled TX
time equal to the preemptable packet's scheduled TX time, then I gradually
increase the express packet's scheduled time by small amounts (8 ns or so).
I take hardware TX timestamps of both packets and I plot when the express
packet is actually sent by the MAC. That is, I measure how long it takes
for the MAC to preempt and to reschedule the express packet.

My point is, if the LaunchTime feature cannot be enabled on preemptable
queues, how can I know that the igc does something functionally valid with
preemptable packets on TX, other than to reassemble the mPackets on RX?

Otherwise, if there isn't any other disagreement on the UAPI, would you
mind posting the iproute2 patch as well, so we could work in parallel
(me on enetc + the selftest) until net-next reopens? I'd like to write a
selftest that covers your hardware as well, but then again, not sure how
to cover it.

Do you have any sort of counters from the list in clause 30.14
Management for MAC Merge Sublayer? I see that structured ethtool counters
are becoming more popular, see struct ethtool_eth_mac_stats for example.=
