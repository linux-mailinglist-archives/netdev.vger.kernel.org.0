Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3081230F6C2
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 16:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbhBDPre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 10:47:34 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23332 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237141AbhBDPhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 10:37:52 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 114FV4wt026901;
        Thu, 4 Feb 2021 07:37:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=49BAZs4Ewe3BfWGkhvZFRBwpVtF7KASYjv/W4tgI7J4=;
 b=Nygy5MLp0RvPe+N795ysI380gtxOn46QLHkB9JPuTHOTnEC6GySHvOonHnAfE2ZW+z93
 TdXeHKnCvDP+bxgqlDQizS/+91moIX844TBFpr2DZTqoPox/XnspKQXbPb41wbRblf8V
 VvojeWHEMRdvDG2QoFcqk3eZCR6ItqgeYiRn1PvHl2WvddRCPtFTTIzN+3/ZOgBJeWkb
 z7ilEfJFXhhfyUkF8pxl8XaZ8FrPdtjIZt/Pwe/LlL8718odYy/GMTpiPquAgmdr+FGv
 4nVHQWEmLYgHPiX+jZvwXguicRI8Nftzt3A7+B7m5xafA86aMfYkEv3sgdAJytfelM4N EQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36gg1t0sqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 04 Feb 2021 07:37:07 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Feb
 2021 07:37:06 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 4 Feb 2021 07:37:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FmMG6MmFWDsaoK6TeEJa9M9p8RQ2td9EE9G9Dss1iwNTroZDMbKAqzoOMi2R5ttMhic9vTqEaoOixhrpBe4HfnCcpKUAVGXI5yvRB8EknbA4Fl/ZJVD/WWi29QEYa1KKECGoEVyLTJB09kig0cj9h5xZGiiD33jDAxD7LxEQjnyLSLqLynMpvPeZbDZSXGE9rMMW0FVxEwc2n8IMax0rGZ4gUUifXV8lmFa3lQglPQIRvAzIWNu1lJDRTUs//gN+8O2VTkRx/hhBvEUb0m5dedoXLCPTiYZJ4QHXg3vvArNDO2u/TUo0tH0t3ekr0bA1lKyyEEc7DE/nQV9SCPyPiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49BAZs4Ewe3BfWGkhvZFRBwpVtF7KASYjv/W4tgI7J4=;
 b=gWO/UbC+5LX8vjC0/qKVKTEEavioa0CqtRBaJuajieHND8MQBRBVWuOaB0QcOGENbH/Wws5QoVcy8ZjnZ9HZmLI+iLzm0+U9UkKn/G4ge1EY5oloa1JYuZmBHdvHHLmvZQZTxs07EiJidLVpWCouAK3m7tbPJ/J+iSN9UjLolF//2RNglzGRyTGkqXbjQdr5GrHCRqsjW5P9fUgYomGdsjf/tFLzlQygXYwisLFLj2rLLfnT8eYjPu7YMLFyGaSX1bsZmafgeorqLEFHF4KP6PynX27bcsX37fPPS2NaPhMJ4cbiGwhYUJ+4nVV0FSpvnMiIfcdA6xv3FbVPWzhRwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49BAZs4Ewe3BfWGkhvZFRBwpVtF7KASYjv/W4tgI7J4=;
 b=i7teYgyLyt4J2wIAq8XxrvrUjsUVf7OnfAq2+ZKPD+R7TF2X8vlAz0K0AY5Q2e/27bQAUcaFUXpQmDTC98p3ODnDlUBAHEyVN5tqP+fswUinLnSWh2Yb8sBEnQdeG9O8wpoEDewl+sk80ccPp12IznED3T9ye06e0UEGRUIRlCQ=
Received: from MWHPR18MB1421.namprd18.prod.outlook.com (2603:10b6:320:2a::23)
 by MW2PR18MB2218.namprd18.prod.outlook.com (2603:10b6:907:5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Thu, 4 Feb
 2021 15:37:04 +0000
Received: from MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d]) by MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d%4]) with mapi id 15.20.3825.020; Thu, 4 Feb 2021
 15:37:04 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [Patch v3 net-next 6/7] octeontx2-pf: ethtool physical link
 status
Thread-Topic: [Patch v3 net-next 6/7] octeontx2-pf: ethtool physical link
 status
Thread-Index: Adb7Czx0WXIL4L/US6mltHqeljehYw==
Date:   Thu, 4 Feb 2021 15:37:04 +0000
Message-ID: <MWHPR18MB14219B4BBFA1E9A7E23621D4DEB39@MWHPR18MB1421.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.206.234.190]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c78741c-6920-42d3-66c1-08d8c922b953
x-ms-traffictypediagnostic: MW2PR18MB2218:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB221899BF4F37448BC49A8709DEB39@MW2PR18MB2218.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fVC7yq9N9r7ZNwNx/IOnv15vKM1tBz6R4x+bKItt8YGbYKpknHe6nobZxWQKtmGGUloHauFAWhcXP5zE+7tJmWyEOgY8/OexQEoPA8Uh2sQ/HJYcAnBXqiPWiKawmCNV+X2IiRzGSzafURfJgzzwvOOUzAtaXE5+SRTTSXCYpY5mXxJ+bHVCcYyoZ4aEH3nTL53e1aRQMaTCd2z4WbpyZytDw6yaN+0FNNX0bJ87EVY7fK8WZSjH8t2A6wKcRzyoQbyJCddW9Xbi0ntPRwykSix8RStAmI7Uy6sHm/4IeOMfebsHaiDGBSews9PapHfIx94da+B1mD1IbA8dHeevoCWQOGn9uq61EG+VesscZ0o/QOvp6KnNaZa0K/x0Cb1iuSeIcmrFRtJOaMZb2ci9ZLiBveNHoJaD209T2BnStzBBK99LeLbraw+OFPuXZ/IawfWZgKQRIt3/eAqAy57+df1mOUfN4m6p+d6DGVc5nkI84edejUKlhtDgJPlMCfb1LzYBDOuaG7b7ZMfoqVlTjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1421.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(366004)(136003)(376002)(9686003)(186003)(4326008)(478600001)(71200400001)(54906003)(86362001)(5660300002)(26005)(316002)(107886003)(66446008)(8676002)(7696005)(66476007)(66556008)(76116006)(55016002)(66946007)(6916009)(6506007)(83380400001)(8936002)(33656002)(2906002)(52536014)(64756008)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pXPGPmVfjBxde0T9H9YIYWCYiEZMPR8QFjmk6QxyjAD9wZzTCiOP4C2mnhmM?=
 =?us-ascii?Q?vFYacBa5QWsNSmF90yvOUQzRyw6rF7libRr3c+1EAirpsqWcxe3XkC2FKqJi?=
 =?us-ascii?Q?pgGV1zwPjLKcm31Y62VtzY7eGy1LI+7lh2NziS9T/ketmYtxJXU7oFS+Xl6X?=
 =?us-ascii?Q?6dDkZjDT+loRgwuDOwornrtJAiVPKZ2/AZfvQWHTC/FUhHWLAYz5BmCO4Y1e?=
 =?us-ascii?Q?2QqyVvz7mPavjiUE6Mhyf5MwImwpo/qfFJrHkcRsvjsWdeu6YIJQiYBiEBk4?=
 =?us-ascii?Q?JSuiylwWrzIk09zddEan+Djh5VxlHu9Jfp6jn4qDbpSCSynNJ3Ft0FSUuirA?=
 =?us-ascii?Q?JN1VkVin3yc63Hbe2bCBgZTpY33BwLOgx9++mIA21rd0i7mNw+GJFMvRppYH?=
 =?us-ascii?Q?FxR05M6Yyct11GoBA41wmcmyc4BUzFJUgd4Rw1t5i8Ynkx2qKhtOCgwdtz1j?=
 =?us-ascii?Q?a50vOzElx3A3rq8htjhKJTBN0Z7VmRMycnTBLZwhwj2a+Y9I6QLT9nVNCI8+?=
 =?us-ascii?Q?61goPngLYFI1nc6FtyJAPB/2qNDjF7fLTwct+t8gUsg4pig2tIMX9LdlGrhw?=
 =?us-ascii?Q?9EbGMmwMK8lCOixc6EtTrQTFVrXLmCUbLNib6eQGFkIJFOTo8y6GIUeLPTWP?=
 =?us-ascii?Q?X6VzNWkrHg8EYxBlJp4prQpLIjXHPIcA39Pp/5sFRSLwz4EnQzr8wumwsrdQ?=
 =?us-ascii?Q?gP+FIBWCXhfSecfzb/L77UjTb6TkZUOGDQR1zqRP8hVPEQRyKjOEoO+4lSYO?=
 =?us-ascii?Q?5um9JFXnev/N/VxVFvZSL3oGruCdKqI7NDgTYsZFvqCGgKBK2iYW9Li80CAE?=
 =?us-ascii?Q?fpehaQgBdfrlggcWkOsZgWpwGXJOOWsAwybu+/b906fWIQ07y4VvlqqaSebd?=
 =?us-ascii?Q?7zkLAcKkhW/lqxIqAo4kEEXGffdDOkQaTHxECFfaPkKQbWFsquhOQGyvmOo5?=
 =?us-ascii?Q?uvXfhNlo2i1pKbW5QqDM6woYbnhbt09T26Rahfs21kaw0y+XqFxDEoCnBubl?=
 =?us-ascii?Q?r31xUcTeYMPjfwc0dkZJVkTjpXA3sO1CJbuG0kGP+xguuyhdxtkIx3cffhK+?=
 =?us-ascii?Q?dCt7Eu+duqPZZMe9xgrsQDEjlCFfRvyu4SLyvz3mtSmEtOq0nFryWX/m0dgk?=
 =?us-ascii?Q?s9pQ1aBDojKDiBUO+aUBHLo+Hc71uLVCyhJYqjL03f6MtoCqmZAdQSqVVaMW?=
 =?us-ascii?Q?tZ0yS5FvwDnD6yYi7tyrM0w7I9Xwhqxwq4XTVUK7dDu/r0gXuG/zpyDzaNcK?=
 =?us-ascii?Q?oMdHzBiEHYApER2cNfXN2vn91uyGdyMN0Ir+E9zeS/6dqqfxbl6DMk0MFV0+?=
 =?us-ascii?Q?bo8g8CvaARsM/e8OlN4dJ4T0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1421.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c78741c-6920-42d3-66c1-08d8c922b953
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 15:37:04.6957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c6Vd9e7SudtcCn4UkJFjFvZNJLbH77rfvV/+ZOjpXaRqH1Ve0u/498ev88k2v6zxpTSfzi8yYrSdpG3eZAHxAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2218
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-04_08:2021-02-04,2021-02-04 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, February 3, 2021 6:54 AM
> To: Hariprasad Kelam <hkelam@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net; willemdebruijn.kernel@gmail.com;
> andrew@lunn.ch; Sunil Kovvuri Goutham <sgoutham@marvell.com>; Linu
> Cherian <lcherian@marvell.com>; Geethasowjanya Akula
> <gakula@marvell.com>; Jerin Jacob Kollanukkaran <jerinj@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
> Subject: [EXT] Re: [Patch v3 net-next 6/7] octeontx2-pf: ethtool physical=
 link
> status
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Sun, 31 Jan 2021 18:41:04 +0530 Hariprasad Kelam wrote:
> > From: Christina Jacob <cjacob@marvell.com>
> >
> > Register get_link_ksettings callback to get link status information
> > from the driver. As virtual function (vf) shares same physical link
> > same API is used for both the drivers and for loop back drivers simply
> > returns the fixed values as its does not have physical link.
> >
> > ethtool eth3
> > Settings for eth3:
> >         Supported ports: [ ]
> >         Supported link modes:   10baseT/Half 10baseT/Full
> >                                 100baseT/Half 100baseT/Full
> >                                 1000baseT/Half 1000baseT/Full
> >                                 10000baseKR/Full
> >                                 1000baseX/Full
> >         Supports auto-negotiation: No
> >         Supported FEC modes: BaseR RS
> >         Advertised link modes:  Not reported
> >         Advertised pause frame use: No
> >         Advertised auto-negotiation: No
> >         Advertised FEC modes: None
> >
> > ethtool lbk0
> > Settings for lbk0:
> > 	Speed: 100000Mb/s
> >         Duplex: Full
> >
> > Signed-off-by: Christina Jacob <cjacob@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > ---
> >  .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 151
> > +++++++++++++++++++++
> >  1 file changed, 151 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > index e5b1a57..d637815 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/etherdevice.h>
> >  #include <linux/log2.h>
> >  #include <linux/net_tstamp.h>
> > +#include <linux/linkmode.h>
> >
> >  #include "otx2_common.h"
> >  #include "otx2_ptp.h"
> > @@ -32,6 +33,24 @@ struct otx2_stat {
> >  	.index =3D offsetof(struct otx2_dev_stats, stat) / sizeof(u64), \  }
> >
> > +/* Physical link config */
> > +#define OTX2_ETHTOOL_SUPPORTED_MODES 0x638CCBF
> //110001110001100110010111111
> > +#define OTX2_RESERVED_ETHTOOL_LINK_MODE	0
>=20
> Just use 0 directly in the code.
>=20
Will fix this in next version.

> > +static const int otx2_sgmii_features_array[6] =3D {
> > +	ETHTOOL_LINK_MODE_10baseT_Half_BIT,
> > +	ETHTOOL_LINK_MODE_10baseT_Full_BIT,
> > +	ETHTOOL_LINK_MODE_100baseT_Half_BIT,
> > +	ETHTOOL_LINK_MODE_100baseT_Full_BIT,
> > +	ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
> > +	ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
> > +};
>=20
> Why is this one up at the top of the file but other arrays are not?
> It seems to be used only in once function.
>
Yes . This array used in only in once function.=20
Will fix in next version.
=20
> > +enum link_mode {
> > +	OTX2_MODE_SUPPORTED,
> > +	OTX2_MODE_ADVERTISED
> > +};
> > +
> >  static const struct otx2_stat otx2_dev_stats[] =3D {
> >  	OTX2_DEV_STAT(rx_ucast_frames),
> >  	OTX2_DEV_STAT(rx_bcast_frames),
> > @@ -1034,6 +1053,123 @@ static int otx2_set_fecparam(struct net_device
> *netdev,
> >  	return err;
> >  }
> >
> > +static void otx2_get_fec_info(u64 index, int req_mode,
> > +			      struct ethtool_link_ksettings *link_ksettings) {
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(otx2_fec_modes) =3D { 0, };
> > +
> > +	switch (index) {
> > +	case OTX2_FEC_NONE:
> > +		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_NONE_BIT,
> otx2_fec_modes);
> > +		break;
> > +	case OTX2_FEC_BASER:
> > +		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT,
> otx2_fec_modes);
> > +		break;
> > +	case OTX2_FEC_RS:
> > +		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT,
> otx2_fec_modes);
> > +		break;
> > +	case OTX2_FEC_BASER | OTX2_FEC_RS:
> > +		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT,
> otx2_fec_modes);
> > +		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT,
> otx2_fec_modes);
> > +		break;
> > +	}
> > +
> > +	/* Add fec modes to existing modes */
> > +	if (req_mode =3D=3D OTX2_MODE_ADVERTISED)
> > +		linkmode_or(link_ksettings->link_modes.advertising,
> > +			    link_ksettings->link_modes.advertising,
> > +			    otx2_fec_modes);
> > +	else
> > +		linkmode_or(link_ksettings->link_modes.supported,
> > +			    link_ksettings->link_modes.supported,
> > +			    otx2_fec_modes);
> > +}
> > +
> > +static void otx2_get_link_mode_info(u64 link_mode_bmap,
> > +				    bool req_mode,
> > +				    struct ethtool_link_ksettings
> > +				    *link_ksettings)
> > +{
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(otx2_link_modes) =3D { 0, };
> > +	u8 bit;
> > +
>=20
> No empty lines in the middle of variable declarations.
>=20
Thanks for pointing this. Will fix in next version.

> > +	/* CGX link modes to Ethtool link mode mapping */
> > +	const int cgx_link_mode[27] =3D {
> > +		0, /* SGMII  Mode */
> > +		ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
> > +		ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
> > +		ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
> > +		ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
> > +		ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
> > +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> > +		ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
> > +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> > +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> > +		ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
> > +		ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
> > +		ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
> > +		ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
> > +		ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
> > +		ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
> > +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> > +		ETHTOOL_LINK_MODE_50000baseSR_Full_BIT,
> > +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> > +		ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
> > +		ETHTOOL_LINK_MODE_50000baseCR_Full_BIT,
> > +		ETHTOOL_LINK_MODE_50000baseKR_Full_BIT,
> > +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> > +		ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
> > +		ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT,
> > +		ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
> > +		ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT
> > +	};
> > +
> > +	link_mode_bmap =3D link_mode_bmap &
> OTX2_ETHTOOL_SUPPORTED_MODES;
> > +
> > +	for_each_set_bit(bit, (unsigned long *)&link_mode_bmap, 27) {
> > +		/* SGMII mode is set */
> > +		if (bit  =3D=3D  0)
>=20
> Double spaces x2
>
Will fix this in next version.
=20
> > +			linkmode_set_bit_array(otx2_sgmii_features_array,
> > +
> ARRAY_SIZE(otx2_sgmii_features_array),
> > +					       otx2_link_modes);
> > +		else
> > +			linkmode_set_bit(cgx_link_mode[bit],
> otx2_link_modes);
> > +	}
> > +
> > +	if (req_mode =3D=3D OTX2_MODE_ADVERTISED)
> > +		linkmode_copy(link_ksettings->link_modes.advertising,
> otx2_link_modes);
> > +	else
> > +		linkmode_copy(link_ksettings->link_modes.supported,
> > +otx2_link_modes); }
>=20
> > +	otx2_get_link_mode_info(rsp->fwdata.advertised_link_modes,
> OTX2_MODE_ADVERTISED, cmd);
> > +	otx2_get_fec_info(rsp->fwdata.advertised_fec,
> OTX2_MODE_ADVERTISED,
> > +cmd);
> > +
> > +	otx2_get_link_mode_info(rsp->fwdata.supported_link_modes,
> OTX2_MODE_SUPPORTED, cmd);
> > +	otx2_get_fec_info(rsp->fwdata.supported_fec,
> OTX2_MODE_SUPPORTED,
> > +cmd);
>=20
> Wrap those lines please.
>=20
Will fix this in next version.

> > +	return 0;
> > +}
>=20
> > +static int otx2vf_get_link_ksettings(struct net_device *netdev,
> > +				     struct ethtool_link_ksettings *cmd) {
> > +	struct otx2_nic *pfvf =3D netdev_priv(netdev);
> > +
> > +	if (is_otx2_lbkvf(pfvf->pdev)) {
> > +		cmd->base.duplex =3D DUPLEX_FULL;
> > +		cmd->base.speed =3D SPEED_100000;
> > +	} else {
> > +		return	otx2_get_link_ksettings(netdev, cmd);
>=20
> Double space

Will fix this in next version.

Thanks,
Hariprasad k
