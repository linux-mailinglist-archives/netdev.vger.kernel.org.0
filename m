Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A2F2F0905
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 19:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbhAJSZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 13:25:26 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33754 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726263AbhAJSZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 13:25:25 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AIBTt8024441;
        Sun, 10 Jan 2021 10:24:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=wPscfo8bFAjXq/IdxIYvXSW5Sr5Q/eOUNWobfKeXyEg=;
 b=JOfTH8Y1TcrfYGzzyjFY1fDqutlsAzkwxDXw5ThkmpUrK+JLPUE1DdEdOeNpDiuF64xg
 OvjvNSadzu1b9az1kzpgCUMUmRR9I/ll7LuXsF4ZjD/sYhqz3kaBytIk7KR1OWEbd+ik
 eIBWAHSCMK/aT5HfhKzzn0ZKs68BhdYAI0HSlpDNgwuFmvJ+ickw+QF9LYY/eMD6qBIK
 H2FSQKQo+UN2uwItmWM0LQEUYS/hhqx0i3RgtAo9fDqjb076itHJkdLehBnXuG6o4vzw
 mgD3kYcyNdl4hjfTNvd5OBhnVF1rw2eUltTm1KCDBMlJ12yFOFSLJr8+CtKT70lIDHMg Eg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqsjbya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 10:24:35 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 10:24:34 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 10:24:33 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 10 Jan 2021 10:24:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZuNKuvH+nwAyNHIoVrmrEX943cAOFM28q2v3admP8PU7y2SKa4SbTUXOil0PxaVDh4wHH9LZ6kKWlp5JHJ0RSUcaxC9NQITzBX7wMIlLb8nZo3EUVmP6jaRGgVuI3plh8s/UO//279sdgA5iFVQKwtT5MNtEFk9t920K/jUTOHIielZ48SEjQBAMGGI9SMymvg/+ZKz1k3WQRA3S5QeuZUaCaM4H0cjxt8gj6sxqshvM8n/qrjzWz0bmkrbETmoXgnXG0xHzKImEL5fDH0C58DT82F9tAeyTTSofNYQQd736qLvoum1SbQzRZi/lyDFHni02JVngYKSlGZRVjIBqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPscfo8bFAjXq/IdxIYvXSW5Sr5Q/eOUNWobfKeXyEg=;
 b=h/dYxPsk0yUa0Yu7TXLVCNpHr1Rg23H03aN67LCeLH6o90O9Mg0IOyu/JnNX8MqIPXxiqaxM/K7O+BqI4ytOC0DNQr4hVdlk9K/oh02XA//GcnTokdUGLRFcpGOyOpjSxMJfwqDHk8vjX52Y4zTq5socbZ6x+20IzJlshXD1S2fXTbbZTIl7vNR+SjmEBNTyvmH5EdKWbOKR/oKAyTRIg63DoCcudLoRqwxY9YYJ1Id2/2PdkASxW7/lrq0o3/e3i0DC9bOrmG0mKsjwamSb7ym5EPUWrniuL+yTYiC3otmrfcm3+i8LkDvVRssuuhBM9f3HZh6iUbqsfrYZMZBU0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPscfo8bFAjXq/IdxIYvXSW5Sr5Q/eOUNWobfKeXyEg=;
 b=X5NN5fYt5ZOy6qBoDgtrwog07G3kNq4LntFZ6uR0P/Iy327rEFxrGzDydO2/0x40VqFm3LM4CDjrONgwUc14TTw1OtvbbHk7Re8sFfNbW6bb/sGzhKuEIzK3P1CwEPDvYX3H9xngu9cB7P0zBc0hd3E8zIJsbeFBgEmS4k4JNTU=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB3921.namprd18.prod.outlook.com (2603:10b6:5:342::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Sun, 10 Jan
 2021 18:24:30 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%7]) with mapi id 15.20.3742.012; Sun, 10 Jan 2021
 18:24:30 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH RFC net-next  11/19] net: mvpp2: add flow
 control RXQ and BM pool config callbacks
Thread-Topic: [EXT] Re: [PATCH RFC net-next  11/19] net: mvpp2: add flow
 control RXQ and BM pool config callbacks
Thread-Index: AQHW52W3RQcyKW0u602QjxvG4m7J5aohJ+cAgAABELA=
Date:   Sun, 10 Jan 2021 18:24:30 +0000
Message-ID: <CO6PR18MB387313CF1DB7B16D015043CCB0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-12-git-send-email-stefanc@marvell.com>
 <20210110180642.GH1551@shell.armlinux.org.uk>
In-Reply-To: <20210110180642.GH1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.29.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2be35858-66de-40c4-7c22-08d8b594f8d7
x-ms-traffictypediagnostic: CO6PR18MB3921:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB3921AED0E5FA758F5E733DC0B0AC9@CO6PR18MB3921.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PD3Y1fcwK6xN1IBYdptSUZUV3jHTDKwHNRARYx6dOkPFtkPI6EGta5Rfg5YEtSCa+2cQwlBiAjz1x9Zj66ZLKFQkZBCNTujEkTEHINcrjn1Qd7tXL99WF+j1kNI+InhrjUzyJsz2la+wx0xLwE/4oG2p3h9lFAb7U62hc7froOHcsZCc5PARpQJ8Af+yGUHpgcPuwYVPKOCo0FT7IF6RhodmWPaSv1hEgrYqnja2c03oZSMOBzm5twEBI9wwjgNd0aeZh18qi9KEdI+v6M7u1BRMlL2ldUPZigtPNCLfl/0M9KMpJmY7nFkdZZotDjuwD0ycqIgRMzgZ6tP02CaAZRiNDUCHJrNBYwChSwscrQ1X1V04yoPlpbsGGi6+T+Ue6fu6os1W/InOXSW5inmbLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(39860400002)(136003)(55016002)(8676002)(5660300002)(6916009)(86362001)(478600001)(9686003)(52536014)(54906003)(316002)(71200400001)(26005)(186003)(2906002)(7696005)(6506007)(76116006)(8936002)(66946007)(66476007)(66446008)(64756008)(66556008)(83380400001)(33656002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6V0A/W345I6KXiBmUVjdFOGPY+mT+zrHB5pt0m9rOEOm/bPmVWthTJkJahKk?=
 =?us-ascii?Q?ED4gJHDCRNzBwPgdxalVfYoKV/tV5uSFAYOt3M/pYZZALlFpeDU3lwYK6CRr?=
 =?us-ascii?Q?6ezgK6nSP5QnKwwxXGkSAKVzQwhfXlHPF5JP29VMxfhuhi61q1dZw8wS6BuU?=
 =?us-ascii?Q?BKa0z4a/YkhntQ/ivnEiRJlq8Xnz51OKYAefDAzsYijvcvqdgMb3O+BacRKl?=
 =?us-ascii?Q?2ICRsIadDb98QXxlJOJYlS+pxT1ObkEDHrZ0f+3+HUX1+gWE5xA8Y56nsGsM?=
 =?us-ascii?Q?4ctK2ZRjLbCdFfFrYqJjkMx4wvoM7LabCv2aDVo1rLjrV8PGia13WikzAPyY?=
 =?us-ascii?Q?7aCMWibFVvxk/pyNgir4rtNzf9MbFcADogss/lVnGS+zxWOFtjrP5XIaNkLI?=
 =?us-ascii?Q?w3rvDVlhimlrgUoAAsIyAOa5OC31QmnvvgMz4TJa/U61OGc3FdI473N5lJoo?=
 =?us-ascii?Q?p2j8X5+5JqyWhexFoZdB/QqaZSxAcn7M3Xh1SzQmbQIX50BO92/vioK0AOyP?=
 =?us-ascii?Q?gwBSlhCpSly0s3xY/ZOvKHMFo3mpMmu/6sjiMClOWB/QejRQnuvncunCh9oB?=
 =?us-ascii?Q?nPLwj3T8UXG0acZhMhxoLYdDoFKFPlAi90ZrhqJKh8Cam9LrjuJdMBts8Qb4?=
 =?us-ascii?Q?jN7/DzPq6tIoc0Xot++M+Oi0n7s7QYVSm7T+AnpVTXMQkBV6WAlf1+iD/iDW?=
 =?us-ascii?Q?Dcqrs4sWn1abNa+yOJo2GYP50PXKzMIw/f26woPakHQnNTr/OdRj1wQYnL5w?=
 =?us-ascii?Q?etusnTKKTM4swz/Lk1roaxQ1OGpLnL7JNYKk0ejvG+FuHJ+2Xe3BO7Aln9xY?=
 =?us-ascii?Q?zsGbJG0+FWDVpJ4YsnKMe2/89LnlhXD4oC5FEPRJJz2KemulCP29sfKGKPGB?=
 =?us-ascii?Q?Bzpy7aGU+1MyJjxZ7hztWrlEYt53hw0v8vZm4ffKf4AOxGLez3PrDdpKmiiq?=
 =?us-ascii?Q?02Yiw8yCtphf0HgkXshxwEINxLBREKwWIvN/ol9bADU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be35858-66de-40c4-7c22-08d8b594f8d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2021 18:24:30.6767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C5hS3xnJjEay42YHecoepW3E8KoLGe0InpWVrMQXUMiBzV7yxNuIUJGDkoRYJvE6FxE8ce17bc6Avz4lyUY8Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3921
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >
> > +/* Routine calculate single queue shares address space */ static int
> > +mvpp22_calc_shared_addr_space(struct mvpp2_port *port) {
> > +	/* If number of CPU's greater than number of threads, return last
> > +	 * address space
> > +	 */
> > +	if (num_active_cpus() >=3D MVPP2_MAX_THREADS)
> > +		return MVPP2_MAX_THREADS - 1;
> > +
> > +	return num_active_cpus();
>=20
> Firstly - this can be written as:
>=20
> 	return min(num_active_cpus(), MVPP2_MAX_THREADS - 1);

OK.

> Secondly - what if the number of active CPUs change, for example due to
> hotplug activity. What if we boot with maxcpus=3D1 and then bring the oth=
er
> CPUs online after networking has been started? The number of active CPUs =
is
> dynamically managed via the scheduler as CPUs are brought online or offli=
ne.
>=20
> > +/* Routine enable flow control for RXQs conditon */ void
> > +mvpp2_rxq_enable_fc(struct mvpp2_port *port)
> ...
> > +/* Routine disable flow control for RXQs conditon */ void
> > +mvpp2_rxq_disable_fc(struct mvpp2_port *port)
>=20
> Nothing seems to call these in this patch, so on its own, it's not obviou=
s how
> these are being called, and therefore what remedy to suggest for
> num_active_cpus().

I don't think that current driver support CPU hotplug, anyway I can remove =
 num_active_cpus
and just use shared RX IRQ ID.

Thanks.
.=20
