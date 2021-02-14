Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1D631AFDA
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 10:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhBNJeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 04:34:14 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13180 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229528AbhBNJeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 04:34:08 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11E9UqqD023454;
        Sun, 14 Feb 2021 01:33:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=BBP6FjsR5Dr84nFlxcRDT9VAk8OH+Hb7tHNFqrykAJg=;
 b=LtfOAxUP43tD4crW0NAX29naN0dVB56PhV0CzDOQv5i6MEqbNiEccxQQML+mYpK2xb9E
 MWk/22LcT3Cw/0RsNE17WzHtIMSSkBvhbJDnv1tf00KVSu7Yee8nXjwTwS7rqNTPM6Oe
 Ti/mR5gsKkVurn2NdowJRnMpAIQ2/PEyvS25EQdfxwjwJ/qpz8phi6yFcecWv5ivpUmo
 b15YKqpFBKwu7YBNX6woFWLaYkiBqsQNEyGl2x13Cba+nVbqqD4UyvPQBnb9chwoDMX1
 HFpDkWqQhDROFcnAOFOUHkwokgV8Xstbf6DXPNWTFGN/NO//QcDimT0+RDL2Ma4G2qzC xg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36pd0vhmmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 14 Feb 2021 01:33:20 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Feb
 2021 01:33:18 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Feb
 2021 01:33:18 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 14 Feb 2021 01:33:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9tAng0eKz/WhGlGVShNvC3OgW0nTtwIBeRolKZ9Yn2G4do1rzKT6eMrZ3XDak7ikIzcgbm2Ib8vSc4f6HTknka7dNSYZU3KxRKLQJhhEKT+Zzaurp33B9OVy5tAxPmDVpv+i855/n57FS9FV3UpIhUcxufQwGl1XbfBJ1hsUO385aGqc12YoCoKfVVGATXRfKXG9k/1HB2yzWTo2XnW6FcNGOYNB1QL1VW8h3tVkTgDgQQOjWEBaUQSlKR1/m8rBKESLx/wCZw9ZYERWF71+IwqzGauwhHIkWj6AbsUOptL7OBscRw8CP58YsuldC4B9DYWnsv5mtCxVIFP00GVWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BBP6FjsR5Dr84nFlxcRDT9VAk8OH+Hb7tHNFqrykAJg=;
 b=AcClp7LNkb02LVmUh7hawa8ros+eLmY5ww8+1gfjYj99Nyy7jVVmWmguCGUTzAb/5DVg/eK4W5HyqrJIffMLXQ7zb7VWixlaRrRXZYwfH5c9uv7OodvNEu/HOWFhNanH5dJ5M7SagqLfVaOf/N0lhit28gg35ModtrfE+GJdTgveB3TtUGn7j2VycO6SKQroNmM2R8sb8uLo+ehMFpauhzOCaKdDWFIvk4FKEBHLBqHWZiVYdFHLqyoTxW09Q5l6UctHHzWI0G7XlnxFgR4GaYCiKvGohvuclm0TC+WFBcu9G++oJc4mO7uh53a1Fs5mnYg7fjDlGDp3VRsazBl+tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BBP6FjsR5Dr84nFlxcRDT9VAk8OH+Hb7tHNFqrykAJg=;
 b=JMCaXLa8PHNryV6U2svmRPcHuvStmL9ME1wRHdkvCoZOBjpcDhEqpdU9r3mdpsBsmdrooQm+lcJzzco0Tx6C5eLOKeb3yrOrMSmYRyCyrqjbq1u3w+G2/NVjO3XzxUb6qUJfmCmn75SwYNL7mLOblZ4iqKqGGEGxGw3RH++xc+E=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW3PR18MB3627.namprd18.prod.outlook.com (2603:10b6:303:5c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Sun, 14 Feb
 2021 09:33:17 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3846.038; Sun, 14 Feb 2021
 09:33:17 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Marcin Wojtas (mw@semihalf.com)" <mw@semihalf.com>,
        Nadav Haklai <nadavh@marvell.com>,
        "Yan Markman" <ymarkman@marvell.com>
Subject: RE: [EXT] Re: Phylink flow control support on ports with MLO_AN_FIXED
 auto negotiation
Thread-Topic: [EXT] Re: Phylink flow control support on ports with
 MLO_AN_FIXED auto negotiation
Thread-Index: AQHW98Hz4zCFeEGpzkiViEcs0nVd+apBpzoAgBRjHoCAAW6YkA==
Date:   Sun, 14 Feb 2021 09:33:16 +0000
Message-ID: <CO6PR18MB38730030DB698C57A8FDCC32B0899@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <CO6PR18MB38732F56EF08FA2C949326F9B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210131103549.GA1463@shell.armlinux.org.uk>
 <CO6PR18MB3873D6F519D1B4112AA77671B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210131111214.GB1463@shell.armlinux.org.uk>
 <20210131121950.GA1477@shell.armlinux.org.uk>
 <20210213113947.GD1477@shell.armlinux.org.uk>
In-Reply-To: <20210213113947.GD1477@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.25.16]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: acee4888-0278-4b19-0ea5-08d8d0cb8f15
x-ms-traffictypediagnostic: MW3PR18MB3627:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB36270BCC6F72DA96D240CD88B0899@MW3PR18MB3627.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9wfdUvH2PVuuAUqP7v4Sb7gHOYL6NzkhutbaVtQTZY4G0hXWaPbXVS7Lk+NgqfPF8Dn0oCrjia3FHKI211RUIdzYYJwBpPdrawqXTFtBn0XRRd89JVM6hEY5gTWqQ4y3iVTMguFf33ZpFdcLKo88DomIDeIcSp2CWW8390HVq6Fjvy7BF/xWABwaz2pAZJoiBbFzErUHsAHM0LGMSK68hGWn3brRqddfvH+kWFGbwBg6+vSKhGfWfC9DzHPgCIOSu5+gDeimyWTfcjuPVxZzXEyULs2qyknJMU+v1u75WEVcgzP+YzrCiqRxaBoWDszWdKwcp5Is8kVIBqZf2Un6Cvak5kiD3vP0lPDkpgIQHGFGUytUZijBwWpkMtXjmi+kMmC9PoWYEK0DmgelsClEYKeyVIBKKeaQseT7pTrGcaOez3DRr7xR56jX/3HRRR/Oh5LljDyWM8fjK8MiIr4AkpyNbQvQWwVnNAY1ZQvN2jVRGEkSW9bkv1iof2mbGRzdr8KAbVkT0qW8dIAGBTyhYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(346002)(136003)(39850400004)(478600001)(9686003)(6916009)(55016002)(8676002)(66946007)(316002)(76116006)(5660300002)(66446008)(4744005)(66476007)(52536014)(66556008)(107886003)(64756008)(54906003)(8936002)(26005)(7696005)(4326008)(6506007)(83380400001)(33656002)(186003)(2906002)(86362001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Tqt/HCzQs/C2Cl4ijE9lIZQPHQU4k3WxcyS9lQy5uI4IAG8HPLSLatjqqBWW?=
 =?us-ascii?Q?c2HhT/2IPVCWw5KCi7JubGCD1uqzt9p8N75aWbPv8lH7l3tIy78qkDZ14Z/9?=
 =?us-ascii?Q?r8rWex3v4l6CtsJ66HaHKbM0mv4YN9cNsVfQ5rxx19rHt7w/DtsL8FAx2xum?=
 =?us-ascii?Q?fY0coaA+KDRlVs3e0tr0HLjzz0eXUrrUPZYEvasKtSH+yyboz7zfIenB5Zkx?=
 =?us-ascii?Q?bXvLOxkNxgvdsB8Q8UTQjpQiq7ilVhe9AeC/o6gyE7AVpxTS3r6m0bj+t4cr?=
 =?us-ascii?Q?c77wB81L7uPhtTh/rZDDrR/ZK6eyE4rTVSULzgpydfkWlDoql4E7UGEwXTiH?=
 =?us-ascii?Q?ivElART8v5Snx26QT/TRQBJWmg7OrGr6syTPY9yYDdp+AElZiU+mb9aI1prn?=
 =?us-ascii?Q?+s5FohKLo38B/6mPCSbKoE5MaLQzCs5F0g0K7LjE4iXNvpkNnkyUrsbvOq5W?=
 =?us-ascii?Q?PH0NPiK9Rdia13ZlUleJUNOlPkVsMEV4bfnli8f1rpEp80dNsEsrzUCEOLkk?=
 =?us-ascii?Q?E4xprzohebORyIfqKWjnT75PldXYu/YnIeFHB1YDKfLGgW4eC7+nh2w2r3wp?=
 =?us-ascii?Q?eMwbpyWmCuvYjVnJA6uSbAD4VVOUfx5GZcELhWyFbbJU59KHv658V2vE99s8?=
 =?us-ascii?Q?08DK44NvK15WHruDDsAXtmwCPBPT+mcZlXfQyETtHIhQG4pE/oV0MGkchJ5b?=
 =?us-ascii?Q?26sy6D/uyxXW3U/N46jwAUvnMS5q6omLBK4D7Oy1un5acVBptKqa9Tx50cZe?=
 =?us-ascii?Q?HSpUMLnrOiJEShWC1DQjX7/BYZHDGMjVmC2rECPz+ve+m2PwkeK4anez3yMi?=
 =?us-ascii?Q?vqJqxnDfHbgRlxoDB43mHRYvz/3ZjBG/Am23GowLmirre1Vcrkf8lBzoXw1l?=
 =?us-ascii?Q?q5mNtrcuZBTKxf1a62CkziAylMSMBwuQByokL7eq2Ow04OHg77gjwUrhJdNE?=
 =?us-ascii?Q?ttJHM1SA17uygrJtSa0yCvOeBsmInzZY8akt3eSrKSR6JHiSWilKGc/DNayL?=
 =?us-ascii?Q?xf//Li6Uajo9JwJ514NUWmVIRWe+ym5Nrn6QaggJz5e1ORALXZBxNHX9naQg?=
 =?us-ascii?Q?YWMybP4uNyc+KQV4xR3RQU7cGwxa5qY+pRYWgCGPIsTiuOmh6GEild9pD7SO?=
 =?us-ascii?Q?P1RO6mJWwMPGAnYL//1xBeB4IDJnTGfSlEyZQGJ65b1sGbnx7D2ct2YKFJX/?=
 =?us-ascii?Q?YSMPL3wNMn5YloGepg5hTUHxHYrKkZdjsg430H8ClyQBLV43niGRuptUo9nt?=
 =?us-ascii?Q?P09gAuPwydG6ApkwHDoZOI6olEZsIxmAEmCk4miiYlWly7Tv0osMLtMApkS6?=
 =?us-ascii?Q?0OY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acee4888-0278-4b19-0ea5-08d8d0cb8f15
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2021 09:33:16.9370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jatP1jSxkomA0UE9oqIvse9cHosnNSkE2mR9dyYqwZnD355l2IS5SVHAkBd4tlrHVWOYyYB3GFsH5zLIOoG6qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3627
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-13_02:2021-02-12,2021-02-13 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > On Sun, Jan 31, 2021 at 11:12:14AM +0000, Russell King - ARM Linux admi=
n
> wrote:
> > > I discussed it with Andrew earlier last year, and his response was:
> > >
> > >  DT configuration of pause for fixed link probably is sufficient. I
> > > don't  remember it ever been really discussed for DSA. It was a
> > > Melanox  discussion about limiting pause for the CPU. So I think it
> > > is safe to  not implement ethtool -A, at least until somebody has a
> > > real use case  for it.
> > >
> > > So I chose not to support it - no point supporting features that
> > > people aren't using. If you have a "real use case" then it can be add=
ed.
> >
> > This patch may be sufficient - I haven't fully considered all the
> > implications of changing this though.
>=20
> Did you try this patch? What's the outcome?
>=20

Hi,

Didn't tried it yet, its in my TODO list.

Regards,
Stefan.
