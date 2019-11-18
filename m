Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7F7100D42
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 21:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfKRUrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 15:47:07 -0500
Received: from mail-eopbgr820128.outbound.protection.outlook.com ([40.107.82.128]:26295
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726568AbfKRUrH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 15:47:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPsHQ1SXtIIhSi2OV1/VrpdX2piHgPMp93ZJWWzl9dQ2Qs7PyDy4eYGUa9Ja2xQUWmruzsVMUK1Ogc9uUiSPcdvR+Pm24MQDrtr49eao5xL4oLSTeD17ufuecZ4awjp4Uc/oKk9e1Dct1OF12Swy6+Am2uL4TzR+LxSoX0Tdkts27T3AeNIlRKgv+3g7QWRYeWKSfXOZMooH7hwLiwsHgDsrnCk27BAdUI+gbUE+jdcXkWPbccH90n2bQZfDVUgwADP2a9ztWusy1WNRmck/xDu0mRrG9b5Tu0WGuIy+Sq6u/ccYRqDaxRg7FnFp34Q2d1WbluzToEhJ/RmI7l+m4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hm1tceBVDNUJADOObZSfkCmy8nPPrIUCAv3WkzrtiQQ=;
 b=WdSvp1nMC2+s4jVASbQhk6LYzj9u/yjG6KlByfmWLOJh5IGmyvisNRf9JrZKUiHrMJ181A1HOnlY2PTUsFQlqhX32BuvravrebGIUrBnQl+JbXAlF85jlDlpFUotnCIXTC5dH61+Yl/Chtbrf6wZlbQj03BsFZKhYJUVlNVnM54Zsd6dZH4AApYp4yfLjN+nIChn5DCTehV5Tl5kWAbU5NOPmUsOh5xk86/WVziK7Aw69KGJvprZxWrefGeOtSBhQBaw3AqMmblIX8qcL6a0ao3TKSlqUyUToD0zBdzadUDKdNyZVLaWNpMIubOWjbseRAg6wgklgcLbSP+YUEok9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hm1tceBVDNUJADOObZSfkCmy8nPPrIUCAv3WkzrtiQQ=;
 b=GwHY8SrB/nIPZQx0Gd94QNVnSxmH2NDclccXOlxO7mbcxDzyhEk2TIWconYG5AIdhxR1i2NI3AF5c8Do3mdS1DjssCvyoZ1psM/viOIrjTJw3tNa41kVYOJJkE5nihEwWG3xFa/3wi0KVe8/3fLOqV7pjPi3jfBjawI+1gYwrfI=
Received: from DM5PR21MB0634.namprd21.prod.outlook.com (10.175.111.141) by
 DM5PR21MB0636.namprd21.prod.outlook.com (10.175.111.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.3; Mon, 18 Nov 2019 20:47:02 +0000
Received: from DM5PR21MB0634.namprd21.prod.outlook.com
 ([fe80::6961:d2cb:70a8:760]) by DM5PR21MB0634.namprd21.prod.outlook.com
 ([fe80::6961:d2cb:70a8:760%9]) with mapi id 15.20.2495.006; Mon, 18 Nov 2019
 20:47:02 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        vkuznets <vkuznets@redhat.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net, 1/2] hv_netvsc: Fix offset usage in
 netvsc_send_table()
Thread-Topic: [PATCH net, 1/2] hv_netvsc: Fix offset usage in
 netvsc_send_table()
Thread-Index: AQHVni4GOIUpPMX2Hkeppwh3Y3jKnaeRLukAgAATwQCAACJ7gA==
Date:   Mon, 18 Nov 2019 20:47:02 +0000
Message-ID: <DM5PR21MB0634CF7997BD9F9B6326D1CED74D0@DM5PR21MB0634.namprd21.prod.outlook.com>
References: <1574094751-98966-1-git-send-email-haiyangz@microsoft.com>
 <1574094751-98966-2-git-send-email-haiyangz@microsoft.com>
 <87wobxgkkv.fsf@vitty.brq.redhat.com>
 <MN2PR21MB13758E83B89BD524B41B71C2CA4D0@MN2PR21MB1375.namprd21.prod.outlook.com>
In-Reply-To: <MN2PR21MB13758E83B89BD524B41B71C2CA4D0@MN2PR21MB1375.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-11-18T18:39:29.5028454Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=821fed68-78ee-4326-a00c-9705c5f44674;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [2001:4898:80e8:f:f1eb:a822:8070:3fdb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0b9d41cc-be7f-421a-6c15-08d76c6876e0
x-ms-traffictypediagnostic: DM5PR21MB0636:|DM5PR21MB0636:|DM5PR21MB0636:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM5PR21MB0636DEBF50DA562FACB89178D74D0@DM5PR21MB0636.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(396003)(346002)(366004)(136003)(189003)(199004)(13464003)(229853002)(6436002)(8990500004)(486006)(316002)(6506007)(86362001)(22452003)(2906002)(6246003)(102836004)(7696005)(76176011)(4326008)(8936002)(33656002)(476003)(11346002)(446003)(99286004)(46003)(55016002)(110136005)(54906003)(9686003)(81156014)(81166006)(186003)(8676002)(66476007)(52536014)(64756008)(66446008)(66946007)(5660300002)(66556008)(10090500001)(7736002)(305945005)(6116002)(74316002)(71190400001)(71200400001)(256004)(76116006)(1511001)(10290500003)(478600001)(14454004)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR21MB0636;H:DM5PR21MB0634.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a9wkSaSzoDz2jXz/ic3yQea+pWWHeCjMAbVyglOIpeTMs0yizghSAHMtdesztIuqh9+3sTVopc1z3YIiKsBPJvxLTVbTZ/2yVi1gzACvCFETI57BryXanpQoFnKdLsHlbY9NNj2VX8e142DjN2MrEXSPyjpu7oj9PKVUXiOzg+xyh1GLN04oWgImTNTYk0kKoT67CZZD0/fwiu4bxwKqt/7nQF0A2oO+D0og480iF0prHpfAiCaPfX56bzWeqCwUhMFAlOlHdciEweGVGn/JbGaLADR9n0yCMjBIdttQ8x/XHPSCMIeDAvHNn4mBu9q5lHi5vZa7CuOshOtjUIQP8cWjQGLLT0kFZXsuGIK4kMj/qXBImYGwPLjYHZbAns5kpmjaz2mIXDflRRif7ZyTE2Xbi9e96Y57njhcLKL9kkztUoVf33T2E5OIUW/FMhc8
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b9d41cc-be7f-421a-6c15-08d76c6876e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 20:47:02.1373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8qQJRRnS8TiNYKACgUoNm0JEDlWBVW+wS60LHtXLVEUVoyKGVSUnCiXgNsfvIbnedmdESE1Z2vMarIdy8sIuR+6rLOL0JehN+yjIg6a1mIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0636
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com> Sent: Monday, November 18, 201=
9 10:40 AM
> > -----Original Message-----
> > From: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Sent: Monday, November 18, 2019 12:29 PM
> >
> > Haiyang Zhang <haiyangz@microsoft.com> writes:
> >
> > > To reach the data region, the existing code adds offset in struct
> > > nvsp_5_send_indirect_table on the beginning of this struct. But the
> > > offset should be based on the beginning of its container,
> > > struct nvsp_message. This bug causes the first table entry missing,
> > > and adds an extra zero from the zero pad after the data region.
> > > This can put extra burden on the channel 0.
> > >
> > > So, correct the offset usage. Also add a boundary check to ensure
> > > not reading beyond data region.
> > >
> > > Fixes: 5b54dac856cb ("hyperv: Add support for virtual Receive Side Sc=
aling
> > (vRSS)")
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > ---
> > >  drivers/net/hyperv/hyperv_net.h |  3 ++-
> > >  drivers/net/hyperv/netvsc.c     | 26 ++++++++++++++++++--------
> > >  2 files changed, 20 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/drivers/net/hyperv/hyperv_net.h
> > b/drivers/net/hyperv/hyperv_net.h
> > > index 670ef68..fb547f3 100644
> > > --- a/drivers/net/hyperv/hyperv_net.h
> > > +++ b/drivers/net/hyperv/hyperv_net.h
> > > @@ -609,7 +609,8 @@ struct nvsp_5_send_indirect_table {
> > >  	/* The number of entries in the send indirection table */
> > >  	u32 count;
> > >
> > > -	/* The offset of the send indirection table from top of this struct=
.
> > > +	/* The offset of the send indirection table from the beginning of
> > > +	 * struct nvsp_message.
> > >  	 * The send indirection table tells which channel to put the send
> > >  	 * traffic on. Each entry is a channel number.
> > >  	 */
> > > diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.=
c
> > > index d22a36f..efd30e2 100644
> > > --- a/drivers/net/hyperv/netvsc.c
> > > +++ b/drivers/net/hyperv/netvsc.c
> > > @@ -1178,20 +1178,28 @@ static int netvsc_receive(struct net_device *=
ndev,
> > >  }
> > >
> > >  static void netvsc_send_table(struct net_device *ndev,
> > > -			      const struct nvsp_message *nvmsg)
> > > +			      const struct nvsp_message *nvmsg,
> > > +			      u32 msglen)
> > >  {
> > >  	struct net_device_context *net_device_ctx =3D netdev_priv(ndev);
> > > -	u32 count, *tab;
> > > +	u32 count, offset, *tab;
> > >  	int i;
> > >
> > >  	count =3D nvmsg->msg.v5_msg.send_table.count;
> > > +	offset =3D nvmsg->msg.v5_msg.send_table.offset;
> > > +
> > >  	if (count !=3D VRSS_SEND_TAB_SIZE) {
> > >  		netdev_err(ndev, "Received wrong send-table size:%u\n",
> > count);
> > >  		return;
> > >  	}
> > >
> > > -	tab =3D (u32 *)((unsigned long)&nvmsg->msg.v5_msg.send_table +
> > > -		      nvmsg->msg.v5_msg.send_table.offset);
> > > +	if (offset + count * sizeof(u32) > msglen) {
> >
> > Nit: I think this can overflow.
>=20
> To prevent overflow, I will change it to:
> 	if (offset > msglen || offset + count * sizeof(u32) > msglen) {
> Thanks,
> - Haiyang

Actually, this would be simpler since we already trust msglen and count
to have good values:

	if (offset > msglen - count * sizeof(u32)) {

Michael


