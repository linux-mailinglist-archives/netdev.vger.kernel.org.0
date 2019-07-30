Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3B6779F8D
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 05:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfG3DgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 23:36:21 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64532 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727124AbfG3DgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 23:36:21 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6U3Ywfx013069;
        Mon, 29 Jul 2019 20:36:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=cvEmi8raHWtqorc9x8vBwxYtxfYr71eH6m7xX7ugBXo=;
 b=o8HUTUKc3RmrxO3FlNZGcbHd2EdcrxTnjzO0B6TfseiQnO4swJg2bfQNnbx9njuyzrJn
 5iYwrRKDhcWt/7tKVeiJPoCIIBi2j871W77RXM3VrkV+oPQQqS6Eg+gSl/wDVxucwMob
 pzSDIe5IIfv07GSBLNIBBkaEiCPs07dflaBkD1EsurJUHodSNeJmV7LgG7LxptzStT3i
 Z+AOFAa5gcYzWWn9Gq/wZzIP5qvnILCYNw/WoDXoVKxU3Vb0RWW1Zt1WItnMfe37kOKG
 r/Y4wTqIgzTPd26A2sq0EfbETGNbwKLe8d1JAXgFgG9hxHD5J1VYq8VaRCiMIyDmHV/Z RA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2u0kyq36bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Jul 2019 20:36:18 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 29 Jul
 2019 20:36:17 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.52) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 29 Jul 2019 20:36:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vhyo0Ooa49NMgiK5nu5ObySTl8KpwsVKa8vS8PQ72hnCD1rHSalZAEVsSDVyxaDlwXxN0DVz2PotwB2HNPl3LkHS0owh9Rtw7E0qQniGu/IGdjKrH3Pqq6UGpm/dEgsJ1DWx53aE+zz/5pLhcyGU1QcWkllXiKEFaUG3OR1Gt/VAjPZ7aqVyTKeUyb3I4sKt1UR/MmUgyiH8W/m5ZE7Ul/9TmqgwFBOpkHYZS00y+9RzR/XY+sDaUWnZflEJpNfMgS21+c0VW3eeA6LdpL+HEWJLCEQApntOSCvpWukLf7w7Dhj5uVSvFB83bFIfaqKSuMv7RcJuMmW2zi0Bugw2aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvEmi8raHWtqorc9x8vBwxYtxfYr71eH6m7xX7ugBXo=;
 b=jk+CjrC3gTG1RVDB04cVJ4xKPQFwsVUNIF6NM1+eomJclQj/YZ/n66rekQSMSSp1sEUfKXMwSjelj6h/5dUb964/ni/rQsy7aOROdz3RhjO1wCX9abiUDx3Rj53F4aVBpTbp6DUSuVvPd4QKb1TgcB1imDD6b8c3AOsdwQjqY54+XugK6gxITav6Sc63rbeoH3zjOEOSIo20VbGxLXRlcd+fVKgsqjhIPXxSLHLAzMRLALAyp3uQ6giK+2RRGhTq78eU1bn/fZyw+hI2weZRZJa8Mj0tgrSc4gsHK7Qv3ZtSLGqRyMRZ3Jlr4s30Ja0hi0mhKe/I2lV3YJNdPbchhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=marvell.com;dmarc=pass action=none
 header.from=marvell.com;dkim=pass header.d=marvell.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvEmi8raHWtqorc9x8vBwxYtxfYr71eH6m7xX7ugBXo=;
 b=QhfrSrDkFND9joISJzauU2M9t3YMJNyJD2gf1/jm/295R+QtfS7uzl3yJYElpdTwMuCSBvyXYORVl5+Ull864/LJnWJMutUHFgginCRWpgk7eRCD0VulIlD3jYK19YEwa5uYDLQ76gxmWV9kSr8h3ucYG2tDngc0cYxbhEKlzCo=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB3151.namprd18.prod.outlook.com (10.255.236.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Tue, 30 Jul 2019 03:36:16 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9%7]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 03:36:16 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: RE: [PATCH net-next v3 2/2] qed: Add driver API for flashing the
 config attributes.
Thread-Topic: [PATCH net-next v3 2/2] qed: Add driver API for flashing the
 config attributes.
Thread-Index: AQHVROeieXWkzaKRbE24UdK4xBNDyabh5hoAgACdmTA=
Date:   Tue, 30 Jul 2019 03:36:16 +0000
Message-ID: <MN2PR18MB2528F3206069A06618CBCCAFD3DC0@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190728015549.27051-1-skalluru@marvell.com>
        <20190728015549.27051-3-skalluru@marvell.com>
 <20190729.110342.703558396264560468.davem@davemloft.net>
In-Reply-To: <20190729.110342.703558396264560468.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2409:4070:218f:1c13:b14c:be7d:7131:c4ed]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc6147d0-f4ce-4956-b8e7-08d7149f1424
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3151;
x-ms-traffictypediagnostic: MN2PR18MB3151:
x-microsoft-antispam-prvs: <MN2PR18MB31516F77972876A39C37A3EBD3DC0@MN2PR18MB3151.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(189003)(199004)(13464003)(446003)(486006)(71200400001)(71190400001)(6436002)(107886003)(53546011)(33656002)(6116002)(2906002)(81156014)(186003)(229853002)(476003)(11346002)(25786009)(256004)(55016002)(102836004)(53936002)(6506007)(6916009)(6246003)(81166006)(4326008)(8676002)(74316002)(46003)(5660300002)(8936002)(478600001)(305945005)(66476007)(99286004)(66446008)(66946007)(66556008)(64756008)(14444005)(316002)(7736002)(76116006)(54906003)(68736007)(86362001)(9686003)(14454004)(52536014)(7696005)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3151;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hcGnA6wAZ44qshOhc5UDwuPibtvXmGLuUg6GGhMHPTZR8pwG6Qx8YyHz5QL+BL0SDUzpppvX+WCuv1av6KY47qkcWyu82loAWBmk4o6BF8w5mzHZrXMmqcQ7Ke8GIkXs+nCB0ypqi1oPuuvkxl3ZK964BoZ24ZwLlfb0Db9VGPwnKyba6LGdeN3+/f1Tdsqaj2/bmKoaaYj18c9vO7CCvwCKvFLIqwRSG1gY18jhZE26+Avs2pDIWlNZqI0uE3PTvbT89gHzt56rvK1ONOTQ7uxBeq7AUIa3/E/LDvWQBj8tbkk7UoWnB58F+L9bRRtWO+FSikYmowNrAFXz/erNhj1MxpH/eF5KQ6ipJcBE1jsJwhCZ/Zjgkjp5zgG5oGnlOTAA/0SLINaeVj1y8Sz8uB15oK3Wr9wKFmwET1E3SuU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dc6147d0-f4ce-4956-b8e7-08d7149f1424
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 03:36:16.4941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3151
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-30_02:2019-07-29,2019-07-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Monday, July 29, 2019 11:34 PM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: netdev@vger.kernel.org; Michal Kalderon <mkalderon@marvell.com>;
> Ariel Elior <aelior@marvell.com>
> Subject: Re: [PATCH net-next v3 2/2] qed: Add driver API for flashing the
> config attributes.
>=20
> From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Date: Sat, 27 Jul 2019 18:55:49 -0700
>=20
> > @@ -2268,6 +2330,9 @@ static int qed_nvm_flash(struct qed_dev *cdev,
> const char *name)
> >  			rc =3D qed_nvm_flash_image_access(cdev, &data,
> >  							&check_resp);
> >  			break;
> > +		case QED_NVM_FLASH_CMD_NVM_CFG_ID:
> > +			rc =3D qed_nvm_flash_cfg_write(cdev, &data);
> > +			break;

> >  		default:
> >  			DP_ERR(cdev, "Unknown command %08x\n",
> cmd_type);
>=20
> I don't see how any existing portable interface can cause this new code t=
o
> actually be used.
>=20
> You have to explain this to me.
The API qed_nvm_flash() is used to flash the user provided data (e.g., Mana=
gement FW) to the required partitions of the adapter.=20
   - Format of the input file would be - file signature info, followed by o=
ne or more data sets.
   - Each data set is represented with the header followed by its contents.=
 Header captures info such as command name (e.g., FILE_START), data size et=
c., which specifies how to handle the data.
The API qed_nvm_flash() validates the user provided input file, parses the =
data sets and handles each accordingly. Here one of the data sets (preferab=
ly the last one) could be nvm-attributes page (with cmd-id =3D QED_NVM_FLAS=
H_CMD_NVM_CHANGE). =20
