Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D9922412F
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgGQRAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:00:02 -0400
Received: from mail-co1nam11on2093.outbound.protection.outlook.com ([40.107.220.93]:40896
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726293AbgGQRAA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 13:00:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OI71N4eCkZsvBRI3Jk7D4GvY4dda3z9zPhJ/osVu4dQWWlWtF/FZ8ezWk34oITi9hKhaGwSMkGk9MvIGc0y32wxc/fY66JHOmyO3ZmE2t5aQQkx7wZeaKEXD6mAH+aBI4rcj/aMZiXYt7FR6RuhsFyX/cfgq8D1lYYE23BSPYbot8gOzJqyqkq4F9O/0THmkExSF3bnu4XSZkS7XIqCabNhWJiJgIa5X1lqgERi95hezEZOEl2rOetO8Xm/2cPkWjwa8Uys4JHp3dabnK1natQwqlJfwVNFNh3gxNEbHXy8S8FVVzk8M11g6nyRv2BdUtfuguuhf5bdSIdY9l/6s5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUBXaB0WGvdXYG528wY/+sBHyH7sGcYHeWSBBLh1HKU=;
 b=m5k+QGckAb66Lc3n1iDhzertFVosvPPbqnE2bbBC/tNHmx2vsFctf4NWBEctvcT5gIO3BaTSATA8tL/d1hLYrTlKZUr0h/TaRG33a57oZ3W/WEkY4yP7Mtl8HW8qyWdr3eTW2bR987wLvWEkmQKYfJmRt843MbgbjgbzilWuK88dzcbiyrI3FsX1xE4I3IW9mqRdszCmYaD2EL95mw3N82PcP0b4Pc30yyXNSdNb06DfF/PwBo11siUbscfkqljcKq8VEWNcPZ+xPBi8F/04dyKZeXfzhs6Qj6TN3QnBVew/lWKUpxj+mFtGRD/DklayESwg4ydJILho/hiOZ7cUyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUBXaB0WGvdXYG528wY/+sBHyH7sGcYHeWSBBLh1HKU=;
 b=T4Y2LKo8cBvtexfaclAujfNg7r4H474qN3lX80eX5cm0owowqOFOpqi/LTAM6lpuO0kEJVgmKTub1kIEMKjreuAVC4lGmJKo0UlXMz7y7gvZ2NogBmAkPZKW8eUIwdd/60PNGJBJDBSmwE544NskCEuuRGRFF9QDcwjlH0XB0Ew=
Received: from DM5PR2101MB0934.namprd21.prod.outlook.com (2603:10b6:4:a5::36)
 by DM5PR2101MB0933.namprd21.prod.outlook.com (2603:10b6:4:a5::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.5; Fri, 17 Jul
 2020 16:59:57 +0000
Received: from DM5PR2101MB0934.namprd21.prod.outlook.com
 ([fe80::88cd:6c37:e0f5:2743]) by DM5PR2101MB0934.namprd21.prod.outlook.com
 ([fe80::88cd:6c37:e0f5:2743%3]) with mapi id 15.20.3195.019; Fri, 17 Jul 2020
 16:59:57 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     David Miller <davem@davemloft.net>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Chi Song <Song.Chi@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>, "andriin@fb.com" <andriin@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] net: hyperv: Add attributes to show RX/TX
 indirection table
Thread-Topic: [PATCH net-next] net: hyperv: Add attributes to show RX/TX
 indirection table
Thread-Index: AdZb/5iAkDMuWyahRIOBehKiULg7mgATtGGAAAFgBuAAAcsygAAAIFPg
Date:   Fri, 17 Jul 2020 16:59:57 +0000
Message-ID: <DM5PR2101MB0934A64FAB205E8481DDB077CA7C0@DM5PR2101MB0934.namprd21.prod.outlook.com>
References: <HK0P153MB027502644323A21B09F6DA60987C0@HK0P153MB0275.APCP153.PROD.OUTLOOK.COM>
        <20200717082451.00c59b42@hermes.lan>
        <DM5PR2101MB09344BA75F08EC926E31E040CA7C0@DM5PR2101MB0934.namprd21.prod.outlook.com>
 <20200717.095535.195550343235350259.davem@davemloft.net>
In-Reply-To: <20200717.095535.195550343235350259.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-17T16:59:56Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6ed51af8-f887-454a-8680-eb168c6447ca;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cc26e145-88b5-4e45-c7fd-08d82a72d5f0
x-ms-traffictypediagnostic: DM5PR2101MB0933:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR2101MB0933F4858F72A99172F24B35CA7C0@DM5PR2101MB0933.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q1ID2yHgJmISBbWXzN0QN4PU/LYBSFoXXKoDws+UQVdhyRDiQdrCMpUFCjbJJGHvPt+oyL/g3oR+GYLGJF4w0S4c3vr4CdkqZE0XHIuRIw/RXYh6sg7PKVDw94w8lAMuU+65FDCEDW3lL7eR53WFXHMMtz3DHgfi0MDgAxbyWFI22y+f3ciAGxe3C/oZzGF1mNkpDTxW+Sdaj/fl12GUerUhDOvehyYaqcCJCJUWrW6ynpBVuR08zH+k84ZyO7mYn5j5niDg0X4NePXAEcu64kPyp/HYcad4xnIJEjqvHoutsaqN7hiOKi1ytMfApNu7ZOu/Ac2segNFtb84wiWIvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR2101MB0934.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(8676002)(52536014)(316002)(7696005)(82950400001)(86362001)(10290500003)(82960400001)(54906003)(6506007)(478600001)(53546011)(8936002)(76116006)(9686003)(83380400001)(2906002)(5660300002)(7416002)(186003)(55016002)(4326008)(6916009)(26005)(33656002)(66476007)(64756008)(66556008)(8990500004)(66946007)(66446008)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: kblpSPLLkAOyfiBZIw/oWGlAlttxDbRWkAPhBaQLllkG9uv+2QohKk/ItkOdjPKYZ2qz7hWbcGfkVzx0L9oO/Tm1UrVLId7XITBAjdl9Nm24OVp05ROHkOduw+K/O/iEtvt/paXyjU/24XLfWZ1YF2ssLVhGGAAHxMBGYVpc+bDchNJcHvudrZ8c/ld0hAk7nVVIqfrWn9ufI0a9PNLVl+/u82mcoBEutgG8TL+0PHA360rSURFriDh4hOfgHaLaLQo0BxHqGVq3hnxi9DJ+V+BsmHnwsA1bXdPa0GzOoWct8bqeLdLrpNtX4y3jfZ7ztltj1ilVMJTh2GI11VNwui+oMvHi855dz4kQ46nJeBZN2pg/izV6xS/1msqfQi7HfqTJ07iT4mSoqqTcW0S9xfBJNx9Ic7G2jan/9PODpLijlgcRq1RuDdN1enIfFt7xUPjnPtaZoB4fwSVBO9dWrJn6U8JzoU+4s3F4+jsnqjE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR2101MB0934.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc26e145-88b5-4e45-c7fd-08d82a72d5f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2020 16:59:57.5341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b1wiwvWqdGFSgNyzDyXPQN/YJzKFMlxyD4l0IOXuDnUOHSA8LeA5XW49qRCsWeshPT6L5h5dpm1U25PSmuGKTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0933
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Friday, July 17, 2020 12:56 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: stephen@networkplumber.org; Chi Song <Song.Chi@microsoft.com>; KY
> Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; wei.liu@kernel.org; kuba@kernel.org;
> ast@kernel.org; daniel@iogearbox.net; kafai@fb.com; songliubraving@fb.com=
;
> yhs@fb.com; andriin@fb.com; john.fastabend@gmail.com;
> kpsingh@chromium.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next] net: hyperv: Add attributes to show RX/TX
> indirection table
>=20
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Fri, 17 Jul 2020 16:18:11 +0000
>=20
> > Also in some minimal installation, "ethtool" may not always be
> > installed.
>=20
> This is never an argument against using the most well suited API for
> exporting information to the user.
>=20
> You can write "minimal" tools that just perform the ethtool netlink
> operations you require for information retrieval, you don't have to
> have the ethtool utility installed.

This option is being considered by us as well.=20

Thanks,
- Haiyang
