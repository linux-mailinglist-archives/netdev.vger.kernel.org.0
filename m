Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D200E30938D
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhA3Jkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:40:39 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45164 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231923AbhA3Jjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 04:39:32 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10U9WTwF026581;
        Sat, 30 Jan 2021 01:38:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=8jH+DS8hxgGpgMUnUId+Tv1sIUsEZE0aG7EQ96+d6n0=;
 b=JOBG8BFt2aK1zJ0Eqh5rRcZM7a3U19G8ZkyF9jjxB3q7r97+/7gP+wdb8klWwS1mCVtT
 9LZyloP7RablQ18dm+9qLLtrBlcSSbibaMei9YoMFn0u0Liz39GZo1mBVWdMIslDUbBV
 eaaAvrmDH0zADQeYl/5e3sk3l1ilk68oUv2cdqyvQvOAdUu6NyX7kAcDPw2w+rdxVwZs
 JKywtl6/24xxc2DxKkFhXqzfUmetTtg5kGOa/7xsr9b9hbBOOChaRdzDPoP6Kh1fPv9j
 2bEKIw/3e6EILo8gSAIc8PUupgapqmX4tMKNQyWVvNzqlATCRI5+K4LuMaqqWBprid+f Mw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36d0rsgasc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 30 Jan 2021 01:38:26 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 30 Jan
 2021 01:38:25 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 30 Jan
 2021 01:38:25 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 30 Jan 2021 01:38:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJ8s+R94fxGaHhNsu64unExay7rjzR0A1dcR/tcs1dUEDzQXXe8uWDf9snOeisqiVLzuq3tTrJ+uj0AY/yizGTcwUZfG5qiR4b9xbE38xjfMEnET5bLNuHBGAAB9HhtmXAVEqm1ObLQrk4SWwjDS3J7rZK/fkcZIj8Wltz4KhaGP9T+JoM3jIucf7SbLrAPNMK9CnMOARB9Zrh9VZbI+MUCm0NinEnQcC9PGzVxGu9OndqGPMJtIljGHvudijAbqXO+4rWAbWnT7vn26q6enrYARFNC8ZogOWY0X3DONeldhzEzJ/Lc8dZwdJhaIZkl4RU7SNXPzz41pKOOayYqpLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jH+DS8hxgGpgMUnUId+Tv1sIUsEZE0aG7EQ96+d6n0=;
 b=gdletzQVe9TCBW5L1X2PUzQMpGzo+talgq1jG9+ws9pGu1Hh3zOhFBQKR0vj/iuP4A+4KnSAkEymG6EvdO96/Xbu9zOp/299Qv6XqO3qII/wvIPXiXo4N4todtIxQ9KEc41yhAaqyfNNFB8L30AF7s5RLpGK+gmSrLS+mNXjqXyFPNEu9HL1irfsYPgvk7T+FVRQ8autC1RA4Mw3YZIngcLmqn2lKVwBlwmWCl2G+jHW+DEqcdzMfxjjGP47llGgxRwmOH5m04VklLGpkEEehTuiQqLk6w07H+vkfbt97fD1cJTWYyHJKRi0wrRKDIGeUHm6XYMew7DVlBVeh0o6Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jH+DS8hxgGpgMUnUId+Tv1sIUsEZE0aG7EQ96+d6n0=;
 b=cdnTb/9PnJgSqDm9lplseSvHhMo57nI9jCFv39JTPK4UxvljtGIdNu4L6XgoaqOmjqLUV9yxFRjCZaGwMqgpzJgKAwxzcYRej3FBuQ/a5KoGxg+ifk6yDvvVMfNj4yT7XrMykpmt9XMXvkHt3PAJTOcuXYATzpuucSrhD9x18GI=
Received: from MWHPR18MB1421.namprd18.prod.outlook.com (2603:10b6:320:2a::23)
 by MW3PR18MB3481.namprd18.prod.outlook.com (2603:10b6:303:2d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Sat, 30 Jan
 2021 09:38:22 +0000
Received: from MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d]) by MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d%4]) with mapi id 15.20.3805.022; Sat, 30 Jan 2021
 09:38:22 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "Jerin Jacob Kollanukkaran" <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Christina Jacob <cjacob@marvell.com>
Subject: Re: [Patch v2 net-next 4/7] octeontx2-af: Physical link configuration
 support
Thread-Topic: [Patch v2 net-next 4/7] octeontx2-af: Physical link
 configuration support
Thread-Index: Adb26zLQ06qJ4/HeT7WJh0ppmSl0fQ==
Date:   Sat, 30 Jan 2021 09:38:21 +0000
Message-ID: <MWHPR18MB14211765ABBCF76C2429E7B0DEB89@MWHPR18MB1421.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.201.216.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f6db32a-638a-43ba-9761-08d8c502c8c8
x-ms-traffictypediagnostic: MW3PR18MB3481:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB34810A61C51C988892551848DEB89@MW3PR18MB3481.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zYB0I01Bh8Fuvy1FmolG1EZO5YZ6CyzVA99ayLI2CWR1aZdYRptx98Hkwb6/iZm0WPOwUhnMUet2y6i99Ufxpf44HYtKxJbvabzFK5PTUqioUm4oL+8cdlywKdajsNNlHxL60IzWpwOoe5GpOvQ7MuJYF3QJVhgCTpZE2ccn7OQLJjrkIecyRFRs2uBJZe+NEXeaChpnJKY7l3zCkHuz9SMygtUgSgS/pLrawOZVAGF9zta3VUjyGReiWXCml4Pc9ILu2Ai8C+76lPU8SlXqC4lRfB1BZWmWPWBODPf5KTq4qMOVoxZXg5H9odi/OVy3N48xjnwPLSnugSeD7WSxwt6gYM0djFLwx24bIaSGhkx66AjACihOQSUUkkaP3UGrM0mVWJikfI3rWSFJGWZKQtwSAcTZdezGcxyU5f2M41QmflCcc6dRGNdanBt85VToqX06hYzaAVCRWAjx3OutL0mjTgPwxd5OhvkBswF5GOFrZqvxgKLbQOZKWrlmB1WEHCPb11RckSsZG5WxLtNW1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1421.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(66446008)(64756008)(2906002)(316002)(54906003)(76116006)(66946007)(66476007)(66556008)(55016002)(9686003)(4326008)(107886003)(7696005)(83380400001)(186003)(8676002)(55236004)(26005)(71200400001)(33656002)(52536014)(53546011)(6916009)(6506007)(5660300002)(478600001)(8936002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3bRRJM9A9kSbVpw3VoVRWlOPt+5bzPMXkEyYzM5euiAZhBp35nKWJO2RctZb?=
 =?us-ascii?Q?6Y5WaA3FDlV0zhx+zE0mbwWzfDHEbch6TZwucHd4Y0U4MFt4wuabegT6dHAE?=
 =?us-ascii?Q?EtyGwesFHhsMeqnRtTstn/Hfm0knasbn4xsN5f39L0bI51e5yNlgTL4gLPFl?=
 =?us-ascii?Q?hrt+0wh7Mgpsem2E7IpUjAnbU9T1B0yK/dAekzKqtL5V1V5zb1v+y9/XsLOn?=
 =?us-ascii?Q?tnFJg0wWQWm4t7uahYcUZmK3u5U5OxX1RlnWQTU/sFbAD6aEoQxs7SP3/Uwk?=
 =?us-ascii?Q?61py1QfrR7XAuelNXeGG4tyrTBRU5sO4pxJzfUaXROAYXAOHOg9D01L2pF71?=
 =?us-ascii?Q?j3zrUY7W9AaGtMxq6Tiu7CLvfcCzJ8nQuqlJSH+j+nGWQXrzSt25q32vlppF?=
 =?us-ascii?Q?hvjeZaPKMPq4IHJrcxuRt+jM1YzHHxahaTo1jC+w4y20GoPhhf3UHKiCX0SX?=
 =?us-ascii?Q?fwlC5egLlgvWtUBdpFJknvRZlQjoFPTeo1WWDSF4mDM5QU1lpgMOugfew29z?=
 =?us-ascii?Q?iMFI9W6fZMBTjZP6hwzWLH18Ar3LIA0CvDLBP5HUsOpWTi60Kn9qPOL9bCQS?=
 =?us-ascii?Q?6MciNF1ifavv6wbLrydsJpWIL7G4prxCSDyAzVU65LwDj0dP2eJ47GkFOu7d?=
 =?us-ascii?Q?n6smBawmPsAIotGVGJyl7aJGXywPrC3a4pvhpAcng7gXTDByUIRBGOTSCRfe?=
 =?us-ascii?Q?mDNP0oXxpFBsYuJ6rxwmKYHkI74nd1nfHmnxYAHJvUha+9LdRzJeMRAeq5ly?=
 =?us-ascii?Q?bRpWWKfNPl2Vm3lB/wxOe0mjaqjTh3cwMeTAO/4Hm4TMiwnm4YUHKxV7G1wd?=
 =?us-ascii?Q?32IEr6t/cOIDLNmR+SrPpF+IPAQZpHqOXU/3cppTVjE+kR448zZtawFe9j+k?=
 =?us-ascii?Q?4IrjNxuM/dZOAc+elAOxlmZ+oCxAh+ZhBNOE8+EWtRCjB4tq/1lXcj1P0hqy?=
 =?us-ascii?Q?0P8lKC/LjDEyhBdsDZgRAt71xpAFAIMe08dHYyEWN4Ux0oahZoscwHQ6WA2+?=
 =?us-ascii?Q?UYT85hykJaA7r42mLD4uBmcbRqhczAL9JCU35142FUSSCCsM2ga486G4NCat?=
 =?us-ascii?Q?IFWEojBf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1421.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f6db32a-638a-43ba-9761-08d8c502c8c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2021 09:38:21.8882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cSldpbzhy1HVeHryuf2Ncaekg/aXoYInxVNRbR/Db0kBWG1CXhwRdjYEVNhX0ajT1AzkHB3TOxhfAtyB62IEuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3481
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-30_06:2021-01-29,2021-01-30 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew Lunn,



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, January 27, 2021 6:56 PM
> To: Hariprasad Kelam <hkelam@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net; kuba@kernel.org; Sunil Kovvuri Goutham
> <sgoutham@marvell.com>; Linu Cherian <lcherian@marvell.com>;
> Geethasowjanya Akula <gakula@marvell.com>; Jerin Jacob Kollanukkaran
> <jerinj@marvell.com>; Subbaraya Sundeep Bhatta <sbhatta@marvell.com>;
> Christina Jacob <cjacob@marvell.com>
> Subject: [EXT] Re: [Patch v2 net-next 4/7] octeontx2-af: Physical link
> configuration support
>=20
> On Wed, Jan 27, 2021 at 01:15:49PM +0530, Hariprasad Kelam wrote:
> > From: Christina Jacob <cjacob@marvell.com>
> >
> > CGX LMAC, the physical interface support link configuration parameters
> > like speed, auto negotiation, duplex  etc. Firmware saves these into
> > memory region shared between firmware and this driver.
> >
> > This patch adds mailbox handler set_link_mode, fw_data_get to
> > configure and read these parameters.
> >
> > Signed-off-by: Christina Jacob <cjacob@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > ---
> >  drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 60
> +++++++++++++++++++++-
> >  drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  2 +
> >  .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  | 18 ++++++-
> >  drivers/net/ethernet/marvell/octeontx2/af/mbox.h   | 21 ++++++++
> >  .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 17 ++++++
> >  5 files changed, 115 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > index b3ae84c..42ee67e 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > @@ -658,6 +658,39 @@ static inline void cgx_link_usertable_init(void)
> >  	cgx_lmactype_string[LMAC_MODE_USXGMII] =3D "USXGMII";  }
> >
> > +static inline int cgx_link_usertable_index_map(int speed) {
>=20
> Hi Christina, Hariprasad
>=20
> No inline functions in .c files please. Let the compiler decide.
>
  will fix this in next version
=20
>=20
> > +	switch (speed) {
> > +	case SPEED_10:
> > +		return CGX_LINK_10M;
> > +	case SPEED_100:
> > +		return CGX_LINK_100M;
> > +	case SPEED_1000:
> > +		return CGX_LINK_1G;
> > +	case SPEED_2500:
> > +		return CGX_LINK_2HG;
> > +	case SPEED_5000:
> > +		return CGX_LINK_5G;
> > +	case SPEED_10000:
> > +		return CGX_LINK_10G;
> > +	case SPEED_20000:
> > +		return CGX_LINK_20G;
> > +	case SPEED_25000:
> > +		return CGX_LINK_25G;
> > +	case SPEED_40000:
> > +		return CGX_LINK_40G;
> > +	case SPEED_50000:
> > +		return CGX_LINK_50G;
> > +	case 80000:
> > +		return CGX_LINK_80G;
> > +	case SPEED_100000:
> > +		return CGX_LINK_100G;
> > +	case SPEED_UNKNOWN:
> > +		return CGX_LINK_NONE;
> > +	}
> > +	return CGX_LINK_NONE;
> > +}
> > +
> >  static inline void link_status_user_format(u64 lstat,
> >  					   struct cgx_link_user_info *linfo,
> >  					   struct cgx *cgx, u8 lmac_id)
>=20
> So it looks like previous reviews did not catch inline functions. So lets=
 say, no
> new inline functions.
>=20
>      Andrew

Thanks for the review. I will fix this in next version.

Thanks,
Hariprasad k
