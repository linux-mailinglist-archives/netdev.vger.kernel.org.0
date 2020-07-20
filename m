Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D980226D6E
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389191AbgGTRnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:43:55 -0400
Received: from mail-eopbgr40080.outbound.protection.outlook.com ([40.107.4.80]:9841
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728324AbgGTRny (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 13:43:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYVIzG15YaLDe7iSmUUyAMvnA+CcDM/249d58Sw9KMLwx+N+JcIpfSajEcU3MzMRvbMlfRvcNljQmUEHUtiu82bZ7/mQwbpAXj0ZFnRWnEVDve304xUU5VOzI7KNNnaokOqcyVUg0GBxSneJIDRMji0XhyitNyZkCk72ExFKd6asrtXa8GBUKU0hCuKr3HvKSJ2gWPdi8TGZdcsnvUjm5MC4xThxPP4pIXhVT6pSV3GNCBkgzfoevxFwbasVyjBIl3IhImMivAJJQFc8AM7aDoP9LOrJ6db9WfGIRi9R/P2v7/bBi1QAv4xfciTsa2VbK3P07ISiuOuk/SwFdsfO/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikkzQpq0OV8fYaurt75al3X2TdfiQzzl9NMnOq0a5vY=;
 b=jp/G3n0IHiYhLpG7D672mZLNKHCV5hYIfrwNr2A8IwyIAJKQLd+BhTNr2UXBnmeEax38vssK0Cn+AeFC/z/VXuXP5YN+BG4JYBgQ1OcnBvVBGCXsgsi0N96KKwmX53kqSRJyrxJqCsu5LGRW4ZqcVJ4KFi6Jl8hlTy1v9WJjZ1vmx+y7UXvz3IW6gFuLfnyK1wHeQeGDQ2Hnddbj9sqyBHOLrF611mvttW+a/pv507POWIg8eJJX+uL/jc5wHmgfhEESej0lQSxqUlnKUdS1zOhOsmHJ1krd07MXin5kiRYmOkUWMcCNTKlwhko+4MCVXK+bON3H16iaed/cUh7+gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikkzQpq0OV8fYaurt75al3X2TdfiQzzl9NMnOq0a5vY=;
 b=h1pegrFqkGDTHWv2jIjV7kMgcrA9HhO3fbqECSM2oVgLXXwKrfyVsHp9BlV/+RIXCZb5w+g6THgMo+pKnkOCR5kNvHeMaizvIyPoKN/Yia2K+A6ee0XNU1UXNS3iNP1KujeYBf89ulkEywnv2BPTtCZ4juWA6Sb/ZuxxloAWeVI=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM5PR0402MB2897.eurprd04.prod.outlook.com (2603:10a6:203:95::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.25; Mon, 20 Jul
 2020 17:43:50 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::51e7:c810:fec7:6943]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::51e7:c810:fec7:6943%3]) with mapi id 15.20.3174.030; Mon, 20 Jul 2020
 17:43:50 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Liu Jian <liujian56@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 net] dpaa_eth: Fix one possible memleak in
 dpaa_eth_probe
Thread-Topic: [PATCH v2 net] dpaa_eth: Fix one possible memleak in
 dpaa_eth_probe
Thread-Index: AQHWXpwE6V8KkExdcUKmoWcxzdsQ7qkQvSjA
Date:   Mon, 20 Jul 2020 17:43:50 +0000
Message-ID: <AM6PR04MB397687761B511A8E9ACEA5F4EC7B0@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20200720142829.40067-1-liujian56@huawei.com>
In-Reply-To: <20200720142829.40067-1-liujian56@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [5.14.204.117]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a2ea5c1d-7ffa-456f-baed-08d82cd47681
x-ms-traffictypediagnostic: AM5PR0402MB2897:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM5PR0402MB2897EA6CC68F8E985ECA34C8AD7B0@AM5PR0402MB2897.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t98hs0iTfySGbYCTODxEIuI9JoQSAN43oIAp9fM6WCvhEGstPtY/AM3WNfoPeQNRoQV/7q2PbmGkBFePbDjM7jli0lEUSf3zFALFNrTMZtyiqo2vphCgF2ThfOodnF9QiCDRtvtfQ9OBR98Dt12FK/cLN3+7XbHE4xJ0x3EITRz5je5sVaoW7KsmoPEQYhTOsjGL6LDFblWISqMNoZYR48GpUGe9D+ZLm+wOiHCSXlbzMGFMWoL8Byfg49/WVON0Ew0DsiPykSZjGSmFGfdNeEI9SzvDyrwfCV1pOpPxJq2NL6y/0Q4PjXWHeQZSDzSchKyKDa6j2a7a3PJ250rNcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(2906002)(110136005)(5660300002)(316002)(8936002)(83380400001)(478600001)(9686003)(8676002)(86362001)(66476007)(66556008)(53546011)(6506007)(186003)(66446008)(52536014)(55016002)(76116006)(71200400001)(64756008)(26005)(7696005)(33656002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: CrsqKIiovWIKzIoGCYS0iG3oI588LBwJBMlxt5TpgSDjereZ/u/2ChEWBSPJXUu+I0KBQxhYZhSF+Cbs9lwrhtJ9VI93e3Co6SxMe9DxVFcYN7KeaJSqePi0MfUIhUsSF/aROoL4aaZPU1qbrdZ5kYlbZTccF/VCbdx4Fgc+dESP1vl1Hm1speAbKeIWeMmGaK5fFr4pPokyuKDtzIqopKpSFswO4IePtGB3QX9kvVeD08Mo8Ig5o7169A4J1oQtd22EHkpaLUvnxx6pI82dEgWcd4yrkOqfcMWvgAsvz0CSccMLoyT/qSxca3O5AdBNPgSIcwidtjL3+GGqZw70kUmod4S990y9QE8JUfW7X1JECHNEh1cjxEacdD9F9YUYpeF4cVhRD8PB6MCun2gfcZiFwXWJacsF2GvX0R9MKNSoRbdcBOdfS/Zkb9A/AbJh/zWJ8mboT01ixyy8IePK1U26MnwAyQTpcsormgLgwa8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2ea5c1d-7ffa-456f-baed-08d82cd47681
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 17:43:50.4168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c4qsEVKtmfpndfiuR0aY9TWcd3igby1CPI7ceJ8noqBkLLiJCG1kV8Py0mgLIcH9qrUp/UAB5gSl8mouE5u1sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2897
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Liu Jian <liujian56@huawei.com>
> Sent: Monday, July 20, 2020 5:28 PM
> To: Madalin Bucur <madalin.bucur@nxp.com>; davem@davemloft.net;
> kuba@kernel.org; Laurentiu Tudor <laurentiu.tudor@nxp.com>;
> netdev@vger.kernel.org
> Subject: [PATCH v2 net] dpaa_eth: Fix one possible memleak in
> dpaa_eth_probe
>=20
> When dma_coerce_mask_and_coherent() fails, the alloced netdev need to be
> freed.
>=20
> Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
>=20
> v1->v2:
> Change targeting from "net-next" to "net"
>=20
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 2972244e6eb0..43570f4911ea 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2938,7 +2938,7 @@ static int dpaa_eth_probe(struct platform_device
> *pdev)
>  						   DMA_BIT_MASK(40));
>  	if (err) {
>  		netdev_err(net_dev, "dma_coerce_mask_and_coherent()
> failed\n");
> -		return err;
> +		goto free_netdev;
>  	}
>=20
>  	/* If fsl_fm_max_frm is set to a higher value than the all-common
> 1500,
> --
> 2.17.1


Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
