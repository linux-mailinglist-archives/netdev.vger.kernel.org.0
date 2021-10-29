Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AF143FEA3
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 16:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhJ2Orr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 10:47:47 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17432 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229521AbhJ2Orp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 10:47:45 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TBUpX1000422;
        Fri, 29 Oct 2021 07:45:12 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by mx0a-0016f401.pphosted.com with ESMTP id 3c0g54gptp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Oct 2021 07:45:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrYASEfc+3FFHNl6glexh6x/AmlHoT339lfDgrwlZJmyd4S12mwYMq0VyIRTulyiA8sbvC7NAvzQxAFYbXpaWFqmPX/vqHrmY+k5jiZJgctmhUNWrqe6ufLQaxH7/PkDb9l3iBwbdw4Wh58SNUfcxYdFYh8rwXxXEzPPz6gE81A3+KH1LjKQ1iFOdi7PymHZbyn9wyUhxadZZnFXGe9XMH7wCBXE/PlRAg0RBuOal5U0xITAfXxT6GucegmWwMcrfQSI+ggk3jytvdCTX6TtfMZwuSku4Yg7mNKBAhC4PKo10vCcGsFpXnL0SznCwl90qozIouESzNt4GpcqVR7cfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M4jSQRERgR2i22OhmYL5zhmpCCvIEKfw2TKAZvR3VW8=;
 b=IBbmE9T7WalqiIgP3YbsLRp2DVTpk9CmAChRAStV24Zt2UwESHvFEQs+Jc8XVbXsb50k54N9tS3z1mgmHzwbZqzUIch14XbcAxOPIQLNU5yaFuhgQcoCMzwK73ndyjl9fm3NLige1kkYfh0eQWBcAo9xzuTAvTvL/2IHibA/r609bIa+dySs7yBzUAx7jRzXOksNO7EMBYzhWmlF103lKwF9IfrndyUZaJdNCbb/YKaXxRFHxQjPenSTLuUjXGfQkYymmPaQ8bAoMp+KrgTR11iclpw7AZON0ftJ/9/aTL2iEmWFd90D9HxeJSeUsigcr9DvZqiig13k2HJsNRiTBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4jSQRERgR2i22OhmYL5zhmpCCvIEKfw2TKAZvR3VW8=;
 b=cDbrxa+rxCIWPYh9sLaMJdwkTCiHJM0udSEhWWA+XyMUWErzQwstumBDNujhnmjn/sAZy+PBEEiTDtziJ7dJIn6uD+L+TrgToaOezuBCzm2Fsy+4cmsq8tAjmJOVbTCFbO8GGhxyxtrXhpSZsmTpo2ddDGnMM40glbfGC5sIaJc=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by BYAPR18MB2904.namprd18.prod.outlook.com (2603:10b6:a03:10c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 14:45:10 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502%9]) with mapi id 15.20.4649.017; Fri, 29 Oct 2021
 14:45:10 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v4] net: marvell: prestera: add firmware v4.0
 support
Thread-Topic: [PATCH net-next v4] net: marvell: prestera: add firmware v4.0
 support
Thread-Index: AQHXzNOS3+pDqWPNGUmXnRrg5qwGMg==
Date:   Fri, 29 Oct 2021 14:45:10 +0000
Message-ID: <SJ0PR18MB4009142EC8B4720B9DEC5648B2879@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <1635485889-27504-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <YXvurO1ssFPL15Qu@lunn.ch>
In-Reply-To: <YXvurO1ssFPL15Qu@lunn.ch>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: ca099ea5-9af5-b89e-0dc9-596c86c47ebf
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e636359-db41-4241-6fa7-08d99aeab53b
x-ms-traffictypediagnostic: BYAPR18MB2904:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BYAPR18MB290421A56238CDF16795754DB2879@BYAPR18MB2904.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YFhLYEgNEHcFl1JcrQUf7TTU+B6V6rTW6HQWiP2NRNzYDWf92hfHLgbNl8ge97vSnjoL510B/7FmtK3EtAufEWn/EIE7hll9LulRBSGu7ZuGt8ak4UPB6LQkc7WVhBT+OO2yzwuypW2W4y0M0hScMerurbs9KsU9UG1J/UTgn6DCrYCh9dZ8clNBbJfxPLvHTbta5qEAJOH8u+dWKArQ2SzkAQ/8I6hqkdhQJQN2aqr+bHzcAhoij6WHI/YLLKGVnqvjYZ7vMGOzmdfE4b28ReNgr46A5wt6jUNHGnY7wF9AmACKA0HIYGl/JU6N7dlSMO2xnw1FCBDZf2Kw7bz/EnyEHYg+BvbAA7uu/ImZ9TgHkQbABPx2A0N6dVdJhOMQosjJ9EGXLq0jaSpUIZLvTSfaZeHGIIlxqpWXLGKXzIxCA6/nkkTTkSMh5TkjsPFiqdhQaxoJjaHKyRym9lAJb710xleo1qWK6P55BlSBDnNMWDeyEECSzQzLcsrSaT8xBSgAitJwmZ92lmvRnlrvci39w5WGs2vEGpDBKm1B4iAVsBAkB64rl+eZbM0bnat5kv99LCjfok9DOrby0+U2vT0HTVDzM8L5p2BV0+7Fzhu4Ir7LHSKItnpHEMEqfpFxDNnhHPICjEW/beHsd3t5yr6jE3kAGeTbfuJb0+SwyCWdCzKYEd/PLyevZLulUE/xizaIUIJVuTDileqM7YHmgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(38100700002)(55016002)(26005)(8676002)(76116006)(9686003)(64756008)(7696005)(66556008)(83380400001)(508600001)(66446008)(66946007)(66476007)(186003)(122000001)(5660300002)(38070700005)(6916009)(316002)(8936002)(6506007)(4326008)(2906002)(86362001)(54906003)(71200400001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?SFXgU3dJ4izMS89aTGoguSYfkD4n45pnPXrjdEQ5ZPs+UJ8Z5hW23ixJE8?=
 =?iso-8859-1?Q?wQHoB5zmlboh/ujV6Yu8DeOjOzfGFmw7w62GqqKglsKGVgULH90xEQ6JoB?=
 =?iso-8859-1?Q?a6cyQJdqfBDW9bTg+eEayueMxVptCqux9lHkChWOHi3lGI9v6yXkjSXP07?=
 =?iso-8859-1?Q?cDmQNotFTzQtqmlOvh7ijnKhdhlMJ8qbm8VYkeyEFwP+Ujmv4sZhB+Hy4t?=
 =?iso-8859-1?Q?8uwWgdhk4b8TNhd2fL96aq2D9vSltu5S14pRSeTF9dg1saqune8yvYufjo?=
 =?iso-8859-1?Q?sTJEd44FxWuBhcXHvZd9Boye53BqFtzc8onVCpKmNlB9BCM6zayU02Y3VK?=
 =?iso-8859-1?Q?/B3cY9GxPLaBZuL4iz0iXtloz+DbyZ4lJOna2g04vrNqlfIwbofKk86SE4?=
 =?iso-8859-1?Q?/20yoQ2Wts+C2dAbqKsZmAI0Q/3NkB2vZxTLz5KiWcoa1yHOgBtRxw3jcR?=
 =?iso-8859-1?Q?hMvnFiBOA/xRO6mZSEeaJmN3sfIzvDvLWYxPGItp+H8LEziB6r1zhERIl/?=
 =?iso-8859-1?Q?6w33xX9rumu1cUyv0wAVvfAyon/PXbq0+lVnw4Y/vWmBAkNZes3phD7rR9?=
 =?iso-8859-1?Q?i9HctZzVFSKkov3Z6gONlY1A+lH/HyhSLjtLuRWmk966r+jYzoBb8JKP9Y?=
 =?iso-8859-1?Q?1DYdE+K2SQ6oV/Mf/TsWqTLDm0eTESAzAvhUxDcJF/DJMmxBWJVLOM2qil?=
 =?iso-8859-1?Q?1fklvA4i5UOnDFK6xWF6r3wrKPCR73yxdFMSgTVsgDYSXs7pKBB2+LDM/7?=
 =?iso-8859-1?Q?Dwmmz8W8BmfAt2KnIPcIJmpANCA+NkqYWMGBsJVJsnMi/wMrcFj2J9veb0?=
 =?iso-8859-1?Q?cZToLOrUt8s9DDaRwpWN2Cm1pOMbqXz7kDZoLr66zCcl0spLigSspHVfuW?=
 =?iso-8859-1?Q?8HOupH4QRk3LrYFFHSKm4x/ROnpOlZMXQoycwbI5AhOfE4bkxXedAREXQo?=
 =?iso-8859-1?Q?1B+ZhyT26LnTJc1YypOl41lC53OAd+xdyN5hAuRLsgNydyajTkkSjscmFD?=
 =?iso-8859-1?Q?auRlJjxIwySzYpaSevCPQIdNS1Cf4vnSigGG/XaM0FDEpTHzzdoE/kMgpI?=
 =?iso-8859-1?Q?QkN28BPQXcFYKXT8yP7NjpqOLnNsD+pQ7zKnFcTaPXTKk93dPDn/QahoRm?=
 =?iso-8859-1?Q?q0N2FNLppX0YFTrTv/h8kTMHoEC1Im0ixl68uyB7zcFBraNFxI1L4g7UAB?=
 =?iso-8859-1?Q?B16IrL7WbAeTOjk3Qhl2wJt1qULrZ8bU+/UPSY/hYuTInMIEf9DdGM4GDO?=
 =?iso-8859-1?Q?Gl853CNaNHNfqG8n29aKiPmCSdExkW4VSamC0nEYq3E1tpAyheEPL4lz7T?=
 =?iso-8859-1?Q?76lfCoi1RL4/apL6BCAaOB4RZ014sqxM+UZMOkfRT6corQQKnHpawNJ3Ya?=
 =?iso-8859-1?Q?RtW5Lco86FVrjYJiJQivHVJqEk6v70Zko1V9vsZTmRNw0LPgYOI3BVCqNo?=
 =?iso-8859-1?Q?gEBUzaPNITxWSvpwcDpofx9rBqVrcgeceZCJbi0QT27CY3UEzji00/i0Yo?=
 =?iso-8859-1?Q?OrE+BHhp1yyjy8KW1ogSGIL5F0S5wLS/XlSFxTk52QRYMIHdimeVirVLt/?=
 =?iso-8859-1?Q?ml0lkXFJByxReQ+3obYbKq0hODlHttO8zjOgjpeVRZacq/+45cv2p5PmVn?=
 =?iso-8859-1?Q?UxM6ZdORYvVMiuJ3lDG7aM2oE3eMCWj5xf1uxHIJHnk3C3zQ+3iJs4EA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e636359-db41-4241-6fa7-08d99aeab53b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2021 14:45:10.2126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FZsUW5yidrBMv668PFZD8pDIgx6McaGRKEMYuvSrmh1vLI6Ypt5tlz+RSogNliuLIv7QWUDj/VfirkLx0YdIUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2904
X-Proofpoint-GUID: qT_lxTlPNlwUj8uGGqx5tAKbjxb5DSZ_
X-Proofpoint-ORIG-GUID: qT_lxTlPNlwUj8uGGqx5tAKbjxb5DSZ_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_03,2021-10-29_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +struct prestera_msg_event_port_param {=0A=
> > +     union {=0A=
> > +             struct {=0A=
> > +                     u8 oper;=0A=
> > +                     __le32 mode;=0A=
> > +                     __le32 speed;=0A=
> > +                     u8 duplex;=0A=
> > +                     u8 fc;=0A=
> > +                     u8 fec;=0A=
> =0A=
> Makes more sense to put the 2 le32 first and then the 4 u8s. At the=0A=
> moment, the le32 are not word aligned, so the compiler has to issue=0A=
> more instructions.=0A=
> =0A=
> =0A=
> > +             } __packed mac;=0A=
> > +             struct {=0A=
> > +                     u8 mdix;=0A=
> > +                     __le64 lmode_bmap;=0A=
> > +                     u8 fc;=0A=
> =0A=
> Same here, le64 first, then to two u8.=0A=
> =0A=
> >  union prestera_msg_port_param {=0A=
> > -     u8  admin_state;=0A=
> > -     u8  oper_state;=0A=
> > -     u32 mtu;=0A=
> > -     u8  mac[ETH_ALEN];=0A=
> > -     u8  accept_frm_type;=0A=
> > -     u32 speed;=0A=
> > +     u8 admin_state;=0A=
> > +     u8 oper_state;=0A=
> > +     __le32 mtu;=0A=
> =0A=
> 2 u8 followed by a le32? Swap them.=0A=
> =0A=
> > +     u8 mac[ETH_ALEN];=0A=
> =0A=
> You then get the 6 byte MAC and the 2 u8 giving you word alignment.=0A=
> =0A=
> > +     u8 accept_frm_type;=0A=
> > +     __le32 speed;=0A=
> =0A=
> Swap these two, keeping speed word aligned.=0A=
> =0A=
> >        u8 learning;=0A=
> >        u8 flood;=0A=
> =0A=
> You have 3 u8 in a row, so move another u8 up to keep word alignment, say=
 type.=0A=
> =0A=
> > -     u32 link_mode;=0A=
> > -     u8  type;=0A=
> > -     u8  duplex;=0A=
> > -     u8  fec;=0A=
> > -     u8  fc;=0A=
> > -     struct prestera_msg_port_mdix_param mdix;=0A=
> > -     struct prestera_msg_port_autoneg_param autoneg;=0A=
> > +     __le32 link_mode;=0A=
> > +     u8 type;=0A=
> > +     u8 duplex;=0A=
> > +     u8 fec;=0A=
> > +     u8 fc;=0A=
> > +     union {=0A=
> =0A=
> With type moved up, this whole union becomes unaligned. So you might=0A=
> want to explicitly add a reserved byte here. Make sure it is set to=0A=
> zero when sent to the firmware, and ignored on receive.=0A=
> =0A=
> > +             struct {=0A=
> > +                     u8 admin:1;=0A=
> > +                     u8 fc;=0A=
> > +                     u8 ap_enable;=0A=
> =0A=
> Move these three after the next union, to keep the union aligned.=0A=
> =0A=
> > +                     union {=0A=
> > +                             struct {=0A=
> > +                                     __le32 mode;=0A=
> > +                                     u8  inband:1;=0A=
> > +                                     __le32 speed;=0A=
> =0A=
> speed should be second, so it is aligned.=0A=
> =0A=
> > +                                     u8  duplex;=0A=
> > +                                     u8  fec;=0A=
> > +                                     u8  fec_supp;=0A=
> > +                             } __packed reg_mode;=0A=
> > +                             struct {=0A=
> > +                                     __le32 mode;=0A=
> > +                                     __le32 speed;=0A=
> > +                                     u8  fec;=0A=
> > +                                     u8  fec_supp;=0A=
> > +                             } __packed ap_modes[PRESTERA_AP_PORT_MAX]=
;=0A=
> > +                     } __packed;=0A=
> > +             } __packed mac;=0A=
> > +             struct {=0A=
> > +                     u8 admin:1;=0A=
> > +                     u8 adv_enable;=0A=
> > +                     __le64 modes;=0A=
> > +                     __le32 mode;=0A=
> =0A=
> These two le64 come first to keep them aligned.=0A=
> =0A=
> > +                     u8 mdix;=0A=
> > +             } __packed phy;=0A=
> > +     } __packed link;=0A=
> =0A=
> =0A=
> Hopefully you get the idea. Getting alignment correct will produce=0A=
> smaller faster code, especially on architectures where none aligned=0A=
> accesses are expensive.=0A=
=0A=
  Thanks for the comments. Those structures are packed, so there will not=
=0A=
be any holes (pahole is my friend now :) ). Also, the structure have been=
=0A=
left intentionally unmodified (with few others like prestera_msg_fdb_req,=
=0A=
prestera_msg_event_port_param), to be align with the FW side. The rest stru=
cts,=0A=
which aren't FW dependent, have been fixed (probably I should have mentione=
d=0A=
this in the patch-set log to make it clear). Will try to fix those also=0A=
to make it consistent in all places. I think this is the right time for=0A=
such changes.=0A=
=0A=
> =0A=
> > @@ -475,15 +543,15 @@ static int __prestera_cmd_ret(struct prestera_swi=
tch *sw,=0A=
> >        struct prestera_device *dev =3D sw->dev;=0A=
> >        int err;=0A=
> >  =0A=
> > -     cmd->type =3D type;=0A=
> > +     cmd->type =3D __cpu_to_le32(type);=0A=
> >  =0A=
> > -     err =3D dev->send_req(dev, cmd, clen, ret, rlen, waitms);=0A=
> > +     err =3D dev->send_req(dev, 0, cmd, clen, ret, rlen, waitms);=0A=
> >        if (err)=0A=
> >                return err;=0A=
> >  =0A=
> > -     if (ret->cmd.type !=3D PRESTERA_CMD_TYPE_ACK)=0A=
> > +     if (__le32_to_cpu(ret->cmd.type) !=3D PRESTERA_CMD_TYPE_ACK)=0A=
> >                return -EBADE;=0A=
> =0A=
> Makes more sense to apply the endianness swap to=0A=
> PRESTERA_CMD_TYPE_ACK. That can be done at compile time, where as=0A=
> swapping ret->cmd.type has to be done a runtime.=0A=
>=0A=
 =0A=
Agree.=0A=
=0A=
> =0A=
> > -     if (ret->status !=3D PRESTERA_CMD_ACK_OK)=0A=
> > +     if (__le32_to_cpu(ret->status) !=3D PRESTERA_CMD_ACK_OK)=0A=
> >                return -EINVAL;=0A=
> =0A=
> So this patch is now doing two different things at once. It is fixing=0A=
> your broken endianness support, and it is changing the ABI. Please=0A=
> separate these into different patches. Fix the endianness first, then=0A=
> change the ABI. That will make it much easier to review.=0A=
=0A=
Makes sense, will do.=0A=
=0A=
> =0A=
>        Andrew=0A=
>=0A=
=0A=
    Volodymyr=0A=
