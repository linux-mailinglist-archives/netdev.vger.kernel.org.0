Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 440C8100B9A
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 19:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfKRSjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 13:39:36 -0500
Received: from mail-eopbgr790133.outbound.protection.outlook.com ([40.107.79.133]:26016
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726370AbfKRSjf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 13:39:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PU8iLW0nuntXXDH72JLRAmUlrNZq0qf8l17/sXPLvnydOOKGi7s3GjI9NQPzLtNsysCYgVl9PkjNZ+owOJCFFTLY97BrKs1hV8Idjd1dzhXmviDpQK/q7SQh76toELvsC7ZhBbR7LBG4YsOq4CHJ6b7NojUSL3K8MuS9AHJ/DM6IDvmQrwRxk4igleNyvzIZYdZvYVmuKTLjBIMxNfrKmrn+1y5ET7xMc84Lyzu1meXuCgLxGiwjBqPln431GLMkKiEEhZGN8jo1FwUqahvIi0lO643OOJ/v49nWvzARnUva7esMJbBffqU268/XqqeCeSiUQS0O60bu7hg1UHysbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6ElEyEsUCGaq0w3xvtxVTwe0GkLv948ZBKxVvtSfs8=;
 b=PAGE/SvfU2VGPNfnRa6tB67a+NbKl7D2YmIZvd4zQm7IujdKWw04UsOBfIE5N+cB0obLfc10ZzbAcQaZKDwW9NvpSuku6AwgWiRYZQuhvHIEST9rdGCmXLQISqoPB7kxrMoN2Nq0DS1t82q9Aa0QB3QilKEQtv8789hOtjPYT5gRR/Z+VkMLKp33pEJeUxyJsJiBiR1X4NEwC99CxSnRMGJAuJ3koVknjvQWuZym1r+EFPT9/7rtIFwoysPWXUbjfROrWSKgx2RysdYiGhvpJw+jWI/JC83CavV2luHTZziXCGpPMV4MfyNJqwIxzS68brXaLSbzrNjf1IlzFBPXTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6ElEyEsUCGaq0w3xvtxVTwe0GkLv948ZBKxVvtSfs8=;
 b=imHcYemjK9nQfxppjtt3xSlIcm+QikH/TrakEivMGruteMOaAy5txCznt73oHnXjJWtPVhCjOfCW+JTDVU20UKhTPMaadjVS6TrEM/dB4AgmgqiGjKISvgLunsZgybjITyk6w5Sv57k61jVSfPnDpjlAoLw57e+/MeIGyuM5f8Q=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1456.namprd21.prod.outlook.com (20.180.26.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.3; Mon, 18 Nov 2019 18:39:31 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::ac9c:72ce:8bf5:790]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::ac9c:72ce:8bf5:790%9]) with mapi id 15.20.2495.004; Mon, 18 Nov 2019
 18:39:31 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     vkuznets <vkuznets@redhat.com>
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
Thread-Index: AQHVni4BMQAA5uuFYkCid07sy0QKsaeRLukAgAASHQA=
Date:   Mon, 18 Nov 2019 18:39:30 +0000
Message-ID: <MN2PR21MB13758E83B89BD524B41B71C2CA4D0@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1574094751-98966-1-git-send-email-haiyangz@microsoft.com>
 <1574094751-98966-2-git-send-email-haiyangz@microsoft.com>
 <87wobxgkkv.fsf@vitty.brq.redhat.com>
In-Reply-To: <87wobxgkkv.fsf@vitty.brq.redhat.com>
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
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 74cbe0cc-cf63-461f-0705-08d76c56a667
x-ms-traffictypediagnostic: MN2PR21MB1456:|MN2PR21MB1456:|MN2PR21MB1456:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB14561434801A9E33E08726E6CA4D0@MN2PR21MB1456.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(376002)(136003)(346002)(39860400002)(13464003)(199004)(189003)(81166006)(81156014)(256004)(71200400001)(66476007)(6916009)(102836004)(76116006)(66556008)(6436002)(53546011)(66946007)(8936002)(8990500004)(66446008)(64756008)(71190400001)(7736002)(305945005)(14454004)(74316002)(10090500001)(22452003)(8676002)(55016002)(316002)(478600001)(52536014)(10290500003)(99286004)(6116002)(186003)(54906003)(9686003)(5660300002)(66066001)(3846002)(486006)(446003)(26005)(2906002)(33656002)(11346002)(229853002)(4326008)(476003)(6246003)(7696005)(76176011)(25786009)(86362001)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1456;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 66nQ+cbXBo0o6uUdEAU1YFLWuchzjXf9I/3aT85cgT324FrPnAWR/jO8l9GTRN1FEgqqF3tdAIHJqvn7lvSwWOSrS4iSr1ZuawJfJLuqu54iszl0eJ8vK4gY0rmYhel3cwTiQ+57UMCCZd6Z7XuB05ePFdAe4G0EptmxfkQKLpC3ebAuAc0y0NIGlFv1B2+NRxu+Eeh2k5rD8tPFgiAT57ZU3C4ouD2BZyeS40WRae6LZTeXHL9w/mQib2QQTLoWcHD0vBcoUe7oYKCffqmEHEMnHXvamWwkkb1GvcTOKYnq8FTVBSECqxhdVgZBWplf8lKS1Uuh4GCSegNvZbx2crM3EDnWgrmJ0SovADr0GPlSMpTD51yS/l4llX4DzsdEM6xAoVxJ1DnFMc64GZeAfR2x7xuZWM+5MpQ+sBTCmx09HKHZokvWNz2RxzbhA1Ye
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74cbe0cc-cf63-461f-0705-08d76c56a667
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 18:39:30.8832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u0JO1jQ4Rkc34RybFH6QFOhksRKhao0sfTN1AGO5DHHG3PzUaGBEquqg9yF7S5I60NW/LvNiAZSIUpZTeYV0SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1456
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> Sent: Monday, November 18, 2019 12:29 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; olaf@aepfle.de; davem@davemloft.net; linux-
> kernel@vger.kernel.org; sashal@kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net, 1/2] hv_netvsc: Fix offset usage in netvsc_send_=
table()
>=20
> Haiyang Zhang <haiyangz@microsoft.com> writes:
>=20
> > To reach the data region, the existing code adds offset in struct
> > nvsp_5_send_indirect_table on the beginning of this struct. But the
> > offset should be based on the beginning of its container,
> > struct nvsp_message. This bug causes the first table entry missing,
> > and adds an extra zero from the zero pad after the data region.
> > This can put extra burden on the channel 0.
> >
> > So, correct the offset usage. Also add a boundary check to ensure
> > not reading beyond data region.
> >
> > Fixes: 5b54dac856cb ("hyperv: Add support for virtual Receive Side Scal=
ing
> (vRSS)")
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/net/hyperv/hyperv_net.h |  3 ++-
> >  drivers/net/hyperv/netvsc.c     | 26 ++++++++++++++++++--------
> >  2 files changed, 20 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/hyperv/hyperv_net.h
> b/drivers/net/hyperv/hyperv_net.h
> > index 670ef68..fb547f3 100644
> > --- a/drivers/net/hyperv/hyperv_net.h
> > +++ b/drivers/net/hyperv/hyperv_net.h
> > @@ -609,7 +609,8 @@ struct nvsp_5_send_indirect_table {
> >  	/* The number of entries in the send indirection table */
> >  	u32 count;
> >
> > -	/* The offset of the send indirection table from top of this struct.
> > +	/* The offset of the send indirection table from the beginning of
> > +	 * struct nvsp_message.
> >  	 * The send indirection table tells which channel to put the send
> >  	 * traffic on. Each entry is a channel number.
> >  	 */
> > diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> > index d22a36f..efd30e2 100644
> > --- a/drivers/net/hyperv/netvsc.c
> > +++ b/drivers/net/hyperv/netvsc.c
> > @@ -1178,20 +1178,28 @@ static int netvsc_receive(struct net_device *nd=
ev,
> >  }
> >
> >  static void netvsc_send_table(struct net_device *ndev,
> > -			      const struct nvsp_message *nvmsg)
> > +			      const struct nvsp_message *nvmsg,
> > +			      u32 msglen)
> >  {
> >  	struct net_device_context *net_device_ctx =3D netdev_priv(ndev);
> > -	u32 count, *tab;
> > +	u32 count, offset, *tab;
> >  	int i;
> >
> >  	count =3D nvmsg->msg.v5_msg.send_table.count;
> > +	offset =3D nvmsg->msg.v5_msg.send_table.offset;
> > +
> >  	if (count !=3D VRSS_SEND_TAB_SIZE) {
> >  		netdev_err(ndev, "Received wrong send-table size:%u\n",
> count);
> >  		return;
> >  	}
> >
> > -	tab =3D (u32 *)((unsigned long)&nvmsg->msg.v5_msg.send_table +
> > -		      nvmsg->msg.v5_msg.send_table.offset);
> > +	if (offset + count * sizeof(u32) > msglen) {
>=20
> Nit: I think this can overflow.

To prevent overflow, I will change it to:
	if (offset > msglen || offset + count * sizeof(u32) > msglen) {
Thanks,
- Haiyang

