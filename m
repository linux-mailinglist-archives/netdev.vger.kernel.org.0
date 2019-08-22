Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5404998F0A
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 11:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbfHVJR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 05:17:26 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37384 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727910AbfHVJR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 05:17:26 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7M9FtlU030462;
        Thu, 22 Aug 2019 02:17:01 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uhag22wra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Aug 2019 02:17:01 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id x7M9H0uo031237;
        Thu, 22 Aug 2019 02:17:00 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uhag22wr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 22 Aug 2019 02:17:00 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 22 Aug
 2019 02:16:59 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (104.47.49.51) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 22 Aug 2019 02:16:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ULa1DcR3zzfBrzdNbMYILIfHtfidlenp0bldQZbKKlO+wj3qNsFL68WXPYS7z5i+3QXPZ1QekwPIjKRoALKWZ1h1q2YSS+hEMigdX/ui1ulMsPBmsZAOJkX4NGn/NAW2D5CumILvLKGtAon36HAMAUig32c3319jY6hSG5w9g9LDemJfpSazVx4IHxJ4URjf+lckjRmer1D4h10c2vIKBrKGzaX5+b+7N1dJd6ZBjxYhUlpeYni9qrD16NrcLSv+yyG7Tis5kKCYQwTFAmHo/5Yy7ES1goI0JHJ2VC+AQJYCY52dnmg874iOhhqqY6TAGBnTYDcXV3OdOckDj+OPWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MePbq4j52tJF4JEJgLukUXBH/ccCoa3i+0AV0NLsh1s=;
 b=Jz+iUtrhiyrEQ7jt/I4oR0FrqoWfs/mVQYqrHXdFNejd+okfPzyn7uyfj/BNk6yg0I+TfpT0FgDPu3E9T5/6sF8EhkM2vmkxvMAjxVPbGPVsNAyRpltXUSuwc4BTjTGBp/pmt1vVAooTK5iolhSveMZFoVFBjILjykfPvtv6AVNaXYxOCLNfBuCEIHD5062bRn9bgqm1G/5JzjqvFd4+r74uKFS115KR+VD0VcNiHPSVHDRqWedFAztAHg9Xtz9D5dPPPM6iAKTScE4SvIAPhs1wmu/uWCBieDlaNr9ZNqx1jkGnVgMi5hU7Kb5EIUgzYLYh4XKb6AK3M4aRSlzWfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MePbq4j52tJF4JEJgLukUXBH/ccCoa3i+0AV0NLsh1s=;
 b=e/yicAUNywAYxAP7FC3K6XZ7LZELFO0ErwjVlhM4za8TP3hQ0ADhE5lmi5vAHRiWHe/LGostvN5y58pC3eSMtghJ9C/TrKjXDmz0Nu82bgbQOWPHFpMEH/+mDFCBG9qG4Oq9Ed+tqB+IKV2XoUkrW0x4qRgclk/aWJ2X79muZeY=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2832.namprd18.prod.outlook.com (20.179.22.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 09:16:53 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9%7]) with mapi id 15.20.2178.018; Thu, 22 Aug 2019
 09:16:53 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Colin Ian King <colin.king@canonical.com>
Subject: RE: [PATCH v1] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for wider
 use
Thread-Topic: [PATCH v1] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for wider
 use
Thread-Index: AQHVV7/ZmldgulT65kmEtBsRoL+bcqcFVU2AgAFBwpCAAEvjgIAAAG1g
Date:   Thu, 22 Aug 2019 09:16:53 +0000
Message-ID: <MN2PR18MB25280B027FBABA5838DD1978D3A50@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190820163112.50818-1-andriy.shevchenko@linux.intel.com>
 <1a3e6660-10d2-e66c-2880-24af64c7f120@linux.alibaba.com>
 <20190821092541.GW30120@smile.fi.intel.com>
 <MN2PR18MB2528511CEFCBC2BE07947BAAD3A50@MN2PR18MB2528.namprd18.prod.outlook.com>
 <20190822090855.GL30120@smile.fi.intel.com>
In-Reply-To: <20190822090855.GL30120@smile.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2402:3a80:52c:5247:9c86:6b60:b861:fd67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52425a59-6d6a-4496-f051-08d726e17931
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR18MB2832;
x-ms-traffictypediagnostic: MN2PR18MB2832:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB28326D276B8EE9BE610B7DB2D3A50@MN2PR18MB2832.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(396003)(346002)(366004)(13464003)(189003)(199004)(229853002)(71190400001)(8936002)(316002)(6916009)(2906002)(6246003)(76116006)(66446008)(6436002)(66556008)(64756008)(66946007)(81156014)(99286004)(8676002)(76176011)(9686003)(5660300002)(81166006)(7696005)(53936002)(66476007)(478600001)(6116002)(54906003)(4326008)(25786009)(14454004)(71200400001)(33656002)(74316002)(256004)(7736002)(305945005)(55016002)(52536014)(476003)(486006)(11346002)(53546011)(6506007)(446003)(102836004)(46003)(86362001)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2832;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: e67FyOuEK4aIWB6bBAonVA1P8v+XfY4LEx7y41icDkZBmB374OC6E21kF7Yxucyl5GkDkxwzeOQ7sOw/I2zxMj/+JBZ0qHJUNpsJToXaZEk7rLkS7a9VhUSehX95D77spWlkviRrU/yDsPykwOH2tFI+G3kkNVotLF7OgaSrHrAWdQzDmmMcGQA8iu9NhFtTAyUwCv5TJTzSxf8b8SmNmk6izcVlGptU5gq4QjCHNuTt+8J/fSyLki44XcjYlOAbzFNf75bRByHoEq8E9/u6b83WppWsGQfVflC9Rund29vB63WwHaRX+fsxcuiCv12mDXIFj2uJlTDw/B+tkkEflw5bIoPwmOgSEQFUCDNT9PeN5fzpz7BQR+ZfmOdO8KYiJU6BiJxClh1RldH/7aYLxwa1AQA47pjoO9qJn0IlQJs=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 52425a59-6d6a-4496-f051-08d726e17931
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 09:16:53.7638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2EJBDxWqbzlXEpTzNPbDWRLjCSqWaOvdL0iOjg4UB5tL8u9q9VsxEvDalYmo7SI6hGY4m5KnKoXNlmy+0tTQmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2832
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-22_06:2019-08-19,2019-08-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Sent: Thursday, August 22, 2019 2:39 PM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com>; Mark Fasheh
> <mark@fasheh.com>; Joel Becker <jlbec@evilplan.org>; ocfs2-
> devel@oss.oracle.com; Ariel Elior <aelior@marvell.com>; GR-everest-linux-=
l2
> <GR-everest-linux-l2@marvell.com>; David S. Miller
> <davem@davemloft.net>; netdev@vger.kernel.org; Colin Ian King
> <colin.king@canonical.com>
> Subject: Re: [PATCH v1] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for
> wider use
>=20
> On Thu, Aug 22, 2019 at 05:46:07AM +0000, Sudarsana Reddy Kalluru wrote:
> >
> > > -----Original Message-----
> > > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On
> > > Behalf Of Andy Shevchenko
> > > Sent: Wednesday, August 21, 2019 2:56 PM
> > > To: Joseph Qi <joseph.qi@linux.alibaba.com>
> > > Cc: Mark Fasheh <mark@fasheh.com>; Joel Becker <jlbec@evilplan.org>;
> > > ocfs2-devel@oss.oracle.com; Ariel Elior <aelior@marvell.com>;
> > > Sudarsana Reddy Kalluru <skalluru@marvell.com>; GR-everest-linux-l2
> > > <GR-everest- linux-l2@marvell.com>; David S. Miller
> > > <davem@davemloft.net>; netdev@vger.kernel.org; Colin Ian King
> > > <colin.king@canonical.com>
> > > Subject: Re: [PATCH v1] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h
> > > for wider use
> > >
> > > On Wed, Aug 21, 2019 at 09:29:04AM +0800, Joseph Qi wrote:
> > > > On 19/8/21 00:31, Andy Shevchenko wrote:
> > > > > There are users already and will be more of BITS_TO_BYTES() macro=
.
> > > > > Move it to bitops.h for wider use.
>=20
> > > > > -#define BITS_TO_BYTES(x) ((x)/8)>
> > > > I don't think this is a equivalent replace, or it is in fact wrong
> > > > before?
> > >
> > > I was thinking about this one and there are two applications:
> > > - calculus of the amount of structures of certain type per PAGE
> > >   (obviously off-by-one error in the original code IIUC purpose of
> > > STRUCT_SIZE)
> > > - calculus of some threshold based on line speed in bytes per second
> > >   (I dunno it will have any difference on the Gbs / 100 MBs speeds)
> > >
> > I see that both the implementations (existing vs new) yield same value =
for
> standard speeds 10G (i.e.,10000), 1G (1000) that device supports. Hence t=
he
> change look to be ok.
>=20
> Thank you for testing, may I use your Tested-by tag?
Sorry, I didn't test the actual driver flows. Was only referring to the out=
put values for 1000/10000 speed values.

>=20
> --
> With Best Regards,
> Andy Shevchenko
>=20

