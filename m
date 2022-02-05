Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3A04AACDD
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 23:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbiBEWcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 17:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiBEWcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 17:32:48 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eus2azon11021021.outbound.protection.outlook.com [52.101.57.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026DEC061348;
        Sat,  5 Feb 2022 14:32:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8XYdvRopimFUMAaz4fqm9qwEKutlGqm/JTWCFWQO2SMqZyx6hZBkSNL6F8lXF3E1auAvO/Ghz7oGLBQCI3oYYcMOjGYwAVdSVjKwSQVSzCGCc9GqCl+hCFJxBTIyssbLIS02BxVd+vRqJWSvnszbniHVf7Ly59Aqk9sIPkjjfEP/nzToJE02jmBC6FC2nJ2uymbPwF36+ZW9b597sJj8QKuE1O9spthCMUcsDvJiMQmMr0NSBBCz6jRakjgZlFIgv9yvn5WMmvXdqliZ+ENUz2z7QTHr3QK+J+/plgiLZIQEGHH/IY+oaBEVHuQFc2mZQ5m488eODFfnSFxFgVFQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ctikg8/9jd+hkvHsSXMj2nTWjJfJaQ0LYhG4oV9SF8w=;
 b=n3lq5hzdZUHKJ3l9AsLD2Q8qkK3urpEUXSPqCc/mNQfZFph98LKcbKStNbnY0+UEmjx/4RWtChBb/a4tOtvM14FybqIiES31U1vYl0VxdDtLMPgpnwR6b6XCgE7SlBE2S8zeyWhTbxTyoZMWBFq7+mRcNwcgmDBQyup68LnodOC7ZT5IV0lS8O5VXRUs1BIbBkAtT/2UngLY37rNoXYnmCrxDv8WYeICZNFiH/SrDyHSgNom3P8Xf8P1QlstydAn1tLIfnVgvjDWyPa9JSIxQ+yp21fzOMPG4lJi0A+mZc2RqlTTbrnZcMPS1h03AX4O7rfREjPPAWMSie+qFaqjYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ctikg8/9jd+hkvHsSXMj2nTWjJfJaQ0LYhG4oV9SF8w=;
 b=ZhTBpDsfvefbOZtG+VOSTaF7rp1FxcevMoQpM5rr8FanYAVB2O+weTD9R9Jzxogj9vJ3Bafk1gN6CXUoo5sGydrD2akesCzusTx4vh3aBr0v1RjcXsN9UtUawekNKW+2+gX8khF8TdHjw9A2d6zB8VXW8coTk1Vee10DV3ub6kA=
Received: from MN2PR21MB1295.namprd21.prod.outlook.com (2603:10b6:208:3e::25)
 by BN6PR21MB2096.namprd21.prod.outlook.com (2603:10b6:404:bf::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.8; Sat, 5 Feb
 2022 22:32:41 +0000
Received: from MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::e081:f6e4:67eb:4704]) by MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::e081:f6e4:67eb:4704%5]) with mapi id 15.20.4995.002; Sat, 5 Feb 2022
 22:32:41 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        Shachar Raindel <shacharr@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next, 1/2] net: mana: Add handling of CQE_RX_TRUNCATED
Thread-Topic: [PATCH net-next, 1/2] net: mana: Add handling of
 CQE_RX_TRUNCATED
Thread-Index: AQHYGhkbwj/2soN83kmQnCFUF3LCRqyFiqLg
Date:   Sat, 5 Feb 2022 22:32:41 +0000
Message-ID: <MN2PR21MB12957F8F10E4B152E26421BBCA2A9@MN2PR21MB1295.namprd21.prod.outlook.com>
References: <1644014745-22261-1-git-send-email-haiyangz@microsoft.com>
 <1644014745-22261-2-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1644014745-22261-2-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=82058302-ca3a-4026-b401-1efc94bff52f;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-02-05T22:26:26Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ac4442e-aefe-4a9f-444b-08d9e8f76bc0
x-ms-traffictypediagnostic: BN6PR21MB2096:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <BN6PR21MB209623CA2E6D1101222345F7CA2A9@BN6PR21MB2096.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lC3Fnt//6tVsD10wtxFv1tWGICvgTZ2IcLQcCIPQYJOk+T5/F2hv0vWGjFRy3x1G9Hg07Hjn7B3XJPFgbTlp7kxbc3XVZsPKTeLQ7aOycHREq7+hKCGq+x0IB3cCCNz6Vzrkaf/45vxrfplLaFl6ivDyNBu2jmEjjTnBLr8T00FgGIB8eAs9pxwvKbwg7cQKn7eIk1Yhm50ooZLAYzLB/n52oMi4/yoF02ABGWtiolBz84s9Ru2DLfPpMLqJYQWr9oH63fq79itkqffu2PdDX6agmciGFbq/e4wljcuu1GaCfEovH0SaSVTudELUIIcs5gn3G1sPJ+gdm0JYIC5xXYVUJSkdytTjDQd8d1UtElLVtC/oC6lshwyGr2nwS69hXOpyiixdmR1Kd5d17NlXs/Pw9bHUshTnp0Wf6YSaydvXSSTqFaOTYL5BGHdg7lFNQHrkonS8UNKaBGh+l0t7FZu5I7Ppbf4cOP23ElwOwYtR2Nx7sgrA6k1ucFoYC4vc0Gv3KHi+3s9PsWwjcq3zwOY2wCJG3n7ef4aUmT3Otc0SUuiHeI+pxnbJbiyp0ty7hfbOa89LoCiuFlFyl/zpekhQI/zFwUq49h42iDfZmnFPoX01ZXfkqHcQDfXLpuwQnbbEMffD/z/ttRIWckYeQJtsGppeM0MvjGN9rQGUiO+XLp20G0v5wiNoVNIrCz1q6OusJijBtuh3KO/1GVLq44m/c3CvIDbKOilaf8Cjf1AsU7YqUo2FNT2EI0Ud5eoY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1295.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(10290500003)(8990500004)(82960400001)(33656002)(76116006)(71200400001)(66946007)(66446008)(8676002)(4326008)(66476007)(64756008)(8936002)(55016003)(38100700002)(38070700005)(110136005)(52536014)(186003)(9686003)(2906002)(86362001)(54906003)(316002)(26005)(122000001)(6506007)(66556008)(53546011)(5660300002)(7696005)(83380400001)(82950400001)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?whc3HmluAEdeIGsg0wmCO6scMySHM/eOTXl1AkUdDC9yZL2c/3azfiFpopyv?=
 =?us-ascii?Q?rcw64C0KSeWXFwqQ3Ff/SzrCfk63zlvXLfcCIuJxRMR+OL3mhbd0QCgiluch?=
 =?us-ascii?Q?SMn5xcWI+NejEz/O0gSLX7Wx+NzwN8a7FPErj0xkCJ1PA9prLia1q6jmT8sc?=
 =?us-ascii?Q?rnRa0sbLy8SKFy5QLgn1t0E9gfKfDgOQeM1SZPvqai4j3yHOwHH9oOt46h17?=
 =?us-ascii?Q?15dbAEOFIbW64VIcO016lQKlFV1rNJGGb21EKzjYtnyyKhyE55TVRuHta3Lx?=
 =?us-ascii?Q?wnTZ2HvUKeZo8akyCWBv42NypOhFBY1FrHnhILlca/Y8KBSCqg4gdTVokv/D?=
 =?us-ascii?Q?3Cgo8xUGyNBawztByICRoLZKLGvyNjZ8ARcIuSkNqtjFuUbP80sAZ5s+solB?=
 =?us-ascii?Q?IyWoImCg3BwicMIV08U2hLH5t42j5LjQrGywaa9HHNAVXVtsSaBzy7Jov23l?=
 =?us-ascii?Q?xWFMEGMVEfsQXYoLUmu0bL5ChkyMkHC39CfHkHvG6rbKknQobnRTVjSSvt09?=
 =?us-ascii?Q?4Q70Xz2O1BvhGo+100sQ0eYMj3NlgCw30M6ISM5HG3A7hP1qkXafF4zb2qxI?=
 =?us-ascii?Q?CFIiEZq7i6ZP3bUFq5xM1r32Zp7ksH1D9Fg3kEBB7un4d2sxK66UmHOyvmTu?=
 =?us-ascii?Q?69yZfq0znT3nD6EH9TZ9Ox054bNaubuJjR2Mmj0g6Tha4pDjhol/13ORclSR?=
 =?us-ascii?Q?foRoKwRfwcrick4ux6YkMON+QRyuDtD9lZp81ZP8hso6Cr0tmzq79EXF7LXj?=
 =?us-ascii?Q?IflU8l8/zCpeWZgma84NNC62y0zDIVzpNAFzzrkAsTLLy3dHQN2qo/OxIugP?=
 =?us-ascii?Q?2I/YpuwQxwLFgWKVAnP12lqC8h43hDv8vy4jBszBf6iirvNgu9omnUnLFRF1?=
 =?us-ascii?Q?7ZtMuH05xiwzAFJsJUh0yPXLoJdcJ1HhMeRJRWISlHJXHRYygcucQj8X7wFD?=
 =?us-ascii?Q?Hl9onIR2rEF5OgsWLDiiby35ArrADbwLvYxHVEr59pqtFznlaFq+P8omkTkn?=
 =?us-ascii?Q?z3JzEwKcmPhEPW/nubKQrJ4Imudsu7Fy0bqJ39dlx06XMG9zTn16bGL3jxzJ?=
 =?us-ascii?Q?jYh6FPSrSzubIVSJGdBJIKtL2KegjSqj9ZNsn8I4PW8Ia1Z2g+zpWmgMswgt?=
 =?us-ascii?Q?VsQy17cNQ9nO0GqaKB/uddwZ1GnA8Ey/ja0guPgvejaxpGQHHZ/ekOXY/y69?=
 =?us-ascii?Q?f9LvZFrFbsbmfpHTACUOgp6bVyPklHWUnlRl2LZSdhnHHcuQI7+JIED+9jb7?=
 =?us-ascii?Q?TR5TfkYFTAeNW95AdHZC/rARMtR1k2lTJiwtLbTJVg+AjQmD9bdkmgN+x1on?=
 =?us-ascii?Q?dvdfsBKicheU8jHl6D+9lXYJbKDdaa6LPYoZAYXX+tY4smoZ8Bbp623vtaan?=
 =?us-ascii?Q?Jej0dptpit/I9nndl/z+DG0YgBVTjAvX0hZhSzyZA0zBoqDmLNR2OmnczpBg?=
 =?us-ascii?Q?aPfP7MaqxPhEGgR/WhivyX3qYBQDMNSUOZY8GC9N/j4urnUIBAuGiyZrYYlG?=
 =?us-ascii?Q?wVGoAOD1LaDGAlYfSAwoOBu2ODEbnSThHUR/WOHuBVBRdC47umqRlVyPD8NG?=
 =?us-ascii?Q?LIrLGRqhd8oJS24A43ySSdrIaaZkhKZHOGxSWuk+vb1sDFaP+wQl8NuoYYrh?=
 =?us-ascii?Q?Dw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR21MB1295.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ac4442e-aefe-4a9f-444b-08d9e8f76bc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2022 22:32:41.0614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eLTileNiKyVF7bxmOvv/b5RiBHcynHtZD4rBM/OfAIFk8ydKmO2nxYX0KyaMyNj+l/5D8dNFMHCz27i2atwldA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB2096
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: LKML haiyangz <lkmlhyz@microsoft.com> On Behalf Of Haiyang Zhang
> Sent: Friday, February 4, 2022 5:46 PM
> To: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org
> Cc: Haiyang Zhang <haiyangz@microsoft.com>; Dexuan Cui <decui@microsoft.c=
om>; KY
> Srinivasan <kys@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com=
>; Paul Rosswurm
> <paulros@microsoft.com>; Shachar Raindel <shacharr@microsoft.com>; olaf@a=
epfle.de;
> vkuznets <vkuznets@redhat.com>; davem@davemloft.net; linux-kernel@vger.ke=
rnel.org
> Subject: [PATCH net-next, 1/2] net: mana: Add handling of CQE_RX_TRUNCATE=
D
>=20
> The proper way to drop this kind of CQE is advancing rxq tail
> without indicating the packet to the upper network layer.
>=20
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c
> b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 69e791e6abc4..d2481a500654 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -1085,8 +1085,10 @@ static void mana_process_rx_cqe(struct mana_rxq *r=
xq, struct
> mana_cq *cq,
>  		break;
>=20
>  	case CQE_RX_TRUNCATED:
> -		netdev_err(ndev, "Dropped a truncated packet\n");
> -		return;
> +		++ndev->stats.rx_dropped;
> +		rxbuf_oob =3D &rxq->rx_oobs[rxq->buf_index];
> +		netdev_warn_once(ndev, "Dropped a truncated packet\n");
> +		goto drop;
>=20
>  	case CQE_RX_COALESCED_4:
>  		netdev_err(ndev, "RX coalescing is unsupported\n");
> @@ -1154,6 +1156,7 @@ static void mana_process_rx_cqe(struct mana_rxq *rx=
q, struct mana_cq
> *cq,
>=20
>  	mana_rx_skb(old_buf, oob, rxq);
>=20
> +drop:
>  	mana_move_wq_tail(rxq->gdma_rq, rxbuf_oob->wqe_inf.wqe_size_in_bu);
>=20
>  	mana_post_pkt_rxq(rxq);
> --

To netdev maintainers:

Since the proper handling of CQE_RX_TRUNCATED type is important, could any
of you backport this patch to the stable branches: 5.16 & 5.15?

Thanks,
- Haiyang

