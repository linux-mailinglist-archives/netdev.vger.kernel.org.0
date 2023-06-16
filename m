Return-Path: <netdev+bounces-11517-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AC5A733679
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:49:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBD292816D3
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C0819BAB;
	Fri, 16 Jun 2023 16:49:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDF017732
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 16:49:12 +0000 (UTC)
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021025.outbound.protection.outlook.com [52.101.57.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F992359C;
	Fri, 16 Jun 2023 09:49:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1ygrnp6F1CMNAOfSD3+m8X+4K+gO4Wo6Z5vYJZR+gLUFjZkdooEAEPEfTbqeGAdQJ3xKj37eUpzOOOOs4eeS5+Ww1ECp93d8aSH6NcoZz+4BvjGB2pC8S+T/mjDVYRyO4YD7f35/oPfk/QQCf1D+F6oWrPAvzjLXulTHtshDjnndDgvbF8cMi9qp2pu1afkMtcJ+qbA1zLEwU7T9nnvJ++TBc8MbIABPBtcyJYW1D1AuGm+pKKWch9MhOz6Ilkp21oDEDEuyMKvneVZkIRusJpY55eMvhyFQFN9dlp9wr7cJnPv6zib/ZC1bUxm+6SdmVWyCqz/1xegRn/48OWA1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HaRT2ZmL/DkCEpRzvYuoQJWMZX37FrH8bzLYvi0gDf0=;
 b=Bx5a5VogZtmVThDdctSva1XKfVvEFN8Yd981bcpKt58NnPCbKMIo8ecGaIVflA18EKemgvr7h5VhvxbLdwJbHs9+CshDkD0C2KZTg9W6DLoNGGW7laYOCMCMDqd5IoIbHtgdFXN8VMA+OdtfbqUrPDi/K8FlsBz1bahEpbCkCGATntFRPCo/hn7J1EdoVJz7CdeaPa0lacnzvqUxjQB7qYoP1DzyEoHvmvoXzq9nf/a5CSWBZtQr/W2rL9JbP8moLS/6zK+CGGI1Nu+0xEMarJjBZYQ0myrtR09WCBwdb89Uh7/C0vi5yROYaZCMc8BMX2EZTO1Z/64RqG5gmemyHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HaRT2ZmL/DkCEpRzvYuoQJWMZX37FrH8bzLYvi0gDf0=;
 b=Uxuabcb7vKvhj54WK5hubt68RTDUdXE0n9Sfg8F+1HNUaP6k81oE2vlK2PGa74zxnW5jlh3Pd1i5aogXt8lkfT4BGs2PV+5lkDGmJnkG8FMzvCQj1CZ2tAr7tBm2OK72ZcffpXlXgTa8qiHF/jeb1p8vtG1hSzdzEum/v6niCfo=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by IA1PR21MB3642.namprd21.prod.outlook.com (2603:10b6:208:3e1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.13; Fri, 16 Jun
 2023 16:49:07 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::848b:6d47:841d:20ff]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::848b:6d47:841d:20ff%4]) with mapi id 15.20.6500.012; Fri, 16 Jun 2023
 16:49:07 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "longli@linuxonhyperv.com" <longli@linuxonhyperv.com>, KY Srinivasan
	<kys@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
	<decui@microsoft.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Leon Romanovsky <leon@kernel.org>, Shradha Gupta
	<shradhagupta@linux.microsoft.com>, Ajay Sharma <sharmaajay@microsoft.com>,
	Shachar Raindel <shacharr@microsoft.com>, Stephen Hemminger
	<stephen@networkplumber.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Long Li
	<longli@microsoft.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] net: mana: Batch ringing RX queue doorbell on receiving
 packets
Thread-Topic: [PATCH] net: mana: Batch ringing RX queue doorbell on receiving
 packets
Thread-Index: AQHZn+EJeDfOP0yMlUWUrSSBklPfX6+NpMCg
Date: Fri, 16 Jun 2023 16:49:07 +0000
Message-ID:
 <PH7PR21MB3116FB2C7E12556B0007C9BFCA58A@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1686871671-31110-1-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1686871671-31110-1-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d3303894-c75d-406b-aad1-a94f96e78183;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-06-16T16:47:36Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|IA1PR21MB3642:EE_
x-ms-office365-filtering-correlation-id: e8cb4b6e-976d-4ee9-b276-08db6e8999d7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 7yOi3NwcbbiN7hj5M9OJWl2Gf5kQn6QcJjkVeCvjdrOpn13p7zNc+ogZr34c2EU0gXk2QO+wVPcGmkUo7aTy2AnMgKBciKsaC7wUEmEX+oBDhpP3AvHFmunxVx7xrNYAYoNBalNkUxPMBYaUTZ7TjfSSOsEvD5JZ8egA+RztLblMpH5kXt8Loj1eVHZtLTsgI9t3sAn7cb2x41wgjZJHLK7NnHf7Ej/7V3k4uSRjC4Vrw/p/g9Eicipv4rGqZlxF/NzcWt8Vd291kgIVI6HIuOKQn4/kW/ZeTq//TgCZkF2ajAij11KXZNOAEwSHWSm9PBKBIA4wy3Iijx/npsh/aeR2upgelqQ6kOpXnMfw7KJRcbmhJbwhgWrauZYHx320JNSE/YRnL/MPTSpxA7Z4EAHvd3kVpDHvS44YxEmWZimR6hCCVZSC72+U1D+p3vNgnZiq6OBauulMIuvhlVCIWnprdc0zC6tjHLVA1lOSL/KVOtUR1L15Z7ytYDm06Shk8BXeO+plKHw/PuAE1VPoTvr1H+yoMfos0wgwdcXsRTbF6uVpjyTXqo7c/v2VUUxfcu+ZqK83jySW75Swg75d/yXlel7m+DVfvquhmMMUNVLZ+6oKa2mG9lGs88blLLAmwHRf09wmnszRPBs1oHMp29m4oG55wnyhzd+y53/Ou/8RMzvkJYIsOD/SyhIEDXkB
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(451199021)(8990500004)(54906003)(478600001)(55016003)(110136005)(7696005)(122000001)(10290500003)(921005)(5660300002)(8936002)(52536014)(82960400001)(82950400001)(8676002)(2906002)(41300700001)(38070700005)(86362001)(33656002)(7416002)(38100700002)(66476007)(66556008)(66446008)(64756008)(66946007)(316002)(4326008)(76116006)(71200400001)(9686003)(6506007)(53546011)(26005)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?x9i0HWfGPXZ/tEIj3jO9UhTEH94vmyBxoQe9VQ5b+qP+vGRlOexEV8MrLXVW?=
 =?us-ascii?Q?/IndyVchQ368RfUyvNeg0RZvzRrL0QBhmQZHDF6g/uGDzujQesSUMz8fc+Ur?=
 =?us-ascii?Q?jRmaceT36DfJSWYnknckIBHlBVUlMLjAiC7HJfDfmoGRBQ7Uj3rxkIRtZy1w?=
 =?us-ascii?Q?bK2x6JjXL1wPSrA3SFCJE8DJcSWO2TyNUAvIxP5mUut6z7wtNztYMQz2Tm1z?=
 =?us-ascii?Q?6ZcBGHTzJWdtU763bjooHFFgHBtVgnbZdmQAdHaCST317R7ql567QXAJiQxZ?=
 =?us-ascii?Q?yeRJGCPhi6di34QB91HAR85JvF5w+u5Lds8LehoMtCNwT6is/oDOKKFHYaLw?=
 =?us-ascii?Q?eU5ynBo5lJe0231jHmCwGQpHVeL3ZXxWe/n3qogcVOZxus0SgofzQv5zTWfH?=
 =?us-ascii?Q?VV8Hz7TRtguPMvu0DK4uTqpzYbeHT1OyyHvJU53KQsRze15azlINhaKvvziE?=
 =?us-ascii?Q?3tt5EOnzHTqe+UMbCgafP5jlnEMX12gOwnVDmoKkIlUlYa551iyhJ9mXUaJx?=
 =?us-ascii?Q?CU6pJU6FyWPu4XT7I3OkeByxaClwE8GrL6q2ikeJu2L2zbkjqRUC9hgPNoA4?=
 =?us-ascii?Q?XO3IZ0SZqArkF+id1VZzWH3d3z+BQmXbe+UY4i1KH2egkFl1ImWUFoycxb1Z?=
 =?us-ascii?Q?ZEW1FVriUyckB1dwoqPj0DbR7FTAgyBlHYGmGE5QoMNIET76zjvDiFx+EmfE?=
 =?us-ascii?Q?luc/mwToENfOI4ROZNHxQ99645J+hR7ae55pWH/ueUCvD3sVL4Z0G5UXvyCA?=
 =?us-ascii?Q?oJzqbqEn6KidFQ5qgdrv3AmFOjUK3uOuHZtLifh45avlQqThYAjI3bYGz4NM?=
 =?us-ascii?Q?foL/qBgeFYfM5oYsaICwcgtYEuL6ENVOcERuKPRn0KqaCRJhqxFft2E3AnBx?=
 =?us-ascii?Q?7WOixZS/suOLDD5GsXzInU62/lKLszZ/XH4jJLRp5Zu2lMU6bgYU09iq904H?=
 =?us-ascii?Q?S+1sXNQPp3D2ccMxLD4ELsvNXHqyCsMrtEWS1zPxvdBMN/7HIaoKBvbnLN3R?=
 =?us-ascii?Q?Hayu0Sa81hDc5RQP1mUNG1uegoIWaTdYpW16vdpFOf4n6vb4B0qd3zKZrJm7?=
 =?us-ascii?Q?zSXJDt9SFWs3T1A5GqZYtablVIfseMCmrrGUpiplxk5N5eBbNPBpOnzrPi2U?=
 =?us-ascii?Q?1xVxsmrBJYz/S7XE9/Q911nUrJHk959lgkXWTERjo1tixVEGCyAAKqGgqcZl?=
 =?us-ascii?Q?gNRyE+lEfRiiIK8Z3JoBwHrSEDOi7RVlm8C+I28Wx5TxmAbJi8mv8C/vPiJN?=
 =?us-ascii?Q?jvl+36J3vLvu7YZD+Quy1DYYznJoH4nCnF4RzqIxBQPzP3TjATewjghekFM4?=
 =?us-ascii?Q?5RCGrPingU7QLGNl/X71zGnPCrFjulZyi54Eoz36cbff9VtNpW2fS6qrzsF2?=
 =?us-ascii?Q?vvyR3QpDMbrOtgo4cM3j2BFk8nFqaEo69PZ1o474+lmAJqWE5iqFWSeI+QHH?=
 =?us-ascii?Q?l62qQOYu3qjD9ou/+/uMSLfoq0PijdNGGChFCuinnxL+UbR2KCwsGhRR9o+4?=
 =?us-ascii?Q?MQqM/PZCAe81iZhxJWws14tGbW175xNzXjStJnew1aFsdj9H3hvDX4QsldCp?=
 =?us-ascii?Q?0qQqno2CazJIVQybaNB8BzUNC5y/dEP4/eh2dHsp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8cb4b6e-976d-4ee9-b276-08db6e8999d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 16:49:07.3164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uii2TCmq8eg993byIOe7f1agJcdqShOLspyO07SpOt7tbLZjEAqBsJpE78Ba+fkGom2JWYXBzgsDblIi932Eog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3642
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Thursday, June 15, 2023 7:28 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Dexuan Cui
> <decui@microsoft.com>; David S. Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo
> Abeni <pabeni@redhat.com>; Leon Romanovsky <leon@kernel.org>; Shradha
> Gupta <shradhagupta@linux.microsoft.com>; Ajay Sharma
> <sharmaajay@microsoft.com>; Shachar Raindel <shacharr@microsoft.com>;
> Stephen Hemminger <stephen@networkplumber.org>; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org; Long Li <longli@microsoft.com>;
> stable@vger.kernel.org
> Subject: [PATCH] net: mana: Batch ringing RX queue doorbell on receiving
> packets
>=20
> From: Long Li <longli@microsoft.com>
>=20
> It's inefficient to ring the doorbell page every time a WQE is posted to
> the received queue.
>=20
> Move the code for ringing doorbell page to where after we have posted all
> WQEs to the receive queue during a callback from napi_poll().
>=20
> Tests showed no regression in network latency benchmarks.
>=20
> Cc: stable@vger.kernel.org
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network
> Adapter (MANA)")
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c
> b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index cd4d5ceb9f2d..ef1f0ce8e44d 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -1383,8 +1383,8 @@ static void mana_post_pkt_rxq(struct mana_rxq
> *rxq)
>=20
>  	recv_buf_oob =3D &rxq->rx_oobs[curr_index];
>=20
> -	err =3D mana_gd_post_and_ring(rxq->gdma_rq, &recv_buf_oob-
> >wqe_req,
> -				    &recv_buf_oob->wqe_inf);
> +	err =3D mana_gd_post_work_request(rxq->gdma_rq, &recv_buf_oob-
> >wqe_req,
> +					&recv_buf_oob->wqe_inf);
>  	if (WARN_ON_ONCE(err))
>  		return;
>=20
> @@ -1654,6 +1654,12 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
>  		mana_process_rx_cqe(rxq, cq, &comp[i]);
>  	}
>=20
> +	if (comp_read) {
> +		struct gdma_context *gc =3D rxq->gdma_rq->gdma_dev-
> >gdma_context;
> +
> +		mana_gd_wq_ring_doorbell(gc, rxq->gdma_rq);
> +	}
> +

Thank you!

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>


