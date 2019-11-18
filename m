Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 300AC100D62
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfKRVBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:01:20 -0500
Received: from mail-eopbgr770132.outbound.protection.outlook.com ([40.107.77.132]:50270
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbfKRVBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 16:01:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBLJdl5ywhZu69qactmXhMpbs7q14Y46aAvZ73dVa+ahQKoFN26dhsLDpSa6XEfGjkSmdndoqjexUIYV9ByZeDf1A++6yE3+IYabc2K0vf8qfH+DkTaJzOctyPJ0NS925oxtY6N5b7b3ijdSIMn9AHJC4XgTbfG+BqqpqPhcKdmfl7pcJVgEhcKiAdZAP7UynOOSATZ93z62JQVOdxi1I7eaB/l2SgNn7eKJ1HumoZyDLYyey5c9as8CYZnmqpTLbk+dGHq9l89EXNXpWPcejreWDR2r6LwHv2hP/aJnaERu/zIyh3ESSSL6eoxj6ofJLNvQb37wYLnhr8OBF31t5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YIaDSRtXnFSbfhjxkIS4frVRt3RY+jhkzTIsIhJRju4=;
 b=NCC9g2JUswQyAKzwjVGw56iILI7NfUxrj7EYLu3Ta6bBiUYGpMcC2cWML1++3gCpTOtPVUE4mdPfo/x0X+826FSdA+gz64jSYWG0nBccBit+k8/pQFDLz6HqMIN9xE5ZXaG3waRdNbQSwsN2+npTIADmxKZ95cY6e2xeLd79cpcWXUwJq3mkZSqhye4FV+tK8Z2c1roIpUJh7uxhlJWKvBEPxF8iGhuKjGe9vNVl9isrMav2HRgCUCxZAhhUmmc7V5XhQPjebCjH/qq+TkZgeLZv7noOifopeNLADkgMrfCSi3Y1e/Dc+v1QT/IXvfpTgQp9HH3vokSsd8xBFyIMOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YIaDSRtXnFSbfhjxkIS4frVRt3RY+jhkzTIsIhJRju4=;
 b=MwtE/hrlhPLmpV5VASTW6FEcOO/qBWYRCiBNrRknuprzeuCrJRiUBH9z6ZQt3bYKYzIyVFlLq7Jvs97gQTmBzZW02wYp/ogLSCm5XGc0i8iJ0ht0xzrCQE2CukUVfKDLcoxxfrCsc9JzTjkQkmsdGZkNfNQCSAnAVrDIK0s1Iec=
Received: from BYAPR21MB1366.namprd21.prod.outlook.com (20.179.59.143) by
 BYAPR21MB1143.namprd21.prod.outlook.com (20.179.56.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.5; Mon, 18 Nov 2019 21:01:17 +0000
Received: from BYAPR21MB1366.namprd21.prod.outlook.com
 ([fe80::897c:7b4:f111:eafd]) by BYAPR21MB1366.namprd21.prod.outlook.com
 ([fe80::897c:7b4:f111:eafd%5]) with mapi id 15.20.2495.006; Mon, 18 Nov 2019
 21:01:16 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Michael Kelley <mikelley@microsoft.com>,
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
Thread-Index: AQHVni4BMQAA5uuFYkCid07sy0QKsaeRLukAgAASHQCAACVGAIAAA0Sw
Date:   Mon, 18 Nov 2019 21:01:16 +0000
Message-ID: <BYAPR21MB1366AB00EC1239A2ABEE9531CA4D0@BYAPR21MB1366.namprd21.prod.outlook.com>
References: <1574094751-98966-1-git-send-email-haiyangz@microsoft.com>
 <1574094751-98966-2-git-send-email-haiyangz@microsoft.com>
 <87wobxgkkv.fsf@vitty.brq.redhat.com>
 <MN2PR21MB13758E83B89BD524B41B71C2CA4D0@MN2PR21MB1375.namprd21.prod.outlook.com>
 <DM5PR21MB0634CF7997BD9F9B6326D1CED74D0@DM5PR21MB0634.namprd21.prod.outlook.com>
In-Reply-To: <DM5PR21MB0634CF7997BD9F9B6326D1CED74D0@DM5PR21MB0634.namprd21.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: fe396234-0700-461e-4063-08d76c6a7433
x-ms-traffictypediagnostic: BYAPR21MB1143:|BYAPR21MB1143:|BYAPR21MB1143:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BYAPR21MB1143EE99C188716D0DCAE7DDCA4D0@BYAPR21MB1143.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(136003)(376002)(366004)(396003)(199004)(189003)(13464003)(64756008)(71190400001)(71200400001)(10090500001)(3846002)(66946007)(76116006)(6116002)(256004)(99286004)(8676002)(8936002)(229853002)(74316002)(14454004)(66066001)(54906003)(6436002)(4326008)(6246003)(110136005)(22452003)(316002)(81156014)(81166006)(55016002)(9686003)(8990500004)(186003)(25786009)(26005)(86362001)(1511001)(52536014)(478600001)(2906002)(446003)(11346002)(5660300002)(486006)(66476007)(476003)(76176011)(7696005)(305945005)(7736002)(33656002)(66556008)(66446008)(102836004)(6506007)(10290500003)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR21MB1143;H:BYAPR21MB1366.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AWERKTfeAvSNSa2yHzHm/4NZi/E7SLZn2hA5xbe9cL0aCPcfmo1Rbjk6r9mt4NAkOkufYopH2LUaNXvkdZOf5PZEbekAGzKCAFFrAk6vU0PjouoZcYYpK5YVuhauf2AtfAmftnl7TnsibrFTUxoWXSxkns92ODYTXZ6vGI1TWT2M+Uidp4pTes4aWWckYyU35muwLyTOZgxMlki/ZPBZX2fwjPKGBw1x3NtKa2MFccGEgw9Sn4WsgOacJsI/OTS2A/AYcw39iScBHY+xmg8zxl+QyPhn9khI6R7d7Egxct8nGBeTqzXG2UKsPxMM0J2uYkEoPqXws4HdPnbHB13USolhljyVvJmc6XZwhk4qGZ0znkYajaW/zoroCZsJKmZ20teuYUddIzZov6JO3MKhPuCFL2THuqJd90BnneKwuzbr2C7zz5Epr7YPTvDSe45F
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe396234-0700-461e-4063-08d76c6a7433
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 21:01:16.6474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UBfXbDKS2I1cAqfQnjvdBHLeDNtl0OwMr8ej7vj4SpYy2YQ3A6yJO7dYyULVC75Y2IjxQdoW123ttwfTr+TR/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1143
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michael Kelley <mikelley@microsoft.com>
> Sent: Monday, November 18, 2019 3:47 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>; vkuznets
> <vkuznets@redhat.com>
> Cc: KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; olaf@aepfle.de; davem@davemloft.net; linux-
> kernel@vger.kernel.org; sashal@kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: RE: [PATCH net, 1/2] hv_netvsc: Fix offset usage in netvsc_send_=
table()
>=20
> From: Haiyang Zhang <haiyangz@microsoft.com> Sent: Monday, November 18,
> 2019 10:40 AM
> > > -----Original Message-----
> > > From: Vitaly Kuznetsov <vkuznets@redhat.com>
> > > Sent: Monday, November 18, 2019 12:29 PM
> > >
> > > Haiyang Zhang <haiyangz@microsoft.com> writes:
> > >
> > > > To reach the data region, the existing code adds offset in struct
> > > > nvsp_5_send_indirect_table on the beginning of this struct. But the
> > > > offset should be based on the beginning of its container,
> > > > struct nvsp_message. This bug causes the first table entry missing,
> > > > and adds an extra zero from the zero pad after the data region.
> > > > This can put extra burden on the channel 0.
> > > >
> > > > So, correct the offset usage. Also add a boundary check to ensure
> > > > not reading beyond data region.
> > > >
> > > > Fixes: 5b54dac856cb ("hyperv: Add support for virtual Receive Side
> Scaling
> > > (vRSS)")
> > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > ---
> > > >  drivers/net/hyperv/hyperv_net.h |  3 ++-
> > > >  drivers/net/hyperv/netvsc.c     | 26 ++++++++++++++++++--------
> > > >  2 files changed, 20 insertions(+), 9 deletions(-)
> > > >
> > > > diff --git a/drivers/net/hyperv/hyperv_net.h
> > > b/drivers/net/hyperv/hyperv_net.h
> > > > index 670ef68..fb547f3 100644
> > > > --- a/drivers/net/hyperv/hyperv_net.h
> > > > +++ b/drivers/net/hyperv/hyperv_net.h
> > > > @@ -609,7 +609,8 @@ struct nvsp_5_send_indirect_table {
> > > >  	/* The number of entries in the send indirection table */
> > > >  	u32 count;
> > > >
> > > > -	/* The offset of the send indirection table from top of this stru=
ct.
> > > > +	/* The offset of the send indirection table from the beginning of
> > > > +	 * struct nvsp_message.
> > > >  	 * The send indirection table tells which channel to put the send
> > > >  	 * traffic on. Each entry is a channel number.
> > > >  	 */
> > > > diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvs=
c.c
> > > > index d22a36f..efd30e2 100644
> > > > --- a/drivers/net/hyperv/netvsc.c
> > > > +++ b/drivers/net/hyperv/netvsc.c
> > > > @@ -1178,20 +1178,28 @@ static int netvsc_receive(struct net_device
> *ndev,
> > > >  }
> > > >
> > > >  static void netvsc_send_table(struct net_device *ndev,
> > > > -			      const struct nvsp_message *nvmsg)
> > > > +			      const struct nvsp_message *nvmsg,
> > > > +			      u32 msglen)
> > > >  {
> > > >  	struct net_device_context *net_device_ctx =3D netdev_priv(ndev);
> > > > -	u32 count, *tab;
> > > > +	u32 count, offset, *tab;
> > > >  	int i;
> > > >
> > > >  	count =3D nvmsg->msg.v5_msg.send_table.count;
> > > > +	offset =3D nvmsg->msg.v5_msg.send_table.offset;
> > > > +
> > > >  	if (count !=3D VRSS_SEND_TAB_SIZE) {
> > > >  		netdev_err(ndev, "Received wrong send-table size:%u\n",
> > > count);
> > > >  		return;
> > > >  	}
> > > >
> > > > -	tab =3D (u32 *)((unsigned long)&nvmsg->msg.v5_msg.send_table +
> > > > -		      nvmsg->msg.v5_msg.send_table.offset);
> > > > +	if (offset + count * sizeof(u32) > msglen) {
> > >
> > > Nit: I think this can overflow.
> >
> > To prevent overflow, I will change it to:
> > 	if (offset > msglen || offset + count * sizeof(u32) > msglen) {
> > Thanks,
> > - Haiyang
>=20
> Actually, this would be simpler since we already trust msglen and count
> to have good values:
>=20
> 	if (offset > msglen - count * sizeof(u32)) {

Great idea. Thanks!


