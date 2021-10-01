Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5BC41E988
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 11:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352994AbhJAJXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 05:23:02 -0400
Received: from mail-vi1eur05on2065.outbound.protection.outlook.com ([40.107.21.65]:49952
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229681AbhJAJW7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 05:22:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVGe8iDl0xOCGC1yQvUc/ge23VBhrulKLifDGgV+UVWsisSMls6CinhnROS5kA+aPaWxSw7mc7PEkJOCQqi+qcKtDC4JOqteYQnyN/e996VSHPf51NaR7SjOBQzUR8lW7QCewJMsc79FB7gWhpT7/dfSrIjpiLF+p15YM+9IFPqWR6pEQH3I0zMaMU5WZweInVg1l6pwIiPV+4f8BgaHITjhbw1bY8108VAacrcU3GZTicJp7tMkMNPvBn0dsOKTlQNO8IhG0dL9f/S/MBfbQMR5a8pRiQ+D7K9tA7Un+5AjbNo1qN5R3dI8jQN/HwCWmeQt+KRirEvp7SrHUm6pww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2vROfgZYve/eN+WJQnBMRjUY8aJLMOdFcI8Ir5wL/9o=;
 b=LiVRUFs3cDVz6bgAPs1OpNL32ywX0xM/ll1b3oCL2kJnmwbRbGGbwcDXzsgJpVGWC+KJXya81jCNYeVCvqlmXiutAqDJHBcHSUZUq9S0osSVdFh0Dhk3+jEPQ0IDB967tSTaGbP5Y8oIC4ci5wtxtTuqspXM0CAzBfFDrDCLHIZKOh9IKQhCLN1THD8i2jPiOJyptFQw1QspMxA+1M+3Bf+/kzMerC8nxJtJYIm9eJFrb+4HDpaYqIdKRG8/IpRgi7MwyixERz/kjuSlUW4PfwiZyK13PouDxhA2VI3YNQn4FgGHvs2iAYLz0H+K8oRVevHuyJulfjH+CwSlTwb3Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vROfgZYve/eN+WJQnBMRjUY8aJLMOdFcI8Ir5wL/9o=;
 b=lGFfl2PCTD9HXgk8K7OO/p6AeFBq+yHByFY9e+P6FWENulXPmtY5BPO5mHv7QOeXhLi9+ta6WccuVbKZ4manCIZHaMGaeNlTRMAEId3hYRXDgUAD2dsKpdFGWcy0AQDJUX3qaZHLWfFw3LvB3kUtkCc2M80aqn16qeFnFjwdH1Y=
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM8PR04MB7956.eurprd04.prod.outlook.com
 (2603:10a6:20b:241::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Fri, 1 Oct
 2021 09:21:13 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 09:21:13 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Jeremy Linton <jeremy.linton@arm.com>,
        Hamza Mahfooz <someguy@effective-light.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DPAA2 triggers, [PATCH] dma debug: report -EEXIST errors in
 add_dma_entry
Thread-Topic: DPAA2 triggers, [PATCH] dma debug: report -EEXIST errors in
 add_dma_entry
Thread-Index: AQHXpSuO4AOhY9kToEi8I4sPqFaslaujtKEAgBn4OYCAAFQpAA==
Date:   Fri, 1 Oct 2021 09:21:13 +0000
Message-ID: <20211001092112.ndi43juysd2vg6zm@skbuf>
References: <20210518125443.34148-1-someguy@effective-light.com>
 <fd67fbac-64bf-f0ea-01e1-5938ccfab9d0@arm.com>
 <20210914154504.z6vqxuh3byqwgfzx@skbuf> <20211001041959.GA17448@lst.de>
In-Reply-To: <20211001041959.GA17448@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bae6da4f-4a09-4a37-a92a-08d984bcd076
x-ms-traffictypediagnostic: AM8PR04MB7956:
x-microsoft-antispam-prvs: <AM8PR04MB79565CF74E36CA71F82ECED1E0AB9@AM8PR04MB7956.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +GD3ZubnkNwHKkoJwtAmpRW3WvAYBlULKWGD5dUUHzjpb84HR8GKEtB+/95Fpe6rL8jnQ8W6g4iC/EECYQMsSUoO2d4AXP8ko7RW41gmaYvZDQAk1cwn9aynDZwzNUY0bpTaxuS4c0nYvwJGa/qX74Svajg1+0ZsQ/KEkwkv5tcQGUBPcyvTVrLIkqW4I9BKCD+HGHphml+6XjOW1eYxE5h3TWNJ6jrabRQa4j0P8xW+WlZ3PbZ4h1fdiCgEc9QTfUwvM2/ALJ+iuEorpr65llgDdT52QJ+KMCJRVSWMHvv0QVv0XD/wx44Bp6pEbl0pAfHGRA7zdXJ98o5uOO8h2LQYN4Qds0IcYkymIJycUE9wsQJePX16hBRpXyawCk1E/i5mlmu4thAg6zmGSFRzK/jBoWWq1Xy0aQ0NscMF+V4Z673cdlK3R47VVpwvde/3iDVAsDHY+FZtJZWRKPGck48eJk6Gj/y9zv0fduQ7JNi4o+OyopSYNHUGB+0oJFEP/eKAsrn5OGHiW6Q/zuvFLcPeq7K+7mluwWbr1RWh641yqXkjAy6/0GVQv7L2RuZTEwIuHaRnoKAp13VZ3jAvpnL+8ZOxqwuYG5cxBCBsygwCNYgLwd+m3JaH3U4n5TwQixykVEksysipAWl9rHuAU27KEF7DkUxR6PfPPOX81rQpOnyZ10QbrZbcBJCQozkg1RsbASBxnfTyKxIRaVr2cQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(44832011)(66946007)(6916009)(2906002)(76116006)(91956017)(38100700002)(83380400001)(5660300002)(6486002)(122000001)(316002)(9686003)(66446008)(6512007)(33716001)(54906003)(66476007)(86362001)(64756008)(66556008)(4326008)(1076003)(38070700005)(26005)(8936002)(186003)(6506007)(71200400001)(45080400002)(8676002)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ajtcWiutTWak/KUAXK0/MlwtRKJdRumfocK869j2wEJFYcMneFt1iRC+v0?=
 =?iso-8859-1?Q?9n1LMny7Nqi8QwGWb7B2o8zbhR+m2FYs14kmeoeMmDVMNA+aXRV/Ov4/k6?=
 =?iso-8859-1?Q?9R8UAI6e/0Q/hUzN6ap11HraX/xK3CmBv/1WwaOU0fnJEQf+G+kp/pTqpS?=
 =?iso-8859-1?Q?WmsFyu1wdv3LdIeLG1JefmlyPynjYO6NYpygsAnmbYsMmhgB/w+4Djm2ZW?=
 =?iso-8859-1?Q?R6YpxJZgn7E68n5ijQflhZCAIVLVoGTWX/8NjomJapKTIPVC/3DCr9DmgH?=
 =?iso-8859-1?Q?ilG5R3XatiKF/k61ix+YuJWlQKwEmSSliKLd/GVOR+h3AbIJMkbsWs403I?=
 =?iso-8859-1?Q?31XqXVRP/TWl0s8lZX8w1f1qM2eC6znBckUuu41KDm7HqczBO24EZvWrzp?=
 =?iso-8859-1?Q?N0OZzOuuZvqHiO47/X+bj9HRtTSLETw0/UpiqDNW0L4egbn6x48/kioNjx?=
 =?iso-8859-1?Q?+eWDHx+XREF/gdgZULWekC5ULbz73D30GkEYVTlvViJ3S3cuAPr45JaBoW?=
 =?iso-8859-1?Q?eLaRnBj6k353mSPYnkqd+yNIEGUk93d6r7oPSXROr6qOsvdS/qFZXWuJo3?=
 =?iso-8859-1?Q?TpkVTTVQs4uGlwxDQIDOzpCJl6vi7NoNXdnCvjXG8QltddAFACaU/IZ0eE?=
 =?iso-8859-1?Q?mEg5QXbLUn/s7pGxLDNaGmr80QPRqyE8jhcQORbXopw3pOyIqGGbrOVyOT?=
 =?iso-8859-1?Q?F2rmZpuoxGgbAw/RpRFI+uOhxCHULqq8reLa7mZnInltFO39+UR2EsJ7so?=
 =?iso-8859-1?Q?7lqmm7TUvxZUqwsB03VO0ETI6QSTyMg35cfV5ITAon3Vr+CWwfSR8KLz2X?=
 =?iso-8859-1?Q?AA9KcTSZimyctVcv8SCEwhSdyys1Lb1qEC5hVZrEU6iMj12MIXC5KchMM6?=
 =?iso-8859-1?Q?25JtXgISV63K8GxHSz3f5lzDrsOkuW8Z6NLbV01TynktvgslgPzHFBfUpe?=
 =?iso-8859-1?Q?ZelAFAvTDXKJCzQeqxjxmVmBz6lR+ne9DDF6klL/oj5GSsIAoj1ajhgyxS?=
 =?iso-8859-1?Q?i6AtkuZjLuxsRl0teZYslPQ5ZEyt3qZGh2BVhheEM1Q64y5FodtyHLTi7G?=
 =?iso-8859-1?Q?R3JOQ49sjryt9axhZQ4tLXSxhcyN6xs8bT58YW1gYvGm+xPxylyQ2ldNJ0?=
 =?iso-8859-1?Q?mcqC7nPM3ILRRXBvL89BGp6Gib6zFsTthMmpzZdUwdXaFBe2ZBy4n7YCG+?=
 =?iso-8859-1?Q?wdWHZvGEwQ0qnxvIBd5oH0/zasoq1BGNrgciYq6qXTGlGd2NLngfUY24Pj?=
 =?iso-8859-1?Q?10W4c3ccXHrvibYHNko9gN5N1PzOmaedzayqNjf3IGHBVDDvnHUo1tbrNL?=
 =?iso-8859-1?Q?/cDpC1HDu/j3TqWsC74GNYjNvW25NRadys3hFKSvIMixw9g2IaZUNIRsCb?=
 =?iso-8859-1?Q?Tdb4c+s3AN?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <8EB46456DFEC83449F1712382451EE3F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bae6da4f-4a09-4a37-a92a-08d984bcd076
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2021 09:21:13.5201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +aqPwjlCDwV/Z3vipSFBf2SImQtf9u+e9EN5T17xteEaNooZTCGlvXJa/tQjnbguO5G/Y0ANXr9ETbNjQRhklQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7956
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 06:19:59AM +0200, Christoph Hellwig wrote:
> On Tue, Sep 14, 2021 at 03:45:06PM +0000, Ioana Ciornei wrote:
> > [  245.927020] fsl_dpaa2_eth dpni.3: scather-gather idx 0 P=3D20a732000=
0 N=3D20a7320 D=3D20a7320000 L=3D30 DMA_BIDIRECTIONAL dma map error check n=
ot applicable=B7
> > [  245.927048] fsl_dpaa2_eth dpni.3: scather-gather idx 1 P=3D20a732003=
0 N=3D20a7320 D=3D20a7320030 L=3D5a8 DMA_BIDIRECTIONAL dma map error check =
not applicable
> > [  245.927062] DMA-API: cacheline tracking EEXIST, overlapping mappings=
 aren't supported
> >=20
> > The first line is the dump of the dma_debug_entry which is already pres=
ent
> > in the radix tree and the second one is the entry which just triggered
> > the EEXIST.
> >=20
> > As we can see, they are not actually overlapping, at least from my
> > understanding. The first one starts at 0x20a7320000 with a size 0x30
> > and the second one at 0x20a7320030.
>=20
> They overlap the cache lines.  Which means if you use this driver
> on a system that is not dma coherent you will corrupt data.

This is a driver of an integrated ethernet controller which is DMA
coherent.

I added a print just to make sure of this:

--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -567,6 +567,7 @@ static void add_dma_entry(struct dma_debug_entry *entry=
)
                pr_err("cacheline tracking ENOMEM, dma-debug disabled\n");
                global_disable =3D true;
        } else if (rc =3D=3D -EEXIST) {
+               pr_err("dev_is_dma_coherent(%s) =3D %d\n", dev_name(entry->=
dev), dev_is_dma_coherent(entry->dev));
                err_printk(entry->dev, entry,
                        "cacheline tracking EEXIST, overlapping mappings ar=
en't supported\n");
        }


[   85.852218] DMA-API: dev_is_dma_coherent(dpni.3) =3D 1
[   85.858891] ------------[ cut here ]------------
[   85.858893] DMA-API: fsl_dpaa2_eth dpni.3: cacheline tracking EEXIST, ov=
erlapping mappings aren't supported
[   85.858901] WARNING: CPU: 13 PID: 1046 at kernel/dma/debug.c:571 add_dma=
_entry+0x330/0x390
[   85.858911] Modules linked in:
[   85.858915] CPU: 13 PID: 1046 Comm: iperf3 Not tainted 5.15.0-rc2-00478-=
g34286ba6a164-dirty #1275
[   85.858919] Hardware name: NXP Layerscape LX2160ARDB (DT)


Shouldn't this case not generate this kind of warning?

Ioana=
