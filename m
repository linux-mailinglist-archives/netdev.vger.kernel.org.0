Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550B632191
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 03:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfFBB4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 21:56:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53552 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726211AbfFBB4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 21:56:55 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x521tNCf000880;
        Sat, 1 Jun 2019 18:56:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=I2BxbWkKL0jf9qti1QbXX+jAOviDQblfeOUGJa0Yv+0=;
 b=i/jrck+DrR0bEMiLBeGv00a87L9pZhHSnis/O96vvphpd4i6vI7X6b17XV4mVYC6Ob8B
 WvANXQqxMV9aV1C8gGPkgioiHHlosMXsxH+OwHTuDkgg3T2/1p49Z95JaB7iNqtqvuwF
 nLricDfqreuQQzvk1oJ/SDMw/gbzJaJGYdyC5Okhs3vuyBIt5KigjwnSVMcO2SGQ8d6m
 8PDE3XNMytA9aESrZ8x6uS5YhKmBiHJbJGbh+8r4fkryi7aLuih9/XH+6XvxYRN59ZOd
 L9opWU1zJEfoI5ohZIp9UuDrqkHz6ovtuHJgepKS8XHcaa7sqgYgXisw3807p8T9CmM0 HQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2supqktfwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 01 Jun 2019 18:56:48 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sat, 1 Jun
 2019 18:56:48 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.53) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sat, 1 Jun 2019 18:56:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2BxbWkKL0jf9qti1QbXX+jAOviDQblfeOUGJa0Yv+0=;
 b=B4nmPj6UjvBIFFk6GDfQiNzXgsw7T5EVz8nWpRMg/llFtVppSbHzrljSJSfxU2aOJJpSqeVzZ6WZLz8FVAEcMcPCHNXD347RcK1R18chH6AUJp4HSYFkFzHyiH5DR3ccXWx+nb9d9vxBs3zqrusRcg+Em8xCtpO1/8AEap7bxqk=
Received: from BYAPR18MB2630.namprd18.prod.outlook.com (20.179.94.155) by
 BYAPR18MB2358.namprd18.prod.outlook.com (20.179.90.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Sun, 2 Jun 2019 01:56:45 +0000
Received: from BYAPR18MB2630.namprd18.prod.outlook.com
 ([fe80::c1f4:51ab:bb47:c671]) by BYAPR18MB2630.namprd18.prod.outlook.com
 ([fe80::c1f4:51ab:bb47:c671%7]) with mapi id 15.20.1943.018; Sun, 2 Jun 2019
 01:56:45 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Colin King <colin.king@canonical.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] mwifiex: check for null return from skb_copy
Thread-Topic: [EXT] Re: [PATCH] mwifiex: check for null return from skb_copy
Thread-Index: AQHU8i7/8jDHsxlJZE+NM+DVVJab26aHWmowgAA9rACAAFAfAA==
Date:   Sun, 2 Jun 2019 01:56:44 +0000
Message-ID: <BYAPR18MB26301A09FB55C44949AD8E30A01B0@BYAPR18MB2630.namprd18.prod.outlook.com>
References: <20190413161438.6376-1-colin.king@canonical.com>
 <20190413192729.GL6095@kadam>
 <MN2PR18MB2637DAA4852542EDA2BBC01DA01A0@MN2PR18MB2637.namprd18.prod.outlook.com>
 <20190601210858.GG31203@kadam>
In-Reply-To: <20190601210858.GG31203@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.45.193.103]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75e8877e-2f2f-4130-5c91-08d6e6fd90ce
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR18MB2358;
x-ms-traffictypediagnostic: BYAPR18MB2358:
x-microsoft-antispam-prvs: <BYAPR18MB23584688A1980DF628776FBBA01B0@BYAPR18MB2358.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 005671E15D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(39850400004)(366004)(136003)(376002)(189003)(199004)(7416002)(229853002)(478600001)(7696005)(76176011)(186003)(446003)(26005)(66066001)(11346002)(81166006)(4744005)(81156014)(25786009)(54906003)(476003)(14454004)(86362001)(8676002)(8936002)(486006)(4326008)(68736007)(5660300002)(2906002)(71200400001)(71190400001)(52536014)(3846002)(6916009)(6506007)(6116002)(55016002)(74316002)(6246003)(33656002)(76116006)(7736002)(305945005)(6436002)(66446008)(66556008)(64756008)(66476007)(73956011)(102836004)(9686003)(256004)(66946007)(53936002)(316002)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2358;H:BYAPR18MB2630.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LkuYFwxtrcvn7QFUlLio5lDPl/EqRsc5lHgGkDE7xWRaJvzLQIalb+LMhO7HuSUh/eHPkoe38KO3hgpAjWaRxpmhDoI/yRt8wn5w1PBSnbNi72DFJ1WNBkD8iahoHN9iDedDFW+yeWTAn4srN/ugFTLNAaBYPCfOxELNGG+C+GfPWcwLmqT8JEzwcz8nGZhMrJN6CwXZjj1C2O9tiPBA28TGv807rfVjn3gv2HAaaqBeEuM4JpotXMUi06wxrmnQVVV68GexrkSfLiawIbJpvHZ6nO75YJEG4xW11I1mg6l21iFppLy2Zs9xAb9WOljQeXJyUqKftsSHZGbA0UObSAxvW8hWAW3vsZodTbSTLLDmLGCLKwV9XIRNWJy7RpvY1Kgj33Mv0YW3GqCyoqR/kTXWHR86W1wvx0xla7QkpoQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e8877e-2f2f-4130-5c91-08d6e6fd90ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2019 01:56:44.8912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gbhat@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2358
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-01_16:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

> > > >  	if (is_multicast_ether_addr(ra)) {
> > > >  		skb_uap =3D skb_copy(skb, GFP_ATOMIC);
> > > > +		if (!skb_uap)
> > > > +			return -ENOMEM;
> > >
> > > I think we would want to free dev_kfree_skb_any(skb) before returning=
.
> > I think if the pointer is NULL, no need to free it;
>=20
> You're misreading skb vs skb_uap.  "skb_uap" is NULL but "skb" is non-NUL=
L
> and I'm pretty sure we should free it.

Oh, right. I missed it; Yes you are correct.

Regards,
Ganapathi
