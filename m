Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245A4D0D4B
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 12:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731030AbfJIK5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 06:57:01 -0400
Received: from mail-eopbgr00073.outbound.protection.outlook.com ([40.107.0.73]:39822
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725953AbfJIK5B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 06:57:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SlrIMxYyK+VxplBYlv5BsetGV6k4vOFasCdW2bdcIZr9wT8nipBRkeY3r9r44ZsJwN1u2ivYWjZPep4XT2JcpAdLQH9Cx9k3RcFecgSTpYp/8jm23QoIM5N3Euzkj3TJHm7AbNFpkRLIDgTAZT1kWlhll3pv24FD5znm8XLoyocWJZjEdbbSPd24NO6QwE00D+X/xCxWUUAj6RybbjTIyPKF7zp8tLvsUFv0J9ZjChFAdnLjP1PpdlProfPdP3I1Urv1XzQKp3f+PQ96Al2f7g4AhJ/bcoE6HXR44Ncfw7KUj5qhBTnJj19zHvi3mb9S13qY8lUOLOXYqv1yXUXDFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3OQqyJQagcDPfrabzSYDsznICsWwuIDmwmUsKb0Souk=;
 b=jkU0HfFnZxqR3nDznOTaVdmJ7y6IAgiHL2DzAVPnYSlScEhozAtYaAB0KFm7xfZOamLJY6eyq7Ol6Ld0HloI7NENPRY9qNF0114FEtF5qJ6ZwaMcNSbSfYafh5zC2wc0ukSwgOcbsJwo7czPjZ1CBOH9pXjdkIouuSli198aS88gxR+4+YEdqDJA8850U1tP2rnYIWk/UFPRP5FtqFVY7RaGoD4+BOIpsJm/0Z6G1Zb3lxChS64uC2o8okhtAKWL89t5BjyG/XtTeVBthx/lt1GmNAe4nq3y9v0ulEAHiTDy0AfskV5BRok6RcRXYAvn1/rJFWdfzcAh7qmaqkkpCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3OQqyJQagcDPfrabzSYDsznICsWwuIDmwmUsKb0Souk=;
 b=cLAK3N+zdoDDdTwsd8QKSu4mY4QjbQ4vsHroD4yAHakW0MYC6qsIRvp3LCphtUwaV7/ttJpSjnsPIztaLQRg+xrv3vESK9/ELHweWw7GD2vSk3gvnInHTGbYAKcyjDOBK/klaFbiy/26snz+vPiXQvS9u+U/pwGkmgXtodeoaxE=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB4526.eurprd04.prod.outlook.com (20.177.54.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Wed, 9 Oct 2019 10:56:57 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4%6]) with mapi id 15.20.2347.016; Wed, 9 Oct 2019
 10:56:57 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roy Pledge <roy.pledge@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 19/20] dpaa_eth: add dpaa_dma_to_virt()
Thread-Topic: [PATCH 19/20] dpaa_eth: add dpaa_dma_to_virt()
Thread-Index: AQHVfdGJuMo7qvFB0Ua4q2457e8s/6dR7bYAgAASDKA=
Date:   Wed, 9 Oct 2019 10:56:57 +0000
Message-ID: <VI1PR04MB55677E492084AB7F816DED7BEC950@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
 <1570536641-25104-20-git-send-email-madalin.bucur@nxp.com>
 <20191009073926.GA6916@infradead.org>
In-Reply-To: <20191009073926.GA6916@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5584e67e-11df-418e-deb2-08d74ca7679d
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR04MB4526:|VI1PR04MB4526:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB45265D7502101E56EF5A118EEC950@VI1PR04MB4526.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(136003)(396003)(39860400002)(189003)(199004)(13464003)(99286004)(486006)(14454004)(102836004)(8936002)(2906002)(7696005)(66066001)(446003)(6506007)(53546011)(66556008)(66946007)(11346002)(9686003)(64756008)(66446008)(476003)(76116006)(6246003)(478600001)(76176011)(25786009)(66476007)(14444005)(71190400001)(55016002)(4326008)(110136005)(6636002)(71200400001)(86362001)(81156014)(81166006)(6436002)(8676002)(229853002)(6116002)(3846002)(26005)(316002)(33656002)(186003)(256004)(52536014)(54906003)(305945005)(74316002)(5660300002)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4526;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q+//isvwzXV27i7fpjfVOzpCAPz+SRLCq9f5poAcUO7WUoOHI390xujebPMuvVxQ9tmdZFNIq+EsjxJKr2QxGKKZFmJAhcyT/2sVDZqpIUOjDzj92fbtvIgneD2KfO9ofPe9oIcZGzz/7HKPQ8/DIMKXjNPZMbpwNE6ZPKwA420PSEzexjpxGuLgF9sPFeqWcaO3kYaCNojjKPCkMnRVeTYcFQouD8Ick/ybVx5DODLRlBK380F+o8b2eoyeeRWCSQciP9k2SSAV/6MdjHRGo97NI6xqUq+Pd1gdGQpjkkNm/VVsZz582DDK7C+3qMyGiIBrg+IlWfiqTR0F2Y1hsPaFw6Kr9QQk55Xf5YZLJFcI2Umt9HmmIKjs304LZgFvh6OhCLva1Ph+c3I5cP2KBSapCxV4xS1dqjQ+6LZWhNU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5584e67e-11df-418e-deb2-08d74ca7679d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 10:56:57.6514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lYU7Z0xuzz0vOa0mU0EaoxD06yRndruQGi+D95s60GkDDBApKnEivDxbl3TQsGD3vKEMZMiTD7tAmPD5o9sR/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4526
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Christoph Hellwig <hch@infradead.org>
> Sent: Wednesday, October 9, 2019 10:39 AM
> To: Madalin-cristian Bucur <madalin.bucur@nxp.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Roy Pledge
> <roy.pledge@nxp.com>; Laurentiu Tudor <laurentiu.tudor@nxp.com>; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 19/20] dpaa_eth: add dpaa_dma_to_virt()
>=20
> On Tue, Oct 08, 2019 at 03:10:40PM +0300, Madalin Bucur wrote:
> > Centralize the phys_to_virt() calls.
>=20
> You don't need to centralize those, you need to fix them.  Calling
> phys_to_virt on a dma_addr is completely bogus.

Hi Christoph, thank you for your input, I'm aware of the limited scenarios
that are supported with the current code state (SMMU disabled/bypassed).
The existing customers using the DPAA platforms cannot make use of the SMMU
features until this is fixed. The problem is there is no fast forward path
to fixing this, the performance requirements of the existing use-cases
preclude the use of the recommended approaches suggested to date. I'm movin=
g
all these phys_to_virt calls into one central location specifically because
of this, as the lack of progress on the SMMU fix problem prevented me from
upstreaming other driver changes/fixes. Having this contained allows it to
follow a separate path towards a solution while it enables me to address
issues for the current users of the DPAA with minimal interference. To
illustrate the decoupling of the DPAA driver code changes from the iova
handling fix, the only change to the driver code that would be required
to make it work with the SMMU enables would look similar to this:

static void *dpaa_dma_to_virt(struct device *dev, dma_addr_t addr)
{
+       struct iommu_domain *domain =3D iommu_get_domain_for_dev(dev);
+
+       if (domain)
+               return phys_to_virt(iommu_iova_to_phys(domain, addr));
+
        return phys_to_virt(addr);
}

Other refinements in regards to the actual APIs to be used would only
affect this code area.

Thank you,
Madalin
