Return-Path: <netdev+bounces-9058-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D803B726DB9
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:45:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F2951C20973
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9181234CDF;
	Wed,  7 Jun 2023 20:45:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7891D34CD3;
	Wed,  7 Jun 2023 20:45:14 +0000 (UTC)
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021019.outbound.protection.outlook.com [52.101.57.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B3C2116;
	Wed,  7 Jun 2023 13:45:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7fucvbd/j3T4LEBHblzlK3o3oRZIdjc+OFb6MeCCkO9n3bmN8e4oqXl+TRCH1DywKln49vejUMOR3RbuEGIJUpwAlq2oYEFMvYXwl1/S/4CPbh3Lq4UOWwyAXTuAxL8KEbtR0ztiYileXp+nIRVvJON1pbGYI4Xh+4nsjefHW3nRRswy22sHXOP2bsvdWFRNVLHGuUSCckjKM0u7n76/ZclUeauOWyTVUGBn3xyOnuy7ONTUM8KZqZa0T6HwCKoupIwLhoJZX31dWui8ncQBvyPcOwtcDp30H8+rqnDd1brAiES2sNKr/Za75pvdCwTQb3BLgqlUVXrp9CiEPFRiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mzCToldRm6QyJo7ttlBG0MFNm/EzB4pNXBnYKb1Yy9w=;
 b=AMMeHFDpHIzykx88cYz6WWm7WMKyLpJTHS4tbeDjvKQXqqGt26ibZtqkNUvAIocWhyoGxOCYajW+QVbNTk67nqwjam7pZ8graEaSQf/MKPGq9F3pK8uLsOBNHTY4/D3gvhgyZ8VxHP7jrCVbNZNCD57ZZ5NjPzKJ0RrG+9GM1yRjhOg1GSUh14FLabLjExStR0K7IFE44hCnToLNqLVJt+D828cTucLDJMwmC7IJAHvpzcNEG1w3pMZ6k9b8AN2bHvoSLC70/ZyGH+A3YKRZDesez8RJKbLnqHVurCfjKeiSjRPh0Ar9STu0ahX8wNKFBCsjJqDXNGscYHN/6lvolg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mzCToldRm6QyJo7ttlBG0MFNm/EzB4pNXBnYKb1Yy9w=;
 b=aIgLNC2YJxpPvNveIKFQgf8y8LBIPdr5ncrZ0Iuk+dZHnf6HT0oNkf12ctTZztFVqyXqNENypHUBw7jlCpMrv5Ubjm+XLDf/hpelg90JFECCsXOdT0ykkSYeTHGDhmjxFG+hf4TAwV4/+mAN91SGGD6uTWNfvelICEsR3pVEdKk=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by CO1PR21MB1284.namprd21.prod.outlook.com (2603:10b6:303:163::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.11; Wed, 7 Jun
 2023 20:44:57 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5600:ea5a:6768:1900]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5600:ea5a:6768:1900%5]) with mapi id 15.20.6500.000; Wed, 7 Jun 2023
 20:44:57 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Dexuan Cui <decui@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Paul
 Rosswurm <paulros@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "wei.liu@kernel.org" <wei.liu@kernel.org>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>, "leon@kernel.org"
	<leon@kernel.org>, Long Li <longli@microsoft.com>,
	"ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "john.fastabend@gmail.com"
	<john.fastabend@gmail.com>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"ast@kernel.org" <ast@kernel.org>, Ajay Sharma <sharmaajay@microsoft.com>,
	"hawk@kernel.org" <hawk@kernel.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "shradhagupta@linux.microsoft.com"
	<shradhagupta@linux.microsoft.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: mana: Add support for vlan tagging
Thread-Topic: [PATCH net-next] net: mana: Add support for vlan tagging
Thread-Index: AQHZmW80JYA+a2crwEyPacU/TjTjWq9/ziJQ
Date: Wed, 7 Jun 2023 20:44:57 +0000
Message-ID:
 <PH7PR21MB31165940B8063AEE647846B6CA53A@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1686163058-25469-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1686163058-25469-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a85b9271-31d8-464b-b468-5299e4294a0d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-06-07T20:41:57Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|CO1PR21MB1284:EE_
x-ms-office365-filtering-correlation-id: 74297469-7d45-4b9b-51be-08db67980e12
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 kli2tzzzdSFxMoDABPOGq6VMvGcH6qAdTOJc6wqHSOy+k50HcyX0zDOkF9ayuG5+/qL2LYwMnRxVg/SGkk19jNwS4iaYrrWwqH2w9tq4wTKvB+2A6b3wVQVjRlzIkKO7P0xkI4oLE5/AIlF+625jcjuDMXSvsiUH3uwuWmj3fd+2IBPAAsfgeLSOMjzKvw7BJXXbgHtPFeXG+Rmkh1ZfHLF9qbv13EQBDEevcwIJucHcFKzwzmsG7PcAi2sHTp4Bj1lqbyjCXrER8oOLC7DarL8t4HPOtygon2A0gno2vca3DWk+/Y2HdyVcmM/Y0zm051OmKBn+0bvHbKyXJSUM7uXYzh9AMzEike1CQA7wyxu8hH022hklISE5WXXXBlCB2iIqtjSwgkcXKQ86KrLKopjiKvIepfiLKHK2G4z5QkTWAxpHG5Y0GZGiDE4WQzkqsOYWHHXxdSIk02c+zMInw4TGmhTZj5uoo8JBeElGv93rr4PG5wBf/LmUAUUOgxKALLvmcX0AQHhZ0FhdXB+jt8QVrzuL79x+nLvpBmn8JemqIcdrY18ZkhRnvjAr6LmELpVGs1hcRHbSlHbFqYNKipoXES3bV0WahN+bXbEA/oJhld8vOhG4ED4egFdSScRsBOyzS1CGb/TVJhBNXhlX0b0yh7FiY1y0y6o6UMJWvmc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199021)(316002)(7696005)(41300700001)(83380400001)(8990500004)(86362001)(38070700005)(53546011)(9686003)(6506007)(7416002)(186003)(2906002)(33656002)(82950400001)(122000001)(82960400001)(38100700002)(55016003)(5660300002)(52536014)(8936002)(8676002)(76116006)(66946007)(110136005)(10290500003)(54906003)(478600001)(71200400001)(4326008)(66476007)(66446008)(66556008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?urSG8ZAX7VMJrhwaz8+Hz3WbmdrrOvm7Kt6GM44oASPOiw9cxW2bh7dgqhMd?=
 =?us-ascii?Q?WWRnG+ofBzPe7xLMhUfxN8ytnylq0Qbrv6xUUoQ8LFhpbJNv2RGZWL2m6v9g?=
 =?us-ascii?Q?gPHqkBf1nsVGhcLxRGqZf2ufpvN+W4VPXeMOzk7VjT1IYMymhbgYHx3Cqk2q?=
 =?us-ascii?Q?7Wv/wpd7NGBOKRBHhR0vM7dkplrFJZiWsPs5uBU5sMywMspy9+PCK9XN904e?=
 =?us-ascii?Q?E8Y3x7qXPdUM7w5WPvmkoLQazIiSu827PHbEBYLXz2AX7eoADeHZRt0y4NZi?=
 =?us-ascii?Q?Jd4gspImleg6wJqRC6zcCTRK97Fx5DYYEjPmXVk8rf0foRJqymcPlUxoIxa5?=
 =?us-ascii?Q?AyJdTD9OKyeHXvLsyYflfJzu7+wHabP2XcVhWJF31UX/FhUZED+7azxzbJyt?=
 =?us-ascii?Q?hpJls4afkIosSwtZPH0/NNTzNKW9pe+6N4fJ5PgFZv8u6v9QMMzdJ/E+EwdL?=
 =?us-ascii?Q?8aG/CZs5DVIU9Pwpu5JHmc5ZHmV8qUnDkQOBpfcgFly0NF1NU1OcI+E1KSHQ?=
 =?us-ascii?Q?sfARMtfU0ldhsLZ1SNxpQJNbK9dJfgoKJAAxh7pk8Y8qAVn60GdTMVvZ2+r7?=
 =?us-ascii?Q?66sEUe9UcqV5cZGFqFPqDOM2p6phyOISDjZuzefHcfls68cDDoBY4Qbu7H8D?=
 =?us-ascii?Q?1ystruyyjdzfJ8IM8cJ9knc9V/skyIQ6kzyj9Oire7JF61ya3AEDMlGaPEVD?=
 =?us-ascii?Q?E/NiB+Eetm2thphsy/R75Ya0PpoQtxMOZf3B3K6xGm/2/M77t8R3urFsnStF?=
 =?us-ascii?Q?HyOmNIyxFWhZg8k08mwbIvTKcPGHEe0kR5/5zIDgHTW3fMhOGFLGsFovMEbx?=
 =?us-ascii?Q?ua2MHMfDwrzAPvTOLa1gmqwVlvWJfX9f9nwK7xhF7Y/Ps8NYhzFCkTRY2wNq?=
 =?us-ascii?Q?A1JtNxjSkYIYpYbN5aO2htSoI9BaAxmsK56UnB6/bJgXCYpzUQgFBqrRea0A?=
 =?us-ascii?Q?CzL+ClUyBBXQRpEVd46Slk+GQQaGlHnK3ZMMYEq5RySHmnQfLjpr02RJpDeU?=
 =?us-ascii?Q?wSaW/AWMO80Hr8qTWfecr0pFiRBObEOUJHDmvuXbo2rHhwhaW5J4JT3d/ZAX?=
 =?us-ascii?Q?G8X0nPvNEyiR6FCUlIFnsUXXJYRORbBxzhUnA685hHn+wrJP6axAyFNr4nyW?=
 =?us-ascii?Q?O3X6dfcgDY2sh1H7f5lY+zzq1pBu5AJSK14gZYv+fuvIfOlRzn+bRkQlwtsT?=
 =?us-ascii?Q?SKSyYew5nLbM8/sXlR+usrMOWKxqBz8LP2MbQUaOoiSZHkOFQkFF2zk8lq7O?=
 =?us-ascii?Q?Xj/6o+dyWdVlYGzjqq2gmON7d5FE5MXJ3Sdx/ZK0qajaBFcnJHlwuoxjJ84P?=
 =?us-ascii?Q?CwH6P2jVeAQNxRI85Oh54ATjIDoaOlsNCjCk5zMmNMeL5ahkzVXVH2TKlbTf?=
 =?us-ascii?Q?jlmbCsfD17X01gOPWl2V84A/8p+tQ2tF5vst+pYE/CmJhGU3YRz//yhiKm9c?=
 =?us-ascii?Q?CL/JE9WlGBesP1pP3qM4sYGD8ODptjO/D3YIy0ZQ5jpmSCUq3LFGPL21XDuQ?=
 =?us-ascii?Q?ZylDtVD886MFGMf2Vtay9GzfBVWxigPCUYJvLqFUboYZMwzq7Qh3sSQ9VUDC?=
 =?us-ascii?Q?xz7k+lpO2R+gckqDkvYxo4GqGG9O4nIZ0YhvobLxkf2zK9KxyUrz086BQqBc?=
 =?us-ascii?Q?EuPPFRtVCiIOeg1xb96W0u6/5/AvylfxAjqHY7L8w4S+?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 74297469-7d45-4b9b-51be-08db67980e12
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 20:44:57.1667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: puQoMAtQwah02oyyDsMgudWb2AJ0jQWZ7PCD/anM8S1SVrZ5Y9BW2NBP4wHZEAVORuLvGvZsJzl2ucSXeFO6ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR21MB1284
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: LKML haiyangz <lkmlhyz@microsoft.com> On Behalf Of Haiyang Zhang
> Sent: Wednesday, June 7, 2023 2:38 PM
> To: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org
> Cc: Haiyang Zhang <haiyangz@microsoft.com>; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> davem@davemloft.net; wei.liu@kernel.org; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com; leon@kernel.org; Long Li
> <longli@microsoft.com>; ssengar@linux.microsoft.com; linux-
> rdma@vger.kernel.org; daniel@iogearbox.net; john.fastabend@gmail.com;
> bpf@vger.kernel.org; ast@kernel.org; Ajay Sharma
> <sharmaajay@microsoft.com>; hawk@kernel.org; tglx@linutronix.de;
> shradhagupta@linux.microsoft.com; linux-kernel@vger.kernel.org
> Subject: [PATCH net-next] net: mana: Add support for vlan tagging
>=20
> To support vlan, use MANA_LONG_PKT_FMT if vlan tag is present in TX
> skb. Then extract the vlan tag from the skb struct or the frame, and
> save it to tx_oob for the NIC to transmit.
>=20
> For RX, extract the vlan tag from CQE and put it into skb.
>=20
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 36
> +++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c
> b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index d907727c7b7a..1d76ac66908c 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -179,6 +179,31 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb,
> struct net_device *ndev)
>  		pkg.tx_oob.s_oob.short_vp_offset =3D txq->vp_offset;
>  	}
>=20
> +	/* When using AF_PACKET we need to move VLAN header from
> +	 * the frame to the SKB struct to allow the NIC to xmit
> +	 * the 802.1Q packet.
> +	 */
> +	if (skb->protocol =3D=3D htons(ETH_P_8021Q)) {
> +		u16 vlan_tci;
> +
> +		skb_reset_mac_header(skb);
> +		if (eth_type_vlan(eth_hdr(skb)->h_proto)) {
> +			if (unlikely(__skb_vlan_pop(skb, &vlan_tci)))
> +				goto tx_drop_count;
> +
> +			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
> +					       vlan_tci);
> +		}
> +	}

Not necessary to extract inband tag, because our NIC accepts inband tags to=
o.
The change is in the next version.



