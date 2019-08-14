Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2E78D5A1
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 16:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfHNOJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 10:09:00 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43286 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725800AbfHNOI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 10:08:59 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7EE4lco009562;
        Wed, 14 Aug 2019 07:08:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=DFLvRbMYt9xKcralRx3f5rXZkxOkjSzhXMkjcPOHXU4=;
 b=C2cnealNm/L4Ev2GYgNv+1rF9zdnSNj6MYUa1DhzC+hLRME3pdBI3nUcmPsuCLOElkj9
 HFwG5U6JkLR/EgNE7BNXGNaLyO2TMrXujEllRyoLchFXyfszKAvoKuchCjRshseh7tNu
 yL1NQ5ajfVFmGdgSE6fGZKY7GD4XX6FBK5HStUT4WL/ZV0vYDZz2n/5Z5WOy+5CvFaP4
 ALnHLOcOOqaZxcGMER3i+uNpg8jkjq6zDGfAOR4MueHNh027Zg5lDdX1reWgWZOHKK0C
 YTr/3Nw/LqWep8wIsC1uicGm+rYbE44zT49KqjWQP1+fcuqz3Kk5BJYeO/JDGEJ5QVsJ RA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ubfacytef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 14 Aug 2019 07:08:49 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 14 Aug
 2019 07:08:48 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.52) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 14 Aug 2019 07:08:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flJKwRFv910hdcZZE/gCVDLtjy14/P4+Y0jbzXJj8GxTUhFn72NJEjXHCH6LM9fk3K+nTVKVKcAyHxtB/EUTX68piGJ9eUjFAA4WMlvuXrv9BSDfowRF5aqtIK17j7A8dh45Ab3/lAXjJu/4vxHwwfxrwAQwlUqfEb3EyAyENHE41Ud/0I2gLfGl+lSkWm3s10Nx+vibS0/G4uuZos7jXRSXuqz8XTiD4F44tGybJSIhqUGeck9YwFSXy95dvnAAXz9JUk38ogvNnk3MatNmd3hcE9YIi8ZyUPmWtpLKjl3cnCLAtQaWprLYTCnIn45bvJW9BdBxGNoGq32wydI1lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFLvRbMYt9xKcralRx3f5rXZkxOkjSzhXMkjcPOHXU4=;
 b=HWjX6/2/WP+Ye53pCYKxGiPGE/+dC4tjZWbJ/47SXDdWNbWhCRC2awwJQQbYrBcTt68uY64riFAzZipNorMRsj1bZGFrjY1+0JSYTaGT6PnEzMPpohQCSJTmZ799SAScgsU3v0DBKM7vDlrTP7TTeXtAc5jpFU1eKEvKQDht/V2sRO6NRdbokRAFWfAZhNVX/UhlMVilrKEB/+p0uaJcGXcA1SWLArbmES22Nx/2aeE6REEiwo1SjboYWOpwF7uqNlOJLuB1f9gl2TBZxOkX3exe6tsUXR25MV12Od6DyoA/9h96EOgLhmFUnmvXfYtLl/bEMMuPmKI9gp+I3eRlpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFLvRbMYt9xKcralRx3f5rXZkxOkjSzhXMkjcPOHXU4=;
 b=mCuqxkOn+rJ3W5S181tHrtPC2vFw/NQwoi5xc9pTP8LPrwHSmiN1e4c67bvi5XkEmZgj8/kST5q7aLucy5mHQvxt8mep5At0cwtkQPNrJVg3GqQufSAWBQDDfIrc9qreg1X3zRFOWRHsoC+uNIiC2mYlmiXOOOviqrKtrVrn1gE=
Received: from MN2PR18MB2637.namprd18.prod.outlook.com (20.179.80.147) by
 MN2PR18MB2863.namprd18.prod.outlook.com (20.179.21.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Wed, 14 Aug 2019 14:08:42 +0000
Received: from MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::dba:2353:86d5:ff20]) by MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::dba:2353:86d5:ff20%3]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 14:08:42 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Andrey Konovalov <andreyknvl@google.com>
CC:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "huxinming820@gmail.com" <huxinming820@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nishants@marvell.com" <nishants@marvell.com>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
Subject: RE: [EXT] INFO: trying to register non-static key in del_timer_sync
 (2)
Thread-Topic: [EXT] INFO: trying to register non-static key in del_timer_sync
 (2)
Thread-Index: AQHU8UKXrSaZj3qnvU6hFZ7GfmsosaaHYqxQgAJS84CAADevwIAOoBJwgGFIWICAAAY3D4ABlLnw
Date:   Wed, 14 Aug 2019 14:08:42 +0000
Message-ID: <MN2PR18MB263724E4791927DF1AE009B1A0AD0@MN2PR18MB2637.namprd18.prod.outlook.com>
References: <000000000000927a7b0586561537@google.com>
        <MN2PR18MB263783F52CAD4A335FD8BB34A01A0@MN2PR18MB2637.namprd18.prod.outlook.com>
        <CACT4Y+aQzBkAq86Hx4jNFnAUzjXnq8cS2NZKfeCaFrZa__g-cg@mail.gmail.com>
        <MN2PR18MB26372D98386D79736A7947EEA0140@MN2PR18MB2637.namprd18.prod.outlook.com>
        <MN2PR18MB263710E8F1F8FFA06B2EDB3CA0EC0@MN2PR18MB2637.namprd18.prod.outlook.com>
        <CAAeHK+z8MBNikw_x50Crf8ZhOhcF=uvPHakvBx44K77xHRUNfg@mail.gmail.com>
 <87k1bhb20j.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87k1bhb20j.fsf@kamboji.qca.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.72.17.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f8bc392-a750-48eb-0c1a-08d720c0ea04
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2863;
x-ms-traffictypediagnostic: MN2PR18MB2863:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB28630DB05D4A2B8C684DB5C7A0AD0@MN2PR18MB2863.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(376002)(39850400004)(346002)(199004)(189003)(6506007)(186003)(99286004)(4326008)(76176011)(25786009)(55236004)(229853002)(102836004)(6246003)(2906002)(6436002)(316002)(26005)(478600001)(6116002)(54906003)(74316002)(7696005)(52536014)(110136005)(66476007)(66556008)(64756008)(66446008)(33656002)(305945005)(71200400001)(8676002)(76116006)(66066001)(53936002)(71190400001)(7416002)(8936002)(966005)(7736002)(55016002)(81166006)(9686003)(81156014)(86362001)(6306002)(3846002)(4744005)(5660300002)(11346002)(486006)(446003)(14454004)(256004)(476003)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2863;H:MN2PR18MB2637.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: a9xx4pQfo52hZbR3XyovtBZEYCIcaA/n6rg0AWkkFyoJnj1dOSE74fN7YeaQQ0Rwwxt/FvmPUJa8ScVf0nnoX1JilLxNrZAbCpLV6DkVLn57yihNbBwSAeSNCSgrZU37D9iSAM64L6SZRPMnMRXVMWbxM6bDcwsMOqkQa8Th03ouVGqRkKuq0/nheaneWWta9JEaH9Dhmtln+zsjFqZwuwApo0c6tuNycVBYiCsr/GTbpPCP3mXh+Crr0LwdMYz1GBit+f1609aeZYwB03aPILSZ0kF/ksOQl5ukHtvbIDev/x8WJBxZA1ahVnAiNR9YKeevZGbZq4/XPHzuwWS4tLWlV6UhodZ88FtfnYm3m7B5LjEyfwU2/qpFtucaKwlkrqgOJXgQqR+mIZuEvYPEAP55xOKsUVK1f3XLk7sWmm0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f8bc392-a750-48eb-0c1a-08d720c0ea04
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 14:08:42.5409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1ngMPoJRR6SXYLcB5NVQe/GEHXmVv3ZpaiZ7e/YAPfdc4bA+XYmCW83wOZ52xNOd1k1K5R9wIf2Zuvlr2UemIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2863
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-14_05:2019-08-14,2019-08-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmitry/Kalle,

> >>
> >> Hi Dmitry,
> >>
> >> We have a patch to fix this:
> >> https://patchwork.kernel.org/patch/10990275/
> >
> > Hi Ganapathi,
> >
> > Has this patch been accepted anywhere? This bug is still open on syzbot=
.
>=20
> The patch is in "Changes Requested" state which means that the author is
> supposed to send a new version based on the review comments.
We will address the review comments and try to push the updated version soo=
n;

Regards,
Ganapathi
