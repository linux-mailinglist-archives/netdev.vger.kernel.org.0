Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAA23566FD
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 10:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349598AbhDGIk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 04:40:26 -0400
Received: from mail-dm3nam07on2110.outbound.protection.outlook.com ([40.107.95.110]:58465
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231909AbhDGIkY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 04:40:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDZc0r/qrLYJHjwC9VpcTBd7DstTaDs/8gc3LVE8+LryKNO5OyvgvcJzPmTLA4erPSQm2ubnBE/OTmCs5UVOK+HGAvzhu4mZI/6ulBd21Iwa+ZCMO9GkjHM8AKNSbbsGpa4aNxviMXvD42PE9vfbz0htVFMpr/SjesSlM/sBAblE30Ir1NhIf3MeLs9yIQo4s7EjYpFCgj9dry9mZUOQWu9j3QV+Yg69lE0DoIeGa1b/yEC9IyMo/9bb9MuDsVQbACA5zejJ75rnMF70+3UiTpTffljNk/mVu97lp2ujpHggZfFBs2HM/Nc6J3V/JLd4xSTIqCpw8lZmsc2b/hDdIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpZfcvzvyr3yxfD/RWW5s07ZWo0dRaSy6vD+eqR0eqo=;
 b=aEKra700SoOXBiwlSDs/QIL9ugMDJ4SHhAxbK5ylLXkRaWjg5d/okKsy+HP1xkSNmZShZAQ5vOtzGCkx3hUla8f/VsTF+kegIEUyjbk3p+omthYIH7UvFzRV/uMbHp9J3JXvIfZ3EhcoqyrO5Nv+1/QSvoUxbdYEH+vKpLqb1xRU2FNc8sB2sjQB9vowpR4PYst8oq/K6fsuwoh+DHClFaxVY15QHKQC3FQS2zv+MpTo+e0gFWQ0YSMEbWVVNfUUCsTnMMKvO0CDmKMUJ9HqWbSsv/kA4WlHtnf6/zvRT1JueIJip+QF4n0aeVggXweuehFN2aNwujRKudnOFLgZTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpZfcvzvyr3yxfD/RWW5s07ZWo0dRaSy6vD+eqR0eqo=;
 b=OmH57JjlTDfrPH9QpGgYgLqJcZM+VulS76oB5S3LOMl9FmAoPV+jFaYxo043f5g5KuNsmmLQdUU5ZmZzJKB4ywnwYXouqdpgsWfI5vJN+O2zo/8p7LydiZRg8NfFny2TAkq48O8hQZnuf5VOSWJq61pyVE7GGwS8T1qQL/9fWoI=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MWHPR2101MB0812.namprd21.prod.outlook.com
 (2603:10b6:301:7c::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.4; Wed, 7 Apr
 2021 08:40:13 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4042.006; Wed, 7 Apr 2021
 08:40:13 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXK4VsK9CYzM87fki9gwnmLmNhk6qotOdw
Date:   Wed, 7 Apr 2021 08:40:13 +0000
Message-ID: <MW2PR2101MB08923D4417E44C5750BFB964BF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210406232321.12104-1-decui@microsoft.com>
 <YG1o4LXVllXfkUYO@unreal>
In-Reply-To: <YG1o4LXVllXfkUYO@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f2d290f8-ac74-4517-b94f-57903914f981;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-07T08:14:03Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:b462:5488:6830:14b3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7b787c5-66a1-44a8-66be-08d8f9a0c303
x-ms-traffictypediagnostic: MWHPR2101MB0812:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR2101MB081228E88892A809D92F0CC8BF759@MWHPR2101MB0812.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2l2AewoAuiVlpVO0LQsqra47q/ecztbYMyUTog4vCyRjE4JOuOaBWFohgvXNQMdRZnLexgmN0S3EDQT6npfbPo/Ufw1nlTbmgXI8+ez9fAQ2X+gkd5jbwoBoNpXSE6ngXxSGvkNvTAskdqQL+BOb5bGZxdG5XWu9Ew+OKRyZBhIL4of0myudkb3URE0ke8b2/mMSCWc+cFxYf5iGN6Dk4oyxbYQ4SOsY4uN5l+cvjdVeincd8R1xNDfR92wBBlUeRfrdUOlAIg+O/f66bXGrkZdJA1QJ9eb3lGXwCy9zoqLq6cVlg6XvO3BgYYnfh9xcLINEYZIO5EWDAlBmNptcno46YOLidipvXsg3ZOKsaVeba6Z8vQtCr/N2Vggx64R8LgACWKxLKirBtGJUIejfg+kUvPIwJUNDoVRqqff7P19ww/v7FM3ul5PPiKlmM3Zne1X4RRLxmgHX1F55cWRzBPFmkbm8wcLqDZSbW+Csu8wSYtzY1axxWVLuEk+blbRDNaEpudY+GBEFFlm3Ko1bGWJ7k/riPyvT31gvyALth4TWK0Ir8uTvhfx7JBcd2P6h9ugkdU2b4nDKs45EXY9ThIa9dlMR8Q4Dtu7eP59UMTzpJ+sZ3wGOAKcuKEDqTQuc8qv6t+MiSemtuJB04Zu1XPN8mVDA2jhl8wdCX+NC2NE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(47530400004)(4326008)(8990500004)(71200400001)(316002)(6916009)(9686003)(8936002)(2906002)(55016002)(76116006)(7696005)(52536014)(82950400001)(33656002)(186003)(66476007)(66556008)(66946007)(478600001)(54906003)(66446008)(8676002)(10290500003)(5660300002)(38100700001)(6506007)(86362001)(82960400001)(83380400001)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?1kQrK1xOxRKcftzbuiBgE3ZnYQOnexCfrVgR6sYKFm2r1lAOK+2CNITTzih9?=
 =?us-ascii?Q?9TX+LUUFf6W9GrL+k6d6FdGCSsi7BpniAbPc0JAHfOK2cq5AE5HojRLXsSNE?=
 =?us-ascii?Q?U7tFD7mJZbYzbLDOn3b4A7VIcU5yWoE0AKWsOrYNQqxoa+X8jRaZKsxnvjnO?=
 =?us-ascii?Q?/hoQWSim/YBGyk6vnNFrV9Y2yVU4xgi+AkalbfWm6o0rdfkjuT/198G4R0TL?=
 =?us-ascii?Q?1ylliNJm5//1iNF0UnN6aHtl5luVnV/VyYvgvzJ99l2076p+AMROx54SroNM?=
 =?us-ascii?Q?wAip19+kQJL2p5Gy/CmWM3LokCZXWM1+eZi7AWjibEqlTHoyUKLvFOqMvaxo?=
 =?us-ascii?Q?fQ1pF3TmBTsV7OLFtD1wJ5nB1aXNQrfURRH+x7/58lCbMMHul7SkG3wDWHBb?=
 =?us-ascii?Q?OmT74Q1U4RiglMzK8tWTxmFiFK0bf/kXgOgnPXt2TgzzYuA7S+nYpaVkdp69?=
 =?us-ascii?Q?4bGSrV9ilpRQ7R0kHXfw5gQJUsnH3hgX5N8hQsEbuB1xP++NzjLLeSKi9Zr+?=
 =?us-ascii?Q?pGsb6hWibHYgpNMH4LD7EVOHCreNJTK7zH+ZD/f0hl4Qbv5x2FBM7gH9Wz0+?=
 =?us-ascii?Q?pyt8L5tBCcGf0yg89dN6D/9GjoWBlKoHTWGEHp/P7G/sZyoINvR+DgTORRIx?=
 =?us-ascii?Q?EUpN0yE2OGgCx7XOjo49MU1aqWw4dPAeRnbFb/ucmSTamMDoTstQkwOpQ50z?=
 =?us-ascii?Q?L+wP1TnBSXAdTPBUiQ1AgNmzIc7m2bJ1rnNxPXozwFoEXUFpEgVGWCiT3QI2?=
 =?us-ascii?Q?YB6aeE6raSbDIt0zE+DjwpAyH67ZarO4yAaIl6TrOQQoX5yDj3Gte6P8WsHk?=
 =?us-ascii?Q?Z43ZS28ud3x621Obl6aS75QMF2meKs/AI+QhhxiIRCZYVod5+xIkuKlqfeFZ?=
 =?us-ascii?Q?Lql5SjQet9tKMkviFYNNFDeUKeY7qxspHJyjFGg/2EqfW/YkgEB+C+x374Ox?=
 =?us-ascii?Q?EK8WQyijfpLzteCxmL14OGunaEHrL9aq4gGbSFjUSlZSc3Jmg/xDD1TBnhUM?=
 =?us-ascii?Q?UIybSaeblQ70ldmx+rdlsb7YsD2e/iSEZNRmihDdPd2YZ5R7ipk4IniAf0B/?=
 =?us-ascii?Q?mMoD9o+LkDaFdHJ9PcSIeH5Q8pghbzrkRwfr8fmqv0Elz7eKrVfJ+KEKv9yX?=
 =?us-ascii?Q?EGz4bfKQoDytjpkvGGGsgzU+ZvX6Gx4qIXcdmN7XnAbFzysK2ezmUHOvRi5U?=
 =?us-ascii?Q?kcCWejA6j9XgsAHfyye1zUDCSQJhNVKwzNUcaWeLg66ih0sG4ShKLT+Dj70e?=
 =?us-ascii?Q?uPXFO+6oHxLhrXwupsPEPksAu+F7wyd0QJThjgYhYwn6l08ZEh4t9VUwtLwD?=
 =?us-ascii?Q?VQlb2YZNlOKLo94JF81TtKat/Y+3P4tOWoxTy7Vwl/8elaoviwidF/OYPC/g?=
 =?us-ascii?Q?tnC1B+xqU8sS1r+TQIDCXfvzc/VR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7b787c5-66a1-44a8-66be-08d8f9a0c303
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 08:40:13.2000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gk0piiEU4GiLtruJBdlk76jTVIdEb24sbdzV+E+Xlc3d3jjvEZMf/Lv/exw2TcUzJSc6/ABR4Bl6tVpxPgGfgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2101MB0812
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Leon Romanovsky <leon@kernel.org>
> Sent: Wednesday, April 7, 2021 1:10 AM
>=20
> <...>
>=20
> > +int gdma_verify_vf_version(struct pci_dev *pdev)
> > +{
> > +	struct gdma_context *gc =3D pci_get_drvdata(pdev);
> > +	struct gdma_verify_ver_req req =3D { 0 };
> > +	struct gdma_verify_ver_resp resp =3D { 0 };
> > +	int err;
> > +
> > +	gdma_init_req_hdr(&req.hdr, GDMA_VERIFY_VF_DRIVER_VERSION,
> > +			  sizeof(req), sizeof(resp));
> > +
> > +	req.protocol_ver_min =3D GDMA_PROTOCOL_FIRST;
> > +	req.protocol_ver_max =3D GDMA_PROTOCOL_LAST;
> > +
> > +	err =3D gdma_send_request(gc, sizeof(req), &req, sizeof(resp), &resp)=
;
> > +	if (err || resp.hdr.status) {
> > +		pr_err("VfVerifyVersionOutput: %d, status=3D0x%x\n", err,
> > +		       resp.hdr.status);
> > +		return -EPROTO;
> > +	}
> > +
> > +	return 0;
> > +}
>=20
> <...>
> > +	err =3D gdma_verify_vf_version(pdev);
> > +	if (err)
> > +		goto remove_irq;
>=20
> Will this VF driver be used in the guest VM? What will prevent from users=
 to
> change it?
> I think that such version negotiation scheme is not allowed.

Yes, the VF driver is expected to run in a Linux VM that runs on Azure.

Currently gdma_verify_vf_version() just tells the PF driver that the VF dri=
ver
is only able to support GDMA_PROTOCOL_V1, and want to use
GDMA_PROTOCOL_V1's message formats to talk to the PF driver later.

enum {
        GDMA_PROTOCOL_UNDEFINED =3D 0,
        GDMA_PROTOCOL_V1 =3D 1,
        GDMA_PROTOCOL_FIRST =3D GDMA_PROTOCOL_V1,
        GDMA_PROTOCOL_LAST =3D GDMA_PROTOCOL_V1,
        GDMA_PROTOCOL_VALUE_MAX
};

The PF driver is supposed to always support GDMA_PROTOCOL_V1, so I expect
here gdma_verify_vf_version() should succeed. If a user changes the Linux V=
F
driver and try to use a protocol version not supported by the PF driver, th=
en
gdma_verify_vf_version() will fail; later, if the VF driver tries to talk t=
o the PF
driver using an unsupported message format, the PF driver will return a fai=
lure.

Thanks,
-- Dexuan
