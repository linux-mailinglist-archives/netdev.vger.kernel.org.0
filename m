Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7909C120908
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 15:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbfLPO4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 09:56:39 -0500
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:5179
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728008AbfLPO4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 09:56:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U4xhnsOcTEM3k0G9fJ04jAGxZItUeVHutKv6jljj5Ffa8yMW+21YuLCbWADwApBO09XtVwqJ20IvDQGKS//ILtzITP8XpcQN1lBs/PqXPQ26qaIRgFek1eV/EanWpiJikCjc3d8GbswrRjBdYcTDmRWm2keRu60LkpR0yAMb72kYy/KBN0ameqIRgtoYv99Ti8mBz15OhX/SqoDGEl9OmjObTyH5SfC0PBw7GJDnmQqU55sWdfzYDRttnsgWiEbWimxOWq66QQlXxAiEp4tPFUEUgYa0HpfivadKRMO+S9muphFn45EtHGSggvXiC/wzIAvppfSEIs0mrSs/1ffAhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBvs46xgWWdN05u3ZFeGgG93Q6f1WHn9ptGyfId3DJE=;
 b=Xu7dm3URqt8B4fw9vo+0U0R34R0wdtSOdD1MxdwVLjnB+ONrpyPBDdXy4Q75/pK+Jra6b502XN3n0yEdJAEVXSf9gKUG5uxUjkjSko0Zp3Y7ArmH5hk8UqGC+7jiJuilT1Fans7Im1NyFEa6f/Zat/1DA3FgZguOJRRB/t/jrsIExG0efbCAJIQ3w8riaDELY/TiU9CF+/zCfyJIkUN/nIMk1pDgyxolUuZxkDIP07eZFgZMOddWKZ16+s5fC2ZHNBsZcy1iHSqj/ipkxse84d8nwLzia2eMFbU2wqG1tjiHMzhZ1ZYsV1vz3G6OTLUuH7lbZcEKE3BzkccrA9q7Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBvs46xgWWdN05u3ZFeGgG93Q6f1WHn9ptGyfId3DJE=;
 b=kPlgFCTTJA0FuIcb1BjKE8hJaFUnS/nWwgufBLMjN/qXafrN3WerlVPRjnEk6WnjSHxUD98Hq0bibmKNopmnx53pd6+H5JqGZehGyS1aOtngxmH1iSo8C1SioGnHejZL28y0Nkyo4TXPvYDHEEdCclNAk3zH2p29AMoXAapEYSY=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2720.eurprd04.prod.outlook.com (10.175.22.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 14:55:52 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::5cc0:798:7cb8:9661]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::5cc0:798:7cb8:9661%11]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 14:55:52 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Y.b. Lu" <yangbo.lu@nxp.com>
Subject: RE: [PATCH net] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
Thread-Topic: [PATCH net] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
Thread-Index: AQHVsZzeTOmGzp1q7E6r6qYw9b889Ke6ri+AgAIwBLA=
Date:   Mon, 16 Dec 2019 14:55:52 +0000
Message-ID: <VI1PR0402MB2800732700E97A1ECB98202EE0510@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1576231462-23886-1-git-send-email-ioana.ciornei@nxp.com>
 <20191214213005.701756d0@cakuba.netronome.com>
In-Reply-To: <20191214213005.701756d0@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c44ab15e-0c80-4ead-36bb-08d782380bc2
x-ms-traffictypediagnostic: VI1PR0402MB2720:|VI1PR0402MB2720:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2720D52BD48DE2FB007FC5BCE0510@VI1PR0402MB2720.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(199004)(189003)(2906002)(6506007)(5660300002)(9686003)(44832011)(6916009)(45080400002)(66446008)(33656002)(81166006)(7696005)(71200400001)(66946007)(478600001)(186003)(316002)(55016002)(54906003)(76116006)(81156014)(4326008)(52536014)(8936002)(86362001)(66476007)(66556008)(8676002)(64756008)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2720;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mQcIK69GQZspmdNfT6yGtQ1PPjP9r4acsDJFqiSFrmkFXr0uUwVzkFbz4KdccQaEE4z88KgLCO7pDowLE01zbXbsSZpQB/BUsKVh8AF0CG/i8lJa+CT91qQLmHyvTSUoRaXC/UyHFTT9b2JSlWk9osLBFAIbV1f2A53mLG3YIzNtImlUa6iPBH+DlJbCkl03iNIk8Ga5wf5rrb0ak4tPMqJYORM3Oro+nIh3ghiv/6n332isK6bnix/bvRmjqRnacq31xI2MOmjfLJuNRAG4BnQHg7Ucik0peJpyxwLBuPvaNuegB3M0la4Xjr/QQKnGB97cAub4mA1hcVF6vfArR+FNJ9KYlutp1HxNqudTkLp/3H06z7DClnyJHg0v/t2sG4hX7ZKuT9SMHrnHXFzzCGHdBor19ZpEXDmO54YKnTAYkpnhNV/TJqsNQLYx1WYv
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c44ab15e-0c80-4ead-36bb-08d782380bc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 14:55:52.2351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ugOJ05bwVwxcxkj3LrlDMZHFikWKMK1gaLB5xdUFxUsRKJfZKSeRfQvzFoLvo5+gBg7VD+Cl8rccxvhuwKZyZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2720
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
>=20
> On Fri, 13 Dec 2019 12:04:22 +0200, Ioana Ciornei wrote:
> > Upon reusing the ptp_qoriq driver, the ptp_qoriq_free() function was
> > used on the remove path to free any allocated resources.
> > The ptp_qoriq IRQ is among these resources that are freed in
> > ptp_qoriq_free() even though it is also a managed one (allocated using
> > devm_request_threaded_irq).
> >
> > Drop the resource managed version of requesting the IRQ in order to
> > not trigger a double free of the interrupt as below:
> >
> > [  226.731005] Trying to free already-free IRQ 126 [  226.735533]
> > WARNING: CPU: 6 PID: 749 at kernel/irq/manage.c:1707
> > __free_irq+0x9c/0x2b8
> > [  226.743435] Modules linked in:
> > [  226.746480] CPU: 6 PID: 749 Comm: bash Tainted: G        W
> > 5.4.0-03629-gfd7102c32b2c-dirty #912
> > [  226.755857] Hardware name: NXP Layerscape LX2160ARDB (DT) [
> > 226.761244] pstate: 40000085 (nZcv daIf -PAN -UAO) [  226.766022] pc :
> > __free_irq+0x9c/0x2b8 [  226.769758] lr : __free_irq+0x9c/0x2b8 [
> > 226.773493] sp : ffff8000125039f0
> > (...)
> > [  226.856275] Call trace:
> > [  226.858710]  __free_irq+0x9c/0x2b8
> > [  226.862098]  free_irq+0x30/0x70
> > [  226.865229]  devm_irq_release+0x14/0x20 [  226.869054]
> > release_nodes+0x1b0/0x220 [  226.872790]  devres_release_all+0x34/0x50
> > [  226.876790]  device_release_driver_internal+0x100/0x1c0
> >
> > Fixes: d346c9e86d86 ("dpaa2-ptp: reuse ptp_qoriq driver")
> > Cc: Yangbo Lu <yangbo.lu@nxp.com>
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> >  drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
> > b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
> > index a9503aea527f..04a4b316f1dc 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
> > @@ -160,10 +160,10 @@ static int dpaa2_ptp_probe(struct fsl_mc_device
> *mc_dev)
> >  	irq =3D mc_dev->irqs[0];
> >  	ptp_qoriq->irq =3D irq->msi_desc->irq;
> >
> > -	err =3D devm_request_threaded_irq(dev, ptp_qoriq->irq, NULL,
> > -					dpaa2_ptp_irq_handler_thread,
> > -					IRQF_NO_SUSPEND | IRQF_ONESHOT,
> > -					dev_name(dev), ptp_qoriq);
> > +	err =3D request_threaded_irq(ptp_qoriq->irq, NULL,
> > +				   dpaa2_ptp_irq_handler_thread,
> > +				   IRQF_NO_SUSPEND | IRQF_ONESHOT,
> > +				   dev_name(dev), ptp_qoriq);
> >  	if (err < 0) {
> >  		dev_err(dev, "devm_request_threaded_irq(): %d\n", err);
> >  		goto err_free_mc_irq;
> > @@ -173,7 +173,7 @@ static int dpaa2_ptp_probe(struct fsl_mc_device
> *mc_dev)
> >  				   DPRTC_IRQ_INDEX, 1);
> >  	if (err < 0) {
> >  		dev_err(dev, "dprtc_set_irq_enable(): %d\n", err);
> > -		goto err_free_mc_irq;
> > +		goto err_free_threaded_irq;
> >  	}
> >
> >  	err =3D ptp_qoriq_init(ptp_qoriq, base, &dpaa2_ptp_caps);
>=20
> There is another goto right here which still jumps to err_free_mc_irq rat=
her than
> err_free_threaded_irq. Is that intentional?

No, that is an oversight from my part. Will fix in v2.

Thanks,
Ioana


>=20
> > @@ -185,6 +185,8 @@ static int dpaa2_ptp_probe(struct fsl_mc_device
> > *mc_dev)
> >
> >  	return 0;
> >
> > +err_free_threaded_irq:
> > +	free_irq(ptp_qoriq->irq, ptp_qoriq);
> >  err_free_mc_irq:
> >  	fsl_mc_free_irqs(mc_dev);
> >  err_unmap:

