Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C037281F21
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 16:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbfHEOaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 10:30:16 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64726 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729578AbfHEOaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 10:30:14 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x75EUDDI020007;
        Mon, 5 Aug 2019 07:30:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=vHEHhwCAA6Sq90WGjWRfiZNK2/Pw6IEWOq8AoopkkZw=;
 b=dhXTYknBbcyeSOnUdBmLl3fAneADBF9NAm3IXMVIg9gTS/S3eRE+5CypYjCzBNSyhdrn
 W5ZQr1UwDS6ExTiizpl1QxVF1EpadgPI16vgBjrUVU2Ce7QOi1BDKWzFpxmNhuGfohkA
 gycOSfLaYhB7eKn5mpmvTU6c7JFZtPOgkQxVnKB3PXjiNRmXpTbO1212apnAF6my0zIP
 Cd1WCVCfy8Hp6i8UGyQwtS3j0i+96VzKWM27xhzdCyqvE8YCFJcARegStykJuSu494nR
 6VPMZI/9vHzobe2S5A3fmWpdRnzm4Fd6+R2Ig+0AppsmDIWjWLCzQUWY913xgai2NXvM cw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2u57mqy835-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 07:30:13 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 5 Aug
 2019 07:30:08 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.52) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 5 Aug 2019 07:30:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6KrKFaGYpV7KnHuBYCgxNhYNSksR8qHM7Pe6bD2GP+Zk6iMlLliY7gFahfqLdMmX7pqWTft8FI8sbw5k5wY1ppFuT6vUjiaZ94lGG2KsBsKRmYix/LOhfLJdALp0ifovDgxRBJFExQK0GCBY2lW3jCIjTBSU2PiOOJ0UxJCPZgorkPDmX2WOanW2Ic7VsFRmwbM/LxYbMhsUkjDP30PUjvcQlTCm9fitTe8VsQJQcfTgHEvlfxj//+NQHpPrwBaMrp5H7q3fHh19mJ4DZgar1nZkSvzc/sJSXIlpav70d7XfQQnuJRtcsDsqpnGaMkcLCdePX1P+z1AH7GsAjAmJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHEHhwCAA6Sq90WGjWRfiZNK2/Pw6IEWOq8AoopkkZw=;
 b=aQXF07WRsjUGUH1pULR7OyOIpf8Yk8JlsGalHxi+hRv4AZCrh8p/UVoPl0LQhyE8dNy7ieZ8MqjuE//RMzsTIH/7738yWkqZshN9izZes3kD8L5cN56H+bgGQxbhb7uENHb63EpBCwRD/CXBfNPvmrL+OWbN3SW5j/M5uO2/G+VWtk/PB7k5BV1BUwUe+ZOgMNbmTjB++t8vTZHFjXKPXnNhHbc9zL3Q/VJpENqX9xrxk2lMkuKyiY8ehOorPb/QfDSp693UBjYgY44UYvx4gTTAmti8zucL3/OdfBZr2XGKXuX6u76pxZzAQyzsmV4bUAKg++fZVWD7lTD7zUxBng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=marvell.com;dmarc=pass action=none
 header.from=marvell.com;dkim=pass header.d=marvell.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHEHhwCAA6Sq90WGjWRfiZNK2/Pw6IEWOq8AoopkkZw=;
 b=m9ypvnk+VsqhBievHzVOXoXFrQCv2HwL3Y+KYtwtaQFhLvcBFNNFI+xeKOd8tXK9Cdcnt0CUlTSzu2RQdnyUx7t06lepUzmpTUY7LtExc+ele4TtDptFJ87/q0Ac7I8McYqirfLju4WhXpA6TlVu+eN+nvvvGbcwgr5GehVCr1Y=
Received: from DM5PR18MB2215.namprd18.prod.outlook.com (52.132.143.150) by
 DM5PR18MB1132.namprd18.prod.outlook.com (10.168.116.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Mon, 5 Aug 2019 14:30:03 +0000
Received: from DM5PR18MB2215.namprd18.prod.outlook.com
 ([fe80::a87a:472:33ff:c5c4]) by DM5PR18MB2215.namprd18.prod.outlook.com
 ([fe80::a87a:472:33ff:c5c4%6]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 14:30:03 +0000
From:   Ariel Elior <aelior@marvell.com>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>
Subject: RE: [PATCH net-next v3 2/2] qed: Add driver API for flashing the
 config attributes.
Thread-Topic: [PATCH net-next v3 2/2] qed: Add driver API for flashing the
 config attributes.
Thread-Index: AQHVRofykOYSCu/uik6nT3dkKSH9JKbspbUg
Date:   Mon, 5 Aug 2019 14:30:02 +0000
Message-ID: <DM5PR18MB2215C258FCC2276F0319D81EC4DA0@DM5PR18MB2215.namprd18.prod.outlook.com>
References: <20190728015549.27051-1-skalluru@marvell.com>
        <20190728015549.27051-3-skalluru@marvell.com>
 <20190729.110342.703558396264560468.davem@davemloft.net>
 <MN2PR18MB2528F3206069A06618CBCCAFD3DC0@MN2PR18MB2528.namprd18.prod.outlook.com>
In-Reply-To: <MN2PR18MB2528F3206069A06618CBCCAFD3DC0@MN2PR18MB2528.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.199.69.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a17f9e82-06a4-486d-ca83-08d719b16766
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM5PR18MB1132;
x-ms-traffictypediagnostic: DM5PR18MB1132:
x-microsoft-antispam-prvs: <DM5PR18MB11321B0C925F75283E660A00C4DA0@DM5PR18MB1132.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(39850400004)(376002)(346002)(13464003)(189003)(199004)(229853002)(66556008)(66446008)(8936002)(7736002)(74316002)(99286004)(9686003)(186003)(14454004)(107886003)(8676002)(476003)(4326008)(478600001)(81156014)(446003)(11346002)(33656002)(486006)(53936002)(305945005)(25786009)(71200400001)(6246003)(81166006)(6116002)(3846002)(26005)(68736007)(6506007)(53546011)(66066001)(6436002)(54906003)(2906002)(316002)(110136005)(7696005)(52536014)(71190400001)(66476007)(76176011)(76116006)(55016002)(64756008)(66946007)(86362001)(256004)(5660300002)(102836004)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB1132;H:DM5PR18MB2215.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QB2+B4ylsLhsV6cBsMPsEi2m5kj25QlLD9ie885lXicVp1LjCUwRUYvDIj0kyT+14i84RWrLrnpVLywH6G354MGbHnzLp8suZqeV79wDRmZNHBPnOjd96xk5y9L/AFY1r1dkPh2YAKawricRj78y2wsiSAyhEDeDI0M/cZnSLYrGr2YI8fGmPzYGOsijsc8cMdEE7XC9/Uftlvqp90/6PyyT+qNvCkP/Q5DjGLMph0dhUfCvWy/Ef37PyoBIMoKtFpeI9T9FIXKUnp+t1VP6vkZ298q1+wJHLxes/l820waXyd8P4vaG8Ny/qBzpuyqvCczEj0IlH1WXW1ackyGvLfbQgtn8T1IfvmGZ3M+pxuJytcnOHNgExawPrVRnHPtH0keZ1xmvYnU2npclvPmRN/gC5wwhzSI68qlSnHmqqpk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a17f9e82-06a4-486d-ca83-08d719b16766
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 14:30:02.9540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aelior@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1132
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-05_07:2019-07-31,2019-08-05 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Sudarsana Reddy Kalluru
> Sent: Tuesday, July 30, 2019 6:36 AM
> To: David Miller <davem@davemloft.net>
>=20
> > -----Original Message-----
> > From: David Miller <davem@davemloft.net>
> > Sent: Monday, July 29, 2019 11:34 PM
> > To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> > Cc: netdev@vger.kernel.org; Michal Kalderon <mkalderon@marvell.com>;
> > Ariel Elior <aelior@marvell.com>
> > Subject: Re: [PATCH net-next v3 2/2] qed: Add driver API for flashing
> > the config attributes.
> >
> > From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> > Date: Sat, 27 Jul 2019 18:55:49 -0700
> >
> > > @@ -2268,6 +2330,9 @@ static int qed_nvm_flash(struct qed_dev *cdev,
> > const char *name)
> > >  			rc =3D qed_nvm_flash_image_access(cdev, &data,
> > >  							&check_resp);
> > >  			break;
> > > +		case QED_NVM_FLASH_CMD_NVM_CFG_ID:
> > > +			rc =3D qed_nvm_flash_cfg_write(cdev, &data);
> > > +			break;
>=20
> > >  		default:
> > >  			DP_ERR(cdev, "Unknown command %08x\n",
> > cmd_type);
> >
> > I don't see how any existing portable interface can cause this new
> > code to actually be used.
> >
> > You have to explain this to me.
> The API qed_nvm_flash() is used to flash the user provided data (e.g.,
> Management FW) to the required partitions of the adapter.
>    - Format of the input file would be - file signature info, followed by=
 one or
> more data sets.
>    - Each data set is represented with the header followed by its content=
s.
> Header captures info such as command name (e.g., FILE_START), data size
> etc., which specifies how to handle the data.
> The API qed_nvm_flash() validates the user provided input file, parses th=
e
> data sets and handles each accordingly. Here one of the data sets (prefer=
ably
> the last one) could be nvm-attributes page (with cmd-id =3D
> QED_NVM_FLASH_CMD_NVM_CHANGE).

This is basically an expansion of our existing ethtool -f implementation.
The management FW has exposed an additional method of configuring
some of the nvram options, and this makes use of that. The new code will
come into use when newer FW files which contain configuration directives
employing this API will be provided to ethtool -f.

thanks,
Ariel

