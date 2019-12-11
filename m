Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E029A11A30F
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 04:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfLKDcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 22:32:31 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37096 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726642AbfLKDcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 22:32:31 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBB3RQ7x003574;
        Tue, 10 Dec 2019 19:32:05 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wtbqg3egb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Dec 2019 19:32:04 -0800
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xBB3VWE7007569;
        Tue, 10 Dec 2019 19:32:04 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wtbqg3eg7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Dec 2019 19:32:04 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Dec
 2019 19:32:02 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 10 Dec 2019 19:32:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYjHvvKso1yyAHjX11piAdoEWaez0EfD1SE4uKgTqJcGLWQlD/1NIya6Rxcr5XhdhmnGwMnFGMzf9YQopM2dBa89/tfHIcJMRnBrYCtxA60D74GGKJznete6dyq9gnRxjtnHY75LdKszCHdpoPQF4nsKx4FaMPd+X3465qdh0CBvhLuoXv4J3yTbJ6jcP1qBh5Ilo4gs3yQK2HOxSgbmeqaZleiC94SyPcevf20Y9XuoafVfxe4xiI566+ZukxUKTXbdsgMABmWnfzY6QRyu3WosHeJH2Y//mcFsdovqHYPRIxpZhgbviOWM/7suit85j5fY+JB/4pT1k2+FtT+0RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVGSkr4CFGMPYh3KYFFsUDwbVZoq9tCcIQeA9kf/w2E=;
 b=jDOrBmRwYzqyeVsdCM+Jd+jnaxdOKCLWADfkyh6YCbwIxUt2OQh5teIhDvUmA+8K5GIxlYuDU6BicjQ82yDkNLqMgXTW4QS35BPhmq1+ZOMePJG3B5NcBf3wshX9f5/8Tk3ECghVnHyPeAOb5QETq9awxUikB3Ck7zHS7XF9Qk/ZxFvWNp5imbPfb44vTuQOIi+wNj4igY1U/zUJLEZTQEDAy9D5Q2Z//Vct1h/EzvbMK3QU8IbBOQkGaVS18cGVQon23bF4aUCiI1LTjzGeH6bJwQ5TUYsXe7pCVaLds1xZa88T52ZEn3q9puHKlbHTdKWmou7QPiZEniwfTTQznA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVGSkr4CFGMPYh3KYFFsUDwbVZoq9tCcIQeA9kf/w2E=;
 b=AKaH9sa/7V9zy9ewhBndUfXQrnpM0tZY+hQnhuzt8u7LSUfU9Us1ySNCpJ+a7LXKI7uGDIh77E3OtuGkcGbhVM9zoijuu6SyYoY9+N6YDyDEOV0wzh5r7XKJE0CENpR5VAO2hkOBONnXu5hHiskIIJ97BzVjBIg/QunZP/pznbg=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB3373.namprd18.prod.outlook.com (10.255.238.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Wed, 11 Dec 2019 03:32:00 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::1d2:f589:c601:9064]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::1d2:f589:c601:9064%5]) with mapi id 15.20.2516.018; Wed, 11 Dec 2019
 03:32:00 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Colin Ian King <colin.king@canonical.com>
Subject: RE: [PATCH v2] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for wider
 use
Thread-Topic: [PATCH v2] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for wider
 use
Thread-Index: AQHVXPW4c6XwhqQSrEmxRuY/MHYwEKeypbEAgAJG94A=
Date:   Wed, 11 Dec 2019 03:32:00 +0000
Message-ID: <MN2PR18MB25282DFB28BB92626C6C8C37D35A0@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190827163717.44101-1-andriy.shevchenko@linux.intel.com>
 <20191209164338.GO32742@smile.fi.intel.com>
In-Reply-To: <20191209164338.GO32742@smile.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2402:3a80:530:d1b3:e12b:a63a:d9b5:4938]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0cc8356-d129-4fc0-2b94-08d77deaaf09
x-ms-traffictypediagnostic: MN2PR18MB3373:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3373D4FB85B77E8B7E18A33DD35A0@MN2PR18MB3373.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(51914003)(189003)(199004)(13464003)(55016002)(66446008)(2906002)(9686003)(8936002)(81156014)(81166006)(316002)(478600001)(86362001)(110136005)(186003)(6506007)(53546011)(52536014)(33656002)(66946007)(7696005)(66476007)(66556008)(76116006)(64756008)(8676002)(5660300002)(71200400001)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3373;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Am1UQGSHUtLrWenxWLF9Rqps3wh9ura+LAbkL3SF+B/N0QqKXHEAepm9gW4rFPNsR/wuqOT98Ajm1bUmwjrOyOYUcK6W8mf5Pvjp/4l5JlePLIrWFuK/rrk5/6i7JJhckjckfHYQ21KEAnI7EtWwKOLBI52kLNbr1J17T/8Z9PuW/YgCkuByELrDIHwsQEfmEFHVlTmsTz+S8DYcDAlNsj2DUHYasAAjHsfBwWIB20JiqdK18kPLUHp7CAzpc7dNLUL7RuBIuK7m3p/JtX9RUk4PAmmVqgVu3bzhdVRXp9/usaoTsaWXbZc3yRoPbng7+jYpNuN6rdTSGLVH3OhiDrF1a3XnTAEoC4M8DFB3+qeM4tXhzDkHTv2DZjxYY8AajjjyoMByu4mWD7xm9iIYw24V8PXiUbGskWBuEC/v+JXhAsbi8zcm7g4ibxcyWqZkOg9QkC4l0wrMuEzHWU9sxQAzF6ETE5GA11Qq9Z0XsvQenFwktW4g9G5ev66HjE5t+MVYHenBTtIqx87i65+m0IM73A2joL/m+BHSvh2bWbZan4NW9ud5JgRXBY02SSvf
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c0cc8356-d129-4fc0-2b94-08d77deaaf09
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 03:32:00.6948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XYwKXjebmMtcD4j3r2MpLJ1rKxo0xZZU8zy9TRUJvUylquVOeo5BAen5AFoZ/IVYik+lkHH/mftxUqB8f3OkXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3373
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_08:2019-12-10,2019-12-10 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Andy Shevchenko
> Sent: Monday, December 9, 2019 10:14 PM
> To: Mark Fasheh <mark@fasheh.com>; Joel Becker <jlbec@evilplan.org>;
> Joseph Qi <joseph.qi@linux.alibaba.com>; ocfs2-devel@oss.oracle.com; Arie=
l
> Elior <aelior@marvell.com>; Sudarsana Reddy Kalluru
> <skalluru@marvell.com>; GR-everest-linux-l2 <GR-everest-linux-
> l2@marvell.com>; David S. Miller <davem@davemloft.net>;
> netdev@vger.kernel.org; Colin Ian King <colin.king@canonical.com>
> Subject: Re: [PATCH v2] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for
> wider use
>=20
> On Tue, Aug 27, 2019 at 07:37:17PM +0300, Andy Shevchenko wrote:
> > There are users already and will be more of BITS_TO_BYTES() macro.
> > Move it to bitops.h for wider use.
> >
> > In the case of ocfs2 the replacement is identical.
> >
> > As for bnx2x, there are two places where floor version is used.
> > In the first case to calculate the amount of structures that can fit
> > one memory page. In this case obviously the ceiling variant is correct
> > and original code might have a potential bug, if amount of bits % 8 is =
not 0.
> > In the second case the macro is used to calculate bytes transmitted in
> > one microsecond. This will work for all speeds which is multiply of
> > 1Gbps without any change, for the rest new code will give ceiling
> > value, for instance 100Mbps will give 13 bytes, while old code gives
> > 12 bytes and the arithmetically correct one is 12.5 bytes. Further the
> > value is used to setup timer threshold which in any case has its own
> > margins due to certain resolution. I don't see here an issue with
> > slightly shifting thresholds for low speed connections, the card is sup=
posed
> to utilize highest available rate, which is usually 10Gbps.
>=20
> Anybody to comment on bnx2 change?
> Can we survive with this applied?
>=20
> >
> > Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> > - described bnx2x cases in the commit message
> > - appended Rb (for ocfs2)
> >
> >  drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h | 1 -
> >  fs/ocfs2/dlm/dlmcommon.h                         | 4 ----
> >  include/linux/bitops.h                           | 1 +
> >  3 files changed, 1 insertion(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
> > b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
> > index 066765fbef06..0a59a09ef82f 100644
> > --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
> > +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
> > @@ -296,7 +296,6 @@ static inline void bnx2x_dcb_config_qm(struct bnx2x
> *bp, enum cos_mode mode,
> >   *    possible, the driver should only write the valid vnics into the =
internal
> >   *    ram according to the appropriate port mode.
> >   */
> > -#define BITS_TO_BYTES(x) ((x)/8)
> >
> >  /* CMNG constants, as derived from system spec calculations */
> >
> > diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h index
> > aaf24548b02a..0463dce65bb2 100644
> > --- a/fs/ocfs2/dlm/dlmcommon.h
> > +++ b/fs/ocfs2/dlm/dlmcommon.h
> > @@ -688,10 +688,6 @@ struct dlm_begin_reco
> >  	__be32 pad2;
> >  };
> >
> > -
> > -#define BITS_PER_BYTE 8
> > -#define BITS_TO_BYTES(bits) (((bits)+BITS_PER_BYTE-1)/BITS_PER_BYTE)
> > -
> >  struct dlm_query_join_request
> >  {
> >  	u8 node_idx;
> > diff --git a/include/linux/bitops.h b/include/linux/bitops.h index
> > cf074bce3eb3..79d80f5ddf7b 100644
> > --- a/include/linux/bitops.h
> > +++ b/include/linux/bitops.h
> > @@ -5,6 +5,7 @@
> >  #include <linux/bits.h>
> >
> >  #define BITS_PER_TYPE(type) (sizeof(type) * BITS_PER_BYTE)
> > +#define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE)
> >  #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_TYPE(long))
> >
> >  extern unsigned int __sw_hweight8(unsigned int w);
> > --
> > 2.23.0.rc1
> >
>=20
> --
> With Best Regards,
> Andy Shevchenko
>=20

Thanks for the changes.

Acked-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>

