Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38443301CCF
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 15:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbhAXOo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 09:44:28 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43920 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725798AbhAXOo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 09:44:27 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10OEfYZe008190;
        Sun, 24 Jan 2021 06:43:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=AB5GzbXi2gKtTR2wNlwSohx9lNiSHsOtSjj6s0zeV14=;
 b=fVx3bUY8DVhLRlxjmtPoTjrbhWG+RwfUToskajXJWlaimx7VJ/6yqodDAyKxmOlm1v4s
 +0iTkhSTo8ZhxUk/Ta4AbS02WsxHpzY+gQxxpDDYJVgTyuA3pP5St6dgjcXRdfSgYnw7
 1OGsAUh0QLE3rEMeB+/+ov+S57KS61qn+L3MJdkGI/HqMJz5THzUHFR3KctH4a8mpspG
 yxinnLCb3jNaiUygqwjtSGAPcKl0G2X93kCJDAY+rh/WAjQZwStUkDSe5dZ2bW8Q01MK
 lzLXoU+uSQ08Yjw3EUjTTky5RJ8esaxLkZEHMBbE0XK2JYw4K53H+TEyXu6EIVGDawpv Uw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1u28a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jan 2021 06:43:33 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 06:43:32 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 24 Jan 2021 06:43:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPbPjv21/Cr1OuzzMw/idfKD3PCzL25/p118Kn835S0yDiBQvguFjZw+GRzPc0xr6AeChiOQdoK8/gj1zPDZ4CXV4S429OqskkhyaRTZYfR+vYVkIyCF2D3F/GgJPs/bNwC9QUXclQ+GkjOFISW966LLR7o2ZcsjLxGAgJHYg42IhAsgILKPwMG/4cUkiZn1xJoVjzUK9lRI4g3tgduTqVeHDk5lPomeyMd0/O3uymHGpAfqc/dEAJ2CFjs2gnsZNQoHV5pLXoKgSRlhPPMw62yYVDxYnrRTXbDjJ/UHqX8fu4lsXerWyYrM6nq5toj4CbIBHpqM1THsVwu33PcHlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AB5GzbXi2gKtTR2wNlwSohx9lNiSHsOtSjj6s0zeV14=;
 b=OXSN3gPzZAU4so+B66ehsD8+n96AfI4JTo0rW79eNZdifqEFXw/fm7MFclbVT7ZTC3iOUGGwl2ZQ9otYGOpXdszWx2c0waCtafEXc14d8SZoHc/Yu7UB26p/5NNtP7QIOOwKjKpXBRAeqm2UCAzrL2jTF5wkeSu25yI+PxMssrERGLtI3DIRamqnOSPqsxUx2IArphtWIlj4xAJH0INb9z2dp+4O5iI9OwfhZqDGUn7vw0Vfw5OUo2isHXFuh73EXRFXjK1EcnfzXW2wdDO/aNhY/2EKnCe+GcRgufbLrlfmI0eRNWtTKUG8/d5GTYzH5lQpZKqM3pVcpmNxR66cAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AB5GzbXi2gKtTR2wNlwSohx9lNiSHsOtSjj6s0zeV14=;
 b=PRYeHG1FnaiVBS9VPdZWa/hu0P78pz5I6o3pI0e2UxjH1kOAtt3CSiyKmOV3QdrFtAeAkr6DRbhCB0eL1mXbUzn3y6xae/v8fW15/x03PiHdy2Cn8oRH4cd/FbQenu2pDAv2Cxja9mC1dVw5VHkOnQcjzScahmj++M75cKTniCA=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1087.namprd18.prod.outlook.com (2603:10b6:300:a2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Sun, 24 Jan
 2021 14:43:31 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3784.017; Sun, 24 Jan 2021
 14:43:30 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 RFC net-next 08/18] net: mvpp2: add FCA
 periodic timer configurations
Thread-Topic: [EXT] Re: [PATCH v2 RFC net-next 08/18] net: mvpp2: add FCA
 periodic timer configurations
Thread-Index: AQHW8kZjKx4oGFLdHkqof+xVkN95zqo2sHGAgAAngvA=
Date:   Sun, 24 Jan 2021 14:43:30 +0000
Message-ID: <CO6PR18MB3873F47DE5BD28951CC3D2E9B0BE9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
 <1611488647-12478-9-git-send-email-stefanc@marvell.com>
 <20210124121443.GU1551@shell.armlinux.org.uk>
In-Reply-To: <20210124121443.GU1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.11.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6bad2b73-d646-4cc6-0a69-08d8c0766b1b
x-ms-traffictypediagnostic: MWHPR18MB1087:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB1087E4D35F1A589681EAEABEB0BE9@MWHPR18MB1087.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ejtdy5JUZMIuHWUlbsNirhzw19PgqTdcXBmkF8zPUhof43ffjePRuiGwxBSjC/RSZ9OrjUI22AwqgJmZyMJhp6UWZB9hgm4VNOo2Dph3yP0KVlzGNPFS2MQy23a9N1uXyhooBHY7x4pG9bKJXkLcsIXh6ttUkgJFmhZX/KemJY2K/92xbKBh7hb5ol7sk7MC6K5lDjrw+1B/52TcH+VU4NT07x8Fg0S2eyLm4FTOaXvtFiseNTB+E798IdXSrFZzzuSIVHY8VmVViEEjSX2nLqvo8pCWfY7Wlt1WhAn0FoLPHYfVOa8HIPWuN/9jAEBtubfWf0nV8dvkQ6qftjRvtXhZyqGDPf+eaqPpdlJY5lktRSSr61nVPwUQekBdXohT6yw4YA4OIItJgzuM/LZLIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(66946007)(76116006)(7696005)(26005)(186003)(4326008)(54906003)(8676002)(8936002)(66556008)(2906002)(52536014)(66446008)(64756008)(66476007)(5660300002)(71200400001)(9686003)(316002)(55016002)(478600001)(86362001)(6506007)(33656002)(6916009)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?tmu9jyCSlXSJo2XsRxmIBp2Mwa7NqO7nfOhg/5vusZqYevf/xV+aQfYiQJzV?=
 =?us-ascii?Q?UniBRTQ011KOhG4pC0CRL4IqDZ7ljzdIP57Il79BNcbFtBa5UR3BABTr+24L?=
 =?us-ascii?Q?yB62eHVtlyYp3/g7DoTdisIJIuGZYkXbzJxu9wlrDAMccV3XyMwU0h/1Oo6Q?=
 =?us-ascii?Q?1zI4+eR6qnD7XWJZc695TC22xpn2O4mlQVOPiG6Z0nw0H3X0Gu+tEDASh0vs?=
 =?us-ascii?Q?frgW0CPBtrsGhN28hTtlQyivSkh4qlQDq8EGXp1ypAX+wTvWOCYWi3ok1AuU?=
 =?us-ascii?Q?/idTwh67EZMJimT3dhtBOGqa5NMPITmslC1jSKI/6cLDbBlZBnuMBwkReQ2l?=
 =?us-ascii?Q?Sti/LShtcAboehS1UuyVUDgA9gxmAdI3k1sLVHxgM+CJw2xuiemgxLsQ4gGh?=
 =?us-ascii?Q?uew+PDc7WYOZQxKj9E/Qpa4y2z5SbR1Y6q+rrA648ksNj6AoLtE5BG0bdC9j?=
 =?us-ascii?Q?uetiv2/dyqZ/qZaS790DvVXtK6ZqtxuSMClQBe9n3Njt2woHIvt1/AeuTJ6+?=
 =?us-ascii?Q?9xfcx6p6k0sm6W2v0xHQzPJYVfRoya/1ViiP129g/O1+JxKwfJY8g8benvJB?=
 =?us-ascii?Q?aKKNtJ0E6yVVIncNjmvHE87xCvR90/AomD8ySVDReCOypNzq+3ydg9gP9dw7?=
 =?us-ascii?Q?7VfjLWLez31SmOCODqrHQSMHuSkZIm5ckfeTHP6K+LXSiufM7bPxzprUtrY9?=
 =?us-ascii?Q?WNfaoptcI0qwnVPwZmXETxLweK98dzJVouto4WNulOhDA84I8mKorvhMLE2Y?=
 =?us-ascii?Q?kfCAAIWuaD+zAjRG9csYwEAFYk54EXgbVqu2gWK2jWPGFhPw23DFt66HzZp4?=
 =?us-ascii?Q?p4WsBJQthqDXXCyyB+lc79ABxJhnjn9txsZg/8d6sqiPxXe8nbVYvOpnByeh?=
 =?us-ascii?Q?WXJ28QhOTnzaQ2XmGGm4S9B7pz6Rdt5Byhffmbly5Vrq4BLRfX+PM3oQRTrL?=
 =?us-ascii?Q?yFPPnsHASSkjz8ewlTYM974P5MYZuGbhRbrw3CeIPp7n3Mxn8iDHGv4CHH61?=
 =?us-ascii?Q?g7E6K5A9MTGN0QU+hUvChbCegxSJLmprRo/xHzatXriQjCnxQMNkV0Rfd0j/?=
 =?us-ascii?Q?Cu06IegG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bad2b73-d646-4cc6-0a69-08d8c0766b1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2021 14:43:30.7249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x8K5DUXgaxntODFvrMStBnZ5MgRb74W3uFntgmazG8+LKCayKbcTQhvKKsEtQ65F2f33kHZAPSv1i9Tvclz2Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1087
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-24_05:2021-01-22,2021-01-24 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> ----------------------------------------------------------------------
> On Sun, Jan 24, 2021 at 01:43:57PM +0200, stefanc@marvell.com wrote:
> > +/* Set Flow Control timer x140 faster than pause quanta to ensure
> > +that link
> > + * partner won't send taffic if port in XOFF mode.
>=20
> Can you explain more why 140 times faster is desirable here? Why 140 time=
s
> and not, say, 10 times faster? Where does this figure come from, and what=
 is
> the reasoning? Is there a switch that requires it?

I tested with 140.
Actually regarding to spec each quanta should be equal to 512 bit times.
In 10G bit time is 0.1ns.
So It actually should be:
FC_CLK_DIVIDER =3D 10000 / 512 =3D ~20. I took some buffer and made it 140.
So maybe I can do it 100?

Regards,
Stefan.
