Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B433895F5
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 06:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbfHLEQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 00:16:35 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27320 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725774AbfHLEQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 00:16:35 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7C4FNxx012992;
        Sun, 11 Aug 2019 21:16:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=WS5Xs8+SFpJZAJsWAwU0IIGX9Sjrq0dF+Q/NjZbV7Cc=;
 b=V/VtzitTj2Sj1LhESNUrjSaXuds5c8jNXcVmI47+DoHK6NhST7RnZNLszRWCzKwLL/J0
 mfrVSx2fOK+f06Wlns9a7bOEpz0Y+ctBxho6+3v80JhpqfxVErGpLJEt1Np876CCH66J
 QTpzqRa3IuhRTdEl5o2kJYSqyw3hMAz9a2rH09ariLZcLd1V0d1RpdjXRWFimaljRLVI
 Mb2QQ4HCxDlMC+NzUwvgYHI7wlv2NlHHNZtrqMEWsgm/zXC2c7D5uicOebHeA2QBtykO
 uRHKMQh4OOQaNyO3DtadGN2dqBJF4Q9cY9ZWHaEpSHISNiyNBLy6AlgchYEetfoOFUsS 4w== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2u9u9qd0ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 11 Aug 2019 21:16:33 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 11 Aug
 2019 21:16:32 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (104.47.34.59) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 11 Aug 2019 21:16:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Atgq8FAAtdkznXJgazTX2ltCwnu/LPiUIFA01iPWPyalaLIUH/FHXEcxJMRDwhoJsA5AkXdfSTW1zrQwA7AbzNmCIluu8JUBdS3zUZKHJuxYnD+VdC4UNKmLJ0st5RS20oplOxqwA+B9EaIp2gw/XWg2TAHWUqyOFNPpSYrQMUbTh8MMUO/MiZ0bLQcGyqlpo6GyL52jVNj43NbzNCM5BTjnOsqtRgA92tFPr1Bng0WTbuSJEKd5tbCzHFs9XPIO0PCexjmdSTS8HQXkH4CZmo1/1G0ctbmYWTUwvS5qXQbRJ3j+xmJrsR5LtLplYLcvdY+GcINx94c5xdtQZ9+taA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WS5Xs8+SFpJZAJsWAwU0IIGX9Sjrq0dF+Q/NjZbV7Cc=;
 b=Z2oo5Kfjvf/wVW8/AJf4zc4nHUO7jVKPdfN3z7LTMo09wdOqCUQwbs0PDizLYYHA2+6qTkxg+CTWH/r+QCLKqAkNlSNPL/I1XBusHNWkZd3hnjpoyhO8+wNAMSqB4nq85TKkhlWdeOqrseP3j93XxoHrPTF20TvTQ4do8JE11/tuJkOFfCe+vG6MqMRLr2gmRxHS1ivPyHDmOFXydDCoDEJDM54RcB4X9lhwyjzSP1iEVBXpuqKMX2WVDiHqJ4/ieLxqjFa0xHZVc393Weh8o9XNsfewLJb3ajX3/1Iq+SYt1VhXsnaCOMyrgxFz7Godxa3nnZs5h04NS9HPWpZcEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WS5Xs8+SFpJZAJsWAwU0IIGX9Sjrq0dF+Q/NjZbV7Cc=;
 b=FrDg+kOcEdyDnEFgPdPeuakAaG7zGRNwTcOgPnlaIWFWCJM9xgIkMyyE2k+cXp2Omj/0QqylaNCPQ3XdBzV6n6wlEluyxCh1zxLzyWdyR0vednxsfwqYmoR0P5uDRaaCYPIaidxV+4DY+XRLPolBLoUvZA3If5TblW+ZNu54I+Y=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2717.namprd18.prod.outlook.com (20.178.255.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Mon, 12 Aug 2019 04:16:28 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9%7]) with mapi id 15.20.2157.022; Mon, 12 Aug 2019
 04:16:28 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: RE: [PATCH net-next v3 2/2] qed: Add driver API for flashing the
 config attributes.
Thread-Topic: [PATCH net-next v3 2/2] qed: Add driver API for flashing the
 config attributes.
Thread-Index: AQHVROeieXWkzaKRbE24UdK4xBNDyabh5hoAgACdmTCACicGAIAKU+Cw
Date:   Mon, 12 Aug 2019 04:16:28 +0000
Message-ID: <MN2PR18MB252865F28ABA05EBD90778EBD3D30@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190728015549.27051-1-skalluru@marvell.com>
        <20190728015549.27051-3-skalluru@marvell.com>
 <20190729.110342.703558396264560468.davem@davemloft.net>
 <MN2PR18MB2528F3206069A06618CBCCAFD3DC0@MN2PR18MB2528.namprd18.prod.outlook.com>
 <DM5PR18MB2215C258FCC2276F0319D81EC4DA0@DM5PR18MB2215.namprd18.prod.outlook.com>
In-Reply-To: <DM5PR18MB2215C258FCC2276F0319D81EC4DA0@DM5PR18MB2215.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.231.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da9d6068-4933-40c9-466d-08d71edbd907
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2717;
x-ms-traffictypediagnostic: MN2PR18MB2717:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB27172644762BD2DF3FAD9639D3D30@MN2PR18MB2717.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 012792EC17
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(396003)(39850400004)(346002)(199004)(189003)(13464003)(7736002)(305945005)(8676002)(5660300002)(6506007)(53546011)(66946007)(55236004)(102836004)(66446008)(64756008)(66556008)(66476007)(76116006)(26005)(81156014)(81166006)(186003)(256004)(14444005)(11346002)(446003)(486006)(476003)(6116002)(3846002)(478600001)(71190400001)(71200400001)(14454004)(54906003)(107886003)(316002)(4326008)(6436002)(6246003)(2906002)(25786009)(66066001)(53936002)(6916009)(229853002)(8936002)(74316002)(52536014)(86362001)(7696005)(76176011)(9686003)(55016002)(99286004)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2717;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9JSJhZJ0uq53sQdAtm8ET2tikm3/GgyVPSI0vqrwOxMKivbJy7UOYyxmi149fSQPnHPbFZ6iAvN/PM4OLGos5qeX6BfLASESgcm2dXE5QrXEcwQQYQy9ceBjEEcnJBQj1cG1nk2wXehSfh1RX6OF+xWawbC9ZGUUWBhbKqiuh0yACGawc3xZquHWRAKoWbxfWtBxDrrWpoNI3T/RVdW+IDX9qkg/fvN5/kkVXtxz0FLpPUu2BQasKEP0XhPjhEQi8gc/R6gMD50IbbLSn6XvMIU1RK2NplxsSO9SeynEZ1T7n8bdV4KvKy5ZpKKtDtXKDn0LfLlc2W2gaIX4hFgb+CHvloM+DSdR7Br470Y9EQNO2cvJXG8T2+HvgCGkS298V3oSASrSFfuLWIwPCSGyPaY6f8uaHUr5RrRe1utfqlU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: da9d6068-4933-40c9-466d-08d71edbd907
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2019 04:16:28.1929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ov4Ob1HIqYaSNjSQf1xIYtkPUHfP1FjQPxxjbWHs6ilV0xkcntveL8/ypevA/5ZI6YlnA0K91T18ajFtNjX76Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2717
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-12_02:2019-08-09,2019-08-12 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ariel Elior <aelior@marvell.com>
> Sent: Monday, August 5, 2019 8:00 PM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>; David Miller
> <davem@davemloft.net>
> Cc: netdev@vger.kernel.org; Michal Kalderon <mkalderon@marvell.com>
> Subject: RE: [PATCH net-next v3 2/2] qed: Add driver API for flashing the
> config attributes.
>=20
> > From: Sudarsana Reddy Kalluru
> > Sent: Tuesday, July 30, 2019 6:36 AM
> > To: David Miller <davem@davemloft.net>
> >
> > > -----Original Message-----
> > > From: David Miller <davem@davemloft.net>
> > > Sent: Monday, July 29, 2019 11:34 PM
> > > To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> > > Cc: netdev@vger.kernel.org; Michal Kalderon
> <mkalderon@marvell.com>;
> > > Ariel Elior <aelior@marvell.com>
> > > Subject: Re: [PATCH net-next v3 2/2] qed: Add driver API for
> > > flashing the config attributes.
> > >
> > > From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> > > Date: Sat, 27 Jul 2019 18:55:49 -0700
> > >
> > > > @@ -2268,6 +2330,9 @@ static int qed_nvm_flash(struct qed_dev
> > > > *cdev,
> > > const char *name)
> > > >  			rc =3D qed_nvm_flash_image_access(cdev, &data,
> > > >  							&check_resp);
> > > >  			break;
> > > > +		case QED_NVM_FLASH_CMD_NVM_CFG_ID:
> > > > +			rc =3D qed_nvm_flash_cfg_write(cdev, &data);
> > > > +			break;
> >
> > > >  		default:
> > > >  			DP_ERR(cdev, "Unknown command %08x\n",
> > > cmd_type);
> > >
> > > I don't see how any existing portable interface can cause this new
> > > code to actually be used.
> > >
> > > You have to explain this to me.
> > The API qed_nvm_flash() is used to flash the user provided data (e.g.,
> > Management FW) to the required partitions of the adapter.
> >    - Format of the input file would be - file signature info, followed
> > by one or more data sets.
> >    - Each data set is represented with the header followed by its conte=
nts.
> > Header captures info such as command name (e.g., FILE_START), data
> > size etc., which specifies how to handle the data.
> > The API qed_nvm_flash() validates the user provided input file, parses
> > the data sets and handles each accordingly. Here one of the data sets
> > (preferably the last one) could be nvm-attributes page (with cmd-id =3D
> > QED_NVM_FLASH_CMD_NVM_CHANGE).
>=20
> This is basically an expansion of our existing ethtool -f implementation.
> The management FW has exposed an additional method of configuring some
> of the nvram options, and this makes use of that. The new code will come
> into use when newer FW files which contain configuration directives
> employing this API will be provided to ethtool -f.
>=20
> thanks,
> Ariel

Dave,
    The series appears as "changes requested" in patchwork. Please let us k=
now if any modifications need to be incorporated on this series?

Thanks,
Sudarsana
