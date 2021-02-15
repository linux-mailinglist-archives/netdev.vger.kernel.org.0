Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83F231C30E
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 21:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhBOUeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 15:34:18 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22012 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229617AbhBOUeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 15:34:14 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11FKUXAY008004;
        Mon, 15 Feb 2021 12:33:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=9s3B1Ui9jUnO1sOcX8c6bONDh1A7Q5FRxEOyyzZ+xAI=;
 b=ZRrNTx3BTp5oX3ideeXr7/gQQaZPCG1KcTHoeS8CbtDK0A6sgyQw+k3NQpOfXT17FrCp
 UGh0+FYZNiJFsRW7ifcb/jAFV/7joWz1xSXEBPIVp4oKf9jFLpR2U7VKLdq20ip7cq2h
 +ZeDSCw0/3zreKoveY+R+qt5qUtUBBaSstdzomghDJ+nRga3lXExzvrats3aPeAjW7f3
 njrZEy0snLyW2JN76us72NSw+9RvRiznb22N2eqIsDmVdgo8XFzhRK0tlZer8Bqp6Jjm
 Q/JyN1aii1RJ32WOBAcqqpHoa0BoAIgWWYKYMFCZiJyZBkPRaJr2rZ5OjQyVTtE32Hdh IA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36pf5tvyej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 12:33:24 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Feb
 2021 12:33:22 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Feb
 2021 12:33:22 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 15 Feb 2021 12:33:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=du7vuqRFV1lnUju5PAEWGKVUt3LaJ0MqxK0gt6G/CQBFM7fKAWeraBrZdJzFCTa33WppG0OqWclZJzbS45jb00ATxLMvmp2VEP23MYVMWFQplKxi7cmi4rGzNbtuR4bl9GQmN9UU+SlKrc2exE05fN5Cj/QuXsPL+IL7+It/SgHNA1yQH6IbedrfMMS9pkkgXk+tDr8lVoqeRkEtaTEEIR8IDB5iwRzi0P7nezRvdEyFtnc+uj6gAxM99nhL1nZXj1GaTaoLz8PgWnG603TfAUphMM1svYFAhawW5QK3RH6vWb/VgDxM20my0DfFcPJcU8pDtiBt2hCCiveDmy2lIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9s3B1Ui9jUnO1sOcX8c6bONDh1A7Q5FRxEOyyzZ+xAI=;
 b=HRMWpxDIQRpxX1eXol70dfN1WnXlWg5LjQY5F5aql/ihst9CyAoj6kyRd7RgFsHgTOXIJK1DqdmKPA509fAgSkabxeaX/1Nuav0QhBgb5p3mRyXN997/QKtfr+sT98rQXn2sD2N+UjQXXEhwx61bMAm0qBOkjlDchdCM1D6X0UFh2e20squyt94P873FN2bnSsO7VplVuPb2n8Qtsjw3aF6wrEh5sd+b8ZZZ9SnhnEjXbJBhiHT1WLxrK9v4BrHXGqwos38LvI7kgBnTzNbN7IB4GyNah+On7fJoe/YG/yVrisy57nR98RtYGbqeCTnjZ79tIQgI4blfLPsKJS6ADA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9s3B1Ui9jUnO1sOcX8c6bONDh1A7Q5FRxEOyyzZ+xAI=;
 b=hsz8m4L7Bfs6SJFYi3ass4OqZZ1/37kIuZ8eZxNYCD2A8plXfSrN48jgZrw/KrypoZeynnT76u7wAlV6PKSfFaZ5CJZ7ww+qU3F5H752TvVpTt3FC/rCPyX6XhEFCWddslb7cBRgaTRR+iFdJpef8AeZRscHj7wFoNqgH3vWm7Y=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1261.namprd18.prod.outlook.com (2603:10b6:320:2b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Mon, 15 Feb
 2021 20:33:19 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3846.042; Mon, 15 Feb 2021
 20:33:19 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Marcin Wojtas (mw@semihalf.com)" <mw@semihalf.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>
Subject: RE: [EXT] Re: Phylink flow control support on ports with MLO_AN_FIXED
 auto negotiation
Thread-Topic: [EXT] Re: Phylink flow control support on ports with
 MLO_AN_FIXED auto negotiation
Thread-Index: AQHW98Hz4zCFeEGpzkiViEcs0nVd+apBpzoAgBRjHoCAA3KKEIAAIXSAgAAheSA=
Date:   Mon, 15 Feb 2021 20:33:19 +0000
Message-ID: <CO6PR18MB3873A73FCB7DD1233249B314B0889@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <CO6PR18MB38732F56EF08FA2C949326F9B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210131103549.GA1463@shell.armlinux.org.uk>
 <CO6PR18MB3873D6F519D1B4112AA77671B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210131111214.GB1463@shell.armlinux.org.uk>
 <20210131121950.GA1477@shell.armlinux.org.uk>
 <20210213113947.GD1477@shell.armlinux.org.uk>
 <CO6PR18MB38732FD9F40B8956B019F719B0889@CO6PR18MB3873.namprd18.prod.outlook.com>
 <YCq65/83SnpgyA86@lunn.ch>
In-Reply-To: <YCq65/83SnpgyA86@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.25.16]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28af20ff-a38c-4443-f345-08d8d1f0ee88
x-ms-traffictypediagnostic: MWHPR18MB1261:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB1261DA64AE18BD4B792CF90BB0889@MWHPR18MB1261.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: COaHJEHgXtAPJHUG0z9IFqcCt0cLW9lUOMDUwBKaGZNHBrpoUSMTekyQH97P4ILmscCRPJPxbt2zklkwtvFfF247/ueE+JCKbQzX+MywglOfbHS+NO8JEUEYaou2r3o3UDzW4alzGeYTvlOICqYjELCYzBHwuMCaG1bMfQs15/Pr6Ugujs7C0k2T1Qz4WaxsWslGRWXXFhhzjaHYYpHw7McYxtY0RfWJ9toUghDAKDlWJQShws9C7rnWZYe8aFeTB/OxM5AJBaRU9IRPnipZqDEpRqjSNd/9BYJPpgpe5t7n4lsJMWuZRS+WIG1o+IDLpY9pQJAOJyfmj7gaqvozICBp9xI5d3uAOeUVCLmgRxHUcPM8esgSw6IoDNIzcqjBNme0Y8hcV+eXOZLTi7UhdfBrmAnQfbbgp9j6aQvUDSU/ppsYzFF/bdUpQ8p0EjGDdfquTUVyG/Lbk/47ESHqhm4m83ic7BW/sqpGKCawcX0314/EAbIZwZNvar7pgPxxUG9uDm8Bayw3kDCmtssceQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(8936002)(9686003)(6506007)(83380400001)(76116006)(107886003)(52536014)(55016002)(66946007)(4326008)(316002)(26005)(54906003)(186003)(6916009)(5660300002)(2906002)(66556008)(71200400001)(64756008)(478600001)(66476007)(7696005)(86362001)(66446008)(33656002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?sJmydAeOTQKItS1GwNeuWDjZ2B4KM8n2HYk8Q/FsJ7qtSzfb73nZT+kNS2?=
 =?iso-8859-1?Q?pFUElfs6SQeKsurgy+pgFayeON6kv6AP11mBbGMhFb7HbVf2UGyjtkLif/?=
 =?iso-8859-1?Q?ic/t+r3rd56j/wQZ/mZLMnL+6wrPaPlm3xjZijpVpJg4eAxxHkBMSOjW/X?=
 =?iso-8859-1?Q?eaHs6mu6rU/XJou3M4ffrh1PLHwhJ7H7jPoE+Z2YEOwr1ToFqhc9ER0J3u?=
 =?iso-8859-1?Q?DG12AZ4PqUcnSgg2OBPDfnIlXF77eEaOIi809uFf/rYUTIFjyMSIRbYcii?=
 =?iso-8859-1?Q?4vRxKsWEH5t+bf8iDmW6q2YkTrYGxo8AjS38zJK3mtzwWid943sABNF4eC?=
 =?iso-8859-1?Q?WGwzpzfNTOlCjFNp52s+DylJWCVfxoTRpB7efKgUyt0zW0Frs/xPfSJBnu?=
 =?iso-8859-1?Q?voCsDi55+PwF9DmrhdLkbhDse7kVDb2wRrueAb2QHZCUSI/DI3LHlIWC4h?=
 =?iso-8859-1?Q?7uQtjafMbxg66WDfXrY+vNeGUVc4Fk85wYXA2sDIbFTTtLG5jALCGYjhwf?=
 =?iso-8859-1?Q?JcgrgEUn4fJ4aM2LDt3G0RUpPXM/HkOC1FPkie4BNtjjOYE7BZ02sWByRC?=
 =?iso-8859-1?Q?bug0kCvl3Qenhl0uY1LosM/0slvOdQQeY1SHdPomJLVQdkMQqqa7AQ4Tq/?=
 =?iso-8859-1?Q?m1SxVzwfpWAyEeHL/CwKvFdImn1gNRoxo/8bsOlzuNeE7WV5tUKHm5AKzc?=
 =?iso-8859-1?Q?T/H2w0FHvD1a2jEYtbpupW8h+ijftLjVDkOEg2yv4J0PNnf4BZFbEs+JiI?=
 =?iso-8859-1?Q?GB9pNH4oEvjzu4mscfYKicrYis+Q95W9f/4fhhO6DQ+DfEbDGlsMpYjfT0?=
 =?iso-8859-1?Q?wBWv2lAxnG7d2Cl9vO6bIDeo4eXZtkK46iFUaiNDZXXPmcfc47az3P9d0b?=
 =?iso-8859-1?Q?4qXB4ySrbNSazjY1jF6GNyLaXfbpl2zu9DeXUFL4cWaZXfDlR6MdAUqyvm?=
 =?iso-8859-1?Q?uRcFgycvEahgmiCH5/nNjBLmGdLxIT2LMNJ2DlrRt9/tGPJZZZb1sv6c2/?=
 =?iso-8859-1?Q?kZqWi1Ggut/SiEUz28jstNZ0M7mPt00mBgI2leGviwClKuqfLNGPEpEbX3?=
 =?iso-8859-1?Q?XpLA95X9IGHep7DKINqgBmWf3lP4h7zdZNUWMrs2wGoiJRA6HYwtRx8hb4?=
 =?iso-8859-1?Q?kKHqiymff3xmi/A0yR8mMmai0joHjKepIT+oj7m3712sg99LfnlQspTV4n?=
 =?iso-8859-1?Q?GR0IiIF//pd8gHst/uoQ2/1wRS5eQRAlxFIVj268pApHJ4eyuUkh3oOIYV?=
 =?iso-8859-1?Q?5GPmxXuSHEpcxqm3LGmx6uvVjd0maBySxciR5AQDbfJvSG63BElE5ZokUh?=
 =?iso-8859-1?Q?JrkCOl6tzZ0kLr1UVMte9yv7/L/ensT4ZIuVP/ZEdw4QOPo=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28af20ff-a38c-4443-f345-08d8d1f0ee88
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2021 20:33:19.5989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cwiz73JT9oixhh0P4Zgi4kAq7uUNhGaAWQJirAL1mmaJziuxjCQXcvv5dFnD1ophbFOr00TfUKqFKxiZzDExLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1261
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-15_16:2021-02-12,2021-02-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > > I discussed it with Andrew earlier last year, and his response wa=
s:
> > > > >
> > > > >  DT configuration of pause for fixed link probably is
> > > > > sufficient. I don't  remember it ever been really discussed for
> > > > > DSA. It was a Melanox  discussion about limiting pause for the
> > > > > CPU. So I think it is safe to  not implement ethtool -A, at
> > > > > least until somebody has a real use case  for it.
> > > > >
> > > > > So I chose not to support it - no point supporting features that
> > > > > people aren't using. If you have a "real use case" then it can be=
 added.
> > > >
> > > > This patch may be sufficient - I haven't fully considered all the
> > > > implications of changing this though.
> > >
> > > Did you try this patch? What's the outcome?
> >
> > For me patch worked as expected.
>=20
> Hi Stefan
>=20
> Russell's patch allows it, but i would be interested in knows why you act=
ually
> need it. What is your use case for changing this on the fly?
>=20
> 	 Andrew

Usually,=A0user prefer have the capability disable/enable flow control on t=
he fly.
For example:
Armada connected by 10G fixed link to SOHO switch and SOHO has 10 external =
1G LAN interfaces.
When we have 2 flows (from Armada to LAN) from two different ports, we have=
 an obvious congestion issue.
Bursts on 10G interface would cause FC frames on Armada<->SOHO 10G port and=
 one flow would affect another.
In some use cases, the=A0user would prefer lossless traffic and keep FC, fo=
r another use case (probably UDP streaming) disable FC.

Regards,
Stefan.










=20

