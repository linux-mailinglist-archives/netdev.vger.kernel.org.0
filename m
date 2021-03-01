Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7170E327DC6
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 13:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbhCAMAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 07:00:50 -0500
Received: from mail-eopbgr20045.outbound.protection.outlook.com ([40.107.2.45]:51204
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233966AbhCAMAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 07:00:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UiIhSqXPUGodryYAj6ZQMa5fbUtOELe44kP/nW11f0SNMH9ELPR+xL8sWcmzMsenx62pgbzr2I2Loa6DR4fwvHCqX60RCNF2ZliKHBCM20Jgkj48bMWcp+AfnJM4uyxCYgXW6AArpfnVaI0VsyI+TreiHjcRkf7qpjd5/r7nPVQVbhx7vNi+m8J9inoAzy4nHJh+GCN+0wOreNJlWa1yApLLT8HGJeph8E9VkmW/gKBkyCEQe/5/AYk7thnvPdHZXzk5V6MCtMaQON+zuWkN0DG6ryClMwuWX199B+IFxllkl4k21vyYyWloWsW0g/M8RxZeAfwN2T4XTK52pafb6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmKz7p2OVGzbKN+CKFPhvXUBLp9jGO+zifn0FUpa0OA=;
 b=AIwh5HSByQnJhxq781KFOn7gENoJRulfldZf16G7QQAQStGS11Jo15n9k/lLxe/SZxl327hbP+KpFIdvTymbOc+mObXyd1d1Yz1ZVDzGUuWF9H4SIVp0QE91RkefFpTA+P01fS6agTg3lUjWSRIeB5akTzGji3k/H9r07H4ESWF5Bnv/A4SMFTms8jFboEC9GWn73akFIFDhXziRT2Qd3UmJpUL64rPBHR7PWrRUXMwMuFEWCvorgW1vXkGU9Z5bSD8+P6K8ntj8mpQq34yEMUU/l0qTKYebiaHQFXU0EBqi7WmdvsDXvMPWYK8gwNFMCbuCYv+Nwy1Hkj6BHRRUdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmKz7p2OVGzbKN+CKFPhvXUBLp9jGO+zifn0FUpa0OA=;
 b=JIHLCsKL21hy8Oge6tDnIykK33J8fNEz5QrOE53G5pVj/xC/LgDH0w6LV16kMPeeIcrS9RsfxW6yxSULPOpNYDmENQKdrhn93l745XviIcGENMqvfBAhd0qFrqUKmF+LzoOLbxmtcTFSTvPKd50lJUUUkO7mCm1iYk42aTiGiKM=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB5245.eurprd04.prod.outlook.com
 (2603:10a6:803:5a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Mon, 1 Mar
 2021 11:59:54 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88%3]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 11:59:54 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "freysteinn.alfredsson@kau.se" <freysteinn.alfredsson@kau.se>,
        "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "netanel@amazon.com" <netanel@amazon.com>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>
Subject: Re: [PATCH v2 bpf-next] bpf: devmap: move drop error path to devmap
 for XDP_REDIRECT
Thread-Topic: [PATCH v2 bpf-next] bpf: devmap: move drop error path to devmap
 for XDP_REDIRECT
Thread-Index: AQHXDPhSW53lvoUfOkWZDRrbX62QEKpvCtaA
Date:   Mon, 1 Mar 2021 11:59:54 +0000
Message-ID: <20210301115953.dufjdjnbmmwooxaf@skbuf>
References: <d0c326f95b2d0325f63e4040c1530bf6d09dc4d4.1614422144.git.lorenzo@kernel.org>
In-Reply-To: <d0c326f95b2d0325f63e4040c1530bf6d09dc4d4.1614422144.git.lorenzo@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.13]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 42609924-47c1-44f8-2505-08d8dca986f6
x-ms-traffictypediagnostic: VI1PR04MB5245:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB52456D0258786EA0371F4246E09A9@VI1PR04MB5245.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zWsO+NTGMW8+u6xZE09cf3EBfWR3CT5vJCq8dv+nuxa5DUFwb/5AneYoWXFI2T11D9+Sh0dsp5fam80VULaYPXcm7R2KcQxIw07TUsu+BCYM0GAw0/QKw5XrvxJDv2WK554/uaX4I/kC4Jg6f80DSsDWw0+aVrXd29h9H+VBEJ3OA5snsTWmCsttP40GB/yA64f823g5CpP8VGB2PnGcw5qw11hoME+1twEx3pjf2Lk0zjguT4w0X8pssIRPOu91Y+4Jo2SOqM7eKwkVftGx1qrB9ZKPp6mqYqjs9UXTjaBulxGAD0+Jm9usVf0ZuHlPLtdMFsrSyiAXU+dfIUkgZE5vzOi6gnk1U8/+kGeg0o+hOFIdati2PscuwKW2W1gi62yerOHr3Mg2+3pwHtNSAPjh/86DlRrZUq7LBId7K8lUrJWvECCSViw7Fg/qN/nDt4IxK6A7EhWRb+A9S1axEy1r2L3Z4zwu6FG8M3U3JJa8Oqw8/DTZ1w5eFY+G3VN5l0ulGPAsz+1+7tbTsRnUbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(136003)(366004)(346002)(39860400002)(396003)(33716001)(26005)(2906002)(3716004)(6486002)(186003)(4326008)(86362001)(478600001)(44832011)(6916009)(9686003)(6512007)(7416002)(71200400001)(5660300002)(64756008)(83380400001)(76116006)(6506007)(66446008)(54906003)(66476007)(66946007)(316002)(1076003)(91956017)(8936002)(66556008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9s8DXKoaGGmuad0ajXP4C3hjPkhXvYmSkZgGQjcl/WClpXsNL6lI2mR0O84J?=
 =?us-ascii?Q?wohvM0dq1pXKrpHry6MVd5LftNVNGtBriU+qtWT4ok/u1NMs146sxM7OvPK6?=
 =?us-ascii?Q?2OeH4VJw5MpDPzP9+EAtx55BQ5240ar09N5TVVoKITx7qQeLVgRULQIErnaD?=
 =?us-ascii?Q?e2udskWLgDxs1V92uVp+uM3VZ4ZRZHrBFN7G0ArOWSPLhf8AZcfXnDRMwnck?=
 =?us-ascii?Q?T5JLbd9gHh4rozoGXVl4jhU2fD3WXz7wHpxCJa/63FPBhqielcBj79iUsVwq?=
 =?us-ascii?Q?UKtDsf/+rzE/jmDjmk0HuNujXphANPIhTAdoOaFGVWNtELBHLIfGf7sI6TdF?=
 =?us-ascii?Q?WMgzjW9W0O1H8jt0Z8zCx+Gj6/K8eeXuBEZfXEwdAIucs0x+f6Yhy+/yGMjz?=
 =?us-ascii?Q?TDgPU0WYFpq/1HVLhR0MCP7psQV0IyZo3Mff4HfE/x9FngrCOkDynrnTOPPc?=
 =?us-ascii?Q?2oIkQ+G5Fq1/v/llpTkzigCHAXrdVMUoFQcWDuAAsjFZZ6OUAwMoxaDJBpBY?=
 =?us-ascii?Q?XytZ48+HB1VL9MMvN3xFbOmrscTx9Ewhq3KYhY8JzRM6m2HOt5MkxZe5sgRv?=
 =?us-ascii?Q?npZ8muMdrUxwCxuMR1/ApqiPfIsAeP4Q0hbBVNtW7PMhA32zrp/PSFXwlOaq?=
 =?us-ascii?Q?sS5AEN/ZFAaH+fN4hDRkQyhnjFwA6sh3RCEU/2EeWLlaDt26w3IXBXj/CQlD?=
 =?us-ascii?Q?xpxIYVb6OPu4s6jjQlC5xindsj47LBXg4xnJYxscoV9k54nO1St9hRsG3bV4?=
 =?us-ascii?Q?x90yOdkwo3Y3bGPoIOb+8k7WiYBd6iKaPC4gjeI9yqzmJqMI/AKYBMnqmGpq?=
 =?us-ascii?Q?PZkyJzQRB8CEFOrwf19A3xB/dMCDoYKppwsOf6bsFZeOWOFfzszImeauHktP?=
 =?us-ascii?Q?OEmgIr/gMxT/Yv0+F2WOLPdz7w1yDt55rh20/Q36ZNBNt8GKEDVJdg8pMnHa?=
 =?us-ascii?Q?xmBpJvBCiwwj+IRo/UDlCD6dNM4IxloFVPTMphOe2JeIwOrcc3dInGhBX6eB?=
 =?us-ascii?Q?oaZGmEXC26v/GV8wnbjCrxCx9slsZcOpSoHDvEM1CgE7xsnqdE3YmqmxuV9h?=
 =?us-ascii?Q?NEer1IX+7QTDjO5ASRmCD5qT0M3IpqIA5+1OxzMOdkqpz8+0zAZAXR1IyZNp?=
 =?us-ascii?Q?ZwEHL/mWmJ0TYvITFkH5q4e3GV3ClHowtjZbjq/+fthK2kczbSx68Cidyf78?=
 =?us-ascii?Q?0j0pB7ABj24n2jtyzDuMSd8eI/4yEi7Fvl3d54exFC3tquZcknoTKKQppi/B?=
 =?us-ascii?Q?9WBMgnEQxn0gVQX0Z86Jkcd7qbzIzpZ3rthZo/UXRNaMTwS7XNWkevb4y7uw?=
 =?us-ascii?Q?oyZMtID0FvQFxC1cMRSZo762?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1E4BA012B6B8F04FA6D1A197F52425ED@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42609924-47c1-44f8-2505-08d8dca986f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 11:59:54.4327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: weraKCTcsRw0jVh0W91/7X0jQaH9taeY9GxjmaTIgsZwQs6IFMwazST+xVIt3/u5gSv6zZmBQM5myQZ376Pcpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5245
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 27, 2021 at 12:04:13PM +0100, Lorenzo Bianconi wrote:
> We want to change the current ndo_xdp_xmit drop semantics because
> it will allow us to implement better queue overflow handling.
> This is working towards the larger goal of a XDP TX queue-hook.
> Move XDP_REDIRECT error path handling from each XDP ethernet driver to
> devmap code. According to the new APIs, the driver running the
> ndo_xdp_xmit pointer, will break tx loop whenever the hw reports a tx
> error and it will just return to devmap caller the number of successfully
> transmitted frames. It will be devmap responsability to free dropped
> frames.
> Move each XDP ndo_xdp_xmit capable driver to the new APIs:
> - veth
> - virtio-net
> - mvneta
> - mvpp2
> - socionext
> - amazon ena
> - bnxt
> - freescale (dpaa2, dpaa)
> - xen-frontend
> - qede
> - ice
> - igb
> - ixgbe
> - i40e
> - mlx5
> - ti (cpsw, cpsw-new)
> - tun
> - sfc
>=20
> Acked-by: Edward Cree <ecree.xilinx@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com> # for the dpaa2-eth

